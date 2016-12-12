--
-- By default the non-underscore-functions are just empty functions! This means Lua
-- has to call this function and immediatelly returns. This should be nearly the same
-- speed as "if debug_mode then"-constructs.
-- 
-- Please avoid such constructions:
--  dbg.ftext(ntt.entity.surface, ntt.entity.position, "DRP " .. ntt.prev.tracker .. " "..ntt.manager .. " " .. unit_number, 1)
-- This is slow, cause the parameter has to be calculated BEFORE debug knows if it should be printed or not.
-- The right way to do this:
--  dbg.ftext(ntt, unit_number, 1)
-- and do the rest in the underscore-debug-function!
-- So for every type of debugging you want to do you need to create an own debug-function
--

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

