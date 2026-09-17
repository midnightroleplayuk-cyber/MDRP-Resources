-- ps-dispatch <-> mdt bridge

if GetResourceState('ps-dispatch') ~= 'started' then return end

local MDT_ORIGIN_PREFIX = 'wasabi_mdt:'

if IsDuplicityVersion() then
    -- pull ps-dispatch alerts into MDT
    if ServerConfig and ServerConfig.IngestExternalDispatch then
        Modules.onInit('dispatch', function(dispatchMod)
            RegisterNetEvent('ps-dispatch:server:notify', function(data)
                local src = source
                if type(data) == 'table' and type(data.codeName) == 'string'
                    and data.codeName:sub(1, #MDT_ORIGIN_PREFIX) == MDT_ORIGIN_PREFIX then return end
                if type(data) ~= 'table' then
                    dispatchMod.createExternal('ps-dispatch', src, data)
                    return
                end

                local priority = data.priority
                if type(priority) == 'string' then
                    priority = #priority <= 32 and tonumber(priority) or nil
                end
                if type(priority) == 'number' then
                    priority = priority <= 0 and 5 or priority == 1 and 4 or priority == 2 and 2 or 1
                else
                    priority = nil
                end

                dispatchMod.createExternal('ps-dispatch', src, {
                    type = data.type or data.codeName,
                    title = data.message or data.title,
                    description = data.description or data.information,
                    priority = priority,
                    coords = data.coords,
                    location = data.location or data.street,
                    code = data.code or data.dispatchCode or data.codeName,
                    providerCallId = data.id or data.callId,
                })
            end)
        end)
    end
else
    -- push MDT calls into ps-dispatch HUD
    RegisterNetEvent('wasabi_mdt:client:relayDispatch', function(d)
        if d.externalProvider then return end
        if GetResourceState('ps-dispatch') ~= 'started' then return end

        exports['ps-dispatch']:CustomAlert({
            coords = d.coords and vec3(d.coords.x, d.coords.y, d.coords.z) or nil,
            message = d.title,
            dispatchCode = MDT_ORIGIN_PREFIX .. tostring(d.id or 0),
            code = d.code or ('P' .. tostring(d.priority or 1)),
            information = d.description,
            radius = 0,
            sprite = 161,
            color = (d.priority and d.priority >= 4) and 1 or 3,
            scale = 0.9,
            length = 5,
            sound = 1,
            sound2 = (d.priority and d.priority >= 4) and 1 or nil,
            offset = false,
            flash = (d.priority and d.priority >= 4) or false,
        })
    end)
end
