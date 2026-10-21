local zones = {}

local function insidePoly(x, y, corners)
    local inside = false
    local j = #corners
    for i = 1, #corners do
        local a, b = corners[i], corners[j]
        if ((a.y > y) ~= (b.y > y)) then
            local crossX = (b.x - a.x) * (y - a.y) / (b.y - a.y) + a.x
            if x < crossX then inside = not inside end
        end
        j = i
    end
    return inside
end

local function inZone(pos, zone)
    return pos.z >= zone.minZ and pos.z <= zone.maxZ
        and insidePoly(pos.x, pos.y, zone.corners)
end

local function nearZone(pos, zone)
    local cx = (zone.minX + zone.maxX) * 0.5
    local cy = (zone.minY + zone.maxY) * 0.5
    local dx, dy = pos.x - cx, pos.y - cy
    local radiusX = (zone.maxX - zone.minX) * 0.5
    local radiusY = (zone.maxY - zone.minY) * 0.5
    local limit = math.sqrt(radiusX * radiusX + radiusY * radiusY) + zone.activationDistance
    return dx * dx + dy * dy <= limit * limit
end

for _, zone in ipairs(Config.Zones) do
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    for _, c in ipairs(zone.corners) do
        minX = math.min(minX, c.x)
        minY = math.min(minY, c.y)
        maxX = math.max(maxX, c.x)
        maxY = math.max(maxY, c.y)
    end
    zone.minX, zone.minY, zone.maxX, zone.maxY = minX, minY, maxX, maxY
    zones[#zones + 1] = zone
end

local function applyRoads(enabled)
    for _, zone in ipairs(zones) do
        if zone.disableRoads then
            -- Native uses a rectangular volume; polygon cleanup below is precise.
            SetRoadsInArea(zone.minX, zone.minY, zone.minZ,
                zone.maxX, zone.maxY, zone.maxZ, enabled, false)
        end
    end
end

CreateThread(function()
    Wait(1000)
    applyRoads(false)
end)

-- Density setters must run every frame. This affects nearby population density,
-- not a perfect polygon mask, so only activate when the player is in the zone.
CreateThread(function()
    while true do
        local waitMs = 750
        local pos = GetEntityCoords(PlayerPedId())
        for _, zone in ipairs(zones) do
            if zone.suppressPopulation and inZone(pos, zone) then
                SetVehicleDensityMultiplierThisFrame(0.0)
                SetRandomVehicleDensityMultiplierThisFrame(0.0)
                SetParkedVehicleDensityMultiplierThisFrame(0.0)
                SetPedDensityMultiplierThisFrame(0.0)
                SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
                waitMs = 0
                break
            end
        end
        Wait(waitMs)
    end
end)

-- Only clean up ambient, locally-owned population entities. Never touch player
-- peds, occupied player vehicles, or mission/script-owned entities.
local function isAmbient(entity)
    return DoesEntityExist(entity) and not IsEntityAMissionEntity(entity)
        and GetEntityPopulationType(entity) >= 1
        and GetEntityPopulationType(entity) <= 5
end

local function inCleanupZone(pos)
    for _, zone in ipairs(zones) do
        if zone.cleanupAmbient and inZone(pos, zone) then return true end
    end
    return false
end

CreateThread(function()
    while true do
        local pos = GetEntityCoords(PlayerPedId())
        local active = false
        local interval = 3000
        for _, zone in ipairs(zones) do
            if zone.cleanupAmbient and nearZone(pos, zone) then
                active = true
                interval = math.min(interval, zone.cleanupIntervalMs or 3000)
            end
        end
        if active then
            for _, veh in ipairs(GetGamePool('CVehicle')) do
                if isAmbient(veh) and NetworkHasControlOfEntity(veh)
                    and inCleanupZone(GetEntityCoords(veh)) then
                    local hasPlayer = false
                    for seat = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
                        local occupant = GetPedInVehicleSeat(veh, seat)
                        if occupant ~= 0 and IsPedAPlayer(occupant) then
                            hasPlayer = true
                            break
                        end
                    end
                    if not hasPlayer then DeleteEntity(veh) end
                end
            end
            for _, ped in ipairs(GetGamePool('CPed')) do
                if isAmbient(ped) and not IsPedAPlayer(ped)
                    and NetworkHasControlOfEntity(ped)
                    and not IsPedInAnyVehicle(ped, false)
                    and inCleanupZone(GetEntityCoords(ped)) then
                    DeleteEntity(ped)
                end
            end
        end
        Wait(active and interval or 3000)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        applyRoads(true)
    end
end)
