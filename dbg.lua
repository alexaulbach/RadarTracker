
--- debugger class ON

global.debugger = global.debugger or true

dbg = {}

-------------------------------

dbg.charting = function(surface, area, unit_number)
end

dbg._charting = function(surface, area, unit_number)
    for _, i in pairs({'left_top', 'right_bottom'}) do
        for _, j in pairs({'left_top', 'right_bottom'}) do
            local pos = {area[i].x, area[j].y}
            surface.create_entity({ name = "flying-text-chartedges", position = pos, text = unit_number})
        end
    end
end

-------------------------------

dbg.ftext = function(surface, pos, text)
end

dbg._ftext = function(surface, pos, text)
    surface.create_entity({ name = "flying-text", position = pos, text = text})
end

-------------------------------

function __switchDebug()
    log("SwitchDebug" .. inspect(dbg))
    for funcName, func in pairs(dbg) do
        log("F " .. funcName .. " - " .. inspect(func))
        if (string.sub(funcName, 0, 1) ~= "_") then
            local funcName2 = "_" .. funcName
            log("F " .. funcName2)
            dbg[funcName] = dbg[funcName2]
            dbg[funcName2] = func
        end
    end
end

if global.debugger == false then
    __switchDebug()
end
