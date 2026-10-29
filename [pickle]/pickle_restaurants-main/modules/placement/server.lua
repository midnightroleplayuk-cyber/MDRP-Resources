-- =============================================
--  modules/placement | server.lua
--  Persists placed station props / counter points; broadcasts spawns.
-- =============================================

local PLACEABLE_MODELS = {
    soda_machine = "pickle_soda_fountain_01",
    fryer        = "pickle_fryer_01",
    stovetop     = "pickle_stovetop_01",
    kitchen_prep = "pickle_kitchen_prep_01",
    -- Self-order kiosk (physical world prop; opens the order NUI, not a station).
    -- Wall-mounted terminal (_01) and free-standing ground kiosk (_02).
    kiosk        = "pickle_kiosk_large_01",
    kiosk_ground = "pickle_kiosk_large_02",
    -- Non-interactable customer info screens (menu board / orders board); their
    -- branded screen texture is driven by a DUI in modules/screens.
    menu_screen   = "pickle_screen_menu_01",
    orders_screen = "pickle_screen_orders_01",
}

lib.callback.register("pickle_restaurants:placement:saveProp", function(src, d)
    local id = tonumber(d.restaurant_id)
    if not GetRestaurant(id) then return { ok = false, error = _L("placement_no_restaurant") } end
    -- ADMIN ONLY: placing/moving/removing world entities is a server-layout job, not
    -- a restaurant manager's. The boss panel no longer offers it at all; this is the
    -- gate that actually enforces it (the NUI is untrusted).
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end
    if PLACEABLE_MODELS[d.prop_type] ~= d.model then return { ok = false, error = _L("placement_invalid_station") } end

    local propId = MySQL.insert.await(
        "INSERT INTO pickle_restaurant_props (restaurant_id, prop_type, model, x, y, z, heading) VALUES (?, ?, ?, ?, ?, ?, ?)",
        { id, d.prop_type, d.model, d.x + 0.0, d.y + 0.0, d.z + 0.0, (d.heading or 0.0) + 0.0 })
    if not propId then return { ok = false } end

    local prop = {
        id = propId, restaurant_id = id, prop_type = d.prop_type, model = d.model,
        x = d.x + 0.0, y = d.y + 0.0, z = d.z + 0.0, heading = (d.heading or 0.0) + 0.0, metadata = {},
    }
    PropCache[propId] = prop
    -- Scoped: a prop appearing is only news to players at that restaurant. Anyone further
    -- out picks it up from `world:getRestaurant` as they approach — writing PropCache FIRST
    -- is what makes that safe, since the fetch reads it.
    SendTo(PlayersNearRestaurant(id, ScopeRadius.PROP), "pickle_restaurants:propPlaced", prop)
    return { ok = true, id = propId }
end)

-- The submitted seat style, validated against the shared catalogue. The NUI (and
-- the placement client) are untrusted, so an unknown id becomes the default rather
-- than being written through to a row nothing can then sit on.
local function SeatStyleId(v)
    for _, s in ipairs(Config.SeatStyles) do
        if s.id == v then return v end
    end
    return Config.DefaultSeatStyle
end

-- One optional point on a seat (its stand-up spot, its meal-tray spot). Coerced to
-- plain numbers here so a malformed payload can't put a string (or a NaN) into a row
-- that a client will later hand straight to SetEntityCoords. nil = not placed, and
-- each consumer has its own fallback for that.
local function SeatPoint(v)
    if type(v) ~= "table" then return nil end
    local x, y, z = tonumber(v.x), tonumber(v.y), tonumber(v.z)
    if not (x and y and z) then return nil end
    return { x = x + 0.0, y = y + 0.0, z = z + 0.0, heading = (tonumber(v.heading) or 0.0) + 0.0 }
end

