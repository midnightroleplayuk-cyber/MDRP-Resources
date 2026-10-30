-- =============================================
--  modules/main | client.lua
--  Receives the server sync, spawns placed station props, blips and the
--  interactions that open cooking / ordering / management.
-- =============================================

Restaurants      = {}   -- [id]            = restaurant data
RecipesByInput   = {}    -- [input_item]    = recipe
RecipesByStation = {}    -- [station]       = { recipe, ... }
Drinks           = {}    -- soda definitions
Assembly         = {}    -- kitchen-prep definitions
Finishes         = {}    -- finish tools (frosting…): tool -> targets -> flavors
Condiments       = {}    -- squeeze-bottle condiments: { item, container_model, applied_model }
Baking           = {}    -- fill tools, a LIST: one { mix_item, mix_model, rub_dist, trays } per tool
Crafts           = {}    -- code-less combine recipes: { id, label, group, components, modifiers }
Ingredients      = {}    -- [item]  = synced ingredient config { item, model, group?, box_base?, halves?, melts? }
IngredientsByModel = {}  -- [model] = its ingredient entry (reverse lookup incl. halves/melt models)
BoxBaseModels    = {}    -- model names the pizza box accepts as a carried pile's BOTTOM layer
StackTweaks      = {}    -- [model] = { sink?, rise? } manual stacking corrections (synced setting)
BakeSlots        = {}    -- [container model] = ordered { x, y } serving seats in the tray (synced setting)
ConfigGen        = 0     -- bumped every sync so lazily-built hash caches invalidate
BagItem          = "restaurant_bag" -- the ONE takeaway CARRIER item (its contents ride as metadata)
BagModel         = "pickle_restaurant_bag_01" -- the Restaurant Bag vessel prop
MealItem         = "meal"           -- the ONE eat-in CARRIER item (serving-tray layout in metadata)
BoxItem          = "takeout_box"    -- the ONE item every bag-KIND food (soup, salad…) becomes
ServingItem      = "restaurant_item" -- THE RESTAURANT ITEM: one serving of anything the
                                    -- kitchen makes (a poured drink, or a cooked product a
                                    -- cook pocketed), what it is riding in metadata
BoxBaseModel     = "pickle_takeout_box_01" -- takeout box: base half
BoxLidModel      = "pickle_takeout_box_02" -- takeout box: hinged lid

-- A CARRIER NEVER GOES INSIDE ANOTHER CARRIER — the serving tray and the Restaurant
-- Bag both hold their contents as build-stack metadata, so nesting one in the other is
-- a container inside itself (see IsCarrierItem in core/server.lua). The takeout box is
-- NOT a carrier by this rule: it holds one food and IS a unit, so it rides on a tray or
-- in a bag as a side in its box. Client-side this only refuses the drag early; prepAdd
-- is the authority.
function IsCarrierItem(item)
    return item ~= nil and item ~= "" and (item == BagItem or item == MealItem)
end

-- prop_type → localization key (resolved via _L at interaction-build time)
local STATION_LABELS = {
    soda_machine = "main_station_soda",
    fryer        = "main_station_fryer",
    stovetop     = "main_station_stovetop",
    kitchen_prep = "main_station_kitchen_prep",
}

-- Target icons, FONT AWESOME 6 **FREE** SOLID ONLY. The target resources ship the
-- free set, and a Pro-only name doesn't fall back to anything — it renders an empty
-- target, which is what the soda machine had: `fa-cup-straw` is a Pro icon (and the
-- Bootstrap Icons spelling), so the one station you'd most expect to be marked was
-- the one with no mark on it. Check a name is in the free set before using it here.
local STATION_ICONS = {
    soda_machine = "fa-solid fa-glass-water",
    fryer        = "fa-solid fa-fire-burner",
    stovetop     = "fa-solid fa-fire",
    kitchen_prep = "fa-solid fa-bowl-food",
}

local spawnedProps       = {} -- [propId]        = entity
local propInteractions   = {} -- [propId]        = interaction index (stations, seats, counters, virtual points)
local restaurantBlips    = {} -- [restaurantId]  = blip
local propsById          = {} -- [propId]        = synced prop row (stations, seats, counters, virtual points)

-- A virtual session (modules/virtual) spawns its station as a LOCAL prop inside
-- the kitchen shell and registers it here so everything that anchors to "the
-- station entity" — the scripted camera, oven doors, fryer baskets, slot seating —
-- resolves to the virtual one for that point's prop id.
local virtualStations = {} -- [propId] = entity while a virtual session is open

function RegisterVirtualStation(propId, ent) virtualStations[propId] = ent end
function GetClientProp(propId) return propsById[propId] end
-- The whole synced prop table, for the loops that must walk every placed prop rather
-- than look one up: modules/cooking's station range watcher (which decides whose
-- cooking events this client is subscribed to). Returned by reference — read only.
function GetClientProps() return propsById end

-- The world entity a placed prop is currently rendered as — the virtual station
-- inside an open shell session if there is one, else the physical world prop.
-- Used by modules/cookfx to hang a fire on the station that's actually on screen.
function GetClientPropEntity(propId)
    propId = tonumber(propId) or propId
    local ent = virtualStations[propId]
    if ent and DoesEntityExist(ent) then return ent end
    ent = spawnedProps[propId]
    if ent and DoesEntityExist(ent) then return ent end
    return nil
end

-- ─── world cleanup ───────────────────────────────────────────────────────────

-- Props are spawned as local, non-mission objects (CreateObject(..., false,
-- false, false)). DeleteEntity silently no-ops on those unless we first take
-- ownership by flagging them as a mission entity, which is why "removed in the
-- menu" stations used to linger in the world.
local function SafeDeleteEntity(ent)
    if not ent or not DoesEntityExist(ent) then return end
    SetEntityAsMissionEntity(ent, true, true)
    DeleteEntity(ent)
end

-- Everything ONE placed prop puts in the world: its entity, its oven doors / fryer
-- baskets, its interaction. Idempotent — the single teardown for a prop, whether it was
-- deleted, changed, or just walked away from.
local function DespawnProp(id)
    if DespawnOvenDoors then DespawnOvenDoors(id) end
    if DespawnFryerBaskets then DespawnFryerBaskets(id) end
    if spawnedProps[id] then SafeDeleteEntity(spawnedProps[id]); spawnedProps[id] = nil end
    if propInteractions[id] then DeleteInteraction(propInteractions[id]); propInteractions[id] = nil end
