-- ============================================================
-- BANS
-- ------------------------------------------------------------
-- `ban_time` is a UNIX timestamp (when the ban was issued).
-- `exp_time` is a UNIX timestamp for when it expires, or -1 for
-- a PERMANENT ban. Anything <= 0 is treated as permanent, which
-- keeps rows written by older builds working.
-- ============================================================
CREATE TABLE IF NOT EXISTS `apex_bans` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `author` VARCHAR(64) DEFAULT NULL,
  `author_lic` VARCHAR(64) DEFAULT NULL,
  `player` VARCHAR(64) DEFAULT NULL,
  `license` VARCHAR(64) DEFAULT NULL,
  `ip` VARCHAR(64) DEFAULT NULL,
  `discord` VARCHAR(64) DEFAULT NULL,
  `reason` VARCHAR(255) DEFAULT NULL,
  `ban_time` BIGINT(20) NOT NULL DEFAULT 0,
  `exp_time` BIGINT(20) NOT NULL DEFAULT -1,
  PRIMARY KEY (`id`),
  KEY `idx_apex_bans_license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
