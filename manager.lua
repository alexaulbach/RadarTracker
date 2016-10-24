--- manager module
-- @module manager
-- many things here are taken from TheFatController mod

--- Entity Info
-- @type Entity Info
nttInfo = {
    manager = "", -- managers
    tracker = "", -- tracker-type: running, waiting, unmoved, fixed, once, random
    entity = false, -- ref to entity
}

--- manager class
-- @type manager
manager = {}

manager.add = function(entity, type)
    if entity.valid then
        if not type then
            for entityType, mappedName in pairs(RTDEF.managers) do
                if entity.type == entityType then
                    type = mappedName
                    break
                end
            end
            if not type then
                return false
            end
        end
        manager[type].add(entity)
        return true
    end
    return false
end


--------------------------------------------------------------------
-- Trains
--------------------------------------------------------------------

manager.trains = {}

--- add the train front_stock and back_stock (first and last train-entity) to the lists
--- Not if back_stock == front_stock (only wagon or loco)
manager.trains.add = function(entity)
    local frontntt = table.deepcopy(nttInfo)
    frontntt.manager = "trains"
    frontntt.tracker = manager.trains.getTracker(entity.train)
    frontntt.entity  = entity.train.front_stock
    container.set(frontntt)
    local backntt = table.deepcopy(frontntt)
    backntt.entity  = entity.train.back_stock
    if backntt.entity ~= frontntt.entity then
        container.set(backntt)
    end
end

--- we need to care about the tracker status, cause when the status changes, the speed is still 0 or it is still moving.
manager.trains.getTracker = function(train)
    local state = train.state

    -- manual_control: This is in manual-control-mode. Player can stop and go, each time we get an event.
    if state == defines.train_state.manual_control and train.speed == 0 then
        return RTDEF.tracker.waiting
    end -- no else, the other case is managed in the loop

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

manager.stops = {}

manager.stops.add = function(entity)
    local ntt = table.deepcopy(nttInfo)
    ntt.manager = "stops"
    ntt.tracker = RTDEF.tracker.unmoved
    ntt.entity  = entity
    container.set(ntt)
end

--------------------------------------------------------------------
-- Cars
--------------------------------------------------------------------

manager.cars = {}

manager.cars.add = function(entity)
    local ntt = table.deepcopy(nttInfo)
    ntt.manager = "cars"
    ntt.tracker = manager.cars.getTracker(entity)
    ntt.entity  = entity
    container.set(ntt)
end

manager.cars.getTracker = function(entity)
    if entity.passenger then
        return RTDEF.tracker.running
    else
        return RTDEF.tracker.waiting
    end
end