-- =============================================
--  modules/cookfx | server.lua
--  KITCHEN FIRES. Food left burning on a station eventually sets the station
--  alight. While a station is on fire nobody can work it, and putting the fire out
--  destroys whatever was on it — so a burnt tray isn't free to ignore.
--
--  Server-authoritative, like every other cooking state: the fire keeps burning
--  while nobody is looking, survives players leaving, and every client renders the
--  same one (modules/cookfx/client.lua owns only the particles).
--
--  It POLLS `BurntCookingItems()` rather than hooking each burn transition: burnt
--  food arrives through several paths (the single-state timer, either grill face,
--  an item placed already-burnt) and leaves through even more (collected, binned,
--  the prop deleted, a restart). One periodic reconcile can't miss a path or leak
--  a timer the way a dozen call-site hooks would.
-- =============================================

local Fires      = {} -- [propId] = { rid = restaurantId, since = os.time() }
local BurntSince = {} -- [uid]    = os.time() this item was FIRST seen burnt

local function cfg()
    local c = GetSetting("kitchen_fires", {})
    return type(c) == "table" and c or {}
end

-- Is this station burning? Read by cooking's openStation gate.
function StationOnFire(propId)
    return Fires[tonumber(propId) or -1] ~= nil
end

local function fireList()
    local out = {}
    for propId, f in pairs(Fires) do
        out[#out + 1] = { prop_id = propId, rid = f.rid }
    end
    return out
end

-- The two tunables the CLIENT needs (how long fighting a fire takes, how close you
-- have to be) ride along with the list, so an admin's retune applies immediately
-- instead of the client holding a second, stale copy of the settings.
local function broadcastFires(target)
    local c = cfg()
    TriggerClientEvent("pickle_restaurants:cookfx:fires", target or -1, fireList(), {
        ms    = math.max(500, tonumber(c.extinguish_ms) or 5000),
        reach = math.max(1.0, tonumber(c.reach) or 4.0),
    })
end

local function ignite(propId, rid)
    if Fires[propId] then return end
    Fires[propId] = { rid = rid, since = os.time() }
    -- Whoever was working this station is thrown out of it client-side; the claim
    -- they were holding has to be released here or the station stays "busy" for
    -- everyone, forever — re-opening it is exactly what the fire forbids.
    if ReleaseStationClaim then ReleaseStationClaim(propId) end
    broadcastFires()
end

local function douse(propId)
    if not Fires[propId] then return false end
    Fires[propId] = nil
    broadcastFires()
    return true
end

-- ─── the reconcile ───────────────────────────────────────────────────────────
CreateThread(function()
    while true do
        Wait(5000)
        local c = cfg()
        if c.enabled == false then
            -- switched off mid-service: put out anything still burning rather than
            -- leaving an un-extinguishable fire painted on a station forever.
            if next(Fires) then Fires = {}; broadcastFires() end
            BurntSince = {}
            goto continue
        end

        local delay = math.max(5, tonumber(c.delay_seconds) or 90)
        local now   = os.time()
        local seen  = {}
        for _, b in ipairs(BurntCookingItems and BurntCookingItems() or {}) do
            seen[b.uid] = true
            BurntSince[b.uid] = BurntSince[b.uid] or now
            if not Fires[b.prop_id] and (now - BurntSince[b.uid]) >= delay then
                ignite(b.prop_id, b.rid)
            end
        end
        -- forget items that are no longer burnt/present, so taking the food off
        -- (or serving it) genuinely resets the clock rather than banking it
        for uid in pairs(BurntSince) do
            if not seen[uid] then BurntSince[uid] = nil end
        end
        ::continue::
    end
end)

-- ─── extinguishing ───────────────────────────────────────────────────────────
-- Anyone standing at the station may fight the fire — deliberately NOT gated on
-- `cook`: a burning kitchen is everyone's problem, and gating it would let one
-- absent employee strand a restaurant. What it IS gated on is being there, and
-- (when the server installs one) carrying an extinguisher.
lib.callback.register("pickle_restaurants:cookfx:extinguish", function(src, d)
    local propId = tonumber(d and d.prop_id)
    local prop   = propId and PropCache[propId]
    if not prop then return { ok = false } end
    if not Fires[propId] then return { ok = false, error = _L("fire_already_out") } end

    local c    = cfg()
    local ped  = GetPlayerPed(src)
    local pos  = ped ~= 0 and GetEntityCoords(ped) or nil
    local reach = math.max(1.0, tonumber(c.reach) or 4.0)
    if not pos or #(pos - vector3(prop.x, prop.y, prop.z)) > reach + 1.5 then
        return { ok = false, error = _L("fire_too_far") }
    end

    -- The extinguisher is EQUIPMENT: you have to be holding one, but it is never
    -- consumed. A server that never installed the item skips the requirement.
    local item = c.extinguisher_item
    if type(item) == "string" and item ~= "" and ItemExists(item) then
        if (Inventory.GetItemCount(src, item) or 0) < 1 then
            return { ok = false, error = _L("fire_need_extinguisher", GetItemLabel(item)) }
        end
    end

    douse(propId)
    -- Everything the station was holding is ruined — including whatever burnt badly
    -- enough to start this.
    local lost = DestroyStationCookingItems and DestroyStationCookingItems(propId) or 0
    ShowNotification(src, lost > 0 and _L("fire_out_ruined", lost) or _L("fire_out"))
    return { ok = true, ruined = lost }
end)

-- A removed station takes its fire with it.
AddEventHandler("pickle_restaurants:propDeleted", function(propId)
    douse(tonumber(propId))
end)

-- A (re)syncing client needs the current fires, exactly like the cooking bulk push.
RegisterNetEvent("pickle_restaurants:requestSync", function()
    broadcastFires(source)
end)
