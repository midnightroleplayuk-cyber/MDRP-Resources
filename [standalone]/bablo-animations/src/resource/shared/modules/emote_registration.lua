eventName = eventName or 'bablo-animations:'

local IS_SERVER = IsDuplicityVersion()
local RESOURCE = GetCurrentResourceName()

local TARGETS = {
    emotes    = { file = 'animations/emotes.lua',    table = 'Emotes' },
    dances    = { file = 'animations/dances.lua',    table = 'Dances' },
    props     = { file = 'animations/props.lua',     table = 'Props' },
    invehicle = { file = 'animations/invehicle.lua', table = 'InVehicle' },
    animal    = { file = 'animations/animal.lua',    table = 'Animal' },
}

local HASH_TABLES = { 'Emotes', 'Props', 'Dances', 'InVehicle', 'Animal', 'Sequences' }
local ARRAY_TABLES = { 'Walks', 'Expressions', 'Shared', 'WeaponStyles' }

local ALLOWED_OPTIONS = {
    prop = true,
    propBone = true,
    propPlacement = true,
    secondProp = true,
    secondPropBone = true,
    secondPropPlacement = true,
    emoteLoop = true,
    emoteMoving = true,
    emoteDuration = true,
    emoteStuck = true,
    emoteFreezeLastFrame = true,
    onlyInVehicle = true,
    onlyAnimals = true,
    onlyOnFoot = true,
    attachTo = true,
    syncOffset = true,
    syncOffsetFront = true,
    syncOffsetSide = true,
    syncOffsetHeading = true,
    syncOffsetHeight = true,
    customMovementType = true,
    bone = true,
    xPos = true,
    yPos = true,
    zPos = true,
    xRot = true,
    yRot = true,
    zRot = true,
    ptfxAsset = true,
    ptfxName = true,
    ptfxScale = true,
    ptfxPlacement = true,
    ptfxOffset = true,
    ptfxOffsetFront = true,
    ptfxOffsetSide = true,
    ptfxOffsetHeading = true,
    ptfxOffsetHeight = true,
    ptfxBone = true,
    ptfxWait = true,
    ptfxCanHold = true,
    ptfxNoProp = true,
    ptfxUseSecondProp = true,
    ptfxInfo = true,
    ptfxColor = true,
    musicURL = true,
    skip = true,
    group = true,
    hide = true,
    jobs = true,
    editAnimSpeed = true,
    onCancelEmote = true,
}

local OPTION_ALIASES = {
    Prop = 'prop',
    PropBone = 'propBone',
    PropPlacement = 'propPlacement',
    SecondProp = 'secondProp',
    SecondPropBone = 'secondPropBone',
    SecondPropPlacement = 'secondPropPlacement',
    EmoteLoop = 'emoteLoop',
    EmoteMoving = 'emoteMoving',
    EmoteDuration = 'emoteDuration',
    EmoteStuck = 'emoteStuck',
    EmoteFreezeLastFrame = 'emoteFreezeLastFrame',
    OnlyInVehicle = 'onlyInVehicle',
    OnlyAnimals = 'onlyAnimals',
    OnlyOnFoot = 'onlyOnFoot',
    Attachto = 'attachTo',
    AttachTo = 'attachTo',
    SyncOffset = 'syncOffset',
    SyncOffsetFront = 'syncOffsetFront',
    SyncOffsetSide = 'syncOffsetSide',
    SyncOffsetHeading = 'syncOffsetHeading',
    SyncOffsetHeight = 'syncOffsetHeight',
    Flag = 'customMovementType',
    CustomMovementType = 'customMovementType',
    Bone = 'bone',
    PtfxAsset = 'ptfxAsset',
    PtfxName = 'ptfxName',
    PtfxScale = 'ptfxScale',
    PtfxPlacement = 'ptfxPlacement',
    PtfxOffset = 'ptfxOffset',
    PtfxOffsetFront = 'ptfxOffsetFront',
    PtfxOffsetSide = 'ptfxOffsetSide',
    PtfxOffsetHeading = 'ptfxOffsetHeading',
    PtfxOffsetHeight = 'ptfxOffsetHeight',
    PtfxBone = 'ptfxBone',
    PtfxWait = 'ptfxWait',
    PtfxCanHold = 'ptfxCanHold',
    PtfxNoProp = 'ptfxNoProp',
    PtfxUseSecondProp = 'ptfxUseSecondProp',
    PtfxInfo = 'ptfxInfo',
    PtfxColor = 'ptfxColor',
    MusicURL = 'musicURL',
    Skip = 'skip',
    SkipRequest = 'skip',
    Group = 'group',
    Hide = 'hide',
    Jobs = 'jobs',
    EditAnimSpeed = 'editAnimSpeed',
    ExitEmote = 'onCancelEmote',
    OnCancelEmote = 'onCancelEmote',
}

