-- ------------------------------------------------------------
-- FW: ponte de framework (client)
--   Detecta qbx_core / qb-core / es_extended e expõe uma API única
--   usada pelo resto do client (nunca usar QBCore/ESX directamente).
--
--   FW.name                 'qbx' | 'qb' | 'esx' | 'standalone' | 'none'
--   FW.GetCore()            objecto do framework (QBCore / ESX) ou nil
--   FW.GetPlayerData()      { cid, firstname, lastname, phone, birthdate,
--                             job = { name, label, onduty, grade, gradeLevel },
--                             cash, bank, loaded }
--   FW.IsLoggedIn()         boolean
--   FW.IsDead()             boolean (morto ou caído: QB/QBox metadata isdead/inlaststand,
--                             ESX esx:onPlayerDeath/esx:onPlayerSpawn, e sempre IsEntityDead)
--   FW.HasItem(item)        número (quantidade; 0 se não tem)
--   FW.Notify(msg, type)    'primary'|'inform'|'success'|'error'|'warning'
--   FW.SetSession(cid)      standalone: a identidade vem do push 'session' do servidor
--   FW.OnPlayerLoaded(fn)   fn()
--   FW.OnPlayerUnload(fn)   fn()
--   FW.OnJobUpdate(fn)      fn(job)  (job já normalizado)
--   FW.OnMoneyChange(fn)    fn()
--   FW.OnDataChange(fn)     fn()     (qualquer alteração aos dados do jogador)
-- ------------------------------------------------------------
FW = { name = 'none', loaded = false }

local core = nil

local function started(res)
    local s = GetResourceState(res)
    return s == 'started' or s == 'starting'
end

-- Config.Framework forçado vale também no cliente (o servidor já o respeitava): com dois
-- frameworks iniciados, cliente e servidor tinham de escolher o MESMO.
local FORCED = { qb = true, qbx = true, esx = true, standalone = true }
if FORCED[Config.Framework] then
    FW.name = Config.Framework
elseif started('qbx_core') then
    FW.name = 'qbx'
elseif started('qb-core') then
    FW.name = 'qb'
elseif started('es_extended') then
    FW.name = 'esx'
end

-- ------------------------------------------------------------
-- Core object (carregado de forma preguiçosa: o resource pode ainda estar a arrancar)
-- ------------------------------------------------------------
local function fetchCore()
    local ok, obj
    if FW.name == 'qbx' then
        ok, obj = pcall(function() return exports.qbx_core:GetCoreObject() end)
        if not ok or type(obj) ~= 'table' then
            ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
        end
    elseif FW.name == 'qb' then
        ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
    elseif FW.name == 'esx' then
        ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
    end
    if ok and type(obj) == 'table' then return obj end
    return nil
end

function FW.GetCore()
    if core then return core end
    core = fetchCore()
    return core
end

-- ------------------------------------------------------------
-- Dados do jogador (raw por framework)
-- ------------------------------------------------------------
local function rawPlayerData()
    if FW.name == 'qbx' then
        local ok, pd = pcall(function() return exports.qbx_core:GetPlayerData() end)
        if ok and type(pd) == 'table' then return pd end
        local c = FW.GetCore()
        if c and c.Functions and c.Functions.GetPlayerData then
            local ok2, pd2 = pcall(c.Functions.GetPlayerData)
            if ok2 and type(pd2) == 'table' then return pd2 end
        end
        return nil
    elseif FW.name == 'qb' then
        local c = FW.GetCore()
        if c and c.Functions and c.Functions.GetPlayerData then
            local ok, pd = pcall(c.Functions.GetPlayerData)
            if ok and type(pd) == 'table' then return pd end
        end
        return nil
    elseif FW.name == 'esx' then
        local c = FW.GetCore()
        if c and c.GetPlayerData then
            local ok, pd = pcall(c.GetPlayerData)
            if ok and type(pd) == 'table' then return pd end
        end
        return nil
    end
    return nil
end

local function normJobQB(job)
    job = job or {}
    local grade = job.grade
    local gradeName, gradeLevel = '', 0
    if type(grade) == 'table' then
        gradeName  = grade.name or ''
        gradeLevel = tonumber(grade.level) or 0
    elseif grade ~= nil then
        gradeName  = tostring(grade)
        gradeLevel = tonumber(grade) or 0
    end
    return {
        name       = job.name or 'unemployed',
        label      = job.label or 'Desempregado',
        onduty     = job.onduty and true or false,
        grade      = gradeName,
        gradeLevel = gradeLevel,
    }
