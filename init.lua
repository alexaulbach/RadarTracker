--- Init module
-- @module Init

Init = {}
Init.initialized = false

Init.init = function()
    if Init.initialized then
        log("[RT] already initialized")
        return
    end

    log("[RT] ----------------- INIT --------------------------")
    global.watchlist = {}
    global.tracker   = {}
    for _,force in pairs(game.forces) do
        local fname = force.name
        global.watchlist[fname] = {}
        global.tracker[fname] = {}
        for _, trackername in pairs(RTDEF.tracker) do
            global.tracker[fname][trackername] = {}
        end
    end
        
    for entityType, mappedName in pairs(RTDEF.managers) do
        Init.type(entityType, mappedName)
    end
    
    Init.initialized = true
    log("[RT] GLOBAL WATCLIST" .. inspect(global.watchlist))
    log("[RT] GLOBAL TRACKER" .. inspect(global.tracker))
end

Init.type = function(entityType, mappedName)
    local count = Init.countEntities(entityType)
    if not count then
        return
    end

    log("[RT] ------ init " .. mappedName .. " -> count " .. entityType .. ": ".. count)

    local entities = Surface.find_all_entities({
        type = entityType
    })

    for _, entity in pairs(entities) do
        local force_name = entity.force.name
--        Init.ifNeeded(mappedName, force_name)
        Manager.add(mappedName, entity, entity.force) 
        log("[RT] added: " .. entity.name .. " /force " .. force_name .. " to " .. mappedName)
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
end