-- Court cases: opened from a CPS charge (or by the court), listed, heard, decided, sentenced.
-- Every action works the same whether a judge does it or the auto court does.
Cases = {}

Cases.Statuses = {
    listed = 'Awaiting first hearing', awaiting_trial = 'Awaiting trial', awaiting_sentence = 'Awaiting sentence',
    sentenced = 'Sentenced', acquitted = 'Acquitted', discontinued = 'Discontinued', dismissed = 'Dismissed',
}
Cases.HearingTypes = {
    first = 'First appearance', plea = 'Plea hearing', trial = 'Trial', sentence = 'Sentencing', breach = 'Breach of order', mention = 'Mention',
}
Cases.Custody = { none = 'Not in custody', bail = 'Police bail to court', court_bail = 'Court bail', remand = 'Remanded in custody',
    police_custody = 'In police custody', at_large = 'Failed to appear', custody = 'Serving sentence' }

local CLOSED = { sentenced = true, acquitted = true, discontinued = true, dismissed = true }
Cases.Closed = CLOSED

local function decode(c)
    if not c then return nil end
    c.charges = U.decode(c.charges)
    c.evidence = U.decode(c.evidence)
    c.log = U.decode(c.log)
    c.bail_conditions = U.decode(c.bail_conditions)
    c.exhibits = U.decode(c.exhibits)
    c.statusLabel = Cases.Statuses[c.status] or c.status
    c.custodyLabel = Cases.Custody[c.custody_status] or c.custody_status
    local court = U.court(c.court_id)
    c.courtLabel = court and court.label or c.court_kind
    return c
end
Cases.Decode = decode

function Cases.Get(id) return decode(MySQL.single.await('SELECT * FROM vw_moj_cases WHERE id = ?', { tonumber(id) })) end

function Cases.Hearing(id) return MySQL.single.await('SELECT * FROM vw_moj_hearings WHERE id = ?', { tonumber(id) }) end

function Cases.Hearings(caseId)
    return MySQL.query.await('SELECT * FROM vw_moj_hearings WHERE case_id = ? ORDER BY scheduled_at DESC', { caseId }) or {}
end

function Cases.NextHearing(caseId)
    return MySQL.single.await("SELECT * FROM vw_moj_hearings WHERE case_id = ? AND status IN ('listed', 'open') ORDER BY scheduled_at ASC LIMIT 1", { caseId })
end

