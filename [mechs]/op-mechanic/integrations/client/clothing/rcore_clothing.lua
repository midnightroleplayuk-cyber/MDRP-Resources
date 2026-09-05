--------------------------------------------
-- FUNCTIONS TO SET/GET PLAYERS CLOTHES ----
--------------------------------------------

if Config.Clothing.clothingScript ~= 'rcore_clothing' then return end

function getPlayerClothes(cb)
    cb(exports['rcore_clothing']:getPlayerClothing())
end

function setPlayerClothes(clothing)
    exports['rcore_clothing']:setPedSkin(PlayerPedId(), clothing, true)
end