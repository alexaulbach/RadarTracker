--- Init module
-- @module Init

Init = {}
Init.initialized = false
Init.initializedData = false
Init.in_load = false

Init.init = function()
    if Init.initialized then
        log("[RTR] already initialized")
        return
    end

    log("[RTR] ----------------- INIT --------------------------")

    global.movement_tracker_count = 0
    global.debugger = false
    global.log_level = global.log_level or 2           -- 4: everything, 3: scheduler messages, 2: basic messages, 1 errors only, 0: off
    global.log_output = global.log_output or "console" -- console or log or both

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

    log("[RTR] ------ init " .. mappedName .. " -> count " .. entityType .. ": ".. count)

    local entities = Surface.find_all_entities({
        type = entityType
    })

    for _, entity in pairs(entities) do
        local force_name = entity.force.name
        manager.add(entity, mappedName) 
        log("[RTR] added: " .. entity.name .. " /force " .. force_name .. " to " .. mappedName)
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
        log("[RTR] initData")
        container.init()
        Init.initializedData = true
    else
        log("[RTR] Not initData cause in on_load")
    end
end