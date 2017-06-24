
event_handler = {}

event_handler.built_RT_entity = function(entity)
    if global.log_level > 2 then printmsg("built entity: " .. entity.unit_number .. " manager " .. mngr) end
    manager.add(entity, mngr)
end







event_handler.sector_scan_trackers = {}

event_handler.sector_scan_trackers.movement = function(radar)
    local trackers = { RTDEF.tracker.running }
    -- look if we also need to track "waiting" entities
    -- todo: movement_tracker_count is a property of the radar
    global.movement_tracker_count = global.movement_tracker_count + 1
    if global.movement_tracker_count % (_config["movement-tracker"].waiting_tracker_interval) == 0 then
        table.insert(trackers, RTDEF.tracker.waiting)
    end

    for _,tracker in pairs(trackers) do
        for unit_number, ntt in pairs(container.get_all_tracker_by_force(tracker, radar.force.name)) do
            local ent = ntt.entity
            if ent.valid then
                local area
                -- handle cars
                if ntt.manager == "cars" then
                    -- turn into wait-mode if passenger has left
                    if not ent.passenger and ntt.tracker ~= RTDEF.tracker.waiting then
                        ntt.tracker = RTDEF.tracker.waiting
                        container.set(ntt)
                    end

                    -- todo: cars should "forsee" one chunk more, than the players radar  --> config
										-- limit sight range (Optera)
										local scan_ahead_x = ent.position.x + ent.speed * _config["movement-tracker"].precognition * 10 * math.sin(2*math.pi * ent.orientation)
										if scan_ahead_x > _config["movement-tracker"].sight_range_limit then
											scan_ahead_x = _config["movement-tracker"].sight_range_limit
										elseif scan_ahead_x < -_config["movement-tracker"].sight_range_limit then
											scan_ahead_x = -_config["movement-tracker"].sight_range_limit
										end
										local scan_ahead_y = ent.position.y - ent.speed * _config["movement-tracker"].precognition * 10 * math.cos(2*math.pi * ent.orientation)
										if scan_ahead_y > _config["movement-tracker"].sight_range_limit then
											scan_ahead_y = _config["movement-tracker"].sight_range_limit
										elseif scan_ahead_y < -_config["movement-tracker"].sight_range_limit then
											scan_ahead_y = -_config["movement-tracker"].sight_range_limit
										end

                    area = Area.adjust({
                        {
                            ent.position.x,
                            ent.position.y
                        }, {
                            scan_ahead_x,
                            scan_ahead_y
                        }
                    })

                -- handle trains
                elseif ntt.manager == "trains" then

                    -- todo: the "back-stock" of a train doesn't need to be tracked when running (gives unwanted double charting in curves)
                    area = Area.adjust({
                        {
                            ent.position.x,
                            ent.position.y
                        }, {
                            ent.position.x + ent.train.speed * _config["movement-tracker"].precognition * math.sin(2*math.pi * ent.orientation),
                            ent.position.y - ent.train.speed * _config["movement-tracker"].precognition * math.cos(2*math.pi * ent.orientation)
                        }
                    })
                end

                -- TODO: do not chart this chunk, if already charted (test if useful? How long does it take to chart a chunk?)
                area = Area.expand(area, _config["movement-tracker"].scanned_radius)
                radar.force.chart(radar.surface, area)
                dbg.charting(radar.surface, area, unit_number)

            else
                container.remove(ntt)
            end
        end
    end
end

event_handler.sector_scan_trackers.immoveables = function(radar)
    for unit_number, ntt in pairs(container.get_all_tracker_by_force(RTDEF.tracker.unmoved, radar.force.name)) do
        local ent = ntt.entity
        if ent.valid then

            local x1 = ent.position.x
            local y1 = ent.position.y
            local area = Area.expand({{x1, y1}, {x1, y1}}, _config["immoveables-tracker"].scanned_radius)
            radar.force.chart(radar.surface, area)
            dbg.charting(radar.surface, area, unit_number)

            -- look if suddenly moving (again)
            if ntt.manager == "cars" then
                dbg.ftext(radar.surface, ent.position, "CAR " .. ntt.tracker .. " - " .. ent.speed)
                if ent.speed ~= 0.0 then
                    ntt.tracker = RTDEF.tracker.running
                    container.set(ntt)
                end
            elseif ntt.manager == "trains" then
                if ent.train.speed ~= 0.0 then
                    ntt.tracker = RTDEF.tracker.running
                    container.set(ntt)
                end
            end

        else
            container.remove(ntt)
        end
    end
end

event_handler.sector_scan_trackers.rotational = function(radar)
    for unit_number, ntt in pairs(container.get_all_tracker_by_force(RTDEF.tracker.rotating, radar.force.name)) do
        if global.log_level > 2 then printmsg("rotational; " .. unit_number .. " ntt " .. ntt.entity.name) end
    end
end