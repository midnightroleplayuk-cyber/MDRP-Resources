-- =============================================
--  modules/camera | client.lua
--  Smooth scripted-camera entry/exit for the station experience. When a player
--  opens one of the four station props we ease from the gameplay camera into a
--  framed view of the station, and ease back out when they leave. The cooking
--  cursor raycast (modules/interactive) reads StationCam so drag-to-place still
--  lines up with what the player is actually looking at.
-- =============================================

StationCam    = nil
StationActive = false   -- true for the whole open->close session (survives view swaps)

local EASE_MS      = 650
local VIEW_EASE_MS = 450  -- sub-view (stovetop <-> oven door) re-frame duration

-- ─── per-station framing ─────────────────────────────────────────────────────
--  The camera is anchored to the interacted entity's own transform (its world
--  coords *and* heading), so each shot follows however the station was rotated
--  when it was placed. The two offsets below are expressed in the entity's
--  LOCAL space, which is what makes the rotation track automatically:
--      pos    x = right of the prop, y = in front of it, z = up
--      lookAt the local-space point the camera aims at (this is the "rotation"
--             tuning — move it to change where the shot is angled)
--      fov    tighter/wider shot
--  Tune these per station type (stove, fryer, etc) to taste.
local STATION_CAM = {
    stovetop     = { pos = vector3(0.0, -0.9, 1.80), lookAt = vector3(0.0, 0.0, 1.10), fov = 42.0 },
    fryer        = { pos = vector3(0.0, -0.9, 1.80), lookAt = vector3(0.0, 0.0, 1.10), fov = 42.0 },
    soda_machine = { pos = vector3(0.0, -1.15, 1.65), lookAt = vector3(0.0, 0.0, 1.25), fov = 44.0 },
    kitchen_prep = { pos = vector3(0.0, -0.9, 1.75), lookAt = vector3(0.0, 0.0, 1.05), fov = 42.0 },
}
local DEFAULT_CAM = { pos = vector3(0.0, -1.15, 0.85), lookAt = vector3(0.0, 0.0, 1.12), fov = 42.0 }

-- Resolve a local-space offset to world coords using the entity's transform when
-- it exists, falling back to rotating the offset around the stored prop heading.
local function localToWorld(prop, ent, o)
    if ent and DoesEntityExist(ent) then
        return GetOffsetFromEntityInWorldCoords(ent, o.x, o.y, o.z)
    end
    local station = vector3(prop.x + 0.0, prop.y + 0.0, prop.z + 0.0)
    local h = math.rad(prop.heading or 0.0)
    local cosH, sinH = math.cos(h), math.sin(h)
    return station + vector3(o.x * cosH - o.y * sinH, o.x * sinH + o.y * cosH, o.z)
end

-- Frame the interacted station from its own front, slightly raised and angled
-- down at the worktop — reads like leaning over the counter.
function StartStationCamera(prop)
    if StationCam then StopStationCamera() end
    local cfg = STATION_CAM[prop.prop_type] or DEFAULT_CAM
    local ent = (GetStationEntity and GetStationEntity(prop.id)) or nil

    local camPos = localToWorld(prop, ent, cfg.pos)
    local lookAt = localToWorld(prop, ent, cfg.lookAt)

    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",
        camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0, cfg.fov, false, 0)
    PointCamAtCoord(cam, lookAt.x, lookAt.y, lookAt.z)
    SetCamActive(cam, true)
    -- A virtual session is built behind a screen fade at a shell that can be
    -- anywhere (underground / in the sky), far from the player's real position.
    -- Easing from the live gameplay camera would drag the shot from the player
    -- down through the terrain to the shell — so cut STRAIGHT to the framed shell
    -- (no interp): the first frame the fade reveals is already the station. A
    -- physical station eases as before (ease = true) for the smooth lean-in.
    if prop.virtual then
        RenderScriptCams(true, false, 0, true, true)
    else
        RenderScriptCams(true, true, EASE_MS, true, true)
    end
    StationCam = cam
    StationActive = true

    -- Hide the player's own ped ~200ms before the entry ease finishes, so the prop
    -- view settles without the ped popping out of frame. Guarded on the session
    -- flag (not cam identity) so a mid-transition view swap doesn't cancel it.
    --
    -- `SetLocalPedHidden` (modules/interactive), NEVER `SetEntityVisible`: this is a
    -- presentation choice about OUR OWN shot, and on a player ped `SetEntityVisible`
    -- propagates — the whole server watched the cook vanish. The comment here used to
    -- claim visibility wasn't networked. It is.
    --
    -- A VIRTUAL session never hides it. The point of hiding is to keep the ped out
    -- of a shot it is standing in — and in a virtual session the ped isn't in the
    -- shot at all: it stays exactly where it was while the camera cuts to the shell.
    -- So the hide bought nothing, and left the player's own body missing from the
    -- room they are physically standing in (theirs is the only client that sees it
    -- go). They are still there, so they should still look it.
    if not prop.virtual then
        CreateThread(function()
            Wait(EASE_MS - 200)
            if StationActive then
                SetLocalPedHidden(true)
            end
        end)
    end
    return cam
