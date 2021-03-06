--- Init module
-- @module Init

Init = {}
Init.initialized = false
Init.initializedData = false
Init.in_load = false

Init.init = function()
    if Init.initialized then
        printmsg("already initialized")
        return
    end

    -- if global.log_level > 0 then printmsg("----------------- INIT --------------------------") end

    -- todo a tracker count for each tracker
    global.movement_tracker_count = 0

    global.debugger = false
    if global.debugger ~= dbg.mode() then
        __switchDebug()
    end

    -- 4: everything, 3: scheduler messages, 2: basic messages, 1 errors only, 0: off
    interface.log_level.func(global.log_level or 1)
    -- "console" or "log" or "console,log"
    interface.log_output.func('console')

    Init.initData()
    
    for entityType, mappedName in pairs(RTDEF.managers) do
        Init.type(entityType, mappedName)
    end
    
    Init.initialized = true
end

Init.type = function(entityType, mappedName)
    local count = Init.countEntities(entityType)
    if not count then
        return
    end

    if global.log_level > 1 then printmsg("------ init " .. mappedName .. " -> count " .. entityType .. ": ".. count) end

    local entities = Surface.find_all_entities({
        type = entityType
    })

    for _, entity in pairs(entities) do
        local force_name = entity.force.name
        manager.add(entity, mappedName)
        if global.log_level > 1 then printmsg("added: " .. entity.name .. " /force " .. force_name .. " to " .. mappedName) end
    end
end

Init.countEntities = function(entityType)
    local count = 0
    for _,force in pairs(game.forces) do
        for name,entity in pairs(game.entity_prototypes) do
            if entity.type == entityType then
                count = count + force.get_entity_count(name)
            end
        end
    end
    return count
end

Init.clearInitialization = function()
    Init.initialized = false
    Init.initializedData = false
    Init.on_load = false
end

Init.initData = function()
    if Init.initializedData then
        return
    end
    
    if not Init.on_load then
        if global.log_level > 1 then printmsg("initData") end
        container.init()
        Init.initializedData = true
    else
        if global.log_level > 1  then printmsg("Not initData cause in on_load") end
    end
end