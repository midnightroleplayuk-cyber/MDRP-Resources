local pma = exports['pma-voice']

local state = {
    open = false,
    on = false,
    talking = false,
    units = {},      -- [serverId] = unit
    ptp = false,
    emergency = false,
}

local civ = { open = false, on = false, channel = 0, talking = false }

local holdProp
local talkAnim = false
local alertBlips = {}

local Reasons = {
    no_item = 'You do not have a radio.',
    unauthorised = 'Terminal not authorised on this network.',
    off_duty = 'Sign on duty to use the radio.',
    grade = 'Your rank is not authorised for this terminal.',
    no_character = 'No character loaded.',
    reprogrammed = 'Terminal deregistered: your role changed. Power on again.',
    duplicate = 'Terminal deregistered: ISSI in use elsewhere.',
    remote = 'Terminal disabled by control.',
}

local function nui(action, data)
    SendNUIMessage({ action = action, data = data })
end

local function notify(text, kind)
    lib.notify({ title = Config.Brand, description = text, type = kind or 'inform' })
end

local function syncPmaEnabled()
    if Config.ManagePmaRadio then pma:setVoiceProperty('radioEnabled', state.on or civ.on) end
    SetRadioVoiceEffect(state.on and 'tetra' or civ.on and 'civ' or nil)
end

---------------------------------------------------------------------------
-- Animations / prop
---------------------------------------------------------------------------
local Anim = Config.Animations
local holdKind, talkKind, talkProp

local function animAllowed(cfg)
    return Anim.enabled and cfg and (not cache.vehicle or cfg.inVehicle)
end

local spawned = {}            -- every prop we've created, so nothing can be orphaned
local holdToken, talkToken = 0, 0

-- Loads the anim dict and prop model up front (this is the bit that can take a moment).
-- Returns false if the model isn't streamed.
local function preload(cfg, anim, withProp)
    if anim and anim.dict then lib.requestAnimDict(anim.dict) end
    if withProp and cfg.prop and cfg.prop.model then
        local model = joaat(cfg.prop.model)
        if not IsModelInCdimage(model) then
            print(('^1[vinewood_radio] prop model "%s" not found. Is it streamed?^7'):format(cfg.prop.model))
            return false
        end
        lib.requestModel(model)
    end
    return true
end

local lockdownWarned = false

local function dbg(...)
    if Config.Debug then print('^5[vinewood_radio]^7', ...) end
end

local function attachTo(obj, ped, p)
    local o, r = p.offset or vec3(0, 0, 0), p.rotation or vec3(0, 0, 0)
    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, p.bone or 28422),
        o.x + 0.0, o.y + 0.0, o.z + 0.0, r.x + 0.0, r.y + 0.0, r.z + 0.0,
        true, true, false, true, 1, true)
end

-- Assumes preload() already ran, so nothing in here waits
local function attachProp(cfg)
    local p = cfg.prop
    if not p or not p.model then return end
    local model = joaat(p.model)
    if not HasModelLoaded(model) then
        dbg(('prop "%s" not loaded, skipping'):format(p.model))
        return
    end

    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local obj = CreateObject(model, c.x, c.y, c.z + 0.2, true, true, false)

    if obj == 0 then
        -- Networked props are being blocked (usually sv_entityLockdown strict). Fall back to a local
        -- prop so at least the holder sees it in hand.
        obj = CreateObject(model, c.x, c.y, c.z + 0.2, false, false, false)
        if not lockdownWarned then
            lockdownWarned = true
            print('^3[vinewood_radio] Could not create a networked radio prop (sv_entityLockdown?). Using a local prop, other players won\'t see it.^7')
        end
    end
    if obj == 0 then return end

    SetEntityCollision(obj, false, false)
    SetEntityCanBeDamaged(obj, false)
    attachTo(obj, ped, p)
    spawned[obj] = true
    dbg(('prop %s -> entity %d, networked %s, attached %s, bone %d'):format(
        p.model, obj, tostring(NetworkGetEntityIsNetworked(obj)),
        tostring(IsEntityAttachedToEntity(obj, ped)), GetPedBoneIndex(ped, p.bone or 28422)))

    -- Ownership can settle a moment after creation and drop the attachment; re-attach if it does
    CreateThread(function()
        for _ = 1, 20 do
            Wait(50)
            if not spawned[obj] or not DoesEntityExist(obj) then return end
            if not IsEntityAttachedToEntity(obj, ped) then
                dbg('prop detached, re-attaching')
                attachTo(obj, ped, p)
            end
        end
    end)

    return obj
