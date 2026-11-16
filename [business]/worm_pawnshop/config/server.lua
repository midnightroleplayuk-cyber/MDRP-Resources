--[[ worm_pawnshop - server settings and hooks ]]

return {
    -- Create the tables on start (same schema as install.sql)
    autoSql = true,

    -- Order state scan (expiry / preparation transitions) interval in seconds
    tickSeconds = 5,

    -- true: only one player at a time per computer; false: everyone can use the same computer at once
    -- (the screen content is only drawn for the player using it, others keep seeing the lock screen)
    lockComputers = false,

    -- How many deliveries may share one spot at the same time (1 = no overlap)
    spotCapacity = 1,

    -- Stats / leaderboards
    stats = {
        topLimit = 10,
        recentLimit = 12,
    },

    -- Discord log webhook (empty = disabled)
    webhook = '',

    hooks = {
        -- May the player use this computer? Return false to block.
        canUse = function(src, computer)
            return true
        end,

        -- After an order was accepted
        onAccepted = function(src, order) end,

        -- When the shipment started (box added to the storage)
        onShipped = function(src, order) end,

        -- When the delivery completed; result = { payout, laundered, cut, dispatched }
        onDelivered = function(src, order, result) end,

        -- When an order was cancelled or expired; reason = 'cancel' | 'expire'
        onClosed = function(src, order, reason) end,
    },
}
