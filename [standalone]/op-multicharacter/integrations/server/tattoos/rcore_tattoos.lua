if Config.Tattoos ~= "rcore_tattoos" then return end

function getTattoos(identifier)
    local timeoutMs = 3000
    local p = promise.new()
    local finished = false

    TriggerEvent('rcore_tattoos:getPlayerTattoosByIdentifier', identifier, function(tattoos)
        if finished then return end
        finished = true

        tattoos = tattoos or {}
        debugPrint(('[getTattoos] Callback fired for %s, got data: %s'):format(
            tostring(identifier),
            json.encode(tattoos)
        ))

        p:resolve(tattoos)
    end)

    CreateThread(function()
        local start = GetGameTimer()
        while not finished and (GetGameTimer() - start) < timeoutMs do
            Wait(50)
        end

        if not finished then
            finished = true
            debugPrint(('[getTattoos / warning] ^3Timeout after %dms for %s â€“ returning empty table^0'):
                format(timeoutMs, tostring(identifier)))
            p:resolve({})
        end
    end)

    local tattoos = Citizen.Await(p)
    if type(tattoos) ~= 'table' then
        tattoos = {}
    end

    return tattoos
end
