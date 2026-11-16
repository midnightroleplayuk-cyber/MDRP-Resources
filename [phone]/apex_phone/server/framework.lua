-- ------------------------------------------------------------
-- Ponte de framework (server): QBCore / QBox / ESX / standalone
--   FW.name            'qb' | 'qbx' | 'esx' | 'standalone'
--   FW.GetPlayer(src)  -> nil ou jogador normalizado:
--        { src, cid, firstname, lastname, phone, birthdate, gender ('male'|'female'),
--          job = { name, label, grade, gradeLevel, onduty },
--          GetMoney(tipo), AddMoney(tipo, valor, motivo) -> bool, RemoveMoney(tipo, valor, motivo) -> bool,
--          Notify(msg, tipo), raw }          tipo = 'cash' | 'bank'
--   cid: citizenid (qb/qbx), identifier (esx, ex.: license:...) ou o identificador do FiveM (standalone)
--   FW.HasItem(src, item) -> unidades · FW.AddItem(src, item, n, meta) -> bool · FW.RemoveItem(src, item, n) -> bool
--   FW.InventoryName() -> 'ox_inventory' | 'qb' | 'esx' | nil
--   FW.AddMoneyOffline(cid, tipo, valor) -> bool (false = não há personagem com esse cid; o dinheiro NÃO entrou)
-- Nenhum outro ficheiro server/*.lua fala directamente com o framework nem com o inventário.
-- ------------------------------------------------------------
FW = { name = nil, ready = false }

local Core = nil            -- objecto QBCore (apenas 'qb')
local ESX  = nil            -- objecto ESX (apenas 'esx')
local warned = {}
local onLoaded, onJob, onDropped = {}, {}, {}
local pendingCommands, pendingItems, suggestions = {}, {}, {}
local esxCache  = {}        -- identifier -> { firstname, lastname, phone, sex, loaded }
local loadedAt  = {}        -- src -> os.time() (evita duplo "player loaded")
local saIds     = {}        -- standalone: src -> identificador (a "citizenid" de quem não tem framework)
FW.esxNoPhoneColumn = false

local function log(msg)  print(('^2[apex_phone]^0 %s'):format(msg)) end
local function warn(msg) print(('^3[apex_phone]^0 %s'):format(msg)) end
local function warnOnce(key, msg) if not warned[key] then warned[key] = true warn(msg) end end
local function started(res) local s = GetResourceState(res) return s == 'started' or s == 'starting' end

local function fire(list, ...)
    for _, fn in ipairs(list) do
        local ok, err = pcall(fn, ...)
        if not ok then warn('hook error: ' .. tostring(err)) end
    end
end

-- ------------------------------------------------------------
-- Detecção
-- ------------------------------------------------------------
local function detect()
    local want = Config.Framework or 'auto'
    if want ~= 'auto' then return want end
    if started('qbx_core') then return 'qbx' end
    if started('qb-core') then return 'qb' end
    if started('es_extended') then return 'esx' end
    return nil
end

-- ------------------------------------------------------------
-- Normalização
-- ------------------------------------------------------------
local function qbMoneyType(t) return (t == 'bank') and 'bank' or 'cash' end
local function esxAccount(t)  return (t == 'bank') and 'bank' or 'money' end

local function normJobQB(job)
    job = job or {}
    local g = job.grade
    return {
        name = job.name or 'unemployed', label = job.label or 'Desempregado',
        grade = (type(g) == 'table') and (g.name or '') or tostring(g or ''),
        gradeLevel = (type(g) == 'table') and (tonumber(g.level) or 0) or (tonumber(g) or 0),
        onduty = job.onduty ~= false,
    }
end

local function normJobESX(job)
    job = job or {}
    return {
        name = job.name or 'unemployed', label = job.label or 'Desempregado',
        grade = job.grade_label or job.grade_name or tostring(job.grade or ''),
        gradeLevel = tonumber(job.grade) or 0,
        onduty = job.onDuty ~= false,
    }
end

-- QBCore / QBox: o objecto do jogador é compatível (PlayerData + Functions)
local function wrapQB(P)
    if not P or type(P) ~= 'table' or not P.PlayerData then return nil end
    local pd = P.PlayerData
    local ci = pd.charinfo or {}
    local isQbx = FW.name == 'qbx'
    local gender = ci.gender
    gender = (gender == 1 or gender == '1' or gender == 'female' or gender == 'f') and 'female' or 'male'
    local p = {
        src = pd.source, cid = pd.citizenid, firstname = ci.firstname or 'Jogador', lastname = ci.lastname or '',
        phone = ci.phone, birthdate = ci.birthdate, gender = gender, job = normJobQB(pd.job), raw = P,
    }
    function p.GetMoney(t)
        local mt = qbMoneyType(t)
        if isQbx then
            local ok, v = pcall(function() return exports.qbx_core:GetMoney(p.src, mt) end)
            if ok and v ~= nil then return tonumber(v) or 0 end
        end
        if P.Functions and P.Functions.GetMoney then
            local v = P.Functions.GetMoney(mt)
            if v ~= nil then return tonumber(v) or 0 end
        end
        return (pd.money and tonumber(pd.money[mt])) or 0
    end
    function p.AddMoney(t, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return false end
        local mt = qbMoneyType(t)
        if isQbx then
            local ok, r = pcall(function() return exports.qbx_core:AddMoney(p.src, mt, amount, reason or 'apex_phone') end)
            if ok then return r ~= false end
        end
        if not (P.Functions and P.Functions.AddMoney) then return false end
        return P.Functions.AddMoney(mt, amount, reason or 'apex_phone') ~= false
    end
    function p.RemoveMoney(t, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return false end
        if p.GetMoney(t) < amount then return false end
        local mt = qbMoneyType(t)
        if isQbx then
            local ok, r = pcall(function() return exports.qbx_core:RemoveMoney(p.src, mt, amount, reason or 'apex_phone') end)
            if ok then return r ~= false end
        end
        if not (P.Functions and P.Functions.RemoveMoney) then return false end
        return P.Functions.RemoveMoney(mt, amount, reason or 'apex_phone') ~= false
    end
    function p.Notify(msg, ntype) FW.Notify(p.src, msg, ntype) end
    return p
end

-- ESX: nome/telefone vêm das variáveis do xPlayer ou da tabela users (cache por identifier)
local function esxInfo(x)
    local id = x.identifier
    local c = esxCache[id]
    if c and c.loaded then return c end
    c = c or {}
    local fn, ln
    if x.get then
        fn = x.get('firstName') or x.get('firstname')
        ln = x.get('lastName') or x.get('lastname')
    end
    if (not fn or fn == '') and x.getName then
        local full = tostring(x.getName() or '')
        local a, b = full:match('^(%S+)%s*(.*)$')
        fn, ln = a or fn, b or ln
    end
    if fn and fn ~= '' then c.firstname = c.firstname or fn end
    if ln and ln ~= '' then c.lastname = c.lastname or ln end
    local ok, row = false, nil
    if not FW.esxNoPhoneColumn then
        ok, row = pcall(function() return MySQL.single.await('SELECT firstname, lastname, sex, phone_number FROM users WHERE identifier = ? LIMIT 1', { id }) end)
        if not ok then FW.esxNoPhoneColumn = true end
    end
    if not ok then
        ok, row = pcall(function() return MySQL.single.await('SELECT firstname, lastname, sex FROM users WHERE identifier = ? LIMIT 1', { id }) end)
    end
    if ok and row then
        if not c.firstname or c.firstname == '' then c.firstname = row.firstname end
        if not c.lastname or c.lastname == '' then c.lastname = row.lastname end
        if c.phone == nil and row.phone_number and row.phone_number ~= '' then c.phone = row.phone_number end
        c.sex = row.sex
    end
    c.loaded = true
    esxCache[id] = c
    return c
end

local function wrapESX(x)
    if not x or type(x) ~= 'table' or not x.identifier then return nil end
    local info = esxInfo(x)
    local sex = (x.get and x.get('sex')) or info.sex
    local p = {
        src = x.source, cid = x.identifier, firstname = info.firstname or 'Jogador', lastname = info.lastname or '',
        phone = info.phone, birthdate = x.get and x.get('dateofbirth') or nil,
        gender = (sex == 'f' or sex == 'female' or sex == 1 or sex == '1') and 'female' or 'male',
        job = normJobESX(x.job), raw = x,
    }
    function p.GetMoney(t)
        if t == 'bank' then
            local a = x.getAccount and x.getAccount('bank')
            return a and tonumber(a.money) or 0
        end
        if x.getMoney then return tonumber(x.getMoney()) or 0 end
        local a = x.getAccount and x.getAccount('money')
        return a and tonumber(a.money) or 0
    end
    function p.AddMoney(t, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 or not x.addAccountMoney then return false end
        x.addAccountMoney(esxAccount(t), amount, reason or 'apex_phone')
        return true
    end
    function p.RemoveMoney(t, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 or not x.removeAccountMoney then return false end
        if p.GetMoney(t) < amount then return false end
        x.removeAccountMoney(esxAccount(t), amount, reason or 'apex_phone')
        return true
    end
    function p.Notify(msg, ntype) FW.Notify(p.src, msg, ntype) end
    return p
end

-- ------------------------------------------------------------
-- STANDALONE: sem framework nenhum
-- Identidade = identificador do FiveM (Config.Standalone.identifier, 'license' por omissão), nome = nome
-- do FiveM, job = unemployed. O número vive só em apex_phone_accounts (a cache Accounts do main.lua).
-- Dinheiro só através dos hooks de Config.Standalone; sem eles o saldo é 0 e nada se cobra nem paga.
-- ------------------------------------------------------------
local function saHook(name)
    local S = Config.Standalone
    local fn = type(S) == 'table' and S[name] or nil
    return type(fn) == 'function' and fn or nil
end

local function saIdentifier(src)
    local want = (type(Config.Standalone) == 'table' and Config.Standalone.identifier) or 'license'
    local ok, id = pcall(GetPlayerIdentifierByType, src, want)
    if ok and type(id) == 'string' and id ~= '' then return id end
    -- artefactos antigos sem GetPlayerIdentifierByType: procura na lista pela ordem de preferência
    local ids = {}
    for i = 0, (GetNumPlayerIdentifiers(src) or 0) - 1 do
        local v = GetPlayerIdentifier(src, i)
        if v then ids[#ids + 1] = v end
    end
    for _, pref in ipairs({ want, 'license', 'license2', 'fivem', 'discord', 'steam' }) do
        for _, v in ipairs(ids) do
            if v:sub(1, #pref + 1) == pref .. ':' then return v end
        end
    end
    return ids[1]
end

local function wrapStandalone(src)
    local name = GetPlayerName(src)
    if not name or name == '' then return nil end
    local cid = saIds[src] or saIdentifier(src)
    if not cid then return nil end
    saIds[src] = cid
    local acc = Accounts and Accounts[cid]
    local p = {
        src = src, cid = cid, firstname = name, lastname = '', phone = acc and acc.phone or nil, birthdate = nil, gender = 'male',
        job = { name = 'unemployed', label = 'Desempregado', grade = '', gradeLevel = 0, onduty = false }, raw = nil,
    }
    function p.GetMoney(t)
        local fn = saHook('getMoney'); if not fn then return 0 end
        local ok, v = pcall(fn, src, qbMoneyType(t))
        return ok and tonumber(v) or 0
    end
    function p.AddMoney(t, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        local fn = saHook('addMoney')
        if amount <= 0 or not fn then return false end
        local ok, r = pcall(fn, src, qbMoneyType(t), amount, reason or 'apex_phone')
        return ok and r == true
    end
    function p.RemoveMoney(t, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        local fn = saHook('removeMoney')
        if amount <= 0 or not fn then return false end
        if p.GetMoney(t) < amount then return false end
        local ok, r = pcall(fn, src, qbMoneyType(t), amount, reason or 'apex_phone')
        return ok and r == true
    end
    function p.Notify(msg, ntype) FW.Notify(src, msg, ntype) end
    return p
end

-- ------------------------------------------------------------
-- Jogadores
-- ------------------------------------------------------------
function FW.GetPlayer(src)
    src = tonumber(src)
    if not src or src <= 0 or not FW.ready then return nil end
    if FW.name == 'qb' then
        return wrapQB(Core.Functions.GetPlayer(src))
    elseif FW.name == 'qbx' then
        local ok, P = pcall(function() return exports.qbx_core:GetPlayer(src) end)
        return ok and wrapQB(P) or nil
    elseif FW.name == 'esx' then
        return wrapESX(ESX.GetPlayerFromId(src))
    elseif FW.name == 'standalone' then
        return wrapStandalone(src)
    end
    return nil
end

-- Só (encontrado, cid, número do framework), SEM montar o jogador normalizado.
-- GetSrcByNumber (server/main.lua) corre GetPlayerNumber para TODOS os jogadores ligados a cada
-- SMS / mensagem do Match / chamada, e o wrapQB criava 2 tabelas + 4 closures por jogador só para
-- ler dois campos (com 100 jogadores, ~700 alocações de lixo por mensagem). Mesmos valores que
-- FW.GetPlayer(src).cid / .phone; fora do QBCore usa o caminho normal.
function FW.GetCidPhone(src)
    src = tonumber(src)
    if not src or src <= 0 or not FW.ready then return false end
    if FW.name == 'qb' then
        local P = Core.Functions.GetPlayer(src)
        if not P or type(P) ~= 'table' or not P.PlayerData then return false end
        local pd = P.PlayerData
        return true, pd.citizenid, pd.charinfo and pd.charinfo.phone
    end
    -- PERFLUA (aplicado pelo STOLEN): ESX sem o wrapESX inteiro (2 x.get + 4 closures por chamada); os mesmos valores
    -- (cid = x.identifier, phone = esxInfo(x).phone). A sessao alheia NAO passa por aqui: GetCid/GetPlayerNumber do
    -- server/main.lua veem o DeviceSessions antes de chamarem esta funcao, que devolve sempre a personagem REAL.
    if FW.name == 'esx' then
        local x = ESX.GetPlayerFromId(src)
        if not x or type(x) ~= 'table' or not x.identifier then return false end
        return true, x.identifier, esxInfo(x).phone
    end
    local p = FW.GetPlayer(src)
    if not p then return false end
    return true, p.cid, p.phone
end

function FW.GetPlayerByCid(cid)
    if not cid or not FW.ready then return nil end
    cid = tostring(cid)
    if FW.name == 'qb' then
        return wrapQB(Core.Functions.GetPlayerByCitizenId(cid))
    elseif FW.name == 'qbx' then
        local ok, P = pcall(function() return exports.qbx_core:GetPlayerByCitizenId(cid) end)
        return ok and wrapQB(P) or nil
    elseif FW.name == 'esx' then
        return wrapESX(ESX.GetPlayerFromIdentifier(cid))
    elseif FW.name == 'standalone' then
        for src, id in pairs(saIds) do
            if id == cid then return wrapStandalone(src) end
        end
        -- quem ainda não passou pelo wrap (ex.: restart do recurso com jogadores ligados)
        for _, v in ipairs(GetPlayers()) do
            local n = tonumber(v)
            if n and not saIds[n] and saIdentifier(n) == cid then return wrapStandalone(n) end
        end
    end
    return nil
end

-- array de src de todos os jogadores carregados
function FW.GetPlayers()
    local out = {}
    if not FW.ready then return out end
    local ok, list = pcall(function()
        if FW.name == 'qb' then return Core.Functions.GetPlayers() end
        if FW.name == 'qbx' then
            local t, players = {}, exports.qbx_core:GetQBPlayers()
            for k, v in pairs(players or {}) do t[#t + 1] = tonumber(k) or (v and v.PlayerData and v.PlayerData.source) end
            return t
        end
        if FW.name == 'esx' then return ESX.GetPlayers() end
        if FW.name == 'standalone' then return GetPlayers() end
        return nil
    end)
    if ok and type(list) == 'table' then
        for _, v in pairs(list) do
            local n = tonumber(v)
            if n then out[#out + 1] = n end
        end
        return out
    end
    for _, v in ipairs(GetPlayers()) do
        local n = tonumber(v)
        if n and FW.GetPlayer(n) then out[#out + 1] = n end
    end
    return out
end

function FW.GetName(src)
    local p = FW.GetPlayer(src)
    if not p then return nil end
    return (p.firstname .. ' ' .. (p.lastname or '')):gsub('%s+$', '')
end

function FW.GetJobPlayers(jobName)
    local out = {}
    if not jobName then return out end
    -- PERFLUA: no ESX o filtro pelo emprego faz-se DENTRO do es_extended (GetExtendedPlayers('job', ...)): so os xPlayer
    -- desse emprego atravessam a fronteira entre recursos, em vez de um ESX.GetPlayerFromId + 2 x.get por CADA jogador
    -- ligado (services.request, eats). Mesma regra de "em servico" do normJobESX (onDuty ~= false).
    if FW.name == 'esx' and ESX and ESX.GetExtendedPlayers then
        local ok, list = pcall(ESX.GetExtendedPlayers, 'job', jobName)
        if ok and type(list) == 'table' then
            for _, x in pairs(list) do
                if type(x) == 'table' and x.identifier and type(x.job) == 'table' and x.job.name == jobName and x.job.onDuty ~= false then
                    local s = tonumber(x.source)
                    if s then out[#out + 1] = s end
                end
            end
            return out
        end
    end
    for _, src in ipairs(FW.GetPlayers()) do
        local p = FW.GetPlayer(src)
        if p and p.job.name == jobName and p.job.onduty then out[#out + 1] = src end
    end
    return out
end

-- O aviso segue em português para o CLIENTE do jogador, que o traduz para o idioma do telemóvel dele
-- (client/i18n.lua) e o mostra pelo framework (client/framework.lua FW.Notify: ox_lib, QBCore, ESX ou chat).
-- O hook notify do standalone (Config.Standalone.notify) continua a receber o texto de origem.
function FW.Notify(src, msg, ntype)
    src = tonumber(src)
    if not src or src <= 0 then return end
    ntype = ntype or 'primary'
    if FW.name == 'standalone' then
        local fn = saHook('notify')
        if fn and pcall(fn, src, msg, ntype) then return end
    end
    TriggerClientEvent('apex_phone:client:notify', src, tostring(msg or ''), ntype)
end

function FW.IsAdmin(src)
    src = tonumber(src) or 0
    if src == 0 then return true end
    if IsPlayerAceAllowed(src, 'command') or IsPlayerAceAllowed(src, 'apex_phone.admin') then return true end
    if FW.name == 'qb' then
        local ok, r = pcall(function() return Core.Functions.HasPermission(src, 'admin') or Core.Functions.HasPermission(src, 'god') end)
        if ok and r then return true end
        return IsPlayerAceAllowed(src, 'qbcore.admin') or IsPlayerAceAllowed(src, 'qbcore.god')
    elseif FW.name == 'qbx' then
        local ok, r = pcall(function() return exports.qbx_core:HasPermission(src, 'admin') end)
        if ok and r then return true end
        return IsPlayerAceAllowed(src, 'group.admin') or IsPlayerAceAllowed(src, 'qbcore.admin')
    elseif FW.name == 'esx' then
        local x = ESX.GetPlayerFromId(src)
        local g = x and x.getGroup and x.getGroup() or 'user'
        return g == 'admin' or g == 'superadmin' or g == '_dev' or IsPlayerAceAllowed(src, 'group.admin')
    end
    return false
end

-- ------------------------------------------------------------
-- Comandos / itens
-- ------------------------------------------------------------
-- Um único RegisterCommand por nome (registar duas vezes substituiria o handler). A consola (src 0) passa sempre;
-- jogadores com perm 'admin' são validados por FW.IsAdmin (ace / QBCore HasPermission / qbx / grupo ESX).
local function registerCommand(name, help, argsHelp, fn, perm)
    argsHelp = argsHelp or {}
    RegisterCommand(name, function(src, args)
        if src ~= 0 and perm == 'admin' and not FW.IsAdmin(src) then FW.Notify(src, 'Sem permissão.', 'error') return end
        fn(src, args or {})
    end, false)
    suggestions[#suggestions + 1] = { name = '/' .. name, help = help or '', args = argsHelp }
    -- o cliente traduz a ajuda para o idioma do telemóvel e passa-a ao chat (client/i18n.lua)
    TriggerClientEvent('apex_phone:client:suggestion', -1, '/' .. name, help or '', argsHelp)
end

function FW.AddCommand(name, help, argsHelp, fn, perm)
    if not FW.ready then pendingCommands[#pendingCommands + 1] = { name = name, help = help, args = argsHelp, fn = fn, perm = perm } return end
    local ok, err = pcall(registerCommand, name, help, argsHelp, fn, perm)
    if not ok then warn(('command /%s: %s'):format(name, tostring(err))) end
end

local function registerItem(item, fn)
    if FW.name == 'qb' then
        Core.Functions.CreateUseableItem(item, function(src) fn(src) end)
    elseif FW.name == 'qbx' then
        exports.qbx_core:CreateUseableItem(item, function(src) fn(src) end)
    elseif FW.name == 'esx' then
        ESX.RegisterUsableItem(item, function(src) fn(src) end)
    end
    -- standalone: não há registo de itens usáveis no servidor; com o ox_inventory quem chama é o
    -- `client.export` do items.lua (ver inventory_items.lua)
end

function FW.CreateUseableItem(item, fn)
    if not item or item == '' then return end
    if not FW.ready then pendingItems[#pendingItems + 1] = { item = item, fn = fn } return end
    local ok, err = pcall(registerItem, item, fn)
    if not ok then warn(('usable item %s: %s'):format(tostring(item), tostring(err))) end
end

-- ------------------------------------------------------------
-- Inventário (server)
-- Antes só o cliente tinha esta ponte; o servidor chamava exports.ox_inventory directamente e,
-- num servidor com qb-inventory ou ESX, o /apexdevices e os itens do Eats simplesmente não davam nada.
-- Ordem: ox_inventory (se estiver iniciado, em qualquer framework) > Player.Functions (qb/qbx) > xPlayer (esx).
-- standalone sem ox_inventory: não há inventário (HasItem 0, Add/Remove false).
-- ------------------------------------------------------------
function FW.InventoryName()
    if started('ox_inventory') then return 'ox_inventory' end
    if FW.name == 'qb' or FW.name == 'qbx' then return 'qb' end
    if FW.name == 'esx' then return 'esx' end
    return nil
end

-- 1.2.0: o objecto do framework para quem precisa de ler as tabelas partilhadas (server/items_check.lua lê
-- Core.Shared.Items no QBCore). qb → QBCore; esx → ESX; qbx → nil (o QBox fala por exports)
function FW.GetCore()
    if FW.name == 'qb' then return Core end
    if FW.name == 'esx' then return ESX end
    return nil
end

local function rawQB(src)
    if FW.name == 'qb' then return Core.Functions.GetPlayer(src) end
    if FW.name == 'qbx' then return exports.qbx_core:GetPlayer(src) end
    return nil
end

local function itemArgs(src, item, n)
    src = tonumber(src)
    if not src or src <= 0 or not FW.ready or type(item) ~= 'string' or item == '' or #item > 64 then return nil end
    n = math.floor(tonumber(n) or 1)
    if n < 1 or n > 10000 then return nil end
    return src, n
end

-- unidades de `item` que o jogador tem (0 se não tiver, se não houver inventário ou em erro)
function FW.HasItem(src, item)
    src = itemArgs(src, item, 1)
    if not src then return 0 end
    local inv = FW.InventoryName()
    local ok, n = pcall(function()
        if inv == 'ox_inventory' then return exports.ox_inventory:GetItemCount(src, item) end
        if inv == 'qb' then
            local P = rawQB(src)
            if not P or not P.PlayerData then return 0 end
            -- soma todas as ranhuras: GetItemByName só devolve a primeira
            local total = 0
            for _, it in pairs(P.PlayerData.items or {}) do
                if type(it) == 'table' and it.name == item then total = total + (tonumber(it.amount or it.count) or 0) end
            end
            if total == 0 and P.Functions and P.Functions.GetItemByName then
                local it = P.Functions.GetItemByName(item)
                total = it and tonumber(it.amount or it.count) or 0
            end
            return total
        end
        if inv == 'esx' then
            local x = ESX.GetPlayerFromId(src)
            local it = x and x.getInventoryItem and x.getInventoryItem(item)
            return it and tonumber(it.count) or 0
        end
        return 0
    end)
    if not ok then warnOnce('hasitem_' .. tostring(inv), ('inventory (%s): error counting items: %s'):format(tostring(inv), tostring(n))) return 0 end
    return tonumber(n) or 0
end

-- PERFLUA (5 out 2026): o jogador tem PELO MENOS UM destes itens? = `FW.HasItem(src, x) > 0` para algum x da lista,
-- mas no ox_inventory numa SO chamada (Search 'count' com a lista inteira) em vez de uma por item. O HasPhoneItem corre
-- por cada destinatario de cada push (mensagens de grupo, canais, estados) e perguntava um aparelho de cada vez: ate
-- 15 exports por jogador. Qualquer erro ou resposta inesperada cai no caminho antigo (item a item).
function FW.HasAnyItem(src, list)
    if type(list) ~= 'table' or #list == 0 then return false end
    if #list > 1 and FW.InventoryName() == 'ox_inventory' and itemArgs(src, list[1], 1) then
        local names = {}
        for i, item in ipairs(list) do
            if type(item) ~= 'string' or item == '' or #item > 64 then names = nil break end
            names[i] = item
        end
        if names then
            local ok, res = pcall(function() return exports.ox_inventory:Search(tonumber(src), 'count', names) end)
            if ok and type(res) == 'table' then
                for _, item in ipairs(names) do
                    -- o ox_inventory devolve as chaves em minusculas (e as armas em maiusculas); tenta-se as tres formas
                    local n = res[item] or res[item:lower()] or res[item:upper()]
                    if (tonumber(n) or 0) > 0 then return true end
                end
                return false
            end
        end
    end
    for _, item in ipairs(list) do
        if (FW.HasItem(src, item) or 0) > 0 then return true end
    end
    return false
end

function FW.AddItem(src, item, n, meta)
    local s, count = itemArgs(src, item, n)
    if not s then return false end
    local inv = FW.InventoryName()
    if type(meta) ~= 'table' then meta = nil end
    local ok, r = pcall(function()
        if inv == 'ox_inventory' then return exports.ox_inventory:AddItem(s, item, count, meta) end
        if inv == 'qb' then
            local P = rawQB(s)
            if not (P and P.Functions and P.Functions.AddItem) then return false end
            return P.Functions.AddItem(item, count, false, meta)
        end
        if inv == 'esx' then
            local x = ESX.GetPlayerFromId(s)
            if not (x and x.addInventoryItem) then return false end
            if x.canCarryItem and not x.canCarryItem(item, count) then return false end
            x.addInventoryItem(item, count, meta)
            return true
        end
        return false
    end)
    if not ok then warnOnce('additem_' .. tostring(inv), ('inventory (%s): error giving item: %s'):format(tostring(inv), tostring(r))) return false end
    return r ~= false and r ~= nil
end

function FW.RemoveItem(src, item, n)
    local s, count = itemArgs(src, item, n)
    if not s then return false end
    local inv = FW.InventoryName()
    local ok, r = pcall(function()
        if inv == 'ox_inventory' then return exports.ox_inventory:RemoveItem(s, item, count) end
        if inv == 'qb' then
            local P = rawQB(s)
            if not (P and P.Functions and P.Functions.RemoveItem) then return false end
            return P.Functions.RemoveItem(item, count)
        end
        if inv == 'esx' then
            local x = ESX.GetPlayerFromId(s)
            local it = x and x.getInventoryItem and x.getInventoryItem(item)
            if not it or (tonumber(it.count) or 0) < count or not x.removeInventoryItem then return false end
            x.removeInventoryItem(item, count)
            return true
        end
        return false
    end)
    if not ok then warnOnce('removeitem_' .. tostring(inv), ('inventory (%s): error removing item: %s'):format(tostring(inv), tostring(r))) return false end
    return r ~= false and r ~= nil
end

-- ------------------------------------------------------------
-- Número de telefone no framework
-- ------------------------------------------------------------
function FW.SetPhone(src, number)
    local p = FW.GetPlayer(src)
    if not p or not number then return false end
    number = tostring(number)
    -- standalone: não há charinfo nem users; o número é o de apex_phone_accounts (já gravado por quem chama)
    if FW.name == 'standalone' then return true end
    if FW.name == 'esx' then
        esxCache[p.cid] = esxCache[p.cid] or {}
        esxCache[p.cid].phone = number
        pcall(function() if p.raw.set then p.raw.set('phone_number', number) end end)
        if not FW.esxNoPhoneColumn then
            pcall(function() MySQL.update('UPDATE users SET phone_number = ? WHERE identifier = ?', { number, p.cid }) end)
        end
        return true
    end
    local P = p.raw
    local ci = P.PlayerData.charinfo or {}
    if ci.phone == number then return true end
    ci.phone = number
    if FW.name == 'qbx' then
        local ok = pcall(function() exports.qbx_core:SetCharInfo(p.src, 'phone', number) end)
        if ok then return true end
    end
    if P.Functions and P.Functions.SetPlayerData then P.Functions.SetPlayerData('charinfo', ci) return true end
    return false
end

-- cid do dono de um número, segundo a base de dados do framework (jogador offline)
function FW.FindCidByPhone(number)
    if not number or number == '' then return nil end
    if FW.name == 'standalone' then return nil end   -- sem tabela players/users para procurar
    local ok, r = pcall(function()
        if FW.name == 'esx' then
            if FW.esxNoPhoneColumn then return nil end
            return MySQL.single.await('SELECT identifier AS cid FROM users WHERE phone_number = ? LIMIT 1', { number })
        end
        return MySQL.single.await("SELECT citizenid AS cid FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.phone')) = ? LIMIT 1", { number })
    end)
    return (ok and r and r.cid) or nil
end

function FW.PhoneTaken(number) return FW.FindCidByPhone(number) ~= nil end

-- número guardado no framework para um cid (jogador offline)
function FW.GetPhoneFromDB(cid)
    if not cid then return nil end
    if FW.name == 'standalone' then return nil end
    local ok, r = pcall(function()
        if FW.name == 'esx' then
            if FW.esxNoPhoneColumn then return nil end
            return MySQL.single.await('SELECT phone_number AS phone FROM users WHERE identifier = ? LIMIT 1', { cid })
        end
        return MySQL.single.await("SELECT JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.phone')) AS phone FROM players WHERE citizenid = ? LIMIT 1", { cid })
    end)
    local phone = ok and r and r.phone or nil
    if phone == nil or phone == '' or phone == 'null' then return nil end
    return tostring(phone)
end

-- 1.3.0: existe uma personagem com este cid no framework (ligada ou não)? -> found, name, cid
-- A Carteira aceita o citizenid escrito à mão como destino de uma transferência: antes de tirar dinheiro a alguém
-- é preciso saber que o destinatário EXISTE (o FW.AddMoneyOffline já devolve false quando não existe, mas o
-- emissor merece a resposta antes de confirmar) e como se chama (ecrã de confirmação). O `cid` devolvido é o da
-- BD, não o escrito: a comparação do MySQL ignora maiúsculas, a do framework em memória não (um "qb1234abcd"
-- escrito em minúsculas encontraria a linha mas o GetPlayerByCitizenId do QB nunca o reconheceria).
-- standalone: a única "tabela de personagens" é apex_phone_accounts (nome = @username).
function FW.FindCidExists(cid)
    if type(cid) ~= 'string' or cid == '' or #cid > 64 then return false end
    local ok, r = pcall(function()
        if FW.name == 'esx' then
            return MySQL.single.await('SELECT identifier AS cid, firstname, lastname FROM users WHERE identifier = ? LIMIT 1', { cid })
        elseif FW.name == 'standalone' then
            return MySQL.single.await('SELECT citizenid AS cid, username AS firstname FROM apex_phone_accounts WHERE citizenid = ? LIMIT 1', { cid })
        end
        return MySQL.single.await("SELECT citizenid AS cid, JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')) AS firstname, JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')) AS lastname FROM players WHERE citizenid = ? LIMIT 1", { cid })
    end)
    if not ok or type(r) ~= 'table' or r.cid == nil then return false end
    local fn, ln = r.firstname, r.lastname
    if fn == nil or fn == 'null' then fn = '' end
    if ln == nil or ln == 'null' then ln = '' end
    if FW.name == 'standalone' and fn ~= '' then fn = '@' .. tostring(fn) end
    local name = (tostring(fn) .. ' ' .. tostring(ln)):gsub('^%s+', ''):gsub('%s+$', '')
    return true, name ~= '' and name or nil, tostring(r.cid)
end

-- ------------------------------------------------------------
-- Dinheiro offline (jogador não está ligado): escreve directamente na DB
-- ------------------------------------------------------------
-- Devolve true SÓ se o dinheiro entrou mesmo numa personagem. Antes devolvia o `ok` do pcall e um UPDATE
-- que não encontrava ninguém (personagem apagada no framework, identificador de outro servidor) contava
-- como sucesso: o bank.transfer tirava o dinheiro ao emissor e ele desaparecia. Quem chama e ignora o
-- valor devolvido continua a funcionar exactamente como antes.
function FW.AddMoneyOffline(cid, t, amount)
    amount = math.floor(tonumber(amount) or 0)
    if not cid or amount == 0 then return false end
    if FW.name == 'standalone' then
        local fn = saHook('addMoneyOffline'); if not fn then return false end
        local okH, r = pcall(fn, cid, qbMoneyType(t), amount)
        return okH and r == true
    end
    -- as linhas afetadas dizem se a personagem existe: o valor muda sempre (amount ~= 0), por isso
    -- 1 linha = entrou, 0 linhas = não há ninguém com este identificador.
    -- O COALESCE(coluna, '{}') é o que torna essa conta verdadeira: `JSON_SET(NULL, ...)` devolve NULL,
    -- logo numa personagem com a coluna a NULL (o `accounts` do ESX nasce assim, e o `money` do QB
    -- também pode, se a linha foi criada por fora) a linha era ENCONTRADA e não mudava: o dinheiro
    -- não entrava e o contador de linhas dizia que sim. Com o COALESCE o objecto JSON nasce agora e o
    -- dinheiro entra mesmo (os tipos que faltarem são preenchidos no login, tanto no QB como no ESX).
    local ok, rows = pcall(function()
        if FW.name == 'esx' then
            local acc = esxAccount(t)
            return MySQL.update.await(("UPDATE users SET accounts = JSON_SET(COALESCE(accounts, '{}'), '$.%s', COALESCE(JSON_EXTRACT(accounts, '$.%s'), 0) + ?) WHERE identifier = ?"):format(acc, acc), { amount, cid })
        end
        local mt = qbMoneyType(t)
        return MySQL.update.await(("UPDATE players SET money = JSON_SET(COALESCE(money, '{}'), '$.%s', COALESCE(JSON_EXTRACT(money, '$.%s'), 0) + ?) WHERE citizenid = ?"):format(mt, mt), { amount, cid })
    end)
    if not ok then return false end
    return (tonumber(rows) or 0) >= 1
end

-- ------------------------------------------------------------
-- Veículos: { plate, model (string), hash, label, garage, state 'garage'|'out'|'impound', fuel, body, engine, mods }
-- ------------------------------------------------------------
local function decodeJson(s)
    if type(s) == 'table' then return s end
    if not s or s == '' then return {} end
    local ok, t = pcall(json.decode, s)
    return (ok and type(t) == 'table') and t or {}
end

-- lite = true (lista da app Garagem): não se pede a coluna `mods` (JSON de 2 a 10 KB por carro, lido
-- e descodificado por cada carro a cada abertura da app): só vem nas linhas em que fuel/body/engine
-- estão a NULL, que é quando o valor tem de sair de lá. v.mods fica {} nas outras; quem precisa dos
-- mods (garage.detail) chama sem lite e recebe tudo como antes.
-- Se o player_vehicles do servidor não tiver alguma destas colunas (fork), cai para SELECT * e não
-- volta a tentar.
local liteVehSql = [[SELECT plate, vehicle, hash, garage, state, fuel, body, engine,
    CASE WHEN fuel IS NULL OR body IS NULL OR engine IS NULL THEN mods END AS mods
    FROM player_vehicles WHERE citizenid = ?]]
local liteVehBroken = false

function FW.GetVehicles(cid, lite)
    local out = {}
    if not cid then return out end
    if FW.name == 'standalone' then return out end   -- sem player_vehicles/owned_vehicles
    local ok, rows = pcall(function()
        if FW.name == 'esx' then return MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = ?', { cid }) end
        if lite and not liteVehBroken then
            local okLite, r = pcall(function() return MySQL.query.await(liteVehSql, { cid }) end)
            if okLite and type(r) == 'table' then return r end
            liteVehBroken = true
            warn('player_vehicles is missing the expected columns (plate/vehicle/hash/garage/state/fuel/body/engine/mods): the Garage app uses SELECT *')
        end
        return MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { cid })
    end)
    if not ok or type(rows) ~= 'table' then return out end
    for _, r in ipairs(rows) do
        if FW.name == 'esx' then
            local v = decodeJson(r.vehicle)
            local stored = tonumber(r.stored)
            if stored == nil then stored = (r.stored == true) and 1 or 0 end
            local state = (stored == 1) and 'garage' or 'out'
            if (tonumber(r.impound) or 0) == 1 or (tonumber(r.impounded) or 0) == 1 or (tonumber(r.pound) or 0) == 1 or (tonumber(r.state) or 0) == 2 then state = 'impound' end
            local model = r.model or r.vehicle_name or r.vehiclename or v.modelName or v.name or v.model
            local hash = tonumber(v.model)
            out[#out + 1] = {
                plate = r.plate, model = model ~= nil and tostring(model) or nil, hash = hash, label = r.label or r.vehicle_name or nil,
                garage = r.parking or r.garage, state = state,
                fuel = tonumber(v.fuelLevel), body = tonumber(v.bodyHealth), engine = tonumber(v.engineHealth), mods = v,
            }
        else
            local mods = decodeJson(r.mods)
            local st = tonumber(r.state) or 0
            out[#out + 1] = {
                plate = r.plate, model = r.vehicle and tostring(r.vehicle) or nil, hash = tonumber(r.hash), label = nil,
                garage = r.garage, state = (st == 1) and 'garage' or (st == 2) and 'impound' or 'out',
                fuel = tonumber(r.fuel) or tonumber(mods.fuelLevel), body = tonumber(r.body) or tonumber(mods.bodyHealth),
                engine = tonumber(r.engine) or tonumber(mods.engineHealth), mods = mods,
            }
        end
    end
    return out
end

-- ------------------------------------------------------------
-- Dinheiro de sociedade (contas de job)
-- ------------------------------------------------------------
local function societyProvider()
    local want = Config.SocietyProvider or 'auto'
    if want == 'none' then return nil end
    if want ~= 'auto' then return started(want) and want or nil end
    if FW.name == 'esx' then
        if started('esx_addonaccount') then return 'esx_addonaccount' end
        if started('Renewed-Banking') then return 'Renewed-Banking' end
        return nil
    end
    if FW.name == 'qbx' and started('Renewed-Banking') then return 'Renewed-Banking' end
    if started('qb-banking') then return 'qb-banking' end
    if started('qb-management') then return 'qb-management' end
    if started('Renewed-Banking') then return 'Renewed-Banking' end
    return nil
end

function FW.GetSocietyMoney(job)
    if not job then return 0 end
    local prov = societyProvider()
    if not prov then warnOnce('society', 'no society account manager found (qb-banking / qb-management / Renewed-Banking / esx_addonaccount): society balance unavailable') return 0 end
    local ok, v = pcall(function()
        if prov == 'qb-banking' then return exports['qb-banking']:GetAccountBalance(job) end
        if prov == 'qb-management' then return exports['qb-management']:GetAccount(job) end
        if prov == 'Renewed-Banking' then return exports['Renewed-Banking']:getAccountMoney(job) end
        if prov == 'esx_addonaccount' then
            local m = 0
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(acc) if acc then m = acc.money or 0 end end)
            return m
        end
        return 0
    end)
    if not ok then warnOnce('society_get_' .. prov, ('%s: error reading society balance: %s'):format(prov, tostring(v))) return 0 end
    return tonumber(v) or 0
end

-- amount > 0 deposita, < 0 levanta. Devolve true/false.
function FW.AddSocietyMoney(job, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if not job or amount == 0 then return false end
    local prov = societyProvider()
    if not prov then warnOnce('society', 'no society account manager found (qb-banking / qb-management / Renewed-Banking / esx_addonaccount): society money ignored') return false end
    reason = reason or 'apex_phone'
    local ok, r = pcall(function()
        if prov == 'qb-banking' then
            if amount > 0 then return exports['qb-banking']:AddMoney(job, amount, reason) end
            return exports['qb-banking']:RemoveMoney(job, -amount, reason)
        end
        if prov == 'qb-management' then
            if amount > 0 then return exports['qb-management']:AddMoney(job, amount) end
            return exports['qb-management']:RemoveMoney(job, -amount)
        end
        if prov == 'Renewed-Banking' then
            if amount > 0 then return exports['Renewed-Banking']:addAccountMoney(job, amount) end
            return exports['Renewed-Banking']:removeAccountMoney(job, -amount)
        end
        if prov == 'esx_addonaccount' then
            local done = false
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(acc)
                if acc then
                    if amount > 0 then acc.addMoney(amount) else acc.removeMoney(-amount) end
                    done = true
                end
            end)
            return done
        end
        return false
    end)
    if not ok then warnOnce('society_add_' .. prov, ('%s: error moving society money: %s'):format(prov, tostring(r))) return false end
    return r ~= false
end

-- ------------------------------------------------------------
-- Hooks
-- ------------------------------------------------------------
function FW.OnPlayerLoaded(fn)  onLoaded[#onLoaded + 1] = fn end
function FW.OnJobUpdate(fn)     onJob[#onJob + 1] = fn end
function FW.OnPlayerDropped(fn) onDropped[#onDropped + 1] = fn end

local function playerLoaded(src)
    src = tonumber(src)
    if not src then return end
    local t = os.time()
    if loadedAt[src] and t - loadedAt[src] < 3 then return end
    loadedAt[src] = t
    for _, s in ipairs(suggestions) do TriggerClientEvent('apex_phone:client:suggestion', src, s.name, s.help, s.args) end
    fire(onLoaded, src)
end

-- Restart do recurso (ou framework detetado tarde) com gente já carregada: o evento "personagem carregada" do framework
-- já passou para essas pessoas e nenhum FW.OnPlayerLoaded corria - sem push `session`, sem a conta em cache, sem a
-- state bag do número. Só o standalone fazia esta volta (1.1.4); desde 1.1.5 fazem-na todos os frameworks: o
-- FW.GetPlayers() dá quem o framework tem como carregado, e o playerLoaded tem o seu próprio travão a repetições.
local function sweepLoadedPlayers()
    CreateThread(function()
        Wait(2000)   -- os outros server/*.lua já registaram os seus hooks
        local list = FW.GetPlayers()
        for _, v in ipairs(list) do playerLoaded(v) end
        if #list > 0 then log(('%d player(s) already in game: sessions re-sent'):format(#list)) end
    end)
end

local eventsRegistered = false
local function registerEvents()
    if eventsRegistered then return end   -- um 2.o init (framework reiniciado) só renova o objeto, nunca duplica handlers
    eventsRegistered = true
    if FW.name == 'standalone' then
        -- sem framework não há "personagem carregada": entrar no servidor é o equivalente
        AddEventHandler('playerJoining', function()
            local src = source
            saIds[tonumber(src) or src] = nil
            playerLoaded(src)
        end)
    elseif FW.name == 'esx' then
        AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
            if xPlayer and xPlayer.identifier then esxCache[xPlayer.identifier] = nil pcall(esxInfo, xPlayer) end
            playerLoaded(playerId)
        end)
        AddEventHandler('esx:setJob', function(playerId, job) fire(onJob, tonumber(playerId), normJobESX(job)) end)
        AddEventHandler('esx:playerLogout', function(playerId) fire(onDropped, tonumber(playerId)) end)
    else
        AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
            local src = Player and Player.PlayerData and Player.PlayerData.source
            if src then playerLoaded(src) end
        end)
        AddEventHandler('qbx_core:server:playerLoaded', function(Player)
            local src = Player and Player.PlayerData and Player.PlayerData.source
            if src then playerLoaded(src) end
        end)
        AddEventHandler('QBCore:Server:OnJobUpdate', function(src, job) fire(onJob, tonumber(src), normJobQB(job)) end)
        AddEventHandler('QBCore:Server:OnPlayerUnload', function(src) fire(onDropped, tonumber(src)) end)
    end
    AddEventHandler('playerDropped', function()
        local src = source
        loadedAt[src] = nil
        fire(onDropped, src)
        saIds[tonumber(src) or src] = nil
    end)
end

-- ------------------------------------------------------------
-- Schema: alarga colunas de dono para VARCHAR(64) (identifiers ESX são compridos)
--   list = { { tabela, coluna, nullable }, ... }
-- ------------------------------------------------------------
function FW.WidenColumns(list)
    for _, e in ipairs(list) do
        pcall(function()
            local len
            if SchemaColumns then
                -- 1.1.5: a leitura única do information_schema do server/main.lua (uma consulta por coluna demorava
                -- segundos cada num alojamento partilhado e atrasava o arranque inteiro)
                local c = SchemaColumns(e[1])[tostring(e[2]):lower()]
                if not c then return end   -- coluna (ou tabela) inexistente: nada a alargar
                len = tonumber(c.max)
            else
                len = tonumber(MySQL.scalar.await('SELECT CHARACTER_MAXIMUM_LENGTH FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?', { e[1], e[2] }))
            end
            if len and len < 64 then
                MySQL.query.await(('ALTER TABLE `%s` MODIFY `%s` VARCHAR(64) %s'):format(e[1], e[2], e[3] and 'NULL' or 'NOT NULL'))
                if SchemaColumnSet then SchemaColumnSet(e[1], e[2], 'varchar', 64) end
                log(('column %s.%s widened to VARCHAR(64)'):format(e[1], e[2]))
            end
        end)
    end
end

-- ESX: garante users.phone_number
local function ensureEsxPhoneColumn()
    CreateThread(function()
        local ok = pcall(function() MySQL.scalar.await('SELECT phone_number FROM users LIMIT 1') end)
        if ok then FW.esxNoPhoneColumn = false return end
        local ok2 = pcall(function() MySQL.query.await('ALTER TABLE `users` ADD COLUMN `phone_number` VARCHAR(20) NULL') end)
        FW.esxNoPhoneColumn = not ok2
        if ok2 then log('column users.phone_number created') else warn('users.phone_number does not exist and could not be created: numbers are only kept in the apex_phone_* tables') end
    end)
end

-- ------------------------------------------------------------
-- Arranque
-- ------------------------------------------------------------
-- o objeto do framework (QBCore / ESX): no arranque e outra vez quando o framework é reiniciado por baixo de nós
-- (os funcrefs de um es_extended / qb-core parado morrem: cada GetPlayerFromId rebentava e o telemóvel ficava "sem
-- jogador" até ao restart do apex_phone)
local function acquire(name)
    if name == 'qb' then
        local ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
        if not ok or type(obj) ~= 'table' then return false end
        Core = obj
    elseif name == 'qbx' then
        local ok = pcall(function() return exports.qbx_core:GetQBPlayers() end)
        if not ok then return false end
    elseif name == 'esx' then
        local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
        if not ok or type(obj) ~= 'table' then return false end
        ESX = obj
    elseif name ~= 'standalone' then
        return false
    end
    return true
end

local function init(name)
    if not acquire(name) then return false end
    FW.name = name
    FW.ready = true
    registerEvents()
    if name == 'esx' then ensureEsxPhoneColumn() end
    for _, c in ipairs(pendingCommands) do FW.AddCommand(c.name, c.help, c.args, c.fn, c.perm) end
    for _, i in ipairs(pendingItems) do FW.CreateUseableItem(i.item, i.fn) end
    pendingCommands, pendingItems = {}, {}
    log('framework: ' .. ({ qb = 'QBCore', qbx = 'QBox', esx = 'ESX', standalone = 'standalone (no framework)' })[name])
    if name == 'standalone' and FW.InventoryName() == nil then
        warn('standalone without ox_inventory: there is no inventory (Config.RequireItem is not checked on the server)')
    end
    sweepLoadedPlayers()
    return true
end

local CORE_RES = { ['qb-core'] = 'qb', qbx_core = 'qbx', es_extended = 'esx' }
local validFw = { auto = true, qb = true, qbx = true, esx = true, standalone = true }

do
    local want = detect()
    if not validFw[Config.Framework or 'auto'] then
        print(('^1[apex_phone] Config.Framework invalid: %s (use auto | qb | qbx | esx | standalone)^0'):format(tostring(Config.Framework)))
    elseif want then
        init(want)
    end
    if not FW.ready and validFw[Config.Framework or 'auto'] then
        CreateThread(function()
            -- 1.1.5: antes desistia ao fim de 60 s. Num servidor grande o framework pode levar mais do que isso a
            -- arrancar (ou arranca DEPOIS do apex_phone na ordem do server.cfg) e o telemóvel ficava para sempre "sem
            -- framework": todos os account.get davam vazio e cada jogador caía no assistente a cada restart. Agora
            -- espera até 10 minutos, avisa a cada minuto, e o onResourceStart abaixo liga-o no instante em que o
            -- framework arranca.
            local tries = 0
            while not FW.ready and tries < 600 do
                Wait(1000)
                tries = tries + 1
                local n = detect()
                if n then init(n) end
                if not FW.ready and tries % 60 == 0 then
                    warn(('still no framework after %d s (qbx_core / qb-core / es_extended not started): the phone waits. Start the framework before apex_phone or set Config.Framework.'):format(tries))
                end
            end
            if not FW.ready then
                print('^1[apex_phone] no framework found (qbx_core / qb-core / es_extended are not started). Set Config.Framework in config.lua and make sure the framework starts before apex_phone (no framework: Config.Framework = \'standalone\').^0')
            end
        end)
    end
end

-- o framework arrancou (ou reiniciou) depois de nós
AddEventHandler('onResourceStart', function(res)
    local n = CORE_RES[res]
    if not n or not validFw[Config.Framework or 'auto'] then return end
    CreateThread(function()
        Wait(1000)   -- os exports do core ficam disponíveis um instante depois do evento
        if not FW.ready then
            local want = detect()
            if want then init(want) end
        elseif FW.name == n then
            if acquire(n) then
                log(('%s restarted: framework object renewed'):format(res))
                sweepLoadedPlayers()
            else
                warn(('%s restarted but its core object could not be fetched again'):format(res))
            end
        end
    end)
end)

-- ------------------------------------------------------------
-- EMPREGOS E SERVICO (apps de trabalho v2, 2026-10-03; acrescentado no fim, o resto do ficheiro fica igual)
--   FW.GetJobsList()            -> { { name, label, grades = { { level, label }, ... } }, ... } (ordenado pelo nome)
--       QBCore: Core.Shared.Jobs · QBox: exports.qbx_core:GetJobs() · ESX: ESX.GetJobs() (ou ESX.Jobs, ou as
--       tabelas jobs/job_grades) · standalone: Config.Standalone.jobs (opcional) + os empregos de quem esta online.
--       Os empregos "fora de servico" do ESX (offpolice quando ha police) ficam de fora: nao sao empregos a parte.
--   FW.DutySupported(src, opts) -> true, modo | false, motivo
--       modos: 'qb' · 'qbx' · 'esx_prefix' (offpolice <-> police) · 'esx_native' (job.onDuty do ESX Legacy 1.10+) ·
--       'standalone' (hook Config.Standalone.setDuty). Motivos: 'noplayer' · 'nojob' (desempregado) · 'server'
--       (o servidor gere o servico de outra maneira: o telemovel so mostra o estado).
--   FW.SetDuty(src, on, opts)   -> true | false, motivo           opts = { esxOffPrefix = 'off' } (modulo duty)
-- ------------------------------------------------------------
local function dutyPrefix(opts)
    local p = type(opts) == 'table' and opts.esxOffPrefix or nil
    if p == nil then p = 'off' end
    if type(p) ~= 'string' then return '' end
    return (p:lower():gsub('[^%w_]', '')):sub(1, 12)
end

-- o ESX tem este emprego com este escalao? (DoesJobExist, ou a tabela de empregos, ou a base de dados)
local function esxJobExists(name, grade)
    if not ESX or type(name) ~= 'string' or name == '' then return false end
    grade = tostring(tonumber(grade) or 0)
    if ESX.DoesJobExist then
        local ok, r = pcall(ESX.DoesJobExist, name, grade)
        if ok then return r == true end
    end
    local jobs = ESX.Jobs
    if type(jobs) ~= 'table' and ESX.GetJobs then
        local ok, j = pcall(ESX.GetJobs)
        if ok then jobs = j end
    end
    if type(jobs) == 'table' then
        local j = jobs[name]
        return type(j) == 'table' and type(j.grades) == 'table' and (j.grades[grade] ~= nil or j.grades[tonumber(grade)] ~= nil)
    end
    local ok, n = pcall(function() return MySQL.scalar.await('SELECT COUNT(*) FROM job_grades WHERE job_name = ? AND grade = ?', { name, tonumber(grade) }) end)
    return ok and (tonumber(n) or 0) > 0
end

local function sortGrades(grades)
    local out = {}
    if type(grades) ~= 'table' then return out end
    for k, g in pairs(grades) do
        local lvl = tonumber(type(g) == 'table' and (g.grade or g.level) or nil) or tonumber(k)
        if lvl then
            local label = type(g) == 'table' and (g.label or g.name) or g
            out[#out + 1] = { level = math.floor(lvl), label = tostring(label or lvl) }
        end
    end
    table.sort(out, function(a, b) return a.level < b.level end)
    return out
end

function FW.GetJobsList()
    local byName = {}
    local function add(name, label, grades)
        if type(name) ~= 'string' or name == '' or #name > 50 then return end
        local e = byName[name]
        if not e then
            e = { name = name, label = tostring(label or name), grades = {} }
            byName[name] = e
        end
        if type(grades) == 'table' and #grades > 0 and #e.grades == 0 then e.grades = grades end
    end
    if FW.name == 'qb' and Core and Core.Shared and type(Core.Shared.Jobs) == 'table' then
        for name, j in pairs(Core.Shared.Jobs) do add(name, type(j) == 'table' and j.label, sortGrades(type(j) == 'table' and j.grades)) end
    elseif FW.name == 'qbx' then
        local ok, jobs = pcall(function() return exports.qbx_core:GetJobs() end)
        if ok and type(jobs) == 'table' then
            for name, j in pairs(jobs) do add(name, type(j) == 'table' and j.label, sortGrades(type(j) == 'table' and j.grades)) end
        end
    elseif FW.name == 'esx' and ESX then
        local jobs = nil
        if ESX.GetJobs then
            local ok, j = pcall(ESX.GetJobs)
            if ok and type(j) == 'table' then jobs = j end
        end
        jobs = jobs or (type(ESX.Jobs) == 'table' and ESX.Jobs or nil)
        if jobs then
            for name, j in pairs(jobs) do add(name, type(j) == 'table' and j.label, sortGrades(type(j) == 'table' and j.grades)) end
        else
            local ok, rows = pcall(function() return MySQL.query.await('SELECT name, label FROM jobs') end)
            local okG, grs = pcall(function() return MySQL.query.await('SELECT job_name, grade, label FROM job_grades') end)
            local G = {}
            if okG and type(grs) == 'table' then
                for _, g in ipairs(grs) do G[g.job_name] = G[g.job_name] or {} G[g.job_name][tostring(g.grade)] = { grade = g.grade, label = g.label } end
            end
            if ok and type(rows) == 'table' then
                for _, r in ipairs(rows) do add(r.name, r.label, sortGrades(G[r.name])) end
            end
        end
    elseif FW.name == 'standalone' then
        local S = Config.Standalone
        if type(S) == 'table' and type(S.jobs) == 'table' then
            for k, j in pairs(S.jobs) do
                if type(j) == 'table' then add(j.name or (type(k) == 'string' and k or nil), j.label, sortGrades(j.grades)) end
            end
        end
    end
    -- quem esta online (em todos os frameworks: um emprego criado por fora da lista tambem aparece)
    for _, src in ipairs(FW.GetPlayers()) do
        local p = FW.GetPlayer(src)
        local j = p and p.job
        if FW.name == 'standalone' then
            local fn = saHook('getJob')
            if fn then
                local ok, r = pcall(fn, src)
                if ok and type(r) == 'table' then j = { name = r.name, label = r.label, grade = r.grade, gradeLevel = tonumber(r.gradeLevel or r.level) or 0 } end
            end
        end
        if j and j.name and j.name ~= 'unemployed' then
            local name = j.name
            if FW.name == 'esx' then
                local pre = dutyPrefix(nil)
                if #name > #pre and name:sub(1, #pre) == pre and byName[name:sub(#pre + 1)] then name = nil end
            end
            if name then
                add(name, j.label, nil)
                local e = byName[name]
                if e and #e.grades == 0 then e.grades = { { level = tonumber(j.gradeLevel) or 0, label = tostring(j.grade or j.gradeLevel or 0) } } end
            end
        end
    end
    local out = {}
    for name, e in pairs(byName) do
        -- ESX: "offpolice" com "police" na lista e o emprego fora de servico, nao um emprego a parte
        local skip = false
        if FW.name == 'esx' and #name > 3 and name:sub(1, 3) == 'off' and byName[name:sub(4)] then skip = true end
        if not skip then out[#out + 1] = e end
    end
    table.sort(out, function(a, b)
        local la, lb = tostring(a.label):lower(), tostring(b.label):lower()
        if la ~= lb then return la < lb end
        return a.name < b.name
    end)
    return out
end

function FW.DutySupported(src, opts)
    local p = FW.GetPlayer(src)
    if not p then return false, 'noplayer' end
    local job = p.job or {}
    if FW.name == 'qb' or FW.name == 'qbx' then
        if not job.name or job.name == 'unemployed' then return false, 'nojob' end
        if FW.name == 'qbx' then return true, 'qbx' end
        local P = p.raw
        if P and P.Functions and P.Functions.SetJobDuty then return true, 'qb' end
        return false, 'server'
    elseif FW.name == 'esx' then
        local x = p.raw
        local xj = x and x.job or {}
        local name = xj.name
        if not name or name == 'unemployed' or not x.setJob then return false, 'nojob' end
        local pre = dutyPrefix(opts)
        if pre ~= '' then
            if #name > #pre and name:sub(1, #pre) == pre and esxJobExists(name:sub(#pre + 1), xj.grade) then return true, 'esx_prefix' end
            if esxJobExists(pre .. name, xj.grade) then return true, 'esx_prefix' end
        end
        if type(xj.onDuty) == 'boolean' then return true, 'esx_native' end
        return false, 'server'
    elseif FW.name == 'standalone' then
        if saHook('setDuty') then return true, 'standalone' end
        return false, 'server'
    end
    return false, 'server'
end

function FW.SetDuty(src, on, opts)
    on = on == true
    local okS, mode = FW.DutySupported(src, opts)
    if not okS then return false, mode end
    local p = FW.GetPlayer(src)
    if not p then return false, 'noplayer' end
    local function qbDuty(P)
        if not (P and P.Functions and P.Functions.SetJobDuty) then return false end
        P.Functions.SetJobDuty(on)
        TriggerClientEvent('QBCore:Client:SetDuty', src, on)
        TriggerEvent('QBCore:Server:SetDuty', src, on)
        return true
    end
    if mode == 'qb' then
        local ok, r = pcall(qbDuty, p.raw)
        if ok and r then return true end
        return false, 'server'
    elseif mode == 'qbx' then
        -- o export do QBox ja dispara os eventos dele; um qbx_core antigo sem o export cai para o objeto do jogador
        local ok = pcall(function() exports.qbx_core:SetJobDuty(src, on) end)
        if ok then return true end
        local ok2, r = pcall(qbDuty, p.raw)
        if ok2 and r then return true end
        return false, 'server'
    elseif mode == 'esx_prefix' then
        local x = p.raw
        local name, grade = x.job.name, x.job.grade
        local pre = dutyPrefix(opts)
        local base = (#name > #pre and name:sub(1, #pre) == pre and esxJobExists(name:sub(#pre + 1), grade)) and name:sub(#pre + 1) or name
        local target = on and base or (pre .. base)
        if target == name then return true end
        -- o 3.o argumento (onDuty) so o ESX Legacy novo le; os antigos ignoram-no. O setJob do ESX recusa (so
        -- com um aviso) um emprego que nao existe: confirma-se pelo emprego que ficou.
        local ok = pcall(x.setJob, target, grade, on)
        if ok and x.job and x.job.name == target then return true end
        return false, 'server'
    elseif mode == 'esx_native' then
        local x = p.raw
        local ok = pcall(x.setJob, x.job.name, x.job.grade, on)
        if not ok then return false, 'server' end
        return true
    elseif mode == 'standalone' then
        local fn = saHook('setDuty')
        local ok, r = pcall(fn, src, on)
        if ok and r ~= false then return true end
        return false, 'server'
    end
    return false, 'server'
end
