
interface = {}

interface.initAllRemoteCalls = function()
    local interfaces = {}
    for funcName, tab in pairs(interface) do
        if type(tab) == "table" then
            interfaces[funcName] = tab.func
        end
    end
    remote.add_interface("RTR", interfaces)
end

----------------------------------------------------------------------------------------

interface.help = {
    help = "This help",
    params = {},
    func = function()

        game.player.print('')
        game.player.print("-----  RadarTracker: Remote functions  -----")

        for funcName, tab in pairs(interface) do
            if type(tab) == "table" then
                local params = ''
                for _, v in pairs(tab.params) do
                    if v then
                        params = params .. ', ' .. v
                    end
                end
                game.player.print("|  " .. funcName .. '  -  ' .. tab.help)
                game.player.print("|    /c remote.call('RTR', '" .. funcName .. "'" .. params .. ")") 
            end
        end

        game.player.print('')

    end
}

----------------------------------------------------------------------------------------

interface.log_level = {
    help = "Set Log-Level to level n" .. 
           " (4: everything, 3: scheduler messages, 2: basic messages, 1 errors only, 0: off)",
    params = {"level"},
    func = function(level)
        global.log_level = level
        remote.call('RTR', 'log_status')
    end
}

----------------------------------------------------------------------------------------

interface.log_output = {
    help = "Sets direction of output, a set: 'console,log' or 'log' or 'console'",
    params = {"direction"},
    func = function(direction)
        if direction == nil or type(direction) ~= 'string' then
            game.player.print("[RTR] log_output: Wrong parameter type")
            return
        end
        local directionSet = {}
        for i in string.gmatch(direction, "[^,]*") do
            if i == 'console' or i == 'log' then
                directionSet[i] = i
            end
        end

        global.log_output = directionSet
        remote.call('RTR', 'log_status')
    end
}

----------------------------------------------------------------------------------------

interface.log_status = {
    help = "show current log status",
    params = {},
    func = function()
        if type(global.log_output) ~= "table" then
            global.log_output = {}
        end
        local tmptab = {}
        local n = 1
        -- count output directions and convert to simple list
        for _, v in pairs(global.log_output) do
            tmptab[n] = v
            n = n + 1
        end
        if #tmptab == 0 then tmptab = {"No Output! Use remote.call('RTR', 'help') to see possible settings"} end
        printmsg("<log_status> log-level: " .. global.log_level .. " - log-output: " .. table.concat(tmptab, ', '))
    end
}
