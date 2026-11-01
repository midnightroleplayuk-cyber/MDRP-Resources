-- For more raid settings go to client/editable/raid.lua
Config = Config or {}
Config.MinLevelForRaid = 1 -- Min level needed to raid another gang
Config.LockOnRestart = false -- true = it will lock all open properties on sv restart
Config.MinMembersOnline = 1 -- min gang members online so other ppl can raid their property
Config.PoliceNeedsItem = "phone" -- Item name or false if police can raid without using an item
Config.GangsNeedItem = "phone" -- Item name or false if gangs can raid without using an item
Config.RemoveItemOnUse = true -- true/false remove the raid item on use
Config.Police = { -- supports multiple jobs and grades, only this jobs/grades can raid properties (client/editable/raid.lua)
    ['police'] = { -- job name
        ['Chief'] = true, -- grade name (qb: qb-core > shared > jobs > grade name)
        ['boss'] = true, -- grade name (esx: database > job_grades table > name)
    },
}

--[[
    Use this function to randomize the gang alert when someone tries to raid
    higher the property security level = more probabilities for gang members to get notified
    If u have 0 clue what is this or how it works just leave it how it is :D
]]--
function alertChance(level)
    local random = 5
    random -= level -- means random can be 5, 4, 3 or 2
    local chance = math.random(1, random)
    if chance == 1 then
        return true
    end
    return false
end