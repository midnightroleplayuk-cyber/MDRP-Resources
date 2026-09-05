CREATE TABLE IF NOT EXISTS anpr_bolos (
    id VARCHAR(36) PRIMARY KEY,
    plate VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    category VARCHAR(255) DEFAULT NULL, 
    reason TEXT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_anpr_bolos_plate (plate)
);

CREATE TABLE IF NOT EXISTS anpr_jetbof (
    id VARCHAR(36) PRIMARY KEY,
    plate VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    color VARCHAR(255),
    coords_x FLOAT NOT NULL,
    coords_y FLOAT NOT NULL,
    coords_z FLOAT NOT NULL,
    street VARCHAR(255) NOT NULL DEFAULT 'Unknown Road',
    direction VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT anpr_jetbof_direction_check 
        CHECK (
            direction IN ('front', 'rear')
            OR direction LIKE 'Camera_%'
            OR direction REGEXP '^[A-Za-z0-9()_ \\-]+$'
        ),
    
    INDEX idx_anpr_jetbof_plate (plate)
);
