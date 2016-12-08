
interface = {}


interface.isInterfaceDocFunction = function(funcName)
    if (string.sub(funcName, -4) == "_doc") then
        return string.sub(funcName, 0, -5)
    end
end

interface.initAllRemoteCalls = function()
    local interfaces = {}
    for funcName, _ in pairs(interface) do
        local funcName2 = interface.isInterfaceDocFunction(funcName)
        if funcName2 then
            interfaces[funcName2] = interface[funcName2]
        end
    end
log("---- X " .. inspect(interfaces))

    remote.add_interface("RTR", interfaces)
end

----------------------------------------------------------------------------------------

interface.help_doc = ")         - This help"

interface.help = function()

    game.player.print('')
    game.player.print("-----  RadarTracker: Remote functions  -----")

    for funcName, _ in pairs(interface) do
        local funcName2 = interface.isInterfaceDocFunction(funcName)
        if funcName2 then
            game.player.print("|  " .. funcName2)
            game.player.print("|    /c remote.call('RTR', '" .. funcName2 .. "'" .. interface[funcName])
        end
    end

    game.player.print('')
    
end

----------------------------------------------------------------------------------------

interface.log_level_doc  = ", level)  - Set Log-Level to level n.\n" ..
        "|     4: everything, 3: scheduler messages, 2: basic messages, 1 errors only, 0: off"

interface.log_level = function(level)
    global.log_level = level
    remote.call('RTR', 'log_status')
end

----------------------------------------------------------------------------------------

interface.log_output_doc = ", 'console,log') - A set: 'console,log' or 'log' or 'console'"

interface.log_output = function(log_set)
    if log_set == nil or type(log_set) ~= 'string' then
        game.player.print("[RTR] log_output: Wrong parameter type")
        return
    end
    local real_set = {}
    for i in string.gmatch(log_set, "[^,]*") do
        if i == 'console' or i == 'log' then
            real_set[i] = i
        end
    end

    global.log_output = real_set
    remote.call('RTR', 'log_status')
end

----------------------------------------------------------------------------------------
interface.log_status_doc = ")         - show current log status"

interface.log_status = function()
    local ctab = {}
    local n = 1
    for _, v in pairs(global.log_output) do
        ctab[n] = v
        n = n + 1
    end
    if #ctab == 0 then ctab = {"No Output! Use remote.call('RTR', 'help') to see possible settings"} end
    printmsg("[RTR] <log_status> log-level: " .. global.log_level .. " - log-output: " .. table.concat(ctab, ', '))
end

----------------------------------------------------------------------------------------
