Bridge = {}

local FW, QB, ESX

local function init()
    if FW then return end
    local f = Config.Framework
    if f == 'auto' then
        if GetResourceState('qbx_core') == 'started' then f = 'qbx'
        elseif GetResourceState('qb-core') == 'started' then f = 'qb'
        elseif GetResourceState('es_extended') == 'started' then f = 'esx' end
    end
    FW = f
    if f == 'qb' then QB = exports['qb-core']:GetCoreObject()
    elseif f == 'esx' then ESX = exports.es_extended:getSharedObject() end
end

function Bridge.Framework() init() return FW end

local function player(src)
    init()
    if FW == 'qbx' then return exports.qbx_core:GetPlayer(src)
    elseif FW == 'qb' then return QB.Functions.GetPlayer(src)
    elseif FW == 'esx' then return ESX.GetPlayerFromId(src) end
end

function Bridge.Cid(src)
    local p = player(src)
    if not p then return end
    if FW == 'esx' then return p.identifier end
    return p.PlayerData.citizenid
end

function Bridge.Name(src)
    local p = player(src)
    if not p then return 'Unknown' end
    if FW == 'esx' then return p.getName() end
    local c = p.PlayerData.charinfo or {}
    return ('%s %s'):format(c.firstname or '', c.lastname or '')
end

-- name, grade, onDuty
function Bridge.Job(src)
    local p = player(src)
    if not p then return end
    if FW == 'esx' then return p.job.name, tonumber(p.job.grade) or 0, true end
    local j = p.PlayerData.job or {}
    local g = type(j.grade) == 'table' and j.grade.level or j.grade
    return j.name, tonumber(g) or 0, j.onduty ~= false
end

function Bridge.HasJob(src, jobs, needDuty)
    local name, grade, duty = Bridge.Job(src)
    local min = name and jobs[name]
    if not min or grade < min then return false end
    if needDuty and not duty then return false end
    return true
end

local function esxAccount(a) return a == 'cash' and 'money' or a end

function Bridge.Balance(src, account)
    local p = player(src)
    if not p then return 0 end
    if FW == 'esx' then
        local a = p.getAccount(esxAccount(account))
        return a and a.money or 0
    end
    return (p.PlayerData.money or {})[account] or 0
end

function Bridge.RemoveMoney(src, account, amount, reason)
    amount = math.floor(amount)
    if amount <= 0 then return true end
    local p = player(src)
    if not p or Bridge.Balance(src, account) < amount then return false end
    if FW == 'esx' then p.removeAccountMoney(esxAccount(account), amount, reason) return true end
    if FW == 'qbx' then return exports.qbx_core:RemoveMoney(src, account, amount, reason) ~= false end
    return p.Functions.RemoveMoney(account, amount, reason) ~= false
end

function Bridge.AddMoney(src, account, amount, reason)
    amount = math.floor(amount)
    if amount <= 0 then return true end
    local p = player(src)
    if not p then return false end
    if FW == 'esx' then p.addAccountMoney(esxAccount(account), amount, reason) return true end
    if FW == 'qbx' then return exports.qbx_core:AddMoney(src, account, amount, reason) ~= false end
    return p.Functions.AddMoney(account, amount, reason) ~= false
end

function Bridge.SourceByCid(cid)
    init()
    local p
    if FW == 'qbx' then p = exports.qbx_core:GetPlayerByCitizenId(cid) return p and p.PlayerData.source end
    if FW == 'qb' then p = QB.Functions.GetPlayerByCitizenId(cid) return p and p.PlayerData.source end
    if FW == 'esx' then p = ESX.GetPlayerFromIdentifier(cid) return p and p.source end
end

local function esxModel(raw)
    if type(raw) ~= 'string' then return end
    local ok, props = pcall(json.decode, raw)
    return ok and type(props) == 'table' and props.model or nil
end

