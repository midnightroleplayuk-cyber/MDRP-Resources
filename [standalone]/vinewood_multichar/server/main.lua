local selecting = {}      -- [src] = true while on the selection screen
local pendingNew = {}     -- [src] = true when a new character still needs starter items
local lastSwitch = {}
local busy = {}           -- simple per-player lock

local function isAdmin(src) return IsPlayerAceAllowed(src, Config.AdminAce) end
IsVMCAdmin = isAdmin

local function lock(src)
    if busy[src] then return false end
    busy[src] = true
    return true
end
local function unlock(src) busy[src] = nil end

local function buildSelection(src)
    local allowed, breakdown = Slots.GetAllowed(src)
    local s = Slots.GetSettings()
    local chars = Bridge.GetCharacters(src)

    local highest = 0
    for _, c in ipairs(chars) do
        if c.slot > highest then highest = c.slot end
        c.locked = s.lockExcess and c.slot > allowed or false
    end

    return {
        characters = chars,
        allowed = allowed,
        breakdown = breakdown,
        display = math.min(math.max(allowed, highest) + (s.showLocked or 0), math.max(s.max, highest)),
        lockedText = s.lockedText,
        lockedLink = s.lockedLink,
        isAdmin = isAdmin(src),
        theme = s.theme,
        allowDelete = s.allowDelete ~= false,
    }
end

lib.callback.register('vmc:getSelection', function(src)
    if Bridge.IsLoggedIn(src) then return { error = 'already_loaded' } end
    selecting[src] = true
    SetPlayerRoutingBucket(src, 5000 + src)
    local data = buildSelection(src)
    data.scene = Scenes.Pick()
    return data
end)

lib.callback.register('vmc:refreshSelection', function(src)
    if not selecting[src] then return nil end
    return buildSelection(src)
end)

-- Rebuild with a specific scene (admin preview)
lib.callback.register('vmc:getScene', function(src, id)
    if not isAdmin(src) then return nil end
    return Scenes.Get(id)
end)

lib.callback.register('vmc:play', function(src, id)
    if not selecting[src] or type(id) ~= 'string' then return false, 'Not on the selection screen.' end
    if not lock(src) then return false, 'Already working on it.' end

    local char = Bridge.OwnsCharacter(src, id)
    if not char then unlock(src) return false, 'That character could not be found.' end

    local allowed = Slots.GetAllowed(src)
    if Slots.GetSettings().lockExcess and char.slot > allowed then
        unlock(src)
        return false, 'This character is in a locked slot.'
    end

    local ok = Bridge.Login(src, id)
    unlock(src)
    if not ok then return false, 'The framework refused the login. Check the server console.' end

    selecting[src] = nil
    SetPlayerRoutingBucket(src, 0)
    DB.Log('Character selected', ('%s (%s) played %s %s [%s]'):format(GetPlayerName(src), src, char.firstname, char.lastname, id))
    return true, { position = char.position, skin = char.skin, skinFormat = char.skinFormat, framework = Bridge.Name }
end)

local function validName(n)
    if type(n) ~= 'string' then return false end
    n = n:gsub('^%s+', ''):gsub('%s+$', '')
    local cc = Config.Character
    if #n < cc.NameMin or #n > cc.NameMax then return false end
    -- letters, spaces, hyphens and apostrophes. Accented letters pass through as utf8 bytes.
    if not n:find("^[%a%s%-'\128-\255]+$") then return false end
    return n:sub(1, 1):upper() .. n:sub(2)
end

local function validDob(dob)
    if type(dob) ~= 'string' then return false end
    local y, m, d = dob:match('^(%d%d%d%d)-(%d%d)-(%d%d)$')
    y, m, d = tonumber(y), tonumber(m), tonumber(d)
    if not y or m < 1 or m > 12 or d < 1 or d > 31 then return false end
    local now = os.date('*t')
    local age = now.year - y
    if now.month < m or (now.month == m and now.day < d) then age = age - 1 end
    if age < Config.Character.MinAge or age > Config.Character.MaxAge then return false end
    return true
