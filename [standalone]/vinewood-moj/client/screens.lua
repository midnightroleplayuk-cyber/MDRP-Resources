-- Courtroom screens: a browser (DUI) running web/screen.html, shown on the courtroom's TVs.
-- Created only while you're inside a courtroom that has screens, so footage (and its sound)
-- is only seen and heard in that room.
--
-- Config.Courtrooms.ScreenRender:
--   'overlay'      (default) the picture is drawn as a panel over each TV you placed or picked.
--                  Only those TVs show it, so the same model can be used in any number of rooms.
--   'rendertarget' the TV model's own screen texture is replaced. GTA ties this to the model, so
--                  every TV of that model in view shows the same thing. Only for one room per model.
local CR = Config.Courtrooms or {}
if CR.enabled == false then return end

local OVERLAY = (CR.ScreenRender or 'overlay') ~= 'rendertarget'
local PAGE = ('https://cfx-nui-%s/web/screen.html'):format(GetCurrentResourceName())
local TXD, TEX            -- texture names for the current browser instance
local serial = 0

local playing = {}      -- [roomId] = what's showing (from the server)
local dui
local curRoom, curKey
local adjusting = false
local targets = {}      -- [targetName] = render target id (rendertarget mode)

local function send(msg) if dui then SendDuiMessage(dui, json.encode(msg)) end end

local function ensureDui()
    if dui then return end
    local res = CR.ScreenResolution or { 1280, 720 }
    dui = CreateDui(PAGE, res[1], res[2])
    local t = GetGameTimer() + 5000
    while not IsDuiAvailable(dui) and GetGameTimer() < t do Wait(50) end
    -- A new name each time: a runtime texture stays bound to the browser it was made from.
    serial = serial + 1
    TXD, TEX = ('vwmoj_scr_txd_%d'):format(serial), ('vwmoj_scr_tex_%d'):format(serial)
    CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd(TXD), TEX, GetDuiHandle(dui))
    Wait(600) -- let the page finish loading before the first message
end

local function destroyDui()
    if dui then DestroyDui(dui) end
    dui, curKey = nil, nil
end

local function modelHash(s)
    if s.mode == 'pick' and s.mapModel then return s.mapModel end
    local m = (CR.ScreenModels or {})[s.model or 1]
    return m and joaat(m.model)
end

---------------------------------------------------------------------------
-- Overlay geometry: a panel in front of the TV, relative to its position and heading.
-- geo = { w, h, up, side, fwd, flip } in metres.
---------------------------------------------------------------------------
local dimsCache = {}

local function dims(hash)
    if dimsCache[hash] then return dimsCache[hash][1], dimsCache[hash][2] end
    if not hash or hash == 0 or not IsModelInCdimage(hash) then return vec3(-0.6, -0.05, 0.0), vec3(0.6, 0.05, 0.7) end
    RequestModel(hash)
    local t = GetGameTimer() + 3000
    while not HasModelLoaded(hash) and GetGameTimer() < t do Wait(10) end
    local mn, mx = GetModelDimensions(hash)
    dimsCache[hash] = { mn, mx }
    return mn, mx
end

--- A best guess from the model's size: the front face, a little inset.
local function defaultGeo(hash, flip)
    local mn, mx = dims(hash)
    return {
        w = math.max(0.2, (mx.x - mn.x) * 0.92), h = math.max(0.15, (mx.z - mn.z) * 0.86),
        up = (mn.z + mx.z) / 2, side = (mn.x + mx.x) / 2 * (flip and -1 or 1),
        fwd = flip and (-mn.y + 0.012) or (mx.y + 0.012), flip = flip == true,
    }
end

local function corners(s, g)
    local hr = math.rad(s.h or 0.0)
    local f = vec3(-math.sin(hr), math.cos(hr), 0.0)
    local r = vec3(math.cos(hr), math.sin(hr), 0.0)
    if g.flip then f, r = -f, -r end
    local c = vec3(s.x, s.y, s.z) + f * g.fwd + r * g.side + vec3(0.0, 0.0, g.up)
    local hw, hh = r * (g.w / 2), vec3(0.0, 0.0, g.h / 2)
    -- Seen from in front (looking back along f), the viewer's left is +r, so the image's left edge goes there.
    return c + hw + hh, c - hw + hh, c + hw - hh, c - hw - hh -- top-left, top-right, bottom-left, bottom-right
