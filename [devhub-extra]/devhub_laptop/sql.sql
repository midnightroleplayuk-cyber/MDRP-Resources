CREATE TABLE IF NOT EXISTS `devhub_laptop` (
`identifier` varchar(46) NOT NULL,
`installed` longtext DEFAULT NULL,
`settings` longtext DEFAULT NULL,
PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `devhub_laptop_crimetraders` (
`identifier` varchar(46) NOT NULL,
`data` longtext DEFAULT NULL,
PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;


CREATE TABLE IF NOT EXISTS `devhub_laptop_notepad` (
`identifier` varchar(46) NOT NULL,
`notes` longtext DEFAULT NULL,
PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;