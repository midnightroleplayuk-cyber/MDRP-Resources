if Sky.Config.license ~= "stg-walletv2" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "stg-walletv2"
local framework_available = Sky.FW.IsLicenseProviderAvailable

-- The framework adapter already owns CheckLicense, GetLicenses, catalog and holders.
function Sky.FW.IsLicenseProviderAvailable()
    return GetResourceState(RESOURCE) == "started" and framework_available()
end

function Sky.FW.AddLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "AddLicense", license_type)
    if not source then return false end
    exports[RESOURCE]:giveLicense(source, license_type)
    return true
end

function Sky.FW.RemoveLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "RemoveLicense", license_type)
    if not source then return false end
    exports[RESOURCE]:removeLicense(source, license_type)
    return true
end
