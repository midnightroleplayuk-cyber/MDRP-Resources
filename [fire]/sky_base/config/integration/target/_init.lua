if IsDuplicityVersion() then return end

Sky.Target = Sky.Target or {}

function Sky.Target.IsEnabled()
    return Sky.Config.target == "custom"
        or Sky.Config.target == "ox" and GetResourceState("ox_target") == "started"
        or Sky.Config.target == "qb" and GetResourceState("qb-target") == "started"
        or Sky.Config.target == "tgiann" and GetResourceState("tgiann-target") == "started"
        or Sky.Config.target == "vivum" and GetResourceState("vivum-target") == "started"
end

local function noop() end

Sky.Target.AddLocalEntity     = Sky.Target.AddLocalEntity     or noop
Sky.Target.RemoveLocalEntity  = Sky.Target.RemoveLocalEntity  or noop
Sky.Target.AddSphereZone      = Sky.Target.AddSphereZone      or function() return nil end
Sky.Target.RemoveZone         = Sky.Target.RemoveZone         or noop
Sky.Target.AddGlobalPlayer    = Sky.Target.AddGlobalPlayer    or noop
Sky.Target.RemoveGlobalPlayer = Sky.Target.RemoveGlobalPlayer or noop
Sky.Target.AddGlobalVehicle   = Sky.Target.AddGlobalVehicle   or noop
Sky.Target.RemoveGlobalVehicle = Sky.Target.RemoveGlobalVehicle or noop
Sky.Target.AddModel           = Sky.Target.AddModel           or noop
Sky.Target.RemoveModel        = Sky.Target.RemoveModel        or noop
Sky.Target.AddVehicleModel    = Sky.Target.AddVehicleModel    or noop
Sky.Target.RemoveVehicleModel = Sky.Target.RemoveVehicleModel or noop
Sky.Target.AddGlobalOption    = Sky.Target.AddGlobalOption    or noop
Sky.Target.RemoveGlobalOption = Sky.Target.RemoveGlobalOption or noop
