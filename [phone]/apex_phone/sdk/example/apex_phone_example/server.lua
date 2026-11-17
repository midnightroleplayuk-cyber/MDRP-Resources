-- ------------------------------------------------------------
-- Taxi Rank (example app for the Apex Phone SDK): the server side.
--   1. RegisterApp       → the icon appears in the phone, the page html/index.html opens in the phone's iframe
--   2. RegisterAppRPC    → the page calls ApexPhone.call('list' | 'save' | 'take' | 'delete')
--   3. PushToApp         → every open Taxi Rank page gets the change live ('ride:new' | 'ride:update' | 'ride:remove')
--   4. SetAppBadge       → the number of open rides on the icon
--   5. SendNotification  → players in "driver mode" (a setting saved with ApexPhone.storage, read here with GetAppStorage)
-- Rides live in memory: a restart of this resource clears the board (persist them yourself if you need to).
-- ------------------------------------------------------------
local APP = 'apex_example'          -- the app id: letters, numbers, _ - . : (up to 64)
local MAX_RIDES = 50

local Rides = {}                    -- array of rides, newest last
local nextId = 1

local function cut(v, max)
    if type(v) ~= 'string' then return nil end
    v = v:gsub('^%s+', ''):gsub('%s+$', '')
    if v == '' then return nil end
    return v:sub(1, max)
end

-- who is asking: citizen id, display name and phone number, through the phone's own helpers
local function who(src)
    local p = exports['apex_phone']:GetPlayerInfo(src)
    local name = p and ((p.firstname or '') .. ' ' .. (p.lastname or '')) or ''
    name = name:gsub('^%s+', ''):gsub('%s+$', '')
    if name == '' then name = GetPlayerName(src) or ('Player ' .. tostring(src)) end
    local cid = p and p.citizenid or nil
    if not cid then
        -- standalone without a framework: fall back to an identifier
        for _, id in ipairs(GetPlayerIdentifiers(src)) do if id:find('^license:') then cid = id break end end
        cid = cid or ('src:' .. tostring(src))
    end
    return cid, name, p and p.phone or nil
end

local function findRide(id)
    for i, r in ipairs(Rides) do if r.id == id then return r, i end end
    return nil
end

local function openCount()
    local n = 0
    for _, r in ipairs(Rides) do if r.status == 'open' then n = n + 1 end end
    return n
end

local function broadcast(event, data)
    exports['apex_phone']:PushToApp(-1, APP, event, data)
    exports['apex_phone']:SetAppBadge(-1, APP, openCount())
end

-- drivers = players who turned "Driver mode" on in the app's Settings tab (ApexPhone.storage.set('settings', {...}))
local function notifyDrivers(exceptSrc, title, msg)
    for _, s in ipairs(GetPlayers()) do
        local src = tonumber(s)
        if src ~= exceptSrc then
            local cid = who(src)
            local settings = exports['apex_phone']:GetAppStorage(cid, APP, 'settings')
            if type(settings) == 'table' and settings.driver == true then
                exports['apex_phone']:SendNotification(src, { app = APP, title = title, msg = msg })
            end
        end
    end
end

local function setup()
    exports['apex_phone']:RegisterApp({
        id = APP,
        name = 'Taxi Rank',
        url = 'nui://apex_phone_example/html/index.html',
        icon = { label = 'TX', color = '#F5A623' },
        category = 'Utilitários',
        description = 'Ask for a taxi or take rides as a driver. Example app built with the Apex Phone SDK.',
        author = 'Apex Scripts',
        defaultInstalled = true,
        statusBar = 'auto',
    })

    -- list → { items = { ride, ... }, me = cid }
    exports['apex_phone']:RegisterAppRPC(APP, 'list', function(src, data)
        local cid = who(src)
        return { items = Rides, me = cid, open = openCount() }
    end)

    -- save { from, to, pax, note, x, y } → { ride }
    exports['apex_phone']:RegisterAppRPC(APP, 'save', function(src, data)
        if type(data) ~= 'table' then return { error = 'invalid' } end
        local from, to = cut(data.from, 60), cut(data.to, 60)
        if not from or not to then return { error = 'fields' } end
        local pax = math.floor(tonumber(data.pax) or 1)
        if pax < 1 then pax = 1 elseif pax > 4 then pax = 4 end
        local cid, name, number = who(src)
        local ride = {
            id = nextId, from = from, to = to, pax = pax, note = cut(data.note, 140),
            by = cid, byName = name, number = number, status = 'open', created = os.time() * 1000,
            x = tonumber(data.x), y = tonumber(data.y),
        }
        nextId = nextId + 1
        Rides[#Rides + 1] = ride
        while #Rides > MAX_RIDES do table.remove(Rides, 1) end
        broadcast('ride:new', ride)
        notifyDrivers(src, 'Taxi Rank', ('%s needs a taxi at %s'):format(name, from))
        return { ride = ride }
    end)

    -- take { id } → { ride } (the driver takes an open ride; the requester gets a notification)
    exports['apex_phone']:RegisterAppRPC(APP, 'take', function(src, data)
        local ride = findRide(math.floor(tonumber(type(data) == 'table' and data.id) or 0))
        if not ride then return { error = 'notfound' } end
        if ride.status ~= 'open' then return { error = 'taken' } end
        local cid, name = who(src)
        if ride.by == cid then return { error = 'own' } end
        ride.status = 'taken'
        ride.driver = cid
        ride.driverName = name
        broadcast('ride:update', ride)
        -- a citizen id (string) as target: the phone delivers it even if that player is offline right now
        exports['apex_phone']:SendNotification(ride.by, { app = APP, title = 'Taxi Rank', msg = ('%s is on the way to %s'):format(name, ride.from) })
        return { ride = ride }
    end)

    -- delete { id } → { ok } (only the requester or the driver)
    exports['apex_phone']:RegisterAppRPC(APP, 'delete', function(src, data)
        local ride, idx = findRide(math.floor(tonumber(type(data) == 'table' and data.id) or 0))
        if not ride then return { error = 'notfound' } end
        local cid = who(src)
        if ride.by ~= cid and ride.driver ~= cid then return { error = 'forbidden' } end
        table.remove(Rides, idx)
        broadcast('ride:remove', { id = ride.id })
        return { ok = true }
    end)
end

-- apex_phone keeps the registrations in memory: register when we start and again whenever apex_phone restarts
CreateThread(function()
    if GetResourceState('apex_phone') == 'started' then setup() end
end)
AddEventHandler('onResourceStart', function(res)
    if res == 'apex_phone' then Wait(500) setup() end
end)