end

local function deleteProp(obj)
    if not obj then return end
    spawned[obj] = nil
    if DoesEntityExist(obj) then DeleteEntity(obj) end
end

-- Removes any of our props that aren't the one currently meant to be in hand
local function sweepProps(keep)
    for obj in pairs(spawned) do
        if obj ~= keep then deleteProp(obj) end
    end
end

local warnedAnims = {}

local function playAnim(a, blendIn)
    if not a or not a.dict then return end
    if not HasAnimDictLoaded(a.dict) then
        if not DoesAnimDictExist(a.dict) and not warnedAnims[a.dict] then
            warnedAnims[a.dict] = true
            print(('^1[vinewood_radio] animation dictionary "%s" does not exist. Check Config.Animations.^7'):format(a.dict))
        end
        return
    end
    local ped = cache.ped
    TaskPlayAnim(ped, a.dict, a.clip, blendIn or 3.0, 3.0, -1, a.flag or 49, 0, false, false, false)

    -- A wrong clip name fails silently in GTA, so check it actually started and say so once
    local key = a.dict .. '/' .. tostring(a.clip)
    if warnedAnims[key] ~= nil then return end
    CreateThread(function()
        Wait(250)
        local ok = IsEntityPlayingAnim(ped, a.dict, a.clip, 3)
        warnedAnims[key] = ok
        if not ok then
            print(('^1[vinewood_radio] animation "%s" in "%s" did not play. Is the clip name right? Check Config.Animations.^7'):format(tostring(a.clip), a.dict))
        end
    end)
end

local function stopAnim(a)
    if a and a.dict then StopAnimTask(cache.ped, a.dict, a.clip, 2.0) end
end

local function stopHoldAnim()
    holdToken = holdToken + 1          -- cancels a hold that's still loading
    deleteProp(holdProp)
    holdProp = nil
    if holdKind then stopAnim(Anim[holdKind].hold) end
    holdKind = nil
    sweepProps(talkProp)
end

---@param kind 'tetra'|'civ'
local function startHoldAnim(kind)
    local cfg = Anim[kind]
    if not animAllowed(cfg) then return end
    stopHoldAnim()
    local token = holdToken
    local hasProp = preload(cfg, cfg.hold, true)
    if token ~= holdToken then return end -- radio closed while loading
    holdKind = kind
    if hasProp then holdProp = attachProp(cfg) end
    playAnim(cfg.hold)
end

---@param kind? 'tetra'|'civ'
local function setTalkAnim(enable, kind)
    talkToken = talkToken + 1
    local token = talkToken

    if enable then
        local cfg = Anim[kind]
        if talkAnim or state.open or civ.open or not animAllowed(cfg) then return end
        local wantProp = cfg.talk and cfg.talk.prop
        -- talk.prop can be true (reuse the hold prop/position) or its own { model, bone, offset, rotation }
        local propCfg = type(wantProp) == 'table'
            and { prop = { model = wantProp.model or cfg.prop.model, bone = wantProp.bone, offset = wantProp.offset, rotation = wantProp.rotation } }
            or cfg
        local hasProp = preload(propCfg, cfg.talk, wantProp and true)
        if token ~= talkToken then return end -- released talk while loading
        talkKind = kind
        talkAnim = true
        playAnim(cfg.talk, 8.0)
        if wantProp and hasProp then talkProp = attachProp(propCfg) end
        return
    end

    if talkAnim then
        stopAnim(Anim[talkKind] and Anim[talkKind].talk)
    end
    deleteProp(talkProp)
    talkProp, talkKind = nil, nil
    talkAnim = false
    sweepProps(holdProp)
end

---------------------------------------------------------------------------
-- Open / close
---------------------------------------------------------------------------
local closeWalkie, pttKeyCode, stopSecondaryTx, clearSideRx -- defined further down

local function openRadio()
    if state.open then return end
    if civ.open then closeWalkie() end
    if IsPauseMenuActive() or IsEntityDead(cache.ped) then return end
    if Config.Item.required and not Bridge.HasItem(Config.Item.name) then
        return notify(Reasons.no_item, 'error')
    end
    state.open = true
    SetNuiFocus(true, true)
    nui('open', { talkKey = pttKeyCode(), talkKey2 = Config.Secondary.enabled and pttKeyCode('+vr_ptt2') or nil })
    setTalkAnim(false)
    startHoldAnim('tetra')
