Bridge = Bridge or {}

local detectedTarget
local registeredZones = {}

local function detectTarget()
    if detectedTarget then return detectedTarget end

    if Config.Target ~= 'auto' then
        detectedTarget = Config.Target
        return detectedTarget
    end

    if ResourceStarted('ox_target') then
        detectedTarget = 'ox_target'
    elseif ResourceStarted('qb-target') then
        detectedTarget = 'qb-target'
    elseif ResourceStarted('qtarget') then
        detectedTarget = 'qtarget'
    else
        detectedTarget = 'none'
    end

    return detectedTarget
end

function Bridge.GetDetectedTarget()
    return detectTarget()
end

function Bridge.AddBoxZone(name, coords, size, options)
    local target = detectTarget()

    if target == 'none' then
        local option = options and options[1]

        registeredZones[#registeredZones + 1] = {
            type = 'textui',
            id = name,
            coords = coords,
            options = options,
            distance = option and option.distance or 2.0
        }
        return
    end

    if target == 'ox_target' then
        local zoneId = exports.ox_target:addBoxZone({
            coords = coords,
            size = size or vec3(1.2, 1.2, 1.2),
            rotation = 0.0,
            debug = Config.Debug,
            options = options
        })
        registeredZones[#registeredZones + 1] = { type = 'ox_target', id = zoneId }
        return
    end

    local qbOptions = {}
    for i = 1, #options do
        local option = options[i]
        qbOptions[#qbOptions + 1] = {
            icon = option.icon,
            label = option.label,
            action = option.onSelect,
            canInteract = option.canInteract
        }
    end

    if target == 'qb-target' then
        exports['qb-target']:AddBoxZone(name, coords, size.x or 1.2, size.y or 1.2, {
            name = name,
            heading = 0.0,
            debugPoly = Config.Debug,
            minZ = coords.z - 1.0,
            maxZ = coords.z + 1.0
        }, {
            options = qbOptions,
            distance = 2.0
        })
        registeredZones[#registeredZones + 1] = { type = 'qb-target', id = name }
        return
    end

    if target == 'qtarget' then
        exports.qtarget:AddBoxZone(name, coords, size.x or 1.2, size.y or 1.2, {
            name = name,
            heading = 0.0,
            debugPoly = Config.Debug,
            minZ = coords.z - 1.0,
            maxZ = coords.z + 1.0
        }, {
            options = qbOptions,
            distance = 2.0
        })
        registeredZones[#registeredZones + 1] = { type = 'qtarget', id = name }
    end
end

function Bridge.AddLocalEntity(entity, options, distance)
    local target = detectTarget()

    if target == 'none' then
        registeredZones[#registeredZones + 1] = {
            type = 'entity',
            id = ('entity:%s'):format(entity),
            entity = entity,
            options = options,
            distance = distance or 2.0
        }
        return
    end

    if target == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, options)
        registeredZones[#registeredZones + 1] = { type = 'ox_target_entity', entity = entity }
        return
    end

    local qbOptions = {}
    for i = 1, #options do
        local option = options[i]
        qbOptions[#qbOptions + 1] = {
            icon = option.icon,
            label = option.label,
            action = option.onSelect,
            canInteract = option.canInteract
        }
    end

    if target == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = qbOptions,
            distance = distance or 2.0
        })
        registeredZones[#registeredZones + 1] = { type = 'qb-target_entity', entity = entity }
        return
    end

    if target == 'qtarget' then
        exports.qtarget:AddTargetEntity(entity, {
            options = qbOptions,
            distance = distance or 2.0
        })
        registeredZones[#registeredZones + 1] = { type = 'qtarget_entity', entity = entity }
    end
end

function Bridge.RemoveRegisteredTargets()
    for i = #registeredZones, 1, -1 do
        local entry = registeredZones[i]

        if entry.type == 'ox_target' and ResourceStarted('ox_target') then
            exports.ox_target:removeZone(entry.id)
        elseif entry.type == 'qb-target' and ResourceStarted('qb-target') then
            exports['qb-target']:RemoveZone(entry.id)
        elseif entry.type == 'qtarget' and ResourceStarted('qtarget') then
            exports.qtarget:RemoveZone(entry.id)
        elseif entry.type == 'ox_target_entity' and ResourceStarted('ox_target') and DoesEntityExist(entry.entity) then
            exports.ox_target:removeLocalEntity(entry.entity)
        elseif entry.type == 'qb-target_entity' and ResourceStarted('qb-target') and DoesEntityExist(entry.entity) then
            exports['qb-target']:RemoveTargetEntity(entry.entity)
        elseif entry.type == 'qtarget_entity' and ResourceStarted('qtarget') and DoesEntityExist(entry.entity) then
            exports.qtarget:RemoveTargetEntity(entry.entity)
        end

        registeredZones[i] = nil
    end
end

function Bridge.GetFallbackZones()
    return registeredZones
end

Bridge.GetMarkerZones = Bridge.GetFallbackZones
