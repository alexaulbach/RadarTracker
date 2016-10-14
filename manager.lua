--- manager module
-- @module manager
-- many things here are taken from TheFatController mod

--- Entity Info
-- @type Entity Info
nttInfo = {
    manager = "", -- managers
    tracker = "", -- tracker-type: running, unmoved, fixed, once, random
    entity = false, -- ref to entity
}

--- manager class
-- @type manager
manager = {}

manager.add = function(type, entity)
    if entity.valid then
        manager[type].add(entity)
        return true
    end
    return false
end

--------------------------------------------------------------------
-- Trains
--------------------------------------------------------------------

manager.trains = {}

--- add the train front_stock to the lists
--- if back_stock ~= front_stock add also that
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

manager.trains.getTracker = function(train)
    if train.speed ~= 0.0 then
        return RTDEF.tracker.running
    else
        return RTDEF.tracker.unmoved
    end
end

--------------------------------------------------------------------
-- Stops
--------------------------------------------------------------------

manager.stops = {}

manager.stops.add = function(entity, force)
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

manager.cars.add = function(entity, force)
    local ntt = table.deepcopy(nttInfo)
    ntt.manager = "cars"
    ntt.tracker = RTDEF.tracker.unmoved
    ntt.entity  = entity
    container.set(ntt)
end

manager.cars.getTracker = function(entity)
    if entity.speed ~= 0.0 then
        return RTDEF.tracker.running
    else
        return RTDEF.tracker.unmoved
    end
end
