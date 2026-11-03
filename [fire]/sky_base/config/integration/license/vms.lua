if Sky.Config.license ~= "vms" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "vms_documentsv2"

-- vms_documentsv2: document-based license provider.

local function register_license_type(results, seen, license_type)
    if type(license_type) ~= "string" then
        return
    end

    license_type = license_type:gsub("^%s+", ""):gsub("%s+$", "")
    if license_type == "" then
        return
    end

    local key = license_type:lower()
    if seen[key] then
        return
    end

    seen[key] = true
    results[#results + 1] = license_type
end

local function collect_license_types(value, results, seen, depth)
    if depth > 4 or type(value) ~= "table" then
        return
    end

    register_license_type(results, seen, value.name)
    register_license_type(results, seen, value.type)
    register_license_type(results, seen, value.document)
    register_license_type(results, seen, value.documentName)
    register_license_type(results, seen, value.item)
    register_license_type(results, seen, value.itemName)

    for _, entry in pairs(value) do
        collect_license_types(entry, results, seen, depth + 1)
    end
end

local function get_discovered_license_types(identifier)
    local results = {}
    local seen = {}

    for _, entry in ipairs(Sky.FW.GetConfiguredLicenseCatalog()) do
        register_license_type(results, seen, entry.type)
    end

    local documents = exports[RESOURCE]:getMyDocuments(identifier) or {}
    collect_license_types(documents, results, seen, 0)

    return results
end

function Sky.FW.IsLicenseProviderAvailable()
    return GetResourceState(RESOURCE) == "started"
end

function Sky.FW.CheckLicense(target, license_type)
    return exports[RESOURCE]:isAnyDocumentValid(target.identifier, license_type) ~= nil
end

function Sky.FW.AddLicense(target, license_type)
    local source = Sky.FW.RequireLicenseSource(target, "AddLicense", license_type)
    if not source then return false end
    exports[RESOURCE]:giveDocument(source, license_type, nil, true)
    return true
end

function Sky.FW.RemoveLicense(target, license_type)
    local serialNumber = exports[RESOURCE]:isAnyDocumentValid(target.identifier, license_type)
    if not serialNumber then
        return true
    end

    exports[RESOURCE]:invalidateDocument(target.identifier, serialNumber)
    return true
end

function Sky.FW.GetLicenses(target)
    local configuredCatalog = Sky.FW.GetConfiguredLicenseCatalog()
    local labels = {}
    for _, entry in ipairs(configuredCatalog) do
        labels[entry.type:lower()] = entry.label or entry.type
    end

    local results = {}
    for _, license_type in ipairs(get_discovered_license_types(target.identifier)) do
        local serialNumber = exports[RESOURCE]:isAnyDocumentValid(target.identifier, license_type)
        if serialNumber then
            results[#results + 1] = {
                type = license_type,
                label = labels[license_type:lower()] or license_type,
                serialNumber = serialNumber
            }
        end
    end

    table.sort(results, function(a, b)
        return tostring(a.type) < tostring(b.type)
    end)

    return results
end
