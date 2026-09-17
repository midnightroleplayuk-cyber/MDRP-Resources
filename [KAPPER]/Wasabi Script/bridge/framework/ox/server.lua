if not GetResourceState('ox_core'):find('start') then return end

lib.print.debug('[wasabi_mdt] ox_core framework detected, initializing bridge')

local Ox = require and require('@ox_core.lib.init') or nil

---@type Bridge
local bridge = {}

bridge.framework = 'ox'

local function getOxPlayer(source)
    if Ox and Ox.GetPlayer then return Ox.GetPlayer(source) end
    return exports.ox_core:GetPlayer(source)
end

function bridge.getIdentifier(source)
    local player = getOxPlayer(source)
    return player and (player.stateId or player.charId and tostring(player.charId)) or nil
end

function bridge.getName(source)
    local player = getOxPlayer(source)
    if not player then return GetPlayerName(source) or 'Unknown' end
    return (player.firstName or '') .. ' ' .. (player.lastName or '')
end

function bridge.getJob(source)
    local player = getOxPlayer(source)
    if not player then return nil end
    local group, grade = player.getGroup and player.getGroup() or nil, 0
    return {
        name = group or 'unemployed',
        label = group or 'Unemployed',
        grade = grade,
        gradeLabel = 'Grade ' .. grade,
        onDuty = true,
    }
end

function bridge.getPlayer(source)
    return getOxPlayer(source)
end

function bridge.getPlayerIdFromIdentifier(identifier)
    for _, playerId in ipairs(GetPlayers()) do
        if bridge.getIdentifier(tonumber(playerId)) == identifier then
            return tonumber(playerId)
        end
    end
    return nil
end

function bridge.hasPermission(source, group)
    return IsPlayerAceAllowed(source, 'group.' .. group) or IsPlayerAceAllowed(source, group)
end

function bridge.registerUsableItem(item, cb)
    -- ox_inventory usable hook
    exports.ox_inventory:registerHook('usingItem', function(payload)
        if payload.name == item then cb(payload.source) end
    end)
end

-- ox_core has no duty toggle — mdt tracks its own
function bridge.setDuty(_, _)
    return true
end

function bridge.setCallsign(_, _)
    return true
end

function bridge.getJobsAndGrades()
    return {}
end

function bridge.getJobLabel(jobName)
    return jobName
end

function bridge.getJobGradeLabel(_, grade)
    return 'Grade ' .. tostring(grade)
end

function bridge.searchPlayers(query)
    local results = {}
    local players = MySQL.query.await([[
        SELECT charId, firstName, lastName, dateOfBirth, gender
        FROM characters
        WHERE LOWER(CONCAT(firstName, ' ', lastName)) LIKE ? OR charId LIKE ? LIMIT 10
    ]], { '%' .. query:lower() .. '%', '%' .. query:lower() .. '%' })
    if players then
        for _, p in ipairs(players) do
            results[#results + 1] = {
                identifier = tostring(p.charId),
                firstname = p.firstName,
                lastname = p.lastName,
                name = (p.firstName or '') .. ' ' .. (p.lastName or ''),
                dob = p.dateOfBirth or 'Unknown',
                phone = 'Unknown',
                gender = p.gender == 'female' and 'female' or 'male',
            }
        end
    end
    return results
end

