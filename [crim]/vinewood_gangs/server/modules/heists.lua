-- Heists: built in game by staff (/gangadmin > Heists), run by gangs step by step.
Heists = {}

local cfg = Config.Heists
local heists = {}      -- heists[id] = { id, label, kind, enabled, nextAt, data = { police, crew, cooldown, timeLimit, tier, start, steps } }
local runs = {}        -- runs[runId] = active run
local byHeist = {}     -- byHeist[heistId] = runId while running
local byGang = {}      -- byGang[crew] = runId while running (crew = a gang id, or 'solo:<citizenid>' for players with no gang)
local gangNext = {}    -- gangNext[gangId] = os.time() the gang can start another

local LOOT_STEPS = { loot = true }
local GAMES = { hack = 'hack', thermite = 'thermite', drill = 'drill', truck_doors = 'thermite' }

local function now() return os.time() end

-------------------------------------------------------------------------------
-- Heist loot tables: named tables shared by every heist; a loot step can draw from one
-------------------------------------------------------------------------------

local lootTables, nextLootTableId = {}, 1

local function lootTableById(id)
    id = tonumber(id)
    for _, t in ipairs(lootTables) do if t.id == id then return t end end
end

---Draws a table's picks: { money = { dirty = n, clean = n }, items = { [item] = count } }.
local function rollLootTable(t)
    local total = 0
    for _, e in ipairs(t.loot) do total = total + (e.chance or 1) end
    local out = { money = {}, items = {} }
    for _ = 1, (t.rolls or 1) do
        local r, acc = math.random() * total, 0
        for _, e in ipairs(t.loot) do
            acc = acc + (e.chance or 1)
            if r <= acc then
                local n = math.random(math.floor(e.min or 1), math.floor(math.max(e.min or 1, e.max or e.min or 1)))
                if e.money then
                    local acct = e.account == 'clean' and 'clean' or 'dirty'
                    out.money[acct] = (out.money[acct] or 0) + n
                else
                    out.items[e.item] = (out.items[e.item] or 0) + n
                end
                break
            end
        end
    end
    return out
end

function Heists.LoadLootTables()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'heist_loot_tables'")
    local ok, data = pcall(json.decode, raw or '')
    if ok and type(data) == 'table' then lootTables, nextLootTableId = data.tables or {}, data.nextId or 1 end
end

