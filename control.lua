require 'stdlib.data.data'
require 'stdlib.area.area'
require 'stdlib.surface'

-- debug-purposes
inspect = require('inspect')


require 'config'

expansion = scanned_area / 2
initialized = false

watched_names = { 
	["train-stop"]  = "stops",
	["cargo-wagon"] = "trains",
	["locomotive"]  = "trains",
	["car"]         = "cars",
}


---------------------------------------------------------------------------------------------------

function init()
	if initialized then
		return
	end
	
	log("[RT] ----------------- INIT --------------------------")
	for entityType, mappedName in pairs(watched_names) do
		for _,force in pairs(game.forces) do
			log("[RT] ------ init mappedName " .. mappedName .. " force " .. force.name)
			global[mappedName] = global[mappedName] or {}
			init_force(force, entityType, mappedName)
		end
	end
	initialized = true
end

---------------------------------------------------------------------------------------------------

function init_force(force, entityType, mappedName)

	local count = 0
	for name,entity in pairs(game.entity_prototypes) do
		if entity.type == entityType then
			count = count + force.get_entity_count(name)
		end
	end

	global[mappedName][force.name] = {}

	log("[RT] COUNT " .. entityType .. " (To: " .. mappedName .. " / Force: " .. force.name .. ") : ".. count)

	if count then
		local entities
		entities = Surface.find_all_entities({
			type = entityType,
			force = force
		})
		
		for _, entity in pairs(entities) do
			table.insert(global[mappedName][force.name], entity)
			log("[RT] added: " .. entity.name .. " /force " .. force.name .. " to " .. mappedName)
		end
	end
	
	if count ~= #global[mappedName][force.name] then
		log("[RT] number of found on map not equal to found entities: " .. #global[mappedName][force.name])
	end

end

---------------------------------------------------------------------------------------------------

script.on_init(function()
	log("[RT] ----------------- ON-INIT--------------------------")
	init()
end)

script.on_configuration_changed(function(event)
	log("[RT] ----------------- on_configuration_changed--------------------------")
	init()
end)

script.on_event(defines.events.on_force_created, function(event)
	init_force(event.force)
end)

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	if entity.type == "locomotive" or entity.type == "cargo-wagon" then
		table.insert(global.trains[entity.force.name], entity)
	end
end)

script.on_event(defines.events.on_sector_scanned, function(event)
	if event.radar.name == "train-tracker" then
		local force = event.radar.force
		for index,train in ipairs(global.trains[force.name]) do
			if train.valid then
				local area = Area.adjust({
					{
						train.position.x,
						train.position.y
					}, {
						train.position.x + train.train.speed * precognition * math.sin(2*math.pi * train.orientation),
						train.position.y - train.train.speed * precognition * math.cos(2*math.pi * train.orientation)
					}
				})
				force.chart(event.radar.surface, Area.expand(area, expansion))
				log('Train: ' .. index ..
						' state: ' .. train.train.state ..
						' speed: ' .. train.train.speed ..
						' ori: ' .. train.orientation
				)
			else
				table.remove(global.trains[force.name], index)
			end
		end
	elseif event.radar.name == "vehicluar-tracker" then
		local force = event.radar.force
		for index,vehcl in ipairs(global.trains[force.name]) do
			if vehcl.valid then

				local x1 = vehcl.position.x
				local y1 = vehcl.position.y

				local scalf = scanned_area / 2
				force.chart(event.radar.surface,{{x1-scalf, y1-scalf}, {x1+scalf, y1+scalf}})
			else
				table.remove(global.trains[force.name], index)
			end
		end
	end
end)
