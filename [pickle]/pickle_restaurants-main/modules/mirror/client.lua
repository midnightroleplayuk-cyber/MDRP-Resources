-- =============================================
--  modules/mirror | client.lua
--  THINGS THIS RESOURCE RENDERS FOR ONE PLAYER, SHOWN TO THE ROOM. Almost everything
--  in a restaurant is world-visible because it renders from SERVER state — a patty on
--  a grill, a tray in an oven, a cup under a tap. Two things were not, and both are
--  the most legible thing the player doing them does:
--    • the PREP TABLE's build (modules/cooking), and
--    • a seated diner's laid-out MEAL (modules/dining).
--  From the outside, both looked like someone miming at an empty surface.
--
--  Neither can move to the server: both are client-authored geometry (free 2D
--  placement under a cursor, per-part offsets, a lid mid-swing, a tray laid out on
--  whatever surface the seat names) and the server holds RESERVATIONS and SLOTS, not
--  positions. Teaching it the layout would be a second copy of maths that could only
--  drift. So the OWNER PUBLISHES WHAT THEY SEE, keyed by a placed prop — the station
--  or the seat anchor — and everyone near that prop spawns plain local props from it.
--  The key is what gives this an audience and a walk-into-range hydration edge, i.e.
--  what makes it a scoped event rather than a broadcast.
--
--  Both ends live here:
--    • PUBLISHER — polls this client's snapshot providers and sends on CHANGE only.
--    • RECEIVER — holds a set of props per mirrored prop id, reconciled by DIFF.
--
--  What it spawns is DECORATION: local, frozen, collisionless copies of someone
--  else's work. Never dragged, never hovered, never consumed — the owner's client
--  owns all of that — so nothing here can ever become an input to a build, a meal or
--  fulfilment. Same relationship modules/cookfx has to the cooking module: it renders
--  what another module is authoritative about and holds no state beyond its handles.
-- =============================================

local PUBLISH_MS = 150   -- how often the author may publish a CHANGE (TUNE IN-GAME)
local IDLE_MS    = 500   -- poll while there is nothing to publish
-- Range for holding someone else's mirror. Same shape as CookRange (out > in so
-- pacing the boundary doesn't thrash) and deliberately tighter than the server's
-- ScopeRadius.PROP: the server must already be sending us a prop's updates before we
-- ask for its state, or a change landing between the reply and our arrival is lost.
local RANGE = { ms = 1000, ["in"] = 70.0, out = 85.0 }

-- Prop types that can carry a mirror. A seat's is the diner's meal; a prep table's is
-- the cook's build. Everything else renders from server state already.
local MIRRORED = { kitchen_prep = true, seat = true }

-- [propId] = { rows = { … }, ents = { entity, … } } — what we hold for someone
-- else's surface. Index-aligned with the rows we were sent, so an unchanged row is
-- left alone and a moved one is moved rather than rebuilt.
local Mirrors = {}
local subbed  = {}   -- [propId] = true while we're in range and holding it

local function safeDelete(ent)
    if not ent or not DoesEntityExist(ent) then return end
    if QuadDetach then QuadDetach(ent) end -- drop any food picture riding this prop
    SetEntityAsMissionEntity(ent, true, true)
    DeleteEntity(ent)
end

local function loadModel(hash)
    if not hash or not IsModelInCdimage(hash) then return false end
    if HasModelLoaded(hash) then return true end
    RequestModel(hash)
    local t0 = GetGameTimer()
    while not HasModelLoaded(hash) and GetGameTimer() - t0 < 2000 do Wait(0) end
    return HasModelLoaded(hash)
end

