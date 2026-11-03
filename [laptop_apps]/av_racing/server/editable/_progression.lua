--[[ 
    every level should contain the following format:
    {
        identifier?string Unique identifier for the prize, default Level1, Level2, Level3...
        level:number Level needed to redeem it (should be unique),
        label:string Label shown in UI
        image?:string Image name to show in UI, make sure it exists in ui/dist/rewards folder (name + extension)
        description?:string Short description shown in UI when a level card is flipped (the info icon)
        notification?:string Notification to show after redeem
        onRedeem:function()
            onRedeem receives 2 params (playerId:number, identifier:string)
            use this parameters to trigger your own reward, I have included a basic addMoney exports
            exports['av_laptop']:addMoney(playerId, accountName, amount)
            make sure to return true to avoid the player from redeeming this level multiple times
    }
            -- onRedeem should ALWAYS return true if redeemed
            -- onRedeem should ALWAYS return true if redeemed
            -- onRedeem should ALWAYS return true if redeemed
]]--
ProgressionLevels = {
    {level = 1, label = "10 Cosmo", image = "tokens.png", notification = "You received 10 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 10)
        end,
    },
    {level = 3, label = "10 Cosmo", image = "tokens.png", notification = "You received 10 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 10)
        end,
    },
    {level = 5, label = "10 Cosmo", image = "tokens.png", notification = "You received 10 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 10)
        end,
    },
    {level = 10, label = "25 Cosmo", image = "tokens.png", notification = "You received 25 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 25)
        end,
    },
    {level = 15, label = "50 Cosmo", image = "tokens.png", notification = "You received 50 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 50)
        end,
    },
    {level = 20, label = "50 Cosmo", image = "tokens.png", notification = "You received 50 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 50)
        end,
    },
    {level = 25, label = "50 Cosmo", image = "tokens.png", notification = "You received 50 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 50)
        end,
    },
    {level = 30, label = "100 Cosmo", image = "tokens.png", notification = "You received 100 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 100)
        end,
    },
    {level = 40, label = "250 Cosmo", image = "tokens.png", notification = "You received 250 Cosmo",
        onRedeem = function(playerId, identifier)
            return exports['av_laptop']:addMoney(playerId, "cosmo", 250)
        end,
    },
    {level = 50, label = "Invertero Coquette D10", image = "vehicle.png", description = "The vehicle will be sent to your Pillbox Garage",
         notification = "You received a Invertero Coquette D10, you can claim it at Pillbox Garage",
        onRedeem = function(playerId, identifier)
            return addVehicle(identifier, 'coquette4')
        end,
    },
}