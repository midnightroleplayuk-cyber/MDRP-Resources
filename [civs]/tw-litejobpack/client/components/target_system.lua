-- ============================================================
--  tw-litejobpack | Target System Abstraction
--  Supports: ox_target, qb-target, distance-based fallback
-- ============================================================

TargetSystem = {}

local _type        = "none"   -- "ox_target" | "qb-target" | "none"
local _available   = false    -- a target resource is running
local _enabled     = false    -- ...and Config.TargetSystem.enabled is on
local _initialized = false
local _registered = {
    entities = {},  -- [entity] = true
    zones    = {},  -- [id]     = true
    models   = {},  -- [id]     = { models, optionName/label }
    bones    = {},  -- [id]     = { bones, label }
}

-- ──────────────────────────────────────────────────────────
--  Internal helpers
-- ──────────────────────────────────────────────────────────

local function _resolveType()
    local cfg = Config.TargetSystem
    if not cfg then
        return "none"
    end

    local preference = cfg.resource or "auto"

    -- The detection deliberately no longer depends on cfg.enabled: the resolved
    -- resource is what IsAvailable() reports, and a target resource has to be
    -- known before any per-point lookup can answer "target" for anything. Only
    -- the warning stays behind cfg.enabled, so servers that never use targets
    -- don't get a warning about a resource they never asked to run.
    if preference == "ox_target" then
        if GetResourceState("ox_target") == "started" then return "ox_target" end
        if cfg.enabled then
            print("[tw-litejobpack] ^3WARN^7 ox_target requested but not running - falling back to none")
        end
        return "none"
    end

    if preference == "qb-target" then
        if GetResourceState("qb-target") == "started" then return "qb-target" end
        if cfg.enabled then
            print("[tw-litejobpack] ^3WARN^7 qb-target requested but not running - falling back to none")
        end
        return "none"
    end

    -- auto-detect: ox_target wins if both happen to be running
    if GetResourceState("ox_target") == "started" then return "ox_target" end
    if GetResourceState("qb-target") == "started" then return "qb-target" end

    return "none"
end

-- Strip [E], [G], [H] etc. key-hint prefixes from labels (not needed in target mode)
local function _cleanLabel(label)
    if not label then return "Interact" end
    return label:gsub("^%[%w%]%s*", "")
end

-- Build a SINGLE option table for ox_target
local function _buildOxOption(opt)
    -- ox_target passes a data table { entity, coords, distance } to onSelect,
    -- but our API normalises onSelect to receive (entity) like qb-target.
    local wrappedOnSelect = opt.onSelect and function(data)
        local entity = type(data) == "table" and data.entity or data
        opt.onSelect(entity)
    end or nil

    return {
        name        = opt.name or ("tw_target_" .. tostring(math.random(100000))),
        label       = _cleanLabel(opt.label),
        icon        = opt.icon  or (Config.TargetSystem and Config.TargetSystem.icon or "fas fa-briefcase"),
        distance    = opt.distance or 2.0,
        onSelect    = wrappedOnSelect,
        canInteract = opt.canInteract,
        bones       = opt.bones or nil,
    }
end

-- Build options array for ox_target (supports single or multi-option)
local function _buildOxOptions(options)
    -- If options is an array of option tables
    if type(options[1]) == "table" then
        local built = {}
        for i, opt in ipairs(options) do
            built[i] = _buildOxOption(opt)
        end
        return built
    end
    -- Single option
    return { _buildOxOption(options) }
end

-- Build a SINGLE option table for qb-target
local function _buildQbOption(opt)
    return {
        type        = "client",
        event       = nil,
        label       = _cleanLabel(opt.label),
        icon        = opt.icon     or (Config.TargetSystem and Config.TargetSystem.icon or "fas fa-briefcase"),
        distance    = opt.distance or 2.0,
        action      = opt.onSelect,
        canInteract = opt.canInteract,
    }
end

-- Build the parameters table for qb-target (supports single or multi-option)
local function _buildQbOptions(options)
    local built = {}
    -- If options is an array of option tables
    if type(options[1]) == "table" then
        for i, opt in ipairs(options) do
            built[i] = _buildQbOption(opt)
        end
    else
        -- Single option
        built[1] = _buildQbOption(options)
    end
    return {
        options  = built,
        distance = options.distance or (options[1] and options[1].distance) or 2.0,
    }
end

-- ──────────────────────────────────────────────────────────
--  Public API - Core
-- ──────────────────────────────────────────────────────────

