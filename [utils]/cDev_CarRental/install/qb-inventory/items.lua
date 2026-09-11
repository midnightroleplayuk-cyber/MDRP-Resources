--[[
    cDev Car Rental - qb-inventory item (QBCore / Qbox shared items)

    1. Open qb-core/shared/items.lua (or qbx_core/shared/items.lua on Qbox — same pattern).

    2. Inside the main items table, add the entry below (keep the comma after the closing }).

    3. Item name must match Config.RentalPapersItem in config.lua (default: rental_papers).

    4. Server registration: cDev_CarRental registers CreateUseableItem for this item automatically
       when Config.Framework is qb or qbox and Config.InventorySystem is qb-inventory.

    5. Image: copy rental_papers.png from install/ox_inventory/rental_papers.png to:
       qb-inventory/html/images/rental_papers.png
       (path may differ slightly if you use a fork; use the same filename as ['image'] below).

    6. Restart qb-inventory (and qb-core if you edited shared items), then ensure cDev_CarRental.
]]

-- Paste this block into shared/items.lua (inside the items table):
--[[

    ['rental_papers'] = {
        ['name'] = 'rental_papers',
        ['label'] = 'Rental Papers',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'rental_papers.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['combinable'] = nil,
        ['description'] = 'Vehicle rental agreement papers',
    },

]]
