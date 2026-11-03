if Sky.Config.license ~= "custom" then return end
if not IsDuplicityVersion() then return end

-- Set Config.license = "custom" to enable this server-side provider template.

function Sky.FW.IsLicenseProviderAvailable()
    -- Config.license = "custom" selects this provider directly.
    return true
end

function Sky.FW.CheckLicense(target, license_type)
    -- Return whether `target.identifier` owns `license_type`.
    error("Custom license integration: Check is not implemented")
end

function Sky.FW.AddLicense(target, license_type)
    -- Grant the license and return whether the operation succeeded.
    error("Custom license integration: Add is not implemented")
end

function Sky.FW.RemoveLicense(target, license_type)
    -- Revoke the license and return whether the operation succeeded.
    error("Custom license integration: Remove is not implemented")
end

function Sky.FW.GetLicenses(target)
    -- Return an array of { type = string, label = string } entries.
    error("Custom license integration: List is not implemented")
end

function Sky.FW.GetLicenseCatalog(target)
    -- Return all available { type = string, label = string } entries.
    -- Use Sky.FW.GetConfiguredLicenseCatalog() when appropriate.
    error("Custom license integration: Catalog is not implemented")
end

function Sky.FW.GetLicenseHolders(license_type)
    -- Optional: return ALL current holders (online + offline) as
    -- { { identifier = "character-id" }, ... }. Return {} only after a
    -- successful empty lookup. Throw on errors; never return partial results.
    return nil, "license_holders_unsupported"
end