end

local function normJobESX(job)
    job = job or {}
    return {
        name       = job.name or 'unemployed',
        label      = job.label or 'Desempregado',
        onduty     = (job.onDuty == nil and true) or (job.onDuty and true or false),
        grade      = job.grade_label or job.grade_name or (job.grade ~= nil and tostring(job.grade)) or '',
        gradeLevel = tonumber(job.grade) or 0,
    }
end

local function splitName(full)
    full = tostring(full or '')
    local first, last = full:match('^(%S+)%s+(.+)$')
    if first then return first, last end
    return full, ''
end

-- standalone: não há framework a dizer quem é a personagem; o servidor decide (licença) e manda
-- o push 'session'. Até lá o jogador não está "carregado".
local sessionCid = nil

function FW.GetPlayerData()
    if FW.name == 'standalone' then
        return { cid = sessionCid, firstname = GetPlayerName(PlayerId()) or 'Jogador', lastname = '', phone = nil, birthdate = nil,
                 job = normJobQB(nil), cash = 0, bank = 0, loaded = sessionCid ~= nil }
    end
    local pd = rawPlayerData()
    if FW.name == 'esx' then
        if not pd or not pd.identifier then
            return { cid = nil, firstname = 'Jogador', lastname = '', phone = nil, birthdate = nil,
                     job = normJobESX(nil), cash = 0, bank = 0, loaded = false }
        end
        local first, last = pd.firstName, pd.lastName
        if not first then first, last = splitName(pd.name) end
        local cash, bank = 0, 0
        if type(pd.accounts) == 'table' then
            for _, acc in pairs(pd.accounts) do
                if type(acc) == 'table' then
                    if acc.name == 'money' then cash = tonumber(acc.money) or 0 end
                    if acc.name == 'bank' then bank = tonumber(acc.money) or 0 end
                end
            end
        end
        if cash == 0 and pd.money then cash = tonumber(pd.money) or 0 end
        local meta = type(pd.metadata) == 'table' and pd.metadata or {}
        return {
            cid       = pd.identifier,
            firstname = first or 'Jogador',
            lastname  = last or '',
            phone     = pd.phone_number or pd.phoneNumber or meta.phone or meta.phone_number,
            birthdate = pd.dateofbirth or meta.dateofbirth,
            job       = normJobESX(pd.job),
            cash      = cash,
            bank      = bank,
            loaded    = true,
        }
    end

    -- qb / qbx (mesma forma de PlayerData)
    if not pd or not pd.citizenid then
        return { cid = nil, firstname = 'Jogador', lastname = '', phone = nil, birthdate = nil,
                 job = normJobQB(nil), cash = 0, bank = 0, loaded = false }
    end
    local ci = pd.charinfo or {}
    local money = pd.money or {}
    return {
        cid       = pd.citizenid,
        firstname = ci.firstname or 'Jogador',
        lastname  = ci.lastname or '',
        phone     = ci.phone,
        birthdate = ci.birthdate,
        job       = normJobQB(pd.job),
        cash      = tonumber(money.cash) or 0,
        bank      = tonumber(money.bank) or 0,
        loaded    = true,
    }
end

function FW.IsLoggedIn()
    if FW.name == 'qb' or FW.name == 'qbx' then
        local ok, st = pcall(function() return LocalPlayer.state.isLoggedIn end)
        if ok and st ~= nil then return st and true or false end
    end
    return FW.GetPlayerData().loaded
end

-- ------------------------------------------------------------
-- Morto / caído
-- Chamado de 700 em 700 ms só com o telemóvel aberto ou em chamada (client/main.lua), e ao abrir.
-- ------------------------------------------------------------
local esxDead = false

function FW.IsDead()
    local ped = PlayerPedId()
    if ped ~= 0 and (IsEntityDead(ped) or IsPedDeadOrDying(ped, true)) then return true end
    -- scripts de ambulância que publicam o estado numa state bag (qualquer framework)
    if LocalPlayer.state.isDead == true then return true end
    if FW.name == 'qb' or FW.name == 'qbx' then
        -- qb-ambulancejob / qbx_medical: o ped está VIVO (animação no chão), só a metadata o diz
        local pd = rawPlayerData()
        local meta = pd and pd.metadata
        if type(meta) == 'table' and (meta.isdead or meta.inlaststand) then return true end
    elseif FW.name == 'esx' then
        return esxDead
    end
    return false
