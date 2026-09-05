------------------------------------------------------------------
-- TARGETS FUNCTIONS, YOU CAN CONNECT YOUR OWN SYSTEM TO THIS ----
------------------------------------------------------------------

function removeTarget(target)
    if not target then return end
    if type(target) == 'table' and target.remove then
        target.remove()
        return
    end
    local id = type(target) == 'table' and (target.id or target.name) or target

    if Config.Target == 'ox-target' then
        exports.ox_target:removeZone(id)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:RemoveZone(id)
    end
end

function removeTargetEntity(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    if Config.Target == 'ox-target' then
        exports.ox_target:removeLocalEntity(entity)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(entity)
    end
end

function addTargetEntity(entity, icon, label, onselect, caninteract, distance)
    distance = distance or 2.75

    if Config.Target == 'ox-target' then
        exports.ox_target:addLocalEntity(entity, {
            {
                icon = icon,
                label = label,
                distance = distance,
                onSelect = function()
                    onselect()
                end,
                canInteract = function()
                    return caninteract() == true
                end,
            }
        })
        return entity
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = {
                {
                    icon = icon,
                    label = label,
                    action = function()
                        onselect()
                    end,
                    canInteract = function()
                        return caninteract() == true
                    end,
                }
            },
            distance = distance
        })
        return entity
    end
end

function addTargetEntityOptions(entity, options, distance)
    distance = distance or 2.5
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end

    local list = {}
    for i = 1, #(options or {}) do
        local o = options[i]
        list[i] = {
            name = o.name,
            icon = o.icon,
            label = o.label,
            distance = o.distance or distance,
            onSelect = o.onSelect,
            canInteract = o.canInteract,
            action = o.onSelect,
        }
    end

    if Config.Target == 'ox-target' then
        exports.ox_target:addLocalEntity(entity, list)
        return true
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = list,
            distance = distance
        })
        return true
    end
    return false
end

function addTargetSphere(name, coords, radius, options, distance)
    radius = radius or 1.5
    distance = distance or math.min(radius, 2.5)
    coords = vector3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)

    local list = {}
    for i = 1, #(options or {}) do
        local o = options[i]
        list[i] = {
            name = o.name,
            icon = o.icon,
            label = o.label,
            distance = o.distance or distance,
            onSelect = o.onSelect,
            canInteract = o.canInteract,
            action = o.onSelect,
        }
    end

    if Config.Target == 'ox-target' then
        return exports.ox_target:addSphereZone({
            name = name,
            coords = coords,
            radius = radius,
            options = list,
        })
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddCircleZone(name, coords, radius, {
            name = name,
            debugPoly = false,
            useZ = true,
        }, {
            options = list,
            distance = distance,
        })
        return name
    end
end

function addTargetTyped(name, coords, size, icon, label, onselect, caninteract)
    if Config.Target == 'ox-target' then
        return exports.ox_target:addBoxZone({
            name = name,
            coords = coords,
            size = size,
            options = {
                {
                    icon = icon,
                    label = label,
                    onSelect = function() onselect() end,
                    canInteract = function()
                        return caninteract()
                    end,
                }
            }
        })
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddCircleZone(name, coords, size.x, { name = name, debugPoly = false, useZ = true }, {
            options = {
                {
                    icon = icon,
                    label = label,
                    action = function()
                        onselect()
                    end,
                    canInteract = function()
                        return caninteract() == true
                    end
                }
            },
            distance = math.max(size.x, 2.75)
        })
        return name
    end
end