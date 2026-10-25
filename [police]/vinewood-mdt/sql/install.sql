-- Optional: vinewood-mdt creates these tables automatically on start.
CREATE TABLE IF NOT EXISTS vw_mdt_records (
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
);

CREATE TABLE IF NOT EXISTS vw_mdt_bail (
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
);

CREATE TABLE IF NOT EXISTS vw_mdt_markers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_type VARCHAR(8) NOT NULL,
    subject_id VARCHAR(64) NOT NULL,
    marker VARCHAR(32) NOT NULL,
    note VARCHAR(255),
    officer_name VARCHAR(96),
    created_at BIGINT NOT NULL,
    INDEX idx_subject (subject_type, subject_id)
);

CREATE TABLE IF NOT EXISTS vw_mdt_cps (
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
);

CREATE TABLE IF NOT EXISTS vw_mdt_defence (
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
);

ALTER TABLE vw_mdt_records ADD COLUMN IF NOT EXISTS incident_id INT NULL;

CREATE TABLE IF NOT EXISTS vw_mdt_incidents (
    id INT AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(32), type VARCHAR(48) NOT NULL, grade VARCHAR(16),
    status VARCHAR(16) NOT NULL DEFAULT 'Open', location VARCHAR(160), coords VARCHAR(96), narrative TEXT,
    officer_name VARCHAR(96), officer_cid VARCHAR(64), created_at BIGINT NOT NULL, updated_at BIGINT NOT NULL,
    INDEX idx_status (status), INDEX idx_ref (ref)
);
CREATE TABLE IF NOT EXISTS vw_mdt_incident_links (
    id INT AUTO_INCREMENT PRIMARY KEY, incident_id INT NOT NULL, kind VARCHAR(8) NOT NULL, subject_id VARCHAR(64) NOT NULL,
    label VARCHAR(96), role VARCHAR(24), INDEX idx_incident (incident_id), INDEX idx_subject (kind, subject_id)
);
CREATE TABLE IF NOT EXISTS vw_mdt_evidence (
    id INT AUTO_INCREMENT PRIMARY KEY, incident_id INT NOT NULL, exhibit_ref VARCHAR(24), type VARCHAR(32), description VARCHAR(255),
    seized_from VARCHAR(64), seized_from_name VARCHAR(96), found_at VARCHAR(160), status VARCHAR(32), photo VARCHAR(400),
    continuity LONGTEXT, officer_name VARCHAR(96), officer_cid VARCHAR(64), created_at BIGINT NOT NULL,
    INDEX idx_incident (incident_id), INDEX idx_seized (seized_from)
);
CREATE TABLE IF NOT EXISTS vw_mdt_intel (
    id INT AUTO_INCREMENT PRIMARY KEY, subject_type VARCHAR(8), subject_id VARCHAR(64), subject_label VARCHAR(96),
    grading VARCHAR(8), text TEXT, officer_name VARCHAR(96), created_at BIGINT NOT NULL, INDEX idx_subject (subject_type, subject_id)
);
CREATE TABLE IF NOT EXISTS vw_mdt_warrants (
    id INT AUTO_INCREMENT PRIMARY KEY, type VARCHAR(16) NOT NULL, cid VARCHAR(64), subject_name VARCHAR(96), address VARCHAR(160),
    reason TEXT, status VARCHAR(16) NOT NULL DEFAULT 'active', issued_by VARCHAR(96), closed_by VARCHAR(96),
    created_at BIGINT NOT NULL, closed_at BIGINT NULL, INDEX idx_cid (cid), INDEX idx_status (status)
);
CREATE TABLE IF NOT EXISTS vw_mdt_notes (
    id INT AUTO_INCREMENT PRIMARY KEY, subject_type VARCHAR(8) NOT NULL, subject_id VARCHAR(64) NOT NULL, text TEXT,
    officer_name VARCHAR(96), created_at BIGINT NOT NULL, INDEX idx_subject (subject_type, subject_id)
);