end

-- ------------------------------------------------------------
-- Inventário
-- ------------------------------------------------------------
local function countFromList(list, item)
    if type(list) ~= 'table' then return 0 end
    local n = 0
    for _, it in pairs(list) do
        if type(it) == 'table' and it.name == item then
            n = n + (tonumber(it.amount or it.count) or 1)
        end
    end
    return n
end

function FW.HasItem(item)
    if not item or item == '' then return 0 end
    if started('ox_inventory') then
        local ok, n = pcall(function() return exports.ox_inventory:Search('count', item) end)
        if ok and type(n) == 'number' then return n end
    end
    local pd = rawPlayerData() or {}
    if FW.name == 'qbx' then
        local n = countFromList(pd.items, item)
        if n > 0 then return n end
        local ok, has = pcall(function() return exports.qbx_core:HasItem(item) end)
        if ok and has then return 1 end
        return 0
    elseif FW.name == 'qb' then
        local n = countFromList(pd.items, item)
        if n > 0 then return n end
        local c = FW.GetCore()
        if c and c.Functions and c.Functions.HasItem then
            local ok, has = pcall(c.Functions.HasItem, item)
            if ok and has then return 1 end
        end
        return 0
    elseif FW.name == 'esx' then
        local c = FW.GetCore()
        if c and c.SearchInventory then
            -- ESX.SearchInventory(items, count): sem count=true devolve a tabela do item (ou false), não um número
            local ok, n = pcall(c.SearchInventory, item, true)
            if ok and type(n) == 'number' then return n end
        end
        return countFromList(pd.inventory, item)
    end
    return 0
end

-- De um conjunto de nomes de item ({ [nome] = qualquer coisa }), o que esta na PRIMEIRA ranhura do inventario
-- (2026-10-01: a tecla abre o primeiro telemovel do inventario quando ha mais do que um). ox_inventory e QB/QBox
-- pela ranhura (`slot`); ESX pela ordem da lista. nil = nenhum, ou inventario que nao se consegue ler.
local function firstOf(list, names)
    if type(list) ~= 'table' then return nil end
    local best, bestSlot = nil, math.huge
    local order = 0
    for _, it in pairs(list) do
        order = order + 1
        if type(it) == 'table' and it.name and names[it.name] and (tonumber(it.amount or it.count) or 1) > 0 then
            local slot = tonumber(it.slot) or order
            if slot < bestSlot then best, bestSlot = it.name, slot end
        end
    end
    return best
end
function FW.FirstItemOf(names)
    if type(names) ~= 'table' then return nil end
    if started('ox_inventory') then
        local ok, items = pcall(function() return exports.ox_inventory:GetPlayerItems() end)
        if ok and type(items) == 'table' then return firstOf(items, names) end
    end
    local pd = rawPlayerData() or {}
    if FW.name == 'qbx' or FW.name == 'qb' then return firstOf(pd.items, names) end
    if FW.name == 'esx' then
        -- a lista do ESX nao tem ranhuras: a ordem e a do inventario (ipairs, nao pairs)
        if type(pd.inventory) ~= 'table' then return nil end
        for _, it in ipairs(pd.inventory) do
            if type(it) == 'table' and it.name and names[it.name] and (tonumber(it.count) or 0) > 0 then return it.name end
        end
    end
    return nil
end

-- ------------------------------------------------------------
-- Notificações
-- ------------------------------------------------------------
local OX_TYPES  = { primary = 'inform', inform = 'inform', info = 'inform', success = 'success', error = 'error', warning = 'warning', warn = 'warning' }
local QB_TYPES  = { primary = 'primary', inform = 'primary', info = 'primary', success = 'success', error = 'error', warning = 'warning', warn = 'warning' }
local ESX_TYPES = { primary = 'info', inform = 'info', info = 'info', success = 'success', error = 'error', warning = 'error', warn = 'error' }

