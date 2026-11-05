Supply = {}

local cfg = Config.Supply
local shipments = {} -- active shipments by id
local finished = {}  -- finished[gangId] = last few results for the tablet
local ACTIVE = { waiting = true, ready = true, in_transit = true }

local function v3(p) return vector3(p.x, p.y, p.z) end

local function setStatus(s, status, stolenBy)
    s.status = status
    MySQL.update('UPDATE vg_shipments SET status = ?, stolen_by = ? WHERE id = ?', { status, stolenBy, s.id })
    if not ACTIVE[status] then
        shipments[s.id] = nil
        if s.vehicle and DoesEntityExist(s.vehicle) then DeleteEntity(s.vehicle) end
        finished[s.gangId] = finished[s.gangId] or {}
        table.insert(finished[s.gangId], 1, { id = s.id, amount = s.amount, method = s.method, status = status, at = os.time() })
        while #finished[s.gangId] > 5 do table.remove(finished[s.gangId]) end
        local runner = s.runnerCid and Bridge.GetSourceFromCitizenId(s.runnerCid)
        if runner then TriggerClientEvent('vinewood_gangs:client:supplyEnd', runner, s.id, status) end
    end
end

local function supplyName(s)
    local e = Enterprises.Get(s.enterpriseId)
    return e and Config.Enterprises.types[e.type].supplies or 'supplies'
end

-------------------------------------------------------------------------------
-- Ordering
-------------------------------------------------------------------------------

