if Bridge.Target ~= 'qb-target' then return end

Target = Target or {}
Target.Resource = 'qb-target'

local function ToQBOptions(options)
    local converted = {}
    for index, option in ipairs(options or {}) do
        local action = option.onSelect or option.action
        converted[index] = {
            type = option.type or 'client',
            action = action and function(entity)
                return action({ entity = entity })
            end or nil,
            event = option.event,
            icon = option.icon,
            label = option.label,
            job = option.groups or option.job,
            item = option.items or option.item,
            canInteract = option.canInteract
        }
    end
    return converted
end

function Target.AddLocalEntity(entity, options, distance)
    if not DoesEntityExist(entity) then return end
    exports['qb-target']:AddTargetEntity(entity, { options = ToQBOptions(options), distance = distance or 2.5 })
    return entity
end

function Target.AddModel(models, options, distance)
    exports['qb-target']:AddTargetModel(models, { options = ToQBOptions(options), distance = distance or 2.5 })
end

function Target.AddSphereZone(data)
    local name = data.name or ('sphere_' .. math.random(100000, 999999))
    exports['qb-target']:AddCircleZone(name, data.coords, data.radius, {
        name = name,
        debugPoly = data.debug == true,
        useZ = data.useZ ~= false
    }, { options = ToQBOptions(data.options), distance = data.distance or 2.5 })
    return name
end

function Target.AddBoxZone(data)
    local name = data.name or ('box_' .. math.random(100000, 999999))
    local size = data.size or vector3(1.0, 1.0, 1.0)
    exports['qb-target']:AddBoxZone(name, data.coords, size.x or size[1] or 1.0, size.y or size[2] or 1.0, {
        name = name,
        heading = data.rotation or data.heading or 0.0,
        debugPoly = data.debug == true,
        minZ = data.minZ or (data.coords.z - ((size.z or size[3] or 1.0) / 2)),
        maxZ = data.maxZ or (data.coords.z + ((size.z or size[3] or 1.0) / 2))
    }, { options = ToQBOptions(data.options), distance = data.distance or 2.5 })
    return name
end

function Target.AddGlobalPlayer(options, distance)
    exports['qb-target']:AddGlobalPlayer({ options = ToQBOptions(options), distance = distance or 2.5 })
end

function Target.AddGlobalVehicle(options, distance)
    exports['qb-target']:AddGlobalVehicle({ options = ToQBOptions(options), distance = distance or 2.5 })
end

function Target.RemoveZone(name)
    if name ~= nil then exports['qb-target']:RemoveZone(name) end
end

function Target.RemoveLocalEntity(entity, names)
    if DoesEntityExist(entity) then exports['qb-target']:RemoveTargetEntity(entity, names) end
end
