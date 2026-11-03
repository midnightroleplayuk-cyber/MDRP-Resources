-- Per-radio voice filters, swapped into pma-voice's radio submix.
local pma = exports['pma-voice']
local FX = Config.VoiceEffects
local Submix = {}
local active

local PARAMS = { 'freq_low', 'freq_hi', 'fudge', 'rm_mod_freq', 'rm_mix', 'o_freq_lo', 'o_freq_hi' }

local function applyParams(id, fx)
    SetAudioSubmixEffectRadioFx(id, 0)
    SetAudioSubmixEffectParamInt(id, 0, joaat('default'), 1)
    for _, k in ipairs(PARAMS) do
        if fx[k] then SetAudioSubmixEffectParamFloat(id, 0, joaat(k), fx[k] + 0.0) end
    end
    local v = (fx.volume or 1.0) + 0.0
    SetAudioSubmixOutputVolumes(id, 0, v, v, v, v, 1.0, 1.0)
end

local function build(key)
    local id = CreateAudioSubmix(('vinewood_radio_%s'):format(key))
    applyParams(id, FX[key])
    AddAudioSubmixOutput(id, 0)
    Submix[key] = id
end

CreateThread(function()
    if not FX or not FX.enabled then return end
    build('tetra')
    build('civ')
end)

---Submix id for a radio type, used for bystanders hearing a loudspeaker
function GetRadioSubmix(key)
    return Submix[key]
end

---Switch the voice filter. key = 'tetra' | 'civ' | nil (restore pma default)
function SetRadioVoiceEffect(key)
    if not FX or not FX.enabled or active == key then return end
    active = key
    if key and Submix[key] then
        pcall(function() pma:setEffectSubmix('radio', Submix[key]) end)
    else
        pcall(function() pma:restoreDefaultSubmix('radio') end)
    end
end

-- Live tuning: /radiofx tetra fudge 0.4   |   /radiofx civ print
if Config.Debug then
    RegisterCommand('radiofx', function(_, args)
        local key, param, value = args[1], args[2], tonumber(args[3])
        local fx = FX and FX[key]
        if not fx or not Submix[key] then
            return print('^3/radiofx [tetra|civ] [param] [value]  or  /radiofx [tetra|civ] print^7')
        end
        if param == 'print' or not param then
            return print(('^2%s^7 = %s'):format(key, json.encode(fx)))
        end
        if value == nil or (param ~= 'volume' and not lib.table.contains(PARAMS, param)) then
            return print('^1Unknown param or value. Params: ' .. table.concat(PARAMS, ', ') .. ', volume^7')
        end
        fx[param] = value
        applyParams(Submix[key], fx)
        print(('^2%s.%s = %s^7'):format(key, param, value))
    end, false)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and active then
        pcall(function() pma:restoreDefaultSubmix('radio') end)
    end
end)
