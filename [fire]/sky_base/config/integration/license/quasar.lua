if Sky.Config.license ~= "quasar" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "qs-licenses"

-- qs-licenses: identifier-based reads/revokes with source-based license grants.

function Sky.FW.IsLicenseProviderAvailable()
    return GetResourceState(RESOURCE) == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    return exports[RESOURCE]:HasLicense(target.identifier, license_type) and true or false
end

function Sky.FW.AddLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "AddLicense", license_type)
    if not source then return false end

    return exports[RESOURCE]:AddLicenseToPlayer(source, license_type) and true or false
end

function Sky.FW.RemoveLicense(target, license_type)
    return exports[RESOURCE]:RevokeLicense(target.identifier, license_type) and true or false
end

function Sky.FW.GetLicenses(target)
    local active_licenses = exports[RESOURCE]:GetActiveLicenses(target.identifier)
    if type(active_licenses) ~= "table" then
        Sky.Debug("warn", ("[sky_base][license] qs-licenses GetActiveLicenses returned %s for identifier %s")
            :format(type(active_licenses), tostring(target.identifier)))
        return {}
    end

    local licenses = {}
    for _, entry in ipairs(active_licenses) do
        if type(entry) ~= "table" then
            Sky.Debug("warn", ("[sky_base][license] qs-licenses returned an invalid active license entry for identifier %s")
                :format(tostring(target.identifier)))
        else
            local license_type = entry.template_id or entry.type
            if type(license_type) ~= "string" or license_type == "" then
                Sky.Debug("warn", ("[sky_base][license] qs-licenses active license is missing template_id for identifier %s")
                    :format(tostring(target.identifier)))
            else
                licenses[#licenses + 1] = {
                    type = license_type,
                    label = entry.display_name or entry.label
                }
            end
        end
    end

    return licenses
end
