-- Helm bridge: the only file that talks to your framework, inventory, ambulance and garage scripts.
--
-- This file is NOT encrypted when the resource is escrowed (see escrow_ignore in fxmanifest.lua), so server
-- owners can edit it: swap an export, change a table name, add support for another script. Keep every
-- function's return shape the same and the rest of Helm keeps working.
--
-- With Config.Framework / Config.Inventory / Config.ReviveEvent left on 'auto' (the default) Helm looks at which
-- resources are running and picks the matching adapter. Set a value in config.lua to force one.
--
--   Frameworks: qbox (qbx_core), qbcore (qb-core), esx (es_extended), standalone (none of those)
--   Inventories: ox_inventory, qb-inventory / ps-inventory / lj-inventory (qb API), qs-inventory, esx, none
--   Ambulance:   qbx_medical (always on qbox), osp_ambulance, qb-ambulancejob, esx_ambulancejob, wasabi_ambulance
--   Banking:     LG Mods UK Banking (LGMods_Banking), or the framework's own bank balance
--
-- 'standalone' still gives you sessions, bans, the staff menu, live players and the activity log (joins, chat,
-- commands, deaths, vehicles, explosions); character, money, job and item features report "not supported".

Bridge = {}

local FW, INV, REVIVE, BANK = nil, nil, nil, nil
local isQb, isEsx = false, false
local QBCore, ESX = nil, nil
local ready = false
local detecting = false

local function unsupported() return false, 'not supported on this framework' end

local function running(name) return GetResourceState(name) == 'started' end

local function firstRunning(list)
    for _, name in ipairs(list) do
        if running(name) then return name end
    end
    return nil
end

local QB_STYLE_INVENTORIES = { 'ox_inventory', 'qs-inventory', 'ps-inventory', 'lj-inventory', 'qb-inventory' }

local function detectFramework()
    if Config.Framework and Config.Framework ~= 'auto' then return Config.Framework end
    if running('qbx_core') then return 'qbox' end
    if running('qb-core') then return 'qbcore' end
    if running('es_extended') then return 'esx' end
    return nil
end

local function detectInventory(fw)
    if Config.Inventory and Config.Inventory ~= 'auto' then return Config.Inventory end
    local found = firstRunning(QB_STYLE_INVENTORIES)
    if found then return found end
    if fw == 'esx' then return 'esx' end
    return 'none'
end

local QBX_REVIVE = 'qbx_medical:client:playerRevived'

local REVIVE_EVENTS = {
    { 'qbx_medical', QBX_REVIVE },
    { 'qb-ambulancejob', 'hospital:client:Revive' },
    { 'wasabi_ambulance', 'wasabi_ambulance:revive' },
    { 'esx_ambulancejob', 'esx_ambulancejob:revive' },
}

-- OSP Ambulance under any folder name (osp_ambulance, osp_ambulance_v2, osp-ambulance...).
local function ospRunning()
    for i = 0, GetNumResources() - 1 do
        local name = GetResourceByFindIndex(i)
        if name and name:lower():gsub('-', '_'):find('^osp_ambulance') and running(name) then return true end
    end
    return false
end

local function detectRevive(fw)
    if Config.ReviveEvent and Config.ReviveEvent ~= '' and Config.ReviveEvent ~= 'auto' then return Config.ReviveEvent end
    -- OSP first: it owns the dead state even on Qbox, and its /revive fires hospital:client:Revive on every framework.
    if ospRunning() then return 'hospital:client:Revive' end
    if fw == 'qbox' and running('qbx_medical') then return QBX_REVIVE end
    for _, pair in ipairs(REVIVE_EVENTS) do
        if running(pair[1]) then return pair[2] end
    end
    return fw == 'esx' and 'esx_ambulancejob:revive' or 'hospital:client:Revive'
end

-- Bank: LG Mods UK Banking keeps personal accounts (sort code, account number, balance) itself; otherwise the
-- framework's 'bank' money is the bank.
local function detectBanking()
    if Config.Banking and Config.Banking ~= 'auto' then return Config.Banking end
    if running('LGMods_Banking') then return 'lgmods' end
    return 'framework'
end

