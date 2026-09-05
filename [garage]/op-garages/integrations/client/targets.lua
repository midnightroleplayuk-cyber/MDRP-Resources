------------------------------------------------------------------
-- TARGETS FUNCTIONS, YOU CAN CONNECT YOUR OWN SYSTEM TO THIS ----
------------------------------------------------------------------


function removeTarget(target)
    if Config.Misc.Target == "ox-target" then
        exports.ox_target:removeZone(target)
    elseif Config.Misc.Target == "qb-target" then
        exports['qb-target']:RemoveZone(target)
    elseif Config.Misc.Target == "onex-radialmenu" then
        exports['onex-radialmenu']:onexRemoveRadialItem(target.parent, target.id)
    end
end

function removeTargetEntity(entity)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    if Config.Misc.Target == "ox-target" then
        exports.ox_target:removeLocalEntity(entity)
    elseif Config.Misc.Target == "qb-target" then
        exports['qb-target']:RemoveTargetEntity(entity)
    end
end

function addTargetEntity(entity, icon, label, onselect, caninteract, distance)
    distance = distance or 2.75

    if Config.Misc.Target == "ox-target" then
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
    elseif Config.Misc.Target == "qb-target" then
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

function addTargetTyped(name, coords, size, icon, label, onselect, caninteract)
    if Config.Misc.Target == "ox-target" then
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
    elseif Config.Misc.Target == "qb-target" then
        exports['qb-target']:AddCircleZone(name, coords, size.x, {name = name, debugPoly = false, useZ = true}, {
            options = {
                {icon = icon, label = label, action = function()
                    onselect()
                end, canInteract = function(entity)
                    return caninteract() == true
                end}
            },
            distance = math.max(size.x, 2.75)
        })
        return name
    elseif Config.Misc.Target == "onex-radialmenu" then
        exports['onex-radialmenu']:onexRadialItemAdd({
            title = label,
            closeRadialMenu = false,
            icon = {
                address = icon,
                width = "24px",
                height = "24px"
            },
            type = "nested",
            trigger = {
                onSelect = function()
                    onselect()
                end
            }
        }, name, 'main_menu')
        return {id = name, parent = "main_menu"}
    end
end