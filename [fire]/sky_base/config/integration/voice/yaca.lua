if Sky.Config.voice ~= "yaca" then return end

local RESOURCE = "yaca-voice"

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
                exports[RESOURCE]:getPlayerVoiceRange(player_source)
            )
            if not range_before_apply or range_before_apply <= 0 then
                error("player voice range is unavailable")
            end
            previous_range = previous_range or range_before_apply
            previous_voice_ranges[player_source] = previous_range
            set_attempted = true
            exports[RESOURCE]:setPlayerVoiceRange(player_source, range)
        end)
        if not ok then
            local rollback_ok = false
            local rollback_error = nil
            if set_attempted and range_before_apply and GetResourceState(RESOURCE) == "started" then
                rollback_ok, rollback_error = pcall(function()
                    exports[RESOURCE]:setPlayerVoiceRange(
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
                "[sky_base][voice] YACA player proximity override failed: "
                    .. tostring(provider_error)
            )
            if set_attempted and not rollback_ok then
                Sky.Debug(
                    "error",
                    "[sky_base][voice] YACA player proximity rollback failed: "
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
            exports[RESOURCE]:setPlayerVoiceRange(player_source, previous_range)
        end)
        if not ok then
            previous_voice_ranges[player_source] = previous_range
            Sky.Debug(
                "error",
                "[sky_base][voice] YACA player proximity reset failed: "
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
        TriggerClientEvent("sky_base:voice:yacaSetRadioChannel", source, channel_id, primary)
        return true
    end

    function Sky.Voice.RemoveRadio(source, channel_id)
        TriggerClientEvent("sky_base:voice:yacaRemoveRadioChannel", source, channel_id)
        return true
    end

    function Sky.Voice.GetPlayersInChannel(channel_id)
        return exports[RESOURCE]:getPlayersInRadioFrequency(tostring(channel_id)) or {}
    end
else
    Sky.Voice._radioCommands = {
        primary = { resource = RESOURCE, command = "+yaca:radioTalking" },
        secondary = { resource = RESOURCE, command = "+yaca:secondaryRadioTalking" }
    }

    function Sky.Voice.GetAnnouncementState()
        if GetResourceState(RESOURCE) ~= "started" then
            return { ready = false, muted = true, provider = "yaca", resource = RESOURCE, muteKnown = false }
        end
        local ok, state = pcall(function()
            return {
                ready = exports[RESOURCE]:getPluginState() == "IN_INGAME_CHANNEL",
                muted = exports[RESOURCE]:getMicrophoneMuteState() or exports[RESOURCE]:getMicrophoneDisabledState()
                    or exports[RESOURCE]:getSoundMuteState() or exports[RESOURCE]:getSoundDisabledState(),
                provider = "yaca", resource = RESOURCE, muteKnown = true,
            }
        end)
        if not ok then
            Sky.Debug("error", "[sky_base][voice] YACA announcement state failed: " .. tostring(state))
            return { ready = false, muted = true, provider = "yaca", resource = RESOURCE, muteKnown = false }
        end
        return state
    end

    local previous_voice_range = nil
    local previous_change_allowed = nil

    function Sky.Voice._ApplyProximityOverride(range, options)
        if GetResourceState(RESOURCE) ~= "started" then
            return false, "provider_unavailable"
        end
        local ok, provider_error = pcall(function()
            if previous_voice_range == nil then
                previous_voice_range = exports[RESOURCE]:getVoiceRange()
                previous_change_allowed = exports[RESOURCE]:getVoiceRangeChangeAllowedState()
            end
            exports[RESOURCE]:setVoiceRange(range)
            if options.lockUserControl ~= false then
                exports[RESOURCE]:setVoiceRangeChangeAllowedState(false)
            end
        end)
        if not ok then
            local restore_range = previous_voice_range
            local restore_change_allowed = previous_change_allowed
            local rollback_ok, rollback_error = pcall(function()
                if restore_range ~= nil and GetResourceState(RESOURCE) == "started" then
                    exports[RESOURCE]:setVoiceRange(restore_range)
                end
                if restore_change_allowed ~= nil and GetResourceState(RESOURCE) == "started" then
                    exports[RESOURCE]:setVoiceRangeChangeAllowedState(
                        restore_change_allowed == true
                    )
                end
            end)
            previous_voice_range = nil
            previous_change_allowed = nil
            Sky.Debug("error", "[sky_base][voice] YACA proximity override failed: " .. tostring(provider_error))
            if not rollback_ok then
                Sky.Debug(
                    "error",
                    "[sky_base][voice] YACA proximity rollback failed: "
                        .. tostring(rollback_error)
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
        local restore_range = previous_voice_range
        local restore_change_allowed = previous_change_allowed
        local ok, provider_error = pcall(function()
            if restore_range ~= nil then
                exports[RESOURCE]:setVoiceRange(restore_range)
            end
            if restore_change_allowed ~= nil then
                exports[RESOURCE]:setVoiceRangeChangeAllowedState(
                    restore_change_allowed == true
                )
            end
        end)
        if not ok then
            Sky.Debug("error", "[sky_base][voice] YACA proximity reset failed: " .. tostring(provider_error))
            return false, "provider_error"
        end
        previous_voice_range = nil
        previous_change_allowed = nil
        return true
    end

    AddEventHandler("onClientResourceStop", function(resource_name)
        if resource_name == RESOURCE then
            previous_voice_range = nil
            previous_change_allowed = nil
            Sky.Voice._InvalidateProximityOverride("provider_unavailable")
        end
    end)

    AddEventHandler("yaca:external:isRadioTalking", function(active)
        TriggerEvent("sky_base:voice:radioActive", active == true)
    end)

    AddEventHandler("yaca:external:isRadioReceiving", function(active, _, source)
        TriggerEvent("sky_base:voice:radioPeerActive", tonumber(source), active == true)
    end)

    function Sky.Voice.SetRadioChannel(channel_id, primary)
        local channel = primary ~= false and 1 or 2
        exports[RESOURCE]:enableRadio(true)
        if primary ~= false then
            exports[RESOURCE]:setActiveRadioChannel(channel)
        end
        exports[RESOURCE]:changeRadioFrequencyRaw(channel, tostring(channel_id))
        return true
    end

    RegisterNetEvent("sky_base:voice:yacaSetRadioChannel", function(channel_id, primary)
        Sky.Voice.SetRadioChannel(channel_id, primary)
    end)

    RegisterNetEvent("sky_base:voice:yacaRemoveRadioChannel", function(channel_id)
        channel_id = tostring(channel_id)
        for channel = 1, 2 do
            if tostring(exports[RESOURCE]:getRadioFrequency(channel)) == channel_id then
                exports[RESOURCE]:changeRadioFrequencyRaw(channel, "0")
            end
        end
    end)

    function Sky.Voice.GetRadioVolume()
        local channel = exports[RESOURCE]:getActiveRadioChannel()
        return math.max(0.0, math.min(1.0, tonumber(exports[RESOURCE]:getRadioChannelVolume(channel)) or 1.0))
    end

    function Sky.Voice.SetRadioVolume(value)
        local channel = exports[RESOURCE]:getActiveRadioChannel()
        exports[RESOURCE]:changeRadioChannelVolumeRaw(channel, math.max(0.0, math.min(1.0, tonumber(value) or 1.0)))
        return true
    end
end

function Sky.Voice.GetCapabilities()
    return {
        provider = "yaca",
        volume = true,
        multiChannel = true,
        radioActivity = true,
        proximityOverride = true,
        playerProximityOverride = IsDuplicityVersion(),
        announcementOverride = false,
        announcementServer = IsDuplicityVersion(),
        announcementMode = "yaca_range",
        announcementRangeMax = 100,
        announcementPositions = 0,
        announcementHandsFree = false,
    }
end