CREATE TABLE IF NOT EXISTS vw_mdt_anpr (
    id INT AUTO_INCREMENT PRIMARY KEY, plate VARCHAR(12) NOT NULL, reason VARCHAR(160), action VARCHAR(64), note TEXT,
    officer_name VARCHAR(96), expires_at BIGINT NULL, active TINYINT(1) NOT NULL DEFAULT 1, created_at BIGINT NOT NULL,
    INDEX idx_plate (plate, active)
);
CREATE TABLE IF NOT EXISTS vw_mdt_anpr_hits (
    id INT AUTO_INCREMENT PRIMARY KEY, plate VARCHAR(12) NOT NULL, model VARCHAR(64), reasons LONGTEXT, source VARCHAR(96),
    officer_name VARCHAR(96), location VARCHAR(160), coords VARCHAR(96), created_at BIGINT NOT NULL,
    INDEX idx_plate (plate), INDEX idx_created (created_at)
);

ALTER TABLE vw_mdt_records ADD COLUMN IF NOT EXISTS custody LONGTEXT NULL;

CREATE TABLE IF NOT EXISTS vw_mdt_audit (
    id INT AUTO_INCREMENT PRIMARY KEY, officer_cid VARCHAR(64), officer_name VARCHAR(96), action VARCHAR(32) NOT NULL,
    subject_type VARCHAR(16), subject_id VARCHAR(64), subject_label VARCHAR(120), reason VARCHAR(64), detail VARCHAR(255),
    created_at BIGINT NOT NULL, INDEX idx_subject (subject_type, subject_id), INDEX idx_officer (officer_cid), INDEX idx_created (created_at)
);
CREATE TABLE IF NOT EXISTS vw_mdt_photos (
    id INT AUTO_INCREMENT PRIMARY KEY, cid VARCHAR(64) NOT NULL, url VARCHAR(400) NOT NULL, record_id INT NULL,
    officer_name VARCHAR(96), created_at BIGINT NOT NULL, INDEX idx_cid (cid)
);
CREATE TABLE IF NOT EXISTS vw_mdt_stopsearch (
    id INT AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(32), cid VARCHAR(64), subject_name VARCHAR(96), description VARCHAR(255),
    plate VARCHAR(12), power VARCHAR(16) NOT NULL, authorisation VARCHAR(160), object VARCHAR(48), grounds TEXT,
    location VARCHAR(160), coords VARCHAR(96), found TEXT, outcome VARCHAR(48), gowisely TINYINT(1) NOT NULL DEFAULT 0,
    receipt TINYINT(1) NOT NULL DEFAULT 0, incident_id INT NULL, officer_name VARCHAR(96), officer_cid VARCHAR(64),
    created_at BIGINT NOT NULL, INDEX idx_cid (cid), INDEX idx_created (created_at)
);

CREATE TABLE IF NOT EXISTS vw_mdt_fines (
    id INT AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(32), cid VARCHAR(64) NOT NULL, subject_name VARCHAR(96), type VARCHAR(8) NOT NULL,
    offences LONGTEXT, amount INT NOT NULL DEFAULT 0, points INT NOT NULL DEFAULT 0, status VARCHAR(16) NOT NULL,
    increased TINYINT(1) NOT NULL DEFAULT 0, due_at BIGINT NULL, paid_at BIGINT NULL, location VARCHAR(160), plate VARCHAR(12),
    notes TEXT, court_result TEXT, incident_id INT NULL, officer_name VARCHAR(96), officer_cid VARCHAR(64), created_at BIGINT NOT NULL,
    INDEX idx_cid (cid), INDEX idx_status (status)
);
CREATE TABLE IF NOT EXISTS vw_mdt_statements (
    id INT AUTO_INCREMENT PRIMARY KEY, incident_id INT NOT NULL, kind VARCHAR(16) NOT NULL, maker_cid VARCHAR(64), maker_name VARCHAR(96),
    occupation VARCHAR(96), body LONGTEXT, status VARCHAR(16) NOT NULL, signed_at BIGINT NULL, taken_by VARCHAR(96), taken_by_cid VARCHAR(64),
    created_at BIGINT NOT NULL, INDEX idx_incident (incident_id), INDEX idx_maker (maker_cid)
);

