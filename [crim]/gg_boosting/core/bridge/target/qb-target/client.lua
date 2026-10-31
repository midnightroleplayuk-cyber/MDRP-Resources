gg.target = gg.target or {}

local utility = require("utility")
local activeTargets = {}

local function resourceStopped(resource)
    for _, target in pairs(activeTargets) do
        if target.invokingResource == resource then 
            local optionNames = {}
            if target.options and target.options.options then
                for _, option in ipairs(target.options.options) do
                    optionNames[#optionNames + 1] = option.label
                end
            end
            
            if target.type == 'zone' then
                exports["qb-target"]:RemoveZone(target.id)
                activeTargets[_] = {}
                
            elseif target.type == 'entity' then
                if DoesEntityExist(target.entity) then 
                    exports['qb-target']:RemoveTargetEntity(target.entity)
                end
                activeTargets[_] = {}

            elseif target.type == 'globalPed' then
                exports['qb-target']:RemoveGlobalType(1, optionNames)
                activeTargets[_] = {}

            elseif target.type == 'globalObject' then
                exports['qb-target']:RemoveGlobalType(3, optionNames)
                activeTargets[_] = {}
            elseif target.type == 'GlobalVehicle' then
                exports['qb-target']:RemoveGlobalVehicle(optionNames)
                activeTargets[_] = {}
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    resourceStopped(resource)
end)

gg.target.AddTargetEntity = function(entity, parameters)
    exports["qb-target"]:AddTargetEntity(entity, parameters)
    local resource = GetInvokingResource()
    activeTargets[entity] = {
        entity = entity,
        type = 'entity',
        invokingResource = resource
    }
end

gg.target.removeTargetEntity = function(entity)
    exports['qb-target']:RemoveTargetEntity(entity)
end

gg.target.AddBoxZone = function(name, coords, size, parameters)
    exports["qb-target"]:AddBoxZone(name, coords, size.x, size.y, {
        name = name,
        debugPoly = utility.debugMode,
        minZ = coords.z - 1,
        maxZ = coords.z + 1,
        heading = coords.w
    }, parameters)
    
    local resource = GetInvokingResource()
    activeTargets[name] = {
        id = name,
        type = 'zone',
        invokingResource = resource
    }
end

gg.target.RemoveZone = function(zone)
    exports["qb-target"]:RemoveZone(zone)
    activeTargets[zone] = {}
end

gg.target.addGlobalPed = function(name, options)
    exports['qb-target']:AddGlobalPed(options)
    
    local resource = GetInvokingResource()
    activeTargets[name] = {
        id = name,
        type = 'globalPed',
        options = options,
        invokingResource = resource
    }
end

gg.target.removeGlobalPed = function(name, options)
    exports['qb-target']:RemoveGlobalType(1, options)
    activeTargets[name] = {}
end


gg.target.addGlobalVehicle = function(id, data)
    exports['qb-target']:AddGlobalVehicle({options = data.options, distance = 2.5})
    local resource = GetInvokingResource()
    activeTargets[id] = {
        id = id,
        type = 'globalVehicle',
        options = data.options,
        invokingResource = resource
    }
end

gg.target.removeGlobalVehicle = function(id)
    exports['qb-target']:RemoveGlobalVehicle(id)
end

gg.target.addGlobalObject = function(data)
    exports['qb-target']:AddGlobalObject({options = data.options, distance = 2.5})
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
    exports['qb-target']:RemoveGlobalVehicle(data.options[1].name)
end


gg.target.addModel = function(models, parameters)
    exports['qb-target']:AddTargetModel(models, parameters)
end

gg.target.removeModel = function(models, targetName)
    exports['qb-target']:RemoveTargetModel(models, targetName)
end