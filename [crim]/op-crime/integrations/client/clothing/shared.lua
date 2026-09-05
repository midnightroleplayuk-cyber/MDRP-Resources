---------------------------------------------------------------
-- OPEN MENU FUNCTION / this is called when user press 'e' ----
---------------------------------------------------------------

function openCloakRoom(orgId)
    if playerOrganisationData.isInOrg then
        if playerOrganisationData.jobId then
            if orgId then
                if playerOrganisationData.jobId ~= orgId then
                return print('not yours organization.')
                end
            end
            
            if Config.Clothing.clothingScript == "tgiann_clothing" then 
                TriggerEvent("tgiann-clothing:openOutfitStash", "organisationClothes")
            else
                openOXClothing()
            end
        end
    end
end

--------------------------------------------------
-- COMMAND TO PRINT YOUR CURRENT OUTFIT IN F8 ----
--------------------------------------------------

RegisterCommand('getMyOutfit', function()
    getPlayerClothes(function(outfit)
        print(json.encode(outfit))
    end)
end)