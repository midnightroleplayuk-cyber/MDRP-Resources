local MumbleIsPlayerTalking = MumbleIsPlayerTalking
local NetworkIsPlayerTalking = NetworkIsPlayerTalking

local talking = false

---@param volume? number # The call volume, 0.0 - 1.0
function SetCallVolume(volume)
    volume = (volume or (settings?.sound?.callVolume or 0.5)) / 1

    local volumePercent = math.clamp(math.floor(volume * 100 + 0.5), 0, 100)

    debugprint("SetCallVolume", volume, volumePercent)

    local success, errorMessage = pcall(function()
        if Config.Voice.System == "pma" then
            exports["pma-voice"]:setCallVolume(volumePercent)
        end
    end)

    if not success then
        infoprint("error", "Failed to set call volume:", errorMessage)
    end
end

function AddToCall(callId)
    debugprint("AddToCall", callId)

    local success, errorMessage = pcall(function()
        if Config.Voice.System == "pma" then
            exports["pma-voice"]:addPlayerToCall(callId)
        elseif Config.Voice.System == "mumble" then
            exports["mumble-voip"]:addPlayerToCall(callId)
        elseif Config.Voice.System == "salty" then
            TriggerServerEvent("phone:voice:addToCall", callId)
        elseif Config.Voice.System == "toko" then
            exports["tokovoip_script"]:addPlayerToRadio(callId)
        end
    end)

    if not success then
        infoprint("error", "Failed to join call:", errorMessage)
    end

    SetCallVolume()
end

function RemoveFromCall(callId)
    debugprint("Leaving call", callId)

    local success = pcall(function()
        if Config.Voice.System == "pma" then
            exports["pma-voice"]:removePlayerFromCall()
        elseif Config.Voice.System == "mumble" then
            exports["mumble-voip"]:removePlayerFromCall()
        elseif Config.Voice.System == "salty" then
            TriggerServerEvent("phone:voice:removeFromCall", callId)
        elseif Config.Voice.System == "toko" then
            exports["tokovoip_script"]:removePlayerFromRadio(callId)
        end
    end)

    if not success then
        infoprint("error", "Failed to leave call (unsupported voice script)")
    end
end

---@param muted boolean
---@param callId number
function SetCallMuted(muted, callId)
    if muted then
        RemoveFromCall(callId)
    else
        AddToCall(callId)
    end

    TriggerServerEvent("phone:phone:toggleMute", muted)
end

function ToggleSpeaker(enabled)
    if Config.Voice.System == "salty" then
        TriggerServerEvent("phone:voice:toggleSpeaker", enabled)
    end
end

function IsTalking()
    if Config.Voice.System == "pma" or Config.Voice.System == "mumble" then
        return MumbleIsPlayerTalking(PlayerId())
    elseif Config.Voice.System == "salty" then
        return talking
    else
        return NetworkIsPlayerTalking(PlayerId())
    end
end

local function ConvertProximityToUnits(proximity)
    return -0.3045 * proximity^2 + 5.016 * proximity - 2.5919
end

function GetVoiceMaxDistance()
    local proximity = MumbleGetTalkerProximity()

    return ConvertProximityToUnits(proximity)
end

function GetVoiceVolume(distance)
    local maxDistance = GetVoiceMaxDistance()

    if distance <= 0 then
        return 1.0
    elseif distance >= maxDistance then
        return 0.0
    end

    local volume = (1 - (distance / maxDistance)) ^ 2

    return math.floor(volume * 100) / 100
end

RegisterNUICallback("waitUntilNotTalking", function(_, cb)
    if not Config.Voice.WaitUntilNotTalking then
        return cb(true)
    end

    debugprint("Waiting until not talking...")

    while IsTalking() do
        Wait(0)
    end

    debugprint("Not talking anymore, proceeding")
    cb(true)
end)

-- This thread is used to send the talking state to the frontend, used to record audio only when talking in-game
RegisterNUICallback("isTalking", function(_, cb)
    cb(IsTalking())
end)

