CREATE TABLE IF NOT EXISTS `tk_ambulancejob_injuries` (
  `identifier` VARCHAR(50) NOT NULL,
  `body_part` VARCHAR(10) NOT NULL,
  `id` VARCHAR(50) NOT NULL PRIMARY KEY,
  `type` VARCHAR(20) NOT NULL,
  `cause` VARCHAR(50) NULL,
  `damage` INT NOT NULL,
  `timestamp` BIGINT NOT NULL,
  INDEX `identifier` (`identifier`),
  INDEX `body_part` (`body_part`)
) CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tk_ambulancejob_bullets` (
  `identifier` VARCHAR(50) NOT NULL,
  `body_part` VARCHAR(10) NOT NULL,
  `id` VARCHAR(50) NOT NULL PRIMARY KEY,
  `caliber` VARCHAR(10) NOT NULL,
  `entry_angle` INT NOT NULL,
  `damage` INT NOT NULL,
  `timestamp` BIGINT NOT NULL,
  INDEX `identifier` (`identifier`),
  INDEX `body_part` (`body_part`)
) CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tk_ambulancejob_vehicles` (
  `owner` varchar(50) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `props` longtext NOT NULL,
  UNIQUE KEY `plate` (`plate`),
  INDEX `owner` (`owner`)
) CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tk_ambulancejob_outfits` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL,
  `data` LONGTEXT NOT NULL,
  `gender` VARCHAR(10) NOT NULL,
  `hospital` INT NOT NULL DEFAULT 1,
  INDEX `hospital` (`hospital`)
) CHARSET=utf8mb4;

-- ESX:
ALTER IGNORE TABLE users ADD COLUMN IF NOT EXISTS isDead TINYINT(1) DEFAULT 0;

-- QB:
ALTER IGNORE TABLE players ADD COLUMN IF NOT EXISTS isDead TINYINT(1) DEFAULT 0;
