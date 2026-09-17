-- cd_dispatch <-> mdt bridge

if GetResourceState('cd_dispatch') ~= 'started' then return end

if IsDuplicityVersion() then
    if ServerConfig and ServerConfig.IngestExternalDispatch then
        Modules.onInit('dispatch', function(dispatchMod)
            RegisterNetEvent('cd_dispatch:AddNotification', function(data)
                local src = source
                if type(data) == 'table' and data.wasabi_mdt then return end
                if type(data) ~= 'table' then
                    dispatchMod.createExternal('cd_dispatch', src, data)
                    return
                end

                dispatchMod.createExternal('cd_dispatch', src, {
                    type = data.type,
                    title = data.message or data.title,
                    description = data.description or data.information,
                    priority = data.priority,
                    coords = data.coords,
                    location = data.location or data.street,
                    code = data.code or data.title,
                    providerCallId = data.unique_id or data.id or data.callId,
                })
            end)
        end)
    end
else
    RegisterNetEvent('wasabi_mdt:client:relayDispatch', function(d)
        if d.externalProvider then return end
        if GetResourceState('cd_dispatch') ~= 'started' then return end

        TriggerServerEvent('cd_dispatch:AddNotification', {
            wasabi_mdt = true,
            job_table = { 'police', 'lssd', 'sasp' },
            coords = d.coords and vec3(d.coords.x, d.coords.y, d.coords.z) or GetEntityCoords(cache.ped),
            title = d.code or ('P' .. tostring(d.priority or 1)),
            message = d.title,
            flash = (d.priority and d.priority >= 4) and 1 or 0,
            blip = {
                sprite = 161,
                scale = 0.9,
                colour = (d.priority and d.priority >= 4) and 1 or 3,
                flashes = false,
                text = d.title,
                time = 5,
                radius = 0,
            },
        })
    end)
end
