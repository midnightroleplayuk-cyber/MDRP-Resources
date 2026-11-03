if Sky.Config.license ~= "qb" and not (Sky.Config.license == "stg-walletv2" and Sky.Config.framework == "qb") then return end
if not IsDuplicityVersion() then return end

local core_object

local function get_core_object()
    core_object = core_object or exports["qb-core"]:GetCoreObject()
    return core_object
end

local function get_metadata(target)
    local player = get_core_object().Functions.GetPlayerByCitizenId(target.identifier)
    if player then
        return player.PlayerData.metadata or {}, player
    end

    local rows = Sky.Query("SELECT metadata FROM players WHERE citizenid = ? LIMIT 1", { target.identifier }) or {}
    if not rows[1] or not rows[1].metadata then
        Sky.Debug("warn", ("[sky_base][license] QB metadata not found for identifier %s"):format(target.identifier))
        return nil, nil
    end

    return json.decode(rows[1].metadata) or {}, nil
end

local function save_metadata(target, metadata, player)
    if player then
        player.Functions.SetMetaData("licences", metadata.licences)
        return true
    end

    Sky.Query("UPDATE players SET metadata = ? WHERE citizenid = ?", {
        json.encode(metadata),
        target.identifier
    })
    return true
end

function Sky.FW.IsLicenseProviderAvailable()
    return Sky.Config.framework == "qb" and GetResourceState("qb-core") == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    local metadata = get_metadata(target)
    local licences = metadata and (metadata.licences or metadata.licenses) or {}
    return licences[license_type] == true
end

function Sky.FW.AddLicense(target, license_type)
    local metadata, player = get_metadata(target)
    if not metadata then return false end

    metadata.licences = metadata.licences or metadata.licenses or {}
    metadata.licences[license_type] = true
    metadata.licenses = nil
    return save_metadata(target, metadata, player)
end

function Sky.FW.RemoveLicense(target, license_type)
    local metadata, player = get_metadata(target)
    if not metadata then return false end

    metadata.licences = metadata.licences or metadata.licenses or {}
    metadata.licences[license_type] = false
    metadata.licenses = nil
    return save_metadata(target, metadata, player)
end

function Sky.FW.GetLicenses(target)
    local metadata = get_metadata(target)
    local results = {}

    for license_type, enabled in pairs(metadata and (metadata.licences or metadata.licenses) or {}) do
        if enabled then
            results[#results + 1] = { type = license_type }
        end
    end

    return results
end

function Sky.FW.GetLicenseCatalog()
    local results = {}
    for license_type in pairs(get_core_object().Config.Player.PlayerDefaults.metadata.licences or {}) do
        results[#results + 1] = { type = license_type }
    end
    return results
end

function Sky.FW.GetLicenseHolders(license_type)
    local players = get_core_object().Functions.GetQBPlayers()
    return Sky.FW.GetLicenseMetadataHolders(license_type, players)
end
