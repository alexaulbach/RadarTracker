------------------------------------------------------------------------------
--- interface methods for debug
------------------------------------------------------------------------------

interface.list = {
    help = "Show all currently tracked objects (ordered by force and tracker)",
    params = {},
    func = function()
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
}

-------------------------------------------------------------------------------

interface.show = {
    help = "Show tracker entry of hovered entity (Only if tracked!)",
    params = {},
    func = function()
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
}

-------------------------------------------------------------------------------

interface.re_init = {
    help = "(Re-)initialize everything",
    params = {},
    func = function()
        Init.clearInitialization()
        Init.init()
    end
}

-------------------------------------------------------------------------------

interface.debug = {
    help = "Switch debug-functionality on/off",
    params = {},
    func = function()
        __switchDebug()
        printmsg("Debugging: " .. tostring(global.debugger))
    end
}
