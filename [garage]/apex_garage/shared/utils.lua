--[[ apex_garage — shared/utils.lua   (open source) ]]

Utils = Utils or {}

function Utils.Debug(...)
    if not Config.debug then return end
    print(('^5[apex_garage]^0 %s'):format(table.concat({ ... }, ' ')))
end

function Utils.Err(...)
    print(('^1[apex_garage] %s^0'):format(table.concat({ ... }, ' ')))
end

function Utils.Round(n, dp)
    local mult = 10 ^ (dp or 0)
    return math.floor((tonumber(n) or 0) * mult + 0.5) / mult
end

function Utils.Money(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(math.abs(n)):reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^,', '')
    if n < 0 then s = '-' .. s end
    if Config.currency.position == 'after' then return s .. Config.currency.symbol end
    return Config.currency.symbol .. s
end

function Utils.Clamp(n, lo, hi)
    n = tonumber(n) or lo
    if n < lo then return lo end
    if n > hi then return hi end
    return n
end

function Utils.SafeAmount(n)
    n = math.floor(tonumber(n) or 0)
    if n <= 0 then return nil end
    return n
end

-- oxmysql returns TINYINT(1) columns as booleans — treat 1/true alike
function Utils.IsTrue(v)
    return v == 1 or v == true
end

function Utils.TableContains(tbl, value)
    if not tbl then return false end
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

-- Canonical plate form: trimmed + upper. Everything compares plates this way so
-- a trailing space from CreateVehicle can never split "ABC 123 " from "ABC 123".
function Utils.CleanPlate(value)
    if type(value) ~= 'string' then return nil end
    return (value:gsub('^%s*(.-)%s*$', '%1')):upper()
end

-- Native GTA class -> our garage domain (car/air/sea).
function Utils.ClassDomain(class)
    return (Config.classDomain and Config.classDomain[class]) or 'car'
end

-- Is a world point inside a zone descriptor? Handles both shapes the placer
-- produces — a circle {x,y,z,r} and a polygon {points={{x,y}...}, minZ, maxZ} —
-- so the same test serves garage zones, parking blacklists, client and server.
function Utils.PointInZone(zone, x, y, z)
    if type(zone) ~= 'table' then return false end

    if zone.shape == 'poly' and type(zone.points) == 'table' and #zone.points >= 3 then
        if z and (z < (zone.minZ or -1000.0) or z > (zone.maxZ or 10000.0)) then return false end
        -- even-odd ray cast, purely 2D; height was checked above
        local pts, inside = zone.points, false
        local n = #pts
        local j = n
        for i = 1, n do
            local xi, yi = pts[i].x, pts[i].y
            local xj, yj = pts[j].x, pts[j].y
            if ((yi > y) ~= (yj > y)) and (x < (xj - xi) * (y - yi) / (yj - yi) + xi) then
                inside = not inside
            end
            j = i
        end
        return inside
    end

    if not zone.x then return false end
    local r = tonumber(zone.r) or 0
    if r <= 0 then return false end
    local dx, dy = x - zone.x, y - zone.y
    if (dx * dx + dy * dy) > (r * r) then return false end
    if z then
        -- explicit band wins when the shape carries one
        if zone.minZ or zone.maxZ then
            return z >= (zone.minZ or -1000.0) and z <= (zone.maxZ or 10000.0)
        end
        -- Otherwise a fixed-ish band. Letting the tolerance grow with the radius
        -- turned a wide circle into a 50 m tall column, so a plaza-sized zone
        -- also blocked the car park under it and the freeway above it.
        if zone.z then return math.abs(z - zone.z) <= math.min(math.max(4.0, r), 8.0) end
    end
    return true
end

-- The static garages, or an empty set when Config.useConfigGarages is off.
-- Every lookup/iteration of the config garages goes through here so the toggle
-- can't be half-applied.
local EMPTY = {}
function Utils.ConfigGarages()
    if Config.useConfigGarages == false then return EMPTY end
    return Config.garages or EMPTY
end

function Utils.CategoryLabel(key)
    for _, c in ipairs(Config.categories or {}) do
        if c.key == key then return c.label end
    end
    return key
end

-- ---------------------------------------------------------------------------
-- OCCUPANTS — who would vanish with the car
-- ---------------------------------------------------------------------------

--[[ Is the occupant guard on for this action?

     One reader, so a config.lua carried over from an older build — where
     Config.occupantGuard does not exist at all, or exists without the
     per-action keys — still behaves like the documented default instead of
     silently switching the guard off. Absent means ON: the whole point of the
     setting is that a player is never deleted by surprise, and an update that
     quietly restored the old behaviour would be exactly that surprise. ]]
function Utils.GuardOn(action)
    local g = Config.occupantGuard
    if g == nil then return true end             -- pre-guard config.lua
    if g == false then return false end          -- Config.occupantGuard = false
    if type(g) ~= 'table' then return true end
    if g.enabled == false then return false end
    if action and g[action] == false then return false end
    return true
end

if not IsDuplicityVersion() then

    --[[ CLIENT: the PLAYER peds sitting in `vehicle`, `except` skipped.

         Seat-by-seat, which is exact: seat -1 is the driver and the passenger
         seats run 0 .. max-1. NPCs are deliberately filtered out — an NPC
         disappearing with the car costs nobody a scene, and a pedestrian who
         wandered into a seat would otherwise make the car unstorable. ]]
    function Utils.PlayersAboard(vehicle, except)
        local out = {}
        if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return out end
        local max = GetVehicleMaxNumberOfPassengers(vehicle) or 0
        for seat = -1, max - 1 do
            local ped = GetPedInVehicleSeat(vehicle, seat)
            if ped and ped ~= 0 and ped ~= except and DoesEntityExist(ped) and IsPedAPlayer(ped) then
                out[#out + 1] = ped
            end
        end
        return out
    end

else

    --[[ SERVER: the players sitting in any world copy of `plate`, by server id.

         Keyed by PLATE and not by entity because that is what the callers hold:
         the recovery branch is deciding whether to delete a car it has not
         located yet, and TowPlate works from a parked row. Walking the player
         list once and reading the plate off whatever each one is sitting in
         costs O(players), needs no GetAllVehicles (a later-build native this
         resource already guards for), and answers only about peds the server is
         authoritative for — which is exactly the set that matters.

         A native that is missing or throws yields an EMPTY list, i.e. "nobody
         aboard", which opens the gate. That is deliberate: a server that cannot
         answer the question must keep working as it did before the guard
         existed, rather than refuse every store and recovery forever. ]]
    function Utils.PlayersOnPlate(plate)
        plate = Utils.CleanPlate(plate)
        local out = {}
        if not plate or plate == '' then return out end
        local ok = pcall(function()
            for _, id in ipairs(GetPlayers()) do
                local src = tonumber(id)
                local ped = src and GetPlayerPed(src)
                if ped and ped ~= 0 then
                    local veh = GetVehiclePedIsIn(ped)
                    if veh and veh ~= 0 and DoesEntityExist(veh)
                        and Utils.CleanPlate(GetVehicleNumberPlateText(veh)) == plate then
                        out[#out + 1] = src
                    end
                end
            end
        end)
        if not ok then return {} end
        return out
    end

    -- SERVER: the players sitting in `entity`, by server id, `exceptSrc`
    -- skipped. Same rules and the same "cannot tell = nobody" stance as
    -- PlayersOnPlate above; used where the caller already holds the entity.
    function Utils.PlayersInEntity(entity, exceptSrc)
        local out = {}
        if not entity or entity == 0 then return out end
        local ok = pcall(function()
            if not DoesEntityExist(entity) then return end
            for _, id in ipairs(GetPlayers()) do
                local src = tonumber(id)
                if src and src ~= exceptSrc then
                    local ped = GetPlayerPed(src)
                    if ped and ped ~= 0 and GetVehiclePedIsIn(ped) == entity then
                        out[#out + 1] = src
                    end
                end
            end
        end)
        if not ok then return {} end
        return out
    end

    --[[ Every occupied plate in one pass, cached briefly.

         blockReason() runs once per row of a garage list, so asking
         PlayersOnPlate per row would walk the whole player list once per car.
         This decides only what a BUTTON SAYS, so an answer a second or so stale
         is harmless — the gates that actually delete something call
         PlayersOnPlate for a fresh one. ]]
    local snapshot, snapshotAt = nil, 0
    function Utils.OccupiedPlates()
        local now = GetGameTimer()
        if snapshot and (now - snapshotAt) < 1500 then return snapshot end
        local map = {}
        pcall(function()
            for _, id in ipairs(GetPlayers()) do
                local src = tonumber(id)
                local ped = src and GetPlayerPed(src)
                if ped and ped ~= 0 then
                    local veh = GetVehiclePedIsIn(ped)
                    if veh and veh ~= 0 and DoesEntityExist(veh) then
                        local p = Utils.CleanPlate(GetVehicleNumberPlateText(veh))
                        if p and p ~= '' then map[p] = (map[p] or 0) + 1 end
                    end
                end
            end
        end)
        snapshot, snapshotAt = map, now
        return map
    end

end

-- ---------------------------------------------------------------------------
-- i18n
-- ---------------------------------------------------------------------------
Locales = Locales or {}
Locales.dict = Locales.dict or {}

function Locales.t(key, ...)
    local lang = Locales.dict[Config.locale] or Locales.dict['en'] or {}
    local str  = lang[key] or (Locales.dict['en'] and Locales.dict['en'][key]) or key
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, str, ...)
        if ok then return formatted end
    end
    return str
end
