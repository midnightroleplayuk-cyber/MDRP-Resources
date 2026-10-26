-- vinewood-emsmdt tables (also created automatically on start)

CREATE TABLE IF NOT EXISTS vems_patients (
    citizenid VARCHAR(64) PRIMARY KEY,
    blood_type VARCHAR(8) DEFAULT NULL,
    allergies TEXT, conditions TEXT, regular_meds TEXT, notes TEXT, nok TEXT,
    flags LONGTEXT,
    updated_by VARCHAR(100), updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vems_incidents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(120) NOT NULL, details TEXT, location VARCHAR(160), coords VARCHAR(120),
    category TINYINT DEFAULT 2, status VARCHAR(16) DEFAULT 'open',
    units LONGTEXT, hems_requested TINYINT DEFAULT 0, source VARCHAR(40) DEFAULT 'mdt', dispatch_id INT NULL,
    created_by VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, closed_at TIMESTAMP NULL
);

CREATE TABLE IF NOT EXISTS vems_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ref VARCHAR(24) UNIQUE,
    citizenid VARCHAR(64), patient_name VARCHAR(100),
    incident_id INT NULL, location VARCHAR(160),
    author_cid VARCHAR(64), author_name VARCHAR(100),
    data LONGTEXT,
    flatline TINYINT DEFAULT 0, news2 INT NULL,
    outcome VARCHAR(24), hospital VARCHAR(40),
    status VARCHAR(12) DEFAULT 'draft',
    amendments LONGTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    finalised_at TIMESTAMP NULL,
    INDEX (citizenid), INDEX (incident_id)
);

CREATE TABLE IF NOT EXISTS vems_report_revisions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    data LONGTEXT, citizenid VARCHAR(64), patient_name VARCHAR(100), location VARCHAR(160),
    outcome VARCHAR(24), hospital VARCHAR(40),
    edited_by VARCHAR(140), edited_cid VARCHAR(64), reason VARCHAR(300), changes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX (report_id)
);

CREATE TABLE IF NOT EXISTS vems_staff (
    citizenid VARCHAR(64) PRIMARY KEY,
    name VARCHAR(100), grade INT DEFAULT 0, rank_label VARCHAR(80),
    joined_at DATE NULL,
    probation_status VARCHAR(16) DEFAULT 'none', probation_start DATE NULL, probation_end DATE NULL, probation_notes TEXT,
    notes TEXT, last_seen TIMESTAMP NULL, active TINYINT DEFAULT 1,
    updated_by VARCHAR(100), updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vems_staff_quals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(64) NOT NULL,
    kind VARCHAR(16) NOT NULL, code VARCHAR(40), title VARCHAR(120),
    ref VARCHAR(30) NULL, result VARCHAR(12) NULL, score VARCHAR(20) NULL,
    issued_at DATE, expires_at DATE NULL,
    issued_by VARCHAR(100), issued_cid VARCHAR(64), notes TEXT,
    revoked_at TIMESTAMP NULL, revoked_by VARCHAR(100), revoke_reason VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX (citizenid), INDEX (kind, code)
);

CREATE TABLE IF NOT EXISTS vems_staff_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(64) NOT NULL, event VARCHAR(40), detail VARCHAR(255), actor VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, INDEX (citizenid)
);

CREATE TABLE IF NOT EXISTS vems_admissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NULL, citizenid VARCHAR(64), patient_name VARCHAR(100),
    hospital VARCHAR(40), reason TEXT,
    admitted_by VARCHAR(100), admitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    discharged_at TIMESTAMP NULL, discharged_by VARCHAR(100), discharge_notes TEXT,
    INDEX (citizenid)
);

CREATE TABLE IF NOT EXISTS vems_prescriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(64), drug VARCHAR(80), dose VARCHAR(60), instructions TEXT,
    item VARCHAR(60) NULL, qty INT DEFAULT 1, status VARCHAR(16) DEFAULT 'pending',
    collected_at TIMESTAMP NULL, handed_by VARCHAR(100) NULL,
    prescriber_cid VARCHAR(64), prescriber_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, INDEX (citizenid)
);

CREATE TABLE IF NOT EXISTS vems_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    actor_cid VARCHAR(64), actor_name VARCHAR(100),
    action VARCHAR(40), target VARCHAR(160), reason VARCHAR(160),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vems_erk (
    id INT AUTO_INCREMENT PRIMARY KEY,
    used_by_cid VARCHAR(64), used_by_name VARCHAR(100),
    target_cid VARCHAR(64), target_name VARCHAR(100),
    reason VARCHAR(80), notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vems_injury_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_ref VARCHAR(60), citizenid VARCHAR(64), patient_name VARCHAR(100),
    officer_name VARCHAR(100), notes TEXT,
    status VARCHAR(12) DEFAULT 'pending',
    report_id INT NULL, statement TEXT, responded_by VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, responded_at TIMESTAMP NULL,
    INDEX (case_ref), INDEX (citizenid)
);
