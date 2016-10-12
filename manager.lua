--- Manager module
-- @module Manager
-- many things here are taken from TheFatController mod

--- Entity Info
-- @type Entity Info
nttInfo = {
    manager = "", -- managers
    tracker = "", -- tracker-type: running, unmoved, fixed, once, random
    entity = false, -- ref to entity
}

--- Manager class
-- @type Manager
Manager = {}

Manager.add = function(type, entity)
    if entity.valid then
        Manager[type].add(entity)
        return true
    end
    return false
end

--------------------------------------------------------------------
-- Trains
--------------------------------------------------------------------

Manager.trains = {}

Manager.trains.add = function(entity)
    local ntt = table.deepcopy(nttInfo)
    ntt.manager = "train"
    ntt.tracker = Manager.trains.getTracker(entity.train)
    ntt.entity  = Manager.trains.getFrontLoco(entity)
    container.set(ntt)
end

Manager.trains.getFrontLoco = function(entity)
    return Manager.trains.frontLocoEntity(entity.train)
end

--- Determines which locomotive in a train is the main one
-- @param LuaTrain train
-- @return LuaEntity the main locomotive
Manager.trains.frontLocoEntity = function(train)
    if train.valid
      and train.locomotives
      and (#train.locomotives.front_movers > 0 or #train.locomotives.back_movers > 0)
    then
        return train.locomotives.front_movers and train.locomotives.front_movers[1] or train.locomotives.back_movers[1]
    end
end

Manager.trains.getTracker = function(train)
    local state = Manager.trains.getTrueState(train)
    log("[RT] state " .. Manager.trains.statePrint(state))
    return Manager.trains.stateComp(state)
end

Manager.trains.getTrueState = function(train)
    local state = train.state
    -- Bug: State 9 is always triggered on manual control
    -- see https://forums.factorio.com/viewtopic.php?f=7&t=34237
    if state == defines.train_state.manual_control and train.speed == 0 then
        return defines.train_state.manual_control_stop
    end
    return state
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

Manager.trains.statePrint = function(state)
    if state == nil then
        log("[RT] state 0")
        return "zero!"
    end
    local statconf = {
        'on_the_path	Normal state -- following the path.5',
        'path_lost	Had path and lost it -- must stop.',
        'no_schedule	Doesn\'t have anywhere to go.',
        'no_path	Has no path and is stopped.',
        'arrive_signal	Braking before a rail signal.',
        'wait_signal	Waiting at a signal.',
        'arrive_station	Braking before a station.',
        'wait_station	Waiting at a station.',
        'manual_control_stop	Switched to manual control and has to stop.',
        'manual_control	Can move if user explicitly sits in and rides the train.',
        'stop_for_auto_control	Train was switched to auto control but it is moving and needs to be stopped.'
    }
    return tostring(state) .. " : " .. statconf[state+1]
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

