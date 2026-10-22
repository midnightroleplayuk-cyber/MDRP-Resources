local STASH = 'rsvx_safe_'
local safes, busy, attempts = {}, {}, {}
local loaded = false

-- Framework bridge ----------------------------------------------------------
local fw = Config.Framework
if fw == 'auto' then
    fw = GetResourceState('qbx_core') == 'started' and 'qbx'
        or GetResourceState('qb-core') == 'started' and 'qb'
        or GetResourceState('es_extended') == 'started' and 'esx'
        or nil
end
assert(fw, '[rsvx_safe] No supported framework running (qbx_core, qb-core, es_extended)')

local QBCore = fw == 'qb' and exports['qb-core']:GetCoreObject() or nil
local ESX = fw == 'esx' and exports.es_extended:getSharedObject() or nil

local function getPlayer(src)
    if fw == 'qbx' then return exports.qbx_core:GetPlayer(src) end
    if fw == 'qb' then return QBCore.Functions.GetPlayer(src) end
    return ESX.GetPlayerFromId(src)
end

local function identifier(src)
    local p = getPlayer(src)
    if not p then return nil end
    return fw == 'esx' and p.identifier or p.PlayerData.citizenid
end

local function pay(src, amount)
    local p = getPlayer(src)
    if not p then return false end
    if fw == 'esx' then
        if p.getAccount(Config.Account).money < amount then return false end
        p.removeAccountMoney(Config.Account, amount, 'rsvx_safe purchase')
        return true
    end
    return p.Functions.RemoveMoney(Config.Account, amount, 'rsvx_safe purchase') and true or false
end

local function refund(src, amount)
    local p = getPlayer(src)
    if not p then return end
    if fw == 'esx' then
        p.addAccountMoney(Config.Account, amount, 'rsvx_safe refund')
    else
        p.Functions.AddMoney(Config.Account, amount, 'rsvx_safe refund')
    end
end

-- Helpers -------------------------------------------------------------------
local function pos(s) return vector3(s.x, s.y, s.z) end

local function nearPlayer(src, coords, dist)
    return #(GetEntityCoords(GetPlayerPed(src)) - coords) <= dist
end

local function public(s, mine)
    return { id = s.id, x = s.x, y = s.y, z = s.z, h = s.h, hasPin = s.pin ~= nil, mine = mine }
end

local function canManage(src, s)
    return identifier(src) == s.owner or IsPlayerAceAllowed(src, Config.AdminAce)
end

local function registerStash(s)
    exports.ox_inventory:RegisterStash(STASH .. s.id, ('Safe #%d'):format(s.id), Config.Slots, Config.MaxWeight, false)
end

local function isStashEmpty(stash)
    local items = exports.ox_inventory:GetInventoryItems(stash)
    if items then return next(items) == nil end
    -- Not loaded in memory: fall back to what ox_inventory saved.
    local data = MySQL.scalar.await('SELECT data FROM ox_inventory WHERE name = ?', { stash })
    return data == nil or data == '' or data == '[]'
end

-- Startup -------------------------------------------------------------------
MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS rsvx_safes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            owner VARCHAR(64) NOT NULL,
            x DOUBLE NOT NULL, y DOUBLE NOT NULL, z DOUBLE NOT NULL, h DOUBLE NOT NULL,
            pin VARCHAR(6) NULL,
            created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX (owner)
        )
    ]])

    for _, r in ipairs(MySQL.query.await('SELECT * FROM rsvx_safes')) do
        safes[r.id] = r
        registerStash(r)
    end
    loaded = true
end)

AddEventHandler('playerDropped', function()
    local src = source
    busy[src], attempts[src] = nil, nil
end)

