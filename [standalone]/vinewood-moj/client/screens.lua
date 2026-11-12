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

--- Corners of the panel, laid out so the picture reads correctly from where the camera is
--- (never mirrored, whichever side you look from). Also returns the centre.
local function corners(s, g)
    local hr = math.rad(s.h or 0.0)
    local f = vec3(-math.sin(hr), math.cos(hr), 0.0)
    local r = vec3(math.cos(hr), math.sin(hr), 0.0)
    if g.flip then f, r = -f, -r end
    local c = vec3(s.x, s.y, s.z) + f * g.fwd + r * g.side + vec3(0.0, 0.0, g.up)
    -- Seen from the +f side the viewer's left is +r; from the other side it's -r.
    local cam = GetFinalRenderedCamCoord()
    if ((cam.x - c.x) * f.x + (cam.y - c.y) * f.y) < 0 then r = -r end
    local hw, hh = r * (g.w / 2), vec3(0.0, 0.0, g.h / 2)
    return c + hw + hh, c - hw + hh, c + hw - hh, c - hw - hh, c -- top-left, top-right, bottom-left, bottom-right
end

-- Texture coordinates MUST be floats (0.0 / 1.0): whole numbers reach the game as ~0, which
-- samples one corner pixel and paints the whole panel a single colour.
local function poly(a, b, c, ua, va, ub, vb, uc, vc, txd, tex)
    DrawSpritePoly(a.x + 0.0, a.y + 0.0, a.z + 0.0, b.x + 0.0, b.y + 0.0, b.z + 0.0, c.x + 0.0, c.y + 0.0, c.z + 0.0,
        255, 255, 255, 255, txd, tex, ua + 0.0, va + 0.0, 1.0, ub + 0.0, vb + 0.0, 1.0, uc + 0.0, vc + 0.0, 1.0)
end