local MAX_MOVEMENT_TYPE = 1048575

local OPTION_VALIDATORS = {
    customMovementType = function(value)
        if type(value) ~= 'number' then return nil end
        if value ~= value or value == math.huge or value == -math.huge then return nil end

        local flag = math.floor(value)

        if flag < 0 then flag = 0 end
        if flag > MAX_MOVEMENT_TYPE then flag = MAX_MOVEMENT_TYPE end

        return math.tointeger(flag) or flag
    end,
}

local function fail(reason)
    return { ok = false, error = reason }
end

local function isCleanString(value, maxLength)
    if type(value) ~= 'string' then return false end
    if #value == 0 or #value > maxLength then return false end
    if value:find('%c') then return false end
    return true
end

local function resolveTarget(target)
    if target == nil then return TARGETS.emotes, 'emotes' end
    if type(target) ~= 'string' then return nil end
    local key = target:lower():gsub('%.lua$', '')
    key = key:gsub('[^a-z]', '')
    local entry = TARGETS[key]
    if not entry then return nil end
    return entry, key
end

local function keyExists(name)
    if type(Config) ~= 'table' or type(name) ~= 'string' or name == '' then return false end

    for _, tableName in ipairs(HASH_TABLES) do
        local tbl = Config[tableName]
        if type(tbl) == 'table' and tbl[name] ~= nil then
            return true, 'Config.' .. tableName
        end
    end

    for _, tableName in ipairs(ARRAY_TABLES) do
        local tbl = Config[tableName]
        if type(tbl) == 'table' then
            for _, entry in ipairs(tbl) do
                if type(entry) == 'table' and tostring(entry.name) == name then
                    return true, 'Config.' .. tableName
                end
            end
        end
    end

    for _, containerName in ipairs({ 'Convert', 'Custom' }) do
        local container = Config[containerName]
        if type(container) == 'table' then
            for subName, subTable in pairs(container) do
                if type(subTable) == 'table' and subTable[name] ~= nil then
                    return true, 'Config.' .. containerName .. '.' .. tostring(subName)
                end
            end
        end
    end

    return false
end

local function isArray(tbl)
    local count = 0
    for key in pairs(tbl) do
        if type(key) ~= 'number' then return false end
        count = count + 1
    end
    if count == 0 then return false end
    for index = 1, count do
        if tbl[index] == nil then return false end
    end
    return true
end

local function sanitizeValue(value, depth)
    local valueType = type(value)

    if valueType == 'string' then
        if #value == 0 or #value > 256 or value:find('%c') then return nil end
        return value
    end

    if valueType == 'number' then
        if value ~= value or value == math.huge or value == -math.huge then return nil end
        return value
    end

    if valueType == 'boolean' then
        return value
    end

    if valueType == 'table' and depth < 3 then
        local out = {}

        if isArray(value) then
            for index = 1, #value do
                local sanitized = sanitizeValue(value[index], depth + 1)
                if sanitized == nil then return nil end
                out[index] = sanitized
            end
            return out
        end

        local count = 0
        for key, entry in pairs(value) do
            if type(key) ~= 'string' or not key:find('^[%a_][%w_]*$') then return nil end
            local sanitized = sanitizeValue(entry, depth + 1)
            if sanitized == nil then return nil end
            out[key] = sanitized
            count = count + 1
        end

        if count == 0 then return nil end
        return out
    end

    return nil
end

local function sanitizeOption(canonicalKey, rawValue)
    local sanitized = sanitizeValue(rawValue, 1)

    if sanitized == nil then return nil end

    local validator = OPTION_VALIDATORS[canonicalKey]

    if validator then
        return validator(sanitized)
    end

    return sanitized
end

local function sanitizeOptions(options)
    if options == nil then return nil end
    if type(options) ~= 'table' then return nil end

    local out, count = {}, 0

    for rawKey, rawValue in pairs(options) do
        if type(rawKey) == 'string' and ALLOWED_OPTIONS[rawKey] then
            local sanitized = sanitizeOption(rawKey, rawValue)
            if sanitized ~= nil then
                out[rawKey] = sanitized
                count = count + 1
            end
        end
    end

    for rawKey, rawValue in pairs(options) do
        if type(rawKey) == 'string' then
            local canonical = OPTION_ALIASES[rawKey]
            if canonical and out[canonical] == nil then
                local sanitized = sanitizeOption(canonical, rawValue)
                if sanitized ~= nil then
                    out[canonical] = sanitized
                    count = count + 1
                end
            end
        end
    end

    if count == 0 then return nil end
    return out
