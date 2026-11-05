ConfigWriter = ConfigWriter or {}

ConfigWriter.FILE_KEYS = {
    ['config/jobs.lua'] = {
        'Jobs',
    },
    ['config/locations.lua'] = {
        'ScreenProp',
        'IncomingRenderDistance',
        'IncomingScreenSoundRange',
        'StationaryECGProp',
        'Hospitals',
        'JailBeds',
    },
    ['config/weapons.lua'] = {
        'WeaponClasses',
        'Weapons',
    },
    ['config/wounds.lua'] = {
        'DamageRigorousness',
        'UnarmedDamageModifier',
        'SevereWoundDamage',
        'FractureMinDamage',
        'WoundApplyChance',
        'Wounds',
        'MinorWounds',
        'InsurvivableInjuries',
    },
    ['config/fractures.lua'] = {
        'Fractures',
    },
    ['config/shop.lua'] = {
        'MaxTakeOut',
        'ItemShopCategories',
        'ItemShop',
    },
    ['config/vehicles.lua'] = {
        'StretcherLimit',
        'StretcherModel',
        'StretcherAttach',
        'Ambulances',
        'AuthorizedVehicles',
        'VehicleExtras',
    },
    ['config/webhook.lua'] = {
        'webHook',
        'webHookName',
        'webHookLogo',
    },
}

ConfigWriter.PRESERVE_SUFFIX = {
    ['config/general.lua'] = 'Config.Casts',
}

-- Never written by the configurator (blood.lua mixes settings with runtime code).
local RUNTIME_ONLY_KEYS = {
    Medication = true,
    Casts = true,
    AmbulanceJobs = true,
    SpawnBloodProp = true,
    BloodChairOffsetZ = true,
    BloodDrawTime = true,
    BloodAnalysisTime = true,
    drawBlood = true,
    drawBloodSample = true,
    BloodDrawAnim = true,
    decayTick = true,
    Decay = true,
    decayTime = true,
    RequireAnalysis = true,
    bloodTypes = true,
}

local HOSPITAL_RUNTIME_KEYS = {
    incomingScreenProps = true,
    ScreenPropList = true,
    XrayScreenProps = true,
    TurnedOnEcgs = true,
}

local BED_RUNTIME_KEYS = {
    taken = true,
}

local OTHER_FILE_KEYS = {}

for _, keys in pairs(ConfigWriter.FILE_KEYS) do
    for _, key in ipairs(keys) do
        OTHER_FILE_KEYS[key] = true
    end
end

local function deepCopyValue(value, seen)
    local valueType = type(value)

    if valueType ~= 'table' then
        if valueType == 'vector2' or valueType == 'vector3' or valueType == 'vector4' then
            return LocationVectors.VectorToTable(value, valueType == 'vector4' and 'vector4' or 'vector3')
        end

        return value
    end

    seen = seen or {}

    if seen[value] then
        return nil
    end

    seen[value] = true

    local copied = {}

    for key, childValue in pairs(value) do
        copied[key] = deepCopyValue(childValue, seen)
    end

    seen[value] = nil

    return copied
end

local function sanitizeBedEntry(bed)
    if type(bed) ~= 'table' then
        return bed
    end

    local sanitized = deepCopyValue(bed)

    for key in pairs(BED_RUNTIME_KEYS) do
        sanitized[key] = nil
    end

    sanitized.taken = false

    return sanitized
end

local function sanitizeHospital(hospital)
    if type(hospital) ~= 'table' then
        return hospital
    end

    local sanitized = deepCopyValue(hospital)

    sanitized.jobs = nil

    for key in pairs(HOSPITAL_RUNTIME_KEYS) do
        sanitized[key] = nil
    end

    if type(sanitized.beds) == 'table' then
        for index, bed in ipairs(sanitized.beds) do
            sanitized.beds[index] = sanitizeBedEntry(bed)
        end
    end

    if type(sanitized.Xray) == 'table' then
        for index, xray in ipairs(sanitized.Xray) do
            if type(xray) == 'table' then
                local sanitizedXray = deepCopyValue(xray)
                sanitizedXray.taken = false
                sanitized.Xray[index] = sanitizedXray
            end
        end
    end

    if type(sanitized.donation) == 'table' then
        for index, donation in ipairs(sanitized.donation) do
            if type(donation) == 'table' then
                local sanitizedDonation = deepCopyValue(donation)
                sanitizedDonation.taken = false
                sanitizedDonation.inOffsetZ = nil
                sanitized.donation[index] = sanitizedDonation
            end
        end
    end

    return sanitized
