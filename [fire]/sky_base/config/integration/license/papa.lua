if Sky.Config.license ~= "papa" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "papa_licensecreator"

-- papa_licensecreator: access-based license resource. License ids come from
-- Config.Licenses.catalog (e.g. papa_id, papa_driver_license) because the
-- resource does not expose a list export.

function Sky.FW.IsLicenseProviderAvailable()
    return GetResourceState(RESOURCE) == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "CheckLicense", license_type)
    if not source then return false end
    return exports[RESOURCE]:hasLicenseAccess(source, license_type) and true or false
end

function Sky.FW.AddLicense(target, license_type)
    exports[RESOURCE]:addLicenseAccess(target.identifier, license_type)
    if (Config.Licenses or {}).papaGiveItem then
        exports[RESOURCE]:giveLicenseItem(target.identifier, license_type)
    end
    return true
end

function Sky.FW.RemoveLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "RemoveLicense", license_type)
    if not source then return false end
    exports[RESOURCE]:removeLicenseAccess(source, license_type)
    return true
end

function Sky.FW.GetLicenses(target)
    local source = Sky.FW.RequireLicenseSource(target, "GetLicenses", "-")
    if not source then return {} end
    local licenses = {}
    for _, entry in ipairs(Sky.FW.GetConfiguredLicenseCatalog()) do
        if exports[RESOURCE]:hasLicenseAccess(source, entry.type) then
            licenses[#licenses + 1] = { type = entry.type, label = entry.label }
        end
    end
    return licenses
end
