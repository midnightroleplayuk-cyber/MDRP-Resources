local function SaveRadioPrefs()
    if not Radio.identifier or not Radio.userData[Radio.identifier] then return end
    local data = Radio.userData[Radio.identifier]
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    SetResourceKvp(('mm_radio_prefs_%s'):format(Radio.identifier), json.encode({
        name = data.name, overlay = data.playerlist.show,
        opacity = data.overlayOpacity or 41, volume = data.volume or Radio.Volume,
        overlayCoords = data.playerlist and data.playerlist.coords or nil
    }))
end

function Radio:SendSvelteMessage(name, data)
    if not Shared.Ready then return end
    SendNUIMessage({
        action = name,
        data = data
    })
end

RegisterNUICallback('join', function(data, cb)
    local rchannel = tonumber(data)
    JoinRadio(rchannel)
    cb("ok")
end)


RegisterNUICallback('joinSecondary', function(data, cb)
    local channel = tonumber(type(data) == 'table' and data.channel or data)
    local ok = channel and Radio:SetSecondaryRadio(channel) or false
    cb(ok and 'ok' or 'error')
end)

RegisterNUICallback('leaveSecondary', function(_, cb)
    Radio:LeaveSecondaryRadio(false)
    cb('ok')
end)

RegisterNUICallback('leave', function(_, cb)
    if Radio.RadioChannel ~= 0 then
        Radio:leaveradio()
    end
    cb("ok")
end)

RegisterNUICallback('toggleMute', function(volume, cb)
    volume = tonumber(volume)
    Radio:Notify(locale(volume == 0 and 'toggle_defean' or 'toggle_undeafen'))
	exports["pma-voice"]:setRadioVolume(volume)
    -- One shared slider controls both Primary and Secondary radio voice volume.
    pcall(function() exports["pma-voice"]:resyncSecondaryRadioVolume() end)
    Radio.Volume = volume
    Radio.userData[Radio.identifier].volume = volume
    SaveRadioPrefs()
    cb('ok')
end)

RegisterNUICallback("volumeChange", function(data, cb)
    data = tonumber(data)
    Radio:Notify(locale('volume_notify_description', data))
	exports["pma-voice"]:setRadioVolume(data)
    -- Re-apply the new shared radio volume to anyone already talking on Secondary.
    pcall(function() exports["pma-voice"]:resyncSecondaryRadioVolume() end)
    Radio.Volume = data
    Radio.userData[Radio.identifier].volume = data
    SaveRadioPrefs()
    cb('ok')
end)

RegisterNUICallback("hideUI", function(_, cb)
    TriggerEvent('mm_radio:client:remove')
    cb('ok')
end)

