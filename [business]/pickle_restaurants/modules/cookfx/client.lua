-- =============================================
--  modules/cookfx | client.lua
--  The kitchen's PARTICLES: steam off a griddle, bubbling off a fryer basket,
--  smoke off food that's gone too far — and the FIRE a station catches when burnt
--  food is left on it (modules/cookfx/server.lua owns that state; this draws it and
--  runs the "press G to put it out" interaction).
--
--  It keeps no cooking state of its own: every tick it asks `CookFxItems()`
--  (modules/cooking/client.lua) what is on a station right now and reconciles the
--  live effect handles against that. A looped PTFX is a handle you must stop by
--  hand, so "start what's missing, stop what's gone" is the whole design — nothing
--  can leak an effect when an item is collected, streamed out, or the resource stops.
-- =============================================

-- TUNE IN-GAME. Every effect names its OWN asset, so a server can point any single
-- one at an effect from a different dictionary (or an add-on asset) without the rest
-- having to live there too. The shipped picks are all in `core`, which is always
-- present, but nothing here assumes that — each asset is streamed in on first use.
--   `asset` is the PTFX dictionary, `name` the effect inside it, `scale` the PTFX
--   scale, `dz` how far above the item/station it sits (m).
local FX = {
    -- gentle steam off anything actively cooking on the plate
    sizzle  = { asset = "scr_fbi5a", name = "scr_bio_grille_singed",         scale = 0.05, dz = 0.03 },
    -- a lowered basket churns harder than a griddle
    fry     = { asset = "scr_fbi5a", name = "scr_bio_grille_singed",         scale = 2.40, dz = -0.025 },
    -- burnt food smokes whether or not it's still being cooked
    smoke   = { asset = "core", name = "exp_grd_grenade_smoke", scale = 0.30, dz = 0.06 },
    -- The station fire's PARTICLE layer. The FLAME itself is a real script fire
    -- (see below) — these two sit on top of it: a flame-heavy ptfx to thicken the
    -- burn, and the smoke column that makes it readable from across the room.
    fire    = { asset = "scr_trevor3", name = "scr_trev3_trailer_fire", scale = 0.60, dz = 0.10 },
    fireSmoke = { asset = "core", name = "exp_grd_grenade_smoke", scale = 0.90, dz = 0.90 },
    draw_distance = 40.0, -- don't spawn effects further away than this
    tick_ms       = 250,  -- reconcile interval
}

-- THE FIRE IS A REAL FIRE. Particles alone can't do this: a ptfx casts no light,
-- throws no heat and damages nobody, so a "burning" station rendered only as
-- particles reads as a smoke machine — which is exactly what it looked like. A
-- script fire is the engine's own fire entity: proper flames, it lights the room
-- around it, and it hurts whoever stands in it. Each client starts its OWN local
-- fire off the server's authoritative burning-station list, so no fire netcode is
-- needed and every player sees one in the same place.
local FIRE = {
    children    = 1,     -- how far it may spread. 1 = stays on the station. Raise
                         -- this and a kitchen fire will genuinely take the building.
    gas         = false, -- gas fires flare differently and burn out fast
    reignite_ms = 8000,  -- script fires burn themselves out; a station fire must not,
                         -- so it's re-lit on this interval until someone puts it out
    dz          = 0.05,  -- height above the station's top surface
}

local Active = {}   -- [key] = ptfx handle currently playing
local Fires  = {}   -- [propId] = true (server-authoritative; see cookfx/server.lua)
local FireCfg = { ms = 5000, reach = 4.0 } -- pushed with the list, never a second copy

-- Stream one effect's asset in, bounded. Nothing is cached as "ready" — an asset can
-- be evicted, and HasNamedPtfxAssetLoaded is the only honest answer, so we ask it
-- every time and only pay the wait when it actually isn't there.
local function ensureAsset(asset)
    if not asset or asset == "" then return false end
    if HasNamedPtfxAssetLoaded(asset) then return true end
    RequestNamedPtfxAsset(asset)
    local t = GetGameTimer()
    while not HasNamedPtfxAssetLoaded(asset) and GetGameTimer() - t < 3000 do Wait(0) end
    return HasNamedPtfxAssetLoaded(asset)
end

local function stopFx(key)
    local h = Active[key]
    if h then
        if DoesParticleFxLoopedExist(h) then StopParticleFxLooped(h, false) end
        Active[key] = nil
    end
