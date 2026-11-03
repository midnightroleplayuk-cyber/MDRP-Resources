if Sky.Config.license ~= "cs" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "cs_license"

-- CodeStudio Ultimate License System: persistent, item-named licenses.

function Sky.FW.IsLicenseProviderAvailable()
    return GetResourceState(RESOURCE) == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    return exports[RESOURCE]:CheckID(target.identifier, license_type)
end

function Sky.FW.AddLicense(target, license_type)
    local player_id = target.source or target.identifier
    exports[RESOURCE]:RegisterCard(player_id, license_type, false, target.source ~= nil)
    return exports[RESOURCE]:CheckID(target.identifier, license_type)
end

function Sky.FW.RemoveLicense(target, license_type)
    exports[RESOURCE]:RevokeCard(target.identifier, license_type)
    return not exports[RESOURCE]:CheckID(target.identifier, license_type)
end

function Sky.FW.GetLicenses(target)
    local licenses = {}
    for _, entry in ipairs(exports[RESOURCE]:GetPlayerLicenses(target.identifier)) do
        if exports[RESOURCE]:CheckID(target.identifier, entry.license) then
            licenses[#licenses + 1] = { type = entry.license, label = entry.heading }
        end
    end
    return licenses
end