function TargetSystem.Init()
    _type    = _resolveType()
    _available = (_type ~= "none")
    _enabled = _available and (Config.TargetSystem and Config.TargetSystem.enabled == true) or false
    _initialized = true

    if Config.Debug then
        print(("[tw-litejobpack] TargetSystem.Init -> type=%s  enabled=%s"):format(_type, tostring(_enabled)))
    end
end

function TargetSystem.IsInitialized()
    return _initialized
end

-- Master switch: is the target system turned on at all?
function TargetSystem.IsEnabled()
    return _enabled
end

-- Is a target resource actually running? Callers that only create a scope or
-- tear a registration down ask this instead of IsEnabled, so a single point
-- switched to "target" still has somewhere to register, and a point switched
-- back to "drawtext" mid-session still gets cleaned up.
function TargetSystem.IsAvailable()
    return _available
end

-- ──────────────────────────────────────────────────────────
--  Per-point mode (Config.TargetSystem.points)
-- ──────────────────────────────────────────────────────────

-- Every interaction in the pack asks this instead of IsEnabled(): "should
-- THIS point use the target system, or a drawtext key prompt?". The answer is
-- Config.TargetSystem.points[pointKey], falling back to
-- Config.TargetSystem.default, and it is false for everything while the master
-- switch is off or no target resource is running.
--
-- Both halves of a point -- the target registration and the drawtext branch --
-- must ask with the SAME key, otherwise that interaction ends up with two
-- prompts or none. Use the /jobpackpoints command to list what is registered.
local _seenPoints = {}

function TargetSystem.Use(pointKey)
    if not _enabled then return false end

    local cfg = Config.TargetSystem
    local mode = cfg and cfg.points and pointKey and cfg.points[pointKey]
    if mode == nil then
        mode = (cfg and cfg.default) or "target"
    end

    local useTarget = (mode ~= "drawtext" and mode ~= false)

    if pointKey then
        _seenPoints[pointKey] = useTarget and "target" or "drawtext"
    end

    return useTarget
end

