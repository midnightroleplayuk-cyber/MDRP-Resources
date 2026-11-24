local SEAT_REACH = 3.5
local OCCUPIED_RANGE = 5.0
local BOARD_REACH = 6.0

local SeatHolder = {} -- [pointId] = src
local HeldSeat = {}   -- [src] = pointId

local function distanceTo(src, point)
    local ped = GetPlayerPed(src)
    if ped == 0 then return math.huge end
    return #(GetEntityCoords(ped) - vector3(point.x, point.y, point.z))
end

local function releaseSeat(src)
    local pointId = HeldSeat[src]
    if not pointId then return end
    HeldSeat[src] = nil
    if SeatHolder[pointId] == src then SeatHolder[pointId] = nil end
end

-- A holder who crashed or was teleported away must not keep the seat.
local function isTaken(pointId, src)
    local holder = SeatHolder[pointId]
    if not holder or holder == src then return false end
    local point = NDM.Points.Get(pointId)
    if GetPlayerPed(holder) ~= 0 and point and distanceTo(holder, point) <= OCCUPIED_RANGE then
        return true
    end
    releaseSeat(holder)
    return false
end

lib.callback.register('ndm_business:dining:sit', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local point = NDM.Points.Get(payload.point)
    if not point or point.type ~= 'seat' then return { ok = false, error = 'This seat is not available.' } end
    if distanceTo(src, point) > SEAT_REACH then return { ok = false, error = 'You are too far from the seat.' } end
    if isTaken(point.id, src) then return { ok = false, error = 'Someone is already sitting there.' } end

    releaseSeat(src)
    SeatHolder[point.id], HeldSeat[src] = src, point.id
    return { ok = true, x = point.x, y = point.y, z = point.z, heading = point.heading }
end)

lib.callback.register('ndm_business:dining:stand', function(src)
    releaseSeat(src)
    return true
end)

lib.callback.register('ndm_business:dining:menu', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local point = NDM.Points.Get(payload.point)
    if not point or point.type ~= 'menu_board' then return { ok = false, error = 'This menu is not available.' } end
    if distanceTo(src, point) > BOARD_REACH then return { ok = false, error = 'You are too far from the menu.' } end
    local venue = NDM.Venue.Get(point.venue_id)
    if not venue then return { ok = false, error = 'This menu is not available.' } end

    local items = {}
    for _, entry in ipairs(NDM.Register.MenuData(venue)) do
        if (tonumber(entry.price) or 0) > 0 then
            items[#items + 1] = { label = entry.label, price = entry.price, available = entry.quantity > 0 }
        end
    end
    table.sort(items, function(a, b) return a.label < b.label end)
    return { ok = true, venue = venue.label, items = items }
end)

AddEventHandler('playerDropped', function()
    releaseSeat(source)
end)
