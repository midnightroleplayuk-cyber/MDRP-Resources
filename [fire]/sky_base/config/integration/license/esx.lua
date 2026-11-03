if Sky.Config.license ~= "esx" and not (Sky.Config.license == "stg-walletv2" and Sky.Config.framework == "esx") then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "esx_license"

function Sky.FW.IsLicenseProviderAvailable()
    return Sky.Config.framework == "esx" and GetResourceState(RESOURCE) == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    local rows = Sky.Query(
        "SELECT 1 FROM user_licenses WHERE owner = ? AND type = ? LIMIT 1",
        { target.identifier, license_type }
    ) or {}
    return rows[1] ~= nil
end

function Sky.FW.AddLicense(target, license_type)
    Sky.Query(
        "INSERT IGNORE INTO user_licenses (owner, type) VALUES (?, ?)",
        { target.identifier, license_type }
    )
    return true
end

function Sky.FW.RemoveLicense(target, license_type)
    Sky.Query(
        "DELETE FROM user_licenses WHERE owner = ? AND type = ?",
        { target.identifier, license_type }
    )
    return true
end

function Sky.FW.GetLicenses(target)
    return Sky.Query([[
        SELECT user_licenses.type, COALESCE(licenses.label, user_licenses.type) AS label
        FROM user_licenses
        LEFT JOIN licenses ON licenses.type = user_licenses.type
        WHERE user_licenses.owner = ?
    ]], { target.identifier }) or {}
end

function Sky.FW.GetLicenseCatalog()
    return Sky.Query("SELECT type, label FROM licenses ORDER BY label", {}) or {}
end

function Sky.FW.GetLicenseHolders(license_type)
    local rows = Sky.Query("SELECT DISTINCT owner AS identifier FROM user_licenses WHERE type = ?", { license_type })
    assert(type(rows) == "table", "[sky_base][license] ESX holder query failed")
    return rows
end
