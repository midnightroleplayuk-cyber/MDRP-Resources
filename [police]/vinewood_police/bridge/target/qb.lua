local function convert(options)
    local out, dist = {}, 2.0
    for i, o in ipairs(options) do
        dist = math.max(dist, o.distance or 2.0)
        out[i] = {
            label = o.label,
            icon = o.icon,
            canInteract = o.canInteract and function(entity) return o.canInteract(entity) end or nil,
            action = function(entity) if o.onSelect then o.onSelect(entity) end end,
        }
    end
    return { options = out, distance = dist }
end

local function labels(list)
    local out = {}
    for i, o in ipairs(list) do out[i] = type(o) == 'table' and o.label or o end
    return out
end

VPO.Target._Register('qb',
    function() return GetResourceState('qb-target') == 'started' end,
    {
        AddBox = function(name, z, options)
            local size = z.size or vec3(1.5, 1.5, 2.0)
            exports['qb-target']:AddBoxZone(name, z.coords, size.x, size.y, {
                name = name, heading = z.rotation or 0.0, debugPoly = z.debug,
                minZ = z.coords.z - size.z / 2, maxZ = z.coords.z + size.z / 2,
            }, convert(options))
            return name
        end,
        RemoveZone = function(name) exports['qb-target']:RemoveZone(name) end,
        AddGlobalPlayer = function(options) exports['qb-target']:AddGlobalPlayer(convert(options)) end,
        -- qb-target removes global options by label, so pass the same option tables you added.
        RemoveGlobalPlayer = function(list) exports['qb-target']:RemoveGlobalPlayer(labels(list)) end,
        AddGlobalVehicle = function(options) exports['qb-target']:AddGlobalVehicle(convert(options)) end,
        RemoveGlobalVehicle = function(list) exports['qb-target']:RemoveGlobalVehicle(labels(list)) end,
        AddGlobalPed = function(options) exports['qb-target']:AddGlobalPed(convert(options)) end,
        RemoveGlobalPed = function(list) exports['qb-target']:RemoveGlobalPed(labels(list)) end,
        AddGlobalObject = function(options) exports['qb-target']:AddGlobalObject(convert(options)) end,
        RemoveGlobalObject = function(list) exports['qb-target']:RemoveGlobalObject(labels(list)) end,
        AddEntity = function(entity, options) exports['qb-target']:AddTargetEntity(entity, convert(options)) end,
        RemoveEntity = function(entity, list) exports['qb-target']:RemoveTargetEntity(entity, labels(list)) end,
    })
