gg.target = gg.target or {}


local utility = require("utility")
local activeTargets = {}

local function convert(options)
    local distance = options.distance
    options = options.options
    for _, v in pairs(options) do
        v.onSelect = v.action
        v.distance = v.distance or distance
        v.name = v.name or v.label
        v.groups = v.job or v.gang
        v.type = nil
        v.action = nil

        v.job = nil
        v.gang = nil
        v.qtarget = true
    end

    return options
end

local function resourceStopped(resource)
    for _, target in pairs(activeTargets) do
        if target.invokingResource == resource then

            if target.options then  
                local optionNames = {}
                for _, option in ipairs(target.options) do
                    optionNames[#optionNames + 1] = option.name
                end
            end

            if target.type == 'zone' then
                exports.ox_target:removeZone(target.id)
                activeTargets[_] = {}

            elseif target.type == 'entity' then
                if DoesEntityExist(target.entity) then 
                    exports.ox_target:removeLocalEntity(target.entity)
                end
                activeTargets[_] = {}

            elseif target.type == 'globalPed' then
                exports.ox_target:removeGlobalPed(optionNames)
                activeTargets[_] = {}
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    resourceStopped(resource)
end)

gg.target.AddTargetEntity = function(entity, parameters)
    if not NetworkGetEntityIsNetworked(entity) then
        exports.ox_target:addLocalEntity(entity, convert(parameters))
    else
        local net = NetworkGetNetworkIdFromEntity(entity)
        exports.ox_target:addEntity(net, convert(parameters))
    end

    local resource = GetInvokingResource()
    activeTargets[entity] = {
        entity = entity,
        type = 'entity',
        invokingResource = resource
    }
end

gg.target.removeTargetEntity = function(entity)
    if not NetworkGetEntityIsNetworked(entity) then
        exports.ox_target:removeLocalEntity(entity)
    else
        local net = NetworkGetNetworkIdFromEntity(entity)
        exports.ox_target:removeEntity(net)
    end
end

gg.target.AddBoxZone = function(name, coords, size, parameters)
    local resource = GetInvokingResource()
    local rotation = parameters.rotation
    local id = exports.ox_target:addBoxZone({
        coords = coords,
        size = size,
        rotation = rotation,
        debug = utility.debugMode,
        options = convert(parameters)
    })
    activeTargets[name] = {
        id = id,
        type = 'zone',
        invokingResource = resource
    }
end

gg.target.RemoveZone = function(zone)
    if not zone or not activeTargets[zone] or not activeTargets[zone].id then return end
    exports.ox_target:removeZone(activeTargets[zone].id)
    activeTargets[zone] = {}
end

gg.target.addGlobalPed = function(name, options)
    exports.ox_target:addGlobalPed(convert(options))
    local resource = GetInvokingResource()
    activeTargets[name] = {
        id = name,
        type = 'globalPed',
        options = convert(options),
        invokingResource = resource
    }
end

gg.target.addGlobalVehicle = function(name, options)
    exports.ox_target:addGlobalVehicle(convert(options))
    local resource = GetInvokingResource()
    activeTargets[name] = {
        id = name,
        type = 'globalVehicle',
        options = convert(options),
        invokingResource = resource
    }
end

gg.target.removeGlobalVehicle = function(data)
    exports.ox_target:removeGlobalVehicle(data)
end

gg.target.addGlobalObject = function(data)
    exports.ox_target:addGlobalObject(convert(data))
    local name = data.options[1].name
    local resource = GetInvokingResource()
    activeTargets[name] = {
        id = name,
        type = 'GlobalObject',
        options = data.options,
        invokingResource = resource
    }
end

gg.target.removeGlobalObject = function(data)
    exports.ox_target:removeGlobalObject(data.options[1].name)
end

gg.target.addModel = function(models, parameters)
    exports.ox_target:addModel(models, convert(parameters))
end

gg.target.removeModel = function(models, targetName)
    exports.ox_target:removeModel(models, targetName)
end