end

local nuiTalking = false
local function nuiTalk(down)
    if down == nuiTalking then return end
    if down and not (state.on or civ.on) then return end
    nuiTalking = down
    ExecuteCommand((down and '+' or '-') .. Config.PushToTalk.command)
end

-- Our own push-to-talk binding (rebindable in FiveM key bindings)
RegisterCommand('+vr_ptt', function() nuiTalk(true) end, false)
RegisterCommand('-vr_ptt', function() nuiTalk(false) end, false)
RegisterKeyMapping('+vr_ptt', 'Radio: push to talk', 'keyboard', Config.PushToTalk.defaultKey)

-- Translate the player's current binding into a browser KeyboardEvent.code for the open UI
local SPECIAL_KEYS = {
    b_1015 = 'AltLeft', b_1000 = 'ShiftLeft', b_2000 = 'Space', b_1013 = 'ControlLeft', b_1002 = 'Tab',
    b_1014 = 'ControlRight', b_1012 = 'CapsLock', b_1003 = 'Enter', b_1004 = 'Backspace',
    b_140 = 'Numpad4', b_141 = 'Numpad5', b_142 = 'Numpad6', b_143 = 'Numpad7', b_144 = 'Numpad8', b_145 = 'Numpad9',
    b_170 = 'F1', b_171 = 'F2', b_172 = 'F3', b_173 = 'F4', b_174 = 'F5', b_175 = 'F6',
    b_176 = 'F7', b_177 = 'F8', b_178 = 'F9', b_179 = 'F10', b_180 = 'F11', b_181 = 'F12',
    b_194 = 'ArrowUp', b_195 = 'ArrowDown', b_196 = 'ArrowLeft', b_197 = 'ArrowRight',
    b_198 = 'Delete', b_200 = 'Insert', b_210 = 'Delete', b_211 = 'Insert', b_212 = 'End',
    b_1008 = 'Home', b_1009 = 'PageUp', b_1010 = 'PageDown', b_1055 = 'Home', b_1056 = 'PageUp',
    b_131 = 'NumpadAdd', b_130 = 'NumpadSubtract',
}
local PUNCT = {
    [','] = 'Comma', ['.'] = 'Period', ['-'] = 'Minus', ['='] = 'Equal', [';'] = 'Semicolon', ['/'] = 'Slash',
    ['['] = 'BracketLeft', [']'] = 'BracketRight', ["'"] = 'Quote', ['`'] = 'Backquote', ['\\'] = 'Backslash', ['#'] = 'Backslash',
}

pttKeyCode = function(cmd)
    local btn = GetControlInstructionalButton(2, joaat(cmd or '+vr_ptt') | 0x80000000, true) or ''
    if btn:sub(1, 2) == 't_' then
        local k = btn:sub(3)
        if k:match('^%a$') then return 'Key' .. k:upper() end
        if k:match('^%d$') then return 'Digit' .. k end
        if k:match('^F%d%d?$') then return k end
        if PUNCT[k] then return PUNCT[k] end
    end
    return SPECIAL_KEYS[btn] or (cmd == '+vr_ptt2' and 'CapsLock' or 'AltLeft')
end

local function closeRadio()
    nuiTalk(false)
    if stopSecondaryTx then stopSecondaryTx() end
    if not state.open then return end
    state.open = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    nui('close')
    stopHoldAnim()
end

RegisterCommand(Config.Command, function()
    if state.open then closeRadio() else openRadio() end
end, false)
RegisterKeyMapping(Config.Command, 'Emergency services radio', 'keyboard', Config.OpenKey)

RegisterNetEvent('vinewood_radio:open', openRadio)
exports('useRadio', function() openRadio() end) -- ox_inventory client export
exports('IsRadioOn', function() return state.on end)
exports('IsRadioOpen', function() return state.open end)

---------------------------------------------------------------------------
-- Power
---------------------------------------------------------------------------
local function clearBlips()
    for _, b in ipairs(alertBlips) do if DoesBlipExist(b) then RemoveBlip(b) end end
    alertBlips = {}
end

local function localPowerOff(reason, fromNui)
    if not state.on and fromNui then return end
    state.on = false
    state.units = {}
    state.ptp = false
    state.emergency = false
    if stopSecondaryTx then stopSecondaryTx() end
    state.talking = false
    if clearSideRx then clearSideRx() end
    syncPmaEnabled()
    setTalkAnim(false)
    clearBlips()
    if not fromNui then
        nui('forceOff', { reason = reason, text = Reasons[reason] })
        if reason and Reasons[reason] then notify(Reasons[reason], 'error') end
    end
