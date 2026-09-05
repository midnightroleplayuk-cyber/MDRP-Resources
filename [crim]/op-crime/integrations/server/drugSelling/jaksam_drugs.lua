if Config.DrugSelling.DrugScript == "jaksam_drugs" then 
    RegisterNetEvent("drugs_creator:soldToNPC", function(playerId, drugName, drugQuantity, totalDrugPrice)
        local turfId = exports['op-crime']:getPlayerTurfZone(playerId)
        if turfId then 
            TriggerEvent('op-crime:drugSold', playerId, turfId, totalDrugPrice)
        end
    end)
end