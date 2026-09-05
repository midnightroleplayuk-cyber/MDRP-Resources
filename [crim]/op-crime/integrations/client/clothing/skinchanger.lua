--------------------------------------------
-- FUNCTIONS TO SET/GET PLAYERS CLOTHES ----
--------------------------------------------

if Config.Clothing.clothingScript ~= "skinchanger" then return end

function getPlayerClothes(cb)
        TriggerEvent('skinchanger:getSkin', function(skin)
            local filtered = filterClothingParts(skin)
            cb(filtered)
        end)
end

function setPlayerClothes(clothing)
    TriggerEvent('skinchanger:getSkin', function(currentSkin)
        for k,v in pairs(clothing) do currentSkin[k] = v end
        TriggerEvent('skinchanger:loadClothes', currentSkin)
    end)
end

function filterClothingParts(skin)
    local clothing = {}
    local clothingKeys = {
        "tshirt_1", "tshirt_2",
        "torso_1", "torso_2",
        "arms", "arms_2",
        "pants_1", "pants_2",
        "shoes_1", "shoes_2",
        "decals_1", "decals_2",
        "mask_1", "mask_2",
        "bproof_1", "bproof_2",
        "chain_1", "chain_2",
        "bags_1", "bags_2",
        "helmet_1", "helmet_2",
        "glasses_1", "glasses_2"
    }
    for _, key in pairs(clothingKeys) do
        if skin[key] then clothing[key] = skin[key] end
    end
    return clothing
end