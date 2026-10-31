-- Optional: vinewood-moj creates these tables automatically on start.
CREATE TABLE IF NOT EXISTS vw_moj_cases (
    id INT AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(32), cid VARCHAR(64) NOT NULL, subject_name VARCHAR(96),
    court_kind VARCHAR(16) NOT NULL DEFAULT 'magistrates', court_id VARCHAR(16),
    cps_id INT NULL, record_id INT NULL, custody_ref VARCHAR(32),
    charges LONGTEXT, summary TEXT, evidence LONGTEXT, prosecutor VARCHAR(96),
    officer_name VARCHAR(96), officer_cid VARCHAR(64), solicitor_cid VARCHAR(64), solicitor_name VARCHAR(96),
    status VARCHAR(24) NOT NULL DEFAULT 'listed', custody_status VARCHAR(16) NOT NULL DEFAULT 'none',
    bail_conditions LONGTEXT, plea_stage VARCHAR(16), adjournments INT NOT NULL DEFAULT 0, log LONGTEXT,
    created_at BIGINT NOT NULL, updated_at BIGINT NOT NULL, closed_at BIGINT NULL,
    INDEX idx_cid (cid), INDEX idx_status (status), INDEX idx_cps (cps_id), INDEX idx_solicitor (solicitor_cid)
);
CREATE TABLE IF NOT EXISTS vw_moj_hearings (
    id INT AUTO_INCREMENT PRIMARY KEY, case_id INT NOT NULL, cid VARCHAR(64) NOT NULL, type VARCHAR(16) NOT NULL,
    court_id VARCHAR(16), scheduled_at BIGINT NOT NULL, status VARCHAR(16) NOT NULL DEFAULT 'listed',
    order_id INT NULL, judge_name VARCHAR(96), judge_cid VARCHAR(64), auto TINYINT(1) NOT NULL DEFAULT 0, result TEXT,
    reminded INT NOT NULL DEFAULT 0, created_at BIGINT NOT NULL, updated_at BIGINT NOT NULL,
    INDEX idx_case (case_id), INDEX idx_status (status, scheduled_at), INDEX idx_cid (cid)
);
CREATE TABLE IF NOT EXISTS vw_moj_sentences (
    id INT AUTO_INCREMENT PRIMARY KEY, case_id INT NOT NULL, cid VARCHAR(64) NOT NULL, subject_name VARCHAR(96),
    components LONGTEXT, summary TEXT, passed_by VARCHAR(96), auto TINYINT(1) NOT NULL DEFAULT 0, created_at BIGINT NOT NULL,
    INDEX idx_case (case_id), INDEX idx_cid (cid)
);
CREATE TABLE IF NOT EXISTS vw_moj_custody (
    id INT AUTO_INCREMENT PRIMARY KEY, cid VARCHAR(64) NOT NULL, subject_name VARCHAR(96), case_id INT NULL, sentence_id INT NULL,
    kind VARCHAR(16) NOT NULL, total_minutes INT NOT NULL DEFAULT 0, served_minutes INT NOT NULL DEFAULT 0,
    release_minutes INT NOT NULL DEFAULT 0, status VARCHAR(16) NOT NULL DEFAULT 'active', confiscated TINYINT(1) NOT NULL DEFAULT 0, unjail_pending TINYINT(1) NOT NULL DEFAULT 0,
    released_at BIGINT NULL, release_reason VARCHAR(160), created_at BIGINT NOT NULL, updated_at BIGINT NOT NULL,
    INDEX idx_cid (cid, status), INDEX idx_status (status)
);
CREATE TABLE IF NOT EXISTS vw_moj_orders (
    id INT AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(32), cid VARCHAR(64) NOT NULL, subject_name VARCHAR(96),
    case_id INT NULL, sentence_id INT NULL, kind VARCHAR(16) NOT NULL,
    hours_required INT NOT NULL DEFAULT 0, hours_done INT NOT NULL DEFAULT 0, requirements LONGTEXT,
    custody_months INT NOT NULL DEFAULT 0, officer_cid VARCHAR(64), officer_name VARCHAR(96),
    warnings INT NOT NULL DEFAULT 0, status VARCHAR(16) NOT NULL DEFAULT 'active', ends_at BIGINT NULL, log LONGTEXT,
    created_at BIGINT NOT NULL, updated_at BIGINT NOT NULL,
    INDEX idx_cid (cid, status), INDEX idx_officer (officer_cid), INDEX idx_status (status)
);
CREATE TABLE IF NOT EXISTS vw_moj_appointments (
    id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL, cid VARCHAR(64) NOT NULL, at BIGINT NOT NULL,
    location VARCHAR(160), status VARCHAR(16) NOT NULL DEFAULT 'booked', notes TEXT, officer_name VARCHAR(96),
    created_at BIGINT NOT NULL, INDEX idx_order (order_id), INDEX idx_cid (cid, status)
);
CREATE TABLE IF NOT EXISTS vw_moj_fines (
    id INT AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(32), cid VARCHAR(64) NOT NULL, subject_name VARCHAR(96), case_id INT NULL,
    kind VARCHAR(16) NOT NULL DEFAULT 'fine', amount INT NOT NULL DEFAULT 0, original INT NOT NULL DEFAULT 0,
    status VARCHAR(16) NOT NULL DEFAULT 'unpaid', due_at BIGINT NULL, paid_at BIGINT NULL, warrant_id INT NULL,
    created_at BIGINT NOT NULL, INDEX idx_cid (cid, status), INDEX idx_status (status)
);
CREATE TABLE IF NOT EXISTS vw_moj_warrants (
    id INT AUTO_INCREMENT PRIMARY KEY, cid VARCHAR(64) NOT NULL, subject_name VARCHAR(96), case_id INT NULL,
    type VARCHAR(16) NOT NULL, reason TEXT, status VARCHAR(16) NOT NULL DEFAULT 'active', mdt_id INT NULL,
    issued_by VARCHAR(96), closed_by VARCHAR(96), created_at BIGINT NOT NULL, closed_at BIGINT NULL,
    INDEX idx_cid (cid, status), INDEX idx_status (status)
);

ALTER TABLE vw_moj_custody ADD COLUMN IF NOT EXISTS unjail_pending TINYINT(1) NOT NULL DEFAULT 0;
