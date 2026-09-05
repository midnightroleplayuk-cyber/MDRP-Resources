--------------------------------------------
-- FUNCTIONS TO SET/GET PLAYERS CLOTHES ----
--------------------------------------------

if Config.Clothing.clothingScript ~= "fivem-appearance" then return end

function getPlayerClothes(cb)
    cb(exports['fivem-appearance']:getPedComponents(PlayerPedId()))
end

function setPlayerClothes(clothing)
    exports['fivem-appearance']:setPedComponents(PlayerPedId(), clothing)
end