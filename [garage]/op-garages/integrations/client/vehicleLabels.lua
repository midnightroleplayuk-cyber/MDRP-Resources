-- Vehicle display labels: admin custom > framework shared > GTA natives > vehiclesList.json

local frameworkLabelByHash = nil
local frameworkSpawnByHash = nil
local jsonLabelByHash = nil
local jsonSpawnNameByHash = nil

local function formatSpawnName(spawn)
    if not spawn or spawn == "" then return nil end
    spawn = tostring(spawn):match("^%s*(.-)%s*$")
    if spawn == "" or tonumber(spawn) then return nil end
    return capitalizeWords(spawn:gsub("_", " "))
end

local function cacheHashKey(hash)
    if hash == nil then return end
    local signed = ToSignedVehicleHash(hash)
    local unsigned = NormalizeVehicleHash(hash)
    return signed, unsigned
end

local function storeLabel(cache, hash, label)
    if not cache or not hash or not label or label == "" then return end
    local signed, unsigned = cacheHashKey(hash)
    if signed then cache[tostring(signed)] = label end
    if unsigned then cache[tostring(unsigned)] = label end
end

local function storeSpawn(cache, hash, spawn)
    if not cache or not hash or not spawn or spawn == "" then return end
    local signed, unsigned = cacheHashKey(hash)
    if signed then cache[tostring(signed)] = spawn end
    if unsigned then cache[tostring(unsigned)] = spawn end
end

local function lookupCached(cache, hash)
    if not cache or not hash then return nil end
    local signed, unsigned = cacheHashKey(hash)
    return cache[tostring(signed)]
        or cache[tostring(unsigned)]
        or cache[tostring(hash)]
end

local function buildJsonSpawnCache()
    if jsonLabelByHash ~= nil then return jsonLabelByHash end
    jsonLabelByHash = {}
    jsonSpawnNameByHash = {}

    local jsonData = LoadResourceFile(GetCurrentResourceName(), "config/vehiclesList.json")
    local jsonConfig = jsonData and json.decode(jsonData)
    if type(jsonConfig) ~= "table" then return jsonLabelByHash end

    for key, entry in pairs(jsonConfig) do
        if type(entry) == "table" and entry.model then
            local hash = tonumber(key) or joaat(tostring(key))
            local spawn = tostring(entry.model)
            storeLabel(jsonLabelByHash, hash, formatSpawnName(spawn))
            storeSpawn(jsonSpawnNameByHash, hash, spawn)
        end
    end

    return jsonLabelByHash
end

local function buildFrameworkLabelCache()
    if frameworkLabelByHash ~= nil then return frameworkLabelByHash end
    frameworkLabelByHash = {}
    frameworkSpawnByHash = {}

    local sharedVehicles = nil
    if Framework and Framework.Shared and Framework.Shared.Vehicles then
        sharedVehicles = Framework.Shared.Vehicles
    end

    if not sharedVehicles and GetResourceState('qbx_core') == 'started' then
        pcall(function()
            sharedVehicles = exports.qbx_core:GetVehiclesByName()
        end)
    end

    if type(sharedVehicles) == "table" then
        for spawn, data in pairs(sharedVehicles) do
            if type(data) == "table" then
                local label = data.name or data.label or capitalizeWords(tostring(spawn))
                local hash = data.hash or joaat(spawn)
                storeLabel(frameworkLabelByHash, hash, label)
                storeSpawn(frameworkSpawnByHash, hash, tostring(spawn))
            elseif type(data) == "string" then
                storeLabel(frameworkLabelByHash, joaat(spawn), capitalizeWords(data))
                storeSpawn(frameworkSpawnByHash, joaat(spawn), tostring(spawn))
            end
        end
    end

    return frameworkLabelByHash
end

local function getGtaVehicleLabelForHash(hash)
    if not hash or hash == 0 then return nil end

    local seen = {}
    local candidates = {
        hash,
        ToSignedVehicleHash(hash),
        NormalizeVehicleHash(hash),
    }

    for i = 1, #candidates do
        local h = candidates[i]
        if h and h ~= 0 and not seen[h] then
            seen[h] = true
            local displayName = GetDisplayNameFromVehicleModel(h)
            if displayName and displayName ~= "" and displayName ~= "CARNOTFOUND" then
                local label = GetLabelText(displayName)
                if label and label ~= "" and label ~= "NULL" and label ~= displayName then
                    return label
                end
                return capitalizeWords(displayName:gsub("_", " "))
            end
        end
    end

    return nil
