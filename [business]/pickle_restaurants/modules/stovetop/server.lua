-- =============================================
--  modules/stovetop | server.lua
--  Server-side stovetop-station state (more coming). Today: authoritative
--  open/closed state for the oven doors. State is kept only in the in-memory
--  PropCache (so it rides the normal sync to clients and to late joiners) — it
--  is intentionally NOT persisted, so doors just reset closed on restart.
-- =============================================

lib.callback.register("pickle_restaurants:doors:toggle", function(src, d)
    local prop = PropCache[tonumber(d.prop_id)]
    if not prop or StationType(prop) ~= "stovetop" then return { ok = false } end
    if not HasPerm(prop.restaurant_id, src, "cook") then return { ok = false, error = _L("no_work_here") } end

    local door = tonumber(d.door)
    if door ~= 1 and door ~= 2 then return { ok = false } end

    prop.metadata = prop.metadata or {}
    local doors = prop.metadata.doors or {}
    doors[1] = doors[1] == true
    doors[2] = doors[2] == true
    doors[door] = not doors[door]
    prop.metadata.doors = doors -- in-memory only; rides the sync payload

    -- Scoped to the oven: the handler animates a door on a prop that must be spawned
    -- locally to do anything at all (SetOvenDoor no-ops without it), so every player
    -- outside the station's range was paying for a message they discarded. The door's
    -- open/closed state also rides the sync payload, so a client arriving later reads
    -- the current position from its prop row rather than from a missed event.
    SendNearProp(prop.id, ScopeRadius.PROP, "pickle_restaurants:doors:set", prop.id, door, doors[door])
    -- drive the bake gate: closing a door starts baking its cavity, opening pauses it
    TriggerEvent("pickle_restaurants:oven:gate", prop.id, door, doors[door])
    return { ok = true, open = doors[door] }
end)
