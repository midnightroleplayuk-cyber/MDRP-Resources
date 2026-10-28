CREATE TABLE IF NOT EXISTS uk_complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reference VARCHAR(20) NOT NULL UNIQUE,
    citizen_id VARCHAR(100) NULL,
    citizen_name VARCHAR(100) NOT NULL,
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

ALTER TABLE uk_complaints MODIFY citizen_id VARCHAR(100) NULL;
