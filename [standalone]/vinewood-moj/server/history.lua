-- A defendant's history for the court: previous court cases and sentences, live orders, custody,
-- warrants, money owed and CCJs from the MoJ, plus arrests and charges from the MDT when it's running.
History = {}

local function names(list)
    local out = {}
    for _, o in ipairs(type(list) == 'table' and list or {}) do
        local n = type(o) == 'table' and (o.offence or o.label or o.name) or o
        if n then out[#out + 1] = tostring(n) end
    end
    return out
end

--- cid's history, leaving out the case being viewed (exceptCase) from the court cases.
function History.For(cid, exceptCase, exceptRecord)
    local h = { cases = {}, records = {}, warrants = {}, orders = {}, ccjs = {} }

    -- Court cases and their outcomes
    for _, c in ipairs(MySQL.query.await([[SELECT id, ref, court_id, status, charges, created_at, closed_at FROM vw_moj_cases
        WHERE cid = ? AND id <> ? ORDER BY created_at DESC LIMIT 30]], { cid, exceptCase or 0 }) or {}) do
        local charges = U.decode(c.charges)
        local convicted = {}
        for _, ch in ipairs(charges) do if ch.verdict == 'guilty' then convicted[#convicted + 1] = ch.offence end end
        local s = MySQL.single.await('SELECT summary, passed_by, auto, created_at FROM vw_moj_sentences WHERE case_id = ? ORDER BY created_at DESC LIMIT 1', { c.id })
        local court = U.court(c.court_id)
        h.cases[#h.cases + 1] = {
            id = c.id, ref = c.ref, court = court and court.label or '', status = c.status, statusLabel = Cases.Statuses[c.status] or c.status,
            charges = names(charges), convicted = convicted, sentence = s and s.summary, sentencedBy = s and (U.flag(s.auto) and 'Auto court' or s.passed_by),
            at = c.closed_at or c.created_at,
        }
    end
    h.previous = Sentence.Previous(cid, exceptCase)

    -- Now
    local custody = Prison.Active(cid)
    if custody then h.custody = { kind = Prison.Kinds[custody.kind], since = custody.created_at } end
    for _, o in ipairs(Orders.Active(cid)) do
        local req = {}
        for _, r in ipairs(o.requirements or {}) do req[#req + 1] = r.label end
        h.orders[#h.orders + 1] = { ref = o.ref, kind = o.kindLabel, requirements = req, hours = o.hours_required, done = o.hours_done,
            ends = o.ends_at, warnings = o.warnings, officer = o.officer_name }
    end
    for _, w in ipairs(Warrants.Active(cid)) do
        h.warrants[#h.warrants + 1] = { type = Warrants.Labels[w.type] or w.type, reason = w.reason, at = w.created_at, by = w.issued_by }
    end
    h.finesOwed = Fines.Outstanding(cid)
    for _, c in ipairs(MySQL.query.await([[SELECT ref, claimant_name, total_due, paid, created_at FROM vw_moj_civil
        WHERE defendant_kind = 'person' AND defendant_cid = ? AND ccj = 1 AND status = 'judgment']], { cid }) or {}) do
        h.ccjs[#h.ccjs + 1] = { ref = c.ref, to = c.claimant_name, owed = (c.total_due or 0) - (c.paid or 0) }
    end

    -- Police records (MDT)
    if MDT.Running() and Schema.Has('vw_mdt_records', 'cid', 'offences', 'outcome') then
        for _, r in ipairs(MySQL.query.await([[SELECT id, ref, type, offences, outcome, officer_name, created_at FROM vw_mdt_records
            WHERE cid = ? ORDER BY created_at DESC LIMIT 40]], { cid }) or {}) do
            h.records[#h.records + 1] = { ref = r.ref, type = r.type, offences = names(U.decode(r.offences)), outcome = r.outcome,
                officer = r.officer_name, at = r.created_at, thisCase = r.id == exceptRecord }
        end
        -- MDT warrants the court didn't issue (court ones are listed above already)
        if Schema.Has('vw_mdt_warrants', 'cid', 'status') then
            for _, w in ipairs(MySQL.query.await([[SELECT type, reason, created_at, issued_by FROM vw_mdt_warrants
                WHERE cid = ? AND status = 'active' AND (issued_by IS NULL OR issued_by <> ?)]], { cid, Config.CourtsName }) or {}) do
                h.warrants[#h.warrants + 1] = { type = 'Police warrant (' .. tostring(w.type) .. ')', reason = w.reason, at = w.created_at, by = w.issued_by }
            end
        end
    end
    return h
end