end

local function lookupAdminSpawnName(hash)
    local tbl = vehicleslabels or {}
    for k, v in pairs(tbl) do
        if type(k) == "string" and not tonumber(k) then
            local keyHash = joaat(k)
            if NormalizeVehicleHash(keyHash) == NormalizeVehicleHash(hash)
                or ToSignedVehicleHash(keyHash) == ToSignedVehicleHash(hash) then
                return k
            end
        elseif type(v) == "table" and v.model and not tonumber(v.model) then
            local entryHash = joaat(v.model)
            if NormalizeVehicleHash(entryHash) == NormalizeVehicleHash(hash)
                or ToSignedVehicleHash(entryHash) == ToSignedVehicleHash(hash) then
                return v.model
            end
        end
    end
    return nil
end

local function resolveSpawnNameFallback(hash, model, fallbackSpawn)
    if fallbackSpawn then
        local formatted = formatSpawnName(fallbackSpawn)
        if formatted then return formatted end
    end

    if type(model) == "string" and not tonumber(model) then
        return formatSpawnName(model)
    end

    buildFrameworkLabelCache()
    local fwSpawn = lookupCached(frameworkSpawnByHash, hash)
    if fwSpawn then return formatSpawnName(fwSpawn) end

    buildJsonSpawnCache()
    local jsonSpawn = lookupCached(jsonSpawnNameByHash, hash)
    if jsonSpawn then return formatSpawnName(jsonSpawn) end

    local adminSpawn = lookupAdminSpawnName(hash)
    if adminSpawn then return formatSpawnName(adminSpawn) end

    return nil
end

function ScriptFunctions.FormatMileage(value)
    local decimals = tonumber(Config.Mileage and Config.Mileage.DecimalPlaces) or 1
    value = tonumber(value) or 0
    if decimals <= 0 then
        return math.floor(value + 0.5)
    end
    local mult = 10 ^ decimals
    return math.floor(value * mult + 0.5) / mult
end

function ScriptFunctions.ResolveVehicleDisplayLabel(model, fallbackSpawn)
    if model == nil or model == "" then
        return resolveSpawnNameFallback(0, nil, fallbackSpawn) or "Unknown"
    end

    local vehiclesConfig = vehicleslabels or {}
    local vehicleConfig = ResolveVehicleLabelEntry(vehiclesConfig, model)
    if vehicleConfig then
        if vehicleConfig.label and vehicleConfig.label ~= ""
            and vehicleConfig.label ~= "CARNOTFOUND" then
            return vehicleConfig.label
        end
        if vehicleConfig.model then
            local fromModel = formatSpawnName(vehicleConfig.model)
            if fromModel then return fromModel end
        end
    end

    local hash = model
    if type(hash) == "string" then
        local asNumber = tonumber(hash)
        hash = asNumber or joaat(hash)
    end
    hash = tonumber(hash) or 0

    local frameworkLabel = lookupCached(buildFrameworkLabelCache(), hash)
    if frameworkLabel then
        return frameworkLabel
    end

    local gtaLabel = getGtaVehicleLabelForHash(hash)
    if gtaLabel then
        return gtaLabel
    end

    local jsonLabel = lookupCached(buildJsonSpawnCache(), hash)
    if jsonLabel then
        return jsonLabel
    end

    local spawnFallback = resolveSpawnNameFallback(hash, model, fallbackSpawn)
    if spawnFallback then
        return spawnFallback
    end

    return formatSpawnName(model) or formatSpawnName(fallbackSpawn) or "Unknown"
end

CreateThread(function()
    while Framework == nil do Wait(100) end
    buildFrameworkLabelCache()
end)

RegisterNetEvent('QBCore:Client:UpdateObject', function()
    frameworkLabelByHash = nil
    frameworkSpawnByHash = nil
end)

RegisterNetEvent('QBCore:Client:OnSharedUpdate', function()
    frameworkLabelByHash = nil
    frameworkSpawnByHash = nil
end)

ResolveVehicleDisplayLabel = function(model, fallbackSpawn)
    return ScriptFunctions.ResolveVehicleDisplayLabel(model, fallbackSpawn)
end
