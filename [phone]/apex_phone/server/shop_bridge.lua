-- ------------------------------------------------------------
-- LOJA DE TELEMOVEIS (ex-apex_phoneshop): ponte de framework do servidor, 2026-10-03
-- ESX / QBCore / QBox, com ox_inventory primeiro. A logica e a do apex_phoneshop (provada): so mudou o nome
-- (ShopBridge, para nao chocar com nada do telemovel, que usa FW) e o aviso, que agora sai pelo FW.Notify do
-- telemovel (o cliente traduz o texto portugues para o idioma do telemovel em client/i18n.lua).
--   ShopBridge.name                         'esx' | 'qb' | 'qbx' | nil (sem framework: nada se vende)
--   ShopBridge.Ready()                      true depois de detetar o framework
--   ShopBridge.HasPlayer(src)               o jogador tem personagem carregada
--   ShopBridge.GetBalance(src, conta)       numero ou nil       conta = 'cash' | 'bank'
--   ShopBridge.RemoveMoney(src, conta, n, motivo) / ShopBridge.AddMoney(...)  -> true/false (VERIFICADO no saldo)
--   ShopBridge.ItemExists(item) · ShopBridge.ItemLabel(item) · ShopBridge.CanCarry(src, item, n)
--   ShopBridge.AddItem(src, item, n, meta)  -> true/false · ShopBridge.CountItems(src, lista) -> { [item] = n }
--   ShopBridge.Notify(src, msg, tipo)       tipo = 'success' | 'error' | 'info' (texto em portugues)
--   ShopBridge.IsAdmin(src) · ShopBridge.Identifier(src) · ShopBridge.CharName(src)
-- So o server/shop.lua usa isto; o resto do telemovel continua no FW (server/framework.lua).
-- ------------------------------------------------------------
ShopBridge = { name = nil }

local ESX, QB = nil, nil
local warned = {}

local function log(msg) print(('^2[apex_phone]^0 shop: %s'):format(msg)) end
local function warn(msg) print(('^3[apex_phone]^0 shop: %s'):format(msg)) end
local function warnOnce(key, msg) if not warned[key] then warned[key] = true warn(msg) end end
local function started(res) local s = GetResourceState(res) return s == 'started' or s == 'starting' end
ShopBridge.log, ShopBridge.warn, ShopBridge.warnOnce, ShopBridge.started = log, warn, warnOnce, started

-- exports['x'].y rebenta ao INDEXAR quando o recurso ou o export nao existem: o pcall envolve o
-- index e a chamada, e table.pack guarda TODOS os valores devolvidos (o pcall simples corta-os).
local function call(res, fn, ...)
    if not started(res) then return false end
    local args = table.pack(...)
    local r = table.pack(pcall(function()
        return exports[res][fn](exports[res], table.unpack(args, 1, args.n))
    end))
    if not r[1] then
        warnOnce(res .. ':' .. fn, ('%s:%s failed: %s'):format(res, fn, tostring(r[2])))
        return false
    end
    return true, table.unpack(r, 2, r.n)
end
ShopBridge.call = call

local function oxInv() return started('ox_inventory') end

-- ------------------------------------------------------------
-- Detecao (com novas tentativas: o framework pode arrancar depois deste recurso)
-- ------------------------------------------------------------
local function detect()
    local want = Config.Framework or 'auto'
    if want == 'esx' or want == 'qb' or want == 'qbx' then return want end
    if started('qbx_core') then return 'qbx' end
    if started('qb-core') then return 'qb' end
    if started('es_extended') then return 'esx' end
    return nil
end

local function init(name)
    if name == 'esx' then
        local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
        if not ok or type(obj) ~= 'table' then return false end
        ESX = obj
    elseif name == 'qb' then
        local ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
        if not ok or type(obj) ~= 'table' then return false end
        QB = obj
    elseif name == 'qbx' then
        -- o Qbox NAO tem GetCoreObject: so exports, resolvidos em cada chamada
        local ok = pcall(function() return exports.qbx_core:GetPlayer(0) end)
        if not ok then return false end
    else
        return false
    end
    ShopBridge.name = name
    log(('framework: %s · inventory: %s'):format(({ esx = 'ESX', qb = 'QBCore', qbx = 'QBox' })[name], oxInv() and 'ox_inventory' or name))
    return true
end

function ShopBridge.Ready() return ShopBridge.name ~= nil end

CreateThread(function()
    for _ = 1, 60 do
        local n = detect()
        if n and init(n) then return end
        Wait(1000)
    end
    print('^3[apex_phone]^0 shop: no framework found (es_extended / qb-core / qbx_core). Without a framework the shop opens but cannot sell.')
end)