function bridge.searchVehicles(query)
    local results = {}
    local normalized = query:gsub('%s+', ''):upper()
    local vehicles = MySQL.query.await([[
        SELECT plate, model, owner FROM vehicles
        WHERE UPPER(REPLACE(plate, ' ', '')) LIKE ? LIMIT 10
    ]], { '%' .. normalized .. '%' })
    if vehicles then
        for _, v in ipairs(vehicles) do
            results[#results + 1] = { plate = v.plate, model = v.model or 'Unknown', owner = tostring(v.owner) }
        end
    end
    return results
end

-- live chars/vehicles — identifier is stateId; vehicles.owner is charId

local function fmtDob(d)
    if not d or d == '' then return 'Unknown' end
    local y, m, day = tostring(d):match('(%d+)-(%d+)-(%d+)')
    if y then return ('%02d/%02d/%04d'):format(tonumber(m), tonumber(day), tonumber(y)) end
    return tostring(d)
end

local function mapCharRow(c)
    return {
        identifier = c.stateId,
        firstname  = c.firstName or 'Unknown',
        lastname   = c.lastName or 'Unknown',
        name       = ((c.firstName or '') .. ' ' .. (c.lastName or '')):gsub('^%s+', ''),
        dob        = fmtDob(c.dateOfBirth),
        phone      = c.phoneNumber or 'Unknown',
        gender     = c.gender or 'other',
        job        = nil,        -- ox groups are membership-based; no single "job" column
        job_grade  = 0,
    }
end

local CHAR_SELECT = 'charId, stateId, firstName, lastName, gender, dateOfBirth, phoneNumber'

function bridge.getCitizen(identifier)
    local c = MySQL.single.await(('SELECT %s FROM characters WHERE stateId = ?'):format(CHAR_SELECT), { identifier })
    return c and mapCharRow(c) or nil
end

function bridge.getCitizens(offset, limit, query)
    local where, params = '', {}
    if query and query ~= '' then
        local like = '%' .. query:lower() .. '%'
        where = [[ WHERE LOWER(CONCAT(COALESCE(firstName,''),' ',COALESCE(lastName,''))) LIKE ?
                     OR LOWER(COALESCE(stateId,'')) LIKE ?
                     OR LOWER(COALESCE(phoneNumber,'')) LIKE ? ]]
        params = { like, like, like }
    end
    local total = MySQL.scalar.await('SELECT COUNT(*) FROM characters' .. where, params) or 0
    local pageParams = {}
    for i = 1, #params do pageParams[i] = params[i] end
    pageParams[#pageParams + 1] = limit
    pageParams[#pageParams + 1] = offset
    local rows = MySQL.query.await(
        ('SELECT %s FROM characters %s ORDER BY firstName, lastName LIMIT ? OFFSET ?'):format(CHAR_SELECT, where), pageParams) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapCharRow(rows[i]) end
    return { items = items, total = total }
end

local VEHICLE_SELECT = [[
    v.plate AS plate, v.model AS model, v.class AS class, c.stateId AS owner_id,
    CONCAT(COALESCE(c.firstName,''),' ',COALESCE(c.lastName,'')) AS ownerName
]]
local VEHICLE_JOIN = 'FROM vehicles v LEFT JOIN characters c ON c.charId = v.owner'

local function mapVehicleRow(v)
    local owner = v.ownerName and v.ownerName:gsub('^%s+', ''):gsub('%s+$', '') or ''
    return {
        id           = v.plate,
        plate        = v.plate,
        model        = v.model or 'Unknown',
        vehicle_type = 'car',
        owner_id     = v.owner_id,
        ownerName    = (owner ~= '' and owner) or nil,
    }
end

function bridge.getVehicle(plate)
    plate = plate:gsub('%s+', ''):upper()
    local v = MySQL.single.await(
        ("SELECT %s %s WHERE UPPER(REPLACE(v.plate,' ','')) = ?"):format(VEHICLE_SELECT, VEHICLE_JOIN), { plate })
    return v and mapVehicleRow(v) or nil
end

function bridge.getVehicles(offset, limit, query)
    local where, params = '', {}
    if query and query ~= '' then
        local like = '%' .. query:lower() .. '%'
        where = [[ WHERE UPPER(REPLACE(v.plate,' ','')) LIKE ?
                     OR LOWER(v.model) LIKE ?
                     OR LOWER(CONCAT(COALESCE(c.firstName,''),' ',COALESCE(c.lastName,''))) LIKE ? ]]
        params = { '%' .. query:gsub('%s+', ''):upper() .. '%', like, like }
    end
    local total = MySQL.scalar.await(('SELECT COUNT(*) %s %s'):format(VEHICLE_JOIN, where), params) or 0
    local pageParams = {}
    for i = 1, #params do pageParams[i] = params[i] end
    pageParams[#pageParams + 1] = limit
    pageParams[#pageParams + 1] = offset
    local rows = MySQL.query.await(
        ('SELECT %s %s %s ORDER BY v.plate LIMIT ? OFFSET ?'):format(VEHICLE_SELECT, VEHICLE_JOIN, where), pageParams) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapVehicleRow(rows[i]) end
    return { items = items, total = total }
end

function bridge.getVehiclesByOwner(identifier)
    local rows = MySQL.query.await(
        ('SELECT %s %s WHERE c.stateId = ? ORDER BY v.plate'):format(VEHICLE_SELECT, VEHICLE_JOIN), { identifier }) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapVehicleRow(rows[i]) end
    return items
end

Modules.register('bridge', bridge)
