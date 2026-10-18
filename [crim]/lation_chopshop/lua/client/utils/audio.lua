local Audio = {}

local AUDIO_BANK = 'audiodirectory/chopshop_wheel'
local SOUNDSET = 'chopshop_wheel_set'
local SOUND_NAME = 'wheel-minigame'
local CLIP_MS = 2590

local bankLoaded = false
local holding = false
local loopToken = 0
local soundId = nil

local function isEnabled()
    local runtime = require 'shared.runtime'
    local wheel = runtime.minigame and runtime.minigame.wheel
    if not wheel then return true end
    if wheel.audioEnabled == nil then return true end
    return wheel.audioEnabled
end

function Audio.loadWheelBank()
    if not isEnabled() or bankLoaded then return end
    if not RequestScriptAudioBank(AUDIO_BANK, false) then
        while not RequestScriptAudioBank(AUDIO_BANK, false) do Wait(0) end
    end
    bankLoaded = true
end

function Audio.unloadWheelBank()
    Audio.stopWheelDrillLoop()
    if bankLoaded then
        ReleaseNamedScriptAudioBank(AUDIO_BANK)
        bankLoaded = false
    end
end

function Audio.stopWheelDrillLoop()
    holding = false
    loopToken = loopToken + 1
    if soundId then
        StopSound(soundId)
        ReleaseSoundId(soundId)
        soundId = nil
    end
end

function Audio.startWheelDrillLoop(entity)
    if not isEnabled() or not entity or not DoesEntityExist(entity) then return end
    if not bankLoaded then Audio.loadWheelBank() end

    Audio.stopWheelDrillLoop()
    holding = true
    local token = loopToken

    CreateThread(function()
        while holding and token == loopToken do
            if soundId then
                StopSound(soundId)
                ReleaseSoundId(soundId)
            end
            soundId = GetSoundId()
            PlaySoundFromEntity(soundId, SOUND_NAME, entity, SOUNDSET, false, 0)
            Wait(CLIP_MS)
        end
    end)
end

return Audio
