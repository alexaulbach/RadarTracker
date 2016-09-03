require("prototypes.trackers.trains")
require("prototypes.trackers.vehicular")

data:extend({
	{
    type = "technology",
    name = "radar-tracker",
    icon = "__"..mod_name.."__/graphics/train-tracker-technology.png",
	icon_size = 128,
    prerequisites = {"electric-energy-distribution-1"},
	effects =
	{
		{
			type = "unlock-recipe",
			recipe = "train-tracker"
		},
		{
			type = "unlock-recipe",
			recipe = "vehicular-tracker"
		}
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

