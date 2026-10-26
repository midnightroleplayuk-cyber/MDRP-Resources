-- =============================================================
--  Framework bridge: Qbox, QBCore and ESX
--  Everything the rest of the script needs from the framework
--  goes through FW, so no core-specific calls live elsewhere.
-- =============================================================

FW = {}

local name, core

local function detect()
    if GetResourceState('qbx_core') == 'started' then
        name, core = 'qbx', exports.qbx_core
    elseif GetResourceState('qb-core') == 'started' then
        name = 'qb'
        local ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
        core = ok and obj or nil
    elseif GetResourceState('es_extended') == 'started' then
        name = 'esx'
        local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
        core = ok and obj or nil
    end
    if not name then
        print('^1[vinewood_licensing]^7 no supported framework found (qbx_core, qb-core or es_extended)')
    else
        print(('^2[vinewood_licensing]^7 framework: %s'):format(name))
    end
end
detect()

function FW.Name() return name end

--- The framework's player object, or nil if they are not loaded.
function FW.Player(src)
    src = tonumber(src)
    if not src or src == 0 then return nil end
    if name == 'qbx' then
        return core:GetPlayer(src)
    elseif name == 'qb' then
        return core and core.Functions.GetPlayer(src)
    elseif name == 'esx' then
        return core and core.GetPlayerFromId(src)
    end
end

function FW.Loaded(src)
    return FW.Player(src) ~= nil
end

--- Stable per-character id (citizenid / ESX identifier).
function FW.Cid(src)
    local p = FW.Player(src)
    if not p then return nil end
    if name == 'esx' then return p.identifier end
    return p.PlayerData.citizenid
end

function FW.Source(cid)
    if not cid then return nil end
    if name == 'qbx' then
        local p = core:GetPlayerByCitizenId(cid)
        return p and p.PlayerData.source
    elseif name == 'qb' then
        local p = core and core.Functions.GetPlayerByCitizenId(cid)
        return p and p.PlayerData.source
    elseif name == 'esx' then
        local p = core and core.GetPlayerFromIdentifier(cid)
        return p and p.source
    end
end

--- { firstname, lastname, birthdate, street, city, postcode }
function FW.CharInfo(src)
    local p = FW.Player(src)
    if not p then return {} end
    if name == 'esx' then
        local v = p.variables or {}
        return {
            firstname = v.firstName or p.getName and p.getName() or '',
            lastname = v.lastName or '',
            birthdate = v.dateofbirth
        }
    end
    return p.PlayerData.charinfo or {}
end

--- Name and date of birth for a character who is not online.
function FW.OfflineCharInfo(cid)
    if not cid or GetResourceState('oxmysql') ~= 'started' then return nil end
    local row
    if name == 'esx' then
        pcall(function()
            row = MySQL.single.await('SELECT firstname, lastname, dateofbirth FROM users WHERE identifier = ?', { cid })
        end)
        if not row then return nil end
        return { firstname = row.firstname, lastname = row.lastname, birthdate = row.dateofbirth }
    end
    pcall(function()
        row = MySQL.single.await('SELECT charinfo FROM players WHERE citizenid = ?', { cid })
    end)
    if not row or not row.charinfo then return nil end
    local ci = row.charinfo
    if type(ci) == 'string' then
        local ok, decoded = pcall(json.decode, ci)
        ci = ok and decoded or nil
    end
    return type(ci) == 'table' and ci or nil
end

---------------------------------------------------------------
-- Money
---------------------------------------------------------------
local function esxAccount(account)
    return account == 'cash' and 'money' or 'bank'
end

function FW.Money(src, account)
    local p = FW.Player(src)
    if not p then return 0 end
    if name == 'esx' then
        local acc = p.getAccount and p.getAccount(esxAccount(account))
        return acc and tonumber(acc.money) or 0
    end
    return tonumber(p.Functions.GetMoney(account)) or 0
end

function FW.RemoveMoney(src, account, amount, reason)
    local p = FW.Player(src)
    if not p or amount <= 0 then return amount <= 0 end
    if name == 'esx' then
        if FW.Money(src, account) < amount then return false end
        p.removeAccountMoney(esxAccount(account), amount, reason or 'vinewood_licensing')
        return true
    end
    return p.Functions.RemoveMoney(account, amount, reason) == true
end

function FW.AddMoney(src, account, amount, reason)
    local p = FW.Player(src)
    if not p or amount <= 0 then return end
    if name == 'esx' then
        p.addAccountMoney(esxAccount(account), amount, reason or 'vinewood_licensing')
    else
        p.Functions.AddMoney(account, amount, reason)
    end
end

---------------------------------------------------------------
-- Licence mirror: qbx/qb keep metadata.licences so other
-- resources that read it keep working. ESX has no equivalent.
---------------------------------------------------------------
function FW.SupportsMetadata()
    return name == 'qbx' or name == 'qb'
end

function FW.GetMetadata(src, key)
    if not FW.SupportsMetadata() then return nil end
    local p = FW.Player(src)
    if not p then return nil end
    local meta = p.PlayerData.metadata or {}
    return meta[key]
end

function FW.SetMetadata(src, key, value)
    if not FW.SupportsMetadata() then return end
    local p = FW.Player(src)
    if not p then return end
    p.Functions.SetMetaData(key, value)
end

--- Fires fn(src) once a character is fully loaded, on any framework.
function FW.OnPlayerLoaded(fn)
    local function wrap(src)
        if src then SetTimeout(2000, function() fn(tonumber(src)) end) end
    end

    RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player)
        wrap((type(player) == 'table' and player.PlayerData and player.PlayerData.source) or source)
    end)
    AddEventHandler('qbx_core:playerLoaded', function(player)
        wrap((type(player) == 'table' and ((player.PlayerData and player.PlayerData.source) or player.source)) or source)
    end)
    RegisterNetEvent('esx:playerLoaded', function(playerId)
        wrap(playerId or source)
    end)
end
