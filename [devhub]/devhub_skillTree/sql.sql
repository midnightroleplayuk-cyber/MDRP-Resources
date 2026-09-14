CREATE TABLE IF NOT EXISTS `dh_skilltree` (
  `identifier` varchar(120) NOT NULL,
  `skills` longtext DEFAULT NULL,
  `globalStats` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- If upgrading from v2 to v3, run the following SQL to add the new columns:
ALTER TABLE `dh_skilltree`
ADD COLUMN IF NOT EXISTS `data` LONGTEXT DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `name` VARCHAR(255) DEFAULT NULL;


-- If your table was created as utf8mb3 (older installs), player names with 4-byte
-- characters (emoji, mathematical/monospace letters) fail to save. The script converts
-- it automatically on start; you can also run this manually:
ALTER TABLE `dh_skilltree` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


