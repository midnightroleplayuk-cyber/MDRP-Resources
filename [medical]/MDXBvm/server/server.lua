local itemName = Config.ItemName or 'bvm'

local function UseBvm(src)
    if not src then return end
    TriggerClientEvent('MDXBvm:Client:UseBvm', src)
end

CreateThread(function()
    if GetResourceState('qbx_core') == 'started' then
        exports.qbx_core:CreateUseableItem(itemName, function(source)
            UseBvm(source)
        end)
    elseif GetResourceState('qb-core') == 'started' then
        local QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.CreateUseableItem(itemName, function(source)
            UseBvm(source)
        end)
    end

    if GetResourceState('ox_inventory') == 'started' then
        pcall(function()
            exports.ox_inventory:registerHook('usingItem', function(payload)
                local name = payload and payload.item and payload.item.name
                if name == itemName then
                    UseBvm(payload.source)
                end
            end)
        end)
    end
end)

exports('useBvm', function(event, item, inventory)
    local src = inventory and inventory.id
    if src then
        UseBvm(src)
    end
end)

RegisterNetEvent('MDXBvm:Server:PlayBvmTargetAnim', function(targetServerId, dict, name)
    local src = source
    local srcPed = GetPlayerPed(src)
    if not srcPed or srcPed == 0 then return end

    local srcCoords = GetEntityCoords(srcPed)
    local srcHeading = GetEntityHeading(srcPed)
    local srcNetId = NetworkGetNetworkIdFromEntity(srcPed)

    TriggerClientEvent('MDXBvm:Client:PlayBvmTargetAnim', targetServerId, dict, name, srcNetId, srcCoords, srcHeading)
end)

RegisterNetEvent('MDXBvm:Server:StopBvmTarget', function(targetServerId)
    TriggerClientEvent('MDXBvm:Client:StopBvmTarget', targetServerId)
end)

RegisterNetEvent('MDXBvm:Server:Ventilate', function(targetServerId)
    local src = source
    targetServerId = tonumber(targetServerId)
    if not targetServerId then return end

    local srcPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetServerId)
    if not srcPed or srcPed == 0 or not targetPed or targetPed == 0 then return end
    if #(GetEntityCoords(srcPed) - GetEntityCoords(targetPed)) > 6.0 then return end

    if GetResourceState('osp_ambulance') == 'started' then
        TriggerClientEvent('osp_ambulance:applyBvmOxygen', targetServerId, Config.OxygenPerSqueeze or 10)
    end
end)
