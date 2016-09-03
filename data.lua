mod_name = "radar-tracker"

require("config")

energy_per_sector = energy_usage * refresh_time -- kilo Joule
log("[RT] energy_usage: " .. energy_usage ..
        " - refresh_time: " .. refresh_time ..
        " - scanned_area: " .. scanned_area ..
        " - precognotion: " .. precognotion ..
        " - energy_per_sector: " .. energy_per_sector)

require("prototypes.radar-tracker")
require("prototypes.trackers.trains")
require("prototypes.trackers.vehicular")
