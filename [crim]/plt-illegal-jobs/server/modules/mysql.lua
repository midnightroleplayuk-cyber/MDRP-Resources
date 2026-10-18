
local TABLE = 'pluto_illegal_jobs'

local Query = {
    SELECT_PROFILES = ('SELECT * FROM `%s`'):format(TABLE),
    UPDATE_PROFILE  = ([[
        UPDATE `%s`
        SET exp = ?, illegal_nickname = ?, job_stats = ?, skill_unlocks = ?, crypto_balances = ?, skill_grants_claimed = ?
        WHERE identifier = ?
    ]]):format(TABLE),
    INSERT_PROFILE  = ([[
        INSERT IGNORE INTO `%s`
            (identifier, illegal_nickname, job_stats, skill_unlocks, crypto_balances, skill_grants_claimed)
        VALUES (?, ?, ?, ?, ?, ?)
    ]]):format(TABLE),
    UPDATE_NICKNAME = ('UPDATE `%s` SET illegal_nickname = ? WHERE identifier = ?'):format(TABLE),
    UPDATE_PHOTO    = ('UPDATE `%s` SET photo = ? WHERE identifier = ?'):format(TABLE),
}

local function ensureColumn(column, definition)
    local exists = MySQL.scalar.await([[
        SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = ?
          AND COLUMN_NAME = ?
    ]], { TABLE, column })
    if not exists or exists == 0 then
        MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN %s'):format(TABLE, definition))
        lib.print.info(('[Illegal-Jobs] Added column `%s` to %s.'):format(column, TABLE))
    end
end

local function tableExists(name)
    local ok = pcall(MySQL.scalar.await, ('SELECT 1 FROM `%s` LIMIT 1'):format(name))
    return ok
end

Citizen.CreateThreadNow(function()
    Citizen.Wait(0)

    -- Migrate legacy table name if present
    if not tableExists(TABLE) and tableExists('pluto_illegal_profiles') then
        MySQL.query.await('RENAME TABLE `pluto_illegal_profiles` TO `pluto_illegal_jobs`')
        lib.print.info('[Illegal-Jobs] Renamed table `pluto_illegal_profiles` → `pluto_illegal_jobs`.')
    end

    if not tableExists(TABLE) then
        MySQL.query([[
            CREATE TABLE `pluto_illegal_jobs` (
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
            )
        ]])
        lib.print.info('[Illegal-Jobs] Created table `pluto_illegal_jobs`.')
    else
        ensureColumn('job_stats', '`job_stats` LONGTEXT DEFAULT NULL')
        ensureColumn('skill_unlocks', '`skill_unlocks` LONGTEXT DEFAULT NULL')
        ensureColumn('crypto_balances', '`crypto_balances` LONGTEXT DEFAULT NULL')
        ensureColumn('skill_grants_claimed', '`skill_grants_claimed` LONGTEXT DEFAULT NULL')
    end
end)

local db = {}

function db.loadProfiles()
    return MySQL.query.await(Query.SELECT_PROFILES)
end

function db.updateProfile(identifier, data)
    return MySQL.prepare(Query.UPDATE_PROFILE, {
        data.exp,
        data.illegal_nickname,
        data.job_stats_json or '{}',
        data.skill_unlocks_json or '[]',
        data.crypto_balances_json or '{}',
        data.skill_grants_claimed_json or '[]',
        identifier,
    })
end

function db.updateProfileNickname(identifier, illegal_nickname)
    return MySQL.prepare(Query.UPDATE_NICKNAME, { illegal_nickname, identifier })
end

function db.updateProfilePhoto(identifier, photo)
    return MySQL.prepare(Query.UPDATE_PHOTO, { photo, identifier })
end

function db.createPlayer(identifier, illegal_nickname, jobStatsJson, skillUnlocksJson, cryptoBalancesJson, skillGrantsClaimedJson)
    return MySQL.insert(Query.INSERT_PROFILE, {
        identifier,
        illegal_nickname,
        jobStatsJson or '{}',
        skillUnlocksJson or '[]',
        cryptoBalancesJson or '{}',
        skillGrantsClaimedJson or '[]',
    })
end

return db
