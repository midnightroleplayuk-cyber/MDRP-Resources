-- =============================================
--  modules/supply | client.lua
--  The world half of a SUPPLY RUN: the depot's bays, the pile of boxes, carrying one
--  to the trailer, and the driver who takes the load away.
--
--  What is authored where:
--    • THE PILE IS NOT OURS. `taken`/`loaded` are server state (modules/supply/server),
--      pushed to everyone near the bay and re-fetched on approach — so a box leaving the
--      stack goes down on every screen at once, and a player who walks up halfway
--      through a run sees the pile as it actually is rather than as it started. This
--      client renders that number; it never decides it.
--    • The boxes are LOCAL props. They are scenery: nothing picks one up but the
--      claimer, and what they are carrying is a number the server already holds.
--    • THE RIG IS NETWORKED, because an NPC driving a truck away is the whole point and
--      a local one would be a man miming at a warehouse. Networked means it outlives us,
--      so the net ids go to the server the moment they exist (the doorstep contract) and
--      it deletes them if we never get to.
--
--  A depot is loaded by PROXIMITY, like everything else in this resource: a client holds
--  the bays it is standing in, not every warehouse on the map.
-- =============================================

-- TUNE IN-GAME
local ZONE_IN, ZONE_OUT = 100.0, 130.0   -- hysteresis on a bay's package point
local PILE = {
    cols   = 2,      -- boxes per row of the stack
    rows   = 2,      -- rows per layer
    gap    = 0.06,   -- gap between boxes (metres)
}
-- Carrying: the widely-used heist carry pose, on the right-hand prop bone. The offsets
-- are per-POSE, not per-box: a different carry clip needs different numbers, which is
-- why they sit next to the dict rather than next to the model.
local CARRY = {
    dict = "anim@heists@box_carry@", clip = "idle",
    bone = 60309,
    off  = { x = 0.03, y = 0.08, z = 0.22 },
    rot  = { x = 0.0, y = 0.0, z = 0.0 },
}
-- WHERE YOU LOAD IS THE BACK OF THE TRAILER, not the middle of it. The placed point is
-- the trailer's ORIGIN, which on a vehicle is roughly its centre, so an interaction sat
-- on it put the prompt (and the map marker) halfway down a 12m box. The rear face is
-- measured off the model rather than guessed, because the trailer is configurable.
local TRAILER = {
    load_gap = 1.4,   -- how far behind the rear face you stand to load (m)
    load_z   = 0.5,   -- lift on the target zone, so it sits at the bed, not the tarmac
}
local DEPART_SPEED  = 18.0
local DEPART_STYLE  = 786603   -- normal driving flags

local Zones        = {}   -- [key] = { key, depot, zone } every bay we know of, from the sync
local Near         = {}   -- [key] = true while we're inside ZONE_IN of the bay
local State        = {}   -- [key] = last server state { active, owner, boxes, taken, loaded }
local BoxProps     = {}   -- [key] = { entity, … } the pile currently rendered
local ZoneIx       = {}   -- [key] = { package = idx, trailer = idx } (NOT `Interactions`,
                          --  which is core/client.lua's own global — never shadow it)
local DepotBlips   = {}

-- Do we have a paid order that isn't currently on a bay? Only true after a run ended
-- without being collected (abandoned, lapsed, disconnected), which is exactly when the
-- resume offer should appear. Seeded by the range hydration and kept live by the run
-- events, so a reconnect is not a special case.
local PendingOrder = false
local LoadAt       = {}   -- [key] = memoized loading point (resolving one can stream a model)
-- Forward: the run actions below retarget the bays, and the interaction code that does
-- it is defined after them.
local syncAllInteractions

local MyRun    = nil   -- the run WE claimed: { key, boxes, package, trailer, models… }
local CarryEnt  = nil  -- the box in our hands
local carrying  = false

local function cfg() return Supply end

-- ─── small helpers ───────────────────────────────────────────────────────────

local function keyFor(depotId, zoneId) return tostring(depotId) .. "|" .. tostring(zoneId) end

local function vec(p) return vector3(p.x + 0.0, p.y + 0.0, p.z + 0.0) end

-- Forward vector of a heading, in the same convention the placement gizmo saves.
local function forwardOf(heading)
    local rad = math.rad(heading or 0.0)
    return vector3(-math.sin(rad), math.cos(rad), 0.0)
end

local function loadModel(model)
    local hash = (type(model) == "number") and model or GetHashKey(model)
    if not IsModelInCdimage(hash) then return nil end
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) and GetGameTimer() - t < 10000 do Wait(0) end
    if not HasModelLoaded(hash) then return nil end
    return hash
