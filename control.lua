require 'stdlib.data.data'
require 'stdlib.area.area'
require 'stdlib.surface'

-- debug-purposes
inspect = require('inspect')

require 'config'
require 'init'
require 'container'
require 'manager'
require 'dbg'


RTDEF = {
	tracker = {
		none    = 1,    -- no scan
		running = 2,    -- movement-tracker   ; vehicles with speed ~= 0, nearly every 0.5 seconds
		waiting = 3,    -- wait-tracker   ; vehicles with speed == 0, every 10 seconds
		unmoved = 4,    -- immoveable-tracker ; static stuff, every 30 seconds
		rotating= 5,    -- rotational-tracker ; chunks that should be scanned rotational, every minute
		once    = 6,    -- scanning once like some kind of rocket or when a robot places/removes an entity
		random  = 7,    -- scanning randomly, like construction bots?
	},
	managers = {
		["train-stop"]  = "stops",
		["cargo-wagon"] = "trains",
		["locomotive"]  = "trains",
		["car"]         = "cars",
	}
}

stateComp = {
	[RTDEF.tracker.running] = { defines.train_state.on_the_path, defines.train_state.arrive_signal,
		defines.train_state.arrive_station, defines.train_state.manual_control,
		defines.train_state.stop_for_auto_control
	},

	[RTDEF.tracker.waiting] = { defines.train_state.wait_signal, defines.train_state.wait_station,
		defines.train_state.path_lost, defines.train_state.no_schedule,  defines.train_state.no_path,
		defines.train_state.manual_control_stop
	}
}
---------------------------------------------------------------------------------------------------

script.on_load(function()
	log("[RT] ----------------- on_load: do nothing--------------------------")
end)

script.on_init(function()
	log("[RT] ----------------- on_init--------------------------")
	Init.init()
end)

script.on_configuration_changed(function(event)
	log("[RT] ----------------- on_configuration_changed--------------------------")
	Init.init()
end)

script.on_event(defines.events.on_force_created, function(event)
	log("[RT] ----------------- on_force_created--------------------------")
	Init.clearInitialization()
	Init.init()
end)

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	local mngr = RTDEF.managers[entity.type]
	if mngr then
		log("[RT] built entity: " .. entity.unit_number .. " manager " .. mngr)
		manager.add(entity, mngr)
	end
end)

--[[
/c game.player.print("FRONT STOCK" .. game.player.selected.train.front_stock.unit_number);
game.player.print("BACK STOCK" ..game.player.selected.train.back_stock.unit_number);
for i, loco in pairs(game.player.selected.train.locomotives.front_movers) do
	game.player.print("Front Mover " .. i .. " . " .. loco.unit_number)
end
for i, loco in pairs(game.player.selected.train.locomotives.back_movers) do
	game.player.print("Back Mover " .. i .. " . " .. loco.unit_number)
end
for i, carr in pairs(game.player.selected.train.carriages) do
	game.player.print("Carr " .. i .. " . " .. carr.unit_number)
end

]]

