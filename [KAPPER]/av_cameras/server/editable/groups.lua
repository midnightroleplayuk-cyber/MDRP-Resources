-- List of fixed groups, this is used for server cameras,
-- for example a group for all cameras in a bank, or a group for all cameras in a store, etc.
-- canAccess is a function that should return true if the player have access to the cameras in this group, for example you can check if the player has a certain job or a certain item, etc.

Config = Config or {}
Config.FixedGroups = {
    ["pacific_bank"] = { -- index key should be unique
        label = "Pacific Bank",
        canAccess = function(playerId)
            local hasAccess = false
            -- Add your own check here and set hasAccess to true if the player should have access to Pacific Bank cameras, for example:
            hasAccess = exports['av_laptop']:hasJob(playerId, {"police", "sheriff", "leo", "bsco"})
            -- Leave the rest of the code as is, it will print a debug message with the result
            dbug("Does player with server id "..tostring(playerId).." have access to bank cameras? "..tostring(hasAccess))
            return hasAccess
        end,
    },
    ["mrpd"] = { -- index key should be unique
        label = "Mission Row PD",
        canAccess = function(playerId)
            local hasAccess = false
            -- Add your own check here and set hasAccess to true if the player should have access to MRPD cameras, for example:
            hasAccess = exports['av_laptop']:hasJob(playerId, {"police", "sheriff", "leo", "bsco"})
            -- Leave the rest of the code as is, it will print a debug message with the result
            dbug("Does player with server id "..tostring(playerId).." have access to MRPD cameras? "..tostring(hasAccess))
            return hasAccess
        end,
    },
    ['city_cameras'] = { -- index key should be unique
        label = "City Cameras",
        canAccess = function(playerId)
            local hasAccess = false
            -- Add your own check here and set hasAccess to true if the player should have access to city cameras, for example:
            hasAccess = exports['av_laptop']:hasJob(playerId, {"police", "sheriff", "leo", "bsco"})
            -- Leave the rest of the code as is, it will print a debug message with the result
            dbug("Does player with server id "..tostring(playerId).." have access to city cameras? "..tostring(hasAccess))
            return hasAccess
        end,
    },
    ['fleeca_banks'] = { -- index key should be unique
        label = "Fleeca Banks",
        canAccess = function(playerId)
            local hasAccess = false
            -- Add your own check here and set hasAccess to true if the player should have access to Fleeca Banks cameras, for example:
            hasAccess = exports['av_laptop']:hasJob(playerId, {"police", "sheriff", "leo", "bsco"})
            -- Leave the rest of the code as is, it will print a debug message with the result
            dbug("Does player with server id "..tostring(playerId).." have access to Fleeca Banks cameras? "..tostring(hasAccess))
            return hasAccess
        end,
    },
}