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