end

-- Metres from a trailer's origin back to its rear face, measured once per model.
local rearOfModel = {}

local function trailerRear(model)
    model = model or "trailers"
    if rearOfModel[model] then return rearOfModel[model] end
    local hash = loadModel(model)
    if not hash then return 0.0 end
    local mn = GetModelDimensions(hash)
    SetModelAsNoLongerNeeded(hash)
    rearOfModel[model] = math.abs(mn.y or 0.0)
    return rearOfModel[model]
end

-- WHERE YOU PUT THE BOX. The admin places this against a side-on camera
-- (`PickTrailerLoadPoint`), so normally it is simply read off the bay. The measured
-- fallback is for a bay placed before that pass existed: step back from the trailer's
-- origin by the model's own rear extent, which is the guess the pass replaced. The rig
-- spawns FORWARD of the placed point (the truck sits at +truck_gap), so the rear is the
-- other way along the same heading.
local function trailerLoadPoint(zone)
    if zone.load then return vec(zone.load) end
    local t = zone.trailer
    local back = trailerRear(cfg() and cfg().trailer_model) + TRAILER.load_gap
    return vec(t) - forwardOf(t.heading) * back
end

-- ─── the pile ────────────────────────────────────────────────────────────────
-- A PILE OF BOXES, built here — one entity per box, in a grid CENTRED on the package
-- point and turned to its facing. That is why `box_model` has to be a single box
-- (`hei_prop_heist_box`, `prop_cardbordbox_0*a`) and never a `prop_boxpile_*`: the
-- stack is ours to build, and a pile prop would stack piles, then put a whole pile in
-- the player's arms when they took one.
--
-- Every client builds the SAME pile from the same number — nothing about the layout is
-- local or random. Measured from the model rather than hardcoded: the box prop is
-- configurable, and a hardcoded step would space a different model wrong.

-- Grid step per axis, plus the LIFT that puts the bottom layer on the floor. The
-- placed point is ground level and CreateObject seats a model by its ORIGIN, so a box
-- whose origin is anywhere but its base sinks into the tarmac. The placement preview
-- applies the same lift (`GroundLift` in modules/placement), which is what keeps the
-- pile where the admin saw it.
local function boxStep(hash)
    local mn, mx = GetModelDimensions(hash)
    return math.abs(mx.x - mn.x) + PILE.gap,
           math.abs(mx.y - mn.y) + PILE.gap,
           math.abs(mx.z - mn.z),
           math.max(0.0, -(mn.z or 0.0))
end

local function clearPile(key)
    for _, ent in ipairs(BoxProps[key] or {}) do
        if DoesEntityExist(ent) then DeleteEntity(ent) end
    end
    BoxProps[key] = nil
end

