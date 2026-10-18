--- Interaction wrapper (open code). Every target the resource registers goes
--- through here as an array of ox_target-shaped options:
---
---   {
---       name        = 'unique-id',        -- used for removal
---       label       = 'Remove Wheel',
---       icon        = 'fas fa-wrench',    -- FontAwesome, prefix optional
---       iconColor   = '#82E58B',          -- optional
---       distance    = 1.75,
---       canInteract = function(entity) end,
---       onSelect    = function(data) end, -- data.entity on entity targets
---       action      = function(entity) end,
---   }
---
--- setup.interact = 'auto' (the default) picks, in order: lation_interact,
--- ox_target, qb-target. Add your own system under 'custom'.
local runtime = require 'shared.runtime'
local setup = runtime.setup

local DISTANCE = 1.75

local function DetectInteractSystem()
    if GetResourceState('lation_interact') == 'started' then
        return 'lation_interact'
    elseif GetResourceState('ox_target') == 'started' then
        return 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        return 'qb-target'
    end

    print('^1[ERROR]: No supported interaction system was detected.^0')
    return nil
end

local detectedInteract = nil

local function getInteractSystem()
    local configured = setup.interact

    if configured == 'auto' or not configured then
        if not detectedInteract then
            detectedInteract = DetectInteractSystem()
        end
        return detectedInteract
    end

    return configured
end

-- lation_interact removes anchors by the id its add* call returned, while the
-- rest of the resource removes by option name. Remember each id under the
-- names it was registered with; removing an id twice is a safe no-op there.
local anchorIds = {}

local function rememberAnchor(data, id)
    if not id then return end
    for i = 1, #data do
        local name = data[i].name
        if name then anchorIds[name] = id end
    end
end

local function forgetAnchor(name)
    local id = anchorIds[name]
    if not id then return end
    anchorIds[name] = nil
    exports.lation_interact:remove(id)
end

-- lation_interact takes bare FontAwesome solid names ('wrench'); the icons
-- config carries the 'fas fa-' prefix other systems expect.
local function faName(icon)
    if type(icon) ~= 'string' or icon == '' then return nil end
    return icon:match('fa%-([%w%-]+)$') or icon
end

local function lationOptions(data)
    local out = {}
    for i = 1, #data do
        local option = data[i]
        out[i] = {
            label = option.label,
            icon = faName(option.icon),
            iconColor = option.iconColor ~= '' and option.iconColor or nil,
            canInteract = option.canInteract and function(payload)
                return option.canInteract(payload.entity, payload.distance)
            end or nil,
            onSelect = option.onSelect and function(payload)
                option.onSelect(payload)
            end or nil,
        }
    end
    return out
end

--- @param entity number
--- @param data table ox_target-shaped options
--- @param anchor table|nil { bone = 'bonnet' } places the lation_interact anchor on a bone
local function AddTargetEntity(entity, data, anchor)
    local interact = getInteractSystem()
    if not interact then return end

    if interact == 'lation_interact' then
        rememberAnchor(data, exports.lation_interact:addEntity(entity, {
            bone = anchor and anchor.bone or nil,
            options = lationOptions(data),
        }))
    elseif interact == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, data)
    elseif interact == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, { options = data, distance = DISTANCE })
    elseif interact == 'custom' then
        -- Add support for a custom target system here
    end
end

local function AddTargetModel(model, data)
    local interact = getInteractSystem()
    if not interact then return end

    if interact == 'lation_interact' then
        local id = exports.lation_interact:addModel(model, { options = lationOptions(data) })
        if id then anchorIds[model] = id end
    elseif interact == 'ox_target' then
        exports.ox_target:addModel(model, data)
    elseif interact == 'qb-target' then
        exports['qb-target']:AddTargetModel(model, { options = data, distance = DISTANCE })
    elseif interact == 'custom' then
        -- Add support for a custom target system here
    end
end

local function AddGlobalVehicle(data)
    local interact = getInteractSystem()
    if not interact then return end

    if interact == 'lation_interact' then
        rememberAnchor(data, exports.lation_interact:addGlobalVehicle({ options = lationOptions(data) }))
    elseif interact == 'ox_target' then
        exports.ox_target:addGlobalVehicle(data)
    elseif interact == 'qb-target' then
        exports['qb-target']:AddGlobalVehicle({ options = data, distance = DISTANCE })
    elseif interact == 'custom' then
        -- Add support for a custom target system here
    end
end

local function AddTargetBone(entity, bone, data)
    local interact = getInteractSystem()
    if not interact then return end

    if interact == 'lation_interact' then
        rememberAnchor(data, exports.lation_interact:addEntity(entity, {
            bone = bone,
            options = lationOptions(data),
        }))
    elseif interact == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, data)
    elseif interact == 'qb-target' then
        exports['qb-target']:AddTargetBone(bone, { options = data, distance = DISTANCE })
    elseif interact == 'custom' then
        -- Add support for a custom target system here
    end
end

local function RemoveTargetEntity(entity, name)
    local interact = getInteractSystem()
    if not interact then return end

    if interact == 'lation_interact' then
        forgetAnchor(name)
    elseif interact == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity, name)
    elseif interact == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(entity, name)
    elseif interact == 'custom' then
        -- Add support for a custom target system here
    end
end

local function RemoveTargetModel(model)
    local interact = getInteractSystem()
    if not interact then return end

    if interact == 'lation_interact' then
        forgetAnchor(model)
    elseif interact == 'ox_target' then
        exports.ox_target:removeModel(model, nil)
    elseif interact == 'qb-target' then
        exports['qb-target']:RemoveTargetModel(model, nil)
    elseif interact == 'custom' then
        -- Add support for a custom target system here
    end
end

local function RemoveTargetBone(entity, bone, name)
    local interact = getInteractSystem()
    if not interact then return end

    if interact == 'lation_interact' then
        forgetAnchor(name)
    elseif interact == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity, name)
    elseif interact == 'qb-target' then
        exports['qb-target']:RemoveTargetBone(bone, name)
    elseif interact == 'custom' then
        -- Add support for a custom target system here
    end
end

return {
    AddTargetEntity = AddTargetEntity,
    AddTargetModel = AddTargetModel,
    AddGlobalVehicle = AddGlobalVehicle,
    AddTargetBone = AddTargetBone,
    RemoveTargetEntity = RemoveTargetEntity,
    RemoveTargetModel = RemoveTargetModel,
    RemoveTargetBone = RemoveTargetBone,
}
