Mileage = {}
Mileage.__index = Mileage
local MILEAGE_KEY <const> = "tuff-hud:mileage:"

function Mileage.new()
    local self = setmetatable({}, Mileage)
    self.active = false
    self.currentMileage = 0.0
    self.lastCoords = nil
    self.plate = nil
    return self
end

local function saveMileageKvp(cleanPlate, meters)
    if not cleanPlate or cleanPlate == "" then return end
    local kvpKey = MILEAGE_KEY .. cleanPlate
    SetResourceKvpFloat(kvpKey, meters)
    TriggerServerEvent("tuff-hud:server:updateMileage", cleanPlate, meters)
end

function Mileage.ConvertUnit(meters, unit)
    meters = tonumber(meters) or 0.0
    if meters < 0.0 then meters = 0.0 end

    local u = (type(unit) == "string" and string.len(unit) > 0) and string.lower(unit) or "player"

    if u == "player" or u == "auto" or u == "default" then
        local playerUnit = Client?.Data?.SPEEDUNIT or "kmh"
        if string.lower(playerUnit) == "mph" then
            u = "mi"
        else
            u = "km"
        end
    end

    if u == "km" or u == "kmh" or u == "kilometers" then
        return meters / 1000.0
    elseif u == "mi" or u == "mph" or u == "miles" then
        return (meters / 1000.0) * 0.621371
    elseif u == "meters" or u == "m" or u == "raw" then
        return meters
    else
        return meters / 1000.0
    end
end

function Mileage.GetFullData(meters)
    meters = tonumber(meters) or 0.0
    if meters < 0.0 then meters = 0.0 end

    local km = meters / 1000.0
    local mi = km * 0.621371

    return {
        meters = meters,
        km = km,
        mi = mi
    }
end

function Mileage:GetMileageByPlate(plate, unit)
    if not plate then return 0.0 end
    local cleanPlate = string.gsub(tostring(plate), "^%s*(.-)%s*$", "%1")
    if cleanPlate == "" then return 0.0 end

    local meters = 0.0
    if self.active and self.plate == cleanPlate then
        meters = self.currentMileage or 0.0
    else
        local kvpKey = MILEAGE_KEY .. cleanPlate
        local saved = GetResourceKvpFloat(kvpKey)
        if saved and saved >= 0.0 then
            meters = saved
        end
    end

    return Mileage.ConvertUnit(meters, unit)
end

function Mileage:GetFullMileageByPlate(plate)
    if not plate then return Mileage.GetFullData(0.0) end
    local cleanPlate = string.gsub(tostring(plate), "^%s*(.-)%s*$", "%1")
    if cleanPlate == "" then return Mileage.GetFullData(0.0) end

    local meters = 0.0
    if self.active and self.plate == cleanPlate then
        meters = self.currentMileage or 0.0
    else
        local kvpKey = MILEAGE_KEY .. cleanPlate
        local saved = GetResourceKvpFloat(kvpKey)
        if saved and saved >= 0.0 then
            meters = saved
        end
    end

    return Mileage.GetFullData(meters)
end

function Mileage:SetMileageByPlate(plate, amount, unit)
    if not plate or amount == nil then return false end
    local cleanPlate = string.gsub(tostring(plate), "^%s*(.-)%s*$", "%1")
    if cleanPlate == "" then return false end

    local val = tonumber(amount) or 0.0
    if val < 0.0 then val = 0.0 end

    local u = type(unit) == "string" and string.lower(unit) or "meters"
    local meters = val

    if u == "km" or u == "kmh" or u == "kilometers" then
        meters = val * 1000.0
    elseif u == "mi" or u == "mph" or u == "miles" then
        meters = (val / 0.621371) * 1000.0
    end

    if self.active and self.plate == cleanPlate then
        self.currentMileage = meters
    end

    saveMileageKvp(cleanPlate, meters)
    return true
end

function Mileage:Start(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end
    if self.active then self:Stop() end

    local rawPlate = GetVehicleNumberPlateText(vehicle)
    if not rawPlate then return end

    local cleanPlate = string.gsub(rawPlate, "^%s*(.-)%s*$", "%1")
    self.plate = cleanPlate
    local kvpKey = MILEAGE_KEY .. cleanPlate

    local savedMileage = GetResourceKvpFloat(kvpKey)
    if not savedMileage or savedMileage < 0.0 then
        savedMileage = 0.0
    end

    self.currentMileage = savedMileage
    self.lastCoords = GetEntityCoords(vehicle)
    self.active = true

    CreateThread(function()
        local lastSaveTime = GetGameTimer()
        local lastSavedMileage = self.currentMileage

        while self.active and Client.Vehicle == vehicle do
            Wait(1000)

            if self.active and Client.Vehicle == vehicle and DoesEntityExist(vehicle) then
                local coords = GetEntityCoords(vehicle)
                local lc = self.lastCoords
                local dx = coords.x - lc.x
                local dy = coords.y - lc.y
                local dz = coords.z - lc.z
                local dist = math.sqrt(dx * dx + dy * dy + dz * dz)

                if dist > 0.5 then
                    self.currentMileage = self.currentMileage + dist
                    self.lastCoords = coords

                    local now = GetGameTimer()
                    if now - lastSaveTime >= 5000 then
                        lastSaveTime = now
                        lastSavedMileage = self.currentMileage
                        saveMileageKvp(cleanPlate, self.currentMileage)
                    end
                end
            end
        end

        if lastSavedMileage ~= self.currentMileage then
            saveMileageKvp(cleanPlate, self.currentMileage)
        end

        self.active = false
    end)
end

function Mileage:Stop()
    self.active = false
    self.plate = nil
    self.lastCoords = nil
end

function Mileage:GetMileage()
    return self.currentMileage or 0.0
end

RegisterNetEvent("tuff-hud:client:syncMileage", function(cleanPlate, meters)
    if not cleanPlate or cleanPlate == "" or not meters then return end
    local kvpKey = MILEAGE_KEY .. cleanPlate
    SetResourceKvpFloat(kvpKey, tonumber(meters) or 0.0)
    if HUD and HUD.Mileage and HUD.Mileage.active and HUD.Mileage.plate == cleanPlate then
        HUD.Mileage.currentMileage = tonumber(meters) or 0.0
    end
end)
