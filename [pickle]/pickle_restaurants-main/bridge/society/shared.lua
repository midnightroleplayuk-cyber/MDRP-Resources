-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/society (shared) — the society/business-account PROVIDER registry.
--
-- A restaurant's balance is its JOB's society account, held by whatever banking
-- resource the server runs. We do not host it (see bridge/society/server.lua for
-- why), so every banking resource we can talk to is one small file in a folder of
-- its own — the same shape bridge/phone and bridge/target use, and the same shape
-- bridge/inventory now uses.
--
-- PROBED BY PROVIDER, NOT BY FRAMEWORK. Money providers are not 1:1 with
-- frameworks — Renewed-Banking `provide`s both `qb-management` AND `esx_society`,
-- and okokBanking runs on ESX and QB alike — so "ESX ⇒ addon accounts" is simply
-- wrong on a server running either. The registry is ordered by PRIORITY, and the
-- highest-priority provider whose resource is actually started wins.
--
-- ADDING YOUR BANKING RESOURCE is one file:
--
--     -- bridge/society/my-banking/server.lua
--     RegisterSocietyProvider({
--         name     = "my-banking",   -- resource name, also the boot-log label
--         priority = 60,
--         get  = function(job)      return tonumber(SocietyExport("my-banking", "GetAccount", job)) end,
--         add  = function(job, amt) return SocietyExport("my-banking", "AddMoney", job, amt) ~= nil end,
--         take = function(job, amt) return SocietyExport("my-banking", "RemoveMoney", job, amt) ~= nil end,
--         make = function(job, label) … end,   -- optional: create the account
--     })
--
-- `get` returning nil means "I don't know this account", which is different from a
-- balance of 0 and is what stops a missing account reading as a broke restaurant.
-- `make` is optional — a provider that creates accounts on first write says so by
-- not defining it.
-- ─────────────────────────────────────────────────────────────────────────────

SocietyProviders = SocietyProviders or {}

function RegisterSocietyProvider(def)
    if type(def) ~= "table" or type(def.name) ~= "string" then return end
    -- Idempotent by name, so an edited provider reloaded with the resource can't
    -- end up listed twice at two priorities.
    for i, p in ipairs(SocietyProviders) do
        if p.name == def.name then SocietyProviders[i] = def return end
    end
    SocietyProviders[#SocietyProviders + 1] = def
end

-- Call an export that might not exist. Indexing a missing export RAISES (the same
-- trap the phone and inventory bridges document — the index is an ARGUMENT to
-- pcall, evaluated before pcall ever runs), so the index happens INSIDE the
-- protected call. Returns the export's first two return values, or nil on a miss.
function SocietyExport(resource, name, ...)
    local args = table.pack(...)
    local ok, a, b = pcall(function()
        return exports[resource][name](nil, table.unpack(args, 1, args.n))
    end)
    if not ok then return nil end
    return a, b
end

-- DID THE MONEY ACTUALLY MOVE? Use this for every `add`/`take`, never a bare
-- `SocietyExport(...) ~= nil`.
--
-- That test was wrong in both directions and it was wrong about money. Every bank
-- here answers a refusal with an explicit `false` — Renewed's AddAccountMoney for
-- an account that doesn't exist, its RemoveAccountMoney for an account that can't
-- cover the amount, and the qb-management / qb-banking / okok / fd equivalents —
-- and `false ~= nil` is TRUE, so a refusal read as success. A credit into a
-- missing account then destroyed a customer's payment, and a debit the bank
-- refused still paid the player out of a balance that never moved, which is a
-- faucet.
--
-- A call that RAISES (resource stopped, export renamed by a fork, an error inside
-- the bank) is also a refusal: nothing moved. A provider that returns NOTHING on
-- success is the common shape, so a nil return with no error is a yes.
function SocietyMoved(resource, name, ...)
    local args = table.pack(...)
    local ok, a = pcall(function()
        return exports[resource][name](nil, table.unpack(args, 1, args.n))
    end)
    if not ok then return false end
    return a ~= false
end

-- A balance out of a provider that answers with an account TABLE rather than a
-- number. Renewed and okok both do this on some builds, and a table where a number
-- was expected reads as "unknown account" — i.e. as a broke restaurant.
function SocietyAmount(value)
    if type(value) == "number" then return value end
    if type(value) == "string" then return tonumber(value) end
    if type(value) == "table" then
        return tonumber(value.amount or value.balance or value.money or value.account_balance)
    end
    return nil
end
