if Sky.Config.license ~= "codem" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "codem-wallet"

-- codem-wallet: identifier-based license store backed by codem_wallet_cards.

function Sky.FW.IsLicenseProviderAvailable()
    return GetResourceState(RESOURCE) == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    return exports[RESOURCE]:hasLicense(target.identifier, license_type) and true or false
end

function Sky.FW.AddLicense(target, license_type)
    if exports[RESOURCE]:hasLicense(target.identifier, license_type) then
        return true
    end
    exports[RESOURCE]:addLicense(target.identifier, license_type, { source = target.source })
    return true
end

function Sky.FW.RemoveLicense(target, license_type)
    Sky.Query("DELETE FROM codem_wallet_cards WHERE identifier = ? AND type = ? AND licenseType = ?;",
        { target.identifier, "license", license_type })
    return true
end

function Sky.FW.GetLicenses(target)
    local rows = Sky.Query([[
        SELECT licenseType
        FROM codem_wallet_cards
        WHERE identifier = ? AND type = ? AND licenseType IS NOT NULL AND licenseType <> ''
    ]], { target.identifier, "license" }) or {}

    local labels = {}
    for _, entry in ipairs(Sky.FW.GetConfiguredLicenseCatalog()) do
        labels[entry.type] = entry.label
    end

    local resolved = {}
    local seen = {}
    for _, row in ipairs(rows) do
        local license_type = row.licenseType
        if type(license_type) == "string" and license_type ~= "" and not seen[license_type] then
            seen[license_type] = true
            resolved[#resolved + 1] = {
                type = license_type,
                label = labels[license_type] or license_type
            }
        end
    end
    return resolved
end

function Sky.FW.GetLicenseHolders(license_type)
    local rows = Sky.Query("SELECT DISTINCT identifier FROM codem_wallet_cards WHERE type = ? AND licenseType = ?", { "license", license_type })
    assert(type(rows) == "table", "[sky_base][license] CodeM holder query failed")
    return rows
end
