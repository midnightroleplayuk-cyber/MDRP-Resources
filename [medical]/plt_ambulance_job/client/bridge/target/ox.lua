if Bridge.Target ~= 'ox_target' then return end

Target = Target or {}
Target.Resource = 'ox_target'

local function WithDistance(options, distance)
    if distance then
        for _, option in ipairs(options or {}) do
            if option.distance == nil then option.distance = distance end
        end
    end
    return options
end

function Target.AddLocalEntity(entity, options, distance)
    if not DoesEntityExist(entity) then return end
    exports.ox_target:addLocalEntity(entity, WithDistance(options, distance))
    return entity
end

function Target.AddModel(models, options, distance)
    exports.ox_target:addModel(models, WithDistance(options, distance))
end

function Target.AddSphereZone(data)
    return exports.ox_target:addSphereZone({
        coords = data.coords,
        radius = data.radius,
        debug = data.debug,
        options = WithDistance(data.options, data.distance)
    })
end

function Target.AddBoxZone(data)
    return exports.ox_target:addBoxZone({
        coords = data.coords,
        size = data.size,
        rotation = data.rotation or data.heading or 0.0,
        debug = data.debug,
        options = WithDistance(data.options, data.distance)
    })
end

function Target.AddGlobalPlayer(options, distance)
    exports.ox_target:addGlobalPlayer(WithDistance(options, distance))
end

function Target.AddGlobalVehicle(options, distance)
    exports.ox_target:addGlobalVehicle(WithDistance(options, distance))
end

function Target.RemoveZone(id)
    if id ~= nil then exports.ox_target:removeZone(id) end
end

function Target.RemoveLocalEntity(entity, names)
    if DoesEntityExist(entity) then exports.ox_target:removeLocalEntity(entity, names) end
end