-- Lists every point this session has actually asked about and the mode it got.
-- A point that is configured but never shows up here was never reached; a point
-- that shows up but is not in the config is running on the `default` setting.
-- Both are what you check first when an interaction shows two prompts or none.
RegisterCommand('jobpackpoints', function()
    print(("[tw-litejobpack] target=%s available=%s enabled=%s default=%s")
        :format(_type, tostring(_available), tostring(_enabled),
            tostring(Config.TargetSystem and Config.TargetSystem.default or "target")))

    local keys = {}
    for key in pairs(_seenPoints) do keys[#keys + 1] = key end
    table.sort(keys)

    if #keys == 0 then
        print("[tw-litejobpack] no interaction points reached yet - start a job first")
        return
    end

    for _i, key in ipairs(keys) do
        local configured = Config.TargetSystem and Config.TargetSystem.points
            and Config.TargetSystem.points[key]
        print(("  %-22s %-9s %s"):format(key, _seenPoints[key],
            configured == nil and "(default)" or ""))
    end
end, false)

-- ──────────────────────────────────────────────────────────
--  Disable / Enable targeting (minigame, break session vb.)
-- ──────────────────────────────────────────────────────────

function TargetSystem.Disable()
    if not _available then return end
    if _type == "ox_target" then
        exports.ox_target:disableTargeting(true)
    elseif _type == "qb-target" then
        exports["qb-target"]:AllowTargeting(false)
    end
end

function TargetSystem.Enable()
    if not _available then return end
    if _type == "ox_target" then
        exports.ox_target:disableTargeting(false)
    elseif _type == "qb-target" then
        exports["qb-target"]:AllowTargeting(true)
    end
end

-- ──────────────────────────────────────────────────────────
--  Entity targets (single or multi-option)
-- ──────────────────────────────────────────────────────────

---@param entity    number   GTA entity handle
---@param options   table    Single: { label, icon, distance, onSelect, canInteract }
---                          Multi:  { {label, ...}, {label, ...}, ... }
function TargetSystem.AddEntityTarget(entity, options)
    if not _available or not DoesEntityExist(entity) then
        if Config.Debug then
            print(("[TargetSystem] AddEntityTarget SKIPPED: enabled=%s entity=%s exists=%s"):format(
                tostring(_enabled), tostring(entity), tostring(entity and DoesEntityExist(entity))))
        end
        return
    end
    if Config.Debug then
        local lbl = _cleanLabel(options.label or (options[1] and options[1].label) or "?")
        print(("[TargetSystem] ^2AddEntityTarget^7 entity=%d label=%s type=%s"):format(entity, lbl, _type))
    end

    if _type == "ox_target" then
        exports.ox_target:addLocalEntity(entity, _buildOxOptions(options))
        _registered.entities[entity] = true

    elseif _type == "qb-target" then
        -- qb-target's AddTargetEntity only attaches options to NETWORKED entities.
        -- Job NPCs are spawned as local (non-networked) peds, so on qb-target the
        -- prompt never appears. For those, fall back to a coordinate-based circle
        -- zone at the entity's position (job NPCs are frozen, coords are stable).
        -- ox_target uses addLocalEntity above and is unaffected.
        if NetworkGetEntityIsNetworked(entity) then
            exports["qb-target"]:AddTargetEntity(entity, _buildQbOptions(options))
            _registered.entities[entity] = true
        else
            local c = GetEntityCoords(entity)
            local radius = (type(options[1]) == "table" and options[1].distance)
                or options.distance or 2.0
            local zoneId = ("tw_localent_%d"):format(entity)
            exports["qb-target"]:RemoveZone(zoneId) -- guard against re-add on same handle
            exports["qb-target"]:AddCircleZone(zoneId, c, radius, {
                name      = zoneId,
                useZ      = true,
                debugPoly = Config.Debug or false,
            }, _buildQbOptions(options))
            -- store the zoneId (string) instead of `true` so RemoveEntityTarget
            -- knows this entity was registered as a zone, not a netId target.
            _registered.entities[entity] = zoneId
        end
    end
end

---@param entity number
---@param optionNames? string|string[]  specific option names to remove (nil = remove all)
function TargetSystem.RemoveEntityTarget(entity, optionNames)
    if not _registered.entities[entity] then return end
    if Config.Debug then
        print(("[TargetSystem] ^1RemoveEntityTarget^7 entity=%s optionNames=%s"):format(tostring(entity), tostring(optionNames)))
    end

    if _type == "ox_target" then
        if DoesEntityExist(entity) then
            exports.ox_target:removeLocalEntity(entity, optionNames)
        end

    elseif _type == "qb-target" then
        local tracked = _registered.entities[entity]
        if type(tracked) == "string" then
            -- local-entity fallback was registered as a circle zone (removes all options)
            exports["qb-target"]:RemoveZone(tracked)
        elseif DoesEntityExist(entity) then
            if optionNames then
                exports["qb-target"]:RemoveTargetEntity(entity, optionNames)
            else
                exports["qb-target"]:RemoveTargetEntity(entity)
            end
        end
    end

    if not optionNames then
        _registered.entities[entity] = nil
    end
end

-- ──────────────────────────────────────────────────────────
--  Box zone targets
-- ──────────────────────────────────────────────────────────

---@param id      string   unique zone identifier
---@param coords  vector3
---@param size    vector3  { x, y, z }
---@param options table    { label, icon, distance, onSelect, canInteract, rotation? }
function TargetSystem.AddBoxZone(id, coords, size, options)
    if not _available then return end
    if Config.Debug then
        local lbl = _cleanLabel(options.label or (options[1] and options[1].label) or "?")
        print(("[TargetSystem] ^2AddBoxZone^7 id=%s coords=%s label=%s"):format(id, tostring(coords), lbl))
    end

    if _type == "ox_target" then
        exports.ox_target:addBoxZone({
            coords   = coords,
            size     = size,
            rotation = options.rotation or 0.0,
            debug    = Config.Debug or false,
            options  = _buildOxOptions(options),
            name     = id,
        })
        _registered.zones[id] = true

    elseif _type == "qb-target" then
        exports["qb-target"]:AddBoxZone(
            id,
            coords,
            size.x or 1.0,
            size.y or 1.0,
            {
                name    = id,
                heading = options.rotation or 0.0,
                debugPoly = Config.Debug or false,
                minZ    = coords.z - (size.z or 1.0),
                maxZ    = coords.z + (size.z or 1.0),
            },
            _buildQbOptions(options)
        )
        _registered.zones[id] = true
    end
end

---@param id string
function TargetSystem.RemoveBoxZone(id)
    if not _registered.zones[id] then return end

    if _type == "ox_target" then
        exports.ox_target:removeZone(id)

    elseif _type == "qb-target" then
        exports["qb-target"]:RemoveZone(id)
    end

    _registered.zones[id] = nil
end

-- ──────────────────────────────────────────────────────────
--  Sphere zone targets (NEW)
-- ──────────────────────────────────────────────────────────

---@param id      string   unique zone identifier
---@param coords  vector3  center of the sphere
---@param radius  number   radius in metres
---@param options table    { label, icon, distance, onSelect, canInteract, useZ? }
function TargetSystem.AddSphereZone(id, coords, radius, options)
    if not _available then return end
    if Config.Debug then
        local lbl = _cleanLabel(options.label or (options[1] and options[1].label) or "?")
        print(("[TargetSystem] ^2AddSphereZone^7 id=%s radius=%.1f label=%s"):format(id, radius, lbl))
    end

    if _type == "ox_target" then
        exports.ox_target:addSphereZone({
            coords   = coords,
            radius   = radius,
            debug    = Config.Debug or false,
            options  = _buildOxOptions(options),
            name     = id,
        })
        _registered.zones[id] = true

    elseif _type == "qb-target" then
        exports["qb-target"]:AddCircleZone(
            id,
            coords,
            radius,
            {
                name      = id,
                useZ      = options.useZ ~= false,
                debugPoly = Config.Debug or false,
            },
            _buildQbOptions(options)
        )
        _registered.zones[id] = true
    end
end

---@param id string
function TargetSystem.RemoveSphereZone(id)
    TargetSystem.RemoveBoxZone(id)
end

-- ──────────────────────────────────────────────────────────
--  Model targets (NEW) - target all instances of a model
-- ──────────────────────────────────────────────────────────

---@param id      string            unique registration identifier
---@param models  string|string[]   model name(s): "prop_rock_4_a" or { "prop_rock_4_a", "prop_rock_4_b" }
---@param options table             { name?, label, icon, distance, onSelect, canInteract }
function TargetSystem.AddModelTarget(id, models, options)
    if not _available then return end
    if Config.Debug then
        local lbl = _cleanLabel(options.name or options.label or "?")
        print(("[TargetSystem] ^2AddModelTarget^7 id=%s models=%s label=%s"):format(id, tostring(models), lbl))
    end

    if type(models) == "string" or type(models) == "number" then
        models = { models }
    end

    local optionName = options.name or options.label or "Interact"

    if _type == "ox_target" then
        exports.ox_target:addModel(models, _buildOxOptions(options))
        _registered.models[id] = { models = models, optionName = optionName }

    elseif _type == "qb-target" then
        exports["qb-target"]:AddTargetModel(models, _buildQbOptions(options))
        _registered.models[id] = { models = models, label = optionName }
    end
end

---@param id string
function TargetSystem.RemoveModelTarget(id)
    if not _registered.models[id] then return end

    local entry = _registered.models[id]

    if _type == "ox_target" then
        exports.ox_target:removeModel(entry.models, entry.optionName)

    elseif _type == "qb-target" then
        exports["qb-target"]:RemoveTargetModel(entry.models, entry.label)
    end

    _registered.models[id] = nil
end

-- ──────────────────────────────────────────────────────────
--  Bone targets (NEW) - target specific vehicle/ped bones
-- ──────────────────────────────────────────────────────────

---@param id      string            unique registration identifier
---@param bones   string|string[]   bone name(s): "boot", "bonnet", etc.
---@param options table             { name?, label, icon, distance, onSelect, canInteract }
function TargetSystem.AddBoneTarget(id, bones, options)
    if not _available then return end

    if type(bones) == "string" then bones = { bones } end

    local optionName = options.name or options.label or "Interact"

    if _type == "ox_target" then
        local oxOpts = _buildOxOptions(options)
        for _, opt in ipairs(oxOpts) do
            opt.bones = bones
        end
        exports.ox_target:addGlobalVehicle(oxOpts)
        _registered.bones[id] = { bones = bones, optionName = optionName }

    elseif _type == "qb-target" then
        exports["qb-target"]:AddTargetBone(bones, _buildQbOptions(options))
        _registered.bones[id] = { bones = bones, label = optionName }
    end
end

---@param id string
function TargetSystem.RemoveBoneTarget(id)
    if not _registered.bones[id] then return end

    local entry = _registered.bones[id]

    if _type == "ox_target" then
        exports.ox_target:removeGlobalVehicle(entry.optionName)

    elseif _type == "qb-target" then
        exports["qb-target"]:RemoveTargetBone(entry.bones)
    end

    _registered.bones[id] = nil
end

-- ──────────────────────────────────────────────────────────
--  Scoped target registry (NEW)
--  Creates a scope that tracks all targets registered through
--  it and provides a single Cleanup() call to remove them all.
-- ──────────────────────────────────────────────────────────

---@param scopeId string  unique scope identifier (typically jobId)
---@return table scope    { AddEntityTarget, AddBoxZone, AddSphereZone, AddModelTarget, Cleanup }
function TargetSystem.CreateScope(scopeId)
    local scope = {
        _entities = {},  -- [entity] = true
        _zones    = {},  -- [id] = true
        _models   = {},  -- [id] = true
        _bones    = {},  -- [id] = true
        _id       = scopeId,
    }

    function scope.AddEntityTarget(entity, options)
        TargetSystem.AddEntityTarget(entity, options)
        scope._entities[entity] = true
    end

    function scope.RemoveEntityTarget(entity, optionNames)
        TargetSystem.RemoveEntityTarget(entity, optionNames)
        if not optionNames then
            scope._entities[entity] = nil
        end
    end

    function scope.AddBoxZone(id, coords, size, options)
        local zoneId = scopeId .. "_" .. id
        TargetSystem.AddBoxZone(zoneId, coords, size, options)
        scope._zones[zoneId] = true
    end

    function scope.RemoveBoxZone(id)
        local zoneId = scopeId .. "_" .. id
        TargetSystem.RemoveBoxZone(zoneId)
        scope._zones[zoneId] = nil
    end

    function scope.AddSphereZone(id, coords, radius, options)
        local zoneId = scopeId .. "_" .. id
        TargetSystem.AddSphereZone(zoneId, coords, radius, options)
        scope._zones[zoneId] = true
    end

    function scope.RemoveSphereZone(id)
        local zoneId = scopeId .. "_" .. id
        TargetSystem.RemoveSphereZone(zoneId)
        scope._zones[zoneId] = nil
    end

    function scope.AddModelTarget(id, models, options)
        local modelId = scopeId .. "_" .. id
        TargetSystem.AddModelTarget(modelId, models, options)
        scope._models[modelId] = true
    end

    function scope.RemoveModelTarget(id)
        local modelId = scopeId .. "_" .. id
        TargetSystem.RemoveModelTarget(modelId)
        scope._models[modelId] = nil
    end

    function scope.AddBoneTarget(id, bones, options)
        local boneId = scopeId .. "_" .. id
        TargetSystem.AddBoneTarget(boneId, bones, options)
        scope._bones[boneId] = true
    end

    function scope.RemoveBoneTarget(id)
        local boneId = scopeId .. "_" .. id
        TargetSystem.RemoveBoneTarget(boneId)
        scope._bones[boneId] = nil
    end

    function scope.Cleanup()
        for entity in pairs(scope._entities) do
            TargetSystem.RemoveEntityTarget(entity)
        end
        for zoneId in pairs(scope._zones) do
            TargetSystem.RemoveBoxZone(zoneId)
        end
        for modelId in pairs(scope._models) do
            TargetSystem.RemoveModelTarget(modelId)
        end
        for boneId in pairs(scope._bones) do
            TargetSystem.RemoveBoneTarget(boneId)
        end
        scope._entities = {}
        scope._zones    = {}
        scope._models   = {}
        scope._bones    = {}
    end

    return scope
end

-- ──────────────────────────────────────────────────────────
--  Resource cleanup
-- ──────────────────────────────────────────────────────────

local function _cleanupAll()
    if not _available then return end

    for entity in pairs(_registered.entities) do
        TargetSystem.RemoveEntityTarget(entity)
    end

    for id in pairs(_registered.zones) do
        if _type == "ox_target" then
            exports.ox_target:removeZone(id)
        elseif _type == "qb-target" then
            exports["qb-target"]:RemoveZone(id)
        end
    end

    for id in pairs(_registered.models) do
        TargetSystem.RemoveModelTarget(id)
    end

    for id in pairs(_registered.bones) do
        TargetSystem.RemoveBoneTarget(id)
    end

    _registered.entities = {}
    _registered.zones    = {}
    _registered.models   = {}
    _registered.bones    = {}
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        _cleanupAll()
    end
end)

-- ──────────────────────────────────────────────────────────
--  Auto-initialise once the resource boots
-- ──────────────────────────────────────────────────────────

CreateThread(function()
    Wait(500)
    TargetSystem.Init()
end)
