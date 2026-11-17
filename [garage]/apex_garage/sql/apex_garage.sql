-- ============================================================================
--  apex_garage — database schema (fresh install)
--  ---------------------------------------------------------------------------
--  This file mirrors, exactly, the schema that server/database.lua provisions
--  at runtime. A server that installs from this file and a server that was
--  migrated by database.lua end up with identical tables, columns, defaults,
--  indexes and key types.
--
--  SAFE TO RE-RUN. Nothing here drops, truncates or rewrites data:
--    * every table uses CREATE TABLE IF NOT EXISTS
--    * every framework-table column goes through a guarded helper that checks
--      information_schema first and skips the column if it already exists
--
--  Portability: MySQL 8 rejects "ALTER TABLE ... ADD COLUMN IF NOT EXISTS"
--  (MariaDB accepts it), so — exactly like database.lua does with its
--  SHOW COLUMNS + ADD pattern — the column adds are guarded by a lookup
--  instead of by IF NOT EXISTS. The helper procedure below is valid on both
--  MySQL 8 and MariaDB.
--
--  Requires a client that understands DELIMITER (mysql CLI, HeidiSQL,
--  phpMyAdmin, DBeaver, Navicat). See the note at the bottom if yours does not.
-- ============================================================================


-- ============================================================================
--  0. guarded column helper
--  ---------------------------------------------------------------------------
--  Adds `col` to `tbl` only when the table exists AND the column does not.
--  Both checks matter: it lets the same script run unchanged on ESX
--  (owned_vehicles) and on QBCore/QBox (player_vehicles) — the CALLs aimed at
--  the table your framework does not have simply do nothing.
-- ============================================================================

DROP PROCEDURE IF EXISTS `apex_garage_add_column`;

DELIMITER $$

CREATE PROCEDURE `apex_garage_add_column`(
    IN p_table  VARCHAR(64),
    IN p_column VARCHAR(64),
    IN p_def    VARCHAR(255)
)
BEGIN
    DECLARE v_table_exists  INT DEFAULT 0;
    DECLARE v_column_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_table_exists
      FROM information_schema.TABLES
     WHERE TABLE_SCHEMA = DATABASE()
       AND TABLE_NAME   = p_table;

    IF v_table_exists > 0 THEN
        SELECT COUNT(*) INTO v_column_exists
          FROM information_schema.COLUMNS
         WHERE TABLE_SCHEMA = DATABASE()
           AND TABLE_NAME   = p_table
           AND COLUMN_NAME  = p_column;

        IF v_column_exists = 0 THEN
            SET @apex_garage_sql = CONCAT(
                'ALTER TABLE `', p_table, '` ADD COLUMN `', p_column, '` ', p_def);
            PREPARE apex_garage_stmt FROM @apex_garage_sql;
            EXECUTE apex_garage_stmt;
            DEALLOCATE PREPARE apex_garage_stmt;
            SET @apex_garage_sql = NULL;
        END IF;
    END IF;
END $$

DELIMITER ;


-- ============================================================================
--  1. framework vehicle table columns
--  ---------------------------------------------------------------------------
--  Source of truth: vehicleColumns() in server/database.lua.
--  Applied to whichever of the two tables exists. On QBCore/QBox the
--  fuel/engine/body columns already ship with the framework, so those CALLs
--  no-op — the same way database.lua's SHOW COLUMNS check skips them.
--
--  NOTE ON `garage_id`: the DEFAULT below is 'legion', which is the shipped
--  Config.defaultGarage (shared/config.lua). database.lua bakes the *live*
--  config value into the DEFAULT. If you changed Config.defaultGarage before
--  first boot, change 'legion' here to match, in both CALLs.
-- ============================================================================