--- Blocks until detection has finished. Safe to call from any thread or event handler.
--- With 'auto' it waits up to 30 seconds for a framework resource to start, so Helm can start before or after it.
function Bridge.Ready()
    if ready then return end
    if detecting then
        while not ready do Wait(100) end
        return
    end
    detecting = true

    local waited = 0
    FW = detectFramework()
    while not FW and waited < 30000 do
        Wait(500)
        waited = waited + 500
        FW = detectFramework()
    end
    FW = FW or 'standalone'

    isQb = (FW == 'qbox' or FW == 'qbcore')
    isEsx = (FW == 'esx')
    if FW == 'qbcore' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif isEsx then
        ESX = exports['es_extended']:getSharedObject()
    end

    -- Give the inventory a moment to start as well, then lock it in.
    INV = detectInventory(FW)
    if (not Config.Inventory or Config.Inventory == 'auto') and INV == 'none' and isQb then
        Wait(5000)
        INV = detectInventory(FW)
    end
    REVIVE = detectRevive(FW)
    BANK = detectBanking()

    ready = true
    print(('^2[helm]^7 framework=%s inventory=%s revive=%s banking=%s'):format(FW, INV, REVIVE, BANK))
end

function Bridge.Detected()
    Bridge.Ready()
    return { framework = FW, inventory = INV, reviveEvent = REVIVE, banking = BANK }
end

RegisterCommand('helm_detect', function(source)
    if source ~= 0 then return end
    local d = Bridge.Detected()
    print(('[helm] framework=%s inventory=%s revive=%s banking=%s'):format(d.framework, d.inventory, d.reviveEvent, d.banking))
end, true)

local function getPlayer(src)
    if FW == 'qbox' then
        return exports.qbx_core:GetPlayer(src)
    elseif FW == 'qbcore' then
        return QBCore.Functions.GetPlayer(src)
    elseif isEsx then
        return ESX.GetPlayerFromId(src)
    end
    return nil
end

-- ESX stores cash as 'money' and other balances as accounts such as 'bank'.
local function esxMoney(xPlayer)
    local bank = xPlayer.getAccount and xPlayer.getAccount('bank')
    return math.floor(xPlayer.getMoney() or 0), math.floor(bank and bank.money or 0)
end

local function esxName(xPlayer)
    local first = xPlayer.get and xPlayer.get('firstName')
    local last = xPlayer.get and xPlayer.get('lastName')
    if first and first ~= '' then return first, last or '' end
    local full = xPlayer.getName() or ''
    local f, l = full:match('^(%S+)%s*(.*)$')
    return f or full, l or ''
end

