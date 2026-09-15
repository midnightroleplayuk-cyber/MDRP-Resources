-- ═══════════════════════════════════════════════════════════════════════
--  APEX GANG — new ESX job + society
--  job: apexgang   ·   label: Apex Gang   ·   society: society_apexgang
--  Idempotent — safe to run more than once. Run it on your ESX database.
-- ═══════════════════════════════════════════════════════════════════════

-- 1) JOB ------------------------------------------------------------------
INSERT IGNORE INTO `jobs` (`name`, `label`) VALUES
    ('apexgang', 'Apex Gang');

-- 2) RANKS / GRADES — 4 gang ranks ---------------------------------------
--    The TOP grade is named 'boss' on purpose: esx_society uses that name
--    to show the society money in the HUD and grant boss-menu access.
DELETE FROM `job_grades` WHERE `job_name` = 'apexgang';
INSERT INTO `job_grades`
    (`job_name`, `grade`, `name`,       `label`,     `salary`, `skin_male`, `skin_female`) VALUES
    ('apexgang', 0,       'associate',  'Associado',  100,      '{}',        '{}'),
    ('apexgang', 1,       'soldier',    'Soldado',    250,      '{}',        '{}'),
    ('apexgang', 2,       'lieutenant', 'Capo',       500,      '{}',        '{}'),
    ('apexgang', 3,       'boss',       'Chefe',      1000,     '{}',        '{}');

-- 3) SOCIETY money account (shared = 1 → single shared pot) ---------------
INSERT IGNORE INTO `addon_account` (`name`, `label`, `shared`) VALUES
    ('society_apexgang', 'Apex Gang', 1);

INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`)
SELECT 'society_apexgang', 0, NULL FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT `account_name` FROM `addon_account_data`
                   WHERE `account_name` = 'society_apexgang') AS _x
);

-- 4) SOCIETY inventory ----------------------------------------------------
INSERT IGNORE INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
    ('society_apexgang', 'Apex Gang', 1);

-- 5) SOCIETY datastore ----------------------------------------------------
INSERT IGNORE INTO `datastore` (`name`, `label`, `shared`) VALUES
    ('society_apexgang', 'Apex Gang', 1);
