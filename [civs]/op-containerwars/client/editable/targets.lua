------------------------------------------------------------------
-- TARGETS FUNCTIONS, YOU CAN CONNECT YOUR OWN SYSTEM TO THIS ----
------------------------------------------------------------------


function removeTarget(target)
    if Config.Misc.Target == "ox-target" then
        exports.ox_target:removeZone(target)
    elseif Config.Misc.Target == "qb-target" then
        exports['qb-target']:RemoveZone(target)
    end
end

function addTargetTyped(name, coords, size, icon, label, onselect)
    if Config.Misc.Target == "ox-target" then
        return exports.ox_target:addBoxZone({
            name = name,
            coords = coords,
            size = size,
            options = {
                {
                    icon = icon,
                    label = label,
                    onSelect = function() onselect() end
                }
            }
        })
    elseif Config.Misc.Target == "qb-target" then
        exports['qb-target']:AddCircleZone(name, coords, size.x, {name = name, debugPoly = false}, {
            options = {
                {icon = icon, label = label, action = function()
                    onselect()
                end}
            }
        })
        return name
    end
end