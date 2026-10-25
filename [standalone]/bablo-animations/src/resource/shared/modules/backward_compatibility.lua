local function createExport(resourceName, exportName, cb)
    AddEventHandler(('__cfx_export_%s_%s'):format(resourceName, exportName), function(setCB)
        setCB(cb)
    end)
end

Citizen.CreateThread(function()
    if not IsDuplicityVersion() then
        -- rpemotes-reborn
        createExport("rpemotes-reborn", "EmoteCommandStart", function(emoteName, _)
            exports["bablo-animations"]:playAnimation(PlayerPedId(), emoteName)
        end)

        createExport("rpemotes-reborn", "EmoteCancel", function()
            exports["bablo-animations"]:cancelAnimation()
        end)

        createExport("rpemotes-reborn", "IsPlayerInAnim", function()
            return GetLocalStateBag('isInAnimation')
        end)

        createExport("rpemotes-reborn", "getCurrentEmote", function()
            return GetLocalStateBag('isInAnimation')
        end)

        -- rpemotes
        createExport("rpemotes", "EmoteCommandStart", function(emoteName, _)
            exports["bablo-animations"]:playAnimation(PlayerPedId(), emoteName)
        end)

        createExport("rpemotes", "EmoteCancel", function()
            exports["bablo-animations"]:cancelAnimation()
        end)

        createExport("rpemotes", "IsPlayerInAnim", function()
            return GetLocalStateBag('isInAnimation')
        end)

        createExport("rpemotes", "getCurrentEmote", function()
            return GetLocalStateBag('isInAnimation')
        end)

        -- dpemotes
        RegisterNetEvent('animations:client:EmoteCommandStart', function(args)
            local emoteName = nil

            if type(args) == 'table' then
                emoteName = args[1]
            else
                emoteName = args
            end

            if emoteName then
                exports["bablo-animations"]:playAnimation(PlayerPedId(), emoteName)
            end
        end)
    end
end)