end

local function poly(a, b, c, ua, va, ub, vb, uc, vc, txd, tex)
    DrawSpritePoly(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, 255, 255, 255, 255, txd, tex, ua, va, 1.0, ub, vb, 1.0, uc, vc, 1.0)
end

--- Two triangles each way round, so it shows whichever way the game culls them.
--- txd/tex default to the courtroom screen's browser.
local function drawPanel(s, g, txd, tex)
    txd, tex = txd or TXD, tex or TEX
    local tl, tr, bl, br = corners(s, g)
    poly(tl, bl, tr, 0, 0, 0, 1, 1, 0, txd, tex)
    poly(tr, bl, br, 1, 0, 0, 1, 1, 1, txd, tex)
    poly(tl, tr, bl, 0, 0, 1, 0, 0, 1, txd, tex)
    poly(tr, br, bl, 1, 0, 1, 1, 0, 1, txd, tex)
end

--- Is a point in front of the TV (on its +forward side)?
local function inFront(s, pos)
    local hr = math.rad(s.h or 0.0)
    local f = vec3(-math.sin(hr), math.cos(hr), 0.0)
    return ((pos.x - s.x) * f.x + (pos.y - s.y) * f.y) >= 0
end

--- Screens that have never been fitted: put the picture on the side facing `towards`
--- (the room's centre, or the viewer), since TV models don't agree on which way they face.
local function geoOf(s, towards)
    if s.geo and s.geo.w then return s.geo end
    local hash = modelHash(s)
    if not hash then return nil end
    local flip = towards and not inFront(s, towards) or false
    s.geo = defaultGeo(hash, flip)
    s.geoGuessed = true
    return s.geo
end

local function outline(s, g, r, gg, b)
    local tl, tr, bl, br = corners(s, g)
    DrawLine(tl.x, tl.y, tl.z, tr.x, tr.y, tr.z, r, gg, b, 255)
    DrawLine(tr.x, tr.y, tr.z, br.x, br.y, br.z, r, gg, b, 255)
    DrawLine(br.x, br.y, br.z, bl.x, bl.y, bl.z, r, gg, b, 255)
    DrawLine(bl.x, bl.y, bl.z, tl.x, tl.y, tl.z, r, gg, b, 255)
end

local debugOn = false

---------------------------------------------------------------------------
-- Render-target mode (model-wide)
---------------------------------------------------------------------------
local linked = {}

local function renderTarget(name, hash)
    if not targets[name] then
        if not IsNamedRendertargetRegistered(name) then RegisterNamedRendertarget(name, false) end
        targets[name] = GetNamedRendertargetRenderId(name)
    end
    if not linked[hash] then
        if not IsNamedRendertargetLinked(hash) then LinkNamedRendertarget(hash) end
        linked[hash] = true
    end
    return targets[name]
end

local function targetOf(s)
    if s.mode == 'pick' and s.mapModel then
        local m = s.model and (CR.ScreenModels or {})[s.model]
        return s.target or (m and m.target) or 'tvscreen'
    end
    local m = (CR.ScreenModels or {})[s.model or 1]
    return m and m.target
end

local function releaseTargets()
    for name in pairs(targets) do
        if IsNamedRendertargetRegistered(name) then ReleaseNamedRendertarget(name) end
    end
    targets, linked = {}, {}
end

---------------------------------------------------------------------------
-- Which room you're in, and what it's showing
---------------------------------------------------------------------------
local function roomHere()
    local here = GetEntityCoords(PlayerPedId())
    for _, r in ipairs(MoJRooms and MoJRooms() or {}) do
        local c = r.centre
        if c and c.x and #(here - vec3(c.x, c.y, c.z)) <= (r.radius or 20.0) + 3.0 then
            local screens = {}
            for _, p in ipairs(r.points or {}) do if p.kind == 'screen' then screens[#screens + 1] = p end end
            if #screens > 0 then return r, screens end
        end
    end
end

--- Changes whenever the screen needs redrawing: something new playing, or (on the slate)
--- the room or court being renamed.
local function stateKey(r)
    local p = playing[r.id] or playing[tostring(r.id)]
    if p then return r.id .. ':' .. p.startedAt .. ':' .. p.src, p end
    return ('%s:slate:%s:%s'):format(r.id, r.label or '', r.courtLabel or ''), nil
end

RegisterNetEvent('vinewood-moj:client:screens', function(list) playing = list or {} end)
CreateThread(function()
    Wait(2500)
    playing = lib.callback.await('vinewood-moj:server:screens', false) or {}
end)

CreateThread(function()
    while true do
        if adjusting then
            Wait(500)
        else
            local r, screens = roomHere()
            if r then
                ensureDui()
                if curRoom ~= r.id then
                    curRoom, curKey = r.id, nil
                    releaseTargets()
                end
                local k, p = stateKey(r)
                if k ~= curKey then
                    curKey = k
                    if p then
                        send({ action = 'play', kind = p.kind, src = p.src, label = p.label, control = p.control, fallback = p.fallback,
                            offset = p.offset or 0, elapsed = math.max(0, GetCloudTimeAsInt() - p.startedAt) })
                    else
                        send({ action = 'slate', room = r.label, court = r.courtLabel or Config.CourtsName })
                    end
                end
                -- Volume falls off with distance from the nearest screen.
                if p and (p.kind == 'file' or p.control) then
                    local here, best = GetEntityCoords(PlayerPedId()), 1e9
                    for _, s in ipairs(screens) do best = math.min(best, #(here - vec3(s.x, s.y, s.z))) end
                    local falloff = math.max(4.0, r.radius or 20.0)
                    send({ action = 'volume', v = (CR.ScreenVolume or 0.8) * math.max(0.15, 1.0 - best / falloff) })
                end
                Wait(500)
            else
                if dui then destroyDui() releaseTargets() end
                curRoom = nil
                Wait(1000)
            end
        end
    end
end)

-- Draw every frame.
CreateThread(function()
    while true do
        if dui and curRoom and TXD and not adjusting then
            local r, screens = roomHere()
            if r then
                if OVERLAY then
                    for _, s in ipairs(screens) do
                        local g = geoOf(s, r.centre and r.centre.x and vec3(r.centre.x, r.centre.y, r.centre.z) or GetEntityCoords(PlayerPedId()))
                        if g then
                            drawPanel(s, g)
                            if debugOn then outline(s, g, 255, 221, 0) end
                        end
                    end
                else
                    local done = {}
                    for _, s in ipairs(screens) do
                        local target, hash = targetOf(s), modelHash(s)
                        if target and hash and not done[target] then
                            done[target] = true
                            local id = renderTarget(target, hash)
                            for _, o in ipairs(screens) do
                                local h2 = modelHash(o)
                                if targetOf(o) == target and h2 and h2 ~= hash then renderTarget(target, h2) end
                            end
                            SetTextRenderId(id)
                            SetScriptGfxDrawOrder(4)
                            SetScriptGfxDrawBehindPausemenu(true)
                            DrawSprite(TXD, TEX, 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                            SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                        end
                    end
                end
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

---------------------------------------------------------------------------
-- Fitting the picture to a TV (admins, from /courtrooms)
---------------------------------------------------------------------------
MoJScreens = {}

--- s = { x, y, z, h, mode, model, mapModel, geo? }. spawnModel = show a temporary TV prop while fitting.
--- Returns the fitted geo, or nil if cancelled.
function MoJScreens.Adjust(s, spawnModel, roomLabel, force)
    if not OVERLAY and not force then return nil end
    adjusting = true
    ensureDui()
    send({ action = 'slate', room = roomLabel or 'Court', court = Config.CourtsName, msg = 'Fit this picture to the screen' })
    local hash = modelHash(s)
    local prop
    if spawnModel then
        local mh = joaat(spawnModel)
        if IsModelInCdimage(mh) then
            RequestModel(mh)
            local t = GetGameTimer() + 3000
            while not HasModelLoaded(mh) and GetGameTimer() < t do Wait(10) end
            prop = CreateObjectNoOffset(mh, s.x, s.y, s.z, false, false, false)
            SetEntityHeading(prop, s.h or 0.0)
            FreezeEntityPosition(prop, true)
            SetEntityCollision(prop, false, false)
        end
    end
    -- Start the picture on the side of the TV you're standing on.
    local mySide = not inFront(s, GetEntityCoords(PlayerPedId()))
    local g = s.geo and s.geo.w and not s.geoGuessed and { w = s.geo.w, h = s.geo.h, up = s.geo.up, side = s.geo.side, fwd = s.geo.fwd, flip = s.geo.flip }
    -- A saved fit on the far side from you (inside the wall): start again on your side.
    if not g or (g.flip == true) ~= mySide then g = defaultGeo(hash or 0, mySide) end
    SendNUIMessage({ action = 'hint', text = '←/→ width · ↑/↓ height · hold Shift: move · scroll: in/out · F: other side · R: reset · E: save · Backspace: cancel' })
    local result
    while true do
        Wait(0)
        for _, c in ipairs({ 14, 15, 16, 17, 23, 24, 25, 37, 44, 45, 140, 141, 142, 172, 173, 174, 175, 261, 262 }) do DisableControlAction(0, c, true) end
        local shift = IsControlPressed(0, 21)
        local step = 0.004
        if shift then
            if IsDisabledControlPressed(0, 174) then g.side = g.side - step end
            if IsDisabledControlPressed(0, 175) then g.side = g.side + step end
            if IsDisabledControlPressed(0, 172) then g.up = g.up + step end
            if IsDisabledControlPressed(0, 173) then g.up = g.up - step end
        else
            if IsDisabledControlPressed(0, 174) then g.w = math.max(0.1, g.w - step * 2) end
            if IsDisabledControlPressed(0, 175) then g.w = g.w + step * 2 end
            if IsDisabledControlPressed(0, 172) then g.h = g.h + step * 2 end
            if IsDisabledControlPressed(0, 173) then g.h = math.max(0.1, g.h - step * 2) end
        end
        if IsDisabledControlJustPressed(0, 15) or IsDisabledControlJustPressed(0, 261) then g.fwd = g.fwd + 0.005 end
        if IsDisabledControlJustPressed(0, 14) or IsDisabledControlJustPressed(0, 262) then g.fwd = g.fwd - 0.005 end
        if IsDisabledControlJustPressed(0, 23) then g = defaultGeo(hash or 0, not g.flip) end
        if IsDisabledControlJustPressed(0, 45) then g = defaultGeo(hash or 0, g.flip) end
        if TXD then drawPanel(s, g) end
        outline(s, g, 255, 221, 0)   -- always visible while fitting, even if the picture isn't
        if IsControlJustReleased(0, 38) then result = g break end
        if IsControlJustReleased(0, 177) or IsControlJustReleased(0, 200) then break end
    end
    if prop and DoesEntityExist(prop) then DeleteEntity(prop) end
    SendNUIMessage({ action = 'hint', text = false })
    adjusting, curKey = false, nil
    if result then
        for k, v in pairs(result) do if type(v) == 'number' then result[k] = math.floor(v * 1000 + 0.5) / 1000 end end
    end
    return result
end

function MoJScreens.Overlay() return OVERLAY end

-- Shared with client/boards.lua: listing boards are always drawn as panels.
MoJScreens.DrawPanel = drawPanel
MoJScreens.GeoOf = geoOf
MoJScreens.Outline = outline
MoJScreens.Debug = function() return debugOn end

-- /mojscreens: outline every screen around you and print what each one is doing (F8 console).
RegisterCommand('mojscreens', function()
    debugOn = not debugOn
    local here = GetEntityCoords(PlayerPedId())
    local r, screens = roomHere()
    print(('[vinewood-moj] screen debug %s. Mode: %s. In a courtroom with screens: %s.'):format(debugOn and 'ON' or 'OFF',
        OVERLAY and 'overlay' or 'rendertarget', r and ('yes (' .. r.label .. ')') or 'no'))
    if r then
        print(('  browser: %s, texture: %s'):format(dui and (IsDuiAvailable(dui) and 'ready' or 'loading') or 'none', TXD or 'none'))
        for i, s in ipairs(screens) do
            local g = geoOf(s, vec3(r.centre.x, r.centre.y, r.centre.z))
            print(('  screen %d "%s": %s, %s, picture %s side, you are %s it, %.1f m away'):format(i, s.label or '', s.mode or '?',
                s.geoGuessed and 'NOT fitted (guess)' or 'fitted', g and (g.flip and 'back' or 'front') or '?',
                inFront(s, here) == not (g and g.flip) and 'in front of' or 'BEHIND', #(here - vec3(s.x, s.y, s.z))))
        end
    end
    lib.notify({ title = 'Screens', description = debugOn and 'Outlines on: yellow box = where the picture is. Details in F8.' or 'Outlines off.' })
end, false)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    destroyDui()
    releaseTargets()
end)
