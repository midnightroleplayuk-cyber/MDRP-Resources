Sky.Voice = Sky.Voice or {}
Sky.Voice._radioCommands = {}

local volume = 1.0
local proximity_override = nil
local player_proximity_overrides = {}
local announcement_volumes = {}

local function normalized_scope(scope_id)
    if type(scope_id) ~= "string" then
        return nil
    end
    scope_id = scope_id:match("^%s*(.-)%s*$")
    if scope_id == "" or #scope_id > 128 then
        return nil
    end
    return scope_id
end

local function normalized_range(range, maximum)
    range = tonumber(range)
    if not range or range ~= range or range == math.huge or range == -math.huge then
        return nil
    end
    if range < 1.0 or range > (maximum or 100.0) then
        return nil
    end
    return range + 0.0
end

local function normalized_source(player_source)
    player_source = tonumber(player_source)
    if not player_source or player_source ~= math.floor(player_source)
        or player_source <= 0
    then
        return nil
    end
    return player_source
end

-- Provider adapters replace these two functions on the client. Keeping the
-- ownership and validation here gives every consumer one stable contract.
Sky.Voice._ApplyProximityOverride = function()
    return false, "unsupported_provider_api"
end

Sky.Voice._ClearProximityOverride = function()
    return false, "unsupported_provider_api"
end

Sky.Voice._ApplyAnnouncementOverride = function()
    return false, "unsupported_provider_api"
end

Sky.Voice._ClearAnnouncementOverride = function()
    return false, "unsupported_provider_api"
end

Sky.Voice._ApplyAnnouncementVolume = function()
    return false, "unsupported_provider_api"
end

Sky.Voice._ClearAnnouncementVolume = function()
    return false, "unsupported_provider_api"
end

-- Server-capable providers replace these functions. The shared layer owns
-- validation and scopes so consumers never branch on a voice provider.
Sky.Voice._ApplyPlayerProximityOverride = function()
    return false, "unsupported_provider_api"
end

Sky.Voice._ClearPlayerProximityOverride = function()
    return false, "unsupported_provider_api"
end

function Sky.Voice.SetProximityOverride(scope_id, range, options)
    if IsDuplicityVersion() then
        return false, "client_only"
    end
    scope_id = normalized_scope(scope_id)
    range = normalized_range(range)
    if not scope_id then
        return false, "invalid_scope"
    end
    if not range then
        return false, "invalid_range"
    end
    if proximity_override and (proximity_override.scopeId ~= scope_id or proximity_override.announcement) then
        return false, "override_in_use"
    end
    local ok, error_code = Sky.Voice._ApplyProximityOverride(
        range,
        type(options) == "table" and options or {}
    )
    if ok ~= true then
        return false, error_code or "provider_error"
    end
    proximity_override = {
        scopeId = scope_id,
        range = range,
        provider = Sky.Voice.GetCapabilities().provider,
    }
    return true
end

function Sky.Voice.SetAnnouncementOverride(scope_id, range, options)
    if IsDuplicityVersion() then
        return false, "client_only"
    end
    scope_id = normalized_scope(scope_id)
    range = normalized_range(range, 300.0)
    if not scope_id then
        return false, "invalid_scope"
    end
    if not range then
        return false, "invalid_range"
    end
    options = type(options) == "table" and options or {}
    if options.recipientCheck ~= nil and type(options.recipientCheck) ~= "function" then
        return false, "invalid_recipient_check"
    end
    if proximity_override and (proximity_override.scopeId ~= scope_id or not proximity_override.announcement) then
        return false, "override_in_use"
    end
    local ok, error_code = Sky.Voice._ApplyAnnouncementOverride(range, options)
    if not ok then
        return false, error_code or "provider_error"
    end
    proximity_override = {
        scopeId = scope_id,
        range = range,
        provider = Sky.Voice.GetCapabilities().provider,
        announcement = true,
    }
    return true
end