local function seatProp(ent, r)
    SetEntityCoordsNoOffset(ent, r.x, r.y, r.z, false, false, false)
    SetEntityRotation(ent, r.rx or 0.0, r.ry or 0.0, r.rz or 0.0, 2, true)
    -- A takeout box carries its food as a drawn quad, not as part of the model, so a
    -- mirrored box needs it re-asserted the same way the kitchen does (idempotent per
    -- url, so doing it on every move is free). Same numbers as SeatTakeoutPart: the
    -- box rectangle is Config.BoxQuad, embedded config both sides read.
    if r.q and QuadAttach then
        local q = Config.BoxQuad or {}
        QuadAttach(ent, r.q, { w = q.w or 0.295, h = q.h or 0.2, dz = q.dz or 0.012, crop = r.qc })
    elseif QuadDetach and QuadAttached and QuadAttached(ent) then
        QuadDetach(ent)
    end
end

-- ─── receiver ────────────────────────────────────────────────────────────────

function DropMirror(propId)
    local m = Mirrors[propId]
    if not m then return end
    Mirrors[propId] = nil
    for _, e in ipairs(m.ents) do safeDelete(e) end
end

-- Reconcile our copies against the picture we were just sent. DIFFED, not rebuilt: a
-- cook dragging a burger publishes several times a second, and deleting and
-- re-spawning every prop at that rate is both a stutter and a stream of models the
-- engine has to load, while moving an existing one is free. Same reason modules/main's
-- prop reconciler diffs instead of respawning on every sync.
local function applyMirror(propId, rows)
    rows = type(rows) == "table" and rows or {}
    if #rows == 0 then return DropMirror(propId) end
    local m = Mirrors[propId]
    if not m then m = { rows = {}, ents = {} }; Mirrors[propId] = m end
    for i, r in ipairs(rows) do
        local prev, ent = m.rows[i], m.ents[i]
        if ent and DoesEntityExist(ent) and prev and prev.m == r.m then
            seatProp(ent, r) -- same prop in this slot: just move it (and its picture)
        else
            safeDelete(ent)
            m.ents[i] = nil
            if loadModel(r.m) then
                -- LOCAL, non-mission, exactly like every food prop this resource
                -- renders (see the note on SafeDeleteEntity in modules/cooking).
                local e = CreateObject(r.m, r.x, r.y, r.z, false, false, false)
                SetModelAsNoLongerNeeded(r.m)
                if e and DoesEntityExist(e) then
                    -- Frozen and collisionless: this is a PICTURE of another player's
                    -- table. A solid copy would shove people standing at the counter
                    -- and could be pushed out of the layout it is meant to depict.
                    FreezeEntityPosition(e, true)
                    SetEntityCollision(e, false, false)
                    seatProp(e, r)
                    m.ents[i] = e
                end
            end
            -- The mirror may have been dropped while a model streamed (walked out of
            -- range, the owner left): whatever we just made belongs to nobody.
            if Mirrors[propId] ~= m then
                safeDelete(m.ents[i])
                return
            end
        end
    end
    -- rows the picture no longer has
    for i = #rows + 1, #m.ents do
        safeDelete(m.ents[i])
        m.ents[i] = nil
    end
    m.rows = rows
end

-- Our OWN surface is never mirrored: the real props are already in front of us, and a
-- second set in the same place would z-fight with them. Both authorities are asked,
-- since a client is only ever one of them but this file serves both.
local function isMine(propId)
    if CookingStationId and CookingStationId() == propId then return true end
    local row = CurrentSeat and CurrentSeat()
    return (row and row.id == propId) or false
end

RegisterNetEvent("pickle_restaurants:mirror:set", function(propId, rows)
    propId = tonumber(propId)
    if not propId then return end
    if isMine(propId) then return DropMirror(propId) end
    applyMirror(propId, rows)
end)

