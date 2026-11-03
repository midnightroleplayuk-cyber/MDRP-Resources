if Sky.Config.license ~= "bit" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "bit-licenses"

-- bit-licenses: source-based license resource. License ids come from
-- Config.Licenses.catalog (e.g. driving, weapon, hunting, idcard) because the
-- resource does not expose a list export.

function Sky.FW.IsLicenseProviderAvailable()
    return GetResourceState(RESOURCE) == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "CheckLicense", license_type)
    if not source then return false end
    return exports[RESOURCE]:CheckLicense(source, license_type) and true or false
end

function Sky.FW.AddLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "AddLicense", license_type)
    if not source then return false end
    exports[RESOURCE]:Addlicense(source, license_type)
    return true
end

function Sky.FW.RemoveLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "RemoveLicense", license_type)
    if not source then return false end
    exports[RESOURCE]:RemoveLicense(source, license_type)
    return true
end

function Sky.FW.GetLicenses(target)
    local source = Sky.FW.RequireLicenseSource(target, "GetLicenses", "-")
    if not source then return {} end
    local licenses = {}
    for _, entry in ipairs(Sky.FW.GetConfiguredLicenseCatalog()) do
        if exports[RESOURCE]:CheckLicense(source, entry.type) then
            licenses[#licenses + 1] = { type = entry.type, label = entry.label }
        end
    end
    return licenses
end
