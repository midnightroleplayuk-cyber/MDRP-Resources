local spawnedNPCs = {}
CreateThread(function()
    while true do
        local myCoords = GetEntityCoords(cache.ped)
        for business, npcs in pairs(Config.CounterNPC) do
            local isActive = GlobalState[business .. "_counter"]
            for i, data in ipairs(npcs) do
                local key = business .. "_" .. i
                local npcCoords = vector3(data.coords.x, data.coords.y, data.coords.z)
                local dist = #(myCoords - npcCoords)
                if isActive and dist <= 70.0 then
                    if not spawnedNPCs[key] then
                        RequestModel(data.model)
                        while not HasModelLoaded(data.model) do Wait(50) end
                        local ped = CreatePed(4, data.model, data.coords.x, data.coords.y, data.coords.z, data.coords.w, false, true)
                        SetEntityInvincible(ped, true)
                        SetBlockingOfNonTemporaryEvents(ped, true)
                        SetPedCanRagdoll(ped, false)
                        FreezeEntityPosition(ped, true)
                        SetModelAsNoLongerNeeded(data.model)
                        spawnedNPCs[key] = ped
                        dbug("CounterNPC spawned", data.model, "for", business)
                    end
                else
                    if spawnedNPCs[key] then
                        DeleteEntity(spawnedNPCs[key])
                        spawnedNPCs[key] = nil
                        dbug("CounterNPC removed for", business)
                    end
                end
            end
        end
        Wait(1000)
    end
end)

RegisterNetEvent("av_business:counterStash", function(data)
    dbug("counterStash()")
    local permissions = getPermissions()
    if permissions['isBoss'] or permissions['counter'] then
        local label = Config.CounterStashLabel or "Counter Stash"
        local job = data['zoneJob']
        local name = job.."_counter"
        exports['av_laptop']:openStash(name, label, Config.CounterStashWeight or 10000, Config.CounterStashSlots or 25)
    else
        TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['missing_permissions'], "error")
    end
end)