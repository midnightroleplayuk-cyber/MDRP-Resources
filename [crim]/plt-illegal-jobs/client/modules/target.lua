
local Nui = require 'client.modules.nui'

local Target = {}

-- Fallback [E]-prompt handles, keyed by zone key / entity handle, so removeZone/
-- removeLocalEntity/removeBone can tear them down alongside the real target zone.
local fallbackZones = {}
local fallbackEntities = {}

---@return 'ox'|'qb'|'e'
local function resolveSystem()
    local cfg = Config.Target or {}
    local wanted = cfg.System or 'auto'

    if wanted == 'disabled' or wanted == 'e' then return 'e' end

    if wanted == 'ox' then
        return shared.isResourceStart('ox_target') and 'ox' or 'e'
    end

    if wanted == 'qb' then
        return shared.isResourceStart('qb-target') and 'qb' or 'e'
    end

    -- auto
    if shared.isResourceStart('ox_target') then return 'ox' end
    if shared.isResourceStart('qb-target') then return 'qb' end
    return 'e'
end

local function eKeyLabel(text)
    local fmt = (Config.Target and Config.Target.EKeyLabel) or '[E] %s'
    local ok, formatted = pcall(string.format, fmt, text)
    return ok and formatted or text
end

local function eKeyControl()
    return (Config.Target and Config.Target.EKey) or 38
end

---@param options table[]
---@return table|nil
local function pickOption(options)
    for _, option in ipairs(options) do
        if not option.canInteract or option.canInteract() then
            return option
        end
    end
    return nil
end

-- Self-managed proximity loop rather than lib.points: lib.points buckets a point
-- into a static spatial grid at creation time, so it never re-checks entities
-- that move away from their original cell (vehicles, peds). This polls the live
-- coords every frame instead, which correctly follows moving targets.
---@param coordsFn fun(): vector3|nil
---@param options table[]
---@return table handle with :remove()
local function createEPrompt(coordsFn, options)
    local visible = false
    local removed = false

    local function hide()
        if visible then
            visible = false
            Nui.hideTextUI()
        end
    end

    CreateThread(function()
        while not removed do
            Wait(0)

            local coords = coordsFn()
            local option = coords and pickOption(options) or nil
            local dist = option and #(GetEntityCoords(cache.ped) - coords) or nil

            if not option or dist > (option.distance or 2.5) then
                hide()
            else
                visible = true
                Nui.showTextUI(eKeyLabel(option.label or 'Interact'))

                if IsControlJustPressed(0, eKeyControl()) then
                    hide()
                    option.onSelect()
                end
            end
        end
    end)

    return {
        remove = function()
            removed = true
            hide()
        end,
    }
end

---@param entities integer|integer[]
local function firstEntity(entities)
    if type(entities) == 'table' then return entities[1] end
    return entities
end

function Target.addBoxZone(key, parameters)
    local system = resolveSystem()
    local forceE = Config.Target and Config.Target.ForceE

    local id = key
    if system == 'ox' then
        parameters.name = key
        parameters.drawSprite = false
        id = exports.ox_target:addBoxZone(parameters)
    elseif system == 'qb' then
        for _, option in pairs(parameters.options) do
            option.action = option.onSelect
        end
        local heading = 0.0
        if parameters.rotation then
            heading = type(parameters.rotation) == 'number' and parameters.rotation or parameters.rotation.z or 0.0
        end
        exports['qb-target']:AddBoxZone(key, parameters.coords, parameters.size.y, parameters.size.x,
            { name = key, heading = heading, debugPoly = parameters.debug,
              minZ = parameters.coords.z - parameters.size.z, maxZ = parameters.coords.z + parameters.size.z },
            { options = parameters.options, distance = 2.5 })
        id = key
    end

    if system == 'e' or forceE then
        local coords = parameters.coords
        fallbackZones[key] = createEPrompt(function() return coords end, parameters.options)
    end

    return id
end

function Target.removeZone(id)
    local system = resolveSystem()
    if system == 'ox' then
        exports.ox_target:removeZone(id)
    elseif system == 'qb' then
        exports['qb-target']:RemoveZone(id)
    end

    if fallbackZones[id] then
        fallbackZones[id]:remove()
        fallbackZones[id] = nil
    end

    return true
end

function Target.addLocalEntity(entities, options)
    local system = resolveSystem()
    local forceE = Config.Target and Config.Target.ForceE

    if system == 'ox' then
        exports.ox_target:addLocalEntity(entities, options)
    elseif system == 'qb' then
        for _, option in pairs(options) do
            option.job    = option.groups
            option.action = option.onSelect
        end
        exports['qb-target']:AddTargetEntity(entities, { options = options })
    end

    if system == 'e' or forceE then
        local entity = firstEntity(entities)
        if fallbackEntities[entity] then
            fallbackEntities[entity]:remove()
            fallbackEntities[entity] = nil
        end
        fallbackEntities[entity] = createEPrompt(function()
            if not DoesEntityExist(entity) then return nil end
            return GetEntityCoords(entity)
        end, options)
    end

    return true
end

function Target.removeLocalEntity(entities)
    local system = resolveSystem()
    if system == 'ox' then
        exports.ox_target:removeLocalEntity(entities)
    elseif system == 'qb' then
        exports['qb-target']:RemoveTargetEntity(entities)
    end

    local entity = firstEntity(entities)
    if fallbackEntities[entity] then
        fallbackEntities[entity]:remove()
        fallbackEntities[entity] = nil
    end

    return true
end

function Target.addBone(entities, options, network)
    local system = resolveSystem()
    local forceE = Config.Target and Config.Target.ForceE

    if system == 'ox' then
        if not network then
            exports.ox_target:addLocalEntity(entities, options)
        else
            exports.ox_target:addEntity(entities, options)
        end
    elseif system == 'qb' then
        for _, option in pairs(options) do
            option.job    = option.groups
            option.action = option.onSelect
        end
        exports['qb-target']:AddTargetEntity(entities, { options = options })
    end

    if system == 'e' or forceE then
        local entity = firstEntity(entities)
        if fallbackEntities[entity] then
            fallbackEntities[entity]:remove()
            fallbackEntities[entity] = nil
        end
        fallbackEntities[entity] = createEPrompt(function()
            if not DoesEntityExist(entity) then return nil end
            return GetEntityCoords(entity)
        end, options)
    end

    return true
end

function Target.removeBone(entities, network)
    local system = resolveSystem()
    if system == 'ox' then
        if not network then
            exports.ox_target:removeLocalEntity(entities)
        else
            exports.ox_target:removeEntity(entities)
        end
    elseif system == 'qb' then
        exports['qb-target']:RemoveTargetEntity(entities)
    end

    local entity = firstEntity(entities)
    if fallbackEntities[entity] then
        fallbackEntities[entity]:remove()
        fallbackEntities[entity] = nil
    end

    return true
end

return Target
