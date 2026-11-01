---@diagnostic disable: duplicate-set-field
if Sky.Config.target ~= "tgiann" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "tgiann-target"

function Sky.Target.AddLocalEntity(entity, options)
    exports[RESOURCE]:addLocalEntity(entity, options)
end

function Sky.Target.RemoveLocalEntity(entity, option_names)
    exports[RESOURCE]:removeLocalEntity(entity, option_names)
end

function Sky.Target.AddSphereZone(params)
    return exports[RESOURCE]:addSphereZone({
        coords = params.coords,
        radius = params.radius,
        debug = params.debug == true,
        drawSprite = params.drawSprite == true,
        options = params.options,
    })
end

function Sky.Target.RemoveZone(handle)
    exports[RESOURCE]:removeZone(handle)
end

function Sky.Target.AddGlobalPlayer(options)
    exports[RESOURCE]:addGlobalPlayer(options)
end

function Sky.Target.RemoveGlobalPlayer(option_names)
    exports[RESOURCE]:removeGlobalPlayer(option_names)
end

function Sky.Target.AddGlobalVehicle(options)
    exports[RESOURCE]:addGlobalVehicle(options)
end

function Sky.Target.RemoveGlobalVehicle(option_names)
    exports[RESOURCE]:removeGlobalVehicle(option_names)
end

function Sky.Target.AddModel(models, options)
    exports[RESOURCE]:addModel(models, options)
end

function Sky.Target.RemoveModel(models, option_names)
    exports[RESOURCE]:removeModel(models, option_names)
end

Sky.Target.AddVehicleModel = Sky.Target.AddModel
Sky.Target.RemoveVehicleModel = Sky.Target.RemoveModel

function Sky.Target.AddGlobalOption(options)
    exports[RESOURCE]:addGlobalOption(options)
end

function Sky.Target.RemoveGlobalOption(option_names)
    exports[RESOURCE]:removeGlobalOption(option_names)
end