end

local function ClearBlips()
    for id, blip in pairs(restaurantBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
        restaurantBlips[id] = nil
    end
end

-- Full teardown. Only for resource stop now — a SYNC no longer razes the world (see the
-- reconciler), it re-diffs it.
local function ClearWorld()
    if ClearPropHighlight then ClearPropHighlight() end -- drop any hover outline/temp body
    for id in pairs(spawnedProps) do DespawnProp(id) end
    for id in pairs(propInteractions) do DespawnProp(id) end
    ClearBlips()
end

-- ─── prop spawning + interaction ─────────────────────────────────────────────

function GetStationEntity(propId) return virtualStations[propId] or spawnedProps[propId] end

-- The counter anchor's world model. A counter row is stored with an EMPTY model (it's a
-- point + heading, not a placed prop — see modules/placement), so unlike every other
-- prop the model isn't in the row: the register IS the counter, so the model belongs to
-- the anchor type rather than to the record. Its `register_brand` screen is the cashier's
-- interactive POS DUI (modules/register OpenRegisterScreen), taken over on interact.
local COUNTER_MODEL = "pickle_register_01"
-- The placement gizmo previews the real thing (modules/placement), so it reads the
-- model from here rather than keeping its own copy of the name.
function CounterModel() return COUNTER_MODEL end

-- The world model a prop row spawns, or nil for a modelless anchor (seat / virtual
-- point). ONE answer to "what does this row put in the world", because the row alone
-- can't say: a counter's `model` column is empty, so its register comes from the anchor
-- TYPE instead. Anything reasoning about a placed prop's model must go through this or
-- it will treat every counter as modelless.
local function PropModel(prop)
    if not prop then return nil end
    if prop.prop_type == "counter" then return COUNTER_MODEL end
    if not prop.model or prop.model == "" then return nil end
    return prop.model
end

-- Load `model` and create a frozen object for `prop` at its point + heading, or nil (and
-- a console line saying exactly why) if the model can't be spawned. Shared by the
-- generic station path and the counter, so a register fails as loudly as a fryer would.
local function CreatePropEntity(prop, model)
    if not model then
        -- Only reachable for a row that should carry a model but doesn't (the anchors
        -- return long before this) — i.e. a corrupt prop row. Say so rather than
        -- hashing nil.
        print(("[pickle_restaurants] ^1Prop #%s ('%s') has no model to spawn.^7")
            :format(tostring(prop.id), tostring(prop.prop_type)))
        return nil
    end
    local hash = (type(model) == "number") and model or GetHashKey(model)
    if not IsModelInCdimage(hash) then
        print(("[pickle_restaurants] ^1Model '%s' (prop #%s) is not in the game index.^7 "
            .. "Check that stream/%s.ydr exists and that data/pickle_restaurants.ytyp declares this archetype.")
            :format(tostring(model), tostring(prop.id), tostring(model)))
        return nil
    end
    RequestModel(hash)
    local started = GetGameTimer()
    while not HasModelLoaded(hash) do
        Wait(0)
        if GetGameTimer() - started > 10000 then
            print(("[pickle_restaurants] ^1Model '%s' failed to load within 10s.^7"):format(tostring(model)))
            return nil
        end
    end
    local ent = CreateObject(hash, prop.x, prop.y, prop.z, false, false, false)
    SetModelAsNoLongerNeeded(hash)
    if not ent or not DoesEntityExist(ent) then
        print(("[pickle_restaurants] ^1CreateObject failed for '%s'.^7"):format(tostring(model)))
        return nil
    end
    SetEntityCoordsNoOffset(ent, prop.x, prop.y, prop.z, false, false, false)
    SetEntityHeading(ent, prop.heading or 0.0)
    FreezeEntityPosition(ent, true)
    SetEntityCollision(ent, true, true)
    return ent
end