-- ---- ESX: owned_vehicles ---------------------------------------------------
CALL `apex_garage_add_column`('owned_vehicles', 'garage_id',         "VARCHAR(64) NOT NULL DEFAULT 'legion'");
CALL `apex_garage_add_column`('owned_vehicles', 'in_garage',         'TINYINT(1) NOT NULL DEFAULT 1');
CALL `apex_garage_add_column`('owned_vehicles', 'fuel',              'FLOAT NOT NULL DEFAULT 100');
CALL `apex_garage_add_column`('owned_vehicles', 'engine',            'FLOAT NOT NULL DEFAULT 1000');
CALL `apex_garage_add_column`('owned_vehicles', 'body',              'FLOAT NOT NULL DEFAULT 1000');
CALL `apex_garage_add_column`('owned_vehicles', 'damage',            'LONGTEXT NULL');
CALL `apex_garage_add_column`('owned_vehicles', 'nickname',          'VARCHAR(40) NULL');
CALL `apex_garage_add_column`('owned_vehicles', 'job_vehicle',       'TINYINT(1) NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('owned_vehicles', 'job_vehicle_rank',  'INT NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('owned_vehicles', 'gang_vehicle',      'TINYINT(1) NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('owned_vehicles', 'gang_vehicle_rank', 'INT NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('owned_vehicles', 'mileage',           'FLOAT NOT NULL DEFAULT 0');

-- ESX only: the class query filters air/sea by owned_vehicles.type, so the
-- column is guaranteed to exist even on a trimmed schema. database.lua adds
-- this one only when Bridge.isESX, i.e. only on owned_vehicles.
CALL `apex_garage_add_column`('owned_vehicles', 'type',              "VARCHAR(20) NOT NULL DEFAULT 'car'");

-- ---- QBCore / QBox: player_vehicles ----------------------------------------
CALL `apex_garage_add_column`('player_vehicles', 'garage_id',         "VARCHAR(64) NOT NULL DEFAULT 'legion'");
CALL `apex_garage_add_column`('player_vehicles', 'in_garage',         'TINYINT(1) NOT NULL DEFAULT 1');
CALL `apex_garage_add_column`('player_vehicles', 'fuel',              'FLOAT NOT NULL DEFAULT 100');
CALL `apex_garage_add_column`('player_vehicles', 'engine',            'FLOAT NOT NULL DEFAULT 1000');
CALL `apex_garage_add_column`('player_vehicles', 'body',              'FLOAT NOT NULL DEFAULT 1000');
CALL `apex_garage_add_column`('player_vehicles', 'damage',            'LONGTEXT NULL');
CALL `apex_garage_add_column`('player_vehicles', 'nickname',          'VARCHAR(40) NULL');
CALL `apex_garage_add_column`('player_vehicles', 'job_vehicle',       'TINYINT(1) NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('player_vehicles', 'job_vehicle_rank',  'INT NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('player_vehicles', 'gang_vehicle',      'TINYINT(1) NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('player_vehicles', 'gang_vehicle_rank', 'INT NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('player_vehicles', 'mileage',           'FLOAT NOT NULL DEFAULT 0');


-- ============================================================================
--  2. impound records
-- ============================================================================
CREATE TABLE IF NOT EXISTS `apex_garage_impounds` (
  `id`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `plate`        VARCHAR(16)  NOT NULL,
  `owner`        VARCHAR(80)  NOT NULL,
  `garage_id`    VARCHAR(64)  NOT NULL DEFAULT '',
  -- The garage the vehicle lived in before it was taken, so an officer's
  -- "return to owner" has somewhere to put it.
  `origin_garage` VARCHAR(64) NOT NULL DEFAULT '',
  `reason`       VARCHAR(255) NOT NULL DEFAULT '',
  `fee`          INT UNSIGNED NOT NULL DEFAULT 0,
  `retrievable`  TINYINT(1)   NOT NULL DEFAULT 1,
  `retrieval_at` BIGINT       NOT NULL DEFAULT 0,
  `officer`      VARCHAR(80)  NOT NULL DEFAULT '',
  `released_at`  TIMESTAMP NULL,
  `created_at`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`plate`),
  INDEX (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CREATE TABLE IF NOT EXISTS above is a no-op on a server that already has the
-- table, so columns added after the first release need retrofitting too.
-- Every column the runtime SELECTs, not only the newest. A table created by an
-- early build has just id/plate/owner/released_at/created_at, and the impound
-- list query died on `Unknown column 'i.retrievable'`. Defaults match what the
-- old code behaved as if the column held.
CALL `apex_garage_add_column`('apex_garage_impounds', 'garage_id',     "VARCHAR(64) NOT NULL DEFAULT ''");
CALL `apex_garage_add_column`('apex_garage_impounds', 'origin_garage', "VARCHAR(64) NOT NULL DEFAULT ''");
CALL `apex_garage_add_column`('apex_garage_impounds', 'reason',        "VARCHAR(255) NOT NULL DEFAULT ''");
CALL `apex_garage_add_column`('apex_garage_impounds', 'fee',           'INT UNSIGNED NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('apex_garage_impounds', 'retrievable',   'TINYINT(1) NOT NULL DEFAULT 1');
CALL `apex_garage_add_column`('apex_garage_impounds', 'retrieval_at',  'BIGINT NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('apex_garage_impounds', 'officer',       "VARCHAR(80) NOT NULL DEFAULT ''");
CALL `apex_garage_add_column`('apex_garage_impounds', 'released_at',   'TIMESTAMP NULL');


-- ============================================================================
--  3. in-game created garages (public / job / private)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `apex_garage_garages` (
  `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `gid`           VARCHAR(64)  NULL,
  `label`         VARCHAR(64)  NOT NULL,
  `type`          VARCHAR(16)  NOT NULL DEFAULT 'public',
  `job`           VARCHAR(48)  NOT NULL DEFAULT '',
  `min_grade`     INT          NOT NULL DEFAULT 0,
  `class`         VARCHAR(8)   NOT NULL DEFAULT 'car',
  `vehicles_type` VARCHAR(16)  NOT NULL DEFAULT 'personal',
  `stock_mode`    VARCHAR(16)  NOT NULL DEFAULT 'infinite',
  `boss_grade`    INT          NOT NULL DEFAULT 0,
  `owners`        LONGTEXT     NULL,
  `zone`          LONGTEXT     NULL,
  `spawns`        LONGTEXT     NULL,
  `store_point`   LONGTEXT     NULL,
  `blip`          LONGTEXT     NULL,
  `vehicles`      LONGTEXT     NULL,
  `created_by`    VARCHAR(80)  NOT NULL DEFAULT '',
  `created_at`    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gid` (`gid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================================
--  4. player / estate created private garages (v1 quick menu)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `apex_garage_private` (
  `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `label`      VARCHAR(64)  NOT NULL,
  `owners`     LONGTEXT     NOT NULL,
  `class`      VARCHAR(8)   NOT NULL DEFAULT 'car',
  `x`          FLOAT NOT NULL,
  `y`          FLOAT NOT NULL,
  `z`          FLOAT NOT NULL,
  `h`          FLOAT NOT NULL DEFAULT 0,
  `distance`   FLOAT NOT NULL DEFAULT 2.4,
  `created_by` VARCHAR(80)  NOT NULL DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================================
--  5. persistent parking
--  ---------------------------------------------------------------------------
--  One row per car left standing in the world. Re-created server-side on boot
--  by server/modules/parking.lua.
--
--  `h` is the yaw column it always was; `rx` / `ry` are pitch and roll, so a
--  car parked on a ramp/kerb/hill comes back at the attitude it was left at
--  instead of axis-aligned flat and half-buried. Both default to 0, which is
--  exactly the flat attitude pre-rotation rows spawned at.
--
--  `plate` is UNIQUE, not a plain index: a plate can only ever be parked once,
--  and the DB is the only guard that survives two concurrent park callbacks.
-- ============================================================================
CREATE TABLE IF NOT EXISTS `apex_garage_parked` (
  `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `plate`      VARCHAR(16)  NOT NULL,
  `owner`      VARCHAR(80)  NOT NULL,
  `model`      BIGINT       NOT NULL DEFAULT 0,
  `vtype`      VARCHAR(24)  NOT NULL DEFAULT '',
  `props`      LONGTEXT     NULL,
  `x`          FLOAT NOT NULL,
  `y`          FLOAT NOT NULL,
  `z`          FLOAT NOT NULL,
  `h`          FLOAT NOT NULL DEFAULT 0,
  `rx`         FLOAT NOT NULL DEFAULT 0,
  `ry`         FLOAT NOT NULL DEFAULT 0,
  `collision`  TINYINT(1)   NOT NULL DEFAULT 0,
  `fuel`       FLOAT NOT NULL DEFAULT 100,
  `engine`     FLOAT NOT NULL DEFAULT 1000,
  `body`       FLOAT NOT NULL DEFAULT 1000,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  INDEX (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Retrofit rx/ry/vtype onto an apex_garage_parked created by an older version.
-- CREATE TABLE IF NOT EXISTS above will not touch an existing table, so this
-- mirrors ensureParkedColumns() in server/database.lua. `vtype` (1.1.10) is the
-- sync-tree type the server saw on the parked car — automobile, bike, boat,
-- heli, plane, submarine, trailer, train — so it is re-created with the right
-- type on boot; '' means "unknown, use the plain CreateVehicle".
CALL `apex_garage_add_column`('apex_garage_parked', 'rx', 'FLOAT NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('apex_garage_parked', 'ry', 'FLOAT NOT NULL DEFAULT 0');
CALL `apex_garage_add_column`('apex_garage_parked', 'vtype', 'VARCHAR(24) NOT NULL DEFAULT ''''');


-- ============================================================================
--  6. parking permissions (who may use /park)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `apex_garage_park_perms` (
  `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(80)  NOT NULL,
  `granted_by` VARCHAR(80)  NOT NULL DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================================
--  7. parking blacklist zones
--  ---------------------------------------------------------------------------
--  Admin-drawn areas where /park is refused. `zone` is the same JSON
--  shape the garage placer produces (circle or polygon), so one geometry test
--  in Utils.PointInZone serves both systems.
-- ============================================================================
CREATE TABLE IF NOT EXISTS `apex_garage_park_blacklist` (
  `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `label`      VARCHAR(64)  NOT NULL DEFAULT 'Zona proibida',
  `zone`       LONGTEXT     NOT NULL,
  `created_by` VARCHAR(80)  NOT NULL DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================================
--  8. generic key/value settings store
--  ---------------------------------------------------------------------------
--  So panel changes outlive a restart. The parking settings row is JSON under
--  the key 'parking'.
-- ============================================================================
CREATE TABLE IF NOT EXISTS `apex_garage_settings` (
  `key`   VARCHAR(64) NOT NULL,
  `value` LONGTEXT    NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================================
--  9. cleanup
--  ---------------------------------------------------------------------------
--  The helper was only needed while this script ran. Removing it touches no
--  data. Comment this line out if you want to keep it around.
-- ============================================================================
DROP PROCEDURE IF EXISTS `apex_garage_add_column`;


-- ============================================================================
--  NOTES
-- ============================================================================
--  * If your SQL client cannot handle DELIMITER, run sections 2-8 (the plain
--    CREATE TABLE IF NOT EXISTS statements) on their own, then just start the
--    resource — server/database.lua adds the framework vehicle columns and the
--    rx/ry/vtype retrofit itself on boot.
--
--  * NOT reproduced here, deliberately: ensureParkedPlateUnique() in
--    server/database.lua promotes a pre-existing non-unique `plate` index on
--    apex_garage_parked to UNIQUE via DROP INDEX + ADD UNIQUE KEY. That is an
--    index-rewriting ALTER that fails outright if duplicate plates exist, and
--    the Lua deliberately refuses rather than picking a winner and deleting
--    somebody's car. A fresh install from this file already gets the UNIQUE
--    key from the CREATE TABLE. On a server migrating from the old schema,
--    let the resource do the promotion on boot — it will log how many
--    duplicate plates you need to clear first.