function Sky.Voice.SetAnnouncementVolume(scope_id, player_source, value, options)
    if IsDuplicityVersion() then return false, "client_only" end
    scope_id, player_source, value = normalized_scope(scope_id), normalized_source(player_source), tonumber(value)
    if not scope_id then return false, "invalid_scope" end
    if not player_source or player_source > 2147483647 then return false, "invalid_source" end
    if not value or value ~= value or value < 0.0 or value > 1.0 then return false, "invalid_volume" end
    options = type(options) == "table" and options or {}
    local owner_resource = normalized_scope(GetInvokingResource()) or normalized_scope(options.ownerResource)
    local current = announcement_volumes[player_source]
    if current and (current.scopeId ~= scope_id or current.ownerResource and current.ownerResource ~= owner_resource) then
        return false, "override_in_use"
    end
    local ok, error_code = Sky.Voice._ApplyAnnouncementVolume(player_source, value)
    if not ok then return false, error_code or "provider_error" end
    announcement_volumes[player_source] = { scopeId = scope_id, ownerResource = owner_resource }
    return true
end

function Sky.Voice.ClearAnnouncementVolume(scope_id, player_source)
    if IsDuplicityVersion() then return false, "client_only" end
    scope_id = normalized_scope(scope_id)
    if not scope_id then return false, "invalid_scope" end
    if player_source ~= nil then
        player_source = normalized_source(player_source)
        if not player_source or player_source > 2147483647 then return false, "invalid_source" end
        local current = announcement_volumes[player_source]
        if not current then return true end
        if current.scopeId ~= scope_id then return false, "scope_mismatch" end
    end
    local pending = {}
    for id, current in pairs(announcement_volumes) do
        if current.scopeId == scope_id and (player_source == nil or player_source == id) then pending[#pending + 1] = id end
    end
    local failure
    for _, id in ipairs(pending) do
        local ok, error_code = Sky.Voice._ClearAnnouncementVolume(id)
        if ok then announcement_volumes[id] = nil else failure = failure or error_code or "provider_error" end
    end
    if failure then return false, failure end
    return true
end

function Sky.Voice._InvalidateAnnouncementVolumes(reason)
    local scopes = {}
    for _, current in pairs(announcement_volumes) do scopes[current.scopeId] = true end
    announcement_volumes = {}
    if not IsDuplicityVersion() then
        for scope_id in pairs(scopes) do
            TriggerEvent("sky_base:voice:announcementVolumeInvalidated", scope_id, reason or "provider_unavailable")
        end
    end
end

function Sky.Voice.ClearProximityOverride(scope_id)
    if IsDuplicityVersion() then
        return false, "client_only"
    end
    scope_id = normalized_scope(scope_id)
    if not scope_id then
        return false, "invalid_scope"
    end
    if not proximity_override then
        return true
    end
    if proximity_override.scopeId ~= scope_id then
        return false, "scope_mismatch"
    end
    local clear = proximity_override.announcement and Sky.Voice._ClearAnnouncementOverride or Sky.Voice._ClearProximityOverride
    local ok, error_code = clear()
    if ok ~= true then
        return false, error_code or "provider_error"
    end
    proximity_override = nil
    return true
end

function Sky.Voice.GetProximityOverride()
    if not proximity_override then
        return nil
    end
    return {
        scopeId = proximity_override.scopeId,
        range = proximity_override.range,
        provider = proximity_override.provider,
        announcement = proximity_override.announcement,
    }
end

function Sky.Voice._InvalidateProximityOverride(reason)
    local previous = proximity_override
    proximity_override = nil
    if previous and not IsDuplicityVersion() then
        TriggerEvent(
            "sky_base:voice:proximityOverrideInvalidated",
            previous.scopeId,
            reason or "provider_unavailable"
        )
    end
end

function Sky.Voice.SetPlayerProximityOverride(player_source, scope_id, range, options)
    if not IsDuplicityVersion() then
        return false, "server_only"
    end
    player_source = normalized_source(player_source)
    scope_id = normalized_scope(scope_id)
    range = normalized_range(range)
    if not player_source then
        return false, "invalid_source"
    end
    if not scope_id then
        return false, "invalid_scope"
    end
    if not range then
        return false, "invalid_range"
    end
    local safe_options = type(options) == "table" and options or {}
    local owner_resource = nil
    if type(GetInvokingResource) == "function" then
        local owner_ok, invoking_resource = pcall(GetInvokingResource)
        if owner_ok then
            owner_resource = normalized_scope(invoking_resource)
        end
    end
    owner_resource = owner_resource
        or normalized_scope(safe_options.ownerResource)
    local current = player_proximity_overrides[player_source]
    if current and current.scopeId ~= scope_id then
        return false, "override_in_use"
    end
    if current and current.ownerResource
        and current.ownerResource ~= owner_resource
    then
        return false, "override_in_use"
    end
    local ok, error_code = Sky.Voice._ApplyPlayerProximityOverride(
        player_source,
        range,
        safe_options
    )
    if ok ~= true then
        return false, error_code or "provider_error"
    end
    player_proximity_overrides[player_source] = {
        scopeId = scope_id,
        range = range,
        provider = Sky.Voice.GetCapabilities().provider,
        ownerResource = current and current.ownerResource or owner_resource,
    }
    return true
end

function Sky.Voice.ClearPlayerProximityOverride(player_source, scope_id)
    if not IsDuplicityVersion() then
        return false, "server_only"
    end
    player_source = normalized_source(player_source)
    scope_id = normalized_scope(scope_id)
    if not player_source then
        return false, "invalid_source"
    end
    if not scope_id then
        return false, "invalid_scope"
    end
    local current = player_proximity_overrides[player_source]
    if not current then
        return true
    end
    if current.scopeId ~= scope_id then
        return false, "scope_mismatch"
    end
    local ok, error_code =
        Sky.Voice._ClearPlayerProximityOverride(player_source, {})
    if ok ~= true then
        return false, error_code or "provider_error"
    end
    player_proximity_overrides[player_source] = nil
    return true
end

function Sky.Voice.GetPlayerProximityOverride(player_source)
    if not IsDuplicityVersion() then
        return nil, "server_only"
    end
    player_source = normalized_source(player_source)
    if not player_source then
        return nil, "invalid_source"
    end
    local current = player_proximity_overrides[player_source]
    if not current then
        return nil
    end
    return {
        scopeId = current.scopeId,
        range = current.range,
        provider = current.provider,
        ownerResource = current.ownerResource,
    }
end

function Sky.Voice._InvalidatePlayerProximityOverride(player_source, reason)
    player_source = normalized_source(player_source)
    local previous = player_source and player_proximity_overrides[player_source] or nil
    if not previous then
        return
    end
    player_proximity_overrides[player_source] = nil
    if IsDuplicityVersion() then
        TriggerEvent(
            "sky_base:voice:playerProximityOverrideInvalidated",
            player_source,
            previous.scopeId,
            reason or "provider_unavailable"
        )
    end
end

function Sky.Voice._InvalidatePlayerProximityOverrides(reason)
    local pending = {}
    for player_source in pairs(player_proximity_overrides) do
        pending[#pending + 1] = player_source
    end
    for _, player_source in ipairs(pending) do
        Sky.Voice._InvalidatePlayerProximityOverride(player_source, reason)
    end
end

function Sky.Voice.SetRadio()
    Sky.Debug("error", "[sky_base][voice] No supported voice adapter is active.")
    return false
end

function Sky.Voice.RemoveRadio()
    Sky.Debug("error", "[sky_base][voice] No supported voice adapter is active.")
    return false
end

function Sky.Voice.GetPlayersInChannel()
    return {}
end

function Sky.Voice.SetRadioChannel()
    Sky.Debug("error", "[sky_base][voice] No supported voice adapter is active.")
    return false
end

function Sky.Voice.GetRadioVolume()
    return volume
end

function Sky.Voice.SetRadioVolume(value)
    volume = math.max(0.0, math.min(1.0, tonumber(value) or 1.0))
    return false
end

function Sky.Voice.GetCapabilities()
    return {
        provider = "none",
        volume = false,
        multiChannel = false,
        radioActivity = false,
        proximityOverride = false,
        playerProximityOverride = false,
        announcementOverride = false,
        announcementPlayback = false,
        announcementHandsFree = false,
        announcementServer = false,
    }
end

function Sky.Voice.GetAnnouncementState()
    return { ready = false, muted = false }
end

if not IsDuplicityVersion() then
    -- Read the player's binding, never the provider's default key. The glyph stays
    -- intact so a NUI can distinguish localized characters from special keys.
    function Sky.Voice.GetRadioBindings()
        local bindings = {}
        local gta_ptt = GetControlInstructionalButton(0, 249, true)
        for id, binding in pairs(Sky.Voice._radioCommands) do
            if GetResourceState(binding.resource) == "started" then
                local instruction = GetControlInstructionalButton(0, joaat(binding.command) | 0x80000000, true)
                if instruction ~= "" then
                    bindings[#bindings + 1] = {
                        id = id,
                        instruction = instruction,
                        native = instruction == gta_ptt,
                        resource = binding.resource
                    }
                end
            end
        end
        return bindings
    end

    function Sky.Voice.SetRadioTransmit(id, transmitting)
        local binding = Sky.Voice._radioCommands[id]
        if not binding or type(transmitting) ~= "boolean" then
            Sky.Debug("warn", "[sky_base][voice] Invalid radio transmit binding or state: " .. tostring(id))
            return false
        end
        if GetResourceState(binding.resource) ~= "started" then
            Sky.Debug("warn", "[sky_base][voice] Radio transmit provider is not started: " .. binding.resource)
            return false
        end
        ExecuteCommand((transmitting and "+" or "-") .. binding.command:sub(2))
        return true
    end

    AddEventHandler("onClientResourceStop", function(resource_name)
        local clear_all = resource_name == GetCurrentResourceName()
        local pending = {}
        for player_source, current in pairs(announcement_volumes) do
            if clear_all or current.ownerResource == resource_name then pending[#pending + 1] = player_source end
        end
        for _, player_source in ipairs(pending) do
            local ok, cleared, error_code = pcall(Sky.Voice._ClearAnnouncementVolume, player_source)
            if ok and cleared then
                announcement_volumes[player_source] = nil
            else
                Sky.Debug("error", "[sky_base][voice] Announcement volume cleanup failed for " .. player_source .. ": " .. tostring(ok and error_code or cleared))
            end
        end
        if clear_all and proximity_override then
            pcall(proximity_override.announcement and Sky.Voice._ClearAnnouncementOverride or Sky.Voice._ClearProximityOverride)
            proximity_override = nil
        end
    end)
else
    AddEventHandler("playerDropped", function()
        local player_source = tonumber(source)
        if not player_source or not player_proximity_overrides[player_source] then
            return
        end
        pcall(
            Sky.Voice._ClearPlayerProximityOverride,
            player_source,
            { playerDropped = true }
        )
        player_proximity_overrides[player_source] = nil
    end)

    AddEventHandler("onResourceStop", function(resource_name)
        local clear_all = resource_name == GetCurrentResourceName()
        local pending = {}
        for player_source, current in pairs(player_proximity_overrides) do
            if clear_all or current.ownerResource == resource_name then
                pending[#pending + 1] = player_source
            end
        end
        for _, player_source in ipairs(pending) do
            local ok, cleared = pcall(
                Sky.Voice._ClearPlayerProximityOverride,
                player_source,
                { resourceStop = true }
            )
            if ok and cleared == true then
                player_proximity_overrides[player_source] = nil
            end
        end
    end)
end
