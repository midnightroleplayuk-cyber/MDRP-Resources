-- Vehicles the script spawns for jobs (stolen cars, supply vans, lost shipments).
JobVehicles = {}

local function exists(veh) return veh and veh ~= 0 and DoesEntityExist(veh) end

---Spawns a vehicle that stays put until the script deletes it. Returns entity, netId (or nil if it failed).
function JobVehicles.Spawn(model, p, plate)
    local hash = type(model) == 'number' and model or GetHashKey(model)
    local veh = CreateVehicleServerSetter(hash, 'automobile', p.x, p.y, p.z, p.w or 0.0)
    local timeout = GetGameTimer() + 5000
    while not exists(veh) and GetGameTimer() < timeout do Wait(50) end
    if not exists(veh) then
        lib.print.warn(('Could not spawn vehicle "%s" at %.1f, %.1f. Check the model exists on your server.'):format(tostring(model), p.x, p.y))
        return nil
    end

    -- By default FiveM deletes server-spawned vehicles as soon as no player is near enough to see them,
    -- which is exactly where a job car waits. Keep it until we delete it ourselves.
    if SetEntityOrphanMode then SetEntityOrphanMode(veh, 2) end

    if plate then SetVehicleNumberPlateText(veh, plate) end
    SetVehicleDoorsLocked(veh, 1)
    return veh, NetworkGetNetworkIdFromEntity(veh)
end

---True only when the vehicle has really gone: deleted, or blown up.
---Its health is only known to the server while a player is near it, so an unattended car counts as fine.
function JobVehicles.Gone(veh)
    if not exists(veh) then return true end
    local owner = NetworkGetEntityOwner(veh)
    if not owner or owner <= 0 then return false end
    return GetVehicleEngineHealth(veh) <= -3900 -- an exploded vehicle's engine reads -4000
end

---0 to 1: how intact the vehicle is (1 when the server can't tell yet).
function JobVehicles.Condition(veh)
    if not exists(veh) then return 0 end
    local body, engine = GetVehicleBodyHealth(veh), GetVehicleEngineHealth(veh)
    if body <= 0 and engine <= 0 then return 1.0 end
    return math.max(0, math.min(1, (math.max(0, body) + math.max(0, engine)) / 2000))
end
