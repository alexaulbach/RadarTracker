
container = {}

container.set = function(ntt)
    if ntt.entity.valid then
        local unit_number = ntt.entity.unit_number
        local fn = ntt.entity.force.name
        local prevntt = global._ntt[unit_number]
        if prevntt and prevntt.tracker ~= ntt.tracker then
            container.remove(unit_number)
        end
        log("[RT] Added unit_number " .. unit_number .. " Force " .. fn .. " trkr: " .. ntt.tracker .. " manager " .. ntt.manager)
        global._ntt[unit_number] = ntt
        global._ntttrkr[fn][ntt.tracker][unit_number] = ntt
    else
        log("[RT] ERROR invalid unit_number: " .. unit_number)
    end
end

container.get = function(unit_number)
    -- log("[RT] container.get - global._ntt: " .. unit_number .. " -- " .. inspect(global._ntt))
    local ntt = global._ntt[unit_number]
    if ntt and ntt.valid then
        return ntt
    end
    log("[RT] container.get: nil")
end

container.get_by_force = function(unit_number, force_name)
    local ntt = global._ntt4rc[force_name][unit_number]
    if ntt and ntt.valid then
        return ntt
    end
end

container.get_all_tracker_by_force = function(tracker, force_name)
    return global._ntttrkr[force_name][tracker]
end

container.remove = function(unit_number)
    local ntt = global._ntt[unit_number]
    if ntt then
        local fn = ntt.entity.force.name
        global._ntttrkr[fn][ntt.tracker][unit_number] = nil
        global._ntt[unit_number] = nil
    end
end

container.init = function()
    log("[RT] container.init")
    global._ntt = {}
    global._ntt4rc = {}
    global._ntttrkr = {}
    for _, force in pairs(game.forces) do
        global._ntt4rc[force.name] = {}
        global._ntttrkr[force.name] = {}
        for _, tracker in pairs(RTDEF.tracker) do
            global._ntttrkr[force.name][tracker] = {}
        end
    end
end

