if not Config.Modules.graffiti then return end

local cfg = Config.Graffiti

-- Spray, cross-out and clean times staff set in /gangadmin > Tags in world (config/graffiti.lua until then)
local function followTiming(t)
    if type(t) ~= 'table' then return end
    for _, k in ipairs({ 'cooldown', 'sprayTime', 'crossTime', 'cleanTime' }) do
        if tonumber(t[k]) then cfg[k] = tonumber(t[k]) end
    end
end
followTiming(GlobalState.vg_graffiti_timing)
AddStateBagChangeHandler('vg_graffiti_timing', 'global', function(_, _, value) followTiming(value) end)
local RESOURCE = GetCurrentResourceName()
local UP = vector3(0.0, 0.0, 1.0)

local tags = {}      -- tags[id] = { id, gangId, designId, p, status, crossColour, centre, quad, crossQuad }
local designs = {}   -- designs[id] = spec
local nearby = {}    -- ordered list of tags within render distance
local textures = {}  -- textures[key] = { dui, txd, txn, lastUsed }
local txdCounter = 0
local pending        -- tag currently being sprayed: { quad, key, url, start, duration }
local placing = false
local busy = false

-------------------------------------------------------------------------------
-- Geometry
-------------------------------------------------------------------------------

local function cross(a, b)
    return vector3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

local function normalise(v)
    local len = #v
    return len > 0 and v / len or v
end

---Builds the four corners of a 2:1 tag on a wall.
local function dot(a, b) return a.x * b.x + a.y * b.y + a.z * b.z end

---Which way is "up" for the lettering on a surface. Walls: towards the sky. Floors and ramps: the hint
---(the direction the sprayer was facing), or north if there isn't one.
local function surfaceUp(normal, upHint)
    if upHint then
        local u = upHint - normal * dot(upHint, normal)
        if #u > 0.1 then return normalise(u) end
    end
    if math.abs(normal.z) < 0.7 then
        local right = normalise(cross(-normal, UP))
        return normalise(cross(right, -normal))
    end
    return normalise(vector3(0.0, 1.0, 0.0) - normal * normal.y)
end

---Builds the four corners of a 2:1 tag on any surface.
local function buildQuad(pos, normal, width, offset, upHint)
    local forward = -normal
    local up = surfaceUp(normal, upHint)
    local right = normalise(cross(forward, up))
    local c = pos + normal * (offset or cfg.surfaceGap)
    local hw, hh = width / 2, width / 4
    return {
        tl = c - right * hw + up * hh,
        tr = c + right * hw + up * hh,
        bl = c - right * hw - up * hh,
        br = c + right * hw - up * hh,
    }
end

local function tri(a, b, c, ua, ub, uc, txd, txn, alpha)
    DrawSpritePoly(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, 255, 255, 255, alpha, txd, txn,
        ua[1], ua[2], 1.0, ub[1], ub[2], 1.0, uc[1], uc[2], 1.0)
end

local UV_TL, UV_TR, UV_BL, UV_BR = { 0.0, 0.0 }, { 1.0, 0.0 }, { 0.0, 1.0 }, { 1.0, 1.0 }

local function drawQuad(q, txd, txn, alpha)
    -- Both windings, so the tag shows whichever way the surface faces
    tri(q.bl, q.tr, q.tl, UV_BL, UV_TR, UV_TL, txd, txn, alpha)
    tri(q.bl, q.br, q.tr, UV_BL, UV_BR, UV_TR, txd, txn, alpha)
    tri(q.tl, q.tr, q.bl, UV_TL, UV_TR, UV_BL, txd, txn, alpha)
    tri(q.tr, q.br, q.bl, UV_TR, UV_BR, UV_BL, txd, txn, alpha)
end

-------------------------------------------------------------------------------
-- Textures (one DUI per design, shared by every tag using it)
-------------------------------------------------------------------------------

local function urlEncode(s)
    return (s:gsub('[^%w%-_%.~]', function(c) return ('%%%02X'):format(c:byte()) end))
end

local function designUrl(spec)
    return ('nui://%s/web/tag.html?d=%s'):format(RESOURCE, urlEncode(json.encode(spec)))
end

local function crossUrl(colour)
    return ('nui://%s/web/tag.html?cross=%s'):format(RESOURCE, urlEncode(colour))
end

local function texture(key, url)
    local t = textures[key]
    if not t then
        txdCounter = txdCounter + 1
        local txdName = ('vg_tag_%d'):format(txdCounter)
        local dui = CreateDui(url, 1024, 512)
        local txd = CreateRuntimeTxd(txdName)
        CreateRuntimeTextureFromDuiHandle(txd, 'tex', GetDuiHandle(dui))
        t = { dui = dui, txd = txdName, txn = 'tex' }
        textures[key] = t
    end
    t.lastUsed = GetGameTimer()
    return t.txd, t.txn
