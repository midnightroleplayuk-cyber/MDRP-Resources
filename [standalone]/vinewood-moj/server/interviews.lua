-- Read-only link to vinewood-interviews: interview recordings for a case, played on courtroom screens.
-- Nothing here writes to the interview tables, and it's skipped quietly when the resource isn't installed.
Interviews = {}

local function cfg() return Config.Interviews or {} end

function Interviews.Available()
    local c = cfg()
    return c.enabled ~= false and Schema.Running(c.resource or 'vinewood-interviews')
        and Schema.Has('vw_interview_sessions', 'id', 'interviewee', 'case_ref', 'started_at')
        and Schema.Has('vw_interview_media', 'session_id', 'url') or false
end

local function row(r, matched)
    return {
        id = r.id, room = r.room_label, caseRef = r.case_ref, interviewee = r.interviewee, officer = r.officer_name,
        startedAt = tonumber(r.started_at), duration = tonumber(r.duration_ms) or 0, status = r.status, notes = r.notes,
        solicitor = r.solicitor, matched = matched,
    }
end

--- Interviews of this defendant: by citizen id, name, or one of the case's references.
--- `matched` = recorded under this case's own references.
function Interviews.ForCase(c)
    if not Interviews.Available() or not c then return nil end
    local refs = { c.ref, c.custody_ref }
    if c.record_id and Schema.Has('vw_mdt_records', 'ref') then
        refs[#refs + 1] = MySQL.scalar.await('SELECT ref FROM vw_mdt_records WHERE id = ?', { c.record_id })
    end
    local clean = {}
    for _, r in pairs(refs) do if r and r ~= '' then clean[#clean + 1] = r end end
    local where, args = { 'interviewee LIKE ?' }, { '%' .. (c.subject_name or '?') .. '%' }
    if Schema.Columns('vw_interview_sessions').interviewee_cid then where[#where + 1] = 'interviewee_cid = ?'; args[#args + 1] = c.cid end
    if #clean > 0 then
        where[#where + 1] = ('case_ref IN (%s)'):format(string.rep('?', #clean, ','))
        for _, r in ipairs(clean) do args[#args + 1] = r end
    end
    local refSet = {}
    for _, r in ipairs(clean) do refSet[r] = true end
    local out = {}
    for _, r in ipairs(MySQL.query.await(('SELECT * FROM vw_interview_sessions WHERE %s ORDER BY started_at DESC LIMIT 30')
        :format(table.concat(where, ' OR ')), args) or {}) do
        out[#out + 1] = row(r, r.case_ref ~= nil and refSet[r.case_ref] == true)
    end
    return out
end

--- One session with its playable tracks (each speaker's audio and any CCTV video, each with its start offset).
function Interviews.Get(id)
    if not Interviews.Available() then return nil end
    local s = MySQL.single.await('SELECT * FROM vw_interview_sessions WHERE id = ?', { tonumber(id) })
    if not s then return nil end
    local out = row(s)
    out.tracks = {}
    for _, m in ipairs(MySQL.query.await('SELECT * FROM vw_interview_media WHERE session_id = ? ORDER BY offset_ms ASC', { s.id }) or {}) do
        if m.url and m.url ~= '' and m.status ~= 'failed' then
            out.tracks[#out.tracks + 1] = { kind = m.kind == 'video' and 'video' or 'audio', url = m.url, speaker = m.speaker_name,
                offset = tonumber(m.offset_ms) or 0, duration = tonumber(m.duration_ms) or 0 }
        end
    end
    local total = out.duration
    for _, t in ipairs(out.tracks) do total = math.max(total, t.offset + t.duration) end
    out.total = math.max(total, 1000)
    return out
end
