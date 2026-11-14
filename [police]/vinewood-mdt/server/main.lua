local resourceName = GetCurrentResourceName()

---------------------------------------------------------------------------
-- Database
---------------------------------------------------------------------------
MySQL.ready(function()
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_records (
        id INT AUTO_INCREMENT PRIMARY KEY,
        ref VARCHAR(32),
        cid VARCHAR(64) NOT NULL,
        subject_name VARCHAR(96),
        type VARCHAR(16) NOT NULL DEFAULT 'custody',
        offences LONGTEXT,
        outcome VARCHAR(64),
        narrative TEXT,
        officer_name VARCHAR(96),
        officer_cid VARCHAR(64),
        created_at BIGINT NOT NULL,
        INDEX idx_cid (cid),
        INDEX idx_ref (ref)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_bail (
        id INT AUTO_INCREMENT PRIMARY KEY,
        cid VARCHAR(64) NOT NULL,
        subject_name VARCHAR(96),
        record_id INT NULL,
        custody_ref VARCHAR(32),
        bail_type VARCHAR(16) NOT NULL,
        offences LONGTEXT,
        conditions LONGTEXT,
        return_at BIGINT NULL,
        return_station VARCHAR(96),
        status VARCHAR(16) NOT NULL DEFAULT 'active',
        notes TEXT,
        officer_name VARCHAR(96),
        officer_cid VARCHAR(64),
        closed_by VARCHAR(96),
        created_at BIGINT NOT NULL,
        updated_at BIGINT NOT NULL,
        INDEX idx_cid (cid),
        INDEX idx_status (status)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_cps (
        id INT AUTO_INCREMENT PRIMARY KEY,
        record_id INT NOT NULL,
        cid VARCHAR(64) NOT NULL,
        subject_name VARCHAR(96),
        custody_ref VARCHAR(32),
        status VARCHAR(16) NOT NULL DEFAULT 'pending',
        offences LONGTEXT,
        charges LONGTEXT,
        summary TEXT,
        evidence LONGTEXT,
        officer_name VARCHAR(96),
        officer_cid VARCHAR(64),
        lawyer_name VARCHAR(96),
        evidential VARCHAR(8),
        public_interest VARCHAR(8),
        decision_reason TEXT,
        action_plan TEXT,
        log LONGTEXT,
        submitted_at BIGINT NOT NULL,
        decided_at BIGINT NULL,
        updated_at BIGINT NOT NULL,
        INDEX idx_status (status),
        INDEX idx_record (record_id),
        INDEX idx_cid (cid)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_defence (
        id INT AUTO_INCREMENT PRIMARY KEY,
        record_id INT NOT NULL,
        cid VARCHAR(64) NOT NULL,
        solicitor_cid VARCHAR(64) NOT NULL,
        solicitor_name VARCHAR(96),
        disclosure TEXT,
        assigned_by VARCHAR(96),
        active TINYINT(1) NOT NULL DEFAULT 1,
        created_at BIGINT NOT NULL,
        updated_at BIGINT NOT NULL,
        INDEX idx_solicitor (solicitor_cid, active),
        INDEX idx_record (record_id)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_incidents (
        id INT AUTO_INCREMENT PRIMARY KEY,
        ref VARCHAR(32),
        type VARCHAR(48) NOT NULL,
        grade VARCHAR(16),
        status VARCHAR(16) NOT NULL DEFAULT 'Open',
        location VARCHAR(160),
        coords VARCHAR(96),
        narrative TEXT,
        officer_name VARCHAR(96),
        officer_cid VARCHAR(64),
        created_at BIGINT NOT NULL,
        updated_at BIGINT NOT NULL,
        INDEX idx_status (status),
        INDEX idx_ref (ref)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_incident_links (
        id INT AUTO_INCREMENT PRIMARY KEY,
        incident_id INT NOT NULL,
        kind VARCHAR(8) NOT NULL,
        subject_id VARCHAR(64) NOT NULL,
        label VARCHAR(96),
        role VARCHAR(24),
        INDEX idx_incident (incident_id),
        INDEX idx_subject (kind, subject_id)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_evidence (
        id INT AUTO_INCREMENT PRIMARY KEY,
        incident_id INT NOT NULL,
        exhibit_ref VARCHAR(24),
        type VARCHAR(32),
        description VARCHAR(255),
        seized_from VARCHAR(64),
        seized_from_name VARCHAR(96),
        found_at VARCHAR(160),
        status VARCHAR(32),
        photo VARCHAR(400),
        continuity LONGTEXT,
        officer_name VARCHAR(96),
        officer_cid VARCHAR(64),
        created_at BIGINT NOT NULL,
        INDEX idx_incident (incident_id),
        INDEX idx_seized (seized_from)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_intel (
        id INT AUTO_INCREMENT PRIMARY KEY,
        subject_type VARCHAR(8),
        subject_id VARCHAR(64),
        subject_label VARCHAR(96),
        grading VARCHAR(8),
        text TEXT,
        officer_name VARCHAR(96),
        created_at BIGINT NOT NULL,
        INDEX idx_subject (subject_type, subject_id)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_warrants (
        id INT AUTO_INCREMENT PRIMARY KEY,
        type VARCHAR(16) NOT NULL,
        cid VARCHAR(64),
        subject_name VARCHAR(96),
        address VARCHAR(160),
        reason TEXT,
        status VARCHAR(16) NOT NULL DEFAULT 'active',
        issued_by VARCHAR(96),
        closed_by VARCHAR(96),
        created_at BIGINT NOT NULL,
        closed_at BIGINT NULL,
        INDEX idx_cid (cid),
        INDEX idx_status (status)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_notes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        subject_type VARCHAR(8) NOT NULL,
        subject_id VARCHAR(64) NOT NULL,
        text TEXT,
        officer_name VARCHAR(96),
        created_at BIGINT NOT NULL,
        INDEX idx_subject (subject_type, subject_id)
    )]])
    local hasIncidentCol = MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vw_mdt_records' AND COLUMN_NAME = 'incident_id']])
    if (tonumber(hasIncidentCol) or 0) == 0 then
        MySQL.query.await('ALTER TABLE vw_mdt_records ADD COLUMN incident_id INT NULL')
    end
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_anpr (
        id INT AUTO_INCREMENT PRIMARY KEY,
        plate VARCHAR(12) NOT NULL,
        reason VARCHAR(160),
        action VARCHAR(64),
        note TEXT,
        officer_name VARCHAR(96),
        expires_at BIGINT NULL,
        active TINYINT(1) NOT NULL DEFAULT 1,
        created_at BIGINT NOT NULL,
        INDEX idx_plate (plate, active)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_anpr_cameras (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(96) NOT NULL,
        x DOUBLE NOT NULL, y DOUBLE NOT NULL, z DOUBLE NOT NULL,
        heading DOUBLE NOT NULL DEFAULT 0,
        radius DOUBLE NOT NULL DEFAULT 18,
        prop TINYINT(1) NOT NULL DEFAULT 1,
        active TINYINT(1) NOT NULL DEFAULT 1,
        added_by VARCHAR(96),
        created_at BIGINT NOT NULL
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_anpr_fitted (
        id INT AUTO_INCREMENT PRIMARY KEY,
        kind VARCHAR(8) NOT NULL,
        value VARCHAR(32) NOT NULL,
        label VARCHAR(96),
        added_by VARCHAR(96),
        created_at BIGINT NOT NULL,
        INDEX idx_kind (kind, value)
    )]])
    ANPR_TablesReady = true
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_anpr_hits (
        id INT AUTO_INCREMENT PRIMARY KEY,
        plate VARCHAR(12) NOT NULL,
        model VARCHAR(64),
        reasons LONGTEXT,
        source VARCHAR(96),
        officer_name VARCHAR(96),
        location VARCHAR(160),
        coords VARCHAR(96),
        created_at BIGINT NOT NULL,
        INDEX idx_plate (plate),
        INDEX idx_created (created_at)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_audit (
        id INT AUTO_INCREMENT PRIMARY KEY,
        officer_cid VARCHAR(64),
        officer_name VARCHAR(96),
        action VARCHAR(32) NOT NULL,
        subject_type VARCHAR(16),
        subject_id VARCHAR(64),
        subject_label VARCHAR(120),
        reason VARCHAR(64),
        detail VARCHAR(255),
        created_at BIGINT NOT NULL,
        INDEX idx_subject (subject_type, subject_id),
        INDEX idx_officer (officer_cid),
        INDEX idx_created (created_at)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_photos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        cid VARCHAR(64) NOT NULL,
        url VARCHAR(400) NOT NULL,
        record_id INT NULL,
        officer_name VARCHAR(96),
        created_at BIGINT NOT NULL,
        INDEX idx_cid (cid)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_stopsearch (
        id INT AUTO_INCREMENT PRIMARY KEY,
        ref VARCHAR(32),
        cid VARCHAR(64),
        subject_name VARCHAR(96),
        description VARCHAR(255),
        plate VARCHAR(12),
        power VARCHAR(16) NOT NULL,
        authorisation VARCHAR(160),
        object VARCHAR(48),
        grounds TEXT,
        location VARCHAR(160),
        coords VARCHAR(96),
        found TEXT,
        outcome VARCHAR(48),
        gowisely TINYINT(1) NOT NULL DEFAULT 0,
        receipt TINYINT(1) NOT NULL DEFAULT 0,
        incident_id INT NULL,
        officer_name VARCHAR(96),
        officer_cid VARCHAR(64),
        created_at BIGINT NOT NULL,
        INDEX idx_cid (cid),
        INDEX idx_created (created_at)
    )]])
    local hasCustodyCol = MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vw_mdt_records' AND COLUMN_NAME = 'custody']])
    if (tonumber(hasCustodyCol) or 0) == 0 then
        MySQL.query.await('ALTER TABLE vw_mdt_records ADD COLUMN custody LONGTEXT NULL')
    end
    if Config.Audit and (Config.Audit.KeepDays or 0) > 0 then
        MySQL.query('DELETE FROM vw_mdt_audit WHERE created_at < ?', { os.time() - Config.Audit.KeepDays * 86400 })
    end
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_fines (
        id INT AUTO_INCREMENT PRIMARY KEY,
        ref VARCHAR(32),
        cid VARCHAR(64) NOT NULL,
        subject_name VARCHAR(96),
        type VARCHAR(8) NOT NULL,
        offences LONGTEXT,
        amount INT NOT NULL DEFAULT 0,
        points INT NOT NULL DEFAULT 0,
        status VARCHAR(16) NOT NULL,
        increased TINYINT(1) NOT NULL DEFAULT 0,
        due_at BIGINT NULL,
        paid_at BIGINT NULL,
        location VARCHAR(160),
        plate VARCHAR(12),
        notes TEXT,
        court_result TEXT,
        incident_id INT NULL,
        officer_name VARCHAR(96),
        officer_cid VARCHAR(64),
        created_at BIGINT NOT NULL,
        INDEX idx_cid (cid),
        INDEX idx_status (status)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_statements (
        id INT AUTO_INCREMENT PRIMARY KEY,
        incident_id INT NOT NULL,
        kind VARCHAR(16) NOT NULL,
        maker_cid VARCHAR(64),
        maker_name VARCHAR(96),
        occupation VARCHAR(96),
        body LONGTEXT,
        status VARCHAR(16) NOT NULL,
        signed_at BIGINT NULL,
        taken_by VARCHAR(96),
        taken_by_cid VARCHAR(64),
        created_at BIGINT NOT NULL,
        INDEX idx_incident (incident_id),
        INDEX idx_maker (maker_cid)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_defence_notes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        solicitor_cid VARCHAR(64) NOT NULL,
        client_cid VARCHAR(64) NOT NULL,
        record_id INT NULL,
        case_ref VARCHAR(32),
        body TEXT NOT NULL,
        created_at BIGINT NOT NULL,
        updated_at BIGINT NOT NULL,
        INDEX idx_owner (solicitor_cid, client_cid)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_prison_status (
        cid VARCHAR(64) PRIMARY KEY,
        status VARCHAR(16) NOT NULL,
        prison_no VARCHAR(16),
        prison VARCHAR(96),
        cell VARCHAR(32),
        release_at BIGINT NULL,
        updated_at BIGINT NOT NULL
    )]])
    for col, def in pairs({ stash_id = 'VARCHAR(48) NULL', items = 'LONGTEXT NULL', suspect_cid = 'VARCHAR(64) NULL', suspect_name = 'VARCHAR(96) NULL' }) do
        local has = MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vw_mdt_evidence' AND COLUMN_NAME = ?]], { col })
        if (tonumber(has) or 0) == 0 then MySQL.query.await(('ALTER TABLE vw_mdt_evidence ADD COLUMN %s %s'):format(col, def)) end
    end
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_traces (
        id INT AUTO_INCREMENT PRIMARY KEY,
        type VARCHAR(8) NOT NULL,
        x DOUBLE NOT NULL, y DOUBLE NOT NULL, z DOUBLE NOT NULL,
        weapon VARCHAR(48),
        serial VARCHAR(48),
        dna_cid VARCHAR(64),
        location VARCHAR(160),
        created_at BIGINT NOT NULL,
        collected_by VARCHAR(64) NULL,
        collected_name VARCHAR(96) NULL,
        collected_at BIGINT NULL,
        evidence_id INT NULL,
        INDEX idx_open (collected_by, evidence_id),
        INDEX idx_created (created_at)
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_prints (
        cid VARCHAR(64) PRIMARY KEY,
        taken_by VARCHAR(96),
        custody_ref VARCHAR(32),
        created_at BIGINT NOT NULL
    )]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_speed (
        id INT AUTO_INCREMENT PRIMARY KEY,
        plate VARCHAR(12) NOT NULL,
        model VARCHAR(64),
        speed INT NOT NULL,
        speed_limit INT,
        unit VARCHAR(4),
        device VARCHAR(96),
        location VARCHAR(160),
        coords VARCHAR(96),
        officer_name VARCHAR(96),
        officer_cid VARCHAR(64),
        patrol_speed INT NULL,
        locked TINYINT(1) NOT NULL DEFAULT 0,
        fine_ref VARCHAR(32) NULL,
        created_at BIGINT NOT NULL,
        INDEX idx_plate (plate),
        INDEX idx_created (created_at)
    )]])
    do
        local has = MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vw_mdt_anpr_cameras' AND COLUMN_NAME = 'speed_limit']])
        if (tonumber(has) or 0) == 0 then
            local tbl = MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vw_mdt_anpr_cameras']])
            if (tonumber(tbl) or 0) > 0 then MySQL.query.await('ALTER TABLE vw_mdt_anpr_cameras ADD COLUMN speed_limit INT NULL') end
        end
    end
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_dna (
        cid VARCHAR(64) PRIMARY KEY,
        taken_by VARCHAR(96),
        custody_ref VARCHAR(32),
        created_at BIGINT NOT NULL
    )]])
    for col, def in pairs({ forensic = 'LONGTEXT NULL', lab_status = 'VARCHAR(16) NULL', lab_due = 'BIGINT NULL', lab_result = 'LONGTEXT NULL' }) do
        local has = MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vw_mdt_evidence' AND COLUMN_NAME = ?]], { col })
        if (tonumber(has) or 0) == 0 then MySQL.query.await(('ALTER TABLE vw_mdt_evidence ADD COLUMN %s %s'):format(col, def)) end
    end
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS vw_mdt_markers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        subject_type VARCHAR(8) NOT NULL,
        subject_id VARCHAR(64) NOT NULL,
        marker VARCHAR(32) NOT NULL,
        note VARCHAR(255),
        officer_name VARCHAR(96),
        created_at BIGINT NOT NULL,
        INDEX idx_subject (subject_type, subject_id)
    )]])
end)

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function now() return os.time() end

local function trim(s, max)
    if type(s) ~= 'string' then return nil end
    s = s:gsub('^%s+', ''):gsub('%s+$', '')
    if s == '' then return nil end
    return max and s:sub(1, max) or s
end

--- Returns job with job.role = 'police' | 'cps', or nil.
local function access(src)
    local job = Bridge.GetJob(src)
    if not job then return nil end
    local min = Config.Jobs[job.name]
    if min ~= nil and (job.grade or 0) >= min then
        if Config.RequireOnDuty and not job.onduty then return nil end
        job.role = 'police'
        return job
    end
    local def = Config.Defence and Config.Defence.enabled and Config.Defence.jobs or {}
    min = def[job.name]
    if min ~= nil and (job.grade or 0) >= min then
        if Config.Defence.RequireOnDuty and not job.onduty then return nil end
        job.role = 'defence'
        return job
    end
    local cps = Config.CPS and Config.CPS.enabled and Config.CPS.jobs or {}
    min = cps[job.name]
    if min ~= nil and (job.grade or 0) >= min then
        if Config.CPS.RequireOnDuty and not job.onduty then return nil end
        job.role = 'cps'
        return job
    end
    return nil
end

local function officerLabel(src, job)
    local name = Bridge.GetName(src) or 'Unknown'
    local callsign = job and job.callsign
    if callsign and callsign ~= '' and callsign ~= 'NO CALLSIGN' then
        return ('%s %s'):format(callsign, name)
    end
    return name
end

