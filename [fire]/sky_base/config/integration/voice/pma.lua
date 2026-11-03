if Sky.Config.voice ~= "pma" then return end

local RESOURCE = "pma-voice"
local volume = 1.0
local playback_supported

local function supports_playback()
    if IsDuplicityVersion() then return false end
    if playback_supported == nil then
        if GetResourceState(RESOURCE) ~= "started" then return false end
        -- Older pma forks expose no mute getter. Never replace their private
        -- receive volume and accidentally undo a user's /muteply choice.
        playback_supported = pcall(function() exports[RESOURCE]:isPlayerMuted(0) end)
    end
    return playback_supported
end

local function channel_number(channel_id)
    local numeric_channel = tonumber(channel_id)
    if numeric_channel and numeric_channel > 0 then
        return math.floor(numeric_channel)
    end
    return (math.abs(joaat(tostring(channel_id))) % 999999) + 1
end

if IsDuplicityVersion() then
    function Sky.Voice.SetRadio(source, channel_id)
        exports[RESOURCE]:setPlayerRadio(source, channel_number(channel_id))
        return true
    end

    function Sky.Voice.RemoveRadio(source)
        exports[RESOURCE]:setPlayerRadio(source, 0)
        return true
    end

    function Sky.Voice.GetPlayersInChannel(channel_id)
        local channel = channel_number(channel_id)
        local players = {}
        for _, source in ipairs(GetPlayers()) do
            source = tonumber(source)
            if Player(source).state.radioChannel == channel then
                players[#players + 1] = source
            end
        end
        return players
    end
else
    local assigned_volumes, announcement_sources, radio_senders = {}, {}, {}

    local function routed_volume(player_source, announcement_volume)
        if exports[RESOURCE]:isPlayerMuted(player_source) then return 0.0 end
        local local_state, remote_state = LocalPlayer.state, Player(player_source).state
        local call = tonumber(local_state.callChannel) or 0
        if call > 0 and call == tonumber(remote_state.callChannel) then
            return exports[RESOURCE]:getCallVolume() / 100.0
        end
        local radio = tonumber(local_state.radioChannel) or 0
        if radio_senders[player_source] and radio > 0 and radio == tonumber(remote_state.radioChannel) then
            return exports[RESOURCE]:getRadioVolume() / 100.0
        end
        return announcement_volume
    end

    function Sky.Voice._ApplyAnnouncementVolume(player_source, announcement_volume)
        if GetResourceState(RESOURCE) ~= "started" or not MumbleIsConnected() then return false, "provider_unavailable" end
        if not supports_playback() then return false, "unsupported_provider_api" end
        local ok, provider_error = pcall(function()
            local desired = routed_volume(player_source, announcement_volume)
            local player = GetPlayerFromServerId(player_source)
            local channel = MumbleGetVoiceChannelFromServerId(player_source)
            local talking = player ~= -1 and MumbleIsPlayerTalking(player)
            local now, current = GetGameTimer(), assigned_volumes[player_source]
            -- Cfx only updates an existing audio sink; an early write is not
            -- queued. Reapply on route/speech changes and once per active second.
            if not current or current.volume ~= desired or current.player ~= player
                or current.channel ~= channel or current.talking ~= talking or now - current.at >= 1000 then
                MumbleSetVolumeOverrideByServerId(player_source, desired)
                assigned_volumes[player_source] = { volume = desired, player = player, channel = channel, talking = talking, at = now }
            end
            announcement_sources[player_source] = announcement_volume
        end)
        if not ok then
            Sky.Debug("error", "[sky_base][voice] pma announcement receive volume failed: " .. tostring(provider_error))
            return false, "provider_error"
        end
        return true
    end

    function Sky.Voice._ClearAnnouncementVolume(player_source)
        if announcement_sources[player_source] == nil then return true end
        if GetResourceState(RESOURCE) ~= "started" then return false, "provider_unavailable" end
        local ok, provider_error = pcall(function()
            MumbleSetVolumeOverrideByServerId(player_source, routed_volume(player_source, -1.0))
            assigned_volumes[player_source] = nil
            announcement_sources[player_source] = nil
        end)
        if not ok then
            Sky.Debug("error", "[sky_base][voice] pma announcement receive reset failed: " .. tostring(provider_error))
            return false, "provider_error"
        end
        return true
    end

    Sky.Voice._radioCommands = {
        primary = { resource = RESOURCE, command = "+radiotalk" }
    }

    function Sky.Voice._ApplyProximityOverride(range, options)
        if GetResourceState(RESOURCE) ~= "started" then
            return false, "provider_unavailable"
        end
        local apply_attempted = false
        local ok, provider_error = pcall(function()
            apply_attempted = true
            exports[RESOURCE]:overrideProximityRange(
                range,
                options.lockUserControl ~= false
            )
        end)
        if not ok then
            local rollback_ok = false
            local rollback_error = nil
            if apply_attempted and GetResourceState(RESOURCE) == "started" then
                rollback_ok, rollback_error = pcall(function()
                    exports[RESOURCE]:clearProximityOverride()
                end)
            end
            Sky.Debug("error", "[sky_base][voice] pma proximity override failed: " .. tostring(provider_error))
            if apply_attempted and not rollback_ok then
                Sky.Debug(
                    "error",
                    "[sky_base][voice] pma proximity rollback failed: "
                        .. tostring(rollback_error or "provider unavailable")
                )
            end
            return false, "provider_error"
        end
        return true
    end

    function Sky.Voice._ClearProximityOverride()
        if GetResourceState(RESOURCE) ~= "started" then
            return false, "provider_unavailable"
        end
        local ok, provider_error = pcall(function()
            exports[RESOURCE]:clearProximityOverride()
        end)
        if not ok then
            Sky.Debug("error", "[sky_base][voice] pma proximity reset failed: " .. tostring(provider_error))
            return false, "provider_error"
        end
        return true
    end

    function Sky.Voice._ApplyAnnouncementOverride(range, options)
        if GetResourceState(RESOURCE) ~= "started" then
            return false, "provider_unavailable"
        end
        if options.speakerPlayback and not supports_playback() then return false, "unsupported_provider_api" end
        -- Older pma releases build recipients from their configured voice mode,
        -- not the overridden talk range. Own both parts for this scoped session.
        local target_range = GetConvar("voice_useNativeAudio", "false") == "true" and range * 3.0 or range
        local coords, sampled_at
        local ok, provider_error = pcall(function()
            exports[RESOURCE]:overrideProximityCheck(options.recipientCheck or function(player)
                local now = GetGameTimer()
                if sampled_at ~= now then
                    coords, sampled_at = GetEntityCoords(PlayerPedId()), now
                end
                return #(coords - GetEntityCoords(GetPlayerPed(player))) < target_range
            end)
            exports[RESOURCE]:overrideProximityRange(range, true)
        end)
        if not ok then
            local rollback_ok, rollback_error = pcall(function()
                exports[RESOURCE]:resetProximityCheck()
                exports[RESOURCE]:clearProximityOverride()
            end)
            Sky.Debug("error", "[sky_base][voice] pma announcement override failed: " .. tostring(provider_error))
            if not rollback_ok then
                Sky.Debug("error", "[sky_base][voice] pma announcement rollback failed: " .. tostring(rollback_error))
            end
            return false, "provider_error"
        end
        return true
    end

    function Sky.Voice._ClearAnnouncementOverride()
        if GetResourceState(RESOURCE) ~= "started" then
            return false, "provider_unavailable"
        end
        local ok, provider_error = pcall(function()
            exports[RESOURCE]:resetProximityCheck()
            exports[RESOURCE]:clearProximityOverride()
        end)
        if not ok then
            Sky.Debug("error", "[sky_base][voice] pma announcement reset failed: " .. tostring(provider_error))
            return false, "provider_error"
        end
        return true
    end

    AddEventHandler("onClientResourceStop", function(resource_name)
        if resource_name == RESOURCE then
            if next(announcement_sources) and MumbleIsConnected() then
                for player_source in pairs(announcement_sources) do
                    MumbleSetVolumeOverrideByServerId(player_source, -1.0)
                end
            end
            playback_supported = nil
            assigned_volumes, announcement_sources, radio_senders = {}, {}, {}
            Sky.Voice._InvalidateAnnouncementVolumes("provider_unavailable")
            Sky.Voice._InvalidateProximityOverride("provider_unavailable")
        end
    end)

    AddEventHandler("mumbleDisconnected", function()
        assigned_volumes, announcement_sources, radio_senders = {}, {}, {}
        Sky.Voice._InvalidateAnnouncementVolumes("provider_unavailable")
    end)

    AddEventHandler("pma-voice:radioActive", function(active)
        TriggerEvent("sky_base:voice:radioActive", active == true)
    end)

    RegisterNetEvent("pma-voice:setTalkingOnRadio", function(source, active)
        source = tonumber(source)
        if source then radio_senders[source], assigned_volumes[source] = active == true, nil end
        if source == GetPlayerServerId(PlayerId()) then return end
        TriggerEvent("sky_base:voice:radioPeerActive", source, active == true)
    end)

    RegisterNetEvent("pma-voice:syncRadioData", function(members)
        radio_senders = {}
        for member_source, active in pairs(members or {}) do
            local player_source = tonumber(member_source)
            if player_source then radio_senders[player_source], assigned_volumes[player_source] = active == true, nil end
        end
    end)

    RegisterNetEvent("pma-voice:removePlayerFromRadio", function(player_source)
        player_source = tonumber(player_source)
        if player_source then radio_senders[player_source], assigned_volumes[player_source] = nil, nil end
    end)

    for _, event_name in ipairs({ "pma-voice:setTalkingOnCall", "pma-voice:addPlayerToCall", "pma-voice:removePlayerFromCall" }) do
        RegisterNetEvent(event_name, function(player_source)
            player_source = tonumber(player_source)
            if player_source then assigned_volumes[player_source] = nil end
        end)
    end

    RegisterNetEvent("pma-voice:syncCallData", function()
        assigned_volumes = {}
    end)

    function Sky.Voice.GetAnnouncementState()
        return { ready = GetResourceState(RESOURCE) == "started" and MumbleIsConnected(),
            muted = LocalPlayer.state.pmaVoiceSelfMuted and true or false }
    end

    function Sky.Voice.SetRadioChannel(channel_id)
        exports[RESOURCE]:setVoiceProperty("micClicks", Sky.Config.voiceRadioSounds.enabled)
        exports[RESOURCE]:setMicClickOnVolume(Sky.Config.voiceRadioSounds.transmitStartVolume)
        exports[RESOURCE]:setMicClickOffVolume(Sky.Config.voiceRadioSounds.transmitEndVolume)
        exports[RESOURCE]:setRadioChannel(channel_number(channel_id))
        return true
    end

    function Sky.Voice.GetRadioVolume()
        return volume
    end

    function Sky.Voice.SetRadioVolume(value)
        volume = math.max(0.0, math.min(1.0, tonumber(value) or 1.0))
        exports[RESOURCE]:setRadioVolume(math.floor(volume * 100 + 0.5))
        return true
    end
end

function Sky.Voice.GetCapabilities()
    return {
        provider = "pma",
        volume = true,
        multiChannel = false,
        radioActivity = true,
        proximityOverride = true,
        playerProximityOverride = false,
        announcementOverride = not IsDuplicityVersion(),
        announcementMode = "pma_pa",
        announcementHandsFree = not IsDuplicityVersion(),
        announcementServer = false,
        announcementPlayback = not IsDuplicityVersion() and supports_playback(),
    }
end
