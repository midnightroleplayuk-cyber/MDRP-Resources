/*
  Illegal Jobs — player progression / profile table

  Run once on any server database so XP, crypto, skills, and profile data persist.
  (The resource also auto-creates this table on start if missing.)

  If you already have `pluto_illegal_profiles`, either:
    RENAME TABLE `pluto_illegal_profiles` TO `pluto_illegal_jobs`;
  or restart the resource (it migrates automatically).

  Columns:
    identifier         Framework player id (unique)
    exp                XP total
    crypto_balances    JSON { snc, dnt, xmr }
    job_stats          JSON job completion counts
    skill_unlocks      JSON skill-tree unlocks
    skill_grants_claimed JSON skill-node ids whose item grants have been paid out
    illegal_nickname   Profile display name
    photo              Profile photo id
*/

CREATE TABLE IF NOT EXISTS `pluto_illegal_jobs` (
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `identifier`       VARCHAR(255) NOT NULL UNIQUE,
    `illegal_nickname` VARCHAR(255) DEFAULT NULL,
    `photo`            INT          DEFAULT 1,
    `exp`              INT          DEFAULT 0,
    `job_stats`        LONGTEXT     DEFAULT NULL,
    `skill_unlocks`    LONGTEXT     DEFAULT NULL,
    `crypto_balances`  LONGTEXT     DEFAULT NULL,
    `skill_grants_claimed` LONGTEXT DEFAULT NULL,
    `created_at`       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_at`       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
