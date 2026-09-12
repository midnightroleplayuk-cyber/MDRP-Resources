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

    if not self.hasRadio then
        if not silent then self:Notify('You need a radio to use a secondary channel') end
        return false
    end

    local allowed, reason = lib.callback.await('mm_radio:server:setSecondaryRadio', false, channel)
    if not allowed then
        if not silent then self:Notify(reason or 'Unable to join secondary channel') end
        return false
    end

    self.SecondaryRadioChannel = channel
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
    if self.identifier and self.userData[self.identifier] then
        self.userData[self.identifier].secondaryChannel = 0
        SetResourceKvp('radioSettings2', json.encode(self.userData))
    end
    TriggerEvent('mm_radio:client:secondaryChanged', 0)
    if not silent then self:Notify('Left secondary radio channel') end
    return true
end

RegisterNetEvent('mm_radio:client:secondaryRejected', function(reason)
    Radio.SecondaryRadioChannel = 0
    if Radio.identifier and Radio.userData[Radio.identifier] then
        Radio.userData[Radio.identifier].secondaryChannel = 0
        SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    end
    Radio:Notify(reason or 'Secondary radio channel rejected')
end)

RegisterCommand('secondaryradio', function(_, args)
    local channel = args[1]
    if not channel then
        Radio:Notify(('Secondary channel: %s'):format(Radio.SecondaryRadioChannel ~= 0 and Radio.SecondaryRadioChannel or 'OFF'))
        return
    end
    Radio:SetSecondaryRadio(channel)
end, false)

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
