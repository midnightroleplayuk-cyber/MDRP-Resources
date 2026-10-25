CREATE TABLE IF NOT EXISTS handling_profiles (  
  id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  vehicle VARCHAR(100) NOT NULL,
  edited_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  edited_by VARCHAR(255),
  handling_data TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS handling_vehicle_data (  
  plate VARCHAR(100) NOT NULL,
  vehicle_hash VARCHAR(100) NOT NULL,
  base_handling_data TEXT NOT NULL,
  handling_data TEXT NOT NULL,
  PRIMARY KEY (plate, vehicle_hash)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;