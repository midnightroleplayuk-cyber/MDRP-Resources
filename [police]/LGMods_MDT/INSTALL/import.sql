CREATE TABLE IF NOT EXISTS vehicle_insurance (
    plate VARCHAR(8) PRIMARY KEY,
    level VARCHAR(50),
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP NULL DEFAULT NULL,
    owner VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS vehicle_tax (
    plate VARCHAR(8) PRIMARY KEY,
    paid_until TIMESTAMP,
    band VARCHAR(50),
    owner VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS vehicle_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(8) NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'Open',
    officer_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plate (plate)
);

CREATE TABLE IF NOT EXISTS police_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'Open',
    officer_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_subject (subject_id)
);

CREATE TABLE IF NOT EXISTS warrants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reference VARCHAR(20) NOT NULL,
    subject_id VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'Active',
    issuing_authority VARCHAR(100),
    officer_id VARCHAR(50),
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_reference (reference),
    INDEX idx_subject (subject_id)
);

CREATE TABLE IF NOT EXISTS prior_offenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50) NOT NULL,
    offense VARCHAR(100) NOT NULL,
    outcome TEXT,
    date DATE NOT NULL,
    officer_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_citizenid (citizenid)
);

CREATE TABLE IF NOT EXISTS mugshots (
    citizenid VARCHAR(50) PRIMARY KEY,
    mugshot VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS fingerprints (
    citizenid VARCHAR(50) NOT NULL PRIMARY KEY,
    suspectName VARCHAR(50) NOT NULL,
    fingerprint_id VARCHAR(50) NOT NULL,
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS crime_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id VARCHAR(50) UNIQUE,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    involved_officers TEXT,
    involved_citizens TEXT,
    officer_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS crime_report_charges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id VARCHAR(50) NOT NULL,
    citizenid VARCHAR(50) NOT NULL,
    charges TEXT NOT NULL,
    total_prison_time INT NOT NULL,
    total_fine INT NOT NULL,
    processed BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_report (report_id),
    INDEX idx_citizen (citizenid)
);

CREATE TABLE IF NOT EXISTS pending_charges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizenid VARCHAR(50) NOT NULL,
    prison_time INT NOT NULL,
    fine INT NOT NULL,
    processed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP NULL DEFAULT NULL,
    INDEX idx_citizen (citizenid),
    INDEX idx_processed (processed)
);

ALTER TABLE player_vehicles
    ADD COLUMN IF NOT EXISTS v5c_last_claimed TIMESTAMP NULL DEFAULT NULL;

ALTER TABLE player_vehicles
    ADD COLUMN IF NOT EXISTS v5c_ref VARCHAR(20) DEFAULT NULL;

ALTER TABLE player_vehicles
    ADD COLUMN IF NOT EXISTS vin VARCHAR(17) DEFAULT NULL;
