
container = {}

container.set = function(ntt)
    if ntt.entity.valid then
        local unit_number = ntt.entity.unit_number
        local fn = ntt.entity.force.name
        local prevntt = global._ntt[unit_number]
log("D? " ..  inspect(prevntt))
        if prevntt and prevntt.tracker ~= ntt.tracker then
            container.remove(unit_number)
        end
        log("[RT] Added unit_number " .. unit_number .. " Force " .. fn .. " trkr: " .. ntt.tracker .. " manager " .. ntt.manager)
        dbg.ftext(ntt.entity.surface, ntt.entity.position, "+T:" .. ntt.tracker .. " M:"..ntt.manager .. unit_number)
        global._ntt[unit_number] = ntt
        global._ntttrkr[fn][ntt.tracker][unit_number] = ntt
    else
        log("[RT] ERROR already invalid, unit_number: " .. unit_number)
    end
end

container.get = function(unit_number)
    local ntt = global._ntt[unit_number]
    if ntt then
        if ntt.entity.valid then
            return ntt
        else
            container.remove(unit_number)
        end
    end
end

--- returns all entities, that are tracked by this tracker
-- you need to care for validation yourself!
container.get_all_tracker_by_force = function(tracker, force_name)
    return global._ntttrkr[force_name][tracker]
end

container.remove = function(unit_number)
    local ntt = global._ntt[unit_number]
    if ntt then
        local fn = ntt.entity.force.name
        global._ntttrkr[fn][ntt.tracker][unit_number] = nil
        global._ntt[unit_number] = nil
        log("[RT] removed unit_number " .. unit_number .. " Force " .. fn .. " trkr: " .. ntt.tracker .. " manager " .. ntt.manager)
        dbg.ftext(ntt.entity.surface, ntt.entity.position, "-T:" .. ntt.tracker .. " M:"..ntt.manager)
    end
end

container.init = function()
    global._ntt = {}
    global._ntttrkr = {}
    for _, force in pairs(game.forces) do
        global._ntttrkr[force.name] = {}
        for _, tracker in pairs(RTDEF.tracker) do
            global._ntttrkr[force.name][tracker] = {}
        end
    end
end