-- THE HYDRATION EDGE. A scoped event a distant player missed is only safe if arriving
-- in range re-fetches the state; this is that fetch.
--
-- ASKED IN ONE CALL FOR THE WHOLE PASS, never one call per prop. Seats are mirrored
-- too and a restaurant has dozens of them, so walking through the door would otherwise
-- fire a callback per chair — for a question that is "nothing there" for almost all of
-- them. The server answers { [propId] = rows } and omits the empty ones.
function HydrateMirrors(ids)
    local ask = {}
    for _, id in ipairs(ids or {}) do
        if not isMine(id) then ask[#ask + 1] = id end
    end
    if #ask == 0 then return end
    local res = lib.callback.await("pickle_restaurants:mirror:state", false, { ids = ask })
    if type(res) ~= "table" then return end
    for _, id in ipairs(ask) do
        applyMirror(id, res[id] or res[tostring(id)] or {})
    end
end

-- Range watcher: hold a mirror only for the surfaces we're standing near. Same shape
-- as the cooking module's CookRange (which does this for a station's cooking items),
-- and separate from it because a SEAT carries a mirror and no cooking items at all.
CreateThread(function()
    while true do
        Wait(RANGE.ms)
        local props = GetClientProps and GetClientProps() or nil
        if props then
            local pc = GetEntityCoords(PlayerPedId())
            local fresh = {} -- newly in range this pass, hydrated together below
            -- A prop that no longer exists takes its subscription with it, or the id
            -- coming back would look like something we already hold.
            for pid in pairs(subbed) do
                if not props[pid] then subbed[pid] = nil; DropMirror(pid) end
            end
            for _, p in pairs(props) do
                if MIRRORED[p.prop_type] and p.x then
                    local d = #(pc - vector3(p.x, p.y, p.z))
                    if subbed[p.id] then
                        if d > RANGE.out then
                            subbed[p.id] = nil
                            DropMirror(p.id)
                        end
                    elseif d < RANGE["in"] then
                        -- claim BEFORE the await, for the same reason CookRange does:
                        -- it yields, and a second pass would ask again and double-spawn
                        subbed[p.id] = true
                        fresh[#fresh + 1] = p.id
                    end
                end
            end
            if #fresh > 0 then HydrateMirrors(fresh) end
        end
    end
end)

-- ─── publisher ───────────────────────────────────────────────────────────────

-- This client's snapshot providers, in the order they're asked. Only one can ever be
-- live at a time (you cannot work a prep table and eat a seated meal at once), so the
-- first answer wins and there is only ever one key being published.
local function snapshot()
    if PrepMirrorSnapshot then
        local propId, rows = PrepMirrorSnapshot()
        if propId then return propId, rows end
    end
    if MealMirrorSnapshot then
        local propId, rows = MealMirrorSnapshot()
        if propId then return propId, rows end
    end
    return nil
end

CreateThread(function()
    local lastSig, lastProp = nil, nil
    while true do
        local propId, rows = snapshot()
        if propId then
            -- The signature is what decides whether anything actually CHANGED. Built
            -- from the same rounded numbers that get sent, so a prop standing still
            -- can never publish itself over and over.
            local parts = {}
            for _, r in ipairs(rows) do
                parts[#parts + 1] = ("%d|%s|%s|%s|%s|%s|%s|%s"):format(r.m, r.x, r.y, r.z, r.rx, r.ry, r.rz, r.q or "")
            end
            local sig = table.concat(parts, ";")
            if sig ~= lastSig or propId ~= lastProp then
                -- Moved to a different surface: retire the old one first, or what we
                -- left there would keep standing because nothing said otherwise.
                if lastProp and lastProp ~= propId then
                    TriggerServerEvent("pickle_restaurants:mirror:publish", lastProp, {})
                end
                lastSig, lastProp = sig, propId
                TriggerServerEvent("pickle_restaurants:mirror:publish", propId, rows)
            end
            Wait(PUBLISH_MS)
        else
            -- Stepped away with something still out: say so once. The server also
            -- clears when the claim / the seat is given up and on a disconnect — this
            -- is the cheap, immediate one.
            if lastProp then
                TriggerServerEvent("pickle_restaurants:mirror:publish", lastProp, {})
                lastProp, lastSig = nil, nil
            end
            Wait(IDLE_MS)
        end
    end
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for propId in pairs(Mirrors) do DropMirror(propId) end
end)
