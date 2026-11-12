-- Requests from the system UI, the public portal, unpaid work and exports for other resources.
local H = {}

-- Who can call what. Roles not listed for an action get "You can't do that."
local ALL_STAFF = { judge = true, clerk = true, cps = true, defence = true, probation = true, prison = true, police = true }
local COURT = { judge = true, clerk = true }
local PERMS = {
    init = ALL_STAFF, dashboard = ALL_STAFF, courtList = { judge = true, clerk = true, cps = true, defence = true, police = true },
    searchCases = { judge = true, clerk = true, cps = true, defence = true, police = true, probation = true },
    getCase = { judge = true, clerk = true, cps = true, defence = true, police = true, probation = true },
    searchPeople = { judge = true, clerk = true, cps = true },
    createCase = { judge = true, clerk = true, cps = true },
    listHearing = COURT, vacateHearing = COURT, assignSolicitor = COURT,
    openHearing = { judge = true }, appearance = { judge = true }, plea = { judge = true }, verdict = { judge = true },
    bail = { judge = true }, adjourn = { judge = true }, concludeHearing = { judge = true }, sentence = { judge = true }, breach = { judge = true },
    guide = { judge = true, clerk = true, cps = true, defence = true },
    withdraw = { cps = true }, caseNote = { judge = true, clerk = true, cps = true },
    warrants = ALL_STAFF, cancelWarrant = { judge = true, clerk = true }, executeWarrant = { judge = true, clerk = true, police = true, prison = true },
    prisonRoll = { judge = true, clerk = true, prison = true, police = true, probation = true },
    releasePrisoner = { judge = true, prison = true },
    caseload = { probation = true, judge = true }, getOrder = { probation = true, judge = true },
    takeOrder = { probation = true }, bookAppointment = { probation = true }, markAppointment = { probation = true },
    warnOrder = { probation = true }, breachOrder = { probation = true }, setLocation = { probation = true },
    orderNote = { probation = true }, creditHours = { probation = true }, completeOrder = { probation = true, judge = true },
    fines = COURT, writeOffFine = { judge = true },
    custodyBoard = { police = true, prison = true, clerk = true, judge = true }, bookIn = { police = true, prison = true, clerk = true },
    paVolume = { judge = true, clerk = true },
    frontBoard = { clerk = true, judge = true }, frontCheckIn = { clerk = true, judge = true },
    civilList = { judge = true, clerk = true, defence = true }, civilGet = { judge = true, clerk = true, defence = true },
    civilIssue = { defence = true }, civilRespond = { defence = true }, civilNote = { judge = true, clerk = true, defence = true },
    civilListHearing = COURT, civilAssign = COURT, civilOpen = { judge = true }, civilJudge = { judge = true },
    civilAdjourn = { judge = true }, civilEnd = { judge = true, defence = true }, civilDefault = { judge = true, defence = true },
    civilSettle = { defence = true }, civilSettleAnswer = { defence = true },
    civilFee = { defence = true }, searchParties = { judge = true, clerk = true, defence = true },
    screenStatus = { judge = true, clerk = true, cps = true, defence = true },
    screenPlay = { judge = true, clerk = true, cps = true, defence = true },
    screenStop = { judge = true, clerk = true, cps = true, defence = true },
    screenRestart = { judge = true, clerk = true, cps = true, defence = true },
    addExhibit = { judge = true, clerk = true, cps = true, defence = true },
    removeExhibit = { judge = true, clerk = true, cps = true, defence = true },
}

local function need(cond, msg) if not cond then error({ user = msg }, 0) end end

-- Defence solicitors only ever see their own clients' cases.
local function canSeeCase(a, c)
    if a.role ~= 'defence' then return true end
    return c.solicitor_cid ~= nil and c.solicitor_cid == a.cid
end

local function openHearingFor(id, a)
    local h = Cases.Hearing(id)
    need(h, 'Hearing not found.')
    need(h.status == 'open', 'Open the hearing first.')
    need(not U.flag(h.auto), 'The auto court is dealing with this hearing.')
    return h
end

