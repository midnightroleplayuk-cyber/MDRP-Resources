function EnsureTarget()
    if (Config.target.enabled and Config.target.system) then

        local system = Config.target.system
        
        local options = {
            {
                type = 'client',
                event = 'kq_outfitbag2:targetOpen',
                icon = "fas fa-suitcase",
                label = L('Open bag'),
                canInteract = function(entity)
                    return IsEntityOutfitBag(entity) and (IsPublic(entity) or OwnsBag(entity)) and CorrectBagJob(entity)
                end,
                distance = 2,
            },
            {
                type = 'client',
                event = 'kq_outfitbag2:targetPickup',
                icon = 'fas fa-arrow-up',
                label = L('Pickup bag'),
                canInteract = function(entity)
                    return IsEntityOutfitBag(entity) and OwnsBag(entity)
                end,
                distance = 2,
            },
        }

        if system == 'ox_target' then
            exports[system]:addModel({GetHashKey(Config.bagObject)}, options)
        else
            exports[system]:AddTargetModel({GetHashKey(Config.bagObject)}, {
                options = options,
                distance = 2,
            })
        end
    end
end

RegisterNetEvent('kq_outfitbag2:targetOpen', function(data)
    OpenBag(data.entity)
end)

RegisterNetEvent('kq_outfitbag2:targetPickup', function(data)
    PickupBag(data.entity)
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    EnsureTarget()
end)