function Heists.AdminLootTables()
    local out = {}
    for _, t in ipairs(lootTables) do
        local list = {}
        for i, e in ipairs(t.loot) do
            list[i] = { money = e.money == true, account = e.account, item = e.item, label = e.item and Bridge.ItemLabel(e.item) or nil, min = e.min, max = e.max, chance = e.chance }
        end
        out[#out + 1] = { id = t.id, name = t.name, rolls = t.rolls, loot = list }
    end
    return out
end

---Saves every heist loot table at once: { { id?, name, rolls, loot = { { money = true, account, min, max, chance } | { item, min, max, chance } } } }.
function Heists.AdminSaveLootTables(src, input)
    if type(input) ~= 'table' or #input > 30 then return false, 'invalid' end
    local tables, used = {}, {}
    for _, t in ipairs(input) do
        if type(t) ~= 'table' or type(t.loot) ~= 'table' or #t.loot == 0 or #t.loot > 40 then return false, 'airdrop_need_loot' end
        local list = {}
        for _, e in ipairs(t.loot) do
            local lo = math.floor(math.max(1, math.min(10000000, tonumber(e.min) or 1)))
            local hi = math.floor(math.max(lo, math.min(10000000, tonumber(e.max) or lo)))
            local chance = math.floor(math.max(1, math.min(1000, tonumber(e.chance) or 10)))
            if e.money then
                list[#list + 1] = { money = true, account = e.account == 'clean' and 'clean' or 'dirty', min = lo, max = hi, chance = chance }
            else
                if type(e.item) ~= 'string' or not Bridge.ItemExists(e.item) then return false, 'item_not_found' end
                list[#list + 1] = { item = e.item, min = lo, max = math.min(hi, 500), chance = chance }
            end
        end
        local name = tostring(t.name or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 32)
        local id = tonumber(t.id)
        if not id or used[id] then id = nextLootTableId nextLootTableId = nextLootTableId + 1 end
        used[id] = true
        if id >= nextLootTableId then nextLootTableId = id + 1 end
        tables[#tables + 1] = { id = id, name = #name > 0 and name or ('Loot table ' .. id), rolls = math.floor(math.max(1, math.min(20, tonumber(t.rolls) or 1))), loot = list }
    end
    lootTables = tables
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('heist_loot_tables', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode({ tables = lootTables, nextId = nextLootTableId }), Bridge.GetCitizenId(src) or 'console' })
    Logger.Log(src, 'staff_heist_loot', ('saved %d heist loot tables'):format(#tables))
    return true, Heists.AdminLootTables()
end

---Loot in its current form: { kind = 'money', account, min, max }, { kind = 'item', item, label, min, max }
---or { kind = 'table', table = id } (a heist loot table).
local function normaliseLoot(l)
    if type(l) ~= 'table' then return nil end
    if l.kind == 'money' or l.kind == 'item' or l.kind == 'table' then return l end
    local def = l.type and cfg.lootTypes[l.type]
    if not def then return nil end
    if def.kind == 'money' then return { kind = 'money', account = def.account or 'dirty', min = l.min, max = l.max } end
    return { kind = 'item', item = def.item, label = def.label, min = l.min, max = l.max }
end
local function dist(a, b) return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2 + (a.z - b.z) ^ 2) end
local function pedPos(src) local c = GetEntityCoords(GetPlayerPed(src)) return { x = c.x, y = c.y, z = c.z } end

-------------------------------------------------------------------------------
-- Storage
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Crews: a gang, or (for heists open to anyone) players with no gang who started it together
-------------------------------------------------------------------------------

local function isGangCrew(key) return type(key) == 'number' end

---Everyone in the run's crew who's online: { source, citizenid }.
local function crewMembers(run)
    if isGangCrew(run.gangId) then return Gangs.OnlineMembers(run.gangId) end
    local out = {}
    for src, cid in pairs(run.crew or {}) do
        if Bridge.GetCitizenId(src) == cid then out[#out + 1] = { source = src, citizenid = cid } end
    end
    return out
end

local function crewNotify(run, message, kind)
    if isGangCrew(run.gangId) then return Gangs.NotifyGang(run.gangId, message, kind) end
    for _, m in ipairs(crewMembers(run)) do Bridge.Notify(m.source, message, kind) end
end

---Is this player part of this run's crew?
local function inRun(src, run)
    if not run then return false end
    if isGangCrew(run.gangId) then
        local g = Gangs.GetPlayerGang(src)
        return g ~= nil and g.id == run.gangId
    end
    return run.crew ~= nil and run.crew[src] ~= nil and run.crew[src] == Bridge.GetCitizenId(src)
end

---The run this player is part of, if any.
local function runOf(src)
    local g = Gangs.GetPlayerGang(src)
    if g then return byGang[g.id] and runs[byGang[g.id]] end
    for _, r in pairs(runs) do if not isGangCrew(r.gangId) and inRun(src, r) then return r end end
end

-------------------------------------------------------------------------------
-- Heist doors: locked while the heist is enabled; a step opens the doors it's linked to; they lock again after
-------------------------------------------------------------------------------

local openDoors = {} -- openDoors[heistId][doorIndex] = true while open

local function publishDoors()
    local list = {}
    for _, h in pairs(heists) do
        if h.enabled then
            for i, d in ipairs(h.data.doors or {}) do
                list[#list + 1] = { h = h.id, i = i, model = d.model, x = d.x, y = d.y, z = d.z,
                    locked = not (openDoors[h.id] and openDoors[h.id][i]) }
            end
        end
    end
    GlobalState.vg_heist_doors = list
end

---A step's done: open the doors it's linked to.
local function openStepDoors(run, i)
    local s = run.heist.data.steps[i]
    if not s or type(s.opens) ~= 'table' or #s.opens == 0 then return end
    openDoors[run.heist.id] = openDoors[run.heist.id] or {}
    for _, d in ipairs(s.opens) do openDoors[run.heist.id][d] = true end
    publishDoors()
end

local function publish()
    local starts = {}
    for _, h in pairs(heists) do
        if h.enabled and h.data.start then
            local npc = (h.data.startMode == 'npc' or h.data.startMode == 'both') and h.data.startNpc or nil
            starts[#starts + 1] = { id = h.id, label = h.label, x = h.data.start.x, y = h.data.start.y, z = h.data.start.z, w = h.data.start.w,
                npc = npc and { ped = npc.ped, name = npc.name } or nil, anyone = h.data.openTo == 'anyone' or nil }
        end
    end
    GlobalState.vg_heist_starts = starts
    publishDoors()
end

local function saveHeist(h)
    MySQL.update.await('UPDATE vg_heists SET label = ?, kind = ?, enabled = ?, data = ?, next_at = ? WHERE id = ?',
        { h.label, h.kind, h.enabled and 1 or 0, json.encode(h.data), h.nextAt or 0, h.id })
end

function Heists.Get(id) return heists[tonumber(id)] end

-------------------------------------------------------------------------------
-- Heist laptops: staff place them around the map; anyone can use one to see the heist board
-------------------------------------------------------------------------------

local laptops, nextLaptopId = {}, 1

local function publishLaptops() GlobalState.vg_heist_laptops = laptops end

local function saveLaptops(src)
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('heist_laptops', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode({ nextId = nextLaptopId, list = laptops }), src and Bridge.GetCitizenId(src) or 'server' })
    publishLaptops()
end

function Heists.LoadLaptops()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'heist_laptops'")
    local ok, data = pcall(json.decode, raw or '')
    if ok and type(data) == 'table' then laptops, nextLaptopId = data.list or {}, data.nextId or 1 end
    publishLaptops()
end

function Heists.AdminLaptops() return laptops end

function Heists.AdminAddLaptop(src, p, label)
    if type(p) ~= 'table' then return false, 'invalid' end
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    if not x or not y or not z or #laptops >= 50 then return false, 'invalid' end
    label = tostring(label or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 32)
    laptops[#laptops + 1] = { id = nextLaptopId, x = x, y = y, z = z, w = tonumber(p.w) or 0.0, label = #label > 0 and label or ('Laptop ' .. nextLaptopId),
        model = cfg.laptopModel or 'prop_laptop_01a' }
    nextLaptopId = nextLaptopId + 1
    saveLaptops(src)
    Logger.Log(src, 'staff_heist_laptop', ('placed heist laptop at %.0f, %.0f'):format(x, y))
    return true
end

function Heists.AdminRemoveLaptop(src, id)
    id = tonumber(id)
    for i, l in ipairs(laptops) do
        if l.id == id then table.remove(laptops, i) saveLaptops(src) return true end
    end
    return false, 'invalid'
end

---Using a laptop: you have to be at one.
function Heists.LaptopBoard(src, id)
    local l
    for _, x in ipairs(laptops) do if x.id == tonumber(id) then l = x end end
    if not l or dist(pedPos(src), l) > 3.0 then return nil, 'too_far' end
    return Heists.Board(src)
end

function Heists.Load()
    heists = {}
    for _, r in ipairs(MySQL.query.await('SELECT id, label, kind, enabled, data, next_at FROM vg_heists')) do
        local ok, data = pcall(json.decode, r.data)
        if ok and type(data) == 'table' then
            data.steps = data.steps or {}
            for _, st in ipairs(data.steps) do if st.loot then st.loot = normaliseLoot(st.loot) end end
            heists[r.id] = { id = r.id, label = r.label, kind = r.kind, enabled = r.enabled == 1 or r.enabled == true, nextAt = r.next_at or 0, data = data }
        end
    end
    -- Anything left "running" by a crash or restart is over
    MySQL.update("UPDATE vg_heist_runs SET status = 'cancelled', ended_at = ? WHERE status = 'running'", { now() })
    publish()
end

-------------------------------------------------------------------------------
-- What's available, and why not
-------------------------------------------------------------------------------

local function policeOnDuty()
    local n = Bridge.Dispatch.OnDuty('police')
    return n -- nil when no dispatch resource reports it
end

---Players with no gang near the start who aren't already on a job (the crew for a heist open to anyone).
local function soloCrewAt(h)
    local out = {}
    for _, id in ipairs(GetPlayers()) do
        local s = tonumber(id)
        if not Gangs.GetPlayerGang(s) and not runOf(s) and dist(pedPos(s), h.data.start) <= cfg.crewRadius then
            local cid = Bridge.GetCitizenId(s)
            if cid then out[s] = cid end
        end
    end
    return out
end

---Why this crew can't start this heist (nil if it can). A gang, or a player with no gang (gang = nil) on a heist
---open to anyone. Counts nearby crew when src is given.
local function startBlocker(h, gang, cid, src)
    if not cfg.enabled or not h.enabled then return 'heist_unavailable' end
    local key
    if gang then
        if not Progression.Has(gang.id, 'heists') then return 'tier_locked' end
        if h.data.tier and Progression.Tier(gang.id) < h.data.tier then return 'tier_locked' end
        if not Gangs.HasPermission(cid, 'heists') then return 'no_permission' end
        key = gang.id
    else
        if h.data.openTo ~= 'anyone' then return 'heist_gangs_only' end
        if src and runOf(src) then return 'heist_already_running' end
        key = 'solo:' .. tostring(cid)
    end
    if byHeist[h.id] then return 'heist_in_progress' end
    if byGang[key] then return 'heist_already_running' end
    if (h.nextAt or 0) > now() then return 'heist_cooldown' end
    if (gangNext[key] or 0) > now() then return 'heist_gang_cooldown' end
    local police = policeOnDuty()
    if police and police < (h.data.police or 0) then return 'heist_not_enough_police' end
    if src then
        if not h.data.start or dist(pedPos(src), h.data.start) > 4.0 then return 'too_far' end
        local crew = 0
        if gang then
            for _, m in ipairs(Gangs.OnlineMembers(gang.id)) do
                if dist(pedPos(m.source), h.data.start) <= cfg.crewRadius then crew = crew + 1 end
            end
        else
            for _ in pairs(soloCrewAt(h)) do crew = crew + 1 end
        end
        if crew < (h.data.crew or 1) then return 'heist_need_crew' end
    end
    return nil
end

---For the tablet's Heists app.
---What a heist needs and involves, for the tablet's heist board and the laptops.
local function requirements(h)
    local d = h.data
    local items, seenItem, steps, loot = {}, {}, {}, {}
    for _, s in ipairs(d.steps or {}) do
        local tool = (s.item and s.item ~= '') and s.item or (cfg.tools[s.type] and cfg.tools[s.type].item) or nil
        if tool and not seenItem[tool] then
            seenItem[tool] = true
            items[#items + 1] = { item = tool, label = Bridge.ItemLabel(tool) }
        end
        steps[#steps + 1] = (cfg.stepTypes[s.type] and cfg.stepTypes[s.type].label or s.type)
        if s.type == 'loot' and s.loot then
            if s.loot.kind == 'money' then loot.money = (loot.money or 0) + (s.loot.max or s.loot.min or 0)
            elseif s.loot.kind == 'table' then
                -- From a loot table: the most money a grab could give, and the items it can give
                local t = lootTableById(s.loot.table)
                if t then
                    local maxMoney = 0
                    for _, e in ipairs(t.loot) do
                        if e.money then maxMoney = math.max(maxMoney, e.max or 0)
                        elseif e.item then loot.items = loot.items or {} loot.items[Bridge.ItemLabel(e.item)] = true end
                    end
                    if maxMoney > 0 then loot.money = (loot.money or 0) + maxMoney * (t.rolls or 1) end
                end
            elseif s.loot.item then loot.items = loot.items or {} loot.items[Bridge.ItemLabel(s.loot.item)] = true end
        end
    end
    local lootItems = {}
    for name in pairs(loot.items or {}) do lootItems[#lootItems + 1] = name end
    table.sort(lootItems)
    local tierLabel = d.tier and Config.Progression.tiers[d.tier] and Config.Progression.tiers[d.tier].label or nil
    return {
        crew = d.crew or 1, police = d.police or 0, tier = tierLabel, timeLimit = d.timeLimit or 15, cooldown = d.cooldown,
        openTo = d.openTo or 'gangs', startMode = d.startMode or 'tablet', contact = d.startNpc and d.startNpc.name or nil,
        items = items, steps = steps, lootMoney = loot.money, lootItems = lootItems,
        payments = (function() local n = 0 for _, s in ipairs(d.steps or {}) do if s.type == 'talk' then n = n + (s.pay or 0) end end return n end)(),
    }
end
Heists.Requirements = requirements

---The heist board on a laptop (anyone): every heist and whether this player could start it right now.
function Heists.Board(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    cid = cid or Bridge.GetCitizenId(src)
    local list = {}
    for _, h in pairs(heists) do
        if h.enabled and h.data.start then
            local why = startBlocker(h, gang, cid, nil)
            local zone = Zones.FromCoords(vector3(h.data.start.x, h.data.start.y, h.data.start.z))
            list[#list + 1] = { id = h.id, label = h.label, area = zone and Zones.Label(zone) or nil, x = h.data.start.x, y = h.data.start.y,
                blocked = why, readyIn = why == 'heist_cooldown' and (h.nextAt - now()) or nil, req = requirements(h) }
        end
    end
    table.sort(list, function(a, b)
        -- What they can do first, then by name
        if (a.blocked == nil) ~= (b.blocked == nil) then return a.blocked == nil end
        return a.label < b.label
    end)
    return { heists = list, inGang = gang ~= nil }
end

function Heists.View(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local list = {}
    for _, h in pairs(heists) do
        if h.enabled and h.data.start then
            local why = startBlocker(h, gang, cid, nil)
            local zone = Zones.FromCoords(vector3(h.data.start.x, h.data.start.y, h.data.start.z))
            list[#list + 1] = {
                startMode = h.data.startMode or 'tablet', contact = h.data.startNpc and h.data.startNpc.name or nil,
                id = h.id, label = h.label, kind = h.kind, area = zone and Zones.Label(zone) or nil,
                crew = h.data.crew or 1, steps = #h.data.steps, cooldownMins = h.data.cooldown,
                blocked = why, readyIn = why == 'heist_cooldown' and (h.nextAt - now()) or (why == 'heist_gang_cooldown' and (gangNext[gang.id] - now()) or nil),
                x = h.data.start.x, y = h.data.start.y, req = requirements(h),
            }
        end
    end
    table.sort(list, function(a, b) return a.label < b.label end)
    local run = byGang[gang.id] and runs[byGang[gang.id]]
    return { heists = list, active = run and Heists.RunView(run) or nil, canStart = Gangs.HasPermission(cid, 'heists') }
end

-------------------------------------------------------------------------------
-- Runs
-------------------------------------------------------------------------------

---Steps that can be worked on right now: the first unfinished one, plus any loot steps straight after it.
local function availableSteps(run)
    local steps, out = run.heist.data.steps, {}
    for i, s in ipairs(steps) do
        if not run.done[i] then
            out[#out + 1] = i
            if LOOT_STEPS[s.type] then
                for j = i + 1, #steps do
                    if run.done[j] then goto continue end
                    if not LOOT_STEPS[steps[j].type] then break end
                    out[#out + 1] = j
                    ::continue::
                end
            end
            return out
        end
    end
    return out
end

---Where a step is right now (truck doors follow the truck).
local function stepPos(run, i)
    local s = run.heist.data.steps[i]
    if (s.type == 'truck_doors' or (s.type == 'loot' and run.truck)) and run.truck and DoesEntityExist(run.truck) then
        local c, hdg = GetEntityCoords(run.truck), math.rad(GetEntityHeading(run.truck))
        -- behind the truck
        return { x = c.x + math.sin(hdg) * 4.2, y = c.y - math.cos(hdg) * 4.2, z = c.z, w = GetEntityHeading(run.truck) }
    end
    return s.x and { x = s.x, y = s.y, z = s.z, w = s.w or 0.0 } or nil
end

function Heists.RunView(run)
    local avail, steps = {}, {}
    for _, i in ipairs(availableSteps(run)) do avail[i] = true end
    for i, s in ipairs(run.heist.data.steps) do
        local p = stepPos(run, i)
        steps[i] = { i = i, type = s.type, label = s.label, done = run.done[i] == true, available = avail[i] == true,
            busy = run.locks[i] ~= nil, x = p and p.x, y = p and p.y, z = p and p.z, w = p and p.w,
            ped = s.ped, time = s.type == 'hostage' and s.time or nil, pay = s.pay,
            guards = run.guards and run.guards[i] or nil, guardsUp = run.guards and run.guards[i] ~= nil or nil }
    end
    local start = run.heist.data.start
    return {
        id = run.id, heistId = run.heist.id, label = run.heist.label, steps = steps,
        escape = run.escaping and { x = start.x, y = start.y, z = start.z, r = cfg.escapeRadius } or nil,
        endsAt = run.endsAt - now(), alarm = run.alarm, loot = run.loot,
        truckNet = run.truck and DoesEntityExist(run.truck) and NetworkGetNetworkIdFromEntity(run.truck) or nil,
    }
end

local function pushRun(run)
    local view = Heists.RunView(run)
    for _, m in ipairs(crewMembers(run)) do
        TriggerClientEvent('vinewood_gangs:client:heistUpdate', m.source, view)
    end
end

local function alarm(run, level, pos)
    if run.alarm == 'loud' or (run.alarm == 'silent' and level == 'silent') then return end
    run.alarm = level
    local where = pos or run.heist.data.start
    local data = { title = ('%s in progress'):format(run.heist.label), code = '10-90', priority = 1,
        coords = vector3(where.x, where.y, where.z),
        description = level == 'loud' and 'Alarm activated. Armed robbery in progress.' or 'Silent alarm triggered.' }
    if level == 'silent' then
        SetTimeout(cfg.silentDelay * 1000, function() if runs[run.id] then Bridge.Dispatch.Alert(data) end end)
    else
        Bridge.Dispatch.Alert(data)
    end
end

local function removeGuards(run)
    for _, nets in pairs(run.guards or {}) do
        for _, net in ipairs(nets) do
            local ped = NetworkGetEntityFromNetworkId(net)
            if ped ~= 0 and DoesEntityExist(ped) then DeleteEntity(ped) end
        end
    end
end

local function endRun(run, status, reason)
    runs[run.id], byHeist[run.heist.id], byGang[run.gangId] = nil, nil, nil
    -- Doors lock again once the crew's had a chance to get out
    if openDoors[run.heist.id] then
        local hid = run.heist.id
        SetTimeout((cfg.doorRelockSeconds or 60) * 1000, function()
            if not byHeist[hid] then openDoors[hid] = nil publishDoors() end
        end)
    end
    if run.guards then SetTimeout(30000, function() removeGuards(run) end) end
    if run.truck and DoesEntityExist(run.truck) then
        local truck = run.truck
        SetTimeout(60000, function() if DoesEntityExist(truck) then DeleteEntity(truck) end end) -- let the crew get clear first
    end
    -- Cooldowns: full after success, half after a failure
    local mins = run.heist.data.cooldown or 60
    run.heist.nextAt = now() + math.floor((status == 'done' and mins or mins / 2) * 60)
    gangNext[run.gangId] = now() + cfg.gangCooldown * 60
    saveHeist(run.heist)
    MySQL.update('UPDATE vg_heist_runs SET status = ?, loot = ?, ended_at = ? WHERE id = ?', { status, run.loot, now(), run.id })

    local start = run.heist.data.start
    local zone = Zones.FromCoords(vector3(start.x, start.y, start.z))
    local gangCrew = isGangCrew(run.gangId)
    if status == 'done' then
        -- Reputation, influence and police intel are about gangs; a crew with no gang just gets the loot
        if gangCrew then
            Activity.Record({ type = 'heist_complete', gangId = run.gangId, zone = zone, coords = vector3(start.x, start.y, start.z),
                metadata = { heist = run.heist.label, loot = run.loot } })
            Intel.CreateLead({ gangId = run.gangId, source = 'surveillance', precision = 'area', zone = zone, force = true,
                summary = ('A crew carried out the %s. Witnesses describe several suspects.'):format(run.heist.label) })
        end
        crewNotify(run, locale('heist_done', run.heist.label), 'success')
    else
        if status == 'failed' and gangCrew then
            Activity.Record({ type = 'heist_failed', gangId = run.gangId, zone = zone, coords = vector3(start.x, start.y, start.z) })
        end
        crewNotify(run, locale(reason or 'heist_failed', run.heist.label), 'error')
    end
    for _, m in ipairs(crewMembers(run)) do
        TriggerClientEvent('vinewood_gangs:client:heistUpdate', m.source, nil)
    end
    Logger.Log(nil, 'heist_' .. status, ('%s %s "%s" (loot %d)'):format(gangCrew and ('gang ' .. run.gangId) or 'crew with no gang', status, run.heist.label, run.loot))
end

local function spawnTruck(run, i)
    local s = run.heist.data.steps[i]
    local veh, netId = JobVehicles.Spawn(cfg.truck.model, { x = s.x, y = s.y, z = s.z, w = s.w or 0.0 }, ('ARM%05d'):format(run.id % 100000))
    if not veh then return false end
    run.truck = veh
    -- The starter's game creates the guards and drives it (server-created peds can't drive on their own)
    TriggerClientEvent('vinewood_gangs:client:heistTruck', run.starterSrc, netId, cfg.truck)
    return true
end

function Heists.Start(src, heistId, fromNpc)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    cid = cid or Bridge.GetCitizenId(src)
    if not cid then return false, 'invalid' end
    local h = heists[tonumber(heistId)]
    if not h then return false, 'heist_unavailable' end
    local mode = h.data.startMode or 'tablet'
    if mode == 'npc' and not fromNpc then return false, 'heist_talk_to_contact', (h.data.startNpc and h.data.startNpc.name or '?') end
    if mode == 'tablet' and fromNpc then return false, 'heist_unavailable' end
    local why = startBlocker(h, gang, cid, src)
    if why then return false, why end
    local truckJob = h.data.steps[1] and h.data.steps[1].type == 'truck'
    for _, s in ipairs(h.data.steps) do
        -- Steps after a truck stop happen at the truck, wherever it ends up
        local followsTruck = s.type == 'truck_doors' or (truckJob and s.type == 'loot')
        if not s.x and not followsTruck then return false, 'heist_not_set_up' end
    end

    local t = now()
    local key = gang and gang.id or ('solo:' .. cid)
    local id = MySQL.insert.await('INSERT INTO vg_heist_runs (heist_id, gang_id, started_by, started_at) VALUES (?, ?, ?, ?)', { h.id, gang and gang.id or 0, cid, t })
    if not id then return false, 'db_error' end
    local run = { id = id, heist = h, gangId = key, starterSrc = src, done = {}, locks = {}, failedAt = {},
        startedAt = t, endsAt = t + (h.data.timeLimit or 15) * 60, alarm = nil, loot = 0 }
    -- No gang: the crew is the players with no gang who were at the start with them
    if not gang then
        run.crew = soloCrewAt(h)
        run.crew[src] = cid
    end
    runs[id], byHeist[h.id], byGang[key] = run, id, id
    run.crewSeen = {}
    for _, m in ipairs(crewMembers(run)) do
        if dist(pedPos(m.source), h.data.start) <= cfg.crewRadius then run.crewSeen[m.citizenid] = true end
    end

    -- A truck job starts with the truck rolling
    local first = h.data.steps[1]
    if first and first.type == 'truck' then
        if not spawnTruck(run, 1) then endRun(run, 'cancelled', 'heist_failed_setup') return false, 'failed' end
    end
    if first and first.alert and first.alert ~= 'none' and first.type == 'truck' then alarm(run, first.alert, first) end

    crewNotify(run, locale('heist_started', h.label), 'inform')
    pushRun(run)
    Logger.Log(src, 'heist_started', ('%s started "%s" for %s'):format(cid, h.label, gang and ('gang ' .. gang.id) or 'a crew with no gang'))
    return true
end

---A crew member starts on a step: checks and locks it, and says which minigame to play.
function Heists.BeginStep(src, runId, i)
    local cid = Bridge.GetCitizenId(src)
    local run = runs[tonumber(runId)]
    i = tonumber(i)
    if not inRun(src, run) then return false, 'heist_not_yours' end
    local s = run.heist.data.steps[i]
    if not s or run.done[i] then return false, 'invalid' end
    local ok = false
    for _, a in ipairs(availableSteps(run)) do if a == i then ok = true end end
    if not ok then return false, 'heist_not_yet' end
    if s.type == 'truck' then return false, 'heist_stop_truck' end
    if s.type == 'guards' then return false, 'heist_take_out_guards' end
    if s.type == 'talk' and (s.pay or 0) > 0 and (isGangCrew(run.gangId) and Ledger.GetBalance(run.gangId, 'dirty') or (Bridge.GetMoney(src, 'cash') or 0)) < s.pay then
        return false, 'heist_cant_pay', Utils.FormatMoney(s.pay)
    end
    if run.locks[i] and run.locks[i].src ~= src then return false, 'heist_step_busy' end
    if run.failedAt[i] and now() - run.failedAt[i] < cfg.retryDelay then return false, 'heist_retry_wait' end
    local p = stepPos(run, i)
    local reach = s.type == 'hostage' and cfg.npc.aimDistance or (cfg.stepRadius + 1.5)
    if not p or dist(pedPos(src), p) > reach then return false, 'too_far' end
    local tool = (s.item and s.item ~= '') and { item = s.item, consume = s.consume } or cfg.tools[s.type]
    if tool and tool.item and not Bridge.HasItem(src, tool.item, 1) then return false, 'heist_need_item', s.itemLabel or Bridge.ItemLabel(tool.item) end

    run.locks[i] = { src = src, at = GetGameTimer() }
    run.crewSeen[cid] = true
    pushRun(run)
    local def = cfg.minigames[GAMES[s.type] or ''] or {}
    return true, {
        game = GAMES[s.type], difficulty = s.difficulty or 2, time = s.time or def.time or 30,
        duration = (s.type == 'loot' or s.type == 'wait') and (s.time or 10)
            or (s.type == 'talk' and cfg.npc.talkTime) or (s.type == 'hostage' and s.time) or nil, type = s.type,
    }
end

local function payMoney(run, src, account, amount)
    if isGangCrew(run.gangId) then
        Ledger.Transact(run.gangId, account or 'dirty', amount, 'heist', { note = run.heist.label })
    elseif (account or 'dirty') == 'dirty' then
        Bridge.AddDirtyMoney(src, amount, 'heist')
    else
        Bridge.AddMoney(src, 'cash', amount, 'heist')
    end
    run.loot = run.loot + amount
end

local function payLoot(run, src, s)
    local l = normaliseLoot(s.loot)
    if not l then return nil end
    if l.kind == 'table' then
        local t = lootTableById(l.table)
        if not t then return nil end
        local got = rollLootTable(t)
        local list, money = {}, 0
        for item, n in pairs(got.items) do
            if Bridge.AddItem(src, item, n) then list[#list + 1] = ('%d x %s'):format(n, Bridge.ItemLabel(item)) end
        end
        table.sort(list)
        for acct, n in pairs(got.money) do payMoney(run, src, acct, n) money = money + n end
        if money > 0 then list[#list + 1] = Utils.FormatMoney(money) end
        return { list = list, money = money > 0 and money or nil }
    end
    local amount = math.random(math.floor(l.min or 1), math.floor(math.max(l.min or 1, l.max or l.min or 1)))
    if l.kind == 'money' then
        if isGangCrew(run.gangId) then
            Ledger.Transact(run.gangId, l.account or 'dirty', amount, 'heist', { note = run.heist.label })
        elseif (l.account or 'dirty') == 'dirty' then
            -- A crew with no gang has no treasury: whoever grabs it pockets it
            Bridge.AddDirtyMoney(src, amount, 'heist')
        else
            Bridge.AddMoney(src, 'cash', amount, 'heist')
        end
        run.loot = run.loot + amount
        return { money = amount }
    end
    if Bridge.AddItem(src, l.item, amount) then return { item = l.label or Bridge.ItemLabel(l.item), count = amount } end
    return nil
end

---The step's minigame or timer has finished.
function Heists.FinishStep(src, runId, i, success)
    local cid = Bridge.GetCitizenId(src)
    local run = runs[tonumber(runId)]
    i = tonumber(i)
    if not inRun(src, run) then return false, 'heist_not_yours' end
    local lock = run.locks[i]
    if not lock or lock.src ~= src then return false, 'invalid' end
    run.locks[i] = nil
    local s = run.heist.data.steps[i]

    -- A hostage who gets killed: the step's done (nobody's left to stop you), but the loud alarm goes off
    local killed = s.type == 'hostage' and success == 'killed'
    if killed then success = true end
    success = success == true

    -- Can't finish faster than the step allows (loot, waits and NPC steps are timed; minigames take a few seconds)
    local elapsed = (GetGameTimer() - lock.at) / 1000
    local minimum = (s.type == 'loot' or s.type == 'wait') and (s.time or 10) * 0.85
        or (s.type == 'talk' and cfg.npc.talkTime * 0.85) or (s.type == 'hostage' and (s.time or 8) * 0.85) or 3
    if success and not killed and elapsed < minimum then success = false end
    local p = stepPos(run, i)
    local reach = s.type == 'hostage' and cfg.npc.aimDistance + 3 or (cfg.stepRadius + 2.5)
    if success and (not p or dist(pedPos(src), p) > reach) then success = false end

    if not success then
        run.failedAt[i] = now()
        if GAMES[s.type] and math.random() < cfg.failAlarm then alarm(run, 'loud', p) end
        pushRun(run)
        return true, { result = 'failed' }
    end

    local paid = true
    if s.type == 'talk' and (s.pay or 0) > 0 then
        if isGangCrew(run.gangId) then paid = Ledger.Transact(run.gangId, 'dirty', -s.pay, 'heist_bribe', { citizenid = cid, note = run.heist.label })
        else paid = Bridge.RemoveMoney(src, 'cash', s.pay, 'heist_bribe') end
    end
    if not paid then
        pushRun(run)
        return false, 'heist_cant_pay', Utils.FormatMoney(s.pay)
    end
    local tool = (s.item and s.item ~= '') and { item = s.item, consume = s.consume } or cfg.tools[s.type]
    if tool and tool.item and tool.consume then Bridge.RemoveItem(src, tool.item, 1) end
    if s.doorId and s.doorId ~= '' then Bridge.UnlockDoor(s.doorId) end
    openStepDoors(run, i)
    if killed then alarm(run, 'loud', p) end
    if s.alert and s.alert ~= 'none' then alarm(run, s.alert, p) end
    local reward = s.type == 'loot' and payLoot(run, src, s) or nil
    run.done[i] = true

    if #availableSteps(run) == 0 then run.escaping = true end
    pushRun(run)
    return true, { result = 'done', reward = reward, escaping = run.escaping == true,
        say = s.type == 'talk' and s.say or nil, killed = killed or nil }
end

---The hostage was killed (maybe by someone who never started intimidating them). The step's done, loudly.
function Heists.HostageKilled(src, runId, i)
    local run = runs[tonumber(runId)]
    i = tonumber(i)
    if not inRun(src, run) then return false end
    local s = run.heist.data.steps[i]
    if not s or s.type ~= 'hostage' or run.done[i] then return false end
    local ok = false
    for _, a in ipairs(availableSteps(run)) do if a == i then ok = true end end
    if not ok or dist(pedPos(src), s) > cfg.npc.spawnDistance then return false end
    run.locks[i] = nil
    run.done[i] = true
    openStepDoors(run, i)
    alarm(run, 'loud', s)
    if #availableSteps(run) == 0 then run.escaping = true end
    crewNotify(run, locale('heist_hostage_killed'), 'error')
    pushRun(run)
    return true
end

---Guards: one crew member's game spawns them (shared NPCs) when the crew gets close, then reports their ids.
function Heists.GuardsClaim(src, runId, i)
    local run = runs[tonumber(runId)]
    i = tonumber(i)
    if not inRun(src, run) then return false end
    local s = run.heist.data.steps[i]
    if not s or s.type ~= 'guards' or run.done[i] or (run.guards and run.guards[i]) then return false end
    local ok = false
    for _, a in ipairs(availableSteps(run)) do if a == i then ok = true end end
    if not ok or dist(pedPos(src), s) > cfg.npc.spawnDistance + 20 then return false end
    run.guardClaims = run.guardClaims or {}
    local c = run.guardClaims[i]
    if c and GetGameTimer() - c.at < 20000 then return false end -- someone's already spawning them
    run.guardClaims[i] = { src = src, at = GetGameTimer() }
    return true, { x = s.x, y = s.y, z = s.z, w = s.w or 0.0, count = s.count or 4, ped = s.ped or cfg.npc.guardPed, spots = s.spots,
        weapon = s.weapon or cfg.npc.guardWeapon, armour = s.armour or 50, accuracy = s.accuracy or 40, radius = s.radius or 10 }
end

function Heists.GuardsSpawned(src, runId, i, nets)
    local run = runs[tonumber(runId)]
    i = tonumber(i)
    if not run or not run.guardClaims or not run.guardClaims[i] or run.guardClaims[i].src ~= src or type(nets) ~= 'table' then return false end
    local list = {}
    for _, n in ipairs(nets) do
        n = tonumber(n)
        local ped = n and NetworkGetEntityFromNetworkId(n)
        if ped and ped ~= 0 and DoesEntityExist(ped) and GetEntityType(ped) == 1 then list[#list + 1] = n end
    end
    if #list == 0 then run.guardClaims[i] = nil return false end
    run.guards = run.guards or {}
    run.guards[i] = list
    pushRun(run)
    return true
end

function Heists.Abandon(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    local run = runOf(src)
    if not run then return false, 'invalid' end
    if gang and not Gangs.HasPermission(cid, 'heists') then return false, 'no_permission' end
    endRun(run, 'cancelled', 'heist_abandoned')
    return true
end

-- Every two seconds: time limits, the getaway, and whether the truck's been stopped
local function tick()
    for _, run in pairs(runs) do
        if now() >= run.endsAt then
            endRun(run, 'failed', 'heist_timed_out')
        elseif run.escaping then
            local start = run.heist.data.start
            local away, anyone = true, false
            for _, m in ipairs(crewMembers(run)) do
                if run.crewSeen and run.crewSeen[m.citizenid] then
                    anyone = true
                    if dist(pedPos(m.source), start) < cfg.escapeRadius then away = false end
                end
            end
            if anyone and away then endRun(run, 'done') end
        else
            -- Guards: done once every one of them is down
            local avail = availableSteps(run)
            for _, gi in ipairs(avail) do
                local gs = run.heist.data.steps[gi]
                if gs.type == 'guards' and run.guards and run.guards[gi] then
                    local standing = 0
                    for _, n in ipairs(run.guards[gi]) do
                        local ped = NetworkGetEntityFromNetworkId(n)
                        if ped ~= 0 and DoesEntityExist(ped) and GetEntityHealth(ped) > 100 then standing = standing + 1 end
                    end
                    if standing == 0 then
                        run.done[gi] = true
                        openStepDoors(run, gi)
                        if gs.alert and gs.alert ~= 'none' then alarm(run, gs.alert, gs) end
                        if #availableSteps(run) == 0 then run.escaping = true end
                        crewNotify(run, locale('heist_guards_down'), 'success')
                        pushRun(run)
                    end
                end
            end
            -- Truck: done once it's stopped and either badly damaged or without a driver
            avail = availableSteps(run)
            local s = avail[1] and run.heist.data.steps[avail[1]]
            if s and s.type == 'truck' then
                local veh = run.truck
                if not veh or not DoesEntityExist(veh) then
                    endRun(run, 'failed', 'heist_truck_lost')
                elseif GetEntitySpeed(veh) < 1.0 then
                    local driver = GetPedInVehicleSeat(veh, -1)
                    if driver == 0 or not DoesEntityExist(driver) or GetEntityHealth(driver) <= 0
                        or GetVehicleEngineHealth(veh) <= cfg.truck.stopHealth then
                        run.done[avail[1]] = true
                        openStepDoors(run, avail[1])
                        pushRun(run)
                    end
                end
            end
        end
    end
end

function Heists.StartLoop()
    if not cfg.enabled then return end
    CreateThread(function()
        while true do
            Wait(2000)
            local ok, err = pcall(tick)
            if not ok then lib.print.error(('heist tick: %s'):format(err)) end
        end
    end)
end

-------------------------------------------------------------------------------
-- Builder (staff)
-------------------------------------------------------------------------------

local VALID_TYPES = cfg.stepTypes
local VALID_ALERTS = { none = true, silent = true, loud = true }

local function cleanNumber(v, lo, hi, default)
    v = tonumber(v)
    if not v then return default end
    return math.max(lo, math.min(hi, v))
end

local function cleanPoint(p)
    if type(p) ~= 'table' then return nil end
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    if not x or not y or not z or math.abs(x) > 10000 or math.abs(y) > 10000 or z < -200 or z > 3000 then return nil end
    return { x = x, y = y, z = z, w = cleanNumber(p.w, 0, 360, 0) }
end

local function cleanText(t, max) return tostring(t or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, max or 48) end

---Checks and tidies a heist from the builder. Returns data, or nil and a reason.
local function cleanHeist(input)
    if type(input) ~= 'table' then return nil, 'invalid' end
    local label = cleanText(input.label, 48)
    if #label < 2 then return nil, 'invalid_label' end
    local data = {
        police = math.floor(cleanNumber(input.police, 0, 20, 2)),
        crew = math.floor(cleanNumber(input.crew, 1, 10, 2)),
        cooldown = math.floor(cleanNumber(input.cooldown, 5, 1440, 60)),
        timeLimit = math.floor(cleanNumber(input.timeLimit, 3, 120, 15)),
        tier = input.tier and math.floor(cleanNumber(input.tier, 1, #Config.Progression.tiers, 3)) or nil,
        start = cleanPoint(input.start),
        steps = {},
        -- How the job starts: press E at a marker on the start point ('tablet', the original way), or talk to a
        -- contact standing there ('npc'). ('both' from an earlier version counts as a contact.)
        startMode = (input.startMode == 'npc' or input.startMode == 'both') and 'npc' or 'tablet',
        -- Who can do it: gangs only, or anyone (players with no gang too)
        openTo = input.openTo == 'anyone' and 'anyone' or 'gangs',
        doors = {},
    }
    -- The heist's own doors (locked while it's enabled; steps open them)
    for _, d in ipairs(type(input.doors) == 'table' and input.doors or {}) do
        local model, x, y, z = tonumber(d.model), tonumber(d.x), tonumber(d.y), tonumber(d.z)
        if model and x and y and z and #data.doors < 20 then
            local label = cleanText(d.label, 32)
            data.doors[#data.doors + 1] = { model = model, x = x, y = y, z = z, label = #label > 0 and label or ('Door ' .. (#data.doors + 1)) }
        end
    end
    if data.startMode ~= 'tablet' then
        local n = type(input.startNpc) == 'table' and input.startNpc or {}
        local model = cleanText(n.ped, 32):lower()
        local name = cleanText(n.name, 32)
        data.startNpc = { ped = model:match('^[%w_]+$') and model or cfg.npc.ped, name = #name > 0 and name or 'The contact', say = cleanText(n.say, 200) }
    end
    if type(input.steps) ~= 'table' or #input.steps > 20 then return nil, 'heist_bad_steps' end
    for _, s in ipairs(input.steps) do
        if type(s) ~= 'table' or not VALID_TYPES[s.type] then return nil, 'heist_bad_steps' end
        local step = {
            type = s.type, label = cleanText(s.label, 40),
            difficulty = math.floor(cleanNumber(s.difficulty, 1, 3, 2)),
            time = math.floor(cleanNumber(s.time, 3, 600, s.type == 'loot' and 15 or 30)),
            alert = VALID_ALERTS[s.alert] and s.alert or 'none',
            doorId = s.doorId and cleanText(s.doorId, 64) or nil,
        }
        if #step.label == 0 then step.label = VALID_TYPES[s.type].label end
        -- Which of the heist's doors this step opens when it's done
        if type(s.opens) == 'table' and #data.doors > 0 then
            local seen = {}
            for _, d in ipairs(s.opens) do
                d = math.floor(tonumber(d) or 0)
                if d >= 1 and d <= #data.doors and not seen[d] then seen[d] = true step.opens = step.opens or {} step.opens[#step.opens + 1] = d end
            end
        end
        if s.type == 'talk' or s.type == 'hostage' or s.type == 'guards' then
            local model = cleanText(s.ped, 32):lower()
            step.ped = model:match('^[%w_]+$') and model or (s.type == 'guards' and cfg.npc.guardPed or cfg.npc.ped)
        end
        if s.type == 'talk' then
            step.say = cleanText(s.say, 200)
            step.pay = math.floor(cleanNumber(s.pay, 0, 10000000, 0))
        elseif s.type == 'hostage' then
            step.time = math.floor(cleanNumber(s.time, 3, 60, 8))
        elseif s.type == 'guards' then
            local weapon = cleanText(s.weapon, 40):lower()
            step.weapon = weapon:match('^weapon_[%w_]+$') and weapon or cfg.npc.guardWeapon
            step.count = math.floor(cleanNumber(s.count, 1, 12, 4))
            step.armour = math.floor(cleanNumber(s.armour, 0, 100, 50))
            step.accuracy = math.floor(cleanNumber(s.accuracy, 1, 100, 40))
            step.radius = math.floor(cleanNumber(s.radius, 2, 40, 10))
            -- Guards placed one by one: their exact spots and facing (then the count is how many were placed)
            if type(s.spots) == 'table' and #s.spots > 0 then
                step.spots = {}
                for _, p in ipairs(s.spots) do
                    local cp = cleanPoint(p)
                    if cp and #step.spots < 12 then step.spots[#step.spots + 1] = cp end
                end
                if #step.spots > 0 then step.count = #step.spots else step.spots = nil end
            end
        end
        local p = cleanPoint(s)
        if p then step.x, step.y, step.z, step.w = p.x, p.y, p.z, p.w end
        if s.type == 'loot' then
            local l = normaliseLoot(s.loot) or {}
            local lo = math.floor(cleanNumber(l.min, 1, 10000000, 1))
            local hi = math.max(lo, math.floor(cleanNumber(l.max, 1, 10000000, lo)))
            if l.kind == 'money' then
                step.loot = { kind = 'money', account = l.account == 'clean' and 'clean' or 'dirty', min = lo, max = hi }
            elseif l.kind == 'item' then
                if not Bridge.ItemExists(l.item) then return nil, 'item_not_found' end
                step.loot = { kind = 'item', item = l.item, label = cleanText(l.label ~= '' and l.label or Bridge.ItemLabel(l.item), 40), min = lo, max = math.min(hi, 500) }
            elseif l.kind == 'table' then
                if not lootTableById(l.table) then return nil, 'heist_bad_loot' end
                step.loot = { kind = 'table', table = tonumber(l.table) }
            else
                return nil, 'heist_bad_loot'
            end
        end
        if s.item and s.item ~= '' then
            if not Bridge.ItemExists(s.item) then return nil, 'item_not_found' end
            step.item, step.itemLabel, step.consume = s.item, cleanText(s.itemLabel or Bridge.ItemLabel(s.item), 40), s.consume == true
        end
        data.steps[#data.steps + 1] = step
    end
    local enabled = input.enabled == true
    if enabled then
        if not data.start then return nil, 'heist_needs_start' end
        if #data.steps == 0 then return nil, 'heist_needs_steps' end
        for _, s in ipairs(data.steps) do
            if not s.x and s.type ~= 'truck_doors' and not (s.type == 'loot' and data.steps[1].type == 'truck') then
                return nil, 'heist_needs_positions'
            end
        end
        if data.steps[1].type ~= 'truck' then
            for _, s in ipairs(data.steps) do if s.type == 'truck' or s.type == 'truck_doors' then return nil, 'heist_truck_first' end end
        end
    end
    return { label = label, kind = cleanText(input.kind, 16), enabled = enabled, data = data }
end

local function adminView(h)
    local run = byHeist[h.id] and runs[byHeist[h.id]]
    local runGang = run and isGangCrew(run.gangId) and Gangs.Get(run.gangId)
    return { id = h.id, label = h.label, kind = h.kind, enabled = h.enabled, data = h.data,
        cooldownLeft = math.max(0, (h.nextAt or 0) - now()), running = run and (runGang and runGang.label or 'A crew with no gang') or nil }
end

function Heists.AdminList()
    local list = {}
    for _, h in pairs(heists) do list[#list + 1] = adminView(h) end
    table.sort(list, function(a, b) return a.label < b.label end)
    local templates = {}
    for key, t in pairs(cfg.templates) do templates[#templates + 1] = { key = key, label = t.label, steps = #t.steps } end
    table.sort(templates, function(a, b) return a.label < b.label end)
    local types, loot = {}, {}
    for key, t in pairs(cfg.stepTypes) do types[#types + 1] = { key = key, label = t.label, game = t.game } end
    table.sort(types, function(a, b) return a.label < b.label end)
    for key, l in pairs(cfg.lootTypes) do loot[#loot + 1] = { key = key, label = l.label } end
    table.sort(loot, function(a, b) return a.label < b.label end)
    local tiers = {}
    for i, t in ipairs(Config.Progression.tiers) do tiers[i] = t.label end
    local tools = {}
    for key, t in pairs(cfg.tools) do
        if t.item then tools[key] = { item = t.item, label = Bridge.ItemLabel(t.item), consume = t.consume == true } end
    end
    local peds = {}
    for _, c in ipairs(Config.PedList or {}) do
        local list2 = {}
        for _, p in ipairs(c.peds or {}) do list2[#list2 + 1] = { model = p[1], label = p[2] or p[1] } end
        peds[#peds + 1] = { category = c.category, peds = list2 }
    end
    return { heists = list, templates = templates, stepTypes = types, lootTypes = loot, tiers = tiers, tools = tools, npc = cfg.npc, peds = peds,
        defaultTier = Progression.TierFor('heists') or 1 }
end

function Heists.AdminCreate(src, template)
    local t = cfg.templates[tostring(template)]
    if not t then return false, 'invalid' end
    local steps = {}
    for i, s in ipairs(t.steps) do
        steps[i] = { type = s.type, label = s.label, difficulty = s.difficulty, time = s.time, alert = s.alert,
            loot = s.loot and normaliseLoot(s.loot) or nil }
    end
    local data = { police = t.police, crew = t.crew, cooldown = t.cooldown, timeLimit = t.timeLimit, steps = steps }
    local id = MySQL.insert.await('INSERT INTO vg_heists (label, kind, enabled, data, created_by) VALUES (?, ?, 0, ?, ?)',
        { t.label, tostring(template), json.encode(data), Bridge.GetCitizenId(src) or 'console' })
    if not id then return false, 'db_error' end
    heists[id] = { id = id, label = t.label, kind = tostring(template), enabled = false, nextAt = 0, data = data }
    Logger.Log(src, 'staff_heist_created', ('created heist %d from %s'):format(id, tostring(template)))
    return true, adminView(heists[id])
end

function Heists.AdminSave(src, id, input)
    local h = heists[tonumber(id)]
    if not h then return false, 'invalid' end
    if byHeist[h.id] then return false, 'heist_in_progress' end
    local clean, err = cleanHeist(input)
    if not clean then return false, err end
    h.label, h.kind, h.enabled, h.data = clean.label, clean.kind ~= '' and clean.kind or h.kind, clean.enabled, clean.data
    saveHeist(h)
    publish()
    Logger.Log(src, 'staff_heist_saved', ('saved heist %d "%s"%s'):format(h.id, h.label, h.enabled and ' (enabled)' or ''))
    return true, adminView(h)
end

function Heists.AdminDelete(src, id)
    local h = heists[tonumber(id)]
    if not h then return false, 'invalid' end
    if byHeist[h.id] then endRun(runs[byHeist[h.id]], 'cancelled', 'heist_cancelled_staff') end
    heists[h.id] = nil
    MySQL.update.await('DELETE FROM vg_heists WHERE id = ?', { h.id })
    publish()
    Logger.Log(src, 'staff_heist_deleted', ('deleted heist %d "%s"'):format(h.id, h.label))
    return true
end

function Heists.AdminReset(src, id)
    local h = heists[tonumber(id)]
    if not h then return false, 'invalid' end
    h.nextAt = 0
    saveHeist(h)
    return true
end

function Heists.AdminStop(src, id)
    local h = heists[tonumber(id)]
    local run = h and byHeist[h.id] and runs[byHeist[h.id]]
    if not run then return false, 'invalid' end
    endRun(run, 'cancelled', 'heist_cancelled_staff')
    return true
end

---Where the staff member is standing (and facing), for setting a start point or a step.
function Heists.AdminHere(src)
    local ped = GetPlayerPed(src)
    local c = GetEntityCoords(ped)
    local r2 = function(n) return math.floor(n * 100 + 0.5) / 100 end
    return { x = r2(c.x), y = r2(c.y), z = r2(c.z), w = r2(GetEntityHeading(ped)) }
end

AddEventHandler('vinewood_gangs:server:gangDisbanded', function(gangId)
    if byGang[gangId] and runs[byGang[gangId]] then endRun(runs[byGang[gangId]], 'cancelled', 'heist_cancelled_staff') end
end)

-- For tests
Heists._runs = runs
Heists._tick = tick
