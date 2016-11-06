
-- movement-tracker

function init_tracker(tracker_name, _c)

data:extend({
    {
        type = "item",
        name = tracker_name,
        icon = "__"..mod_name.."__/graphics/VehicleTracker-item.png",
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[radar-tracker]-a["..tracker_name.."]",
        place_result = tracker_name,
        stack_size = 5
    }
})

data:extend({
    {
        type = "radar",
        name = tracker_name,
        icon =  "__"..mod_name.."__/graphics/VehicleTracker-item.png",
        flags = {"placeable-player", "player-creation"},
        minable = {hardness = 0.2, mining_time = 1.5, result = tracker_name},
        max_health = 500,
        corpse = "big-remnants",
        resistances =
        {
            {
                type = "fire",
                percent = 70
            }
        },
        collision_box = {{-1.87, -1.87}, {1.87, 1.87}},
        selection_box = {{-2, -2}, {2, 2}},
        energy_per_sector = _c.energy_per_sector .. "kJ",
        max_distance_of_sector_revealed = 0,
        max_distance_of_nearby_sector_revealed = 0,
        energy_per_nearby_scan = "0J",
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input"
        },
        energy_usage = _c.energy_usage .. "kW",
        pictures =
        {
            filename = "__"..mod_name.."__/graphics/VehicleTracker-entity.png",
            priority = "low",
            width = 195,
            height = 232,
            apply_projection = false,
            direction_count = 1,
            line_length = 1,
            shift = {0.0, -1.0}
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        working_sound =
        {
            sound = {
                {
                    filename = "__base__/sound/radar.ogg"
                }
            },
            apparent_volume = 1.5,
        }
    }
})

data:extend({
    {
        type = "recipe",
        name = tracker_name,
        enabled = false,
        ingredients =
        {
            {"steel-plate", 25},
            {"radar", 1},
            {"immoveables-tracker", 1},
            {"advanced-circuit", 25},
            {"electronic-circuit", 25},
        },
        result = tracker_name
    },
})

data:extend({
    {
        type = "technology",
        name = tracker_name,
        icon = "__"..mod_name.."__/graphics/train-tracker-technology.png",
        icon_size = 128,
        prerequisites = {"automated-rail-transportation", "immoveables-tracker"},
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = tracker_name
            },
        },
        unit =
        {
            count = 100,
            ingredients =
            {
                {"science-pack-1", 1},
                {"science-pack-2", 2}
            },
            time = 20
        },
        order = "c-g-c",
    }
})

end