end

-- Free DUIs nobody has looked at for two minutes
CreateThread(function()
    while true do
        Wait(30000)
        local now = GetGameTimer()
        for key, t in pairs(textures) do
            if now - t.lastUsed > 120000 then
                DestroyDui(t.dui)
                textures[key] = nil
            end
        end
    end
end)

-------------------------------------------------------------------------------
-- Tag store
-------------------------------------------------------------------------------

local function prepare(tag)
    local p = tag.p
    local pos, normal = vector3(p.x, p.y, p.z), vector3(p.nx, p.ny, p.nz)
    local up = p.ux and vector3(p.ux, p.uy, p.uz) or nil
    tag.centre = pos
    tag.quad = buildQuad(pos, normal, p.w, cfg.surfaceGap, up)
    if tag.status == 'crossed' then
        tag.crossQuad = buildQuad(pos, normal, p.w * 1.05, cfg.surfaceGap + 0.008, up)
    end
    tags[tag.id] = tag
end

local function drawTag(tag, alpha)
    local spec = designs[tag.designId]
    if not spec then return end
    local txd, txn = texture('d' .. tag.designId, designUrl(spec))
    drawQuad(tag.quad, txd, txn, alpha or 255)
    if tag.crossQuad then
        local ctxd, ctxn = texture('x' .. tag.crossColour, crossUrl(tag.crossColour))
        drawQuad(tag.crossQuad, ctxd, ctxn, alpha or 255)
    end
end

RegisterNetEvent('vinewood_gangs:client:graffitiUpsert', function(tag, design)
    if design then designs[design.id] = design.spec end
    prepare(tag)
end)

RegisterNetEvent('vinewood_gangs:client:graffitiRemove', function(id)
    tags[id] = nil
end)

CreateThread(function()
    -- The server may still be loading after a restart, so keep asking
    while true do
        local snap = lib.callback.await('vinewood_gangs:server:graffitiSnapshot', false)
        if snap then
            for _, d in ipairs(snap.designs) do designs[d.id] = d.spec end
            for _, t in ipairs(snap.tags) do prepare(t) end
            break
        end
        Wait(3000)
    end
end)

-------------------------------------------------------------------------------
-- Rendering
-------------------------------------------------------------------------------

