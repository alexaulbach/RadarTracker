require 'stdlib.data.data'
require 'stdlib.area.area'
require 'stdlib.surface'

-- debug-purposes
inspect = require('inspect')

require 'config'
require 'init'
require 'container'
require 'manager'

RTDEF = {
	tracker = {
		none    = 1,    -- no scan
		running = 2,    -- vehicles with speed ~= 0
		unmoved = 3,    -- vehicles with speed == 0
		rotating= 4,    -- chunks that should be scanned rotational
		once    = 5,    -- scanning once like some kind of rocket
		random  = 6,    -- scanning randomly, like construction bots?
	},
	managers = {
		["train-stop"]  = "stops",
		["cargo-wagon"] = "trains",
		["locomotive"]  = "trains",
		["car"]         = "cars",
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
		manager.add(mngr, entity)
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
	

eventcount = 0
script.on_event(defines.events.on_sector_scanned, function(event)
	log("[RT] TRACKER" .. event.radar.name)
	if event.radar.name == "movement-tracker" then
		local force = event.radar.force
		for unit_number, ntt in pairs(container.get_all_tracker_by_force(RTDEF.tracker.running, force.name)) do
			local train = ntt.entity
			if train.valid then
				local area = Area.adjust({
					{
						train.position.x,
						train.position.y
					}, {
						train.position.x + train.train.speed * _config["movement-tracker"].precognition * math.sin(2*math.pi * train.orientation),
						train.position.y - train.train.speed * _config["movement-tracker"].precognition * math.cos(2*math.pi * train.orientation)
					}
				})
				force.chart(event.radar.surface, Area.expand(area, _config["movement-tracker"].scanned_radius))
				eventcount = eventcount + 1
				if eventcount % 10 == 0 then
					log('[RT] Train: ' .. unit_number ..
							' state: ' .. train.train.state ..
							' cnt: ' .. eventcount
					)
				end
			else
				container.remove(unit_number)
			end
		end
	elseif event.radar.name == "vehicluar-tracker" then
		local force = event.radar.force
		for index,vehcl in ipairs(global.trains[force.name]) do
			if vehcl.valid then

				local x1 = vehcl.position.x
				local y1 = vehcl.position.y

				force.chart(event.radar.surface,{{x1-expansion, y1-expansion}, {x1+expansion, y1+expansion}})
			else
				table.remove(global.trains[force.name], index)
			end
		end
	end
end)

script.on_event(defines.events.on_train_changed_state, function(event)
	local train = event.train
	local unit_number = train.locomotives.front_movers[1].unit_number
	log("[RT] >>>>>>> train unit " .. unit_number .. " changed state:" ..train.state)
	local ntt = container.get(unit_number)
	if ntt then
		log("[RT] Exists: " .. unit_number .. " force " .. ntt.entity.force.name)
		log("[RT] Current ntttrkr: " .. inspect(global._ntttrkr))
		return unit_number
		--- TODO: Trigger garbage-collection?
	end
	--- TODO: If not found then we need to add it
	manager.add(RTDEF.managers.locomotive, train.front_stock)
	log("[RT] Current ntttrkr: " .. inspect(global._ntttrkr))
end)
