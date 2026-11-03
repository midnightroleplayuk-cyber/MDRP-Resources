Config = Config or {}

-- canUse() is triggered client side only
-- return boolean (true/false)
-- Cops can only view/access the tracks and events with the "police" category

Config.TracksCategories = {
    {
        value = "bikes",
        label = "Bikes",
        canUse = function()
            return not exports['av_laptop']:isCop()
        end
    },
    {
        value = "circuit",
        label = "Circuit",
        canUse = function()
            return not exports['av_laptop']:isCop()
        end
    },
    {
        value = "drag",
        label = "Drag",
        canUse = function()
            return not exports['av_laptop']:isCop()
        end
    },
    {
        value = "drift",
        label = "Drift",
        canUse = function()
            return not exports['av_laptop']:isCop()
        end
    },
    {
        value = "police",
        label = "Police",
        canUse = function()
            return exports['av_laptop']:isCop()
        end
    },
}