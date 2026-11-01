if Sky.Config.license ~= "ak47" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "ak47_idcardv2"

-- ak47_idcardv2: id-card based license resource (driverlicense item).

function Sky.FW.IsLicenseProviderAvailable()
    return GetResourceState(RESOURCE) == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "CheckLicense", license_type)
    if not source then return false end
    return exports[RESOURCE]:HasLicense(source, "driverlicense", license_type)
end

function Sky.FW.AddLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "AddLicense", license_type)
    if not source then return false end
    exports[RESOURCE]:GiveIdCard(source, {
        item = 'driverlicense', -- item name
        class = license_type,
        address = 'Greenlight', -- player address
        expire = 3,             -- in month
    })
    return true
end

function Sky.FW.RemoveLicense(target, license_type)
    Sky.Debug("warn", ("[sky_base][license] RemoveLicense is not supported by ak47_idcardv2 (identifier %s, license %s)"):format(tostring(target.identifier), tostring(license_type)))
    return false
end

function Sky.FW.GetLicenses(target)
    local source = Sky.FW.RequireLicenseSource(target, "GetLicenses", "-")
    if not source then return {} end
    local ok, result = pcall(function()
        return exports[RESOURCE]:GetLicenses(source, "driverlicense")
    end)
    if ok and type(result) == "table" then
        return result
    end

    local licenses = {}
    for _, entry in ipairs(Sky.FW.GetConfiguredLicenseCatalog()) do
        if exports[RESOURCE]:HasLicense(source, "driverlicense", entry.type) then
            licenses[#licenses + 1] = { type = entry.type, label = entry.label }
        end
    end
    return licenses
end
