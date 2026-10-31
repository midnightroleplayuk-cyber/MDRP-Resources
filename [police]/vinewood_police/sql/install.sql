-- Vinewood Police Operations 1.1.0: every table in one file.
-- You don't need to import this: the resource creates its tables on start (sql/migrations).
-- It's here if you'd rather import by hand on a NEW database (014 adds columns, so don't re-run it on an existing one).

-- ===== 001_core.sql =====
-- vinewood_police 001_core: officers, qualifications, persistent player state, audit log.
-- Applied automatically on first start. Safe to run by hand (every statement is IF NOT EXISTS).

CREATE TABLE IF NOT EXISTS `vpo_officers` (
    `identifier`    VARCHAR(64)  NOT NULL,
    `display_name`  VARCHAR(100) DEFAULT NULL,
    `collar_number` VARCHAR(10)  DEFAULT NULL,
    `callsign`      VARCHAR(16)  DEFAULT NULL,
    `created_at`    INT UNSIGNED NOT NULL,
    `updated_at`    INT UNSIGNED NOT NULL,
    PRIMARY KEY (`identifier`),
    UNIQUE KEY `uq_vpo_officers_collar` (`collar_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_qualifications` (
    `id`              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`      VARCHAR(64)  NOT NULL,
    `qualification`   VARCHAR(32)  NOT NULL,
    `granted_by`      VARCHAR(64)  DEFAULT NULL,
    `granted_by_name` VARCHAR(100) DEFAULT NULL,
    `granted_at`      INT UNSIGNED NOT NULL,
    `expires_at`      INT UNSIGNED DEFAULT NULL,
    `notes`           VARCHAR(255) DEFAULT NULL,
    `revoked_at`      INT UNSIGNED DEFAULT NULL,
    `revoked_by`      VARCHAR(100) DEFAULT NULL,
    `revoke_reason`   VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_qual_officer` (`identifier`, `qualification`, `revoked_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_player_state` (
    `identifier` VARCHAR(64)     NOT NULL,
    `state_key`  VARCHAR(32)     NOT NULL,
    `value`      TEXT            DEFAULT NULL,
    `seq`        BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` INT UNSIGNED    NOT NULL,
    PRIMARY KEY (`identifier`, `state_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_audit` (
    `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `created_at`       INT UNSIGNED    NOT NULL,
    `action`           VARCHAR(64)     NOT NULL,
    `source`           VARCHAR(64)     NOT NULL,
    `actor_identifier` VARCHAR(64)     DEFAULT NULL,
    `actor_name`       VARCHAR(100)    DEFAULT NULL,
    `target_type`      VARCHAR(32)     DEFAULT NULL,
    `target_id`        VARCHAR(64)     DEFAULT NULL,
    `previous_value`   TEXT            DEFAULT NULL,
    `new_value`        TEXT            DEFAULT NULL,
    `reason`           VARCHAR(500)    DEFAULT NULL,
    `meta`             TEXT            DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_audit_time` (`created_at`),
    KEY `idx_vpo_audit_action` (`action`, `created_at`),
    KEY `idx_vpo_audit_actor` (`actor_identifier`, `created_at`),
    KEY `idx_vpo_audit_target` (`target_type`, `target_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 002_duty.sql =====
-- vinewood_police 002_duty: duty sessions, pocket notebook, equipment issue log.

CREATE TABLE IF NOT EXISTS `vpo_duty_sessions` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`  VARCHAR(64)  NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    `callsign`    VARCHAR(16)  DEFAULT NULL,
    `collar`      VARCHAR(10)  DEFAULT NULL,
    `unit`        VARCHAR(32)  DEFAULT NULL,
    `vehicle`     VARCHAR(24)  DEFAULT NULL,
    `station`     VARCHAR(32)  DEFAULT NULL,
    `started_at`  INT UNSIGNED NOT NULL,
    `ended_at`    INT UNSIGNED DEFAULT NULL,
    `end_reason`  VARCHAR(32)  DEFAULT NULL,
    `report`      TEXT         DEFAULT NULL,
    `stats`       TEXT         DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_duty_officer` (`identifier`, `started_at`),
    KEY `idx_vpo_duty_open` (`ended_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_notebook` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`  VARCHAR(64)  NOT NULL,
    `session_id`  INT UNSIGNED DEFAULT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `text`        TEXT         NOT NULL,
    `ref`         VARCHAR(32)  DEFAULT NULL,
    `corrects_id` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_notebook_officer` (`identifier`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_equipment_issue` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`    VARCHAR(64)  NOT NULL,
    `session_id`    INT UNSIGNED DEFAULT NULL,
    `item`          VARCHAR(64)  NOT NULL,
    `label`         VARCHAR(64)  DEFAULT NULL,
    `count`         INT UNSIGNED NOT NULL DEFAULT 1,
    `serial`        VARCHAR(32)  DEFAULT NULL,
    `issued_at`     INT UNSIGNED NOT NULL,
    `returned_at`   INT UNSIGNED DEFAULT NULL,
    `return_reason` VARCHAR(32)  DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_equipment_out` (`identifier`, `returned_at`),
    UNIQUE KEY `uq_vpo_equipment_serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 003_arrests.sql =====
-- vinewood_police 003_arrests: arrests and stop and search. When vinewood-mdt is running these
-- hold the MDT's reference too, so the custody suite (phase 3) can find the record either way.

CREATE TABLE IF NOT EXISTS `vpo_arrests` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(32)  DEFAULT NULL,
    `identifier`         VARCHAR(64)  NOT NULL,
    `subject_name`       VARCHAR(100) DEFAULT NULL,
    `offences`           TEXT         NOT NULL,
    `grounds`            TEXT         NOT NULL,
    `necessity`          TEXT         DEFAULT NULL,
    `cautioned`          TINYINT(1)   NOT NULL DEFAULT 0,
    `incident_ref`       VARCHAR(32)  DEFAULT NULL,
    `mdt_record_id`      INT UNSIGNED DEFAULT NULL,
    `mdt_incident_id`    INT UNSIGNED DEFAULT NULL,
    `location`           VARCHAR(160) DEFAULT NULL,
    `coords`             VARCHAR(100) DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `created_at`         INT UNSIGNED NOT NULL,
    `released_at`        INT UNSIGNED DEFAULT NULL,
    `release_reason`     VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_arrests_person` (`identifier`, `created_at`),
    KEY `idx_vpo_arrests_ref` (`ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_stop_search` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(32)  DEFAULT NULL,
    `identifier`         VARCHAR(64)  DEFAULT NULL,
    `subject_name`       VARCHAR(100) DEFAULT NULL,
    `power`              VARCHAR(32)  NOT NULL,
    `authorisation`      VARCHAR(160) DEFAULT NULL,
    `object`             VARCHAR(64)  NOT NULL,
    `grounds`            TEXT         DEFAULT NULL,
    `found`              TEXT         DEFAULT NULL,
    `outcome`            VARCHAR(64)  NOT NULL,
    `location`           VARCHAR(160) DEFAULT NULL,
    `coords`             VARCHAR(100) DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `created_at`         INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_ss_person` (`identifier`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 004_roads.sql =====
-- vinewood_police 004_roads: vehicle stops.

CREATE TABLE IF NOT EXISTS `vpo_traffic_stops` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(32)  DEFAULT NULL,
    `plate`              VARCHAR(12)  NOT NULL,
    `model`              VARCHAR(64)  DEFAULT NULL,
    `driver_identifier`  VARCHAR(64)  DEFAULT NULL,
    `driver_name`        VARCHAR(100) DEFAULT NULL,
    `npc`                TINYINT(1)   NOT NULL DEFAULT 0,
    `reason`             VARCHAR(64)  DEFAULT NULL,
    `outcome`            VARCHAR(64)  DEFAULT NULL,
    `notes`              TEXT         DEFAULT NULL,
    `checks`             TEXT         DEFAULT NULL,
    `tickets`            TEXT         DEFAULT NULL,
    `location`           VARCHAR(160) DEFAULT NULL,
    `coords`             VARCHAR(100) DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `started_at`         INT UNSIGNED NOT NULL,
    `ended_at`           INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_ts_plate` (`plate`, `started_at`),
    KEY `idx_vpo_ts_driver` (`driver_identifier`, `started_at`),
    KEY `idx_vpo_ts_officer` (`officer_identifier`, `started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 005_npc.sql =====
-- vinewood_police 005_npc: generated NPC people and vehicles.

CREATE TABLE IF NOT EXISTS `vpo_npc_people` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `firstname`   VARCHAR(40)  NOT NULL,
    `lastname`    VARCHAR(40)  NOT NULL,
    `dob`         VARCHAR(10)  NOT NULL,
    `sex`         CHAR(1)      NOT NULL,
    `address`     VARCHAR(160) DEFAULT NULL,
    `licence`     VARCHAR(16)  NOT NULL,
    `points`      TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `wanted`      VARCHAR(160) DEFAULT NULL,
    `prior_record` TINYINT(1)  NOT NULL DEFAULT 0,
    `traits`      TEXT         DEFAULT NULL,
    `keep`        TINYINT(1)   NOT NULL DEFAULT 0,
    `created_at`  INT UNSIGNED NOT NULL,
    `last_seen`   INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_npcp_name` (`lastname`, `firstname`, `dob`),
    KEY `idx_vpo_npcp_seen` (`keep`, `last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_npc_vehicles` (
    `plate`       VARCHAR(12)  NOT NULL,
    `model`       VARCHAR(32)  DEFAULT NULL,
    `keeper_id`   INT UNSIGNED DEFAULT NULL,
    `keeper_type` VARCHAR(16)  NOT NULL,
    `keeper_name` VARCHAR(100) DEFAULT NULL,
    `driver_id`   INT UNSIGNED DEFAULT NULL,
    `insurance`   VARCHAR(16)  NOT NULL,
    `mot`         VARCHAR(16)  NOT NULL,
    `tax`         VARCHAR(16)  NOT NULL,
    `stolen`      TINYINT(1)   NOT NULL DEFAULT 0,
    `defect`      VARCHAR(80)  DEFAULT NULL,
    `keep`        TINYINT(1)   NOT NULL DEFAULT 0,
    `created_at`  INT UNSIGNED NOT NULL,
    `last_seen`   INT UNSIGNED NOT NULL,
    PRIMARY KEY (`plate`),
    KEY `idx_vpo_npcv_seen` (`keep`, `last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 006_roadside.sql =====
-- vinewood_police 006_roadside: vehicle seizures.

CREATE TABLE IF NOT EXISTS `vpo_vehicle_seizures` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(32)  DEFAULT NULL,
    `stop_id`            INT UNSIGNED DEFAULT NULL,
    `plate`              VARCHAR(12)  NOT NULL,
    `model`              VARCHAR(64)  DEFAULT NULL,
    `npc`                TINYINT(1)   NOT NULL DEFAULT 0,
    `power`              VARCHAR(16)  NOT NULL,
    `reason`             TEXT         NOT NULL,
    `driver_name`        VARCHAR(100) DEFAULT NULL,
    `location`           VARCHAR(160) DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `status`             VARCHAR(24)  NOT NULL DEFAULT 'awaiting_recovery',
    `created_at`         INT UNSIGNED NOT NULL,
    `recovered_at`       INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_seiz_plate` (`plate`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 007_custody.sql =====
-- vinewood_police 007_custody: custody suite detention and the custody log.

CREATE TABLE IF NOT EXISTS `vpo_custody` (
    `arrest_id`       INT UNSIGNED NOT NULL,
    `identifier`      VARCHAR(64)  NOT NULL,
    `subject_name`    VARCHAR(100) DEFAULT NULL,
    `suite`           VARCHAR(32)  DEFAULT NULL,
    `booked_at`       INT UNSIGNED DEFAULT NULL,
    `booked_by`       VARCHAR(120) DEFAULT NULL,
    `grounds`         VARCHAR(160) DEFAULT NULL,
    `risk`            VARCHAR(16)  DEFAULT NULL,
    `observation`     TINYINT UNSIGNED DEFAULT NULL,
    `property_stash`  VARCHAR(64)  DEFAULT NULL,
    `property_status` VARCHAR(16)  NOT NULL DEFAULT 'none',
    `released_at`     INT UNSIGNED DEFAULT NULL,
    `outcome`         VARCHAR(64)  DEFAULT NULL,
    PRIMARY KEY (`arrest_id`),
    KEY `idx_vpo_custody_person` (`identifier`, `property_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_custody_log` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `arrest_id`   INT UNSIGNED NOT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `kind`        VARCHAR(24)  NOT NULL,
    `text`        TEXT         NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_clog_arrest` (`arrest_id`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 008_npc_custody.sql =====
-- vinewood_police 008_npc_custody: NPC detainees and exhibits kept by vinewood_police.

CREATE TABLE IF NOT EXISTS `vpo_npc_custody` (
    `arrest_id`     INT UNSIGNED NOT NULL,
    `ref`           VARCHAR(32)  DEFAULT NULL,
    `person_id`     INT UNSIGNED DEFAULT NULL,
    `name`          VARCHAR(100) DEFAULT NULL,
    `model`         BIGINT       DEFAULT NULL,
    `suite`         VARCHAR(32)  NOT NULL,
    `status`        VARCHAR(16)  NOT NULL DEFAULT 'awaiting',
    `offences`      TEXT         DEFAULT NULL,
    `arrested_by`   VARCHAR(120) DEFAULT NULL,
    `arrested_at`   INT UNSIGNED NOT NULL,
    `stop_ref`      VARCHAR(32)  DEFAULT NULL,
    `evidence`      TEXT         DEFAULT NULL,
    `booked_at`     INT UNSIGNED DEFAULT NULL,
    `booked_by`     VARCHAR(120) DEFAULT NULL,
    `grounds`       VARCHAR(160) DEFAULT NULL,
    `risk`          VARCHAR(16)  DEFAULT NULL,
    `observation`   TINYINT UNSIGNED DEFAULT NULL,
    `cell`          VARCHAR(16)  DEFAULT NULL,
    `out_reason`    VARCHAR(48)  DEFAULT NULL,
    `next_welfare`  INT UNSIGNED DEFAULT NULL,
    `interview`     TEXT         DEFAULT NULL,
    `outcome`       VARCHAR(64)  DEFAULT NULL,
    `released_at`   INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`arrest_id`),
    KEY `idx_vpo_npcc_open` (`status`, `suite`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_exhibits` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(16)  NOT NULL,
    `description`        VARCHAR(255) NOT NULL,
    `type`               VARCHAR(48)  DEFAULT NULL,
    `from_name`          VARCHAR(100) DEFAULT NULL,
    `from_identifier`    VARCHAR(64)  DEFAULT NULL,
    `linked_ref`         VARCHAR(32)  DEFAULT NULL,
    `stash`              VARCHAR(64)  DEFAULT NULL,
    `items`              TEXT         DEFAULT NULL,
    `status`             VARCHAR(16)  NOT NULL DEFAULT 'seized',
    `continuity`         TEXT         DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `created_at`         INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_exh_ref` (`ref`),
    KEY `idx_vpo_exh_linked` (`linked_ref`),
    KEY `idx_vpo_exh_officer` (`officer_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 009_callouts.sql =====
-- vinewood_police 009_callouts: calls created by the callout engine.

CREATE TABLE IF NOT EXISTS `vpo_callouts` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`           VARCHAR(32)  DEFAULT NULL,
    `scenario`      VARCHAR(32)  NOT NULL,
    `title`         VARCHAR(120) NOT NULL,
    `location`      VARCHAR(160) DEFAULT NULL,
    `coords`        VARCHAR(100) DEFAULT NULL,
    `priority`      TINYINT UNSIGNED NOT NULL DEFAULT 3,
    `status`        VARCHAR(16)  NOT NULL DEFAULT 'pending',
    `outcome`       VARCHAR(64)  DEFAULT NULL,
    `notes`         TEXT         DEFAULT NULL,
    `officers`      TEXT         DEFAULT NULL,
    `mdt_incident`  VARCHAR(32)  DEFAULT NULL,
    `created_at`    INT UNSIGNED NOT NULL,
    `attended_at`   INT UNSIGNED DEFAULT NULL,
    `closed_at`     INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_callouts_status` (`status`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 010_locations.sql =====
-- vinewood_police 010_locations: places set in game with the location editor (override the config).

CREATE TABLE IF NOT EXISTS `vpo_locations` (
    `key`        VARCHAR(32)  NOT NULL,
    `data`       MEDIUMTEXT   NOT NULL,
    `updated_at` INT UNSIGNED NOT NULL,
    `updated_by` VARCHAR(120) DEFAULT NULL,
    PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 011_armoury.sql =====
-- vinewood_police 011_armoury: rounds not handed back (discharges) for review.

CREATE TABLE IF NOT EXISTS `vpo_discharges` (
    `id`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`   VARCHAR(64)  NOT NULL,
    `officer_name` VARCHAR(120) DEFAULT NULL,
    `session_id`   INT UNSIGNED DEFAULT NULL,
    `station`      VARCHAR(64)  DEFAULT NULL,
    `ammo`         VARCHAR(64)  NOT NULL,
    `label`        VARCHAR(64)  DEFAULT NULL,
    `rounds`       INT UNSIGNED NOT NULL,
    `account`      TEXT         DEFAULT NULL,
    `unaccounted`  TINYINT(1)   NOT NULL DEFAULT 0,
    `reviewed_by`  VARCHAR(120) DEFAULT NULL,
    `reviewed_at`  INT UNSIGNED DEFAULT NULL,
    `created_at`   INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_discharges_officer` (`identifier`, `created_at`),
    KEY `idx_vpo_discharges_review` (`reviewed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 012_incidents_cid.sql =====
-- vinewood_police 012_incidents_cid: major incidents (cordons, scene log) and CID case files.

CREATE TABLE IF NOT EXISTS `vpo_incidents` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`         VARCHAR(32)  DEFAULT NULL,
    `type`        VARCHAR(48)  NOT NULL,
    `label`       VARCHAR(120) NOT NULL,
    `coords`      VARCHAR(100) NOT NULL,
    `inner_r`     SMALLINT UNSIGNED NOT NULL,
    `outer_r`     SMALLINT UNSIGNED NOT NULL,
    `status`      VARCHAR(16)  NOT NULL DEFAULT 'active',
    `linked`      VARCHAR(160) DEFAULT NULL,
    `roles`       TEXT         DEFAULT NULL,
    `declared_by` VARCHAR(120) DEFAULT NULL,
    `summary`     TEXT         DEFAULT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `closed_at`   INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_incidents_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_incident_log` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `incident_id` INT UNSIGNED NOT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `kind`        VARCHAR(24)  NOT NULL,
    `text`        TEXT         NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_ilog` (`incident_id`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_cases` (
    `id`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`            VARCHAR(32)  DEFAULT NULL,
    `title`          VARCHAR(160) NOT NULL,
    `type`           VARCHAR(48)  DEFAULT NULL,
    `status`         VARCHAR(32)  NOT NULL DEFAULT 'Open',
    `oic_identifier` VARCHAR(64)  DEFAULT NULL,
    `oic_name`       VARCHAR(120) DEFAULT NULL,
    `summary`        TEXT         DEFAULT NULL,
    `links`          TEXT         DEFAULT NULL,
    `people`         TEXT         DEFAULT NULL,
    `created_by`     VARCHAR(120) DEFAULT NULL,
    `created_at`     INT UNSIGNED NOT NULL,
    `updated_at`     INT UNSIGNED NOT NULL,
    `closed_at`      INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_cases_status` (`status`, `updated_at`),
    KEY `idx_vpo_cases_oic` (`oic_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_case_entries` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `case_id`     INT UNSIGNED NOT NULL,
    `kind`        VARCHAR(16)  NOT NULL,
    `text`        TEXT         NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    `assigned_identifier` VARCHAR(64) DEFAULT NULL,
    `assigned_name` VARCHAR(120) DEFAULT NULL,
    `done_at`     INT UNSIGNED DEFAULT NULL,
    `done_by`     VARCHAR(120) DEFAULT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_case_entries` (`case_id`, `kind`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 013_standards.sql =====
-- vinewood_police 013_standards: use of force forms and public complaints.

CREATE TABLE IF NOT EXISTS `vpo_uof` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`  VARCHAR(64)  NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    `status`      VARCHAR(16)  NOT NULL DEFAULT 'pending',
    `trigger`     VARCHAR(64)  DEFAULT NULL,
    `subject`     VARCHAR(120) DEFAULT NULL,
    `linked_ref`  VARCHAR(32)  DEFAULT NULL,
    `tactics`     TEXT         DEFAULT NULL,
    `reasons`     TEXT         DEFAULT NULL,
    `subject_injured` TINYINT(1) DEFAULT NULL,
    `officer_injured` TINYINT(1) DEFAULT NULL,
    `narrative`   TEXT         DEFAULT NULL,
    `location`    VARCHAR(160) DEFAULT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `submitted_at` INT UNSIGNED DEFAULT NULL,
    `reviewed_by` VARCHAR(120) DEFAULT NULL,
    `review_note` VARCHAR(500) DEFAULT NULL,
    `reviewed_at` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_uof_officer` (`identifier`, `status`),
    KEY `idx_vpo_uof_review` (`status`, `reviewed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_complaints` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`           VARCHAR(32)  DEFAULT NULL,
    `complainant`   VARCHAR(100) DEFAULT NULL,
    `complainant_identifier` VARCHAR(64) DEFAULT NULL,
    `officer_text`  VARCHAR(120) DEFAULT NULL,
    `officer_identifier` VARCHAR(64) DEFAULT NULL,
    `officer_name`  VARCHAR(120) DEFAULT NULL,
    `happened`      VARCHAR(120) DEFAULT NULL,
    `category`      VARCHAR(48)  DEFAULT NULL,
    `details`       TEXT         NOT NULL,
    `status`        VARCHAR(24)  NOT NULL DEFAULT 'Received',
    `investigator`  VARCHAR(120) DEFAULT NULL,
    `outcome`       VARCHAR(64)  DEFAULT NULL,
    `notes`         TEXT         DEFAULT NULL,
    `created_at`    INT UNSIGNED NOT NULL,
    `updated_at`    INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_complaints_status` (`status`),
    KEY `idx_vpo_complaints_officer` (`officer_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===== 014_management.sql =====
-- vinewood_police 014_management: suspension from duty.
ALTER TABLE `vpo_officers`
    ADD COLUMN `suspended_at` INT UNSIGNED DEFAULT NULL,
    ADD COLUMN `suspended_reason` VARCHAR(255) DEFAULT NULL,
    ADD COLUMN `suspended_by` VARCHAR(120) DEFAULT NULL;

-- Mark the migrations as applied so the resource doesn't run them again
CREATE TABLE IF NOT EXISTS `vpo_schema_migrations` (`id` VARCHAR(64) NOT NULL PRIMARY KEY, `applied_at` INT UNSIGNED NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT IGNORE INTO `vpo_schema_migrations` (`id`, `applied_at`) VALUES ('001_core', UNIX_TIMESTAMP()), ('002_duty', UNIX_TIMESTAMP()), ('003_arrests', UNIX_TIMESTAMP()), ('004_roads', UNIX_TIMESTAMP()), ('005_npc', UNIX_TIMESTAMP()), ('006_roadside', UNIX_TIMESTAMP()), ('007_custody', UNIX_TIMESTAMP()), ('008_npc_custody', UNIX_TIMESTAMP()), ('009_callouts', UNIX_TIMESTAMP()), ('010_locations', UNIX_TIMESTAMP()), ('011_armoury', UNIX_TIMESTAMP()), ('012_incidents_cid', UNIX_TIMESTAMP()), ('013_standards', UNIX_TIMESTAMP()), ('014_management', UNIX_TIMESTAMP());
