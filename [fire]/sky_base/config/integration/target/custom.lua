---@diagnostic disable: duplicate-set-field
-- Set Config.target = "custom" to enable this client-side template.
if Sky.Config.target ~= "custom" then return end
if IsDuplicityVersion() then return end

function Sky.Target.AddLocalEntity(entity, options)
    error("Custom target integration: AddLocalEntity is not implemented")
end

function Sky.Target.RemoveLocalEntity(entity, option_names)
    error("Custom target integration: RemoveLocalEntity is not implemented")
end

function Sky.Target.AddSphereZone(params)
    -- Return the provider's zone handle.
    error("Custom target integration: AddSphereZone is not implemented")
end

function Sky.Target.RemoveZone(handle)
    error("Custom target integration: RemoveZone is not implemented")
end

function Sky.Target.AddGlobalPlayer(options)
    error("Custom target integration: AddGlobalPlayer is not implemented")
end

function Sky.Target.RemoveGlobalPlayer(option_names)
    error("Custom target integration: RemoveGlobalPlayer is not implemented")
end

function Sky.Target.AddGlobalVehicle(options)
    error("Custom target integration: AddGlobalVehicle is not implemented")
end

function Sky.Target.RemoveGlobalVehicle(option_names)
    error("Custom target integration: RemoveGlobalVehicle is not implemented")
end

function Sky.Target.AddModel(models, options)
    error("Custom target integration: AddModel is not implemented")
end

function Sky.Target.RemoveModel(models, option_names)
    error("Custom target integration: RemoveModel is not implemented")
end

Sky.Target.AddVehicleModel = Sky.Target.AddModel
Sky.Target.RemoveVehicleModel = Sky.Target.RemoveModel

function Sky.Target.AddGlobalOption(options)
    error("Custom target integration: AddGlobalOption is not implemented")
end

function Sky.Target.RemoveGlobalOption(option_names)
    error("Custom target integration: RemoveGlobalOption is not implemented")
end