--- Both windings, so it shows whichever way the game culls triangles.
--- txd/tex default to the courtroom screen's browser.
local function drawPanel(s, g, txd, tex)
    txd, tex = txd or TXD, tex or TEX
    local tl, tr, bl, br = corners(s, g)
    poly(tl, bl, tr, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, txd, tex)
    poly(tr, bl, br, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0, txd, tex)
    poly(tl, tr, bl, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, txd, tex)
    poly(tr, br, bl, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, txd, tex)
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
--- The courtroom you're in: of every room whose circle you're inside, the one whose centre is
--- closest (neighbouring rooms' circles often overlap). Nil if that room has no screens.
local function roomsAround()
    local here = GetEntityCoords(PlayerPedId())
    local inside = {}
    for _, r in ipairs(MoJRooms and MoJRooms() or {}) do
        local c = r.centre
        -- Drawn shapes: you have to be inside the walls (a little leeway for doorways). Circles: as before.
        if c and c.x and Zones.Contains(r, here, Zones.IsPoly(r) and 0.5 or 3.0) then
            inside[#inside + 1] = { room = r, d = #(here - vec3(c.x, c.y, c.z)), rank = Zones.Rank(r, here) }
        end
    end
    table.sort(inside, function(a, b) return a.rank < b.rank end)
    return inside
end

local function roomHere()
    local inside = roomsAround()
    local r = inside[1] and inside[1].room
    if not r then return nil end
    local screens = {}
    for _, p in ipairs(r.points or {}) do if p.kind == 'screen' then screens[#screens + 1] = p end end
    if #screens > 0 then return r, screens end
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
                        send({ action = 'play', kind = p.kind, src = p.src, label = p.label, control = p.control, fallback = p.fallback, fallbackEmbed = p.fallbackEmbed,
                            tracks = p.tracks, total = p.total, meta = p.meta,
                            offset = p.offset or 0, elapsed = math.max(0, GetCloudTimeAsInt() - p.startedAt) })
                    else
                        send({ action = 'slate', room = r.label, court = r.courtLabel or Config.CourtsName })
                    end
                end
                -- Sound comes from the room's speakers if it has any, otherwise from the screens.
                if p and (p.kind == 'file' or p.kind == 'interview' or p.control) then
                    local here = GetEntityCoords(PlayerPedId())
                    if MoJPA and #MoJPA.Speakers(r) > 0 then
                        send({ action = 'volume', v = (CR.ScreenVolume or 0.8) * MoJPA.VolumeAt(r, here) / (CR.SpeakerVolume or 0.85) })
                    else
                        local best = 1e9
                        for _, s in ipairs(screens) do best = math.min(best, #(here - vec3(s.x, s.y, s.z))) end
                        local falloff = math.max(4.0, r.radius or 20.0)
                        send({ action = 'volume', v = (CR.ScreenVolume or 0.8) * math.max(0.15, 1.0 - best / falloff) })
                    end
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
    SendNUIMessage({ action = 'hint', text = 'W/A/S/D move · ←/→ width · ↑/↓ height · scroll or PgUp/PgDn: in/out · hold Ctrl: fine · F: other side · R: reset · E: save · Backspace: cancel' })
    local result
    -- Keys used here, kept from moving or controlling the character while fitting.
    local LOCK = { 14, 15, 16, 17, 21, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35, 36, 37, 44, 45, 10, 11,
        140, 141, 142, 172, 173, 174, 175, 261, 262 }
    local P = IsDisabledControlPressed
    while true do
        Wait(0)
        for _, c in ipairs(LOCK) do DisableControlAction(0, c, true) end
        local step = P(0, 36) and 0.0015 or 0.005            -- Ctrl held: fine adjustment
        -- Left/right as you see it: which way that is along the TV depends on the side you're on.
        local hr = math.rad(s.h or 0.0)
        local f = vec3(-math.sin(hr), math.cos(hr), 0.0)
        if g.flip then f = -f end
        local cam = GetFinalRenderedCamCoord()
        local tvC = vec3(s.x, s.y, s.z)
        local lr = (((cam.x - tvC.x) * f.x + (cam.y - tvC.y) * f.y) >= 0) and 1 or -1
        -- Move: W/A/S/D, or Shift + arrows.
        local shift = P(0, 21)
        if P(0, 34) or (shift and P(0, 174)) then g.side = g.side + step * lr end
        if P(0, 35) or (shift and P(0, 175)) then g.side = g.side - step * lr end
        if P(0, 32) or (shift and P(0, 172)) then g.up = g.up + step end
        if P(0, 33) or (shift and P(0, 173)) then g.up = g.up - step end
        -- Size: arrows (without Shift).
        if not shift then
            if P(0, 174) then g.w = math.max(0.1, g.w - step * 2) end
            if P(0, 175) then g.w = g.w + step * 2 end
            if P(0, 172) then g.h = g.h + step * 2 end
            if P(0, 173) then g.h = math.max(0.1, g.h - step * 2) end
        end
        -- In/out: scroll a notch at a time, or hold Page Up / Page Down.
        if IsDisabledControlJustPressed(0, 15) or IsDisabledControlJustPressed(0, 261) then g.fwd = g.fwd + 0.01 end
        if IsDisabledControlJustPressed(0, 14) or IsDisabledControlJustPressed(0, 262) then g.fwd = g.fwd - 0.01 end
        if P(0, 10) then g.fwd = g.fwd + step end
        if P(0, 11) then g.fwd = g.fwd - step end
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
    print(('[vinewood-moj] screen debug %s. Mode: %s. Showing screens for: %s.'):format(debugOn and 'ON' or 'OFF',
        OVERLAY and 'overlay' or 'rendertarget', r and r.label or 'none'))
    local around = roomsAround()
    if #around > 1 then
        print('  You are inside more than one courtroom\'s area (they overlap). Using the nearest centre:')
        for i, x in ipairs(around) do
            print(('    %s%s: %s, centre %.1f m away'):format(i == 1 and '> ' or '  ', x.room.label,
                Zones.IsPoly(x.room) and ('drawn shape, ' .. #x.room.shape.points .. ' corners') or ('circle, ' .. math.floor(x.room.radius or 0) .. ' m'), x.d))
        end
        print('  Draw each room\'s shape in /courtrooms → the room → Draw the room\'s shape, so their areas follow the walls.')
    end
    if r then
        print(('  browser: %s, texture: %s'):format(dui and (IsDuiAvailable(dui) and 'ready' or 'loading') or 'none', TXD or 'none'))
        for i, s in ipairs(screens) do
            local g = geoOf(s, vec3(r.centre.x, r.centre.y, r.centre.z))
            print(('  screen %d "%s": %s, %s, %.2f x %.2f m, %.2f m out from the TV, %.1f m away'):format(i, s.label or '', s.mode or '?',
                s.geoGuessed and 'NOT fitted (using a guess)' or 'fitted', g and g.w or 0, g and g.h or 0, g and g.fwd or 0, #(here - vec3(s.x, s.y, s.z))))
        end
    end
    lib.notify({ title = 'Screens', description = debugOn and 'Outlines on: yellow box = where the picture is. Details in F8.' or 'Outlines off.' })
end, false)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    destroyDui()
    releaseTargets()
end)
