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
