Config = Config or {}
Config.GraffitisAlwaysVisible = false -- graffitis are hidden until discovered by gang
Config.PlaceSprayTime = 30 --in seconds
Config.RemoveSprayTime = 30 -- in seconds
Config.ProgressType = "progressBar" -- "progressCircle" or "progressBar"
Config.RemoveDistance = 7 -- distance needed to remove a graffiti
Config.ZoneRadius = 80.0 -- Distance between graffitis
Config.MinMembersForRemover = 0 -- Min members online to remove their graffiti
Config.SprayGivesXP = 10 -- Gang receives XP when creating a graffiti or false
Config.RemoveSprayGivesXP = 10 -- Remove other Gang Spray will give you XP or false
Config.LoseGraffitiXP = 10 -- If your graffiti is removed, you will lose XP or false
Config.ShopAccount = 'bank' -- Account used to pay for items
Config.SprayTime = 6 -- (hours) Time before the spray item becomes totally unusable
Config.RemoveSprayOnUse = true -- true it will remove spray item on use, player will lose the item even if he decides not to place the graffiti
Config.AllowGraffitiScale = true -- allow (or not) players to change the graffiti image scale
Config.ItemNames = {
    spray = "spray", -- Used to apply graffiti
    remover = "spray_remover" -- Used to remove graffiti
}
Config.Prices = { ['spray'] = 1000, ['remover'] = 20000 }
Config.ItemCooldown = { -- Cooldown in hours, gangs can buy this item every X hours
    [Config.ItemNames['spray']] = 7,
    [Config.ItemNames['remover']] = 7,
}
Config.SprayMultiplier = 1.25 -- Multiplier for spray price (SprayPrice * SprayMultiplier * Graffitis Count)