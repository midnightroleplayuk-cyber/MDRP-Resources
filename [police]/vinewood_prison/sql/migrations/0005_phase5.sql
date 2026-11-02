-- Vinewood Prison Phase 5: visits, phone, gangs, healthcare

ALTER TABLE prison_prisoners ADD COLUMN phone_pin VARCHAR(8) NULL;
ALTER TABLE prison_accounts ADD COLUMN phone_credit INT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS prison_visits (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    prisoner_id INT UNSIGNED NOT NULL,
    visitor_identifier VARCHAR(64) NULL,
    visitor_name VARCHAR(100) NOT NULL,
    type VARCHAR(8) NOT NULL DEFAULT 'social',
    session VARCHAR(32) NOT NULL,
    session_label VARCHAR(64) NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'booked',
    note VARCHAR(255) NULL,
    created_at INT UNSIGNED NOT NULL,
    started_at INT UNSIGNED NULL,
    ended_at INT UNSIGNED NULL,
    INDEX idx_visit_session (prison_id, session, status),
    INDEX idx_visit_prisoner (prisoner_id, session)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_visit_bans (
    identifier VARCHAR(64) NOT NULL PRIMARY KEY,
    until_at INT UNSIGNED NOT NULL,
    reason VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_contacts (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(64) NOT NULL,
    name VARCHAR(64) NOT NULL,
    number VARCHAR(24) NOT NULL,
    legal TINYINT(1) NOT NULL DEFAULT 0,
    status VARCHAR(16) NOT NULL DEFAULT 'pending',
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_contacts_identifier (identifier, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_calls (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    prisoner_id INT UNSIGNED NOT NULL,
    number VARCHAR(24) NOT NULL,
    contact VARCHAR(64) NOT NULL,
    legal TINYINT(1) NOT NULL DEFAULT 0,
    monitored TINYINT(1) NOT NULL DEFAULT 0,
    answered TINYINT(1) NOT NULL DEFAULT 0,
    seconds INT UNSIGNED NOT NULL DEFAULT 0,
    cost INT UNSIGNED NOT NULL DEFAULT 0,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_calls_prison (prison_id, id),
    INDEX idx_calls_prisoner (prisoner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_gangs (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    name VARCHAR(32) NOT NULL,
    influence INT NOT NULL DEFAULT 0,
    created_by VARCHAR(64) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    disbanded_at INT UNSIGNED NULL,
    INDEX idx_gangs_prison (prison_id, disbanded_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_gang_members (
    identifier VARCHAR(64) NOT NULL PRIMARY KEY,
    gang_id INT UNSIGNED NOT NULL,
    rank VARCHAR(16) NOT NULL DEFAULT 'member',
    joined_at INT UNSIGNED NOT NULL,
    INDEX idx_members_gang (gang_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_gang_relations (
    gang_a INT UNSIGNED NOT NULL,
    gang_b INT UNSIGNED NOT NULL,
    stance VARCHAR(8) NOT NULL,
    PRIMARY KEY (gang_a, gang_b)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_territories (
    zone_id INT UNSIGNED NOT NULL PRIMARY KEY,
    gang_id INT UNSIGNED NULL,
    since INT UNSIGNED NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_health_requests (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    prisoner_id INT UNSIGNED NOT NULL,
    category VARCHAR(24) NOT NULL,
    details VARCHAR(500) NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'open',
    appointment VARCHAR(100) NULL,
    outcome VARCHAR(500) NULL,
    handled_by VARCHAR(100) NULL,
    created_at INT UNSIGNED NOT NULL,
    closed_at INT UNSIGNED NULL,
    INDEX idx_health_status (prison_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_medical_notes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    note VARCHAR(1000) NOT NULL,
    author VARCHAR(100) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_notes_prisoner (prisoner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_medications (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    name VARCHAR(64) NOT NULL,
    dose VARCHAR(64) NOT NULL,
    rounds VARCHAR(64) NOT NULL,
    prescribed_by VARCHAR(100) NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_meds_prisoner (prisoner_id, active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_med_doses (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    medication_id INT UNSIGNED NOT NULL,
    prisoner_id INT UNSIGNED NOT NULL,
    session VARCHAR(32) NOT NULL,
    status VARCHAR(8) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    UNIQUE KEY uq_dose (medication_id, session),
    INDEX idx_doses_prisoner (prisoner_id, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_welfare_plans (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    reason VARCHAR(255) NOT NULL,
    interval_minutes INT UNSIGNED NOT NULL,
    opened_by VARCHAR(100) NOT NULL,
    opened_at INT UNSIGNED NOT NULL,
    closed_at INT UNSIGNED NULL,
    closed_by VARCHAR(100) NULL,
    INDEX idx_welfare_open (prisoner_id, closed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_welfare_checks (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    plan_id INT UNSIGNED NOT NULL,
    note VARCHAR(255) NOT NULL,
    officer VARCHAR(100) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_checks_plan (plan_id, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
