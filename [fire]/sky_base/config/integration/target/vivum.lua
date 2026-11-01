---@diagnostic disable: duplicate-set-field
if Sky.Config.target ~= "vivum" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "vivum-target"
local local_entity_targets = {}
local global_player_target
local global_vehicle_target
local model_targets = {}
local global_option_target

local function map_options(options)
    local mapped = {}

    for index, option in ipairs(options) do
        local option_name = option.name or option.label
        if not option_name or not option.label then
            error("Vivum target options require both a label and a name or label fallback")
        end

        local on_select = option.onSelect
        local can_interact = option.canInteract
        mapped[index] = {
            name = option_name,
            label = option.label,
            icon = option.icon,
            style = option.style,
            bone = option.bones or option.bone,
            offset = option.offsetAbsolute and { relative = option.offsetAbsolute } or nil,
            allowEntityHovering = option.allowEntityHovering == true,
            distance = tonumber(option.distance),
            action = on_select and function(_, _, _, coords, distance, entity)
                return on_select({
                    entity = entity,
                    coords = coords,
                    distance = distance,
                    name = option_name,
                })
            end or nil,
            canInteract = can_interact and function(entity, coords, distance, name, bone)
                return can_interact(entity, distance, coords, name or option_name, bone) and true or false
            end or nil,
        }
    end

    return mapped
end

local function max_distance(items)
    local distance = 0
    for _, item in ipairs(items) do
        local item_distance = tonumber(item.distance) or 0
        if item_distance > distance then
            distance = item_distance
        end
    end
    return distance > 0 and distance or 2.5
end

local function record_items(record)
    local items = {}
    for _, name in ipairs(record.order) do
        items[#items + 1] = record.items[name]
    end
    return items
end

local function create_target(target, items)
    local id = exports[RESOURCE]:AddTarget({
        target = target,
        items = items,
        icon = items[1] and items[1].icon or nil,
        distance = max_distance(items),
    })
    if not id then
        error("Vivum target failed to create a target menu")
    end
    return id
end

local function upsert_target(record, target, options)
    record = record or {
        items = {},
        order = {},
    }

    for _, item in ipairs(map_options(options)) do
        if not record.items[item.name] then
            record.order[#record.order + 1] = item.name
        end
        record.items[item.name] = item
    end

    local items = record_items(record)
    if record.id then
        local updated = exports[RESOURCE]:UpdateTarget(record.id, {
            items = items,
            icon = items[1] and items[1].icon or nil,
            distance = max_distance(items),
        })
        if not updated then
            error("Vivum target failed to update target " .. tostring(record.id))
        end
    else
        record.id = create_target(target, items)
    end

    return record
end

local function names_lookup(option_names)
    local names = {}
    if type(option_names) == "string" then
        names[option_names] = true
    elseif type(option_names) == "table" then
        for _, name in ipairs(option_names) do
            names[name] = true
        end
    end
    return names
end

local function normalize_models(models)
    if type(models) == "table" then
        return models
    end
    return { models }
end

local function remove_options(record, option_names)
    if not record then return nil end

    local requested = names_lookup(option_names)
    local removed = {}
    local remaining_order = {}

    for _, name in ipairs(record.order) do
        if requested[name] then
            removed[#removed + 1] = name
            record.items[name] = nil
        else
            remaining_order[#remaining_order + 1] = name
        end
    end

    if #removed == 0 then return record end

    record.order = remaining_order
    if #remaining_order == 0 then
        exports[RESOURCE]:RemoveTarget(record.id)
        return nil
    end

    exports[RESOURCE]:RemoveNames(record.id, removed)
    local items = record_items(record)
    local updated = exports[RESOURCE]:UpdateTarget(record.id, {
        icon = items[1] and items[1].icon or nil,
        distance = max_distance(items),
    })
    if not updated then
        error("Vivum target failed to update target " .. tostring(record.id) .. " after removing options")
    end
    return record
end

function Sky.Target.AddLocalEntity(entity, options)
    local_entity_targets[entity] = upsert_target(
        local_entity_targets[entity],
        { entity = { handle = entity } },
        options
    )
end

function Sky.Target.RemoveLocalEntity(entity, option_names)
    local_entity_targets[entity] = remove_options(local_entity_targets[entity], option_names)
end

function Sky.Target.AddSphereZone(params)
    local items = map_options(params.options)
    return create_target({ position = params.coords }, items)
end

function Sky.Target.RemoveZone(handle)
    exports[RESOURCE]:RemoveTarget(handle)
end

function Sky.Target.AddGlobalPlayer(options)
    global_player_target = upsert_target(
        global_player_target,
        { global = { type = "player" } },
        options
    )
end

function Sky.Target.RemoveGlobalPlayer(option_names)
    global_player_target = remove_options(global_player_target, option_names)
end

function Sky.Target.AddGlobalVehicle(options)
    global_vehicle_target = upsert_target(
        global_vehicle_target,
        { global = { type = "vehicle", preserveLastEntity = true } },
        options
    )
end

function Sky.Target.RemoveGlobalVehicle(option_names)
    global_vehicle_target = remove_options(global_vehicle_target, option_names)
end

function Sky.Target.AddModel(models, options)
    for _, model in ipairs(normalize_models(models)) do
        model_targets[model] = upsert_target(
            model_targets[model],
            { global = { type = "all", model = model, preserveLastEntity = true } },
            options
        )
    end
end

function Sky.Target.RemoveModel(models, option_names)
    for _, model in ipairs(normalize_models(models)) do
        model_targets[model] = remove_options(model_targets[model], option_names)
    end
end

Sky.Target.AddVehicleModel = Sky.Target.AddModel
Sky.Target.RemoveVehicleModel = Sky.Target.RemoveModel

function Sky.Target.AddGlobalOption(options)
    global_option_target = upsert_target(
        global_option_target,
        { global = { type = "all" } },
        options
    )
end

function Sky.Target.RemoveGlobalOption(option_names)
    global_option_target = remove_options(global_option_target, option_names)
end
