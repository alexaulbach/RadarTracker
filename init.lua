--- Init module
-- @module Init

initialized = false
inited = {}
Init = {}

Init.init = function()
    if initialized then
        log("[RT] already initialized")
        return
    end

    log("[RT] ----------------- INIT --------------------------")
    for entityType, mappedName in pairs(trackerTypes) do
        Init.type(entityType, mappedName)
    end
    initialized = true
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
        Init.ifNeeded(mappedName, force_name)
        table.insert(global[mappedName][force_name], entity)
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

Init.ifNeeded = function(mappedName, force_name)
    if not inited[mappedName] then
        global[mappedName] = {}
        inited[mappedName] = mappedName
    end

    local index = mappedName .. "." .. force_name
    if not inited[index] then
        global[mappedName][force_name] = {}
        inited[index] = index
    end
end

Init.clearInitialization = function()
    initialized = false
    inited = {}
end