end

lib.callback.register('vmc:create', function(src, slot, data)
    if not selecting[src] then return false, 'Not on the selection screen.' end
    if type(data) ~= 'table' then return false, 'Missing details.' end
    slot = math.floor(tonumber(slot) or 0)

    local allowed = Slots.GetAllowed(src)
    if slot < 1 or slot > allowed then return false, 'That slot is locked.' end

    for _, c in ipairs(Bridge.GetCharacters(src)) do
        if c.slot == slot then return false, 'That slot already has a character.' end
    end

    local first, last = validName(data.firstname), validName(data.lastname)
    if not first or not last then
        return false, ('Names need %d–%d letters. Hyphens, spaces and apostrophes are fine.'):format(Config.Character.NameMin, Config.Character.NameMax)
    end
    if not validDob(data.dob) then
        return false, ('Characters must be between %d and %d years old.'):format(Config.Character.MinAge, Config.Character.MaxAge)
    end
    local gender = data.gender == 'female' and 'female' or 'male'
    local nationality = Config.Character.DefaultNationality
    for _, n in ipairs(Config.Character.Nationalities) do
        if n == data.nationality then nationality = n end
    end

    if not lock(src) then return false, 'Already working on it.' end
    local ok, id = Bridge.CreateCharacter(src, slot, {
        firstname = first, lastname = last, dob = data.dob, gender = gender, nationality = nationality,
    })
    unlock(src)
    if not ok then return false, 'The framework could not create the character. Check the server console.' end

    selecting[src] = nil
    pendingNew[src] = true
    SetPlayerRoutingBucket(src, 0)
    DB.Log('Character created', ('%s (%s) created %s %s in slot %d [%s]'):format(GetPlayerName(src), src, first, last, slot, tostring(id)))
    return true, { id = id, gender = gender, framework = Bridge.Name }
end)

lib.callback.register('vmc:delete', function(src, id)
    if not Slots.GetSettings().allowDelete then return false, 'Deleting characters is turned off on this server.' end
    if not selecting[src] or type(id) ~= 'string' then return false, 'Not on the selection screen.' end
    local char = Bridge.OwnsCharacter(src, id)
    if not char then return false, 'That character could not be found.' end
    if not lock(src) then return false, 'Already working on it.' end
    Bridge.DeleteCharacter(src, id)
    unlock(src)
    DB.Log('Character deleted', ('%s (%s) deleted %s %s [%s]'):format(GetPlayerName(src), src, char.firstname, char.lastname, id))
    return true, buildSelection(src)
end)

-- Fired by the client once it has spawned in, so inventories are ready for starter items
RegisterNetEvent('vmc:server:spawned', function()
    local src = source
    if pendingNew[src] then
        pendingNew[src] = nil
        SetTimeout(2000, function() Bridge.GiveStarterItems(src) end)
    end
end)

-- Switch character ---------------------------------------------------------------
if Config.SwitchCommand then
    lib.addCommand(Config.SwitchCommand, {
        help = 'Return to the character selection screen',
    }, function(src)
        if Config.SwitchAce and not IsPlayerAceAllowed(src, Config.SwitchAce) then
            TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'You do not have permission to switch characters.' })
            return
        end
        if lastSwitch[src] and os.time() - lastSwitch[src] < Config.SwitchCooldown then
            TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = ('Wait %ds before switching again.'):format(Config.SwitchCooldown - (os.time() - lastSwitch[src])) })
            return
        end
        if not Bridge.IsLoggedIn(src) then return end
        lastSwitch[src] = os.time()
        Bridge.Logout(src)
        Wait(500)
        TriggerClientEvent('vmc:client:open', src)
    end)
end

AddEventHandler('playerDropped', function()
    local src = source
    selecting[src], pendingNew[src], busy[src], lastSwitch[src] = nil, nil, nil, nil
end)

exports('GetAllowedSlots', function(src) return Slots.GetAllowed(src) end)
exports('IsSelecting', function(src) return selecting[src] == true end)
