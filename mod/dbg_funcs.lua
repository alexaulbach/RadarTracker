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

------------------------------------------------------------------------------
--- Add debug-methods to interface
------------------------------------------------------------------------------

interface.list_doc = ")  - Show all currently tracked objects (ordered by force and tracker)"

interface.list = function()
    for fn, trackers in pairs(global._ntttrkr) do
        printmsg("--------- " .. fn .. " ---------")
        for tracker, units in pairs(trackers) do
            printmsg("---- " .. tracker)
            for unit_number, ntt in pairs(units) do
                prnt_ntt(ntt, unit_number, fn)
            end
        end
    end
end

-------------------------------------------------------------------------------

interface.show_doc = ")  - Show tracker entry of hovered entity (Only if tracked!)"

interface.show = function()
    if game.player.selected == nil then
        printmsg("NOTHING SELECTED: You need to select a tracked entity (train, car...)")
        return
    end
    
    entity = game.player.selected
    local unit_number
    if entity.type == 'train' then
        unit_number = entity.train.back_stock.unit_number
    else
        unit_number = entity.unit_number
    end
    local ntt = container.get(unit_number)
    if ntt then
        prnt_ntt(ntt, unit_number)
        if ntt.entity.unit_number ~= unit_number then
            printmsg("UNIT NUMBER NOT EQUAL!")
        end
    end
end

-------------------------------------------------------------------------------

interface.reinit_doc = ")  - (Re-)initialize everything"

interface.reinit = function()
    Init.clearInitialization()
    Init.init()
end

-------------------------------------------------------------------------------

interface.debug_doc = ") - switch debug-functionality on/off"

interface.debug = function()
    __switchDebug()
    printmsg("Debugging: " .. tostring(global.debugger))
end

-------------------------------------------------------------------------------