-- msg chega em português (do cliente ou do servidor, já formatada): sai no idioma do telemóvel (client/i18n.lua)
function FW.Notify(msg, ntype)
    msg = tostring(msg or '')
    if Tr then msg = Tr(msg) end
    local title = Tr and Tr('Telemóvel') or 'Telemóvel'
    ntype = tostring(ntype or 'primary')
    if FW.name == 'standalone' and started('ox_lib') then
        TriggerEvent('ox_lib:notify', { title = title, description = msg, type = OX_TYPES[ntype] or 'inform' })
        return
    end
    if FW.name == 'qbx' then
        if started('ox_lib') then
            -- ox_lib regista este net event no client; TriggerEvent local chega-lhe sem exports
            TriggerEvent('ox_lib:notify', { title = title, description = msg, type = OX_TYPES[ntype] or 'inform' })
            return
        end
        TriggerEvent('QBCore:Notify', msg, QB_TYPES[ntype] or 'primary')
        return
    elseif FW.name == 'qb' then
        local c = FW.GetCore()
        if c and c.Functions and c.Functions.Notify then
            pcall(c.Functions.Notify, msg, QB_TYPES[ntype] or 'primary')
        else
            TriggerEvent('QBCore:Notify', msg, QB_TYPES[ntype] or 'primary')
        end
        return
    elseif FW.name == 'esx' then
        local c = FW.GetCore()
        if c and c.ShowNotification then
            pcall(c.ShowNotification, msg, ESX_TYPES[ntype] or 'info')
        else
            TriggerEvent('esx:showNotification', msg, ESX_TYPES[ntype] or 'info')
        end
        return
    end
    -- sem framework: mostra no chat
    TriggerEvent('chat:addMessage', { args = { title, msg } })
end

-- ------------------------------------------------------------
-- Eventos de ciclo de vida
-- ------------------------------------------------------------
local loadedFns, unloadFns, jobFns, moneyFns, dataFns = {}, {}, {}, {}, {}

local function fire(list, ...)
    for _, fn in ipairs(list) do
        local ok, err = pcall(fn, ...)
        if not ok then print(('[apex_phone] erro em handler FW: %s'):format(tostring(err))) end
    end
end

function FW.OnPlayerLoaded(fn) loadedFns[#loadedFns + 1] = fn end
function FW.OnPlayerUnload(fn) unloadFns[#unloadFns + 1] = fn end
function FW.OnJobUpdate(fn)    jobFns[#jobFns + 1] = fn end
function FW.OnMoneyChange(fn)  moneyFns[#moneyFns + 1] = fn end
function FW.OnDataChange(fn)   dataFns[#dataFns + 1] = fn end

if FW.name == 'qb' or FW.name == 'qbx' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        core = nil -- refresca o objecto (novo PlayerData)
        FW.loaded = true
        fire(loadedFns)
    end)
    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        FW.loaded = false
        fire(unloadFns)
    end)
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
        fire(jobFns, normJobQB(job))
    end)
    RegisterNetEvent('QBCore:Client:OnMoneyChange', function() fire(moneyFns) end)
    RegisterNetEvent('QBCore:Player:SetPlayerData', function() fire(dataFns) end)
elseif FW.name == 'esx' then
    RegisterNetEvent('esx:playerLoaded', function()
        esxDead = false
        FW.loaded = true
        fire(loadedFns)
    end)
    RegisterNetEvent('esx:onPlayerLogout', function()
        esxDead = false
        FW.loaded = false
        fire(unloadFns)
    end)
    RegisterNetEvent('esx:setJob', function(job)
        fire(jobFns, normJobESX(job))
    end)
    RegisterNetEvent('esx:setAccountMoney', function() fire(moneyFns) end)
    RegisterNetEvent('esx:setPlayerData', function() fire(dataFns) end)
    -- o ESX avisa a morte e o respawn por eventos locais (esx_ambulancejob / baseevents)
    AddEventHandler('esx:onPlayerDeath', function() esxDead = true end)
    AddEventHandler('esx:onPlayerSpawn', function() esxDead = false end)
end

-- standalone: carregado = o servidor mandou a sessão. Os handlers correm numa thread à parte
-- porque o de client/main.lua espera 1,5 s e SetSession é chamado de dentro do push.
function FW.SetSession(cid)
    if FW.name ~= 'standalone' then return end
    -- só texto/número: um false (sem personagem) virava a personagem "false"
    cid = (type(cid) == 'string' or type(cid) == 'number') and tostring(cid):sub(1, 64) or nil
    if cid == '' then cid = nil end
    if cid == sessionCid then return end
    sessionCid = cid
    FW.loaded = cid ~= nil
    CreateThread(function() fire(cid and loadedFns or unloadFns) end)
end

-- Se o jogador já estiver carregado quando o resource arranca (restart), marca como loaded
CreateThread(function()
    Wait(500)
    if not FW.loaded and FW.GetPlayerData().loaded then FW.loaded = true end
end)

print(('[apex_phone] framework client: %s'):format(FW.name))
