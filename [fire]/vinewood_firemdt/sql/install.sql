-- Optional: tables are created automatically on first start.
CREATE TABLE IF NOT EXISTS firemdt_incidents (
    id INT AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(32), type VARCHAR(64), priority VARCHAR(32),
    location VARCHAR(128), details TEXT, caller VARCHAR(64), x FLOAT, y FLOAT, z FLOAT,
    status VARCHAR(16) DEFAULT 'open', created_at INT, closed_at INT NULL, created_by VARCHAR(64), source VARCHAR(32),
    INDEX(status));
CREATE TABLE IF NOT EXISTS firemdt_incident_log (
    id INT AUTO_INCREMENT PRIMARY KEY, incident_id INT, kind VARCHAR(16), text TEXT,
    author VARCHAR(64), callsign VARCHAR(32), created_at INT, INDEX(incident_id));
CREATE TABLE IF NOT EXISTS firemdt_hydrants (
    id INT AUTO_INCREMENT PRIMARY KEY, code VARCHAR(32), type VARCHAR(32), status VARCHAR(32),
    defect TEXT, x FLOAT, y FLOAT, z FLOAT, updated_by VARCHAR(64), updated_at INT);
CREATE TABLE IF NOT EXISTS firemdt_risks (
    id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(128), address VARCHAR(128), level TINYINT DEFAULT 1,
    x FLOAT, y FLOAT, z FLOAT, radius FLOAT DEFAULT 50, hazards TEXT, access TEXT, water TEXT,
    contacts TEXT, notes TEXT, updated_by VARCHAR(64), updated_at INT);
CREATE TABLE IF NOT EXISTS firemdt_sops (
    id INT AUTO_INCREMENT PRIMARY KEY, category VARCHAR(64), title VARCHAR(128), body TEXT,
    updated_by VARCHAR(64), updated_at INT);
