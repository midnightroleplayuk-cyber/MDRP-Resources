local locations, NPC, closeToNPC, inZone = nil, nil, nil, false
local point = nil

lib.registerContext({
    id = 'warehouse_menu',
    title = Lang['title'],
    options = {
        {
            title = Lang['option_title'],
            description = Lang['option_description'],
            onSelect = function()
                local paid = lib.callback.await('av_warehouse:pay', false)
                if paid then
                    getMission()
                end
            end,
        },
    }
})

CreateThread(function()
    if not Config.UseNPC then return end
    while not locations do Wait(1000) end
    while true do
        if locations and next(locations) then
            inZone = false
            local myCoords = GetEntityCoords(cache.ped)
            for _, v in pairs(locations) do
                local npcCoords = #(myCoords - vector3(v['x'], v['y'], v['z']))
                if npcCoords < 50 then
                    inZone = true
                    if not NPC then
                        local loaded = loadModel(v['model'])
                        if loaded then
                            NPC = CreatePed(3, loaded, v['x'], v['y'], v['z'], v['heading'], false, false)
                            SetEntityInvincible(NPC, true)
                            SetBlockingOfNonTemporaryEvents(NPC, true)
                            local options = {
                                {
                                    name = "warehouse_npc",
                                    num = 1,
                                    type = "client",
                                    icon = "fas fa-comment",
                                    label = Lang['talk_npc'],
                                    canInteract = function()
                                        return not isCop()
                                    end,
                                    onSelect = function()
                                        lib.showContext('warehouse_menu')
                                    end,
                                    action = function()
                                        lib.showContext('warehouse_menu')
                                    end,
                                    distance = 2
                                }
                            }
                            if Config.Target then
                                if Config.Target == "ox_target" then
                                    exports[Config.Target]:addLocalEntity(NPC, options)
                                else
                                    exports[Config.Target]:AddTargetEntity(NPC, {
                                        options = options,
                                        distance = 2.5
                                    })
                                end
                            else
                                if not point and not isCop() then
                                    point = lib.points.new({
                                        coords = vector3(v['x'], v['y'], v['z']),
                                        distance = 1.5,
                                    })
                                    function point:onEnter()
                                        if not isOpen() then
                                            showText("[E] "..Lang['talk_npc'])
                                        end
                                    end
                                    function point:nearby()
                                        if IsControlJustPressed(0,38) and not getBusy() then
                                            setBusy(true)
                                            lib.showContext('warehouse_menu')
                                            setBusy(false)
                                        end
                                    end
                                    function point:onExit()
                                        if isOpen() then
                                            closeText()
                                        end
                                    end
                                end
                            end
                            SetModelAsNoLongerNeeded(v['model'])
                        end
                    end
                end
                if inZone and not closeToNPC then
                    closeToNPC = true
                end
            end
            if not inZone and closeToNPC then
                closeToNPC = false
                if NPC then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(NPC, i, false)
                    end
                    SetEntityAsNoLongerNeeded(NPC)
                    if Config.Target then
                        if Config.Target == "ox_target" then
                            exports[Config.Target]:removeLocalEntity(NPC, "warehouse_npc")
                        else
                            exports[Config.Target]:RemoveTargetEntity(NPC, "warehouse_npc")
                        end
                    else
                        if point then
                            point:remove()
                            point = nil
                        end
                    end
                    DeletePed(NPC)
                    NPC = nil
                end
            end
        end
        Wait(2000)
    end
end)

function setLocations(data)
    locations = data
end