-- A seat is an INVISIBLE sit anchor (prop_type "seat"): stored in the same props
-- table as stations, but nothing spawns in the world — players sit on the
-- restaurant's own furniture at this point/heading. No model is validated (there's
-- no runtime prop); the placement preview is a ghost ped, position + heading only.
--
-- metadata.style names which Config.SeatStyles entry it is — the scenario the
-- seating module plays, i.e. whether this anchor is a dining chair, a bar stool or
-- a booth bench. A row without one sits as the default style.
lib.callback.register("pickle_restaurants:placement:saveSeat", function(src, d)
    local id = tonumber(d.restaurant_id)
    if not GetRestaurant(id) then return { ok = false, error = _L("placement_no_restaurant") } end
    -- ADMIN ONLY: placing/moving/removing world entities is a server-layout job, not
    -- a restaurant manager's. The boss panel no longer offers it at all; this is the
    -- gate that actually enforces it (the NUI is untrusted).
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end

    local metadata = { style = SeatStyleId(d.style), exit = SeatPoint(d.exit), tray = SeatPoint(d.tray) }
    local propId = MySQL.insert.await(
        "INSERT INTO pickle_restaurant_props (restaurant_id, prop_type, model, x, y, z, heading, metadata) VALUES (?, 'seat', '', ?, ?, ?, ?, ?)",
        { id, d.x + 0.0, d.y + 0.0, d.z + 0.0, (d.heading or 0.0) + 0.0, json.encode(metadata) })
    if not propId then return { ok = false } end

    local prop = {
        id = propId, restaurant_id = id, prop_type = "seat", model = "",
        x = d.x + 0.0, y = d.y + 0.0, z = d.z + 0.0, heading = (d.heading or 0.0) + 0.0,
        metadata = metadata,
    }
    PropCache[propId] = prop
    -- Scoped: a prop appearing is only news to players at that restaurant. Anyone further
    -- out picks it up from `world:getRestaurant` as they approach — writing PropCache FIRST
    -- is what makes that safe, since the fetch reads it.
    SendTo(PlayersNearRestaurant(id, ScopeRadius.PROP), "pickle_restaurants:propPlaced", prop)
    return { ok = true, id = propId }
end)

-- A DELIVERY DOOR is an invisible anchor (prop_type "delivery_door") stored like a
-- seat: point + heading, no model, no runtime prop. It is where an NPC delivery
-- order sends the driver — the doorstep they knock on — and the heading is the way
-- the resident FACES when they open it, i.e. out of the doorway toward the street.
-- NPC deliveries pick a random one of these; a restaurant with none falls back to
-- the old random-bearing drop point, so this is additive.
lib.callback.register("pickle_restaurants:placement:saveDeliveryDoor", function(src, d)
    local id = tonumber(d.restaurant_id)
    if not GetRestaurant(id) then return { ok = false, error = _L("placement_no_restaurant") } end
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end
    local x, y, z = tonumber(d.x), tonumber(d.y), tonumber(d.z)
    if not (x and y and z) then return { ok = false } end

    local propId = MySQL.insert.await(
        "INSERT INTO pickle_restaurant_props (restaurant_id, prop_type, model, x, y, z, heading) VALUES (?, 'delivery_door', '', ?, ?, ?, ?)",
        { id, x + 0.0, y + 0.0, z + 0.0, (tonumber(d.heading) or 0.0) + 0.0 })
    if not propId then return { ok = false } end

    local prop = {
        id = propId, restaurant_id = id, prop_type = "delivery_door", model = "",
        x = x + 0.0, y = y + 0.0, z = z + 0.0, heading = (tonumber(d.heading) or 0.0) + 0.0,
        metadata = {},
    }
    PropCache[propId] = prop
    -- Scoped: a prop appearing is only news to players at that restaurant. Anyone further
    -- out picks it up from `world:getRestaurant` as they approach — writing PropCache FIRST
    -- is what makes that safe, since the fetch reads it.
    SendTo(PlayersNearRestaurant(id, ScopeRadius.PROP), "pickle_restaurants:propPlaced", prop)
    return { ok = true, id = propId }
end)

-- The station types a virtual point may open. Mirrors PLACEABLE_MODELS' keys —
-- the NUI is untrusted, so the target is whitelisted here.
local VIRTUAL_TARGETS = {
    soda_machine = true, fryer = true, stovetop = true, kitchen_prep = true,
}

