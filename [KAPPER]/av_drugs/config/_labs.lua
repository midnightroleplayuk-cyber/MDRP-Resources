-- You can find a lot more config options for labs in server/editable/_labs.lua
Config = Config or {}
Config.MoneyAccount = "bank" -- Money account used to pay upgrades
Config.RaidItem = "pd_decrypter" -- Item used to raid, modify the raid check in client/editable/raid.lua
Config.DaysForTransfer = 5 -- Days the player needs to wait before he can transfer the lab / or set to false to disable Transfer button
-- Config.DaysRaided = true > will completely delete the lab (after sv restart) if it gets seized by cops
-- Config.DaysRaided = false > the lab will be stopped and will go back online until next sv restart
-- Config.DaysRaided = 5 > lab will be unavailable for use for X days
Config.DaysRaided = 5
Config.CanDeleteLab = true -- true/false lab owner can delete it (no money will be given back)
Config.DefaultLabStash = { -- all labs without upgrades will have this stash
    slots = 10, -- stash slots
    weight = 10000, -- stash weight (10kg)
}
Config.DefaultSecurity = {
    hand = "left", seconds = 10, blocks = 14
}

Config.Prices = {
    ['stash'] = 50000, -- per level
    ['security'] = 30000, -- per level
    ['maintenance'] = 25000, -- every week
}

Config.Upgrades = {
    ['stash'] = {
        [1] = {slots = 20, weight = 20000},
        [2] = {slots = 35, weight = 35000},
        [3] = {slots = 50, weight = 50000},
    },
    ['security'] = { -- this is used for the Thermite minigame, check client/editable/minigames.lua
        [1] = {hand = "right", seconds = 9, blocks = 15},
        [2] = {hand = "both", seconds = 8, blocks = 17},
        [3] = {hand = "both", seconds = 8, blocks = 18},
    }
}