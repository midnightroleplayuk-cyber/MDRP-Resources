local insideZone = false
local activeZone = nil
local lastCleanup = 0

local function distance2D(ax, ay, bx, by)
    local dx = ax - bx
    local dy = ay - by
    return math.sqrt((dx * dx) + (dy * dy))
end

local function pointInSphere(point, zone)
    return distance2D(point.x, point.y, zone.coords.x, zone.coords.y) <= zone.radius
end

local function pointInBox(point, zone)
    local dx = point.x - zone.coords.x
    local dy = point.y - zone.coords.y
    local dz = point.z - zone.coords.z

    local heading = math.rad(zone.heading or 0.0)
    local cosH = math.cos(heading)
    local sinH = math.sin(heading)

    -- Rotate the point into the box's local coordinate space.
    local localX = dx * cosH + dy * sinH
    local localY = -dx * sinH + dy * cosH

    return math.abs(localX) <= (zone.size.x / 2.0)
       and math.abs(localY) <= (zone.size.y / 2.0)
       and math.abs(dz) <= (zone.size.z / 2.0)
end

local function pointInZone(point, zone)
    if zone.type == "box" then
        return pointInBox(point, zone)
    end

    return pointInSphere(point, zone)
end

local function getZoneAtCoords(coords)
    for _, zone in ipairs(Config.Zones) do
        if pointInZone(coords, zone) then
            return zone
        end
    end

    return nil
end

local function isProtectedModel(ped)
    local model = GetEntityModel(ped)

    for _, modelName in ipairs(Config.Settings.protectedModels or {}) do
        if model == joaat(modelName) then
            return true
        end
    end

    return false
end

local function shouldRemovePed(ped)
    if not DoesEntityExist(ped) then
        return false
    end

    if IsEntityDead(ped) then
        return false
    end

    -- Never remove players.
    if IsPedAPlayer(ped) then
        return false
    end

    -- Don't touch protected NPC models.
    if isProtectedModel(ped) then
        return false
    end

    -- Mission entities are commonly used by scripted resources.
    -- Leave them alone to reduce the chance of breaking job/interaction NPCs.
    if IsEntityAMissionEntity(ped) then
        return false
    end

    return true
end

local function removeAmbientPedsInZone(zone)
    if not Config.Settings.removeExistingPeds then
        return
    end

    local pool = GetGamePool("CPed")

    for i = 1, #pool do
        local ped = pool[i]

        if shouldRemovePed(ped) then
            local coords = GetEntityCoords(ped)

            if pointInZone(coords, zone) then
                SetEntityAsMissionEntity(ped, true, true)
                DeletePed(ped)
            end
        end
    end
end

local function applyPedBlock()
    if Config.Settings.blockAmbientPeds then
        SetPedDensityMultiplierThisFrame(0.0)
    end

    if Config.Settings.blockScenarioPeds then
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
    end
end

local function applyVehicleBlock()
    if not Config.Settings.blockAmbientVehicles then
        return
    end

    if activeZone and activeZone.blockVehicles then
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
    end
end

-- This is the strongest part of the resource:
-- populationPedCreating fires immediately before GTA creates an ambient
-- population ped, so we can cancel it before it exists.
AddEventHandler("populationPedCreating", function(x, y, z, model, setters)
    if not Config.Settings.blockAmbientPeds then
        return
    end

    local zone = getZoneAtCoords(vec3(x, y, z))

    if zone then
        CancelEvent()
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local zone = getZoneAtCoords(coords)

        activeZone = zone
        insideZone = zone ~= nil

        if insideZone then
            sleep = 0

            -- These need to run every frame.
            applyPedBlock()
            applyVehicleBlock()

            local now = GetGameTimer()

            if now - lastCleanup >= Config.Settings.cleanupInterval then
                lastCleanup = now
                removeAmbientPedsInZone(zone)
            end
        end

        Wait(sleep)
    end
end)

-- Debug drawing.
CreateThread(function()
    while true do
        if Config.Settings.debug then
            Wait(0)

            for _, zone in ipairs(Config.Zones) do
                if zone.type == "box" then
                    local size = zone.size
                    local heading = zone.heading or 0.0

                    DrawMarker(
                        1,
                        zone.coords.x,
                        zone.coords.y,
                        zone.coords.z,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, heading,
                        size.x,
                        size.y,
                        size.z,
                        255, 80, 80, 90,
                        false, false, 2, false, nil, nil, false
                    )
                else
                    DrawMarker(
                        1,
                        zone.coords.x,
                        zone.coords.y,
                        zone.coords.z - 1.0,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        zone.radius * 2.0,
                        zone.radius * 2.0,
                        2.0,
                        255, 80, 80, 90,
                        false, false, 2, false, nil, nil, false
                    )
                end
            end
        else
            Wait(500)
        end
    end
end)

RegisterCommand(Config.Settings.debugCommand, function()
    Config.Settings.debug = not Config.Settings.debug

    print(("[pedblock] Debug drawing %s."):format(
        Config.Settings.debug and "ENABLED" or "DISABLED"
    ))
end, false)


AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    -- Nothing persistent is changed by this resource.
    -- Density natives are frame-based, so they automatically stop applying.
end)
