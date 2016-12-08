
function printmsg(msg)
--    if global.log_output.lastMessage == msg then
--        -- don't spam the same message
--        return
--    end
--    global.log_output.lastMessage = msg
    if global.log_output == "console" or global.log_output == "both" then
        game.print("[RTR] " .. msg)
    end
    if global.log_output == "log" or global.log_output == "both" then
        log("[RTR] " .. msg)
    end
end

function prnt_ntt(ntt, unit_number, force_name)
    if unit_number == nil then
        unit_number = ntt.entity.unit_number
    end
    if force_name == nil then
        force_name = ntt.entity.force.name
    end

    local str = "UN: " .. unit_number .. " FN: " .. force_name .. "TRK: " .. ntt.tracker .. " MNGR: " .. ntt.manager
    printmsg(str)
end