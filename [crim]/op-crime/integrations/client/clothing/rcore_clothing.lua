--------------------------------------------
-- FUNCTIONS TO SET/GET PLAYERS CLOTHES ----
--------------------------------------------

if Config.Clothing.clothingScript ~= "rcore_clothing" then return end

function getPlayerClothes(cb)
    local playerClothing = exports['rcore_clothing']:getPlayerClothing()
    cb(playerClothing)
end

function setPlayerClothes(clothing)
    exports['rcore_clothing']:setPedSkin(PlayerPedId(), clothing, true)
end