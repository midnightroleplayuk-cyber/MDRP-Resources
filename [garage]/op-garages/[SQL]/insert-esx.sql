ALTER TABLE `owned_vehicles`
    ADD COLUMN `id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
    ADD COLUMN `vehicleid` int DEFAULT NULL,
    ADD COLUMN `stored` int(11) DEFAULT 0,
    ADD COLUMN `co_owner` varchar(255) DEFAULT NULL,
    ADD COLUMN `co_owner_name` varchar(255) DEFAULT NULL,
    ADD COLUMN `retrievable` tinyint(1) DEFAULT 1,
    ADD COLUMN `towedPrice` int(11) DEFAULT 0,
    ADD COLUMN `towedAfterPrice` int(11) DEFAULT 0,
    ADD COLUMN `towedToDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN `towedOutBy` varchar(255) DEFAULT NULL,
    ADD COLUMN `isTowedOut` tinyint(1) DEFAULT 0,
    ADD COLUMN `vehicleGarage` int(11) DEFAULT 1,
    ADD COLUMN `vehicleImpound` int(11) DEFAULT 1,
    ADD COLUMN `impoundReason` varchar(255) DEFAULT NULL,
    ADD COLUMN `job` varchar(20) DEFAULT NULL,
    ADD COLUMN `gang` varchar(20) DEFAULT NULL,
    ADD COLUMN `jobGrade` int(11) DEFAULT 0,
    ADD COLUMN `jobPrivate` TEXT DEFAULT NULL,
    ADD COLUMN `gangGrade` int(11) DEFAULT 0,
    ADD COLUMN `gangPrivate` TEXT DEFAULT NULL,
    ADD COLUMN `gangLocked` varchar(20) DEFAULT NULL,
    ADD COLUMN `jobLocked` varchar(20) DEFAULT NULL,
    ADD COLUMN `deformation` varchar(300) DEFAULT NULL,
    ADD COLUMN `fakeplate` varchar(12) DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `opgarages_garages2` (
    `Index` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `Label` VARCHAR(300) DEFAULT NULL,
    `Type` varchar(250) NOT NULL DEFAULT 'car',
    `Coords` longtext NOT NULL DEFAULT '{"CenterOfZone":[{"z": 0,"y": 0,"x": 0,"w": 0}],"AccessPoint": {"z": 0,"y": 0,"x": 0,"w": 0}}',
    `JobName` varchar(250) DEFAULT NULL,
    `JobGrade` int NOT NULL DEFAULT '0',
    `JobMode` VARCHAR(300) NOT NULL DEFAULT 'owned',
    `isPrivate` tinyint(1) NOT NULL DEFAULT '0',
    `privatePlayers` VARCHAR(300) NOT NULL DEFAULT '[]',
    `onespawn` VARCHAR(300) NOT NULL DEFAULT '{"z": 0,"y": 0,"x": 0,"w": 0}',
    `GangName` VARCHAR(300) DEFAULT NULL,
    `GangGrade` int(11) DEFAULT 0,
    `GangMode` VARCHAR(300) NOT NULL DEFAULT 'owned',
    `blipDisabled` tinyint DEFAULT 0,
    PRIMARY KEY (`Index`)
);

CREATE TABLE IF NOT EXISTS `opgarages_impounds` (
    `Index` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `Label` varchar(250) DEFAULT NULL,
    `Type` varchar(250) NOT NULL DEFAULT 'car',
    `Coords` VARCHAR(300) NOT NULL DEFAULT '{"z": 0,"y": 0,"x": 0,"w": 0}',
    `takeOutCoords` longtext NOT NULL DEFAULT '[]',
    `AllowedJobs` VARCHAR(300) NOT NULL DEFAULT '[]',
    `blipDisabled` tinyint DEFAULT 0,
    PRIMARY KEY (`Index`)
);

CREATE TABLE IF NOT EXISTS `opgarages_jobvehicles` (
    `index` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `model` VARCHAR(300) DEFAULT NULL,
    `job` VARCHAR(300) DEFAULT NULL,
    `gradesAllowed` VARCHAR(300) NOT NULL DEFAULT '[]',
    `properties` TEXT NOT NULL DEFAULT '{}',
    PRIMARY KEY (`index`)
);

CREATE TABLE IF NOT EXISTS `opgarages_ownedgarages` (
    `index` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `label` VARCHAR(300) DEFAULT NULL,
    `price` int(11) DEFAULT 0,
    `interiorIndex` int(11) DEFAULT 1,
    `entrance` VARCHAR(300) NOT NULL DEFAULT '{"z": 0,"y": 0,"x": 0,"w": 0}',
    `vehicleSpawn` VARCHAR(300) NOT NULL DEFAULT '{"z": 0,"y": 0,"x": 0,"w": 0}',
    `owner` VARCHAR(300) NOT NULL,
    `coOwners` VARCHAR(3000) NOT NULL DEFAULT '[]',
    `rentExpireDate` VARCHAR(300) NOT NULL DEFAULT '2026-06-01T21:59:59.207Z',
    PRIMARY KEY (`index`)
) AUTO_INCREMENT = 1500;

CREATE TABLE IF NOT EXISTS `opgarages_vehicles` (
    `model` VARCHAR(300) DEFAULT NULL,
    `label` VARCHAR(300) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `opgarages_gangvehicles` (
    `index` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `model` VARCHAR(300) DEFAULT NULL,
    `gang` VARCHAR(300) DEFAULT NULL,
    `gradesAllowed` VARCHAR(300) NOT NULL DEFAULT '[]',
    `properties` TEXT NOT NULL DEFAULT '{}',
    PRIMARY KEY (`index`)
);