-- require "defines"

require("config")

---------------------------------------------------------------------------------------------------

function init()
	global.trains = global.trains or {}
	for _,force in pairs(game.forces) do
		init_force(force)
	end
end

---------------------------------------------------------------------------------------------------

function init_force(force)
	local n_trains = 0
	
	for name,entity in pairs(game.entity_prototypes) do
		if entity.type == "locomotive" or entity.type == "cargo-wagon" then
			n_trains = n_trains + force.get_entity_count(name)
		end
	end
	
	log("[RT] Found "..n_trains.." trains for the "..force.name.."-force")

	local x = 16
	local y = 16
	repeat
		global.trains[force.name] = {}
		for _,surface in pairs(game.surfaces) do
			local locomotives = surface.find_entities_filtered{area = {{-x,-y},{x,y}}, force = force, type = "locomotive"}
			for _,locomotive in pairs(locomotives) do
				table.insert(global.trains[force.name],locomotive)
			end
			local cargo_wagons = surface.find_entities_filtered{area = {{-x,-y},{x,y}}, force = force, type = "cargo-wagon"}
			for _,cargo_wagon in pairs(cargo_wagons) do
				table.insert(global.trains[force.name],cargo_wagon)
			end
		end
		log("[RT] Found "..#global.trains[force.name].." trains inside {"..-x..","..-y.."},{"..x..","..y.."}")
		x = x +16
		y = y +16
	until #global.trains[force.name] >= n_trains

end

---------------------------------------------------------------------------------------------------

script.on_init(function()
	init()
end)

script.on_configuration_changed(function(event)
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

				local x1 = train.position.x
				local y1 = train.position.y
				local x2 = x1 + train.train.speed * precognotion * math.sin(2*math.pi * train.orientation)
				local y2 = y1 - train.train.speed * precognotion * math.cos(2*math.pi * train.orientation)
				
				if x2 < x1 then 
					local x = x1
					x1 = x2
					x2 = x
				end
				if y2 < y1 then
					local y = y1
					y1 = y2
					y2 = y
				end
				
				local scalf = scanned_area / 2
				force.chart(event.radar.surface,{{x1-scalf, y1-scalf}, {x2+scalf, y2+scalf}})
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
