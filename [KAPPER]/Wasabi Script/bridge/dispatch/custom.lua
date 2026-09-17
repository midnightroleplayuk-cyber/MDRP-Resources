-- Custom dispatch <-> MDT template.
-- Replace the resource/event names and map the payload fields for your dispatch script.

local RESOURCE = 'your_dispatch'
local INBOUND_EVENT = 'your_dispatch:server:notify'
local OUTBOUND_EVENT = 'your_dispatch:server:notify'

if GetResourceState(RESOURCE) ~= 'started' then return end

if IsDuplicityVersion() then
    -- Pull custom dispatch alerts into MDT.
    if ServerConfig and ServerConfig.IngestExternalDispatch then
        Modules.onInit('dispatch', function(dispatch)
            RegisterNetEvent(INBOUND_EVENT, function(data)
                local src = source
                if type(data) == 'table' and data.wasabi_mdt then return end
                if type(data) ~= 'table' then
                    dispatch.createExternal(RESOURCE, src, data)
                    return
                end

                dispatch.createExternal(RESOURCE, src, {
                    type = data.type,
                    title = data.message or data.title,
                    description = data.description or data.information,
                    priority = data.priority, -- MDT uses 1 (lowest) to 5 (highest).
                    coords = data.coords,
                    location = data.location or data.street,
                    code = data.code,
                    providerCallId = data.id or data.callId or data.unique_id,
                })
            end)
        end)
    end
else
    -- Push native MDT calls into the custom dispatch script.
    RegisterNetEvent('wasabi_mdt:client:relayDispatch', function(call)
        if call.externalProvider then return end
        if GetResourceState(RESOURCE) ~= 'started' then return end

        -- Replace this event and payload with the API expected by your dispatch script.
        TriggerServerEvent(OUTBOUND_EVENT, {
            wasabi_mdt = true,
            type = call.type,
            title = call.title,
            description = call.description,
            priority = call.priority,
            coords = call.coords,
            location = call.location,
            code = call.code,
            id = call.id,
        })
    end)
end
