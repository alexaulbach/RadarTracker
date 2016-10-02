--- Manager module
-- @module Manager
-- many things here are taken from TheFatController mod

--- Entity Info
-- @type Entity Info
EntityInfo = {
    managerType = "", -- vehicles, trains, stops, see entityTypesToManagerType
    entity = false, -- ref to entity
    indexNo = false, -- reference to itself
}

--- Manager class
-- @type Manager
Manager = {}

Manager.add = function(entity, type)
    if type == "trains" then
        Manager.addTrain(entity)
    end
    
end

Manager.addTrain = function(entity)
    local info = table.deepcopy(EntityInfo)
    info.entity = entity
    info.manager = "train"
    table.insert(global.Manager, 
end