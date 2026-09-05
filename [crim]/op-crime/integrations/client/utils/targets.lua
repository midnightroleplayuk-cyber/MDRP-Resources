------------------------------------------------------------------
-- Target Integration Layer                                       
-- (Information) ► Centralized bridge for ox_target / qb-target. 
------------------------------------------------------------------

---@param target string|number
function removeTarget(target)
    if not target then return end
    if Config.Misc.AccessMethod == "ox-target" then
        exports.ox_target:removeZone(target)
    elseif Config.Misc.AccessMethod == "qb-target" then
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
    if Config.Misc.AccessMethod == "ox-target" then
        -- Replace any previous zone with the same name to avoid stacked options.
        pcall(function()
            exports.ox_target:removeZone(name)
        end)

        return exports.ox_target:addBoxZone({
            name = name,
            coords = coords,
            size = size,
            options = {
                {
                    name = name,
                    icon = icon,
                    label = label,
                    distance = 3.0,
                    onSelect = function()
                        onselect()
                    end
                }
            }
        })
    elseif Config.Misc.AccessMethod == "qb-target" then
        pcall(function()
            exports['qb-target']:RemoveZone(name)
        end)

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

---@param data any
function removeTargetPlayer(data)
    if not data then return end
    if Config.Misc.AccessMethod == "ox-target" then
        exports.ox_target:removeGlobalPlayer(data)
    elseif Config.Misc.AccessMethod == "qb-target" then
        exports['qb-target']:RemoveGlobalPlayer(data)
    end
end

---@param name string
---@param icon string
---@param label string
---@param onselect function
---@return string
function addTargetPlayer(name, icon, label, onselect, canInt)
    if Config.Misc.AccessMethod == "ox-target" then
        -- `name` is required so removeGlobalPlayer can actually clear old options.
        pcall(function()
            exports.ox_target:removeGlobalPlayer(name)
        end)

        exports.ox_target:addGlobalPlayer({
            {
                name = name,
                distance = 2.0,
                icon = icon,
                label = label,
                onSelect = function()
                    onselect()
                end,
                canInteract = function(entity)
                    return canInt(entity)
                end,
            }
        })
        return name
    elseif Config.Misc.AccessMethod == "qb-target" then
        pcall(function()
            exports['qb-target']:RemoveGlobalPlayer(label)
        end)

        exports['qb-target']:AddGlobalPlayer({
            options = {
                {
                    num = 1,
                    type = "client",
                    icon = icon,
                    label = label,
                    action = function(entity)
                        onselect()
                    end,
                    canInteract = function(entity)
                        return canInt(entity)
                    end
                }
            },
            distance = 2.5
        })
        return label
    end
end

---@param name string
---@param icon string
---@param label string
---@param onselect function
---@return string
function addTargetVehicle(name, icon, label, onselect, canInt)
    if Config.Misc.AccessMethod == "ox-target" then
        pcall(function()
            exports.ox_target:removeGlobalVehicle(name)
        end)

        exports.ox_target:addGlobalVehicle({
            {
                name = name,
                icon = icon,
                label = label,
                distance = 2.5,
                onSelect = function()
                    onselect()
                end,
                canInteract = function(entity)
                    return canInt(entity)
                end
            }
        })
        return name
    elseif Config.Misc.AccessMethod == "qb-target" then
        pcall(function()
            exports['qb-target']:RemoveGlobalVehicle(label)
        end)

        exports['qb-target']:AddGlobalVehicle({
            options = {
                {
                    num = 1,
                    type = "client",
                    icon = icon,
                    label = label,
                    action = function(entity)
                        onselect()
                    end,
                    canInteract = function(entity)
                        return canInt(entity)
                    end
                }
            },
            distance = 2.5
        })
        return label
    end
end

---@param data any
function removeTargetVehicle(data)
    if not data then return end
    if Config.Misc.AccessMethod == "ox-target" then
        exports.ox_target:removeGlobalVehicle(data)
    elseif Config.Misc.AccessMethod == "qb-target" then
        exports['qb-target']:RemoveGlobalVehicle(data)
    end
end
