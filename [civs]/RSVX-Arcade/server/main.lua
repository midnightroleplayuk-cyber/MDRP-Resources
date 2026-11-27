local Machines = {}
local Sessions = {}
local InUse    = {}
local Guests   = {}
local Boards   = {}
local ready    = false
local PERMANENT = '@permanent'

local function public(m)
    return { id = m.id, game = m.game, x = m.x, y = m.y, z = m.z, h = m.h, owner = not m.static and m.owner or nil,
        static = m.static, permanent = m.permanent, prizes = m.prizes }
end

local PRIZE_SPOTS = 9

local function rollPrize(cfg)
    local total = 0
    for _, p in ipairs(cfg.prizes) do total += p.weight end
    local roll = math.random() * total
    for i, p in ipairs(cfg.prizes) do
        roll -= p.weight
        if roll <= 0 then return i end
    end
    return #cfg.prizes
end

local function stock(m)
    local cfg = Config.Machines[m.game]
    if not cfg or not cfg.prizes then return m end
    m.prizes = {}
    for i = 1, PRIZE_SPOTS do m.prizes[i] = rollPrize(cfg) end
    return m
end

local function isAdmin(src)
    return IsPlayerAceAllowed(src, Config.AdminAce)
end

local function getCid(src)
    local player = exports.qbx_core:GetPlayer(src)
    return player and player.PlayerData.citizenid, player
end

local function near(src, m, dist)
    local ped = GetPlayerPed(src)
    if ped == 0 then return false end
    return #(GetEntityCoords(ped) - vec3(m.x, m.y, m.z)) <= dist
end

local function loadBoard(game)
    Boards[game] = MySQL.query.await(
        'SELECT name, score FROM rsvx_arcade_scores WHERE game = ? ORDER BY score DESC, updated ASC LIMIT 10',
        { game }) or {}
    return Boards[game]
end

local function give(src, player, entry)
    if entry.money then
        player.Functions.AddMoney(Config.PayAccount, entry.money, 'arcade-prize')
        return entry.label or (Config.Currency .. entry.money)
    end
    if entry.item and exports.ox_inventory:AddItem(src, entry.item, entry.count or 1) then
        return entry.label or ('%dx %s'):format(entry.count or 1, entry.item)
    end
end

local function record(game, cid, player, score, add)
    local previous = MySQL.scalar.await(
        'SELECT score FROM rsvx_arcade_scores WHERE game = ? AND citizenid = ?', { game, cid }) or 0
    if add then score = previous + score end
    if score <= previous then return false end
    local info = player.PlayerData.charinfo
    local name = ('%s %s.'):format(info.firstname, info.lastname:sub(1, 1))
    MySQL.query.await([[
        INSERT INTO rsvx_arcade_scores (game, citizenid, name, score) VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE score = VALUES(score), name = VALUES(name)
    ]], { game, cid, name, score })
    return true
end

local function release(src)
    Sessions[src] = nil
    for id, user in pairs(InUse) do
        if user == src then
            InUse[id] = nil
            if Guests[id] then
                TriggerClientEvent('rsvx_arcade:guestEnd', Guests[id], id)
                Guests[id] = nil
            end
        end
    end
    for id, guest in pairs(Guests) do
        if guest == src then
            Guests[id] = nil
            if InUse[id] then TriggerClientEvent('rsvx_arcade:guest', InUse[id], id, false) end
        end
    end