-- Render exactly `count` boxes. A DIFF, not a rebuild: a run is a steady trickle of
-- single-box changes, and deleting and respawning the whole stack for each one is a
-- visible stutter on every screen at the depot.
local function renderPile(key, count)
    local z = Zones[key]
    if not z then return end
    if count <= 0 then return clearPile(key) end
    local have = BoxProps[key] or {}
    if #have > count then
        for i = #have, count + 1, -1 do
            if DoesEntityExist(have[i]) then DeleteEntity(have[i]) end
            have[i] = nil
        end
        BoxProps[key] = have
        return
    end
    if #have == count then return end

    local hash = loadModel(cfg() and cfg().box_model or "hei_prop_heist_box")
    if not hash then return end
    local sx, sy, sz, lift = boxStep(hash)
    local p = z.zone.package
    local fwd = forwardOf(p.heading)
    local right = vector3(fwd.y, -fwd.x, 0.0)
    for i = #have + 1, count do
        local n = i - 1
        local col   = n % PILE.cols
        local row   = math.floor(n / PILE.cols) % PILE.rows
        local layer = math.floor(n / (PILE.cols * PILE.rows))
        -- Centred on BOTH axes, so the placed point is the middle of the finished pile
        -- at floor level — which is what the placement preview (a single box sitting on
        -- that point) leads an admin to expect.
        local base = vec(p)
            + right * ((col - (PILE.cols - 1) / 2) * sx)
            + fwd   * ((row - (PILE.rows - 1) / 2) * sy)
        -- Seated from the PLACED POINT, never dropped to the ground: the point is where
        -- the admin put the preview box, and every client has to build the same pile
        -- out of the same number. Letting the physics settle each box would give a
        -- different answer per machine and put the upper layers somewhere else again.
        local ent = CreateObject(hash, base.x, base.y, base.z + lift + layer * sz, false, false, false)
        SetEntityHeading(ent, p.heading or 0.0)
        FreezeEntityPosition(ent, true)
        SetEntityCollision(ent, false, false)
        have[i] = ent
    end
    SetModelAsNoLongerNeeded(hash)
    BoxProps[key] = have
end

-- ─── carrying ────────────────────────────────────────────────────────────────

local function stopCarry()
    if CarryEnt and DoesEntityExist(CarryEnt) then DeleteEntity(CarryEnt) end
    CarryEnt = nil
    carrying = false
    local ped = PlayerPedId()
    if IsEntityPlayingAnim(ped, CARRY.dict, CARRY.clip, 3) then ClearPedTasks(ped) end
end