end

function ConfigWriter.PrepareConfig(config)
    if type(config) ~= 'table' then
        return nil
    end

    local prepared = deepCopyValue(config)

    if type(prepared.Hospitals) == 'table' then
        for index, hospital in ipairs(prepared.Hospitals) do
            prepared.Hospitals[index] = sanitizeHospital(hospital)
        end
    end

    if type(prepared.JailBeds) == 'table' then
        for index, bed in ipairs(prepared.JailBeds) do
            prepared.JailBeds[index] = sanitizeBedEntry(bed)
        end
    end

    return prepared
end

local function writeResourceFile(resourceName, path, content)
    if SaveResourceFile(resourceName, path, content, -1) then
        return true
    end

    local resourcePath = GetResourcePath(resourceName)

    if not resourcePath or resourcePath == '' then
        return false
    end

    local fullPath = ('%s/%s'):format(resourcePath:gsub('\\', '/'), path:gsub('\\', '/'))
    local file = io.open(fullPath, 'w')

    if not file then
        return false
    end

    file:write(content)
    file:close()

    return true
end

local activePatchError = nil

local function clearPatchError()
    activePatchError = nil
end

local function setPatchError(code)
    if type(code) == 'string' and code ~= '' and not activePatchError then
        activePatchError = code
    end
end

local function getPatchError()
    return activePatchError
end

local function roundNumber(value)
    local number = tonumber(value)

    if not number then
        return 0.0
    end

    return tonumber(string.format('%.4f', number)) or 0.0
end

local function serializeString(value)
    return string.format('%q', value)
end

local function formatScalar(value)
    local valueType = type(value)

    if valueType == 'boolean' then
        return value and 'true' or 'false'
    end

    if valueType == 'number' then
        local number = tonumber(value)

        if not number then
            return nil
        end

        if number % 1 == 0 then
            return tostring(math.floor(number))
        end

        return tostring(roundNumber(number))
    end

    if valueType == 'string' then
        return serializeString(value)
    end

    return nil
end

local function normalizeCoord(value)
    if value == nil then
        return nil
    end

    local valueType = type(value)

    if valueType == 'vector3' or valueType == 'vector4' then
        return {
            x = value.x,
            y = value.y,
            z = value.z,
            w = value.w,
        }
    end

    if valueType == 'table' and value.x ~= nil and value.y ~= nil and value.z ~= nil then
        return {
            x = value.x,
            y = value.y,
            z = value.z,
            w = value.w,
        }
    end

    return nil
end

local function isArrayTable(value)
    if type(value) ~= 'table' then
        return false
    end

    local count = 0

    for key in pairs(value) do
        if type(key) ~= 'number' or key < 1 or key % 1 ~= 0 then
            return false
        end

        count = count + 1
    end

    if count == 0 then
        return false
    end

    for index = 1, count do
        if value[index] == nil then
            return false
        end
    end

    return true
end

local function shouldSkipPatchKey(key)
    return HOSPITAL_RUNTIME_KEYS[key] or BED_RUNTIME_KEYS[key]
end

local SHOP_OBJECT_KEY_ORDER = {
    id = 1,
    label = 2,
    icon = 3,
    name = 4,
    price = 5,
    type = 6,
    amount = 7,
    category = 8,
}

local FULL_REWRITE_KEYS = {
    ItemShop = true,
    ItemShopCategories = true,
    Jobs = true,
}