end

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS rsvx_arcade_machines (
            id INT AUTO_INCREMENT PRIMARY KEY,
            owner VARCHAR(64) NOT NULL,
            game VARCHAR(32) NOT NULL,
            x DOUBLE NOT NULL, y DOUBLE NOT NULL, z DOUBLE NOT NULL, h FLOAT NOT NULL,
            balance INT NOT NULL DEFAULT 0,
            created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX (owner)
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS rsvx_arcade_scores (
            game VARCHAR(32) NOT NULL,
            citizenid VARCHAR(64) NOT NULL,
            name VARCHAR(64) NOT NULL,
            score INT NOT NULL,
            updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (game, citizenid)
        )
    ]])

    for _, row in ipairs(MySQL.query.await('SELECT * FROM rsvx_arcade_machines') or {}) do
        if Config.Machines[row.game] then
            if row.owner == PERMANENT then row.static, row.permanent = true, true end
            Machines[row.id] = stock(row)
        end
    end

    for i, s in ipairs(Config.StaticMachines) do
        if Config.Machines[s.game] then
            local id = 's' .. i
            Machines[id] = stock({ id = id, game = s.game, x = s.coords.x, y = s.coords.y, z = s.coords.z, h = s.coords.w, static = true, balance = 0 })
        else
            print(('[RSVX_Arcade] static machine %d uses unknown game "%s"'):format(i, tostring(s.game)))
        end
    end

    for game in pairs(Config.Machines) do loadBoard(game) end
    ready = true

    local count = 0
    for _ in pairs(Machines) do count += 1 end
    print(('[RSVX_Arcade] %s v%s loaded %d machines'):format(GetCurrentResourceName(),
        GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '?', count))
end)

