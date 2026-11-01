-- Load as a client script in Chezza Inventory after its shared configuration.
-- This replaces the stock 4.3.9 restraint hook; merge custom providers here if needed.
assert(type(Config) == "table" and type(Config.isHandcuffed) == "function",
    "[sky_jobs_base] Load chezza_restraints.lua after Chezza's config.functions.lua")

-- A stopped legacy resource must not select Chezza's Jaksam-only trunk bridge.
Config.useJobCreator = Config.useJobCreator == true and GetResourceState("jobs_creator") == "started"

Config.isHandcuffed = function(playerId)
    if GetResourceState("sky_jobs_base") == "started" and exports.sky_jobs_base:isPlayerCuffed(playerId) then
        return true
    end

    if GetResourceState("msk_handcuffs") == "started" then
        local cuffed
        if playerId then
            cuffed = exports.msk_handcuffs:getIsHandcuffed({ source = playerId })
        else
            cuffed = exports.msk_handcuffs:getIsHandcuffed()
        end
        if cuffed then return true end
    end

    if not playerId and GetResourceState("jobs_creator") == "started"
        and exports.jobs_creator:isPlayerHandcuffed() then
        return true
    end
    return false
end
