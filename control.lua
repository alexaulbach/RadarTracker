require 'stdlib.data.data'
require 'stdlib.area.area'
require 'stdlib.surface'

-- debug-purposes
inspect = require('inspect')


require 'config'
require 'init'
require 'manager'


expansion = scanned_area / 2



RTDEF = {
	tracker = {
		running = 1,
		unmoved = 2,
		fixed   = 3,
		once    = 4,
		random  = 5,
	},
	managers = {
		["train-stop"]  = "stops",
		["cargo-wagon"] = "trains",
		["locomotive"]  = "trains",
		["car"]         = "cars",
	}
}

RTDEF.tracker.running = 1

log("RTDEF " .. inspect(RTDEF))


---------------------------------------------------------------------------------------------------

script.on_init(function()
	log("[RT] ----------------- on_init--------------------------")
	Init.init()
end)

script.on_configuration_changed(function(event)
	log("[RT] ----------------- on_configuration_changed--------------------------")
	Init.init()
end)

script.on_event(defines.events.on_force_created, function(event)
	log("[RT] ----------------- on_force_created--------------------------")
	Init.clearInitialization()
	Init.init()
end)

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity

	-- TODO complete rewrite
	if entity.type == "locomotive" or entity.type == "cargo-wagon" then
		table.insert(global.trains[entity.force.name], entity)
	end
end)

script.on_event(defines.events.on_sector_scanned, function(event)
	if event.radar.name == "train-tracker" then
		local force = event.radar.force
		for index,train in ipairs(global.tracker[force.name][RTDEF.tracker.running]) do
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
				table.remove(global.tracker[force.name][RTDEF.tracker.running], index)
			end
		end
	elseif event.radar.name == "vehicluar-tracker" then
		local force = event.radar.force
		for index,vehcl in ipairs(global.trains[force.name]) do
			if vehcl.valid then

				local x1 = vehcl.position.x
				local y1 = vehcl.position.y

				force.chart(event.radar.surface,{{x1-expansion, y1-expansion}, {x1+expansion, y1+expansion}})
			else
				table.remove(global.trains[force.name], index)
			end
		end
	end
end)

script.on_event(defines.events.on_train_changed_state, function(event)
	local train = event.train
	local unit_number = train.locomotives.front_movers[1].unit_number
	local force = train.carriages[1].force
	log("[RT] train unit " .. unit_number .. " changed state:" ..train.state)
	if global.watchlist[force.name][unit_number] then
		log("[RT] Exists: " .. unit_number .. " force " .. force.name)
		local found_entity = global.watchlist[force.name][unit_number]
		if found_entity.entity.valid then
			log("[RT] Valid: " .. found_entity.manager .. found_entity.tracker )
			return unit_number
		end
		--- TODO: Trigger garbage-collection
		return nil
	end
	--- TODO: If not found then we need to add it
	Manager.add(RTDEF.manager.locomotive, entity, entity.force)
end)
