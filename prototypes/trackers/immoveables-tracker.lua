
-- immoveables-tracker

local tracker_name = "immoveables-tracker"
local _c = _config[tracker_name]

data:extend({
    {
        type = "item",
        name = tracker_name,
        icon = "__"..mod_name.."__/graphics/train-tracker-item.png",
        flags = {"goes-to-quickbar"},
        subgroup = "transport",
        order = "a[vehicle-system]-h[vehicular-tracker]",
        place_result = tracker_name,
        stack_size = 5
    }
})

data:extend({
    {
        type = "radar",
        name = tracker_name,
        icon =  "__"..mod_name.."__/graphics/train-tracker-item.png",
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
            filename = "__"..mod_name.."__/graphics/train-tracker-entity.png",
            priority = "low",
            width = 204,
            height = 175,
            apply_projection = false,
            direction_count = 64,
            line_length = 8,
            shift = {1.1375, -0.34375}
        },
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
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
            {"iron-gear-wheel", 50},
            {"steel-plate", 30},
            {"radar", 1},
            {"advanced-circuit", 25},
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
        prerequisites = {"electric-energy-distribution-1"},
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
                {"science-pack-1", 2},
                {"science-pack-2", 1}
            },
            time = 20
        },
        order = "c-g-c",
    }
})