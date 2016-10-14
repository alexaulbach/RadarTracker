-- Changes on this vars needs a reload of Factorio

_config = {
    ["movement-tracker"]   = {
        ["energy_usage"]   = 10000.0, -- kilo Watt
        ["refresh_time"]   = 0.5,    -- seconds
        ["scanned_radius"] = 5.0,   -- radius scanned around the entity
        ["precognition"]   = 40.0    -- look-forwad for movement-tracker, in tiles
    },
    ["immoveables-tracker"] = {
        ["energy_usage"]    = 1000.0, -- kilo Watt
        ["refresh_time"]    = 10.0,   -- seconds
        ["scanned_radius"]  = 5.0,   -- radius scanned around the entity
    },
    ["rotational-tracker"]  = {
        ["energy_usage"]    = 1000.0, -- kilo Watt
        ["refresh_time"]    = 10.0,   -- seconds
        ["segment_per_refresh"] = 0.26179938779915 -- in rad (0.26179938779915 rad ~ 12 degrees)
    }
}
