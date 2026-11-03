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
