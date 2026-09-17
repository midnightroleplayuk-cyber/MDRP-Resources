
CREATE TABLE IF NOT EXISTS `opmdt_medcats` (
  `uniqueId` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(3000) NOT NULL,
  `job` varchar(250) DEFAULT 'ambulance',
  PRIMARY KEY (`uniqueId`),
  UNIQUE KEY `uniqueId` (`uniqueId`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

INSERT INTO `opmdt_medcats` (`uniqueId`, `label`, `job`) VALUES
	(1, 'Infectious Diseases', 'ambulance'),
	(2, 'Cardiovascular', 'ambulance'),
	(3, 'Trauma & Injuries', 'ambulance'),
	(4, 'Neurology', 'ambulance'),
	(5, 'Respiratory', 'ambulance');

CREATE TABLE IF NOT EXISTS `opmdt_medconds` (
  `uniqueId` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(250) NOT NULL,
  `insuranceCost` int(250) DEFAULT 0,
  `noInsuranceCost` int(250) DEFAULT 0,
  `category` bigint(20) DEFAULT 1,
  `color` varchar(150) NOT NULL DEFAULT 'green',
  `job` varchar(250) DEFAULT 'ambulance',
  PRIMARY KEY (`uniqueId`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

INSERT INTO `opmdt_medconds` (`uniqueId`, `label`, `insuranceCost`, `noInsuranceCost`, `category`, `color`, `job`) VALUES
	(1, 'HIV / AIDS', 5000, 25000, 1, 'yellow', 'ambulance'),
	(3, 'Hepatitis B', 1500, 10000, 1, 'yellow', 'ambulance'),
	(4, 'Hepatitis C', 1800, 12000, 1, 'yellow', 'ambulance'),
	(6, 'Hypertension', 400, 2500, 2, 'green', 'ambulance'),
	(7, 'Arrhythmia', 800, 6000, 2, 'yellow', 'ambulance'),
	(8, 'Heart Attack', 3000, 20000, 2, 'red', 'ambulance'),
	(9, 'Cardiac Arrest', 5000, 35000, 2, 'red', 'ambulance'),
	(10, 'Heart Failure', 2200, 14000, 2, 'yellow', 'ambulance'),
	(11, 'Broken Arm', 700, 5000, 3, 'yellow', 'ambulance'),
	(12, 'Broken Leg', 1000, 7500, 3, 'yellow', 'ambulance'),
	(13, 'Internal Bleeding', 2000, 15000, 3, 'red', 'ambulance'),
	(14, 'Gunshot Wound', 2500, 18000, 3, 'red', 'ambulance'),
	(15, 'Stab Wound', 1800, 13000, 3, 'red', 'ambulance'),
	(16, 'Burns (2nd Degree)', 1400, 9000, 3, 'yellow', 'ambulance'),
	(17, 'Burns (3rd Degree)', 2600, 20000, 3, 'red', 'ambulance'),
	(18, 'Concussion', 600, 4000, 4, 'yellow', 'ambulance'),
	(19, 'Stroke', 3500, 22000, 4, 'red', 'ambulance'),
	(20, 'Epileptic Seizure', 900, 6500, 4, 'yellow', 'ambulance'),
	(21, 'Brain Hemorrhage', 4500, 30000, 4, 'red', 'ambulance'),
	(22, 'Asthma Attack', 500, 3000, 5, 'yellow', 'ambulance'),
	(23, 'Pneumonia', 1200, 9000, 5, 'red', 'ambulance'),
	(24, 'Respiratory Failure', 4000, 26000, 5, 'red', 'ambulance'),
	(25, 'Smoke Inhalation', 1100, 7500, 5, 'yellow', 'ambulance');