CreateThread(function()
    while true do
        local origin = GetEntityCoords(cache.ped)
        local list = {}
        for _, t in pairs(tags) do
            local d = #(origin - t.centre)
            if d <= cfg.renderDistance then list[#list + 1] = { tag = t, dist = d } end
        end
        table.sort(list, function(a, b) return a.dist < b.dist end)
        local out = {}
        for i = 1, math.min(#list, cfg.maxRendered) do out[i] = list[i] end
        nearby = out
        Wait(750)
    end
end)

CreateThread(function()
    while true do
        if #nearby > 0 or pending then
            for i = 1, #nearby do drawTag(nearby[i].tag) end
            if pending then
                local progress = math.min(1.0, (GetGameTimer() - pending.start) / pending.duration)
                local txd, txn = texture(pending.key, pending.url)
                drawQuad(pending.quad, txd, txn, math.floor(255 * progress))
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

-------------------------------------------------------------------------------
-- Spraying
-------------------------------------------------------------------------------

local function notifyError(err)
    lib.notify({ description = locale(err or 'failed'), type = 'error' })
end

local SPRAY_ANIM = { dict = 'switch@franklin@lamar_tagging_wall', clip = 'lamar_tagging_wall_loop_lamar', flag = 1 }
local SPRAY_PROP = { model = 'prop_cs_spray_can', bone = 57005, pos = vec3(0.12, 0.04, -0.02), rot = vec3(-70.0, 0.0, 0.0) }

local function sprayProgress(duration, label)
    return lib.progressBar({
        duration = duration,
        label = label,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = SPRAY_ANIM,
        prop = SPRAY_PROP,
    })
end

local function spray(design, placement)
    local ok, err = lib.callback.await('vinewood_gangs:server:graffitiCanPlace', false, design.id, placement)
    if not ok then return notifyError(err) end

    busy = true
    local pos = vector3(placement.x, placement.y, placement.z)
    pending = {
        quad = buildQuad(pos, vector3(placement.nx, placement.ny, placement.nz), placement.w, cfg.surfaceGap,
            placement.ux and vector3(placement.ux, placement.uy, placement.uz) or nil),
        key = 'd' .. design.id, url = designUrl(design.spec),
        start = GetGameTimer(), duration = cfg.sprayTime,
    }
    designs[design.id] = designs[design.id] or design.spec

    local done = sprayProgress(cfg.sprayTime, locale('spraying_tag'))
    if done then
        local placed, placeErr = lib.callback.await('vinewood_gangs:server:graffitiPlace', false, design.id, placement)
        if placed then
            lib.notify({ description = locale('tag_sprayed'), type = 'success' })
        else
            notifyError(placeErr)
        end
    end
    pending = nil
    busy = false
end

local function disablePlacementControls()
    DisableControlAction(0, 24, true)  -- attack
    DisableControlAction(0, 25, true)  -- aim
    DisableControlAction(0, 14, true)  -- weapon wheel scroll
    DisableControlAction(0, 15, true)
    DisableControlAction(0, 16, true)
    DisableControlAction(0, 17, true)
    DisableControlAction(0, 37, true)  -- weapon wheel
    DisableControlAction(0, 140, true) -- melee
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
end

-- Where the player is looking: a ray from the camera, long enough to pass the player in third person.
-- The spray range (cfg.maxDistance) is then measured from the player, not from the camera.
local function rotationToDirection(rot)
    local x, z = math.rad(rot.x), math.rad(rot.z)
    local cosX = math.abs(math.cos(x))
    return vector3(-math.sin(z) * cosX, math.cos(z) * cosX, math.sin(x))
end

local function aimedWall()
    local camPos = GetFinalRenderedCamCoord()
    local dir = rotationToDirection(GetFinalRenderedCamRot(2))
    local pedPos = GetEntityCoords(cache.ped)
    local reach = #(camPos - pedPos) + cfg.maxDistance + 1.0
    local target = camPos + dir * reach
    -- 1 = map, 16 = objects; ignore our own ped
    local probe = StartExpensiveSynchronousShapeTestLosProbe(camPos.x, camPos.y, camPos.z, target.x, target.y, target.z, 17, cache.ped, 7)
    local _, hit, coords, normal = GetShapeTestResult(probe)
    if hit ~= 1 and hit ~= true then return nil, 'graffiti_aim_wall' end
    if not coords or not normal then return nil, 'graffiti_aim_wall' end
    if #(pedPos - coords) > cfg.maxDistance + 0.5 then return nil, 'graffiti_aim_closer' end
    local s = cfg.surfaces or { walls = true }
    if normal.z > 0.35 and not s.floors then return nil, 'graffiti_aim_wall' end
    if normal.z < -0.35 and not s.ceilings then return nil, 'graffiti_aim_wall' end
    if math.abs(normal.z) <= 0.35 and s.walls == false then return nil, 'graffiti_aim_wall' end
    return coords, nil, normal
end

local function probeLine(from, to)
    local h = StartExpensiveSynchronousShapeTestLosProbe(from.x, from.y, from.z, to.x, to.y, to.z, 17, cache.ped, 7)
    local _, hit, coords = GetShapeTestResult(h)
    if hit == 1 or hit == true then return coords end
end

local SNAP = {
    vertical  = 0.035, -- walls within about 2 degrees of upright are treated as exactly upright
    reach     = 0.6,  -- how far in front of / behind the wall each corner is checked
    bumpiness = 0.10, -- metres a corner may sit off the fitted surface before it's "not flat enough"
    agreement = 0.94, -- how closely the fitted surface must face the same way as the aimed point
}

local function upright(n)
    if math.abs(n.z) < SNAP.vertical then return normalise(vector3(n.x, n.y, 0.0)) end
    return normalise(n)
end

---Snaps the tag to the surface under the crosshair. When the surface under all four corners is flat, the tag is
---laid flush on it; otherwise it simply sticks to the point you aimed at. It never refuses a spot.
local function snapToSurface(hitPos, hitNormal, width, upHint)
    local normal = upright(hitNormal)
    local up = surfaceUp(normal, upHint)
    local right = normalise(cross(-normal, up))
    local hw, hh = width / 2 * 0.95, width / 4 * 0.95

    local corners = { { -hw, hh }, { hw, hh }, { -hw, -hh }, { hw, -hh }, { 0, 0 } } -- four corners and the middle
    local pts = {}
    for i, o in ipairs(corners) do
        local base = hitPos + right * o[1] + up * o[2]
        pts[i] = probeLine(base + normal * SNAP.reach, base - normal * SNAP.reach)
        if not pts[i] then return hitPos, normal, up end -- part of the tag is off the surface: stick to the aim point
    end

    local fitted = normalise(cross(pts[2] - pts[1], pts[3] - pts[1]))
    if dot(fitted, normal) < 0 then fitted = -fitted end
    if dot(fitted, normal) < SNAP.agreement then return hitPos, normal, up end -- uneven: stick to the aim point
    local centre = (pts[1] + pts[2] + pts[3] + pts[4]) / 4
    for _, p in ipairs(pts) do -- includes the middle, which catches steps the corners alone would miss
        if math.abs(dot(p - centre, fitted)) > SNAP.bumpiness then return hitPos, normal, up end
    end

    fitted = upright(fitted)
    local onSurface = hitPos - fitted * dot(hitPos - centre, fitted)
    -- Walls: lettering always upright to the sky. Floors: keep the sprayer's facing.
    return onSurface, fitted, math.abs(fitted.z) < 0.7 and surfaceUp(fitted) or surfaceUp(fitted, up)
end

-- How far the tag sits in front of (+) or behind (-) the wall's collision, in metres.
-- GTA's collision is often a few centimetres in front of the visible wall, so players can push the tag in
-- to sit on the brickwork. Remembered between sprays.
local depth = 0.0
local DEPTH_MIN, DEPTH_MAX, DEPTH_STEP = -0.30, 0.10, 0.01

function StartSprayPlacement(design)
    if placing or busy or not design or not design.spec then return end
    if IsPedInAnyVehicle(cache.ped, false) then return notifyError('not_in_vehicle') end

    placing = true
    designs[design.id] = designs[design.id] or design.spec
    local width = cfg.defaultWidth
    local key, url = 'd' .. design.id, designUrl(design.spec)
    local shownHelp, shownDepth, pendingHelp, pendingSince
    local lastSig, snapped, snappedNormal, snappedUp

    -- Only switch the help text once a new message has held for a moment, so a borderline aim can't flicker it
    local shownArea
    local function help(keyName, areaLabel)
        keyName = keyName or 'graffiti_aim_wall'
        local now = GetGameTimer()
        local depthCm = math.floor(depth * 100 + 0.5)
        local text = function() return locale(keyName, areaLabel or '', depthCm) end
        if keyName == shownHelp then
            pendingHelp = nil
            if keyName == 'graffiti_place_help' and (depthCm ~= shownDepth or areaLabel ~= shownArea) then
                lib.showTextUI(text())
                shownDepth, shownArea = depthCm, areaLabel
            end
            return
        end
        if shownHelp then
            if keyName ~= pendingHelp or not pendingSince then pendingHelp, pendingSince = keyName, now return end
            if now - pendingSince < 200 then return end
        end
        lib.showTextUI(text())
        shownHelp, shownDepth, shownArea, pendingHelp = keyName, depthCm, areaLabel, nil
    end

    CreateThread(function()
        while placing do
            disablePlacementControls()

            -- Scroll = size, Shift + scroll = depth. Both work at any time.
            local up, down = IsDisabledControlJustPressed(0, 15), IsDisabledControlJustPressed(0, 14)
            if IsControlPressed(0, 21) then
                if up then depth = math.min(DEPTH_MAX, depth + DEPTH_STEP) end
                if down then depth = math.max(DEPTH_MIN, depth - DEPTH_STEP) end
            else
                if up then width = math.min(cfg.maxWidth, width + 0.1) end
                if down then width = math.max(cfg.minWidth, width - 0.1) end
            end

            local coords, problem, normal = aimedWall()
            local zone
            if coords then
                -- Re-fit only when the aim moves 5cm or the size changes, not on every tiny wobble
                local sig = ('%d:%d:%d:%.2f'):format(math.floor(coords.x * 20), math.floor(coords.y * 20), math.floor(coords.z * 20), width)
                -- On floors the lettering reads upright from where you stand: "up" is the way you're facing
                local upHint = math.abs(normal.z) > 0.7 and rotationToDirection(GetFinalRenderedCamRot(2)) or nil
                if upHint then sig = sig .. (':%d'):format(math.floor(GetEntityHeading(cache.ped) / 15)) end
                if sig ~= lastSig then
                    lastSig = sig
                    snapped, snappedNormal, snappedUp = snapToSurface(coords, normal, width, upHint)
                end
                coords, normal = snapped, snappedNormal
            end
            if coords then
                coords = coords + normal * depth
                zone = Zones.FromCoords(coords)
                if not zone and cfg.onlyInAreas then coords = nil end
            end
            if coords then
                help('graffiti_place_help', zone and Zones.Label(zone) or locale('graffiti_no_area_short'))
                local q = buildQuad(coords, normal, width, cfg.surfaceGap, snappedUp)
                local txd, txn = texture(key, url)
                drawQuad(q, txd, txn, 150)

                if IsControlJustPressed(0, 38) then
                    placing = false
                    lib.hideTextUI()
                    local up = surfaceUp(normal, snappedUp)
                    spray(design, {
                        x = coords.x, y = coords.y, z = coords.z,
                        nx = normal.x, ny = normal.y, nz = normal.z, w = width,
                        ux = up.x, uy = up.y, uz = up.z,
                    })
                    return
                end
            else
                -- Aiming failed (problem says why), or it worked but the spot is outside every area
                help(problem or 'graffiti_no_area')
            end

            if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 194) then -- backspace
                placing = false
                notifyError('graffiti_cancelled')
            end
            Wait(0)
        end
        lib.hideTextUI()
    end)
end

exports('StartSprayPlacement', StartSprayPlacement)

-------------------------------------------------------------------------------
-- Crossing out, cleaning and removing
-------------------------------------------------------------------------------

local function canGraffiti()
    local gang = GetPlayerGang()
    if not gang then return false end
    for _, p in ipairs(gang.permissions) do
        if p == '*' or p == 'graffiti' then return true end
    end
    return false
end

local jobCache, jobCheckedAt = nil, 0
local function cachedJob()
    if GetGameTimer() - jobCheckedAt > 2000 then
        jobCache, jobCheckedAt = ClientBridge.GetJob(), GetGameTimer()
    end
    return jobCache
end

---Picks what E does at the nearest tag, if anything.
local PROMPT_ON, PROMPT_OFF = 2.2, 2.8 -- show within 2.2m, only hide once past 2.8m
local promptTagId -- the tag the prompt is currently showing for

local function interaction()
    if busy or placing or #nearby == 0 then return end
    -- Measure live (the nearby list is only refreshed every 750ms) and pick the closest tag
    local pos = GetEntityCoords(cache.ped)
    local tag, best
    for i = 1, math.min(#nearby, 5) do
        local t = nearby[i].tag
        local d = #(pos - t.centre)
        local limit = t.id == promptTagId and PROMPT_OFF or PROMPT_ON
        if d <= limit and (not best or d < best) then tag, best = t, d end
    end
    if not tag or not tags[tag.id] then return end

    local job = cachedJob()
    if job and cfg.cleanJobs[job] then return tag, 'clean' end

    local gang = GetPlayerGang()
    if not gang or not canGraffiti() then return end
    if tag.gangId == gang.id then return tag, 'remove' end
    if tag.status == 'active' then return tag, 'cross' end
end

local ACTIONS = {
    cross = { prompt = 'graffiti_cross_prompt', label = 'crossing_out', time = function() return cfg.crossTime end, event = 'graffitiCross', done = 'tag_crossed', spray = true },
    clean = { prompt = 'graffiti_clean_prompt', label = 'cleaning_tag', time = function() return cfg.cleanTime end, event = 'graffitiClean', done = 'tag_cleaned' },
    remove = { prompt = 'graffiti_remove_prompt', label = 'removing_tag', time = function() return cfg.cleanTime / 2 end, event = 'graffitiClean', done = 'tag_removed' },
}

local CLEAN_ANIM = { dict = 'timetable@floyd@clean_kitchen@base', clip = 'base', flag = 1 }

local function perform(tag, kind)
    local a = ACTIONS[kind]
    busy = true
    local done = lib.progressBar({
        duration = a.time(),
        label = locale(a.label),
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = a.spray and SPRAY_ANIM or CLEAN_ANIM,
        prop = a.spray and SPRAY_PROP or nil,
    })
    if done then
        local ok, err = lib.callback.await('vinewood_gangs:server:' .. a.event, false, tag.id)
        if ok then lib.notify({ description = locale(a.done), type = 'success' }) else notifyError(err) end
    end
    busy = false
end

CreateThread(function()
    local shownFor
    while true do
        local tag, kind = interaction()
        promptTagId = tag and tag.id or nil
        local key = tag and (tag.id .. kind) or nil
        if key ~= shownFor then
            if shownFor then lib.hideTextUI() end
            if key then lib.showTextUI(locale(ACTIONS[kind].prompt)) end
            shownFor = key
        end
        if tag then
            if IsControlJustPressed(0, 38) then
                lib.hideTextUI()
                shownFor = nil
                perform(tag, kind)
            end
            Wait(0)
        else
            Wait(300)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= RESOURCE then return end
    for _, t in pairs(textures) do DestroyDui(t.dui) end
    if placing then lib.hideTextUI() end
end)
