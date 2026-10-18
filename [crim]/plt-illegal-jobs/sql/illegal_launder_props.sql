CREATE TABLE IF NOT EXISTS `illegal_launder_props` (
    `id`            INT AUTO_INCREMENT PRIMARY KEY,
    `owner_id`      VARCHAR(64) NOT NULL,
    `owner_type`    ENUM('player','group') DEFAULT 'player',
    `prop_type`     VARCHAR(32) NOT NULL,
    `item_key`      VARCHAR(64) NOT NULL,
    `model`         VARCHAR(64) NOT NULL,
    `coords`        JSON NOT NULL,
    `heading`       FLOAT NOT NULL,
    `parent_id`     INT DEFAULT NULL,
    `money_dirty`   INT NOT NULL DEFAULT 0,
    `money_clean`   INT NOT NULL DEFAULT 0,
    `chemical_key`  VARCHAR(64) DEFAULT NULL,
    `chemical_amt`  INT NOT NULL DEFAULT 0,
    `state`         JSON NOT NULL,
    `created_at`    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_owner` (`owner_id`),
    INDEX `idx_parent` (`parent_id`)
);
