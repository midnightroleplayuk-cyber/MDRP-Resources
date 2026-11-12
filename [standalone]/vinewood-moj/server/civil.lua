-- Civil claims in the County Court: claimant v defendant. Issued by a solicitor for their client,
-- served on the defendant, admitted or defended, decided by a judge (or by default), then paid.
Civil = {}

local CV = Config.Civil or {}

Civil.Statuses = {
    issued = 'Awaiting response', defended = 'Defended: awaiting hearing', listed = 'Listed for hearing',
    judgment = 'Judgment: awaiting payment', satisfied = 'Judgment paid', order = 'Order made',
    dismissed = 'Dismissed', withdrawn = 'Withdrawn', settled = 'Settled', struck_out = 'Struck out',
}
Civil.Closed = { satisfied = true, order = true, dismissed = true, withdrawn = true, settled = true, struck_out = true }

function Civil.TypeLabel(id)
    for _, t in ipairs(CV.Types or {}) do if t.id == id then return t.label end end
    return id
end

local function money(t) return t == 'debt' or t == 'damages' or t == 'contract' or t == 'other' end

--- Court fee for issuing a claim of this amount.
function Civil.Fee(claimType, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 or not money(claimType) then return CV.NonMoneyFee or 0 end
    for _, band in ipairs(CV.Fees or {}) do
        if not band.upTo or amount <= band.upTo then
            local fee = band.fee or math.floor(amount * (band.pct or 0) / 100)
            if band.max then fee = math.min(fee, band.max) end
            return fee
        end
    end
    return 0
end

local function decode(c)
    if not c then return nil end
    c.response = U.decode(c.response)
    c.judgment = U.decode(c.judgment)
    c.log = U.decode(c.log)
    c.exhibits = U.decode(c.exhibits)
    c.statusLabel = Civil.Statuses[c.status] or c.status
    c.typeLabel = Civil.TypeLabel(c.claim_type)
    local court = U.court(c.hearing_court or Courts.CivilDefault())
    c.courtLabel = court and court.label or 'County Court'
    c.hearing_open = U.flag(c.hearing_open)
    c.ccj = U.flag(c.ccj)
    c.claimant_kind = c.claimant_kind or 'person'
    c.defendant_kind = c.defendant_kind or 'person'
    return c
end
Civil.Decode = decode

function Civil.Get(id) return decode(MySQL.single.await('SELECT * FROM vw_moj_civil WHERE id = ?', { tonumber(id) })) end

local function log(id, by, text)
    local cur = MySQL.scalar.await('SELECT log FROM vw_moj_civil WHERE id = ?', { id })
    local l = U.decode(cur)
    l[#l + 1] = { at = U.now(), by = by, text = text }
    while #l > 200 do table.remove(l, 1) end
    MySQL.update.await('UPDATE vw_moj_civil SET log = ?, updated_at = ? WHERE id = ?', { U.encode(l), U.now(), id })
end
Civil.Log = log

local function set(id, fields)
    local sets, args = {}, {}
    for k, v in pairs(fields) do
        sets[#sets + 1] = k .. ' = ?'
        args[#args + 1] = type(v) == 'table' and U.encode(v) or v
    end
    sets[#sets + 1] = 'updated_at = ?'
    args[#args + 1] = U.now()
    args[#args + 1] = id
    MySQL.update.await(('UPDATE vw_moj_civil SET %s WHERE id = ?'):format(table.concat(sets, ', ')), args)
end

--- Tell both parties and their solicitors.
--- A party is a person (citizen id) or a business (job name). Tell them: the person, or the business's online bosses.
local function tellParty(kind, id, msg, level)
    if not id then return end
    if kind == 'business' then Business.Notify(id, msg, level) else U.NotifyCid(id, msg, level) end
end
Civil.TellParty = tellParty

local function tellParties(c, msg, kind)
    tellParty(c.claimant_kind, c.claimant_cid, msg, kind)
    tellParty(c.defendant_kind, c.defendant_cid, msg, kind)
    for _, cid in ipairs({ c.claimant_sol_cid, c.defendant_sol_cid }) do
        if cid then U.NotifyCid(cid, msg, kind) end
    end
end

--- Is this player the party on a side: the person themselves, or a boss of the business.
function Civil.IsParty(c, side, cid, src)
    local kind, id = c[side .. '_kind'], c[side .. '_cid']
    if kind == 'business' then return Business.IsBoss(src or Bridge.GetSource(cid), id) end
    return id == cid
end

--- Which side someone is on: 'claimant', 'defendant' (as party, business boss or solicitor), or nil.
function Civil.Side(c, cid, src)
    if not cid then return nil end
    if c.claimant_sol_cid == cid or Civil.IsParty(c, 'claimant', cid, src) then return 'claimant' end
    if c.defendant_sol_cid == cid or Civil.IsParty(c, 'defendant', cid, src) then return 'defendant' end
end

--- MDT notes only make sense for people.
local function noteParty(c, side, text)
    if c[side .. '_kind'] == 'business' then return end
    MDT.Note(c[side .. '_cid'], text)
end

---------------------------------------------------------------------------
-- Money: paying the claimant (now if they're in the city, otherwise at their next login)
---------------------------------------------------------------------------
function Civil.Payout(cid, amount, reason, kind)
    if kind == 'business' then
        if Business.Add(cid, amount, reason) then
            Business.Notify(cid, ('%s paid into the business account: %s.'):format(U.money(amount), reason), 'success')
            return
        end
        print(('[vinewood-moj] could not pay %s into business account %s (%s)'):format(U.money(amount), cid, reason))
        return
    end
    local src = Bridge.GetSource(cid)
    if src and Bridge.AddMoney(src, CV.Account or 'bank', amount, reason) then
        Bridge.Notify(src, ('%s paid into your account: %s.'):format(U.money(amount), reason), 'success')
        return
    end
    MySQL.insert.await('INSERT INTO vw_moj_payouts (cid, amount, reason, created_at) VALUES (?, ?, ?, ?)', { cid, amount, reason, U.now() })
end

function Civil.PayPending(src, cid)
    for _, p in ipairs(MySQL.query.await('SELECT * FROM vw_moj_payouts WHERE cid = ? AND paid_at IS NULL', { cid }) or {}) do
        if Bridge.AddMoney(src, CV.Account or 'bank', p.amount, p.reason or 'Court payment') then
            MySQL.update.await('UPDATE vw_moj_payouts SET paid_at = ? WHERE id = ?', { U.now(), p.id })
            Bridge.Notify(src, ('%s paid into your account: %s.'):format(U.money(p.amount), p.reason or 'court payment'), 'success')
        end
    end
end

---------------------------------------------------------------------------
-- Issue and serve
---------------------------------------------------------------------------
--- a = access of whoever issues it (a solicitor), or nil with litigant = { src, cid, name } (in person).
--- { kind, id, name } for a person (citizen id) or a business (job name), or nil.
function Civil.Party(kind, id)
    id = U.trim(id, 64)
    if not id then return nil end
    if kind == 'business' then
        if not CV.Businesses then return nil end
        local b = Business.Get(id)
        return b and { kind = 'business', id = b.id, name = b.name } or nil
    end
    local p = Bridge.GetPerson(id)
    return p and { kind = 'person', id = id, name = U.fullName(p) } or nil
end

--- litigant = { cid, name } in person, or { business = id } when a boss issues for their business.
function Civil.Issue(src, a, d, litigant)
    if CV.enabled == false then return { error = 'Civil claims are switched off.' } end
    local pc
    if litigant and litigant.business then pc = Civil.Party('business', litigant.business)
    elseif litigant then pc = Civil.Party('person', litigant.cid)
    else pc = Civil.Party(d.claimantKind == 'business' and 'business' or 'person', d.claimant) end
    local pd = Civil.Party(d.defendantKind == 'business' and 'business' or 'person', d.defendant)
    if not pc then return { error = 'Choose who is bringing the claim.' } end
    if not pd then return { error = 'Choose who the claim is against.' } end
    if pc.kind == pd.kind and pc.id == pd.id then return { error = 'Someone cannot bring a claim against themselves.' } end
    if a and pd.kind == 'person' and a.cid == pd.id then return { error = 'You cannot issue a claim against yourself.' } end
    local claimant, defendant = pc.id, pd.id
    local ctype = Civil.TypeLabel(d.type) ~= d.type and d.type or nil
    if not ctype then return { error = 'Choose the type of claim.' } end
    local amount = U.int(d.amount, 0, 100000000)
    if money(ctype) and amount <= 0 then return { error = 'Enter how much is being claimed.' } end
    local particulars = U.trim(d.particulars, 6000)
    if not particulars or #particulars < 20 then return { error = 'Set out what happened and why it is owed (particulars of claim).' } end
    local remedy = U.trim(d.remedy, 250)
    if not money(ctype) and not remedy then return { error = 'Say what order you want the court to make.' } end

    local fee = Civil.Fee(ctype, amount)
    if fee > 0 then
        if litigant and litigant.business then
            -- A boss issuing for their business pays from the business account.
            local ok, err = Business.Remove(litigant.business, fee, 'County Court issue fee')
            if not ok then return { error = ('Court fee %s: %s'):format(U.money(fee), err or 'payment failed') } end
        else
            local account = CV.Account or 'bank'
            if Bridge.GetMoney(src, account) < fee then return { error = ('The court fee is %s and you do not have enough in your %s account.'):format(U.money(fee), account) } end
            if not Bridge.RemoveMoney(src, account, fee, 'County Court issue fee') then return { error = 'The court fee payment did not go through.' } end
        end
    end

    local t = U.now()
    local due = t + (CV.ResponseDays or 3) * 86400
    local opener = a and U.By(a) or (litigant and litigant.business and ('%s for %s'):format(Bridge.GetName(src), pc.name))
        or (litigant and (litigant.name .. ' (in person)'))
    local id = MySQL.insert.await([[INSERT INTO vw_moj_civil (claim_type, claimant_kind, claimant_cid, claimant_name, defendant_kind, defendant_cid, defendant_name,
        claimant_sol_cid, claimant_sol_name, amount, remedy, particulars, fee, status, response_due, hearing_court, log, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'issued', ?, ?, ?, ?, ?)]],
        { ctype, pc.kind, claimant, pc.name, pd.kind, defendant, pd.name, a and a.cid or nil, a and a.name or nil, amount, remedy, particulars,
          fee, due, Courts.CivilDefault(), U.encode({ { at = t, by = opener, text = ('Claim issued. Court fee %s paid.'):format(U.money(fee)) } }), t, t })
    local ref = ('%s%s/%05d'):format(Config.CaseRefPrefix.county or 'CV', os.date('%y'), id)
    MySQL.update.await('UPDATE vw_moj_civil SET ref = ? WHERE id = ?', { ref, id })

    tellParty(pd.kind, defendant, ('A County Court claim (%s) has been issued against %s by %s. Respond by %s with /%s, or judgment may be entered.')
        :format(ref, pd.kind == 'business' and pd.name or 'you', pc.name, U.fmtDate(due), Config.PortalCommand), 'error')
    if a then tellParty(pc.kind, claimant, ('The claim against %s has been issued (%s).'):format(pd.name, ref), 'success') end
    Webhook.Send('civil', ('Claim issued: %s v %s'):format(pc.name, pd.name), particulars:sub(1, 500), {
        { 'Claim', ref }, { 'Type', Civil.TypeLabel(ctype) }, { 'Amount', amount > 0 and U.money(amount) or remedy }, { 'Issued by', opener },
    }, 'blue')
    return { ok = true, id = id }
end

---------------------------------------------------------------------------
-- Judgments
---------------------------------------------------------------------------
--- forParty: 'claimant' | 'defendant'. amount: money awarded, costs: added on. order: text of any order.
local function giveJudgment(c, forParty, amount, costs, order, how, by)
    amount, costs = U.int(amount, 0), U.int(costs, 0)
    -- The losing side pays: the defendant pays damages and costs, or a claimant who lost pays the defendant's costs.
    local payer = forParty == 'claimant' and 'defendant' or 'claimant'
    local total = forParty == 'claimant' and (amount + costs) or costs
    local status
    if total > 0 then status = 'judgment'
    elseif order then status = 'order'
    else status = 'dismissed' end
    local j = { forParty = forParty, payer = payer, amount = amount, costs = costs, order = order, how = how, by = by, at = U.now() }
    set(c.id, { status = status, judgment = j, total_due = total, judgment_due = total > 0 and (U.now() + (CV.PayDays or 7) * 86400) or nil,
        hearing_open = 0, closed_at = Civil.Closed[status] and U.now() or nil })
    local text = forParty == 'claimant'
        and (('Judgment for the claimant%s: %s'):format(how and (' (' .. how .. ')') or '',
            total > 0 and (U.money(amount) .. (costs > 0 and (' plus ' .. U.money(costs) .. ' costs') or '')) or 'no money award'))
        or ('Claim dismissed: judgment for the defendant' .. (costs > 0 and (', claimant to pay ' .. U.money(costs) .. ' costs') or '') .. '.')
    if order then text = text .. ' Order: ' .. order end
    log(c.id, by, text)
    tellParties(c, ('%s %s: %s'):format(c.ref or '', 'judgment', text), forParty == 'claimant' and 'warning' or 'inform')
    if total > 0 then
        tellParty(c[payer .. '_kind'], c[payer .. '_cid'], ('Pay %s by %s with /%s. Unpaid judgments are registered as a CCJ.')
            :format(U.money(total), U.fmtDate(U.now() + (CV.PayDays or 7) * 86400), Config.PortalCommand), 'error')
    end
    if order then noteParty(c, 'defendant', ('County Court order (%s, %s v %s): %s'):format(c.ref or '', c.claimant_name or '', c.defendant_name or '', order)) end
    Webhook.Send('civil', ('Judgment: %s v %s'):format(c.claimant_name or '', c.defendant_name or ''), text, { { 'Claim', c.ref }, { 'By', by } },
        forParty == 'claimant' and 'amber' or 'green')
end
Civil.GiveJudgment = giveJudgment

function Civil.DefaultJudgment(c, by)
    if c.status ~= 'issued' then return { error = 'The defendant has already responded.' } end
    if U.now() < (c.response_due or 0) then return { error = ('The defendant has until %s to respond.'):format(U.fmtDate(c.response_due)) } end
    giveJudgment(c, 'claimant', c.amount, 0, (not money(c.claim_type)) and c.remedy or nil, 'in default of a response', by)
    return { ok = true }
end

---------------------------------------------------------------------------
-- Response (defendant or their solicitor)
---------------------------------------------------------------------------
--- kind: 'admit' (the whole claim), 'defend'. text: the defence.
function Civil.Respond(c, kind, text, by)
    if c.status ~= 'issued' then return { error = 'This claim has already been responded to.' } end
    if kind == 'admit' then
        set(c.id, { response = { kind = 'admit', text = U.trim(text, 2000), at = U.now(), by = by } })
        log(c.id, by, 'Defendant admitted the claim.')
        giveJudgment(Civil.Get(c.id), 'claimant', c.amount, 0, (not money(c.claim_type)) and c.remedy or nil, 'on admission', by)
        return { ok = true }
    elseif kind == 'defend' then
        text = U.trim(text, 6000)
        if not text or #text < 20 then return { error = 'Set out why the claim is disputed (the defence).' } end
        set(c.id, { status = 'defended', response = { kind = 'defend', text = text, at = U.now(), by = by } })
        log(c.id, by, 'Defence filed. The claim will be listed for a hearing.')
        tellParties(c, ('%s: the claim is defended and will be listed for a hearing.'):format(c.ref or ''))
        U.NotifyRole('clerk', ('Civil claim %s is defended and needs a hearing date.'):format(c.ref or ''))
        Webhook.Send('civil', ('Defended: %s v %s'):format(c.claimant_name or '', c.defendant_name or ''), text:sub(1, 500), { { 'Claim', c.ref } }, 'purple')
        return { ok = true }
    end
    return { error = 'Choose how to respond.' }
end

---------------------------------------------------------------------------
-- Hearings
---------------------------------------------------------------------------
function Civil.List(c, at, courtId, by, roomId)
    if Civil.Closed[c.status] or c.status == 'judgment' then return { error = 'This claim has been decided.' } end
    at = tonumber(at)
    if not at or at < U.now() then return { error = 'Pick a date and time in the future.' } end
    local court = U.court(courtId) and courtId or c.hearing_court or Courts.CivilDefault()
    local room = roomId and Rooms.Get(roomId)
    set(c.id, { status = 'listed', hearing_at = at, hearing_court = court, hearing_open = 0 })
    MySQL.update.await('UPDATE vw_moj_civil SET hearing_room = ? WHERE id = ?', { room and room.court_id == court and room.id or nil, c.id })
    local label = (U.court(court) or {}).label or 'County Court'
    log(c.id, by, ('Hearing listed for %s at %s.'):format(U.fmtDate(at), label))
    Webhook.Send('civil', ('Listed: %s v %s'):format(c.claimant_name or '', c.defendant_name or ''), nil, { { 'Claim', c.ref }, { 'When', U.fmtDate(at) }, { 'Court', label }, { 'By', by } }, 'blue')
    tellParties(c, ('%s: hearing listed for %s at %s.'):format(c.ref or '', U.fmtDate(at), label), 'warning')
    return { ok = true }
end

--- Opened by a judge, from a courtroom laptop if they're at one (parties get a waypoint to it).
function Civil.OpenHearing(c, a, src)
    if c.status ~= 'listed' and c.status ~= 'defended' and c.status ~= 'issued' then return { error = 'There is no hearing to open.' } end
    set(c.id, { hearing_open = 1, judge_name = a.name, status = c.status == 'issued' and 'issued' or 'listed' })
    local room = Rooms.LaptopRoom(src)
    if room then MySQL.update.await('UPDATE vw_moj_civil SET hearing_room = ? WHERE id = ?', { room.id, c.id }) end
    log(c.id, U.By(a), ('Hearing opened%s.'):format(room and (' in ' .. room.label) or ''))
    Webhook.Send('civil', ('Hearing opened: %s v %s'):format(c.claimant_name or '', c.defendant_name or ''), nil, { { 'Claim', c.ref }, { 'Where', room and room.label }, { 'Judge', U.By(a) } }, 'blue')
    local where = room and room.label or c.courtLabel
    local targets = { c.claimant_sol_cid, c.defendant_sol_cid }
    for _, side in ipairs({ 'claimant', 'defendant' }) do
        if c[side .. '_kind'] == 'business' then
            for _, s in ipairs(Business.Bosses(c[side .. '_cid'])) do targets[#targets + 1] = Bridge.GetCid(s) end
        else
            targets[#targets + 1] = c[side .. '_cid']
        end
    end
    for _, cid in pairs(targets) do
        local s = cid and U.NotifyCid(cid, ('%s (%s v %s) is being heard now in %s.'):format(c.ref or '', c.claimant_name or '', c.defendant_name or '', where), 'warning')
        if s and room and room.centre and room.centre.x then
            TriggerClientEvent('vinewood-moj:client:courtNotice', s, vec3(room.centre.x, room.centre.y, room.centre.z), room.label)
        end
    end
    return { ok = true }
end

function Civil.Adjourn(c, at, reason, a)
    set(c.id, { hearing_open = 0 })
    log(c.id, U.By(a), 'Hearing adjourned. ' .. (reason or ''))
    Webhook.Send('civil', ('Adjourned: %s v %s'):format(c.claimant_name or '', c.defendant_name or ''), reason, { { 'Claim', c.ref }, { 'By', U.By(a) } }, 'purple')
    if at then return Civil.List(Civil.Get(c.id), at, nil, U.By(a)) end
    return { ok = true }
end

function Civil.Judge(c, d, a)
    if Civil.Closed[c.status] or c.status == 'judgment' then return { error = 'This claim has already been decided.' } end
    local forParty = d.forParty == 'defendant' and 'defendant' or 'claimant'
    local amount = forParty == 'claimant' and U.int(d.amount, 0, 100000000) or 0
    local order = U.trim(d.order, 1000)
    if forParty == 'claimant' and amount == 0 and not order then return { error = 'Enter the amount awarded, or the order the court makes.' } end
    giveJudgment(c, forParty, amount, U.int(d.costs, 0, 10000000), order, nil, U.By(a))
    return { ok = true }
end

function Civil.End(c, status, reason, by)
    if Civil.Closed[status] == nil then return { error = 'Unknown outcome.' } end
    if Civil.Closed[c.status] or c.status == 'judgment' then return { error = 'This claim has already been decided.' } end
    set(c.id, { status = status, hearing_open = 0, closed_at = U.now() })
    log(c.id, by, ('%s. %s'):format(Civil.Statuses[status], reason or ''))
    Webhook.Send('civil', ('%s: %s v %s'):format(Civil.Statuses[status], c.claimant_name or '', c.defendant_name or ''), reason, { { 'Claim', c.ref }, { 'By', by } }, 'grey')
    tellParties(c, ('%s: %s.'):format(c.ref or '', Civil.Statuses[status]:lower()))
    return { ok = true }
end

---------------------------------------------------------------------------
-- Paying a judgment (defendant, through /mycase): goes straight to the claimant
---------------------------------------------------------------------------
--- Who owes on a judgment: 'defendant' normally, 'claimant' when they lost and were ordered to pay costs.
function Civil.Payer(c)
    local j = type(c.judgment) == 'table' and c.judgment or U.decode(c.judgment)
    return j.payer or 'defendant'
end

function Civil.Pay(src, c, amount)
    local cid = Bridge.GetCid(src)
    local payer = Civil.Payer(c)
    local payee = payer == 'defendant' and 'claimant' or 'defendant'
    local payerCid, payeeCid = c[payer .. '_cid'], c[payee .. '_cid']
    local payerName = c[payer .. '_name']
    if not Civil.IsParty(c, payer, cid, src) then return { error = 'Only the party ordered to pay can pay this judgment.' } end
    if c.status ~= 'judgment' then return { error = 'There is nothing to pay on this claim.' } end
    local owed = math.max(0, c.total_due - c.paid)
    amount = U.int(amount, 1, owed)
    if amount <= 0 then return { error = 'There is nothing left to pay.' } end
    if c[payer .. '_kind'] == 'business' then
        local ok, err = Business.Remove(payerCid, amount, ('County Court judgment %s'):format(c.ref or ''))
        if not ok then return { error = err or 'The business payment did not go through.' } end
    else
        local account = CV.Account or 'bank'
        if Bridge.GetMoney(src, account) < amount then return { error = ('You need %s in your %s account.'):format(U.money(amount), account) } end
        if not Bridge.RemoveMoney(src, account, amount, ('County Court judgment %s'):format(c.ref or '')) then return { error = 'The payment did not go through.' } end
    end
    local paid = c.paid + amount
    set(c.id, { paid = paid, status = paid >= c.total_due and 'satisfied' or 'judgment', closed_at = paid >= c.total_due and U.now() or nil })
    Civil.Payout(payeeCid, amount, ('Judgment %s from %s'):format(c.ref or '', payerName or 'the other party'), c[payee .. '_kind'])
    log(c.id, payerName or 'Payer', ('Paid %s. %s'):format(U.money(amount), paid >= c.total_due and 'Judgment satisfied.' or ('%s left to pay.'):format(U.money(c.total_due - paid))))
    if paid >= c.total_due and c.ccj then noteParty(c, payer, ('County Court judgment %s satisfied (paid in full).'):format(c.ref or '')) end
    Webhook.Send('civil', ('Judgment payment: %s'):format(c.ref or ''), nil, { { 'Paid', U.money(amount) }, { 'Left', U.money(math.max(0, c.total_due - paid)) } }, 'green')
    return { ok = true, satisfied = paid >= c.total_due }
end

---------------------------------------------------------------------------
-- Lists
---------------------------------------------------------------------------
--- Claims a person is a party to, plus claims for the business they're a boss of (business = job name or nil).
function Civil.ForPerson(cid, business)
    local out = {}
    for _, r in ipairs(MySQL.query.await([[SELECT * FROM vw_moj_civil WHERE
        (claimant_kind = 'person' AND claimant_cid = ?) OR (defendant_kind = 'person' AND defendant_cid = ?)
        OR (? IS NOT NULL AND ((claimant_kind = 'business' AND claimant_cid = ?) OR (defendant_kind = 'business' AND defendant_cid = ?)))
        ORDER BY updated_at DESC LIMIT 40]], { cid, cid, business, business, business }) or {}) do
        local c = decode(r)
        c.log = nil
        local asClaimant = (c.claimant_kind == 'person' and c.claimant_cid == cid) or (c.claimant_kind == 'business' and c.claimant_cid == business)
        c.side = asClaimant and 'claimant' or 'defendant'
        c.forBusiness = c[c.side .. '_kind'] == 'business' and c[c.side .. '_name'] or nil
        out[#out + 1] = c
    end
    return out
end

---------------------------------------------------------------------------
-- Timers: default judgment, and unpaid judgments becoming CCJs
---------------------------------------------------------------------------
CreateThread(function()
    U.WaitReady()
    while true do
        local t = U.now()
        if CV.enabled ~= false and CV.AutoDefaultJudgment then
            for _, r in ipairs(MySQL.query.await("SELECT * FROM vw_moj_civil WHERE status = 'issued' AND response_due < ?", { t }) or {}) do
                local c = decode(r)
                if not c.hearing_open then giveJudgment(c, 'claimant', c.amount, 0, (not money(c.claim_type)) and c.remedy or nil, 'in default of a response', 'County Court') end
            end
        end
        if CV.RegisterCCJ then
            for _, r in ipairs(MySQL.query.await("SELECT * FROM vw_moj_civil WHERE status = 'judgment' AND ccj = 0 AND judgment_due < ?", { t }) or {}) do
                local c = decode(r)
                local payer = Civil.Payer(c)
                local payee = payer == 'defendant' and 'claimant' or 'defendant'
                MySQL.update.await('UPDATE vw_moj_civil SET ccj = 1, updated_at = ? WHERE id = ?', { t, c.id })
                log(c.id, 'County Court', 'Judgment unpaid: registered as a County Court Judgment (CCJ).')
                Webhook.Send('civil', ('CCJ registered: %s'):format(c[payer .. '_name'] or ''), nil, {
                    { 'Claim', c.ref }, { 'Owed to', c[payee .. '_name'] }, { 'Unpaid', U.money(c.total_due - c.paid) },
                }, 'red')
                noteParty(c, payer, ('County Court Judgment registered: %s owed to %s (%s).'):format(U.money(c.total_due - c.paid), c[payee .. '_name'] or '', c.ref or ''))
                tellParty(c[payer .. '_kind'], c[payer .. '_cid'], ('The unpaid judgment %s has been registered as a CCJ.'):format(c.ref or ''), 'error')
                tellParty(c[payee .. '_kind'], c[payee .. '_cid'], ('The judgment %s is unpaid and has been registered as a CCJ.'):format(c.ref or ''))
            end
        end
        Wait(300000)
    end
end)
