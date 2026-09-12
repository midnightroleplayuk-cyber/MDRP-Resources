-- mm_radio secondary channel bridge for pma-voice
-- Copy this file into: pma-voice/client/module/mm_radio_secondary.lua
-- pma-voice loads client/module/*.lua automatically on current releases.

local secondaryRadioChannel = 0
local secondaryRadioData = {}
local secondaryRadioPressed = false

-- Match pma-voice's stock primary PTT shoulder-radio animation.
local secondaryRadioAnim = {
    dict = "random@arrests",
    anim = "generic_radio_enter"
}

local function secondaryRadioAnimEnabled()
    if GetConvarInt('voice_enableRadioAnim', 1) ~= 1 then return false end
    if GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1 and IsPedInAnyVehicle(PlayerPedId(), false) then return false end
    -- pma-voice's disableRadioAnim local isn't exported as a getter with the actual enabled state,
    -- so respect its public getRadioAnimState export when available.
    local ok, disabled = pcall(function() return exports['pma-voice']:getRadioAnimState() end)
    if ok and disabled == true then return false end
    return true
end

local function secondaryEnabled()
    if GetConvarInt('voice_enableRadios', 1) ~= 1 then return false end
    if secondaryRadioChannel <= 0 then return false end
    if isDead and isDead() then return false end
    if isRadioEnabled and not isRadioEnabled() then return false end
    return true
end

RegisterNetEvent('mm_radio:pma:syncSecondaryRadioData', function(channel, data)
    secondaryRadioChannel = tonumber(channel) or 0
    secondaryRadioData = data or {}
    SendNUIMessage({ secondaryRadioChannel = secondaryRadioChannel, usingSecondaryRadio = secondaryRadioPressed })
end)

RegisterNetEvent('mm_radio:pma:setTalkingOnSecondaryRadio', function(plySource, enabled)
    plySource = tonumber(plySource)
    if not plySource then return end
    if toggleVoice then
        toggleVoice(plySource, enabled == true, 'radio')
    end
    if playMicClicks then
        playMicClicks(enabled == true)
    end
    TriggerEvent('pma-voice:setTalkingOnSecondaryRadio', plySource, enabled == true)
end)

local function stopSecondaryTalk()
    if not secondaryRadioPressed then return end
    secondaryRadioPressed = false

    -- Rebuild pma's normal target state after secondary transmission.
    MumbleClearVoiceTargetPlayers(voiceTarget)
    if callData and addVoiceTargets then
        addVoiceTargets(callData)
    end

    TriggerServerEvent('mm_radio:server:setSecondaryTalking', false)
    TriggerEvent('mm_radio:client:secondaryRadioActive', false)
    LocalPlayer.state:set('secondaryRadioActive', false, true)
    SendNUIMessage({ secondaryRadioChannel = secondaryRadioChannel, usingSecondaryRadio = false })
    StopAnimTask(PlayerPedId(), secondaryRadioAnim.dict, secondaryRadioAnim.anim, -4.0)
    if playMicClicks then playMicClicks(false) end
end

RegisterCommand('+secondaryradiotalk', function()
    if secondaryRadioPressed or not secondaryEnabled() then return end

    -- Do not overlap PTTs. Both channels remain joined/listenable simultaneously,
    -- but a single microphone transmission is routed to one channel at a time.
    if radioPressed then return end

    secondaryRadioPressed = true
    MumbleClearVoiceTargetPlayers(voiceTarget)
    if addVoiceTargets then
        addVoiceTargets(secondaryRadioData, callData or {})
    end

    TriggerServerEvent('mm_radio:server:setSecondaryTalking', true)
    TriggerEvent('mm_radio:client:secondaryRadioActive', true)
    LocalPlayer.state:set('secondaryRadioActive', true, true)
    SendNUIMessage({ secondaryRadioChannel = secondaryRadioChannel, usingSecondaryRadio = true })
    if playMicClicks then playMicClicks(true) end

    local shouldPlayAnimation = secondaryRadioAnimEnabled()
    if shouldPlayAnimation then
        RequestAnimDict(secondaryRadioAnim.dict)
    end

    CreateThread(function()
        while secondaryRadioPressed do
            if not secondaryEnabled() or radioPressed then
                stopSecondaryTalk()
                break
            end

            -- Use the same shoulder-radio animation as primary pma-voice PTT.
            if shouldPlayAnimation and HasAnimDictLoaded(secondaryRadioAnim.dict) then
                local ped = PlayerPedId()
                if not IsEntityPlayingAnim(ped, secondaryRadioAnim.dict, secondaryRadioAnim.anim, 3) then
                    TaskPlayAnim(ped, secondaryRadioAnim.dict, secondaryRadioAnim.anim, 8.0, 2.0, -1, 50, 2.0, false, false, false)
                end
            end

            -- Force the game PTT control while this key is held, matching pma-voice's radio PTT.
            SetControlNormal(0, 249, 1.0)
            SetControlNormal(1, 249, 1.0)
            SetControlNormal(2, 249, 1.0)
            Wait(0)
        end
        if shouldPlayAnimation then
            RemoveAnimDict(secondaryRadioAnim.dict)
        end
    end)
end, false)

RegisterCommand('-secondaryradiotalk', function()
    stopSecondaryTalk()
end, false)

RegisterKeyMapping('+secondaryradiotalk', 'Talk over Secondary Radio', 'keyboard', GetConvar('voice_defaultSecondaryRadio', 'CAPITAL'))

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if secondaryRadioPressed then
        TriggerServerEvent('mm_radio:server:setSecondaryTalking', false)
    end
end)

exports('getSecondaryRadioChannel', function()
    return secondaryRadioChannel
end)
