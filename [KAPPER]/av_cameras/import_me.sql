CREATE TABLE IF NOT EXISTS `av_cameras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `owner` varchar(80) DEFAULT NULL,
  `group_id` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `item` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT 'camera',
  `thumbnail` text DEFAULT NULL,
  `coords` JSON DEFAULT NULL,
  `settings` JSON DEFAULT NULL,
  `battery` tinyint UNSIGNED DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `authorized_players` JSON DEFAULT NULL,
  `install_date` timestamp NULL DEFAULT current_timestamp(),
  `expiration` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`),
  KEY `owner` (`owner`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_cameras_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL DEFAULT '0',
  `owner` varchar(50) NOT NULL DEFAULT '0',
  `label` varchar(50) NOT NULL DEFAULT '0',
  `authorized_players` JSON DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_cameras_replay` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `camera` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `camera` (`camera`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;