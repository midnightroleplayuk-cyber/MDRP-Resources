CREATE TABLE IF NOT EXISTS `av_racing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` longtext DEFAULT NULL,
  `identifier` longtext DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `leaderboard` text DEFAULT NULL,
  `createdby` varchar(50) DEFAULT NULL,
  `distance` varchar(50) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `av_racing_profiles` (
  `identifier` varchar(50) NOT NULL DEFAULT '123',
  `name` varchar(50) DEFAULT NULL,
  `photo` longtext DEFAULT NULL,
  `crew` varchar(50) DEFAULT NULL,
  `crewLabel` varchar(50) DEFAULT NULL,
  `isBoss` int(11) NOT NULL DEFAULT 0,
  `joined` varchar(50) DEFAULT NULL,
  `races` int(11) NOT NULL DEFAULT 0,
  `wins` int(11) NOT NULL DEFAULT 0,
  `settings` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

ALTER TABLE `av_racing` ADD COLUMN IF NOT EXISTS `type` varchar(50) NULL DEFAULT NULL;
ALTER TABLE `av_racing_profiles` ADD COLUMN IF NOT EXISTS `favorites` LONGTEXT DEFAULT '[]';
ALTER TABLE `av_racing_profiles` ADD COLUMN IF NOT EXISTS `elo` INT NOT NULL DEFAULT 0;
ALTER TABLE `av_racing_profiles` ADD COLUMN IF NOT EXISTS `xp` INT NOT NULL DEFAULT 0;
ALTER TABLE `av_racing_profiles` ADD COLUMN IF NOT EXISTS `redeemed` LONGTEXT DEFAULT '[]';
ALTER TABLE `av_racing_profiles` ADD COLUMN IF NOT EXISTS `stats` LONGTEXT DEFAULT '{}';
