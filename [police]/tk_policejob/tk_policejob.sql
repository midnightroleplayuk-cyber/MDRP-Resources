CREATE TABLE IF NOT EXISTS `tk_policejob_impounded_vehicles` (
  `plate` varchar(12) NOT NULL,
  `veh_name` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tk_policejob_vehicles` (
  `owner` varchar(50) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `props` longtext NOT NULL,
  UNIQUE KEY `unique_plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tk_policejob_outfits` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL,
  `data` LONGTEXT NOT NULL,
  `gender` VARCHAR(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tk_policejob_speed_cameras` (
  `id` VARCHAR(50) PRIMARY KEY,
  `coords` JSON,
  `rotation` JSON,
  `configIndex` VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;