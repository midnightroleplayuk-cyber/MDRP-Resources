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
