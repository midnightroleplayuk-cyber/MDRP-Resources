CREATE TABLE IF NOT EXISTS `tk_mdt_announcements` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `message` TEXT NULL,
    `creator` VARCHAR(100) NOT NULL,
    `date` INT(11) NOT NULL,
    `pinned` BOOLEAN NOT NULL DEFAULT FALSE,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_tags` (
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `label` VARCHAR(50) NULL,
    `color` VARCHAR(10) NOT NULL,
    `minGrade` INT(10) NULL,
    `grades` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_profiles` (
    `identifier` VARCHAR(60) NOT NULL,
    `image` VARCHAR(2048) NULL,
    `notes` TEXT NULL,
    `tags` LONGTEXT NULL,
    `licenses` LONGTEXT NULL,
    `linkedProfiles` LONGTEXT NULL,
    `photos` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    UNIQUE KEY `profile` (`identifier`, `page`)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_vehicles` (
    `plate` VARCHAR(12) NOT NULL,
    `image` VARCHAR(2048) NULL,
    `notes` TEXT NULL,
    `tags` LONGTEXT NULL,
    `photos` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    UNIQUE KEY `vehicle` (`plate`, `page`)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_properties` (
    `id` INT NOT NULL,
    `image` VARCHAR(2048) NULL,
    `notes` TEXT NULL,
    `linkedProfiles` LONGTEXT NULL,
    `tags` LONGTEXT NULL,
    `photos` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    UNIQUE KEY `property` (`id`, `page`)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_businesses` (
    `name` VARCHAR(100) NOT NULL,
    `image` VARCHAR(2048) NULL,
    `notes` TEXT NULL,
    `photos` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    UNIQUE KEY `business` (`name`, `page`)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_incidents` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL,
    `creator` VARCHAR(100) NOT NULL,
    `date` INT(11) NOT NULL,
    `content` TEXT NULL,
    `tags` LONGTEXT NULL,
    `employees` LONGTEXT NULL,
    `criminals` LONGTEXT NULL,
    `civilians` LONGTEXT NULL,
    `vehicles` LONGTEXT NULL,
    `evidence` LONGTEXT NULL,
    `weapons` LONGTEXT NULL,
    `linkedIncidents` LONGTEXT NULL,
    `linkedReports` LONGTEXT NULL,
    `linkedPoliceReports` LONGTEXT NULL,
    `photos` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_reports` (
    `id` INT(10) NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL,
    `creator` VARCHAR(100) NOT NULL,
    `date` INT(11) NOT NULL,
    `content` TEXT NULL,
    `report_type` VARCHAR(100) NULL,
    `tags` LONGTEXT NULL,
    `employees` LONGTEXT NULL,
    `suspects` LONGTEXT NULL,
    `civilians` LONGTEXT NULL,
    `vehicles` LONGTEXT NULL,
    `evidence` LONGTEXT NULL,
    `weapons` LONGTEXT NULL,
    `linkedIncidents` LONGTEXT NULL,
    `linkedReports` LONGTEXT NULL,
    `linkedPoliceReports` LONGTEXT NULL,
    `photos` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_training_reports` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL,
    `creator` VARCHAR(100) NOT NULL,
    `trainee` VARCHAR(100) NULL,
    `date` INT(11) NOT NULL,
    `content` TEXT NULL,
    `data` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_police_reports` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL,
    `creator` VARCHAR(100) NULL,
    `phoneNumber` VARCHAR(100) NULL,
    `date` INT(11) NOT NULL,
    `content` TEXT NOT NULL,
    `tags` LONGTEXT NULL,
    `linkedIncidents` LONGTEXT NULL,
    `linkedReports` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_evidence` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `creator` VARCHAR(100) NOT NULL,
    `image` VARCHAR(2048) NULL,
    `date` INT(11) NOT NULL,
    `notes` TEXT NULL,
    `tags` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_weapons` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `creator` VARCHAR(100) NOT NULL,
    `owners` LONGTEXT NULL,
    `image` VARCHAR(2048) NULL,
    `date` INT(11) NOT NULL,
    `serial` VARCHAR(100) NULL,
    `notes` TEXT NULL,
    `tags` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_charges` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `class` VARCHAR(100) NOT NULL,
    `description` TEXT NULL,
    `fine` LONGTEXT NOT NULL,
    `sentence` LONGTEXT NOT NULL,
    `points` INT NULL,
    `color` VARCHAR(100) NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_legislation` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT NOT NULL,
    `date` INT(11) NOT NULL,
    `page` VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_employees` (
    `identifier` VARCHAR(60) NOT NULL,
    `image` VARCHAR(2048) NULL,
    `callsign` VARCHAR(100) NULL,
    `notes` TEXT NULL,
    `status` VARCHAR(100) NULL,
    `licenses` LONGTEXT NULL,
    `page` VARCHAR(255) NOT NULL,
    UNIQUE KEY `employee` (`identifier`, `page`)
);

CREATE TABLE IF NOT EXISTS `tk_mdt_permissions` (
    `page` VARCHAR(255) NOT NULL,
    `data` LONGTEXT NULL,
    PRIMARY KEY (page)
);