-- Anti-cheat style checks. Everything is read on the server (a cheater can't hide it by editing their game),
-- and nothing is punished automatically: Helm raises an alert on the panel's Alerts page and staff decide.
-- Staff (anyone the panel says has the in-game menu) are skipped, because noclip and spectate look like cheats.

local cfg = Config.AntiCheat or {}
if cfg.Enabled == false then return end

local INTERVAL = 3000
local REPORT_EVERY = 5 * 60 * 1000 -- per player and check, so one cheater can't flood the panel

local lastReport = {}  -- src -> { [check] = game timer }
local lastPos = {}     -- src -> { x, y, at }
local hidden = {}      -- src -> consecutive invisible samples
local godSamples = {}  -- src -> consecutive invincible samples (spawn/revive protection is brief)
local jumps = {}       -- src -> { game timers of recent teleport-like jumps }
local joinedAt = {}    -- src -> game timer
local graceUntil = {}  -- src -> game timer; set when Helm itself moves a player

local function on(name) return cfg[name] ~= false end

-- Other scripts (and Helm's own teleport, bring and send back) can call this before moving a player.
function HelmAntiCheatGrace(src, ms)
    graceUntil[src] = GetGameTimer() + (ms or 10000)
end
exports('Grace', HelmAntiCheatGrace)

local function report(src, check, severity, message, data)
    local now = GetGameTimer()
    lastReport[src] = lastReport[src] or {}
    if lastReport[src][check] and now - lastReport[src][check] < REPORT_EVERY then return end
    -- Only now ask whether they're staff: a panel lookup, cached for a minute by menu.lua.
    if HelmIsStaff and HelmIsStaff(src) then return end
    lastReport[src][check] = now
    data = data or {}
    data.severity = severity
    local ped = GetPlayerPed(src)
    if ped and ped ~= 0 then
        local c = GetEntityCoords(ped)
        data.pos = { x = math.floor(c.x), y = math.floor(c.y), z = math.floor(c.z) }
    end
    local text = ('[%d] %s %s'):format(src, GetPlayerName(src) or 'unknown', message)
    -- Online staff hear about it in game too (unless they turned alerts off with /helmalerts). In its own thread:
    -- the first staff lookup per player is a panel request (then cached for a minute).
    CreateThread(function()
        local staff = {}
        for _, s in ipairs(GetPlayers()) do
            local id = tonumber(s)
            if id ~= src and HelmAlertsOn(id) and HelmIsStaff and HelmIsStaff(id) then staff[#staff + 1] = HelmLicense(id) end
        end
        HelmNotifyStaff(staff, 'Anti-cheat', text)
    end)
    HelmApi('POST', '/api/game/events', { events = { {
        category = 'anticheat',
        type = check,
        message = text,
        license = HelmLicense(src),
        playerName = GetPlayerName(src),
        src = src,
        data = data,
    } } })
end

-- Hashes compared as unsigned 32-bit numbers: natives and joaat don't agree on the sign.
local function u32(n) return (tonumber(n) or 0) % 4294967296 end
local BLACKLIST = {}
for _, name in ipairs(cfg.BlacklistedWeapons or {}) do BLACKLIST[u32(GetHashKey(name))] = name end

local function check(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    local now = GetGameTimer()
    local settled = now - (joinedAt[src] or now) > 60000 and now > (graceUntil[src] or 0)
    local loaded = Bridge.Character(src) ~= nil -- past character select, where scripts hide and freeze the ped

    if on('GodMode') and loaded then
        local god = GetPlayerInvincible(src) and not (HelmIsFrozen and HelmIsFrozen(src))
        godSamples[src] = god and (godSamples[src] or 0) + 1 or 0
        if godSamples[src] >= 5 then report(src, 'godmode', 'high', 'has been invincible (god mode) for over 15 seconds') end
    end

    if on('Health') and loaded then
        local hp, max, armour = GetEntityHealth(ped), GetEntityMaxHealth(ped), GetPedArmour(ped)
        if (max > 0 and hp > max + 5) or armour > 100 then
            report(src, 'health', 'high', ('has %d/%d health and %d armour, above the game maximum'):format(hp, max, armour), { health = hp, max = max, armour = armour })
        end
    end

    if on('Weapons') and next(BLACKLIST) then
        local weapon = BLACKLIST[u32(GetSelectedPedWeapon(ped))]
        if weapon then report(src, 'weapon', 'high', ('is holding a blacklisted weapon (%s)'):format(weapon), { weapon = weapon }) end
    end

    if on('Invisible') and loaded and settled then
        hidden[src] = IsEntityVisible(ped) and 0 or (hidden[src] or 0) + 1
        if hidden[src] >= 10 then report(src, 'invisible', 'medium', 'has been invisible for over 30 seconds') end
    end

    if on('Teleport') then
        local c = GetEntityCoords(ped)
        local prev = lastPos[src]
        local dead = GetEntityHealth(ped) <= 0
        lastPos[src] = { x = c.x, y = c.y, at = now, dead = dead }
        -- Dying means a respawn or hospital move is coming: give it time rather than count it as a jump.
        if dead then graceUntil[src] = now + 20000 end
        if prev and settled and not dead and not prev.dead then
            local dist = math.sqrt((c.x - prev.x) ^ 2 + (c.y - prev.y) ^ 2)
            local speed = dist / math.max(0.5, (now - prev.at) / 1000)
            local inVehicle = GetVehiclePedIsIn(ped, false) ~= 0
            local limit = inVehicle and (tonumber(cfg.MaxVehicleSpeed) or 250) or (tonumber(cfg.MaxFootSpeed) or 60)
            if speed > limit then
                -- Housing, garages and interiors teleport players legitimately, so only repeated jumps alert.
                local list = jumps[src] or {}
                list[#list + 1] = now
                while list[1] and now - list[1] > 10 * 60000 do table.remove(list, 1) end
                jumps[src] = list
                if #list >= 3 then
                    report(src, 'teleport', 'medium', ('moved unusually fast %d times in 10 minutes (latest %d m in %.1f s %s)')
                        :format(#list, math.floor(dist), (now - prev.at) / 1000, inVehicle and 'in a vehicle' or 'on foot'), { distance = math.floor(dist) })
                end
            end
        end
    end
end

AddEventHandler('playerJoining', function() joinedAt[source] = GetGameTimer() end)
AddEventHandler('playerDropped', function()
    local src = source
    lastReport[src], lastPos[src], hidden[src], jumps[src], joinedAt[src], graceUntil[src], godSamples[src] = nil, nil, nil, nil, nil, nil, nil
end)

CreateThread(function()
    -- Players already on when the resource (re)starts count as just joined.
    for _, s in ipairs(GetPlayers()) do joinedAt[tonumber(s)] = GetGameTimer() end
    while true do
        Wait(INTERVAL)
        for _, s in ipairs(GetPlayers()) do
            local src = tonumber(s)
            local ok, err = pcall(check, src)
            if not ok and Config.Debug then print('[helm] anticheat:', err) end
        end
    end
end)

-- Spawning lots of vehicles, peds or props in a few seconds is a classic mod-menu sign.
if on('EntitySpam') then
    local spawned = {} -- src -> { count, since }
    local limit = tonumber(cfg.MaxSpawnsPer10s) or 40
    AddEventHandler('entityCreating', function(entity)
        local owner = NetworkGetEntityOwner(entity)
        if not owner or owner <= 0 then return end
        -- 7 = mission entities, i.e. made by a script or menu rather than the game's ambient traffic.
        if GetEntityPopulationType(entity) ~= 7 then return end
        local now = GetGameTimer()
        local s = spawned[owner]
        if not s or now - s.since > 10000 then s = { count = 0, since = now }; spawned[owner] = s end
        s.count = s.count + 1
        if s.count == limit then
            CreateThread(function() report(owner, 'entity_spam', 'high', ('spawned %d entities in 10 seconds'):format(limit)) end)
        end
    end)
    AddEventHandler('playerDropped', function() spawned[source] = nil end)
end
