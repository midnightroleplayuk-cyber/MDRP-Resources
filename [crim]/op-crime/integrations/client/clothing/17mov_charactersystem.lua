--------------------------------------------
-- FUNCTIONS TO SET/GET PLAYERS CLOTHES ----
--------------------------------------------

if Config.Clothing.clothingScript ~= "17mov_CharacterSystem" then return end

function getPlayerClothes(cb)
    cb(exports['illenium-appearance']:getPedComponents(PlayerPedId()))
end

function setPlayerClothes(clothing)
    exports['illenium-appearance']:setPedComponents(PlayerPedId(), clothing)
end