-- A virtual point is an INVISIBLE interaction anchor (prop_type "virtual_point"),
-- stored like a seat: no model, just a point + heading. metadata.target names the
-- station type it opens inside the restaurant's virtual kitchen shell. Each row is
-- its own point INSTANCE — the cooking state it holds is keyed by this prop id, so
-- two points for the same station type never share anything.
lib.callback.register("pickle_restaurants:placement:saveVirtualPoint", function(src, d)
    local id = tonumber(d.restaurant_id)
    if not GetRestaurant(id) then return { ok = false, error = _L("placement_no_restaurant") } end
    -- ADMIN ONLY: placing/moving/removing world entities is a server-layout job, not
    -- a restaurant manager's. The boss panel no longer offers it at all; this is the
    -- gate that actually enforces it (the NUI is untrusted).
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end
    if not VIRTUAL_TARGETS[d.target] then return { ok = false, error = _L("placement_invalid_station") } end
    local x, y, z = tonumber(d.x), tonumber(d.y), tonumber(d.z)
    if not (x and y and z) then return { ok = false } end

    local metadata = { target = d.target }
    local propId = MySQL.insert.await(
        "INSERT INTO pickle_restaurant_props (restaurant_id, prop_type, model, x, y, z, heading, metadata) VALUES (?, 'virtual_point', '', ?, ?, ?, ?, ?)",
        { id, x + 0.0, y + 0.0, z + 0.0, (tonumber(d.heading) or 0.0) + 0.0, json.encode(metadata) })
    if not propId then return { ok = false } end

    local prop = {
        id = propId, restaurant_id = id, prop_type = "virtual_point", model = "",
        x = x + 0.0, y = y + 0.0, z = z + 0.0, heading = (tonumber(d.heading) or 0.0) + 0.0, metadata = metadata,
    }
    PropCache[propId] = prop
    -- Scoped: a prop appearing is only news to players at that restaurant. Anyone further
    -- out picks it up from `world:getRestaurant` as they approach — writing PropCache FIRST
    -- is what makes that safe, since the fetch reads it.
    SendTo(PlayersNearRestaurant(id, ScopeRadius.PROP), "pickle_restaurants:propPlaced", prop)
    return { ok = true, id = propId }
end)

-- The restaurant's virtual kitchen shell: one per restaurant, stored in
-- metadata.shell. XY is always re-derived from the counter (the blip/center
-- anchor) so the shell can't drift from its restaurant — the admin placement
-- view only chooses height + facing.
lib.callback.register("pickle_restaurants:placement:saveShell", function(src, d)
    local id = tonumber(d.restaurant_id)
    local r = GetRestaurant(id)
    if not r then return { ok = false, error = _L("placement_no_restaurant") } end
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end
    if not r.counter then return { ok = false, error = _L("place_shell_needs_counter") } end
    local z = tonumber(d.z)
    if not z then return { ok = false } end

    local old = r.metadata and r.metadata.shell
    r.metadata = r.metadata or {}
    r.metadata.shell = {
        x = r.counter.x + 0.0, y = r.counter.y + 0.0,
        z = z + 0.0, heading = (tonumber(d.heading) or 0.0) + 0.0,
    }
    MySQL.update.await("UPDATE pickle_restaurants SET metadata = ? WHERE id = ?", { json.encode(r.metadata), id })
    -- cooking shifts any free-placed virtual items with the shell...
    TriggerEvent("pickle_restaurants:shellMoved", id, old, r.metadata.shell)
    -- ...and any client mid-session inside this shell closes out cleanly. Scoped: only
    -- someone AT this restaurant can be in one of its virtual sessions, and the new anchor
    -- rides the world sync below for everyone else.
    SendTo(PlayersNearRestaurant(id, ScopeRadius.BOARD), "pickle_restaurants:shellMoved", id)
    SyncWorldSoon()
    return { ok = true }
end)

-- A counter is an INVISIBLE register anchor (prop_type "counter"), stored like a
-- seat: no world model, just a point + heading. Each one spawns a register /
-- management interaction (modules/main). A restaurant may have several; the LOWEST-
-- id counter is the restaurant's primary anchor (blip / shell XY / NPC queue), kept
-- in the `counter` column by RecomputeCounterAnchor. Placing one is additive.
lib.callback.register("pickle_restaurants:placement:saveCounter", function(src, d)
    local id = tonumber(d.restaurant_id)
    if not GetRestaurant(id) then return { ok = false, error = _L("placement_no_restaurant") } end
    -- ADMIN ONLY: placing/moving/removing world entities is a server-layout job, not
    -- a restaurant manager's. The boss panel no longer offers it at all; this is the
    -- gate that actually enforces it (the NUI is untrusted).
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end

    local propId = MySQL.insert.await(
        "INSERT INTO pickle_restaurant_props (restaurant_id, prop_type, model, x, y, z, heading) VALUES (?, 'counter', '', ?, ?, ?, ?)",
        { id, d.x + 0.0, d.y + 0.0, d.z + 0.0, (d.heading or 0.0) + 0.0 })
    if not propId then return { ok = false } end

    PropCache[propId] = {
        id = propId, restaurant_id = id, prop_type = "counter", model = "",
        x = d.x + 0.0, y = d.y + 0.0, z = d.z + 0.0, heading = (d.heading or 0.0) + 0.0, metadata = {},
    }
    RecomputeCounterAnchor(id) -- may become the new primary anchor (blip/shell/NPC)
    SyncWorldSoon() -- rebuild counter interactions + blip everywhere
    return { ok = true, id = propId }
end)