local function getOrderedObjectKeys(value)
    local keys = {}

    for key in pairs(value) do
        if type(key) == 'string' and not shouldSkipPatchKey(key) then
            keys[#keys + 1] = key
        end
    end

    table.sort(keys, function(a, b)
        local aOrder = SHOP_OBJECT_KEY_ORDER[a] or 100
        local bOrder = SHOP_OBJECT_KEY_ORDER[b] or 100

        if aOrder ~= bOrder then
            return aOrder < bOrder
        end

        return a < b
    end)

    return keys
end

local function serializeLuaValue(value, indent)
    indent = indent or 0
    local pad = string.rep('    ', indent)
    local childPad = string.rep('    ', indent + 1)
    local valueType = type(value)
    local formatted = formatScalar(value)

    if formatted then
        return formatted
    end

    local coord = normalizeCoord(value)

    if coord then
        if coord.w ~= nil then
            return ('vector4(%s, %s, %s, %s)'):format(
                roundNumber(coord.x or 0.0),
                roundNumber(coord.y or 0.0),
                roundNumber(coord.z or 0.0),
                roundNumber(coord.w or 0.0)
            )
        end

        return ('vector3(%s, %s, %s)'):format(
            roundNumber(coord.x or 0.0),
            roundNumber(coord.y or 0.0),
            roundNumber(coord.z or 0.0)
        )
    end

    if valueType ~= 'table' then
        return 'nil'
    end

    if isArrayTable(value) then
        if #value == 0 then
            return '{}'
        end

        local parts = { '{\n' }

        for index = 1, #value do
            parts[#parts + 1] = childPad
            parts[#parts + 1] = serializeLuaValue(value[index], indent + 1)
            parts[#parts + 1] = ',\n'
        end

        parts[#parts + 1] = pad
        parts[#parts + 1] = '}'
        return table.concat(parts)
    end

    local keys = getOrderedObjectKeys(value)

    if #keys == 0 then
        return '{}'
    end

    local parts = { '{\n' }

    for _, key in ipairs(keys) do
        local childValue = value[key]

        if childValue ~= nil then
            parts[#parts + 1] = childPad
            parts[#parts + 1] = key
            parts[#parts + 1] = ' = '
            parts[#parts + 1] = serializeLuaValue(childValue, indent + 1)
            parts[#parts + 1] = ',\n'
        end
    end

    parts[#parts + 1] = pad
    parts[#parts + 1] = '}'
    return table.concat(parts)
end

local function isCoordTableBlock(block)
    return block:match('%sx%s*=%s*[%d%.%-]+')
        and block:match('%sy%s*=%s*[%d%.%-]+')
        and block:match('%sz%s*=%s*[%d%.%-]+')
end

-- Prefer file-conventional field order when falling back to sequential patching.
local COORD_KEY_PRIORITY = {
    coords = 1,
    rotation = 2,
    bedcoords = 3,
    screencoords = 4,
    screenrotation = 5,
    screen = 6,
    bed = 7,
}

local function collectCoords(value, coords)
    if value == nil then
        return
    end

    local valueType = type(value)
    local coord = normalizeCoord(value)

    if coord then
        coords[#coords + 1] = coord
        return
    end

    if valueType ~= 'table' then
        return
    end

    if isArrayTable(value) then
        for index = 1, #value do
            collectCoords(value[index], coords)
        end
        return
    end

    local keys = {}

    for key in pairs(value) do
        if not shouldSkipPatchKey(key) then
            keys[#keys + 1] = key
        end
    end

    table.sort(keys, function(a, b)
        local aKey = tostring(a)
        local bKey = tostring(b)
        local aPriority = COORD_KEY_PRIORITY[aKey] or 50
        local bPriority = COORD_KEY_PRIORITY[bKey] or 50

        if aPriority ~= bPriority then
            return aPriority < bPriority
        end

        -- Numeric keys must sort 1,2,9,10 — not string order 1,10,2,9.
        if type(a) == 'number' and type(b) == 'number' then
            return a < b
        end

        local aNum = tonumber(a)
        local bNum = tonumber(b)

        if aNum and bNum then
            return aNum < bNum
        end

        return aKey < bKey
    end)

    for _, key in ipairs(keys) do
        collectCoords(value[key], coords)
    end
end

local function patchAxisValues(block, coord)
    local patched = block

    for _, axis in ipairs({ 'x', 'y', 'z', 'w' }) do
        if coord[axis] ~= nil then
            local numberText = tostring(roundNumber(coord[axis]))
            local pattern = '(%s' .. axis .. '%s*=%s*)([%d%.%-]+)'

            if patched:find(pattern) then
                patched = patched:gsub(pattern, '%1' .. numberText, 1)
            end
        end
    end

    return patched
end

local function patchVectorLiteral(literal, coord, isVector4)
    if isVector4 then
        return ('vector4(%s, %s, %s, %s)'):format(
            roundNumber(coord.x or 0.0),
            roundNumber(coord.y or 0.0),
            roundNumber(coord.z or 0.0),
            roundNumber(coord.w or 0.0)
        )
    end

    return ('vector3(%s, %s, %s)'):format(
        roundNumber(coord.x or 0.0),
        roundNumber(coord.y or 0.0),
        roundNumber(coord.z or 0.0)
    )
end

local function findMatchingBrace(content, openPos)
    local depth = 0
    local i = openPos
    local inString

    while i <= #content do
        local char = content:sub(i, i)
        local comment = content:sub(i, i + 1)

        if inString then
            if char == '\\' then
                i = i + 2
            elseif char == inString then
                inString = nil
                i = i + 1
            else
                i = i + 1
            end
        elseif comment == '--' then
            local lineEnd = content:find('\n', i + 2)

            if lineEnd then
                i = lineEnd + 1
            else
                break
            end
        elseif char == '"' or char == "'" then
            inString = char
            i = i + 1
        elseif char == '{' then
            depth = depth + 1
            i = i + 1
        elseif char == '}' then
            depth = depth - 1

            if depth == 0 then
                return i
            end

            i = i + 1
        else
            i = i + 1
        end
    end

    return nil
end

local function patchScalarFields(inner, value)
    if type(value) ~= 'table' then
        return inner
    end

    local patched = inner

    for key, childValue in pairs(value) do
        if not shouldSkipPatchKey(key) then
            local formatted = formatScalar(childValue)

            if formatted then
                local pattern = '(%s' .. key .. '%s*=%s*)([^\n\r,}]+)'

                if patched:find(pattern) then
                    patched = patched:gsub(pattern, '%1' .. formatted, 1)
                end
            end
        end
    end

    return patched
end

local function patchCoordExpressions(text, coords, coordIndex)
    coordIndex = coordIndex or 0
    local i = 1
    local parts = {}

    while i <= #text do
        if text:sub(i, i + 7) == 'vector4(' then
            local closeIndex = text:find(')', i)

            if not closeIndex then
                setPatchError('unclosed_vector4_literal')
                parts[#parts + 1] = text:sub(i)
                break
            end

            local literal = text:sub(i, closeIndex)
            coordIndex = coordIndex + 1

            if coords[coordIndex] then
                parts[#parts + 1] = patchVectorLiteral(literal, coords[coordIndex], true)
            else
                parts[#parts + 1] = literal
            end

            i = closeIndex + 1
        elseif text:sub(i, i + 7) == 'vector3(' then
            local closeIndex = text:find(')', i)

            if not closeIndex then
                setPatchError('unclosed_vector3_literal')
                parts[#parts + 1] = text:sub(i)
                break
            end

            local literal = text:sub(i, closeIndex)
            coordIndex = coordIndex + 1

            if coords[coordIndex] then
                parts[#parts + 1] = patchVectorLiteral(literal, coords[coordIndex], false)
            else
                parts[#parts + 1] = literal
            end

            i = closeIndex + 1
        elseif text:sub(i, i) == '{' then
            local closeIndex = findMatchingBrace(text, i)

            if not closeIndex then
                setPatchError('unbalanced_brace_in_coords')
                parts[#parts + 1] = text:sub(i)
                break
            end

            local block = text:sub(i, closeIndex)

            if isCoordTableBlock(block) then
                coordIndex = coordIndex + 1

                if coords[coordIndex] then
                    parts[#parts + 1] = patchAxisValues(block, coords[coordIndex])
                else
                    parts[#parts + 1] = block
                end
            else
                local inner = text:sub(i + 1, closeIndex - 1)
                local patchedInner
                patchedInner, coordIndex = patchCoordExpressions(inner, coords, coordIndex)
                parts[#parts + 1] = '{' .. patchedInner .. '}'
            end

            i = closeIndex + 1
        else
            parts[#parts + 1] = text:sub(i, i)
            i = i + 1
        end
    end

    return table.concat(parts), coordIndex
end

local function isObjectWithNamedCoords(value)
    if type(value) ~= 'table' or isArrayTable(value) or normalizeCoord(value) then
        return false
    end

    for key, childValue in pairs(value) do
        if type(key) == 'string' and not shouldSkipPatchKey(key) then
            if normalizeCoord(childValue) then
                return true
            end

            if type(childValue) == 'table' and not isArrayTable(childValue) then
                for nestedKey, nestedValue in pairs(childValue) do
                    if type(nestedKey) == 'string' and normalizeCoord(nestedValue) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function patchNamedVectorAssignments(text, objectValue)
    if type(objectValue) ~= 'table' then
        return text
    end

    local patched = text

    for key, childValue in pairs(objectValue) do
        if type(key) == 'string' and not shouldSkipPatchKey(key) then
            local coord = normalizeCoord(childValue)

            if coord then
                -- Frontier pattern avoids matching "coords" inside "bedcoords" and
                -- still matches "{coords = ..." / " coords = ..." forms.
                local prefixPattern = '(%f[%w_]' .. key .. '%s*=%s*)'
                local vector4Pattern = prefixPattern .. 'vector4%([^%)]+%)'
                local vector3Pattern = prefixPattern .. 'vector3%([^%)]+%)'

                if patched:find(vector4Pattern) then
                    patched = patched:gsub(vector4Pattern, '%1' .. patchVectorLiteral(nil, coord, true), 1)
                elseif patched:find(vector3Pattern) then
                    patched = patched:gsub(vector3Pattern, '%1' .. patchVectorLiteral(nil, coord, false), 1)
                end
            end
        end
    end

    return patched
end

local function patchNestedObjectSection(text, sectionKey, sectionValue)
    if type(sectionValue) ~= 'table' then
        return text
    end

    local sectionStart = text:find('%f[%w_]' .. sectionKey .. '%s*=%s*{')

    if not sectionStart then
        return text
    end

    local openPos = text:find('{', sectionStart)

    if not openPos then
        setPatchError(('missing_section_brace_%s'):format(sectionKey))
        return text
    end

    local closePos = findMatchingBrace(text, openPos)

    if not closePos then
        setPatchError(('unbalanced_brace_in_section_%s'):format(sectionKey))
        return text
    end

    local sectionInner = text:sub(openPos + 1, closePos - 1)
    local patchedInner = patchScalarFields(sectionInner, sectionValue)
    patchedInner = patchNamedVectorAssignments(patchedInner, sectionValue)

    for key, childValue in pairs(sectionValue) do
        if type(key) == 'string'
            and type(childValue) == 'table'
            and not normalizeCoord(childValue)
            and not isArrayTable(childValue)
        then
            patchedInner = patchNestedObjectSection(patchedInner, key, childValue)
        end
    end

    return text:sub(1, openPos) .. patchedInner .. text:sub(closePos)
end

local function patchObjectEntryBlock(block, objectValue)
    local inner = block:sub(2, #block - 1)
    local patched = patchScalarFields(inner, objectValue)
    patched = patchNamedVectorAssignments(patched, objectValue)

    for key, childValue in pairs(objectValue) do
        if type(key) == 'string'
            and type(childValue) == 'table'
            and not normalizeCoord(childValue)
            and not isArrayTable(childValue)
        then
            patched = patchNestedObjectSection(patched, key, childValue)
        end
    end

    return '{' .. patched .. '}'
end

local function patchObjectArrayInner(inner, array)
    local parts = {}
    local i = 1
    local entryIndex = 0

    while i <= #inner do
        if inner:sub(i, i) == '{' then
            local closeIndex = findMatchingBrace(inner, i)

            if not closeIndex then
                setPatchError('unbalanced_brace_in_array')
                parts[#parts + 1] = inner:sub(i)
                break
            end

            entryIndex = entryIndex + 1
            local block = inner:sub(i, closeIndex)
            local entry = array[entryIndex]

            if entry and isObjectWithNamedCoords(entry) then
                parts[#parts + 1] = patchObjectEntryBlock(block, entry)
            elseif entry then
                local coords = {}
                collectCoords(entry, coords)
                local blockInner = block:sub(2, #block - 1)
                local patchedInner = patchScalarFields(blockInner, entry)
                patchedInner = select(1, patchCoordExpressions(patchedInner, coords, 0))
                parts[#parts + 1] = '{' .. patchedInner .. '}'
            else
                parts[#parts + 1] = block
            end

            i = closeIndex + 1
        else
            parts[#parts + 1] = inner:sub(i, i)
            i = i + 1
        end
    end

    return table.concat(parts)
end

local function countCoordExpressions(text)
    local count = 0
    local i = 1

    while i <= #text do
        if text:sub(i, i + 7) == 'vector4(' or text:sub(i, i + 7) == 'vector3(' then
            local closeIndex = text:find(')', i)

            if not closeIndex then
                setPatchError(text:sub(i, i + 7) == 'vector4(' and 'unclosed_vector4_literal' or 'unclosed_vector3_literal')
                break
            end

            count = count + 1
            i = closeIndex + 1
        elseif text:sub(i, i) == '{' then
            local closeIndex = findMatchingBrace(text, i)

            if not closeIndex then
                setPatchError('unbalanced_brace_in_coords')
                break
            end

            local block = text:sub(i, closeIndex)

            if isCoordTableBlock(block) then
                count = count + 1
                i = closeIndex + 1
            else
                count = count + countCoordExpressions(text:sub(i + 1, closeIndex - 1))
                i = closeIndex + 1
            end
        else
            i = i + 1
        end
    end

    return count
end

local function getIndentLevelAt(text, pos)
    local lineStart = pos

    while lineStart > 1 and text:sub(lineStart - 1, lineStart - 1) ~= '\n' do
        lineStart = lineStart - 1
    end

    local spaces = 0

    while text:sub(lineStart + spaces, lineStart + spaces) == ' ' do
        spaces = spaces + 1
    end

    return math.floor(spaces / 4)
end

-- A hospital block may not contain every section (e.g. no `vehicle = {}`).
-- Without this, locations added to a missing section were kept in memory and
-- reported as saved, but never written to config/locations.lua.
local function insertMissingSection(block, sectionKey, newValue)
    if type(newValue) ~= 'table' or next(newValue) == nil then
        return block
    end

    if block:sub(-1) ~= '}' then
        setPatchError(('cannot_insert_section_%s'):format(sectionKey))
        return block
    end

    local body = block:sub(1, -2):gsub('%s+$', '')
    local indent = getIndentLevelAt(block, #block) + 1
    local pad = string.rep('    ', indent)
    local lastChar = body:sub(-1)
    local separator = (lastChar == ',' or lastChar == '{') and '' or ','
    local serialized = serializeLuaValue(newValue, indent)

    return ('%s%s\n%s%s = %s,\n%s}'):format(
        body, separator, pad, sectionKey, serialized, string.rep('    ', indent - 1)
    )
end

local function patchSectionAssignment(inner, sectionKey, newValue)
    if type(newValue) ~= 'table' then
        return inner
    end

    local sectionStart = inner:find(sectionKey .. '%s*=%s*{')

    if not sectionStart then
        return insertMissingSection(inner, sectionKey, newValue)
    end

    local openPos = inner:find('{', sectionStart)

    if not openPos then
        setPatchError(('missing_section_brace_%s'):format(sectionKey))
        return inner
    end

    local closePos = findMatchingBrace(inner, openPos)

    if not closePos then
        setPatchError(('unbalanced_brace_in_section_%s'):format(sectionKey))
        return inner
    end

    local sectionInner = inner:sub(openPos + 1, closePos - 1)
    local newCoords = {}
    collectCoords(newValue, newCoords)

    -- In-place vector patching cannot insert/remove entries. Rewrite the whole
    -- section when the coordinate count changes (add/remove from configurator).
    local coordCount = countCoordExpressions(sectionInner)

    if getPatchError() then
        return inner
    end

    if #newCoords ~= coordCount then
        local rewritten = serializeLuaValue(newValue, getIndentLevelAt(inner, sectionStart))
        return inner:sub(1, openPos - 1) .. rewritten .. inner:sub(closePos + 1)
    end

    local patchedInner = patchTableInner(sectionInner, newValue)

    if getPatchError() then
        return inner
    end

    return inner:sub(1, openPos) .. patchedInner .. inner:sub(closePos)
end

local function forceRewriteSection(inner, sectionKey, newValue)
    if type(newValue) ~= 'table' then
        return inner
    end

    local sectionStart = inner:find(sectionKey .. '%s*=%s*{')

    if not sectionStart then
        return inner
    end

    local openPos = inner:find('{', sectionStart)

    if not openPos then
        return inner
    end

    local closePos = findMatchingBrace(inner, openPos)

    if not closePos then
        setPatchError(('unbalanced_brace_in_section_%s'):format(sectionKey))
        return inner
    end

    local rewritten = serializeLuaValue(newValue, getIndentLevelAt(inner, sectionStart))
    return inner:sub(1, openPos - 1) .. rewritten .. inner:sub(closePos + 1)
end

local function patchHospitalBlock(block, hospital)
    if type(hospital) ~= 'table' then
        return block
    end

    local patched = patchScalarFields(block, hospital)

    local objectSections = { 'blip' }

    for _, sectionKey in ipairs(objectSections) do
        if hospital[sectionKey] then
            patched = patchSectionAssignment(patched, sectionKey, hospital[sectionKey])
        end
    end

    local arraySections = {
        'checking', 'pharmacy', 'duty', 'vehicle', 'helicopter', 'shop', 'stash',
        'bloodstorage', 'bloodanalysis', 'donation', 'beds', 'Xray', 'IncomingScreenPos',
        'IncomingScreenSoundPos', 'StationaryECG', 'elevator', 'boss', 'cloakroom',
    }

    for _, sectionKey in ipairs(arraySections) do
        if hospital[sectionKey] then
            if sectionKey == 'elevator' then
                patched = forceRewriteSection(patched, sectionKey, hospital[sectionKey])
            else
                patched = patchSectionAssignment(patched, sectionKey, hospital[sectionKey])
            end
        end
    end

    return patched
end

local function patchHospitalsInner(inner, hospitals)
    if type(hospitals) ~= 'table' then
        return inner
    end

    local parts = {}
    local i = 1
    local hospitalIndex = 0

    while i <= #inner do
        if inner:sub(i, i) == '{' then
            local closeIndex = findMatchingBrace(inner, i)

            if not closeIndex then
                setPatchError(('unbalanced_brace_in_Hospitals_at_%d'):format(hospitalIndex + 1))
                parts[#parts + 1] = inner:sub(i)
                break
            end

            hospitalIndex = hospitalIndex + 1
            local block = inner:sub(i, closeIndex)

            if hospitals[hospitalIndex] then
                parts[#parts + 1] = patchHospitalBlock(block, hospitals[hospitalIndex])

                if getPatchError() then
                    break
                end
            else
                parts[#parts + 1] = block
            end

            i = closeIndex + 1
        else
            parts[#parts + 1] = inner:sub(i, i)
            i = i + 1
        end
    end

    return table.concat(parts)
end

function patchTableInner(inner, value, keyName)
    if keyName == 'Hospitals' then
        return patchHospitalsInner(inner, value)
    end

    local newCoords = {}
    collectCoords(value, newCoords)

    local coordCount = countCoordExpressions(inner)

    if getPatchError() then
        return inner
    end

    -- Same limitation as hospital sections: in-place patching cannot grow/shrink arrays.
    if type(value) == 'table' and #newCoords ~= coordCount then
        local rewritten = serializeLuaValue(value, 0)

        if rewritten:sub(1, 1) == '{' and rewritten:sub(-1) == '}' then
            return rewritten:sub(2, #rewritten - 1)
        end

        return rewritten
    end

    -- Objects with named coord fields (e.g. StationaryECG coords/bedcoords) must be
    -- patched by field name. Sequential vector patching can swap values when key
    -- iteration order differs from file order.
    if isArrayTable(value) and value[1] and isObjectWithNamedCoords(value[1]) then
        return patchObjectArrayInner(inner, value)
    end

    if isObjectWithNamedCoords(value) then
        local patched = patchScalarFields(inner, value)
        return patchNamedVectorAssignments(patched, value)
    end

    local coords = {}
    collectCoords(value, coords)

    local patched = patchScalarFields(inner, value)
    patched = select(1, patchCoordExpressions(patched, coords, 0))

    return patched
end

local function getPatchBoundary(content, path)
    local marker = ConfigWriter.PRESERVE_SUFFIX[path]

    if marker then
        local markerIndex = content:find(marker, 1, true)

        if markerIndex then
            return markerIndex - 1
        end
    end

    return #content
end

local function findAssignmentRange(content, key, boundary)
    local pattern = 'Config%.' .. key .. '%s*='
    local startPos, endPos = content:find(pattern)

    if not startPos or startPos > boundary then
        return nil
    end

    local equalsPos = content:find('=', startPos)
    local valueStart = equalsPos + 1

    while valueStart <= #content and content:sub(valueStart, valueStart):match('%s') do
        valueStart = valueStart + 1
    end

    local firstChar = content:sub(valueStart, valueStart)

    if firstChar == '{' then
        local closePos = findMatchingBrace(content, valueStart)

        if not closePos or closePos > boundary then
            return nil
        end

        return startPos, closePos
    end

    if content:sub(valueStart, valueStart + 7) == 'vector4(' or content:sub(valueStart, valueStart + 7) == 'vector3(' then
        local closePos = content:find(')', valueStart)

        if not closePos then
            return nil
        end

        return startPos, closePos
    end

    local lineEnd = content:find('\n', valueStart)

    if not lineEnd or lineEnd > boundary then
        lineEnd = boundary + 1
    end

    return startPos, lineEnd - 1
end

local function patchSimpleAssignment(content, key, value, boundary)
    local rangeStart, rangeEnd = findAssignmentRange(content, key, boundary)

    if not rangeStart then
        return content, false
    end

    local equalsPos = content:find('=', rangeStart)
    local valueStart = equalsPos + 1

    while valueStart <= #content and content:sub(valueStart, valueStart):match('%s') do
        valueStart = valueStart + 1
    end

    local firstChar = content:sub(valueStart, valueStart)
    local formatted = formatScalar(value)

    if firstChar == '{' then
        if FULL_REWRITE_KEYS[key] then
            local rewritten = serializeLuaValue(value, 0)
            local openLineEnd = content:find('\n', valueStart) or (rangeEnd + 1)
            local openLine = content:sub(valueStart, openLineEnd - 1)
            local commentStart = openLine:find('%-%-')

            if commentStart and rewritten:sub(1, 1) == '{' then
                local comment = openLine:sub(commentStart):gsub('%s+$', '')
                rewritten = '{ ' .. comment .. rewritten:sub(2)
            end

            return content:sub(1, valueStart - 1) .. rewritten .. content:sub(rangeEnd + 1), true
        end

        local inner = content:sub(valueStart + 1, rangeEnd - 1)
        local patchedInner = patchTableInner(inner, value, key)

        return content:sub(1, valueStart) .. patchedInner .. content:sub(rangeEnd, rangeEnd) .. content:sub(rangeEnd + 1), true
    end

    if formatted then
        local line = content:sub(rangeStart, rangeEnd)
        local commentStart = line:find('%-%-')
        local prefix = content:sub(rangeStart, equalsPos) .. ' '
        local suffix = commentStart and (' ' .. line:sub(commentStart)) or ''

        return content:sub(1, rangeStart - 1) .. prefix .. formatted .. suffix .. content:sub(rangeEnd + 1), true
    end

    return content, false
end

local function getGeneralKeys(config, changedKeys)
    local keys = {}

    for key in pairs(changedKeys or config) do
        if not RUNTIME_ONLY_KEYS[key] and not OTHER_FILE_KEYS[key] then
            keys[#keys + 1] = key
        end
    end

    table.sort(keys)
    return keys
end

local function getChangedKeysForFile(path, changedKeys)
    local keys = {}

    if path == 'config/general.lua' then
        return getGeneralKeys(nil, changedKeys)
    end

    for _, key in ipairs(ConfigWriter.FILE_KEYS[path] or {}) do
        if changedKeys[key] ~= nil then
            keys[#keys + 1] = key
        end
    end

    return keys
end

local function patchFileContent(content, path, config, changedKeys)
    local boundary = getPatchBoundary(content, path)
    local keys = getChangedKeysForFile(path, changedKeys)
    local patchedAny = false

    for _, key in ipairs(keys) do
        local value = config[key]

        if value ~= nil then
            local updated, patched = patchSimpleAssignment(content, key, value, boundary)

            if getPatchError() then
                return content, false
            end

            if patched then
                content = updated
                patchedAny = true
            end
        end
    end

    return content, patchedAny
end

local function getFilePathForKey(key)
    for path, keys in pairs(ConfigWriter.FILE_KEYS) do
        for _, fileKey in ipairs(keys) do
            if fileKey == key then
                return path
            end
        end
    end

    if not RUNTIME_ONLY_KEYS[key] and not OTHER_FILE_KEYS[key] then
        return 'config/general.lua'
    end

    return nil
end

local function sanitizeErrorMessage(message)
    message = tostring(message or 'unknown_error')
    message = message:gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
    return message:sub(1, 160)
end

local function saveConfigFiles(resourceName, config, changedKeys)
    clearPatchError()

    config = ConfigWriter.PrepareConfig(config)

    if type(config) ~= 'table' then
        return false, 'invalid_config'
    end

    local filesToPatch = {}

    for key in pairs(changedKeys) do
        local path = getFilePathForKey(key)

        if path then
            filesToPatch[path] = true
        end
    end

    if not next(filesToPatch) then
        return false, 'nothing_to_save'
    end

    local savedFiles = {}

    for path in pairs(filesToPatch) do
        clearPatchError()

        local content = LoadResourceFile(resourceName, path)

        if not content or content == '' then
            return false, ('missing_file_%s'):format(path)
        end

        local patchedContent, patchedAny = patchFileContent(content, path, config, changedKeys)
        local patchError = getPatchError()

        if patchError then
            return false, ('%s:%s'):format(path, patchError)
        end

        if not patchedAny then
            return false, ('nothing_patched_%s'):format(path)
        end

        if not writeResourceFile(resourceName, path, patchedContent) then
            return false, ('failed_to_write_%s'):format(path)
        end

        savedFiles[#savedFiles + 1] = path
    end

    table.sort(savedFiles)

    return true, savedFiles
end

function ConfigWriter.Save(resourceName, config, changedKeys)
    resourceName = resourceName or GetCurrentResourceName()
    changedKeys = changedKeys or config

    local ok, saved, saveResult = pcall(saveConfigFiles, resourceName, config, changedKeys)

    if not ok then
        local message = sanitizeErrorMessage(saved)
        print(('^1[osp_ambulance] ConfigWriter.Save crashed: %s^0'):format(message))
        return false, ('save_crash:%s'):format(message)
    end

    return saved, saveResult
end

SaveConfigToFiles = ConfigWriter.Save
