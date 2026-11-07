CREATE TABLE IF NOT EXISTS uk_complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reference VARCHAR(20) NOT NULL UNIQUE,
    citizen_id VARCHAR(100) NULL,
    citizen_name VARCHAR(100) NOT NULL,
    service VARCHAR(40) NOT NULL DEFAULT 'Ambulance Services',
    category VARCHAR(60) NOT NULL,
    title VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    contact VARCHAR(100),
    description TEXT NOT NULL,
    anonymous TINYINT(1) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'submitted',
    officer_note TEXT,
    updated_by VARCHAR(100),
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_date (submitted_at),
    INDEX idx_citizen_date (citizen_id, submitted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET @service_column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'uk_complaints'
      AND column_name = 'service'
);
SET @service_column_migration = IF(
    @service_column_exists = 0,
    'ALTER TABLE uk_complaints ADD COLUMN service VARCHAR(40) NOT NULL DEFAULT ''Ambulance Services'' AFTER citizen_name',
    'SELECT 1'
);
PREPARE service_column_statement FROM @service_column_migration;
EXECUTE service_column_statement;
DEALLOCATE PREPARE service_column_statement;

ALTER TABLE uk_complaints MODIFY citizen_id VARCHAR(100) NULL;