end

local serializeValue

local function serializeNumber(value)
    if math.type(value) == 'integer' then return tostring(value) end
    local text = string.format('%.14g', value)
    if not text:find('[%.eE]') then text = text .. '.0' end
    return text
end

local function serializeTable(tbl, indent, unit)
    unit = unit or '    '

    local pad = string.rep(unit, indent)
    local innerPad = string.rep(unit, indent + 1)

    if isArray(tbl) then
        local scalarOnly = true
        for index = 1, #tbl do
            if type(tbl[index]) == 'table' then
                scalarOnly = false
                break
            end
        end

        local parts = {}
        for index = 1, #tbl do
            parts[#parts + 1] = serializeValue(tbl[index], indent + 1, unit)
        end

        if scalarOnly then
            return '{ ' .. table.concat(parts, ', ') .. ' }'
        end

        for index = 1, #parts do
            parts[index] = innerPad .. parts[index]
        end
        return '{\n' .. table.concat(parts, ',\n') .. '\n' .. pad .. '}'
    end

    local keys = {}
    for key in pairs(tbl) do
        keys[#keys + 1] = key
    end
    table.sort(keys)

    local lines = {}
    for _, key in ipairs(keys) do
        lines[#lines + 1] = innerPad .. key .. ' = ' .. serializeValue(tbl[key], indent + 1, unit)
    end

    return '{\n' .. table.concat(lines, ',\n') .. '\n' .. pad .. '}'
end

serializeValue = function(value, indent, unit)
    local valueType = type(value)
    if valueType == 'string' then return string.format('%q', value) end
    if valueType == 'number' then return serializeNumber(value) end
    if valueType == 'boolean' then return tostring(value) end
    if valueType == 'table' then return serializeTable(value, indent, unit) end
    return 'nil'
end

local function buildAssignment(tableName, key, dict, clip, label, options)
    local lines = {}

    lines[#lines + 1] = string.format('Config.%s[%q] = {', tableName, key)
    lines[#lines + 1] = string.format('    %q,', dict)
    lines[#lines + 1] = string.format('    %q,', clip)

    if options then
        lines[#lines + 1] = string.format('    %q,', label)
        lines[#lines + 1] = '    animationOptions = ' .. serializeTable(options, 1, '    ')
    else
        lines[#lines + 1] = string.format('    %q', label)
    end

    lines[#lines + 1] = '}'

    return table.concat(lines, '\n')
end

local function buildEntry(key, dict, clip, label, options, unit)
    unit = unit or '    '

    local pad1 = unit
    local pad2 = unit .. unit
    local lines = {}

    lines[#lines + 1] = pad1 .. string.format('[%q] = {', key)
    lines[#lines + 1] = pad2 .. string.format('%q,', dict)
    lines[#lines + 1] = pad2 .. string.format('%q,', clip)

    if options then
        lines[#lines + 1] = pad2 .. string.format('%q,', label)
        lines[#lines + 1] = pad2 .. 'animationOptions = ' .. serializeTable(options, 2, unit)
    else
        lines[#lines + 1] = pad2 .. string.format('%q', label)
    end

    lines[#lines + 1] = pad1 .. '},'

    return table.concat(lines, '\n')
end

local function findTableBounds(content, tableName)
    local anchor = 'Config.' .. tableName
    local anchorLen = #anchor
    local total = #content
    local index = 1
    local openIndex, closeIndex, lastSignificant
    local depth = 0
    local inTable = false

    while index <= total do
        local char = content:sub(index, index)

        if char == '-' and content:sub(index + 1, index + 1) == '-' then
            local level = content:match('^%[(=*)%[', index + 2)

            if level then
                local closer = ']' .. level .. ']'
                local stop = content:find(closer, index + 4 + #level, true)
                if not stop then return nil end
                index = stop + #closer
            else
                local stop = content:find('\n', index, true)
                if not stop then break end
                index = stop + 1
            end
        elseif char == '"' or char == "'" then
            local quote = char
            local cursor = index + 1
            local closed = false

            while cursor <= total do
                local inner = content:sub(cursor, cursor)

                if inner == '\\' then
                    cursor = cursor + 2
                elseif inner == quote then
                    cursor = cursor + 1
                    closed = true
                    break
                elseif inner == '\n' then
                    return nil
                else
                    cursor = cursor + 1
                end
            end

            if not closed then return nil end

            lastSignificant = cursor - 1
            index = cursor
        elseif char == '[' and content:match('^%[=*%[', index) then
            local level = content:match('^%[(=*)%[', index)
            local closer = ']' .. level .. ']'
            local stop = content:find(closer, index + 2 + #level, true)
            if not stop then return nil end
            lastSignificant = stop + #closer - 1
            index = stop + #closer
        elseif inTable and char == '{' then
            depth = depth + 1
            lastSignificant = index
            index = index + 1
        elseif inTable and char == '}' then
            depth = depth - 1

            if depth == 0 then
                closeIndex = index
                break
            end

            lastSignificant = index
            index = index + 1
        elseif not inTable and char == 'C' and content:sub(index, index + anchorLen - 1) == anchor then
            local previous = index > 1 and content:sub(index - 1, index - 1) or ''
            local _, stop = content:find('^%s*=%s*{', index + anchorLen)

            if stop and not previous:find('[%w_%.]') then
                openIndex = stop
                lastSignificant = stop
                depth = 1
                inTable = true
                index = stop + 1
            else
                index = index + 1
            end
        else
            if char:find('%S') then lastSignificant = index end
            index = index + 1
        end
    end

    if not openIndex or not closeIndex or not lastSignificant then return nil end
    if lastSignificant >= closeIndex then return nil end

    return openIndex, closeIndex, lastSignificant
end

local function insertIntoTable(content, tableName, key, dict, clip, label, options)
    local openIndex, closeIndex, lastSignificant = findTableBounds(content, tableName)

    if not openIndex then return nil end

    local unit = '    '
    local found, _, detected = content:find('\n([ \t]+)%S', openIndex)

    if found and detected and found < closeIndex then
        unit = detected
    end

    local lastChar = content:sub(lastSignificant, lastSignificant)
    local comma = (lastChar == ',' or lastChar == '{') and '' or ','
    local head = content:sub(1, lastSignificant)
    local gap = content:sub(lastSignificant + 1, closeIndex - 1)
    local tail = content:sub(closeIndex)

    if not gap:find('\n') then
        gap = '\n' .. gap
    end

    return head .. comma .. '\n' .. buildEntry(key, dict, clip, label, options, unit) .. gap .. tail
end

if IS_SERVER then
    local SessionRegistrations = {}

    local function isAdmin(source)
        return Framework and Framework.isAdmin and Framework:isAdmin(source) and true or false
    end

    local function refreshServerList()
        if Main and type(Main.Init) == 'function' then
            pcall(function() Main:Init() end)
        end
    end

    local function registerEmote(data)
        if type(data) ~= 'table' then
            return fail('data must be a table')
        end

        if type(Config) ~= 'table' then
            return fail('Config is not loaded yet')
        end

        if type(data.name) ~= 'string' then
            return fail('name is required and must be a string')
        end

        local key = (data.name:lower():gsub('[^a-z0-9_]', ''))

        if key == '' then
            return fail('name contains no usable characters (allowed: a-z, 0-9, _)')
        end

        if #key > 64 then
            return fail('name is too long (max 64 characters)')
        end

        if not isCleanString(data.dict, 128) then
            return fail('dict is required and must be a non-empty single-line string')
        end

        if not isCleanString(data.clip, 128) then
            return fail('clip is required and must be a non-empty single-line string')
        end

        if not isCleanString(data.label, 128) then
            return fail('label is required and must be a non-empty single-line string')
        end

        local target, targetKey = resolveTarget(data.target)

        if not target then
            return fail('unknown target (expected one of: emotes, dances, props, invehicle, animal)')
        end

        local exists, whereFound = keyExists(key)

        if exists then
            return fail(('name "%s" already exists in %s'):format(key, whereFound))
        end

        local content = LoadResourceFile(RESOURCE, target.file)

        if content and content ~= '' then
            if content:find('["' .. key .. '"]', 1, true) or content:find("['" .. key .. "']", 1, true) then
                return fail(('name "%s" already exists in %s'):format(key, target.file))
            end
        end

        local options = sanitizeOptions(data.options)
        local output, mode

        if not content or content == '' then
            output = ('Config.%s = {\n%s\n}\n'):format(
                target.table,
                buildEntry(key, data.dict, data.clip, data.label, options, '    ')
            )
            mode = 'inserted'
        else
            output = insertIntoTable(content, target.table, key, data.dict, data.clip, data.label, options)

            if output then
                mode = 'inserted'
            else
                local block = buildAssignment(target.table, key, data.dict, data.clip, data.label, options)
                local base = content

                if base:sub(-1) ~= '\n' then
                    base = base .. '\n'
                end

                output = base .. '\n' .. block .. '\n'
                mode = 'appended'
            end
        end

        if not SaveResourceFile(RESOURCE, target.file, output, -1) then
            return fail('failed to write ' .. target.file)
        end

        local entry = { data.dict, data.clip, data.label }

        if options then
            entry.animationOptions = options
        end

        if type(Config[target.table]) ~= 'table' then
            Config[target.table] = {}
        end

        Config[target.table][key] = entry

        local payload = { table = target.table, name = key, entry = entry }

        SessionRegistrations[#SessionRegistrations + 1] = payload

        refreshServerList()

        TriggerClientEvent(eventName .. 'client:emoteRegistered', -1, payload)

        Trace(('registerEmote: %s "%s" into %s (%s)'):format(mode, key, target.table, target.file))

        return { ok = true, name = key, target = targetKey, file = target.file, table = target.table, mode = mode }
    end

    exports('registerEmote', registerEmote)

    exports('emoteExists', function(name)
        if type(name) ~= 'string' then return false end
        local key = (name:lower():gsub('[^a-z0-9_]', ''))
        if key == '' then return false end
        return (keyExists(key)) and true or false
    end)

    RegisterNetEvent(eventName .. 'server:registerEmote')
    AddEventHandler(eventName .. 'server:registerEmote', function(data)
        local src = source

        if not isAdmin(src) then
            Trace(('registerEmote: rejected client %s (not an admin)'):format(tostring(src)))
            TriggerClientEvent(eventName .. 'client:notify', src, 'You do not have permission to register emotes.')
            return
        end

        local result = registerEmote(data)

        if result.ok then
            TriggerClientEvent(eventName .. 'client:notify', src, ('Emote "%s" registered.'):format(result.name))
        else
            TriggerClientEvent(eventName .. 'client:notify', src, ('Emote registration failed: %s'):format(result.error))
        end
    end)

    RegisterNetEvent(eventName .. 'server:requestRegisteredEmotes')
    AddEventHandler(eventName .. 'server:requestRegisteredEmotes', function()
        local src = source

        if #SessionRegistrations == 0 then return end

        TriggerClientEvent(eventName .. 'client:emoteRegistrationSync', src, { entries = SessionRegistrations })
    end)
else
    local function applyEntry(payload)
        if type(payload) ~= 'table' then return nil end
        if type(payload.table) ~= 'string' or type(payload.name) ~= 'string' then return nil end
        if type(payload.entry) ~= 'table' then return nil end
        if type(Config) ~= 'table' then return nil end

        if type(Config[payload.table]) ~= 'table' then
            Config[payload.table] = {}
        end

        Config[payload.table][payload.name] = payload.entry

        return payload.name
    end

    local function refreshMenu(names)
        if #names == 0 then return end

        if Main and type(Main.rebuildAnimations) == 'function' and Main.isLoaded then
            Main:rebuildAnimations()
        end

        if type(PushUpdatedMenuItems) == 'function' then
            local map = {}
            for _, name in ipairs(names) do
                map[name] = {}
            end
            PushUpdatedMenuItems(map)
        end
    end

    RegisterNetEvent(eventName .. 'client:emoteRegistered')
    AddEventHandler(eventName .. 'client:emoteRegistered', function(payload)
        local name = applyEntry(payload)
        if not name then return end

        Trace(('registerEmote: received "%s" for Config.%s'):format(name, tostring(payload.table)))

        refreshMenu({ name })
    end)

    RegisterNetEvent(eventName .. 'client:emoteRegistrationSync')
    AddEventHandler(eventName .. 'client:emoteRegistrationSync', function(payload)
        if type(payload) ~= 'table' or type(payload.entries) ~= 'table' then return end

        local names = {}

        for _, entry in ipairs(payload.entries) do
            local name = applyEntry(entry)
            if name then
                names[#names + 1] = name
            end
        end

        refreshMenu(names)
    end)

    exports('registerEmote', function(data)
        if type(data) ~= 'table' then
            return fail('data must be a table')
        end

        TriggerServerEvent(eventName .. 'server:registerEmote', data)

        return { ok = true, queued = true }
    end)

    exports('emoteExists', function(name)
        if type(name) ~= 'string' then return false end
        local key = (name:lower():gsub('[^a-z0-9_]', ''))
        if key == '' then return false end
        return (keyExists(key)) and true or false
    end)

    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        TriggerServerEvent(eventName .. 'server:requestRegisteredEmotes')
    end)
end