-- How far ABOVE a seat anchor its "Sit" target zone sits. The anchor itself is
-- bottom-based (the seated ped's root), so the zone has to be lifted to where a
-- player is actually looking — otherwise it hides under the chair. TUNE IN-GAME.
local SEAT_TARGET_Z = 1.0

-- Same problem, per STATION TYPE: a station's row is its floor position, so the target
-- zone sits at the base of the machine. That works for the counter-height units (the
-- zone's radius reaches the worktop), but the SODA FOUNTAIN is a tall body whose whole
-- working face — the taps, the cup seat at `SODA.cup_z` ≈ 1.12 — is a metre up, so a zone
-- at its feet reads as "too far" while you're standing right at the nozzles. Lift it to
-- the taps. Anything not listed keeps the row's own z. TUNE IN-GAME.
-- A SCREEN prop is the same problem again, and worse: a kiosk is a tall panel whose
-- readable face is at eye height, and a row's z is the FOOT of it, so the target sat
-- on the floor under the screen while the player stood looking at the middle of it.
-- Lift every screen-faced prop to the middle of its own face. TUNE IN-GAME.
local STATION_TARGET_Z = {
    soda_machine = 1.0,
    kiosk        = 1.0,
    kiosk_ground = 1.0,
    -- (The menu / orders wall boards are deliberately absent: they spawn NO
    -- interaction at all — they are read, not used — so there is nothing to lift.)
}

-- The z a prop's interaction zone sits at: its row plus that type's lift.
local function targetCoords(prop)
    return vector3(prop.x, prop.y, prop.z + (STATION_TARGET_Z[prop.prop_type] or 0.0))
end

local function SpawnProp(prop)
    -- A seat is an INVISIBLE sit anchor: no world model spawns — just a "Sit"
    -- interaction at the point. Players sit on the restaurant's own furniture here
    -- (the seating module plays the pose). Cleaned up via propInteractions like any
    -- other placed prop (ClearWorld / propRemoved).
    -- A DELIVERY DOOR is a pure data point: no model, no interaction, nothing in the
    -- world at all. It exists only as a destination for NPC delivery orders
    -- (modules/doorstep runs the knock + hand-off when a driver arrives at one).
    if prop.prop_type == "delivery_door" then return end

    if prop.prop_type == "seat" then
        -- Does a reservation hold this anchor? The synced `reservedSeats` map
        -- (BuildSyncPayload) is HOLDER-AGNOSTIC — it says a seat is booked, not by whom —
        -- so this is a LABEL HINT only: the holder and their guests read "Reserved" too
        -- and sit down perfectly well, because `seating:sit` is the actual gate. Making
        -- the label the gate would need every party's guest list on every client.
        -- Keys survive the wire as numbers, but a payload that ever ships them as JSON
        -- object keys would arrive as strings, so both are checked rather than silently
        -- labelling every seat free.
        local rest = Restaurants[prop.restaurant_id]
        local resMap = rest and rest.reservedSeats or nil
        local reserved = (resMap and (resMap[prop.id] or resMap[tostring(prop.id)])) and true or false
        -- Generous reach: the anchor sits at the seated pose (often up on a chair),
        -- so a tight radius reads as "too far" even standing right at it. These are
        -- forgiving enough to sit from beside the chair in both target and
        -- keypress interaction modes.
        propInteractions[prop.id] = CreateInteraction({
            -- Raised off the anchor: a seat's stored point is BOTTOM-based (the
            -- ped's root, on the floor / seat pan), so a target zone centred on it
            -- sits under the chair where a player is aiming at the seat back or the
            -- table. SEAT_TARGET_Z lifts it to roughly torso height, where the eye
            -- (and the target ray) actually goes.
            coords         = vector3(prop.x, prop.y, prop.z + SEAT_TARGET_Z),
            label          = _L(reserved and "main_sit_reserved" or "main_sit"),
            -- FONT AWESOME 6 FREE SOLID only (see STATION_ICONS) — `fa-lock` is free.
            icon           = reserved and "fa-solid fa-lock" or "fa-solid fa-chair",
            radius         = 1.2,
            interactRadius = 2.5,
            distance       = 2.5,
        }, function()
            if SitOnSeat then SitOnSeat(prop) end
        end)
        return
    end

    -- A counter is the REGISTER anchor: it spawns the register model at the point and
    -- carries the "Register / Management" interaction. A restaurant may have several;
    -- each is its own register. The primary (lowest-id) counter also anchors the
    -- blip/shell/NPC queue, but that's read off restaurant.counter, not this
    -- interaction. The model is COUNTER_MODEL, not prop.model — a counter row stores an
    -- empty model (it predates having one; see modules/placement).
    --
    -- The register's screen is now the cashier's own POS: interacting opens the staff
    -- register as an INTERACTIVE in-world DUI painted on the counter's `register_brand`
    -- screen (modules/register OpenRegisterScreen), the same way the kiosk works. The
    -- second option opens management (still a fullscreen NUI).
    if prop.prop_type == "counter" then
        local rest = Restaurants[prop.restaurant_id]
        local label = (rest and rest.label) or _L("main_station_generic")
        local ent = CreatePropEntity(prop, PropModel(prop))
        if ent then
            spawnedProps[prop.id] = ent
            -- The counter's screen is the always-on register POS DUI (modules/register);
            -- re-assert its texture now the model exists (AddReplaceTexture needs the
            -- prop streamed in), mirroring ReassertScreenFor for the info boards.
            if ReassertRegister then ReassertRegister() end
        end
        propInteractions[prop.id] = CreateInteraction({
            coords         = vector3(prop.x, prop.y, prop.z),
            label          = label,
            icon           = "fa-solid fa-cash-register",
            radius         = 1.5,
            interactRadius = 2.0,
            title          = label,
            options        = {
                { label = _L("main_staff_register"), icon = "fa-solid fa-cash-register" },
                { label = _L("main_management"),     icon = "fa-solid fa-users-gear" },
                -- EVERY employee needs this one, which is why it is here and not behind
                -- the POS: the register wants `sell` and the panel wants a management
                -- perm, so a cook with neither had no way to start a shift but the phone.
                { label = _L("main_clock_toggle"),   icon = "fa-solid fa-user-clock" },
            },
        }, function(selection)
            if selection == 1 then
                if OpenRegisterScreen then OpenRegisterScreen(prop, ent) end
            elseif selection == 2 then
                OpenManagement(prop.restaurant_id)
            elseif selection == 3 then
                if ToggleShiftClock then ToggleShiftClock(prop.restaurant_id) end
            end
        end)
        return
    end

    -- A virtual register is an INVISIBLE anchor like a seat (prop_type
    -- "virtual_register"): nothing spawns in the world, and — having no screen to paint
    -- — it keeps the ordinary fullscreen NUI register (OpenRegister) rather than the
    -- in-world DUI. Same two-option interaction as a physical counter.
    if prop.prop_type == "virtual_register" then
        local rest = Restaurants[prop.restaurant_id]
        local label = (rest and rest.label) or _L("main_station_generic")
        propInteractions[prop.id] = CreateInteraction({
            coords         = vector3(prop.x, prop.y, prop.z),
            label          = label,
            icon           = "fa-solid fa-cash-register",
            radius         = 1.2,
            interactRadius = 1.8,
            title          = label,
            options        = {
                { label = _L("main_staff_register"), icon = "fa-solid fa-cash-register" },
                { label = _L("main_management"),     icon = "fa-solid fa-users-gear" },
                { label = _L("main_clock_toggle"),   icon = "fa-solid fa-user-clock" },
            },
        }, function(selection)
            if selection == 1 then
                OpenRegister(prop.restaurant_id)
            elseif selection == 2 then
                OpenManagement(prop.restaurant_id)
            elseif selection == 3 then
                if ToggleShiftClock then ToggleShiftClock(prop.restaurant_id) end
            end
        end)
        return
    end

    -- A virtual point is an INVISIBLE anchor like a seat: nothing spawns here —
    -- using it fades out and builds the restaurant's kitchen shell (with this
    -- point's station inside) locally for just this player (modules/virtual).
    -- Equipment is STAFF-ONLY, and that is said in the world rather than only at the
    -- refusal: a player who can't cook here gets no prompt on the station at all.
    -- (The server still gates every station callback — this is the visible half.)
    if prop.prop_type == "virtual_point" and not CanCookAt(prop.restaurant_id) then return end

    if prop.prop_type == "virtual_point" then
        local target = prop.metadata and prop.metadata.target
        local label = _L(STATION_LABELS[target] or "main_station_generic")
        propInteractions[prop.id] = CreateInteraction({
            coords         = vector3(prop.x, prop.y, prop.z),
            label          = _L("main_use_virtual", label),
            icon           = STATION_ICONS[target] or "fa-solid fa-utensils",
            radius         = 1.2,
            interactRadius = 1.8,
        }, function()
            if OpenVirtualStation then OpenVirtualStation(prop) end
        end)
        return
    end

    -- Spawn the model ourselves (rather than core's CreateProp) so we can log
    -- exactly why a station doesn't appear. Watch the F8 / server console.
    local ent = CreatePropEntity(prop, PropModel(prop))
    if not ent then return end
    spawnedProps[prop.id] = ent
    debugPrint(("Spawned prop #%s '%s' at %.2f %.2f %.2f"):format(prop.id, prop.model, prop.x, prop.y, prop.z))

    -- A kiosk is a real world prop but NOT a cooking station: its interaction opens
    -- the self-service order screen as an INTERACTIVE in-world DUI (modules/kiosk
    -- OpenKioskScreen) — the customer orders on the kiosk's own screen, no fullscreen
    -- NUI, and it shows the restaurant BRAND when idle. The order still becomes a
    -- kitchen ticket a worker fulfils. Re-assert any configured brand now the model
    -- exists (its screen is a render-target texture; AddReplaceTexture only takes on a
    -- streamed model). Pass the spawned entity so the kiosk can frame its camera.
    if prop.prop_type == "kiosk" or prop.prop_type == "kiosk_ground" then
        if ReassertBrandFor then ReassertBrandFor(prop.model) end
        propInteractions[prop.id] = CreateInteraction({
            coords         = targetCoords(prop),
            label          = _L("main_use_kiosk"),
            icon           = "fa-solid fa-utensils",
            radius         = 1.2,
            interactRadius = 1.8,
        }, function()
            if OpenKioskScreen then OpenKioskScreen(prop, ent) end
        end)
        return
    end

    -- A menu / orders SCREEN is a placed but NON-INTERACTABLE prop: its branded
    -- screen texture is replaced at runtime by a DUI (modules/screens) rendering the
    -- restaurant's live menu / open tickets. Re-assert the screen render now the model
    -- exists (AddReplaceTexture only takes on a streamed model), and spawn no
    -- interaction — players just read it.
    if prop.prop_type == "menu_screen" or prop.prop_type == "orders_screen" then
        if ReassertScreenFor then ReassertScreenFor(prop.model) end
        return
    end

    -- Stovetops carry two oven doors that render + sync independently.
    if prop.prop_type == "stovetop" and SpawnOvenDoors then SpawnOvenDoors(prop, ent) end
    -- Let the cooking module (re)seat any oven/fryer items on this station and pick up
    -- the fryer basket's synced up/down state, now the station entity exists.
    if OnStationSpawned then OnStationSpawned(prop) end

    -- The station itself still SPAWNS for everyone — a kitchen with no grill in it is
    -- not what "staff only" means — but only staff get the prompt that opens it.
    if not CanCookAt(prop.restaurant_id) then return end

    local label = _L(STATION_LABELS[prop.prop_type] or "main_station_generic")
    propInteractions[prop.id] = CreateInteraction({
        coords         = targetCoords(prop),
        label          = _L("main_use_station", label),
        icon           = STATION_ICONS[prop.prop_type] or "fa-solid fa-utensils",
        radius         = 1.2,
        interactRadius = 1.8,
    }, function()
        OpenCookingStation(prop)
    end)
end

-- ─── the world reconciler ────────────────────────────────────────────────────
--
-- A CLIENT HOLDS ONLY THE RESTAURANTS IT IS AT. It used to spawn a real entity for every
-- placed prop of every restaurant on the server the moment it synced, and re-spawn the lot
-- on every config edit. That is what forced the prop events to be world-wide broadcasts:
-- if everyone holds everything, everyone has to be told about everything.
--
-- Now proximity decides, and ONE function is the only thing that spawns or despawns a
-- prop. It DIFFS: for each prop we compare the row we'd build against the row we actually
-- built from, so an unchanged prop is left alone, a moved or re-styled one is rebuilt, and
-- a deleted or walked-away-from one is torn down. This replaces the whole-payload
-- fingerprint that used to gate the rebuild — a per-prop diff is strictly finer (a single
-- moved prop no longer rebuilds the world either) and it is what makes range loading
-- possible at all.
--
-- Rows are NOT range-scoped, only entities: `propsById` stays complete from the sync, so
-- every lookup elsewhere keeps working for restaurants across the map. What proximity
-- governs is what exists in the world.
local RWorld = {
    near    = {},  -- [rid]    = true while we hold this restaurant's props
    sig     = {},  -- [propId] = signature of the row we spawned from (nil = not spawned)
    dirty   = {},  -- [rid]    = true -> re-diff on the next tick
    fetched = {},  -- [rid]    = true once we've pulled the authoritative set for it
}

-- ONE thread owns reconciliation, so there is no concurrency to guard: SpawnProp yields
-- while its model streams, and two passes racing on one prop is exactly the double-spawn
-- that leaves an orphan nothing tracks (see CookSpawnGen in modules/cooking/client.lua for
-- the same hazard). Events and syncs only ever mark a restaurant DIRTY; they never spawn.
local WORLD_TICK_MS = 250 -- responsive enough that a placing admin sees the prop appear

-- Hysteresis, and both radii are deliberately far larger than anything that renders: the
-- cooking module's own station range (CookRange, 70/85m) must fall INSIDE this, or a
-- station's prop would vanish while its items were still subscribed. Measured against the
-- restaurant's whole extent, not its centre, so a far-flung delivery door or shell anchor
-- still counts as part of the restaurant. TUNE IN-GAME.
local REST_IN, REST_OUT = 250.0, 320.0

-- What about a prop row would change what it puts in the world. The reserved-seat flag is
-- folded in because a seat's interaction LABEL is baked in at spawn — a booking landing has
-- to rebuild that seat, and nothing about the prop row itself moves when it does.
local function propRowSig(prop)
    local rest = Restaurants[prop.restaurant_id]
    local resMap = rest and rest.reservedSeats or nil
    local reserved = (resMap and (resMap[prop.id] or resMap[tostring(prop.id)])) and "1" or "0"
    return table.concat({
        prop.prop_type or "", prop.model or "",
        string.format("%.3f,%.3f,%.3f,%.3f", prop.x or 0, prop.y or 0, prop.z or 0, prop.heading or 0),
        json.encode(prop.metadata or {}), reserved,
        (rest and rest.label) or "", -- a virtual register's interaction is titled with it
        -- Whether we may work here decides whether a station gets an interaction at
        -- all, so a hire or a firing has to rebuild the same way a move does.
        CanCookAt(prop.restaurant_id) and "1" or "0",
    }, "|")
end

local function restaurantInRange(r, here)
    local c = r.centre or r.counter
    if not c then return false end
    local d = #(here - vector3(c.x + 0.0, c.y + 0.0, c.z + 0.0))
    local reach = (c.r or 0.0) + (RWorld.near[r.id] and REST_OUT or REST_IN)
    return d <= reach
end

-- Bring restaurant `rid`'s props in the world into line with the rows we hold.
local function reconcileRestaurant(rid, want)
    -- SNAPSHOT FIRST. SpawnProp yields while its model streams, and a `propPlaced` arriving
    -- in that window ADDS a key to propsById — modifying a table during a `pairs` traversal
    -- is undefined in Lua (assigning nil to an existing field is the only mutation that's
    -- allowed). The new prop isn't missed: its event marked the restaurant dirty, so the
    -- next tick reconciles it.
    local list = {}
    for id, prop in pairs(propsById) do
        if prop.restaurant_id == rid then list[#list + 1] = { id = id, prop = prop } end
    end
    for _, e in ipairs(list) do
        local id, prop = e.id, e.prop
        local sig = want and propRowSig(prop) or nil
        if RWorld.sig[id] ~= sig then
            DespawnProp(id)
            RWorld.sig[id] = sig
            -- The claim is recorded BEFORE the yield, and this thread is the only spawner,
            -- so there is no second pass to race. But the ROW can be replaced or deleted
            -- while we stream, which would leave our entity behind as an orphan nothing
            -- tracks — so re-check that it's still the row we were building before keeping it.
            if want then
                SpawnProp(prop)
                if propsById[id] ~= prop then DespawnProp(id); RWorld.sig[id] = nil end
            end
        end
    end
end

-- Props we hold whose row is gone entirely (their restaurant was deleted, or the row was
-- removed while we were out of range and the delta never reached us).
local function reapOrphanProps()
    for id in pairs(RWorld.sig) do
        if not propsById[id] then DespawnProp(id); RWorld.sig[id] = nil end
    end
end

-- Pull the authoritative props + reserved seats for a restaurant we're walking into. THIS
-- is what allows propPlaced / propRemoved / shellMoved / reservedSeats to be scoped: any
-- delta we missed while out of range is repaired here, before the place is in view.
local function fetchRestaurant(rid)
    local res = lib.callback.await("pickle_restaurants:world:getRestaurant", false, { id = rid })
    if not res then return end
    local r = Restaurants[rid]
    if r then
        r.reservedSeats = res.reservedSeats or {}
        r.props = {}
    end
    -- replace, don't merge: rows we hold for this restaurant that the server didn't send
    -- are rows that no longer exist
    for id, prop in pairs(propsById) do
        if prop.restaurant_id == rid then propsById[id] = nil end
    end
    for _, prop in ipairs(res.props or {}) do
        propsById[prop.id] = prop
        if r then table.insert(r.props, prop) end
    end
end

-- MAY WE WORK HERE? The server has always been the authority — every station callback
-- is gated on `cook` — but the WORLD said otherwise: a passer-by with no job got the
-- same "Use the Grill" prompt an employee does, walked up to a restaurant's whole
-- kitchen, and only found out at the refusal. A prompt on equipment you can never use
-- is indistinguishable from equipment that isn't gated at all, which is exactly how
-- this was reported. So the answer is fetched once per restaurant we walk into and the
-- station interactions are only built for a player who holds it.
--
-- Cached per restaurant, never derived here: employment lives in the framework's job
-- and the ranks live in the restaurant's metadata, neither of which the client has.
-- Dropped on `jobChanged` (the event every bridge funnels its framework's own into),
-- so a promotion or a firing takes effect without a relog.
local WorkPerms = {}   -- [rid] = { cook = bool, sell = bool } once answered

local function fetchWorkPerms(rid)
    local res = lib.callback.await("pickle_restaurants:main:workPerms", false, { id = rid })
    WorkPerms[rid] = { cook = res and res.cook == true, sell = res and res.sell == true }
end

-- Can this player work the kitchen here? Unknown (not fetched yet) reads as NO: the
-- reconciler re-diffs the moment the answer lands, so a legitimate employee sees the
-- prompt appear a beat later — where the opposite default would flash the whole
-- kitchen open to everyone on approach.
function CanCookAt(rid)
    local p = WorkPerms[rid]
    return (p and p.cook) == true
end

CreateThread(function()
    while true do
        Wait(WORLD_TICK_MS)
        local here = GetEntityCoords(PlayerPedId())
        reapOrphanProps()
        for rid, r in pairs(Restaurants or {}) do
            local want = restaurantInRange(r, here)
            local was  = RWorld.near[rid] and true or false
            if want ~= was or RWorld.dirty[rid] then
                RWorld.dirty[rid] = nil
                RWorld.near[rid] = want or nil
                -- Entering range: take the server's word for what's here before building
                -- it. Once per approach — the scoped deltas keep it current while we stay.
                if want and not RWorld.fetched[rid] then
                    RWorld.fetched[rid] = true
                    fetchRestaurant(rid)
                    -- …and whether we may work here, before anything is built from it.
                    if WorkPerms[rid] == nil then fetchWorkPerms(rid) end
                elseif not want then
                    RWorld.fetched[rid] = nil -- re-fetch next time we come back
                end
                reconcileRestaurant(rid, want)
            end
        end
    end
end)

-- Our job (or the job DEFINITION, in which case the server relays to everyone) moved.
-- Forget every cached answer and re-ask for the restaurants we are actually at, then
-- re-diff: `propRowSig` carries the answer, so the stations we may now work grow their
-- prompts and the ones we may not lose them, without a relog.
RegisterNetEvent("pickle_restaurants:jobChanged", function()
    WorkPerms = {}
    CreateThread(function()
        for rid in pairs(RWorld.near) do
            fetchWorkPerms(rid)
            RWorld.dirty[rid] = true
        end
    end)
end)

-- Mark a restaurant for re-diffing on the next tick. The ONE way anything outside the
-- reconciler asks for a world change.
local function markRestaurantDirty(rid)
    if rid then RWorld.dirty[rid] = true end
end

-- Are this restaurant's props actually IN THE WORLD for us? Rows are kept for every
-- restaurant (so lookups work everywhere), but only a restaurant we're at has entities. Any
-- driver that binds a render target to a placed prop's model has to ask, because
-- AddReplaceTexture only takes on a model that exists: modules/screens and modules/register
-- both pick "the nearest restaurant with this prop placed", and before proximity loading
-- that could never be a restaurant whose prop wasn't spawned.
function IsRestaurantLoaded(rid) return RWorld.near[rid] and true or false end

local function SetupBlip(restaurant)
    local b = restaurant.blip or { sprite = 93, color = 1, scale = 0.8, enabled = true }
    if b.enabled == false then return end
    -- `centre` is server-computed and always present for a restaurant with any prop placed,
    -- which is why this no longer falls back to `props[1]`: props are loaded by proximity
    -- now, so a distant restaurant has none and its blip would have gone missing.
    local coords = restaurant.counter or restaurant.centre
    if not coords then return end
    local blip = AddBlipForCoord(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)
    SetBlipSprite(blip, b.sprite or 93)
    SetBlipColour(blip, b.color or 1)
    SetBlipScale(blip, b.scale or 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(restaurant.label or "Restaurant")
    EndTextCommandSetBlipName(blip)
    restaurantBlips[restaurant.id] = blip
end

-- ─── sync handler ────────────────────────────────────────────────────────────

local function DoApplySync(payload)
    -- A sync no longer razes the world. Blips are rebuilt (cheap, and a label or counter can
    -- change with no prop changing); the props are handed to the reconciler, which diffs
    -- them per prop and touches only what actually differs. A config-only edit — which is
    -- what a sync almost always is — therefore costs no entity work at all, where it used to
    -- delete and respawn every prop of every restaurant, each blocking on its model.
    ClearBlips()
    Restaurants, RecipesByInput, RecipesByStation, Drinks, Assembly, Finishes, Condiments = {}, {}, {}, {}, {}, {}, {}

    for _, r in ipairs(payload.restaurants or {}) do
        r.props = {}
        Restaurants[r.id] = r
    end
    for _, recipe in ipairs(payload.recipes or {}) do
        RecipesByInput[recipe.input_item] = recipe
        RecipesByStation[recipe.station] = RecipesByStation[recipe.station] or {}
        table.insert(RecipesByStation[recipe.station], recipe)
    end
    if payload.settings then
        Drinks   = payload.settings.drinks or {}
        Assembly = payload.settings.assembly or {}
        Finishes = payload.settings.finishes or {}
        Condiments = payload.settings.condiments or {}
        Baking   = payload.settings.baking or {}
        Crafts   = payload.settings.crafts or {}
        BagItem  = payload.settings.bag_item or "restaurant_bag"
        BagModel = payload.settings.bag_model or "pickle_restaurant_bag_01"
        MealItem = payload.settings.meal_item or "meal"
        BoxItem      = payload.settings.box_item or "takeout_box"
        ServingItem  = payload.settings.serving_item or "restaurant_item"
        BoxBaseModel = payload.settings.box_base_model or "pickle_takeout_box_01"
        BoxLidModel  = payload.settings.box_lid_model or "pickle_takeout_box_02"
        SideContainerModel = payload.settings.side_container_model or ""
        -- Synced ingredient config (only installed items ship): the item map plus a
        -- reverse map from EVERY model an ingredient can render as (its base model,
        -- its halves pair, its melt topping's applied/melted looks) back to the entry.
        Ingredients, IngredientsByModel = {}, {}
        for _, ing in ipairs(payload.settings.ingredients or {}) do
            if ing.item then Ingredients[ing.item] = ing end
            if ing.model then IngredientsByModel[ing.model] = ing end
            local hv = ing.halves
            if hv then
                if hv.top_model then IngredientsByModel[hv.top_model] = ing end
                if hv.bottom_model then IngredientsByModel[hv.bottom_model] = ing end
            end
            local ml = ing.melts
            if ml then
                if ml.applied_model then IngredientsByModel[ml.applied_model] = ing end
                if ml.melted_model then IngredientsByModel[ml.melted_model] = ing end
            end
        end
        -- Supplier depots + the run's models/geometry (modules/supply reads this global
        -- and rebuilds its depot interactions off it).
        Supply   = payload.settings.supply or nil
        BoxBaseModels = payload.settings.box_base_models or {}
        StackTweaks   = payload.settings.stack_tweaks or {}
        BakeSlots     = payload.settings.bake_slots or {}
        -- invalidate lazily-built hash caches (e.g. the cooking module's boxable set)
        ConfigGen = (ConfigGen or 0) + 1
    end

    propsById = {}
    for _, prop in ipairs(payload.props or {}) do
        propsById[prop.id] = prop
        if Restaurants[prop.restaurant_id] then
            table.insert(Restaurants[prop.restaurant_id].props, prop)
        end
    end
    -- Hand every restaurant to the reconciler rather than spawning here. It runs on its own
    -- thread — the only spawner, which is what keeps SpawnProp's yield free of races — and
    -- will build exactly the ones we're standing at. A restaurant that vanished from the
    -- payload has no row left, so reapOrphanProps takes its props down.
    for rid in pairs(Restaurants) do markRestaurantDirty(rid) end
    for _, r in pairs(Restaurants) do
        SetupBlip(r)
    end
    -- Re-assert brand render-target bindings now that brand_images may have changed,
    -- so a brand edit takes effect after re-streaming the item (no resource restart).
    -- RefreshBrands is defined in modules/rendertarget/client.lua (same client).
    if RefreshBrands then RefreshBrands() end
    -- Same for the info SCREENS: re-assert each screen's render-target replacement while
    -- its prop exists and re-push its data (a menu price may have changed — and the menu is
    -- FETCHED now, not synced, so RefreshScreens is what invalidates the fetched copy).
    -- Idempotent, so it's correct whether or not the props were respawned just above.
    -- RefreshScreens is in modules/screens/client.lua.
    if RefreshScreens then RefreshScreens() end
    -- And the always-on register board: its counter's catalog/menu may have changed, so
    -- re-seed + re-paint it (modules/register).
    if RefreshRegister then RefreshRegister() end
    -- And the supplier depots: their points are authored in the admin panel, so a bay
    -- placed with the gizmo has to appear without a restart (modules/supply).
    if RefreshSupply then RefreshSupply() end
    -- NOT touched here: the cooking module's station subscriptions and the item props they
    -- own. A sync leaves cooking items standing, and the reconciler re-seats them through
    -- SpawnProp's OnStationSpawned for any station it actually rebuilds. Dropping and
    -- re-hydrating them on every sync would be the exact entity churn the per-prop diff
    -- exists to avoid. A subscription to a prop that has GONE is pruned by that module's
    -- own range loop (modules/cooking/client.lua).
end

-- Serialize syncs. This guard used to be load-bearing for a different reason: DoApplySync
-- spawned props itself, SpawnProp yields while a model streams, and two overlapping syncs
-- (a joining client gets one from `playerJoining` and one from its own `requestSync`) each
-- spawned a full set because neither could see the other's not-yet-registered entities —
-- props doubled up until a resource restart.
--
-- DoApplySync no longer spawns anything: it records data and marks restaurants dirty, and
-- the reconciler thread — the only spawner — does the world work. The double-spawn it
-- guarded against is now structurally impossible. It stays because coalescing overlapping
-- payloads to the latest is still the right behaviour: a payload superseded before it was
-- applied is work nobody needs.
local applyingSync = false
local pendingSync  = nil

local function ApplySync(payload)
    if applyingSync then
        pendingSync = payload
        return
    end
    applyingSync = true
    DoApplySync(payload)
    while pendingSync do
        local p = pendingSync
        pendingSync = nil
        DoApplySync(p)
    end
    applyingSync = false
end

RegisterNetEvent("pickle_restaurants:sync", ApplySync)

-- ONE restaurant's reserved-seat map changed (a booking made, cancelled or lapsed). Scoped
-- to the restaurant by the server, and repaired on approach by world:getRestaurant for
-- anyone who was out of range. The "Reserved" label and lock icon are baked in when a seat's
-- interaction is created, so the map is folded into propRowSig and marking the restaurant
-- dirty is enough — the reconciler rebuilds exactly the seats whose label changed, and
-- nothing else. Never spawn from here: one thread owns that.
RegisterNetEvent("pickle_restaurants:reservedSeats", function(rid, map)
    local r = Restaurants[rid]
    if not r then return end
    r.reservedSeats = map or {}
    markRestaurantDirty(rid)
end)

-- Scoped by the server to players at this restaurant; anyone further out gets it from
-- world:getRestaurant when they walk in. Record the row and mark it dirty — the reconciler
-- spawns it on the next tick if we're actually in range (an admin placing props is, by
-- definition, standing there).
-- An UPSERT, not an append: `placement:updateProp` sends this too (moving a prop is a new
-- transform for an existing id), so appending would duplicate the row in `r.props` on every
-- gizmo save — and that list is what the screens driver and the register board scan.
RegisterNetEvent("pickle_restaurants:propPlaced", function(prop)
    propsById[prop.id] = prop
    local r = Restaurants[prop.restaurant_id]
    if r then
        r.props = r.props or {}
        local replaced = false
        for i, p in ipairs(r.props) do
            if p.id == prop.id then r.props[i] = prop; replaced = true; break end
        end
        if not replaced then r.props[#r.props + 1] = prop end
    end
    markRestaurantDirty(prop.restaurant_id)
end)

-- Scoped by the server to players at this restaurant (the audience is resolved BEFORE the
-- row leaves PropCache, since the restaurant's extent is derived from its props). A client
-- that was out of range never held an entity for it, and its stale row is replaced wholesale
-- by world:getRestaurant on approach.
RegisterNetEvent("pickle_restaurants:propRemoved", function(propId)
    local prop = propsById[propId]
    -- Note whether we held a live entity BEFORE tearing down, for the ghost sweep below.
    local hadEntity = spawnedProps[propId] and DoesEntityExist(spawnedProps[propId])
    DespawnProp(propId)
    RWorld.sig[propId] = nil -- no longer built from anything (reapOrphanProps would too)
    -- Safety sweep: if our tracked handle was already gone (the prop streamed out and
    -- back, or was placed before we cached its entity), the world object could linger
    -- until a resource restart. Delete any object of this model still sitting at the
    -- prop's point so a "removed" station can't stay in the world. Skipped for
    -- modelless anchors (seats / virtual points spawn no world prop) — but NOT for a
    -- counter: its row's model is empty while its register is very much in the world,
    -- so PropModel is what decides, not the column.
    local sweepModel = PropModel(prop)
    if not hadEntity and sweepModel then
        local hash = (type(sweepModel) == "number") and sweepModel or GetHashKey(sweepModel)
        local ghost = GetClosestObjectOfType(prop.x + 0.0, prop.y + 0.0, prop.z + 0.0, 1.5, hash, false, false, false)
        if ghost and ghost ~= 0 and DoesEntityExist(ghost) then SafeDeleteEntity(ghost) end
    end
    -- Prune the client cache so nothing keeps treating the prop as still placed —
    -- notably the screens driver (modules/screens), which scans r.props to decide a
    -- board still exists and would otherwise leave its texture replacement bound
    -- until the next full sync / restart.
    propsById[propId] = nil
    if prop and Restaurants[prop.restaurant_id] then
        local list = Restaurants[prop.restaurant_id].props or {}
        for i = #list, 1, -1 do if list[i].id == propId then table.remove(list, i) end end
    end
    -- A deleted station takes its cooking items with it, and we drop them LOCALLY rather
    -- than wait for the server's per-item removals: those are scoped by the station's
    -- coords (SendNearProp), and by the time propDeleted fires the row may already be
    -- out of PropCache — an audience of nobody, i.e. food left floating where the grill
    -- used to be. Nothing else can be looking at these items either way.
    if DropItemsFor then DropItemsFor(propId) end
end)

-- ─── boot ────────────────────────────────────────────────────────────────────

CreateThread(function()
    -- Don't gate on Inventory.Ready: under ESX/QB the client inventory mirror
    -- only flips to Ready once the server answers requestSync with the item
    -- list, so requesting the sync is what unblocks it.
    Wait(1000)
    TriggerServerEvent("pickle_restaurants:requestSync")
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    ClearWorld()
end)

function GetRestaurantById(id) return Restaurants[id] end

-- ─── admin prop highlight ────────────────────────────────────────────────────
-- Hovering a prop's card in the admin / boss panel flags exactly which placed thing
-- it is, using the SAME entity outline the interaction / cooking hover uses (amber
-- SetEntityDrawOutline). A physical prop's own world entity is outlined directly;
-- an INVISIBLE anchor (seat / virtual point) has no entity, so a temporary
-- body — the same one its placement previews — is spawned at the point and outlined,
-- so the highlight reads identically everywhere. SetPropHighlight is global so the
-- admin / management NUI relays can toggle it. (Panel is centred, so the world — and
-- the outline — shows around it.)
local HL_OUTLINE = { 255, 180, 40, 255 } -- amber, matching the cooking/stovetop hover
local ANCHOR_HL = {
    -- Fallback only: a counter spawns its own register now, so the real entity above is
    -- what normally gets outlined. This vanilla till stands in if COUNTER_MODEL is
    -- missing from the game index, so the admin can still see WHERE the counter is.
    counter          = { model = "prop_till_01" },
    virtual_register = { model = "prop_till_01" },  -- invisible register anchor
    virtual_point    = { model = "prop_tennis_ball" },  -- the virtual-point gizmo preview
    -- A SEAT IS DRAWN, NOT SPAWNED. It used to preview as a ghost PED here, which
    -- crashed the game: hovering a list of seat chips creates and deletes a ped per
    -- mouse-over (the panel fires on-enter, on-leave AND an unmount cleanup), and
    -- churning peds that fast — spawning one, then DeleteEntity-ing it a few frames
    -- later, repeatedly — takes the client down. Markers cost nothing, load no model
    -- and create no entity, so a seat highlight cannot crash and cannot leak.
    seat             = { marker = true },
    delivery_door    = { marker = true },  -- the NPC-delivery doorstep, same reasoning
}
local HL_MARKER = { 255, 180, 40, 170 } -- same amber as the outline, translucent
local hlReal   = nil -- a real world entity whose outline we turned on
local hlTemp   = nil -- a temp body we spawned for an invisible anchor
local hlMarker = nil -- { x, y, z, h } drawn each frame for an anchor with no body
local hlGen    = 0   -- bumped each toggle so a late async spawn can bail

-- The seat marker: a puck on the anchor plus a small ball a step along its heading,
-- so an admin sees WHERE the seat is and WHICH WAY it faces. One thread for the
-- lifetime of the resource — it idles cheaply when nothing is highlighted.
CreateThread(function()
    while true do
        local m = hlMarker
        if m then
            DrawMarker(1, m.x, m.y, m.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                       0.45, 0.45, 0.15, HL_MARKER[1], HL_MARKER[2], HL_MARKER[3], HL_MARKER[4],
                       false, false, 2, false, nil, nil, false)
            local rad = math.rad(m.h)
            DrawMarker(28, m.x - math.sin(rad) * 0.45, m.y + math.cos(rad) * 0.45, m.z - 0.75,
                       0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.10, 0.10, 0.10,
                       HL_MARKER[1], HL_MARKER[2], HL_MARKER[3], HL_MARKER[4],
                       false, false, 2, false, nil, nil, false)
            Wait(0)
        else
            Wait(250)
        end
    end
end)

function ClearPropHighlight()
    hlGen = hlGen + 1
    if hlReal and DoesEntityExist(hlReal) then SetEntityDrawOutline(hlReal, false) end
    hlReal = nil
    if hlTemp and DoesEntityExist(hlTemp) then
        SetEntityAsMissionEntity(hlTemp, true, true)
        DeleteEntity(hlTemp)
    end
    hlTemp = nil
    hlMarker = nil
end

function SetPropHighlight(propId, on)
    ClearPropHighlight()
    if not on then return end
    propId = tonumber(propId)
    local prop = propId and propsById[propId]
    if not prop then return end

    -- Physical prop (station / kiosk / screen): outline its actual world entity.
    local ent = GetStationEntity and GetStationEntity(propId)
    if ent and DoesEntityExist(ent) then
        SetEntityDrawOutline(ent, true)
        SetEntityDrawOutlineColor(HL_OUTLINE[1], HL_OUTLINE[2], HL_OUTLINE[3], HL_OUTLINE[4])
        hlReal = ent
        return
    end

    -- Invisible anchor: spawn its placement-preview body at the point and outline it.
    local spec = ANCHOR_HL[prop.prop_type]
    if not spec then return end
    local gen, x, y, z, h = hlGen, prop.x + 0.0, prop.y + 0.0, prop.z + 0.0, (prop.heading or 0.0) + 0.0

    -- Drawn, not spawned (seats). No model, no entity, nothing to clean up but a
    -- table reference — so no amount of hover churn can leak or crash.
    if spec.marker then
        hlMarker = { x = x, y = y, z = z, h = h }
        return
    end

    CreateThread(function()
        local hash = GetHashKey(spec.model)
        RequestModel(hash)
        local t = GetGameTimer()
        while not HasModelLoaded(hash) and GetGameTimer() - t < 1000 do Wait(0) end
        if not HasModelLoaded(hash) or gen ~= hlGen then SetModelAsNoLongerNeeded(hash); return end
        -- OBJECTS ONLY. Do not add a ped preview back here (see ANCHOR_HL): a hover
        -- highlight spawns and deletes its body on every mouse-over, and peds do not
        -- survive that churn — it crashes the client. Anything ped-shaped belongs in
        -- the `marker` path.
        local e
        do
            e = CreateObject(hash, x, y, z, false, false, false)
            if e and DoesEntityExist(e) then
                SetEntityHeading(e, h)
                SetEntityCollision(e, false, false)
            end
        end
        SetModelAsNoLongerNeeded(hash)
        if not e or not DoesEntityExist(e) or gen ~= hlGen then
            if e and DoesEntityExist(e) then SetEntityAsMissionEntity(e, true, true); DeleteEntity(e) end
            return
        end
        FreezeEntityPosition(e, true)
        SetEntityDrawOutline(e, true)
        SetEntityDrawOutlineColor(HL_OUTLINE[1], HL_OUTLINE[2], HL_OUTLINE[3], HL_OUTLINE[4])
        hlTemp = e
    end)
end