script.on_event(defines.events.on_sector_scanned, function(event)
	local radar = event.radar
	if radar.name == "movement-tracker" then

		local trackers = { RTDEF.tracker.running }
		global.movement_tracker_count = global.movement_tracker_count + 1
		-- every 20 times = every 10 seconds -> todo calculate in config
		if global.movement_tracker_count % 20 == 0 then
			table.insert(trackers, RTDEF.tracker.waiting)
		end

log(inspect(trackers) .. global.movement_tracker_count)
		
		for _,tracker in pairs(trackers) do
			for unit_number, ntt in pairs(container.get_all_tracker_by_force(tracker, radar.force.name)) do
				local ent = ntt.entity
				if ent.valid then
					local area
					if ntt.manager == "cars" then
						-- turn into wait-mode if passenger has left
						if not ent.passenger and ntt.tracker ~= RTDEF.tracker.waiting then
							ntt.tracker = RTDEF.tracker.waiting
							container.set(ntt)
						end

						-- todo: cars should "forsee" one chunk more, than the players radar  --> config
						area = Area.adjust({
							{
								ent.position.x,
								ent.position.y
							}, {
								ent.position.x + ent.speed * _config["movement-tracker"].precognition * 10 * math.sin(2*math.pi * ent.orientation),
								ent.position.y - ent.speed * _config["movement-tracker"].precognition * 10 * math.cos(2*math.pi * ent.orientation)
							}
						})
	
					elseif ntt.manager == "trains" then
						area = Area.adjust({
							{
								ent.position.x,
								ent.position.y
							}, {
								ent.position.x + ent.train.speed * _config["movement-tracker"].precognition * math.sin(2*math.pi * ent.orientation),
								ent.position.y - ent.train.speed * _config["movement-tracker"].precognition * math.cos(2*math.pi * ent.orientation)
							}
						})
					end
					
					-- TODO: do not chart this chunk, if already charted (test if useful? How long does it take to chart a chunk?)
					area = Area.expand(area, _config["movement-tracker"].scanned_radius)
					radar.force.chart(radar.surface, area)
					dbg.charting(radar.surface, area, unit_number)
					
				else
					container.remove(ntt)
				end
			end
		end
	elseif radar.name == "immoveables-tracker" then
		for unit_number, ntt in pairs(container.get_all_tracker_by_force(RTDEF.tracker.unmoved, radar.force.name)) do
			local ent = ntt.entity
			if ent.valid then

				local x1 = ent.position.x
				local y1 = ent.position.y
				local area = Area.expand({{x1, y1}, {x1, y1}}, _config["immoveables-tracker"].scanned_radius)
				radar.force.chart(radar.surface, area)
				dbg.charting(radar.surface, area, unit_number)

				-- look if suddenly moving (again)
				if ntt.manager == "cars" then
					dbg.ftext(radar.surface, ent.position, "CAR " .. ntt.tracker .. " - " .. ent.speed)
					if ent.speed ~= 0.0 then
						ntt.tracker = RTDEF.tracker.running
						container.set(ntt)
					end
				elseif ntt.manager == "trains" then
					if ent.train.speed ~= 0.0 then
						ntt.tracker = RTDEF.tracker.running
						container.set(ntt)
					end
				end
				
			else
				container.remove(ntt)
			end
		end
	elseif radar.name == "rotational-tracker" then
		for unit_number, ntt in pairs(container.get_all_tracker_by_force(RTDEF.tracker.rotating, radar.force.name)) do
			log("[RT] rotational; " .. unit_number .. " ntt " .. ntt.entity.name)
		end
	end
end)


script.on_event(defines.events.on_train_changed_state, function(event)
	local train = event.train
	manager.add(train.front_stock, RTDEF.managers.locomotive)
end)

script.on_event(defines.events.on_player_driving_changed_state, function(event)
	local player = game.players[event.player_index]
	if not player.vehicle then
		-- not sitting in a vehicle...
		return
	end
	-- todo: need to watch for force?? Mabe in that case the entity is added to the own force-radars instead of vehicles?
	manager.add(player.vehicle)
end)


remote.add_interface("tr",
	{
		help = function()
			game.player.print("-----  RadarTracker: Remote functions  -----")
			game.player.print("|  help()  - This help")
			game.player.print("|  list()  - Show all currently tracked objects (ordered by force and tracker)")
			game.player.print("|  show()  - Show tracker entry of hovered entity (Only if tracked!)")
			game.player.print("|  debug() - switch debug-functionality on/off")
			game.player.print("")
		end,
		
		list = function()
			for fn, trackers in pairs(global._ntttrkr) do
				prnt_n_log("--------- " .. fn .. " ---------")
				for tracker, units in pairs(trackers) do
					prnt_n_log("---- " .. tracker)
					for unit_number, ntt in pairs(units) do
						prnt_ntt(ntt, unit_number, fn) 
					end
				end
			end
		end, 
		
		show = function()
			entity = game.player.selected
			local unit_number
			if entity.type == 'train' then
				unit_number = entity.train.back_stock.unit_number
			else
				unit_number = entity.unit_number
			end
			local ntt = container.get(unit_number)
			if ntt then
				prnt_ntt(ntt, unit_number)
				if ntt.entity.unit_number ~= unit_number then
					prnt_n_log("UNIT NUMBER NOT EQUAL!")
				end
			end
		end,

		init = function()
			Init.clearInitialization()
			Init.init()
		end,
		
		debug = function()
			global.debugger = not global.debugger
			__switchDebug()
			game.player.print("[RT] Debugging: " .. inspect(global.debugger))
		end,
	}
)
