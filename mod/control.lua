require 'stdlib.data.data'
require 'stdlib.area.area'
require 'stdlib.surface'

-- debug-purposes
inspect = require('inspect')

require 'config'
require 'basics'
require 'init'
require 'container'
require 'manager'
require 'events'
require 'interface'
require 'dbg'

interface.initAllRemoteCalls()


RTDEF = {
	tracker = {
		none     = 1,    -- no scan
		running  = 2,    -- movement-tracker   ; vehicles with speed ~= 0, nearly every 0.5 seconds
		waiting  = 3,    -- wait-tracker   ; vehicles with speed == 0, every 10 seconds
		unmoved  = 4,    -- immoveable-tracker ; static stuff, every 30 seconds
		rotating = 5,    -- rotational-tracker ; chunks that should be scanned rotational, every minute
		change   = 6,    -- scanning changes, when a robot places/removes an entity. Or special scanning rockets?
		random   = 7,    -- scanning randomly, like construction bots?
	},
	managers = {
		["train-stop"]  = "stops",
		["roboport"]    = "ports",
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
	-- if global.log_level > 0 then printmsg("----------------- on_load: do nothing--------------------------") end
end)

script.on_init(function()
	-- if global.log_level > 0 then printmsg("----------------- on_init--------------------------") end
	Init.init()
end)

script.on_configuration_changed(function(event)
	-- if global.log_level > 0 then printmsg("----------------- on_configuration_changed--------------------------") end
	Init.init()
end)

script.on_event(defines.events.on_force_created, function(event)
	-- if global.log_level > 0 then printmsg("----------------- on_force_created--------------------------") end
	Init.clearInitialization()
	Init.init()
end)

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	local mngr = RTDEF.managers[entity.type]
	if mngr then
		event_handler.built_RT_entity(entity)
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
		event_handler.sector_scan_trackers.movement(radar)
	elseif radar.name == "immoveables-tracker" then
		event_handler.sector_scan_trackers.immoveables(radar)
	elseif radar.name == "rotational-tracker" then
		event_handler.sector_scan_trackers.rotational(radar)
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