local sendTalkingInterval = Interval:new(function()
    local isTalking = IsTalking()

    if isTalking and not talking then
        talking = true

        SendNUIAction("camera:toggleMicrophone", talking)
    elseif not isTalking and talking then
        talking = false

        SendNUIAction("camera:toggleMicrophone", talking)
    end
end, 100, false)

function sendTalkingInterval.onStart()
    debugprint("Started send talking interval")
end

function sendTalkingInterval.onStop()
    debugprint("Stopped send talking interval")
end

RegisterNUICallback("toggleTalkingInterval", function(enabled, cb)
    sendTalkingInterval:toggle(enabled)

    cb("ok")
end)

if Config.Voice.System == "salty" then
    RegisterNetEvent("SaltyChat_TalkStateChanged", function(isTalking)
        talking = isTalking

        if sendTalkingInterval.enabled then
            SendNUIAction("camera:toggleMicrophone", talking)
        end
    end)
end

-- proximity

local submixes = {
    ---@type number?
    call = nil,
    ---@type { submixId: number, source?: number }[] | nil
    speaker = nil
}

CreateThread(function()
    local callEffect = {
        [`freq_low`] = 200.0,
        [`freq_hi`] = 4500.0,
        [`o_freq_lo`] = 150.0,
        [`o_freq_hi`] = 5000.0,
        [`fudge`] = 0.2,
        [`rm_mod_freq`] = 150.0,
        [`rm_mix`] = 0.04,
    }

    if Config.Voice.CallEffects then
        local submixId = CreateAudioSubmix("lb-phone-call")

        SetAudioSubmixEffectRadioFx(submixId, 0)
        ---@diagnostic disable-next-line: param-type-mismatch
        SetAudioSubmixEffectParamInt(submixId, 0, `default`, 1)

        for hash, value in pairs(callEffect) do
            ---@diagnostic disable-next-line: param-type-mismatch
            SetAudioSubmixEffectParamFloat(submixId, 0, hash, value)
        end

        SetAudioSubmixOutputVolumes(submixId, 0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
        AddAudioSubmixOutput(submixId, 0)

        submixes.call = submixId
    end

    if Config.Voice.HearNearby and Config.Voice.SpatialAudio then
        local submixesToCreate = math.max(Config.Voice.SpatialAudioSubmixes or 1, 1)

        submixes.speaker = {}

        for i = 1, submixesToCreate do
            local submixId = CreateAudioSubmix("lb-phone-speaker-" .. i)

            submixes.speaker[i] = { submixId = submixId }

            if Config.Voice.CallEffects then
                SetAudioSubmixEffectRadioFx(submixId, 0)
                ---@diagnostic disable-next-line: param-type-mismatch
                SetAudioSubmixEffectParamInt(submixId, 0, `default`, 1)

                for hash, value in pairs(callEffect) do
                    ---@diagnostic disable-next-line: param-type-mismatch
                    SetAudioSubmixEffectParamFloat(submixId, 0, hash, value)
                end
            end

            SetAudioSubmixOutputVolumes(submixId, 0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)
            AddAudioSubmixOutput(submixId, 0)
        end
    end
end)

---A lookup table of sources that we are listening to since they are close to the InstaPic live host we are watching
---@type { [number]: boolean }
local instapicProximityListeningTo = {}
---<b>Key:</b> The source that we should hear/talk to
---<br><b>Value:</b> whether or not we should hear them. if it's a number, it's the entity to play the sound from
---@type { [number]: { audible: boolean, phoneCall?: boolean, source?: number, submix?: number } }
local voiceTargets = {}

local voiceTargetsInterval = Interval:new(function()
    local currentTargets = table.clone(voiceTargets)
    local baseVolume = (settings?.sound?.volume or 0.5) / 1
    local callVolume = (settings?.sound?.callVolume or 0.5) / 1

    for source, audio in pairs(currentTargets) do
        local instapic = instapicProximityListeningTo[source] or table.contains(watchingSources, source)

        MumbleAddVoiceTargetPlayerByServerId(1, source)

        if audio.submix then
            MumbleSetSubmixForServerId(source, audio.submix)
        end

        if instapic then
            MumbleSetVolumeOverrideByServerId(source, baseVolume)
        else
            local targetVolume = audio.audible and callVolume * 0.7 or -1.0

            if audio.audible and audio.phoneCall and audio.submix and audio.source and Config.Voice.SpatialAudio then
                MumbleSetVolumeOverrideByServerId(source, 1.0)
            else
                MumbleSetVolumeOverrideByServerId(source, targetVolume)
            end
        end
    end
end, 250, false)

local spatialAudioInterval = Interval:new(function(self)
    local camCoords = GetFinalRenderedCamCoord()
    local camRot = GetFinalRenderedCamRot(2)
    local shouldRemove = true

    for i = 1, #submixes.speaker do
        local submix = submixes.speaker[i]

        if submix.source then
            local player = GetPlayerFromServerId(submix.source)
            local ped = player and GetPlayerPed(player)

            if ped and DoesEntityExist(ped) and ped ~= PlayerPedId() then
                local speakerVolumes = CalculateSpatialAudio(camCoords, camRot, GetEntityCoords(ped), 15.0)

                -- debugprint("Spatial audio volumes for", submix.source, speakerVolumes)
                SetAudioSubmixOutputVolumes(submix.submixId, 0, speakerVolumes.frontLeft, speakerVolumes.frontRight, speakerVolumes.rearLeft, speakerVolumes.rearRight, 0.0, 0.0)
            end

            shouldRemove = false
        end
    end

    if shouldRemove then
        self:toggle(false)
    end
end, 50, false)

function spatialAudioInterval.onStart()
    debugprint("Started spatial audio interval")
end

function spatialAudioInterval.onStop()
    debugprint("Stopped spatial audio interval")
end

---@param source number
local function GetSpatialAudioSubmix(source)
    if type(submixes.speaker) ~= "table" then
        return
    end

    for i = 1, #submixes.speaker do
        local submix = submixes.speaker[i]

        if submix.source and submix.source == source then
            return submix
        end
    end
end

---@param source number
function SetSpatialAudioSubmixForSource(source)
    if type(submixes.speaker) ~= "table" then
        return
    end

    if GetSpatialAudioSubmix(source) then
        return
    end

    ---@type number?
    local foundSubmix

    for i = 1, #submixes.speaker do
        local submix = submixes.speaker[i]

        if not submix.source then
            submix.source = source
            foundSubmix = submix.submixId

            break
        end
    end

    if not foundSubmix then
        return
    end

    debugprint("Setting spatial audio submix for", source, foundSubmix)

    for targetSource, audio in pairs(voiceTargets) do
        if audio.source == source then
            audio.submix = foundSubmix

            MumbleSetSubmixForServerId(targetSource, foundSubmix)
        end
    end

    spatialAudioInterval:toggle(true)
end

---@param source number
function ResetSpatialAudioSubmixForSource(source)
    if type(submixes.speaker) ~= "table" then
        return
    end

    local submix = GetSpatialAudioSubmix(source)

    if not submix then
        return
    end

    debugprint("Resetting spatial audio submix for", source, submix.submixId)

    for targetSource, audio in pairs(voiceTargets) do
        if audio.source and audio.source == source then
            audio.submix = nil

            MumbleSetSubmixForServerId(targetSource, -1)
        end
    end

    submix.source = nil
end

RegisterNetEvent("phone:phone:setCallEffect", function(source, enabled)
    if (Config.Voice.System ~= "pma" and Config.Voice.System ~= "mumble") or not submixes.call then
        return
    end

    Wait(500)
    MumbleSetSubmixForServerId(source, enabled and submixes.call or -1)
    debugprint("Set call effect for", source, enabled)
end)

---@param options { sources: number | number[], audio?: boolean, phoneCall?: boolean, playFromSource?: number }
RegisterNetEvent("phone:phone:addVoiceTarget", function(options)
    local sources = options.sources

    debugprint("Adding voice target(s)", sources, options)

    if type(sources) ~= "table" then
        sources = { sources }
    end

    local mySource = GetPlayerServerId(PlayerId())

    if options.playFromSource == mySource then
        options.playFromSource = nil
    end

    for i = 1, #sources do
        local id = sources[i]

        if id == mySource then
            goto continue
        end

        local oldVoiceTarget = voiceTargets[id]

        ---@type number?
        local submix

        if options.phoneCall then
            if type(submixes.speaker) == "table" and options.playFromSource then
                submix = GetSpatialAudioSubmix(options.playFromSource)?.submixId

                if submixes.call and not submix then
                    MumbleSetSubmixForServerId(id, submixes.call)
                end
            else
                submix = submixes.call
            end
        end

        voiceTargets[id] = {
            audible = options.audio == true or (oldVoiceTarget and oldVoiceTarget.audible) or false,
            phoneCall = options.phoneCall == true or (oldVoiceTarget and oldVoiceTarget.phoneCall),
            source = options.playFromSource or (oldVoiceTarget and oldVoiceTarget.source),
            submix = submix or (oldVoiceTarget and oldVoiceTarget.submix),
        }

        if submix then
            MumbleSetSubmixForServerId(id, submix)
        end

        ::continue::
    end

    voiceTargetsInterval:toggle(next(voiceTargets) ~= nil)
end)

---@param sources number | number[]
---@param phoneCall? boolean
RegisterNetEvent("phone:phone:removeVoiceTarget", function(sources, phoneCall)
    debugprint("Removing voice target(s)", sources, phoneCall)

    if type(sources) ~= "table" then
        sources = { sources }
    end

    for i = 1, #sources do
        local id = sources[i]

        if id == GetPlayerServerId(PlayerId()) then
            goto continue
        end

        voiceTargets[id] = nil

        MumbleRemoveVoiceTargetPlayerByServerId(1, id)
        MumbleSetVolumeOverrideByServerId(id, -1.0)

        if phoneCall and (Config.Voice.CallEffects or Config.Voice.SpatialAudio) then
            MumbleSetSubmixForServerId(id, -1)
        end

        debugprint("Removed voice target", id)

        ::continue::
    end

    voiceTargetsInterval:toggle(next(voiceTargets) ~= nil)
end)

---@param sources number | number[]
---@param audible boolean
RegisterNetEvent("phone:phone:setTargetsAudible", function(sources, audible)
    debugprint("Setting voice target(s) audible =", audible, sources)

    if type(sources) ~= "table" then
        sources = { sources }
    end

    for i = 1, #sources do
        local id = sources[i]

        if id == GetPlayerServerId(PlayerId()) then
            goto continue
        end

        local voiceTarget = voiceTargets[id]

        if voiceTarget then
            voiceTarget.audible = audible == true

            debugprint("Set target volume for", id, audible)
        end

        ::continue::
    end

    voiceTargetsInterval:toggle(next(voiceTargets) ~= nil)
end)

---This event is triggered when "source" enters the proximity of "liveHost"
RegisterNetEvent("phone:instagram:enteredProximity", function(source, liveHost)
    if not table.contains(watchingSources, liveHost) then -- if we're not watching "liveHost", don't listen to "source"
        return
    end

    local player = GetPlayerFromServerId(source)

    if player and player ~= -1 and #(GetEntityCoords(GetPlayerPed(player)) - GetEntityCoords(PlayerPedId())) <= 15 then
        return
    end

    debugprint("Adding live target", source)

    voiceTargets[source] = { audible = true }
    instapicProximityListeningTo[source] = true

    voiceTargetsInterval:toggle(next(voiceTargets) ~= nil)
end)

---This event is triggered when "source" leaves the proximity of "liveHost"
RegisterNetEvent("phone:instagram:leftProximity", function(source, liveHost)
    voiceTargets[source] = nil
    instapicProximityListeningTo[source] = nil

    MumbleRemoveVoiceTargetPlayerByServerId(1, source)
    MumbleSetVolumeOverrideByServerId(source, -1.0)
    debugprint("Removing live target", source)

    voiceTargetsInterval:toggle(next(voiceTargets) ~= nil)
end)

if Config.Debug then
    RegisterCommand("phonevoicetargets", function(...)
        debugprint("Current voice targets:", voiceTargets)
    end, false)
end
