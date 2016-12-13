require 'stdlib.data.data'
require 'stdlib.area.area'
require 'stdlib.surface'

-- debug-purposes, can be removed
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
    -- definitions of *internal* tracker types
    tracker = {
        none     = 1,    -- no scan
        running  = 2,    -- movement-tracker   ; vehicles with speed ~= 0, nearly every 0.5 seconds
        waiting  = 3,    -- wait-tracker   ; vehicles with speed == 0, every 10 seconds
        unmoved  = 4,    -- immoveable-tracker ; static stuff, every 30 seconds
        rotating = 5,    -- rotational-tracker ; chunks that should be scanned rotational, every minute
        change   = 6,    -- scanning changes, when a robot places/removes an entity. Or special scanning rockets?
        random   = 7,    -- scanning randomly, like construction bots?
    },
    
    -- definition of entity-type -> manager
    managers = {
        ["train-stop"]  = "stops",
        ["roboport"]    = "ports",
        ["cargo-wagon"] = "trains",
        ["locomotive"]  = "trains",
        ["car"]         = "cars",
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

script.on_event(defines.events.on_sector_scanned, function(event)
    local radar = event.radar

    if string.sub(radar.name, -7) == 'tracker' then
        if global.log_level > 3 then printmsg("Tracker scanned: " .. radar.name .. " calling " .. string.sub(radar.name,0, -9)) end
        event_handler.sector_scan_trackers[string.sub(radar.name,0, -9)](radar) 
    end
end)

script.on_event(defines.events.on_train_changed_state, function(event)
    local train = event.train
    manager.add(train.front_stock, RTDEF.managers.locomotive)
end)

script.on_event(defines.events.on_player_driving_changed_state, function(event)
    local player = game.players[event.player_index]
    if not player.vehicle then
        -- not sitting in a vehicle... the vehicle will look by itself, player is still present.
        return
    end
    -- todo: need to watch for force?? Mabe in that case the entity is added to the own force-radars instead of vehicles?
    manager.add(player.vehicle)
end)
