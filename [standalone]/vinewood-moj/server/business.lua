-- Businesses as parties to civil claims: who they are (framework jobs), who can act for them
-- (their bosses), and their money (the society / business bank account).
-- Left unencrypted so you can add a banking script or change who counts as a business.
Business = {}

local CV = Config.Civil or {}

---------------------------------------------------------------------------
-- Society accounts. Detected in this order; set Config.Civil.BusinessBank to force one.
---------------------------------------------------------------------------
local function call(res, fn, ...)
    local args = { ... }
    local ok, r = pcall(function() return exports[res][fn](exports[res], table.unpack(args)) end)
    if ok then return r end
    print(('[vinewood-moj] %s:%s failed: %s'):format(res, fn, tostring(r)))
    return nil
end

Business.Banks = {
    -- Qbox (qbx_management uses it), many QBCore servers
    ['Renewed-Banking'] = {
        get = function(job) return tonumber(call('Renewed-Banking', 'getAccountMoney', job)) or 0 end,
        add = function(job, amount) return call('Renewed-Banking', 'addAccountMoney', job, amount) ~= false end,
        remove = function(job, amount) return call('Renewed-Banking', 'removeAccountMoney', job, amount) == true end,
    },
    okokBanking = {
        get = function(job) return tonumber(call('okokBanking', 'GetAccount', job)) or 0 end,
        add = function(job, amount) call('okokBanking', 'AddMoney', job, amount) return true end,
        remove = function(job, amount) return call('okokBanking', 'RemoveMoney', job, amount) ~= false end,
    },
    -- Renewed-compatible exports provided by wasabi_banking
    wasabi_banking = {
        get = function(job) return tonumber(call('wasabi_banking', 'getAccountMoney', job)) or 0 end,
        add = function(job, amount) return call('wasabi_banking', 'addAccountMoney', job, amount) ~= false end,
        remove = function(job, amount) return call('wasabi_banking', 'removeAccountMoney', job, amount) == true end,
    },
    ['qb-banking'] = {
        get = function(job)
            local ok, v = pcall(function() return exports['qb-banking']:GetAccountBalance(job) end)
            if ok and v then return tonumber(v) or 0 end
            return tonumber(call('qb-banking', 'GetBalance', job)) or 0
        end,
        add = function(job, amount, reason) return call('qb-banking', 'AddMoney', job, amount, reason) ~= false end,
        remove = function(job, amount, reason) return call('qb-banking', 'RemoveMoney', job, amount, reason) ~= false end,
    },
    ['qb-management'] = {
        get = function(job) return tonumber(call('qb-management', 'GetAccount', job)) or 0 end,
        add = function(job, amount) call('qb-management', 'AddMoney', job, amount) return true end,
        remove = function(job, amount) return call('qb-management', 'RemoveMoney', job, amount) ~= false end,
    },
    esx_addonaccount = {
        get = function(job)
            local p = promise.new()
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(a) p:resolve(a and a.money or 0) end)
            return Citizen.Await(p)
        end,
        add = function(job, amount)
            local p = promise.new()
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(a)
                if a then a.addMoney(amount) end
                p:resolve(a ~= nil)
            end)
            return Citizen.Await(p)
        end,
        remove = function(job, amount)
            local p = promise.new()
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(a)
                if a and a.money >= amount then a.removeMoney(amount) p:resolve(true) else p:resolve(false) end
            end)
            return Citizen.Await(p)
        end,
    },
}
local ORDER = { 'Renewed-Banking', 'okokBanking', 'wasabi_banking', 'qb-banking', 'qb-management', 'esx_addonaccount' }

function Business.Bank()
    local want = CV.BusinessBank or 'auto'
    if want ~= 'auto' then return Business.Banks[want], want end
    for _, name in ipairs(ORDER) do
        if GetResourceState(name) == 'started' then return Business.Banks[name], name end
    end
end

function Business.Balance(job)
    local b = Business.Bank()
    return b and b.get(job) or 0
end

function Business.Add(job, amount, reason)
    local b = Business.Bank()
    return b ~= nil and b.add(job, amount, reason)
end

function Business.Remove(job, amount, reason)
    local b = Business.Bank()
    if not b then return false, 'No business bank account system is running.' end
    if b.get(job) < amount then return false, 'The business account does not have enough money.' end
    return b.remove(job, amount, reason), 'The business payment did not go through.'
end

---------------------------------------------------------------------------
-- Who is a business: framework jobs, minus the ones excluded in config
---------------------------------------------------------------------------
local cache, cacheAt = nil, 0

function Business.All()
    if cache and os.time() - cacheAt < 300 then return cache end
    local skip = {}
    for _, j in ipairs(CV.ExcludeBusinesses or {}) do skip[j] = true end
    local out = {}
    for _, j in ipairs(Bridge.GetJobs()) do
        if not skip[j.name] then out[#out + 1] = { id = j.name, name = j.label or j.name } end
    end
    for _, extra in ipairs(CV.ExtraBusinesses or {}) do out[#out + 1] = { id = extra.id, name = extra.label or extra.id } end
    table.sort(out, function(a, b) return a.name < b.name end)
    cache, cacheAt = out, os.time()
    return out
end

function Business.Get(id)
    for _, b in ipairs(Business.All()) do if b.id == id then return b end end
end

function Business.Search(q, limit)
    q = tostring(q or ''):lower()
    local out = {}
    for _, b in ipairs(Business.All()) do
        if q == '' or b.name:lower():find(q, 1, true) or b.id:lower():find(q, 1, true) then
            out[#out + 1] = b
            if #out >= (limit or 10) then break end
        end
    end
    return out
end

--- The business this player can act for (they're a boss there), or nil.
function Business.BossOf(src)
    if not src then return nil end
    local job = Bridge.GetJob(src)
    if not job or not job.name or not job.isboss then return nil end
    local b = Business.Get(job.name)
    return b
end

function Business.IsBoss(src, id)
    local b = Business.BossOf(src)
    return b ~= nil and b.id == id
end

--- Online bosses of a business.
function Business.Bosses(id)
    local out = {}
    for _, p in ipairs(GetPlayers()) do
        local s = tonumber(p)
        if Business.IsBoss(s, id) then out[#out + 1] = s end
    end
    return out
end

function Business.Notify(id, msg, kind)
    for _, s in ipairs(Business.Bosses(id)) do Bridge.Notify(s, msg, kind) end
end
