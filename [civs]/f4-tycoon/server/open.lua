--[[
    F4 Tycoon - server side, open file.

    This file is not encrypted: it is the place to connect the resource to your server.
      * money for the optional stakes (qbx_core, qb-core, es_extended are built in)
      * the names shown at the table
      * who is an admin
      * hooks: called when something happens, some of them can say no
      * exports: for your other resources

    Everything in OpenServer is called safely: an error here is printed and the resource
    goes on with the default.

    Players are passed to hooks as { src, name, bot }. Bots (AI players) have a negative src
    and must never be paid or charged.
]]

OpenServer = {}

-- Show character names (firstname lastname) instead of FiveM names at the table.
local USE_CHARACTER_NAMES = true

---------------------------------------------------------------------------------------------------
--- Money (stakes only)
---------------------------------------------------------------------------------------------------

Bridge = {}

local account = Config.Bet.account or 'cash'
local reason = 'f4-tycoon'

local function detect()
    local forced = Config.Framework
    if forced and forced ~= 'auto' then return forced end
    if GetResourceState('qbx_core') == 'started' then return 'qbx' end
    if GetResourceState('qb-core') == 'started' then return 'qb' end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
    return 'standalone'
end

Bridge.Name = detect()

---Stakes are possible: enabled in the config and a money system is connected.
function Bridge.BetsEnabled()
    return Config.Bet.enabled and Bridge.Name ~= 'standalone'
end

if Bridge.Name == 'qbx' then
    local QBX = exports.qbx_core

    function Bridge.GetMoney(src)
        return QBX:GetMoney(src, account) or 0
    end

    function Bridge.RemoveMoney(src, amount)
        if amount <= 0 then return true end
        if (QBX:GetMoney(src, account) or 0) < amount then return false end
        return QBX:RemoveMoney(src, account, amount, reason) == true
    end

    function Bridge.AddMoney(src, amount)
        if amount <= 0 then return true end
        return QBX:AddMoney(src, account, amount, reason) == true
    end

    function Bridge.CharacterName(src)
        local p = QBX:GetPlayer(src)
        local ci = p and p.PlayerData.charinfo
        return ci and (ci.firstname .. ' ' .. ci.lastname) or nil
    end

elseif Bridge.Name == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()

    function Bridge.GetMoney(src)
        local p = QBCore.Functions.GetPlayer(src)
        return p and p.PlayerData.money[account] or 0
    end

    function Bridge.RemoveMoney(src, amount)
        if amount <= 0 then return true end
        local p = QBCore.Functions.GetPlayer(src)
        if not p or (p.PlayerData.money[account] or 0) < amount then return false end
        return p.Functions.RemoveMoney(account, amount, reason) ~= false
    end

    function Bridge.AddMoney(src, amount)
        if amount <= 0 then return true end
        local p = QBCore.Functions.GetPlayer(src)
        if not p then return false end
        return p.Functions.AddMoney(account, amount, reason) ~= false
    end

    function Bridge.CharacterName(src)
        local p = QBCore.Functions.GetPlayer(src)
        local ci = p and p.PlayerData.charinfo
        return ci and (ci.firstname .. ' ' .. ci.lastname) or nil
    end

elseif Bridge.Name == 'esx' then
    local ESX = exports.es_extended:getSharedObject()
    local esxAccount = account == 'cash' and 'money' or account

    function Bridge.GetMoney(src)
        local p = ESX.GetPlayerFromId(src)
        local acc = p and p.getAccount(esxAccount)
        return acc and acc.money or 0
    end

    function Bridge.RemoveMoney(src, amount)
        if amount <= 0 then return true end
        local p = ESX.GetPlayerFromId(src)
        local acc = p and p.getAccount(esxAccount)
        if not acc or acc.money < amount then return false end
        p.removeAccountMoney(esxAccount, amount, reason)
        return true
    end

    function Bridge.AddMoney(src, amount)
        if amount <= 0 then return true end
        local p = ESX.GetPlayerFromId(src)
        if not p then return false end
        p.addAccountMoney(esxAccount, amount, reason)
        return true
    end

    function Bridge.CharacterName(src)
        local p = ESX.GetPlayerFromId(src)
        return p and p.getName() or nil
    end

else
    -- Standalone: the game works, stakes are off. Connect another money system here.
    function Bridge.GetMoney() return 0 end
    function Bridge.RemoveMoney() return false end
    function Bridge.AddMoney() return false end
    function Bridge.CharacterName() return nil end
end

CreateThread(function()
    print(('[f4-tycoon] money: %s, stakes %s'):format(Bridge.Name, Bridge.BetsEnabled() and 'on' or 'off'))
end)

---------------------------------------------------------------------------------------------------
--- Names and permissions
---------------------------------------------------------------------------------------------------

---Name shown at the table, in the game log and on the result screen.
---@param src number
---@return string
function OpenServer.GetDisplayName(src)
    local name = USE_CHARACTER_NAMES and Bridge.CharacterName(src) or GetPlayerName(src)
    return name or ('#' .. tostring(src))
end

---Allowed to use /tycoontable. The server console always is.
---@param src number
---@return boolean
function OpenServer.IsAdmin(src)
    return IsPlayerAceAllowed(src, 'command') or IsPlayerAceAllowed(src, Config.AdminAce)
end

---------------------------------------------------------------------------------------------------
--- Hooks
---------------------------------------------------------------------------------------------------

