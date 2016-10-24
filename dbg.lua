
--- debugger class
dbg = {}

dbg.charting = function(surface, area, unit_number)
    for _, i in pairs({'left_top', 'right_bottom'}) do
        for _, j in pairs({'left_top', 'right_bottom'}) do
            local pos = {area[i].x, area[j].y}
            surface.create_entity({ name = "flying-text-chartedges", position = pos, text = unit_number})
        end
    end
end

dbg.container = function(surface, pos, text)
    surface.create_entity({ name = "flying-text-chartedges", position = pos, text = text})
end