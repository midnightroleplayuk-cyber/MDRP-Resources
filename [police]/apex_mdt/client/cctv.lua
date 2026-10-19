--[[
    Apex MDT - CCTV (self-contained)
    Opens a scripted security camera at each configured location and lets
    the officer/medic watch it "through the tablet": the game camera renders
    full-screen behind a tablet CCTV overlay (REC HUD, scanlines, controls).
    Arrows rotate/tilt · scroll zooms · Q/E switch cameras · Esc/Backspace exit.
    Pure game natives, no external dependency.
]]

CCTV = CCTV or {}

local cfg = Config.cctv or {}
local active   = false
local viewCam  = nil
local list, idx = {}, 1
local heading, pitch, fov = 0.0, -10.0, 55.0

local function buildList(forMode)
    list = {}
    for _, c in ipairs(cfg.cameras or {}) do
        if (not forMode) or (not c.mode) or c.mode == forMode or c.mode == 'both' or forMode == 'both' then
            list[#list + 1] = c
        end
    end
end

local function applyCamera()
    local c = list[idx]; if not c then return end
    heading = c.heading or 0.0
    pitch   = c.pitch or -10.0
    fov     = 55.0
    if not viewCam then
        viewCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', c.coords.x, c.coords.y, c.coords.z, pitch, 0.0, heading, fov, false, 0)
        SetCamActive(viewCam, true)
        RenderScriptCams(true, false, 0, true, false)
    else
        SetCamCoord(viewCam, c.coords.x, c.coords.y, c.coords.z)
        SetCamRot(viewCam, pitch, 0.0, heading, 2)
        SetCamFov(viewCam, fov)
    end
    -- Stream the world around the camera so you see LIVE gameplay there
    -- (peds/vehicles) even when you're far away.
    SetFocusPosAndVel(c.coords.x, c.coords.y, c.coords.z, 0.0, 0.0, 0.0)
    RequestCollisionAtCoord(c.coords.x, c.coords.y, c.coords.z)
    SendNUIMessage({ action = 'cctvCam', payload = { label = c.label, index = idx, total = #list } })
end

function CCTV.Open(id)
    if active or not cfg.enabled then return end
    local found
    for _, c in ipairs(cfg.cameras or {}) do if c.id == id then found = c; break end end
    if not found then return end

    buildList(found.mode)
    idx = 1
    for i, c in ipairs(list) do if c.id == id then idx = i; break end end

    active = true
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'cctvShow' })   -- JS hides the tablet, shows the CCTV frame

    DoScreenFadeOut(220); while not IsScreenFadedOut() do Wait(0) end
    if cfg.timecycle and cfg.timecycle ~= '' then
        SetTimecycleModifier(cfg.timecycle); SetTimecycleModifierStrength(0.4)
    end
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, false)
    applyCamera()
    DoScreenFadeIn(220)

    CreateThread(function()
        local spd = cfg.rotateSpeed or 1.4
        while active do
            DisableAllControlActions(0)
            HideHudAndRadarThisFrame()
            if IsDisabledControlPressed(0, 174) then heading = heading + spd end   -- ← arrow
            if IsDisabledControlPressed(0, 175) then heading = heading - spd end   -- → arrow
            if IsDisabledControlPressed(0, 172) then pitch = math.min(pitch + spd, 25.0) end  -- ↑ arrow
            if IsDisabledControlPressed(0, 173) then pitch = math.max(pitch - spd, -80.0) end -- ↓ arrow
            if IsDisabledControlPressed(0, 241) then fov = math.max(20.0, fov - 1.0) end       -- scroll up (zoom in)
            if IsDisabledControlPressed(0, 242) then fov = math.min(70.0, fov + 1.0) end       -- scroll down
            SetCamRot(viewCam, pitch, 0.0, heading, 2)
            SetCamFov(viewCam, fov)
            if #list > 1 then
                if IsDisabledControlJustReleased(0, 38) then idx = (idx % #list) + 1; applyCamera() end       -- E next
                if IsDisabledControlJustReleased(0, 44) then idx = ((idx - 2) % #list) + 1; applyCamera() end -- Q prev
            end
            if IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(0, 200) or IsDisabledControlJustReleased(0, 322) then
                active = false
            end
            Wait(0)
        end

        DoScreenFadeOut(200); while not IsScreenFadedOut() do Wait(0) end
        RenderScriptCams(false, false, 0, true, false)
        if viewCam then DestroyCam(viewCam, false); viewCam = nil end
        ClearTimecycleModifier()
        ClearFocus()
        SetEntityVisible(ped, true, false)
        FreezeEntityPosition(ped, false)
        SendNUIMessage({ action = 'cctvHide' })
        SetNuiFocus(true, true)   -- back to the tablet
        DoScreenFadeIn(220)
    end)
end

RegisterNUICallback('cctv_open', function(data, cb)
    cb({})
    if data and data.id then CCTV.Open(data.id) end
end)

AddEventHandler('onResourceStop', function(r)
    if r ~= GetCurrentResourceName() then return end
    if active then
        active = false
        if viewCam then RenderScriptCams(false, false, 0, true, false); DestroyCam(viewCam, false); viewCam = nil end
        ClearTimecycleModifier(); ClearFocus()
        local ped = PlayerPedId()
        SetEntityVisible(ped, true, false); FreezeEntityPosition(ped, false)
    end
end)
