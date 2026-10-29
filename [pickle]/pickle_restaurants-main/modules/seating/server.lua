-- =============================================
--  modules/seating | server.lua
--  Seat occupancy AND seat ACCESS for the invisible sit anchors (prop_type "seat").
--
--  Occupancy stops two players sharing one anchor and clipping into each other — the
--  sit itself is a client animation. A seat is freed when its occupant stands, drops,
--  or the seat prop is deleted.
--
--  Access is the reservations half (modules/phone/server.lua): an anchor held by an
--  ACTIVE reservation admits only its holder and that reservation's granted guests.
--  `seating:sit` is the ONE door — the client's "Reserved" interaction label is a hint
--  off the synced map, never the check — so anything new that seats a player has to
--  come through here rather than growing its own copy of the rule.
--
--  Anyone else gets `reserved = true` back, which is what makes the client offer to
--  ASK: the request is relayed to the holder's phone + a prompt, and an accept adds the
--  asker as a guest of that reservation (all of its seats) and tells them to sit.
-- =============================================

local SeatOccupancy = {} -- [propId] = src currently seated there

-- ─── seat requests ("ask to sit here") ───────────────────────────────────────
-- One in flight per REQUESTER, expiring after this long. Both bounds exist for the
-- same reason: a prompt is an interruption, so nobody should be able to queue them up
-- against a holder, and a request the holder never answered must not sit its asker down
-- ten minutes later on a seat they've walked away from.
local REQUEST_TTL = 60

local SeatRequests = {}  -- [reqId] = { id, from, fromIdent, name, propId, resId, holder, expires }
local nextRequestId = 0

local function requestLive(req)
    return req ~= nil and req.expires > os.time()
end