local function startCarry()
    local ped = PlayerPedId()
    local hash = loadModel(cfg() and cfg().box_model or "hei_prop_heist_box")
    if not hash then return false end
    RequestAnimDict(CARRY.dict)
    local t = GetGameTimer()
    while not HasAnimDictLoaded(CARRY.dict) and GetGameTimer() - t < 5000 do Wait(0) end
    TaskPlayAnim(ped, CARRY.dict, CARRY.clip, 5.0, -1, -1, 49, 0, false, false, false)
    local c = GetEntityCoords(ped)
    CarryEnt = CreateObject(hash, c.x, c.y, c.z, false, false, false)
    AttachEntityToEntity(CarryEnt, ped, GetPedBoneIndex(ped, CARRY.bone),
        CARRY.off.x, CARRY.off.y, CARRY.off.z, CARRY.rot.x, CARRY.rot.y, CARRY.rot.z,
        true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(hash)
    carrying = true
    return true
end

-- ─── the rig ─────────────────────────────────────────────────────────────────
-- Spawned by the claimer as NETWORKED vehicles, which is the only way an NPC can drive
-- one away in front of everybody. Locked on purpose: the trailer is the delivery, not a
-- vehicle anyone gets to take.

local function spawnRig(run)
    local trailerHash = loadModel(run.trailer_model)
    local truckHash   = loadModel(run.truck_model)
    if not trailerHash or not truckHash then return end
    local t = run.trailer
    local fwd = forwardOf(t.heading)
    local trailer = CreateVehicle(trailerHash, t.x, t.y, t.z, t.heading or 0.0, true, false)
    local tp = vec(t) + fwd * (run.truck_gap or 8.5)
    local truck = CreateVehicle(truckHash, tp.x, tp.y, tp.z, t.heading or 0.0, true, false)
    for _, v in ipairs({ trailer, truck }) do
        if DoesEntityExist(v) then
            SetVehicleDoorsLocked(v, 2)
            SetVehicleOnGroundProperly(v)
            SetEntityAsMissionEntity(v, true, true)
        end
    end
    if DoesEntityExist(truck) and DoesEntityExist(trailer) then
        AttachVehicleToTrailer(truck, trailer, 1.0)
    end
    SetModelAsNoLongerNeeded(trailerHash)
    SetModelAsNoLongerNeeded(truckHash)
    run.truck, run.trailerEnt = truck, trailer
    -- Report the net ids IMMEDIATELY: from here on the server can take them back out of
    -- the world if this client never reaches its own cleanup.
    local ids = {}
    for _, v in ipairs({ truck, trailer }) do
        if DoesEntityExist(v) then ids[#ids + 1] = NetworkGetNetworkIdFromEntity(v) end
    end
    TriggerServerEvent("pickle_restaurants:supply:entities", ids)
end

-- The load leaves. The driver is spawned INTO the cab and told to drive; the server
-- deletes the rig a little later, so nothing here has to wait around for it.
local function departRig(run)
    if not (run.truck and DoesEntityExist(run.truck)) then return end
    local pedHash = loadModel("s_m_m_trucker_01")
    if not pedHash then return end
    local driver = CreatePedInsideVehicle(run.truck, 4, pedHash, -1, true, false)
    SetModelAsNoLongerNeeded(pedHash)
    if not DoesEntityExist(driver) then return end
    SetEntityAsMissionEntity(driver, true, true)
    SetBlockingOfNonTemporaryEvents(driver, true)
    TriggerServerEvent("pickle_restaurants:supply:entities", { NetworkGetNetworkIdFromEntity(driver) })
    SetVehicleEngineOn(run.truck, true, true, false)
    TaskVehicleDriveWander(driver, run.truck, DEPART_SPEED, DEPART_STYLE)
end

-- ─── run actions ─────────────────────────────────────────────────────────────

-- WHERE THE WORK IS, ON THE MAP. A run is somewhere else in the depot from the counter
-- you paid at, and a warehouse yard reads as identical concrete in every direction. So
-- an active run marks both of its points, and the ROUTE follows what you should do next:
-- the pallet while there are boxes left to fetch, the trailer while you're carrying one.
-- Cleared with the run, on every ending.
local RunBlips = { package = nil, trailer = nil }

local function clearRunBlips()
    for k, b in pairs(RunBlips) do
        if b and DoesBlipExist(b) then RemoveBlip(b) end
        RunBlips[k] = nil
    end
end

local function makeRunBlip(p, sprite, colour, name)
    local b = AddBlipForCoord(p.x + 0.0, p.y + 0.0, p.z + 0.0)
    SetBlipSprite(b, sprite)
    SetBlipColour(b, colour)
    SetBlipScale(b, 0.85)
    SetBlipAsShortRange(b, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(b)
    return b
end

-- Point the GPS at whichever half of the job is next. Called on every state change, so
-- picking a box up moves the route to the trailer and dropping it off moves it back.
local function refreshRunRoute()
    if not MyRun then return end
    for k, b in pairs(RunBlips) do
        if b and DoesBlipExist(b) then SetBlipRoute(b, false) end
    end
    local target = carrying and RunBlips.trailer or RunBlips.package
    if target and DoesBlipExist(target) then
        SetBlipRoute(target, true)
        SetBlipRouteColour(target, 5)
    end
end

local function endMyRun()
    stopCarry()
    clearRunBlips()
    MyRun = nil
    if syncAllInteractions then syncAllInteractions() end
end

-- The order was paid for and a bay is already holding our boxes. Nothing to claim and
-- nothing to pick: the server hands us the run, we put the rig in the yard and mark the
-- two points on the map.
RegisterNetEvent("pickle_restaurants:supply:runStarted", function(run)
    if type(run) ~= "table" or not run.key then return end
    if MyRun then endMyRun() end
    MyRun = run
    spawnRig(run)
    clearRunBlips()
    RunBlips.package = makeRunBlip(run.package, 478, 5, _L("supply_blip_pallet"))
    -- Marked at the loading end for the same reason: the point of the blip is where to
    -- take the box, not where the vehicle's origin happens to be.
    RunBlips.trailer = makeRunBlip(trailerLoadPoint(run), 479, 3, _L("supply_blip_trailer"))
    refreshRunRoute()
    PendingOrder = true
    if syncAllInteractions then syncAllInteractions() end
    ShowNotification(_L("supply_run_started", run.boxes))
end)

local function takeBox()
    if carrying then return ShowNotification(_L("supply_hands_full")) end
    local res = lib.callback.await("pickle_restaurants:supply:takeBox", false)
    if not res or not res.ok then return ShowNotification((res and res.error) or _L("supply_no_run")) end
    if not startCarry() then return end
    refreshRunRoute()
    if syncAllInteractions then syncAllInteractions() end
end

local function loadBox()
    if not carrying then return ShowNotification(_L("supply_no_box")) end
    local res = lib.callback.await("pickle_restaurants:supply:loadBox", false)
    if not res or not res.ok then return ShowNotification((res and res.error) or _L("supply_no_run")) end
    stopCarry()
    if res.done then
        -- Collected: the order is gone, so no bay should be offering to resume it.
        PendingOrder = false
        local run = MyRun
        if run then departRig(run) end
        endMyRun()
    else
        refreshRunRoute()
        ShowNotification(_L("supply_boxes_left", res.left))
    end
    if syncAllInteractions then syncAllInteractions() end
end

local function abandonRun()
    lib.callback.await("pickle_restaurants:supply:abandon", false)
    endMyRun()
    ShowNotification(_L("supply_run_abandoned"))
end

-- Pick a paid-for order back up after a run ended without it being collected. No picker:
-- one active order per player means there is only ever one thing this can be.
local function resumeRun(key)
    local z = Zones[key]
    if not z then return end
    local res = lib.callback.await("pickle_restaurants:supply:resume", false,
        { depot = z.depot.id, zone = z.zone.id })
    if not (res and res.ok) then ShowNotification((res and res.error) or _L("supply_nothing_waiting")) end
end

-- ─── interactions ────────────────────────────────────────────────────────────
--
-- A TARGET IS AN OFFER, so it exists only when it is one. Standing prompts for both
-- points at once told the player they could pick a box up and load a box at the same
-- moment, and offered both to someone with no order at all. So the two points are
-- DIFFED against what you can actually do right now:
--
--   pallet   your run + boxes left, hands empty -> Pick up box
--            your run + nothing left to fetch   -> Give up the bay (the only escape)
--            idle bay + a paid order of yours   -> Resume supply run
--            anything else                      -> no target
--   trailer  your run + a box in your arms      -> Load box into trailer
--            anything else                      -> no target
--
-- Rebuilt by SIGNATURE, not on a timer: the inputs change a handful of times per run
-- (start, each pick-up, each drop-off, end), so this is nothing like the per-frame churn
-- the "build once" version was avoiding, and it can't leave a stale prompt behind.

-- The loading point per bay, memoized: resolving it can stream the trailer model on a
-- bay with no authored spot, and the interaction set is rebuilt several times a run.
local function loadPointFor(key)
    if LoadAt[key] then return LoadAt[key] end
    local z = Zones[key]
    if not z then return nil end
    local p = trailerLoadPoint(z.zone) + vector3(0.0, 0.0, TRAILER.load_z)
    -- The resolve above can YIELD (model streaming). A sync landing in that window
    -- rebuilds `Zones`, so the row we measured may no longer be the row: same re-check
    -- the prop reconciler does after its spawn yields.
    if Zones[key] ~= z then return nil end
    LoadAt[key] = p
    return p
end

-- What each point should be offering, or nil. One place decides, so the label, the
-- handler and the signature can never disagree about the state they describe.
local function slotsFor(key)
    local st = State[key] or {}
    local mine = MyRun and MyRun.key == key
    local pkg, trl = nil, nil
    if mine then
        local left = (st.boxes or 0) - (st.taken or 0)
        if carrying then
            trl = { id = "load", label = _L("supply_load_box"), icon = "fa-solid fa-truck-ramp-box" }
        elseif left > 0 then
            pkg = { id = "take", label = _L("supply_take_box"), icon = "fa-solid fa-box" }
        else
            pkg = { id = "abandon", label = _L("supply_abandon"), icon = "fa-solid fa-xmark" }
        end
    elseif not st.active and PendingOrder and not MyRun then
        pkg = { id = "resume", label = _L("supply_resume_run"), icon = "fa-solid fa-truck-ramp-box" }
    end
    return pkg, trl
end

-- The depot's ORDER COUNTER. With runs on the boss panel is not a shop any more, so
-- this is where supplies are bought: pick which restaurant you're ordering for (skipped
-- when there is only one), then the ordinary management panel opens in SHOP MODE with
-- just the Supplies tab. Reusing that view rather than growing a second buying UI is
-- what keeps one purchase path, one row component and one set of rules.
local function openShop()
    local res = lib.callback.await("pickle_restaurants:supply:shopFor", false)
    if not res or not res.ok then return ShowNotification((res and res.error) or _L("supply_not_at_shop")) end
    local list = res.restaurants or {}
    if #list == 1 then return OpenManagement(list[1].id, "supplies", true) end
    local options = {}
    for _, r in ipairs(list) do
        options[#options + 1] = {
            title = r.label, icon = "store",
            onSelect = function() OpenManagement(r.id, "supplies", true) end,
        }
    end
    lib.registerContext({ id = "pickle_restaurants_supply_shop", title = _L("supply_shop_title"), options = options })
    lib.showContext("pickle_restaurants_supply_shop")
end

local function dropInteractions(key)
    local ix = ZoneIx[key]
    if not ix then return end
    if ix.package then DeleteInteraction(ix.package) end
    if ix.trailer then DeleteInteraction(ix.trailer) end
    ZoneIx[key] = nil
end

local ACTIONS = {
    take    = function() takeBox() end,
    load    = function() loadBox() end,
    abandon = function() abandonRun() end,
    resume  = function(key) resumeRun(key) end,
}

-- Bring one bay's targets in line with what it currently offers. A no-op unless the
-- offer actually changed.
local function syncInteractions(key)
    local z = Zones[key]
    if not z or not Near[key] then return dropInteractions(key) end
    local pkg, trl = slotsFor(key)
    local sig = (pkg and pkg.id or "-") .. "|" .. (trl and trl.id or "-")
    local ix = ZoneIx[key]
    if ix and ix.sig == sig then return end
    dropInteractions(key)
    if not pkg and not trl then return end

    local built = { sig = sig }
    if pkg then
        built.package = CreateInteraction({
            coords = vec(z.zone.package),
            label  = pkg.label,
            -- FONT AWESOME 6 FREE SOLID only (see modules/main's STATION_ICONS).
            icon   = pkg.icon,
            radius = 1.6, interactRadius = 3.0, distance = 3.0,
        }, function() ACTIONS[pkg.id](key) end)
    end
    if trl then
        local at = loadPointFor(key)
        -- The measure can yield, so re-check that this is still the offer we set out to
        -- build before claiming the slot.
        if at and Zones[key] == z and not ZoneIx[key] then
            built.trailer = CreateInteraction({
                -- At the placed LOADING SPOT (or the measured rear of the trailer on an
                -- older bay), lifted to bed height: a zone on the tarmac under the
                -- vehicle's centre reads as "too far" while you stand at the doors.
                coords = at,
                label  = trl.label,
                icon   = trl.icon,
                radius = 2.5, interactRadius = 4.0, distance = 4.0,
            }, function() ACTIONS[trl.id](key) end)
        end
    end
    if built.package or built.trailer then ZoneIx[key] = built end
end

-- Every bay we are standing in. Called after anything that changes what is on offer.
function syncAllInteractions()
    for key in pairs(Near) do syncInteractions(key) end
end

-- ─── config → world ──────────────────────────────────────────────────────────

local ShopIx = {}   -- [depotId] = interaction index for its order counter

local function clearBlips()
    for _, b in pairs(DepotBlips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    DepotBlips = {}
    for id, ix in pairs(ShopIx) do
        DeleteInteraction(ix)
        ShopIx[id] = nil
    end
end

-- Rebuild everything the depot config puts in the world. Called on every sync: the
-- points are authored in the admin panel, so an admin placing a bay has to see it
-- without a restart.
function RefreshSupply()
    clearBlips()
    for key in pairs(Zones) do
        dropInteractions(key)
        clearPile(key)
    end
    Zones, Near, State, LoadAt = {}, {}, {}, {}
    local c = cfg()
    if not (c and c.enabled) then return end
    for _, d in ipairs(c.depots or {}) do
        for _, z in ipairs(d.zones or {}) do
            Zones[keyFor(d.id, z.id)] = { key = keyFor(d.id, z.id), depot = d, zone = z }
        end
        -- The counter is a DEPOT-level interaction, not a bay one, and it is always
        -- present rather than proximity-loaded: it is one target zone per depot, which
        -- is the same order of cost as the blip sitting next to it.
        if d.shop then
            ShopIx[d.id] = CreateInteraction({
                coords = vec(d.shop),
                label  = _L("supply_shop_label"),
                -- FONT AWESOME 6 FREE SOLID only (see modules/main's STATION_ICONS).
                icon   = "fa-solid fa-cart-shopping",
                radius = 1.5, interactRadius = 2.5, distance = 2.5,
            }, openShop)
        end
        local b = d.blip
        -- A depot with no blip config still gets one: a supplier nobody can find is a
        -- feature nobody uses. `enabled = false` is the way to turn it off.
        if (not b or b.enabled ~= false) and (d.shop or (d.zones and d.zones[1])) then
            -- On the COUNTER when there is one: that is where a run starts, so it is
            -- what someone driving to the marker is looking for.
            local p = d.shop or d.zones[1].package
            local blip = AddBlipForCoord(p.x + 0.0, p.y + 0.0, p.z + 0.0)
            SetBlipSprite(blip, (b and tonumber(b.sprite)) or 478)
            SetBlipColour(blip, (b and tonumber(b.color)) or 2)
            SetBlipScale(blip, (b and tonumber(b.scale)) or 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(d.label or _L("supply_bay_title"))
            EndTextCommandSetBlipName(blip)
            DepotBlips[d.id] = blip
        end
    end
end

-- ─── proximity + hydration ───────────────────────────────────────────────────
-- The hydration edge the scoped state pushes require: arriving at a depot replaces
-- everything we think we know about its bays with the server's current answer, in ONE
-- call for the whole batch (a depot has several bays, and a call per bay per approach is
-- the mistake modules/mirror already made once).

RegisterNetEvent("pickle_restaurants:supply:zone", function(st)
    if type(st) ~= "table" or not st.key then return end
    State[st.key] = st
    renderPile(st.key, st.active and math.max(0, (st.boxes or 0) - (st.taken or 0)) or 0)
    -- Somebody else claiming the bay, or a pile running dry, changes what it offers.
    syncInteractions(st.key)
    -- Our own run ending elsewhere (a lapsed claim, a sweep, an admin restart) has to
    -- put the box down too — otherwise we walk around holding cargo for a run that is
    -- over.
    if MyRun and MyRun.key == st.key and not st.active then endMyRun() end
end)

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local me = GetEntityCoords(ped)
        local fresh = {}
        for key, z in pairs(Zones) do
            local d = #(me - vec(z.zone.package))
            local was = Near[key]
            if (not was and d <= ZONE_IN) or (was and d <= ZONE_OUT) then
                Near[key] = true
                if not was then fresh[#fresh + 1] = key end
                syncInteractions(key)
                wait = 500
            elseif was then
                Near[key] = nil
                dropInteractions(key)
                clearPile(key)
                State[key] = nil
            end
        end
        if #fresh > 0 then
            local res = lib.callback.await("pickle_restaurants:supply:state", false, { keys = fresh })
            -- The same reply says whether we have a paid order still waiting, which is
            -- what decides if an idle bay offers to resume. Seeding it here is what
            -- makes a reconnect ordinary: walk back into the depot and the offer is
            -- there, with nothing to remember client-side across the session.
            if res then PendingOrder = res.order == true end
            for _, st in ipairs((res and res.zones) or {}) do
                if Near[st.key] then
                    State[st.key] = st
                    renderPile(st.key, st.active and math.max(0, (st.boxes or 0) - (st.taken or 0)) or 0)
                end
            end
            syncAllInteractions()
        end
        Wait(wait)
    end
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    stopCarry()
    for key in pairs(BoxProps) do clearPile(key) end
    clearBlips()
end)
