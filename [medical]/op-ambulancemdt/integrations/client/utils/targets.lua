------------------------------------------------------------------
-- Target Integration Layer                                       
-- (Information) ► Centralized bridge for ox_target / qb-target. 
------------------------------------------------------------------

---@param target string|number
function removeTarget(target)
    if Config.Target == "ox-target" then
        exports.ox_target:removeZone(target)
    elseif Config.Target == "qb-target" then
        exports['qb-target']:RemoveZone(target)
    end
end

---@param name string
---@param coords vector3
---@param size vector3
---@param icon string
---@param label string
---@param onselect function
---@return any
function addTargetTyped(name, coords, size, icon, label, onselect)
    if Config.Target == "ox-target" then
        return exports.ox_target:addBoxZone({
            name = name,
            coords = coords,
            size = size,
            options = {
                {
                    icon = icon,
                    label = label,
                    distance = 3.0,
                    onSelect = function()
                        onselect()
                    end
                }
            }
        })
    elseif Config.Target == "qb-target" then
        exports['qb-target']:AddCircleZone(
            name,
            coords,
            size.x,
            { name = name, debugPoly = false },
            {
                options = {
                    {
                        icon = icon,
                        label = label,
                        action = function()
                            onselect()
                        end
                    }
                }
            }
        )
        return name
    end
end
