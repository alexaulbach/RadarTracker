
container = {}

container.set = function(ntt)
    if ntt.entity.valid then
        local unit_number = ntt.entity.unit_number
        local fn = ntt.entity.force.name
        local prevntt = global._ntt[unit_number]
        if prevntt then
            -- todo REMOVE
            global._ntt[unit_number].prev = global._ntt[unit_number].prev or {}; prevntt.prev.tracker = prevntt.prev.tracker or 0

            if prevntt.prev.tracker ~= ntt.tracker then
                container.drop_link(prevntt)
            end
        end
        log("[RT] Added unit_number " .. unit_number .. " Force " .. fn .. " trkr: " .. ntt.tracker .. " manager " .. ntt.manager)
        dbg.ftext(ntt.entity.surface, ntt.entity.position, "ADD " .. ntt.tracker .. " "..ntt.manager .. unit_number)
        ntt.force_name   = fn
        ntt.unit_number  = unit_number
        ntt.prev.tracker = ntt.tracker
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
            container.remove(ntt)
        end
    end
end

--- returns all entities, that are tracked by this tracker
-- you need to care for validation yourself!
container.get_all_tracker_by_force = function(tracker, force_name)
    return global._ntttrkr[force_name][tracker]
end

container.drop_link = function(ntt)
    local fn = ntt.force_name
    local unit_number = ntt.unit_number
    global._ntttrkr[fn][ntt.prev.tracker][unit_number] = nil
    log("[RT] drop_link " .. unit_number .. " Force " .. fn .. " trkr: " .. ntt.prev.tracker .. " manager " .. ntt.manager)
    dbg.ftext(ntt.entity.surface, ntt.entity.position, "DRP " .. ntt.prev.tracker .. " "..ntt.manager .. " " .. unit_number, 1)
end

container.remove = function(ntt)
    local unit_number = ntt.unit_number
    global._ntttrkr[ntt.force_name][ntt.prev.tracker][unit_number] = nil
    global._ntt[unit_number] = nil
    prnt_n_log("DEL " .. unit_number .. " " .. ntt.prev.tracker .. " " .. ntt.manager)
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

