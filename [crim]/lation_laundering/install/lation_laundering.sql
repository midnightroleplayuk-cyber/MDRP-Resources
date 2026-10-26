CREATE TABLE IF NOT EXISTS `lation_laundering` (
  `player_identifier` varchar(255) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `experience` int(11) NOT NULL DEFAULT 0,
  `contracts_completed` int(11) NOT NULL DEFAULT 0,
  `total_money_cleaned` bigint(20) NOT NULL DEFAULT 0,
  `pending` int(11) NOT NULL DEFAULT 0,
  `time_remaining` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`player_identifier`)
);
