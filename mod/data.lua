mod_name = "RadarTracker"

require("config")

for tracker, conf in pairs(_config) do
    if conf.energy_usage and conf.refresh_time then
        conf.energy_per_sector = conf.energy_usage * conf.refresh_time -- kilo Joule
    end

    -- log("______ Tracker " .. tracker .. " ______")
    
    local str = ""
    for name, value in pairs(conf) do
        str = str .. " - " .. name .. ": " .. value
    end
    -- log(str)
end

require("prototypes.radar-tracker")
require("prototypes.other")
