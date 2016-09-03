
data:extend({
    {
        type = "item",
        name = "train-tracker",
        icon = "__"..mod_name.."__/graphics/train-tracker-item.png",
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[train-system]-h[train-tracker]",
        place_result = "train-tracker",
        stack_size = 5
    }
})

data:extend({
    {
        type = "radar",
        name = "train-tracker",
        icon =  "__"..mod_name.."__/graphics/train-tracker-item.png",
        flags = {"placeable-player", "player-creation"},
        minable = {hardness = 0.2, mining_time = 1.5, result = "train-tracker"},
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
        energy_per_sector = energy_per_sector .. "kJ",
        max_distance_of_sector_revealed = 0,
        max_distance_of_nearby_sector_revealed = 0,
        energy_per_nearby_scan = "0J",
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input"
        },
        energy_usage = energy_usage .. "kW",
        pictures =
        {
            filename = "__"..mod_name.."__/graphics/train-tracker-entity.png",
            priority = "low",
            width = 204,
            height = 175,
            apply_projection = false,
            direction_count = 64,
            line_length = 8,
            shift = {1.1375, -0.34375}
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
        name = "train-tracker",
        enabled = false,
        ingredients =
        {
            {"iron-gear-wheel", 50},
            {"steel-plate", 30},
            {"radar", 2},
            {"advanced-circuit", 25},
        },
        result = "train-tracker"
    },
})