end

local function powerOn()
    local res = lib.callback.await('vinewood_radio:powerOn', false)
    if not res or not res.ok then return res or { ok = false, reason = 'error' } end

    if civ.on then -- server already released the walkie's channel
        civ.on, civ.channel, civ.talking = false, 0, false
        nui('civ:forceOff', { reason = 'switch' })
    end
    state.on = true
    for _, u in ipairs(res.directory or {}) do state.units[u.src] = u end
    syncPmaEnabled()
    state.volume = res.volume or 60
    state.tg2 = res.tg2
    pma:setRadioVolume(res.volume)
    pma:setCallVolume(res.volume)
    return res
end

RegisterNetEvent('vinewood_radio:forceOff', function(reason)
    localPowerOff(reason, false)
end)

---------------------------------------------------------------------------
-- NUI callbacks
---------------------------------------------------------------------------
RegisterNUICallback('ready', function(_, cb)
    cb({
        civ = {
            enabled = Config.CivRadio.enabled,
            min = Config.CivRadio.min,
            max = Config.CivRadio.max,
            decimals = Config.CivRadio.decimals,
            tones = Config.CivRadio.tones,
        },
        sounds = Config.Sounds,
        ui = Config.UI,
        emergencyHold = Config.Emergency.holdTime,
        emergency = Config.Emergency.enabled,
        powerHold = Config.PowerHoldTime,
        radioList = Config.RadioList,
        secondary = Config.Secondary.enabled,
        callsignMax = math.min(Config.CallsignMaxLength or 24, 32),
        ptp = Config.PTP.enabled,
    })
end)

RegisterNUICallback('ptt', function(data, cb)
    nuiTalk(data.down == true)
    cb(1)
end)

RegisterNUICallback('close', function(_, cb)
    closeRadio()
    cb(1)
end)

RegisterNUICallback('power', function(data, cb)
    if data.on then
        cb(powerOn())
    else
        TriggerServerEvent('vinewood_radio:powerOff')
        localPowerOff('user', true)
        cb({ ok = true })
    end
end)

RegisterNUICallback('setTalkgroup', function(data, cb)
    cb({ ok = lib.callback.await('vinewood_radio:setTalkgroup', false, data.id) == true })
end)

RegisterNUICallback('setVolume', function(data, cb)
    local v = math.floor(tonumber(data.volume) or 60)
    state.volume = v
    pma:setRadioVolume(v)
    pma:setCallVolume(v)
    TriggerServerEvent('vinewood_radio:setVolume', v)
    cb(1)
end)

RegisterNUICallback('setSecondary', function(data, cb)
    local res = lib.callback.await('vinewood_radio:setSecondary', false, data.id or false)
    if res and res.ok then state.tg2 = res.tg2 end
    cb(res or { ok = false })
end)

RegisterNUICallback('setSpeaker', function(data, cb)
    cb(lib.callback.await('vinewood_radio:setSpeaker', false, data.on == true) or { ok = false })
end)

RegisterNUICallback('setCallsign', function(data, cb)
    cb({ callsign = lib.callback.await('vinewood_radio:setCallsign', false, data.callsign) })
end)

RegisterNUICallback('ptpDial', function(data, cb)
    state.ptp = true
    TriggerServerEvent('vinewood_radio:ptpDial', data.issi)
    cb(1)
end)

RegisterNUICallback('ptpAnswer', function(_, cb)
    TriggerServerEvent('vinewood_radio:ptpAnswer')
    cb(1)
end)

RegisterNUICallback('ptpEnd', function(_, cb)
    TriggerServerEvent('vinewood_radio:ptpEnd')
    cb(1)
end)

local function location()
    local c = GetEntityCoords(cache.ped)
    local s1, s2 = GetStreetNameAtCoord(c.x, c.y, c.z)
    local street = GetStreetNameFromHashKey(s1)
    if s2 and s2 ~= 0 then street = street .. ' / ' .. GetStreetNameFromHashKey(s2) end
    return ('%s, %s'):format(street, GetLabelText(GetNameOfZone(c.x, c.y, c.z)))
end

RegisterNUICallback('emergency', function(_, cb)
    local ok = lib.callback.await('vinewood_radio:emergency', false, location())
    state.emergency = ok
    cb({ ok = ok })
end)