end

local function stopAll()
    for key in pairs(Active) do stopFx(key) end
end

-- Start `cfg` on `ent` unless it's already running for this key. The key encodes
-- the effect too ("sizzle:12"), so a raw patty that burns swaps steam for smoke
-- simply by wanting a different key — the old one falls out of the desired set.
local function wantFx(desired, key, ent, cfg, dz)
    desired[key] = true
    if Active[key] and DoesParticleFxLoopedExist(Active[key]) then return end
    if not ensureAsset(cfg.asset) then return end
    UseParticleFxAssetNextCall(cfg.asset)
    local h = StartParticleFxLoopedOnEntity(cfg.name, ent, 0.0, 0.0, dz or cfg.dz,
                                            0.0, 0.0, 0.0, cfg.scale, false, false, false)
    if h and h ~= 0 then Active[key] = h end
end

-- How high a station's fire should sit: on top of the model, not inside it.
local function stationTop(ent)
    local mn, mx = GetModelDimensions(GetEntityModel(ent))
    if mx then return mx.z end
    return 0.5
end

local function nearPlayer(ent)
    local p = GetEntityCoords(PlayerPedId())
    return #(GetEntityCoords(ent) - p) <= FX.draw_distance
end

-- ─── the flame (real script fires) ───────────────────────────────────────────

local ScriptFires = {} -- [propId] = { handle = fireId, at = GetGameTimer() }

local function killScriptFire(propId)
    local f = ScriptFires[propId]
    if not f then return end
    if f.handle and f.handle ~= -1 then RemoveScriptFire(f.handle) end
    ScriptFires[propId] = nil
end

local function killAllScriptFires()
    for propId in pairs(ScriptFires) do killScriptFire(propId) end
end

-- Light (or re-light) a station's fire. A script fire burns ITSELF out after a
-- while, which is right for a car wreck and wrong for a kitchen fire nobody has
-- dealt with — so it's re-lit on a timer until the server says it's out.
local function wantScriptFire(propId, x, y, z)
    local f = ScriptFires[propId]
    if f and GetGameTimer() - f.at < FIRE.reignite_ms then return end
    killScriptFire(propId)
    local handle = StartScriptFire(x, y, z, FIRE.children, FIRE.gas)
    if handle and handle ~= -1 then
        ScriptFires[propId] = { handle = handle, at = GetGameTimer() }
    end
end

-- Where a burning station's flames belong, in WORLD space (a script fire is a
-- point in the world, not something attached to an entity). Falls back to the
-- synced prop row so a station whose model hasn't streamed in — or a virtual one
-- with no world entity at all — still burns.
local function stationFirePoint(propId, ent)
    if ent and DoesEntityExist(ent) then
        local c = GetEntityCoords(ent)
        return vector3(c.x, c.y, c.z + stationTop(ent) + FIRE.dz)
    end
    local row = GetClientProp and GetClientProp(propId)
    if row then return vector3(row.x + 0.0, row.y + 0.0, row.z + 0.9 + FIRE.dz) end
    return nil
end

-- ─── the reconcile ───────────────────────────────────────────────────────────
CreateThread(function()
    while true do
        local desired = {}

        -- 1. food on stations
        for _, it in ipairs(CookFxItems and CookFxItems() or {}) do
            if it.ent and DoesEntityExist(it.ent) and nearPlayer(it.ent) then
                if it.state == "burnt" then
                    -- ruined food smokes for as long as it's left there — the visible
                    -- warning that this station is minutes away from catching fire
                    wantFx(desired, "smoke:" .. it.uid, it.ent, FX.smoke)
                elseif it.active and (it.method == "grill" or it.method == "fry" or it.method == "oven") then
                    wantFx(desired, "sizzle:" .. it.uid, it.ent,
                           it.method == "fry" and FX.fry or FX.sizzle)
                end
            end
        end

        -- 2. stations on fire: a real flame, plus particles on top of it
        local me = GetEntityCoords(PlayerPedId())
        for propId in pairs(Fires) do
            local ent  = GetClientPropEntity and GetClientPropEntity(propId)
            local at   = stationFirePoint(propId, ent)
            local near = at and #(at - me) <= FX.draw_distance
            if near then
                wantScriptFire(propId, at.x, at.y, at.z)
                -- the ptfx ride on the entity, so they only apply when one exists
                if ent and DoesEntityExist(ent) then
                    local top = stationTop(ent)
                    wantFx(desired, "fire:" .. propId, ent, FX.fire, top + FX.fire.dz)
                    wantFx(desired, "firesmoke:" .. propId, ent, FX.fireSmoke, top + FX.fireSmoke.dz)
                end
            else
                killScriptFire(propId) -- out of range: stop paying for it
            end
        end

        -- 3. stop everything nobody asked for this pass (collected, streamed out,
        --    walked away from, extinguished)
        for key in pairs(Active) do
            if not desired[key] then stopFx(key) end
        end
        for propId in pairs(ScriptFires) do
            if not Fires[propId] then killScriptFire(propId) end
        end

        Wait(FX.tick_ms)
    end
end)

