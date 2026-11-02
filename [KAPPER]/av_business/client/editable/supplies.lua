local NPC = nil
local blip = nil
local temp_point = nil
local busy = false

CreateThread(function()
    local closeToNPC = false
    while true do
        local inZone = false
        if Config.SuppliesLocations and next(Config.SuppliesLocations) then
            local myCoords = GetEntityCoords(cache.ped)
            for _, v in pairs(Config.SuppliesLocations) do
                local npcCoords = #(myCoords - vector3(v['x'], v['y'], v['z']))
                if npcCoords < 50 then
                    inZone = true
                    if not NPC then
                        lib.requestModel(v['model'], 30000)
                        NPC = CreatePed(3, v['model'], v['x'], v['y'], v['z'], v['heading'], false, false)
                        SetEntityInvincible(NPC, true)
                        SetBlockingOfNonTemporaryEvents(NPC, true)
                        SetPedCanRagdoll(NPC, false)
                        FreezeEntityPosition(NPC, true)
                        if Config.ZonesTarget then
                            local options = {
                                {
                                    name = "supplies",
                                    num = 1,
                                    type = "client",
                                    event = "av_business:supplies",
                                    icon = "fas fa-comment",
                                    label = Lang['supplies_npc'],
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
                            end
                        end
                    end
                end
                if inZone and not closeToNPC then
                    closeToNPC = true
                    if temp_point then temp_point:remove() end
                    temp_point = nil
                    if not temp_point then
                        temp_point = lib.points.new({
                            coords = vector3(v['x'], v['y'], v['z']),
                            distance = 3,
                        })
                        function temp_point:onEnter()
                            dbug("onEnter() supplies zone")
                            if not Config.Target or not Config.ZonesTarget then
                                if not exports['av_laptop']:isTextUIOpen() then
                                    exports['av_laptop']:showTextUI(Lang['supplies_key'] or "[E] Supplies")
                                end
                            end
                        end
                        function temp_point:nearby()
                            if self.currentDistance <= self.distance then
                                if IsControlJustPressed(0,(Config.supplies_key or 38)) and not busy then
                                    busy = true
                                    TriggerEvent("av_business:supplies")
                                    lib.timer(1000, function()
                                        busy = false
                                    end,true)
                                end
                            end
                        end
                        function temp_point:onExit()
                            if exports['av_laptop']:isTextUIOpen() then
                                exports['av_laptop']:hideTextUI()
                            end
                        end
                    end
                end
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
                if Config.Target == "ox_target" then
                    exports[Config.Target]:removeLocalEntity(NPC, "supplies")
                else
                    exports[Config.Target]:RemoveTargetEntity(NPC, "supplies")
                end
                DeletePed(NPC)
                NPC = nil
            end
            if temp_point then temp_point:remove() temp_point = nil end
        end
        Wait(1000)
    end
end)

RegisterNetEvent('av_business:supplies', function()
    local permissions = getPermissions()
    if permissions['isBoss'] or permissions['supplies'] then
        removeBlip()
        local data = Config.SuppliesStash
        local myJob = exports['av_laptop']:getJob()
        local stashName = data['prefix']..myJob.name
        local label = data['label']
        local weight = data['weight']
        local slots = data['slots']
        dbug('supplies(stash,label,weight,slots)', stashName, label, weight, slots)
        if stashName and label then
            exports['av_laptop']:openStash(stashName, label, weight, slots)
        end
    else
        TriggerEvent('av_laptop:notification', Lang['app_title'], Lang['missing_permissions'], 'error')
    end
end)

function addBlip(x,y,z)
    blip = AddBlipForCoord(x,y,z)
    SetBlipSprite(blip, Config.SuppliesBlip['sprite'])
    SetBlipScale(blip, 0.7)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, Config.SuppliesBlip['color'])
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.SuppliesBlip['label'])
    EndTextCommandSetBlipName(blip)
end

function removeBlip()
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
        blip = nil
    end
end