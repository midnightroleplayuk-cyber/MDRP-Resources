-- Manual install (optional). The resource applies sql/migrations automatically on start.
CREATE TABLE IF NOT EXISTS prison_schema (version VARCHAR(64) NOT NULL PRIMARY KEY, applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
-- Vinewood Prison Phase 1 schema. Applied automatically on start; tracked in prison_schema.

CREATE TABLE IF NOT EXISTS prison_prisons (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(16) NOT NULL UNIQUE,
    name VARCHAR(64) NOT NULL,
    boundary LONGTEXT NULL,
    settings LONGTEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_wings (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    code VARCHAR(16) NOT NULL,
    name VARCHAR(64) NOT NULL,
    type VARCHAR(16) NOT NULL DEFAULT 'standard',
    security CHAR(1) NOT NULL DEFAULT 'C',
    UNIQUE KEY uq_wing (prison_id, code),
    CONSTRAINT fk_wing_prison FOREIGN KEY (prison_id) REFERENCES prison_prisons (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_doors (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    wing_id INT UNSIGNED NULL,
    label VARCHAR(64) NOT NULL,
    kind VARCHAR(16) NOT NULL DEFAULT 'cell',
    model BIGINT NOT NULL,
    coords LONGTEXT NOT NULL,
    access_level TINYINT UNSIGNED NOT NULL DEFAULT 1,
    default_locked TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_door_prison FOREIGN KEY (prison_id) REFERENCES prison_prisons (id) ON DELETE CASCADE,
    CONSTRAINT fk_door_wing FOREIGN KEY (wing_id) REFERENCES prison_wings (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_cells (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    wing_id INT UNSIGNED NOT NULL,
    cell_no VARCHAR(16) NOT NULL,
    capacity TINYINT UNSIGNED NOT NULL DEFAULT 1,
    coords LONGTEXT NOT NULL,
    door_id INT UNSIGNED NULL,
    flags LONGTEXT NULL,
    UNIQUE KEY uq_cell (wing_id, cell_no),
    CONSTRAINT fk_cell_wing FOREIGN KEY (wing_id) REFERENCES prison_wings (id) ON DELETE CASCADE,
    CONSTRAINT fk_cell_door FOREIGN KEY (door_id) REFERENCES prison_doors (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_zones (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    type VARCHAR(32) NOT NULL,
    label VARCHAR(64) NOT NULL,
    coords LONGTEXT NOT NULL,
    radius FLOAT NOT NULL DEFAULT 1.5,
    data LONGTEXT NULL,
    INDEX idx_zone_type (prison_id, type),
    CONSTRAINT fk_zone_prison FOREIGN KEY (prison_id) REFERENCES prison_prisons (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_prisoners (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(64) NOT NULL,
    name VARCHAR(100) NOT NULL,
    prison_no VARCHAR(16) NOT NULL,
    prison_id INT UNSIGNED NOT NULL,
    cell_id INT UNSIGNED NULL,
    category CHAR(1) NOT NULL DEFAULT 'C',
    iep VARCHAR(16) NOT NULL DEFAULT 'standard',
    status VARCHAR(24) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    received_at TIMESTAMP NULL,
    released_at TIMESTAMP NULL,
    last_seen INT UNSIGNED NULL,
    outfit LONGTEXT NULL,
    mugshot VARCHAR(255) NULL,
    prints_hash VARCHAR(64) NULL,
    INDEX idx_prisoner_identifier (identifier),
    INDEX idx_prisoner_no (prison_no),
    INDEX idx_prisoner_status (prison_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_sentences (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    source VARCHAR(24) NOT NULL DEFAULT 'manual',
    external_ref VARCHAR(64) NULL,
    offences LONGTEXT NULL,
    term_s INT UNSIGNED NOT NULL DEFAULT 0,
    served_s INT UNSIGNED NOT NULL DEFAULT 0,
    release_at_s INT UNSIGNED NULL,
    remand TINYINT(1) NOT NULL DEFAULT 0,
    status VARCHAR(16) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    INDEX idx_sentence_prisoner (prisoner_id, status),
    CONSTRAINT fk_sentence_prisoner FOREIGN KEY (prisoner_id) REFERENCES prison_prisoners (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_property (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    identifier VARCHAR(64) NOT NULL,
    bag_no VARCHAR(16) NOT NULL,
    stash_id VARCHAR(64) NOT NULL,
    item_count INT UNSIGNED NOT NULL DEFAULT 0,
    stored_by VARCHAR(100) NOT NULL,
    stored_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    returned_at TIMESTAMP NULL,
    INDEX idx_property_identifier (identifier, returned_at),
    CONSTRAINT fk_property_prisoner FOREIGN KEY (prisoner_id) REFERENCES prison_prisoners (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_audit (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NULL,
    actor VARCHAR(100) NOT NULL,
    actor_identifier VARCHAR(64) NULL,
    action VARCHAR(64) NOT NULL,
    target VARCHAR(100) NULL,
    payload LONGTEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_action (action),
    INDEX idx_audit_target (target),
    INDEX idx_audit_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Vinewood Prison Phase 2: regime, incentives, discipline, accounts, canteen

ALTER TABLE prison_prisoners ADD COLUMN iep_since INT UNSIGNED NULL;

CREATE TABLE IF NOT EXISTS prison_behaviour (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    kind VARCHAR(16) NOT NULL,
    points TINYINT NOT NULL DEFAULT 0,
    note VARCHAR(255) NOT NULL,
    officer VARCHAR(100) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_behaviour_prisoner (prisoner_id, created_at),
    CONSTRAINT fk_behaviour_prisoner FOREIGN KEY (prisoner_id) REFERENCES prison_prisoners (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_iep_reviews (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    from_level VARCHAR(16) NOT NULL,
    to_level VARCHAR(16) NOT NULL,
    reviewer VARCHAR(100) NOT NULL,
    reason VARCHAR(255) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_iep_prisoner (prisoner_id),
    CONSTRAINT fk_iep_prisoner FOREIGN KEY (prisoner_id) REFERENCES prison_prisoners (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_adjudications (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    prison_id INT UNSIGNED NOT NULL,
    charge_code VARCHAR(16) NOT NULL,
    charge_text VARCHAR(128) NOT NULL,
    details VARCHAR(500) NOT NULL,
    raised_by VARCHAR(100) NOT NULL,
    raised_at INT UNSIGNED NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'open',
    plea VARCHAR(16) NULL,
    finding_notes VARCHAR(500) NULL,
    punishments LONGTEXT NULL,
    heard_by VARCHAR(100) NULL,
    heard_at INT UNSIGNED NULL,
    INDEX idx_adj_status (prison_id, status),
    INDEX idx_adj_prisoner (prisoner_id),
    CONSTRAINT fk_adj_prisoner FOREIGN KEY (prisoner_id) REFERENCES prison_prisoners (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_segregation (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    reason VARCHAR(255) NOT NULL,
    from_cell_id INT UNSIGNED NULL,
    cell_id INT UNSIGNED NOT NULL,
    placed_by VARCHAR(100) NOT NULL,
    start_at INT UNSIGNED NOT NULL,
    end_at INT UNSIGNED NULL,
    ended_at INT UNSIGNED NULL,
    ended_by VARCHAR(100) NULL,
    INDEX idx_seg_active (prisoner_id, ended_at),
    CONSTRAINT fk_seg_prisoner FOREIGN KEY (prisoner_id) REFERENCES prison_prisoners (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_restrictions (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    kind VARCHAR(24) NOT NULL,
    value INT NOT NULL DEFAULT 0,
    until_at INT UNSIGNED NOT NULL,
    reason VARCHAR(255) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_restriction_active (prisoner_id, until_at),
    CONSTRAINT fk_restriction_prisoner FOREIGN KEY (prisoner_id) REFERENCES prison_prisoners (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_accounts (
    identifier VARCHAR(64) NOT NULL PRIMARY KEY,
    spends INT NOT NULL DEFAULT 0,
    private_cash INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_transactions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(64) NOT NULL,
    wallet VARCHAR(16) NOT NULL,
    kind VARCHAR(24) NOT NULL,
    amount INT NOT NULL,
    balance INT NOT NULL,
    ref VARCHAR(128) NULL,
    actor VARCHAR(100) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_tx_identifier (identifier, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_canteen_orders (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(64) NOT NULL,
    prisoner_id INT UNSIGNED NOT NULL,
    prison_id INT UNSIGNED NOT NULL,
    period VARCHAR(24) NOT NULL,
    items LONGTEXT NOT NULL,
    total INT NOT NULL,
    paid LONGTEXT NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'pending',
    created_at INT UNSIGNED NOT NULL,
    delivered_at INT UNSIGNED NULL,
    INDEX idx_canteen_status (prison_id, status),
    INDEX idx_canteen_identifier (identifier, period)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_roll_checks (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    phase VARCHAR(32) NOT NULL,
    expected INT NOT NULL,
    accounted INT NOT NULL,
    missing LONGTEXT NULL,
    out_of_cell LONGTEXT NULL,
    by_name VARCHAR(100) NOT NULL,
    automated TINYINT(1) NOT NULL DEFAULT 0,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_roll_prison (prison_id, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Vinewood Prison Phase 3: jobs, industries, education, activities

CREATE TABLE IF NOT EXISTS prison_employment (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    identifier VARCHAR(64) NOT NULL,
    prison_id INT UNSIGNED NOT NULL,
    job VARCHAR(32) NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'applied',
    applied_at INT UNSIGNED NOT NULL,
    started_at INT UNSIGNED NULL,
    ended_at INT UNSIGNED NULL,
    ended_reason VARCHAR(255) NULL,
    decided_by VARCHAR(100) NULL,
    INDEX idx_employment_active (prison_id, status),
    INDEX idx_employment_prisoner (prisoner_id, status),
    CONSTRAINT fk_employment_prisoner FOREIGN KEY (prisoner_id) REFERENCES prison_prisoners (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_skills (
    identifier VARCHAR(64) NOT NULL,
    job VARCHAR(32) NOT NULL,
    xp INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (identifier, job)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_work_orders (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    job VARCHAR(32) NOT NULL,
    label VARCHAR(64) NOT NULL,
    target INT UNSIGNED NOT NULL,
    done INT UNSIGNED NOT NULL DEFAULT 0,
    contributors LONGTEXT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'open',
    created_by VARCHAR(100) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    completed_at INT UNSIGNED NULL,
    INDEX idx_orders_open (prison_id, job, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_enrolments (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(64) NOT NULL,
    course VARCHAR(32) NOT NULL,
    lesson TINYINT UNSIGNED NOT NULL DEFAULT 0,
    started_at INT UNSIGNED NOT NULL,
    completed_at INT UNSIGNED NULL,
    withdrawn_at INT UNSIGNED NULL,
    INDEX idx_enrolment_identifier (identifier, completed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_qualifications (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(64) NOT NULL,
    course VARCHAR(32) NOT NULL,
    label VARCHAR(100) NOT NULL,
    awarded_at INT UNSIGNED NOT NULL,
    UNIQUE KEY uq_qualification (identifier, course)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_stats (
    identifier VARCHAR(64) NOT NULL,
    stat VARCHAR(32) NOT NULL,
    value INT NOT NULL DEFAULT 0,
    PRIMARY KEY (identifier, stat)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Vinewood Prison Phase 4: searches, contraband, intelligence, incidents

CREATE TABLE IF NOT EXISTS prison_stashes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    kind VARCHAR(8) NOT NULL,
    ref_id INT UNSIGNED NOT NULL,
    stash_id VARCHAR(64) NOT NULL,
    created_by VARCHAR(64) NULL,
    created_at INT UNSIGNED NOT NULL,
    UNIQUE KEY uq_stash (kind, ref_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_searches (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    kind VARCHAR(16) NOT NULL,
    target VARCHAR(64) NOT NULL,
    prisoner_id INT UNSIGNED NULL,
    officer VARCHAR(100) NOT NULL,
    finds LONGTEXT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_search_prison (prison_id, id),
    INDEX idx_search_prisoner (prisoner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_intel (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    prisoner_id INT UNSIGNED NULL,
    category VARCHAR(24) NOT NULL,
    source_grade TINYINT UNSIGNED NOT NULL,
    intel_grade CHAR(1) NOT NULL,
    handling CHAR(1) NOT NULL DEFAULT 'P',
    body VARCHAR(1000) NOT NULL,
    author VARCHAR(100) NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_intel_prison (prison_id, id),
    INDEX idx_intel_prisoner (prisoner_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_incidents (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    type VARCHAR(24) NOT NULL,
    priority TINYINT UNSIGNED NOT NULL DEFAULT 2,
    location VARCHAR(100) NULL,
    coords LONGTEXT NULL,
    raised_by VARCHAR(100) NOT NULL,
    involved LONGTEXT NULL,
    note VARCHAR(255) NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'open',
    attending LONGTEXT NULL,
    report VARCHAR(2000) NULL,
    closed_by VARCHAR(100) NULL,
    created_at INT UNSIGNED NOT NULL,
    closed_at INT UNSIGNED NULL,
    INDEX idx_incident_prison (prison_id, status, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
-- Vinewood Prison Phase 6: movements, parole

CREATE TABLE IF NOT EXISTS prison_movements (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prison_id INT UNSIGNED NOT NULL,
    prisoner_id INT UNSIGNED NOT NULL,
    kind VARCHAR(16) NOT NULL,
    destination VARCHAR(64) NOT NULL,
    destination_label VARCHAR(64) NOT NULL,
    note VARCHAR(255) NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'planned',
    planned_by VARCHAR(100) NOT NULL,
    escort VARCHAR(100) NULL,
    created_at INT UNSIGNED NOT NULL,
    out_at INT UNSIGNED NULL,
    done_at INT UNSIGNED NULL,
    INDEX idx_movements_open (prison_id, status),
    INDEX idx_movements_prisoner (prisoner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS prison_parole (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prisoner_id INT UNSIGNED NOT NULL,
    sentence_id INT UNSIGNED NOT NULL,
    prison_id INT UNSIGNED NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'pending',
    score INT NOT NULL DEFAULT 0,
    factors LONGTEXT NULL,
    conditions LONGTEXT NULL,
    reason VARCHAR(500) NULL,
    decided_by VARCHAR(100) NULL,
    applied_at INT UNSIGNED NOT NULL,
    decided_at INT UNSIGNED NULL,
    INDEX idx_parole_status (prison_id, status),
    INDEX idx_parole_prisoner (prisoner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Double doors: the second leaf of a door pair
ALTER TABLE prison_doors ADD COLUMN pair LONGTEXT NULL;
INSERT IGNORE INTO prison_schema (version) VALUES ('0001_init'), ('0002_phase2'), ('0003_phase3'), ('0004_phase4'), ('0005_phase5'), ('0006_phase6'), ('0007_double_doors');
