-- Contracts staff make in game (/gangadmin > Custom contracts). They use the same three job types as the
-- generated ones, but staff choose the title, contact, spots, and the reward (money, items, reputation).
CustomContracts = {}

local jobs, nextId = {}, 1

local function save(src)
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('custom_contracts', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode({ nextId = nextId, jobs = jobs }), src and Bridge.GetCitizenId(src) or 'server' })
end

function CustomContracts.Load()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'custom_contracts'")
    local ok, data = pcall(json.decode, raw or '')
    if ok and type(data) == 'table' then jobs, nextId = data.jobs or {}, data.nextId or 1 else jobs, nextId = {}, 1 end
end

local function find(id)
    id = tonumber(id)
    for i, j in ipairs(jobs) do if j.id == id then return j, i end end
end

---A custom contract for this gang's board right now, or nil (each one rolls its own chance).
function CustomContracts.PickFor(gangId)
    local pool = {}
    local tier = Progression.Tier(gangId)
    for _, j in ipairs(jobs) do
        if j.enabled and not (j.once and (j.done or 0) > 0) and (not j.gangId or j.gangId == gangId)
            and tier >= (j.minTier or 1) and not Contracts.HasCustom(gangId, j.id) then
            pool[#pool + 1] = j
        end
    end
    for i = #pool, 2, -1 do local k = math.random(i) pool[i], pool[k] = pool[k], pool[i] end
    for _, j in ipairs(pool) do
        if math.random() * 100 < (j.chance or 0) then return j end
    end
end

function CustomContracts.Completed(id)
    local j = find(id)
    if not j then return end
    j.done = (j.done or 0) + 1
    if j.once then j.enabled = false end
    save()
end

-------------------------------------------------------------------------------
-- Staff
-------------------------------------------------------------------------------

local function text(v, max) return tostring(v or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, max) end
local function num(v, lo, hi, d) v = tonumber(v) return v and math.max(lo, math.min(hi, v)) or d end
local function point(p)
    if type(p) ~= 'table' then return nil end
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    if not x or not y or not z or math.abs(x) > 10000 or math.abs(y) > 10000 then return nil end
    return { x = x, y = y, z = z, w = num(p.w, 0, 360, 0), label = text(p.label ~= nil and p.label or 'Marked spot', 40) }
end

local function clean(input)
    if type(input) ~= 'table' then return nil, 'invalid' end
    local title = text(input.title, 48)
    if #title < 2 then return nil, 'invalid_label' end
    if not Config.Contracts.templates[input.type] then return nil, 'invalid' end
    local items = {}
    for _, it in ipairs(type(input.items) == 'table' and input.items or {}) do
        if #items >= 10 then break end
        if it.item and it.item ~= '' then
            if not Bridge.ItemExists(it.item) then return nil, 'item_not_found' end
            items[#items + 1] = { item = it.item, label = text(it.label or Bridge.ItemLabel(it.item), 40), count = math.floor(num(it.count, 1, 500, 1)) }
        end
    end
    local money = math.floor(num(input.money, 0, 10000000, 0))
    local reputation = math.floor(num(input.reputation, 0, 500, 0))
    if money == 0 and #items == 0 and reputation == 0 then return nil, 'contract_no_reward' end
    local gangId = tonumber(input.gangId)
    if gangId and not Gangs.Get(gangId) then gangId = nil end
    local job = {
        title = title, description = text(input.description, 200), contact = text(input.contact, 32),
        type = input.type, difficulty = math.floor(num(input.difficulty, 1, #Config.Contracts.difficulty, 1)),
        timeLimit = math.floor(num(input.timeLimit, 3, 120, 15)),
        money = money, account = input.account == 'clean' and 'clean' or 'dirty', items = items, reputation = reputation,
        pickup = point(input.pickup), drop = point(input.drop), spot = point(input.spot),
        model = text(input.model, 32),
        gangId = gangId, minTier = math.floor(num(input.minTier, 1, #Config.Progression.tiers, 1)),
        chance = num(input.chance, 0, 100, 25), once = input.once == true, enabled = input.enabled ~= false,
    }
    -- One of the regular contacts (so the job builds trust with them), or a one-off name
    local key = tostring(input.contactKey or '')
    local regular
    for _, c in ipairs(Config.Contracts.contacts) do if c.key == key then regular = c end end
    if regular then job.contactKey, job.contact = regular.key, regular.label
    else job.contactKey = nil end
    if #job.contact == 0 then job.contact = 'Unknown' end
    -- Only keep the spots that job type uses
    if job.type == 'collect' then job.pickup, job.drop = nil, nil else job.spot = nil end
    if job.type ~= 'transport' then job.model = '' end
    return job
end

function CustomContracts.AdminList()
    local list = {}
    for _, j in ipairs(jobs) do
        local g = j.gangId and Gangs.Get(j.gangId)
        local copy = {}
        for k, v in pairs(j) do copy[k] = v end
        copy.gangLabel = g and g.label or nil
        list[#list + 1] = copy
    end
    local types = {}
    for key, t in pairs(Config.Contracts.templates) do types[#types + 1] = { key = key, label = t.title } end
    table.sort(types, function(a, b) return a.label < b.label end)
    local diff = {}
    for i, d in ipairs(Config.Contracts.difficulty) do diff[i] = d.label end
    local tiers = {}
    for i, t in ipairs(Config.Progression.tiers) do tiers[i] = t.label end
    local gangs = {}
    for id, g in pairs(Gangs.All()) do gangs[#gangs + 1] = { id = id, label = g.label } end
    table.sort(gangs, function(a, b) return a.label < b.label end)
    local contacts = {}
    for _, c in ipairs(Config.Contracts.contacts) do contacts[#contacts + 1] = { key = c.key, label = c.label } end
    return { jobs = list, types = types, difficulty = diff, tiers = tiers, gangs = gangs, contacts = contacts }
end

function CustomContracts.AdminSave(src, input)
    local job, err = clean(input)
    if not job then return false, err end
    local existing = input.id and find(input.id)
    if existing then
        job.id, job.done = existing.id, existing.done
        for k in pairs(existing) do existing[k] = nil end
        for k, v in pairs(job) do existing[k] = v end
    else
        job.id, job.done = nextId, 0
        nextId = nextId + 1
        jobs[#jobs + 1] = job
    end
    save(src)
    Logger.Log(src, 'staff_custom_contract', ('saved custom contract %d "%s"'):format(job.id, job.title))
    return true, job.id
end

function CustomContracts.AdminDelete(src, id)
    local j, i = find(id)
    if not j then return false, 'invalid' end
    table.remove(jobs, i)
    save(src)
    Logger.Log(src, 'staff_custom_contract_deleted', ('deleted custom contract %d "%s"'):format(j.id, j.title))
    return true
end

---Puts it straight on one gang's board (stays up for three hours).
function CustomContracts.AdminOfferNow(src, id, gangId)
    local j = find(id)
    gangId = tonumber(gangId)
    if not j or not gangId or not Gangs.Get(gangId) then return false, 'invalid' end
    if Contracts.HasCustom(gangId, j.id) then return false, 'contract_already_offered' end
    if not Contracts.OfferCustom(gangId, j, 180) then return false, 'failed' end
    Gangs.NotifyGang(gangId, locale('contract_special_offer', j.contact, j.title), 'inform')
    Logger.Log(src, 'staff_custom_contract_offered', ('offered custom contract %d to gang %d'):format(j.id, gangId))
    return true
end