-- ---------------------------------------------------------------------------
-- LG Mods UK Banking (https://docs.lgmods.co.uk/scripts/uk-banking). Its exports are server-side; the balance
-- lookup is asynchronous (a database read), so balances are cached and refreshed in the background.
-- ---------------------------------------------------------------------------

local lgBalance = {} -- src -> { balance, at }

-- Personal balance from LG Banking, or nil if it couldn't be read. wait = block (up to 3 s) for a fresh value.
local function lgPersonalBalance(src, wait)
    local c = lgBalance[src]
    if not wait and c and GetGameTimer() - c.at < 60000 then return c.balance end
    local p = wait and promise.new() or nil
    local ok = pcall(function()
        exports['LGMods_Banking']:GetAccountDetails(src, 'personal', nil, function(a, b)
            -- Accept both callback shapes: (success, account) or ({ success, account }).
            local success, account = a, b
            if type(a) == 'table' then success, account = a.success, a.account end
            if success and type(account) == 'table' and tonumber(account.balance) then
                lgBalance[src] = { balance = math.floor(tonumber(account.balance)), at = GetGameTimer() }
            end
            if p then p:resolve(true) end
        end)
    end)
    if p and ok then
        SetTimeout(3000, function() p:resolve(false) end)
        Citizen.Await(p)
    end
    c = lgBalance[src]
    return c and c.balance or nil
end
AddEventHandler('playerDropped', function() lgBalance[source] = nil end)

--- Loaded character for a player, or nil when they are on the character screen (or standalone).
--- Returns { citizenid, firstname, lastname, job, jobGrade, cash, bank, down }
function Bridge.Character(src)
    Bridge.Ready()
    if not (isQb or isEsx) then return nil end
    local ok, player = pcall(getPlayer, src)
    if not ok or not player then return nil end

    if isEsx then
        local first, last = esxName(player)
        local job = player.getJob and player.getJob() or nil
        local cash, bank = esxMoney(player)
        if BANK == 'lgmods' then bank = lgPersonalBalance(src) or bank end
        return {
            citizenid = player.identifier,
            firstname = first,
            lastname = last,
            job = job and job.name or nil,
            jobGrade = job and job.grade or nil,
            cash = cash,
            bank = bank,
        }
    end

    local d = player.PlayerData
    if not d or not d.charinfo then return nil end
    return {
        citizenid = d.citizenid,
        firstname = d.charinfo.firstname or '',
        lastname = d.charinfo.lastname or '',
        job = d.job and d.job.name or nil,
        jobGrade = d.job and d.job.grade and d.job.grade.level or nil,
        cash = math.floor((d.money and d.money.cash) or 0),
        bank = BANK == 'lgmods' and lgPersonalBalance(src) or math.floor((d.money and d.money.bank) or 0),
        -- Dead or in last stand (qb-ambulancejob, qbx_medical and most forks keep this in metadata).
        down = d.metadata and (d.metadata.isdead or d.metadata.inlaststand) or false,
    }
end

-- Inventories that expose the qb-inventory style AddItem/RemoveItem exports.
local function qbStyle(name)
    return name == 'qb-inventory' or name == 'ps-inventory' or name == 'lj-inventory' or name == 'qs-inventory'
end

--- Items the player carries: { { name = 'water', amount = 2 }, ... }
function Bridge.Inventory(src)
    Bridge.Ready()
    local out = {}
    if INV == 'ox_inventory' then
        local items = exports.ox_inventory:GetInventoryItems(src) or {}
        for _, it in pairs(items) do out[#out + 1] = { name = it.name, amount = it.count } end
    elseif INV == 'esx' and isEsx then
        local ok, player = pcall(getPlayer, src)
        if ok and player and player.getInventory then
            for _, it in pairs(player.getInventory() or {}) do
                if (it.count or 0) > 0 then out[#out + 1] = { name = it.name, amount = it.count } end
            end
        end
    elseif qbStyle(INV) and isQb then
        -- These inventories keep the player's items on PlayerData.
        local ok, player = pcall(getPlayer, src)
        if ok and player and player.PlayerData then
            for _, it in pairs(player.PlayerData.items or {}) do
                out[#out + 1] = { name = it.name, amount = it.amount or it.count or 1 }
            end
        end
    end
    return out
end

--- Returns true on success.
function Bridge.GiveItem(src, item, amount)
    Bridge.Ready()
    if INV == 'ox_inventory' then
        return exports.ox_inventory:AddItem(src, item, amount) and true or false
    elseif qbStyle(INV) then
        return exports[INV]:AddItem(src, item, amount) and true or false
    elseif INV == 'esx' and isEsx then
        local player = getPlayer(src)
        if not player or (player.canCarryItem and not player.canCarryItem(item, amount)) then return false end
        player.addInventoryItem(item, amount)
        return true
    end
    return false
end

--- Returns true on success.
function Bridge.RemoveItem(src, item, amount)
    Bridge.Ready()
    if INV == 'ox_inventory' then
        return exports.ox_inventory:RemoveItem(src, item, amount) and true or false
    elseif qbStyle(INV) then
        return exports[INV]:RemoveItem(src, item, amount) and true or false
    elseif INV == 'esx' and isEsx then
        local player = getPlayer(src)
        if not player then return false end
        local have = player.getInventoryItem(item)
        if not have or (have.count or 0) < amount then return false end
        player.removeInventoryItem(item, amount)
        return true
    end
    return false
end

--- Removes every item the player carries. Returns true on success.
function Bridge.ClearInventory(src)
    Bridge.Ready()
    if INV == 'ox_inventory' then
        exports.ox_inventory:ClearInventory(src)
        return true
    elseif qbStyle(INV) then
        exports[INV]:ClearInventory(src)
        return true
    elseif INV == 'esx' and isEsx then
        local player = getPlayer(src)
        if not player then return false end
        for _, it in pairs(player.getInventory() or {}) do
            if (it.count or 0) > 0 then player.removeInventoryItem(it.name, it.count) end
        end
        return true
    end
    return false
end

--- account is 'cash' or 'bank'. Returns ok, errorMessage.
function Bridge.SetMoney(src, account, amount)
    Bridge.Ready()
    if not (isQb or isEsx) then return unsupported() end
    local ok, player = pcall(getPlayer, src)
    if not ok or not player then return false, 'no character loaded' end
    -- LG Banking has add and remove, not set: move the difference, which also shows in the player's bank history.
    if account == 'bank' and BANK == 'lgmods' then
        local current = lgPersonalBalance(src, true)
        if not current then return false, 'could not read the LG Banking balance' end
        local diff = amount - current
        if diff == 0 then return true end
        local okCall, done = pcall(function()
            if diff > 0 then return exports['LGMods_Banking']:AddMoney(src, diff, 'personal', nil) end
            return exports['LGMods_Banking']:RemoveMoney(src, -diff, 'personal', nil)
        end)
        if not okCall or done == false then return false, 'LG Banking refused the change' end
        lgBalance[src] = { balance = amount, at = GetGameTimer() }
        return true
    end
    if isEsx then
        if account == 'cash' then player.setMoney(amount) else player.setAccountMoney('bank', amount) end
        return true
    end
    player.Functions.SetMoney(account, amount, 'helm-panel')
    return true
end

--- Returns ok, errorMessage.
function Bridge.SetJob(src, job, grade)
    Bridge.Ready()
    if not (isQb or isEsx) then return unsupported() end
    local ok, player = pcall(getPlayer, src)
    if not ok or not player then return false, 'no character loaded' end
    if isEsx then
        if ESX.DoesJobExist and not ESX.DoesJobExist(job, grade or 0) then return false, 'job or grade does not exist' end
        player.setJob(job, grade or 0)
        return true
    end
    if player.Functions.SetJob(job, grade or 0) == false then return false, 'job or grade does not exist' end
    return true
end

--- Adds an owned vehicle to a character's garage, whether or not they are online.
-- OP Garages (OtherPlanet, op-garages v2) keeps the garage in its own column, vehicleGarage (a garage number from
-- Garage Admin), and flips the stored flag: state / stored 0 = in a garage, 1 = out.
local function opGarages() return running('op-garages') end

--- The OP Garages garage to use: the number staff typed, or the lowest numbered garage.
local function opGarageIndex(wanted)
    if tonumber(wanted) then return tostring(wanted) end
    local ok, all = pcall(function() return exports['op-garages']:getAllGarages() end)
    local first
    for idx in pairs(ok and type(all) == 'table' and all or {}) do
        if not first or (tonumber(idx) or math.huge) < (tonumber(first) or math.huge) then first = idx end
    end
    return first and tostring(first) or nil
end

local function opGarageLabel(idx)
    if idx == nil then return nil end
    local ok, g = pcall(function() return exports['op-garages']:getGarageByIndex(tostring(idx)) end)
    return ok and type(g) == 'table' and (g.Label or g.label or g.name) or tostring(idx)
end

--- After a vehicle is created, put it in an OP Garages garage so it shows there.
local function opPark(plate, garage)
    local idx = opGarageIndex(garage)
    if not idx then return false, 'OP Garages has no garages set up' end
    if isQb then
        MySQL.update.await('UPDATE player_vehicles SET state = 0, vehicleGarage = ? WHERE plate = ?', { idx, plate })
    else
        MySQL.update.await('UPDATE owned_vehicles SET stored = 0, vehicleGarage = ? WHERE plate = ?', { idx, plate })
    end
    return true
end

--- v = { license, citizenId, model, plate, garage }. Returns ok, errorMessage.
--- QBox uses qbx_vehicles when it is running; QBCore writes player_vehicles; ESX writes owned_vehicles.
--- With OP Garages, the vehicle is then parked in an OP Garages garage (the garage number, or the first one).
--- Change the table or columns here if your garage script stores vehicles differently.
local giveVehicle

function Bridge.GiveVehicle(v)
    local ok, err = giveVehicle(v)
    if ok and opGarages() then
        local ran, parked, perr = pcall(opPark, (v.plate or ''):upper(), v.garage)
        -- The vehicle exists either way, so this is not a failure (a failure would release a linked Tebex payment).
        if not ran or not parked then
            print(('^3[helm]^7 vehicle %s was added but not parked in OP Garages: %s'):format(v.plate, tostring(ran and perr or parked)))
        end
    end
    return ok, err
end

function giveVehicle(v)
    Bridge.Ready()
    if not (isQb or isEsx) then return unsupported() end
    local plate = (v.plate or ''):upper()
    if plate == '' then return false, 'missing plate' end

    if FW == 'qbox' and running('qbx_vehicles') then
        local ok, id, err = pcall(function()
            return exports.qbx_vehicles:CreatePlayerVehicle({
                model = v.model,
                citizenid = v.citizenId,
                garage = v.garage,
                props = { plate = plate },
            })
        end)
        if not ok then return false, tostring(id) end
        if not id then return false, (type(err) == 'table' and (err.message or err.code)) or 'vehicle could not be created' end
        return true
    end

    if isQb then
        if MySQL.scalar.await('SELECT 1 FROM player_vehicles WHERE plate = ?', { plate }) then
            return false, 'plate already in use'
        end
        MySQL.insert.await(
            'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            { v.license, v.citizenId, v.model, GetHashKey(v.model), '{}', plate, v.garage, 1 }
        )
        return true
    end

    -- ESX: the vehicle column holds vehicle properties; model and plate are enough for garages to spawn it.
    if MySQL.scalar.await('SELECT 1 FROM owned_vehicles WHERE plate = ?', { plate }) then
        return false, 'plate already in use'
    end
    MySQL.insert.await(
        'INSERT INTO owned_vehicles (owner, plate, vehicle, stored) VALUES (?, ?, ?, ?)',
        { v.citizenId, plate, json.encode({ model = GetHashKey(v.model), plate = plate }), 1 }
    )
    return true
end

--- Revive the player with whatever your ambulance script uses (auto-detected, or Config.ReviveEvent).
--- Dead or downed by whichever signal the medical script gives. Downed players often still have health above 0.
function Bridge.IsDown(src)
    local ped = GetPlayerPed(src)
    if ped and ped ~= 0 and GetEntityHealth(ped) <= 0 then return true end
    local c = Bridge.Character(src)
    if c and c.down then return true end
    local st = Player(src).state
    local bd = st.BodyDamage -- OSP Ambulance
    if type(bd) == 'table' and (bd.isDead or bd.inLastStand) then return true end
    return st.isDead == true or st.dead == true or st.inLaststand == true or st.isDown == true -- wasabi and others
end

--- Works like txAdmin's heal: the ambulance script's revive, a native resurrect on the player's game, then
--- txAdmin's heal events for scripts that listen to those (some only accept them from txAdmin itself).
function Bridge.Revive(src, by)
    Bridge.Ready()
    -- Same call as qbx_medical's /revive: fires the revive event and refills hunger and thirst.
    if REVIVE == QBX_REVIVE and running('qbx_medical') then
        exports.qbx_medical:Revive(src)
    else
        -- true = admin revive: OSP skips its "insurvivable injuries" block, other scripts ignore the extra arg.
        TriggerClientEvent(REVIVE, src, true)
    end
    TriggerClientEvent('helm:client:revive', src)
    TriggerEvent('txAdmin:events:healedPlayer', { id = src })
    TriggerEvent('txAdmin:events:playerHealed', { target = src, author = by or 'Helm' })
end

--- Vehicles owned by the given character ids: { { citizenId, plate, model, garage, state }, ... }
function Bridge.OwnedVehicles(citizenIds)
    Bridge.Ready()
    local out = {}
    -- A missing table (different garage script) must not crash the sync, so each query is protected.
    local op = opGarages()
    -- Helm's state: 1 in a garage, 0 out, 2 impounded. OP Garages: 0 in a garage, 1 out, towed = impounded.
    local function opState(flag, towed)
        if towed == 1 or towed == true then return 2 end
        return (flag == 0 or flag == false) and 1 or 0
    end
    if isQb then
        local ok, rows = pcall(function()
            return MySQL.query.await(
                op and 'SELECT plate, vehicle, citizenid, vehicleGarage, isTowedOut, state FROM player_vehicles WHERE citizenid IN (?)'
                    or 'SELECT plate, vehicle, citizenid, garage, state FROM player_vehicles WHERE citizenid IN (?)',
                { citizenIds }
            )
        end)
        for _, r in ipairs(ok and rows or {}) do
            out[#out + 1] = {
                citizenId = r.citizenid, plate = r.plate, model = r.vehicle,
                garage = op and opGarageLabel(r.vehicleGarage) or r.garage,
                state = op and opState(r.state, r.isTowedOut) or r.state or 1,
            }
        end
    elseif isEsx then
        local ok, rows = pcall(function()
            return MySQL.query.await(
                op and 'SELECT plate, vehicle, owner, stored, vehicleGarage, isTowedOut FROM owned_vehicles WHERE owner IN (?)'
                    or 'SELECT plate, vehicle, owner, stored FROM owned_vehicles WHERE owner IN (?)',
                { citizenIds }
            )
        end)
        for _, r in ipairs(ok and rows or {}) do
            local props = type(r.vehicle) == 'string' and json.decode(r.vehicle) or nil
            out[#out + 1] = {
                citizenId = r.owner,
                plate = r.plate,
                model = props and props.model and tostring(props.model) or 'unknown',
                garage = op and opGarageLabel(r.vehicleGarage) or nil,
                state = op and opState(r.stored, r.isTowedOut) or ((r.stored == 1 or r.stored == true) and 1 or 0),
            }
        end
    end
    return out
end

-- Event subscriptions used by the activity log. Each one waits for detection, then subscribes.
-- If your framework uses different events, change them here.

--- cb(src, account, amount, kind, reason)   kind is 'add', 'remove' or 'set'
function Bridge.OnMoneyChange(cb)
    CreateThread(function()
        Bridge.Ready()
        if isQb then
            AddEventHandler('QBCore:Server:OnMoneyChange', function(src, account, amount, kind, reason)
                if src then cb(src, account, amount, kind, reason) end
            end)
        elseif isEsx then
            -- ESX has no stable server-side money event across versions, so compare balances every few seconds.
            local last = {}
            AddEventHandler('playerDropped', function() last[source] = nil end)
            while true do
                Wait(5000)
                for _, s in ipairs(GetPlayers()) do
                    local src = tonumber(s)
                    local ok, player = pcall(getPlayer, src)
                    if ok and player and player.getMoney then
                        local cash, bank = esxMoney(player)
                        local prev = last[src]
                        if prev then
                            for account, now in pairs({ cash = cash, bank = bank }) do
                                local diff = now - prev[account]
                                if diff ~= 0 then cb(src, account, math.abs(diff), diff > 0 and 'add' or 'remove', 'balance changed') end
                            end
                        end
                        last[src] = { cash = cash, bank = bank }
                    end
                end
            end
        end
    end)
end

--- cb(src, jobName, gradeLevel)
function Bridge.OnJobChange(cb)
    CreateThread(function()
        Bridge.Ready()
        if isQb then
            AddEventHandler('QBCore:Server:OnJobUpdate', function(src, job)
                if src and type(job) == 'table' then cb(src, job.name, job.grade and job.grade.level) end
            end)
        elseif isEsx then
            AddEventHandler('esx:setJob', function(src, job)
                if src and type(job) == 'table' then cb(src, job.name, job.grade) end
            end)
        end
    end)
end

--- cb(src)
function Bridge.OnCharacterLoaded(cb)
    CreateThread(function()
        Bridge.Ready()
        if isQb then
            AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
                local src = player and player.PlayerData and player.PlayerData.source
                if src then cb(src) end
            end)
        elseif isEsx then
            AddEventHandler('esx:playerLoaded', function(src) if src then cb(src) end end)
        end
    end)
end

--- cb(src)
function Bridge.OnCharacterUnloaded(cb)
    CreateThread(function()
        Bridge.Ready()
        if isQb then
            AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
                if src then cb(src) end
            end)
        elseif isEsx then
            AddEventHandler('esx:playerDropped', function(src) if src then cb(src) end end)
        end
    end)
end

--- cb(src, itemName, count, fromType, toType) for items that change hands. ox_inventory only.
function Bridge.OnItemMove(cb)
    CreateThread(function()
        Bridge.Ready()
        if INV ~= 'ox_inventory' then return end
        local tries = 0
        while not running('ox_inventory') and tries < 30 do Wait(1000); tries = tries + 1 end
        if not running('ox_inventory') then return end
        exports.ox_inventory:registerHook('swapItems', function(payload)
            if payload.fromInventory == payload.toInventory then return end
            local item = payload.fromSlot
            if type(item) ~= 'table' or not item.name then return end
            cb(payload.source, item.name, payload.count or item.count or 1, payload.fromType, payload.toType)
        end, {})
    end)
end
