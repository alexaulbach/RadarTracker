-- Changes on this vars needs a reload of Factorio

_config = {
    ["movement-tracker"]   = {
        ["energy_usage"]   = 10000.0, -- kilo Watt
        ["refresh_time"]   = 0.5,     -- seconds
        ["scanned_radius"] = 5.0,     -- radius scanned around the entity
        ["precognition"]   = 32.0,    -- look-forwad for movement-tracker, in tiles
        ["waiting_tracker_refresh_time"] = 17.5 -- seconds between tracking waiting vehicles
    },
    ["immoveables-tracker"] = {
        ["energy_usage"]    = 500.0,  -- kilo Watt
        ["refresh_time"]    = 30.0,   -- seconds
        ["scanned_radius"]  = 7.0,    -- radius scanned around the entity
    },
    ["rotational-tracker"]  = {
        ["energy_usage"]    = 1000.0, -- kilo Watt
        ["refresh_time"]    = 2.0,    -- seconds
        ["segment_per_refresh"] = 0.26179938779915, -- in rad (0.26179938779915 rad ~ 12 degrees)
        ["scanned_radius"]  = 2000.0,   -- radius scanned around the entity
    },
    ["once-tracker"]  = {
        ["energy_usage"]    = 1000.0, -- kilo Watt
        ["refresh_time"]    = 2.0,    -- seconds
        ["scanned_radius"]  = 2000.0,   -- radius scanned around the entity
    }
}

-- calculate after how many intervals of the movement-tracker the waiting tracker is triggered.
_config["movement-tracker"].waiting_tracker_interval = math.floor(_config["movement-tracker"].waiting_tracker_refresh_time / _config["movement-tracker"].refresh_time)

