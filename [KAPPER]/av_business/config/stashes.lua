Config = Config or {}
-- Stashes and Trays default weight and slots

Config.StashWeight = 500000     -- Stash Weight (500kg)
Config.StashSlots = 50          -- Stash Item Slots
Config.TrayWeight = 50000       -- Tray Weight (50kg)
Config.TraySlots = 10           -- Tray Item Slots
Config.Boxes = {                -- Box stash config
    slots = 5,
    weight = 5000               -- 5kg
}

function getStashName(name, job, type)
    -- You can change the stash/tray inventory name here or just leave the return name as it is
    dbug("getStashName()",name,job,type)
    return name
end