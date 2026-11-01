if not IsDuplicityVersion() then return end

-- QB/Qbox persist offline licenses in metadata, while online metadata is newer
-- than the last database save. Merge both before returning a complete snapshot.
function Sky.FW.GetLicenseMetadataHolders(license_type, online_players)
    local path = "$." .. json.encode(license_type)
    local rows = Sky.Query([[SELECT citizenid AS identifier FROM players
        WHERE JSON_UNQUOTE(JSON_EXTRACT(COALESCE(JSON_EXTRACT(metadata, '$.licences'),
            JSON_EXTRACT(metadata, '$.licenses')), ?)) = 'true']], { path })
    assert(type(rows) == "table", "[sky_base][license] Metadata holder query failed")
    local holders = {}
    for _, row in ipairs(rows) do holders[row.identifier] = true end
    for _, player in pairs(online_players) do
        local data = player.PlayerData
        local metadata = data.metadata or {}
        local licenses = metadata.licences or metadata.licenses or {}
        holders[data.citizenid] = licenses[license_type] == true or nil
    end
    local result = {}
    for identifier in pairs(holders) do result[#result + 1] = { identifier = identifier } end
    return result
end

function Sky.FW.GetConfiguredLicenseCatalog()
    local catalog = {}

    for _, entry in ipairs((Config.Licenses or {}).catalog or {}) do
        local license_type = entry
        local label

        if type(entry) == "table" then
            license_type = entry.type
            label = entry.label
        end

        if type(license_type) == "string" and license_type ~= "" then
            catalog[#catalog + 1] = {
                type = license_type,
                label = label or license_type
            }
        end
    end

    return catalog
end

function Sky.FW.ResolveLicenseTarget(source_or_identifier)
    local source
    local identifier

    if type(source_or_identifier) == "number" then
        source = source_or_identifier
        identifier = Sky.FW.GetIdentifier(source)
    elseif type(source_or_identifier) == "string" then
        identifier = source_or_identifier:gsub("^%s+", ""):gsub("%s+$", "")
        local online_source = Sky.FW.IsPlayerOnline(identifier)
        if type(online_source) == "number" then
            source = online_source
        end
    end

    if type(identifier) ~= "string" or identifier == "" then
        return nil
    end

    return {
        identifier = identifier,
        source = source
    }
end

function Sky.FW.RequireLicenseSource(target, action, license_type)
    if target.source then
        return target.source
    end

    Sky.Debug("warn", ("[sky_base][license] %s is not supported offline by the active provider (identifier %s, license %s)")
        :format(action, tostring(target.identifier), tostring(license_type)))
    return nil
end

-- Direct adapter defaults. A selected provider replaces the methods it supports.
function Sky.FW.IsLicenseProviderAvailable() return false end
function Sky.FW.CheckLicense() return false end
function Sky.FW.AddLicense() return false end
function Sky.FW.RemoveLicense() return false end
function Sky.FW.GetLicenses() return {} end
Sky.FW.GetLicenseCatalog = Sky.FW.GetConfiguredLicenseCatalog
function Sky.FW.GetLicenseHolders() return nil, "license_holders_unsupported" end
