if Sky.Config.license ~= "standalone" then return end
if not IsDuplicityVersion() then return end

function Sky.FW.IsLicenseProviderAvailable()
    return true
end

function Sky.FW.CheckLicense(target, license_type)
    local rows = Sky.Query(
        "SELECT 1 FROM sky_base_licenses WHERE identifier = ? AND license_type = ? LIMIT 1",
        { target.identifier, license_type }
    ) or {}
    return rows[1] ~= nil
end

function Sky.FW.AddLicense(target, license_type)
    Sky.Query(
        "INSERT IGNORE INTO sky_base_licenses (identifier, license_type) VALUES (?, ?)",
        { target.identifier, license_type }
    )
    return true
end

function Sky.FW.RemoveLicense(target, license_type)
    Sky.Query(
        "DELETE FROM sky_base_licenses WHERE identifier = ? AND license_type = ?",
        { target.identifier, license_type }
    )
    return true
end

function Sky.FW.GetLicenses(target)
    local rows = Sky.Query(
        "SELECT license_type AS type FROM sky_base_licenses WHERE identifier = ?",
        { target.identifier }
    ) or {}
    return rows
end

function Sky.FW.GetLicenseHolders(license_type)
    local rows = Sky.Query("SELECT identifier FROM sky_base_licenses WHERE license_type = ?", { license_type })
    assert(type(rows) == "table", "[sky_base][license] Standalone holder query failed")
    return rows
end