-- Callbacks -----------------------------------------------------------------
lib.callback.register('rsvx_safe:sync', function(src)
    if not loaded then return false end
    local me, list = identifier(src), {}
    for _, s in pairs(safes) do
        list[#list + 1] = public(s, me ~= nil and s.owner == me)
    end
    return list
end)

lib.callback.register('rsvx_safe:buy', function(src)
    if not nearPlayer(src, Config.Shop.coords.xyz, 6.0) then return false, 'You are too far from the dealer.' end
    if not exports.ox_inventory:CanCarryItem(src, Config.Item, 1) then return false, 'You cannot carry a safe.' end
    if not pay(src, Config.Price) then return false, ('You need $%s.'):format(Config.Price) end
    if not exports.ox_inventory:AddItem(src, Config.Item, 1) then
        refund(src, Config.Price)
        return false, 'Purchase failed, you were refunded.'
    end
    return true, 'Safe purchased. Use it from your inventory to place it.'
end)

lib.callback.register('rsvx_safe:place', function(src, coords, heading)
    if busy[src] then return false, 'Slow down.' end
    local owner = identifier(src)
    if not owner or type(coords) ~= 'vector3' or type(heading) ~= 'number' then return false, 'Invalid placement.' end
    if not nearPlayer(src, coords, Config.PlaceDistance + 2.0) then return false, 'That is too far away.' end

    busy[src] = true
    local ok, result, msg = pcall(function()
        local owned = 0
        for _, s in pairs(safes) do
            if s.owner == owner then owned = owned + 1 end
            if #(pos(s) - coords) < Config.MinDistance then return false, 'Too close to another safe.' end
        end
        if owned >= Config.MaxPerPlayer then
            return false, ('You can only own %d safes.'):format(Config.MaxPerPlayer)
        end
        if exports.ox_inventory:GetItemCount(src, Config.Item) < 1 then return false, 'You have no safe to place.' end
        if not exports.ox_inventory:RemoveItem(src, Config.Item, 1) then return false, 'Could not use the safe.' end

        local id = MySQL.insert.await(
            'INSERT INTO rsvx_safes (owner, x, y, z, h) VALUES (?, ?, ?, ?, ?)',
            { owner, coords.x, coords.y, coords.z, heading }
        )
        if not id then
            exports.ox_inventory:AddItem(src, Config.Item, 1)
            return false, 'Could not save the safe.'
        end

        local s = { id = id, owner = owner, x = coords.x, y = coords.y, z = coords.z, h = heading, pin = nil }
        safes[id] = s
        registerStash(s)
        for _, p in ipairs(GetPlayers()) do
            TriggerClientEvent('rsvx_safe:add', tonumber(p), public(s, identifier(tonumber(p)) == owner))
        end
        return true, 'Safe placed. Set a PIN from its menu if you want to share it.'
    end)
    busy[src] = nil

    if not ok then
        print(('[rsvx_safe] place error: %s'):format(result))
        return false, 'Something went wrong.'
    end
    return result, msg
end)

lib.callback.register('rsvx_safe:open', function(src, id, pin)
    local s = safes[id]
    if not s or not nearPlayer(src, pos(s), 4.0) then return false, 'You are too far away.' end

    if not canManage(src, s) then
        if not s.pin then return false, 'This safe is locked.' end

        local a = attempts[src] or { n = 0 }
        attempts[src] = a
        if a.lock and os.time() < a.lock then return false, 'Too many attempts. Try again later.' end

        if type(pin) ~= 'string' or pin ~= s.pin then
            a.n = a.n + 1
            if a.n >= Config.PinAttempts then
                a.lock, a.n = os.time() + Config.LockoutSeconds, 0
            end
            return false, 'Wrong PIN.'
        end
        a.n = 0
    end

    exports.ox_inventory:forceOpenInventory(src, 'stash', STASH .. id)
    return true
end)

lib.callback.register('rsvx_safe:setpin', function(src, id, pin)
    local s = safes[id]
    if not s or not nearPlayer(src, pos(s), 4.0) then return false, 'You are too far away.' end
    if not canManage(src, s) then return false, 'This is not your safe.' end

    if pin == nil or pin == '' then
        pin = nil
    elseif type(pin) ~= 'string' or not pin:match('^%d%d%d%d%d?%d?$') then
        return false, 'PIN must be 4-6 digits.'
    end

    MySQL.update.await('UPDATE rsvx_safes SET pin = ? WHERE id = ?', { pin, id })
    s.pin = pin
    TriggerClientEvent('rsvx_safe:pin', -1, id, pin ~= nil)
    return true, pin and 'PIN set.' or 'PIN removed. Only you can open the safe.'
end)

lib.callback.register('rsvx_safe:pickup', function(src, id)
    if busy[src] then return false, 'Slow down.' end
    local s = safes[id]
    if not s or not nearPlayer(src, pos(s), 4.0) then return false, 'You are too far away.' end
    if not canManage(src, s) then return false, 'This is not your safe.' end

    local stash = STASH .. id
    if not isStashEmpty(stash) then return false, 'Empty the safe first.' end
    if not exports.ox_inventory:CanCarryItem(src, Config.Item, 1) then return false, 'You cannot carry a safe.' end

    busy[src] = true
    MySQL.update.await('DELETE FROM rsvx_safes WHERE id = ?', { id })
    MySQL.update.await('DELETE FROM ox_inventory WHERE name = ?', { stash })
    safes[id] = nil
    busy[src] = nil

    exports.ox_inventory:AddItem(src, Config.Item, 1)
    TriggerClientEvent('rsvx_safe:remove', -1, id)
    return true, 'Safe picked up.'
end)
