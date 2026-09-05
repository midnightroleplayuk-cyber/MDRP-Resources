--------------------------------------------
-- FUNCTIONS TO SET/GET PLAYERS CLOTHES ----
--------------------------------------------

if Config.Clothing.clothingScript ~= "0r-clothingv2" then return end

function getPlayerClothes(cb)
    local skinData = exports["0r-clothingv2"]:getPlayerClothing(PlayerPedId())
    cb(skinData) 
end

function setPlayerClothes(clothing)
    TriggerEvent('0r-clothing:client:loadPlayerClothing', clothing, PlayerPedId())
end