lib.callback.register('rsvx_arcade:init', function(src)
    while not ready do Wait(100) end
    local list = {}
    for _, m in pairs(Machines) do list[#list + 1] = public(m) end
    return list, getCid(src), isAdmin(src), GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
end)

lib.callback.register('rsvx_arcade:board', function(_, game)
    while not ready do Wait(100) end
    return Boards[game] or {}
end)

lib.callback.register('rsvx_arcade:place', function(src, slot, coords, heading)
    local cid = getCid(src)
    if not cid or type(slot) ~= 'number' or type(coords) ~= 'vector3' or type(heading) ~= 'number' then
        return false, 'Could not place that.'
    end

    local slotData = exports.ox_inventory:GetSlot(src, slot)
    local game
    if slotData then
        for id, cfg in pairs(Config.Machines) do
            if cfg.item == slotData.name then game = id break end
        end
    end
    if not game then return false, 'You are not holding a machine.' end

    local ped = GetPlayerPed(src)
    if #(GetEntityCoords(ped) - coords) > Config.PlaceDistance + 2.0 then
        return false, 'That is too far away.'
    end

    local owned = 0
    for _, m in pairs(Machines) do
        if m.owner == cid then owned += 1 end
        if #(vec3(m.x, m.y, m.z) - coords) < Config.MinSpacing then
            return false, 'Too close to another machine.'
        end
    end
    if owned >= Config.MaxPerPlayer and not isAdmin(src) then
        return false, ('You can only have %d machines out.'):format(Config.MaxPerPlayer)
    end

    if not exports.ox_inventory:RemoveItem(src, slotData.name, 1, nil, slot) then
        return false, 'You are not holding a machine.'
    end

    local id = MySQL.insert.await(
        'INSERT INTO rsvx_arcade_machines (owner, game, x, y, z, h) VALUES (?, ?, ?, ?, ?, ?)',
        { cid, game, coords.x, coords.y, coords.z, heading })
    if not id then
        exports.ox_inventory:AddItem(src, slotData.name, 1)
        return false, 'Could not place that.'
    end

    local m = stock({ id = id, owner = cid, game = game, x = coords.x, y = coords.y, z = coords.z, h = heading, balance = 0 })
    Machines[id] = m
    TriggerClientEvent('rsvx_arcade:add', -1, public(m))
    return true
end)

lib.callback.register('rsvx_arcade:placePermanent', function(src, game, coords, heading)
    if not isAdmin(src) then return false, 'You are not allowed to do that.' end
    if not Config.Machines[game] or type(coords) ~= 'vector3' or type(heading) ~= 'number' then
        return false, 'Could not place that.'
    end
    if #(GetEntityCoords(GetPlayerPed(src)) - coords) > Config.PlaceDistance + 2.0 then
        return false, 'That is too far away.'
    end
    for _, m in pairs(Machines) do
        if #(vec3(m.x, m.y, m.z) - coords) < Config.MinSpacing then
            return false, 'Too close to another machine.'
        end
    end

    local id = MySQL.insert.await(
        'INSERT INTO rsvx_arcade_machines (owner, game, x, y, z, h) VALUES (?, ?, ?, ?, ?, ?)',
        { PERMANENT, game, coords.x, coords.y, coords.z, heading })
    if not id then return false, 'Could not place that.' end

    local m = { id = id, owner = PERMANENT, game = game, x = coords.x, y = coords.y, z = coords.z, h = heading,
        balance = 0, static = true, permanent = true }
    Machines[id] = stock(m)
    TriggerClientEvent('rsvx_arcade:add', -1, public(m))
    return true
end)

lib.callback.register('rsvx_arcade:pickup', function(src, id)
    local m = Machines[id]
    local cid, player = getCid(src)
    if not m or not cid then return false, 'That machine cannot be moved.' end

    if m.permanent then
        if not isAdmin(src) then return false, 'That machine cannot be moved.' end
        if InUse[id] then return false, 'Someone is playing on it.' end
        Machines[id] = nil
        MySQL.query.await('DELETE FROM rsvx_arcade_machines WHERE id = ?', { id })
        TriggerClientEvent('rsvx_arcade:remove', -1, id)
        return true, 0
    end
    if m.static then return false, 'That machine cannot be moved.' end

    local owner = m.owner == cid
    if not owner and not isAdmin(src) then return false, 'This is not your machine.' end
    if InUse[id] then return false, 'Someone is playing on it.' end
    if not near(src, m, 4.0) then return false, 'Get closer.' end

    local item = Config.Machines[m.game].item
    if not exports.ox_inventory:CanCarryItem(src, item, 1) then
        return false, 'You cannot carry that.'
    end

    Machines[id] = nil
    MySQL.query.await('DELETE FROM rsvx_arcade_machines WHERE id = ?', { id })
    exports.ox_inventory:AddItem(src, item, 1)
    if owner and m.balance > 0 then
        player.Functions.AddMoney(Config.PayAccount, m.balance, 'arcade-takings')
    end
    TriggerClientEvent('rsvx_arcade:remove', -1, id)
    return true, owner and m.balance or 0
end)

lib.callback.register('rsvx_arcade:collect', function(src, id)
    local m = Machines[id]
    local cid, player = getCid(src)
    if not m or not cid or m.owner ~= cid then return false, 'This is not your machine.' end
    if not near(src, m, 4.0) then return false, 'Get closer.' end
    if m.balance <= 0 then return false, 'The coin box is empty.' end

    local amount = m.balance
    m.balance = 0
    MySQL.update('UPDATE rsvx_arcade_machines SET balance = 0 WHERE id = ?', { id })
    player.Functions.AddMoney(Config.PayAccount, amount, 'arcade-takings')
    return amount
end)

lib.callback.register('rsvx_arcade:play', function(src, id)
    local m = Machines[id]
    local cid, player = getCid(src)
    if not cid then return false, 'No character loaded.' end
    if not m then
        print(('[RSVX_Arcade] play: machine %s is not known to this resource (%s). Is a second copy of the resource running?')
            :format(tostring(id), GetCurrentResourceName()))
        return false, 'That machine is gone.'
    end
    if not near(src, m, 3.5) then return false, 'Get closer.' end
    if InUse[id] and InUse[id] ~= src then return false, 'Someone is already playing.' end

    local cfg = Config.Machines[m.game]
    if cfg.display then return false, 'There is nothing to play on this.' end
    if cfg.price > 0 and not player.Functions.RemoveMoney(Config.PayAccount, cfg.price, 'arcade-play') then
        return false, ('You need %s%d.'):format(Config.Currency, cfg.price)
    end

    if not m.static and cfg.price > 0 then
        local cut = math.floor(cfg.price * Config.OwnerCut + 0.5)
        if cut > 0 then
            m.balance += cut
            MySQL.update('UPDATE rsvx_arcade_machines SET balance = ? WHERE id = ?', { m.balance, id })
        end
    end

    release(src)
    InUse[id] = src
    Sessions[src] = { id = id, game = m.game, started = os.time() }

    return { game = m.game, label = cfg.label, price = cfg.price, board = Boards[m.game] or {} }
end)

lib.callback.register('rsvx_arcade:join', function(src, id)
    local m = Machines[id]
    local cid, player = getCid(src)
    if not cid or not m then return false, 'That machine is gone.' end
    local cfg, host = Config.Machines[m.game], InUse[id]
    if not cfg.versus or not host or host == src then return false, 'Nobody is playing.' end
    if Guests[id] then return false, 'Someone has already joined.' end
    if not near(src, m, 3.5) then return false, 'Get closer.' end
    if cfg.price > 0 and not player.Functions.RemoveMoney(Config.PayAccount, cfg.price, 'arcade-play') then
        return false, ('You need %s%d.'):format(Config.Currency, cfg.price)
    end

    release(src)
    Guests[id] = src
    TriggerClientEvent('rsvx_arcade:guest', host, id, true)
    return true
end)

RegisterNetEvent('rsvx_arcade:guestPos', function(id, x, y)
    if Guests[id] ~= source or type(x) ~= 'number' or type(y) ~= 'number' then return end
    if InUse[id] then TriggerClientEvent('rsvx_arcade:guestPos', InUse[id], id, x, y) end
end)

lib.callback.register('rsvx_arcade:submit', function(src, score, spot)
    local s = Sessions[src]
    Sessions[src] = nil
    local cid, player = getCid(src)
    if not s or not cid or type(score) ~= 'number' then return { rejected = true } end

    score = math.floor(score)
    local cfg = Config.Machines[s.game]
    local elapsed = math.max(os.time() - s.started, 1)
    if score < 0 or score > cfg.maxScore or score > 50 + cfg.maxPerSecond * elapsed then
        print(('[RSVX_Arcade] rejected score %d on %s from %s after %ds'):format(score, s.game, cid, elapsed))
        return { rejected = true, board = Boards[s.game] or {} }
    end

    local out = { board = Boards[s.game] or {}, tickets = 0 }

    if cfg.tally then
        local changed = score > 0 and record(s.game, cid, player, 1, true)
        local guest = spot == 'guest' and Guests[s.id]
        if guest then
            local guestCid, guestPlayer = getCid(guest)
            if guestCid and record(s.game, guestCid, guestPlayer, 1, true) then changed = true end
        end
        if changed then
            out.board = loadBoard(s.game)
            TriggerClientEvent('rsvx_arcade:board', -1, s.game, out.board)
        end
    elseif cfg.board ~= false and score > 0 and record(s.game, cid, player, score, false) then
        out.best = true
        out.board = loadBoard(s.game)
        TriggerClientEvent('rsvx_arcade:board', -1, s.game, out.board)
    end

    if Config.Tickets.enabled and cfg.ticketEvery then
        local tickets = math.min(math.floor(score / cfg.ticketEvery), Config.Tickets.maxPerPlay)
        if tickets > 0 and exports.ox_inventory:AddItem(src, Config.Tickets.item, tickets) then
            out.tickets = tickets
        end
    end

    local tier
    for _, r in ipairs(cfg.rewards or {}) do
        if score >= r.min and (not tier or r.min > tier.min) then tier = r end
    end
    if tier then out.reward = give(src, player, tier) end

    if cfg.prizes then
        out.prize = false
        if score >= cfg.winAlign and math.random() < cfg.winChance then
            local m = Machines[s.id]
            local known = m and m.prizes and type(spot) == 'number' and m.prizes[spot]
            local prize = cfg.prizes[known or rollPrize(cfg)]
            if give(src, player, prize) then
                out.prize = prize.label
                if known then
                    m.prizes[spot] = rollPrize(cfg)
                    TriggerClientEvent('rsvx_arcade:prize', -1, m.id, spot, m.prizes[spot])
                end
            else
                out.full = true
            end
        end
    end

    return out
end)

RegisterNetEvent('rsvx_arcade:fx', function(id, key, ...)
    if InUse[id] ~= source or type(key) ~= 'string' or select('#', ...) > 10 then return end
    TriggerClientEvent('rsvx_arcade:fx', -1, id, key, ...)
end)

RegisterNetEvent('rsvx_arcade:leave', function()
    release(source)
end)

AddEventHandler('playerDropped', function()
    release(source)
end)
