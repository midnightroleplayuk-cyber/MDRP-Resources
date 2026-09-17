---@meta

---@description Example inventory item data for wasabi_mdt_v2
--- Copy  `wasabi_inventory` into wasabi_inventory/data/items.lua, `ox` into ox_inventory/data/items.lua, `qb` into qb-inventory items, `jaksam` into jaksam_inventory/_data/items.lua, `codem` into codem-inventory/config/itemlist.lua (`Config.Itemlist`), `tgiann` into tgiann-inventory/items/items.lua (itemsData).
---
--- Usable item is registered by wasabi_mdt_v2 via bridge.registerUsableItem (Config.OpenMDT.item.name).


local wasabi_inventory = {
    ["mdt_tablet"] = { -- Make sure no duplicates exist in the original items.lua
        label = 'MDT Tablet',
        description = 'A law enforcement MDT device.',
        weight = 50,
        stack = false,
        close = true
    },
}

local ox = {
    ["mdt_tablet"] = { -- Make sure no duplicates exist in the original items.lua
        label = 'MDT Tablet',
        description = 'A law enforcement MDT device.',
        weight = 50,
        stack = false,
        close = true
    },
}

-- QB-Inventory
local qb = {
    mdt_tablet = {name = "mdt_tablet", label = "MDT Tablet", weight = 50, type = "item", image = "mdt_tablet.png", unique = true, useable = true, shouldClose = true, combinable = nil, description = "A law enforcement MDT device."}, -- Make sure no duplicates exist in the original items.lua
}

-- codem-inventory (config/itemlist.lua)
local codem = {
    mdt_tablet = { name = "mdt_tablet", label = "MDT Tablet", weight = 50, type = "item", image = "mdt_tablet.png", unique = true, useable = true, shouldClose = true, description = "A law enforcement MDT device." }, -- Make sure no duplicates exist in the original itemlist
}

-- tgiann-inventory (items.lua itemsData)
-- Copy into tgiann-inventory/items/items.lua — resolve name clashes with any existing items.
local tgiann = {
    mdt_tablet = { hasMetadata = true, label = "MDT Tablet", weight = 50, type = "item", image = "mdt_tablet.png", unique = true, useable = true, shouldClose = true, description = "A law enforcement MDT device." }, -- Make sure no duplicates exist in the original items.lua
}

-- jaksam_inventory: installed under `Script.Items` in `jaksam_inventory/_data/items.lua`.
-- When updating: copy changes from here into that file, or edit both and grep `jaksam_inventory/_data/items.lua` for `['mdt_tablet']` so you never define the same key twice.
-- Usable item is driven by wasabi_mdt_v2 via registerUsableItem; you do not need `onUse` here (see jaksam item_example.lua).
local jaksam = {
    ['mdt_tablet'] = { -- Check for duplicates in jaksam_inventory/_data/items.lua
        label = 'MDT Tablet',
        description = 'A law enforcement MDT device.',
        weight = 2,
        stackable = false,
        close = true,
    },
}
