--[[
    Apex MDT - Bodycam (police)
    • Install the bodycam from the tablet (one-time, persisted).
    • Activate it → you broadcast a live feed; a minimal REC overlay stays on
      your screen even with the tablet closed.
    • View a colleague's live bodycam from the tablet (spectate-based; shows
      their feed live, first-person when their ped is streamed).
]]

Bodycam = Bodycam or {}
local recording = false
local viewing   = false

function Bodycam.IsOn() return recording end

-- ─── Your own recording (broadcasts a viewable feed) ─────
function Bodycam.Set(on)
    if not (Config.bodycam and Config.bodycam.enabled) then return end
    on = on == true
    local ok, applied = Apex.Callback('apex_mdt:bodycamSetActive', on)
    if not ok then
        Apex.Notify('Install the bodycam first (Bodycam app).', 'error')
        return
    end
    recording = applied == true
    SendNUIMessage({ action = recording and 'bodycamOn' or 'bodycamOff' })
end

function Bodycam.Toggle() Bodycam.Set(not recording) end

RegisterNUICallback('bodycam_toggle', function(_, cb) cb({}); Bodycam.Toggle() end)
RegisterCommand('bodycam', function() Bodycam.Toggle() end, false)

RegisterNetEvent('apex_mdt:forceDuty', function(state)
    if Config.bodycam and Config.bodycam.autoOnDuty then Bodycam.Set(state == true) end
end)

-- ─── View another officer's live bodycam (spectate) ──────
function Bodycam.View(serverId)
    if viewing then return end
    local tgt = GetPlayerFromServerId(tonumber(serverId) or -1)
    if tgt == -1 or tgt == PlayerId() then
        Apex.Notify('That unit is not reachable.', 'error'); return
    end
    viewing = true
    SendNUIMessage({ action = 'captureStart' })          -- hide the tablet
    SendNUIMessage({ action = 'bodycamViewOn', payload = { name = GetPlayerName(tgt) } })
    SetNuiFocus(false, false)
    local myPed = PlayerPedId()
    DoScreenFadeOut(300); while not IsScreenFadedOut() do Wait(0) end
    FreezeEntityPosition(myPed, true)
    SetEntityVisible(myPed, false, false)
    NetworkSetInSpectatorMode(true, GetPlayerPed(tgt))
    if Config.cctv and Config.cctv.timecycle ~= '' then SetTimecycleModifier('default') end
    DoScreenFadeIn(300)
    CreateThread(function()
        while viewing do
            HideHudAndRadarThisFrame()
            for _, c in ipairs({ 200, 177, 202, 322, 24, 25, 140, 141, 142 }) do DisableControlAction(0, c, true) end
            local tp = GetPlayerPed(tgt)
            if tp and tp ~= 0 then NetworkSetInSpectatorMode(true, tp) end
            -- stop if the target leaves, stops recording, or we press exit
            if GetPlayerFromServerId(tonumber(serverId)) == -1 then viewing = false end
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 177) or IsDisabledControlJustPressed(0, 202) then viewing = false end
            Wait(0)
        end
        NetworkSetInSpectatorMode(false, myPed)
        SetEntityVisible(myPed, true, false)
        FreezeEntityPosition(myPed, false)
        ClearTimecycleModifier()
        SendNUIMessage({ action = 'bodycamViewOff' })
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'captureEnd' })         -- show the tablet again
    end)
end

RegisterNUICallback('bodycam_view', function(data, cb)
    cb({})
    if data and data.serverId then Bodycam.View(data.serverId) end
end)

AddEventHandler('onResourceStop', function(r)
    if r ~= GetCurrentResourceName() then return end
    if recording then recording = false; SendNUIMessage({ action = 'bodycamOff' }) end
    if viewing then
        viewing = false
        local p = PlayerPedId()
        NetworkSetInSpectatorMode(false, p)
        SetEntityVisible(p, true, false); FreezeEntityPosition(p, false)
    end
end)
