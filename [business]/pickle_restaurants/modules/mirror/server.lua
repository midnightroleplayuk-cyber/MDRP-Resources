-- =============================================
--  modules/mirror | server.lua
--  RELAY for the two things this resource renders client-side and everyone in the
--  room should see anyway: a cook's PREP TABLE build and a seated diner's laid-out
--  MEAL (see client.lua for why the owner is the author). Same shape as every other
--  world event here — ONE authority, an audience resolved by distance, local props on
--  the receiving side. Nothing is ever a `-1`.
--
--  THE AUTHORITY IS THE PROP, not the sender's word, and each kind of prop already
--  has exactly one occupant:
--    • kitchen_prep — the station CLAIM (`StationHolder`, modules/cooking).
--    • seat         — the seat's OCCUPANT (`SeatHolder`, modules/seating).
--  Only that player's rows are accepted for that prop, which is also why there is
--  nothing to merge: two authors for one surface cannot exist. A prop type with no
--  occupancy rule has no mirror, and asking for one is refused rather than guessed
--  at — a mirror nobody owns is a picture nobody can ever take down.
-- =============================================

-- [propId] = { src = the publishing owner, rows = { {m,x,y,z,rx,ry,rz}, … } }
-- Latest snapshot only. This is a PICTURE, not a log: a player arriving late wants
-- what is on the table now, and nothing here is ever replayed in order.
local Mirror = {}

-- A build or a laid-out meal is a handful of props; the cap is a bound on a hostile
-- payload, not a design limit (a full serving tray of stacked burgers is well under it).
local MAX_ROWS = 96

local function num(v, lo, hi)
    v = tonumber(v)
    if not v or v ~= v then return nil end -- nil / NaN
    if lo and v < lo then return nil end
    if hi and v > hi then return nil end
    return v
end

-- Who may publish for this prop, or nil if nobody can. ONE place, so a new mirrored
-- surface is one line here plus its own occupancy accessor — and a prop type nobody
-- occupies can never be published to.
local function authorityFor(prop, propId)
    if not prop then return nil end
    if prop.prop_type == "kitchen_prep" then return StationHolder and StationHolder(propId) end
    if prop.prop_type == "seat" then return SeatHolder and SeatHolder(propId) end
    return nil
end

-- Sanitise a published snapshot. The client is untrusted like any other: a row must
-- be a real model hash and a finite transform, and anything else is dropped rather
-- than relayed on to other people's clients to spawn.
local function sanitize(rows)
    local out = {}
    if type(rows) ~= "table" then return out end
    for _, r in ipairs(rows) do
        if #out >= MAX_ROWS then break end
        if type(r) == "table" then
            local m = num(r.m, 1)
            local x, y, z = num(r.x), num(r.y), num(r.z)
            if m and x and y and z then
                local row = { m = math.floor(m), x = x, y = y, z = z,
                              rx = num(r.rx) or 0.0, ry = num(r.ry) or 0.0,
                              rz = num(r.rz) or 0.0 }
                -- A takeout box's food PICTURE. It is an image url painted into a DUI
                -- on the receiving clients, so it is length-capped and taken only from
                -- the prop's own occupant — and the quad page renders it as an <img>,
                -- never as a page, which is what keeps an odd url a broken picture
                -- rather than something running on someone else's screen.
                if type(r.q) == "string" and r.q ~= "" and #r.q <= 512 then
                    row.q = r.q
                    local c = type(r.qc) == "table" and r.qc or nil
                    if c and num(c.x) and num(c.y) and num(c.w) and num(c.h) then
                        row.qc = { x = num(c.x), y = num(c.y), w = num(c.w), h = num(c.h) }
                    end
                end
                out[#out + 1] = row
            end
        end
    end
    return out
end

-- Tell the audience a surface is empty (the owner left, or was thrown out). Sent
-- rather than simply forgotten: a scoped event needs a hydration edge, and "nothing
-- here now" is state a client already in range will never learn any other way.
local function clearMirror(propId)
    if not Mirror[propId] then return end
    Mirror[propId] = nil
    SendNearProp(propId, ScopeRadius.PROP, "pickle_restaurants:mirror:set", propId, {})
end

RegisterNetEvent("pickle_restaurants:mirror:publish", function(propId, rows)
    local src = source
    propId = tonumber(propId)
    if not propId then return end
    local prop = PropCache[propId]
    -- Only the player actually AT this prop may draw on it. Everything about the
    -- payload is cosmetic, but a stranger publishing to a prop across the map would
    -- put food on a table nobody is sitting at.
    if authorityFor(prop, propId) ~= src then
        clearMirror(propId)
        return
    end
    local clean = sanitize(rows)
    if #clean == 0 then
        clearMirror(propId)
        return
    end
    Mirror[propId] = { src = src, rows = clean }
    -- The audience minus the author: they are looking at their own props, and a mirror
    -- of them on top would be a second copy in the same place.
    for _, target in ipairs(PlayersNearProp(propId, ScopeRadius.PROP)) do
        if target ~= src then
            TriggerClientEvent("pickle_restaurants:mirror:set", target, propId, clean)
        end
    end
end)

-- THE HYDRATION EDGE for a scoped event: a client walking into range asks what is on
-- the table, exactly as it asks a cooking station to replay its items. Answering with
-- the cached picture is the whole reason the cache exists.
-- Answers a whole range pass at once: { [propId] = rows } for the ones that have
-- anything, nothing for the rest. Batched because a restaurant's seats are mirrored
-- too — a per-prop question would be one callback per chair every time someone walks
-- in, almost all of them answering "nothing there".
lib.callback.register("pickle_restaurants:mirror:state", function(src, d)
    local ids = (type(d) == "table" and type(d.ids) == "table") and d.ids or {}
    local out = {}
    local n = 0
    for _, raw in ipairs(ids) do
        n = n + 1
        if n > 128 then break end -- a pass is bounded by what's in range; this is the hostile-payload cap
        local propId = tonumber(raw)
        local rec = propId and Mirror[propId]
        if rec then
            -- A snapshot whose author no longer occupies the prop is stale by
            -- definition — they left through a path that never reached us (a crash, a
            -- claim taken away by a fire). Drop it rather than hand a newcomer food
            -- that isn't there.
            if authorityFor(PropCache[propId], propId) ~= rec.src then
                clearMirror(propId)
            elseif rec.src ~= src then -- their own props are already in front of them
                out[tostring(propId)] = rec.rows
            end
        end
    end
    return out
end)

-- The owner gave the prop up (or left the game). Both occupancies are released by
-- their own modules' events; this hangs off those rather than reaching into their
-- tables, so none of the three has to know about the others.
local function releasedBy(propId, src)
    propId = tonumber(propId)
    local rec = propId and Mirror[propId]
    if rec and rec.src == src then clearMirror(propId) end
end

AddEventHandler("pickle_restaurants:cooking:closeStation", function(propId) releasedBy(propId, source) end)
AddEventHandler("pickle_restaurants:seating:stand", function(propId) releasedBy(propId, source) end)

AddEventHandler("playerDropped", function()
    for propId, rec in pairs(Mirror) do
        if rec.src == source then clearMirror(propId) end
    end
end)
