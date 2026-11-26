-- Created automatically on first start. Here for reference or manual installs.
CREATE TABLE IF NOT EXISTS `rsvx_bowling_stats` (
    `citizenid` VARCHAR(64) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `games` INT NOT NULL DEFAULT 0,
    `best` INT NOT NULL DEFAULT 0,
    `total` INT NOT NULL DEFAULT 0,
    `strikes` INT NOT NULL DEFAULT 0,
    `perfect` INT NOT NULL DEFAULT 0,
    `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`citizenid`)
);