RegisterNUICallback('emergencyCancel', function(_, cb)
    state.emergency = false
    TriggerServerEvent('vinewood_radio:emergencyCancel')
    cb(1)
end)

---------------------------------------------------------------------------
-- Network events -> NUI
---------------------------------------------------------------------------
RegisterNetEvent('vinewood_radio:directory', function(list)
    if not state.on then return end
    state.units = {}
    for _, u in ipairs(list) do state.units[u.src] = u end
    nui('directory', list)
end)

RegisterNetEvent('vinewood_radio:ptpRinging', function(peer)
    nui('ptpRinging', peer)
end)

RegisterNetEvent('vinewood_radio:ptpIncoming', function(peer)
    state.ptp = true
    nui('ptpIncoming', peer)
    if not state.open then
        notify(('Individual call from %s (%s). Open your radio to answer.'):format(peer.callsign, peer.issi))
    end
end)

-- Control moved this terminal to another talkgroup
RegisterNetEvent('vinewood_radio:tgForced', function(id, by)
    if not state.on then return end
    nui('tgForced', { id = id, by = by })
    if not state.open then notify(('Talkgroup changed by %s.'):format(by or 'Control')) end
end)

RegisterNetEvent('vinewood_radio:ptpConnected', function()
    nui('ptpConnected')
end)

RegisterNetEvent('vinewood_radio:ptpEnded', function(reason)
    state.ptp = false
    nui('ptpEnded', { reason = reason })
end)