function Supply.Order(src, enterpriseId, amount, method)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'enterprise_manage') then return false, 'no_permission' end
    local e = Enterprises.Get(enterpriseId)
    if not e or e.gangId ~= gang.id then return false, 'invalid' end
    if method ~= 'collect' and method ~= 'delivery' then return false, 'invalid' end
    if not Progression.Has(gang.id, 'enterprises') then return false, 'tier_locked' end
    local t = Config.Enterprises.types[e.type]

    local pending = 0
    for _, s in pairs(shipments) do if s.enterpriseId == e.id then pending = pending + s.amount end end
    amount = math.floor(tonumber(amount) or 0)
    local room = t.maxSupplies - math.floor(e.supplies) - pending
    if amount <= 0 then return false, 'invalid_amount' end
    if amount > room then return false, 'supply_no_room', room end

    local cost = math.floor(amount * t.supplyCost * (method == 'delivery' and cfg.deliveryMarkup or 1.0) * (1 - Relations.SupplyDiscount(gang.id)) * Director.Mult('supplyCost', e.type))
    local ok, res = Ledger.Transact(gang.id, 'dirty', -cost, 'supply_order', { citizenid = cid, refType = 'enterprise', refId = e.id, note = ('%d %s'):format(amount, t.supplies) })
    if not ok then return false, res end

    local now = os.time()
    local s = { gangId = gang.id, enterpriseId = e.id, amount = amount, cost = cost, method = method }
    if method == 'delivery' then
        s.status, s.dueAt = 'waiting', now + cfg.deliveryMinutes * 60
    else
        local pool = Config.Contracts.locations[cfg.pickups]
        s.pickup = pool[math.random(#pool)]
        s.status, s.dueAt = 'ready', now + cfg.collectWindow * 60
    end
    s.id = MySQL.insert.await('INSERT INTO vg_shipments (gang_id, enterprise_id, amount, cost, method, status, pickup, due_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        { s.gangId, s.enterpriseId, amount, cost, method, s.status, s.pickup and json.encode(s.pickup) or nil, s.dueAt })
    shipments[s.id] = s
    return true
end

-------------------------------------------------------------------------------
-- Collection runs
-------------------------------------------------------------------------------

local function onlineMembers(gangId)
    local out = {}
    for _, m in ipairs(Gangs.GetMembers(gangId)) do
        local src = m.online and Bridge.GetSourceFromCitizenId(m.citizenid)
        if src then out[#out + 1] = src end
    end
    return out
end

local function tipOffRivals(s)
    local zone = Zones.FromCoords(v3(s.pickup))
    local where = zone and Zones.Label(zone) or s.pickup.label
    for gangId in pairs(Gangs.All()) do
        if gangId ~= s.gangId and not Relations.IsProtected(gangId, s.gangId, zone) and math.random() < cfg.tipChance then
            local members = onlineMembers(gangId)
            for _, src in ipairs(members) do
                TriggerClientEvent('vinewood_gangs:client:supplyTip', src, s.netId, where, cfg.tipMinutes * 60)
            end
        end
    end
end

function Supply.StartRun(src, shipmentId)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    local s = shipments[tonumber(shipmentId)]
    if not s or s.gangId ~= gang.id then return false, 'invalid' end
    if s.status ~= 'ready' then return false, 'supply_not_ready' end
    for _, other in pairs(shipments) do
        if other.runnerCid == cid and other.status == 'in_transit' then return false, 'contract_active' end
    end

    local e = Enterprises.Get(s.enterpriseId)
    local h = e and Safehouses.Get(e.safehouseId)
    if not h then return false, 'invalid' end

    local p = s.pickup
    s.plate = ('SUP%05d'):format(s.id % 100000)
    local veh, netId = JobVehicles.Spawn(cfg.vans[math.random(#cfg.vans)], p, s.plate)
    if not veh then return false, 'failed' end
    s.vehicle, s.netId = veh, netId
    s.runnerCid, s.startedAt, s.deadline = cid, os.time(), os.time() + cfg.runMinutes * 60
    setStatus(s, 'in_transit')

    TriggerClientEvent('vinewood_gangs:client:supplyStart', src, {
        id = s.id, netId = s.netId, plate = s.plate, pickup = p, home = h.entrance,
        secondsLeft = cfg.runMinutes * 60,
    })
    tipOffRivals(s)
    return true
end

---Unload the van at a safehouse: your own enterprise's (delivery) or your gang's (stolen, fenced).
function Supply.Unload(src, shipmentId)
    local s = shipments[tonumber(shipmentId)]
    if not s or s.status ~= 'in_transit' or not DoesEntityExist(s.vehicle) then return false, 'tag_gone' end
    local ped = GetPlayerPed(src)
    if #(GetEntityCoords(ped) - GetEntityCoords(s.vehicle)) > 8.0 then return false, 'too_far' end

    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    local vpos = GetEntityCoords(s.vehicle)
    local elapsed = math.max(1, os.time() - s.startedAt)

    if gang.id == s.gangId then
        local e = Enterprises.Get(s.enterpriseId)
        local h = e and Safehouses.Get(e.safehouseId)
        if not h then return false, 'invalid' end
        if #(vpos - v3(h.entrance)) > 15.0 then return false, 'supply_wrong_place' end
        if #(v3(s.pickup) - v3(h.entrance)) / elapsed > Config.Contracts.maxSpeed then return false, 'too_fast' end
        local added = Enterprises.AddSupplies(e, s.amount)
        setStatus(s, 'delivered')
        Gangs.NotifyGang(gang.id, locale('supply_delivered', added, supplyName(s)), 'success')
        return true, 'delivered'
    end

    -- A rival drove it to one of their own safehouses
    if Relations.IsProtected(gang.id, s.gangId, Zones.FromCoords(vpos)) then return false, 'diplomacy_protected' end
    for _, h in ipairs(Safehouses.OwnedBy(gang.id)) do
        if #(vpos - v3(h.entrance)) <= 15.0 then
            if #(v3(s.pickup) - v3(h.entrance)) / elapsed > Config.Contracts.maxSpeed then return false, 'too_fast' end
            local e = Enterprises.Get(s.enterpriseId)
            local unit = e and Config.Enterprises.types[e.type].supplyCost or 50
            local value = math.floor(s.amount * unit * cfg.fenceShare)
            setStatus(s, 'stolen', gang.id)
            Ledger.Transact(gang.id, 'dirty', value, 'stolen_supplies', { citizenid = cid, refType = 'shipment', refId = s.id })
            Heat.Add(gang.id, cid, 4, Zones.FromCoords(vpos))
            Gangs.NotifyGang(s.gangId, locale('supply_stolen_from_you', gang.label), 'error')
            Gangs.NotifyGang(gang.id, locale('supply_fenced', Utils.FormatMoney(value)), 'success')
            Logger.Log(src, 'supply_hijacked', ('%s fenced shipment %d from gang %d'):format(cid, s.id, s.gangId))
            return true, 'fenced'
        end
    end
    return false, 'supply_wrong_place'
end

-------------------------------------------------------------------------------
-- Ticking: deliveries arrive (or get seized), runs time out, vans get lost
-------------------------------------------------------------------------------

local function tick()
    local now = os.time()
    for _, s in pairs(shipments) do
        local e = Enterprises.Get(s.enterpriseId)
        if not e then
            setStatus(s, 'lost')
        elseif s.status == 'waiting' and now >= s.dueAt then
            if math.random() < cfg.seizureChance then
                setStatus(s, 'seized')
                Gangs.NotifyGang(s.gangId, locale('supply_seized', supplyName(s)), 'error')
                local h = Safehouses.Get(e.safehouseId)
                Intel.CreateLead({
                    gangId = s.gangId, source = 'surveillance', precision = 'vague',
                    zone = h and Zones.FromCoords(v3(h.entrance)) or nil,
                    summary = ('Border Force intercepted a consignment of %s bound for an organised crime group.'):format(supplyName(s)),
                })
            else
                local added = Enterprises.AddSupplies(e, s.amount)
                setStatus(s, 'delivered')
                Gangs.NotifyGang(s.gangId, locale('supply_delivered', added, supplyName(s)), 'success')
            end
        elseif s.status == 'ready' and now >= s.dueAt then
            local refund = math.floor(s.cost * 0.5)
            setStatus(s, 'expired')
            Ledger.Transact(s.gangId, 'dirty', refund, 'supply_refund', { refType = 'shipment', refId = s.id })
            Gangs.NotifyGang(s.gangId, locale('supply_expired', Utils.FormatMoney(refund)), 'error')
        elseif s.status == 'in_transit' then
            if JobVehicles.Gone(s.vehicle) then
                setStatus(s, 'lost')
                Gangs.NotifyGang(s.gangId, locale('supply_lost', supplyName(s)), 'error')
            elseif now > s.deadline then
                setStatus(s, 'lost')
                Gangs.NotifyGang(s.gangId, locale('supply_late', supplyName(s)), 'error')
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Views and lifecycle
-------------------------------------------------------------------------------

---Vans currently on the road for a gang (for informant tips).
function Supply.ActiveRuns(gangId)
    local out = {}
    for _, s in pairs(shipments) do
        if s.gangId == gangId and s.status == 'in_transit' and s.vehicle and DoesEntityExist(s.vehicle) then
            out[#out + 1] = { id = s.id, coords = GetEntityCoords(s.vehicle), plate = s.plate }
        end
    end
    return out
end

---A free load waiting to be collected (auction prize). Fits what room the business has.
function Supply.CreateFree(gangId, enterpriseId, amount)
    local e = Enterprises.Get(enterpriseId)
    if not e or e.gangId ~= gangId then return false end
    local pool = Config.Contracts.locations[cfg.pickups]
    local s = { gangId = gangId, enterpriseId = e.id, amount = amount, cost = 0, method = 'collect',
        status = 'ready', pickup = pool[math.random(#pool)], dueAt = os.time() + cfg.collectWindow * 60 }
    s.id = MySQL.insert.await('INSERT INTO vg_shipments (gang_id, enterprise_id, amount, cost, method, status, pickup, due_at) VALUES (?, ?, ?, 0, ?, ?, ?, ?)',
        { gangId, e.id, amount, 'collect', 'ready', json.encode(s.pickup), s.dueAt })
    shipments[s.id] = s
    return true
end

function Supply.GangShipments(gangId)
    local now = os.time()
    local active = {}
    for _, s in pairs(shipments) do
        if s.gangId == gangId then
            active[#active + 1] = {
                id = s.id, amount = s.amount, method = s.method, status = s.status, supplies = supplyName(s),
                secondsLeft = math.max(0, (s.status == 'in_transit' and s.deadline or s.dueAt) - now),
                pickup = s.pickup and s.pickup.label or nil,
            }
        end
    end
    table.sort(active, function(a, b) return a.id < b.id end)
    return { active = active, recent = finished[gangId] or {} }
end

function Supply.Load()
    shipments = {}
    -- Vans don't survive a restart
    MySQL.update.await("UPDATE vg_shipments SET status = 'lost' WHERE status = 'in_transit'")
    for _, r in ipairs(MySQL.query.await("SELECT id, gang_id, enterprise_id, amount, cost, method, status, pickup, due_at FROM vg_shipments WHERE status IN ('waiting','ready')")) do
        local ok, pickup = pcall(json.decode, r.pickup or 'null')
        shipments[r.id] = { id = r.id, gangId = r.gang_id, enterpriseId = r.enterprise_id, amount = r.amount, cost = r.cost,
            method = r.method, status = r.status, pickup = ok and pickup or nil, dueAt = r.due_at }
    end
end

function Supply.Start()
    if not Config.Modules.supplyChains then return end
    CreateThread(function()
        while true do
            Wait(5000)
            tick()
        end
    end)
end

AddEventHandler('vinewood_gangs:server:enterpriseClosed', function(enterpriseId)
    for _, s in pairs(shipments) do
        if s.enterpriseId == enterpriseId then setStatus(s, 'lost') end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, s in pairs(shipments) do
        if s.vehicle and DoesEntityExist(s.vehicle) then DeleteEntity(s.vehicle) end
    end
end)
