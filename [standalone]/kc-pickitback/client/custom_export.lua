-- /!\ /!\ /!\ /!\ /!\ BE SURE TO SET 'InteractionType' IN THE CONFIG.LUA FILE TO "custom" /!\ /!\ /!\ /!\ /!\

-- Here's an example with 'ox_target'
--[[ exports[Config.TargetName]:addModel({
        'physics_hat',
        'physics_hat2',
        'physics_glasses'
    },
    {
        {
            name = 'PickUp',
            event = 'kc-pickitback:PickUp',
            icon = Config.Icon,
            label = Config.TargetText,
            distance = Config.PickUpDistance,
            canInteract = function(entity, distance, coords, type)
                if not Entity(entity).state.Params then return end
                if Config.PreventIfAlreadyEquipped and GetPedPropIndex(PlayerPedId(), Entity(entity).state.Params[3]) ~= -1 then return end
                if Config.PreventItemPickupByGender then
                    return GetPedGender(PlayerPedId()) == Entity(entity).state.Params[4]
                else
                    return true
                end
            end
        }
    })  ]]

-- /!\ /!\ /!\ /!\ /!\ BE SURE TO SET 'InteractionType' IN THE CONFIG.LUA FILE TO "custom" /!\ /!\ /!\ /!\ /!\

-- The prop will have a state bag called 'Params' (https://docs.fivem.net/docs/scripting-manual/networking/state-bags/)
-- The first and second entries of 'Params' are not important for this matter
-- The third entry of 'Params' indicates whether it's a hat (0) or glasses (1)
-- The fourth entry of 'Params' is the gender, either 0 (female) or 1 (male)
-- You need to trigger the event 'kc-pickitback:PickUp' with the said entity, and the script should handle the rest

-- /!\ /!\ /!\ /!\ /!\ BE SURE TO SET 'InteractionType' IN THE CONFIG.LUA FILE TO "custom" /!\ /!\ /!\ /!\ /!\