RegisterNetEvent('vinewood_radio:emergencyAlert', function(p)
    if not state.on then return end
    nui('emergencyAlert', p)
    notify(('EMERGENCY: %s on %s%s'):format(p.callsign, p.talkgroup, p.street ~= '' and (' at ' .. p.street) or ''), 'error')

    if Config.Emergency.blip and p.coords then
        local b = AddBlipForCoord(p.coords.x, p.coords.y, p.coords.z)
        SetBlipSprite(b, 161)
        SetBlipColour(b, 1)
        SetBlipScale(b, 1.2)
        SetBlipFlashes(b, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Emergency: ' .. p.callsign)
        EndTextCommandSetBlipName(b)
        alertBlips[#alertBlips + 1] = b
        SetTimeout(Config.Emergency.blipTime * 1000, function()
            if DoesBlipExist(b) then RemoveBlip(b) end
        end)
    end
end)

RegisterNetEvent('vinewood_radio:emergencyCleared', function(issi)
    nui('emergencyCleared', { issi = issi })
end)

---------------------------------------------------------------------------
-- pma-voice hooks: TX (own PTT) and RX (others talking)
---------------------------------------------------------------------------
local Spk = Config.Speaker
local extraTargets = {}

local function onTx(talking)
    if not (Spk.enabled or Config.Secondary.enabled) then return end
    TriggerServerEvent('vinewood_radio:tx', talking)
    if not talking then extraTargets = {} return end
    CreateThread(function()
        while (state.talking or civ.talking) and not state.talking2 do
            for i = 1, #extraTargets do
                MumbleAddVoiceTargetPlayerByServerId(Spk.voiceTarget, extraTargets[i])
            end
            Wait(200)
        end
    end)
end

RegisterNetEvent('vinewood_radio:speakerTargets', function(list)
    extraTargets = type(list) == 'table' and list or {}
    if state.talking or civ.talking or state.talking2 then
        for i = 1, #extraTargets do
            MumbleAddVoiceTargetPlayerByServerId(Spk.voiceTarget, extraTargets[i])
        end
    end
end)

AddEventHandler('pma-voice:radioActive', function(talking)
    if civ.on then
        if civ.talking == talking or civ.channel == 0 then return end
        civ.talking = talking
        nui('civ:tx', { active = talking })
        setTalkAnim(talking, 'civ')
        onTx(talking)
        return
    end
    if not state.on or state.talking == talking then return end
    state.talking = talking
    nui('tx', { active = talking })
    setTalkAnim(talking, 'tetra')
    onTx(talking)
end)

RegisterNetEvent('pma-voice:setTalkingOnRadio', function(plySource, enabled)
    if plySource == cache.serverId then return end
    if civ.on then return nui('civ:rx', { active = enabled }) end
    if not state.on then return end
    local u = state.units[plySource]
    nui('rx', { active = enabled, label = u and u.callsign or 'Unknown', src = plySource })
end)

---------------------------------------------------------------------------
-- Job / logout / death
---------------------------------------------------------------------------
Bridge.OnJobChange(function()
    if state.on then TriggerServerEvent('vinewood_radio:revalidate') end
end)

Bridge.OnLogout(function()
    if state.on then
        TriggerServerEvent('vinewood_radio:powerOff')
        localPowerOff(nil, false)
    end
    if civ.on then
        TriggerServerEvent('vinewood_radio:civPowerOff')
        civ.on, civ.channel = false, 0
        syncPmaEnabled()
        nui('civ:forceOff', {})
    end
    closeRadio()
    if closeWalkie then closeWalkie() end
end)

CreateThread(function()
    if Config.Sounds.disablePmaClicks then pma:setVoiceProperty('micClicks', false) end
    if Config.ManagePmaRadio then pma:setVoiceProperty('radioEnabled', false) end

    while true do
        Wait(1000)
        if IsEntityDead(cache.ped) then
            if state.open then closeRadio() end
            if civ.open then closeWalkie() end
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    stopHoldAnim()
    setTalkAnim(false)
    clearBlips()
    if state.open or civ.open then SetNuiFocus(false, false) end
    if state.on or civ.on then pma:setRadioChannel(0) end
end)

---------------------------------------------------------------------------
-- Civilian / gang handheld
---------------------------------------------------------------------------
local CivCfg = Config.CivRadio

local function openWalkie()
    if not CivCfg.enabled or civ.open then return end
    if IsPauseMenuActive() or IsEntityDead(cache.ped) then return end
    if not Bridge.HasItem(CivCfg.item) then
        return notify('You do not have a handheld radio.', 'error')
    end
    if state.open then closeRadio() end
    civ.open = true
    SetNuiFocus(true, true)
    nui('civ:open', { talkKey = pttKeyCode() })
    setTalkAnim(false)
    startHoldAnim('civ')
end

closeWalkie = function()
    nuiTalk(false)
    if not civ.open then return end
    civ.open = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    nui('civ:close')
    stopHoldAnim()
end

if CivCfg.enabled then
    RegisterCommand(CivCfg.command, function()
        if civ.open then closeWalkie() else openWalkie() end
    end, false)
    RegisterKeyMapping(CivCfg.command, 'Handheld radio', 'keyboard', CivCfg.openKey or '')
end

RegisterNetEvent('vinewood_radio:openWalkie', openWalkie)
exports('useWalkie', function() openWalkie() end) -- ox_inventory client export

RegisterNUICallback('civClose', function(_, cb)
    closeWalkie()
    cb(1)
end)

RegisterNUICallback('civPower', function(data, cb)
    if data.on then
        local res = lib.callback.await('vinewood_radio:civPowerOn', false)
        if res and res.ok then
            if state.on then localPowerOff('switch', false) end -- server already released the terminal
            civ.on, civ.channel = true, 0
            syncPmaEnabled()
            pma:setRadioVolume(tonumber(data.volume) or 50)
        end
        return cb(res or { ok = false })
    end
    TriggerServerEvent('vinewood_radio:civPowerOff')
    civ.on, civ.channel, civ.talking = false, 0, false
    setTalkAnim(false)
    syncPmaEnabled()
    cb({ ok = true })
end)

RegisterNUICallback('civSetChannel', function(data, cb)
    local res = lib.callback.await('vinewood_radio:civSetChannel', false, data.channel)
    if res and res.ok then civ.channel = res.channel end
    cb(res or { ok = false })
end)

RegisterNUICallback('civVolume', function(data, cb)
    pma:setRadioVolume(math.floor(tonumber(data.volume) or 50))
    cb(1)
end)

RegisterNetEvent('vinewood_radio:civForceOff', function()
    civ.on, civ.channel, civ.talking = false, 0, false
    syncPmaEnabled()
    setTalkAnim(false)
    nui('civ:forceOff', { reason = 'no_item' })
    notify('Your handheld radio was switched off.', 'error')
end)

RegisterNetEvent('vinewood_radio:civKicked', function()
    civ.channel = 0
    nui('civ:kicked')
end)

exports('IsWalkieOn', function() return civ.on end)

RegisterNUICallback('civSetSpeaker', function(data, cb)
    cb(lib.callback.await('vinewood_radio:civSetSpeaker', false, data.on == true) or { ok = false })
end)

RegisterNetEvent('vinewood_radio:civSpeaker', function(on)
    nui('civ:speaker', { on = on })
    if on then notify('No earpiece: your radio is back on loudspeaker.', 'inform') end
end)

---------------------------------------------------------------------------
-- Bystander: hearing someone else's loudspeaker radio
---------------------------------------------------------------------------
local hearing = {} -- [talkerServerId] = { listener = serverId, kind = 'tetra'|'civ' }
local hearingLoop = false

local function stopHearing(talker)
    if not hearing[talker] then return end
    hearing[talker] = nil
    MumbleSetVolumeOverrideByServerId(talker, -1.0)
    MumbleSetSubmixForServerId(talker, -1)
end

RegisterNetEvent('vinewood_radio:speakerHear', function(talker, listener, kind)
    hearing[talker] = { listener = listener, kind = kind }
    local submix = GetRadioSubmix and GetRadioSubmix(kind)
    if submix then MumbleSetSubmixForServerId(talker, submix) end

    if hearingLoop then return end
    hearingLoop = true
    CreateThread(function()
        while next(hearing) do
            local me = GetEntityCoords(cache.ped)
            for t, h in pairs(hearing) do
                local p = GetPlayerFromServerId(h.listener)
                local ped = p ~= -1 and GetPlayerPed(p) or 0
                if ped == 0 then
                    stopHearing(t)
                else
                    local d = #(me - GetEntityCoords(ped))
                    local vol = math.max(0.0, 1.0 - d / Spk.range) * Spk.volume
                    MumbleSetVolumeOverrideByServerId(t, vol + 0.0)
                end
            end
            Wait(100)
        end
        hearingLoop = false
    end)
end)

RegisterNetEvent('vinewood_radio:speakerStop', function(talker)
    stopHearing(talker)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for t in pairs(hearing) do stopHearing(t) end
end)

---------------------------------------------------------------------------
-- Radio list toggle
---------------------------------------------------------------------------
local listMoving = false

local function stopListMove()
    if not listMoving then return end
    listMoving = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end

if Config.RadioList.enabled then
    RegisterCommand(Config.RadioList.command, function() nui('toggleList') end, false)
    RegisterKeyMapping(Config.RadioList.command, 'Radio: show/hide channel list', 'keyboard', Config.RadioList.key or '')

    RegisterCommand(Config.RadioList.moveCommand or 'radiolistmove', function()
        if listMoving or IsPauseMenuActive() then return end
        if state.open then closeRadio() end
        if civ.open then closeWalkie() end
        listMoving = true
        SetNuiFocus(true, true)
        nui('listMove')
    end, false)
    RegisterKeyMapping(Config.RadioList.moveCommand or 'radiolistmove', 'Radio: move/resize channel list', 'keyboard', '')
end

RegisterNUICallback('listMoveDone', function(_, cb)
    stopListMove()
    cb(1)
end)

---------------------------------------------------------------------------
-- /radiodebug: on-screen readout of what pma-voice and the mic are doing.
-- For support: have the player hold talk with the radio closed, then open, and compare.
---------------------------------------------------------------------------
local debugOn = false

local function drawLine(text, y)
    SetTextFont(4)
    SetTextScale(0.0, 0.38)
    SetTextColour(255, 255, 255, 230)
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.015, y)
end

local function yn(v) return v and '~g~YES~w~' or '~r~NO~w~' end

RegisterCommand('radiodebug', function()
    debugOn = not debugOn
    if not debugOn then return end
    CreateThread(function()
        local lastTalking, lastMic = nil, nil
        while debugOn do
            local ply = PlayerId()
            local ls = LocalPlayer.state
            local mic = MumbleIsPlayerTalking(ply)
            local lines = {
                ('vinewood_radio debug   (/radiodebug to hide)'),
                ('Septra on: %s   Comtel on: %s   Screen open: %s'):format(yn(state.on), yn(civ.on), yn(state.open or civ.open)),
                ('Radio TX (our state): %s'):format(yn(state.talking or civ.talking)),
                ('pma radioActive: %s   radioChannel: %s   disableRadio: %s'):format(
                    yn(ls.radioActive), tostring(ls.radioChannel), tostring(ls.disableRadio)),
                ('Mic actually sending (Mumble): %s'):format(yn(mic)),
                ('Voice PTT control 249  pressed: %s   disabled-pressed: %s'):format(
                    yn(IsControlPressed(0, 249)), yn(IsDisabledControlPressed(0, 249))),
                ('Control 249 enabled: %s'):format(yn(IsControlEnabled(0, 249))),
                ('PTT bind: %s'):format(GetControlInstructionalButton(2, joaat('+vr_ptt') | 0x80000000, true) or '?'),
            }
            for i, l in ipairs(lines) do drawLine(l, 0.30 + (i - 1) * 0.028) end

            local talking = state.talking or civ.talking
            if talking ~= lastTalking or (talking and mic ~= lastMic) then
                print(('[vinewood_radio debug] TX=%s mic=%s screenOpen=%s pmaActive=%s channel=%s ctrl249=%s/%s enabled=%s'):format(
                    tostring(talking), tostring(mic), tostring(state.open or civ.open), tostring(ls.radioActive),
                    tostring(ls.radioChannel), tostring(IsControlPressed(0, 249)), tostring(IsDisabledControlPressed(0, 249)),
                    tostring(IsControlEnabled(0, 249))))
                lastTalking, lastMic = talking, mic
            end
            Wait(0)
        end
    end)
end, false)

---------------------------------------------------------------------------
-- Secondary talkgroup (Septra)
-- pma-voice only has one radio channel, so talking on the secondary is done here:
-- the server supplies everyone on that talkgroup as voice targets, and we hold
-- GTA's voice push-to-talk while the key is down (the same way pma-voice does).
---------------------------------------------------------------------------
local Sec = Config.Secondary

local function startSecondaryTx()
    if not Sec.enabled or state.talking2 then return end
    if not state.on or not state.tg2 or state.ptp or state.talking then return end
    if IsEntityDead(cache.ped) then return end

    state.talking2 = true
    extraTargets = {}
    nui('tx', { active = true, secondary = true })
    setTalkAnim(true, 'tetra')
    TriggerServerEvent('vinewood_radio:tx2', true)

    CreateThread(function()
        local tick = 0
        while state.talking2 do
            SetControlNormal(0, 249, 1.0)
            SetControlNormal(1, 249, 1.0)
            SetControlNormal(2, 249, 1.0)
            if tick % 10 == 0 then
                for i = 1, #extraTargets do
                    MumbleAddVoiceTargetPlayerByServerId(Spk.voiceTarget, extraTargets[i])
                end
            end
            tick = tick + 1
            if not state.on or IsEntityDead(cache.ped) then break end
            Wait(0)
        end
        if state.talking2 then stopSecondaryTx() end
    end)
end

stopSecondaryTx = function()
    if not state.talking2 then return end
    state.talking2 = false
    extraTargets = {}
    MumbleClearVoiceTargetPlayers(Spk.voiceTarget)
    TriggerServerEvent('vinewood_radio:tx2', false)
    nui('tx', { active = false, secondary = true })
    setTalkAnim(false)
end

if Sec.enabled then
    RegisterCommand('+vr_ptt2', startSecondaryTx, false)
    RegisterCommand('-vr_ptt2', function() stopSecondaryTx() end, false)
    RegisterKeyMapping('+vr_ptt2', 'Radio: talk on secondary talkgroup', 'keyboard', Sec.defaultKey or 'CAPITAL')
end

RegisterNUICallback('ptt2', function(data, cb)
    if data.down then startSecondaryTx() else stopSecondaryTx() end
    cb(1)
end)

-- Hearing a transmission pma-voice isn't delivering (someone on our secondary, or talking on their secondary)
local sideHearing = {} -- [talkerServerId] = slot

clearSideRx = function()
    for t in pairs(sideHearing) do
        MumbleSetVolumeOverrideByServerId(t, -1.0)
        MumbleSetSubmixForServerId(t, -1)
    end
    sideHearing = {}
end

RegisterNetEvent('vinewood_radio:sideRx', function(talker, active, slot)
    if active then
        if not state.on then return end
        sideHearing[talker] = slot
        MumbleSetVolumeOverrideByServerId(talker, math.max(0.0, math.min(1.0, (state.volume or 60) / 100)) + 0.0)
        local submix = GetRadioSubmix and GetRadioSubmix('tetra')
        if submix then MumbleSetSubmixForServerId(talker, submix) end
    else
        slot = sideHearing[talker]
        if not slot then return end
        sideHearing[talker] = nil
        MumbleSetVolumeOverrideByServerId(talker, -1.0)
        MumbleSetSubmixForServerId(talker, -1)
    end
    local u = state.units[talker]
    nui('rx', { active = active, label = u and u.callsign or 'Unknown', src = talker, slot = slot })
end)
