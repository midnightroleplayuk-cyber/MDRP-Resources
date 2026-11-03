if not IsDuplicityVersion() then return end

-- Adapters bind Sky.FW directly; normalize the public contract once after loading them.
local selected_provider = Sky.Config.license
local is_available = Sky.FW.IsLicenseProviderAvailable
local check_license = Sky.FW.CheckLicense
local add_license = Sky.FW.AddLicense
local remove_license = Sky.FW.RemoveLicense
local get_licenses = Sky.FW.GetLicenses
local get_catalog = Sky.FW.GetLicenseCatalog
local get_holders = Sky.FW.GetLicenseHolders
local warned_provider = false

local function normalize_license_type(license_type)
    if type(license_type) ~= "string" then return nil end
    license_type = license_type:gsub("^%s+", ""):gsub("%s+$", "")
    if license_type ~= "" then return license_type end
end

local function append_unique_licenses(target, seen, entries)
    for _, entry in ipairs(entries or {}) do
        local license_type = type(entry) == "table" and entry.type or entry
        if type(license_type) == "string" and license_type ~= "" and not seen[license_type] then
            seen[license_type] = true
            target[#target + 1] = {
                type = license_type,
                label = type(entry) == "table" and entry.label or nil
            }
        end
    end
end

function Sky.FW.IsLicenseProviderAvailable()
    if Sky.Config.license == selected_provider and is_available() then return true end
    if not warned_provider then
        warned_provider = true
        Sky.Debug("warn", "[license] Selected provider '%s' is unavailable or changed after startup; no fallback will be used",
            tostring(selected_provider))
    end
    return false
end

function Sky.FW.CheckLicense(source_or_identifier, license_type)
    license_type = normalize_license_type(license_type)
    if not license_type then
        Sky.Debug("warn", "[license] CheckLicense failed: invalid license type")
        return false
    end
    if not Sky.FW.IsLicenseProviderAvailable() then return false end
    local target = Sky.FW.ResolveLicenseTarget(source_or_identifier)
    if not target then
        Sky.Debug("warn", "[license] CheckLicense failed: invalid target %s", tostring(source_or_identifier))
        return false
    end
    return not not check_license(target, license_type)
end

function Sky.FW.AddLicense(source_or_identifier, license_type)
    license_type = normalize_license_type(license_type)
    if not license_type then
        Sky.Debug("warn", "[license] AddLicense failed: invalid license type")
        return false
    end
    if not Sky.FW.IsLicenseProviderAvailable() then return false end
    local target = Sky.FW.ResolveLicenseTarget(source_or_identifier)
    if not target then
        Sky.Debug("warn", "[license] AddLicense failed: invalid target %s", tostring(source_or_identifier))
        return false
    end
    return not not add_license(target, license_type)
end

function Sky.FW.RemoveLicense(source_or_identifier, license_type)
    license_type = normalize_license_type(license_type)
    if not license_type then
        Sky.Debug("warn", "[license] RemoveLicense failed: invalid license type")
        return false
    end
    if not Sky.FW.IsLicenseProviderAvailable() then return false end
    local target = Sky.FW.ResolveLicenseTarget(source_or_identifier)
    if not target then
        Sky.Debug("warn", "[license] RemoveLicense failed: invalid target %s", tostring(source_or_identifier))
        return false
    end
    return not not remove_license(target, license_type)
end

function Sky.FW.GetLicenses(source_or_identifier)
    if not Sky.FW.IsLicenseProviderAvailable() then return {} end
    local target = Sky.FW.ResolveLicenseTarget(source_or_identifier)
    if not target then
        Sky.Debug("warn", "[license] GetLicenses failed: invalid target %s", tostring(source_or_identifier))
        return {}
    end
    local licenses, seen = {}, {}
    append_unique_licenses(licenses, seen, get_licenses(target))

    local labels = {}
    for _, entry in ipairs(Sky.FW.GetConfiguredLicenseCatalog()) do
        labels[entry.type] = entry.label
    end
    for _, entry in ipairs(licenses) do
        entry.label = entry.label or labels[entry.type] or entry.type
    end
    table.sort(licenses, function(a, b) return a.type < b.type end)
    return licenses
end

function Sky.FW.GetLicenseCatalog(source_or_identifier)
    if not Sky.FW.IsLicenseProviderAvailable() then return {} end
    local target = source_or_identifier and Sky.FW.ResolveLicenseTarget(source_or_identifier) or nil
    local catalog, seen = {}, {}
    append_unique_licenses(catalog, seen, get_catalog(target))
    local configured_catalog = Sky.FW.GetConfiguredLicenseCatalog()
    append_unique_licenses(catalog, seen, configured_catalog)
    local labels = {}
    for _, entry in ipairs(configured_catalog) do
        labels[entry.type] = entry.label
    end
    for _, entry in ipairs(catalog) do
        entry.label = entry.label or labels[entry.type] or entry.type
    end
    table.sort(catalog, function(a, b) return a.type < b.type end)
    return catalog
end

-- Complete current holders, including offline characters; unsupported is not an empty snapshot.
function Sky.FW.GetLicenseHolders(license_type)
    license_type = normalize_license_type(license_type)
    if not license_type then return nil, "invalid_license_type" end
    if not Sky.FW.IsLicenseProviderAvailable() then return nil, "license_provider_unavailable" end
    local entries, failure = get_holders(license_type)
    if entries == nil then return nil, failure end
    local result, seen = {}, {}
    for _, entry in ipairs(entries) do
        if type(entry) ~= "table" or type(entry.identifier) ~= "string" or entry.identifier == "" or #entry.identifier > 128 then
            error("[license] Holder snapshot contains an invalid character identifier")
        end
        if not seen[entry.identifier] then
            seen[entry.identifier] = true
            result[#result + 1] = entry
        end
    end
    return result
end
