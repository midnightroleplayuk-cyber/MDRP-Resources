---@diagnostic disable: duplicate-set-field
if Sky.Config.target ~= "qb" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "qb-target"

local zone_counter = 0
local local_entity_labels = {}
local global_player_labels = {}
local global_vehicle_labels = {}
local global_vehicle_bones = {}
local model_labels = {}
local global_option_labels = {}

local function max_distance(options, fallback)
    local m = 0
    for _, opt in ipairs(options) do
        local d = tonumber(opt.distance) or 0
        if d > m then m = d end
    end
    if m <= 0 then return fallback or 2.5 end
    return m
end

local function map_options(options, target_bone)
    local mapped = {}
    for i, opt in ipairs(options) do
        local onSelect = opt.onSelect
        local canInteract = opt.canInteract
        mapped[i] = {
            type = "client",
            icon = opt.icon,
            label = opt.label,
            action = onSelect and function(entity)
                onSelect({ entity = entity, name = opt.name, bone = target_bone })
            end or nil,
            canInteract = canInteract and function(entity, distance)
                return canInteract(entity, distance, nil, opt.name, target_bone) and true or false
            end or nil,
            job = opt.job,
            gang = opt.gang,
            item = opt.item,
        }
    end
    return mapped
end

local function remember_labels(store, options)
    for _, opt in ipairs(options) do
        if opt.name and opt.label then
            store[opt.name] = opt.label
        end
    end
end

local function resolve_labels(store, names)
    local labels = {}
    if type(names) == "string" then
        local label = store[names]
        if label then labels[#labels + 1] = label end
        store[names] = nil
    elseif type(names) == "table" then
        for _, name in ipairs(names) do
            local label = store[name]
            if label then labels[#labels + 1] = label end
            store[name] = nil
        end
    end
    return labels
end

local function normalize_models(models)
    if type(models) == "table" then
        return models
    end
    return { models }
end

function Sky.Target.AddLocalEntity(entity, options)
    if not entity or not options or #options == 0 then return end
    local_entity_labels[entity] = local_entity_labels[entity] or {}
    remember_labels(local_entity_labels[entity], options)
    exports[RESOURCE]:AddTargetEntity(entity, {
        options = map_options(options),
        distance = max_distance(options),
    })
end

function Sky.Target.RemoveLocalEntity(entity, option_names)
    if not entity then return end
    local store = local_entity_labels[entity]
    if not store then return end
    local labels = resolve_labels(store, option_names)
    if #labels == 0 then return end
    exports[RESOURCE]:RemoveTargetEntity(entity, labels)
    if not next(store) then
        local_entity_labels[entity] = nil
    end
end

function Sky.Target.AddSphereZone(params)
    if not params or not params.coords or not params.options then return nil end
    zone_counter = zone_counter + 1
    local name = ("sky_zone_%d"):format(zone_counter)
    exports[RESOURCE]:AddCircleZone(
        name,
        params.coords,
        params.radius or 1.5,
        { name = name, useZ = true, debugPoly = params.debug == true },
        { options = map_options(params.options), distance = max_distance(params.options, params.radius or 1.5) }
    )
    return name
end

function Sky.Target.RemoveZone(handle)
    if not handle then return end
    exports[RESOURCE]:RemoveZone(handle)
end

function Sky.Target.AddGlobalPlayer(options)
    if not options or #options == 0 then return end
    remember_labels(global_player_labels, options)
    exports[RESOURCE]:AddGlobalPlayer({
        options = map_options(options),
        distance = max_distance(options),
    })
end

function Sky.Target.RemoveGlobalPlayer(option_names)
    local labels = resolve_labels(global_player_labels, option_names)
    if #labels == 0 then return end
    exports[RESOURCE]:RemoveGlobalPlayer(labels)
end

function Sky.Target.AddGlobalVehicle(options)
    if not options or #options == 0 then return end

    local globalOptions = {}
    for _, option in ipairs(options) do
        local bones = type(option.bones) == "string" and { option.bones } or option.bones
        if type(bones) == "table" and #bones > 0 then
            global_vehicle_labels[option.name] = option.label
            global_vehicle_bones[option.name] = bones
            for _, boneName in ipairs(bones) do
                local target_bone = boneName
                exports[RESOURCE]:AddTargetBone(target_bone, {
                    options = map_options({ option }, target_bone),
                    distance = tonumber(option.distance) or 2.5,
                })
            end
        else
            globalOptions[#globalOptions + 1] = option
        end
    end

    if #globalOptions > 0 then
        remember_labels(global_vehicle_labels, globalOptions)
        exports[RESOURCE]:AddGlobalVehicle({
            options = map_options(globalOptions),
            distance = max_distance(globalOptions),
        })
    end
end

function Sky.Target.RemoveGlobalVehicle(option_names)
    local names = type(option_names) == "table" and option_names or { option_names }
    local globalLabels = {}

    for _, optionName in ipairs(names) do
        local label = global_vehicle_labels[optionName]
        local bones = global_vehicle_bones[optionName]
        if label and bones then
            exports[RESOURCE]:RemoveTargetBone(bones, label)
        elseif label then
            globalLabels[#globalLabels + 1] = label
        end
        global_vehicle_labels[optionName] = nil
        global_vehicle_bones[optionName] = nil
    end

    if #globalLabels > 0 then
        exports[RESOURCE]:RemoveGlobalVehicle(globalLabels)
    end
end

function Sky.Target.AddModel(models, options)
    if not models or not options or #options == 0 then return end

    local normalized_models = normalize_models(models)
    if #normalized_models == 0 then return end

    for _, model in ipairs(normalized_models) do
        model_labels[model] = model_labels[model] or {}
        remember_labels(model_labels[model], options)
    end

    exports[RESOURCE]:AddTargetModel(models, {
        options = map_options(options),
        distance = max_distance(options),
    })
end

function Sky.Target.RemoveModel(models, option_names)
    if not models then return end

    for _, model in ipairs(normalize_models(models)) do
        local labels = model_labels[model]
        if labels then
            local resolved_labels = resolve_labels(labels, option_names)
            if #resolved_labels > 0 then
                exports[RESOURCE]:RemoveTargetModel(model, resolved_labels)
            end
            if not next(labels) then
                model_labels[model] = nil
            end
        end
    end
end

Sky.Target.AddVehicleModel = Sky.Target.AddModel
Sky.Target.RemoveVehicleModel = Sky.Target.RemoveModel

function Sky.Target.AddGlobalOption(options)
    if not options or #options == 0 then return end
    remember_labels(global_option_labels, options)
    local payload = { options = map_options(options), distance = max_distance(options) }
    exports[RESOURCE]:AddGlobalPed(payload)
    exports[RESOURCE]:AddGlobalVehicle(payload)
    exports[RESOURCE]:AddGlobalObject(payload)
    exports[RESOURCE]:AddGlobalPlayer(payload)
end

function Sky.Target.RemoveGlobalOption(option_names)
    local labels = resolve_labels(global_option_labels, option_names)
    if #labels == 0 then return end
    exports[RESOURCE]:RemoveGlobalPed(labels)
    exports[RESOURCE]:RemoveGlobalVehicle(labels)
    exports[RESOURCE]:RemoveGlobalObject(labels)
    exports[RESOURCE]:RemoveGlobalPlayer(labels)
end
