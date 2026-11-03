if Sky.Config.voice ~= "saltychat" then return end

local RESOURCE = "saltychat"

if IsDuplicityVersion() then
    local previous_voice_ranges = {}

    function Sky.Voice._ApplyPlayerProximityOverride(player_source, range)
        if GetResourceState(RESOURCE) ~= "started" then
            return false, "provider_unavailable"
        end
        local stored_range = previous_voice_ranges[player_source]
        local previous_range = stored_range
        local range_before_apply = nil
        local set_attempted = false
        local ok, provider_error = pcall(function()
            range_before_apply = tonumber(
                exports[RESOURCE]:GetPlayerVoiceRange(player_source)
            )
            if not range_before_apply or range_before_apply <= 0 then
                error("player voice client is not ready")
            end
            previous_range = previous_range or range_before_apply
            previous_voice_ranges[player_source] = previous_range
            set_attempted = true
            exports[RESOURCE]:SetPlayerVoiceRange(player_source, range)
        end)
        if not ok then
            local rollback_ok = false
            local rollback_error = nil
            if set_attempted and range_before_apply and GetResourceState(RESOURCE) == "started" then
                rollback_ok, rollback_error = pcall(function()
                    exports[RESOURCE]:SetPlayerVoiceRange(
                        player_source,
                        range_before_apply
                    )
                end)
            end
            if stored_range == nil and rollback_ok then
                previous_voice_ranges[player_source] = nil
            else
                previous_voice_ranges[player_source] = previous_range
            end
            Sky.Debug(
                "error",
                "[sky_base][voice] SaltyChat player proximity override failed: "
                    .. tostring(provider_error)
            )
            if set_attempted and not rollback_ok then
                Sky.Debug(
                    "error",
                    "[sky_base][voice] SaltyChat player proximity rollback failed: "
                        .. tostring(rollback_error or "provider unavailable")
                )
            end
            return false, "provider_error"
        end
        previous_voice_ranges[player_source] = previous_range
        return true
    end

    function Sky.Voice._ClearPlayerProximityOverride(player_source, options)
        local previous_range = previous_voice_ranges[player_source]
        if previous_range == nil then
            return true
        end
        if options and options.playerDropped then
            previous_voice_ranges[player_source] = nil
            return true
        end
        if GetResourceState(RESOURCE) ~= "started" then
            return false, "provider_unavailable"
        end
        local ok, provider_error = pcall(function()
            exports[RESOURCE]:SetPlayerVoiceRange(player_source, previous_range)
        end)
        if not ok then
            previous_voice_ranges[player_source] = previous_range
            Sky.Debug(
                "error",
                "[sky_base][voice] SaltyChat player proximity reset failed: "
                    .. tostring(provider_error)
            )
            return false, "provider_error"
        end
        previous_voice_ranges[player_source] = nil
        return true
    end

    AddEventHandler("onResourceStop", function(resource_name)
        if resource_name ~= RESOURCE then
            return
        end
        previous_voice_ranges = {}
        Sky.Voice._InvalidatePlayerProximityOverrides("provider_unavailable")
    end)

    function Sky.Voice.SetRadio(source, channel_id, primary)
        exports[RESOURCE]:SetPlayerRadioChannel(source, tostring(channel_id), primary ~= false)
        return true
    end

    function Sky.Voice.RemoveRadio(source, channel_id)
        exports[RESOURCE]:RemovePlayerRadioChannel(source, tostring(channel_id))
        return true
    end

    function Sky.Voice.GetPlayersInChannel(channel_id)
        return exports[RESOURCE]:GetPlayersInRadioChannel(tostring(channel_id)) or {}
    end
else
    Sky.Voice._radioCommands = {
        primary = { resource = RESOURCE, command = "+primaryRadio" },
        secondary = { resource = RESOURCE, command = "+secondaryRadio" }
    }

    local microphone_muted, microphone_enabled
    AddEventHandler("SaltyChat_MicStateChanged", function(muted)
        microphone_muted = muted
    end)
    AddEventHandler("SaltyChat_MicEnabledChanged", function(enabled)
        microphone_enabled = enabled
    end)
    AddEventHandler("onClientResourceStop", function(resource_name)
        if resource_name == RESOURCE then microphone_muted, microphone_enabled = nil, nil end
    end)

    function Sky.Voice.GetAnnouncementState()
        if GetResourceState(RESOURCE) ~= "started" then
            return { ready = false, muted = true, provider = "saltychat", resource = RESOURCE, muteKnown = false }
        end
        local ok, state = pcall(function() return exports[RESOURCE]:GetPluginState() end)
        if not ok then
            Sky.Debug("error", "[sky_base][voice] SaltyChat announcement state failed: " .. tostring(state))
        end
        return {
            ready = ok and tonumber(state) == 2,
            muted = microphone_muted == true or microphone_enabled == false,
            provider = "saltychat", resource = RESOURCE,
            muteKnown = microphone_muted ~= nil and microphone_enabled ~= nil,
        }
    end

    AddEventHandler("SaltyChat_RadioTrafficStateChanged", function(primary_receive, primary_transmit, secondary_receive, secondary_transmit)
        TriggerEvent("sky_base:voice:radioActive", primary_transmit or secondary_transmit)
        TriggerEvent("sky_base:voice:radioPeerActive", nil, primary_receive or secondary_receive)
    end)

    function Sky.Voice.SetRadioChannel(channel_id, primary)
        exports[RESOURCE]:SetMicClick(Sky.Config.voiceRadioSounds.enabled)
        exports[RESOURCE]:SetRadioChannel(tostring(channel_id), primary ~= false)
        return true
    end

    function Sky.Voice.GetRadioVolume()
        return math.max(0.0, math.min(1.0, (tonumber(exports[RESOURCE]:GetRadioVolume()) or 1.6) / 1.6))
    end

    function Sky.Voice.SetRadioVolume(value)
        exports[RESOURCE]:SetRadioVolume(math.max(0.0, math.min(1.0, tonumber(value) or 1.0)) * 1.6)
        return true
    end
end

function Sky.Voice.GetCapabilities()
    return {
        provider = "saltychat",
        volume = true,
        multiChannel = true,
        radioActivity = true,
        proximityOverride = false,
        playerProximityOverride = IsDuplicityVersion(),
        announcementOverride = false,
        announcementServer = IsDuplicityVersion(),
        announcementMode = "salty_range",
        announcementRangeMax = 100,
        announcementPositions = 0,
        announcementHandsFree = false,
    }
end
