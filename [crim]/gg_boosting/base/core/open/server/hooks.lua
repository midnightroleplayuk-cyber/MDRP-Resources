hooks = hooks or {}


-- NOTE: Fired for every player in the boosting group when a boost is completed

--- @param payload table
--- @param payload.player table
--- @param payload.player.source number
--- @param payload.player.identifier string
--- @param payload.player.name string
--- @param payload.player.leader boolean
---
--- @param payload.job table
--- @param payload.job.vehicle string
--- @param payload.job.label string
--- @param payload.job.class string
--- @param payload.job.payout number
--- @param payload.job.rep number
--- @param payload.job.vinScratch boolean

--- @param payload.group_id number
hooks.onBoostComplete = function(payload)


    -- Example to only fire once per group check if user is leader - payload.player.leader
end

