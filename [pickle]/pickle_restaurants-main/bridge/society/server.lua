-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/society (server) — WHERE A RESTAURANT'S MONEY LIVES.
--
-- A restaurant's balance is its JOB's society/business account, held by whatever
-- banking resource the server runs. We do not host it: there is no `balance` of
-- ours to drift from the boss menu the rest of the server already uses, and paying
-- wages or buying stock moves the same dollars a job's own banking UI shows.
--
-- This file is the RESOLVER and the public API. Every provider is its own file in
-- a folder beside it (bridge/society/<resource>/server.lua) and registers itself
-- through bridge/society/shared.lua — so supporting one more bank is one more
-- file, and none of the framework bridges define any of this (two definitions of
-- `AddSocietyMoney` would be a load-order coin toss).
--
-- The API (nil-safe, and `jobName` is the account name — a restaurant with no job
-- assigned has no account, which is one more reason a job is REQUIRED):
--     SocietyAvailable()                    -- is there a real account store at all
--     SocietyProvider()                     -- its name, for the boot log / diagnostics
--     GetSocietyBalance(jobName)            -- number, 0 when unknown
--     AddSocietyMoney(jobName, amount)      -- true on success
--     RemoveSocietyMoney(jobName, amount)   -- true on success; false when short
--     EnsureSocietyAccount(jobName, label)  -- best-effort create, safe to repeat
-- ─────────────────────────────────────────────────────────────────────────────

-- WE ARE THE BANK ONLY WHEN THERE IS NO BANK. A frameworkless server has no
-- society system to hold anything, and the same reasoning that made this resource
-- the job system there applies to the money: one small table, used ONLY on that
-- path, so the feature works standalone without pretending to be a bank on a
-- server that has one. (The legacy `pickle_restaurants.balance` column is NOT this
-- store — it is dead.)
--
-- It lives HERE rather than in a folder of its own because it is not a provider
-- you could add or remove: it is the floor the resolver lands on.
local FALLBACK = {
    name = "pickle_restaurants (standalone)",
    get  = function(job) return SocietyLocalBalance and SocietyLocalBalance(job) or 0 end,
    add  = function(job, amt) return SocietyLocalAdjust and SocietyLocalAdjust(job, amt) or false end,
    take = function(job, amt) return SocietyLocalAdjust and SocietyLocalAdjust(job, -amt) or false end,
}

local resolved = nil

local function provider()
    if resolved then return resolved end
    local best
    for _, p in ipairs(SocietyProviders or {}) do
        local running = (not p.resource) or GetResourceState(p.resource) == "started"
        if running and (not p.ok or p.ok()) then
            if not best or (p.priority or 0) > (best.priority or 0) then best = p end
        end
    end
    resolved = best or FALLBACK
    return resolved
end

-- Re-probe when resources start/stop: a banking resource that boots after us must
-- not leave us writing to the standalone table for the rest of the session.
AddEventHandler("onResourceStart", function() resolved = nil end)
AddEventHandler("onResourceStop", function() resolved = nil end)

-- ─── the API ─────────────────────────────────────────────────────────────────

function SocietyProvider() return provider().name end
function SocietyAvailable() return provider() ~= FALLBACK end

function GetSocietyBalance(jobName)
    if not jobName or jobName == "" then return 0 end
    return math.floor(SocietyAmount(provider().get(jobName)) or 0)
end

function AddSocietyMoney(jobName, amount)
    amount = math.floor(tonumber(amount) or 0)
    if not jobName or jobName == "" or amount <= 0 then return false end
    return provider().add(jobName, amount) and true or false
end

function RemoveSocietyMoney(jobName, amount)
    amount = math.floor(tonumber(amount) or 0)
    if not jobName or jobName == "" or amount <= 0 then return false end
    -- Check first even though most providers check for themselves: they disagree
    -- about whether an overdraw is refused or silently allowed, and a restaurant
    -- must never be able to spend money it doesn't have.
    if GetSocietyBalance(jobName) < amount then return false end
    return provider().take(jobName, amount) and true or false
end

function EnsureSocietyAccount(jobName, label)
    if not jobName or jobName == "" then return false end
    local p = provider()
    if not p.make then return true end -- provider auto-creates on first write
    return p.make(jobName, label) and true or false
end

CreateThread(function()
    Wait(2000)
    print(("[pickle_restaurants] restaurant funds are held by: %s"):format(SocietyProvider()))
end)