end

-- ─── sub-view switching (stovetop oven doors) ────────────────────────────────
--  While inside the station experience we can re-frame onto a sub-part without
--  leaving the scripted camera. Offsets are in the entity's LOCAL space, same
--  as STATION_CAM. Only the LEFT door (#1) is tuned; the RIGHT door (#2) mirrors
--  it by flipping ONLY X — matching how the door props themselves mirror.
local STOVE_DOOR_VIEWS = {
    door1 = { pos = vector3(-0.40, -1.025, 0.95), lookAt = vector3(-0.26, 0.0, 0.35), fov = 38.0 },
}

local function flipX(cfg)
    return {
        pos    = vector3(-cfg.pos.x, cfg.pos.y, cfg.pos.z),
        lookAt = vector3(-cfg.lookAt.x, cfg.lookAt.y, cfg.lookAt.z),
        fov    = cfg.fov,
    }
end

local function resolveView(prop, viewKey)
    if viewKey == "door1" then return STOVE_DOOR_VIEWS.door1 end
    if viewKey == "door2" then return flipX(STOVE_DOOR_VIEWS.door1) end
    return STATION_CAM[prop.prop_type] or DEFAULT_CAM
end

-- Smoothly re-frame the active station camera onto the cooktop or an oven door.
function SetStationView(prop, viewKey)
    if not StationActive or not StationCam then return end
    local cfg = resolveView(prop, viewKey)
    local ent = (GetStationEntity and GetStationEntity(prop.id)) or nil
    local camPos = localToWorld(prop, ent, cfg.pos)
    local lookAt = localToWorld(prop, ent, cfg.lookAt)

    local newCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",
        camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0, cfg.fov, false, 0)
    PointCamAtCoord(newCam, lookAt.x, lookAt.y, lookAt.z)

    local old = StationCam
    StationCam = newCam
    -- Interp from whatever cam is currently rendering into the new framing.
    SetCamActiveWithInterp(newCam, old, VIEW_EASE_MS, 1, 1)
    CreateThread(function()
        Wait(VIEW_EASE_MS + 50)
        if old and DoesCamExist(old) and old ~= StationCam then DestroyCam(old, false) end
    end)
end

function StopStationCamera()
    local cam = StationCam
    if not cam then return end
    StationCam = nil
    StationActive = false
    -- Ease back to the gameplay camera, then tear the scripted cam down once the
    -- transition has finished so the hand-off stays smooth.
    RenderScriptCams(false, true, EASE_MS, true, true)
    -- Unhide the player 200ms into the exit ease, so they fade back in as the
    -- gameplay camera takes over rather than snapping in at the very start.
    CreateThread(function()
        Wait(200)
        SetLocalPedHidden(false)
    end)
    CreateThread(function()
        Wait(EASE_MS + 50)
        if DoesCamExist(cam) then DestroyCam(cam, false) end
    end)
end

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    if StationCam and DoesCamExist(StationCam) then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(StationCam, false)
        StationCam = nil
    end
    StationActive = false
    -- Don't leave the player invisible if we tear down mid-session.
    SetLocalPedHidden(false)
end)
