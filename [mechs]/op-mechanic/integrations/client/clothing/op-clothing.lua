--------------------------------------------
-- FUNCTIONS TO SET/GET PLAYERS CLOTHES ----
--------------------------------------------
-- Docs: https://docs.otherplanet.dev/scripts/op-clothing/exports-events/client-side

if Config.Clothing.clothingScript ~= 'op-clothing' then return end

function getPlayerClothes(cb)
    cb(exports['op-clothing']:GetPlayerClothing())
end

function setPlayerClothes(clothing)
    exports['op-clothing']:ApplyOutfit(clothing)
end