-- ------------------------------------------------------------
-- Jogador
-- ------------------------------------------------------------
local function esxPlayer(src)
    if not ESX then return nil end
    local ok, x = pcall(function() return ESX.GetPlayerFromId(src) end)
    if ok and type(x) == 'table' then return x end
    return nil
end

local function qbPlayer(src)
    if ShopBridge.name == 'qbx' then
        local ok, P = call('qbx_core', 'GetPlayer', src)
        if ok and type(P) == 'table' then return P end
        return nil
    end
    if not QB then return nil end
    local ok, P = pcall(function() return QB.Functions.GetPlayer(src) end)
    if ok and type(P) == 'table' then return P end
    return nil
end

function ShopBridge.HasPlayer(src)
    src = tonumber(src)
    if not src or src <= 0 or not ShopBridge.name then return false end
    if ShopBridge.name == 'esx' then return esxPlayer(src) ~= nil end
    return qbPlayer(src) ~= nil
end

function ShopBridge.Identifier(src)
    if ShopBridge.name == 'esx' then
        local x = esxPlayer(src)
        return x and x.identifier or nil
    end
    local P = qbPlayer(src)
    return P and P.PlayerData and P.PlayerData.citizenid or nil
end

function ShopBridge.CharName(src)
    if ShopBridge.name == 'esx' then
        local x = esxPlayer(src)
        if x then
            local ok, n = pcall(function() return x.getName() end)
            if ok and n then return tostring(n) end
        end
    else
        local P = qbPlayer(src)
        local ci = P and P.PlayerData and P.PlayerData.charinfo
        if ci then
            local n = ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
            if n ~= '' then return n end
        end
    end
    return GetPlayerName(src) or ('#' .. tostring(src))
end

-- ------------------------------------------------------------
-- Dinheiro
-- ESX + ox_inventory: o dinheiro vivo e o item 'money' do ox_inventory (o ESX so o espelha), por isso
-- le-se e mexe-se diretamente no ox. Banco: xPlayer.getAccount/removeAccountMoney.
-- ⚠ No es_extended 1.13 o override do ox_inventory (server/classes/overrides/oxinventory.lua) muda o
--   saldo e SO DEPOIS rebenta em `Inventory.accounts` quando o ox arrancou antes do ESX. Por isso cada
--   operacao e confirmada lendo o saldo outra vez, e um erro depois de o dinheiro mexer conta como feito.
-- ------------------------------------------------------------
local function qbMoneyType(t) return t == 'bank' and 'bank' or 'cash' end

function ShopBridge.GetBalance(src, account)
    src = tonumber(src)
    if not src or not ShopBridge.name then return nil end
    if ShopBridge.name == 'esx' then
        if account == 'cash' and oxInv() then
            local ok, n = call('ox_inventory', 'GetItemCount', src, 'money')
            if ok and tonumber(n) then return tonumber(n) end
        end
        local x = esxPlayer(src)
        if not x then return nil end
        local ok, acc = pcall(function() return x.getAccount(account == 'bank' and 'bank' or 'money') end)
        if ok and type(acc) == 'table' then return tonumber(acc.money) or 0 end
        return nil
    end
    local mt = qbMoneyType(account)
    if ShopBridge.name == 'qbx' then
        local ok, v = call('qbx_core', 'GetMoney', src, mt)
        if ok and tonumber(v) then return tonumber(v) end
    end
    local P = qbPlayer(src)
    if not P then return nil end
    local pd = P.PlayerData
    if pd and pd.money and tonumber(pd.money[mt]) then return tonumber(pd.money[mt]) end
    return nil
end

local function moved(before, after, amount, sign)
    if not before or not after then return false end
    if sign < 0 then return after <= before - amount + 0.001 end
    return after >= before + amount - 0.001
end