---A player wants to sit down. Return false to refuse, optionally with a reason to show them.
---@param src number
---@param tableId string
---@param seat number 1..4
---@return boolean allowed, string? reason
function OpenServer.CanSitDown(src, tableId, seat)
    -- if Player(src).state.isCuffed then return false, 'You cannot sit down now' end
    return true
end

---Everybody is ready and the countdown ran out. Return false to cancel the start
---(everybody is set back to not ready).
---@param tableId string
---@param players table[] { src, name, bot }
---@param stake number per player, 0 = no stake
---@return boolean
function OpenServer.CanStartGame(tableId, players, stake)
    return true
end

---A game has started (stakes are already paid).
---@param tableId string
---@param players table[] { src, name, bot }
---@param stake number
function OpenServer.OnGameStarted(tableId, players, stake)
    -- print(('[f4-tycoon] game started at %s with %d players'):format(tableId, #players))
end

---A game has ended. The prize is already paid to the winner.
---@param tableId string
---@param result table { winner = { src, name, bot } | nil, prize,
---                      reason ('prestige'|'wealth'|'last'|'time'|'abandoned'|'stopped'|'error'),
---                      ranking = { { src, name, bot, worth, bankrupt }, ... }, minutes }
function OpenServer.OnGameEnded(tableId, result)
    -- if result.winner and not result.winner.bot then
    --     TriggerEvent('my-logs:server:log', 'tycoon', ('%s won %s'):format(result.winner.name, result.prize))
    -- end
end

---A player is out of the game: bankrupt, left the table or removed for being away.
---@param tableId string
---@param player table { src, name, bot }
---@param creditor table|nil { src, name, bot } when everything went to another player
---@param why string 'bankrupt' | 'left' | 'afk'
function OpenServer.OnPlayerOut(tableId, player, creditor, why)
end

---A space was bought (a district can come with houses right away).
---@param tableId string
---@param player table { src, name, bot }
---@param position number 0..35 (data/board.json)
---@param cost number land + houses paid
---@param level number 0 land only, 1-3 houses
function OpenServer.OnPropertyBought(tableId, player, position, cost, level)
end

---A district got buildings (on landing there, at the contractor, from city hall or a card).
---@param tableId string
---@param player table { src, name, bot }
---@param position number
---@param level number 1-3 houses, 4 hotel
---@param cost number 0 when it was free
function OpenServer.OnPropertyUpgraded(tableId, player, position, level, cost)
end

---------------------------------------------------------------------------------------------------
--- Exports
---------------------------------------------------------------------------------------------------

---Every table: { id, coords = vector4, players = { { src, seat, name } }, bots = { { seat, name } }, stake,
---playing, runtime (added by command / export), persist (kept in data/tables.json) }.
---@return table[]
exports('GetTables', function()
    local out = {}
    for _, t in ipairs(Tables.list) do out[#out + 1] = Tables.summary(t) end
    return out
end)

---One table's summary, or nil.
---@param tableId string
---@return table|nil
exports('GetTable', function(tableId)
    local t = Tables.byId[tostring(tableId)]
    return t and Tables.summary(t) or nil
end)

---The table and seat a player sits at.
---@param src number
---@return string|nil tableId, number|nil seat
exports('GetPlayerTable', function(src)
    local t, seat = Tables.seatOf(src)
    if not t then return nil, nil end
    return t.id, seat
end)

---Whether a player takes part in a running game (not just sitting / watching).
---@param src number
---@return boolean
exports('IsPlayerPlaying', function(src)
    local t = Tables.seatOf(src)
    local g = t and t.game
    if not g or g.over then return false end
    local p = g:playerBySrc(src)
    return p ~= nil and not p.bankrupt
end)

---The full state of a table (the same data the players' UI gets, `rules` = the table settings), or nil.
---@param tableId string
---@return table|nil
exports('GetGameState', function(tableId)
    local t = Tables.byId[tostring(tableId)]
    return t and Tables.state(t) or nil
end)

---Places a new table. persist = true keeps it in data/tables.json across restarts.
---@param tableId string
---@param coords vector4 x, y, z (ground or player height), heading
---@param persist boolean|nil
---@return boolean ok, string|nil err
exports('AddTable', function(tableId, coords, persist)
    return Tables.add(tableId, coords, persist ~= false)
end)

---Removes a table (not while a game runs at it). Tables from config.lua come back on restart.
---@param tableId string
---@return boolean ok, string|nil err
exports('RemoveTable', function(tableId)
    return Tables.remove(tableId)
end)

---Makes a player stand up. During a game that means leaving it.
---@param src number
exports('StandUp', function(src)
    Tables.stand(src, false)
end)

---Puts an AI player on a free seat of a table in the lobby.
---@param tableId string
---@param seat number 1..4
---@return boolean ok, string|nil err
exports('AddBot', function(tableId, seat)
    local t = Tables.byId[tostring(tableId)]
    if not t then return false, 'no_table' end
    return Tables.addBot(t, seat)
end)

---@param tableId string
---@param seat number 1..4
---@return boolean ok
exports('RemoveBot', function(tableId, seat)
    local t = Tables.byId[tostring(tableId)]
    if not t then return false end
    return Tables.removeBot(t, seat)
end)

---Stops the game at a table. Stakes are given back to the players still in it.
---@param tableId string
---@return boolean ok
exports('EndGame', function(tableId)
    local t = Tables.byId[tostring(tableId)]
    if not t then return false end
    return Tables.endGame(t)
end)
