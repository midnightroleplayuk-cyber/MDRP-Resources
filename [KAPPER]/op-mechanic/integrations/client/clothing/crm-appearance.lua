--------------------------------------------
-- FUNCTIONS TO SET/GET PLAYERS CLOTHES ----
--------------------------------------------

if Config.Clothing.clothingScript ~= 'crm-appearance' then return end

function getPlayerClothes(cb)
    cb(exports['crm-appearance']:crm_get_ped_clothing(PlayerPedId()))
end

function setPlayerClothes(clothing)
    exports['crm-appearance']:crm_set_ped_clothing(PlayerPedId(), clothing)
end