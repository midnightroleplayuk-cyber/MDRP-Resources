-- bridge/society/esx_addonaccount — ESX's shared "society_<job>" accounts.
--
-- EVENT-SHAPED, NOT EXPORT-SHAPED, and that is the whole reason this file reads
-- differently from its neighbours: the account arrives through a callback. That
-- callback fires INLINE — esx_addonaccount looks the account up in a table it
-- already holds — so reading the result out of a closure afterwards is safe. There
-- is no yield between the trigger and the read, which is what would otherwise make
-- this pattern a race.
--
-- The account NAME is `society_<job>`, not the job: that prefix is ESX convention
-- and every ESX society resource expects it.
local function account(job, fn)
    local done = false
    TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. job, function(acc)
        if acc then done = fn(acc) ~= false end
    end)
    return done
end

RegisterSocietyProvider({
    name     = "esx_addonaccount",
    resource = "esx_addonaccount",
    priority = 60,
    get  = function(job)
        local money
        account(job, function(acc) money = tonumber(acc.money) end)
        return money
    end,
    add  = function(job, amt) return account(job, function(acc) acc.addMoney(amt) end) end,
    take = function(job, amt)
        return account(job, function(acc)
            if (tonumber(acc.money) or 0) < amt then return false end
            acc.removeMoney(amt)
        end)
    end,
})
