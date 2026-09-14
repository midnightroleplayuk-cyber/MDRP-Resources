if IsDuplicityVersion() then
    -- Server side
    local callbacks = {}

    function RegisterCallback(name, cb)
        callbacks[name] = cb
    end

    RegisterNetEvent('plt_mdt:server:triggerCallback', function(name, id, ...)
        local src = source
        if callbacks[name] then
            callbacks[name](src, function(...)
                TriggerClientEvent('plt_mdt:client:receiveCallback', src, id, ...)
            end, ...)
        end
    end)
else
    -- Client side
    local callbacks = {}
    local currentId = 0

    function TriggerCallback(name, cb, ...)
        local id = currentId
        currentId = currentId + 1
        callbacks[id] = cb
        TriggerServerEvent('plt_mdt:server:triggerCallback', name, id, ...)
    end

    RegisterNetEvent('plt_mdt:client:receiveCallback', function(id, ...)
        if callbacks[id] then
            callbacks[id](...)
            callbacks[id] = nil
        end
    end)
end
