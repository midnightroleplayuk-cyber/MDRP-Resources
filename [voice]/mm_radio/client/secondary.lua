-- mm_radio dual-channel support
-- Primary radio remains managed by pma-voice. Secondary membership is managed by mm_radio
-- and transmitted by the companion pma-voice module included in the release bundle.

local function normalizeChannel(channel)
    channel = tonumber(channel)
    if not channel then return nil end
    channel = math.floor(channel * 100 + 0.5) / 100
    if channel < 0 or channel > Shared.MaxFrequency then return nil end
    return channel
end

function Radio:SetSecondaryRadio(channel, silent)
    channel = normalizeChannel(channel)
    if channel == nil then
        if not silent then self:Notify(('Invalid secondary channel (0-%s)'):format(Shared.MaxFrequency)) end
        return false
    end

    if channel == 0 then
        return self:LeaveSecondaryRadio(silent)
    end

    if self.insideJammer and not IsJammerAllowed(self.insideJammerZone, channel) then
        if not silent then self:Notify(('Secondary channel %s is jammed'):format(channel)) end
        return false
    end

    if not self.hasRadio then
        if not silent then self:Notify('You need a radio to use a secondary channel') end
        return false
    end

    -- Set the local channel before awaiting the server. The server immediately sends
    -- the membership snapshot on a successful join; setting this first ensures the
    -- secondaryListUpdate handler accepts that initial snapshot instead of dropping it
    -- until somebody transmits. Roll back if the server rejects the join.
    local previousChannel = self.SecondaryRadioChannel
    self.SecondaryRadioChannel = channel
    self.SecondaryRadioMembers = {}

    local allowed, reason = lib.callback.await('mm_radio:server:setSecondaryRadio', false, channel)
    if not allowed then
        self.SecondaryRadioChannel = previousChannel or 0
        if not silent then self:Notify(reason or 'Unable to join secondary channel') end
        return false
    end

    -- Keep pma's radio audio/UI infrastructure alive for Secondary-only operation.
    -- pma's playMicClicks uses this same voice resource, so both key-down and
    -- key-up clicks continue to behave exactly like normal radio PTT.
    if (self.RadioChannel or 0) == 0 then
        exports['pma-voice']:setVoiceProperty('radioEnabled', true)
    end

    self:SendSvelteMessage('secondaryChannelChanged', { channel = channel, talking = false })
    self.userData[self.identifier].secondaryChannel = channel
    SetResourceKvp('radioSettings2', json.encode(self.userData))
    TriggerEvent('mm_radio:client:secondaryChanged', channel)

    if not silent then
        self:connectSound()
        self:Notify(('Secondary channel set to %s'):format(channel))
    end
    return true
end

function Radio:LeaveSecondaryRadio(silent)
    if self.SecondaryRadioChannel == 0 then return true end
    TriggerServerEvent('mm_radio:server:leaveSecondaryRadio')
    self.SecondaryRadioChannel = 0
    self.SecondaryRadioMembers = {}
    self:SendSvelteMessage('secondaryChannelChanged', { channel = 0, talking = false })
    self:SendSvelteMessage('dualRadioListUpdate', { primary = self.PrimaryRadioMembers or {}, secondary = {}, primaryChannel = self.RadioChannel or 0, secondaryChannel = 0 })
    if self.identifier and self.userData[self.identifier] then
        self.userData[self.identifier].secondaryChannel = 0
        SetResourceKvp('radioSettings2', json.encode(self.userData))
    end
    TriggerEvent('mm_radio:client:secondaryChanged', 0)
    if (self.RadioChannel or 0) == 0 then
        exports['pma-voice']:setVoiceProperty('radioEnabled', false)
    end
    if not silent then self:Notify('Left secondary radio channel') end
    return true
end

RegisterNetEvent('mm_radio:client:secondaryRejected', function(reason)
    Radio.SecondaryRadioChannel = 0
    Radio:SendSvelteMessage('secondaryChannelChanged', { channel = 0, talking = false })
    if Radio.identifier and Radio.userData[Radio.identifier] then
        Radio.userData[Radio.identifier].secondaryChannel = 0
        SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    end
    Radio:Notify(reason or 'Secondary radio channel rejected')
end)


RegisterCommand('secondaryoff', function()
    Radio:LeaveSecondaryRadio(false)
end, false)

exports('SetSecondaryRadio', function(channel)
    return Radio:SetSecondaryRadio(channel)
end)

exports('GetSecondaryRadio', function()
    return Radio.SecondaryRadioChannel
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SetTimeout(1500, function()
        if not Radio.identifier or not Radio.userData[Radio.identifier] then return end
        local saved = tonumber(Radio.userData[Radio.identifier].secondaryChannel) or 0
        if saved > 0 and Radio.hasRadio then
            Radio:SetSecondaryRadio(saved, true)
        end
    end)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    SetTimeout(1500, function()
        if not LocalPlayer.state.isLoggedIn or not Radio.identifier or not Radio.userData[Radio.identifier] then return end
        local saved = tonumber(Radio.userData[Radio.identifier].secondaryChannel) or 0
        if saved > 0 and Radio.hasRadio then
            Radio:SetSecondaryRadio(saved, true)
        end
    end)
end)


RegisterNetEvent('mm_radio:client:secondaryListUpdate', function(players, channel)
    if tonumber(channel) == tonumber(Radio.SecondaryRadioChannel) or tonumber(channel) == 0 then
        Radio.SecondaryRadioMembers = players or {}
        Radio:SendSvelteMessage('dualRadioListUpdate', {
            primary = Radio.PrimaryRadioMembers or {},
            secondary = Radio.SecondaryRadioMembers or {},
            primaryChannel = Radio.RadioChannel or 0,
            secondaryChannel = Radio.SecondaryRadioChannel or 0
        })
    end
end)

AddEventHandler('mm_radio:client:secondaryRadioActive', function(active)
    local id = tostring(Radio.playerServerID)
    if Radio.SecondaryRadioMembers and Radio.SecondaryRadioMembers[id] then
        Radio.SecondaryRadioMembers[id].isTalking = active == true
    end
    Radio:SendSvelteMessage('secondaryTalkingChanged', {
        channel = Radio.SecondaryRadioChannel,
        talking = active == true
    })
    Radio:SendSvelteMessage('dualRadioListUpdate', {
        primary = Radio.PrimaryRadioMembers or {},
        secondary = Radio.SecondaryRadioMembers or {},
        primaryChannel = Radio.RadioChannel or 0,
        secondaryChannel = Radio.SecondaryRadioChannel or 0
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if Radio.SecondaryRadioChannel ~= 0 then
        TriggerServerEvent('mm_radio:server:leaveSecondaryRadio')
    end
end)
