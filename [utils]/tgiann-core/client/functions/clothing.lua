local tgiann_clothing    = GetResourceState("tgiann-clothing") ~= "missing"
local rcore_clothing     = GetResourceState("rcore_clothing") ~= "missing"
local illenium_appearance = GetResourceState("illenium-appearance") ~= "missing"

tgiCore.OpenClothingShop = function()
    --local invokingResource = GetInvokingResource()
    if tgiann_clothing then
        exports["tgiann-clothing"]:openMenu({
            allowedMenus = { [0] = false, [1] = true, [2] = false, [3] = false },
            isBerberMenu = false,
        })
    elseif rcore_clothing then
        TriggerEvent('rcore_clothing:openShop', "binco")
    elseif config.framework == "qb" then
        TriggerEvent("qb-clothing:client:openOutfitMenu")
    elseif config.framework == "esx" then
        -- TODO: Implement ESX clothing shop
    end
end

--- Opens the saved-outfit changer of the active clothing system
--- @param stashName string? outfit stash name for clothing-as-item setups (tgiann-clothing)
tgiCore.OpenOutfitChanger = function(stashName)
    if tgiann_clothing then
        exports["tgiann-clothing"]:OpenOutfitChanger(stashName)
    elseif illenium_appearance then
        TriggerEvent("illenium-appearance:client:openOutfitMenu")
    elseif config.framework == "qb" then
        TriggerEvent("qb-clothing:client:openOutfitMenu")
    else
        assert(false, "There is no outfit changer open function in the client for the clothing system you are using!")
    end
end

RegisterNetEvent("tgiann-core:client:openOutfitChanger")
AddEventHandler("tgiann-core:client:openOutfitChanger", tgiCore.OpenOutfitChanger)
