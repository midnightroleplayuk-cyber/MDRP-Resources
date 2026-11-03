CREATE TABLE IF NOT EXISTS `av_gangs` (
  `identifier` varchar(50) DEFAULT NULL,
  `playerName` varchar(50) DEFAULT NULL,
  `isBoss` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `label` longtext DEFAULT NULL,
  `photo` longtext DEFAULT '',
  `rank` VARCHAR(50) DEFAULT '',
  `joined` VARCHAR(50) DEFAULT '',
  `permissions` LONGTEXT DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE av_gangs
ADD COLUMN alias VARCHAR(50) DEFAULT NULL,
ADD COLUMN reputation INT DEFAULT 0;