--- Manager module
-- @module Manager
-- many things here are taken from TheFatController mod

--- Entity Info
-- @type Entity Info
EntityInfo = {
    manager = "", -- managers
    tracker = "", -- tracker-type: running, unmoved, fixed, once, random
    entity = false, -- ref to entity
}

--- Manager class
-- @type Manager
Manager = {}

Manager.add = function(type, entity, force)
    if entity.valid then
        Manager[type].add(entity, force)
        return true
    end
    return false
end

--------------------------------------------------------------------
-- Trains
--------------------------------------------------------------------

Manager.trains = {}

Manager.trains.add = function(entity, force)
    local eInfo = table.deepcopy(EntityInfo)
    eInfo.manager = "train"
    eInfo.tracker = Manager.trains.getTracker(entity.train)
    eInfo.entity  = Manager.trains.getFrontLoco(entity)
    local unit_number = entity.unit_number
    log("[RT] Add unit_number " .. unit_number .. " Force " .. force.name .. " tracker " .. eInfo.tracker .. " manager " .. eInfo.manager)
    global.watchlist[force.name][unit_number] = eInfo
    global.tracker[force.name][eInfo.tracker][unit_number] = eInfo
end

Manager.trains.getFrontLoco = function(entity)
    return Manager.trains.frontLocoEntity(entity.train)
end

--- Determines which locomotive in a train is the main one
-- @param LuaTrain train
-- @return LuaEntity the main locomotive
Manager.trains.frontLocoEntity = function(train)
    if train.valid and
            train.locomotives and
            (#train.locomotives.front_movers > 0 or #train.locomotives.back_movers > 0)
    then
        return train.locomotives.front_movers and train.locomotives.front_movers[1] or train.locomotives.back_movers[1]
    end
end

Manager.trains.getTracker = function(train)
    local state = train.state

    if state == defines.train_state.on_the_path and train.schedule and #train.schedule.records < 2 then
        return RTDEF.tracker.unmoved
    end

    return Manager.trains.stateComp(state)
end

Manager.trains.stateComp = function(state)
    local stateComp = {   
        [RTDEF.tracker.running] = { defines.train_state.on_the_path, defines.train_state.arrive_signal,
            defines.train_state.arrive_station, defines.train_state.manual_control,
            defines.train_state.stop_for_auto_control
        },
    
        [RTDEF.tracker.unmoved] = { defines.train_state.wait_signal, defines.train_state.wait_station,
            defines.train_state.path_lost, defines.train_state.no_schedule,  defines.train_state.no_path,
            defines.train_state.manual_control_stop
        }
    }

    for tracker, comparedStates in pairs(stateComp) do
        for _, comparedState in ipairs(comparedStates) do
            if state == comparedState then
                return tracker
            end
        end
    end
    return nil
end

--------------------------------------------------------------------
-- Stops
--------------------------------------------------------------------

Manager.stops = {}
Manager.stops.add = function(entity, force)
end

--------------------------------------------------------------------
-- Cars
--------------------------------------------------------------------

Manager.cars = {}
Manager.cars.add = function(entity, force)
end