-- Drop expired rows lazily rather than on a timer: nothing depends on a request
-- disappearing on the second, and the only questions asked of this table ("has this
-- player got one open", "is this answer still valid") are asked at exactly the moments
-- a sweep would matter.
local function pruneRequests()
    local now = os.time()
    for id, req in pairs(SeatRequests) do
        if req.expires <= now then SeatRequests[id] = nil end
    end
end

local function requestFrom(src)
    for _, req in pairs(SeatRequests) do
        if req.from == src and requestLive(req) then return req end
    end
    return nil
end

-- Reserve a seat. Rejects an anchor that isn't a seat, one held by somebody else's
-- reservation, or one already taken by another player (re-requesting your own seat is a
-- no-op success).
lib.callback.register("pickle_restaurants:seating:sit", function(src, d)
    local propId = tonumber(d and d.id)
    local prop = propId and PropCache[propId]
    if not prop or prop.prop_type ~= "seat" then return { ok = false, error = _L("seat_cant_sit") } end

    -- Reservation gate BEFORE occupancy: "this table is booked" is the more useful
    -- answer than "that seat is taken" when both are true, and it's the one the client
    -- can act on (it offers to ask). Guarded because the reservations backend is the
    -- phone module — a server with it stripped out has no held seats at all.
    local res = ReservationForSeat and ReservationForSeat(propId)
    if res and not ReservationAdmits(res, GetIdentifier(src)) then
        return { ok = false, reserved = true, error = _L("seat_reserved") }
    end

    local holder = SeatOccupancy[propId]
    if holder and holder ~= src then return { ok = false, error = _L("seat_taken") } end
    SeatOccupancy[propId] = src
    return { ok = true }
end)

-- Ask the reservation's holder for a seat at their table. Answers immediately with
-- whether the ASK went out; the accept/decline arrives later as a client event, since
-- it depends on another player reading a prompt.
lib.callback.register("pickle_restaurants:seating:requestSeat", function(src, d)
    pruneRequests()
    local propId = tonumber(d and d.propId)
    local prop = propId and PropCache[propId]
    if not prop or prop.prop_type ~= "seat" then return { ok = false, error = _L("seat_cant_sit") } end
    local res = ReservationForSeat and ReservationForSeat(propId)
    -- No live reservation any more (it expired, or was cancelled while the client was
    -- reading the prompt): tell them to just sit down rather than paging nobody.
    if not res then return { ok = false, error = _L("seat_free_now") } end
    local me = GetIdentifier(src)
    if ReservationAdmits(res, me) then return { ok = false, error = _L("seat_free_now") } end
    if requestFrom(src) then return { ok = false, error = _L("seat_request_pending") } end

    -- The holder has to be ONLINE to answer. There is deliberately no auto-accept and
    -- no fallback to the restaurant's staff: the seats are the holder's to share.
    local holderSrc = SourceForIdentifier and SourceForIdentifier(res.identifier) or nil
    if not holderSrc then return { ok = false, error = _L("seat_holder_away") } end

    nextRequestId = nextRequestId + 1
    local req = {
        id = nextRequestId, from = src, fromIdent = me,
        name = GetPlayerCharacterName and GetPlayerCharacterName(src) or nil,
        propId = propId, resId = res.id, holder = res.identifier,
        expires = os.time() + REQUEST_TTL,
    }
    SeatRequests[req.id] = req

    local r = GetRestaurant(prop.restaurant_id)
    local place = r and (r.label or r.name) or _L("phone_order_fallback")
    -- BOTH channels, on purpose: the phone notification is the record ("someone asked
    -- while I was driving"), and the prompt is what can actually be answered. A phone
    -- alone can't answer, and a prompt alone is missed by anyone not looking.
    if PhoneNotify then
        PhoneNotify(holderSrc, _L("seat_request_notify_title"), _L("seat_request_notify_body", req.name or "?", place))
    end
    TriggerClientEvent("pickle_restaurants:seating:seatRequest", holderSrc, {
        id = req.id, name = req.name, restaurant = place, ttl = REQUEST_TTL,
    })
    return { ok = true, sent = true }
end)

-- The holder's answer. A net event, not a callback: the prompt is fire-and-forget from
-- the holder's side, and everything that follows is a push to the OTHER player.
RegisterNetEvent("pickle_restaurants:seating:answerSeat", function(d)
    local src = source
    pruneRequests()
    local req = SeatRequests[tonumber(d and d.id)]
    if not requestLive(req) then return end
    -- Only the holder this request was raised against may answer it, re-checked here
    -- rather than trusted from the client: the event is open to everyone.
    if GetIdentifier(src) ~= req.holder then return end
    SeatRequests[req.id] = nil

    local res = ReservationForSeat and ReservationForSeat(req.propId)
    if not (d and d.accept) then
        TriggerClientEvent("pickle_restaurants:seating:seatAnswer", req.from, { ok = false })
        return
    end
    -- The reservation may have ended while the prompt was up; a grant with nothing to
    -- grant is just a free seat, so tell the asker to sit either way.
    if res and res.id == req.resId then
        local ok, err = ReservationAddGuest(res, req.fromIdent, req.name)
        if not ok then
            TriggerClientEvent("pickle_restaurants:seating:seatAnswer", req.from, { ok = false, error = _L(err or "reserve_guest_limit") })
            return
        end
    end
    TriggerClientEvent("pickle_restaurants:seating:seatAnswer", req.from,
        { ok = true, propId = req.propId })
end)

-- Who is sitting on this anchor right now (nil = nobody). Occupancy is what makes a
-- seat single-occupant, so anything that has to decide "may this player speak for this
-- seat" asks here rather than keeping a second idea of who is on it — modules/mirror
-- gates a diner's published meal render on it, exactly as it gates a cook's prep table
-- on the station claim.
function SeatHolder(propId)
    return SeatOccupancy[tonumber(propId) or -1]
end

RegisterNetEvent("pickle_restaurants:seating:stand", function(propId)
    propId = tonumber(propId)
    if propId and SeatOccupancy[propId] == source then SeatOccupancy[propId] = nil end
end)

-- Free every seat a leaving player held, and drop any request they were part of — a
-- request whose asker left would seat a stranger who reconnected onto that source id.
AddEventHandler("playerDropped", function()
    for propId, holder in pairs(SeatOccupancy) do
        if holder == source then SeatOccupancy[propId] = nil end
    end
    local ident = GetIdentifier(source)
    for id, req in pairs(SeatRequests) do
        if req.from == source or (ident and req.holder == ident) then SeatRequests[id] = nil end
    end
end)

-- A deleted seat frees its reservation (the occupant's client auto-stands).
AddEventHandler("pickle_restaurants:propDeleted", function(propId)
    SeatOccupancy[tonumber(propId)] = nil
end)
