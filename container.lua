
container = {}

container.ntt = {}
container.ntt4rc = {}

container.set = function(unit_number, ntt)
    if ntt.valid then
        container.ntt4rc[ntt.force.name][unit_number] = container.ntt[unit_number] = ntt
    end
end

container.get = function(unit_number)
    local e = container.ntt[unit_number]
    if e.valid then
        return e
    end
end

container.get_by_force = function(unit_number, force_name)
    local e = container.ntt4rc[force_name][unit_number]
    if e.valid then
        return e
    end
end

container.remove = function(unit_number)
    local e = container.ntt[unit_number]
    if e then
        container.ntt4rc[e.force.name][unit_number] = nil
        container.ntt[unit_number] = nil
    end
end

-- INIT
for _,force in pairs(game.forces) do
    container.ntt4rc[force.name] = {}
end