local function fullName(p)
    local n = ((p.firstname or '') .. ' ' .. (p.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
    return n
end

local function markersFor(kind, ids)
    if #ids == 0 then return {} end
    local rows = MySQL.query.await(('SELECT * FROM vw_mdt_markers WHERE subject_type = ? AND subject_id IN (%s) ORDER BY created_at DESC')
        :format(string.rep('?', #ids, ',')), { kind, table.unpack(ids) }) or {}
    local map = {}
    for _, r in ipairs(rows) do
        map[r.subject_id] = map[r.subject_id] or {}
        table.insert(map[r.subject_id], { id = r.id, marker = r.marker, note = r.note, officer = r.officer_name, at = r.created_at })
    end
    return map
end

local function decodeBail(r)
    local b = {
        id = r.id, cid = r.cid, name = r.subject_name, recordId = r.record_id, custodyRef = r.custody_ref,
        type = r.bail_type, offences = Bridge.Decode(r.offences), conditions = Bridge.Decode(r.conditions),
        returnAt = r.return_at, station = r.return_station, status = r.status, notes = r.notes,
        officer = r.officer_name, closedBy = r.closed_by, createdAt = r.created_at, updatedAt = r.updated_at,
    }
    b.overdue = b.status == 'active' and b.returnAt ~= nil and b.returnAt < now()
    return b
end

local function activeBailMap(cids)
    if #cids == 0 then return {} end
    local rows = MySQL.query.await(("SELECT * FROM vw_mdt_bail WHERE status = 'active' AND cid IN (%s)")
        :format(string.rep('?', #cids, ',')), cids) or {}
    local map = {}
    for _, r in ipairs(rows) do map[r.cid] = decodeBail(r) end
    return map
end

local function namesFor(cids)
    local out = {}
    for _, cid in ipairs(cids) do
        if not out[cid] then
            local p = Bridge.GetPerson(cid)
            out[cid] = p and fullName(p) or nil
        end
    end
    return out
end

local function bailTypeById(id)
    for _, t in ipairs(Config.BailTypes) do if t.id == id then return t end end
end

local function conditionById(id)
    for _, c in ipairs(Config.BailConditions) do if c.id == id then return c end end
end

---------------------------------------------------------------------------
-- Handlers
---------------------------------------------------------------------------
local H = {}

H.init = function(src, job)
    local interviews = Interviews.Available() and Interviews.CanListen(job)
    return {
        officer = { name = officerLabel(src, job), job = job.label, grade = job.gradeLabel, supervisor = job.role == 'police' and (job.grade or 0) >= Config.SupervisorGrade },
        role = job.role,
        defence = Config.Defence and Config.Defence.enabled or false,
        cps = Config.CPS and Config.CPS.enabled and {
            evidenceTypes = Config.CPS.EvidenceTypes,
            nfaReasons = Config.CPS.NfaReasons,
            policeCanWithdraw = Config.CPS.PoliceCanWithdraw,
        } or false,
        force = { name = Config.ForceName, short = Config.ForceShort },
        stations = Config.Stations,
        bailTypes = Config.BailTypes,
        bailConditions = Config.BailConditions,
        defaultBailDays = Config.DefaultBailDays,
        outcomes = Config.Outcomes,
        crest = Config.ForceCrest,
        incidentTypes = Config.IncidentTypes,
        incidentGrades = Config.IncidentGrades,
        incidentStatuses = Config.IncidentStatuses,
        incidentRoles = Config.IncidentRoles,
        evidenceTypes = Config.EvidenceTypes,
        evidenceStatuses = Config.EvidenceStatuses,
        intel = { source = Config.IntelSource, assessment = Config.IntelAssessment, handling = Config.IntelHandling },
        warrantTypes = Config.WarrantTypes,
        highRisk = Config.HighRiskMarkers,
        callsign = job.callsign,
        dispatch = Dispatch.Connected(),
        anpr = Config.ANPR and Config.ANPR.enabled and { actions = Config.ANPR.Actions } or false,
        audit = Config.Audit.enabled and { reasons = Config.Audit.Reasons, require = Config.Audit.RequireReason, canView = job.role == 'police' and (job.grade or 0) >= (Config.Audit.ViewGrade or 3) } or false,
        custody = { reviewReasons = Config.Custody.ReviewReasons, extensions = Config.Custody.Extensions, reviewGrade = Config.Custody.ReviewGrade, hourLength = Config.Custody.HourLength },
        mugshot = Config.Mugshot.enabled,
        stopSearch = Config.StopSearch.enabled and { powers = Config.StopSearch.Powers, objects = Config.StopSearch.Objects, outcomes = Config.StopSearch.Outcomes } or false,
        grade = job.grade,
        prison = Prison.Name(),
        forensics = Config.Forensics and Config.Forensics.enabled ~= false or false,
        fingerprints = Config.Forensics and Config.Forensics.enabled ~= false and Config.Forensics.Fingerprints or false,
        speed = Config.ANPR and Config.ANPR.Speed and Config.ANPR.Speed.enabled and { unit = Config.ANPR.Speed.Unit } or false,
        evidenceStorage = Config.Evidence and Config.Evidence.enabled ~= false and Inv.Pick() ~= nil,
        remandMinutes = (Config.Prison or {}).RemandMinutes or 60,
        sentencing = Config.Sentencing and Config.Sentencing.enabled and Config.Sentencing or false,
        fines = Config.Fines.enabled and { currency = Config.Fines.Currency, offences = Config.Fines.Offences, dueDays = Config.Fines.DueDays, increase = Config.Fines.UnpaidIncrease } or false,
        statements = Config.Statements.enabled and { kinds = Config.Statements.Kinds, declaration = Config.Statements.Declaration } or false,
        onduty = job.onduty,
        offences = Config.Offences,
        markers = Config.Markers,
        endorsementCodes = (Config.Licences.dvla or Config.Licences.citydriving or {}).codes or {},
        dvla = Licences.DvlaResource() ~= nil,
        interviews = interviews,
        serverTime = now(),
    }
end

H.home = function(src)
    local t = now()
    local due = MySQL.query.await([[SELECT * FROM vw_mdt_bail WHERE status = 'active' AND return_at IS NOT NULL
        AND return_at < ? ORDER BY return_at ASC LIMIT 25]], { t + 172800 }) or {}
    local recent = MySQL.query.await('SELECT id, ref, cid, subject_name, outcome, officer_name, created_at, offences FROM vw_mdt_records ORDER BY created_at DESC LIMIT 12') or {}
    local bails = {}
    for _, r in ipairs(due) do bails[#bails + 1] = decodeBail(r) end
    for _, r in ipairs(recent) do r.offences = Bridge.Decode(r.offences) end

    local decisions = {}
    if Config.CPS and Config.CPS.enabled then
        for _, r in ipairs(MySQL.query.await([[SELECT * FROM vw_mdt_cps WHERE status IN ('charge','nfa','more_evidence')
            AND updated_at > ? ORDER BY updated_at DESC LIMIT 12]], { t - 604800 }) or {}) do
            decisions[#decisions + 1] = DecodeCase(r)
        end
    end

    local live = MySQL.query.await("SELECT id, ref, type, grade, status, location, created_at FROM vw_mdt_incidents WHERE status <> 'Closed' ORDER BY FIELD(grade, 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4'), created_at DESC LIMIT 6") or {}
    local calls, dispatchName = Dispatch.Get(src)

    local stats = {
        openIncidents = MySQL.scalar.await("SELECT COUNT(*) FROM vw_mdt_incidents WHERE status <> 'Closed'") or 0,
        activeCalls = dispatchName and #calls or nil,
        wanted = #WantedCids(),
        stolen = MySQL.scalar.await("SELECT COUNT(DISTINCT subject_id) FROM vw_mdt_markers WHERE subject_type = 'vehicle' AND marker = 'Stolen'") or 0,
        bailDue = #bails,
        cpsPending = (Config.CPS and Config.CPS.enabled) and (MySQL.scalar.await("SELECT COUNT(*) FROM vw_mdt_cps WHERE status = 'pending'") or 0) or nil,
    }

    local anyHousing = false
    for key, h in pairs(Config.Housing) do
        if type(h) == 'table' and h.enabled and Schema.Running(h.resource) then anyHousing = true end
    end
    local system = {
        { label = 'PNC', online = true },
        { label = 'DVLA', online = Licences.DvlaResource() ~= nil, detail = select(2, Licences.DvlaResource()) },
        { label = 'Housing', online = anyHousing },
        { label = 'CCTV / Interviews', online = Interviews.Available() },
        { label = 'Dispatch', online = dispatchName ~= nil, detail = dispatchName },
        { label = 'MID / MOT / VED', online = VS.Running() ~= nil, detail = VS.Running() },
        { label = 'Prison', online = Prison.Name() ~= nil, detail = Prison.Name() },
        { label = 'Evidence store', online = Inv.Name() ~= nil, detail = Inv.Name() },
        { label = 'Ambulance', online = EMS.Running() ~= nil, detail = EMS.Running() },
        { label = 'ANPR', online = Config.ANPR and Config.ANPR.enabled or false, detail = Config.ANPR and Config.ANPR.enabled and ('%d cameras'):format(ANPR_CameraCount and ANPR_CameraCount() or 0) or nil },
    }

    local topCalls = {}
    for i = 1, math.min(6, #calls) do topCalls[i] = calls[i] end
    return { bails = bails, records = recent, cps = decisions, live = live, calls = dispatchName and topCalls or nil, dispatch = dispatchName, stats = stats, system = system,
        searches = RecentSearches[Bridge.GetCid(src) or ''] or {}, serverTime = t }
end

H.searchPeople = function(src, _, d)
    local ref, first, last = trim(d.ref, 64), trim(d.first, 32), trim(d.last, 32)
    local q = ref or trim(((first or '') .. ' ' .. (last or '')), 64) or trim(d.q, 64)
    if not q or #q < 2 then return { error = 'Enter at least two letters of a name, or a reference number.' } end
    local results = Bridge.SearchPeople(q, 40)

    -- Nothing by name or reference: try the licence number from the card in hand
    if #results == 0 and Licences.FindCids then
        local seen = {}
        for _, lcid in ipairs(Licences.FindCids(q) or {}) do
            if not seen[lcid] then
                seen[lcid] = true
                for _, p in ipairs(Bridge.SearchPeople(lcid, 5) or {}) do
                    if p.cid == lcid then results[#results + 1] = p end
                end
            end
        end
    end

    -- Optional date of birth filter: compares digits only, so 14/03/1996 matches 1996-03-14.
    local dob = trim(d.dob, 16)
    if dob then
        local y, m, dd = dob:match('(%d%d%d%d)%-(%d%d)%-(%d%d)')
        local keep = {}
        for _, p in ipairs(results) do
            local digits = tostring(p.dob or ''):gsub('%D', '')
            if y and (digits == y .. m .. dd or digits == dd .. m .. y) then keep[#keep + 1] = p end
        end
        results = keep
    end

    local cids = {}
    for _, p in ipairs(results) do cids[#cids + 1] = p.cid; p.metadata = nil end
    local markers, bails = markersFor('person', cids), activeBailMap(cids)
    local wanted = {}
    for _, c in ipairs(WantedCids(cids)) do wanted[c] = true end
    for i, p in ipairs(results) do
        p.markers = markers[p.cid] or {}
        p.bail = bails[p.cid]
        p.online = Bridge.GetSource(p.cid) ~= nil
        p.status = wanted[p.cid] and 'wanted' or ((#p.markers > 0 or p.bail) and 'caution' or 'clear')
        if i <= 12 and not d.quick then
            local h = Housing.Get(p.cid)[1]
            p.address = h and table.concat({ h.label, h.address }, ', ') or nil
        end
    end
    if not d.quick then RecordSearch(src, q, 'Person search') end
    return { results = results }
end

H.getPerson = function(_, job, d)
    local cid = trim(d.cid, 64)
    local p = cid and Bridge.GetPerson(cid)
    if not p then return { error = 'No record found for that reference.' } end
    p.metadata = nil
    p.online = Bridge.GetSource(cid) ~= nil

    local records = MySQL.query.await('SELECT * FROM vw_mdt_records WHERE cid = ? ORDER BY created_at DESC', { cid }) or {}
    local refs = {}
    for _, r in ipairs(records) do
        r.offences = Bridge.Decode(r.offences)
        if r.ref then refs[#refs + 1] = r.ref end
    end

    local bail = {}
    for _, r in ipairs(MySQL.query.await('SELECT * FROM vw_mdt_bail WHERE cid = ? ORDER BY created_at DESC', { cid }) or {}) do
        bail[#bail + 1] = decodeBail(r)
        if r.custody_ref then refs[#refs + 1] = r.custody_ref end
    end

    local vehicles = Bridge.GetVehiclesByOwner(cid)
    local plates = {}
    for _, v in ipairs(vehicles) do plates[#plates + 1] = v.plate end
    local vMarkers = markersFor('vehicle', plates)
    local vsBulk = VS.Running() and VS.Bulk(plates) or {}
    for _, v in ipairs(vehicles) do
        v.markers = vMarkers[v.plate] or {}
        v.flags = VS.Flags(vsBulk[ANPR_Key(v.plate)])
    end

    local licences = Licences.Get(cid)
    for _, b in ipairs(licences) do
        if b.dvla and b.photo then p.photo = b.photo end
    end
    local photos = MySQL.query.await('SELECT url, officer_name, created_at, record_id FROM vw_mdt_photos WHERE cid = ? ORDER BY created_at DESC LIMIT 12', { cid }) or {}
    if photos[1] then p.photo = photos[1].url end
    p.photos = photos

    local interviews
    if Interviews.Available() and Interviews.CanListen(job) then
        interviews = Interviews.ForPerson(fullName(p), refs, cid)
    end

    local cases = {}
    for _, r in ipairs(MySQL.query.await('SELECT * FROM vw_mdt_cps WHERE cid = ? ORDER BY submitted_at DESC', { cid }) or {}) do
        local c = DecodeCase(r)
        if not cases[c.recordId] then cases[c.recordId] = c end
    end
    for _, r in ipairs(records) do
        local c = cases[r.id]
        if c then r.cps = { id = c.id, status = c.status, lawyer = c.lawyer, decidedAt = c.decidedAt } end
    end
    for _, a in ipairs(MySQL.query.await('SELECT * FROM vw_mdt_defence WHERE cid = ? AND active = 1', { cid }) or {}) do
        for _, r in ipairs(records) do
            if r.id == a.record_id then
                r.defence = { id = a.id, solicitor = a.solicitor_name, disclosure = a.disclosure, assignedBy = a.assigned_by, at = a.created_at }
            end
        end
    end

    local warrants = MySQL.query.await("SELECT * FROM vw_mdt_warrants WHERE cid = ? ORDER BY created_at DESC", { cid }) or {}
    local notes = MySQL.query.await("SELECT * FROM vw_mdt_notes WHERE subject_type = 'person' AND subject_id = ? ORDER BY created_at DESC LIMIT 50", { cid }) or {}
    local intel = MySQL.query.await("SELECT * FROM vw_mdt_intel WHERE subject_type = 'person' AND subject_id = ? ORDER BY created_at DESC LIMIT 50", { cid }) or {}
    local incidents = MySQL.query.await([[SELECT i.id, i.ref, i.type, i.status, i.location, i.created_at, l.role FROM vw_mdt_incident_links l
        JOIN vw_mdt_incidents i ON i.id = l.incident_id WHERE l.kind = 'person' AND l.subject_id = ? ORDER BY i.created_at DESC]], { cid }) or {}
    local markers = (markersFor('person', { cid }))[cid] or {}

    local convictions = 0
    for _, r in ipairs(records) do
        if r.outcome == 'Charged' or (r.cps and r.cps.status == 'charge') then convictions = convictions + 1 end
    end

    -- One timeline of everything that has happened to this person.
    local activity = {}
    local function act(at, kind, detail, officer) activity[#activity + 1] = { at = at, type = kind, detail = detail, officer = officer } end
    for _, r in ipairs(records) do act(r.created_at, 'Arrest', table.concat(r.offences or {}, '; '), r.officer_name) end
    for _, b in ipairs(bail) do act(b.createdAt, 'Bail', bailTypeById(b.type) and bailTypeById(b.type).label or b.type, b.officer) end
    for _, i in ipairs(incidents) do act(i.created_at, i.type, ('%s at %s (%s)'):format(i.ref or '', i.location or 'unknown location', i.role or 'Involved'), nil) end
    for _, w in ipairs(warrants) do act(w.created_at, 'Warrant', w.reason or '', w.issued_by) end
    for _, n in ipairs(notes) do act(n.created_at, 'Note', n.text, n.officer_name) end
    for _, m in ipairs(markers) do act(m.at, 'Marker', m.marker .. (m.note and (': ' .. m.note) or ''), m.officer) end
    table.sort(activity, function(a, b) return (a.at or 0) > (b.at or 0) end)

    for _, r in ipairs(records) do
        if r.outcome == Config.Outcomes[1] then r.clock = CustodyClock(r) end
        r.custody = nil
    end
    local stopSearch = MySQL.query.await('SELECT * FROM vw_mdt_stopsearch WHERE cid = ? ORDER BY created_at DESC LIMIT 40', { cid }) or {}
    for _, x in ipairs(stopSearch) do activity[#activity + 1] = { at = x.created_at, type = 'Stop and search', detail = ('%s: %s (%s)'):format(x.object or '', x.outcome or '', x.ref or ''), officer = x.officer_name } end
    table.sort(activity, function(a, b) return (a.at or 0) > (b.at or 0) end)

    -- Court results already reach the activity timeline as notes written by vinewood-moj.
    local court = MoJ.Person(cid)

    local prisonStatus = MySQL.single.await("SELECT * FROM vw_mdt_prison_status WHERE cid = ? AND status = 'in_custody'", { cid })
    local evidence = Evidence_ForPerson(cid)
    local dnaOnFile = MySQL.single.await('SELECT taken_by, custody_ref, created_at FROM vw_mdt_dna WHERE cid = ?', { cid })
    local printsOnFileRow = MySQL.single.await('SELECT taken_by, custody_ref, created_at FROM vw_mdt_prints WHERE cid = ?', { cid })

    return {
        prisonStatus = prisonStatus,
        evidence = evidence,
        dna = dnaOnFile,
        prints = printsOnFileRow,
        court = court,
        stopSearch = stopSearch,
        admitted = EMS.Admitted(cid),
        person = p,
        markers = markers,
        licences = licences,
        housing = Housing.Get(cid),
        vehicles = vehicles,
        records = records,
        bail = bail,
        interviews = interviews,
        warrants = warrants,
        notes = notes,
        intel = intel,
        incidents = incidents,
        activity = activity,
        convictions = convictions,
        serverTime = now(),
    }
end

-- Vehicles carrying a marker (Stolen by default), newest first.
H.flaggedVehicles = function(_, _, d)
    local marker = trim(d.marker, 32) or 'Stolen'
    local valid = false
    for _, m in ipairs(Config.Markers.vehicle) do if m == marker then valid = true end end
    if not valid then return { error = 'Unknown marker.' } end
    local rows = MySQL.query.await([[SELECT subject_id AS plate, MAX(note) AS note, MAX(officer_name) AS officer, MAX(created_at) AS at
        FROM vw_mdt_markers WHERE subject_type = 'vehicle' AND marker = ? GROUP BY subject_id ORDER BY at DESC LIMIT 100]], { marker }) or {}
    local owners = {}
    for _, r in ipairs(rows) do
        local v = Bridge.GetVehicle(r.plate)
        if v then r.model, r.owner = v.model, v.owner; if v.owner then owners[#owners + 1] = v.owner end end
    end
    local names = namesFor(owners)
    for _, r in ipairs(rows) do r.ownerName = r.owner and names[r.owner] or nil end
    local counts = {}
    for _, r in ipairs(MySQL.query.await("SELECT marker, COUNT(DISTINCT subject_id) AS n FROM vw_mdt_markers WHERE subject_type = 'vehicle' GROUP BY marker") or {}) do counts[r.marker] = r.n end
    return { results = rows, marker = marker, counts = counts }
end

-- Everyone shown as wanted: an active arrest-type warrant, or a Wanted marker.
H.wantedPeople = function()
    local cids = WantedCids()
    local out = {}
    for _, cid in ipairs(cids) do
        local p = Bridge.GetPerson(cid)
        if p then
            p.metadata = nil
            p.online = Bridge.GetSource(cid) ~= nil
            local w = MySQL.single.await("SELECT type, reason, created_at FROM vw_mdt_warrants WHERE cid = ? AND status = 'active' ORDER BY created_at DESC LIMIT 1", { cid })
            local m = MySQL.single.await("SELECT note, created_at FROM vw_mdt_markers WHERE subject_type = 'person' AND subject_id = ? AND marker = 'Wanted' ORDER BY created_at DESC LIMIT 1", { cid })
            p.why = w and w.reason or (m and m.note) or 'Wanted marker'
            p.warrantType = w and w.type or nil
            p.since = (w and w.created_at) or (m and m.created_at)
            out[#out + 1] = p
        end
    end
    table.sort(out, function(a, b) return (a.since or 0) > (b.since or 0) end)
    return { results = out }
end

H.searchVehicles = function(src, _, d)
    local q = trim(d.q, 12)
    if not q or #q < 2 then return { error = 'Enter at least two characters of the registration.' } end
    local results = Bridge.SearchVehicles(q)
    local plates, owners = {}, {}
    for _, v in ipairs(results) do
        plates[#plates + 1] = v.plate
        if v.owner then owners[#owners + 1] = v.owner end
    end
    local markers, names = markersFor('vehicle', plates), namesFor(owners)
    local ownerMarkers, bails = markersFor('person', owners), activeBailMap(owners)
    local vsSearch = VS.Running() and VS.Bulk(plates) or {}
    for _, v in ipairs(results) do
        v.markers = markers[v.plate] or {}
        v.ownerName = names[v.owner]
        v.ownerMarkers = ownerMarkers[v.owner] or {}
        v.ownerBail = bails[v.owner]
        if v.owner then v.ownerLicence, v.ownerPoints = Licences.Summary(v.owner) end
        v.flags = VS.Flags(vsSearch[ANPR_Key(v.plate)])
    end
    RecordSearch(src, q:upper(), 'Vehicle search')
    return { results = results }
end

H.addMarker = function(src, job, d)
    local kind = d.kind == 'vehicle' and 'vehicle' or 'person'
    local id, marker = trim(d.id, 64), trim(d.marker, 32)
    if not id or not marker then return { error = 'Choose a marker.' } end
    local allowed = false
    for _, m in ipairs(Config.Markers[kind]) do if m == marker then allowed = true end end
    if not allowed then return { error = 'That marker is not available.' } end
    MySQL.insert.await('INSERT INTO vw_mdt_markers (subject_type, subject_id, marker, note, officer_name, created_at) VALUES (?, ?, ?, ?, ?, ?)',
        { kind, id, marker, trim(d.note, 255), officerLabel(src, job), now() })
    if ANPR_ClearCache then ANPR_ClearCache() end
    return { ok = true }
end

H.removeMarker = function(_, job, d)
    if (job.grade or 0) < Config.SupervisorGrade then return { error = 'Removing markers needs a supervisor.' } end
    MySQL.update.await('DELETE FROM vw_mdt_markers WHERE id = ?', { tonumber(d.id) })
    if ANPR_ClearCache then ANPR_ClearCache() end
    return { ok = true }
end

H.createRecord = function(src, job, d)
    local cid = trim(d.cid, 64)
    local p = cid and Bridge.GetPerson(cid)
    if not p then return { error = 'Select a person first.' } end
    local offences = type(d.offences) == 'table' and d.offences or {}
    local outcome = trim(d.outcome, 64) or Config.Outcomes[1]
    if #offences == 0 then return { error = 'Add at least one offence.' } end
    local incidentId = tonumber(d.incidentId)
    if incidentId and not MySQL.scalar.await('SELECT id FROM vw_mdt_incidents WHERE id = ?', { incidentId }) then incidentId = nil end
    local id = MySQL.insert.await([[INSERT INTO vw_mdt_records (cid, subject_name, type, offences, outcome, narrative, officer_name, officer_cid, created_at, incident_id)
        VALUES (?, ?, 'custody', ?, ?, ?, ?, ?, ?, ?)]],
        { cid, fullName(p), json.encode(offences), outcome, trim(d.narrative, 4000), officerLabel(src, job), Bridge.GetCid(src), now(), incidentId })
    if incidentId then
        if not MySQL.scalar.await("SELECT id FROM vw_mdt_incident_links WHERE incident_id = ? AND kind = 'person' AND subject_id = ?", { incidentId, cid }) then
            MySQL.insert.await("INSERT INTO vw_mdt_incident_links (incident_id, kind, subject_id, label, role) VALUES (?, 'person', ?, ?, 'Suspect')", { incidentId, cid, fullName(p) })
        end
    end
    local ref = ('%s/%s/%05d'):format(Config.ForceShort, os.date('%y%m'), id)
    MySQL.update.await('UPDATE vw_mdt_records SET ref = ? WHERE id = ?', { ref, id })
    if Config.Forensics and Config.Forensics.enabled and Config.Forensics.DNAOnArrest and Forensics_TakeDNA then
        Forensics_TakeDNA(cid, officerLabel(src, job), ref)
    end
    if Config.Forensics and Config.Forensics.enabled and Config.Forensics.Fingerprints and Config.Forensics.PrintsOnArrest and Forensics_TakePrints then
        Forensics_TakePrints(cid, officerLabel(src, job), ref)
    end
    return { ok = true, id = id, ref = ref }
end

H.deleteRecord = function(_, job, d)
    if (job.grade or 0) < Config.SupervisorGrade then return { error = 'Deleting records needs a supervisor.' } end
    MySQL.update.await('DELETE FROM vw_mdt_records WHERE id = ?', { tonumber(d.id) })
    return { ok = true }
end

H.releaseOnBail = function(src, job, d)
    local cid = trim(d.cid, 64)
    local p = cid and Bridge.GetPerson(cid)
    if not p then return { error = 'Select a person first.' } end

    local bt = bailTypeById(d.type)
    if not bt then return { error = 'Choose a type of bail.' } end

    local existing = MySQL.scalar.await("SELECT id FROM vw_mdt_bail WHERE cid = ? AND status = 'active' LIMIT 1", { cid })
    if existing then return { error = 'This person is already on bail. Close the existing bail first.' } end

    local returnAt, station
    if bt.needsDate then
        returnAt = tonumber(d.returnAt)
        if not returnAt or returnAt <= now() then return { error = 'Set a return date in the future.' } end
        station = trim(d.station, 96)
        if not station then return { error = 'Choose where they must answer bail.' } end
    end

    local conditions = {}
    for _, c in ipairs(type(d.conditions) == 'table' and d.conditions or {}) do
        local def = conditionById(c.id)
        if def then
            local value = def.input and trim(c.value, 160) or nil
            if def.input and not value then return { error = ('Fill in: %s'):format(def.label) } end
            conditions[#conditions + 1] = { id = def.id, label = def.label, value = value }
        end
    end

    local offences = type(d.offences) == 'table' and d.offences or {}
    local recordId, custodyRef = tonumber(d.recordId), nil
    local wasRemanded = false
    if recordId then
        custodyRef = MySQL.scalar.await('SELECT ref FROM vw_mdt_records WHERE id = ? AND cid = ?', { recordId, cid })
        if not custodyRef then recordId = nil end
        wasRemanded = MySQL.scalar.await('SELECT outcome FROM vw_mdt_records WHERE id = ?', { recordId }) == 'Remanded in custody'
        if #offences == 0 and recordId then
            offences = Bridge.Decode(MySQL.scalar.await('SELECT offences FROM vw_mdt_records WHERE id = ?', { recordId }))
        end
    end
    if #offences == 0 then return { error = 'Add the offences they are bailed for.' } end

    local officer = officerLabel(src, job)
    local t = now()
    local id = MySQL.insert.await([[INSERT INTO vw_mdt_bail (cid, subject_name, record_id, custody_ref, bail_type, offences, conditions,
        return_at, return_station, status, notes, officer_name, officer_cid, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'active', ?, ?, ?, ?, ?)]],
        { cid, fullName(p), recordId, custodyRef, bt.id, json.encode(offences), json.encode(conditions),
          returnAt, station, trim(d.notes, 1000), officer, Bridge.GetCid(src), t, t })

    if recordId then
        local outcome = bt.id == 'rui' and 'Released under investigation' or 'Released on bail'
        MySQL.update.await('UPDATE vw_mdt_records SET outcome = ? WHERE id = ?', { outcome, recordId })
        TriggerEvent('vinewood-mdt:server:custodyOutcome', recordId, custodyRef, cid, outcome, src)
    end

    local bail = decodeBail(MySQL.single.await('SELECT * FROM vw_mdt_bail WHERE id = ?', { id }))
    local target = Bridge.GetSource(cid)

    if target then
        local msg = bt.needsDate
            and ('You have been released on %s. Answer bail at %s on %s.'):format(bt.label, station, os.date('%d/%m/%Y at %H:%M', returnAt))
            or ('You have been %s. You will be contacted about the outcome.'):format(bt.label:lower())
        if #conditions > 0 then msg = msg .. (' %d condition(s) apply.'):format(#conditions) end
        Bridge.Notify(target, msg, 'inform')
        TriggerClientEvent('vinewood-mdt:client:bailNotice', target, bail, Config.ForceName)

        if Config.BailNoticeItem and Inv.Pick() then
            pcall(function()
                Inv.Give(target, Config.BailNoticeItem, 1, {
                    description = ('%s - %s%s'):format(bt.label, bail.custodyRef or ('Bail ' .. id),
                        returnAt and (' - answer ' .. os.date('%d/%m/%Y %H:%M', returnAt)) or ''),
                    bail = id,
                })
            end)
        end
    end

    pcall(Config.OnBailGranted, target, bail)
    -- Remanded? Let them out of prison now they've been bailed.
    if Config.Prison and Config.Prison.ReleaseOnBail ~= false and recordId then
        if wasRemanded then Prison.Release(cid, 'bail') end
    end
        TriggerEvent('vinewood-mdt:server:bailGranted', bail, target)
    return { ok = true, bail = bail }
end

H.updateBail = function(src, job, d)
    local id = tonumber(d.id)
    local row = id and MySQL.single.await('SELECT * FROM vw_mdt_bail WHERE id = ?', { id })
    if not row then return { error = 'Bail record not found.' } end
    if row.status ~= 'active' then return { error = 'This bail is already closed.' } end
    local officer = officerLabel(src, job)
    local action = d.action

    if action == 'extend' then
        local at = tonumber(d.returnAt)
        if not at or at <= now() then return { error = 'Set a return date in the future.' } end
        MySQL.update.await('UPDATE vw_mdt_bail SET return_at = ?, return_station = COALESCE(?, return_station), updated_at = ? WHERE id = ?',
            { at, trim(d.station, 96), now(), id })
        local target = Bridge.GetSource(row.cid)
        if target then Bridge.Notify(target, ('Your bail return date has changed to %s.'):format(os.date('%d/%m/%Y at %H:%M', at))) end
    elseif action == 'nfa' then
        return H.nfa(src, job, { cid = row.cid, recordId = row.record_id, reason = d.reason })
    elseif action == 'answered' or action == 'breached' or action == 'cancelled' then
        MySQL.update.await('UPDATE vw_mdt_bail SET status = ?, closed_by = ?, updated_at = ? WHERE id = ?', { action, officer, now(), id })
        if action == 'breached' then
            MySQL.insert.await('INSERT INTO vw_mdt_markers (subject_type, subject_id, marker, note, officer_name, created_at) VALUES (?, ?, ?, ?, ?, ?)',
                { 'person', row.cid, 'Wanted', ('Failed to answer bail / breach of conditions (%s)'):format(row.custody_ref or ('bail ' .. id)), officer, now() })
        end
    else
        return { error = 'Unknown bail action.' }
    end
    return { ok = true }
end

H.endorse = function(src, job, d)
    local points = math.floor(tonumber(d.points) or 0)
    if points < 1 or points > 11 then return { error = 'Points must be between 1 and 11.' } end
    local code, reason = trim(d.code, 8), trim(d.reason, 120)
    if not code or not reason then return { error = 'Choose an endorsement code.' } end
    local ok, err, total, autoBanned, queued = Licences.Endorse(trim(d.cid, 64), points, code, reason, officerLabel(src, job))
    if not ok then return { error = err } end
    return { ok = true, total = total, autoBanned = autoBanned, queued = queued }
end

H.disqualify = function(src, job, d)
    local days = tonumber(d.days)
    if days and days < 0 then days = nil end
    local reason = trim(d.reason, 120)
    if not reason then return { error = 'Give a reason for the disqualification.' } end
    local ok, err, queued = Licences.Disqualify(trim(d.cid, 64), days, reason, officerLabel(src, job))
    if not ok then return { error = err } end
    return { ok = true, queued = queued }
end

H.liftDisqualification = function(_, job, d)
    if (job.grade or 0) < Config.SupervisorGrade then return { error = 'Lifting a disqualification needs a supervisor.' } end
    local ok, err, queued = Licences.LiftDisqualification(trim(d.cid, 64))
    if not ok then return { error = err } end
    return { ok = true, queued = queued }
end

H.clearPoints = function(_, job, d)
    if (job.grade or 0) < Config.SupervisorGrade then return { error = 'Clearing points needs a supervisor.' } end
    local ok, err, queued = Licences.ClearPoints(trim(d.cid, 64))
    if not ok then return { error = err } end
    return { ok = true, queued = queued }
end

H.revokeCategory = function(_, job, d)
    if (job.grade or 0) < Config.SupervisorGrade then return { error = 'Revoking a licence needs a supervisor.' } end
    local cat = trim(d.category, 24)
    if not cat then return { error = 'Choose a category.' } end
    local ok, err = Licences.RevokeCategory(trim(d.cid, 64), cat)
    if not ok then return { error = err } end
    return { ok = true }
end

H.clearPendingLicence = function(_, job, d)
    if (job.grade or 0) < Config.SupervisorGrade then return { error = 'Cancelling queued actions needs a supervisor.' } end
    local ok, err = Licences.ClearPending(trim(d.cid, 64))
    if not ok then return { error = err } end
    return { ok = true }
end

H.searchInterviews = function(_, job, d)
    if not Interviews.Available() or not Interviews.CanListen(job) then return { error = 'Interview recordings are not available.' } end
    return { results = Interviews.Search(trim(d.q, 64) or '') }
end

H.getInterview = function(src, job, d)
    if job.role == 'defence' then return H.defenceInterview(src, job, d) end
    if not Interviews.Available() or not Interviews.CanListen(job) then return { error = 'Interview recordings are not available.' } end
    local s = Interviews.Get(tonumber(d.id))
    if not s then return { error = 'Interview not found.' } end
    return { interview = s }
end

---------------------------------------------------------------------------
-- Shared lookups
---------------------------------------------------------------------------
RecentSearches = {}

function RecordSearch(src, q, kind)
    local cid = Bridge.GetCid(src)
    if not cid then return end
    local list = RecentSearches[cid] or {}
    for i = #list, 1, -1 do if list[i].q == q then table.remove(list, i) end end
    table.insert(list, 1, { q = q, kind = kind, at = now() })
    while #list > 6 do table.remove(list) end
    RecentSearches[cid] = list
end

local function warrantType(id)
    for _, w in ipairs(Config.WarrantTypes) do if w.id == id then return w end end
end

--- Character ids that are wanted: an active arrest-type warrant, or a Wanted marker.
function WantedCids(filter)
    local types = {}
    for _, w in ipairs(Config.WarrantTypes) do if w.wanted then types[#types + 1] = w.id end end
    local set = {}
    local args, where = {}, ''
    if filter then
        if #filter == 0 then return {} end
        where = (' AND %s IN (%s)'):format('%s', string.rep('?', #filter, ','))
    end
    if #types > 0 then
        local a = {}
        for _, t in ipairs(types) do a[#a + 1] = t end
        for _, c in ipairs(filter or {}) do a[#a + 1] = c end
        for _, r in ipairs(MySQL.query.await(("SELECT DISTINCT cid FROM vw_mdt_warrants WHERE status = 'active' AND type IN (%s)%s")
            :format(string.rep('?', #types, ','), where:format('cid')), a) or {}) do set[r.cid] = true end
    end
    for _, c in ipairs(filter or {}) do args[#args + 1] = c end
    for _, r in ipairs(MySQL.query.await(("SELECT DISTINCT subject_id FROM vw_mdt_markers WHERE subject_type = 'person' AND marker = 'Wanted'%s")
        :format(where:format('subject_id')), args) or {}) do set[r.subject_id] = true end
    local out = {}
    for c in pairs(set) do out[#out + 1] = c end
    return out
end

local function linksFor(incidentId)
    return MySQL.query.await('SELECT * FROM vw_mdt_incident_links WHERE incident_id = ?', { incidentId }) or {}
end

---------------------------------------------------------------------------
-- Vehicle record
---------------------------------------------------------------------------
H.getVehicle = function(_, _, d)
    local plate = trim(d.plate, 12)
    local v = plate and Bridge.GetVehicle(plate)
    if not v then return { error = 'No registered keeper found for that vehicle.' } end
    v.markers = (markersFor('vehicle', { v.plate }))[v.plate] or {}
    local vs = VS.Status(v.plate)
    if vs then
        v.mid, v.mot, v.ved = vs.insurance, vs.mot, vs.tax
        v.services = true
        local bulk = VS.Bulk({ v.plate })
        v.flags = VS.Flags(bulk[ANPR_Key(v.plate)])
    end
    if v.owner then
        local p = Bridge.GetPerson(v.owner)
        v.keeper = p and { cid = p.cid, name = fullName(p), dob = p.dob } or nil
        local h = Housing.Get(v.owner)[1]
        v.keeperAddress = h and table.concat({ h.label, h.address }, ', ') or nil
        v.keeperLicence, v.keeperPoints = Licences.Summary(v.owner)
        v.keeperBail = activeBailMap({ v.owner })[v.owner]
        v.keeperWanted = #WantedCids({ v.owner }) > 0
    end
    local incidents = MySQL.query.await([[SELECT i.id, i.ref, i.type, i.status, i.location, i.created_at, i.officer_name FROM vw_mdt_incident_links l
        JOIN vw_mdt_incidents i ON i.id = l.incident_id WHERE l.kind = 'vehicle' AND l.subject_id = ? ORDER BY i.created_at DESC]], { v.plate }) or {}
    local linked, seen = {}, {}
    if v.keeper then linked[1] = { cid = v.keeper.cid, name = v.keeper.name, role = 'Registered keeper' }; seen[v.keeper.cid] = true end
    for _, i in ipairs(incidents) do
        for _, l in ipairs(linksFor(i.id)) do
            if l.kind == 'person' and not seen[l.subject_id] then
                seen[l.subject_id] = true
                linked[#linked + 1] = { cid = l.subject_id, name = l.label, role = ('%s, %s'):format(l.role or 'Involved', i.ref or '') }
            end
        end
    end
    local notes = MySQL.query.await("SELECT * FROM vw_mdt_notes WHERE subject_type = 'vehicle' AND subject_id = ? ORDER BY created_at DESC LIMIT 50", { v.plate }) or {}
    local intel = MySQL.query.await("SELECT * FROM vw_mdt_intel WHERE subject_type = 'vehicle' AND subject_id = ? ORDER BY created_at DESC LIMIT 50", { v.plate }) or {}

    local activity = {}
    for _, i in ipairs(incidents) do activity[#activity + 1] = { at = i.created_at, type = i.type, detail = ('%s at %s'):format(i.ref or '', i.location or 'unknown'), officer = i.officer_name } end
    for _, t in ipairs((v.mot and v.mot.history) or {}) do
        activity[#activity + 1] = { at = t.createdAt, type = 'MOT ' .. tostring(t.result or ''):lower(),
            detail = ('%s at %s%s'):format(t.testNo or '', t.garage or '-', (t.defects and #t.defects > 0) and (' - ' .. #t.defects .. ' defect(s)') or ''), officer = t.tester }
    end
    local key = ANPR_Key(v.plate)
    v.anpr = MySQL.query.await('SELECT * FROM vw_mdt_anpr WHERE plate = ? AND active = 1 AND (expires_at IS NULL OR expires_at > ?)', { key, now() }) or {}
    for _, sp in ipairs(MySQL.query.await('SELECT * FROM vw_mdt_speed WHERE plate = ? ORDER BY created_at DESC LIMIT 20', { key }) or {}) do
        activity[#activity + 1] = { at = sp.created_at, type = sp.locked == 1 and 'Speed check' or 'Speed detection',
            detail = ('%d %s in a %s limit, %s'):format(sp.speed, sp.unit or 'mph', tostring(sp.speed_limit or '?'), sp.device or ''), officer = sp.officer_name or sp.device }
    end
    for _, h in ipairs(MySQL.query.await('SELECT * FROM vw_mdt_anpr_hits WHERE plate = ? ORDER BY created_at DESC LIMIT 20', { key }) or {}) do
        local rs = {}
        for _, r in ipairs(Bridge.Decode(h.reasons)) do rs[#rs + 1] = r.label end
        activity[#activity + 1] = { at = h.created_at, type = 'ANPR hit', detail = ('%s at %s'):format(table.concat(rs, ', '), h.location or h.source or ''), officer = h.officer_name or h.source }
    end
    for _, m in ipairs(v.markers) do activity[#activity + 1] = { at = m.at, type = 'Marker', detail = m.marker .. (m.note and (': ' .. m.note) or ''), officer = m.officer } end
    for _, n in ipairs(notes) do activity[#activity + 1] = { at = n.created_at, type = 'Note', detail = n.text, officer = n.officer_name } end
    table.sort(activity, function(a, b) return (a.at or 0) > (b.at or 0) end)

    return { vehicle = v, incidents = incidents, linked = linked, notes = notes, intel = intel, activity = activity }
end

---------------------------------------------------------------------------
-- Notes
---------------------------------------------------------------------------
H.nearbyPeople = function(src)
    return { results = Bridge.NearbyPeople(src, 8) }
end

H.dispatchCalls = function(src)
    local calls, name = Dispatch.Get(src)
    return { calls = calls, dispatch = name, attachable = Dispatch.UsingVinewood() }
end

-- Post an update to a vinewood-dispatch call
H.dispatchNote = function(src, _, d)
    if not Dispatch.UsingVinewood() then return { error = 'Call updates need vinewood-dispatch.' } end
    local id, text = tonumber(d.id), trim(d.text, 200)
    if not id or not text then return { error = 'Write an update first.' } end
    local ok, err = exports['vinewood-dispatch']:AddUnitNote(id, src, text)
    if not ok then return { error = err or 'The update could not be posted.' } end
    return { ok = true }
end

-- Roadside: is this person insured to drive this vehicle, and can they legally drive?
H.checkDriver = function(_, _, d)
    local plate, cid = trim(d.plate, 12), trim(d.cid, 64)
    local p = cid and Bridge.GetPerson(cid)
    if not plate or not p then return { error = 'Choose the driver.' } end
    local out = { name = fullName(p), cid = cid }
    out.insured = VS.InsuredToDrive(plate, cid)
    out.licence, out.points = Licences.Summary(cid)
    out.wanted = #WantedCids({ cid }) > 0
    out.bail = activeBailMap({ cid })[cid]
    return out
end

-- What the record says about this person, for the sentencing calculator.
H.sentencingContext = function(_, _, d)
    local cid = trim(d.cid, 64)
    if not cid then return { convictions = 0, cautions = 0 } end
    local excludeId = tonumber(d.recordId)
    local convictions, cautions, list = 0, 0, {}
    local charged = {}
    for _, r in ipairs(MySQL.query.await("SELECT record_id FROM vw_mdt_cps WHERE cid = ? AND status = 'charge'", { cid }) or {}) do charged[r.record_id] = true end
    for _, r in ipairs(MySQL.query.await('SELECT id, ref, outcome, offences, created_at FROM vw_mdt_records WHERE cid = ? ORDER BY created_at DESC', { cid }) or {}) do
        if r.id ~= excludeId then
            if r.outcome == 'Charged' or charged[r.id] then
                convictions = convictions + 1
                list[#list + 1] = { ref = r.ref, at = r.created_at, offences = Bridge.Decode(r.offences), outcome = 'Charged' }
            elseif r.outcome == 'Simple caution' or r.outcome == 'Community resolution' then
                cautions = cautions + 1
                list[#list + 1] = { ref = r.ref, at = r.created_at, offences = Bridge.Decode(r.offences), outcome = r.outcome }
            end
        end
    end
    -- With vinewood-moj, convictions are the sentences a court actually passed, not charges.
    local court = MoJ.Running() and MoJ.Person(cid)
    if court and type(court.sentences) == 'table' then
        convictions = #court.sentences
        for i = #list, 1, -1 do if list[i].outcome == 'Charged' then table.remove(list, i) end end
        for _, x in ipairs(court.sentences) do
            list[#list + 1] = { at = x.created_at, offences = {}, outcome = 'Convicted', summary = x.summary }
        end
    end
    local bail = activeBailMap({ cid })[cid]
    return { convictions = convictions, cautions = cautions, onBail = bail ~= nil, history = list, fromCourt = court ~= nil and court ~= false }
end

H.addNote = function(src, job, d)
    local kind = d.kind == 'vehicle' and 'vehicle' or 'person'
    local id, text = trim(d.id, 64), trim(d.text, 2000)
    if not id or not text then return { error = 'Write the note first.' } end
    MySQL.insert.await('INSERT INTO vw_mdt_notes (subject_type, subject_id, text, officer_name, created_at) VALUES (?, ?, ?, ?, ?)',
        { kind, id, text, officerLabel(src, job), now() })
    return { ok = true }
end

---------------------------------------------------------------------------
-- Incidents and evidence
---------------------------------------------------------------------------
local function inList(list, v)
    for _, x in ipairs(list) do if x == v then return true end end
    return false
end

H.searchIncidents = function(_, _, d)
    local where, args = { '1 = 1' }, {}
    local ref = trim(d.ref, 32)
    if ref then where[#where + 1] = 'ref LIKE ?'; args[#args + 1] = '%' .. ref .. '%' end
    if d.type and inList(Config.IncidentTypes, d.type) then where[#where + 1] = 'type = ?'; args[#args + 1] = d.type end
    if d.status and inList(Config.IncidentStatuses, d.status) then where[#where + 1] = 'status = ?'; args[#args + 1] = d.status end
    if tonumber(d.from) then where[#where + 1] = 'created_at >= ?'; args[#args + 1] = tonumber(d.from) end
    if tonumber(d.to) then where[#where + 1] = 'created_at <= ?'; args[#args + 1] = tonumber(d.to) end
    local rows = MySQL.query.await(('SELECT id, ref, type, grade, status, location, officer_name, created_at FROM vw_mdt_incidents WHERE %s ORDER BY created_at DESC LIMIT 60')
        :format(table.concat(where, ' AND ')), args) or {}
    return { results = rows }
end

H.createIncident = function(src, job, d)
    if not inList(Config.IncidentTypes, d.type) then return { error = 'Choose an incident type.' } end
    local grade = inList(Config.IncidentGrades, d.grade) and d.grade or Config.IncidentGrades[2]
    local t = now()
    local id = MySQL.insert.await([[INSERT INTO vw_mdt_incidents (type, grade, status, location, coords, narrative, officer_name, officer_cid, created_at, updated_at)
        VALUES (?, ?, 'Open', ?, ?, ?, ?, ?, ?, ?)]],
        { d.type, grade, trim(d.location, 160), type(d.coords) == 'table' and json.encode(d.coords) or nil, trim(d.narrative, 6000),
          officerLabel(src, job), Bridge.GetCid(src), t, t })
    local ref = ('%s-%s-%05d'):format(Config.ForceShort, os.date('%Y'), id)
    MySQL.update.await('UPDATE vw_mdt_incidents SET ref = ? WHERE id = ?', { ref, id })

    -- Started from a person or vehicle record: link it straight away.
    if d.linkKind and d.linkId then
        H.linkIncident(src, job, { incidentId = id, kind = d.linkKind, id = d.linkId, role = d.linkRole })
    end
    return { ok = true, id = id, ref = ref }
end

H.getIncident = function(_, job, d)
    local i = MySQL.single.await('SELECT * FROM vw_mdt_incidents WHERE id = ?', { tonumber(d.id) })
    if not i then return { error = 'Incident not found.' } end
    local links = linksFor(i.id)
    local people, vehicles = {}, {}
    for _, l in ipairs(links) do
        if l.kind == 'person' then people[#people + 1] = l else vehicles[#vehicles + 1] = l end
    end
    local evidence = MySQL.query.await('SELECT * FROM vw_mdt_evidence WHERE incident_id = ? ORDER BY id ASC', { i.id }) or {}
    for _, e in ipairs(evidence) do
        if e.stash_id and Evidence_BagItems then e.bag = Evidence_BagItems(e) end
        if Forensics_Public then Forensics_Public(e) end
        e.items = nil
    end
    for _, e in ipairs(evidence) do e.continuity = Bridge.Decode(e.continuity) end
    local records = MySQL.query.await('SELECT id, ref, cid, subject_name, outcome, created_at FROM vw_mdt_records WHERE incident_id = ?', { i.id }) or {}
    -- Interviews recorded under this incident's reference or one of its custody references.
    local interviews
    if Interviews.Available() and Interviews.CanListen(job) then
        interviews = {}
        local seen = {}
        local refs = { i.ref }
        for _, r in ipairs(records) do if r.ref then refs[#refs + 1] = r.ref end end
        for _, ref in ipairs(refs) do
            for _, s in ipairs(Interviews.ForCase(ref) or {}) do
                if not seen[s.id] then seen[s.id] = true; interviews[#interviews + 1] = s end
            end
        end
    end
    return { incident = i, people = people, vehicles = vehicles, evidence = evidence, records = records, interviews = interviews,
        injury = EMS.ForCase(i.ref) }
end

-- Ask the ambulance service for an injury statement about someone linked to this incident.
H.requestInjury = function(src, job, d)
    if not EMS.Running() then return { error = 'The ambulance MDT is not running.' } end
    local i = MySQL.single.await('SELECT id, ref FROM vw_mdt_incidents WHERE id = ?', { tonumber(d.incidentId) })
    if not i then return { error = 'Incident not found.' } end
    local cid = trim(d.cid, 64)
    local link = cid and MySQL.single.await("SELECT label FROM vw_mdt_incident_links WHERE incident_id = ? AND kind = 'person' AND subject_id = ?", { i.id, cid })
    if not link then return { error = 'Link the person to this incident first.' } end
    local id = EMS.Request({ caseRef = i.ref, citizenid = cid, patientName = link.label, officerName = officerLabel(src, job), notes = trim(d.notes, 1000) })
    if not id then return { error = 'The ambulance MDT did not accept the request.' } end
    return { ok = true, id = id }
end

H.updateIncident = function(_, _, d)
    local id = tonumber(d.id)
    if not id then return { error = 'Incident not found.' } end
    local sets, args = {}, {}
    if d.status then
        if not inList(Config.IncidentStatuses, d.status) then return { error = 'Unknown status.' } end
        sets[#sets + 1] = 'status = ?'; args[#args + 1] = d.status
    end
    if d.grade and inList(Config.IncidentGrades, d.grade) then sets[#sets + 1] = 'grade = ?'; args[#args + 1] = d.grade end
    if d.narrative ~= nil then sets[#sets + 1] = 'narrative = ?'; args[#args + 1] = trim(d.narrative, 6000) end
    if #sets == 0 then return { ok = true } end
    sets[#sets + 1] = 'updated_at = ?'; args[#args + 1] = now()
    args[#args + 1] = id
    MySQL.update.await(('UPDATE vw_mdt_incidents SET %s WHERE id = ?'):format(table.concat(sets, ', ')), args)
    return { ok = true }
end

H.linkIncident = function(_, _, d)
    local incidentId = tonumber(d.incidentId)
    local kind = d.kind == 'vehicle' and 'vehicle' or 'person'
    local id = trim(d.id, 64)
    if not incidentId or not id then return { error = 'Choose who or what to link.' } end
    local label
    if kind == 'person' then
        local p = Bridge.GetPerson(id)
        if not p then return { error = 'No person with that reference.' } end
        label = fullName(p)
    else
        local v = Bridge.GetVehicle(id)
        label = id:upper()
        if v then label = v.plate end
    end
    if MySQL.scalar.await('SELECT id FROM vw_mdt_incident_links WHERE incident_id = ? AND kind = ? AND subject_id = ?', { incidentId, kind, id }) then
        return { error = 'Already linked to this incident.' }
    end
    local role = inList(Config.IncidentRoles, d.role) and d.role or (kind == 'vehicle' and 'Involved' or 'Involved')
    MySQL.insert.await('INSERT INTO vw_mdt_incident_links (incident_id, kind, subject_id, label, role) VALUES (?, ?, ?, ?, ?)', { incidentId, kind, id, label, role })
    MySQL.update.await('UPDATE vw_mdt_incidents SET updated_at = ? WHERE id = ?', { now(), incidentId })
    return { ok = true }
end

H.unlinkIncident = function(_, _, d)
    MySQL.update.await('DELETE FROM vw_mdt_incident_links WHERE id = ?', { tonumber(d.id) })
    return { ok = true }
end

local function initials(name)
    local out = ''
    for w in tostring(name or ''):gmatch('%a+') do out = out .. w:sub(1, 1):upper() end
    return out:sub(-2)
end

H.addEvidence = function(src, job, d)
    local incidentId = tonumber(d.incidentId)
    if not incidentId or not MySQL.scalar.await('SELECT id FROM vw_mdt_incidents WHERE id = ?', { incidentId }) then return { error = 'Incident not found.' } end
    if not inList(Config.EvidenceTypes, d.type) then return { error = 'Choose an exhibit type.' } end
    local desc = trim(d.description, 255)
    if not desc then return { error = 'Describe the exhibit.' } end
    local officer, ocid = officerLabel(src, job), Bridge.GetCid(src)

    -- Exhibit reference in the officer's initials, numbered in sequence: JC/1, JC/2...
    local n = (MySQL.scalar.await('SELECT COUNT(*) FROM vw_mdt_evidence WHERE officer_cid = ?', { ocid }) or 0) + 1
    local exhibitRef = ('%s/%d'):format(initials(Bridge.GetName(src)), n)

    local seizedFrom, seizedName = trim(d.seizedFrom, 64), nil
    if seizedFrom then
        local p = Bridge.GetPerson(seizedFrom)
        seizedName = p and fullName(p) or nil
        if not p then seizedFrom = nil end
    end
    local t = now()
    local status = inList(Config.EvidenceStatuses, d.status) and d.status or Config.EvidenceStatuses[1]
    local where = trim(d.foundAt, 160)
    local text = 'Seized' .. (where and (' at ' .. where) or '') .. (status ~= Config.EvidenceStatuses[1] and ('. ' .. status) or '')
    local continuity = { { at = t, by = officer, text = text } }
    MySQL.insert.await([[INSERT INTO vw_mdt_evidence (incident_id, exhibit_ref, type, description, seized_from, seized_from_name, found_at, status, photo, continuity, officer_name, officer_cid, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]],
        { incidentId, exhibitRef, d.type, desc, seizedFrom, seizedName, trim(d.foundAt, 160), status,
          trim(d.photo, 400), json.encode(continuity), officer, ocid, t })
    MySQL.update.await('UPDATE vw_mdt_incidents SET updated_at = ? WHERE id = ?', { t, incidentId })
    return { ok = true, ref = exhibitRef }
end

H.moveEvidence = function(src, job, d)
    local e = MySQL.single.await('SELECT * FROM vw_mdt_evidence WHERE id = ?', { tonumber(d.id) })
    if not e then return { error = 'Exhibit not found.' } end
    if not inList(Config.EvidenceStatuses, d.status) then return { error = 'Choose where the exhibit is going.' } end
    local log = Bridge.Decode(e.continuity)
    log[#log + 1] = { at = now(), by = officerLabel(src, job), text = d.status .. (trim(d.note, 200) and ('. ' .. trim(d.note, 200)) or '') }
    MySQL.update.await('UPDATE vw_mdt_evidence SET status = ?, continuity = ? WHERE id = ?', { d.status, json.encode(log), e.id })
    return { ok = true }
end

---------------------------------------------------------------------------
-- Custody list
---------------------------------------------------------------------------
H.custodyList = function(_, _, d)
    local where, args = '', {}
    if d.filter == 'in' then where = ' WHERE outcome = ?'; args = { Config.Outcomes[1] } end
    local rows = MySQL.query.await(('SELECT id, ref, cid, subject_name, offences, outcome, officer_name, created_at, incident_id, custody FROM vw_mdt_records%s ORDER BY created_at DESC LIMIT 60'):format(where), args) or {}
    for _, r in ipairs(rows) do
        if r.outcome == Config.Outcomes[1] then r.clock = CustodyClock(r) end
        r.custody = nil
    end
    local cids = {}
    for _, r in ipairs(rows) do r.offences = Bridge.Decode(r.offences); cids[#cids + 1] = r.cid end
    local seen, uniq = {}, {}
    for _, c in ipairs(cids) do if not seen[c] then seen[c] = true; uniq[#uniq + 1] = c end end
    local dobs = {}
    for _, c in ipairs(uniq) do local p = Bridge.GetPerson(c); dobs[c] = p and p.dob end
    for _, r in ipairs(rows) do r.dob = dobs[r.cid] end
    return { results = rows }
end

H.setOutcome = function(src, _, d)
    local outcome = trim(d.outcome, 64)
    if not outcome or not inList(Config.Outcomes, outcome) then return { error = 'Choose an outcome.' } end
    local rec = MySQL.single.await('SELECT id, ref, cid, offences FROM vw_mdt_records WHERE id = ?', { tonumber(d.id) })
    if not rec then return { error = 'Custody record not found.' } end
    local result = { ok = true }

    -- Remanded: send them to the prison script first, and only save the outcome if it took them.
    if outcome == 'Remanded in custody' and Prison.Pick() then
        local offences = Bridge.Decode(rec.offences)
        local ok, msg, name = Prison.Remand(rec.cid, {
            minutes = tonumber(d.minutes), reason = ('Remanded: %s'):format(table.concat(offences, '; ')):sub(1, 250),
            caseRef = rec.ref, offences = offences, officer = src,
        })
        if not ok then return { error = ('Not sent to prison: %s'):format(msg or 'unknown error') } end
        result.prison = msg or ('Sent to %s on remand.'):format(name or 'prison')
    end

    MySQL.update.await('UPDATE vw_mdt_records SET outcome = ? WHERE id = ?', { outcome, rec.id })
    -- Custody scripts (vinewood_police) release the person from the cells on outcomes like this.
    TriggerEvent('vinewood-mdt:server:custodyOutcome', rec.id, rec.ref, rec.cid, outcome, src)
    return result
end

---------------------------------------------------------------------------
-- Intelligence
---------------------------------------------------------------------------
H.addIntel = function(src, job, d)
    local kind = d.kind == 'vehicle' and 'vehicle' or (d.kind == 'person' and 'person' or 'general')
    local text = trim(d.text, 3000)
    if not text then return { error = 'Write the intelligence.' } end
    local function valid(list, v) for _, x in ipairs(list) do if x.id == v then return true end end return false end
    if not (valid(Config.IntelSource, d.source) and valid(Config.IntelAssessment, d.assessment) and valid(Config.IntelHandling, d.handling)) then
        return { error = 'Grade the intelligence (source, assessment and handling).' }
    end
    local id, label = trim(d.id, 64), trim(d.label, 96)
    if kind == 'person' and id then
        local p = Bridge.GetPerson(id)
        if not p then return { error = 'No person with that reference.' } end
        label = fullName(p)
    end
    MySQL.insert.await('INSERT INTO vw_mdt_intel (subject_type, subject_id, subject_label, grading, text, officer_name, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { kind, id, label, d.source .. d.assessment .. d.handling, text, officerLabel(src, job), now() })
    return { ok = true }
end

H.searchIntel = function(_, _, d)
    local q = trim(d.q, 64)
    local rows
    if q then
        local like = '%' .. q .. '%'
        rows = MySQL.query.await('SELECT * FROM vw_mdt_intel WHERE subject_label LIKE ? OR subject_id LIKE ? OR text LIKE ? ORDER BY created_at DESC LIMIT 60', { like, like, like })
    else
        rows = MySQL.query.await('SELECT * FROM vw_mdt_intel ORDER BY created_at DESC LIMIT 60')
    end
    return { results = rows or {} }
end

---------------------------------------------------------------------------
-- Warrants
---------------------------------------------------------------------------
H.listWarrants = function(_, _, d)
    local status = d.status == 'closed' and "status <> 'active'" or "status = 'active'"
    return { results = MySQL.query.await(('SELECT * FROM vw_mdt_warrants WHERE %s ORDER BY created_at DESC LIMIT 80'):format(status)) or {} }
end

H.issueWarrant = function(src, job, d)
    if (job.grade or 0) < (Config.WarrantGrade or 0) then return { error = 'Your rank cannot record warrants.' } end
    local wt = warrantType(d.type)
    if not wt then return { error = 'Choose a warrant type.' } end
    local reason = trim(d.reason, 1000)
    if not reason then return { error = 'Give the grounds for the warrant.' } end
    local cid, name, address = trim(d.cid, 64), nil, trim(d.address, 160)
    if cid then
        local p = Bridge.GetPerson(cid)
        if not p then return { error = 'No person with that reference.' } end
        name = fullName(p)
    end
    if wt.wanted and not cid then return { error = 'An arrest warrant needs a person.' } end
    if not wt.wanted and not address then return { error = 'A search warrant needs an address.' } end
    MySQL.insert.await('INSERT INTO vw_mdt_warrants (type, cid, subject_name, address, reason, status, issued_by, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        { wt.id, cid, name, address, reason, 'active', officerLabel(src, job), now() })
    return { ok = true }
end

H.closeWarrant = function(src, job, d)
    local status = d.status == 'executed' and 'executed' or 'cancelled'
    MySQL.update.await("UPDATE vw_mdt_warrants SET status = ?, closed_by = ?, closed_at = ? WHERE id = ? AND status = 'active'",
        { status, officerLabel(src, job), now(), tonumber(d.id) })
    return { ok = true }
end

---------------------------------------------------------------------------
-- ANPR
---------------------------------------------------------------------------
local ANPR = Config.ANPR or {}

function ANPR_Key(plate)
    return tostring(plate or ''):upper():gsub('[^%w]', ''):sub(1, 12)
end

local hitCache = {}          -- plate key -> { at, result }
function ANPR_ClearCache() hitCache = {} end
local lastBatch = {}         -- src -> GetGameTimer of last in-car batch
local cameraSeen = {}        -- src..camera -> os.time
local activeUnits = {}       -- src -> true while in-car ANPR is on

local function anprAccess(src)
    local job = Bridge.GetJob(src)
    if not job then return nil end
    local min = (ANPR.Jobs or {})[job.name]
    if min == nil or (job.grade or 0) < min then return nil end
    if Config.RequireOnDuty and not job.onduty then return nil end
    return job
end

--- What (if anything) is wrong with these plates. Returns { [key] = { plate, model, reasons = {{label, level, action}}, owner } }
function ANPR_Check(plates)
    local t = now()
    local want, out = {}, {}
    for _, p in ipairs(plates) do
        local k = ANPR_Key(p)
        if #k >= 2 then
            local c = hitCache[k]
            if c and t - c.at < 20 then
                if c.result then out[k] = c.result end
            else
                want[#want + 1] = k
            end
        end
    end
    if #want == 0 then return out end
    local ph = string.rep('?', #want, ',')
    local results = {}
    local function add(k, label, level, action)
        results[k] = results[k] or { plate = k, reasons = {} }
        table.insert(results[k].reasons, { label = label, level = level, action = action })
    end

    -- 1. Plates put on ANPR by officers
    for _, r in ipairs(MySQL.query.await(('SELECT * FROM vw_mdt_anpr WHERE active = 1 AND (expires_at IS NULL OR expires_at > ?) AND plate IN (%s)'):format(ph),
        { t, table.unpack(want) }) or {}) do
        add(r.plate, r.reason or 'ANPR marker', 'red', r.action)
        if r.note then results[r.plate].note = r.note end
    end

    -- 2. Registered vehicles: markers and keeper checks
    local fw = Bridge.Framework()
    local rows = fw == 'esx'
        and MySQL.query.await(("SELECT plate, owner, vehicle FROM owned_vehicles WHERE REPLACE(UPPER(plate), ' ', '') IN (%s)"):format(ph), want)
        or MySQL.query.await(("SELECT plate, citizenid AS owner, vehicle FROM player_vehicles WHERE REPLACE(UPPER(plate), ' ', '') IN (%s)"):format(ph), want)
    local registered, owners, ownerList, realPlates = {}, {}, {}, {}
    for _, r in ipairs(rows or {}) do
        local k = ANPR_Key(r.plate)
        registered[k] = r
        realPlates[#realPlates + 1] = r.plate
        if r.owner and not owners[r.owner] then owners[r.owner] = true; ownerList[#ownerList + 1] = r.owner end
    end

    local hm = ANPR.HitMarkers or {}
    for plate, list in pairs(markersFor('vehicle', realPlates)) do
        for _, m in ipairs(list) do
            local def = hm[m.marker]
            if def then add(ANPR_Key(plate), m.marker .. (m.note and (': ' .. m.note) or ''), def.level, def.action) end
        end
    end

    local wanted = {}
    if ANPR.KeeperWanted and #ownerList > 0 then for _, c in ipairs(WantedCids(ownerList)) do wanted[c] = true end end
    local bails = (ANPR.KeeperBailNoDriving and #ownerList > 0) and activeBailMap(ownerList) or {}
    for k, r in pairs(registered) do
        local o = r.owner
        if o then
            if wanted[o] then add(k, 'Registered keeper wanted', 'red', 'Stop. Identify the driver - keeper is wanted.') end
            local b = bails[o]
            if b then
                for _, c in ipairs(b.conditions or {}) do
                    if c.id == 'vehicle' then add(k, 'Keeper bailed not to drive', 'amber', 'Stop. Check who is driving.') end
                end
            end
            if ANPR.KeeperDisqualified and Licences.Summary(o) == 'disqualified' then
                add(k, 'Registered keeper disqualified', 'amber', 'Stop if the driver may be the keeper.')
            end
        end
    end
    -- MID / MOT / VED from vinewood-vehicleservices
    if VS.Running() then
        local list = {}
        for _, r in pairs(registered) do list[#list + 1] = r.plate end
        local st = VS.Bulk(list)
        local c = Config.VehicleServices or {}
        for k in pairs(registered) do
            local s = st[k]
            if s then
                if c.AnprNoInsurance ~= false and not s.insured then
                    add(k, s.insurance == 'void' and 'Insurance void (keeper changed)' or 'No insurance on MID', 'red', 'Stop. Check insurance - seize under s.165 if uninsured.')
                end
                if c.AnprDangerousMOT ~= false and s.mot == 'dangerous' then
                    add(k, 'MOT failed - dangerous defects', 'red', 'Stop. Vehicle not fit to be driven.')
                elseif c.AnprNoMOT ~= false and s.mot ~= 'valid' and s.mot ~= 'dangerous' then
                    add(k, 'No current MOT', 'amber', 'Stop if safe. Deal with no MOT.')
                end
                if c.AnprSorn ~= false and s.tax == 'sorn' then
                    add(k, 'SORN vehicle on the road', 'amber', 'Stop. Vehicle declared off road.')
                elseif c.AnprUntaxed ~= false and s.tax ~= 'taxed' and s.tax ~= 'sorn' then
                    add(k, 'Untaxed', 'amber', 'Stop if safe. Report for no VED.')
                end
            end
        end
    end

    if ANPR.UnregisteredPlates then
        for _, k in ipairs(want) do if not registered[k] then add(k, 'No registered keeper', 'amber', 'Check vehicle.') end end
    end

    -- Keeper name and model for the alert
    local names = namesFor(ownerList)
    for _, k in ipairs(want) do
        local res = results[k]
        if res then
            local r = registered[k]
            if r then
                res.owner = r.owner
                res.realPlate = r.plate
                res.keeper = names[r.owner]
                local v = Bridge.Decode(r.vehicle)
                res.model = type(r.vehicle) == 'string' and not r.vehicle:find('{') and r.vehicle or v.model
            end
            -- most serious first
            table.sort(res.reasons, function(a, b) return (a.level == 'red' and 0 or 1) < (b.level == 'red' and 0 or 1) end)
            out[k] = res
        end
        hitCache[k] = { at = t, result = res }
    end
    return out
end

local function logHit(hit, source, officer, location, coords)
    if Webhook.Enabled('anpr') then
        local rs = {}
        for _, r in ipairs(hit.reasons or {}) do rs[#rs + 1] = r.label end
        Webhook.Send('anpr', ('ANPR hit: %s'):format(hit.plate), table.concat(rs, '\n'),
            { { 'Vehicle', hit.model }, { 'Keeper', hit.keeper }, { 'Read by', officer or source }, { 'Location', location } },
            (hit.reasons[1] and hit.reasons[1].level == 'red') and 'red' or 'amber')
    end
    MySQL.insert('INSERT INTO vw_mdt_anpr_hits (plate, model, reasons, source, officer_name, location, coords, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        { hit.plate, hit.model and tostring(hit.model) or nil, json.encode(hit.reasons), source, officer, location, coords and json.encode(coords) or nil, now() })
end

-- Speed ------------------------------------------------------------------------------
local SPD = (Config.ANPR or {}).Speed or {}
local function speedThreshold(limit)
    local tol = SPD.Tolerance or { percent = 10, plus = 2 }
    return limit * (1 + (tol.percent or 0) / 100) + (tol.plus or 0)
end

local function recordSpeed(r, device, officer, officerCid, locked)
    local speed = math.floor(tonumber(r.speed) or 0)
    if speed <= 0 then return nil end
    local key = ANPR_Key(r.plate)
    local id = MySQL.insert.await([[INSERT INTO vw_mdt_speed (plate, model, speed, speed_limit, unit, device, location, coords, officer_name, officer_cid, patrol_speed, locked, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]],
        { key, r.model and tostring(r.model):sub(1, 64) or nil, speed, tonumber(r.limit), SPD.Unit or 'mph', device, r.location and tostring(r.location):sub(1, 160) or nil,
          type(r.coords) == 'table' and json.encode(r.coords) or nil, officer, officerCid, tonumber(r.patrol) and math.floor(tonumber(r.patrol)) or nil, locked and 1 or 0, now() })
    Webhook.Send('anpr', ('Speed %s: %s'):format(locked and 'check' or 'detection', key),
        ('%d %s in a %s limit'):format(speed, SPD.Unit or 'mph', tostring(r.limit or '?')), { { 'Device', device }, { 'Officer', officer }, { 'Location', r.location } }, 'amber')
    return id
end

-- Officer pressed lock: record the vehicle in front's speed as evidence, whatever it is.
RegisterNetEvent('vinewood-mdt:server:anprLock', function(r)
    local src = source
    if not SPD.enabled or type(r) ~= 'table' or type(r.plate) ~= 'string' then return end
    local job = anprAccess(src)
    if not job then return end
    local id = recordSpeed(r, ('In-car ANPR (%s, locked)'):format(r.camera or 'Front'), officerLabel(src, job), Bridge.GetCid(src), true)
    if id then
        local over = tonumber(r.limit) and tonumber(r.speed) > speedThreshold(tonumber(r.limit))
        Bridge.Notify(src, ('Speed locked: %s %d %s in a %s.%s'):format(r.plate, math.floor(r.speed), SPD.Unit or 'mph', tostring(r.limit or '?'),
            over and ' Over the limit - recorded for a ticket.' or ''), over and 'error' or 'inform')
    end
end)

-- In-car ANPR: the officer's client sends the plates it has read.
RegisterNetEvent('vinewood-mdt:server:anprReads', function(reads)
    local src = source
    if not ANPR.enabled or type(reads) ~= 'table' then return end
    local job = anprAccess(src)
    if not job then return end
    local t = GetGameTimer()
    if lastBatch[src] and t - lastBatch[src] < 800 then return end
    lastBatch[src] = t
    activeUnits[src] = true

    local plates, byKey = {}, {}
    for i, r in ipairs(reads) do
        if i > 12 then break end
        if type(r) == 'table' and type(r.plate) == 'string' then
            local k = ANPR_Key(r.plate)
            plates[#plates + 1] = k
            byKey[k] = r
        end
    end
    local officer = officerLabel(src, job)

    -- Speeders: record them, and add a speeding reason to the alert.
    local speeding = {}
    if SPD.enabled then
        for k, r in pairs(byKey) do
            local limit, speed = tonumber(r.limit), tonumber(r.speed)
            if limit and speed and speed > speedThreshold(limit) then
                if SPD.AutoRecord ~= false then recordSpeed(r, ('In-car ANPR (%s)'):format(r.camera or 'Front'), officer, Bridge.GetCid(src), false) end
                if SPD.AlertOfficer ~= false then
                    speeding[k] = { label = ('Speeding: %d %s in a %d limit'):format(math.floor(speed), SPD.Unit or 'mph', limit), level = 'amber',
                        action = 'Stop if safe. Speed recorded as evidence on the ANPR page.' }
                end
            end
        end
    end

    -- Plates only sent for speed were already checked; don't alert their hits twice.
    local checkPlates = {}
    for _, k in ipairs(plates) do if not (byKey[k] and byKey[k].speedOnly) then checkPlates[#checkPlates + 1] = k end end
    local hits = ANPR_Check(checkPlates)
    for k, sp in pairs(speeding) do
        if hits[k] then
            local copy = { plate = hits[k].plate, model = hits[k].model, keeper = hits[k].keeper, note = hits[k].note, reasons = {} }
            for _, x in ipairs(hits[k].reasons) do copy.reasons[#copy.reasons + 1] = x end
            copy.reasons[#copy.reasons + 1] = sp
            hits[k] = copy
        else
            hits[k] = { plate = k, reasons = { sp } }
        end
    end
    for k, hit in pairs(hits) do
        local r = byKey[k] or {}
        logHit(hit, 'In-car ANPR', officer, r.location, r.coords)
        TriggerClientEvent('vinewood-mdt:client:anprHit', src, {
            plate = r.plate or k, key = k, model = r.model or hit.model, keeper = hit.keeper, reasons = hit.reasons, note = hit.note,
            camera = r.camera, location = r.location, netId = r.netId, source = 'In-car ANPR',
        })
    end
end)

RegisterNetEvent('vinewood-mdt:server:anprState', function(on)
    local src = source
    activeUnits[src] = on and anprAccess(src) and true or nil
end)

-- Fixed cameras: every driver's client reports its own plate when passing one.
RegisterNetEvent('vinewood-mdt:server:anprCamera', function(index, plate, modelLabel, location, speed)
    local src = source
    local cam = ANPR_Cams[tostring(index)]
    if not ANPR.enabled or not cam or not cam.active or type(plate) ~= 'string' then return end
    local key = src .. ':' .. tostring(index)
    if cameraSeen[key] and now() - cameraSeen[key] < 60 then return end
    cameraSeen[key] = now()
    -- The sender must actually be near the camera.
    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped) - cam.coords) > (cam.radius or 18.0) + 25.0 then return end

    local k = ANPR_Key(plate)
    -- Speed camera: record anyone over its limit.
    speed = tonumber(speed)
    if SPD.enabled and cam.speedLimit and cam.speedLimit > 0 and speed and speed > speedThreshold(cam.speedLimit) then
        recordSpeed({ plate = plate, model = modelLabel, speed = speed, limit = cam.speedLimit, location = location or cam.name,
            coords = { x = cam.coords.x, y = cam.coords.y, z = cam.coords.z } }, cam.name, nil, nil, false)
    end
    local hit = ANPR_Check({ k })[k]
    if not hit then return end
    logHit(hit, cam.name, nil, location or cam.name, { x = cam.coords.x, y = cam.coords.y, z = cam.coords.z })
    local payload = {
        plate = plate, key = k, model = modelLabel or hit.model, keeper = hit.keeper, reasons = hit.reasons, note = hit.note,
        camera = 'fixed', cameraName = cam.name, location = location or cam.name,
        coords = { x = cam.coords.x, y = cam.coords.y, z = cam.coords.z }, source = cam.name,
    }
    for _, id in ipairs(GetPlayers()) do
        local p = tonumber(id)
        if p ~= src and access(p) and access(p).role == 'police' and (ANPR.CameraAlerts ~= 'anpr' or activeUnits[p]) then
            TriggerClientEvent('vinewood-mdt:client:anprHit', p, payload)
        end
    end
    if ANPR.CameraHitsAsCalls then
        local top = hit.reasons[1] or {}
        Dispatch.Add({ title = ('ANPR hit: %s'):format(plate), code = 'ANPR', message = ('%s. %s'):format(top.label or '', top.action or ''),
            location = location or cam.name, coords = payload.coords, priority = top.level == 'red' and 1 or 2 }, 'ANPR')
    end
end)

AddEventHandler('playerDropped', function()
    lastBatch[source] = nil
    activeUnits[source] = nil
end)

lib.callback.register('vinewood-mdt:server:anprAllowed', function(src)
    return ANPR.enabled ~= false and anprAccess(src) ~= nil
end)

-- MDT pages
H.anprList = function()
    local t = now()
    local markers = MySQL.query.await('SELECT * FROM vw_mdt_anpr WHERE active = 1 AND (expires_at IS NULL OR expires_at > ?) ORDER BY created_at DESC LIMIT 100', { t }) or {}
    local hits = MySQL.query.await('SELECT * FROM vw_mdt_anpr_hits ORDER BY created_at DESC LIMIT 60') or {}
    for _, h in ipairs(hits) do h.reasons = Bridge.Decode(h.reasons) end
    local units = 0
    for _ in pairs(activeUnits) do units = units + 1 end
    local cams = 0
    for _, c in pairs(ANPR_Cams) do if c.active then cams = cams + 1 end end
    return { markers = markers, hits = hits, units = units, cameras = cams }
end

H.speedList = function(_, _, d)
    local where, args = '1 = 1', {}
    if d.plate then where = 'plate = ?'; args = { ANPR_Key(d.plate) } end
    if d.filter == 'over' then where = where .. ' AND speed_limit IS NOT NULL' end
    local rows = MySQL.query.await(('SELECT * FROM vw_mdt_speed WHERE %s ORDER BY created_at DESC LIMIT 80'):format(where), args) or {}
    local owners = {}
    for _, r in ipairs(rows) do
        local v = Bridge.GetVehicle(r.plate)
        if not v then for _, x in ipairs(Bridge.SearchVehicles(r.plate)) do if ANPR_Key(x.plate) == r.plate then v = x end end end
        if v then r.realPlate, r.owner = v.plate, v.owner; if v.owner then owners[#owners + 1] = v.owner end end
        r.over = r.speed_limit and r.speed > speedThreshold(r.speed_limit) or false
        r.coords = nil
    end
    local names = namesFor(owners)
    for _, r in ipairs(rows) do r.keeper = r.owner and names[r.owner] or nil end
    return { results = rows, unit = SPD.Unit or 'mph', tolerance = SPD.Tolerance }
end

H.speedTicketed = function(_, _, d)
    MySQL.update.await('UPDATE vw_mdt_speed SET fine_ref = ? WHERE id = ?', { trim(d.ref, 32), tonumber(d.id) })
    return { ok = true }
end

H.anprAdd = function(src, job, d)
    local key = ANPR_Key(d.plate)
    if #key < 2 then return { error = 'Enter the registration.' } end
    local reason = trim(d.reason, 160)
    if not reason then return { error = 'Give a reason for the ANPR marker.' } end
    local action = trim(d.action, 64)
    local hours = tonumber(d.hours)
    local expires = (hours and hours > 0) and (now() + hours * 3600) or nil
    -- One entry per plate: adding a plate that is already on ANPR updates it instead of doubling up.
    local existing = MySQL.scalar.await('SELECT id FROM vw_mdt_anpr WHERE plate = ? AND active = 1 AND (expires_at IS NULL OR expires_at > ?) LIMIT 1', { key, now() })
    if existing then
        MySQL.update.await('UPDATE vw_mdt_anpr SET reason = ?, action = ?, note = ?, officer_name = ?, expires_at = ?, created_at = ? WHERE id = ?',
            { reason, action, trim(d.note, 1000), officerLabel(src, job), expires, now(), existing })
    else
        MySQL.insert.await('INSERT INTO vw_mdt_anpr (plate, reason, action, note, officer_name, expires_at, active, created_at) VALUES (?, ?, ?, ?, ?, ?, 1, ?)',
            { key, reason, action, trim(d.note, 1000), officerLabel(src, job), expires, now() })
    end
    ANPR_ClearCache()
    return { ok = true, updated = existing ~= nil }
end

-- Plate suggestions while typing: registered vehicles, plates already on ANPR,
-- and plates ANPR has hit before (catches false plates nobody owns).
H.plateSuggest = function(_, _, d)
    local key = ANPR_Key(d.q)
    if #key < 2 then return { results = {} } end
    local out, seen = {}, {}
    local function push(item)
        local k = ANPR_Key(item.plate)
        if seen[k] then
            for kk, vv in pairs(item) do if out[seen[k]][kk] == nil then out[seen[k]][kk] = vv end end
            return
        end
        out[#out + 1] = item
        seen[k] = #out
    end

    local regs = Bridge.SearchVehicles(key)
    local owners = {}
    for i = 1, math.min(8, #regs) do if regs[i].owner then owners[#owners + 1] = regs[i].owner end end
    local names = namesFor(owners)
    for i = 1, math.min(8, #regs) do
        local v = regs[i]
        push({ plate = v.plate, model = v.model, keeper = names[v.owner], registered = true })
    end

    local like = '%' .. key .. '%'
    for _, r in ipairs(MySQL.query.await("SELECT plate, reason FROM vw_mdt_anpr WHERE active = 1 AND (expires_at IS NULL OR expires_at > ?) AND plate LIKE ? LIMIT 5", { now(), like }) or {}) do
        push({ plate = r.plate, onAnpr = r.reason })
    end
    for _, r in ipairs(MySQL.query.await('SELECT plate, MAX(model) AS model, MAX(created_at) AS last FROM vw_mdt_anpr_hits WHERE plate LIKE ? GROUP BY plate ORDER BY last DESC LIMIT 5', { like }) or {}) do
        push({ plate = r.plate, seen = r.last, modelLabel = r.model })
    end

    -- Exact and starts-with matches first.
    table.sort(out, function(a, b)
        local function rank(x)
            local k = ANPR_Key(x.plate)
            return k == key and 0 or (k:sub(1, #key) == key and 1 or 2)
        end
        local ra, rb = rank(a), rank(b)
        if ra ~= rb then return ra < rb end
        return ANPR_Key(a.plate) < ANPR_Key(b.plate)
    end)
    while #out > 8 do table.remove(out) end
    return { results = out }
end

H.anprRemove = function(_, _, d)
    local r = MySQL.single.await('SELECT plate FROM vw_mdt_anpr WHERE id = ?', { tonumber(d.id) })
    if not r then return { error = 'Marker not found.' } end
    -- Take the plate off completely, including any duplicate entries for it.
    MySQL.update.await('UPDATE vw_mdt_anpr SET active = 0 WHERE plate = ? AND active = 1', { r.plate })
    ANPR_ClearCache()
    -- Tell the officer if something else will still set it off (a Stolen marker, a wanted keeper...).
    local still = ANPR_Check({ r.plate })[r.plate]
    local reasons = {}
    for _, x in ipairs(still and still.reasons or {}) do reasons[#reasons + 1] = x.label end
    return { ok = true, plate = (still and still.realPlate) or r.plate, stillHits = reasons }
end

---------------------------------------------------------------------------
-- Audit log
---------------------------------------------------------------------------
-- reason = true: needs a lawful reason before it runs.
AUDITED = {
    searchPeople = { kind = 'person', reason = true, label = 'Person search' },
    getPerson = { kind = 'person', reason = true, label = 'Viewed person record' },
    searchVehicles = { kind = 'vehicle', reason = true, label = 'Vehicle search' },
    getVehicle = { kind = 'vehicle', reason = true, label = 'Viewed vehicle record' },
    removeMarker = { kind = 'marker', label = 'Removed warning marker' },
    deleteRecord = { kind = 'record', label = 'Deleted custody record' },
    liftDisqualification = { kind = 'person', label = 'Lifted disqualification' },
    clearPoints = { kind = 'person', label = 'Cleared penalty points' },
    seizeItems = { kind = 'person', label = 'Seized items into evidence' },
    evidenceOpen = { kind = 'evidence', label = 'Opened evidence bag' },
    evidenceReturn = { kind = 'evidence', label = 'Returned evidence to owner' },
    evidenceDestroy = { kind = 'evidence', label = 'Destroyed evidence' },
    revokeCategory = { kind = 'person', label = 'Revoked licence category' },
    clearPendingLicence = { kind = 'person', label = 'Cancelled queued licence actions' },
    endorse = { kind = 'person', label = 'Endorsed licence' },
    disqualify = { kind = 'person', label = 'Disqualified driver' },
    closeWarrant = { kind = 'warrant', label = 'Closed warrant' },
    anprRemove = { kind = 'anpr', label = 'Removed plate from ANPR' },
    nfa = { kind = 'record', label = 'No further action' },
    getInterview = { kind = 'interview', label = 'Played interview' },
    defenceCase = { kind = 'defence', label = 'Solicitor opened disclosure' },
    cpsCase = { kind = 'cps', label = 'Opened CPS file' },
    custodyReview = { kind = 'record', label = 'Custody review' },
    custodyExtend = { kind = 'record', label = 'Detention extended' },
}

function ValidReason(r)
    if type(r) ~= 'string' then return false end
    for _, x in ipairs(Config.Audit.Reasons or {}) do if x == r then return true end end
    return false
end

function Audit(src, job, action, def, d, result)
    if not Config.Audit.enabled then return end
    local sid, label, detail
    if action == 'searchPeople' then
        sid = d.ref or nil
        label = trim(d.ref, 64) or trim(((d.first or '') .. ' ' .. (d.last or '')), 64) or trim(d.q, 64)
        detail = ('%d result(s)'):format(#(result.results or {}))
    elseif action == 'getPerson' then
        sid = d.cid
        label = result.person and fullName(result.person)
    elseif action == 'searchVehicles' then
        label = trim(d.q, 12) and d.q:upper()
        detail = ('%d result(s)'):format(#(result.results or {}))
    elseif action == 'getVehicle' then
        sid = result.vehicle and result.vehicle.plate or d.plate
        label = sid
    else
        sid = tostring(d.id or d.cid or d.recordId or '')
        label = d.label
        detail = trim(d.reason, 160)
    end
    MySQL.insert('INSERT INTO vw_mdt_audit (officer_cid, officer_name, action, subject_type, subject_id, subject_label, reason, detail, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        { Bridge.GetCid(src), officerLabel(src, job), def.label, def.kind, sid and tostring(sid):sub(1, 64) or nil,
          label and tostring(label):sub(1, 120) or nil, ValidReason(d._reason) and d._reason or nil, detail, now() })
end

local function canAudit(job) return job.role == 'police' and (job.grade or 0) >= (Config.Audit.ViewGrade or 3) end

H.auditLog = function(_, job, d)
    if not canAudit(job) then return { error = 'Only supervisors can read the audit log.' } end
    local where, args = { '1 = 1' }, {}
    local officer = trim(d.officer, 64)
    if officer then where[#where + 1] = 'officer_name LIKE ?'; args[#args + 1] = '%' .. officer .. '%' end
    local subject = trim(d.subject, 64)
    if subject then where[#where + 1] = '(subject_label LIKE ? OR subject_id = ?)'; args[#args + 1] = '%' .. subject .. '%'; args[#args + 1] = subject end
    if d.subjectType and d.subjectId then
        where[#where + 1] = 'subject_type = ? AND subject_id = ?'; args[#args + 1] = d.subjectType; args[#args + 1] = d.subjectId
    end
    if tonumber(d.from) then where[#where + 1] = 'created_at >= ?'; args[#args + 1] = tonumber(d.from) end
    if tonumber(d.to) then where[#where + 1] = 'created_at <= ?'; args[#args + 1] = tonumber(d.to) end
    local rows = MySQL.query.await(('SELECT * FROM vw_mdt_audit WHERE %s ORDER BY created_at DESC LIMIT 200'):format(table.concat(where, ' AND ')), args) or {}
    return { results = rows }
end

---------------------------------------------------------------------------
-- Custody clock
---------------------------------------------------------------------------
local function custodyData(r) return type(r.custody) == 'string' and Bridge.Decode(r.custody) or (r.custody or {}) end

--- Elapsed custody hours, next review, limit, and whether anything is overdue.
function CustodyClock(r)
    local c = Config.Custody
    local data = custodyData(r)
    local hour = (c.HourLength or 60) * 60
    local hours = (now() - (r.created_at or now())) / hour
    local reviews = data.reviews or {}
    local nextReview = c.FirstReview + #reviews * c.ReviewEvery
    local limit = (data.extension and data.extension.hours) or c.Limit
    return {
        hours = math.floor(hours * 10) / 10,
        nextReview = nextReview,
        reviewDueAt = (r.created_at or now()) + math.floor(nextReview * hour),
        reviewOverdue = hours >= nextReview,
        limit = limit,
        limitAt = (r.created_at or now()) + math.floor(limit * hour),
        overLimit = hours >= limit,
        reviews = reviews,
        extension = data.extension,
        hourLength = c.HourLength or 60,
    }
end

H.custodyReview = function(src, job, d)
    if (job.grade or 0) < (Config.Custody.ReviewGrade or 2) then return { error = 'Reviews must be done by an inspector or above.' } end
    local r = MySQL.single.await('SELECT id, created_at, outcome, custody FROM vw_mdt_records WHERE id = ?', { tonumber(d.id) })
    if not r or r.outcome ~= Config.Outcomes[1] then return { error = 'This person is not in custody.' } end
    local ok = false
    for _, x in ipairs(Config.Custody.ReviewReasons) do if x == d.reason then ok = true end end
    if not ok then return { error = 'Choose why detention should continue.' } end
    local data = custodyData(r)
    data.reviews = data.reviews or {}
    data.reviews[#data.reviews + 1] = { at = now(), by = officerLabel(src, job), reason = d.reason, note = trim(d.note, 400) }
    MySQL.update.await('UPDATE vw_mdt_records SET custody = ? WHERE id = ?', { json.encode(data), r.id })
    return { ok = true }
end

H.custodyExtend = function(src, job, d)
    local ext
    for _, e in ipairs(Config.Custody.Extensions) do if e.id == d.extension then ext = e end end
    if not ext then return { error = 'Choose an extension.' } end
    if (job.grade or 0) < (ext.grade or 0) then return { error = 'Your rank cannot authorise that extension.' } end
    local r = MySQL.single.await('SELECT id, created_at, outcome, custody FROM vw_mdt_records WHERE id = ?', { tonumber(d.id) })
    if not r or r.outcome ~= Config.Outcomes[1] then return { error = 'This person is not in custody.' } end
    local data = custodyData(r)
    if data.extension and data.extension.hours >= ext.hours then return { error = 'Detention is already extended that far.' } end
    data.extension = { id = ext.id, hours = ext.hours, label = ext.label, by = officerLabel(src, job), at = now(), note = trim(d.note, 400) }
    MySQL.update.await('UPDATE vw_mdt_records SET custody = ? WHERE id = ?', { json.encode(data), r.id })
    return { ok = true }
end

---------------------------------------------------------------------------
-- Custody photos
---------------------------------------------------------------------------
local photoWindow = {}   -- officer src -> { cid, recordId, until }

local function fivemanageKey()
    local k = (SvConfig and SvConfig.Fivemanage and SvConfig.Fivemanage.ApiKey) or ''
    if k == '' then k = GetConvar('fivemanage_key', '') end
    return k
end

-- Step 1: officer asks to photograph a detainee. Checks they're close, returns the target's server id.
H.mugshotStart = function(src, job, d)
    if not Config.Mugshot.enabled then return { error = 'Custody photos are switched off.' } end
    if GetResourceState('screenshot-basic') ~= 'started' then return { error = 'screenshot-basic is not running on the server.' } end
    if fivemanageKey() == '' then return { error = 'No Fivemanage key in server/sv_config.lua.' } end
    local cid = trim(d.cid, 64)
    local target = cid and Bridge.GetSource(cid)
    if not target then return { error = 'The detainee must be in the city.' } end
    local a, b = GetPlayerPed(src), GetPlayerPed(target)
    if a == 0 or b == 0 or #(GetEntityCoords(a) - GetEntityCoords(b)) > (Config.Mugshot.MaxDistance or 4.0) then
        return { error = 'Stand in front of the detainee to take their photo.' }
    end
    photoWindow[src] = { cid = cid, recordId = tonumber(d.recordId), untilAt = now() + 120 }
    return { ok = true, target = target }
end

-- Step 2: the officer's client took the picture and sends it here; the server uploads it.
-- The image is far too big for a normal event or ox_lib callback (they time out), so the
-- client sends it as a latent event and we reply with the result.
local function uploadMugshot(src, data)
    local w = photoWindow[src]
    photoWindow[src] = nil
    if not w or now() > w.untilAt then return { error = 'The photo took too long. Try again.' } end
    if type(data) ~= 'string' or not data:match('^data:image/') or #data > 8 * 1024 * 1024 then return { error = 'The photo could not be taken.' } end
    local job = access(src)
    if not job or job.role ~= 'police' then return { error = 'You do not have access to the MDT.' } end

    local p, done = promise.new(), false
    local function finish(v) if not done then done = true; p:resolve(v) end end
    PerformHttpRequest((SvConfig.Fivemanage and SvConfig.Fivemanage.Endpoint) or 'https://api.fivemanage.com/api/v3/file/base64', function(status, body)
        if status ~= 200 and status ~= 201 then
            print(('[vinewood-mdt] Fivemanage upload failed (%s): %s'):format(tostring(status), tostring(body)))
            return finish(nil)
        end
        local ok, decoded = pcall(json.decode, body or '')
        finish(ok and decoded and ((decoded.data and decoded.data.url) or decoded.url) or nil)
    end, 'POST', json.encode({ base64 = data, filename = ('custody_%s_%d.%s'):format(w.cid, now(), Config.Mugshot.Encoding or 'jpg') }),
        { ['Content-Type'] = 'application/json', ['Authorization'] = fivemanageKey() })
    SetTimeout(30000, function() finish(nil) end)
    local url = Citizen.Await(p)
    if not url then return { error = 'The photo could not be uploaded. Check the server console.' } end
    MySQL.insert.await('INSERT INTO vw_mdt_photos (cid, url, record_id, officer_name, created_at) VALUES (?, ?, ?, ?, ?)',
        { w.cid, url, w.recordId, officerLabel(src, job), now() })
    return { ok = true, url = url }
end

RegisterNetEvent('vinewood-mdt:server:mugshotData', function(token, data)
    local src = source
    local ok, result = pcall(uploadMugshot, src, data)
    if not ok then
        print(('[vinewood-mdt] custody photo failed: %s'):format(result))
        result = { error = 'The photo could not be saved. Check the server console.' }
    end
    TriggerClientEvent('vinewood-mdt:client:mugshotResult', src, token, result)
end)

---------------------------------------------------------------------------
-- Stop and search
---------------------------------------------------------------------------
local function powerById(id)
    for _, p in ipairs(Config.StopSearch.Powers) do if p.id == id then return p end end
end
local function inSet(list, v) for _, x in ipairs(list) do if x == v then return true end end return false end

H.stopSearchList = function(_, _, d)
    local rows
    if d.cid then
        rows = MySQL.query.await('SELECT * FROM vw_mdt_stopsearch WHERE cid = ? ORDER BY created_at DESC LIMIT 60', { d.cid })
    else
        rows = MySQL.query.await('SELECT * FROM vw_mdt_stopsearch ORDER BY created_at DESC LIMIT 80')
    end
    return { results = rows or {} }
end

H.stopSearchCreate = function(src, job, d)
    if not Config.StopSearch.enabled then return { error = 'Stop and search is switched off.' } end
    local power = powerById(d.power)
    if not power then return { error = 'Choose the power used.' } end
    if not inSet(Config.StopSearch.Objects, d.object) then return { error = 'Choose what you were searching for.' } end
    if not inSet(Config.StopSearch.Outcomes, d.outcome) then return { error = 'Choose the outcome.' } end
    local grounds = trim(d.grounds, 2000)
    if not power.authorisation and (not grounds or #grounds < 20) then
        return { error = 'Record your reasonable grounds for suspicion.' }
    end
    local authorisation = trim(d.authorisation, 160)
    if power.authorisation and not authorisation then return { error = 'Record the authorising officer and area for this power.' } end
    if d.gowisely ~= true then return { error = 'Confirm you gave the GOWISELY information.' } end

    local cid, name = trim(d.cid, 64), nil
    if cid then
        local p = Bridge.GetPerson(cid)
        if not p then return { error = 'No person with that reference.' } end
        name = fullName(p)
    end
    local description = trim(d.description, 255)
    if not cid and not description then return { error = 'Choose the person, or describe them if they would not give a name.' } end

    local t = now()
    local id = MySQL.insert.await([[INSERT INTO vw_mdt_stopsearch (cid, subject_name, description, plate, power, authorisation, object, grounds, location, coords, found, outcome, gowisely, receipt, incident_id, officer_name, officer_cid, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 0, ?, ?, ?, ?)]],
        { cid, name, description, trim(d.plate, 12) and d.plate:upper() or nil, power.id, authorisation, d.object, grounds,
          trim(d.location, 160), type(d.coords) == 'table' and json.encode(d.coords) or nil, trim(d.found, 1000), d.outcome,
          tonumber(d.incidentId), officerLabel(src, job), Bridge.GetCid(src), t })
    local ref = ('SS/%s/%s/%05d'):format(Config.ForceShort, os.date('%y%m'), id)
    MySQL.update.await('UPDATE vw_mdt_stopsearch SET ref = ? WHERE id = ?', { ref, id })

    -- The person searched is entitled to a record of it.
    local target = cid and Bridge.GetSource(cid)
    if target then
        local rec = { ref = ref, power = power.label, object = d.object, outcome = d.outcome, officer = officerLabel(src, job), at = t, grounds = grounds }
        TriggerClientEvent('vinewood-mdt:client:stopSearchNotice', target, rec, Config.ForceName)
        if Config.StopSearch.ReceiptItem and Inv.Pick() then
            pcall(function()
                Inv.Give(target, Config.StopSearch.ReceiptItem, 1, {
                    description = ('%s - %s - %s'):format(ref, power.label, os.date('%d/%m/%Y %H:%M', t)),
                    ref = ref,
                })
            end)
        end
        MySQL.update('UPDATE vw_mdt_stopsearch SET receipt = 1 WHERE id = ?', { id })
    end
    return { ok = true, id = id, ref = ref, receipt = target ~= nil }
end

---------------------------------------------------------------------------
-- Fines and traffic offence reports
---------------------------------------------------------------------------
local FINE_STATUS = { unpaid = true, paid = true, court = true, cancelled = true }
local money = function(n) return ('%s%s'):format(Config.Fines.Currency or '£', math.floor(n or 0)) end

local function offenceByCode(code)
    for _, o in ipairs(Config.Fines.Offences) do if o.code == code then return o end end
end

-- Unpaid after the due date: register it with the increase, once.
local function escalate(f)
    if f.status == 'unpaid' and f.due_at and f.due_at < now() and f.increased == 0 and (Config.Fines.UnpaidIncrease or 0) > 0 then
        f.amount = math.floor(f.amount * (1 + Config.Fines.UnpaidIncrease / 100))
        f.increased = 1
        MySQL.update('UPDATE vw_mdt_fines SET amount = ?, increased = 1 WHERE id = ?', { f.amount, f.id })
    end
    f.overdue = f.status == 'unpaid' and f.due_at and f.due_at < now() or false
    f.offences = Bridge.Decode(f.offences)
    return f
end

H.finesList = function(_, _, d)
    local where, args = {}, {}
    if d.cid then where[#where + 1] = 'cid = ?'; args[#args + 1] = d.cid end
    if FINE_STATUS[d.status] then where[#where + 1] = 'status = ?'; args[#args + 1] = d.status end
    local rows = MySQL.query.await(('SELECT * FROM vw_mdt_fines %s ORDER BY created_at DESC LIMIT 100'):format(#where > 0 and ('WHERE ' .. table.concat(where, ' AND ')) or ''), args) or {}
    for _, f in ipairs(rows) do escalate(f) end
    return { results = rows }
end

H.issueFine = function(src, job, d)
    if not Config.Fines.enabled then return { error = 'Fines are switched off.' } end
    local cid = trim(d.cid, 64)
    local p = cid and Bridge.GetPerson(cid)
    if not p then return { error = 'Choose the person.' } end
    local kind = (d.type == 'PND' or d.type == 'TOR') and d.type or 'FPN'
    local list, amount, points = {}, 0, 0
    for _, code in ipairs(type(d.codes) == 'table' and d.codes or {}) do
        local o = offenceByCode(code)
        if o and (kind == 'TOR' or o.type == kind) then
            list[#list + 1] = { code = o.code, label = o.label, amount = o.amount, points = o.points or 0 }
            amount = amount + (o.amount or 0)
            points = points + (o.points or 0)
        end
    end
    local other = trim(d.other, 160)
    if kind == 'TOR' and other then list[#list + 1] = { code = 'TOR', label = other, amount = 0, points = 0 } end
    if #list == 0 then return { error = 'Choose at least one offence.' } end
    if kind == 'TOR' then amount, points = 0, 0 end

    local target = Bridge.GetSource(cid)
    -- Points go on at the roadside, so the driver has to be there for an endorsable FPN.
    local _, _, canQueue = Licences.DvlaResource()
    if kind == 'FPN' and points > 0 and not target and not canQueue then return { error = 'The driver must be in the city to receive an endorsable fixed penalty.' } end

    local t = now()
    local officer = officerLabel(src, job)
    local id = MySQL.insert.await([[INSERT INTO vw_mdt_fines (cid, subject_name, type, offences, amount, points, status, due_at, location, plate, notes, incident_id, officer_name, officer_cid, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]],
        { cid, fullName(p), kind, json.encode(list), amount, points, kind == 'TOR' and 'court' or 'unpaid',
          kind == 'TOR' and nil or (t + (Config.Fines.DueDays or 28) * 86400), trim(d.location, 160),
          trim(d.plate, 12) and d.plate:upper() or nil, trim(d.notes, 1000), tonumber(d.incidentId), officer, Bridge.GetCid(src), t })
    local ref = ('%s/%s/%s/%05d'):format(kind, Config.ForceShort, os.date('%y%m'), id)
    MySQL.update.await('UPDATE vw_mdt_fines SET ref = ? WHERE id = ?', { ref, id })

    local endorsed = {}
    if kind == 'FPN' then
        for _, o in ipairs(list) do
            if (o.points or 0) > 0 then
                local ok, err, total, banned, queued = Licences.Endorse(cid, o.points, o.code, o.label, officer)
                endorsed[#endorsed + 1] = ok and ('%s: %d points%s'):format(o.code, o.points, queued and ' (applies at next login)' or '') or ('%s: not endorsed (%s)'):format(o.code, err or 'error')
                if banned then endorsed[#endorsed + 1] = 'Totting up: driver disqualified' end
            end
        end
    end

    if target then
        TriggerClientEvent('vinewood-mdt:client:fineNotice', target, {
            ref = ref, type = kind, offences = list, amount = amount, points = points, officer = officer,
            due = kind ~= 'TOR' and (t + (Config.Fines.DueDays or 28) * 86400) or nil, command = Config.Fines.PayCommand,
        }, Config.ForceName)
    end
    return { ok = true, id = id, ref = ref, amount = amount, endorsed = endorsed }
end

H.fineCourtResult = function(src, job, d)
    if (job.grade or 0) < (Config.SupervisorGrade or 3) then return { error = 'Court results are recorded by a supervisor.' } end
    local f = MySQL.single.await('SELECT * FROM vw_mdt_fines WHERE id = ?', { tonumber(d.id) })
    if not f or f.status ~= 'court' then return { error = 'This report is not waiting for court.' } end
    local result = trim(d.result, 1000)
    if not result then return { error = 'Record what the court decided.' } end
    local amount = math.max(0, math.floor(tonumber(d.amount) or 0))
    local points = math.max(0, math.floor(tonumber(d.points) or 0))
    local officer = officerLabel(src, job)
    local notes = {}
    if points > 0 then
        local codes = Bridge.Decode(f.offences)
        local code = codes[1] and codes[1].code or 'TOR'
        local ok, err = Licences.Endorse(f.cid, points, code, 'Court: ' .. result, officer)
        notes[#notes + 1] = ok and ('%d points endorsed'):format(points) or ('Points not endorsed: %s'):format(err or 'error')
    end
    local ban = tonumber(d.banDays)
    if ban and ban >= 0 and d.ban then
        local ok, err = Licences.Disqualify(f.cid, ban > 0 and ban or nil, 'Court: ' .. result, officer)
        notes[#notes + 1] = ok and 'Disqualified' or ('Not disqualified: %s'):format(err or 'error')
    end
    MySQL.update.await('UPDATE vw_mdt_fines SET court_result = ?, amount = ?, points = ?, status = ?, due_at = ? WHERE id = ?',
        { result, amount, points, amount > 0 and 'unpaid' or 'paid', amount > 0 and (now() + (Config.Fines.DueDays or 28) * 86400) or nil, f.id })
    return { ok = true, notes = notes }
end

H.cancelFine = function(src, job, d)
    if (job.grade or 0) < (Config.SupervisorGrade or 3) then return { error = 'Cancelling needs a supervisor.' } end
    MySQL.update.await("UPDATE vw_mdt_fines SET status = 'cancelled', court_result = CONCAT(COALESCE(court_result, ''), ?) WHERE id = ? AND status IN ('unpaid','court')",
        { ('\nCancelled by %s: %s'):format(officerLabel(src, job), trim(d.reason, 200) or 'no reason given'), tonumber(d.id) })
    return { ok = true }
end

-- Players: see and pay what they owe.
lib.callback.register('vinewood-mdt:server:myFines', function(src)
    local cid = Bridge.GetCid(src)
    if not cid then return {} end
    local rows = MySQL.query.await("SELECT * FROM vw_mdt_fines WHERE cid = ? AND status IN ('unpaid','court') ORDER BY created_at DESC", { cid }) or {}
    for _, f in ipairs(rows) do
        escalate(f)
        -- Client Lua has no os library, so the date is formatted here.
        f.due_text = f.due_at and os.date('%d/%m/%Y', f.due_at) or nil
    end
    return rows
end)

lib.callback.register('vinewood-mdt:server:payFine', function(src, id)
    local cid = Bridge.GetCid(src)
    local f = cid and MySQL.single.await("SELECT * FROM vw_mdt_fines WHERE id = ? AND cid = ? AND status = 'unpaid'", { tonumber(id), cid })
    if not f then return { error = 'That fine is not outstanding.' } end
    escalate(f)
    local account = Config.Fines.Account or 'bank'
    if Bridge.GetMoney(src, account) < f.amount then return { error = ('You need %s in your %s.'):format(money(f.amount), account) } end
    if not Bridge.RemoveMoney(src, account, f.amount, ('Fine %s'):format(f.ref)) then return { error = 'The payment failed.' } end
    MySQL.update.await("UPDATE vw_mdt_fines SET status = 'paid', paid_at = ? WHERE id = ?", { now(), f.id })
    pcall(Config.Fines.OnPaid, f.amount, f)
    Webhook.Send('fines', ('Fine paid: %s'):format(f.ref), nil, { { 'Paid by', f.subject_name }, { 'Amount', money(f.amount) } }, 'green')
    return { ok = true, amount = money(f.amount) }
end)

---------------------------------------------------------------------------
-- Statements (MG11)
---------------------------------------------------------------------------
local function inKinds(k) for _, x in ipairs(Config.Statements.Kinds) do if x == k then return true end end return false end

H.statementsFor = function(_, _, d)
    return { results = MySQL.query.await('SELECT * FROM vw_mdt_statements WHERE incident_id = ? ORDER BY created_at ASC', { tonumber(d.incidentId) }) or {} }
end

local function sendForSignature(st)
    local target = st.maker_cid and Bridge.GetSource(st.maker_cid)
    if not target then return false end
    TriggerClientEvent('vinewood-mdt:client:signStatement', target, {
        id = st.id, kind = st.kind, name = st.maker_name, body = st.body, takenBy = st.taken_by,
        declaration = Config.Statements.Declaration, force = Config.ForceName,
    })
    return true
end

H.takeStatement = function(src, job, d)
    if not Config.Statements.enabled then return { error = 'Statements are switched off.' } end
    local incidentId = tonumber(d.incidentId)
    if not incidentId or not MySQL.scalar.await('SELECT id FROM vw_mdt_incidents WHERE id = ?', { incidentId }) then return { error = 'Incident not found.' } end
    if not inKinds(d.kind) then return { error = 'Choose the type of statement.' } end
    local body = trim(d.body, 20000)
    if not body or #body < 30 then return { error = 'The statement is too short.' } end
    local officer = officerLabel(src, job)
    local makerCid, makerName, status
    if d.kind == 'Officer' then
        makerCid, makerName, status = Bridge.GetCid(src), officer, 'signed'
    else
        makerCid = trim(d.makerCid, 64)
        local p = makerCid and Bridge.GetPerson(makerCid)
        if not p then return { error = 'Choose who is making the statement.' } end
        makerName, status = fullName(p), 'pending'
    end
    local t = now()
    local id = MySQL.insert.await([[INSERT INTO vw_mdt_statements (incident_id, kind, maker_cid, maker_name, occupation, body, status, signed_at, taken_by, taken_by_cid, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]],
        { incidentId, d.kind, makerCid, makerName, trim(d.occupation, 96), body, status, status == 'signed' and t or nil, officer, Bridge.GetCid(src), t })
    local sent = false
    if status == 'pending' then
        sent = sendForSignature({ id = id, kind = d.kind, maker_cid = makerCid, maker_name = makerName, body = body, taken_by = officer })
    end
    return { ok = true, id = id, status = status, sent = sent }
end

H.resendStatement = function(_, _, d)
    local st = MySQL.single.await("SELECT * FROM vw_mdt_statements WHERE id = ? AND status IN ('pending','refused')", { tonumber(d.id) })
    if not st then return { error = 'That statement is not waiting for a signature.' } end
    MySQL.update.await("UPDATE vw_mdt_statements SET status = 'pending' WHERE id = ?", { st.id })
    if not sendForSignature(st) then return { error = ('%s is not in the city.'):format(st.maker_name or 'They') } end
    return { ok = true }
end

-- The witness signs (or refuses) on their own screen.
RegisterNetEvent('vinewood-mdt:server:statementSign', function(id, accept)
    local src = source
    local cid = Bridge.GetCid(src)
    local st = cid and MySQL.single.await("SELECT * FROM vw_mdt_statements WHERE id = ? AND maker_cid = ? AND status = 'pending'", { tonumber(id), cid })
    if not st then return end
    local status = accept and 'signed' or 'refused'
    MySQL.update.await('UPDATE vw_mdt_statements SET status = ?, signed_at = ? WHERE id = ?', { status, now(), st.id })
    local officerSrc = st.taken_by_cid and Bridge.GetSource(st.taken_by_cid)
    if officerSrc then
        Bridge.Notify(officerSrc, ('%s %s their statement.'):format(st.maker_name or 'The witness', accept and 'signed' or 'refused to sign'), accept and 'success' or 'error')
    end
    Webhook.Send('statements', ('Statement %s'):format(accept and 'signed' or 'refused'), nil,
        { { 'By', st.maker_name }, { 'Type', st.kind }, { 'Taken by', st.taken_by } }, accept and 'green' or 'amber')
end)

---------------------------------------------------------------------------
-- Discord webhooks for MDT actions
---------------------------------------------------------------------------
local function nameOf(cid) local p = cid and Bridge.GetPerson(cid); return p and fullName(p) or cid end
local function recordOf(id) return MySQL.single.await('SELECT ref, subject_name, offences, outcome FROM vw_mdt_records WHERE id = ?', { tonumber(id) }) end

HOOKS = {
    -- custody
    createRecord = function(src, job, d, r)
        Webhook.Send('custody', ('Booked into custody: %s'):format(nameOf(d.cid)), table.concat(type(d.offences) == 'table' and d.offences or {}, '\n'),
            { { 'Custody ref', r.ref }, { 'Officer', officerLabel(src, job) }, { 'Status', d.outcome or Config.Outcomes[1] } }, 'blue')
    end,
    setOutcome = function(src, job, d)
        local rec = recordOf(d.id)
        Webhook.Send('custody', ('Custody outcome: %s'):format(rec and rec.subject_name or ''), nil, { { 'Custody ref', rec and rec.ref }, { 'Outcome', d.outcome }, { 'Officer', officerLabel(src, job) } }, 'blue')
    end,
    releaseOnBail = function(src, job, d, r)
        local b = r.bail or {}
        Webhook.Send('custody', ('Released on bail: %s'):format(b.name or ''), nil,
            { { 'Type', d.type }, { 'Answer', b.returnAt and os.date('%d/%m/%Y %H:%M', b.returnAt) or 'No date' }, { 'At', b.station }, { 'Conditions', #(b.conditions or {}) }, { 'Officer', officerLabel(src, job) } }, 'amber')
    end,
    updateBail = function(src, job, d)
        Webhook.Send('custody', ('Bail %s'):format(d.action), nil, { { 'Bail id', d.id }, { 'Officer', officerLabel(src, job) } }, d.action == 'breached' and 'red' or 'grey')
    end,
    nfa = function(src, job, d)
        local rec = d.recordId and recordOf(d.recordId)
        Webhook.Send('custody', ('No further action: %s'):format(rec and rec.subject_name or nameOf(d.cid) or ''), d.reason, { { 'Custody ref', rec and rec.ref }, { 'By', officerLabel(src, job) } }, 'green')
    end,
    custodyReview = function(src, job, d)
        local rec = recordOf(d.id)
        Webhook.Send('custody', ('Custody review: %s'):format(rec and rec.subject_name or ''), d.reason, { { 'Custody ref', rec and rec.ref }, { 'Reviewed by', officerLabel(src, job) } }, 'grey')
    end,
    custodyExtend = function(src, job, d)
        local rec = recordOf(d.id)
        Webhook.Send('custody', ('Detention extended: %s'):format(rec and rec.subject_name or ''), d.note, { { 'Custody ref', rec and rec.ref }, { 'Authority', d.extension }, { 'By', officerLabel(src, job) } }, 'amber')
    end,
    -- warrants
    issueWarrant = function(src, job, d)
        Webhook.Send('warrants', 'Warrant recorded', d.reason, { { 'Type', d.type }, { 'Person', d.cid and nameOf(d.cid) }, { 'Address', d.address }, { 'By', officerLabel(src, job) } }, 'red')
    end,
    closeWarrant = function(src, job, d)
        local w = MySQL.single.await('SELECT type, subject_name, address FROM vw_mdt_warrants WHERE id = ?', { tonumber(d.id) })
        Webhook.Send('warrants', ('Warrant %s'):format(d.status == 'executed' and 'executed' or 'cancelled'), nil,
            { { 'Type', w and w.type }, { 'Subject', w and (w.subject_name or w.address) }, { 'By', officerLabel(src, job) } }, d.status == 'executed' and 'green' or 'grey')
    end,
    -- CPS
    submitCps = function(src, job, d)
        local rec = recordOf(d.recordId)
        Webhook.Send('cps', ('Submitted to CPS: %s'):format(rec and rec.subject_name or ''), nil, { { 'Custody ref', rec and rec.ref }, { 'Officer', officerLabel(src, job) } }, 'blue')
    end,
    cpsDecide = function(src, job, d)
        local c = MySQL.single.await('SELECT subject_name, custody_ref FROM vw_mdt_cps WHERE id = ?', { tonumber(d.id) })
        local words = { charge = 'Charge authorised', nfa = 'No further action', more_evidence = 'Further evidence requested' }
        Webhook.Send('cps', ('CPS: %s'):format(words[d.decision] or d.decision), d.decision == 'more_evidence' and d.actionPlan or d.reason,
            { { 'Suspect', c and c.subject_name }, { 'Custody ref', c and c.custody_ref }, { 'Lawyer', officerLabel(src, job) } }, d.decision == 'charge' and 'red' or (d.decision == 'nfa' and 'green' or 'amber'))
    end,
    -- fines
    issueFine = function(src, job, d, r)
        Webhook.Send('fines', ('%s issued: %s'):format(d.type == 'TOR' and 'Traffic offence report' or (d.type or 'FPN'), r.ref), nil,
            { { 'To', nameOf(d.cid) }, { 'Amount', d.type ~= 'TOR' and money(r.amount) or 'To court' }, { 'Offences', table.concat(d.codes or {}, ', ') }, { 'Endorsed', table.concat(r.endorsed or {}, '\n') }, { 'Officer', officerLabel(src, job) } },
            d.type == 'TOR' and 'amber' or 'blue')
    end,
    fineCourtResult = function(src, job, d, r)
        Webhook.Send('fines', 'Court result recorded', d.result, { { 'Fine', money(tonumber(d.amount) or 0) }, { 'Points', d.points }, { 'Notes', table.concat(r.notes or {}, '\n') }, { 'By', officerLabel(src, job) } }, 'amber')
    end,
    cancelFine = function(src, job, d)
        Webhook.Send('fines', 'Fine cancelled', d.reason, { { 'Fine id', d.id }, { 'By', officerLabel(src, job) } }, 'grey')
    end,
    -- statements
    takeStatement = function(src, job, d, r)
        Webhook.Send('statements', ('%s statement taken'):format(d.kind), nil,
            { { 'From', d.kind == 'Officer' and officerLabel(src, job) or nameOf(d.makerCid) }, { 'Status', r.status }, { 'Taken by', officerLabel(src, job) } }, 'blue')
    end,
    -- stop and search
    stopSearchCreate = function(src, job, d, r)
        Webhook.Send('stopsearch', ('Stop and search: %s'):format(r.ref), d.grounds,
            { { 'Person', d.cid and nameOf(d.cid) or d.description }, { 'Power', d.power }, { 'Object', d.object }, { 'Outcome', d.outcome }, { 'Location', d.location }, { 'Officer', officerLabel(src, job) } },
            d.outcome == 'Arrest' and 'red' or 'grey')
    end,
    mugshotStart = nil,
}

-- Audit entries also go to Discord (searches only if AuditSearches is on).
local baseAudit = Audit
Audit = function(src, job, action, def, d, result)
    baseAudit(src, job, action, def, d, result)
    local isSearch = action == 'searchPeople' or action == 'searchVehicles' or action == 'getPerson' or action == 'getVehicle'
    if isSearch and not (SvConfig.Webhooks and SvConfig.Webhooks.AuditSearches) then return end
    local subject = (action == 'getPerson' and result.person and fullName(result.person)) or (result.vehicle and result.vehicle.plate) or d.cid or d.plate or d.q or d.id
    Webhook.Send('audit', def.label, nil, { { 'Officer', officerLabel(src, job) }, { 'Subject', subject }, { 'Reason', ValidReason(d._reason) and d._reason or nil }, { 'Detail', d.reason } },
        isSearch and 'grey' or 'amber')
end

---------------------------------------------------------------------------
-- ANPR setup: fitted vehicles and roadside cameras added in game
---------------------------------------------------------------------------
ANPR_Cams = {}                         -- id -> { id, name, coords, heading, radius, prop, active, source }
local fittedModels, fittedPlates = {}, {}
local fittedRows = {}

function ANPR_CameraCount()
    local n = 0
    for _, c in pairs(ANPR_Cams) do if c.active then n = n + 1 end end
    return n
end

local function setupPayload()
    local cams = {}
    for id, c in pairs(ANPR_Cams) do
        if c.active then
            cams[#cams + 1] = { id = id, name = c.name, x = c.coords.x, y = c.coords.y, z = c.coords.z,
                heading = c.heading, radius = c.radius, prop = c.prop, speedLimit = c.speedLimit }
        end
    end
    local models, plates = {}, {}
    for v in pairs(fittedModels) do models[#models + 1] = v end
    for v in pairs(fittedPlates) do plates[#plates + 1] = v end
    return { cameras = cams, models = models, plates = plates }
end

function ANPR_LoadSetup()
    ANPR_Cams = {}
    for i, c in ipairs((Config.ANPR or {}).Cameras or {}) do
        ANPR_Cams['cfg' .. i] = { id = 'cfg' .. i, name = c.name, coords = c.coords, heading = c.heading or 0.0, speedLimit = c.speedLimit,
            radius = c.radius or 18.0, prop = false, active = true, source = 'config' }
    end
    for _, r in ipairs(MySQL.query.await('SELECT * FROM vw_mdt_anpr_cameras') or {}) do
        ANPR_Cams['db' .. r.id] = { id = 'db' .. r.id, dbId = r.id, name = r.name, coords = vec3(r.x, r.y, r.z), heading = r.heading, speedLimit = tonumber(r.speed_limit),
            radius = r.radius, prop = r.prop == 1 or r.prop == true, active = r.active == 1 or r.active == true, source = 'game', addedBy = r.added_by }
    end
    fittedModels, fittedPlates, fittedRows = {}, {}, MySQL.query.await('SELECT * FROM vw_mdt_anpr_fitted ORDER BY created_at DESC') or {}
    for _, r in ipairs(fittedRows) do
        if r.kind == 'model' then fittedModels[r.value] = true else fittedPlates[r.value] = true end
    end
    TriggerClientEvent('vinewood-mdt:client:anprSetup', -1, setupPayload())
end

lib.callback.register('vinewood-mdt:server:anprSetup', function() return setupPayload() end)

-- Load once the tables exist.
CreateThread(function()
    while not ANPR_TablesReady do Wait(250) end
    ANPR_LoadSetup()
end)

local function anprManager(src)
    if IsPlayerAceAllowed(src, 'vinewood-mdt.anpradmin') then return 'Admin' end
    local job = access(src)
    if job and job.role == 'police' and (job.grade or 0) >= ((Config.ANPR or {}).ManageGrade or Config.SupervisorGrade or 3) then
        return officerLabel(src, job)
    end
    return nil
end

-- In-game setup menu (/anpradmin). The server reads the player's own position for cameras.
lib.callback.register('vinewood-mdt:server:anprManage', function(src, action, d)
    local who = anprManager(src)
    if not who then return { error = 'You are not allowed to set up ANPR.' } end
    d = type(d) == 'table' and d or {}
    local t = now()

    if action == 'check' then
        return { ok = true }
    elseif action == 'addCamera' then
        local name = trim(d.name, 96)
        if not name then return { error = 'Give the camera a name.' } end
        local ped = GetPlayerPed(src)
        local c = GetEntityCoords(ped)
        local radius = math.max(6.0, math.min(60.0, tonumber(d.radius) or 18.0))
        local limit = tonumber(d.speedLimit)
        if limit and limit <= 0 then limit = nil end
        MySQL.insert.await('INSERT INTO vw_mdt_anpr_cameras (name, x, y, z, heading, radius, prop, active, added_by, created_at, speed_limit) VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?)',
            { name, c.x, c.y, c.z, GetEntityHeading(ped), radius, d.prop and 1 or 0, who, t, limit })
    elseif action == 'updateCamera' then
        local cam = ANPR_Cams[tostring(d.id)]
        if not cam or not cam.dbId then return { error = 'Cameras from config.lua are edited in the config file.' } end
        local prop, active
        if d.prop ~= nil then prop = d.prop and 1 or 0 end
        if d.active ~= nil then active = d.active and 1 or 0 end
        local radius = tonumber(d.radius)
        if radius then radius = math.max(6.0, math.min(60.0, radius)) end
        MySQL.update.await('UPDATE vw_mdt_anpr_cameras SET name = COALESCE(?, name), radius = COALESCE(?, radius), prop = COALESCE(?, prop), active = COALESCE(?, active) WHERE id = ?',
            { trim(d.name, 96), radius, prop, active, cam.dbId })
        if d.speedLimit ~= nil then
            local limit = tonumber(d.speedLimit)
            MySQL.update.await('UPDATE vw_mdt_anpr_cameras SET speed_limit = ? WHERE id = ?', { (limit and limit > 0) and limit or nil, cam.dbId })
        end
    elseif action == 'moveCamera' then
        local cam = ANPR_Cams[tostring(d.id)]
        if not cam or not cam.dbId then return { error = 'Cameras from config.lua are moved in the config file.' } end
        local ped = GetPlayerPed(src)
        local c = GetEntityCoords(ped)
        MySQL.update.await('UPDATE vw_mdt_anpr_cameras SET x = ?, y = ?, z = ?, heading = ? WHERE id = ?', { c.x, c.y, c.z, GetEntityHeading(ped), cam.dbId })
    elseif action == 'deleteCamera' then
        local cam = ANPR_Cams[tostring(d.id)]
        if not cam or not cam.dbId then return { error = 'Cameras from config.lua are removed in the config file.' } end
        MySQL.update.await('DELETE FROM vw_mdt_anpr_cameras WHERE id = ?', { cam.dbId })
    elseif action == 'fitModel' then
        local hash = tostring(math.floor(tonumber(d.hash) or 0))
        if hash == '0' then return { error = 'Get in the vehicle first.' } end
        if fittedModels[hash] then return { error = 'That model is already fitted.' } end
        MySQL.insert.await("INSERT INTO vw_mdt_anpr_fitted (kind, value, label, added_by, created_at) VALUES ('model', ?, ?, ?, ?)", { hash, trim(d.label, 96), who, t })
    elseif action == 'fitPlate' then
        local key = ANPR_Key(d.plate)
        if #key < 2 then return { error = 'Get in the vehicle first.' } end
        if fittedPlates[key] then return { error = 'This vehicle is already fitted.' } end
        MySQL.insert.await("INSERT INTO vw_mdt_anpr_fitted (kind, value, label, added_by, created_at) VALUES ('plate', ?, ?, ?, ?)", { key, trim(d.label, 96), who, t })
    elseif action == 'unfit' then
        if d.id then
            MySQL.update.await('DELETE FROM vw_mdt_anpr_fitted WHERE id = ?', { tonumber(d.id) })
        else
            -- remove whatever fits the vehicle they're in: its plate and its model
            MySQL.update.await("DELETE FROM vw_mdt_anpr_fitted WHERE (kind = 'plate' AND value = ?) OR (kind = 'model' AND value = ?)",
                { ANPR_Key(d.plate), tostring(math.floor(tonumber(d.hash) or 0)) })
        end
    elseif action == 'list' then
        local cams = {}
        for id, c in pairs(ANPR_Cams) do
            cams[#cams + 1] = { id = id, name = c.name, x = c.coords.x, y = c.coords.y, z = c.coords.z, radius = c.radius,
                prop = c.prop, active = c.active, source = c.source, speedLimit = c.speedLimit }
        end
        table.sort(cams, function(a, b) return a.name < b.name end)
        return { ok = true, cameras = cams, fitted = fittedRows }
    else
        return { error = 'Unknown action.' }
    end
    ANPR_LoadSetup()
    Webhook.Send('anpr', 'ANPR setup changed', nil, { { 'Action', action }, { 'Name', d.name or d.label or d.plate }, { 'By', who } }, 'grey')
    return { ok = true }
end)

-- MDT ANPR page: cameras and fitted vehicles (read for everyone, removal for managers)
H.anprSetup = function(src)
    local cams = {}
    for id, c in pairs(ANPR_Cams) do
        cams[#cams + 1] = { id = id, name = c.name, radius = c.radius, active = c.active, source = c.source, addedBy = c.addedBy, speedLimit = c.speedLimit,
            x = c.coords.x, y = c.coords.y }
    end
    table.sort(cams, function(a, b) return a.name < b.name end)
    return { cameras = cams, fitted = fittedRows, canManage = anprManager(src) ~= nil,
        configModels = (Config.ANPR or {}).Vehicles or {}, command = (Config.ANPR or {}).AdminCommand or 'anpradmin' }
end

H.anprSetupRemove = function(src, _, d)
    if not anprManager(src) then return { error = 'You are not allowed to change ANPR setup.' } end
    if d.kind == 'camera' then
        local cam = ANPR_Cams[tostring(d.id)]
        if not cam or not cam.dbId then return { error = 'Cameras from config.lua are removed in the config file.' } end
        MySQL.update.await('DELETE FROM vw_mdt_anpr_cameras WHERE id = ?', { cam.dbId })
    elseif d.kind == 'cameraToggle' then
        local cam = ANPR_Cams[tostring(d.id)]
        if not cam or not cam.dbId then return { error = 'Cameras from config.lua are switched off in the config file.' } end
        MySQL.update.await('UPDATE vw_mdt_anpr_cameras SET active = ? WHERE id = ?', { cam.active and 0 or 1, cam.dbId })
    else
        MySQL.update.await('DELETE FROM vw_mdt_anpr_fitted WHERE id = ?', { tonumber(d.id) })
    end
    ANPR_LoadSetup()
    return { ok = true }
end

---------------------------------------------------------------------------
-- Evidence storage (ox_inventory, qb-inventory, qs-inventory, ps/lj-inventory; see server/inventory.lua)
---------------------------------------------------------------------------
local function evOn() return Config.Evidence and Config.Evidence.enabled ~= false and Inv.Pick() ~= nil end

local function policeGroups()
    local g = {}
    for name, grade in pairs(Config.Jobs) do g[name] = grade end
    return g
end

local function inv() return (Inv.Pick()) end

-- Each exhibit's bag is a stash in the server's inventory.
local function bagId(e) return e.stash_id or ('mdt_evidence_' .. e.id) end
local function bagLabel(e) return ('Exhibit %s'):format(e.exhibit_ref or e.id) end
local function registerBag(e)
    local id = bagId(e)
    local open = inv():prepare(id, bagLabel(e), Config.Evidence.Slots or 30, Config.Evidence.MaxWeight or 100000, policeGroups())
    return id, open
end

function Evidence_BagItems(e)
    if not evOn() then return nil end
    local id = registerBag(e)
    local ok, items = pcall(function() return inv():bagItems(id) end)
    local out = {}
    for _, it in ipairs(ok and items or {}) do
        out[#out + 1] = { name = it.name, label = it.label, count = it.count,
            serial = type(it.metadata) == 'table' and (it.metadata.serial or it.metadata.serie) or nil }
    end
    return out
end

local function near(a, b, dist)
    local pa, pb = GetPlayerPed(a), GetPlayerPed(b)
    return pa ~= 0 and pb ~= 0 and #(GetEntityCoords(pa) - GetEntityCoords(pb)) <= (dist or 4.0)
end

local function addContinuity(e, by, text)
    local log = Bridge.Decode(e.continuity)
    log[#log + 1] = { at = now(), by = by, text = text }
    return json.encode(log)
end

local function noInv() return { error = 'Evidence storage needs a supported inventory (ox, qb, qs, ps or lj).' } end

-- What the suspect is carrying, for the seize picker. They must be in the city and next to the officer.
H.evidenceInventory = function(src, _, d)
    if not evOn() then return noInv() end
    local target = Bridge.GetSource(trim(d.cid, 64))
    if not target then return { error = 'They must be in the city to seize items from them.' } end
    if not near(src, target, Config.Evidence.SeizeDistance) then return { error = 'Stand next to them to seize items.' } end
    local out = {}
    for _, it in ipairs(inv():playerItems(target) or {}) do
        out[#out + 1] = { slot = it.slot, name = it.name, label = it.label, count = it.count,
            serial = type(it.metadata) == 'table' and (it.metadata.serial or it.metadata.serie) or nil }
    end
    table.sort(out, function(a, b) return (a.slot or 0) < (b.slot or 0) end)
    return { items = out }
end

-- Take items off the suspect and put them in a new exhibit's evidence bag.
H.seizeItems = function(src, job, d)
    if not evOn() then return noInv() end
    local I = inv()
    local incidentId = tonumber(d.incidentId)
    if not incidentId or not MySQL.scalar.await('SELECT id FROM vw_mdt_incidents WHERE id = ?', { incidentId }) then return { error = 'Incident not found.' } end
    local cid = trim(d.cid, 64)
    local person = cid and Bridge.GetPerson(cid)
    local target = cid and Bridge.GetSource(cid)
    if not person or not target then return { error = 'They must be in the city to seize items from them.' } end
    if not near(src, target, Config.Evidence.SeizeDistance) then return { error = 'Stand next to them to seize items.' } end
    if type(d.items) ~= 'table' or #d.items == 0 then return { error = 'Tick the items to seize.' } end

    -- Check every item is still where the picker saw it before moving anything.
    local picks = {}
    for _, p in ipairs(d.items) do
        local slot, count = tonumber(p.slot), math.floor(tonumber(p.count) or 0)
        local it = slot and I:playerSlot(target, slot)
        if not it or count < 1 or count > (it.count or 0) then return { error = 'Their inventory changed. Search their pockets again.' } end
        picks[#picks + 1] = { count = count, item = it }
    end

    local labels = {}
    for _, p in ipairs(picks) do labels[#labels + 1] = ('%dx %s'):format(p.count, p.item.label) end
    local desc = trim(d.description, 255) or table.concat(labels, ', '):sub(1, 255)
    local add = H.addEvidence(src, job, { incidentId = incidentId, type = d.type, description = desc, seizedFrom = cid,
        foundAt = d.foundAt, status = Config.EvidenceStatuses[1] })
    if not add.ok then return add end
    local e = MySQL.single.await('SELECT * FROM vw_mdt_evidence WHERE incident_id = ? AND exhibit_ref = ? ORDER BY id DESC LIMIT 1', { incidentId, add.ref })
    local stash = registerBag(e)

    local moved = {}
    for _, p in ipairs(picks) do
        if I:take(target, p.item, p.count) then
            if I:bagAdd(stash, p.item, p.count) then
                moved[#moved + 1] = ('%dx %s'):format(p.count, p.item.label)
            else
                I:give(target, p.item, p.count)   -- bag full: give it back
            end
        end
    end
    if #moved == 0 then
        MySQL.update.await('DELETE FROM vw_mdt_evidence WHERE id = ?', { e.id })
        return { error = 'Nothing could be moved into the evidence bag (it may be full).' }
    end
    MySQL.update.await('UPDATE vw_mdt_evidence SET stash_id = ?, suspect_cid = ?, suspect_name = ?, continuity = ? WHERE id = ?',
        { stash, cid, fullName(person), addContinuity(e, officerLabel(src, job), 'Bagged: ' .. table.concat(moved, ', ')), e.id })
    Bridge.Notify(target, ('Police seized: %s (exhibit %s).'):format(table.concat(moved, ', '), add.ref), 'inform')
    return { ok = true, ref = add.ref, moved = moved }
end

-- Open an exhibit's bag. Returns how the client should open it; some inventories open from the server.
local bagTickets = {}
H.evidenceOpen = function(src, job, d)
    if not evOn() then return noInv() end
    local e = MySQL.single.await('SELECT * FROM vw_mdt_evidence WHERE id = ?', { tonumber(d.id) })
    if not e then return { error = 'Exhibit not found.' } end
    if e.status == 'Destroyed' then return { error = 'This exhibit has been destroyed.' } end
    if Config.Evidence.RequireStore then
        local me, ok = GetEntityCoords(GetPlayerPed(src)), false
        for _, st in ipairs(Config.Evidence.Stores or {}) do
            if #(me - st.coords) <= (st.radius or 3.0) then ok = true end
        end
        if not ok then return { error = 'Evidence bags can only be opened at a property store.' } end
    end
    local stash, open = registerBag(e)
    if not e.stash_id then MySQL.update.await('UPDATE vw_mdt_evidence SET stash_id = ? WHERE id = ?', { stash, e.id }) end
    MySQL.update.await('UPDATE vw_mdt_evidence SET continuity = ? WHERE id = ?', { addContinuity(e, officerLabel(src, job), 'Bag opened'), e.id })
    if open.kind == 'server' then bagTickets[src] = { id = stash, label = bagLabel(e), at = GetGameTimer() } end
    return { ok = true, stash = stash, open = open }
end

-- For inventories that open from the server (qb-inventory 2.x): the client asks once the MDT has closed.
RegisterNetEvent('vinewood-mdt:server:openBag', function(id)
    local src = source
    local t = bagTickets[src]
    bagTickets[src] = nil
    if not t or t.id ~= id or GetGameTimer() - t.at > 15000 then return end
    local I = inv()
    if I and I.open then I:open(src, t.id, t.label, Config.Evidence.Slots or 30, Config.Evidence.MaxWeight or 100000) end
end)

-- Give everything in the bag back to the person it was seized from.
H.evidenceReturn = function(src, job, d)
    if not evOn() then return noInv() end
    local I = inv()
    local e = MySQL.single.await('SELECT * FROM vw_mdt_evidence WHERE id = ?', { tonumber(d.id) })
    if not e or not e.stash_id then return { error = 'This exhibit has no evidence bag.' } end
    local owner = e.seized_from and Bridge.GetSource(e.seized_from)
    if not owner then return { error = 'The owner must be in the city to get their property back.' } end
    if not near(src, owner, Config.Evidence.ReturnDistance) then return { error = 'Stand next to them to hand it back.' } end
    registerBag(e)
    local given, kept = {}, 0
    for _, it in ipairs(I:bagItems(e.stash_id) or {}) do
        if I:canCarry(owner, it, it.count) and I:bagRemove(e.stash_id, it, it.count) then
            if I:give(owner, it, it.count) then
                given[#given + 1] = ('%dx %s'):format(it.count, it.label)
            else
                I:bagAdd(e.stash_id, it, it.count)   -- couldn't give it: put it back
                kept = kept + 1
            end
        else
            kept = kept + 1
        end
    end
    local text = #given > 0 and ('Returned to owner: ' .. table.concat(given, ', ')) or 'Nothing returned'
    if kept > 0 then text = text .. (' (%d item(s) kept: owner cannot carry them)'):format(kept) end
    MySQL.update.await('UPDATE vw_mdt_evidence SET status = ?, continuity = ? WHERE id = ?',
        { kept == 0 and 'Returned to owner' or e.status, addContinuity(e, officerLabel(src, job), text), e.id })
    return { ok = true, returned = given, kept = kept }
end

H.evidenceDestroy = function(src, job, d)
    if (job.grade or 0) < Config.SupervisorGrade then return { error = 'Destroying evidence needs a supervisor.' } end
    local e = MySQL.single.await('SELECT * FROM vw_mdt_evidence WHERE id = ?', { tonumber(d.id) })
    if not e then return { error = 'Exhibit not found.' } end
    if e.stash_id and evOn() then registerBag(e); inv():bagClear(e.stash_id) end
    MySQL.update.await('UPDATE vw_mdt_evidence SET status = ?, continuity = ? WHERE id = ?',
        { 'Destroyed', addContinuity(e, officerLabel(src, job), 'Destroyed' .. (trim(d.reason, 160) and (': ' .. trim(d.reason, 160)) or '')), e.id })
    return { ok = true }
end

-- Link an exhibit to a suspect (e.g. a knife found on the ground, matched to someone later).
H.evidenceLinkSuspect = function(src, job, d)
    local e = MySQL.single.await('SELECT * FROM vw_mdt_evidence WHERE id = ?', { tonumber(d.id) })
    if not e then return { error = 'Exhibit not found.' } end
    local cid = trim(d.cid, 64)
    if not cid then
        MySQL.update.await('UPDATE vw_mdt_evidence SET suspect_cid = NULL, suspect_name = NULL, continuity = ? WHERE id = ?',
            { addContinuity(e, officerLabel(src, job), 'Unlinked from ' .. (e.suspect_name or 'suspect')), e.id })
        return { ok = true }
    end
    local p = Bridge.GetPerson(cid)
    if not p then return { error = 'No person with that reference.' } end
    MySQL.update.await('UPDATE vw_mdt_evidence SET suspect_cid = ?, suspect_name = ?, continuity = ? WHERE id = ?',
        { cid, fullName(p), addContinuity(e, officerLabel(src, job), 'Linked to suspect ' .. fullName(p)), e.id })
    return { ok = true }
end

-- Exhibits linked to a person, as the suspect or the person they were seized from.
function Evidence_ForPerson(cid)
    local rows = MySQL.query.await([[SELECT e.*, i.ref AS incident_ref FROM vw_mdt_evidence e LEFT JOIN vw_mdt_incidents i ON i.id = e.incident_id
        WHERE e.suspect_cid = ? OR e.seized_from = ? ORDER BY e.created_at DESC LIMIT 60]], { cid, cid }) or {}
    for _, e in ipairs(rows) do
        if e.stash_id then e.bag = Evidence_BagItems(e) end
        e.continuity = Bridge.Decode(e.continuity)
        e.items = nil
        Forensics_Public(e)
    end
    return rows
end

---------------------------------------------------------------------------
-- Forensics: shell casings and blood at scenes, collection, lab tests, DNA database
---------------------------------------------------------------------------
local FC = Config.Forensics or {}
local function fOn() return FC.enabled ~= false end

local function dnaProfile(cid)
    -- Stable, non-reversible looking profile number for a person, e.g. DNA-4F2A91C0
    local h = 2166136261
    for i = 1, #cid do h = ((h ~ cid:byte(i)) * 16777619) % 4294967296 end
    return ('DNA-%08X'):format(h)
end

function Forensics_TakeDNA(cid, by, ref)
    if not cid then return end
    local had = MySQL.scalar.await('SELECT cid FROM vw_mdt_dna WHERE cid = ?', { cid })
    if had then return false end
    MySQL.insert.await('INSERT INTO vw_mdt_dna (cid, taken_by, custody_ref, created_at) VALUES (?, ?, ?, ?)', { cid, by, ref, now() })
    -- Earlier scene samples with no match may match now.
    Forensics_Rematch(cid, 'dna')
    return true
end

local function onDatabase(cid) return cid and MySQL.scalar.await('SELECT cid FROM vw_mdt_dna WHERE cid = ?', { cid }) ~= nil end
local function printsOnFile(cid) return cid and MySQL.scalar.await('SELECT cid FROM vw_mdt_prints WHERE cid = ?', { cid }) ~= nil end

local function printRef(cid)
    local h = 5381
    for i = 1, #cid do h = (h * 33 + cid:byte(i)) % 4294967296 end
    return ('PR-%08X'):format(h)
end

function Forensics_TakePrints(cid, by, ref)
    if not cid or printsOnFile(cid) then return false end
    MySQL.insert.await('INSERT INTO vw_mdt_prints (cid, taken_by, custody_ref, created_at) VALUES (?, ?, ?, ?)', { cid, by, ref, now() })
    Forensics_Rematch(cid, 'print')
    return true
end

-- Strip hidden fields before an exhibit goes to the MDT.
function Forensics_Public(e)
    e.forensic = e.forensic and Bridge.Decode(e.forensic) or nil
    if type(e.forensic) == 'table' then e.forensic.dna = nil; e.forensic.casingDna = nil; e.forensic.print = nil end
    e.lab_result = e.lab_result and Bridge.Decode(e.lab_result) or nil
end

local function exhibitWithForensic(id)
    local e = MySQL.single.await('SELECT * FROM vw_mdt_evidence WHERE id = ?', { id })
    if e then e.forensic = Bridge.Decode(e.forensic) end
    return e
end

-- Add a person to the incident as a suspect (if they aren't linked already) and to the exhibit.
local function linkForensicSuspect(e, cid, why)
    local p = Bridge.GetPerson(cid)
    if not p then return end
    if not MySQL.scalar.await("SELECT id FROM vw_mdt_incident_links WHERE incident_id = ? AND kind = 'person' AND subject_id = ?", { e.incident_id, cid }) then
        MySQL.insert.await("INSERT INTO vw_mdt_incident_links (incident_id, kind, subject_id, label, role) VALUES (?, 'person', ?, ?, 'Suspect')", { e.incident_id, cid, fullName(p) })
    end
    local log = Bridge.Decode(e.continuity)
    log[#log + 1] = { at = now(), by = 'Forensic lab', text = why .. ': ' .. fullName(p) }
    MySQL.update.await('UPDATE vw_mdt_evidence SET suspect_cid = COALESCE(suspect_cid, ?), suspect_name = COALESCE(suspect_name, ?), continuity = ? WHERE id = ?',
        { cid, fullName(p), json.encode(log), e.id })
end

-- Work out what the lab finds.
local function runLab(e)
    local f = type(e.forensic) == 'table' and e.forensic or {}
    local result = { kind = f.kind, at = now() }
    if f.kind == 'print' then
        result.vehicle = f.plate
        result.printRef = f.print and printRef(f.print) or nil
        if f.print and printsOnFile(f.print) then
            local p = Bridge.GetPerson(f.print)
            result.match = { cid = f.print, name = p and fullName(p) or f.print }
            linkForensicSuspect(e, f.print, 'Fingerprint match')
        elseif f.print then
            result.noMatch = true
        end
        return result
    end
    if f.kind == 'blood' or f.casingDna then
        local cid = f.kind == 'blood' and f.dna or f.casingDna
        result.profile = cid and dnaProfile(cid) or nil
        if cid and onDatabase(cid) then
            local p = Bridge.GetPerson(cid)
            result.match = { cid = cid, name = p and fullName(p) or cid }
            linkForensicSuspect(e, cid, f.kind == 'blood' and 'DNA match' or 'DNA on casing matches')
        elseif cid then
            result.noMatch = true
        end
    end
    if f.kind == 'casing' then
        result.weapon, result.serial = f.weapon, f.serial
        -- Same weapon at other scenes, and seized weapons with the same serial.
        if f.serial then
            local others = MySQL.query.await([[SELECT DISTINCT i.ref FROM vw_mdt_traces t JOIN vw_mdt_evidence e ON e.id = t.evidence_id
                JOIN vw_mdt_incidents i ON i.id = e.incident_id WHERE t.serial = ? AND e.incident_id <> ?]], { f.serial, e.incident_id }) or {}
            result.otherScenes = {}
            for _, r in ipairs(others) do result.otherScenes[#result.otherScenes + 1] = r.ref end
            local seized = MySQL.query.await([[SELECT e.exhibit_ref, e.suspect_cid, e.seized_from, i.ref AS incident_ref FROM vw_mdt_evidence e
                LEFT JOIN vw_mdt_incidents i ON i.id = e.incident_id WHERE e.description LIKE ? AND e.id <> ?]], { '%' .. f.serial .. '%', e.id }) or {}
            for _, x in ipairs(MySQL.query.await("SELECT e.exhibit_ref, e.suspect_cid, e.seized_from, e.items FROM vw_mdt_evidence e WHERE e.stash_id IS NOT NULL AND e.id <> ?", { e.id }) or {}) do
                if Evidence_BagItems then
                    for _, it in ipairs(Evidence_BagItems(x) or {}) do
                        if it.serial and tostring(it.serial) == tostring(f.serial) then seized[#seized + 1] = x end
                    end
                end
            end
            result.seizedWeapons = {}
            for _, x in ipairs(seized) do
                result.seizedWeapons[#result.seizedWeapons + 1] = x.exhibit_ref
                local who = x.suspect_cid or x.seized_from
                if who then linkForensicSuspect(e, who, ('Fired from seized weapon %s'):format(x.exhibit_ref)) end
            end
        end
    end
    return result
end

-- Finish any lab tests that are due.
local function completeDue()
    local due = MySQL.query.await("SELECT * FROM vw_mdt_evidence WHERE lab_status = 'at_lab' AND lab_due <= ?", { now() }) or {}
    for _, e in ipairs(due) do
        e.forensic = Bridge.Decode(e.forensic)
        local ok, result = pcall(runLab, e)
        if not ok then print(('[vinewood-mdt] lab test failed: %s'):format(result)); result = { error = true } end
        local fresh = MySQL.single.await('SELECT continuity FROM vw_mdt_evidence WHERE id = ?', { e.id })
        local log = Bridge.Decode(fresh and fresh.continuity)
        local summary = result.match and ((result.kind == 'print' and 'Fingerprint match: ' or 'DNA match: ') .. result.match.name)
            or (result.kind == 'casing' and ('%s casing%s'):format(result.weapon or 'Unknown', result.serial and (', serial ' .. result.serial) or ''))
            or (result.noMatch and (result.kind == 'print' and 'Fingerprints lifted, no match on database' or 'DNA profile obtained, no match on database')) or 'No usable result'
        log[#log + 1] = { at = now(), by = 'Forensic lab', text = 'Results: ' .. summary }
        MySQL.update.await("UPDATE vw_mdt_evidence SET lab_status = 'complete', lab_result = ?, status = ?, continuity = ? WHERE id = ?",
            { json.encode(result), 'In property store', json.encode(log), e.id })
        local sender = e.forensic and e.forensic.sentBy and Bridge.GetSource(e.forensic.sentBy)
        if sender then Bridge.Notify(sender, ('Lab results for %s: %s.'):format(e.exhibit_ref, summary), result.match and 'success' or 'inform') end
        Webhook.Send('custody', ('Forensic results: %s'):format(e.exhibit_ref), summary, {}, result.match and 'green' or 'grey')
    end
end

-- A new DNA sample can match blood tested before the person was on the database.
function Forensics_Rematch(cid, which)
    local rows = MySQL.query.await("SELECT * FROM vw_mdt_evidence WHERE lab_status = 'complete' AND forensic LIKE ?", { '%' .. cid .. '%' }) or {}
    for _, e in ipairs(rows) do
        e.forensic = Bridge.Decode(e.forensic)
        local res = Bridge.Decode(e.lab_result)
        local f = e.forensic or {}
        local hit = (which == 'print') and (f.kind == 'print' and f.print == cid) or (which ~= 'print' and (f.dna == cid or f.casingDna == cid))
        if res.noMatch and hit then
            local p = Bridge.GetPerson(cid)
            res.noMatch, res.match, res.lateMatch = nil, { cid = cid, name = p and fullName(p) or cid }, now()
            MySQL.update.await('UPDATE vw_mdt_evidence SET lab_result = ? WHERE id = ?', { json.encode(res), e.id })
            linkForensicSuspect(e, cid, which == 'print' and 'Fingerprint database hit' or 'DNA database hit')
            local sender = f.sentBy and Bridge.GetSource(f.sentBy)
            if sender then Bridge.Notify(sender, ('%s hit: %s now matches %s.'):format(which == 'print' and 'Fingerprint' or 'DNA', e.exhibit_ref, res.match.name), 'success') end
        end
    end
end

CreateThread(function()
    while true do
        Wait(30000)
        if fOn() then
            pcall(completeDue)
            MySQL.update("DELETE FROM vw_mdt_traces WHERE collected_by IS NULL AND type <> 'print' AND created_at < ?", { now() - (FC.TraceMinutes or 60) * 60 })
            MySQL.update("DELETE FROM vw_mdt_traces WHERE collected_by IS NULL AND type = 'print' AND created_at < ?", { now() - (FC.PrintMinutes or 120) * 60 })
        end
    end
end)

-- Traces left by players -----------------------------------------------------------
local lastShot, lastBlood = {}, {}

local function weaponSerial(src, hash)
    local I = Inv and Inv.Pick and (Inv.Pick())
    if not I then return nil end
    local ok, items = pcall(function() return I:playerItems(src) end)
    for _, it in ipairs(ok and items or {}) do
        local U = function(h) return (tonumber(h) or 0) % 4294967296 end
        if type(it.name) == 'string' and (U(joaat(it.name:upper())) == U(hash) or U(joaat(it.name)) == U(hash)) then
            local m = type(it.metadata) == 'table' and it.metadata or {}
            return m.serial or m.serie or m.serialnumber
        end
    end
end

RegisterNetEvent('vinewood-mdt:server:traceShots', function(hash, label, list, location)
    local src = source
    if not fOn() or type(list) ~= 'table' then return end
    local job = Bridge.GetJob(src)
    if job and (FC.IgnoreJobs or {})[job.name] then return end
    local t = GetGameTimer()
    if lastShot[src] and t - lastShot[src] < 900 then return end
    lastShot[src] = t
    local ped = GetPlayerPed(src)
    local me = GetEntityCoords(ped)
    local cid = Bridge.GetCid(src)
    local serial = weaponSerial(src, tonumber(hash) or 0)
    for i, c in ipairs(list) do
        if i > 6 then break end
        local p = vec3(tonumber(c.x) or 0, tonumber(c.y) or 0, tonumber(c.z) or 0)
        if #(p - me) < 15.0 then
            local withDna = math.random() < (FC.CasingDNAChance or 0.25)
            MySQL.insert('INSERT INTO vw_mdt_traces (type, x, y, z, weapon, serial, dna_cid, location, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                { 'casing', p.x, p.y, p.z, tostring(label or 'Unknown'):sub(1, 48), serial and tostring(serial):sub(1, 48) or nil,
                  withDna and cid or nil, type(location) == 'string' and location:sub(1, 160) or nil, now() })
        end
    end
end)

RegisterNetEvent('vinewood-mdt:server:traceBlood', function(c, location)
    local src = source
    if not fOn() or type(c) ~= 'table' then return end
    local t = GetGameTimer()
    if lastBlood[src] and t - lastBlood[src] < 10000 then return end
    lastBlood[src] = t
    local p = vec3(tonumber(c.x) or 0, tonumber(c.y) or 0, tonumber(c.z) or 0)
    if #(p - GetEntityCoords(GetPlayerPed(src))) > 10.0 then return end
    local cid = Bridge.GetCid(src)
    if not cid then return end
    MySQL.insert('INSERT INTO vw_mdt_traces (type, x, y, z, dna_cid, location, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { 'blood', p.x, p.y, p.z, cid, type(location) == 'string' and location:sub(1, 160) or nil, now() })
end)

-- Fingerprints: the client says it got into a vehicle with bare hands.
local lastPrint = {}
RegisterNetEvent('vinewood-mdt:server:tracePrint', function(plate, netId)
    local src = source
    if not fOn() or not FC.Fingerprints or type(plate) ~= 'string' then return end
    local key = ANPR_Key(plate)
    if #key < 2 then return end
    local cid = Bridge.GetCid(src)
    if not cid then return end
    local k = src .. ':' .. key
    if lastPrint[k] and now() - lastPrint[k] < 300 then return end
    lastPrint[k] = now()
    -- They must actually be in or next to that vehicle.
    local veh = netId and NetworkGetEntityFromNetworkId(netId) or 0
    local ped = GetPlayerPed(src)
    if veh == 0 or not DoesEntityExist(veh) or #(GetEntityCoords(veh) - GetEntityCoords(ped)) > 6.0 then return end
    local c = GetEntityCoords(veh)
    -- One print per person per vehicle: refresh it rather than piling them up.
    MySQL.update.await("DELETE FROM vw_mdt_traces WHERE type = 'print' AND serial = ? AND dna_cid = ? AND collected_by IS NULL", { key, cid })
    MySQL.insert('INSERT INTO vw_mdt_traces (type, x, y, z, weapon, serial, dna_cid, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        { 'print', c.x, c.y, c.z, plate:gsub('^%s+', ''):gsub('%s+$', ''):sub(1, 48), key, cid, now() })
end)

-- Dust a vehicle: every set of prints on it becomes a sample for this officer.
lib.callback.register('vinewood-mdt:server:dustVehicle', function(src, plate, netId)
    local job = access(src)
    if not fOn() or not FC.Fingerprints or not job or job.role ~= 'police' then return { error = 'Only police can dust for prints.' } end
    local veh = netId and NetworkGetEntityFromNetworkId(netId) or 0
    if veh == 0 or not DoesEntityExist(veh) or #(GetEntityCoords(veh) - GetEntityCoords(GetPlayerPed(src))) > 5.0 then
        return { error = 'Get next to the vehicle.' }
    end
    local key = ANPR_Key(plate)
    local rows = MySQL.query.await("SELECT id FROM vw_mdt_traces WHERE type = 'print' AND serial = ? AND collected_by IS NULL AND created_at > ? ORDER BY created_at DESC LIMIT 4",
        { key, now() - (FC.PrintMinutes or 120) * 60 }) or {}
    for _, r in ipairs(rows) do
        MySQL.update.await('UPDATE vw_mdt_traces SET collected_by = ?, collected_name = ?, collected_at = ?, location = ? WHERE id = ?',
            { Bridge.GetCid(src), officerLabel(src, job), now(), ('Vehicle %s'):format(plate), r.id })
    end
    return { ok = true, count = #rows }
end)

AddEventHandler('playerDropped', function() lastShot[source] = nil; lastBlood[source] = nil end)

-- Officers: see and collect traces --------------------------------------------------
lib.callback.register('vinewood-mdt:server:tracesNear', function(src)
    local job = access(src)
    if not fOn() or not job or job.role ~= 'police' then return {} end
    local me = GetEntityCoords(GetPlayerPed(src))
    local r = FC.ViewDistance or 30.0
    local rows = MySQL.query.await([[SELECT id, type, x, y, z, weapon FROM vw_mdt_traces WHERE collected_by IS NULL AND type <> 'print' AND created_at > ?
        AND x BETWEEN ? AND ? AND y BETWEEN ? AND ? LIMIT 80]], { now() - (FC.TraceMinutes or 60) * 60, me.x - r, me.x + r, me.y - r, me.y + r }) or {}
    return rows
end)

lib.callback.register('vinewood-mdt:server:collectTrace', function(src, id)
    local job = access(src)
    if not fOn() or not job or job.role ~= 'police' then return { error = 'Only police can collect evidence.' } end
    local tr = MySQL.single.await('SELECT * FROM vw_mdt_traces WHERE id = ? AND collected_by IS NULL', { tonumber(id) })
    if not tr then return { error = 'Someone already collected that.' } end
    if #(vec3(tr.x, tr.y, tr.z) - GetEntityCoords(GetPlayerPed(src))) > 3.0 then return { error = 'Get closer.' } end
    MySQL.update.await('UPDATE vw_mdt_traces SET collected_by = ?, collected_name = ?, collected_at = ? WHERE id = ?',
        { Bridge.GetCid(src), officerLabel(src, job), now(), tr.id })
    return { ok = true, type = tr.type }
end)

lib.callback.register('vinewood-mdt:server:forensicsAllowed', function(src)
    local job = access(src)
    return fOn() and job ~= nil and job.role == 'police'
end)

-- MDT ---------------------------------------------------------------------------------
-- Samples this officer has collected and not yet bagged on an incident.
H.mySamples = function(src)
    local rows = MySQL.query.await('SELECT id, type, weapon, location, collected_at FROM vw_mdt_traces WHERE collected_by = ? AND evidence_id IS NULL ORDER BY collected_at DESC', { Bridge.GetCid(src) }) or {}
    return { results = rows }
end

-- Bag collected samples on an incident: one exhibit per sample.
H.bagSamples = function(src, job, d)
    local incidentId = tonumber(d.incidentId)
    if not incidentId then return { error = 'Incident not found.' } end
    local refs = {}
    for _, id in ipairs(type(d.ids) == 'table' and d.ids or {}) do
        local tr = MySQL.single.await('SELECT * FROM vw_mdt_traces WHERE id = ? AND collected_by = ? AND evidence_id IS NULL', { tonumber(id), Bridge.GetCid(src) })
        if tr then
            local desc = tr.type == 'casing' and ('Shell casing (%s)'):format(tr.weapon or 'unknown weapon')
                or tr.type == 'print' and ('Fingerprint lift from vehicle %s'):format(tr.weapon or '')
                or 'Blood swab'
            local add = H.addEvidence(src, job, { incidentId = incidentId, type = 'Forensic sample', description = desc,
                foundAt = tr.location, status = Config.EvidenceStatuses[1] })
            if add.ok then
                local e = MySQL.single.await('SELECT id FROM vw_mdt_evidence WHERE incident_id = ? AND exhibit_ref = ? ORDER BY id DESC LIMIT 1', { incidentId, add.ref })
                local forensic = { kind = tr.type, weapon = tr.type ~= 'print' and tr.weapon or nil, serial = tr.type == 'casing' and tr.serial or nil,
                    plate = tr.type == 'print' and tr.weapon or nil, collectedBy = tr.collected_name, collectedAt = tr.collected_at,
                    dna = tr.type == 'blood' and tr.dna_cid or nil, casingDna = tr.type == 'casing' and tr.dna_cid or nil,
                    print = tr.type == 'print' and tr.dna_cid or nil }
                MySQL.update.await("UPDATE vw_mdt_evidence SET forensic = ?, lab_status = 'not_sent' WHERE id = ?", { json.encode(forensic), e.id })
                MySQL.update.await('UPDATE vw_mdt_traces SET evidence_id = ? WHERE id = ?', { e.id, tr.id })
                refs[#refs + 1] = add.ref
            end
        end
    end
    if #refs == 0 then return { error = 'Choose samples you collected.' } end
    return { ok = true, refs = refs }
end

H.sendToLab = function(src, job, d)
    local e = exhibitWithForensic(tonumber(d.id))
    if not e or type(e.forensic) ~= 'table' then return { error = 'Only forensic samples can go to the lab.' } end
    if e.lab_status == 'at_lab' then return { error = 'It is already at the lab.' } end
    if e.lab_status == 'complete' then return { error = 'Results are already back.' } end
    e.forensic.sentBy = Bridge.GetCid(src)
    local log = Bridge.Decode(e.continuity)
    log[#log + 1] = { at = now(), by = officerLabel(src, job), text = 'Sent to the forensic lab' }
    MySQL.update.await("UPDATE vw_mdt_evidence SET forensic = ?, lab_status = 'at_lab', lab_due = ?, status = 'Sent for forensics', continuity = ? WHERE id = ?",
        { json.encode(e.forensic), now() + (FC.LabMinutes or 10) * 60, json.encode(log), e.id })
    return { ok = true, minutes = FC.LabMinutes or 10 }
end

H.takePrints = function(src, job, d)
    local cid = trim(d.cid, 64)
    if not cid or not Bridge.GetPerson(cid) then return { error = 'Person not found.' } end
    local added = Forensics_TakePrints(cid, officerLabel(src, job), trim(d.ref, 32))
    return { ok = true, already = added == false }
end

H.takeDNA = function(src, job, d)
    local cid = trim(d.cid, 64)
    if not cid or not Bridge.GetPerson(cid) then return { error = 'Person not found.' } end
    local added = Forensics_TakeDNA(cid, officerLabel(src, job), trim(d.ref, 32))
    return { ok = true, already = added == false }
end

---------------------------------------------------------------------------
-- Defence solicitors
---------------------------------------------------------------------------
DEFENCE_ACTIONS = { init = true, defenceCases = true, defenceCase = true, getInterview = true, defenceNoteSave = true, defenceNoteDelete = true }
POLICE_ONLY = { dispatchNote = true, requestInjury = true, solicitorSearch = true, solicitorList = true, assignSolicitor = true, updateDisclosure = true, removeSolicitor = true }

local CLOSED_OUTCOMES = { ['Charged'] = true, ['No further action'] = true }

-- Online players who hold a defence job, for the custody officer's picker.
H.solicitorList = function()
    local out = {}
    for _, id in ipairs(GetPlayers()) do
        local s = tonumber(id)
        local j = access(s)
        if j and j.role == 'defence' then
            out[#out + 1] = { cid = Bridge.GetCid(s), name = Bridge.GetName(s), firm = j.label }
        end
    end
    table.sort(out, function(a, b) return a.name < b.name end)
    return { solicitors = out }
end

-- Solicitors by name, in the city or not. Only people holding a defence job are returned.
H.solicitorSearch = function(_, _, d)
    local q = trim(d.q, 64)
    if not q or #q < 2 then return { results = {} } end
    local out = {}
    for _, p in ipairs(Bridge.SearchPeople(q, 40)) do
        local j = Bridge.GetJobOffline(p.cid)
        local min = j and (Config.Defence.jobs or {})[j.name]
        if min and (j.grade or 0) >= min then
            out[#out + 1] = { cid = p.cid, name = fullName(p), job = j.name, online = Bridge.GetSource(p.cid) ~= nil }
        end
        if #out >= 10 then break end
    end
    return { results = out }
end

H.assignSolicitor = function(src, job, d)
    if not (Config.Defence and Config.Defence.enabled) then return { error = 'Defence access is switched off.' } end
    local rec = MySQL.single.await('SELECT id, cid, ref, subject_name FROM vw_mdt_records WHERE id = ?', { tonumber(d.recordId) })
    if not rec then return { error = 'Custody record not found.' } end
    local solCid = trim(d.solicitorCid, 64)
    if not solCid then return { error = 'Choose a solicitor.' } end
    local solSrc = Bridge.GetSource(solCid)
    local solName
    if solSrc then
        local j = access(solSrc)
        if not j or j.role ~= 'defence' then return { error = 'That person is not a solicitor.' } end
        solName = Bridge.GetName(solSrc)
    else
        local p = Bridge.GetPerson(solCid)
        if not p then return { error = 'No one found with that reference.' } end
        local j = Bridge.GetJobOffline(solCid)
        local min = j and (Config.Defence.jobs or {})[j.name]
        if not min or (j.grade or 0) < min then return { error = ('%s is not a solicitor.'):format(fullName(p)) } end
        solName = fullName(p)
    end
    if solCid == rec.cid then return { error = 'A suspect cannot be their own solicitor.' } end

    local t = now()
    -- One solicitor per case: a new assignment replaces the old one.
    MySQL.update.await('UPDATE vw_mdt_defence SET active = 0, updated_at = ? WHERE record_id = ? AND active = 1', { t, rec.id })
    MySQL.insert.await([[INSERT INTO vw_mdt_defence (record_id, cid, solicitor_cid, solicitor_name, disclosure, assigned_by, active, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?)]], { rec.id, rec.cid, solCid, solName, trim(d.disclosure, 4000), officerLabel(src, job), t, t })

    if solSrc then
        Bridge.Notify(solSrc, ('You have been assigned to %s (%s). Their disclosure is on your MDT.'):format(rec.subject_name or 'a client', rec.ref or ''), 'inform')
    end
    return { ok = true }
end

H.updateDisclosure = function(src, job, d)
    local a = MySQL.single.await('SELECT * FROM vw_mdt_defence WHERE id = ? AND active = 1', { tonumber(d.id) })
    if not a then return { error = 'Assignment not found.' } end
    MySQL.update.await('UPDATE vw_mdt_defence SET disclosure = ?, updated_at = ? WHERE id = ?', { trim(d.disclosure, 4000), now(), a.id })
    local solSrc = Bridge.GetSource(a.solicitor_cid)
    if solSrc then Bridge.Notify(solSrc, 'Disclosure for one of your clients has been updated.') end
    return { ok = true }
end

H.removeSolicitor = function(_, _, d)
    MySQL.update.await('UPDATE vw_mdt_defence SET active = 0, updated_at = ? WHERE id = ?', { now(), tonumber(d.id) })
    return { ok = true }
end

-- Every assignment the request is checked against. Expired ones are closed on read.
local function myAssignments(src)
    local solCid = Bridge.GetCid(src)
    if not solCid then return {} end
    local rows = MySQL.query.await([[SELECT a.*, r.ref, r.subject_name, r.outcome, r.offences, r.narrative, r.created_at AS arrested_at
        FROM vw_mdt_defence a JOIN vw_mdt_records r ON r.id = a.record_id
        WHERE a.solicitor_cid = ? AND a.active = 1 ORDER BY a.created_at DESC]], { solCid }) or {}
    local keep = {}
    local expiry = (Config.Defence.ExpireDaysAfterClose or 0) * 86400
    for _, a in ipairs(rows) do
        if expiry > 0 and CLOSED_OUTCOMES[a.outcome] and a.updated_at + expiry < now() then
            MySQL.update.await('UPDATE vw_mdt_defence SET active = 0 WHERE id = ?', { a.id })
        else
            keep[#keep + 1] = a
        end
    end
    return keep
end

H.defenceCases = function(src)
    local out = {}
    for _, a in ipairs(myAssignments(src)) do
        out[#out + 1] = {
            id = a.id, name = a.subject_name, ref = a.ref, outcome = a.outcome,
            assignedBy = a.assigned_by, at = a.created_at, arrestedAt = a.arrested_at,
        }
    end
    return { cases = out }
end

H.defenceCase = function(src, _, d)
    local a
    for _, x in ipairs(myAssignments(src)) do
        if x.id == tonumber(d.id) then a = x end
    end
    -- Not theirs, or no longer active: say nothing about whether it exists.
    if not a then return { error = 'You are not assigned to that case.' } end
    local cfg = Config.Defence
    local p = Bridge.GetPerson(a.cid) or {}

    local pack = {
        id = a.id,
        ref = a.ref,
        client = { name = fullName(p), dob = p.dob, cid = a.cid, online = Bridge.GetSource(a.cid) ~= nil },
        outcome = a.outcome,
        arrestedAt = a.arrested_at,
        assignedBy = a.assigned_by,
        disclosure = a.disclosure,
        updatedAt = a.updated_at,
        offences = cfg.ShowOffences and Bridge.Decode(a.offences) or nil,
        narrative = cfg.ShowNarrative and a.narrative or nil,
    }

    if cfg.ShowBail then
        local b = MySQL.single.await("SELECT * FROM vw_mdt_bail WHERE record_id = ? AND status = 'active' LIMIT 1", { a.record_id })
        pack.bail = b and decodeBail(b) or nil
    end
    if cfg.ShowCpsDecision then
        local c = MySQL.single.await("SELECT status, charges, decided_at FROM vw_mdt_cps WHERE record_id = ? AND status IN ('charge','nfa') ORDER BY decided_at DESC LIMIT 1", { a.record_id })
        if c then pack.cps = { status = c.status, charges = Bridge.Decode(c.charges), decidedAt = c.decided_at } end
    end
    if cfg.ShowInterviews and Interviews.Available() and a.ref then
        pack.interviews = Interviews.ForCase(a.ref)
    end

    -- The client's own history: earlier custody records and how they ended, bail and fines.
    -- Never warning markers, intelligence or anyone else's details.
    if cfg.ShowHistory then
        local charged = {}
        for _, r in ipairs(MySQL.query.await("SELECT record_id FROM vw_mdt_cps WHERE cid = ? AND status = 'charge'", { a.cid }) or {}) do charged[r.record_id] = true end
        local history, convictions, cautions = {}, 0, 0
        for _, r in ipairs(MySQL.query.await('SELECT id, ref, offences, outcome, created_at FROM vw_mdt_records WHERE cid = ? AND id <> ? ORDER BY created_at DESC LIMIT 40', { a.cid, a.record_id }) or {}) do
            local outcome = charged[r.id] and 'Charged' or r.outcome
            if outcome == 'Charged' then convictions = convictions + 1 end
            if outcome == 'Simple caution' or outcome == 'Community resolution' then cautions = cautions + 1 end
            history[#history + 1] = { ref = r.ref, at = r.created_at, offences = Bridge.Decode(r.offences), outcome = outcome }
        end
        local bails = {}
        for _, b in ipairs(MySQL.query.await('SELECT bail_type, status, created_at, return_at, custody_ref FROM vw_mdt_bail WHERE cid = ? ORDER BY created_at DESC LIMIT 20', { a.cid }) or {}) do
            bails[#bails + 1] = { type = b.bail_type, status = b.status, at = b.created_at, returnAt = b.return_at, ref = b.custody_ref }
        end
        local fines = {}
        if Config.Fines and Config.Fines.enabled then
            for _, f in ipairs(MySQL.query.await("SELECT ref, type, offences, amount, status, created_at FROM vw_mdt_fines WHERE cid = ? AND status <> 'cancelled' ORDER BY created_at DESC LIMIT 20", { a.cid }) or {}) do
                fines[#fines + 1] = { ref = f.ref, type = f.type, offences = Bridge.Decode(f.offences), amount = f.amount, status = f.status, at = f.created_at }
            end
        end
        -- With vinewood-moj, count convictions from sentences passed, and show them.
        local court = MoJ.Running() and MoJ.Person(a.cid)
        local sentences
        if court and type(court.sentences) == 'table' then
            convictions = #court.sentences
            sentences = {}
            for _, x in ipairs(court.sentences) do sentences[#sentences + 1] = { at = x.created_at, summary = x.summary } end
        end
        pack.history = { records = history, convictions = convictions, cautions = cautions, bail = bails, fines = fines, sentences = sentences }
    end

    -- Private notes: only this solicitor, about this client.
    if cfg.Notes then
        pack.notes = MySQL.query.await('SELECT id, body, case_ref, created_at, updated_at FROM vw_mdt_defence_notes WHERE solicitor_cid = ? AND client_cid = ? ORDER BY created_at DESC',
            { a.solicitor_cid, a.cid }) or {}
    end
    return { case = pack }
end

-- Solicitor's private notes. Checked against their own active assignment every time.
H.defenceNoteSave = function(src, _, d)
    if not Config.Defence.Notes then return { error = 'Notes are switched off.' } end
    local a
    for _, x in ipairs(myAssignments(src)) do if x.id == tonumber(d.caseId) then a = x end end
    if not a then return { error = 'You are not assigned to that case.' } end
    local body = trim(d.body, 4000)
    if not body then return { error = 'Write the note first.' } end
    local t = now()
    if d.noteId then
        local n = MySQL.update.await('UPDATE vw_mdt_defence_notes SET body = ?, updated_at = ? WHERE id = ? AND solicitor_cid = ? AND client_cid = ?',
            { body, t, tonumber(d.noteId), a.solicitor_cid, a.cid })
        if (n or 0) == 0 then return { error = 'Note not found.' } end
    else
        MySQL.insert.await('INSERT INTO vw_mdt_defence_notes (solicitor_cid, client_cid, record_id, case_ref, body, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
            { a.solicitor_cid, a.cid, a.record_id, a.ref, body, t, t })
    end
    return { ok = true }
end

H.defenceNoteDelete = function(src, _, d)
    local cid = Bridge.GetCid(src)
    MySQL.update.await('DELETE FROM vw_mdt_defence_notes WHERE id = ? AND solicitor_cid = ?', { tonumber(d.noteId), cid })
    return { ok = true }
end

-- Solicitors can only play recordings whose case reference matches one of their active cases.
H.defenceInterview = function(src, _, d)
    if not (Config.Defence.ShowInterviews and Interviews.Available()) then return { error = 'Interview recordings are not available.' } end
    local s = Interviews.Get(tonumber(d.id))
    if not s then return { error = 'Interview not found.' } end
    for _, a in ipairs(myAssignments(src)) do
        if a.ref and s.caseRef == a.ref then return { interview = s } end
    end
    return { error = 'You are not assigned to that case.' }
end

---------------------------------------------------------------------------
-- No further action
---------------------------------------------------------------------------
-- Closes the case for this person: marks the custody record NFA, ends any active bail,
-- withdraws a pending CPS file, and tells the person if they are in the city.
H.nfa = function(src, job, d)
    local remandedBefore = false
    local cid = trim(d.cid, 64)
    local recordId = tonumber(d.recordId)
    local reason = trim(d.reason, 160)
    if not reason then return { error = 'Choose a reason for no further action.' } end

    if recordId then
        local row = MySQL.single.await('SELECT cid FROM vw_mdt_records WHERE id = ?', { recordId })
        if not row then return { error = 'Custody record not found.' } end
        cid = row.cid
        local pending = MySQL.single.await("SELECT id, status FROM vw_mdt_cps WHERE record_id = ? AND status IN ('pending','more_evidence') LIMIT 1", { recordId })
        if pending and job.role == 'police' and not Config.CPS.PoliceCanWithdraw then
            return { error = 'This case is with the CPS. Only they can decide on no further action.' }
        end
        if pending then
            local c = DecodeCase(MySQL.single.await('SELECT * FROM vw_mdt_cps WHERE id = ?', { pending.id }))
            c.log[#c.log + 1] = { at = now(), by = officerLabel(src, job), text = 'Withdrawn by police: ' .. reason }
            MySQL.update.await("UPDATE vw_mdt_cps SET status = 'withdrawn', log = ?, updated_at = ? WHERE id = ?", { json.encode(c.log), now(), pending.id })
        end
        remandedBefore = MySQL.scalar.await('SELECT outcome FROM vw_mdt_records WHERE id = ?', { recordId }) == 'Remanded in custody'
        MySQL.update.await('UPDATE vw_mdt_defence SET updated_at = ? WHERE record_id = ? AND active = 1', { now(), recordId })
        MySQL.update.await("UPDATE vw_mdt_records SET outcome = 'No further action', narrative = CONCAT(COALESCE(narrative, ''), ?) WHERE id = ?",
            { ('\n\nNFA (%s): %s'):format(officerLabel(src, job), reason), recordId })
        TriggerEvent('vinewood-mdt:server:custodyOutcome', recordId, MySQL.scalar.await('SELECT ref FROM vw_mdt_records WHERE id = ?', { recordId }),
            cid, 'No further action', src)
    end
    if not cid then return { error = 'Select a person first.' } end

    -- End bail tied to this record, or any active bail if no record was given.
    local bails = recordId
        and MySQL.query.await("SELECT id FROM vw_mdt_bail WHERE status = 'active' AND cid = ? AND (record_id = ? OR record_id IS NULL)", { cid, recordId })
        or MySQL.query.await("SELECT id FROM vw_mdt_bail WHERE status = 'active' AND cid = ?", { cid })
    for _, b in ipairs(bails or {}) do
        MySQL.update.await("UPDATE vw_mdt_bail SET status = 'nfa', closed_by = ?, notes = CONCAT(COALESCE(notes, ''), ?), updated_at = ? WHERE id = ?",
            { officerLabel(src, job), ('\nNFA: %s'):format(reason), now(), b.id })
    end

    local target = Bridge.GetSource(cid)
    if target then
        Bridge.Notify(target, 'You have been notified that no further action will be taken against you. Any bail has been cancelled.', 'success')
    end
    if Config.Prison and Config.Prison.ReleaseOnBail ~= false and remandedBefore then Prison.Release(cid, 'no further action') end
        TriggerEvent('vinewood-mdt:server:noFurtherAction', cid, recordId, reason)
    return { ok = true }
end

---------------------------------------------------------------------------
-- CPS
---------------------------------------------------------------------------
CPS_ACTIONS = { init = true, cpsQueue = true, cpsCase = true, cpsDecide = true, searchInterviews = true, getInterview = true, sentencingContext = true }

function DecodeCase(r)
    return {
        id = r.id, recordId = r.record_id, cid = r.cid, name = r.subject_name, custodyRef = r.custody_ref,
        status = r.status, offences = Bridge.Decode(r.offences), charges = Bridge.Decode(r.charges),
        summary = r.summary, evidence = Bridge.Decode(r.evidence), officer = r.officer_name, officerCid = r.officer_cid,
        lawyer = r.lawyer_name, evidential = r.evidential, publicInterest = r.public_interest,
        reason = r.decision_reason, actionPlan = r.action_plan, log = Bridge.Decode(r.log),
        submittedAt = r.submitted_at, decidedAt = r.decided_at, updatedAt = r.updated_at,
    }
end

local function notifyRole(role, msg)
    for _, id in ipairs(GetPlayers()) do
        local j = access(tonumber(id))
        if j and j.role == role then Bridge.Notify(tonumber(id), msg) end
    end
end

local function cleanEvidence(list)
    local out = {}
    local allowed = {}
    for _, t in ipairs(Config.CPS.EvidenceTypes) do allowed[t] = true end
    for _, e in ipairs(type(list) == 'table' and list or {}) do
        local detail = trim(e.detail, 600)
        if detail and allowed[e.type] then
            out[#out + 1] = { type = e.type, detail = detail, link = trim(e.link, 300) }
        end
        if #out >= 30 then break end
    end
    return out
end

H.submitCps = function(src, job, d)
    if not (Config.CPS and Config.CPS.enabled) then return { error = 'The CPS is not enabled on this server.' } end
    local rec = MySQL.single.await('SELECT * FROM vw_mdt_records WHERE id = ?', { tonumber(d.recordId) })
    if not rec then return { error = 'Custody record not found.' } end
    if MySQL.scalar.await("SELECT id FROM vw_mdt_cps WHERE record_id = ? AND status IN ('pending','more_evidence','charge')", { rec.id }) then
        return { error = 'This case already has an open or charged CPS file.' }
    end
    local summary = trim(d.summary, 4000)
    if not summary or #summary < 40 then return { error = 'Write a case summary of at least a few sentences.' } end
    local evidence = cleanEvidence(d.evidence)
    if #evidence == 0 then return { error = 'List the evidence you are relying on.' } end
    local offences = type(d.offences) == 'table' and #d.offences > 0 and d.offences or Bridge.Decode(rec.offences)

    local officer = officerLabel(src, job)
    local t = now()
    local log = { { at = t, by = officer, text = 'Submitted for a charging decision.' } }
    local id = MySQL.insert.await([[INSERT INTO vw_mdt_cps (record_id, cid, subject_name, custody_ref, status, offences, summary, evidence,
        officer_name, officer_cid, log, submitted_at, updated_at) VALUES (?, ?, ?, ?, 'pending', ?, ?, ?, ?, ?, ?, ?, ?)]],
        { rec.id, rec.cid, rec.subject_name, rec.ref, json.encode(offences), summary, json.encode(evidence),
          officer, Bridge.GetCid(src), json.encode(log), t, t })
    notifyRole('cps', ('New case for a charging decision: %s (%s).'):format(rec.subject_name or 'Unknown', rec.ref or id))
    return { ok = true, id = id }
end

H.cpsResubmit = function(src, job, d)
    local r = MySQL.single.await('SELECT * FROM vw_mdt_cps WHERE id = ?', { tonumber(d.id) })
    if not r then return { error = 'Case not found.' } end
    if r.status ~= 'more_evidence' then return { error = 'The CPS has not asked for more evidence on this case.' } end
    local c = DecodeCase(r)
    local added = cleanEvidence(d.evidence)
    local response = trim(d.response, 2000)
    if #added == 0 and not response then return { error = 'Add evidence or respond to the action plan.' } end
    for _, e in ipairs(added) do c.evidence[#c.evidence + 1] = e end
    c.log[#c.log + 1] = { at = now(), by = officerLabel(src, job), text = 'Resubmitted' .. (response and (': ' .. response) or '.') }
    MySQL.update.await("UPDATE vw_mdt_cps SET status = 'pending', evidence = ?, log = ?, updated_at = ? WHERE id = ?",
        { json.encode(c.evidence), json.encode(c.log), now(), c.id })
    notifyRole('cps', ('Further evidence received: %s (%s).'):format(c.name or 'Unknown', c.custodyRef or c.id))
    return { ok = true }
end

H.cpsQueue = function(_, _, d)
    local filter = ({ pending = { 'pending' }, more_evidence = { 'more_evidence' }, decided = { 'charge', 'nfa', 'withdrawn' } })[d.filter or 'pending'] or { 'pending' }
    local rows = MySQL.query.await(('SELECT * FROM vw_mdt_cps WHERE status IN (%s) ORDER BY %s LIMIT 60')
        :format(string.rep('?', #filter, ','), d.filter == 'decided' and 'updated_at DESC' or 'submitted_at ASC'), filter) or {}
    local counts = {}
    for _, r in ipairs(MySQL.query.await('SELECT status, COUNT(*) AS n FROM vw_mdt_cps GROUP BY status') or {}) do counts[r.status] = r.n end
    local out = {}
    for _, r in ipairs(rows) do out[#out + 1] = DecodeCase(r) end
    return { cases = out, counts = counts }
end

H.cpsCase = function(_, job, d)
    local r = MySQL.single.await('SELECT * FROM vw_mdt_cps WHERE id = ?', { tonumber(d.id) })
    if not r then return { error = 'Case not found.' } end
    local c = DecodeCase(r)
    local rec = MySQL.single.await('SELECT * FROM vw_mdt_records WHERE id = ?', { c.recordId })
    if rec then rec.offences = Bridge.Decode(rec.offences) end

    -- Antecedents: other custody records with a charge or caution.
    local prior = MySQL.query.await([[SELECT ref, offences, outcome, created_at FROM vw_mdt_records
        WHERE cid = ? AND id <> ? ORDER BY created_at DESC LIMIT 20]], { c.cid, c.recordId }) or {}
    for _, p in ipairs(prior) do p.offences = Bridge.Decode(p.offences) end

    local bail = MySQL.single.await("SELECT * FROM vw_mdt_bail WHERE cid = ? AND status = 'active' LIMIT 1", { c.cid })

    local interviews
    if Interviews.Available() and Interviews.CanListen(job) then
        interviews = Interviews.ForPerson(c.name or '', { c.custodyRef }, c.cid)
    end
    local statements = {}
    if rec and rec.incident_id then
        statements = MySQL.query.await("SELECT * FROM vw_mdt_statements WHERE incident_id = ? AND status = 'signed' ORDER BY created_at ASC", { rec.incident_id }) or {}
    end
    -- Injury statements from the ambulance service, requested on the incident this arrest came from.
    -- Only ones a clinician has provided go into the file.
    local injury
    if rec and rec.incident_id and EMS.Running() then
        local incRef = MySQL.scalar.await('SELECT ref FROM vw_mdt_incidents WHERE id = ?', { rec.incident_id })
        injury = {}
        for _, q in ipairs(EMS.ForCase(incRef) or {}) do
            if q.status == 'fulfilled' then injury[#injury + 1] = q end
        end
        local pending = 0
        for _, q in ipairs(EMS.ForCase(incRef) or {}) do if q.status == 'pending' then pending = pending + 1 end end
        injury = { list = injury, pending = pending, incidentRef = incRef }
    end
    local exhibits = {}
    if rec and rec.incident_id then
        exhibits = MySQL.query.await("SELECT * FROM vw_mdt_evidence WHERE incident_id = ? AND (suspect_cid = ? OR seized_from = ? OR (suspect_cid IS NULL AND seized_from IS NULL)) ORDER BY id ASC",
            { rec.incident_id, c.cid, c.cid }) or {}
        for _, e in ipairs(exhibits) do
            if e.stash_id then e.bag = Evidence_BagItems(e) end
            e.continuity = Bridge.Decode(e.continuity)
            e.items = nil
            Forensics_Public(e)
        end
    end
    return { case = c, record = rec, prior = prior, bail = bail and decodeBail(bail) or nil, interviews = interviews, statements = statements, injury = injury, exhibits = exhibits }
end

H.cpsDecide = function(src, job, d)
    local r = MySQL.single.await('SELECT * FROM vw_mdt_cps WHERE id = ?', { tonumber(d.id) })
    if not r then return { error = 'Case not found.' } end
    if r.status ~= 'pending' then return { error = 'This case is not awaiting a decision.' } end
    local c = DecodeCase(r)
    local decision = d.decision
    local evidential = d.evidential == 'met' and 'met' or (d.evidential == 'not_met' and 'not_met' or nil)
    local publicInterest = d.publicInterest == 'met' and 'met' or (d.publicInterest == 'not_met' and 'not_met' or nil)
    local reason = trim(d.reason, 2000)
    local lawyer = officerLabel(src, job)
    local t = now()

    if decision == 'charge' then
        if evidential ~= 'met' or publicInterest ~= 'met' then
            return { error = 'Both stages of the Full Code Test must be met to charge.' }
        end
        local charges = type(d.charges) == 'table' and d.charges or {}
        if #charges == 0 then return { error = 'Select the charges.' } end
        if not reason then return { error = 'Record your reasons.' } end
        c.log[#c.log + 1] = { at = t, by = lawyer, text = 'Charge authorised.' }
        MySQL.update.await([[UPDATE vw_mdt_cps SET status = 'charge', charges = ?, lawyer_name = ?, evidential = ?, public_interest = ?,
            decision_reason = ?, log = ?, decided_at = ?, updated_at = ? WHERE id = ?]],
            { json.encode(charges), lawyer, evidential, publicInterest, reason, json.encode(c.log), t, t, c.id })
        MySQL.update.await("UPDATE vw_mdt_records SET outcome = 'Charged' WHERE id = ?", { c.recordId })
        TriggerEvent('vinewood-mdt:server:custodyOutcome', c.recordId, c.custodyRef, c.cid, 'Charged', src)
        MySQL.update.await('UPDATE vw_mdt_defence SET updated_at = ? WHERE record_id = ? AND active = 1', { t, c.recordId })
        local target = Bridge.GetSource(c.cid)
        if target then Bridge.Notify(target, ('The CPS has authorised charges against you (%s). You will be required to attend court.'):format(c.custodyRef or ''), 'error') end

    elseif decision == 'nfa' then
        if not evidential or (evidential == 'met' and not publicInterest) then
            return { error = 'Record the outcome of each stage of the Full Code Test you applied.' }
        end
        if evidential == 'met' and publicInterest == 'met' then
            return { error = 'Both stages are met. Charge, or change your assessment.' }
        end
        if not reason then return { error = 'Record your reasons for no further action.' } end
        c.log[#c.log + 1] = { at = t, by = lawyer, text = 'No further action.' }
        MySQL.update.await([[UPDATE vw_mdt_cps SET status = 'nfa', lawyer_name = ?, evidential = ?, public_interest = ?,
            decision_reason = ?, log = ?, decided_at = ?, updated_at = ? WHERE id = ?]],
            { lawyer, evidential, publicInterest, reason, json.encode(c.log), t, t, c.id })
        local label = evidential == 'not_met' and 'CPS: evidential stage not met' or 'CPS: not in the public interest'
        H.nfa(src, job, { recordId = c.recordId, reason = label })

    elseif decision == 'more_evidence' then
        local plan = trim(d.actionPlan, 2000)
        if not plan then return { error = 'Write an action plan telling the officer what is needed.' } end
        c.log[#c.log + 1] = { at = t, by = lawyer, text = 'Further evidence requested: ' .. plan }
        MySQL.update.await([[UPDATE vw_mdt_cps SET status = 'more_evidence', lawyer_name = ?, action_plan = ?, log = ?, updated_at = ? WHERE id = ?]],
            { lawyer, plan, json.encode(c.log), t, c.id })
    else
        return { error = 'Choose a decision.' }
    end

    local officerSrc = c.officerCid and Bridge.GetSource(c.officerCid)
    if officerSrc then
        local words = { charge = 'charge authorised', nfa = 'no further action', more_evidence = 'further evidence requested' }
        Bridge.Notify(officerSrc, ('CPS decision on %s (%s): %s.'):format(c.name or 'Unknown', c.custodyRef or c.id, words[decision]))
    end
    TriggerEvent('vinewood-mdt:server:cpsDecision', c.id, decision, c)
    return { ok = true }
end

---------------------------------------------------------------------------
-- Entry point
---------------------------------------------------------------------------
lib.callback.register('vinewood-mdt:server:canOpen', function(src)
    return access(src) ~= nil
end)

--- One request from an officer. The tablet's NUI and other server resources (Request export)
--- both come through here, so every permission check, audit entry and webhook runs the same way.
local function handleRequest(src, action, data)
    local job = access(src)
    if not job then return { error = 'You do not have access to the MDT.' } end
    local fn = H[action]
    if not fn then return { error = 'Unknown request.' } end
    if job.role == 'cps' and not CPS_ACTIONS[action] then return { error = 'That is a police function.' } end
    if job.role == 'defence' and not DEFENCE_ACTIONS[action] then return { error = 'You can only view clients assigned to you.' } end
    if job.role ~= 'police' and POLICE_ONLY[action] then return { error = 'That is a police function.' } end
    if job.role == 'police' and action == 'cpsDecide' then return { error = 'Only the CPS can make a charging decision.' } end
    data = type(data) == 'table' and data or {}

    local audit = AUDITED[action]
    if audit and audit.reason and job.role == 'police' and Config.Audit.enabled and Config.Audit.RequireReason and not data.quick then
        if not ValidReason(data._reason) then
            return { error = 'Select a reason for this check.', needReason = true }
        end
    end

    local ok, result = pcall(fn, src, job, data)
    if not ok then
        print(('[vinewood-mdt] %s failed: %s'):format(action, result))
        return { error = 'The request failed. Check the server console.' }
    end
    if audit and not data.quick and type(result) == 'table' and not result.error then
        pcall(Audit, src, job, action, audit, data, result)
    end
    if type(result) == 'table' and not result.error and HOOKS[action] then
        local okHook, err = pcall(HOOKS[action], src, job, data, result)
        if not okHook then print(('[vinewood-mdt] webhook for %s failed: %s'):format(action, err)) end
    end
    return result
end

lib.callback.register('vinewood-mdt:server:request', handleRequest)

if Config.Item then
    CreateThread(function()
        local fw = Bridge.Framework()
        if fw == 'qbx' then
            exports.qbx_core:CreateUseableItem(Config.Item, function(src) TriggerClientEvent('vinewood-mdt:client:open', src) end)
        elseif fw == 'qb' then
            exports['qb-core']:GetCoreObject().Functions.CreateUseableItem(Config.Item, function(src) TriggerClientEvent('vinewood-mdt:client:open', src) end)
        elseif fw == 'esx' then
            exports.es_extended:getSharedObject().RegisterUsableItem(Config.Item, function(src) TriggerClientEvent('vinewood-mdt:client:open', src) end)
        end
    end)
end

---------------------------------------------------------------------------
-- Exports for other resources
---------------------------------------------------------------------------
-- Prison scripts tell the MDT when someone is received or released (vinewood_prison does this).
-- status = 'in_custody' | 'released' ; data = { prisonNo, prison, cell, releaseEstimate (seconds) }
--- Actions other resources may run for an officer through the Request export.
--- Everything else stays tablet-only. Add names here if a resource you trust needs more.
local EXTERNAL_ACTIONS = {
    -- lookups
    searchPeople = true, getPerson = true, searchVehicles = true, getVehicle = true, nearbyPeople = true,
    checkDriver = true, wantedPeople = true, flaggedVehicles = true,
    -- incidents and evidence
    createIncident = true, getIncident = true, searchIncidents = true, linkIncident = true,
    addEvidence = true, seizeItems = true,
    -- custody
    createRecord = true, custodyList = true, setOutcome = true, releaseOnBail = true, nfa = true,
    -- roadside and intelligence
    stopSearchCreate = true, issueFine = true, anprAdd = true, addMarker = true,
}

--- Run an MDT action as the officer `src`, exactly as if they had done it on the tablet.
--- The officer must have MDT access (job, grade, duty). Audited actions need data._reason set to one of
--- Config.Audit.Reasons. Returns the action's result table, or { error = '...' }.
---   exports['vinewood-mdt']:Request(src, 'createRecord', { cid = 'ABC123', offences = {...}, _reason = 'Arrest / custody' })
exports('Request', function(src, action, data)
    src = tonumber(src)
    if not src or not GetPlayerName(src) then return { error = 'Officer is not online.' } end
    if type(action) ~= 'string' or not EXTERNAL_ACTIONS[action] then return { error = 'That action is not available to other resources.' } end
    return handleRequest(src, action, type(data) == 'table' and data or {})
end)

---------------------------------------------------------------------------
-- Vinewood MDT Mobile (vinewood_mdt_mobile): the phone app runs this tablet's own UI,
-- so every action goes through handleRequest with the same permissions, audit and webhooks.
---------------------------------------------------------------------------
-- Actions that need the officer at the tablet in-world (camera, inventory) stay in-game only.
local MOBILE_BLOCKED = { mugshotStart = true, evidenceOpen = true }

-- Ask the officer's game client for something, without hanging if they don't answer.
local function mobileClient(src, name, timeoutMs, ...)
    local p, done = promise.new(), false
    lib.callback(name, src, function(r)
        if not done then done = true; p:resolve(r) end
    end, ...)
    SetTimeout(timeoutMs, function()
        if not done then done = true; p:resolve(nil) end
    end)
    return Citizen.Await(p)
end

--- Role the player gets on the MDT ('police' | 'cps' | 'defence'), or nil.
exports('MobileAccess', function(src)
    src = tonumber(src)
    if not src or not GetPlayerName(src) then return nil end
    local job = access(src)
    return job and job.role or nil
end)

--- Run any tablet action for a player from the phone app. Returns what the tablet would get,
--- including the client-side extras (vehicle model names, street names).
exports('MobileRequest', function(src, action, data)
    src = tonumber(src)
    if not src or not GetPlayerName(src) then return { error = 'You need to be in the city to use the MDT.' } end
    if type(action) ~= 'string' or not H[action] then return { error = 'Unknown request.' } end
    if MOBILE_BLOCKED[action] then return { error = 'That can only be done on the MDT in the city.' } end
    local res = handleRequest(src, action, type(data) == 'table' and data or {})
    if type(res) == 'table' and not res.error then
        res = mobileClient(src, 'vinewood-mdt:client:mobileEnrich', 4000, action, res) or res
    end
    return res
end)

--- Where the player is standing (used by the app when creating incidents).
exports('MobileLocation', function(src)
    return mobileClient(tonumber(src), 'vinewood-mdt:client:mobileLocation', 3000) or {}
end)

--- Set a waypoint in the player's game from the app.
exports('MobileWaypoint', function(src, x, y)
    if tonumber(x) and tonumber(y) then TriggerClientEvent('vinewood-mdt:client:mobileWaypoint', src, tonumber(x), tonumber(y)) end
end)

--- Attach the player to a vinewood-dispatch call from the app.
exports('MobileRespond', function(src, data)
    if type(data) == 'table' and tonumber(data.id) then TriggerClientEvent('vinewood-mdt:client:mobileRespond', src, data) end
end)

--- The lists the MDT's own forms use, so other resources can build matching forms.
exports('GetFormOptions', function()
    return {
        forceName = Config.ForceName, forceShort = Config.ForceShort,
        auditReasons = Config.Audit.Reasons,
        outcomes = Config.Outcomes, offences = Config.Offences,
        stopSearch = { enabled = Config.StopSearch.enabled, powers = Config.StopSearch.Powers,
            objects = Config.StopSearch.Objects, outcomes = Config.StopSearch.Outcomes },
        incidentTypes = Config.IncidentTypes, incidentGrades = Config.IncidentGrades, incidentRoles = Config.IncidentRoles,
        evidenceTypes = Config.EvidenceTypes, markers = Config.Markers,
        bailTypes = Config.BailTypes, bailConditions = Config.BailConditions,
        fines = Config.Fines and { enabled = Config.Fines.enabled, currency = Config.Fines.Currency,
            offences = Config.Fines.Offences } or nil,
    }
end)

exports('SetCustodyStatus', function(identifier, status, data)
    if type(identifier) ~= 'string' then return false end
    data = type(data) == 'table' and data or {}
    local est = tonumber(data.releaseEstimate)
    MySQL.insert([[INSERT INTO vw_mdt_prison_status (cid, status, prison_no, prison, cell, release_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE status = VALUES(status), prison_no = COALESCE(VALUES(prison_no), prison_no), prison = COALESCE(VALUES(prison), prison),
        cell = VALUES(cell), release_at = VALUES(release_at), updated_at = VALUES(updated_at)]],
        { identifier, status == 'in_custody' and 'in_custody' or 'released', data.prisonNo, data.prison, data.cell,
          est and (os.time() + est) or nil, os.time() })
    return true
end)

---------------------------------------------------------------------------
-- Paper documents: the bail notice and stop and search record items can be used to read them again.
-- Works with ox_inventory (through the item's server export, see the README) and with the framework's
-- usable items for qb-inventory / ESX inventories.
---------------------------------------------------------------------------
local function showBail(src, meta)
    local id = type(meta) == 'table' and tonumber(meta.bail) or nil
    local row = id and MySQL.single.await('SELECT * FROM vw_mdt_bail WHERE id = ?', { id })
    if not row then return Bridge.Notify(src, 'This bail notice is no longer valid.', 'error') end
    TriggerClientEvent('vinewood-mdt:client:bailNotice', src, decodeBail(row), Config.ForceName)
end

local function showSearch(src, meta)
    local ref = type(meta) == 'table' and meta.ref or nil
    local r = ref and MySQL.single.await('SELECT * FROM vw_mdt_stopsearch WHERE ref = ?', { ref })
    if not r then return Bridge.Notify(src, 'This record is no longer valid.', 'error') end
    local power = r.power
    for _, p in ipairs((Config.StopSearch and Config.StopSearch.Powers) or {}) do if p.id == r.power then power = p.label end end
    TriggerClientEvent('vinewood-mdt:client:stopSearchNotice', src,
        { ref = r.ref, power = power, object = r.object, outcome = r.outcome, officer = r.officer_name, at = r.created_at, grounds = r.grounds }, Config.ForceName)
end

local DOCS = {}
if Config.BailNoticeItem then DOCS[Config.BailNoticeItem] = showBail end
if Config.StopSearch and Config.StopSearch.ReceiptItem then DOCS[Config.StopSearch.ReceiptItem] = showSearch end

-- ox_inventory: items.lua uses server = { export = 'vinewood-mdt.useDocument' }
exports('useDocument', function(event, item, inventory, slot)
    if event ~= 'usingItem' then return end
    local fn = DOCS[item and item.name]
    if not fn then return end
    local s = exports.ox_inventory:GetSlot(inventory.id, slot)
    fn(inventory.id, s and s.metadata or {})
    return false -- reading it doesn't use it up
end)

CreateThread(function()
    if GetResourceState('ox_inventory') == 'started' then return end -- ox uses the export above
    local fw = Bridge.Framework()
    for name, fn in pairs(DOCS) do
        if fw == 'qbx' then
            exports.qbx_core:CreateUseableItem(name, function(src, item) fn(src, item and (item.metadata or item.info) or {}) end)
        elseif fw == 'qb' then
            exports['qb-core']:GetCoreObject().Functions.CreateUseableItem(name, function(src, item) fn(src, item and item.info or {}) end)
        elseif fw == 'esx' then
            exports.es_extended:getSharedObject().RegisterUsableItem(name, function(src, _, item) fn(src, item and (item.metadata or item.info) or {}) end)
        end
    end
end)

exports('GetActiveBail', function(cid)
    local r = MySQL.single.await("SELECT * FROM vw_mdt_bail WHERE cid = ? AND status = 'active' LIMIT 1", { cid })
    return r and decodeBail(r) or nil
end)

exports('GetMarkers', function(kind, id)
    return (markersFor(kind, { id }))[id] or {}
end)

--- People search for other resources (vinewood-interviews links interviewees with this).
--- Same matching as the MDT's own search: every word against first/last name, or an exact ID/phone.
exports('SearchPeople', function(q, limit)
    limit = math.min(tonumber(limit) or 8, 20)
    local out = {}
    for _, p in ipairs(Bridge.SearchPeople(tostring(q or ''), limit)) do
        out[#out + 1] = { cid = p.cid, name = fullName(p), dob = p.dob, online = Bridge.GetSource(p.cid) ~= nil }
        if #out >= limit then break end
    end
    return out
end)

--- A person's cases, newest first: custody records (with CPS status) and incidents they're linked to.
--- Each: { ref, kind = 'custody'|'incident', title, status, createdAt }
exports('GetCasesForPerson', function(cid)
    cid = tostring(cid or '')
    if cid == '' then return {} end
    local out, cps = {}, {}
    for _, r in ipairs(MySQL.query.await('SELECT record_id, status FROM vw_mdt_cps WHERE cid = ? ORDER BY submitted_at DESC', { cid }) or {}) do
        if cps[r.record_id] == nil then cps[r.record_id] = r.status end
    end
    for _, r in ipairs(MySQL.query.await([[SELECT id, ref, offences, outcome, created_at FROM vw_mdt_records
        WHERE cid = ? AND ref IS NOT NULL ORDER BY created_at DESC LIMIT 10]], { cid }) or {}) do
        local offs = {}
        local list = Bridge.Decode(r.offences)
        for _, o in ipairs(type(list) == 'table' and list or {}) do
            offs[#offs + 1] = type(o) == 'table' and (o.title or o.label or o.name or o.code) or tostring(o)
        end
        out[#out + 1] = {
            ref = r.ref, kind = 'custody',
            title = #offs > 0 and table.concat(offs, ', ') or 'Custody record',
            status = cps[r.id] and ('CPS ' .. cps[r.id]) or (r.outcome or ''),
            createdAt = tonumber(r.created_at),
        }
    end
    for _, r in ipairs(MySQL.query.await([[SELECT i.ref, i.type, i.status, i.created_at, l.role
        FROM vw_mdt_incident_links l JOIN vw_mdt_incidents i ON i.id = l.incident_id
        WHERE l.kind = 'person' AND l.subject_id = ? AND i.ref IS NOT NULL
        ORDER BY i.created_at DESC LIMIT 10]], { cid }) or {}) do
        out[#out + 1] = {
            ref = r.ref, kind = 'incident',
            title = (r.type or 'Incident') .. (r.role and (' (' .. r.role .. ')') or ''),
            status = r.status or '',
            createdAt = tonumber(r.created_at),
        }
    end
    table.sort(out, function(a, b) return (a.createdAt or 0) > (b.createdAt or 0) end)
    return out
end)

print(('[%s] started (framework: %s, interviews: %s)'):format(resourceName, Bridge.Framework(), tostring(Config.Interviews.enabled)))
