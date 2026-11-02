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
