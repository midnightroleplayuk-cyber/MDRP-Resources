local whitelistedStateBags <const> = {
    ['heliCamMarkers'] = true,
    ['heliCamTargetBlip'] = true,
    ['heliCamInUse'] = true
}

local helicopters = {}
GlobalState.heliSpotlightsActive = 0

RegisterServerEvent('helicam:enterCamera', function(heliNetId)
    local helicopter = Entity(NetworkGetEntityFromNetworkId(heliNetId))
    if helicopter and not helicopter.state.heliCamInUse then
        helicopter.state.heliCamInUse = true
        helicopter.state.heliCamTargetBlip = false
        helicopter.state.heliCamSpotlightData = nil
        if not helicopter.state.heliCamMarkers then
            helicopter.state.heliCamMarkers = {}
        end
        helicopters[source] = heliNetId
        TriggerClientEvent('helicam:enterCamera', source, true)
    else
        TriggerClientEvent('helicam:enterCamera', source, false)
    end
end)

RegisterServerEvent('helicam:leaveCamera', function(heliNetId)
    local helicopter = Entity(NetworkGetEntityFromNetworkId(heliNetId))
    helicopter.state.heliCamInUse = false
    helicopter.state.heliCamTargetBlip = nil
    if source ~= nil and source ~= "" then
        helicopters[source] = nil
    end
end)

RegisterServerEvent('helicam:setStateBag', function(heliNetId, bagName, value)
    -- This prevents cheaters from using this event to set other state bags than the onces intended to be used in this script
    if not whitelistedStateBags[bagName] then
        return
    end

    local helicopter = Entity(NetworkGetEntityFromNetworkId(heliNetId))
    helicopter.state[bagName] = value
end)

RegisterServerEvent('helicam:toggleSpotlight', function(state)
    if state then
        GlobalState.heliSpotlightsActive += 1
    else
        GlobalState.heliSpotlightsActive -= 1
    end
end)

-- If a player crashes/leaves while in the camera
AddEventHandler('playerDropped', function(_reason)
    if helicopters[source] then
        TriggerEvent('helicam:leaveCamera', helicopters[source])
        Player(source).state.heliCamSpotlightData = { position = false, helicopter = helicopters[source] }
        helicopters[source] = nil
    end
end)