---------------------------------------------------------------------------
-- General
---------------------------------------------------------------------------
H.init = function(src, a)
    local offences = {}
    for name, o in pairs(Config.Sentencing.Offences) do offences[#offences + 1] = { name = name, court = o.court } end
    table.sort(offences, function(x, y) return x.name < y.name end)
    local room = Rooms.LaptopRoom(src)
    return {
        me = { name = a.name, role = a.role, label = a.label, supervisor = a.supervisor, cid = a.cid },
        room = room and { id = room.id, label = room.label, screens = Rooms.HasScreens(room), volume = room.pa_volume or 1.0,
            canVolume = (function()
                for _, role in ipairs((Config.Courtrooms or {}).VolumeRoles or { 'judge', 'clerk' }) do if role == a.role then return true end end
                return false
            end)() } or nil,
        cfg = {
            serviceName = Config.ServiceName, courtsName = Config.CourtsName, crest = Config.Crest, currency = Config.Fines.Currency,
            courts = Config.Courts, hearingTypes = Cases.HearingTypes, statuses = Cases.Statuses, custody = Cases.Custody,
            outcomes = Sentence.Outcomes, bailConditions = Config.BailConditions, zones = Config.Probation.ExclusionZones,
            aggravating = Config.Sentencing.Aggravating, mitigating = Config.Sentencing.Mitigating, pleas = Config.Sentencing.Pleas,
            offences = offences, warrantTypes = Warrants.Labels, orderKinds = Orders.Kinds, prisonKinds = Prison.Kinds,
            suspendUpTo = Config.Sentencing.SuspendUpTo, suspendDays = Config.Sentencing.SuspendOperationalDays,
            civil = (Config.Civil or {}).enabled ~= false, civilTypes = (Config.Civil or {}).Types, civilStatuses = Civil.Statuses,
            civilOpenRoles = (Config.Civil or {}).OpenRoles, civilCourt = Courts.CivilDefault(),
            rooms = (function()
                local out = {}
                for _, r in ipairs(Rooms.Public()) do out[#out + 1] = { id = r.id, label = r.label, court_id = r.court_id } end
                return out
            end)(),
            businesses = (Config.Civil or {}).Businesses == true,
            office = Config.Probation.Office.label, warnLimit = Config.Probation.WarningsBeforeBreach, autoCourt = Config.AutoCourt.enabled, mdt = MDT.Running(),
        },
        serverTime = U.now(),
    }
end

H.dashboard = function(_, a)
    local dayStart = os.time({ year = tonumber(os.date('%Y')), month = tonumber(os.date('%m')), day = tonumber(os.date('%d')), hour = 0 })
    local count = function(sql, args) return MySQL.scalar.await(sql, args or {}) or 0 end
    local out = {
        stats = {
            today = count("SELECT COUNT(*) FROM vw_moj_hearings WHERE status IN ('listed', 'open') AND scheduled_at BETWEEN ? AND ?", { dayStart, dayStart + 86400 }),
            overdue = count("SELECT COUNT(*) FROM vw_moj_hearings WHERE status = 'listed' AND scheduled_at < ?", { U.now() - (Config.AutoCourt.GraceMinutes or 10) * 60 }),
            open = count("SELECT COUNT(*) FROM vw_moj_cases WHERE status IN ('listed', 'awaiting_trial', 'awaiting_sentence')"),
            warrants = count("SELECT COUNT(*) FROM vw_moj_warrants WHERE status = 'active'"),
            prisoners = count("SELECT COUNT(*) FROM vw_moj_custody WHERE status = 'active'"),
            orders = count("SELECT COUNT(*) FROM vw_moj_orders WHERE status = 'active'"),
        },
    }
    out.list = H.courtList(_, a, { from = U.now() - 3 * 3600, to = dayStart + 2 * 86400, limit = 15 }).results
    if a.role == 'probation' then
        out.myOrders = MySQL.query.await("SELECT id, ref, subject_name, kind, hours_required, hours_done, warnings FROM vw_moj_orders WHERE status = 'active' AND officer_cid = ? ORDER BY updated_at DESC LIMIT 10", { a.cid }) or {}
        out.unassigned = count("SELECT COUNT(*) FROM vw_moj_orders WHERE status = 'active' AND officer_cid IS NULL")
    end
    return out
end

H.courtList = function(_, a, d)
    local from = tonumber(d.from) or (U.now() - 6 * 3600)
    local to = tonumber(d.to) or (from + 3 * 86400)
    local where, args = { "h.status IN ('listed', 'open')", 'h.scheduled_at BETWEEN ? AND ?' }, { from, to }
    if d.courtId and d.courtId ~= '' then where[#where + 1] = 'h.court_id = ?'; args[#args + 1] = d.courtId end
    if a.role == 'defence' then where[#where + 1] = 'c.solicitor_cid = ?'; args[#args + 1] = a.cid end
    args[#args + 1] = math.min(tonumber(d.limit) or 100, 200)
    local rows = MySQL.query.await(([[SELECT h.*, c.ref, c.subject_name, c.status AS case_status, c.custody_status, c.charges
        FROM vw_moj_hearings h JOIN vw_moj_cases c ON c.id = h.case_id WHERE %s ORDER BY h.scheduled_at ASC LIMIT ?]]):format(table.concat(where, ' AND ')), args) or {}
    for _, r in ipairs(rows) do
        r.charges = U.decode(r.charges)
        r.online = Bridge.GetSource(r.cid) ~= nil
    end
    return { results = rows, serverTime = U.now() }
end

H.searchCases = function(_, a, d)
    local q = U.trim(d.q, 64)
    local where, args = {}, {}
    if q then
        where[#where + 1] = '(ref LIKE ? OR subject_name LIKE ? OR cid = ? OR custody_ref = ?)'
        args = { '%' .. q .. '%', '%' .. q .. '%', q, q }
    end
    if d.status == 'open' then where[#where + 1] = "status IN ('listed', 'awaiting_trial', 'awaiting_sentence')"
    elseif d.status == 'closed' then where[#where + 1] = "status IN ('sentenced', 'acquitted', 'discontinued', 'dismissed')" end
    if a.role == 'defence' then where[#where + 1] = 'solicitor_cid = ?'; args[#args + 1] = a.cid end
    local sql = 'SELECT id, ref, cid, subject_name, court_kind, status, custody_status, charges, updated_at FROM vw_moj_cases'
        .. (#where > 0 and (' WHERE ' .. table.concat(where, ' AND ')) or '') .. ' ORDER BY updated_at DESC LIMIT 60'
    local rows = MySQL.query.await(sql, args) or {}
    for _, r in ipairs(rows) do r.charges = U.decode(r.charges) end
    return { results = rows }
end

H.getCase = function(_, a, d)
    local c = Cases.Get(d.id)
    need(c, 'Case not found.')
    need(canSeeCase(a, c), 'You can only see cases for clients assigned to you.')
    c.hearings = Cases.Hearings(c.id)
    c.sentences = MySQL.query.await('SELECT * FROM vw_moj_sentences WHERE case_id = ? ORDER BY created_at DESC', { c.id }) or {}
    for _, s in ipairs(c.sentences) do s.components = U.decode(s.components) end
    c.fines = MySQL.query.await('SELECT * FROM vw_moj_fines WHERE case_id = ? ORDER BY created_at DESC', { c.id }) or {}
    c.orders = {}
    for _, o in ipairs(MySQL.query.await('SELECT * FROM vw_moj_orders WHERE case_id = ? ORDER BY created_at DESC', { c.id }) or {}) do
        c.orders[#c.orders + 1] = Orders.Decode(o)
    end
    c.warrants = MySQL.query.await('SELECT * FROM vw_moj_warrants WHERE case_id = ? ORDER BY created_at DESC', { c.id }) or {}
    c.custodyNow = Prison.Active(c.cid)
    c.production = Cases.NeedsProduction(c)
    c.productionLabel = c.production and Cases.ProductionLabels[c.production] or nil
    -- Should be produced, but the court has no custody desk to do it at.
    local rule = Cases.ProductionRule(c)
    c.noDesk = rule ~= nil and c.production == nil and not Cases.Closed[c.status] and (Config.CustodyDesk or {}).enabled ~= false
    c.online = Bridge.GetSource(c.cid) ~= nil
    if a.role ~= 'police' then c.statements = MDT.Statements(c.record_id) end
    if c.status == 'awaiting_sentence' and a.role ~= 'police' then
        c.guide = Sentence.Guide(Cases.Convicted(c), { previous = Sentence.Previous(c.cid, c.id), plea = Cases.PleaId(c), courtKind = c.court_kind })
    end
    c.history = History.For(c.cid, c.id, c.record_id)
    c.interviews = Interviews.ForCase(c)
    if a.role == 'police' then c.log, c.evidence = nil, nil end
    return { case = c, serverTime = U.now() }
end

H.searchPeople = function(_, _, d)
    local out = {}
    for _, p in ipairs(Bridge.SearchPeople(tostring(d.q or ''), 10)) do
        out[#out + 1] = { cid = p.cid, name = U.fullName(p), dob = p.dob }
    end
    return { results = out }
end

H.createCase = function(_, a, d) return Cases.CreateManual(d, a) end

H.caseNote = function(_, a, d)
    local c = Cases.Get(d.id)
    need(c, 'Case not found.')
    local text = U.trim(d.text, 1000)
    need(text, 'Write the note.')
    U.Log(c.id, U.By(a), text)
    return { ok = true }
end

H.assignSolicitor = function(_, a, d)
    local c = Cases.Get(d.id)
    need(c, 'Case not found.')
    local cid = U.trim(d.cid, 64)
    if not cid then
        Cases.Save(c, { solicitor_cid = nil, solicitor_name = nil })
        MySQL.update.await('UPDATE vw_moj_cases SET solicitor_cid = NULL, solicitor_name = NULL WHERE id = ?', { c.id })
        U.Log(c.id, U.By(a), 'Defence solicitor removed.')
        return { ok = true }
    end
    local name = U.nameOf(cid)
    Cases.Save(c, { solicitor_cid = cid, solicitor_name = name })
    U.Log(c.id, U.By(a), ('Defence solicitor: %s.'):format(name))
    Webhook.Send('cases', ('Solicitor assigned: %s'):format(c.subject_name or c.cid), nil, { { 'Case', c.ref }, { 'Solicitor', name }, { 'By', U.By(a) } }, 'grey')
    U.NotifyCid(cid, ('You have been assigned to %s (%s).'):format(c.subject_name or '', c.ref or ''))
    return { ok = true }
end

---------------------------------------------------------------------------
-- Listing and hearings
---------------------------------------------------------------------------
H.listHearing = function(_, a, d)
    local c = Cases.Get(d.id)
    need(c, 'Case not found.')
    need(not Cases.Closed[c.status] or d.type == 'breach', 'This case has concluded.')
    need(Cases.HearingTypes[d.type], 'Choose the hearing type.')
    local at = tonumber(d.at)
    need(at and at > U.now(), 'Pick a date and time in the future.')
    local courtId = U.court(d.courtId) and d.courtId or c.court_id
    local hid = Cases.List(c, d.type, at, courtId, nil, true)
    -- Optional courtroom, shown on listing boards. Must belong to the court it's listed at.
    local room = d.roomId and Rooms.Get(d.roomId)
    if room and room.court_id == courtId then MySQL.update.await('UPDATE vw_moj_hearings SET room_id = ? WHERE id = ?', { room.id, hid }) end
    return { ok = true }
end

H.vacateHearing = function(_, a, d)
    local h = Cases.Hearing(d.id)
    need(h and h.status == 'listed', 'This hearing is not listed.')
    Cases.CloseHearing(h, 'Vacated: ' .. (U.trim(d.reason, 200) or 'no reason given'), 'vacated')
    U.Log(h.case_id, U.By(a), ('%s on %s vacated.'):format(Cases.HearingTypes[h.type] or h.type, U.fmtDate(h.scheduled_at)))
    Webhook.Send('cases', 'Hearing vacated', d.reason, { { 'Hearing', ('%s on %s'):format(Cases.HearingTypes[h.type] or h.type, U.fmtDate(h.scheduled_at)) }, { 'By', U.By(a) } }, 'grey')
    return { ok = true }
end

H.openHearing = function(src, a, d)
    local h = Cases.Hearing(d.id)
    need(h and h.status == 'listed', 'This hearing is not waiting to be heard.')
    Cases.OpenHearing(h, a)
    local c = Cases.Get(h.case_id)
    -- Opened from a courtroom laptop: that's the room it's in (listing boards show it).
    local here = Rooms.LaptopRoom(src)
    if here then MySQL.update.await('UPDATE vw_moj_hearings SET room_id = ? WHERE id = ?', { here.id, h.id }) end
    -- Opened from a courtroom laptop: the defendant (and their solicitor) are pointed to that room.
    local room = Config.Courtrooms and Config.Courtrooms.WaypointToRoom and Rooms.LaptopRoom(src)
    local where = room and room.label or c.courtLabel
    if room then U.Log(c.id, U.By(a), ('Heard in %s.'):format(room.label)) end
    local dsrc = U.NotifyCid(c.cid, ('Your case %s is being heard now in %s. Make your way there.'):format(c.ref or '', where), 'warning')
    if room and room.centre and room.centre.x then
        local centre = vec3(room.centre.x, room.centre.y, room.centre.z)
        if dsrc then TriggerClientEvent('vinewood-moj:client:courtNotice', dsrc, centre, room.label) end
        local sol = c.solicitor_cid and U.NotifyCid(c.solicitor_cid, ('%s is being heard now in %s.'):format(c.subject_name or 'Your client', room.label))
        if sol then TriggerClientEvent('vinewood-moj:client:courtNotice', sol, centre, room.label) end
    end
    return { ok = true }
end

H.appearance = function(_, a, d)
    local h = openHearingFor(d.id, a)
    if d.present then
        local c = Cases.Get(h.case_id)
        local need = Cases.NeedsProduction(c)
        if need and not h.booked_at then
            error({ user = need == 'custody' and 'The defendant has not been produced. They must be booked in at the court custody desk first.'
                or 'The defendant must surrender at the court custody desk and be booked in first.' }, 0)
        end
        U.Log(h.case_id, U.By(a), h.booked_at and ('Defendant present (booked in at the custody desk by %s).'):format(h.booked_by or 'staff') or 'Defendant present.')
        if c.custody_status == 'at_large' then Cases.Save(c, { custody_status = 'police_custody' }) end
        Warrants.CloseFor(h.cid, 'fta', h.case_id, 'executed', U.By(a))
        return { ok = true }
    end
    Cases.FailedToAppear(h, a)
    return { ok = true, closed = true }
end

H.plea = function(_, a, d) return Cases.Plea(openHearingFor(d.id, a), type(d.pleas) == 'table' and d.pleas or {}, a) end
H.verdict = function(_, a, d) return Cases.Verdict(openHearingFor(d.id, a), type(d.verdicts) == 'table' and d.verdicts or {}, a) end

H.bail = function(_, a, d)
    local c = Cases.Get(d.id)
    need(c and not Cases.Closed[c.status], 'This case has concluded.')
    return Cases.BailDecision(c, d.decision, d.conditions, a)
end

H.adjourn = function(_, a, d)
    local h = openHearingFor(d.id, a)
    need(Cases.HearingTypes[d.type], 'Choose what the next hearing is.')
    local at = tonumber(d.at)
    if at then need(at > U.now(), 'Pick a time in the future.') end
    Cases.Adjourn(h, d.type, at, U.trim(d.reason, 300), a)
    return { ok = true }
end

H.concludeHearing = function(_, a, d)
    local h = openHearingFor(d.id, a)
    local result = U.trim(d.result, 300) or 'Hearing concluded.'
    Cases.CloseHearing(h, result)
    U.Log(h.case_id, U.By(a), ('%s concluded: %s'):format(Cases.HearingTypes[h.type] or h.type, result))
    return { ok = true }
end

---------------------------------------------------------------------------
-- Court custody desk
---------------------------------------------------------------------------
local function deskOrError(src)
    local r, at = Rooms.Desk(src)
    need(r, 'Use the court custody desk to do this.')
    return r, at
end

H.custodyBoard = function(src, a)
    local room, at = deskOrError(src)
    local serves = room.serves or { room.court_id }
    local rows = MySQL.query.await(([[SELECT h.*, c.ref, c.subject_name, c.custody_status, c.court_kind, c.charges, c.court_id AS case_court
        FROM vw_moj_hearings h JOIN vw_moj_cases c ON c.id = h.case_id
        WHERE h.status IN ('listed', 'open') AND c.court_id IN (%s) AND h.scheduled_at BETWEEN ? AND ? ORDER BY h.scheduled_at ASC]])
        :format(string.rep('?', #serves, ',')), (function() local a2 = {} for _, x in ipairs(serves) do a2[#a2 + 1] = x end
            a2[#a2 + 1] = U.now() - 8 * 3600; a2[#a2 + 1] = U.now() + 18 * 3600 return a2 end)()) or {}
    local out = {}
    for _, h in ipairs(rows) do
        local c = Cases.Get(h.case_id)
        local need = Cases.NeedsProduction(c)
        if need then
            local s = Bridge.GetSource(h.cid)
            local dist = s and #(GetEntityCoords(GetPlayerPed(s)) - at) or nil
            out[#out + 1] = {
                id = h.id, case_id = h.case_id, ref = h.ref, name = h.subject_name, type = h.type, at = h.scheduled_at, status = h.status,
                need = need, needLabel = Cases.ProductionLabels[need], custody = Cases.Custody[h.custody_status] or h.custody_status,
                booked_at = h.booked_at, booked_by = h.booked_by, notes = h.booking_notes, charges = U.decode(h.charges),
                online = s ~= nil, distance = dist and math.floor(dist + 0.5) or nil, room_id = h.room_id, court_id = h.case_court,
                courtLabel = (U.court(h.case_court) or {}).label,
            }
        end
    end
    -- The courtrooms of this court, for choosing where each defendant goes.
    local rooms, servesSet = {}, {}
    for _, x in ipairs(serves) do servesSet[x] = true end
    for _, r in ipairs(Rooms.Public()) do
        if servesSet[r.court_id] then rooms[#rooms + 1] = { id = r.id, label = r.label, court_id = r.court_id } end
    end
    return { room = room.label, court = room.courtLabel, rooms = rooms, results = out, range = (Config.CustodyDesk or {}).BookInRange or 12.0, serverTime = U.now() }
end

H.bookIn = function(src, a, d)
    local room, at = deskOrError(src)
    local h = Cases.Hearing(d.id)
    need(h and (h.status == 'listed' or h.status == 'open'), 'This hearing is not waiting to be heard.')
    need(not h.booked_at, 'Already booked in.')
    local c = Cases.Get(h.case_id)
    local servesThis = false
    for _, x in ipairs(room.serves or { room.court_id }) do if x == c.court_id then servesThis = true end end
    need(servesThis, 'This defendant is listed at a court this desk does not handle.')
    local s = Bridge.GetSource(c.cid)
    need(s, 'The defendant is not in the city.')
    local range = (Config.CustodyDesk or {}).BookInRange or 12.0
    need(#(GetEntityCoords(GetPlayerPed(s)) - at) <= range, ('The defendant must be at the custody desk (within %d m).'):format(math.floor(range)))
    local notes = U.trim(d.notes, 600)
    -- Which courtroom they'll be heard in: chosen at the desk (must be a room of this court).
    local courtroom = d.roomId and Rooms.Get(d.roomId)
    if courtroom and courtroom.court_id ~= c.court_id then courtroom = nil end
    if not courtroom and h.room_id then courtroom = Rooms.Get(h.room_id) end
    local roomCount = 0
    for _, r in ipairs(Rooms.Public()) do if r.court_id == c.court_id then roomCount = roomCount + 1 end end
    need(courtroom or roomCount == 0, 'Choose which courtroom they are going to.')
    MySQL.update.await('UPDATE vw_moj_hearings SET booked_at = ?, booked_by = ?, booking_notes = ?, room_id = ?, updated_at = ? WHERE id = ?',
        { U.now(), U.By(a), notes, courtroom and courtroom.id or h.room_id, U.now(), h.id })
    U.Log(c.id, U.By(a), ('Booked in at the %s custody desk%s.%s'):format(room.label, courtroom and (' for ' .. courtroom.label) or '', notes and (' ' .. notes) or ''))
    Webhook.Send('custody', ('Booked in: %s'):format(c.subject_name or c.cid), notes, {
        { 'Case', c.ref }, { 'Hearing', ('%s at %s'):format(Cases.HearingTypes[h.type] or h.type, U.fmtDate(h.scheduled_at)) },
        { 'Why', Cases.ProductionLabels[Cases.NeedsProduction(c) or ''] }, { 'Desk', room.label }, { 'Courtroom', courtroom and courtroom.label },
        { 'Booked in by', U.By(a) },
    }, 'amber')
    if c.custody_status == 'at_large' then Cases.Save(c, { custody_status = 'police_custody' }) end
    Bridge.Notify(s, courtroom and ('You have been booked into the custody of the court. You will be taken to %s when your case is called.'):format(courtroom.label)
        or 'You have been booked into the custody of the court. Wait to be called.', 'inform')
    U.NotifyRole('judge', ('%s (%s) has been booked in%s.'):format(c.subject_name or '', c.ref or '', courtroom and (' for ' .. courtroom.label) or ''))
    return { ok = true }
end

---------------------------------------------------------------------------
-- Front desk (reception)
---------------------------------------------------------------------------
local function frontDeskOrError(src)
    local r = Rooms.Desk(src)
    need(r and r.kind == 'front', 'Use the court front desk to do this.')
    return r
end

H.frontBoard = function(src)
    local desk = frontDeskOrError(src)
    return { room = desk.label, court = desk.courtLabel, rows = FrontDesk.Today(desk.serves or { desk.court_id }), serverTime = U.now() }
end

H.frontCheckIn = function(src, a, d)
    frontDeskOrError(src)
    return FrontDesk.StaffCheckIn(d.kind, tonumber(d.id), d.side, U.By(a))
end

---------------------------------------------------------------------------
-- Civil claims (County Court)
---------------------------------------------------------------------------
local function civilOrError(a, id, needSide)
    local c = Civil.Get(id)
    need(c, 'Claim not found.')
    if a.role == 'defence' then
        -- Solicitors only: business bosses act through /mycase, not the staff system.
        local side = (c.claimant_sol_cid == a.cid and 'claimant') or (c.defendant_sol_cid == a.cid and 'defendant') or nil
        need(side, 'You can only see claims where you act for one of the parties.')
        if needSide then need(side == needSide, needSide == 'defendant' and 'Only the defendant\'s solicitor can do that.' or 'Only the claimant\'s solicitor can do that.') end
        c.mySide = side
    end
    return c
end

H.civilList = function(_, a, d)
    local where, args = {}, {}
    if d.status == 'open' then where[#where + 1] = "status IN ('issued', 'defended', 'listed', 'judgment')"
    elseif d.status == 'closed' then where[#where + 1] = "status NOT IN ('issued', 'defended', 'listed', 'judgment')" end
    if a.role == 'defence' then where[#where + 1] = '(claimant_sol_cid = ? OR defendant_sol_cid = ?)'; args[#args + 1] = a.cid; args[#args + 1] = a.cid end
    local q = U.trim(d.q, 64)
    if q then
        where[#where + 1] = '(ref LIKE ? OR claimant_name LIKE ? OR defendant_name LIKE ?)'
        for _ = 1, 3 do args[#args + 1] = '%' .. q .. '%' end
    end
    local rows = MySQL.query.await('SELECT * FROM vw_moj_civil' .. (#where > 0 and (' WHERE ' .. table.concat(where, ' AND ')) or '')
        .. ' ORDER BY updated_at DESC LIMIT 80', args) or {}
    for i, r in ipairs(rows) do rows[i] = Civil.Decode(r); rows[i].log = nil; rows[i].particulars = nil end
    return { results = rows }
end

H.civilGet = function(_, a, d)
    local c = civilOrError(a, d.id)
    local function online(side)
        if c[side .. '_kind'] == 'business' then return #Business.Bosses(c[side .. '_cid']) > 0 end
        return Bridge.GetSource(c[side .. '_cid']) ~= nil
    end
    c.claimantOnline, c.defendantOnline = online('claimant'), online('defendant')
    return { claim = c, serverTime = U.now() }
end

H.civilFee = function(_, _, d) return { fee = Civil.Fee(d.type, d.amount) } end

--- People or businesses for the claim form.
H.searchParties = function(_, _, d)
    if d.kind == 'business' then
        if not Config.Civil.Businesses then return { results = {} } end
        local out = {}
        for _, b in ipairs(Business.Search(d.q, 10)) do out[#out + 1] = { cid = b.id, name = b.name } end
        return { results = out }
    end
    local out = {}
    for _, p in ipairs(Bridge.SearchPeople(tostring(d.q or ''), 10)) do out[#out + 1] = { cid = p.cid, name = U.fullName(p) } end
    return { results = out }
end

H.civilIssue = function(src, a, d)
    local allowed = false
    for _, role in ipairs(Config.Civil.OpenRoles or {}) do if role == a.role then allowed = true end end
    need(allowed, 'Your role cannot issue civil claims.')
    if not Config.Civil.Businesses then d.claimantKind, d.defendantKind = 'person', 'person' end
    return Civil.Issue(src, a, d)
end

H.civilRespond = function(_, a, d)
    local c = civilOrError(a, d.id, 'defendant')
    return Civil.Respond(c, d.kind, d.text, U.By(a))
end

H.civilNote = function(_, a, d)
    local c = civilOrError(a, d.id)
    local text = U.trim(d.text, 2000)
    need(text, 'Write the note.')
    Civil.Log(c.id, U.By(a), text)
    return { ok = true }
end

H.civilListHearing = function(_, a, d) return Civil.List(civilOrError(a, d.id), d.at, d.courtId, U.By(a), d.roomId) end

H.civilAssign = function(_, a, d)
    local c = civilOrError(a, d.id)
    local side = d.side == 'claimant' and 'claimant' or 'defendant'
    local cid = U.trim(d.cid, 64)
    local name = cid and U.nameOf(cid) or nil
    MySQL.update.await(('UPDATE vw_moj_civil SET %s_sol_cid = ?, %s_sol_name = ?, updated_at = ? WHERE id = ?'):format(side, side), { cid, name, U.now(), c.id })
    Civil.Log(c.id, U.By(a), cid and ('%s now represents the %s.'):format(name, side) or ('The %s is now unrepresented.'):format(side))
    Webhook.Send('civil', ('Solicitor %s: %s'):format(cid and 'assigned' or 'removed', c.ref or ''), nil, { { 'For the', side }, { 'Solicitor', name }, { 'By', U.By(a) } }, 'grey')
    if cid then U.NotifyCid(cid, ('You now act for the %s in %s.'):format(side, c.ref or '')) end
    return { ok = true }
end

H.civilOpen = function(src, a, d) return Civil.OpenHearing(civilOrError(a, d.id), a, src) end

H.civilJudge = function(_, a, d)
    local c = civilOrError(a, d.id)
    need(c.hearing_open or c.status == 'issued' or c.status == 'defended', 'Open the hearing first.')
    return Civil.Judge(c, d, a)
end

H.civilAdjourn = function(_, a, d)
    local c = civilOrError(a, d.id)
    return Civil.Adjourn(c, tonumber(d.at), U.trim(d.reason, 300), a)
end

H.civilEnd = function(_, a, d)
    local c = civilOrError(a, d.id)
    local status = d.status
    if a.role == 'defence' then
        need(c.mySide == 'claimant', 'Only the claimant\'s solicitor can withdraw the claim.')
        need(status == 'withdrawn', 'A settlement has to be agreed by both sides: propose it instead.')
    else
        need(status == 'struck_out' or status == 'dismissed' or status == 'settled' or status == 'withdrawn', 'Choose an outcome.')
    end
    return Civil.End(c, status, U.trim(d.reason, 500), U.By(a))
end

H.civilSettle = function(_, a, d)
    local c = civilOrError(a, d.id)
    need(c.mySide, 'You do not act in this claim.')
    return Civil.ProposeSettlement(c, c.mySide, d.terms, d.amount, U.By(a))
end

H.civilSettleAnswer = function(_, a, d)
    local c = civilOrError(a, d.id)
    need(c.mySide, 'You do not act in this claim.')
    return Civil.AnswerSettlement(c, c.mySide, d.accept == true, U.By(a))
end

H.civilDefault = function(_, a, d)
    local c = civilOrError(a, d.id)
    if a.role == 'defence' then need(c.mySide == 'claimant', 'Only the claimant\'s solicitor can ask for judgment in default.') end
    return Civil.DefaultJudgment(c, U.By(a))
end

---------------------------------------------------------------------------
-- Video exhibits and the courtroom screens
---------------------------------------------------------------------------
local function screenRoom(src, a)
    local CR = Config.Courtrooms or {}
    local ok = false
    for _, role in ipairs(CR.ScreenRoles or {}) do if role == a.role then ok = true end end
    need(ok, 'Your role cannot use the courtroom screens.')
    local r = Rooms.LaptopRoom(src)
    need(r, 'Use a laptop in the courtroom to control its screens.')
    need(Rooms.HasScreens(r), ('%s has no screens set up.'):format(r.label))
    need(Zones.Contains(r, GetEntityCoords(GetPlayerPed(src)), 10.0),
        'You have left the courtroom.')
    return r
end

--- The case or claim an exhibit belongs to, after checking this person may see it.
local function exhibitOwner(a, kind, id)
    if kind == 'claim' then return 'claim', civilOrError(a, id) end
    local c = Cases.Get(id)
    need(c, 'Case not found.')
    need(canSeeCase(a, c), 'You can only see cases for clients assigned to you.')
    return 'case', c
end

local function ownerLog(kind, c, by, text)
    if kind == 'claim' then Civil.Log(c.id, by, text) else U.Log(c.id, by, text) end
end

--- The Sound button: turn this courtroom's speakers up or down.
H.paVolume = function(src, a, d)
    local ok = false
    for _, role in ipairs((Config.Courtrooms or {}).VolumeRoles or { 'judge', 'clerk' }) do if role == a.role then ok = true end end
    need(ok, 'Your role cannot change the courtroom volume.')
    local r = Rooms.LaptopRoom(src)
    need(r, 'Use a laptop in the courtroom to change its volume.')
    need(Zones.Contains(r, GetEntityCoords(GetPlayerPed(src)), 10.0), 'You have left the courtroom.')
    if d.volume ~= nil then
        Rooms.SetVolume(r.id, d.volume)
    end
    local now = Rooms.Get(r.id)
    return { ok = true, room = now.label, volume = now.pa_volume or 1.0 }
end

H.screenStatus = function(src, a)
    local r = Rooms.LaptopRoom(src)
    return { room = r and r.label, screens = r and Rooms.HasScreens(r) or false, now = r and Rooms.NowShowing(r.id) or nil, sources = VideoLinks.Names() }
end

H.screenPlay = function(src, a, d)
    local r = screenRoom(src, a)
    local url, label, kind, owner = d.url, d.label, nil, nil
    -- An interview recording from vinewood-interviews, linked to this case.
    if d.interviewId then
        kind, owner = exhibitOwner(a, 'case', d.ownerId)
        local linked = false
        for _, s in ipairs(Interviews.ForCase(owner) or {}) do if s.id == tonumber(d.interviewId) then linked = true end end
        need(linked, 'That interview is not linked to this case.')
        local session = Interviews.Get(d.interviewId)
        need(session and #session.tracks > 0, 'That interview has no playable recordings yet (uploads may still be processing).')
        local p = Rooms.PlayInterview(r.id, session, U.By(a), owner.ref)
        ownerLog(kind, owner, U.By(a), ('Interview of %s (%s) played in %s.'):format(session.interviewee or '?', U.fmtDate(session.startedAt and math.floor(session.startedAt / (session.startedAt > 1e11 and 1000 or 1)) or 0), r.label))
        Webhook.Send('evidence', ('Interview played in court: %s'):format(session.interviewee or '?'), nil, {
            { 'Courtroom', r.label }, { 'Case', owner.ref }, { 'Interview ref', session.caseRef }, { 'By', U.By(a) },
        }, 'purple')
        return { ok = true, now = p }
    end
    if d.ownerKind and d.ownerId then
        kind, owner = exhibitOwner(a, d.ownerKind, d.ownerId)
        local ex = owner.exhibits[tonumber(d.index) or 0]
        need(ex, 'Exhibit not found.')
        url, label = ex.url, ex.label
    end
    local p, err = Rooms.Play(r.id, url, label, U.By(a), owner and owner.ref)
    need(p, err)
    if owner then ownerLog(kind, owner, U.By(a), ('Exhibit "%s" shown on the screens in %s.'):format(p.label, r.label)) end
    Webhook.Send('evidence', ('Shown in court: %s'):format(p.label), p.url, {
        { 'Courtroom', r.label }, { 'Case', owner and owner.ref }, { 'Source', p.providerLabel }, { 'By', U.By(a) },
    }, 'purple')
    return { ok = true, now = p }
end

H.screenStop = function(src, a)
    local r = screenRoom(src, a)
    local was = Rooms.NowShowing(r.id)
    Rooms.StopScreen(r.id)
    if was then Webhook.Send('evidence', ('Screens stopped: %s'):format(r.label), nil, { { 'Was showing', was.label }, { 'By', U.By(a) } }, 'grey') end
    return { ok = true }
end

H.screenRestart = function(src, a)
    local r = screenRoom(src, a)
    need(Rooms.Restart(r.id), 'Nothing is showing.')
    return { ok = true }
end

H.addExhibit = function(_, a, d)
    local kind, c = exhibitOwner(a, d.ownerKind, d.ownerId)
    local v, err = Rooms.ParseVideo(d.url)
    need(v, err)
    local label = U.trim(d.label, 80)
    need(label, 'Give the exhibit a name, e.g. "Exhibit PH/1: bodycam footage".')
    local list = c.exhibits or {}
    need(#list < 30, 'This has the most exhibits allowed.')
    list[#list + 1] = { label = label, url = U.trim(d.url, 500), kind = v.provider, source = v.providerLabel, by = U.By(a), at = U.now() }
    MySQL.update.await(('UPDATE %s SET exhibits = ?, updated_at = ? WHERE id = ?'):format(kind == 'claim' and 'vw_moj_civil' or 'vw_moj_cases'),
        { U.encode(list), U.now(), c.id })
    ownerLog(kind, c, U.By(a), ('Video exhibit added: %s.'):format(label))
    Webhook.Send('evidence', ('Exhibit added: %s'):format(label), U.trim(d.url, 500), { { kind == 'claim' and 'Claim' or 'Case', c.ref }, { 'Source', v.providerLabel }, { 'By', U.By(a) } }, 'blue')
    return { ok = true }
end

H.removeExhibit = function(_, a, d)
    local kind, c = exhibitOwner(a, d.ownerKind, d.ownerId)
    local i = tonumber(d.index)
    local ex = c.exhibits and c.exhibits[i or 0]
    need(ex, 'Exhibit not found.')
    need(a.role == 'judge' or ex.by == U.By(a), 'Only whoever added it, or a judge, can remove an exhibit.')
    table.remove(c.exhibits, i)
    MySQL.update.await(('UPDATE %s SET exhibits = ?, updated_at = ? WHERE id = ?'):format(kind == 'claim' and 'vw_moj_civil' or 'vw_moj_cases'),
        { U.encode(c.exhibits), U.now(), c.id })
    ownerLog(kind, c, U.By(a), ('Video exhibit removed: %s.'):format(ex.label))
    Webhook.Send('evidence', ('Exhibit removed: %s'):format(ex.label), ex.url, { { kind == 'claim' and 'Claim' or 'Case', c.ref }, { 'By', U.By(a) } }, 'grey')
    return { ok = true }
end

H.sentence = function(_, a, d)
    local h = openHearingFor(d.id, a)
    return Cases.Sentence(h, type(d.components) == 'table' and d.components or {}, a)
end

H.breach = function(_, a, d)
    local h = openHearingFor(d.id, a)
    need(h.type == 'breach', 'This is not a breach hearing.')
    return Cases.Breach(h, d.action, tonumber(d.hours), type(d.components) == 'table' and d.components or {}, a)
end

H.guide = function(_, a, d)
    local c = Cases.Get(d.id)
    need(c, 'Case not found.')
    need(canSeeCase(a, c), 'You can only see cases for clients assigned to you.')
    local charges = #Cases.Convicted(c) > 0 and Cases.Convicted(c) or Cases.ChargeNames(c, function(ch) return ch.verdict ~= 'withdrawn' and ch.verdict ~= 'not_guilty' end)
    return { guide = Sentence.Guide(charges, {
        previous = Sentence.Previous(c.cid, c.id), courtKind = c.court_kind,
        plea = d.plea or Cases.PleaId(c),
        aggravating = type(d.aggravating) == 'table' and d.aggravating or {},
        mitigating = type(d.mitigating) == 'table' and d.mitigating or {},
    }) }
end

H.withdraw = function(_, a, d)
    local c = Cases.Get(d.id)
    need(c, 'Case not found.')
    local reason = U.trim(d.reason, 500)
    need(reason, 'Give the reason.')
    return Cases.Withdraw(c, tonumber(d.index), reason, a)
end

---------------------------------------------------------------------------
-- Warrants
---------------------------------------------------------------------------
H.warrants = function(_, a, d)
    local status = d.status == 'closed' and "status <> 'active'" or "status = 'active'"
    return { results = MySQL.query.await(('SELECT * FROM vw_moj_warrants WHERE %s ORDER BY created_at DESC LIMIT 100'):format(status)) or {} }
end

H.cancelWarrant = function(_, a, d)
    need(a.role == 'judge' or a.supervisor, 'Only a judge or a senior clerk can cancel a warrant.')
    need(Warrants.Close(tonumber(d.id), 'cancelled', U.By(a)), 'This warrant is not active.')
    return { ok = true }
end

H.executeWarrant = function(_, a, d)
    need(Warrants.Close(tonumber(d.id), 'executed', U.By(a)), 'This warrant is not active.')
    return { ok = true }
end

---------------------------------------------------------------------------
-- Prison
---------------------------------------------------------------------------
H.prisonRoll = function()
    local rows = Prison.Roll()
    for _, r in ipairs(rows) do
        r.online = Bridge.GetSource(r.cid) ~= nil
        local live = Prison.Live(r.cid)
        if live then
            r.prisonNo, r.cell, r.liveStatus = live.prisonNo, live.cell, live.status
            if live.sentence then
                r.served_minutes = math.floor((live.sentence.served or 0) / 60)
                r.leftLive = live.sentence.remaining and math.ceil(live.sentence.remaining / 60) or nil
            end
        end
    end
    return { results = rows, minutesPerMonth = Config.Prison.MinutesPerMonth, prison = Config.Prison.Name, holder = Prison.Holder() }
end

H.releasePrisoner = function(_, a, d)
    need(a.supervisor or a.role == 'judge', 'Early release needs a senior officer or a judge.')
    local reason = U.trim(d.reason, 200)
    need(reason, 'Give the reason for release.')
    need(Prison.Release(tonumber(d.id), 'Released early: ' .. reason, U.By(a)), 'This prisoner is not in custody.')
    return { ok = true }
end

---------------------------------------------------------------------------
-- Probation
---------------------------------------------------------------------------
H.caseload = function(_, a, d)
    local where, args = { "status = 'active'" }, {}
    if d.filter == 'mine' then where[#where + 1] = 'officer_cid = ?'; args[#args + 1] = a.cid
    elseif d.filter == 'unassigned' then where[#where + 1] = 'officer_cid IS NULL'
    elseif d.filter == 'closed' then where = { "status <> 'active'" } end
    local q = U.trim(d.q, 64)
    if q then where[#where + 1] = '(subject_name LIKE ? OR ref LIKE ?)'; args[#args + 1] = '%' .. q .. '%'; args[#args + 1] = '%' .. q .. '%' end
    local rows = MySQL.query.await(('SELECT * FROM vw_moj_orders WHERE %s ORDER BY updated_at DESC LIMIT 80'):format(table.concat(where, ' AND ')), args) or {}
    for i, o in ipairs(rows) do
        rows[i] = Orders.Decode(o)
        rows[i].log = nil
        rows[i].online = Bridge.GetSource(o.cid) ~= nil
    end
    return { results = rows }
end

H.getOrder = function(_, _, d)
    local o = Orders.Get(d.id)
    need(o, 'Order not found.')
    o.appointments = Orders.Appointments(o.id)
    o.online = Bridge.GetSource(o.cid) ~= nil
    o.case = o.case_id and MySQL.single.await('SELECT id, ref, charges FROM vw_moj_cases WHERE id = ?', { o.case_id })
    if o.case then o.case.charges = U.decode(o.case.charges) end
    o.sentence = o.sentence_id and MySQL.single.await('SELECT summary, passed_by, created_at FROM vw_moj_sentences WHERE id = ?', { o.sentence_id })
    return { order = o, serverTime = U.now() }
end

H.takeOrder = function(_, a, d)
    local o = Orders.Get(d.id)
    need(o, 'Order not found.')
    MySQL.update.await('UPDATE vw_moj_orders SET officer_cid = ?, officer_name = ?, updated_at = ? WHERE id = ?', { a.cid, a.name, U.now(), o.id })
    U.OrderLog(o.id, U.By(a), 'Responsible officer: ' .. a.name)
    U.NotifyCid(o.cid, ('%s is your probation officer.'):format(a.name))
    return { ok = true }
end

H.bookAppointment = function(_, a, d) return Orders.Book(d.id, tonumber(d.at), U.trim(d.location, 160), U.By(a)) end
H.markAppointment = function(_, a, d) return Orders.MarkAppointment(d.id, d.status, U.By(a), U.trim(d.notes, 500)) end

H.warnOrder = function(_, a, d)
    local reason = U.trim(d.reason, 300)
    need(reason, 'Give the reason for the warning.')
    return Orders.Warn(d.id, U.By(a), reason)
end

H.breachOrder = function(_, a, d)
    local reason = U.trim(d.reason, 300)
    need(reason, 'Give the reason for breach action.')
    return Orders.Breach(d.id, U.By(a), reason)
end

H.orderNote = function(_, a, d)
    local text = U.trim(d.text, 1000)
    need(text, 'Write the contact note.')
    U.OrderLog(tonumber(d.id), U.By(a), text)
    return { ok = true }
end

H.creditHours = function(_, a, d)
    local o = Orders.Get(d.id)
    need(o and o.status == 'active', 'This order is not active.')
    local hours = U.int(d.hours, 1, 300)
    local added = Orders.CreditHours(o, hours)
    U.OrderLog(o.id, U.By(a), ('%d hours of unpaid work credited by the officer.'):format(added))
    return { ok = true }
end

H.completeOrder = function(_, a, d)
    need(a.supervisor or a.role == 'judge', 'Ending an order early needs a senior officer or a judge.')
    Orders.Complete(tonumber(d.id), U.By(a), 'Ended early: ' .. (U.trim(d.reason, 200) or 'no reason given'))
    return { ok = true }
end

--- Sets a curfew address or adds an exclusion zone at a position: the officer's own, or the offender's.
H.setLocation = function(src, a, d)
    local o = Orders.Get(d.id)
    need(o and o.status == 'active', 'This order is not active.')
    local who = src
    if d.from == 'offender' then
        who = Bridge.GetSource(o.cid)
        need(who, 'The offender is not in the city.')
    end
    local p = GetEntityCoords(GetPlayerPed(who))
    local coords = { x = math.floor(p.x * 10) / 10, y = math.floor(p.y * 10) / 10, z = math.floor(p.z * 10) / 10 }
    if d.kind == 'curfew' then
        local found = false
        for _, r in ipairs(o.requirements) do
            if r.type == 'curfew' then r.coords = coords; found = true end
        end
        need(found, 'This order has no curfew requirement.')
        U.OrderLog(o.id, U.By(a), 'Curfew address set. Electronic monitoring active.')
    else
        local label = U.trim(d.label, 60) or 'Exclusion zone'
        o.requirements[#o.requirements + 1] = { type = 'exclusion', label = label, coords = coords, radius = U.int(d.radius, 20, 1000) }
        U.OrderLog(o.id, U.By(a), ('Exclusion zone added: %s.'):format(label))
    end
    MySQL.update.await('UPDATE vw_moj_orders SET requirements = ?, updated_at = ? WHERE id = ?', { U.encode(o.requirements), U.now(), o.id })
    return { ok = true }
end

---------------------------------------------------------------------------
-- Fines (court staff)
---------------------------------------------------------------------------
H.fines = function(_, _, d)
    local status = ({ unpaid = "status IN ('unpaid', 'default')", paid = "status = 'paid'", default = "status = 'default'" })[d.status] or "status IN ('unpaid', 'default')"
    return { results = MySQL.query.await(('SELECT * FROM vw_moj_fines WHERE %s ORDER BY created_at DESC LIMIT 100'):format(status)) or {} }
end

H.writeOffFine = function(_, a, d)
    local f = MySQL.single.await('SELECT * FROM vw_moj_fines WHERE id = ?', { tonumber(d.id) })
    need(f and (f.status == 'unpaid' or f.status == 'default'), 'This fine is not outstanding.')
    MySQL.update.await("UPDATE vw_moj_fines SET status = 'written_off' WHERE id = ?", { f.id })
    if f.case_id then U.Log(f.case_id, U.By(a), ('%s %s written off.'):format(Fines.Labels[f.kind] or 'Fine', f.ref or '')) end
    Webhook.Send('fines', ('Written off: %s %s'):format(f.subject_name or f.cid, f.ref or ''), nil, { { 'Amount', U.money(f.amount) }, { 'By', U.By(a) } }, 'grey')
    return { ok = true }
end

---------------------------------------------------------------------------
-- Entry points
---------------------------------------------------------------------------
local function needsLaptop(a)
    local CR = Config.Courtrooms
    if not (CR and CR.enabled ~= false and CR.CourtRolesNeedLaptop) then return false end
    for _, role in ipairs(CR.LaptopOnlyRoles or { 'judge', 'clerk' }) do
        if role == a.role then return true end
    end
    return false
end

-- At a courtroom laptop, and still in that room.
local function atLaptop(src)
    local r = Rooms.LaptopRoom(src)
    if not r or not r.centre or not r.centre.x then return false end
    return Zones.Contains(r, GetEntityCoords(GetPlayerPed(src)), 10.0)
end

local function hasTablet(src)
    local UI = Config.UI or {}
    if not (UI.RequireTabletItem and UI.TabletItem) or GetResourceState('ox_inventory') ~= 'started' then return true end
    local ok, n = pcall(function() return exports.ox_inventory:Search(src, 'count', UI.TabletItem) end)
    return not ok or (tonumber(n) or 0) > 0
end

-- fromItem = opened by using the tablet item. Returns role, or nil plus a reason
-- (nil with no reason means "not staff": the tablet item then opens their justice account).
lib.callback.register('vinewood-moj:server:canOpen', function(src, fromItem)
    local a = U.Access(src)
    if not a then return nil end
    Rooms.ClearLaptop(src)
    if needsLaptop(a) then return nil, 'Use a laptop in a courtroom to open the court system.' end
    -- Checked every time (using the item means they have it), so a client can't skip it.
    if not hasTablet(src) then return nil, 'You need your justice tablet to open the system.' end
    return a.role
end)

RegisterNetEvent('vinewood-moj:server:closedUi', function() Rooms.ClearLaptop(source) end)

lib.callback.register('vinewood-moj:server:request', function(src, action, data)
    local a = U.Access(src)
    if not a then return { error = 'You do not have access to this system.' } end
    local fn, allowed = H[action], PERMS[action]
    if not fn or not allowed then return { error = 'Unknown request.' } end
    if not allowed[a.role] then return { error = "Your role can't do that." } end
    -- Working at a court custody desk counts, even though the cells are usually outside the courtroom.
    local atDesk = (action == 'custodyBoard' or action == 'bookIn' or action == 'frontBoard' or action == 'frontCheckIn' or action == 'init') and Rooms.Desk(src) ~= nil
    if needsLaptop(a) and not atLaptop(src) and not atDesk then return { error = 'Use a laptop in a courtroom to open the court system.' } end
    data = type(data) == 'table' and data or {}
    local ok, result = pcall(fn, src, a, data)
    if not ok then
        if type(result) == 'table' and result.user then return { error = result.user } end
        print(('[vinewood-moj] %s failed: %s'):format(action, tostring(result)))
        return { error = 'The request failed. Check the server console.' }
    end
    return result
end)

---------------------------------------------------------------------------
-- Public portal (/mycase): anyone, about themselves only
---------------------------------------------------------------------------
local function portal(cid, src)
    local bossOf = Config.Civil and Config.Civil.Businesses and Business.BossOf(src) or nil
    local orders = Orders.Active(cid)
    local appts = MySQL.query.await("SELECT * FROM vw_moj_appointments WHERE cid = ? AND status = 'booked' AND at > ? ORDER BY at ASC", { cid, U.now() - 1800 }) or {}
    local cases = Cases.ForPerson(cid)
    for _, c in ipairs(cases) do c.evidence, c.summary = nil, nil end
    local custody = Prison.Active(cid)
    return {
        name = U.nameOf(cid), cases = cases, fines = Fines.For(cid), orders = orders, appointments = appts, custody = custody,
        warrants = Warrants.Active(cid),
        civil = (Config.Civil or {}).enabled ~= false and Civil.ForPerson(cid, bossOf and bossOf.id) or {},
        business = bossOf and Config.Civil.Businesses and { id = bossOf.id, name = bossOf.name } or nil,
        cfg = {
            serviceName = Config.ServiceName, courtsName = Config.CourtsName, crest = Config.Crest, currency = Config.Fines.Currency,
            hearingTypes = Cases.HearingTypes, statuses = Cases.Statuses, orderKinds = Orders.Kinds, courts = Config.Courts,
            sites = Config.UnpaidWork.Sites, hoursPerTask = Config.UnpaidWork.HoursPerTask, prisonKinds = Prison.Kinds,
            fineLabels = Fines.Labels, warrantTypes = Warrants.Labels,
            civilTypes = (Config.Civil or {}).Types, civilStatuses = Civil.Statuses,
            litigantInPerson = (Config.Civil or {}).enabled ~= false and (Config.Civil or {}).AllowLitigantInPerson == true,
            businessCanIssue = (Config.Civil or {}).enabled ~= false and Config.Civil.Businesses and Config.Civil.BusinessesCanIssue == true and bossOf ~= nil,
            businesses = Config.Civil and Config.Civil.Businesses == true,
        },
        serverTime = U.now(),
    }
end

lib.callback.register('vinewood-moj:server:portal', function(src, action, data)
    local cid = Bridge.GetCid(src)
    if not cid then return { error = 'No character loaded.' } end
    data = type(data) == 'table' and data or {}
    if action == 'pay' then return Fines.Pay(src, data.id) end
    -- Civil claims: the defendant responds and pays here; the claimant can withdraw or settle.
    if action == 'civilPay' or action == 'civilRespond' or action == 'civilEnd' or action == 'civilSettle' or action == 'civilSettleAnswer' then
        local c = Civil.Get(data.id)
        if not c then return { error = 'Claim not found.' } end
        if action == 'civilPay' then return Civil.Pay(src, c, data.amount) end
        local who = function(side)
            return c[side .. '_kind'] == 'business' and ('%s for %s'):format(U.nameOf(cid), c[side .. '_name'] or 'the business')
                or ((c[side .. '_name'] or side) .. ' (in person)')
        end
        if action == 'civilRespond' then
            if not Civil.IsParty(c, 'defendant', cid, src) then return { error = 'Only the defendant can respond to this claim.' } end
            return Civil.Respond(c, data.kind, data.text, who('defendant'))
        end
        -- Which side this player is on (as the person, or as a boss of the business).
        local side = Civil.IsParty(c, 'claimant', cid, src) and 'claimant' or (Civil.IsParty(c, 'defendant', cid, src) and 'defendant') or nil
        if not side then return { error = 'You are not a party to this claim.' } end
        if action == 'civilSettle' then return Civil.ProposeSettlement(c, side, data.terms, data.amount, who(side)) end
        if action == 'civilSettleAnswer' then return Civil.AnswerSettlement(c, side, data.accept == true, who(side)) end
        -- Only the claimant can drop their own claim; settling needs both sides (above).
        if side ~= 'claimant' then return { error = 'Only the claimant can withdraw the claim.' } end
        if data.status ~= 'withdrawn' then return { error = 'A settlement has to be agreed by both sides: propose it instead.' } end
        return Civil.End(c, 'withdrawn', U.trim(data.reason, 500), who('claimant'))
    end
    if action == 'civilFee' then return { fee = Civil.Fee(data.type, data.amount) } end
    local CVc = Config.Civil or {}
    local bossOf = CVc.Businesses and CVc.BusinessesCanIssue and Business.BossOf(src) or nil
    if action == 'civilIssue' then
        if data.asBusiness then
            if not bossOf then return { error = 'Only a boss of the business can take someone to court for it.' } end
            return Civil.Issue(src, nil, data, { business = bossOf.id })
        end
        if not CVc.AllowLitigantInPerson then return { error = 'Claims must be issued through a solicitor.' } end
        return Civil.Issue(src, nil, data, { cid = cid, name = U.nameOf(cid) })
    end
    if action == 'searchPeople' then
        if not (CVc.AllowLitigantInPerson or bossOf) then return { results = {} } end
        local out = {}
        if data.kind == 'business' then
            if CVc.Businesses then for _, b in ipairs(Business.Search(data.q, 8)) do out[#out + 1] = { cid = b.id, name = b.name } end end
        else
            for _, p in ipairs(Bridge.SearchPeople(tostring(data.q or ''), 8)) do out[#out + 1] = { cid = p.cid, name = U.fullName(p) } end
        end
        return { results = out }
    end
    if action == 'courtWaypoint' then
        local court = U.court(data.id)
        local at = Rooms.CourtCoords(court)
        if at then TriggerClientEvent('vinewood-moj:client:courtNotice', src, at, court.label) end
        return { ok = true }
    end
    if action == 'waypoint' then
        local site = Config.UnpaidWork.Sites[tonumber(data.site) or 0]
        if site then TriggerClientEvent('vinewood-moj:client:courtNotice', src, site.coords, site.label) end
        return { ok = true }
    end
    return portal(cid, src)
end)

---------------------------------------------------------------------------
-- Unpaid work: tasks are handed out and checked on the server
---------------------------------------------------------------------------
local work = {}   -- [src] = { site, point, issued, last }

local function randomPoint(site)
    local ang, dist = math.random() * math.pi * 2, math.random() * site.radius * 0.85
    return vec3(site.coords.x + math.cos(ang) * dist, site.coords.y + math.sin(ang) * dist, site.coords.z)
end

lib.callback.register('vinewood-moj:server:uwStart', function(src, siteIndex)
    local cid = Bridge.GetCid(src)
    local o = cid and Orders.WorkOrder(cid)
    if not o then return { error = 'You have no unpaid work to do.' } end
    if Prison.Active(cid) then return { error = 'You cannot do unpaid work while in custody.' } end
    local site = Config.UnpaidWork.Sites[tonumber(siteIndex) or 0]
    if not site then return { error = 'Unknown work site.' } end
    local pos = GetEntityCoords(GetPlayerPed(src))
    if #(pos - site.coords) > site.radius + 30.0 then return { error = ('Go to %s to start.'):format(site.label) } end
    local point = randomPoint(site)
    work[src] = { site = tonumber(siteIndex), point = point, issued = os.time(), last = work[src] and work[src].last or 0 }
    return { ok = true, point = point, site = site, left = o.hours_required - o.hours_done, task = site.task, seconds = Config.UnpaidWork.TaskSeconds }
end)

lib.callback.register('vinewood-moj:server:uwDone', function(src)
    local w = work[src]
    if not w then return { error = 'No task in progress.' } end
    local site = Config.UnpaidWork.Sites[w.site]
    local pos = GetEntityCoords(GetPlayerPed(src))
    if #(pos - w.point) > 6.0 then return { error = 'You need to be at the task.' } end
    if os.time() - w.issued < (Config.UnpaidWork.TaskSeconds or 20) then return { error = 'Finish the task first.' } end
    if os.time() - w.last < (Config.UnpaidWork.CooldownSeconds or 20) + (Config.UnpaidWork.TaskSeconds or 20) then return { error = 'Slow down.' } end
    local cid = Bridge.GetCid(src)
    local o = Orders.WorkOrder(cid)
    if not o then work[src] = nil return { done = true } end
    local added = Orders.CreditHours(o, Config.UnpaidWork.HoursPerTask or 4)
    w.last = os.time()
    local left = o.hours_required - o.hours_done
    if left <= 0 then
        work[src] = nil
        Webhook.Send('probation', ('Unpaid work completed: %s'):format(o.subject_name or cid), nil, { { 'Hours', o.hours_required } }, 'green')
        return { done = true, added = added }
    end
    w.point, w.issued = randomPoint(site), os.time()
    return { ok = true, added = added, left = left, point = w.point }
end)

AddEventHandler('playerDropped', function() work[source] = nil end)

---------------------------------------------------------------------------
-- Character loaded: prison, reminders
---------------------------------------------------------------------------
local loadedAt = {}
AddEventHandler('playerDropped', function() loadedAt[source] = nil end)
RegisterNetEvent('vinewood-moj:server:loaded', function()
    local src = source
    -- Frameworks can fire more than one "loaded" event; handle the first.
    if loadedAt[src] and os.time() - loadedAt[src] < 15 then return end
    loadedAt[src] = os.time()
    CreateThread(function()
        U.WaitReady()
        Wait(2000)
        local cid = Bridge.GetCid(src)
        if not cid then return end
        Prison.OnLoaded(src, cid)
        Civil.PayPending(src, cid)
        local h = MySQL.single.await([[SELECT h.*, c.ref FROM vw_moj_hearings h JOIN vw_moj_cases c ON c.id = h.case_id
            WHERE h.cid = ? AND h.status = 'listed' ORDER BY h.scheduled_at ASC LIMIT 1]], { cid })
        if h then
            local court = U.court(h.court_id)
            Bridge.Notify(src, ('Court date (%s): %s at %s, %s.'):format(h.ref or '', Cases.HearingTypes[h.type] or 'Hearing',
                U.fmtDate(h.scheduled_at), court and court.label or ''), 'warning')
        end
        local o = Orders.WorkOrder(cid)
        if o then Bridge.Notify(src, ('%d hours of unpaid work left. See /%s.'):format(o.hours_required - o.hours_done, Config.PortalCommand)) end
        local owed = Fines.Outstanding(cid)
        if owed > 0 then Bridge.Notify(src, ('You owe %s in court fines. Pay with /%s.'):format(U.money(owed), Config.PortalCommand)) end
    end)
end)

---------------------------------------------------------------------------
-- Exports
---------------------------------------------------------------------------
--- Everything the MDT shows on a person's record.
exports('GetPersonSummary', function(cid)
    cid = tostring(cid or '')
    if cid == '' or not Ready then return nil end
    local cases = Cases.ForPerson(cid)
    local sentences = MySQL.query.await('SELECT case_id, summary, passed_by, auto, created_at FROM vw_moj_sentences WHERE cid = ? ORDER BY created_at DESC LIMIT 20', { cid }) or {}
    local custody = Prison.Active(cid)
    local orders = Orders.Active(cid)
    for _, o in ipairs(orders) do o.log = nil end
    local out = {
        cases = {}, sentences = sentences, orders = orders, warrants = Warrants.Active(cid),
        custody = custody and (function()
            local live = Prison.Live(cid)
            local left = custody.kind ~= 'remand' and math.max(0, custody.release_minutes - custody.served_minutes) or nil
            if live and live.sentence and live.sentence.remaining then left = math.ceil(live.sentence.remaining / 60) end
            return { kind = custody.kind, label = Prison.Kinds[custody.kind], served = custody.served_minutes, left = left,
                prison = Config.Prison.Name, prisonNo = live and live.prisonNo, cell = live and live.cell }
        end)() or nil,
        finesOwed = Fines.Outstanding(cid), currency = Config.Fines.Currency,
    }
    for _, c in ipairs(cases) do
        local court = c.next and U.court(c.next.court_id)
        out.cases[#out.cases + 1] = {
            id = c.id, ref = c.ref, status = c.status, statusLabel = c.statusLabel, custody = c.custodyLabel, court = c.courtLabel,
            charges = c.charges, custodyRef = c.custody_ref, solicitor = c.solicitor_name,
            next = c.next and { type = Cases.HearingTypes[c.next.type] or c.next.type, at = c.next.scheduled_at, court = court and court.label or '' } or nil,
        }
    end
    return out
end)

exports('IsInPrison', function(cid) return Prison.Active(cid) ~= nil end)
exports('GetActiveOrders', function(cid) return Orders.Active(cid) end)
exports('GetActiveWarrants', function(cid) return Warrants.Active(cid) end)

--- Open a case from another resource. data: { cid, charges = { 'offence', ... }, summary, officer }
exports('CreateCase', function(data)
    local r = Cases.CreateManual(data or {}, { name = data and data.by or 'External', label = 'System', role = 'clerk' })
    return r.id, r.error
end)

--- Straight to prison from another resource (e.g. a judge script). months on the sentencing scale.
exports('SendToPrison', function(cid, months, reason)
    local name = U.nameOf(cid)
    return Prison.Receive(cid, name, nil, nil, 'sentence', Prison.MonthsToMinutes(months), reason or 'Committed to prison')
end)

--- The MDT's OnBailGranted hook: police bail for someone on remand here releases them.
exports('ReleaseFromCustody', function(src)
    local cid = Bridge.GetCid(src)
    if cid then Prison.EndRemand(cid, 'Released on bail') end
end)

exports('ReleasePrisoner', function(cid, reason)
    local row = Prison.Active(cid)
    return row and Prison.Release(row.id, reason or 'Released') or false
end)
