-- bridge/inventory/none — no inventory at all.
--
-- A frameworkless server with no inventory resource has nowhere to put an item,
-- and that is a legitimate way to run this resource: everything the kitchen makes
-- lives in the cooked-items pool, and `giveVessel` already falls back to the tray
-- whenever an inventory can't take a vessel. So the answer here is a driver that
-- honestly holds nothing, NOT a missing `Inventory` table — one nil-check skipped
-- somewhere would otherwise error out a whole order.
--
-- It claims at priority 0 with no resource guard, so it only ever wins when every
-- other driver has stood down. Adds and removes report failure rather than
-- pretending, which is exactly what makes the tray fallback take over.
RegisterInventoryDriver({
    name     = "none (no inventory installed)",
    priority = 0,
    metadata = true,   -- nothing is stored, so nothing can lose its metadata
    build = function()
        return {
            items     = function() return {} end,
            exists    = function() return false end,
            count     = function() return 0 end,
            canCarry  = function() return false end,
            inventory = function() return {} end,
            slots     = function() return {} end,
            add       = function() return false end,
            remove    = function() return false end,
        }
    end,
})
