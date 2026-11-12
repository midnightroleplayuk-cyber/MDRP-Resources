-- Front desk (reception): people not coming from custody check in for their hearing here.
-- Anyone can check themselves in ("Check in for my hearing"); court staff see today's list and
-- can check people in by hand. Defendants who must be produced or surrender go to the custody desk.
FrontDesk = {}

local FD = Config.FrontDesk or {}

local function window()
    return U.now() - (FD.CheckInAfter or 60) * 60, U.now() + (FD.CheckInBefore or 120) * 60
end

local function inList(list)
    local q, args = {}, {}
    for _, x in ipairs(list) do q[#q + 1] = '?'; args[#args + 1] = x end
    return table.concat(q, ','), args
end

local function roomLabel(id)
    local r = id and Rooms.Get(id)
    return r and r.label or nil
end

--- Today's hearings at these courts, criminal and civil, with who has arrived.
function FrontDesk.Today(serves)
    local from, to = window()
    from = math.min(from, U.now() - 6 * 3600)
    to = math.max(to, U.now() + 12 * 3600)
    local q, args = inList(serves)
    local rows = {}
    local crimArgs = {}
    for _, a in ipairs(args) do crimArgs[#crimArgs + 1] = a end
    crimArgs[#crimArgs + 1] = from; crimArgs[#crimArgs + 1] = to
    for _, h in ipairs(MySQL.query.await(([[SELECT h.id, h.type, h.court_id, h.scheduled_at, h.status, h.room_id, h.checked_in_at, h.checked_in_by,
            h.booked_at, c.id AS case_id, c.ref, c.cid, c.subject_name, c.custody_status, c.court_kind, c.charges
        FROM vw_moj_hearings h JOIN vw_moj_cases c ON c.id = h.case_id
        WHERE h.court_id IN (%s) AND h.status IN ('listed', 'open') AND h.scheduled_at BETWEEN ? AND ? ORDER BY h.scheduled_at ASC]]):format(q), crimArgs) or {}) do
        local need = Cases.NeedsProduction({ court_id = h.court_id, court_kind = h.court_kind, custody_status = h.custody_status, charges = U.decode(h.charges) })
        rows[#rows + 1] = {
            kind = 'case', id = h.id, caseId = h.case_id, ref = h.ref, title = 'R v ' .. (h.subject_name or ''), name = h.subject_name,
            hearing = Cases.HearingTypes[h.type] or h.type, at = h.scheduled_at, room = roomLabel(h.room_id), court = (U.court(h.court_id) or {}).label,
            custodyDesk = need, bookedAt = h.booked_at, checkedInAt = h.checked_in_at, checkedInBy = h.checked_in_by,
            open = h.status == 'open', online = Bridge.GetSource(h.cid) ~= nil,
        }
    end
    if Config.Civil and Config.Civil.enabled ~= false then
        local civArgs = {}
        for _, a in ipairs(args) do civArgs[#civArgs + 1] = a end
        civArgs[#civArgs + 1] = from; civArgs[#civArgs + 1] = to
        for _, r in ipairs(MySQL.query.await(([[SELECT * FROM vw_moj_civil WHERE hearing_court IN (%s) AND hearing_at BETWEEN ? AND ?
            AND status IN ('listed', 'defended', 'issued') ORDER BY hearing_at ASC]]):format(q), civArgs) or {}) do
            local c = Civil.Decode(r)
            local ci = U.decode(r.checkins)
            rows[#rows + 1] = {
                kind = 'claim', id = c.id, ref = c.ref, title = ('%s v %s'):format(c.claimant_name or '', c.defendant_name or ''),
                hearing = 'Civil hearing', at = c.hearing_at, room = roomLabel(r.hearing_room), court = (U.court(c.hearing_court) or {}).label,
                claimant = c.claimant_name, defendant = c.defendant_name, checkins = ci, open = c.hearing_open,
            }
        end
    end
    table.sort(rows, function(a, b) return a.at < b.at end)
    return rows
end

local function tellJudges(msg) U.NotifyRole('judge', msg) end

--- Check a criminal hearing's defendant in. by = who did it (them, or a member of staff).
local function checkInHearing(h, by)
    if h.checked_in_at then return false, 'Already checked in.' end
    MySQL.update.await('UPDATE vw_moj_hearings SET checked_in_at = ?, checked_in_by = ?, updated_at = ? WHERE id = ?', { U.now(), by, U.now(), h.id })
    local c = Cases.Get(h.case_id)
    U.Log(c.id, by, 'Checked in at the front desk.')
    local room = roomLabel(h.room_id)
    tellJudges(('%s (%s) has checked in at the front desk%s.'):format(c.subject_name or '', c.ref or '', room and (' for ' .. room) or ''))
    Webhook.Send('cases', ('Checked in: %s'):format(c.subject_name or c.cid), nil, { { 'Case', c.ref }, { 'Courtroom', room }, { 'By', by } }, 'blue')
    return true, room
end

local function checkInClaim(c, side, by)
    local ci = U.decode(MySQL.scalar.await('SELECT checkins FROM vw_moj_civil WHERE id = ?', { c.id }))
    if ci[side] then return false, 'Already checked in.' end
    ci[side] = { at = U.now(), by = by }
    MySQL.update.await('UPDATE vw_moj_civil SET checkins = ?, updated_at = ? WHERE id = ?', { U.encode(ci), U.now(), c.id })
    Civil.Log(c.id, by, ('The %s checked in at the front desk.'):format(side))
    tellJudges(('%s: the %s has checked in at the front desk.'):format(c.ref or '', side))
    return true, roomLabel(MySQL.scalar.await('SELECT hearing_room FROM vw_moj_civil WHERE id = ?', { c.id }))
end

--- Staff at the front desk checking someone in by hand.
function FrontDesk.StaffCheckIn(kind, id, side, by)
    if kind == 'claim' then
        local c = Civil.Get(id)
        if not c then return { error = 'Claim not found.' } end
        if side ~= 'claimant' and side ~= 'defendant' then return { error = 'Choose which side has arrived.' } end
        local ok, err = checkInClaim(c, side, by)
        return ok and { ok = true } or { error = err }
    end
    local h = Cases.Hearing(id)
    if not h then return { error = 'Hearing not found.' } end
    local c = Cases.Get(h.case_id)
    local need = Cases.NeedsProduction(c)
    if need then return { error = need == 'custody' and 'They are in custody: they are produced at the custody desk, not here.'
        or 'This is a serious case: they must surrender at the custody desk, not check in here.' } end
    local ok, err = checkInHearing(h, by)
    return ok and { ok = true } or { error = err }
end

--- A player checking themselves in at a front desk that handles these courts.
function FrontDesk.SelfCheckIn(src, serves)
    local cid = Bridge.GetCid(src)
    if not cid then return { error = 'No character loaded.' } end
    local name = Bridge.GetName(src)
    local from, to = window()
    local q, args = inList(serves)
    local done, notes = 0, {}
    local crimArgs = { cid }
    for _, a in ipairs(args) do crimArgs[#crimArgs + 1] = a end
    crimArgs[#crimArgs + 1] = from; crimArgs[#crimArgs + 1] = to
    for _, h in ipairs(MySQL.query.await(([[SELECT * FROM vw_moj_hearings WHERE cid = ? AND court_id IN (%s)
        AND status IN ('listed', 'open') AND scheduled_at BETWEEN ? AND ?]]):format(q), crimArgs) or {}) do
        local c = Cases.Get(h.case_id)
        local need = Cases.NeedsProduction(c)
        if need == 'serious' then
            notes[#notes + 1] = ('%s: you must surrender at the custody desk, not here.'):format(c.ref or 'Your case')
        elseif need == 'custody' then
            notes[#notes + 1] = ('%s: you are due to be produced from custody.'):format(c.ref or 'Your case')
        else
            local ok, roomOrErr = checkInHearing(h, name .. ' (self check-in)')
            if ok then
                done = done + 1
                notes[#notes + 1] = ('%s: checked in. %s'):format(c.ref or 'Your case', roomOrErr and ('Go to ' .. roomOrErr .. ' and wait to be called.') or 'Wait to be called.')
            else
                notes[#notes + 1] = ('%s: %s'):format(c.ref or 'Your case', roomOrErr)
            end
        end
    end
    -- civil claims where they're a party (in person, or as a boss of the business)
    if Config.Civil and Config.Civil.enabled ~= false then
        local civArgs = {}
        for _, a in ipairs(args) do civArgs[#civArgs + 1] = a end
        civArgs[#civArgs + 1] = from; civArgs[#civArgs + 1] = to
        for _, r in ipairs(MySQL.query.await(([[SELECT * FROM vw_moj_civil WHERE hearing_court IN (%s) AND hearing_at BETWEEN ? AND ?
            AND status IN ('listed', 'defended', 'issued')]]):format(q), civArgs) or {}) do
            local c = Civil.Decode(r)
            for _, side in ipairs({ 'claimant', 'defendant' }) do
                if Civil.IsParty(c, side, cid, src) then
                    local ok, roomOrErr = checkInClaim(c, side, name .. ' (self check-in)')
                    if ok then
                        done = done + 1
                        notes[#notes + 1] = ('%s: checked in as the %s. %s'):format(c.ref or 'Your claim', side,
                            roomOrErr and ('Go to ' .. roomOrErr .. ' and wait to be called.') or 'Wait to be called.')
                    else
                        notes[#notes + 1] = ('%s: %s'):format(c.ref or 'Your claim', roomOrErr)
                    end
                end
            end
        end
    end
    if #notes == 0 then
        return { error = ('You have no hearings at this court in the next %d minutes.'):format(FD.CheckInBefore or 120) }
    end
    return { ok = done > 0, notes = notes }
end
