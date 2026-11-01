local ShopNPC = nil
CreateThread(function()
    while not Config.Target do
        Config.Target = exports['av_laptop']:getTarget()
        dbug('Config.Target', Config.Target)
        Wait(50) 
    end
    local closeToNPC = false
    while true do
        local inZone = false
        local playerCoords = GetEntityCoords(PlayerPedId())
        for i=1, #Config.NPC do
            local npcCoords = #(playerCoords - vector3(Config.NPC[i]['coords'][1],Config.NPC[i]['coords'][2], Config.NPC[i]['coords'][3]))
            if npcCoords < 50 then
                inZone = true
                if not ShopNPC then
                    ShopNPC = SpawnPed(Config.NPC[i]['model'],Config.NPC[i]['coords'])
                    local options = {
                        {
                            num = 1,
                            type = "client",
                            event = "av_gangs:shop",
                            icon = "fas fa-comment",
                            label = Lang['talk_npc'],
                            distance = 2
                        }
                    }
                    if Config.Target == "ox_target" then
                        exports[Config.Target]:addLocalEntity(ShopNPC, options)
                    else
                        exports[Config.Target]:AddTargetEntity(ShopNPC, {
                            options = options,
                            distance = 2.5
                        })
                    end
                end
            end
            if inZone and not closeToNPC then
                closeToNPC = true
            end
        end
        if not inZone and closeToNPC then
            closeToNPC = false
            if ShopNPC then
                for i = 255, 0, -51 do
                    Wait(50)
                    SetEntityAlpha(ShopNPC, i, false)
                end
                SetEntityAsNoLongerNeeded(ShopNPC)
                if Config.Target == "ox_target" then
                    exports[Config.Target]:removeLocalEntity(ShopNPC, "gangShop")
                else
                    exports[Config.Target]:RemoveTargetEntity(ShopNPC, Lang['talk_npc'])
                end
                DeletePed(ShopNPC)
                ShopNPC = nil
            end
        end
        Wait(1000)
    end
end)

function SpawnPed(model,coords)
    lib.requestModel(model, 30000)
    spawnedPed = CreatePed(4, model, coords[1], coords[2], coords[3], coords[4], false, true)
    SetEntityAlpha(spawnedPed, 0, false)
    FreezeEntityPosition(spawnedPed, true)
    SetEntityInvincible(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    for i = 0, 255, 51 do
        Wait(50)
        SetEntityAlpha(spawnedPed, i, false)
    end
    SetModelAsNoLongerNeeded(model)
    return spawnedPed
end

RegisterNetEvent('av_gangs:shop', function()
    if PlayerGang then
        local prices = lib.callback.await('av_gangs:getPrices', false, PlayerGang.name)
        if prices then
            exports['av_laptop']:registerContext({
                id = 'spray_menu',
                title = Lang['gang_shop'],
                options = {
                    {
                        title = Lang['buy_spray']..' | $'..prices['spray'],
                        serverEvent = 'av_gangs:buyItem',
                        args = {gang = PlayerGang.name, item = Config.ItemNames['spray'], price = prices['spray']}
                    },
                    {
                        title = Lang['buy_remover']..' | $'..prices['remover'],
                        serverEvent = 'av_gangs:buyItem',
                        args = {gang = PlayerGang.name, item = Config.ItemNames['remover'], price = prices['remover']}
                    },
                }
            })
            exports['av_laptop']:showContext('spray_menu')
        end
    else
        TriggerEvent('av_laptop:notification', nil, Lang['shop_civ'], 'error')
    end
end)