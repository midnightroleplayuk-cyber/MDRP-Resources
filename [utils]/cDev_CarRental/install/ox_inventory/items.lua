--[[
    cDev Car Rental - ox_inventory item

    1. Open ox_inventory/data/items.lua.

    2. If the file returns one big table, merge the ['rental_papers'] entry below into it
       (same keys as in this file’s return table).

    3. Item name must match Config.RentalPapersItem in config.lua (default: rental_papers).

    4. Set Config.InventorySystem = 'ox_inventory' in cDev_CarRental/config.lua.

    5. Image: copy rental_papers.png from this install folder to:
       ox_inventory/web/images/rental_papers.png

    6. Restart ox_inventory, then ensure cDev_CarRental.
]]

return {
    ['rental_papers'] = {
        label = 'Rental Papers',
        weight = 10,
        stack = false,
        close = true,
        description = 'Vehicle rental agreement papers',
        client = {
            export = 'cDev_CarRental.useRentalPapers',
        },
    },
}