-- ─── fighting the fire ───────────────────────────────────────────────────────

RegisterNetEvent("pickle_restaurants:cookfx:fires", function(list, tune)
    if type(tune) == "table" then
        FireCfg.ms    = tonumber(tune.ms) or FireCfg.ms
        FireCfg.reach = tonumber(tune.reach) or FireCfg.reach
    end
    local next_ = {}
    for _, f in ipairs(list or {}) do next_[tonumber(f.prop_id) or f.prop_id] = true end
    -- drop the particles of any fire that just went out, immediately (the reconcile
    -- would get there anyway, but a doused fire should vanish on the same frame)
    for propId in pairs(Fires) do
        if not next_[propId] then
            stopFx("fire:" .. propId)
            stopFx("firesmoke:" .. propId)
            killScriptFire(propId) -- the flame especially: it outlives its ptfx
        end
    end
    -- A station that catches fire WHILE somebody is working it throws them out.
    -- The openStation gate only stops you walking up to a burning station; without
    -- this, whoever was already inside keeps cooking on it indefinitely — the one
    -- way to use a station that's on fire.
    local openId = CookingStationId and CookingStationId()
    if openId and next_[openId] and not Fires[openId] then
        ShowNotification(_L("cook_station_on_fire"))
        if ForceStopCooking then ForceStopCooking() end
    end
    Fires = next_
end)

local function helpText(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- The nearest burning station within arm's reach, or nil.
local function fireInReach()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local best, bestD
    for propId in pairs(Fires) do
        local prop = GetClientProp and GetClientProp(propId)
        if prop then
            local d = #(pos - vector3(prop.x + 0.0, prop.y + 0.0, prop.z + 0.0))
            if d <= FireCfg.reach and (not bestD or d < bestD) then best, bestD = propId, d end
        end
    end
    return best
end

local fighting = false

local function fightFire(propId)
    if fighting then return end
    fighting = true
    local ped = PlayerPedId()
    -- No extinguisher WEAPON is forced on the player (a server may not want the
    -- pickup at all): the gesture is the generic "working on something" clip, and
    -- the server is what decides whether you were carrying the item.
    if lib and lib.progressBar then
        lib.progressBar({ duration = FireCfg.ms, label = _L("fire_extinguishing"),
                          useWhileDead = false, canCancel = true,
                          disable = { move = true, combat = true },
                          anim = { dict = "amb@world_human_stand_impatient@male@no_sign@base",
                                   clip = "base" } })
    else
        Wait(FireCfg.ms)
    end
    if DoesEntityExist(ped) then ClearPedTasks(ped) end
    local res = lib.callback.await("pickle_restaurants:cookfx:extinguish", false, { prop_id = propId })
    if not (res and res.ok) and res and res.error then ShowNotification(res.error) end
    fighting = false
end

CreateThread(function()
    while true do
        local wait = 500
        if next(Fires) ~= nil and not fighting then
            local propId = fireInReach()
            if propId then
                wait = 0
                helpText(_L("fire_extinguish_prompt"))
                -- G, not E: E is the station's own "open kitchen" interaction, and
                -- pressing it at a burning station would fire both (the open is
                -- refused server-side, but the double prompt reads as a bug).
                if IsControlJustPressed(0, 47) then -- INPUT_DETONATE (G)
                    CreateThread(function() fightFire(propId) end)
                end
            end
        end
        Wait(wait)
    end
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    stopAll()
    -- a script fire is a WORLD entity: left behind on a restart it would keep
    -- burning (and keep hurting people) with nothing left to put it out
    killAllScriptFires()
end)
