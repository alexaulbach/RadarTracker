
rotational = {}

rotational.init = function()
    global.area_spirals = {}
    global.reveal = {}
end

rotational.scan = function(ntt)
    local ent = ntt.entity
    if not ent.valid then
        return false
    end
    local unit_number = ent.unit_number
    if global.area_spirals[unit_number] == nil then
--        local x1 = ent.position.x
--        local y1 = ent.position.y
        local area = Area.expand({{ent.position}, {ent.position}}, _config["rotational-tracker"].scanned_radius)
        global.area_spirals[unit_number] = Area.spiral_iterate(area)
    end
    
     next(global.area_spirals[unit_number])

        
end

