-- =============================================
--  modules/doorstep | server.lua
--  Answers ONE question for the delivery client: "is this order's drop point an
--  admin-placed delivery door, and where is it?" — so the driver's client can run
--  the knock / hand-off sequence (modules/doorstep/client.lua) before completing.
--
--  It grants nothing. Completion is still `sales:completeOrder`, with all of its
--  own claim + distance + fulfilment checks; this only tells a client whether to
--  play a doorstep scene first. A forged answer would buy an attacker an animation.
-- =============================================

lib.callback.register("pickle_restaurants:doorstep:point", function(src, d)
    local rid, oid = tonumber(d and d.rid), tonumber(d and d.orderId)
    if not (rid and oid) then return nil end
    local o = OrderCache[rid] and OrderCache[rid][oid]
    if not o or o.status ~= "open" or o.order_type ~= "delivery" then return nil end
    -- Only the assigned driver gets the doorstep — the sequence spawns a ped and
    -- locks the player into animations, which nobody else's client should be told
    -- to do on this order's behalf.
    if not o.driver_identifier or o.driver_identifier ~= GetIdentifier(src) then return nil end

    local t = DeliveryTargets[oid]
    if not (t and t.door) then return nil end -- a plain coordinate drop: no door
    local prop = PropCache[t.door]
    if not prop or prop.prop_type ~= "delivery_door" then return nil end

    return {
        x = prop.x + 0.0, y = prop.y + 0.0, z = prop.z + 0.0,
        heading = (prop.heading or 0.0) + 0.0,
        name = o.customer_name,
    }
end)

-- ─── the scene's networked entities, and their dead-man's switch ──────────────
-- The hand-off used to be entirely client-LOCAL: only the driver saw the resident and
-- the bag, so to everyone else a delivery was a man miming at a door. They are networked
-- now, which is the only way anyone else can see them — and that is exactly why this
-- exists. A networked entity outlives the client that made it: a driver who crashes,
-- alt-F4s or hits a timeout mid-scene would leave a stranger's ped standing in the road
-- forever, and it is the reason the scene was local in the first place.
--
-- So the client reports what it spawned and the server holds a DEADLINE. Whoever gets
-- there first cleans up: the client on a normal ending (the usual case), or this thread /
-- the drop handler when the client can no longer speak for itself. Deleting an already
-- deleted entity is a no-op, so the two racing is harmless.
local SceneEntities = {}   -- [src] = { deadline = os.time() + ttl, ents = { entityId, … } }
local SCENE_TTL    = 45    -- seconds; the scene itself is ~10s, so this is slack, not a timer

local function sweepScene(src)
    local rec = SceneEntities[src]
    if not rec then return end
    SceneEntities[src] = nil
    for _, ent in ipairs(rec.ents) do
        if DoesEntityExist(ent) then DeleteEntity(ent) end
    end
end

-- The client hands over NETWORK ids; the server resolves them to its own entity handles
-- (a net id is the only handle both sides share).
RegisterNetEvent("pickle_restaurants:doorstep:sceneEntities", function(netIds)
    local src = source
    if type(netIds) ~= "table" then return end
    local ents = {}
    for _, id in ipairs(netIds) do
        local ent = NetworkGetEntityFromNetworkId(tonumber(id) or 0)
        if ent and ent ~= 0 and DoesEntityExist(ent) then ents[#ents + 1] = ent end
    end
    if #ents == 0 then return end
    -- A second scene from the same driver sweeps the first: one hand-off at a time, and a
    -- report that never got its "done" must not keep the next one's entities alive.
    sweepScene(src)
    SceneEntities[src] = { deadline = os.time() + SCENE_TTL, ents = ents }
end)

-- The scene ended cleanly and the client has deleted its own props: forget them without
-- deleting (they are already gone, and a stale handle could have been recycled).
RegisterNetEvent("pickle_restaurants:doorstep:sceneDone", function()
    SceneEntities[source] = nil
end)

AddEventHandler("playerDropped", function()
    sweepScene(source)
end)

CreateThread(function()
    while true do
        Wait(5000)
        local now = os.time()
        for src, rec in pairs(SceneEntities) do
            if rec.deadline <= now then sweepScene(src) end
        end
    end
end)
