Laundering = {}

local cfg = Config.Laundering
local DAY = 86400
local batches = {} -- batches[id] = { id, gangId, method, amountIn, amountOut, readyAt, status, createdAt, citizenid }

local function now() return os.time() end

local function usedToday(gangId, method)
    local total, cutoff = 0, now() - DAY
    for _, b in pairs(batches) do
        if b.gangId == gangId and b.method == method and b.createdAt > cutoff and b.status ~= 'cancelled' then
            total = total + b.amountIn
        end
    end
    return total
end

local function capacity(gangId, method)
    local m = cfg.methods[method]
    if method == 'fronts' then return #(Rackets and Rackets.ProtectedBy(gangId) or {}) * m.perBusiness end
    return m.dailyLimit or 0
end

---Why this gang can't use a method right now, if anything.
local function blocker(gangId, method)
    local m = cfg.methods[method]
    if m.needs and not Progression.Has(gangId, m.needs) then return 'tier_locked' end
    if method == 'fronts' and capacity(gangId, method) == 0 then return 'launder_no_fronts' end
    return nil
end

function Laundering.View(src)
    if not cfg.enabled then return nil, 'invalid' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'treasury_view') then return { canSee = false } end

    local methods = {}
    for key, m in pairs(cfg.methods) do
        local limit = capacity(gang.id, key)
        local used = usedToday(gang.id, key)
        methods[#methods + 1] = {
            key = key, label = m.label, description = m.description, cut = m.cut, minutes = m.minutes, min = m.min,
            limit = limit, left = math.max(0, limit - used), blocked = blocker(gang.id, key),
            tierNeeded = m.needs and Progression.TierFor(m.needs) or nil,
        }
    end
    table.sort(methods, function(a, b) return a.cut < b.cut end)

    local washing, done = {}, {}
    for _, b in pairs(batches) do
        if b.gangId == gang.id then
            local row = { id = b.id, method = cfg.methods[b.method] and cfg.methods[b.method].label or b.method,
                amountIn = b.amountIn, amountOut = b.amountOut, secondsLeft = math.max(0, b.readyAt - now()), at = b.createdAt }
            if b.status == 'washing' then washing[#washing + 1] = row elseif b.status == 'done' then done[#done + 1] = row end
        end
    end
    table.sort(washing, function(a, b) return a.secondsLeft < b.secondsLeft end)
    table.sort(done, function(a, b) return a.at > b.at end)
    while #done > 5 do table.remove(done) end

    return {
        canSee = true, canWash = Gangs.HasPermission(cid, 'treasury_withdraw'),
        dirty = Ledger.GetBalance(gang.id, 'dirty'), methods = methods, washing = washing, done = done,
    }
end

function Laundering.Start(src, method, amount)
    if not cfg.enabled then return false, 'invalid' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'treasury_withdraw') then return false, 'no_permission' end
    local m = cfg.methods[method]
    if not m then return false, 'invalid' end
    local why = blocker(gang.id, method)
    if why then return false, why end

    amount = math.floor(tonumber(amount) or 0)
    if amount < m.min then return false, 'launder_too_small' end
    local left = capacity(gang.id, method) - usedToday(gang.id, method)
    if amount > left then return false, 'launder_over_limit' end

    local ok = Ledger.Transact(gang.id, 'dirty', -amount, 'laundering', { citizenid = cid, note = m.label })
    if not ok then return false, 'insufficient_funds' end

    local t = now()
    local b = { gangId = gang.id, method = method, amountIn = amount, amountOut = math.floor(amount * (1 - m.cut)),
        readyAt = t + m.minutes * 60, status = 'washing', createdAt = t, citizenid = cid }
    b.id = MySQL.insert.await('INSERT INTO vg_laundering (gang_id, method, amount_in, amount_out, ready_at, status, citizenid, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        { b.gangId, method, b.amountIn, b.amountOut, b.readyAt, 'washing', cid, t })
    batches[b.id] = b

    Heat.Add(gang.id, cid, amount / 1000 * cfg.heatPer1000)
    Logger.Log(src, 'laundering_started', ('%s washing %d via %s for gang %d'):format(cid, amount, method, gang.id))
    return true, b.amountOut
end

local function tick()
    local t = now()
    for id, b in pairs(batches) do
        if b.status == 'washing' and t >= b.readyAt then
            b.status = 'done'
            MySQL.update("UPDATE vg_laundering SET status = 'done' WHERE id = ?", { id })
            if Gangs.Get(b.gangId) then
                local m = cfg.methods[b.method]
                Ledger.Transact(b.gangId, 'clean', b.amountOut, 'laundered', { citizenid = b.citizenid, refType = 'laundering', refId = id, note = m and m.label })
                Gangs.NotifyGang(b.gangId, locale('launder_done', Utils.FormatMoney(b.amountOut)), 'success', nil)
                -- Bigger washes are likelier to be noticed
                local chance = math.min(0.6, (m and m.leadChance or 0.1) * (b.amountIn / 10000))
                if math.random() < chance then
                    Intel.CreateLead({
                        gangId = b.gangId, source = 'financial', precision = 'vague',
                        summary = ('Suspicious deposits of around %s through local businesses, consistent with money laundering.'):format(Utils.FormatMoney(b.amountIn)),
                    })
                end
            end
        elseif b.status ~= 'washing' and b.createdAt < t - DAY then
            batches[id] = nil
        end
    end
end

function Laundering.Load()
    batches = {}
    for _, r in ipairs(MySQL.query.await("SELECT id, gang_id, method, amount_in, amount_out, ready_at, status, citizenid, created_at FROM vg_laundering WHERE status = 'washing' OR created_at > ?", { now() - DAY })) do
        batches[r.id] = { id = r.id, gangId = r.gang_id, method = r.method, amountIn = r.amount_in, amountOut = r.amount_out,
            readyAt = r.ready_at, status = r.status, createdAt = r.created_at, citizenid = r.citizenid }
    end
end

function Laundering.Start_loop()
    if not cfg.enabled then return end
    CreateThread(function()
        while true do
            tick()
            Wait(30000)
        end
    end)
end

AddEventHandler('vinewood_gangs:server:gangDisbanded', function(gangId)
    for id, b in pairs(batches) do
        if b.gangId == gangId and b.status == 'washing' then
            b.status = 'cancelled'
            MySQL.update("UPDATE vg_laundering SET status = 'cancelled' WHERE id = ?", { id })
        end
    end
end)
