-- vinewood_gangs: complete database
-- The resource creates these tables itself on first start, so importing this file is optional.
-- If you'd rather set the database up by hand, import this file once before starting the resource.
-- Every statement uses IF NOT EXISTS, so running it twice does no harm.
-- Comments in this file must not contain semicolons.

CREATE TABLE IF NOT EXISTS `vg_meta` (
    `key`   VARCHAR(64)  NOT NULL,
    `value` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- GANGS AND MEMBERS -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_gangs` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(32)  NOT NULL,
    `label`       VARCHAR(64)  NOT NULL,
    `colour`      VARCHAR(7)   NOT NULL DEFAULT '#FFFFFF',
    `logo_url`    VARCHAR(255) NULL DEFAULT NULL,
    `logo_status` ENUM('none','pending','approved','rejected') NOT NULL DEFAULT 'none',
    `reputation`  INT          NOT NULL DEFAULT 0,
    `heat`        DECIMAL(10,2) NOT NULL DEFAULT 0,
    `status`      ENUM('active','disbanded','suspended') NOT NULL DEFAULT 'active',
    `disbanded_at` TIMESTAMP   NULL DEFAULT NULL,
    `created_by`  VARCHAR(64)  NOT NULL,
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_gang_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_ranks` (
    `gang_id`     INT UNSIGNED NOT NULL,
    `grade`       TINYINT UNSIGNED NOT NULL,
    `label`       VARCHAR(48)  NOT NULL,
    `permissions` LONGTEXT     NOT NULL,
    `wage`        INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`gang_id`, `grade`),
    CONSTRAINT `fk_rank_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_members` (
    `citizenid`     VARCHAR(64)  NOT NULL,
    `name`          VARCHAR(64)  NULL DEFAULT NULL,
    `gang_id`       INT UNSIGNED NOT NULL,
    `grade`         TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `personal_heat` DECIMAL(10,2) NOT NULL DEFAULT 0,
    `joined_at`     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_seen`     TIMESTAMP    NULL DEFAULT NULL,
    PRIMARY KEY (`citizenid`),
    KEY `idx_member_gang` (`gang_id`),
    CONSTRAINT `fk_member_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TERRITORY -------------------------------------------------------------
-- ACTIVITY LOG ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_activity_log` (
    `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`         INT UNSIGNED  NULL DEFAULT NULL,
    `citizenid`       VARCHAR(64)   NULL DEFAULT NULL,
    `type`            VARCHAR(48)   NOT NULL,
    `zone`            VARCHAR(48)   NULL DEFAULT NULL,
    `coords`          VARCHAR(96)   NULL DEFAULT NULL,
    `influence_delta` DECIMAL(10,2) NOT NULL DEFAULT 0,
    `heat_delta`      DECIMAL(10,2) NOT NULL DEFAULT 0,
    `target_gang_id`  INT UNSIGNED  NULL DEFAULT NULL,
    `metadata`        LONGTEXT      NULL DEFAULT NULL,
    `created_at`      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_activity_gang_time` (`gang_id`, `created_at`),
    KEY `idx_activity_zone_time` (`zone`, `created_at`),
    KEY `idx_activity_type` (`type`),
    CONSTRAINT `fk_activity_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- TREASURY --------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_accounts` (
    `gang_id` INT UNSIGNED NOT NULL,
    `account` ENUM('clean','dirty') NOT NULL,
    `balance` BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`gang_id`, `account`),
    CONSTRAINT `chk_balance_positive` CHECK (`balance` >= 0),
    CONSTRAINT `fk_account_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_transactions` (
    `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`        INT UNSIGNED NOT NULL,
    `account`        ENUM('clean','dirty') NOT NULL,
    `amount`         BIGINT       NOT NULL,
    `balance_after`  BIGINT       NOT NULL,
    `type`           VARCHAR(48)  NOT NULL,
    `citizenid`      VARCHAR(64)  NULL DEFAULT NULL,
    `reference_type` VARCHAR(32)  NULL DEFAULT NULL,
    `reference_id`   VARCHAR(64)  NULL DEFAULT NULL,
    `note`           VARCHAR(255) NULL DEFAULT NULL,
    `flagged`        TINYINT(1)   NOT NULL DEFAULT 0,
    `created_at`     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_tx_gang_time` (`gang_id`, `created_at`),
    KEY `idx_tx_flagged` (`flagged`, `created_at`),
    CONSTRAINT `fk_tx_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_debts` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`       INT UNSIGNED NOT NULL,
    `creditor_type` ENUM('gang','contact','player') NOT NULL,
    `creditor_id`   VARCHAR(64)  NOT NULL,
    `principal`     BIGINT       NOT NULL,
    `outstanding`   BIGINT       NOT NULL,
    `interest_bp`   SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `due_at`        DATETIME     NULL DEFAULT NULL,
    `status`        ENUM('open','paid','defaulted','forgiven') NOT NULL DEFAULT 'open',
    `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_debt_gang_status` (`gang_id`, `status`),
    CONSTRAINT `fk_debt_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- POLICE INTELLIGENCE ---------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_intel_leads` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`     INT UNSIGNED NULL DEFAULT NULL,
    `citizenid`   VARCHAR(64)  NULL DEFAULT NULL,
    `source`      ENUM('heat','witness','informant','financial','surveillance','event') NOT NULL,
    `zone`        VARCHAR(48)  NULL DEFAULT NULL,
    `precision`   ENUM('vague','area','exact') NOT NULL DEFAULT 'vague',
    `summary`     VARCHAR(255) NOT NULL,
    `data`        LONGTEXT     NULL DEFAULT NULL,
    `status`      ENUM('open','assigned','actioned','closed','expired') NOT NULL DEFAULT 'open',
    `assigned_to` VARCHAR(64)  NULL DEFAULT NULL,
    `expires_at`  DATETIME     NOT NULL,
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_lead_status_expiry` (`status`, `expires_at`),
    KEY `idx_lead_gang` (`gang_id`),
    CONSTRAINT `fk_lead_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DIPLOMACY AND CONTACTS ------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_relations` (
    `gang_a`     INT UNSIGNED NOT NULL,
    `gang_b`     INT UNSIGNED NOT NULL,
    `state`      ENUM('neutral','allied','ceasefire','trade','rival','war') NOT NULL DEFAULT 'neutral',
    `trust`      SMALLINT     NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`gang_a`, `gang_b`),
    CONSTRAINT `chk_relation_order` CHECK (`gang_a` < `gang_b`),
    CONSTRAINT `fk_rel_a` FOREIGN KEY (`gang_a`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_rel_b` FOREIGN KEY (`gang_b`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_agreements` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_a`      INT UNSIGNED NOT NULL,
    `gang_b`      INT UNSIGNED NOT NULL,
    `type`        ENUM('alliance','ceasefire','trade','neutral_zone','non_aggression') NOT NULL,
    `terms`       LONGTEXT     NULL DEFAULT NULL,
    `status`      ENUM('proposed','active','expired','broken','rejected','cancelled') NOT NULL DEFAULT 'proposed',
    `proposed_by` VARCHAR(64)  NOT NULL,
    `signed_at`   DATETIME     NULL DEFAULT NULL,
    `expires_at`  DATETIME     NULL DEFAULT NULL,
    `broken_by`   INT UNSIGNED NULL DEFAULT NULL,
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_agreement_status` (`status`),
    KEY `idx_agreement_pair` (`gang_a`, `gang_b`),
    CONSTRAINT `fk_agr_a` FOREIGN KEY (`gang_a`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_agr_b` FOREIGN KEY (`gang_b`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_contacts` (
    `gang_id`     INT UNSIGNED NOT NULL,
    `contact`     VARCHAR(48)  NOT NULL,
    `trust`       INT          NOT NULL DEFAULT 0,
    `tier`        TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `last_job_at` DATETIME     NULL DEFAULT NULL,
    PRIMARY KEY (`gang_id`, `contact`),
    CONSTRAINT `fk_contact_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CONTRACTS -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_contracts` (
    `id`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `template`       VARCHAR(48)  NOT NULL,
    `gang_id`        INT UNSIGNED NULL DEFAULT NULL,
    `issued_by`      VARCHAR(48)  NULL DEFAULT NULL,
    `status`         ENUM('available','accepted','completed','failed','expired') NOT NULL DEFAULT 'available',
    `difficulty`     TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `reward`         BIGINT       NOT NULL DEFAULT 0,
    `reward_account` ENUM('clean','dirty') NOT NULL DEFAULT 'dirty',
    `data`           LONGTEXT     NULL DEFAULT NULL,
    `accepted_by`    VARCHAR(64)  NULL DEFAULT NULL,
    `expires_at`     DATETIME     NOT NULL,
    `accepted_at`    DATETIME     NULL DEFAULT NULL,
    `completed_at`   DATETIME     NULL DEFAULT NULL,
    `created_at`     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_contract_board` (`status`, `expires_at`),
    KEY `idx_contract_gang` (`gang_id`, `status`),
    CONSTRAINT `fk_contract_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- GRAFFITI --------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_tag_designs` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`     INT UNSIGNED NOT NULL,
    `name`        VARCHAR(48)  NOT NULL,
    `design`      LONGTEXT     NOT NULL,
    `status`      ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
    `reviewed_by` VARCHAR(64)  NULL DEFAULT NULL,
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_design_gang` (`gang_id`, `status`),
    CONSTRAINT `fk_design_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_graffiti` (
    `id`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`        INT UNSIGNED NOT NULL,
    `design_id`      INT UNSIGNED NOT NULL,
    `zone`           VARCHAR(48)  NULL DEFAULT NULL,
    `placement`      VARCHAR(255) NOT NULL,
    `progress`       TINYINT UNSIGNED NOT NULL DEFAULT 100,
    `status`         ENUM('active','crossed','removed') NOT NULL DEFAULT 'active',
    `crossed_by`     INT UNSIGNED NULL DEFAULT NULL,
    `created_by`     VARCHAR(64)  NOT NULL,
    `created_at`     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_graffiti_zone` (`zone`, `status`),
    KEY `idx_graffiti_gang` (`gang_id`),
    CONSTRAINT `fk_graffiti_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_graffiti_design` FOREIGN KEY (`design_id`) REFERENCES `vg_tag_designs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- AREAS DRAWN IN GAME ---------------------------------------------------
-- PROTECTION RACKETS ----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_rackets` (
    `business`       VARCHAR(48)  NOT NULL,
    `gang_id`        INT UNSIGNED NULL DEFAULT NULL,
    `owed`           INT UNSIGNED NOT NULL DEFAULT 0,
    `since`          INT UNSIGNED NOT NULL DEFAULT 0,
    `last_accrual`   INT UNSIGNED NOT NULL DEFAULT 0,
    `last_collected` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`business`),
    KEY `idx_racket_gang` (`gang_id`),
    CONSTRAINT `fk_racket_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SAFEHOUSES ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_safehouses` (
    `id`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`          VARCHAR(64)  NOT NULL,
    `address`        VARCHAR(128) NOT NULL,
    `points`         LONGTEXT     NOT NULL,
    `price`          INT UNSIGNED NOT NULL DEFAULT 0,
    `upkeep`         INT UNSIGNED NOT NULL DEFAULT 0,
    `gang_id`        INT UNSIGNED NULL DEFAULT NULL,
    `paid_until`     INT UNSIGNED NOT NULL DEFAULT 0,
    `upgrades`       LONGTEXT     NULL DEFAULT NULL,
    `breached_until` INT UNSIGNED NOT NULL DEFAULT 0,
    `created_by`     VARCHAR(64)  NULL DEFAULT NULL,
    `created_at`     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_safehouse_gang` (`gang_id`),
    CONSTRAINT `fk_safehouse_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BUSINESSES AND SUPPLY -------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_enterprises` (
    `id`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`      INT UNSIGNED NOT NULL,
    `safehouse_id` INT UNSIGNED NOT NULL,
    `type`         VARCHAR(32)  NOT NULL,
    `level`        TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `staff`        TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `supplies`     INT UNSIGNED NOT NULL DEFAULT 0,
    `product`      INT UNSIGNED NOT NULL DEFAULT 0,
    `distribute`   TINYINT(1)   NOT NULL DEFAULT 0,
    `last_tick`    INT UNSIGNED NOT NULL DEFAULT 0,
    `created_at`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_enterprise_safehouse` (`safehouse_id`),
    KEY `idx_enterprise_gang` (`gang_id`),
    CONSTRAINT `fk_enterprise_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_enterprise_safehouse` FOREIGN KEY (`safehouse_id`) REFERENCES `vg_safehouses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_shipments` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`       INT UNSIGNED NOT NULL,
    `enterprise_id` INT UNSIGNED NOT NULL,
    `amount`        INT UNSIGNED NOT NULL,
    `cost`          INT UNSIGNED NOT NULL,
    `method`        ENUM('collect','delivery') NOT NULL,
    `status`        ENUM('waiting','ready','in_transit','delivered','stolen','lost','seized','expired') NOT NULL DEFAULT 'waiting',
    `pickup`        VARCHAR(255) NULL DEFAULT NULL,
    `due_at`        INT UNSIGNED NOT NULL DEFAULT 0,
    `stolen_by`     INT UNSIGNED NULL DEFAULT NULL,
    `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_shipment_status` (`status`),
    KEY `idx_shipment_gang` (`gang_id`),
    CONSTRAINT `fk_shipment_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_shipment_enterprise` FOREIGN KEY (`enterprise_id`) REFERENCES `vg_enterprises` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- INFORMANTS ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_informants` (
    `citizenid`  VARCHAR(64)  NOT NULL,
    `code`       VARCHAR(16)  NOT NULL,
    `tips`       INT UNSIGNED NOT NULL DEFAULT 0,
    `earned`     INT UNSIGNED NOT NULL DEFAULT 0,
    `day`        INT UNSIGNED NOT NULL DEFAULT 0,
    `tips_today` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `active`     TINYINT(1)   NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`citizenid`),
    UNIQUE KEY `uq_informant_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_informant_leaks` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`    INT UNSIGNED NOT NULL,
    `kind`       VARCHAR(16)  NOT NULL,
    `detail`     VARCHAR(128) NOT NULL,
    `informant`  VARCHAR(64)  NOT NULL,
    `online`     LONGTEXT     NOT NULL,
    `reported`   TINYINT(1)   NOT NULL DEFAULT 0,
    `suspects`   LONGTEXT     NULL DEFAULT NULL,
    `created_at` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_leak_gang` (`gang_id`, `reported`),
    CONSTRAINT `fk_leak_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- BLACK MARKET ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_auctions` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `lot`        LONGTEXT     NOT NULL,
    `status`     ENUM('open','sold','unsold','awaiting_pickup','collected','lost','cancelled') NOT NULL DEFAULT 'open',
    `ends_at`    INT UNSIGNED NOT NULL,
    `top_gang`   INT UNSIGNED NULL DEFAULT NULL,
    `top_bid`    INT UNSIGNED NOT NULL DEFAULT 0,
    `bids`       INT UNSIGNED NOT NULL DEFAULT 0,
    `drop_point` VARCHAR(255) NULL DEFAULT NULL,
    `drop_until` INT UNSIGNED NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_auction_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- GANG TIERS ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_progress` (
    `gang_id`    INT UNSIGNED NOT NULL,
    `reached`    TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `stats`      LONGTEXT     NULL DEFAULT NULL,
    `rep_buffer` DECIMAL(8,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (`gang_id`),
    CONSTRAINT `fk_progress_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- MONEY LAUNDERING ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_laundering` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`    INT UNSIGNED NOT NULL,
    `method`     VARCHAR(16)  NOT NULL,
    `amount_in`  INT UNSIGNED NOT NULL,
    `amount_out` INT UNSIGNED NOT NULL,
    `ready_at`   INT UNSIGNED NOT NULL,
    `status`     ENUM('washing','done','cancelled') NOT NULL DEFAULT 'washing',
    `citizenid`  VARCHAR(64)  NULL DEFAULT NULL,
    `created_at` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_launder_gang` (`gang_id`, `status`),
    CONSTRAINT `fk_launder_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CONTRACT SPOTS ADDED IN GAME ------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_contract_spots` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `pool`       ENUM('general','vehicles','debtors') NOT NULL,
    `label`      VARCHAR(64)  NOT NULL,
    `x`          DECIMAL(9,2) NOT NULL,
    `y`          DECIMAL(9,2) NOT NULL,
    `z`          DECIMAL(9,2) NOT NULL,
    `w`          DECIMAL(6,2) NOT NULL DEFAULT 0,
    `created_by` VARCHAR(64)  NULL DEFAULT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RACKET SHOPS ADDED IN GAME --------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_racket_shops` (
    `shop`       VARCHAR(48)  NOT NULL,
    `label`      VARCHAR(64)  NOT NULL,
    `income`     INT UNSIGNED NOT NULL DEFAULT 300,
    `x`          DECIMAL(9,2) NOT NULL,
    `y`          DECIMAL(9,2) NOT NULL,
    `z`          DECIMAL(9,2) NOT NULL,
    `created_by` VARCHAR(64)  NULL DEFAULT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`shop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- HEISTS ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_heists` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`      VARCHAR(64)  NOT NULL,
    `kind`       VARCHAR(16)  NOT NULL DEFAULT 'custom',
    `enabled`    TINYINT(1)   NOT NULL DEFAULT 0,
    `data`       LONGTEXT     NOT NULL,
    `next_at`    INT UNSIGNED NOT NULL DEFAULT 0,
    `created_by` VARCHAR(64)  NULL DEFAULT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_heist_runs` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `heist_id`   INT UNSIGNED NOT NULL,
    `gang_id`    INT UNSIGNED NOT NULL,
    `status`     ENUM('running','done','failed','cancelled') NOT NULL DEFAULT 'running',
    `loot`       INT UNSIGNED NOT NULL DEFAULT 0,
    `started_by` VARCHAR(64)  NULL DEFAULT NULL,
    `started_at` INT UNSIGNED NOT NULL,
    `ended_at`   INT UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_heist_runs_gang` (`gang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SETTINGS CHANGED IN GAME ---------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_settings` (
    `key`        VARCHAR(48) NOT NULL,
    `value`      LONGTEXT    NOT NULL,
    `updated_by` VARCHAR(64) NULL DEFAULT NULL,
    `updated_at` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- HEX TERRITORY --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `vg_hexes` (
    `hex_key`    VARCHAR(24)   NOT NULL,
    `gang_id`    INT UNSIGNED  NOT NULL,
    `control`    DECIMAL(6,2)  NOT NULL DEFAULT 0,
    `is_main`    TINYINT(1)    NOT NULL DEFAULT 0,
    `compound`   TINYINT(1)    NOT NULL DEFAULT 0,
    `claimed_at` INT UNSIGNED  NOT NULL,
    PRIMARY KEY (`hex_key`),
    KEY `idx_hexes_gang` (`gang_id`),
    CONSTRAINT `fk_hexes_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_hex_reveals` (
    `gang_id`     INT UNSIGNED NOT NULL,
    `hex_key`     VARCHAR(24)  NOT NULL,
    `revealed_at` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`gang_id`, `hex_key`),
    CONSTRAINT `fk_hex_reveals_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Marks the schema as current so the resource doesn't try to set it up again
INSERT IGNORE INTO `vg_meta` (`key`, `value`) VALUES ('schema_version', '18');
