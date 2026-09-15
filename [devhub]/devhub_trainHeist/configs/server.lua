Config = {}

Config.Debug = true

-- Queue system
Config.MaxTaskTime = 20          -- minutes: safety cap on a single heist; the slot is force-freed after this
Config.PersonalCooldownTime = 10 -- minutes: per-player cooldown applied once their heist is processed

-- ── Cargo payout ─────────────────────────────────────────────────────────────
-- How the dynamic loot payout (sum of delivered cargo prices) is paid on drop-off.
--   type = 'item' -> given as an inventory item, `item` below (default: black_money)
--   type = 'cash' -> given as clean cash straight to the player's pocket
Config.Payout = {
    type = 'item',
    item = 'black_money',
}

-- ── Police alerts ────────────────────────────────────────────────────────────
-- Every time a player handles loot there is a chance the cops get tipped off.
-- This works for ANYONE touching the loot, even teammates who did not start the heist.
Config.Police = {
    -- Chance (0-100) the police get alerted each time a player...
    callChance = {
        pickup = 15, -- ...grabs a loot prop off the train
        search = 20, -- ...searches a crate
        load   = 10, -- ...loads an item into the getaway vehicle
    },
    -- Quiet window (seconds) after an alert fires before the SAME player can trigger
    -- another one. Stops a flood of calls when looting fast. Set to 0 for an
    -- independent roll on literally every action.
    cooldownSeconds = 20,
}

-- Called server-side whenever the police actually get alerted (after the chance roll).
-- Plug your own dispatch / alarm logic in here (e.g. ps-dispatch, cd_dispatch, etc.).
-- `coords` is where the player was when they tipped off the cops.
function TriggerAlarm(source, coords)
    -- TODO implement your police call logic here (server side) or go to configs/client.lua to implement it client side
end

-- Completion rewards.
-- Granted DIRECTLY to the player the moment a heist is finished successfully,
-- on top of the dynamic black money payout calculated from the delivered cargo.
--   cash  -> a single random amount between min and max (Core.AddCash)
--   items -> a random number of DIFFERENT items (between minItems and maxItems),
--            each given in a random quantity between its own min and max (Core.AddItem)
Config.CompletionRewards = {
    cash = {
        enabled = true,
        min = 5000,  -- minimum cash reward
        max = 12000, -- maximum cash reward
    },

    items = {
        enabled = true,
        minItems = 1, -- minimum number of different items to hand out
        maxItems = 3, -- maximum number of different items to hand out
        -- Pool of possible items. `min`/`max` is the random quantity for that item.
        -- `label` is only used for the notification text (falls back to `name`).
        pool = {
            { name = "gold_bar",         label = "Gold Bar",         min = 1, max = 3 },
            { name = "diamond_ring",     label = "Diamond Ring",     min = 1, max = 2 },
            { name = "rolex",            label = "Rolex Watch",      min = 1, max = 2 },
            { name = "money_bag",        label = "Money Bag",        min = 1, max = 2 },
            { name = "electronic_parts", label = "Electronic Parts", min = 2, max = 6 },
            { name = "weapon_parts",     label = "Weapon Parts",     min = 1, max = 4 },
        },
    },
}
