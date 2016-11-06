
function prnt_n_log(str)
    if global.debugger then
        game.print(str)
    end
    log("[TR] " .. str)
end

function prnt_ntt(ntt, unit_number, force_name)
    if unit_number == nil then
        unit_number = ntt.entity.unit_number
    end
    if force_name == nil then
        force_name = ntt.entity.force.name
    end

    local str = "UN: " .. unit_number .. " FN: " .. force_name .. "TRK: " .. ntt.tracker .. " MNGR: " .. ntt.manager
    prnt_n_log(str)
end

--- debugger class

global.debugger = global.debugger or false

dbg = {}


-------------------------------

dbg.mode = function()
    return false
end

dbg._mode = function()
    return true
end

-------------------------------

dbg.charting = function(surface, area, unit_number)
end

dbg._charting = function(surface, area, unit_number)
    for _, i in pairs({'left_top', 'right_bottom'}) do
        for _, j in pairs({'left_top', 'right_bottom'}) do
            local pos = {area[i].x-2, area[j].y}
            surface.create_entity({ name = "flying-text-chartedges", position = pos, text = unit_number})
        end
    end
end

-------------------------------

dbg.ftext = function(surface, pos, text, offset)
end

dbg._ftext = function(surface, pos, text, offset)
    if offset ~= nil then
        pos.y = pos.y + offset
    end
    surface.create_entity({ name = "flying-text", position = pos, text = text})
end

-------------------------------

--- exchanges all functions without "_" with the same parallel-function with "_"
function __switchDebug()
    log("[RT] SwitchDebug from " .. tostring(dbg.mode()) .. " to " .. tostring(dbg._mode()))
    for funcName, func in pairs(dbg) do
        if (string.sub(funcName, 0, 1) ~= "_") then
            local funcName2 = "_" .. funcName
            dbg[funcName] = dbg[funcName2]
            dbg[funcName2] = func
        end
    end
    global.debugger = dbg.mode()
end

if global.debugger ~= dbg.mode() then
    __switchDebug()
end