-- A virtual register is an INVISIBLE register anchor (prop_type "virtual_register"),
-- stored like a seat: no world model, just a point + heading. Using it opens the
-- ordinary fullscreen NUI register (modules/main) — it has no screen to paint a DUI on,
-- unlike a physical counter. It is NOT a primary anchor (blip/shell/NPC queue stays on
-- the physical counters), so it never touches RecomputeCounterAnchor. Placing is additive.
lib.callback.register("pickle_restaurants:placement:saveVirtualRegister", function(src, d)
    local id = tonumber(d.restaurant_id)
    if not GetRestaurant(id) then return { ok = false, error = _L("placement_no_restaurant") } end
    -- ADMIN ONLY: placing/moving/removing world entities is a server-layout job, not
    -- a restaurant manager's. The boss panel no longer offers it at all; this is the
    -- gate that actually enforces it (the NUI is untrusted).
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end
    local x, y, z = tonumber(d.x), tonumber(d.y), tonumber(d.z)
    if not (x and y and z) then return { ok = false } end

    local propId = MySQL.insert.await(
        "INSERT INTO pickle_restaurant_props (restaurant_id, prop_type, model, x, y, z, heading) VALUES (?, 'virtual_register', '', ?, ?, ?, ?)",
        { id, x + 0.0, y + 0.0, z + 0.0, (tonumber(d.heading) or 0.0) + 0.0 })
    if not propId then return { ok = false } end

    local prop = {
        id = propId, restaurant_id = id, prop_type = "virtual_register", model = "",
        x = x + 0.0, y = y + 0.0, z = z + 0.0, heading = (tonumber(d.heading) or 0.0) + 0.0, metadata = {},
    }
    PropCache[propId] = prop
    -- Scoped: a prop appearing is only news to players at that restaurant. Anyone further
    -- out picks it up from `world:getRestaurant` as they approach — writing PropCache FIRST
    -- is what makes that safe, since the fetch reads it.
    SendTo(PlayersNearRestaurant(id, ScopeRadius.PROP), "pickle_restaurants:propPlaced", prop)
    return { ok = true, id = propId }
end)

-- Reposition an already-placed prop (station / counter / seat / virtual point /
-- kiosk / screen): the admin re-runs the gizmo seeded at the prop's current
-- transform and saves the new one. A full re-sync respawns it at the new spot; a
-- counter move may shift the primary anchor, so recompute it first.
lib.callback.register("pickle_restaurants:placement:updateProp", function(src, d)
    local propId = tonumber(d.id)
    local prop = PropCache[propId]
    if not prop then return { ok = false } end
    -- ADMIN ONLY: placing/moving/removing world entities is a server-layout job, not
    -- a restaurant manager's. The boss panel no longer offers it at all; this is the
    -- gate that actually enforces it (the NUI is untrusted).
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end
    local x, y, z = tonumber(d.x), tonumber(d.y), tonumber(d.z)
    if not (x and y and z) then return { ok = false } end

    prop.x, prop.y, prop.z, prop.heading = x + 0.0, y + 0.0, z + 0.0, (tonumber(d.heading) or 0.0) + 0.0
    MySQL.update.await("UPDATE pickle_restaurant_props SET x = ?, y = ?, z = ?, heading = ? WHERE id = ?",
        { prop.x, prop.y, prop.z, prop.heading, propId })
    -- Repositioning a seat also re-picks its style (the admin chooses one to preview
    -- the right ghost pose before dragging), so the same edit writes it back. Only
    -- for seats, and only when one was submitted — every other prop_type ignores it.
    if prop.prop_type == "seat" and d.style then
        prop.metadata = prop.metadata or {}
        prop.metadata.style = SeatStyleId(d.style)
        -- Cancelling the exit gizmo CLEARS the exit point (nil), which is how you
        -- take one back off a seat — the edit always re-asks, so "no answer" has to
        -- mean "none" or a placed exit could never be removed.
        prop.metadata.exit = SeatPoint(d.exit)
        prop.metadata.tray = SeatPoint(d.tray)
        MySQL.update.await("UPDATE pickle_restaurant_props SET metadata = ? WHERE id = ?",
            { json.encode(prop.metadata), propId })
    end
    if prop.prop_type == "counter" then RecomputeCounterAnchor(prop.restaurant_id) end
    -- The MOVE goes out as a scoped prop update, not as a world sync. `propPlaced` is an
    -- upsert on the client — it replaces the row by id — and the reconciler diffs the row
    -- it built each prop from, so the new transform is part of that signature and exactly
    -- this prop is rebuilt. Sending it directly also keeps the gizmo feeling immediate: a
    -- world sync is coalesced (up to SYNC_MIN_MS), which an admin nudging a prop into place
    -- would feel as lag.
    SendTo(PlayersNearRestaurant(prop.restaurant_id, ScopeRadius.PROP), "pickle_restaurants:propPlaced", prop)
    -- A counter move can shift the restaurant's primary anchor (blip / shell XY / NPC
    -- queue), which lives on the restaurant row rather than the prop — that still needs a
    -- sync, and only for a counter.
    if prop.prop_type == "counter" then SyncWorldSoon() end
    return { ok = true }