-- { plate, owner, model } list for a character
function Bridge.OwnedVehicles(cid)
    init()
    local out = {}
    if FW == 'esx' then
        for _, r in ipairs(MySQL.query.await('SELECT plate, owner, vehicle FROM owned_vehicles WHERE owner = ?', { cid }) or {}) do
            out[#out + 1] = { plate = r.plate, owner = r.owner, model = esxModel(r.vehicle) }
        end
    else
        for _, r in ipairs(MySQL.query.await('SELECT plate, citizenid, vehicle FROM player_vehicles WHERE citizenid = ?', { cid }) or {}) do
            out[#out + 1] = { plate = r.plate, owner = r.citizenid, model = r.vehicle }
        end
    end
    return out
end

-- Registered vehicle by plate, or nil
function Bridge.VehicleByPlate(plate)
    init()
    local k = VWMI.Key(plate)
    if FW == 'esx' then
        local r = MySQL.single.await("SELECT plate, owner, vehicle FROM owned_vehicles WHERE REPLACE(UPPER(plate), ' ', '') = ? LIMIT 1", { k })
        return r and { plate = r.plate, owner = r.owner, model = esxModel(r.vehicle) }
    end
    local r = MySQL.single.await("SELECT plate, citizenid, vehicle FROM player_vehicles WHERE REPLACE(UPPER(plate), ' ', '') = ? LIMIT 1", { k })
    return r and { plate = r.plate, owner = r.citizenid, model = r.vehicle }
end

-- Keepers for many plates at once: { [plateKey] = owner }
function Bridge.KeepersBulk(keys)
    init()
    local out = {}
    if #keys == 0 then return out end
    local ph = ('?,'):rep(#keys):sub(1, -2)
    local sql = FW == 'esx'
        and ("SELECT plate, owner FROM owned_vehicles WHERE REPLACE(UPPER(plate), ' ', '') IN (%s)")
        or ("SELECT plate, citizenid AS owner FROM player_vehicles WHERE REPLACE(UPPER(plate), ' ', '') IN (%s)")
    for _, r in ipairs(MySQL.query.await(sql:format(ph), keys) or {}) do out[VWMI.Key(r.plate)] = r.owner end
    return out
end

local function signed(h)
    h = tonumber(h)
    if not h then return end
    if h > 2147483647 then h = h - 4294967296 end
    return h
end

local esxPrices
function Bridge.VehicleValue(model)
    init()
    if not model then return end
    if FW == 'qbx' then
        local ok, list = pcall(function() return exports.qbx_core:GetVehiclesByName() end)
        local v = ok and list and list[model]
        return v and v.price
    elseif FW == 'qb' then
        local v = QB.Shared.Vehicles and QB.Shared.Vehicles[model]
        return v and v.price
    elseif FW == 'esx' then
        if not esxPrices then
            esxPrices = {}
            local ok, rows = pcall(MySQL.query.await, 'SELECT model, price FROM vehicles')
            for _, r in ipairs(ok and rows or {}) do
                esxPrices[signed(joaat(r.model))] = r.price
                esxPrices[r.model] = r.price
            end
        end
        return esxPrices[model] or esxPrices[signed(model)]
    end
end

function Bridge.Notify(src, msg, kind)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Motor', description = msg, type = kind or 'inform' })
end

function Bridge.GiveItem(src, item, metadata)
    if not item or GetResourceState('ox_inventory') ~= 'started' then return end
    exports.ox_inventory:AddItem(src, item, 1, metadata)
end

---------------------------------------------------------------------------
-- Societies (jobs and gangs)
---------------------------------------------------------------------------
-- { name, isBoss } for the player's gang, or nil
function Bridge.Gang(src)
    if FW == 'esx' then return end
    local p = player(src)
    local g = p and p.PlayerData.gang
    if not g or not g.name or g.name == 'none' then return end
    return g.name, g.isboss == true
end

function Bridge.IsJobBoss(src)
    local p = player(src)
    if not p then return false end
    if FW == 'esx' then return p.job.grade_name == 'boss' end
    return (p.PlayerData.job or {}).isboss == true
end

local function lists()
    init()
    local jobs, gangs = {}, {}
    if FW == 'qbx' then
        local ok, j = pcall(function() return exports.qbx_core:GetJobs() end)
        local ok2, g = pcall(function() return exports.qbx_core:GetGangs() end)
        jobs, gangs = ok and j or {}, ok2 and g or {}
    elseif FW == 'qb' then
        jobs, gangs = QB.Shared.Jobs or {}, QB.Shared.Gangs or {}
    elseif FW == 'esx' then
        local ok, j = pcall(ESX.GetJobs)
        jobs = ok and j or {}
    end
    return jobs, gangs
end

-- If this owner id is a job or gang rather than a character: kind, label
function Bridge.Society(owner)
    if type(owner) ~= 'string' or owner == '' then return end
    local jobs, gangs = lists()
    if jobs[owner] then return 'job', jobs[owner].label or owner end
    if gangs[owner] then return 'gang', gangs[owner].label or owner end
end