local function chargeNames(c, filter)
    local out = {}
    for _, ch in ipairs(c.charges) do
        if not filter or filter(ch) then out[#out + 1] = ch.offence end
    end
    return out
end
Cases.ChargeNames = chargeNames

local function save(c, fields)
    local sets, args = {}, {}
    for k, v in pairs(fields) do
        sets[#sets + 1] = k .. ' = ?'
        if type(v) == 'table' then v = U.encode(v) end
        args[#args + 1] = v
    end
    sets[#sets + 1] = 'updated_at = ?'
    args[#args + 1] = U.now()
    args[#args + 1] = c.id
    MySQL.update.await(('UPDATE vw_moj_cases SET %s WHERE id = ?'):format(table.concat(sets, ', ')), args)
end
Cases.Save = save

-- Indictable-only offences go to the Crown Court; everything else starts in the magistrates'.
local function venueFor(charges)
    for _, name in ipairs(charges) do
        local o = Config.Sentencing.Offences[name]
        if o and o.court == 'indictable' then return 'crown' end
    end
    return 'magistrates'
end

---------------------------------------------------------------------------
-- Opening cases
---------------------------------------------------------------------------
local function create(data)
    local t = U.now()
    local kind = data.courtKind or venueFor(data.charges)
    local court = U.courtFor(kind)
    local charges = {}
    for _, name in ipairs(data.charges) do charges[#charges + 1] = { offence = name } end
    local id = MySQL.insert.await([[INSERT INTO vw_moj_cases (cid, subject_name, court_kind, court_id, cps_id, record_id, custody_ref, charges,
        summary, evidence, prosecutor, officer_name, officer_cid, solicitor_cid, solicitor_name, status, custody_status, bail_conditions, log,
        created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'listed', ?, ?, ?, ?, ?)]],
        { data.cid, data.name, kind, court.id, data.cpsId, data.recordId, data.custodyRef, U.encode(charges), data.summary,
          U.encode(data.evidence or {}), data.prosecutor, data.officer, data.officerCid, data.solicitorCid, data.solicitorName,
          data.custodyStatus or 'none', U.encode(data.bailConditions or {}),
          U.encode({ { at = t, by = data.by or Config.CourtsName, text = data.openedText or 'Case opened.' } }), t, t })
    local ref = ('%s%s/%05d'):format(Config.CaseRefPrefix[kind] or 'C', os.date('%y'), id)
    MySQL.update.await('UPDATE vw_moj_cases SET ref = ? WHERE id = ?', { ref, id })
    Webhook.Send('cases', ('Case opened: %s'):format(data.name or data.cid), table.concat(data.charges, '\n'), {
        { 'Case', ref }, { 'Court', court.label }, { 'Opened by', data.by or Config.CourtsName },
    }, 'blue')
    return id
end

function Cases.FromCps(cpsId)
    local exists = MySQL.scalar.await('SELECT id FROM vw_moj_cases WHERE cps_id = ?', { cpsId })
    if exists then return exists end
    local c = MDT.CpsCase(cpsId)
    if not c or c.status ~= 'charge' then return nil end
    local charges = {}
    for _, x in ipairs(c.charges or {}) do charges[#charges + 1] = type(x) == 'table' and (x.offence or x.label) or tostring(x) end
    if #charges == 0 then return nil end

    local custody = 'police_custody'
    if c.bail then custody = 'bail' end
    local id = create({
        cid = c.cid, name = c.name, charges = charges, cpsId = c.id, recordId = c.recordId, custodyRef = c.custodyRef,
        summary = c.summary, evidence = c.evidence, prosecutor = c.lawyer, officer = c.officer, officerCid = c.officerCid,
        solicitorCid = c.solicitor and c.solicitor.solicitor_cid, solicitorName = c.solicitor and c.solicitor.solicitor_name,
        custodyStatus = custody, bailConditions = c.bail and c.bail.conditions or {},
        by = c.lawyer or 'CPS', openedText = ('Charges authorised by the CPS (%s). Case sent to court.'):format(c.lawyer or 'CPS'),
    })
    local case = Cases.Get(id)
    local earliest = custody == 'bail' and (U.now() + (Config.Listing.FirstHearingHours or 24) * 3600)
        or (U.now() + (Config.Listing.RemandHearingMinutes or 30) * 60)
    Cases.List(case, 'first', earliest)
    return id
end

--- Opened by a clerk, judge or the CPS on the system (no MDT, or a summons).
function Cases.CreateManual(d, a)
    local cid = U.trim(d.cid, 64)
    local p = cid and Bridge.GetPerson(cid)
    if not p then return { error = 'No person with that reference.' } end
    local charges = {}
    for _, x in ipairs(type(d.charges) == 'table' and d.charges or {}) do
        local n = U.trim(x, 120)
        if n then charges[#charges + 1] = n end
    end
    if #charges == 0 then return { error = 'Add at least one charge.' } end
    local id = create({
        cid = cid, name = U.fullName(p), charges = charges, summary = U.trim(d.summary, 4000),
        prosecutor = a.role == 'cps' and a.name or nil, officer = U.trim(d.officer, 96), by = U.By(a),
        courtKind = (d.courtKind == 'crown' or d.courtKind == 'magistrates') and d.courtKind or nil,
        openedText = ('Case opened on the system by %s (summons).'):format(U.By(a)),
    })
    Cases.List(Cases.Get(id), 'first', tonumber(d.at) or (U.now() + (Config.Listing.FirstHearingHours or 24) * 3600))
    return { ok = true, id = id }
end

---------------------------------------------------------------------------
-- Listing
---------------------------------------------------------------------------
function Cases.List(case, htype, earliest, courtId, orderId, exact)
    courtId = courtId or case.court_id
    local at = exact and math.max(tonumber(earliest) or 0, U.now() + 60) or U.NextSlot(courtId, earliest or U.now())
    local id = MySQL.insert.await([[INSERT INTO vw_moj_hearings (case_id, cid, type, court_id, scheduled_at, status, order_id, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, 'listed', ?, ?, ?)]], { case.id, case.cid, htype, courtId, at, orderId, U.now(), U.now() })
    local court = U.court(courtId) or { label = courtId }
    U.Log(case.id, Config.CourtsName, ('%s listed for %s at %s.'):format(Cases.HearingTypes[htype] or htype, U.fmtDate(at), court.label))
    Webhook.Send('cases', ('Listed: %s'):format(case.subject_name or case.cid), nil, {
        { 'Case', case.ref }, { 'Hearing', Cases.HearingTypes[htype] or htype }, { 'When', U.fmtDate(at) }, { 'Court', court.label },
    }, 'blue')
    local src = U.NotifyCid(case.cid, ('Court date (%s): %s at %s, %s. Failing to attend is an offence.'):format(
        case.ref or '', Cases.HearingTypes[htype] or htype, U.fmtDate(at), court.label), 'warning')
    if src and Rooms.CourtCoords(court) then TriggerClientEvent('vinewood-moj:client:courtNotice', src, Rooms.CourtCoords(court), court.label) end
    if case.solicitor_cid then U.NotifyCid(case.solicitor_cid, ('Your client %s is listed: %s, %s.'):format(case.subject_name or '', Cases.HearingTypes[htype] or htype, U.fmtDate(at))) end
    if case.custody_status == 'bail' or case.custody_status == 'court_bail' then
        MDT.CourtBail(case.cid, case.subject_name, case.ref, chargeNames(case), case.bail_conditions, at, court.label)
    end
    -- Where to go on the day: produced at the custody desk, surrender there, or check in at the front desk.
    local probe = { court_id = courtId, court_kind = case.court_kind, custody_status = case.custody_status, charges = case.charges }
    local need = Cases.NeedsProduction(probe)
    local when = os.date('%H:%M on %d/%m', at)
    if need == 'custody' then
        local msg = ('%s (%s) must be produced at the %s custody desk for their %s at %s.'):format(case.subject_name or '', case.ref or '',
            court.label, (Cases.HearingTypes[htype] or htype):lower(), when)
        for _, role in ipairs((Config.CustodyDesk or {}).Roles or {}) do U.NotifyRole(role, msg, 'warning') end
        U.NotifyCid(case.cid, ('You will be taken to the %s custody desk before your hearing.'):format(court.label))
    elseif need == 'serious' then
        U.NotifyCid(case.cid, ('You must surrender at the %s custody desk before %s. Failing to surrender is an offence.'):format(court.label, when), 'error')
    elseif Courts.HasDeskFor(courtId, 'front') then
        U.NotifyCid(case.cid, ('On the day, check in at the %s front desk before %s.'):format(court.label, when))
    end
    return id, at
end

--- Straight back before the court (arrested on warrant, breach).
function Cases.RelistUrgent(caseId, htype, reason)
    local c = Cases.Get(caseId)
    if not c then return end
    MySQL.update.await("UPDATE vw_moj_hearings SET status = 'vacated', result = 'Relisted' WHERE case_id = ? AND status = 'listed'", { c.id })
    if c.custody_status == 'at_large' then save(c, { custody_status = 'police_custody' }) end
    if reason then U.Log(c.id, Config.CourtsName, reason) end
    Cases.List(c, htype or Cases.NextType(c), U.now() + (Config.Listing.RemandHearingMinutes or 30) * 60)
end

function Cases.ListBreach(order, reason)
    local c = Cases.Get(order.case_id)
    if not c then return end
    U.Log(c.id, 'Probation Service', ('Breach of %s %s reported: %s'):format(Orders.Kinds[order.kind] or 'order', order.ref or '', reason))
    Cases.List(c, 'breach', U.now() + (Config.Listing.RemandHearingMinutes or 30) * 60, nil, order.id)
end

function Cases.NextType(c)
    if c.status == 'awaiting_trial' then return 'trial' end
    if c.status == 'awaiting_sentence' then return 'sentence' end
    for _, ch in ipairs(c.charges) do if ch.plea then return 'mention' end end
    return 'first'
end

---------------------------------------------------------------------------
-- Hearing actions. a = access table of whoever does it (nil = auto court).
---------------------------------------------------------------------------
local function by(a) return a and U.By(a) or 'Auto court' end

function Cases.OpenHearing(h, a)
    MySQL.update.await("UPDATE vw_moj_hearings SET status = 'open', judge_name = ?, judge_cid = ?, auto = ?, updated_at = ? WHERE id = ?",
        { a and a.name or 'Auto court', a and a.cid, a and 0 or 1, U.now(), h.id })
    U.Log(h.case_id, by(a), ('%s opened.'):format(Cases.HearingTypes[h.type] or h.type))
    local c = MySQL.single.await('SELECT ref, subject_name FROM vw_moj_cases WHERE id = ?', { h.case_id }) or {}
    Webhook.Send('cases', ('Hearing opened: %s'):format(c.subject_name or h.cid), nil, {
        { 'Case', c.ref }, { 'Hearing', Cases.HearingTypes[h.type] or h.type }, { 'Before', by(a) },
    }, a and 'blue' or 'grey')
end

function Cases.CloseHearing(h, result, status)
    MySQL.update.await('UPDATE vw_moj_hearings SET status = ?, result = ?, updated_at = ? WHERE id = ?', { status or 'done', result, U.now(), h.id })
end

--- Defendant did not attend.
function Cases.FailedToAppear(h, a)
    local c = Cases.Get(h.case_id)
    Cases.CloseHearing(h, 'Defendant failed to appear. Warrant issued.', 'fta')
    save(c, { custody_status = 'at_large' })
    MDT.EndBail(c.cid, 'breached')
    Warrants.Issue(c.cid, c.subject_name, c.id, 'fta', ('Failed to attend %s at %s on %s (%s).'):format(
        Cases.HearingTypes[h.type] or h.type, c.courtLabel, U.fmtDate(h.scheduled_at), c.ref), by(a))
    Webhook.Send('cases', ('Failed to appear: %s'):format(c.subject_name or c.cid), nil, { { 'Case', c.ref } }, 'red')
end

local function stageFor(htype)
    if htype == 'first' then return 'first' end
    if htype == 'trial' then return 'trial' end
    return 'later'
end

--- pleas: { [index] = 'guilty' | 'not_guilty' } for charges without a plea yet.
function Cases.Plea(h, pleas, a)
    local c = Cases.Get(h.case_id)
    local entered, anyNG, lines = 0, false, {}
    for i, ch in ipairs(c.charges) do
        local p = pleas[i] or pleas[tostring(i)]
        if not ch.plea and not ch.verdict and (p == 'guilty' or p == 'not_guilty') then
            ch.plea = p
            ch.pleaStage = stageFor(h.type)
            if p == 'guilty' then ch.verdict = 'guilty' end
            entered = entered + 1
            lines[#lines + 1] = ('%s: %s'):format(ch.offence, p == 'guilty' and 'Guilty' or 'Not guilty')
        end
        if ch.plea == 'not_guilty' and not ch.verdict then anyNG = true end
    end
    if entered == 0 then return { error = 'Enter a plea to at least one charge.' } end
    local status = anyNG and 'awaiting_trial' or 'awaiting_sentence'
    local stage = c.plea_stage or stageFor(h.type)
    save(c, { charges = c.charges, status = status, plea_stage = stage })
    U.Log(c.id, by(a), 'Pleas entered. ' .. table.concat(lines, '; '))
    Webhook.Send('cases', ('Pleas: %s'):format(c.subject_name or c.cid), table.concat(lines, '\n'), { { 'Case', c.ref } }, 'blue')
    return { ok = true, status = status }
end

--- verdicts: { [index] = 'guilty' | 'not_guilty' } for charges pleaded not guilty.
function Cases.Verdict(h, verdicts, a)
    local c = Cases.Get(h.case_id)
    local lines, given = {}, 0
    for i, ch in ipairs(c.charges) do
        local v = verdicts[i] or verdicts[tostring(i)]
        if ch.plea == 'not_guilty' and not ch.verdict and (v == 'guilty' or v == 'not_guilty') then
            ch.verdict = v
            given = given + 1
            lines[#lines + 1] = ('%s: %s'):format(ch.offence, v == 'guilty' and 'Guilty' or 'Not guilty')
        end
    end
    if given == 0 then return { error = 'Record a verdict on at least one charge.' } end
    local pending, convicted = false, false
    for _, ch in ipairs(c.charges) do
        if ch.plea == 'not_guilty' and not ch.verdict then pending = true end
        if ch.verdict == 'guilty' then convicted = true end
    end
    local status = pending and 'awaiting_trial' or (convicted and 'awaiting_sentence' or 'acquitted')
    save(c, { charges = c.charges, status = status, closed_at = status == 'acquitted' and U.now() or nil })
    U.Log(c.id, by(a), 'Verdicts. ' .. table.concat(lines, '; '))
    Webhook.Send('cases', ('Verdicts: %s'):format(c.subject_name or c.cid), table.concat(lines, '\n'), { { 'Case', c.ref }, { 'By', by(a) } },
        status == 'acquitted' and 'green' or 'amber')
    if status == 'acquitted' then Cases.Finish(c, 'acquitted', by(a)) end
    return { ok = true, status = status }
end

--- Case over without a sentence: acquitted, discontinued, dismissed.
function Cases.Finish(c, status, who)
    save(c, { status = status, custody_status = 'none', closed_at = U.now() })
    MySQL.update.await("UPDATE vw_moj_hearings SET status = 'vacated', result = 'Case concluded' WHERE case_id = ? AND status = 'listed'", { c.id })
    Prison.EndRemand(c.cid, ('Case %s'):format(Cases.Statuses[status] or status))
    Warrants.CloseFor(c.cid, 'fta', c.id, 'cancelled', who)
    MDT.EndBail(c.cid, 'answered')
    MDT.Note(c.cid, ('Court result %s: %s.'):format(c.ref or '', Cases.Statuses[status] or status))
    U.NotifyCid(c.cid, ('Your case %s has ended: %s.'):format(c.ref or '', (Cases.Statuses[status] or status):lower()), 'success')
    if c.officer_cid then U.NotifyCid(c.officer_cid, ('Court result for %s (%s): %s.'):format(c.subject_name or '', c.ref or '', Cases.Statuses[status] or status)) end
    Webhook.Send('cases', ('%s: %s'):format(Cases.Statuses[status] or status, c.subject_name or c.cid), nil, { { 'Case', c.ref }, { 'By', who } }, 'green')
end

--- CPS drops one charge or the whole case.
function Cases.Withdraw(c, index, reason, a)
    if CLOSED[c.status] then return { error = 'This case has concluded.' } end
    if index then
        local ch = c.charges[index]
        if not ch or ch.verdict then return { error = 'That charge cannot be withdrawn.' } end
        ch.verdict = 'withdrawn'
        local left = false
        for _, x in ipairs(c.charges) do if x.verdict ~= 'withdrawn' and x.verdict ~= 'not_guilty' then left = true end end
        save(c, { charges = c.charges })
        U.Log(c.id, U.By(a), ('Charge withdrawn: %s. %s'):format(ch.offence, reason or ''))
        Webhook.Send('cases', ('Charge withdrawn: %s'):format(c.subject_name or c.cid), reason, { { 'Case', c.ref }, { 'Charge', ch.offence }, { 'By', U.By(a) } }, 'grey')
        if not left then Cases.Finish(c, 'discontinued', U.By(a)) end
        return { ok = true }
    end
    U.Log(c.id, U.By(a), 'Case discontinued: ' .. (reason or ''))
    Cases.Finish(c, 'discontinued', U.By(a))
    return { ok = true }
end

--- Bail decision. decision: 'unconditional', 'conditional', 'remand'
function Cases.BailDecision(c, decision, conditions, a)
    if decision == 'remand' then
        save(c, { custody_status = 'remand', bail_conditions = {} })
        MDT.EndBail(c.cid, 'answered')
        Prison.Receive(c.cid, c.subject_name, c.id, nil, 'remand', 0, ('Remanded by %s (%s)'):format(by(a), c.ref))
        U.Log(c.id, by(a), 'Remanded in custody.')
        Webhook.Send('cases', ('Remanded in custody: %s'):format(c.subject_name or c.cid), nil, { { 'Case', c.ref }, { 'By', by(a) } }, 'red')
        return { ok = true }
    end
    local list = {}
    if decision == 'conditional' then
        local valid = {}
        for _, bc in ipairs(Config.BailConditions) do valid[bc.id] = bc end
        for _, x in ipairs(type(conditions) == 'table' and conditions or {}) do
            local def = valid[x.id]
            if def then list[#list + 1] = { id = def.id, label = def.label, value = def.input and U.trim(x.value, 120) or nil } end
        end
        if #list == 0 then return { error = 'Choose the bail conditions, or grant unconditional bail.' } end
    end
    save(c, { custody_status = 'court_bail', bail_conditions = list })
    c.custody_status, c.bail_conditions = 'court_bail', list
    Prison.EndRemand(c.cid, 'Granted court bail')
    local next = Cases.NextHearing(c.id)
    local court = U.court(c.court_id)
    MDT.CourtBail(c.cid, c.subject_name, c.ref, chargeNames(c), list, next and next.scheduled_at or nil, court and court.label or '')
    local text = #list > 0 and ('Conditional bail: ' .. table.concat((function()
        local t = {}
        for _, x in ipairs(list) do t[#t + 1] = x.label .. (x.value and (' ' .. x.value) or '') end
        return t
    end)(), '; ')) or 'Unconditional bail.'
    U.Log(c.id, by(a), text)
    Webhook.Send('cases', ('Court bail: %s'):format(c.subject_name or c.cid), text, { { 'Case', c.ref }, { 'By', by(a) } }, 'amber')
    U.NotifyCid(c.cid, ('Court bail granted (%s). %s'):format(c.ref or '', text))
    return { ok = true }
end

function Cases.Adjourn(h, htype, at, reason, a)
    local c = Cases.Get(h.case_id)
    Cases.CloseHearing(h, ('Adjourned: %s'):format(reason or 'no reason given'), 'adjourned')
    save(c, { adjournments = (c.adjournments or 0) + 1 })
    U.Log(c.id, by(a), ('Adjourned. %s'):format(reason or ''))
    Webhook.Send('cases', ('Adjourned: %s'):format(c.subject_name or c.cid), reason, { { 'Case', c.ref }, { 'Next', Cases.HearingTypes[htype or ''] or htype }, { 'By', by(a) } }, 'purple')
    local exact = tonumber(at) ~= nil
    local earliest = tonumber(at)
    if not earliest then
        local hours = htype == 'trial' and (Config.Listing.TrialHours or 48) or (Config.Listing.SentenceHours or 0)
        earliest = U.now() + math.max(hours * 3600, 600)
    end
    return Cases.List(c, htype or Cases.NextType(c), earliest, nil, h.order_id, exact)
end

--- Sentence on the open hearing. components from the judge (or the auto court's guide).
function Cases.Sentence(h, components, a)
    local c = Cases.Get(h.case_id)
    if c.status ~= 'awaiting_sentence' and not (h.type == 'breach' and components.resentence) then
        return { error = 'There is nothing to sentence on this case yet.' }
    end
    local valid, err = Sentence.Validate(components)
    if not valid then return { error = err } end
    if c.court_kind == 'magistrates' and valid.outcome == 'custody' and valid.custodyMonths > (Config.Sentencing.MagistratesMaxMonths or 12) then
        save(c, { court_kind = 'crown', court_id = U.courtFor('crown').id })
        U.Log(c.id, by(a), 'Committed to the Crown Court for sentence.')
        c = Cases.Get(c.id)
    end
    local _, summary, notes = Sentence.Apply(c, valid, by(a), a == nil)
    Cases.CloseHearing(h, 'Sentenced: ' .. summary)
    return { ok = true, summary = summary, notes = notes }
end

--- Breach hearing outcome. action: 'extra_hours', 'activate', 'resentence', 'revoke_only', 'no_action'
function Cases.Breach(h, action, hours, components, a)
    local o = h.order_id and Orders.Get(h.order_id)
    if not o then return { error = 'The order for this breach was not found.' } end
    local c = Cases.Get(h.case_id)
    if action == 'no_action' then
        MySQL.update.await("UPDATE vw_moj_orders SET status = 'active', warnings = 0, updated_at = ? WHERE id = ?", { U.now(), o.id })
        U.OrderLog(o.id, by(a), 'Breach not proved / no action. Order continues.')
        Cases.CloseHearing(h, 'Breach: no action, order continues.')
        return { ok = true }
    end
    if action == 'resentence' then
        Orders.DealWithBreach(o, 'revoke_only', by(a))
        components.resentence = true
        local r = Cases.Sentence(h, components, a)
        if r.ok then U.Log(c.id, by(a), 'Order revoked on breach and resentenced.') end
        return r
    end
    local text = Orders.DealWithBreach(o, action, by(a), hours)
    U.Log(c.id, by(a), ('Breach of %s: %s.'):format(o.kindLabel, text))
    MDT.Note(c.cid, ('Breach of %s (%s): %s.'):format(o.kindLabel, c.ref or '', text))
    U.NotifyCid(c.cid, ('Breach of your %s: %s.'):format(o.kindLabel:lower(), text), 'error')
    Cases.CloseHearing(h, 'Breach: ' .. text)
    return { ok = true }
end

---------------------------------------------------------------------------
-- Lists
---------------------------------------------------------------------------
function Cases.ForPerson(cid)
    local out = {}
    for _, r in ipairs(MySQL.query.await('SELECT * FROM vw_moj_cases WHERE cid = ? ORDER BY created_at DESC LIMIT 30', { cid }) or {}) do
        local c = decode(r)
        c.next = Cases.NextHearing(c.id)
        c.log = nil
        out[#out + 1] = c
    end
    return out
end

--- Plea credit for sentencing: the latest stage any convicted charge was admitted at.
function Cases.PleaId(c)
    local order = { first = 1, later = 2, trial = 3, notguilty = 4 }
    local worst = 'first'
    for _, ch in ipairs(c.charges) do
        if ch.verdict == 'guilty' then
            local p = ch.plea == 'guilty' and (ch.pleaStage or 'later') or 'notguilty'
            if order[p] > order[worst] then worst = p end
        end
    end
    return worst
end

function Cases.Convicted(c)
    return chargeNames(c, function(ch) return ch.verdict == 'guilty' end)
end

---------------------------------------------------------------------------
-- Court custody desk: who has to be produced and booked in before their hearing
---------------------------------------------------------------------------
local function isSerious(c)
    if c.court_kind == 'crown' then return true end
    for _, ch in ipairs(c.charges or {}) do
        local o = Config.Sentencing.Offences[ch.offence]
        if o and o.court == 'indictable' and ch.verdict ~= 'withdrawn' then return true end
    end
    return false
end

--- 'custody' (police custody or remand: must be produced), 'serious' (on bail: must surrender), or nil.
--- What the rules say, whether or not the court has a desk: 'custody', 'serious' or nil.
function Cases.ProductionRule(c)
    local CD = Config.CustodyDesk or {}
    if CD.enabled == false or not c then return nil end
    if (CD.RequireFor or {})[c.custody_status] then return 'custody' end
    if CD.Serious and isSerious(c) and c.custody_status ~= 'custody' then return 'serious' end
    return nil
end

--- 'custody' (police custody or remand: must be produced), 'serious' (on bail: must surrender), or nil.
--- Only where the court has a custody desk to book them in at (its own, or one that serves it).
function Cases.NeedsProduction(c)
    if not c or not Rooms.HasDesk(c.court_id) then return nil end
    return Cases.ProductionRule(c)
end

Cases.ProductionLabels = {
    custody = 'Must be produced from custody',
    serious = 'Must surrender at the court custody desk',
}
