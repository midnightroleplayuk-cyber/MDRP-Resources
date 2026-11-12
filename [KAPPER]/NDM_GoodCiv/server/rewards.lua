-- Rewards with anti-farm checks. Only volunteers who actually treated the patient are
-- paid, never the person who injured them, and repeat payouts are limited per patient
-- and per hour (tracked by FiveM licence so swapping characters doesn't reset them).

local AF = Config.Rewards.AntiFarm or {}

local pairPaid = {}  -- ['responderLicence|patientLicence'] = os.time()
local payouts = {}   -- [responderLicence] = { os.time(), ... }

local function licence(src)
    return GetPlayerIdentifierByType(src, 'license') or Bridge.GetIdentifier(src)
end

local function recentPayouts(key, t)
    local list = payouts[key] or {}
    for i = #list, 1, -1 do
        if t - list[i] >= 3600 then table.remove(list, i) end
    end
    payouts[key] = list
    return list
end

---@return string|nil reason locale key if src should not be paid for inc
local function blocked(inc, src, t)
    if AF.RequireTreatment and not (inc.treated and inc.treated[src]) then
        return 'reward_none_treat'
    end
    if AF.NoRewardIfAttacker then
        local report = Player(inc.patient).state['goodciv:patient'] or {}
        if inc.attacker == src or report.attacker == src then return 'reward_none_attacker' end
    end
    local me = licence(src)
    if (AF.PairCooldown or 0) > 0 then
        local last = pairPaid[me .. '|' .. licence(inc.patient)]
        if last and t - last < AF.PairCooldown then return 'reward_none_pair' end
    end
    if (AF.MaxPerHour or 0) > 0 and #recentPayouts(me, t) >= AF.MaxPerHour then
        return 'reward_none_cap'
    end
end

---Mark a responder as having done real work on this incident.
function Incidents.MarkTreated(inc, src)
    inc.treated = inc.treated or {}
    inc.treated[src] = true
end

function Incidents.Reward(inc, amount)
    if not Config.Rewards.Enabled or amount <= 0 then return end
    local t = os.time()
    for src in pairs(inc.responders) do
        local reason = blocked(inc, src, t)
        if reason then
            TriggerClientEvent('goodciv:client:toast', src, 'info', L(reason))
            print(('^3[goodciv]^7 reward withheld from %s (%d) on incident %d: %s'):format(
                GetPlayerName(src) or '?', src, inc.id, reason))
            Logs.Send('rewards', ('Call #%d: reward withheld'):format(inc.id), 'orange', {
                { 'Responder', Logs.Player(src) },
                { 'Patient', Logs.Player(inc.patient) },
                { 'Reason', L(reason) },
                { 'Would have been', ('£%d'):format(amount), true },
            })
        else
            local me = licence(src)
            pairPaid[me .. '|' .. licence(inc.patient)] = t
            local list = recentPayouts(me, t)
            list[#list + 1] = t
            Bridge.AddMoney(src, amount)
            TriggerClientEvent('goodciv:client:toast', src, 'success', L('reward', amount))
            Logs.Send('rewards', ('Call #%d: reward paid'):format(inc.id), 'green', {
                { 'Responder', Logs.Player(src) },
                { 'Patient', Logs.Player(inc.patient) },
                { 'Amount', ('£%d (%s)'):format(amount, Config.Rewards.Account), true },
                { 'Paid calls this hour', #list, true },
            })
        end
    end
end