end)

-- The per-restaurant NPC customer spawn point (where AI customers appear before
-- walking up to queue). One per restaurant, stored in metadata.npc_spawn like the
-- kitchen shell — a free point + heading. modules/npc_customers folds it into every
-- spawn/state broadcast so clients start the walk-in there instead of a fixed offset
-- back from the counter (which used to bury customers in props and strand them).
lib.callback.register("pickle_restaurants:placement:saveNpcSpawn", function(src, d)
    local id = tonumber(d.restaurant_id)
    local r = GetRestaurant(id)
    if not r then return { ok = false, error = _L("placement_no_restaurant") } end
    -- ADMIN ONLY (not `manage_props`): where AI customers spawn into the world is a
    -- server-layout call — a spot that has to be clear and reachable — not something
    -- a restaurant's own managers set. Same gate as the kitchen shell.
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end
    local x, y, z = tonumber(d.x), tonumber(d.y), tonumber(d.z)
    if not (x and y and z) then return { ok = false } end

    r.metadata = r.metadata or {}
    r.metadata.npc_spawn = { x = x + 0.0, y = y + 0.0, z = z + 0.0, heading = (tonumber(d.heading) or 0.0) + 0.0 }
    MySQL.update.await("UPDATE pickle_restaurants SET metadata = ? WHERE id = ?", { json.encode(r.metadata), id })
    return { ok = true }
end)

lib.callback.register("pickle_restaurants:placement:removeProp", function(src, d)
    local propId = tonumber(d.id)
    local prop = PropCache[propId]
    if not prop then return { ok = false } end
    -- ADMIN ONLY: placing/moving/removing world entities is a server-layout job, not
    -- a restaurant manager's. The boss panel no longer offers it at all; this is the
    -- gate that actually enforces it (the NUI is untrusted).
    if not IsPlayerAdmin(src) then return { ok = false, error = _L("no_permission") } end
    MySQL.update.await("DELETE FROM pickle_restaurant_props WHERE id = ?", { propId })
    -- Audience BEFORE the cache write. PlayersNearRestaurant derives its sphere from the
    -- restaurant's props, so asking after the row is gone can answer with a sphere this prop
    -- no longer contributes to — or, for the last prop of a restaurant, with nobody at all.
    -- Resolve who is watching while the thing being removed still exists.
    local audience = PlayersNearRestaurant(prop.restaurant_id, ScopeRadius.PROP)
    PropCache[propId] = nil
    SendTo(audience, "pickle_restaurants:propRemoved", propId)
    -- server-side notice so other modules can release state tied to this prop
    -- (cooking drops any items cooking on it; seating frees its occupancy)
    TriggerEvent("pickle_restaurants:propDeleted", propId)
    -- Removing a counter may drop or shift the restaurant's primary anchor
    -- (blip / shell XY / NPC queue) — recompute it and re-sync the world.
    if prop.prop_type == "counter" and RecomputeCounterAnchor(prop.restaurant_id) then
        SyncWorldSoon()
    end
    return { ok = true }
end)

lib.callback.register("pickle_restaurants:getProps", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_props") then return {} end
    local list = {}
    for _, p in pairs(PropCache) do
        if p.restaurant_id == id then list[#list + 1] = PropSummary(p) end
    end
    return list
end)
