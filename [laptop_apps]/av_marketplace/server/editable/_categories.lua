Config = Config or {}
Config.Categories = {
    ['electronics'] = {
        label = "Electronics",
        canAccess = function(playerId, serial)
            return true
        end,
    },
    ['underground'] = {
        label = "Underground",
        canAccess = function(playerId, serial)
            local isCop = exports['av_laptop']:hasJob(playerId, {"police", "sheriff", "bcso", "leo"})
            return not isCop
        end,
    },
    ['properties'] = {
        label = "Properties",
        canAccess = function(playerId, serial)
            return true
        end,
    },
    ['services'] = {
        label = "Services",
        canAccess = function(playerId, serial)
            return true
        end,
    },
}