CREATE TABLE IF NOT EXISTS vw_mdt_anpr_cameras (
    id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(96) NOT NULL, x DOUBLE NOT NULL, y DOUBLE NOT NULL, z DOUBLE NOT NULL,
    heading DOUBLE NOT NULL DEFAULT 0, radius DOUBLE NOT NULL DEFAULT 18, prop TINYINT(1) NOT NULL DEFAULT 1,
    active TINYINT(1) NOT NULL DEFAULT 1, added_by VARCHAR(96), created_at BIGINT NOT NULL
);
CREATE TABLE IF NOT EXISTS vw_mdt_anpr_fitted (
    id INT AUTO_INCREMENT PRIMARY KEY, kind VARCHAR(8) NOT NULL, value VARCHAR(32) NOT NULL, label VARCHAR(96),
    added_by VARCHAR(96), created_at BIGINT NOT NULL, INDEX idx_kind (kind, value)
);

CREATE TABLE IF NOT EXISTS vw_mdt_defence_notes (
    id INT AUTO_INCREMENT PRIMARY KEY, solicitor_cid VARCHAR(64) NOT NULL, client_cid VARCHAR(64) NOT NULL, record_id INT NULL,
    case_ref VARCHAR(32), body TEXT NOT NULL, created_at BIGINT NOT NULL, updated_at BIGINT NOT NULL,
    INDEX idx_owner (solicitor_cid, client_cid)
);

CREATE TABLE IF NOT EXISTS vw_mdt_prison_status (
    cid VARCHAR(64) PRIMARY KEY, status VARCHAR(16) NOT NULL, prison_no VARCHAR(16), prison VARCHAR(96),
    cell VARCHAR(32), release_at BIGINT NULL, updated_at BIGINT NOT NULL
);

-- Evidence storage (added automatically on start if missing)
ALTER TABLE vw_mdt_evidence ADD COLUMN IF NOT EXISTS stash_id VARCHAR(48) NULL;
ALTER TABLE vw_mdt_evidence ADD COLUMN IF NOT EXISTS items LONGTEXT NULL;
ALTER TABLE vw_mdt_evidence ADD COLUMN IF NOT EXISTS suspect_cid VARCHAR(64) NULL;
ALTER TABLE vw_mdt_evidence ADD COLUMN IF NOT EXISTS suspect_name VARCHAR(96) NULL;

CREATE TABLE IF NOT EXISTS vw_mdt_traces (
    id INT AUTO_INCREMENT PRIMARY KEY, type VARCHAR(8) NOT NULL, x DOUBLE NOT NULL, y DOUBLE NOT NULL, z DOUBLE NOT NULL,
    weapon VARCHAR(48), serial VARCHAR(48), dna_cid VARCHAR(64), location VARCHAR(160), created_at BIGINT NOT NULL,
    collected_by VARCHAR(64) NULL, collected_name VARCHAR(96) NULL, collected_at BIGINT NULL, evidence_id INT NULL,
    INDEX idx_open (collected_by, evidence_id), INDEX idx_created (created_at)
);
CREATE TABLE IF NOT EXISTS vw_mdt_dna (cid VARCHAR(64) PRIMARY KEY, taken_by VARCHAR(96), custody_ref VARCHAR(32), created_at BIGINT NOT NULL);
ALTER TABLE vw_mdt_evidence ADD COLUMN IF NOT EXISTS forensic LONGTEXT NULL;
ALTER TABLE vw_mdt_evidence ADD COLUMN IF NOT EXISTS lab_status VARCHAR(16) NULL;
ALTER TABLE vw_mdt_evidence ADD COLUMN IF NOT EXISTS lab_due BIGINT NULL;
ALTER TABLE vw_mdt_evidence ADD COLUMN IF NOT EXISTS lab_result LONGTEXT NULL;