function ShopBridge.RemoveMoney(src, account, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return amount == 0 end
    local before = ShopBridge.GetBalance(src, account)
    if not before or before < amount then return false end
    reason = reason or 'apex_phone'
    if ShopBridge.name == 'esx' then
        if account == 'cash' and oxInv() then
            local ok, r = call('ox_inventory', 'RemoveItem', src, 'money', amount)
            if ok and r then return true end
            return moved(before, ShopBridge.GetBalance(src, 'cash'), amount, -1)
        end
        local x = esxPlayer(src)
        if not x then return false end
        local acc = account == 'bank' and 'bank' or 'money'
        local ok, err = pcall(function() x.removeAccountMoney(acc, amount, reason) end)
        if ok then return true end
        if moved(before, ShopBridge.GetBalance(src, account), amount, -1) then
            warnOnce('esx_remove_after', ('removeAccountMoney took the money and then crashed (ox_inventory override in es_extended): %s'):format(tostring(err)))
            return true
        end
        warn(('removeAccountMoney failed: %s'):format(tostring(err)))
        return false
    end
    local mt = qbMoneyType(account)
    if ShopBridge.name == 'qbx' then
        local ok, r = call('qbx_core', 'RemoveMoney', src, mt, amount, reason)
        if ok and r ~= nil then return r ~= false end
    end
    local P = qbPlayer(src)
    if not (P and P.Functions and P.Functions.RemoveMoney) then return false end
    local ok, r = pcall(function() return P.Functions.RemoveMoney(mt, amount, reason) end)
    if ok and r ~= nil then return r ~= false end
    return moved(before, ShopBridge.GetBalance(src, account), amount, -1)
end

function ShopBridge.AddMoney(src, account, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return amount == 0 end
    local before = ShopBridge.GetBalance(src, account)
    reason = reason or 'apex_phone'
    if ShopBridge.name == 'esx' then
        if account == 'cash' and oxInv() then
            local ok, r = call('ox_inventory', 'AddItem', src, 'money', amount)
            if ok and r then return true end
            return moved(before, ShopBridge.GetBalance(src, 'cash'), amount, 1)
        end
        local x = esxPlayer(src)
        if not x then return false end
        local acc = account == 'bank' and 'bank' or 'money'
        local ok, err = pcall(function() x.addAccountMoney(acc, amount, reason) end)
        if ok then return true end
        if moved(before, ShopBridge.GetBalance(src, account), amount, 1) then return true end
        warn(('addAccountMoney failed: %s'):format(tostring(err)))
        return false
    end
    local mt = qbMoneyType(account)
    if ShopBridge.name == 'qbx' then
        local ok, r = call('qbx_core', 'AddMoney', src, mt, amount, reason)
        if ok and r ~= nil then return r ~= false end
    end
    local P = qbPlayer(src)
    if not (P and P.Functions and P.Functions.AddMoney) then return false end
    local ok, r = pcall(function() return P.Functions.AddMoney(mt, amount, reason) end)
    if ok and r ~= nil then return r ~= false end
    return moved(before, ShopBridge.GetBalance(src, account), amount, 1)
end

-- ------------------------------------------------------------
-- Itens (ox_inventory primeiro, em qualquer framework)
-- ------------------------------------------------------------
local function oxItem(item)
    local ok, data = call('ox_inventory', 'Items', item)
    if ok and type(data) == 'table' then return data end
    return nil
end

function ShopBridge.ItemExists(item)
    if type(item) ~= 'string' or item == '' then return false end
    if oxInv() then return oxItem(item) ~= nil end
    if ShopBridge.name == 'esx' and ESX then
        local ok, label = pcall(function() return ESX.GetItemLabel(item) end)
        return ok and label ~= nil
    end
    if ShopBridge.name == 'qb' and QB then
        return QB.Shared and QB.Shared.Items and QB.Shared.Items[item] ~= nil or false
    end
    if ShopBridge.name == 'qbx' then
        local ok, items = call('qbx_core', 'GetItems')
        if ok and type(items) == 'table' then return items[item] ~= nil end
    end
    return false
end

function ShopBridge.ItemLabel(item)
    if oxInv() then
        local d = oxItem(item)
        if d and d.label then return tostring(d.label) end
    end
    if ShopBridge.name == 'esx' and ESX then
        local ok, label = pcall(function() return ESX.GetItemLabel(item) end)
        if ok and label then return tostring(label) end
    end
    if ShopBridge.name == 'qb' and QB and QB.Shared and QB.Shared.Items and QB.Shared.Items[item] then
        return tostring(QB.Shared.Items[item].label or item)
    end
    return nil
end

function ShopBridge.CanCarry(src, item, count)
    count = math.max(1, math.floor(tonumber(count) or 1))
    if oxInv() then
        local ok, r = call('ox_inventory', 'CanCarryItem', src, item, count)
        if ok then return r == true or r == 1 end
        return false
    end
    if ShopBridge.name == 'esx' then
        local x = esxPlayer(src)
        if not x then return false end
        local ok, r = pcall(function() return x.canCarryItem(item, count) end)
        if ok and r ~= nil then return r == true end
        return true
    end
    if started('qb-inventory') then
        local ok, r = call('qb-inventory', 'CanAddItem', src, item, count)
        if ok and r ~= nil then return r == true end
    end
    return true   -- sem forma de saber: o AddItem diz se entrou e o dinheiro e devolvido se nao entrar
end

function ShopBridge.AddItem(src, item, count, meta)
    count = math.max(1, math.floor(tonumber(count) or 1))
    if type(meta) ~= 'table' then meta = nil end
    if oxInv() then
        local ok, success = call('ox_inventory', 'AddItem', src, item, count, meta)
        return ok and (success == true or (type(success) == 'table')) or false
    end
    if ShopBridge.name == 'esx' then
        local x = esxPlayer(src)
        if not x then return false end
        local before = 0
        pcall(function() local it = x.getInventoryItem(item); before = it and tonumber(it.count) or 0 end)
        local ok = pcall(function() x.addInventoryItem(item, count) end)
        if not ok then return false end
        local after = 0
        pcall(function() local it = x.getInventoryItem(item); after = it and tonumber(it.count) or 0 end)
        return after >= before + count
    end
    local P = qbPlayer(src)
    if not (P and P.Functions and P.Functions.AddItem) then return false end
    local ok, r = pcall(function() return P.Functions.AddItem(item, count, false, meta) end)
    return ok and r ~= false and r ~= nil
end

-- { [item] = unidades } para uma lista de itens (UMA chamada ao ox_inventory)
function ShopBridge.CountItems(src, list)
    local out = {}
    for _, it in ipairs(list) do out[it] = 0 end
    if #list == 0 then return out end
    if oxInv() then
        local ok, r = call('ox_inventory', 'Search', src, 'count', list)
        if ok and type(r) == 'table' then
            for k, v in pairs(r) do if out[k] ~= nil then out[k] = tonumber(v) or 0 end end
            return out
        elseif ok and tonumber(r) and #list == 1 then
            out[list[1]] = tonumber(r)
            return out
        end
        for _, it in ipairs(list) do
            local ok2, n = call('ox_inventory', 'GetItemCount', src, it)
            if ok2 then out[it] = tonumber(n) or 0 end
        end
        return out
    end
    if ShopBridge.name == 'esx' then
        local x = esxPlayer(src)
        if not x then return out end
        for _, it in ipairs(list) do
            pcall(function() local e = x.getInventoryItem(it); out[it] = e and tonumber(e.count) or 0 end)
        end
        return out
    end
    local P = qbPlayer(src)
    local items = P and P.PlayerData and P.PlayerData.items
    if type(items) == 'table' then
        for _, e in pairs(items) do
            if type(e) == 'table' and e.name and out[e.name] ~= nil then
                out[e.name] = out[e.name] + (tonumber(e.amount or e.count) or 0)
            end
        end
    end
    return out
end

-- ------------------------------------------------------------
-- Avisos e permissoes
-- ------------------------------------------------------------
-- o texto segue em portugues: o FW.Notify do telemovel manda-o ao cliente, que o traduz (client/i18n.lua) e o
-- mostra pelo framework dele (ox_lib, QBCore, ESX ou chat)
local NTYPE = { success = 'success', error = 'error', info = 'primary' }
function ShopBridge.Notify(src, msg, ntype)
    src = tonumber(src)
    if not src or src <= 0 then return end
    if FW and FW.Notify then FW.Notify(src, msg, NTYPE[ntype or 'info'] or 'primary') end
end

function ShopBridge.IsAdmin(src)
    src = tonumber(src) or 0
    if src == 0 then return true end
    if IsPhoneAdmin then return IsPhoneAdmin(src) == true end
    if IsPlayerAceAllowed(src, 'command') or IsPlayerAceAllowed(src, 'apex_phone.admin') then return true end
    if ShopBridge.name == 'esx' then
        local x = esxPlayer(src)
        local ok, g = pcall(function() return x and x.getGroup() end)
        g = ok and g or 'user'
        return g == 'admin' or g == 'superadmin' or g == 'owner' or g == '_dev' or IsPlayerAceAllowed(src, 'group.admin')
    elseif ShopBridge.name == 'qb' and QB then
        local ok, r = pcall(function() return QB.Functions.HasPermission(src, 'admin') or QB.Functions.HasPermission(src, 'god') end)
        if ok and r then return true end
        return IsPlayerAceAllowed(src, 'qbcore.admin') or IsPlayerAceAllowed(src, 'qbcore.god')
    elseif ShopBridge.name == 'qbx' then
        return IsPlayerAceAllowed(src, 'group.admin') or IsPlayerAceAllowed(src, 'qbcore.admin')
    end
    return false
end
