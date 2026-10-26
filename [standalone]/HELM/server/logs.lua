-- In-city activity logging. Events are queued and sent to the panel in batches.
-- Events that come from other resources' client triggers (deaths, vehicles) can be spoofed by
-- cheaters, so treat them as evidence, not proof.

local cfg = Config.Logging or {}
if cfg.Enabled == false then return end

local queue = {}
local MAX_QUEUE = 2000

local function characterName(src)
    local c = Bridge.Character(src)
    if not c then return nil end
    return ('%s %s'):format(c.firstname, c.lastname)
end

local function coords(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    local c = GetEntityCoords(ped)
    return { x = math.floor(c.x), y = math.floor(c.y), z = math.floor(c.z) }
end

local function playerLabel(src)
    local name = GetPlayerName(src) or 'unknown'
    local char = characterName(src)
    if char and char ~= ' ' then return ('[%d] %s (%s)'):format(src, char, name) end
    return ('[%d] %s'):format(src, name)
end

--- Queue one event. src may be nil for server-wide events.
local function log(src, category, type_, message, data)
    if #queue >= MAX_QUEUE then return end
    src = tonumber(src) -- other resources (and some events) pass the player id as a string
    local e = {
        category = category,
        type = type_,
        message = tostring(message):sub(1, 400),
        data = data,
        t = os.time(),
    }
    if src and src > 0 then
        e.license = HelmLicense and HelmLicense(src) or nil
        e.playerName = GetPlayerName(src)
        e.src = src
        e.character = characterName(src)
        if data == nil then
            local c = coords(src)
            if c then e.data = { pos = c } end
        end
    end
    queue[#queue + 1] = e
end

-- Other resources can log too: exports.helm:Log(source, 'custom', 'arrest', 'Arrested John Doe', { reason = '...' })
exports('Log', function(src, category, type_, message, data)
    log(src, category or 'custom', type_ or 'event', message or '', data)
end)

CreateThread(function()
    while true do
        Wait((cfg.FlushSeconds or 5) * 1000)
        if #queue > 0 then
            local batch, rest = {}, {}
            for i, e in ipairs(queue) do
                if i <= 100 then batch[#batch + 1] = e else rest[#rest + 1] = e end
            end
            local now = os.time()
            local payload = {}
            for _, e in ipairs(batch) do
                payload[#payload + 1] = {
                    category = e.category, type = e.type, message = e.message, data = e.data,
                    license = e.license, playerName = e.playerName, character = e.character, src = e.src,
                    ago = math.max(0, now - e.t),
                }
            end
            queue = rest
            local res = HelmApi('POST', '/api/game/events', { events = payload })
            -- Put the batch back (once) if the panel was unreachable; 4xx means the data itself is bad.
            if res.status == 0 or res.status >= 500 then
                for i = #batch, 1, -1 do
                    if #queue < MAX_QUEUE then table.insert(queue, 1, batch[i]) end
                end
                Wait(15000)
            end
        end
    end
end)

-- Connections --------------------------------------------------------------

if cfg.Connections ~= false then
    AddEventHandler('playerJoining', function()
        local src = source
        log(src, 'connection', 'join', ('[%d] %s joined the server'):format(src, GetPlayerName(src) or 'unknown'))
    end)
    AddEventHandler('playerDropped', function(reason)
        local src = source
        log(src, 'connection', 'leave', ('%s left: %s'):format(playerLabel(src), reason or 'unknown'))
    end)
end

-- Chat and commands --------------------------------------------------------

if cfg.Chat ~= false or cfg.Commands ~= false then
    local redact = {}
    for _, c in ipairs(cfg.RedactCommands or {}) do redact[c:lower()] = true end

    AddEventHandler('chatMessage', function(src, _, message)
        if type(message) ~= 'string' or message == '' then return end
        if message:sub(1, 1) == '/' then
            if cfg.Commands == false then return end
            local name, args = message:match('^/(%S+)%s*(.*)$')
            if not name then return end
            if redact[name:lower()] or cfg.CommandArguments == false then args = '[hidden]' end
            log(src, 'command', name:lower(), ('/%s %s'):format(name, args))
        elseif cfg.Chat ~= false then
            log(src, 'chat', 'message', message)
        end
    end)
end

-- Deaths, vehicles (baseevents) -------------------------------------------
-- These events are fired by the player's own client, so a cheater can send them at any rate. Limit each
-- source to one per type per second so they cannot fill the queue and push out real entries.

local lastSeen = {}
local function throttled(src, key, ms)
    local k = key .. ':' .. tostring(src)
    local now = GetGameTimer()
    if lastSeen[k] and now - lastSeen[k] < ms then return true end
    lastSeen[k] = now
    return false
end
AddEventHandler('playerDropped', function()
    local suffix = ':' .. tostring(source)
    for k in pairs(lastSeen) do
        if k:sub(-#suffix) == suffix then lastSeen[k] = nil end
    end
end)

if cfg.Deaths ~= false then
    RegisterNetEvent('baseevents:onPlayerDied', function(_, pos)
        local src = source
        if throttled(src, 'died', 1000) then return end
        log(src, 'death', 'died', ('%s died'):format(playerLabel(src)))
    end)

    RegisterNetEvent('baseevents:onPlayerKilled', function(killerId, data)
        local src = source
        if throttled(src, 'killed', 1000) then return end
        data = type(data) == 'table' and data or {}
        local killer = tonumber(killerId)
        -- A killer must be a connected player other than the victim; anything else is logged as "something else".
        if killer and (killer <= 0 or killer == src or not GetPlayerName(killer)) then killer = nil end
        local who = killer and playerLabel(killer) or 'something else'
        log(src, 'death', 'killed', ('%s was killed by %s'):format(playerLabel(src), who), {
            killerLicense = killer and HelmLicense(killer) or nil,
            weapon = data.weaponhash,
            inVehicle = data.killerinveh,
        })
    end)
end

if cfg.Vehicles ~= false then
    RegisterNetEvent('baseevents:enteredVehicle', function(_, seat, display)
        local src = source
        if throttled(src, 'enter', 1000) then return end
        display = tostring(display):sub(1, 40)
        log(src, 'vehicle', 'enter', ('%s got into %s (seat %s)'):format(playerLabel(src), tostring(display), tostring(seat)))
    end)
    RegisterNetEvent('baseevents:leftVehicle', function(_, _, display)
        local src = source
        if throttled(src, 'leave', 1000) then return end
        display = tostring(display):sub(1, 40)
        log(src, 'vehicle', 'leave', ('%s left %s'):format(playerLabel(src), tostring(display)))
    end)
end

-- Explosions (throttled so a grenade spam cannot flood the log) -------------

if cfg.Explosions ~= false then
    local lastExplosion = {}
    AddEventHandler('explosionEvent', function(sender, ev)
        local now = GetGameTimer()
        if lastExplosion[sender] and now - lastExplosion[sender] < 3000 then return end
        lastExplosion[sender] = now
        log(sender, 'explosion', 'explosion', ('%s caused an explosion (type %s)'):format(playerLabel(sender), tostring(ev.explosionType)), {
            explosionType = ev.explosionType,
            pos = { x = math.floor(ev.posX or 0), y = math.floor(ev.posY or 0), z = math.floor(ev.posZ or 0) },
        })
    end)
    AddEventHandler('playerDropped', function() lastExplosion[source] = nil end)
end

-- Framework events (the subscriptions live in bridge.lua) ---------------------

-- Combat log: player-on-player hits and kills, with weapon and distance. Read on the server from the game's own
-- damage events. Hits between the same two players are logged at most every 10 seconds; kills always.
if cfg.Combat ~= false then
    local WEAPONS = {
        'WEAPON_UNARMED', 'WEAPON_KNIFE', 'WEAPON_NIGHTSTICK', 'WEAPON_HAMMER', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_CROWBAR',
        'WEAPON_BOTTLE', 'WEAPON_DAGGER', 'WEAPON_HATCHET', 'WEAPON_KNUCKLE', 'WEAPON_MACHETE', 'WEAPON_SWITCHBLADE',
        'WEAPON_WRENCH', 'WEAPON_BATTLEAXE', 'WEAPON_POOLCUE', 'WEAPON_STONE_HATCHET', 'WEAPON_FLASHLIGHT',
        'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL', 'WEAPON_STUNGUN', 'WEAPON_PISTOL50',
        'WEAPON_SNSPISTOL', 'WEAPON_SNSPISTOL_MK2', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_FLAREGUN',
        'WEAPON_MARKSMANPISTOL', 'WEAPON_REVOLVER', 'WEAPON_REVOLVER_MK2', 'WEAPON_DOUBLEACTION', 'WEAPON_CERAMICPISTOL',
        'WEAPON_NAVYREVOLVER', 'WEAPON_GADGETPISTOL', 'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_SMG_MK2', 'WEAPON_ASSAULTSMG',
        'WEAPON_COMBATPDW', 'WEAPON_MACHINEPISTOL', 'WEAPON_MINISMG', 'WEAPON_PUMPSHOTGUN', 'WEAPON_PUMPSHOTGUN_MK2',
        'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_BULLPUPSHOTGUN', 'WEAPON_MUSKET', 'WEAPON_HEAVYSHOTGUN',
        'WEAPON_DBSHOTGUN', 'WEAPON_AUTOSHOTGUN', 'WEAPON_COMBATSHOTGUN', 'WEAPON_ASSAULTRIFLE', 'WEAPON_ASSAULTRIFLE_MK2',
        'WEAPON_CARBINERIFLE', 'WEAPON_CARBINERIFLE_MK2', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE',
        'WEAPON_SPECIALCARBINE_MK2', 'WEAPON_BULLPUPRIFLE', 'WEAPON_BULLPUPRIFLE_MK2', 'WEAPON_COMPACTRIFLE',
        'WEAPON_MILITARYRIFLE', 'WEAPON_HEAVYRIFLE', 'WEAPON_TACTICALRIFLE', 'WEAPON_MG', 'WEAPON_COMBATMG',
        'WEAPON_COMBATMG_MK2', 'WEAPON_GUSENBERG', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_HEAVYSNIPER_MK2',
        'WEAPON_MARKSMANRIFLE', 'WEAPON_MARKSMANRIFLE_MK2', 'WEAPON_PRECISIONRIFLE', 'WEAPON_RPG', 'WEAPON_GRENADELAUNCHER',
        'WEAPON_MINIGUN', 'WEAPON_FIREWORK', 'WEAPON_RAILGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_COMPACTLAUNCHER',
        'WEAPON_GRENADE', 'WEAPON_BZGAS', 'WEAPON_MOLOTOV', 'WEAPON_STICKYBOMB', 'WEAPON_PROXMINE', 'WEAPON_PIPEBOMB',
        'WEAPON_SMOKEGRENADE', 'WEAPON_PETROLCAN', 'WEAPON_FIREEXTINGUISHER',
        'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR', 'WEAPON_FALL', 'WEAPON_DROWNING', 'WEAPON_EXPLOSION', 'WEAPON_FIRE',
    }
    local NAMES = {}
    for _, w in ipairs(WEAPONS) do NAMES[GetHashKey(w) % 4294967296] = w:gsub('^WEAPON_', ''):lower() end
    local lastHit = {} -- 'attacker:victim' -> game timer

    AddEventHandler('weaponDamageEvent', function(sender, ev)
        sender = tonumber(sender)
        if not sender or type(ev) ~= 'table' or not ev.hitGlobalId then return end
        local victimPed = NetworkGetEntityFromNetworkId(ev.hitGlobalId)
        if not victimPed or victimPed == 0 or not DoesEntityExist(victimPed) or not IsPedAPlayer(victimPed) then return end
        local victim = NetworkGetEntityOwner(victimPed)
        if not victim or victim <= 0 or victim == sender then return end

        local kill = ev.willKill == true
        local key = sender .. ':' .. victim
        local now = GetGameTimer()
        if not kill and lastHit[key] and now - lastHit[key] < 10000 then return end
        lastHit[key] = now

        local hash = (tonumber(ev.weaponType) or 0) % 4294967296
        local weapon = NAMES[hash] or ('weapon ' .. tostring(ev.weaponType))
        local a, v = GetEntityCoords(GetPlayerPed(sender)), GetEntityCoords(victimPed)
        local distance = math.floor(#(a - v) + 0.5)
        log(sender, 'combat', kill and 'kill' or 'hit',
            ('%s %s %s with %s from %d m'):format(playerLabel(sender), kill and 'killed' or 'hit', playerLabel(victim), weapon, distance), {
                victim = HelmLicense and HelmLicense(victim) or nil,
                victimName = GetPlayerName(victim),
                victimSrc = victim,
                weapon = weapon,
                damage = tonumber(ev.weaponDamage),
                distance = distance,
                pos = { x = math.floor(a.x), y = math.floor(a.y), z = math.floor(a.z) },
            })
    end)
    AddEventHandler('playerDropped', function()
        local prefix, suffix = source .. ':', ':' .. source
        for k in pairs(lastHit) do
            if k:sub(1, #prefix) == prefix or k:sub(-#suffix) == suffix then lastHit[k] = nil end
        end
    end)
end

if cfg.Economy ~= false then
    Bridge.OnMoneyChange(function(src, account, amount, kind, reason)
        log(src, 'economy', 'money_' .. tostring(kind), ('%s: %s $%s %s (%s)'):format(
            playerLabel(src), tostring(kind), tostring(amount), tostring(account), tostring(reason or 'n/a')), {
            account = account, amount = amount, kind = kind, reason = reason,
        })
    end)
end

if cfg.Jobs ~= false then
    Bridge.OnJobChange(function(src, job, grade)
        log(src, 'job', 'changed', ('%s is now %s (grade %s)'):format(playerLabel(src), tostring(job), tostring(grade or '?')))
    end)
end

if cfg.Characters ~= false then
    Bridge.OnCharacterLoaded(function(src)
        log(src, 'character', 'loaded', ('[%d] %s loaded character %s'):format(src, GetPlayerName(src) or 'unknown', characterName(src) or '?'))
    end)
    Bridge.OnCharacterUnloaded(function(src)
        log(src, 'character', 'unloaded', ('%s unloaded their character'):format(playerLabel(src)))
    end)
end

if cfg.Inventory ~= false then
    Bridge.OnItemMove(function(src, item, count, fromType, toType)
        local dest = toType == 'player' and 'a player' or tostring(toType)
        local from = fromType == 'player' and 'their inventory' or tostring(fromType)
        log(src, 'inventory', 'move', ('%s moved %sx %s from %s to %s'):format(playerLabel(src), tostring(count), item, from, dest), {
            item = item, count = count, fromType = fromType, toType = toType,
        })
    end)
end