RegisterNUICallback('addFav', function(data, cb)
    data = tonumber(data)
    if Radio.RadioChannel == data then
        Radio.favourite[#Radio.favourite+1] = data
        Radio.userData[Radio.identifier].favourite[#Radio.userData[Radio.identifier].favourite+1] = data
        SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    end
    cb("ok")
end)

RegisterNUICallback('removeFav', function(data, cb)
    data = tonumber(data)
    if Radio.RadioChannel == data then
        for index, val in ipairs(Radio.favourite) do
            if val == data then
                table.remove(Radio.favourite, index)
            end
        end
        for index, val in ipairs(Radio.userData[Radio.identifier].favourite) do
            if val == data then
                table.remove(Radio.userData[Radio.identifier].favourite, index)
            end
        end
        SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    end
    cb("ok")
end)

RegisterNUICallback('showPlayerList', function(data, cb)
    Radio.userData[Radio.identifier].playerlist.show = data
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    -- Keep the custom dual-channel roster tied to the stock overlay setting.
    Radio:SendSvelteMessage('overlayVisibilityChanged', { show = data == true })
    SaveRadioPrefs()
    cb("ok")
end)

RegisterNUICallback('updatePlayerListPosition', function(data, cb)
    local coords = {
        x = tonumber(data.x) or 0,
        y = tonumber(data.y) or 0
    }
    if not Radio.identifier or not Radio.userData[Radio.identifier] then
        cb('error')
        return
    end
    Radio.userData[Radio.identifier].playerlist.coords = coords
    -- Save the most recent position to every persistent preferences store.
    -- Otherwise a later settings refresh can restore an older copy.
    SaveRadioPrefs()
    -- Separate per-character backup makes the dragged position durable across
    -- /logout, reconnects, client restarts and later sessions.
    SetResourceKvp(('mm_radio_overlay_pos_%s'):format(Radio.identifier), json.encode(coords))
    local ok, saved = pcall(function()
        return lib.callback.await('midnight_radio:server:storeOverlayPosition', false, coords)
    end)
    if not ok or saved ~= true then
        print('[midnight_radio] WARNING: overlay position was NOT confirmed saved on server')
        cb('error')
        return
    end
    print(('[midnight_radio] Overlay position confirmed saved x=%.1f y=%.1f'):format(coords.x, coords.y))
    cb('ok')
end)

RegisterNUICallback('updateRadioPosition', function(data, cb)
    Radio.userData[Radio.identifier].radio.coords = data
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    cb("ok")
end)

RegisterNUICallback('allowMovement', function(data, cb)
    Radio.userData[Radio.identifier].allowMovement = data
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    if data then
        SetNuiFocusKeepInput(true)
        DisableControls()
    else
        SetNuiFocusKeepInput(false)
    end
    cb("ok")
end)

RegisterNUICallback('enableClicks', function(data, cb)
    Radio.userData[Radio.identifier].enableClicks = data
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    exports['pma-voice']:setVoiceProperty('micClicks', data)
    cb("ok")
end)

RegisterNUICallback('updateRadioSize', function(data, cb)
    Radio.userData[Radio.identifier].radioSizeMultiplier = tonumber(data.radio) or Radio.userData[Radio.identifier].radioSizeMultiplier
    local overlay = tonumber(data.overlay) or Radio.userData[Radio.identifier].overlaySizeMultiplier or 100
    Radio.userData[Radio.identifier].overlaySizeMultiplier = math.max(75, math.min(150, overlay))
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    cb("ok")
end)

RegisterNUICallback('saveData', function(data, cb)
    local identifier = Radio.identifier
    local settings = identifier and Radio.userData[identifier]
    if not settings then
        cb('error')
        return
    end

    local name = type(data) == 'table' and data.name or nil
    if type(name) ~= 'string' then
        cb('error')
        return
    end
    name = name:match('^%s*(.-)%s*$')
    if name == '' then
        cb('error')
        return
    end

    settings.name = name
    -- Save both the main KVP and per-character backup immediately.
    SaveRadioPrefs()
    Radio:update()
    if Radio.RadioChannel and Radio.RadioChannel > 0 then
        TriggerServerEvent('mm_radio:server:addToRadioChannel', Radio.RadioChannel, name)
    end
    TriggerServerEvent('mm_radio:server:updateSecondaryName', name)
    cb('ok')
end)

RegisterNUICallback('getMutedList', function(_, cb)
    cb(exports['pma-voice']:getMutedPlayers())
end)

RegisterNUICallback('togglemutePlayer', function(data, cb)
    if data == cache.serverId then
        Radio:Notify(locale('failed_mute'))
        return cb(nil)
    end
    exports['pma-voice']:toggleMutePlayer(data)
    Wait(100)
    print(json.encode(exports['pma-voice']:getMutedPlayers()))
    cb(exports['pma-voice']:getMutedPlayers())
end)
RegisterNUICallback('setOverlayOpacity', function(data, cb)
    local value = math.max(20, math.min(100, tonumber(data) or 100))
    Radio.userData[Radio.identifier].overlayOpacity = value
    SaveRadioPrefs()
    cb('ok')
end)
