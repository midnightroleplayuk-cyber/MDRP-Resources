--[[
    Apex MDT - Server
    Framework auto-detect (ESX / QB / QBox), callback bus, persistence
    for every app, access control, live unit tracking, dispatch CAD,
    audit logging and Discord webhooks.
]]

local ESX, QBCore = nil, nil
local FRAMEWORK = 'none'

--[[ ⚠⚠ AN EXPORT THAT DOES NOT EXIST RAISES ON THE INDEX, NOT ON THE CALL.

     `exports['qbx_core']:GetCoreObject()` is the single most expensive line
     this file used to contain. Qbox removed GetCoreObject, and the error is
     raised while RESOLVING the name, before any argument is evaluated, so a
     plain `if exports.x.y then` guard IS the crash it was meant to prevent.

     It ran inside a bare CreateThread with no pcall, so on a Qbox server the
     thread died on that line. ESX and QBCore both stayed nil for the rest of
     the session, every identifier lookup returned nil, no staff row was ever
     written and the tablet had nothing to show. Silently. ]]
local function callExport(res, name, ...)
    local args = table.pack(...)
    local ok, ret = pcall(function()
        return exports[res][name](exports[res], table.unpack(args, 1, args.n))
    end)
    if ok then return true, ret end
    return false, ret
end

--[[ Qbox without GetCoreObject: a façade over the exports Qbox really has.

     ⚠ Deliberately GENERIC rather than a hand-written list. Qbox exports the
     same names QBCore puts under QBCore.Functions, so `QBCore.Functions.X(...)`
     maps to `exports.qbx_core:X(...)` one for one: GetPlayer,
     GetPlayerByCitizenId, CreateUseableItem, HasPermission and the rest. The
     first version of this façade hard-coded GetPlayer alone, which quietly
     left `QBCore.Functions.CreateUseableItem` nil and the tablet item
     unusable on Qbox: fixing a bridge one missing name at a time is how the
     next missing name ships.

     Resolved at CALL time because the export list moves between versions, and
     a name Qbox does not have returns nil instead of raising, so a feature
     degrades rather than taking a thread down. ]]
local function qbxFacade()
    local Functions = setmetatable({}, {
        __index = function(_, name)
            return function(...)
                local ok, ret = callExport('qbx_core', name, ...)
                if not ok and Config.debug then
                    print(('^3[apex_mdt]^7 qbx_core has no export %s'):format(tostring(name)))
                end
                return ok and ret or nil
            end
        end,
    })
    -- Shared.Jobs / Shared.Items are not used by this resource; an empty table
    -- is honest and indexing it cannot raise.
    return { Functions = Functions, Shared = {} }
end

--[[ ⚠⚠ AND IT WAITED FOR NOBODY.

     The old detection ran once, the instant this file was evaluated. A server
     that starts apex_mdt before es_extended or qb-core (an `ensure` ordering
     anyone can have) got nil for both and never looked again. Same silent
     dead end. Now it waits, and it says what it found. ]]
CreateThread(function()
    local deadline = GetGameTimer() + 60000
    while GetGameTimer() < deadline do
        if GetResourceState('es_extended') == 'started' then
            local ok, obj = callExport('es_extended', 'getSharedObject')
            if ok and obj then ESX, FRAMEWORK = obj, 'esx' break end
        elseif GetResourceState('qb-core') == 'started' then
            local ok, obj = callExport('qb-core', 'GetCoreObject')
            if ok and obj then QBCore, FRAMEWORK = obj, 'qb' break end
        elseif GetResourceState('qbx_core') == 'started' then
            -- Some forks still ship the shim, and where it exists it is the
            -- better object, so try it first and fall back to the façade.
            local ok, obj = callExport('qbx_core', 'GetCoreObject')
            if ok and type(obj) == 'table' then QBCore, FRAMEWORK = obj, 'qbx' break end
            QBCore, FRAMEWORK = qbxFacade(), 'qbx'
            break
        end
        Wait(500)
    end

    if FRAMEWORK == 'none' then
        print('^1[apex_mdt]^7 no framework found after 60s. Looked for es_extended, qb-core and qbx_core.')
        print('^1[apex_mdt]^7 The MDT cannot identify players without one. Start your framework before apex_mdt.')
    elseif Config.debug then
        print(('^2[apex_mdt]^7 framework: %s'):format(FRAMEWORK))
    end
end)

local function feat(k) return Config.features and Config.features[k] ~= false end

-- ═══════════════════════════════════════════════════════════
-- DATABASE
-- ═══════════════════════════════════════════════════════════
local DB_READY     = false
local PLAYER_TABLE = nil   -- 'users' (ESX) | 'players' (QB)
local VEH_TABLE    = nil   -- 'owned_vehicles' (ESX) | 'player_vehicles' (QB)
-- 'esx' | 'qb', decided at boot from the COLUMNS each table really has, not
-- from its name. Every query below branches on these, never on the name.
local PLAYER_SHAPE = nil
local VEH_SHAPE    = nil

local function tableExists(t)
    local n = MySQL.scalar.await(
        'SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', { t })
    return (n or 0) > 0
end

--[[ ⚠⚠ THIS IS THE "THE MDT IS NOT CONNECTING TO THE DATABASE" BUG.

     The old code asked GetResourceState('oxmysql') ONCE, the instant this
     file was evaluated, and returned if the answer was not 'started'. On any
     server where apex_mdt is evaluated before oxmysql has finished starting,
     which is ordinary and which `dependencies` does not prevent, that single
     check failed and the thread returned for good.

     DB_READY then stayed false forever. Every reader in this file is written
     as `DB_READY and MySQL... or {}`, so the tablet opened, showed empty
     lists, saved nothing, and printed exactly one line at boot that scrolled
     away. That is precisely "0 functionality".

     So: wait for it, prove the connection with a real query rather than
     trusting a resource state, guard every schema statement, and if it still
     cannot work, SAY SO, repeatedly, with the reason. ]]

local DB_ERROR = nil          -- the reason, when there is one, for /mdt_db

local function waitForOxmysql()
    local deadline = GetGameTimer() + 120000
    while GetGameTimer() < deadline do
        if GetResourceState('oxmysql') == 'started' then
            -- 'started' is not 'connected'. oxmysql reports started before it
            -- has a usable pool, and a query issued in that window is what
            -- produced half the "database error" reports. Ask it something
            -- trivial until it answers.
            local ok, res = pcall(function() return MySQL.scalar.await('SELECT 1') end)
            if ok and res ~= nil then return true end
            DB_ERROR = ok and 'oxmysql answered nothing to SELECT 1'
                or tostring(res):gsub('%s+', ' ')
        elseif GetResourceState('oxmysql') == 'missing' then
            DB_ERROR = 'oxmysql is not installed on this server'
        else
            DB_ERROR = ('oxmysql is %s, waiting'):format(GetResourceState('oxmysql'))
        end
        Wait(1000)
    end
    return false
end

CreateThread(function()
    if not waitForOxmysql() then
        print('^1[apex_mdt]^7 ================================================')
        print('^1[apex_mdt]^7 THE DATABASE IS NOT AVAILABLE. The MDT will open')
        print('^1[apex_mdt]^7 but every list will be empty and nothing saves.')
        print(('^1[apex_mdt]^7 Reason: %s'):format(tostring(DB_ERROR)))
        print('^1[apex_mdt]^7 Check: oxmysql is installed and started BEFORE')
        print('^1[apex_mdt]^7 apex_mdt, and set_mysql_connection_string in')
        print('^1[apex_mdt]^7 server.cfg points at a database that exists.')
        print('^1[apex_mdt]^7 Then run  mdt_db  in this console to re-check.')
        print('^1[apex_mdt]^7 ================================================')
        return
    end
    DB_ERROR = nil

    local schema = {
        -- staff: ONE row per (identifier, job) so a player's POLICE and HOSPITAL
        -- registrations (setup, callsign, division, stats, hours) are fully separate.
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_staff` (
            `identifier` VARCHAR(60) NOT NULL,
            `job` VARCHAR(40) NOT NULL DEFAULT '', `callsign` VARCHAR(20) DEFAULT NULL,
            `division` VARCHAR(40) DEFAULT NULL, `status` VARCHAR(20) DEFAULT NULL,
            `stats` TEXT DEFAULT NULL, `duty_seconds` INT UNSIGNED NOT NULL DEFAULT 0,
            `notes` TEXT DEFAULT NULL, `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`identifier`, `job`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_reports` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `mode` VARCHAR(10) DEFAULT 'police',
            `type` VARCHAR(30) DEFAULT NULL, `title` VARCHAR(160) DEFAULT NULL,
            `author` VARCHAR(60) DEFAULT NULL, `author_name` VARCHAR(80) DEFAULT NULL,
            `involved` TEXT DEFAULT NULL, `charges` TEXT DEFAULT NULL, `narrative` MEDIUMTEXT DEFAULT NULL,
            `tags` VARCHAR(255) DEFAULT NULL, `status` VARCHAR(20) DEFAULT 'draft',
            `approved_by` VARCHAR(80) DEFAULT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_warrants` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `citizen_id` VARCHAR(60) DEFAULT NULL,
            `citizen_name` VARCHAR(80) DEFAULT NULL, `type` VARCHAR(20) DEFAULT 'arrest',
            `reason` TEXT DEFAULT NULL, `charges` TEXT DEFAULT NULL, `status` VARCHAR(20) DEFAULT 'pending',
            `issued_by` VARCHAR(80) DEFAULT NULL, `approved_by` VARCHAR(80) DEFAULT NULL,
            `expires_at` BIGINT DEFAULT NULL, `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_bolos` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `mode` VARCHAR(10) DEFAULT 'police',
            `type` VARCHAR(20) DEFAULT 'person', `title` VARCHAR(160) DEFAULT NULL,
            `description` TEXT DEFAULT NULL, `priority` VARCHAR(20) DEFAULT 'medium',
            `image` VARCHAR(255) DEFAULT NULL, `plate` VARCHAR(12) DEFAULT NULL,
            `last_seen` VARCHAR(160) DEFAULT NULL, `coords` VARCHAR(60) DEFAULT NULL,
            `status` VARCHAR(20) DEFAULT 'active', `author` VARCHAR(80) DEFAULT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_citations` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `citizen_id` VARCHAR(60) DEFAULT NULL,
            `citizen_name` VARCHAR(80) DEFAULT NULL, `plate` VARCHAR(12) DEFAULT NULL,
            `charges` TEXT DEFAULT NULL, `amount` INT DEFAULT 0, `officer` VARCHAR(80) DEFAULT NULL,
            `paid` TINYINT(1) DEFAULT 0, `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_evidence` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `case_ref` VARCHAR(40) DEFAULT NULL,
            `type` VARCHAR(20) DEFAULT NULL, `label` VARCHAR(160) DEFAULT NULL,
            `description` TEXT DEFAULT NULL, `location` VARCHAR(160) DEFAULT NULL,
            `image` VARCHAR(255) DEFAULT NULL, `custody` TEXT DEFAULT NULL,
            `added_by` VARCHAR(80) DEFAULT NULL, `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_notes` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `target_type` VARCHAR(20) DEFAULT 'citizen',
            `target_id` VARCHAR(60) DEFAULT NULL, `body` TEXT DEFAULT NULL,
            `author` VARCHAR(80) DEFAULT NULL, `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_flags` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `citizen_id` VARCHAR(60) DEFAULT NULL,
            `flag` VARCHAR(30) DEFAULT NULL, `added_by` VARCHAR(80) DEFAULT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_bulletins` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `mode` VARCHAR(10) DEFAULT 'police',
            `title` VARCHAR(160) DEFAULT NULL, `body` TEXT DEFAULT NULL,
            `priority` VARCHAR(20) DEFAULT 'medium', `author` VARCHAR(80) DEFAULT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_messages` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `channel` VARCHAR(40) DEFAULT 'general',
            `author` VARCHAR(80) DEFAULT NULL, `body` TEXT DEFAULT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_audit` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `actor` VARCHAR(60) DEFAULT NULL,
            `actor_name` VARCHAR(80) DEFAULT NULL, `action` VARCHAR(60) DEFAULT NULL,
            `detail` VARCHAR(255) DEFAULT NULL, `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        -- EMS
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_admissions` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `patient_id` VARCHAR(60) DEFAULT NULL,
            `patient_name` VARCHAR(80) DEFAULT NULL, `ward` VARCHAR(30) DEFAULT NULL,
            `bed` INT DEFAULT 0, `doctor` VARCHAR(80) DEFAULT NULL, `triage` VARCHAR(10) DEFAULT NULL,
            `diagnosis` TEXT DEFAULT NULL, `vitals` TEXT DEFAULT NULL, `notes` TEXT DEFAULT NULL,
            `status` VARCHAR(20) DEFAULT 'admitted', `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            `discharged_at` TIMESTAMP NULL DEFAULT NULL, PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_surgeries` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `patient_id` VARCHAR(60) DEFAULT NULL,
            `patient_name` VARCHAR(80) DEFAULT NULL, `type` VARCHAR(40) DEFAULT NULL,
            `team` TEXT DEFAULT NULL, `scheduled_at` BIGINT DEFAULT NULL, `status` VARCHAR(20) DEFAULT 'scheduled',
            `outcome` VARCHAR(20) DEFAULT NULL, `notes` TEXT DEFAULT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_deaths` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `citizen_id` VARCHAR(60) DEFAULT NULL,
            `citizen_name` VARCHAR(80) DEFAULT NULL, `cause` VARCHAR(160) DEFAULT NULL,
            `examiner` VARCHAR(80) DEFAULT NULL, `autopsy` TEXT DEFAULT NULL,
            `shared_police` TINYINT(1) DEFAULT 0, `time_of_death` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_invoices` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `citizen_id` VARCHAR(60) DEFAULT NULL,
            `citizen_name` VARCHAR(80) DEFAULT NULL, `items` TEXT DEFAULT NULL,
            `total` INT DEFAULT 0, `insurance` TINYINT(1) DEFAULT 0, `status` VARCHAR(20) DEFAULT 'unpaid',
            `issued_by` VARCHAR(80) DEFAULT NULL, `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_prescriptions` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `patient_id` VARCHAR(60) DEFAULT NULL,
            `patient_name` VARCHAR(80) DEFAULT NULL, `medication` VARCHAR(40) DEFAULT NULL,
            `qty` INT DEFAULT 1, `prescriber` VARCHAR(80) DEFAULT NULL,
            `dispensed` TINYINT(1) DEFAULT 0, `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
        -- per-citizen mugshot (the character's face) keyed by identifier - shown
        -- on Profiles (police) and Patients (hospital).
        [[CREATE TABLE IF NOT EXISTS `apex_mdt_mugshots` (
            `identifier` VARCHAR(60) NOT NULL,
            `photo` LONGTEXT DEFAULT NULL, `captured_by` VARCHAR(80) DEFAULT NULL,
            `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]],
    }
    --[[ ⚠ ONE BAD STATEMENT USED TO KILL THE WHOLE BOOT.

         These ran unguarded in a loop, so the first CREATE that MySQL refused
         (no CREATE privilege, an older MariaDB rejecting a default, a table
         left over from a half-finished install) threw, the thread stopped,
         and DB_READY was never set. Some tables existed, some did not, and
         the owner saw nothing. Each statement now stands on its own and the
         failures are collected and reported together. ]]
    local failed = {}
    for _, q in ipairs(schema) do
        local ok, err = pcall(function() return MySQL.query.await(q) end)
        if not ok then
            local name = q:match('EXISTS%s+`([%w_]+)`') or '?'
            failed[#failed + 1] = ('%s: %s'):format(name, tostring(err):gsub('%s+', ' '):sub(1, 180))
        end
    end
    if #failed > 0 then
        DB_ERROR = ('%d table(s) could not be created'):format(#failed)
        print('^1[apex_mdt]^7 ================================================')
        print(('^1[apex_mdt]^7 %d TABLE(S) COULD NOT BE CREATED:'):format(#failed))
        for _, f in ipairs(failed) do print('^1[apex_mdt]^7   ' .. f) end
        print('^1[apex_mdt]^7 The usual cause is the MySQL user not having')
        print('^1[apex_mdt]^7 CREATE on this database. Either grant it, or')
        print('^1[apex_mdt]^7 import installation/apex_mdt.sql by hand and')
        print('^1[apex_mdt]^7 restart apex_mdt.')
        print('^1[apex_mdt]^7 ================================================')
    end

    -- Migrations for the account-setup fields (safe on existing installs).
    -- ⚠ CREATE TABLE IF NOT EXISTS does NOT migrate: an install from an older
    -- version keeps its old columns and the IF NOT EXISTS silently does
    -- nothing, so every query naming a new column fails. That is what these
    -- are for, and they must never be removed on the grounds that "the CREATE
    -- already has the column".
    local function ensureColumn(tbl, col, def)
        local ok, err = pcall(function()
            local n = MySQL.scalar.await('SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?', { tbl, col })
            if (n or 0) == 0 then MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN `%s` %s'):format(tbl, col, def)) end
        end)
        if not ok then
            print(('^3[apex_mdt]^7 could not add %s.%s: %s'):format(tbl, col, tostring(err):gsub('%s+', ' '):sub(1, 160)))
        end
    end
    ensureColumn('apex_mdt_staff', 'setup_done',  'TINYINT(1) NOT NULL DEFAULT 0')
    ensureColumn('apex_mdt_staff', 'fingerprint', 'VARCHAR(24) DEFAULT NULL')
    ensureColumn('apex_mdt_staff', 'blood',       'VARCHAR(5) DEFAULT NULL')
    ensureColumn('apex_mdt_staff', 'phone',       'VARCHAR(20) DEFAULT NULL')
    ensureColumn('apex_mdt_staff', 'photo',       'LONGTEXT DEFAULT NULL')
    ensureColumn('apex_mdt_staff', 'bodycam_installed', 'TINYINT(1) NOT NULL DEFAULT 0')
    ensureColumn('apex_mdt_messages', 'image',    'LONGTEXT DEFAULT NULL')

    -- Migrate legacy single-column PK → composite (identifier, job) so POLICE
    -- and HOSPITAL registrations stay separate (older installs keyed by id only).
    do
        local pk = MySQL.query.await("SELECT COLUMN_NAME FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'apex_mdt_staff' AND INDEX_NAME = 'PRIMARY'") or {}
        if #pk < 2 then
            pcall(function() MySQL.query.await("UPDATE `apex_mdt_staff` SET `job` = '' WHERE `job` IS NULL") end)
            pcall(function() MySQL.query.await("ALTER TABLE `apex_mdt_staff` MODIFY `job` VARCHAR(40) NOT NULL DEFAULT ''") end)
            pcall(function() MySQL.query.await("ALTER TABLE `apex_mdt_staff` DROP PRIMARY KEY, ADD PRIMARY KEY (`identifier`, `job`)") end)
            print('^2[apex_mdt]^7 migrated apex_mdt_staff to a per-job (identifier, job) primary key')
        end
    end

    --[[ ⚠⚠ PICK THE TABLE BY ITS COLUMNS, NEVER BY ITS NAME.

         This block used to be `if tableExists('users') then ... 'users'`, and
         that one line produced a console full of:

             Unknown column 'identifier' in 'WHERE'
             Query: SELECT * FROM users WHERE identifier = ?
             Unknown column 'firstname' in 'ORDER BY'

         A `users` table existing does not make it ESX's users table. QBCore
         and Qbox servers very often have one: left behind by an old ESX
         install that was never dropped, created by some other resource, or
         shipped by a server template. The name matched, so every reader took
         the ESX branch and sent ESX column names at a QB database.

         The shape is what matters, so that is what is tested. ESX keeps
         `identifier` and `firstname`; QB keeps `citizenid` and `charinfo`.
         A table that has neither is not a player table whatever it is
         called, and saying so with the columns it DOES have turns a wall of
         SQL errors into one line somebody can act on. ]]
    local function columns(tbl)
        local rows = MySQL.query.await(
            'SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?',
            { tbl }) or {}
        local set = {}
        for _, r in ipairs(rows) do set[tostring(r.COLUMN_NAME or r.column_name or ''):lower()] = true end
        return set, #rows
    end

    local function hasAll(set, need)
        for _, c in ipairs(need) do if not set[c] then return false end end
        return true
    end

    --- @param candidates { {name, needed columns, shape} }
    local function pickTable(what, candidates)
        local tried = {}
        for _, c in ipairs(candidates) do
            if tableExists(c[1]) then
                local set, n = columns(c[1])
                if hasAll(set, c[2]) then return c[1], c[3] end
                tried[#tried + 1] = ('`%s` exists but has no %s (%d columns)')
                    :format(c[1], table.concat(c[2], '/'), n)
            end
        end
        if #tried > 0 then
            print(('^3[apex_mdt]^7 no usable %s table:'):format(what))
            for _, t in ipairs(tried) do print('^3[apex_mdt]^7   ' .. t) end
            print('^3[apex_mdt]^7 That part of the MDT stays empty. It reads your FRAMEWORK\'s')
            print('^3[apex_mdt]^7 tables, so this is about the framework install, not about this')
            print('^3[apex_mdt]^7 resource. Run  mdt_db  for the full picture.')
        end
        return nil, nil
    end

    local playerShape, vehShape
    PLAYER_TABLE, playerShape = pickTable('citizens', {
        { 'users',   { 'identifier', 'firstname' }, 'esx' },
        { 'players', { 'citizenid', 'charinfo' },   'qb'  },
    })
    VEH_TABLE, vehShape = pickTable('vehicles', {
        { 'owned_vehicles',  { 'owner', 'plate' },     'esx' },
        { 'player_vehicles', { 'citizenid', 'plate' }, 'qb'  },
    })
    PLAYER_SHAPE, VEH_SHAPE = playerShape, vehShape

    DB_READY = true

    --[[ Always printed, not hidden behind Config.debug. These three lines are
         the whole answer to "the MDT shows nothing", and they used to be
         exactly the output nobody had. ]]
    print(('^2[apex_mdt]^7 database ready. citizens from `%s`, vehicles from `%s`.')
        :format(tostring(PLAYER_TABLE), tostring(VEH_TABLE)))
    if not PLAYER_TABLE then
        print('^3[apex_mdt]^7 No `users` (ESX) or `players` (QB) table was found, so citizen')
        print('^3[apex_mdt]^7 search will be empty. That table belongs to your framework, not')
        print('^3[apex_mdt]^7 to this resource: start the framework first and restart apex_mdt.')
    end
    if not VEH_TABLE then
        print('^3[apex_mdt]^7 No `owned_vehicles` (ESX) or `player_vehicles` (QB) table was')
        print('^3[apex_mdt]^7 found, so the vehicle registry will be empty.')
    end
end)

--[[ One command that answers a database ticket without a round trip.
     Console only, like the rest of the house diagnostics. ]]
RegisterCommand('mdt_db', function(source)
    if source ~= 0 then return end
    print('^5[apex_mdt]^7 database diagnosis')
    print(('  oxmysql resource state : %s'):format(GetResourceState('oxmysql')))
    local ok, res = pcall(function() return MySQL.scalar.await('SELECT 1') end)
    print(('  SELECT 1               : %s'):format(ok and tostring(res) or ('^1FAILED^7 ' .. tostring(res):gsub('%s+', ' '))))
    local okDb, dbName = pcall(function() return MySQL.scalar.await('SELECT DATABASE()') end)
    print(('  connected database     : %s'):format(okDb and tostring(dbName) or 'unknown'))
    print(('  DB_READY               : %s'):format(tostring(DB_READY)))
    print(('  last error             : %s'):format(tostring(DB_ERROR)))
    print(('  citizens table         : %s  (shape: %s)'):format(tostring(PLAYER_TABLE), tostring(PLAYER_SHAPE)))
    print(('  vehicles table         : %s  (shape: %s)'):format(tostring(VEH_TABLE), tostring(VEH_SHAPE)))
    print(('  framework              : %s'):format(FRAMEWORK))
    if DB_READY then
        local names = { 'apex_mdt_staff', 'apex_mdt_reports', 'apex_mdt_warrants', 'apex_mdt_bolos',
                        'apex_mdt_citations', 'apex_mdt_evidence', 'apex_mdt_notes', 'apex_mdt_flags',
                        'apex_mdt_bulletins', 'apex_mdt_messages', 'apex_mdt_audit', 'apex_mdt_admissions',
                        'apex_mdt_surgeries', 'apex_mdt_deaths', 'apex_mdt_invoices',
                        'apex_mdt_prescriptions', 'apex_mdt_mugshots' }
        local missing = {}
        for _, t in ipairs(names) do if not tableExists(t) then missing[#missing + 1] = t end end
        print(('  tables                 : %d of %d present%s'):format(#names - #missing, #names,
            #missing > 0 and (' ^1missing: ' .. table.concat(missing, ', ') .. '^7') or ''))
    else
        print('  The MDT will open but every list is empty and nothing saves.')
        print('  Fix the line above that says FAILED, then run this again.')
    end
end, true)

-- ═══════════════════════════════════════════════════════════
-- FRAMEWORK BRIDGE
-- ═══════════════════════════════════════════════════════════
local function getIdentifier(src)
    if ESX then local x = ESX.GetPlayerFromId(src); return x and x.identifier or nil
    elseif QBCore then local p = QBCore.Functions.GetPlayer(src); return p and p.PlayerData.citizenid or nil end
    return nil
end

local function getJobInfo(src)
    if ESX then
        local x = ESX.GetPlayerFromId(src)
        if x and x.job then return x.job.name, x.job.grade or 0, x.job.grade_label or x.job.label end
    elseif QBCore then
        local p = QBCore.Functions.GetPlayer(src)
        if p and p.PlayerData.job then return p.PlayerData.job.name, p.PlayerData.job.grade and (p.PlayerData.job.grade.level or 0) or 0, p.PlayerData.job.grade and p.PlayerData.job.grade.name end
    end
    return nil, 0, nil
end

local function getName(src)
    if ESX then
        local x = ESX.GetPlayerFromId(src)
        if x then
            if x.getName then local n = x.getName(); if n and n ~= '' then return n end end
            local fn, ln = x.get and x.get('firstName'), x.get and x.get('lastName')
            local n = ((fn or '') .. ' ' .. (ln or '')):gsub('^%s+',''):gsub('%s+$','')
            if n ~= '' then return n end
        end
    elseif QBCore then
        local p = QBCore.Functions.GetPlayer(src)
        local ci = p and p.PlayerData and p.PlayerData.charinfo
        if ci then
            local n = ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):gsub('^%s+',''):gsub('%s+$','')
            if n ~= '' then return n end
        end
    end
    local gn = GetPlayerName(src)
    return gn and gn ~= '' and gn or 'Unknown'
end

local function getMoney(src)
    if ESX then local x = ESX.GetPlayerFromId(src); return x and x.getMoney() or 0
    elseif QBCore then local p = QBCore.Functions.GetPlayer(src); return p and p.PlayerData.money.cash or 0 end
    return 0
end

local function addMoney(src, amount)
    if amount <= 0 then return end
    if ESX then ESX.GetPlayerFromId(src).addMoney(amount)
    elseif QBCore then QBCore.Functions.GetPlayer(src).Functions.AddMoney('bank', amount) end
end

local function getItemCount(src, item)
    if ESX then local x = ESX.GetPlayerFromId(src); local i = x and x.getInventoryItem(item); return i and i.count or 0
    elseif QBCore then local p = QBCore.Functions.GetPlayer(src); local i = p and p.Functions.GetItemByName(item); return i and i.amount or 0 end
    return 0
end

-- Send a fine/invoice to a citizen if a billing resource is present;
-- otherwise just create our own invoice row (handled by caller).
local function notify(src, msg, type)
    TriggerClientEvent('apex_mdt:notify', src, msg, type or 'info')
end

-- ─── Mode + permission resolution ────────────────────────
local function jobCfg(jobName) return jobName and Config.jobs[jobName] or nil end
local function resolveMode(jobName) local j = jobCfg(jobName); return j and j.mode or nil end

local function isSupervisor(jobName, grade)
    local r = Config.ranks[jobName]; if not r then return false end
    local g = r[grade]
    return g and g.supervisor == true
end

local function rankLabel(jobName, grade)
    local r = Config.ranks[jobName]; local g = r and r[grade]
    return g and g.label or ('Grade ' .. tostring(grade))
end

-- ═══════════════════════════════════════════════════════════
-- STAFF (callsign / division / status / stats) + LIVE UNITS
-- ═══════════════════════════════════════════════════════════
local staffCache = {}   -- by identifier
local units      = {}   -- by src (on-duty live units)
local bodycams   = {}   -- by src (active bodycam streams) = { name, callsign }
local nextCallId = 1
local calls      = {}   -- by id (active dispatch calls, in-memory)

local function defaultStats()
    return { arrests = 0, citations = 0, reports = 0, calls = 0, patients = 0, surgeries = 0 }
end

local function genCallsign(jobName, identifier)
    local prefix = (Config.callsign.prefixByJob and Config.callsign.prefixByJob[jobName]) or 'UNIT'
    local n = 0
    for i = 1, #tostring(identifier) do n = n + tostring(identifier):byte(i) end
    return ('%s-%02d'):format(prefix, (n % 99) + 1)
end

-- Staff is cached + keyed per (identifier, job) so POLICE and HOSPITAL
-- registrations never bleed into each other (switching job loads a fresh row).
local function staffKey(id, job) return (id or '') .. '|' .. (job or '') end

local function loadStaff(src)
    local id = getIdentifier(src); if not id then return nil end
    local jobName = select(1, getJobInfo(src)) or ''
    local key = staffKey(id, jobName)
    if staffCache[key] then return staffCache[key] end
    local row = DB_READY and MySQL.single.await('SELECT * FROM apex_mdt_staff WHERE identifier = ? AND job = ?', { id, jobName }) or nil
    local s = row or { identifier = id, job = jobName }
    s.identifier = id; s.job = jobName
    if type(s.stats) == 'string' and s.stats ~= '' then
        local ok, d = pcall(json.decode, s.stats); s.stats = ok and d or defaultStats()
    else s.stats = s.stats or defaultStats() end
    if not s.callsign and Config.callsign.autoGenerate then s.callsign = genCallsign(jobName, id) end
    s.status = s.status or Config.defaultStatus
    s._key = key
    staffCache[key] = s
    return s
end

-- Accepts the staff object (preferred) or a legacy cache key string.
local function persistStaff(s)
    if not DB_READY then return end
    if type(s) == 'string' then s = staffCache[s] end
    if type(s) ~= 'table' or not s.identifier then return end
    -- nil fields (division, notes, fingerprint… before setup) are turned
    -- into NULL by server/aa_sqlnull.lua.
    MySQL.query.await([[INSERT INTO apex_mdt_staff (identifier, job, callsign, division, status, stats, duty_seconds, notes, setup_done, fingerprint, blood, phone, bodycam_installed)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)
        ON DUPLICATE KEY UPDATE callsign=VALUES(callsign), division=VALUES(division),
            status=VALUES(status), stats=VALUES(stats), duty_seconds=VALUES(duty_seconds), notes=VALUES(notes),
            setup_done=VALUES(setup_done), fingerprint=VALUES(fingerprint), blood=VALUES(blood), phone=VALUES(phone),
            bodycam_installed=VALUES(bodycam_installed)]],
        { s.identifier, s.job or '', s.callsign, s.division, s.status, json.encode(s.stats or defaultStats()), s.duty_seconds or 0, s.notes,
          s.setup_done or 0, s.fingerprint, s.blood, s.phone, s.bodycam_installed or 0 })
end

local function bumpStat(src, key, by)
    local s = loadStaff(src); if not s then return end
    s.stats = s.stats or defaultStats()
    s.stats[key] = (s.stats[key] or 0) + (by or 1)
    persistStaff(s)
end

-- ═══════════════════════════════════════════════════════════
-- AUDIT + DISCORD
-- ═══════════════════════════════════════════════════════════
local function audit(src, action, detail)
    if not feat('logEverything') then return end
    local id, name = getIdentifier(src), getName(src)
    if DB_READY then
        MySQL.insert('INSERT INTO apex_mdt_audit (actor, actor_name, action, detail) VALUES (?,?,?,?)',
            { id, name, action, detail })
    end
end

local function discord(channel, title, description, color)
    if not feat('enableDiscordWebhooks') then return end
    local url = Config.discord and Config.discord.webhooks and Config.discord.webhooks[channel]
    if not url or url == '' then return end
    PerformHttpRequest(url, function() end, 'POST', json.encode({
        username   = Config.discord.username or 'Apex MDT',
        avatar_url = Config.discord.avatar or nil,
        embeds = { {
            title = title, description = description,
            color = color or 2055423,
            footer = { text = ('Apex MDT · %s'):format(os.date('%Y-%m-%d %H:%M')) },
        } },
    }), { ['Content-Type'] = 'application/json' })
end

-- ═══════════════════════════════════════════════════════════
-- CALLBACK BUS
-- ═══════════════════════════════════════════════════════════
local handlers = {}
local function reg(name, fn) handlers[name] = fn end

RegisterNetEvent('apex_mdt:cb', function(name, id, ...)
    local src = source
    local fn = handlers[name]
    if not fn then TriggerClientEvent('apex_mdt:cbResp', src, id, nil); return end
    local ok, a, b, c = pcall(fn, src, ...)
    if ok then TriggerClientEvent('apex_mdt:cbResp', src, id, a, b, c)
    else
        print('^1[apex_mdt]^7 callback ' .. name .. ' failed: ' .. tostring(a))
        TriggerClientEvent('apex_mdt:cbResp', src, id, nil)
    end
end)

-- ═══════════════════════════════════════════════════════════
-- CITIZEN / VEHICLE LOOKUP (framework DB)
-- ═══════════════════════════════════════════════════════════
local function safeJson(s, fallback)
    if type(s) ~= 'string' or s == '' then return fallback end
    local ok, d = pcall(json.decode, s); return ok and d or fallback
end

-- Normalise a player-table row → a uniform citizen object.
local function mapCitizenRow(row)
    if not row then return nil end
    if PLAYER_SHAPE == 'esx' then
        local lic = safeJson(row.licenses, nil)
        return {
            id        = row.identifier,
            firstname = row.firstname, lastname = row.lastname,
            name      = ((row.firstname or '') .. ' ' .. (row.lastname or '')):gsub('^%s+',''):gsub('%s+$',''),
            dob       = row.dateofbirth, sex = row.sex, height = row.height,
            phone     = row.phone_number,
            job       = row.job, jobGrade = row.job_grade,
            licenses  = lic,
        }
    else -- QB players
        local ci  = safeJson(row.charinfo, {})
        local md  = safeJson(row.metadata, {})
        return {
            id        = row.citizenid,
            firstname = ci.firstname, lastname = ci.lastname,
            name      = ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):gsub('^%s+',''):gsub('%s+$',''),
            dob       = ci.birthdate, sex = ci.gender, height = nil,
            phone     = ci.phone,
            licenses  = md.licences or md.licenses,
            fingerprint = md.fingerprint,
            blood     = md.bloodtype,
        }
    end
end

-- Empty query → the whole register, alphabetical; a query filters it.
local function searchCitizens(query, limit)
    if not DB_READY or not PLAYER_TABLE then return {} end
    query = query or ''
    local lim = limit or (query == '' and 400 or 40)
    local like = '%' .. query .. '%'
    local rows
    if PLAYER_SHAPE == 'esx' then
        if query == '' then
            rows = MySQL.query.await(('SELECT * FROM users ORDER BY firstname, lastname LIMIT %d'):format(lim))
        else
            rows = MySQL.query.await(([[SELECT * FROM users
                WHERE firstname LIKE ? OR lastname LIKE ? OR identifier LIKE ?
                   OR CONCAT(firstname,' ',lastname) LIKE ?
                ORDER BY firstname, lastname LIMIT %d]]):format(lim), { like, like, like, like })
        end
    else
        if query == '' then
            rows = MySQL.query.await(('SELECT * FROM players ORDER BY charinfo LIMIT %d'):format(lim))
        else
            rows = MySQL.query.await(('SELECT * FROM players WHERE charinfo LIKE ? OR citizenid LIKE ? ORDER BY charinfo LIMIT %d'):format(lim), { like, like })
        end
    end
    local out = {}
    for _, r in ipairs(rows or {}) do out[#out + 1] = mapCitizenRow(r) end
    return out
end

-- List/search all owned vehicles (empty query → all, alphabetical by plate).
local function listVehicles(query, limit)
    if not DB_READY or not VEH_TABLE then return {} end
    query = (query or ''):upper()
    local lim = limit or (query == '' and 300 or 60)
    local like = '%' .. query .. '%'
    local rows
    if VEH_SHAPE == 'esx' then
        if query == '' then rows = MySQL.query.await(('SELECT plate, vehicle, owner FROM owned_vehicles ORDER BY plate LIMIT %d'):format(lim))
        else rows = MySQL.query.await(('SELECT plate, vehicle, owner FROM owned_vehicles WHERE plate LIKE ? ORDER BY plate LIMIT %d'):format(lim), { like }) end
    else
        if query == '' then rows = MySQL.query.await(('SELECT plate, vehicle, citizenid FROM player_vehicles ORDER BY plate LIMIT %d'):format(lim))
        else rows = MySQL.query.await(('SELECT plate, vehicle, citizenid FROM player_vehicles WHERE plate LIKE ? ORDER BY plate LIMIT %d'):format(lim), { like }) end
    end
    local out = {}
    for _, r in ipairs(rows or {}) do
        local v = safeJson(r.vehicle, {})
        out[#out + 1] = { plate = (r.plate or ''):gsub('%s+$', ''), model = v.model or v.modelName or '-', ownerId = r.owner or r.citizenid }
    end
    return out
end

local function getCitizenRow(id)
    if not DB_READY or not PLAYER_TABLE then return nil end
    local row
    if PLAYER_SHAPE == 'esx' then
        row = MySQL.single.await('SELECT * FROM users WHERE identifier = ?', { id })
    else
        row = MySQL.single.await('SELECT * FROM players WHERE citizenid = ?', { id })
    end
    return mapCitizenRow(row)
end

local function getCitizenVehicles(id)
    if not DB_READY or not VEH_TABLE then return {} end
    local rows
    if VEH_SHAPE == 'esx' then
        rows = MySQL.query.await('SELECT plate, vehicle FROM owned_vehicles WHERE owner = ?', { id })
    else
        rows = MySQL.query.await('SELECT plate, vehicle, mods FROM player_vehicles WHERE citizenid = ?', { id })
    end
    local out = {}
    for _, r in ipairs(rows or {}) do
        local v = safeJson(r.vehicle, {})
        out[#out + 1] = { plate = (r.plate or ''):gsub('%s+$',''), model = v.model or v.modelName or '-' }
    end
    return out
end

local function lookupVehicle(plate)
    if not DB_READY or not VEH_TABLE then return nil end
    plate = (plate or ''):upper():gsub('%s+$','')
    local row, ownerCol
    if VEH_SHAPE == 'esx' then
        row = MySQL.single.await('SELECT * FROM owned_vehicles WHERE plate LIKE ? LIMIT 1', { plate .. '%' })
        ownerCol = row and row.owner
    else
        row = MySQL.single.await('SELECT * FROM player_vehicles WHERE plate LIKE ? LIMIT 1', { plate .. '%' })
        ownerCol = row and row.citizenid
    end
    if not row then return nil end
    local v = safeJson(row.vehicle, {})
    local owner = ownerCol and getCitizenRow(ownerCol)
    return {
        plate    = (row.plate or plate):gsub('%s+$',''),
        model    = v.model or v.modelName or '-',
        ownerId  = ownerCol, ownerName = owner and owner.name or 'Unknown',
        stored   = row.stored, garage = row.garage,
    }
end

-- ═══════════════════════════════════════════════════════════
-- CALLS / DISPATCH (in-memory, broadcast to on-duty units)
-- ═══════════════════════════════════════════════════════════
local function onDutyUnitsForMode(mode)
    local list = {}
    for s, u in pairs(units) do if u.mode == mode and u.duty then list[#list + 1] = s end end
    return list
end

local function publicUnit(u)
    return {
        -- Stable per-character key. Callsigns are a byte-sum % 99 (genCallsign),
        -- so two officers collide often - and the NUI used to treat a matching
        -- callsign as "that's me" and hide the other unit from the map entirely.
        id = u.identifier,
        callsign = u.callsign, name = u.name, job = u.job, mode = u.mode,
        status = u.status, division = u.division, coords = u.coords,
        statusColor = u.statusColor, available = u.available,
    }
end

local function unitsList(mode)
    local out = {}
    for _, u in pairs(units) do
        if (not mode) or u.mode == mode then out[#out + 1] = publicUnit(u) end
    end
    return out
end

local function callsList(mode)
    local out = {}
    for _, c in pairs(calls) do
        if (not mode) or c.mode == mode then out[#out + 1] = c end
    end
    table.sort(out, function(a, b) return (a.time or 0) > (b.time or 0) end)
    return out
end

local function broadcastDispatch(mode)
    for _, s in ipairs(onDutyUnitsForMode(mode)) do
        TriggerClientEvent('apex_mdt:dispatchUpdate', s, { calls = callsList(mode), units = unitsList(mode) })
    end
end

local function createCall(data, fromSrc)
    local mode = data.mode or 'police'
    local id = nextCallId; nextCallId = nextCallId + 1
    calls[id] = {
        id = id, mode = mode, type = data.type, code = data.code, label = data.label,
        priority = data.priority or 'medium', desc = data.desc or '',
        location = data.location or 'Unknown', coords = data.coords, postal = data.postal,
        caller = data.caller or 'Anonymous', time = os.time(), status = 'pending', assigned = {},
    }
    -- Alert on-duty units of that mode.
    for _, s in ipairs(onDutyUnitsForMode(mode)) do
        TriggerClientEvent('apex_mdt:newCall', s, calls[id])
    end
    broadcastDispatch(mode)
    if data.priority == 'critical' and data.discord ~= false then
        discord('panic', '🚨 ' .. (data.label or 'Critical Call'),
            ('**%s**\nLocation: %s\nCaller: %s'):format(data.code or '', calls[id].location, calls[id].caller), 15089755)
    end
    return id
end
_CREATE_CALL = createCall

-- ═══════════════════════════════════════════════════════════
-- BOOTSTRAP - everything the NUI needs on open
-- ═══════════════════════════════════════════════════════════
-- Resolve a citizen's face for the records detail (Profiles / Patients):
--   1) a captured mugshot (apex_mdt_mugshots)
--   2) the person's OWN MDT photo, if they're a registered officer/medic
--   3) the configured CDN mugshot URL
-- Heavy base64 is only embedded in single-record detail (never in list payloads).
local function avatarUrl(id)
    if not id or id == '' then return nil end
    if DB_READY then
        local m = MySQL.scalar.await('SELECT photo FROM apex_mdt_mugshots WHERE identifier = ? LIMIT 1', { id })
        if m and m ~= '' then return m end
        local p = MySQL.scalar.await("SELECT photo FROM apex_mdt_staff WHERE identifier = ? AND photo IS NOT NULL AND photo <> '' LIMIT 1", { id })
        if p and p ~= '' then return p end
    end
    if Config.avatar and Config.avatar.enable and Config.avatar.mugshotUrl then
        return string.format(Config.avatar.mugshotUrl, id)
    end
    return nil
end

-- Build the lock-screen notification cards (real-tablet style).
local function buildLockNotifications(mode)
    local out = {}
    local active = #callsList(mode)
    if active > 0 then
        out[#out + 1] = { icon = 'fa-tower-broadcast', color = '#F97316', title = mode == 'ems' and 'EMS Dispatch' or 'Dispatch', body = active .. ' active call' .. (active > 1 and 's' or ''), time = 'now' }
    end
    if mode == 'police' then
        local w = DB_READY and MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_warrants WHERE status='active'") or 0
        if (w or 0) > 0 then out[#out + 1] = { icon = 'fa-gavel', color = '#E5564B', title = 'Warrants', body = w .. ' active warrant' .. (w > 1 and 's' or ''), time = 'today' } end
        local bolo = DB_READY and MySQL.single.await("SELECT title FROM apex_mdt_bolos WHERE status='active' AND mode='police' ORDER BY id DESC LIMIT 1") or nil
        if bolo and bolo.title then out[#out + 1] = { icon = 'fa-bullhorn', color = '#E5A93C', title = 'New BOLO', body = bolo.title, time = 'recent' } end
    else
        local adm = DB_READY and MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_admissions WHERE status='admitted'") or 0
        if (adm or 0) > 0 then out[#out + 1] = { icon = 'fa-bed', color = '#06B6D4', title = 'Admissions', body = adm .. ' patient' .. (adm > 1 and 's' or '') .. ' admitted', time = 'now' } end
    end
    local bl = DB_READY and MySQL.single.await('SELECT title, author FROM apex_mdt_bulletins WHERE mode=? ORDER BY id DESC LIMIT 1', { mode }) or nil
    if bl and bl.title then out[#out + 1] = { icon = 'fa-circle-info', color = '#1F5EFF', title = 'Bulletin', body = bl.title, time = bl.author or '' } end
    return out
end

reg('apex_mdt:bootstrap', function(src)
    local jobName, grade = getJobInfo(src)
    local mode = resolveMode(jobName)
    if not mode and feat('restrictByJob') then return { ok = false, reason = 'no_access' } end
    mode = mode or 'police'

    local staff = loadStaff(src)
    staff.job = jobName
    persistStaff(staff)

    local jcfg = jobCfg(jobName) or {}
    return {
        ok       = true,
        mode     = mode,
        notifications = buildLockNotifications(mode),
        officer  = {
            id        = staff.identifier,
            name      = getName(src),
            job       = jobName,
            jobLabel  = jcfg.label or jobName,
            jobShort  = jcfg.short or (jobName or ''):upper(),
            rank      = rankLabel(jobName, grade),
            grade     = grade,
            supervisor = isSupervisor(jobName, grade),
            callsign  = staff.callsign,
            division  = staff.division,
            status    = staff.status,
            avatar    = (staff.photo and staff.photo ~= '' and staff.photo) or avatarUrl(staff.identifier),
            duty      = units[src] ~= nil and units[src].duty or false,
            deptColor = jcfg.color,
            setupDone = (staff.setup_done == 1 or staff.setup_done == true),
            fingerprint = staff.fingerprint,
            blood     = staff.blood,
            phone     = staff.phone,
            -- service hours (accrued + current session) + activity counters for My Profile
            dutySeconds = (staff.duty_seconds or 0) + ((units[src] and units[src].onSince) and (os.time() - units[src].onSince) or 0),
            stats     = staff.stats or defaultStats(),
            divisionList = Config.divisions[mode] or {},
            bloodTypes   = Config.bloodTypes,
        },
        config   = {
            theme      = Config.theme,
            features   = Config.features,
            currency   = Config.currency,
            imgBase    = Config.itemImageBase,
            wallpaper  = Config.wallpaper,
            cctv       = (function()
                if not (Config.cctv and Config.cctv.enabled) then return { enabled = false } end
                local cams = {}
                for _, c in ipairs(Config.cctv.cameras or {}) do
                    if not c.mode or c.mode == mode or c.mode == 'both' then cams[#cams + 1] = { id = c.id, label = c.label } end
                end
                return { enabled = true, cameras = cams }
            end)(),
            bodycam    = { enabled = (Config.bodycam and Config.bodycam.enabled) and mode == 'police' },
            map        = Config.map,
            stations   = (function()
                local out = {}
                for _, s in ipairs(Config.stations or {}) do
                    if (not s.mode) or s.mode == mode then
                        out[#out + 1] = { label = s.label, x = s.coords.x + 0.0, y = s.coords.y + 0.0 }
                    end
                end
                return out
            end)(),
            statuses   = Config.statuses[mode] or Config.statuses.police,
            callTypes  = Config.callTypes[mode] or Config.callTypes.police,
            priorities = Config.priorities,
            penalCode  = Config.penalCode,
            flags      = Config.flags,
            reportTypes = Config.reportTypes,
            evidenceTypes = Config.evidenceTypes,
            boloTypes  = Config.boloTypes,
            divisions  = Config.divisions[mode] or {},
            triage     = Config.triage,
            vitals     = Config.vitals,
            diagnoses  = Config.diagnoses,
            wards      = Config.wards,
            medications = Config.medications,
            surgeries  = Config.surgeries,
            bloodTypes = Config.bloodTypes,
            billing    = Config.billing,
            booking    = Config.booking,
            dateFormat = Config.dateFormat,
            use24h     = Config.use24h,
            keybind    = Config.keybind,
            command    = Config.command,
            requireItem = Config.requireItem,
            openItem   = Config.openItem,
            locale     = GetLocaleTable and GetLocaleTable() or {},
        },
    }
end)

-- ─── Dashboard snapshot ─────────────────────────────────
reg('apex_mdt:dashboard', function(src)
    local jobName = select(1, getJobInfo(src))
    local mode = resolveMode(jobName) or 'police'
    local activeWarrants = DB_READY and MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_warrants WHERE status='active'") or 0
    local activeBolos    = DB_READY and MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_bolos WHERE status='active' AND mode=?", { mode }) or 0
    local bulletins      = DB_READY and MySQL.query.await('SELECT * FROM apex_mdt_bulletins WHERE mode=? ORDER BY id DESC LIMIT 5', { mode }) or {}
    local recent         = DB_READY and MySQL.query.await('SELECT actor_name, action, detail, created_at FROM apex_mdt_audit ORDER BY id DESC LIMIT 12') or {}
    return {
        unitsOnDuty  = #onDutyUnitsForMode(mode),
        activeCalls  = #callsList(mode),
        pendingCalls = (function() local n=0 for _,c in pairs(calls) do if c.mode==mode and c.status=='pending' then n=n+1 end end return n end)(),
        activeWarrants = activeWarrants,
        activeBolos  = activeBolos,
        bulletins    = bulletins,
        recent       = recent,
        units        = unitsList(mode),
        calls        = callsList(mode),
    }
end)

-- Resolve a list of player server-ids → their character name + identifier
-- (used by the "nearest player" pickers in Billing / Pharmacy / Admissions).
reg('apex_mdt:resolvePlayers', function(src, ids)
    local out = {}
    for _, sid in pairs(ids or {}) do
        sid = tonumber(sid)
        if sid then out[#out + 1] = { serverId = sid, id = getIdentifier(sid), name = getName(sid) } end
    end
    return out
end)

-- ═══════════════════════════════════════════════════════════
-- DUTY / STATUS / UNITS
-- ═══════════════════════════════════════════════════════════
-- Add the elapsed on-duty seconds of this player's CURRENT session to their
-- per-job staff record (feeds the "service hours" on My Profile + the roster).
local function accrueDuty(src)
    local u = units[src]; if not u or not u.onSince then return end
    local secs = os.time() - u.onSince; u.onSince = nil
    if secs > 0 then
        local s = loadStaff(src)
        if s then s.duty_seconds = (s.duty_seconds or 0) + secs; persistStaff(s) end
    end
end

local function setUnit(src, duty)
    local jobName, grade = getJobInfo(src)
    local mode = resolveMode(jobName); if not mode then return end
    local staff = loadStaff(src)
    if duty then
        units[src] = {
            src = src, identifier = staff.identifier, name = getName(src),
            callsign = staff.callsign, job = jobName, mode = mode,
            division = staff.division, status = staff.status or Config.defaultStatus,
            duty = true, coords = nil, available = true, statusColor = '#34C77B',
            onSince = os.time(),
        }
    else
        accrueDuty(src)
        units[src] = nil
    end
    broadcastDispatch(mode)
end

-- ─── Framework duty bridge ───────────────────────────────
-- QBCore owns duty: the qb-policejob duty point, the paycheck and every
-- `job.onduty` gate in qb-policejob all read PlayerData.job.onduty. The MDT
-- used to keep a duty flag of its own that only its own /duty ever set, so an
-- officer who booked on at the station was never added to `units` - invisible
-- on the Units board, the Live Map and the roster, and skipped by every
-- dispatch broadcast. Both directions are wired here so they cannot diverge.
local function frameworkDuty(src)
    if QBCore then
        local p = QBCore.Functions.GetPlayer(src)
        local j = p and p.PlayerData and p.PlayerData.job
        if j then return j.onduty == true end
    elseif ESX then
        local x = ESX.GetPlayerFromId(src)
        if x and x.job and x.job.onDuty ~= nil then return x.job.onDuty == true end
    end
    return nil   -- no duty flag we can trust: leave the MDT's own state alone
end

-- QB → MDT (duty point, an admin forcing duty, any resource toggling duty).
AddEventHandler('QBCore:Server:SetDuty', function(src, onDuty)
    src = tonumber(src); if not src then return end
    if not resolveMode(select(1, getJobInfo(src))) then return end
    setUnit(src, onDuty == true)
    TriggerClientEvent('apex_mdt:forceDuty', src, onDuty == true)
end)

-- MDT → QB; the bridge above then registers/removes the unit.
local function applyDuty(src, onDuty)
    onDuty = onDuty == true
    if QBCore then
        local p = QBCore.Functions.GetPlayer(src)
        if p and p.PlayerData.job and p.PlayerData.job.onduty ~= onDuty then
            p.Functions.SetJobDuty(onDuty)
            TriggerEvent('QBCore:Server:SetDuty', src, onDuty)
            TriggerClientEvent('QBCore:Client:SetDuty', src, onDuty)
            return onDuty
        end
    end
    setUnit(src, onDuty)
    return onDuty
end

-- Adopt anyone already on duty: on login, and after an apex_mdt restart
-- (which wipes the in-memory `units` while job.onduty stays set).
local function reconcileDuty(src)
    if not src or src <= 0 then return end
    local fw = frameworkDuty(src); if fw == nil then return end
    if not resolveMode(select(1, getJobInfo(src))) then return end
    if fw ~= (units[src] ~= nil) then
        setUnit(src, fw)
        TriggerClientEvent('apex_mdt:forceDuty', src, fw)
    end
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(p)
    local src = p and p.PlayerData and p.PlayerData.source
    if src then SetTimeout(3000, function() reconcileDuty(tonumber(src)) end) end
end)

AddEventHandler('onResourceStart', function(r)
    if r ~= GetCurrentResourceName() then return end
    SetTimeout(3000, function()
        for _, pid in ipairs(GetPlayers()) do reconcileDuty(tonumber(pid)) end
    end)
end)

reg('apex_mdt:toggleDuty', function(src, onDuty)
    if not feat('enableDutyToggle') then return false end
    local state = applyDuty(src, onDuty)
    notify(src, state and (L and L('notify_on_duty') or 'On duty') or (L and L('notify_off_duty') or 'Off duty'), 'success')
    audit(src, 'duty', state and 'went on duty' or 'went off duty')
    return true, state
end)

reg('apex_mdt:setStatus', function(src, code)
    local u = units[src]
    local jobName = select(1, getJobInfo(src))
    local mode = resolveMode(jobName) or 'police'
    local list = Config.statuses[mode] or Config.statuses.police
    local found
    for _, st in ipairs(list) do if st.code == code then found = st break end end
    if not found then return false end
    local staff = loadStaff(src); staff.status = code; persistStaff(staff)
    if u then u.status = code; u.statusColor = found.color; u.available = found.available; broadcastDispatch(mode) end
    notify(src, (L and L('notify_status_set', found.label) or ('Status: ' .. found.label)), 'info')
    return true, found
end)

RegisterNetEvent('apex_mdt:updatePosition', function(coords)
    local u = units[source]
    if u then u.coords = coords end
end)

reg('apex_mdt:getUnits', function(src)
    local jobName = select(1, getJobInfo(src))
    local mode = resolveMode(jobName) or 'police'
    return { units = unitsList(mode), calls = callsList(mode) }
end)

-- ═══════════════════════════════════════════════════════════
-- DISPATCH callbacks
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:getCalls', function(src)
    local jobName = select(1, getJobInfo(src)); local mode = resolveMode(jobName) or 'police'
    return { calls = callsList(mode), units = unitsList(mode) }
end)

reg('apex_mdt:createCall', function(src, data)
    if not feat('enableDispatch') then return false end
    data = data or {}
    local jobName = select(1, getJobInfo(src)); data.mode = resolveMode(jobName) or 'police'
    data.caller = data.caller or getName(src)
    local id = createCall(data, src)
    audit(src, 'call', ('created %s call #%d'):format(data.label or data.type or '?', id))
    return true, id
end)

reg('apex_mdt:assignCall', function(src, callId)
    local c = calls[tonumber(callId)]; if not c then return false end
    local u = units[src]; if not u then return false, 'not_on_duty' end
    c.assigned = c.assigned or {}
    local cs = u.callsign or getName(src)
    local exists = false
    for _, a in ipairs(c.assigned) do if a == cs then exists = true break end end
    if not exists then c.assigned[#c.assigned + 1] = cs end
    c.status = 'assigned'
    bumpStat(src, 'calls')
    broadcastDispatch(c.mode)
    if feat('enableWaypointOnCall') and c.coords then TriggerClientEvent('apex_mdt:setWaypoint', src, c.coords) end
    return true
end)

reg('apex_mdt:setCallStatus', function(src, callId, status)
    local c = calls[tonumber(callId)]; if not c then return false end
    if status == 'closed' then calls[tonumber(callId)] = nil
    else c.status = status end
    broadcastDispatch(c.mode)
    audit(src, 'call', ('set call #%s → %s'):format(tostring(callId), tostring(status)))
    return true
end)

reg('apex_mdt:respondCall', function(src, callId)
    local c = calls[tonumber(callId)]; if not c or not c.coords then return false end
    TriggerClientEvent('apex_mdt:setWaypoint', src, c.coords)
    notify(src, L and L('notify_waypoint_set') or 'Waypoint set.', 'success')
    return true
end)

-- ═══════════════════════════════════════════════════════════
-- CITIZENS / VEHICLES
-- ═══════════════════════════════════════════════════════════
local function citizenFlags(id)
    if not DB_READY then return {} end
    local rows = MySQL.query.await('SELECT flag FROM apex_mdt_flags WHERE citizen_id = ?', { id }) or {}
    local out = {}; for _, r in ipairs(rows) do out[#out + 1] = r.flag end
    return out
end

local function citizenRecord(id)
    if not DB_READY then return {} end
    local reports   = MySQL.query.await("SELECT id, type, title, status, created_at FROM apex_mdt_reports WHERE involved LIKE ? ORDER BY id DESC LIMIT 25", { '%' .. id .. '%' }) or {}
    local citations = MySQL.query.await('SELECT id, charges, amount, officer, paid, created_at FROM apex_mdt_citations WHERE citizen_id = ? ORDER BY id DESC', { id }) or {}
    local warrants  = MySQL.query.await('SELECT id, type, reason, status, created_at FROM apex_mdt_warrants WHERE citizen_id = ? ORDER BY id DESC', { id }) or {}
    return { reports = reports, citations = citations, warrants = warrants }
end

reg('apex_mdt:searchCitizens', function(src, query)
    return { results = searchCitizens(query, 30) }
end)

reg('apex_mdt:getCitizen', function(src, id)
    local c = getCitizenRow(id); if not c then return { ok = false } end
    c.vehicles = getCitizenVehicles(id)
    c.flags    = citizenFlags(id)
    c.notes    = DB_READY and (MySQL.query.await("SELECT * FROM apex_mdt_notes WHERE target_type='citizen' AND target_id=? ORDER BY id DESC", { id }) or {}) or {}
    local rec  = citizenRecord(id)
    c.reports, c.citations, c.warrants = rec.reports, rec.citations, rec.warrants
    c.avatar = avatarUrl(id)
    audit(src, 'lookup', 'viewed citizen ' .. (c.name or id))
    return { ok = true, citizen = c }
end)

reg('apex_mdt:addFlag', function(src, id, flag)
    if not DB_READY then return false end
    MySQL.insert('INSERT INTO apex_mdt_flags (citizen_id, flag, added_by) VALUES (?,?,?)', { id, flag, getName(src) })
    audit(src, 'flag', ('flagged %s as %s'):format(id, flag))
    return true
end)

reg('apex_mdt:removeFlag', function(src, id, flag)
    if not DB_READY then return false end
    MySQL.query.await('DELETE FROM apex_mdt_flags WHERE citizen_id=? AND flag=?', { id, flag })
    return true
end)

reg('apex_mdt:addNote', function(src, targetType, targetId, body)
    if not DB_READY then return false end
    MySQL.insert('INSERT INTO apex_mdt_notes (target_type, target_id, body, author) VALUES (?,?,?,?)',
        { targetType or 'citizen', targetId, body, getName(src) })
    return true
end)

reg('apex_mdt:deleteNote', function(src, noteId)
    if not DB_READY then return false end
    MySQL.query.await('DELETE FROM apex_mdt_notes WHERE id=?', { noteId })
    return true
end)

reg('apex_mdt:searchVehicles', function(src, plate)
    return { results = listVehicles(plate) }
end)

reg('apex_mdt:getVehicle', function(src, plate)
    local v = lookupVehicle(plate); if not v then return { ok = false } end
    v.notes = DB_READY and (MySQL.query.await("SELECT * FROM apex_mdt_notes WHERE target_type='vehicle' AND target_id=? ORDER BY id DESC", { v.plate }) or {}) or {}
    v.bolo  = DB_READY and MySQL.single.await("SELECT id, priority, description FROM apex_mdt_bolos WHERE type='vehicle' AND plate=? AND status='active' LIMIT 1", { v.plate }) or nil
    audit(src, 'lookup', 'ran plate ' .. v.plate)
    return { ok = true, vehicle = v }
end)

-- ═══════════════════════════════════════════════════════════
-- REPORTS
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:getReports', function(src, filter)
    if not DB_READY then return { reports = {} } end
    local jobName = select(1, getJobInfo(src)); local mode = resolveMode(jobName) or 'police'
    local rows = MySQL.query.await('SELECT id, mode, type, title, author_name, status, created_at FROM apex_mdt_reports WHERE mode=? ORDER BY id DESC LIMIT 100', { mode }) or {}
    return { reports = rows }
end)

reg('apex_mdt:getReport', function(src, id)
    if not DB_READY then return { ok = false } end
    local r = MySQL.single.await('SELECT * FROM apex_mdt_reports WHERE id=?', { id })
    if not r then return { ok = false } end
    r.involved = safeJson(r.involved, {}); r.charges = safeJson(r.charges, {})
    return { ok = true, report = r }
end)

reg('apex_mdt:saveReport', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local jobName, grade = getJobInfo(src); local mode = resolveMode(jobName) or 'police'
    local status = data.status or 'draft'
    if feat('reportsNeedApproval') and status == 'submitted' and isSupervisor(jobName, grade) then status = 'approved' end
    if data.id and tonumber(data.id) then
        MySQL.query.await([[UPDATE apex_mdt_reports SET type=?, title=?, involved=?, charges=?, narrative=?, tags=?, status=? WHERE id=?]],
            { data.type, data.title, json.encode(data.involved or {}), json.encode(data.charges or {}), data.narrative, data.tags, status, data.id })
        audit(src, 'report', ('updated report #%s'):format(tostring(data.id)))
        return true, tonumber(data.id)
    else
        local id = MySQL.insert.await([[INSERT INTO apex_mdt_reports (mode, type, title, author, author_name, involved, charges, narrative, tags, status)
            VALUES (?,?,?,?,?,?,?,?,?,?)]],
            { mode, data.type, data.title, getIdentifier(src), getName(src), json.encode(data.involved or {}), json.encode(data.charges or {}), data.narrative, data.tags, status })
        bumpStat(src, 'reports')
        audit(src, 'report', ('created report #%s (%s)'):format(tostring(id), data.title or ''))
        return true, id
    end
end)

reg('apex_mdt:approveReport', function(src, id)
    local jobName, grade = getJobInfo(src)
    if not isSupervisor(jobName, grade) then return false, 'no_permission' end
    MySQL.query.await("UPDATE apex_mdt_reports SET status='approved', approved_by=? WHERE id=?", { getName(src), id })
    audit(src, 'report', ('approved report #%s'):format(tostring(id)))
    return true
end)

reg('apex_mdt:deleteReport', function(src, id)
    if not DB_READY then return false end
    local jobName, grade = getJobInfo(src)
    if feat('lockRecordEditToAuthor') and not isSupervisor(jobName, grade) then
        local r = MySQL.single.await('SELECT author FROM apex_mdt_reports WHERE id=?', { id })
        if r and r.author ~= getIdentifier(src) then return false, 'no_permission' end
    end
    MySQL.query.await('DELETE FROM apex_mdt_reports WHERE id=?', { id })
    audit(src, 'report', ('deleted report #%s'):format(tostring(id)))
    return true
end)

-- ═══════════════════════════════════════════════════════════
-- WARRANTS
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:getWarrants', function(src)
    if not DB_READY then return { warrants = {} } end
    return { warrants = MySQL.query.await('SELECT * FROM apex_mdt_warrants ORDER BY FIELD(status,"pending","active","executed","expired"), id DESC LIMIT 100') or {} }
end)

reg('apex_mdt:createWarrant', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local jobName, grade = getJobInfo(src)
    local status = 'active'
    if feat('warrantsNeedApproval') and not isSupervisor(jobName, grade) then status = 'pending' end
    local id = MySQL.insert.await([[INSERT INTO apex_mdt_warrants (citizen_id, citizen_name, type, reason, charges, status, issued_by, expires_at)
        VALUES (?,?,?,?,?,?,?,?)]],
        { data.citizenId, data.citizenName, data.type or 'arrest', data.reason, json.encode(data.charges or {}), status, getName(src), data.expiresAt })
    if status == 'active' then
        MySQL.insert('INSERT INTO apex_mdt_flags (citizen_id, flag, added_by) VALUES (?,?,?)', { data.citizenId, 'warrant', getName(src) })
        local jcfg = jobCfg(jobName) or {}
        if feat('notifyOnWarrant') then for s, u in pairs(units) do if u.mode == 'police' and u.duty then notify(s, (L and L('notify_warrant_active', data.citizenName or '') or ('Warrant: '..(data.citizenName or ''))), 'warning') end end end
        discord('warrants', '⚖️ New Active Warrant', ('**%s** - %s\nIssued by %s'):format(data.citizenName or '?', data.reason or '', getName(src)), 15158332)
    end
    audit(src, 'warrant', ('created %s warrant for %s (%s)'):format(data.type or 'arrest', data.citizenName or '', status))
    return true, id
end)

reg('apex_mdt:approveWarrant', function(src, id)
    local jobName, grade = getJobInfo(src)
    if not isSupervisor(jobName, grade) then return false, 'no_permission' end
    local w = MySQL.single.await('SELECT * FROM apex_mdt_warrants WHERE id=?', { id }); if not w then return false end
    MySQL.query.await("UPDATE apex_mdt_warrants SET status='active', approved_by=? WHERE id=?", { getName(src), id })
    MySQL.insert('INSERT INTO apex_mdt_flags (citizen_id, flag, added_by) VALUES (?,?,?)', { w.citizen_id, 'warrant', getName(src) })
    discord('warrants', '⚖️ Warrant Approved', ('**%s** - %s'):format(w.citizen_name or '?', w.reason or ''), 15158332)
    audit(src, 'warrant', ('approved warrant #%s'):format(tostring(id)))
    return true
end)

reg('apex_mdt:setWarrantStatus', function(src, id, status)
    if not DB_READY then return false end
    MySQL.query.await('UPDATE apex_mdt_warrants SET status=? WHERE id=?', { status, id })
    if status == 'executed' or status == 'expired' then
        local w = MySQL.single.await('SELECT citizen_id FROM apex_mdt_warrants WHERE id=?', { id })
        if w then MySQL.query.await("DELETE FROM apex_mdt_flags WHERE citizen_id=? AND flag='warrant'", { w.citizen_id }) end
    end
    audit(src, 'warrant', ('set warrant #%s → %s'):format(tostring(id), tostring(status)))
    return true
end)

-- ═══════════════════════════════════════════════════════════
-- BOLOs
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:getBolos', function(src)
    if not DB_READY then return { bolos = {} } end
    local jobName = select(1, getJobInfo(src)); local mode = resolveMode(jobName) or 'police'
    return { bolos = MySQL.query.await("SELECT * FROM apex_mdt_bolos WHERE mode=? AND status='active' ORDER BY FIELD(priority,'critical','high','medium','low'), id DESC", { mode }) or {} }
end)

reg('apex_mdt:createBolo', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local jobName = select(1, getJobInfo(src)); local mode = resolveMode(jobName) or 'police'
    local coords = data.coords and json.encode(data.coords) or nil
    local id = MySQL.insert.await([[INSERT INTO apex_mdt_bolos (mode, type, title, description, priority, image, plate, last_seen, coords, author)
        VALUES (?,?,?,?,?,?,?,?,?,?)]],
        { mode, data.type or 'person', data.title, data.description, data.priority or 'medium', data.image, data.plate, data.lastSeen, coords, getName(src) })
    if feat('notifyOnBolo') then for s, u in pairs(units) do if u.mode == mode and u.duty then notify(s, (L and L('notify_new_bolo', data.type or 'person') or 'New BOLO'), 'warning') end end end
    if data.priority == 'high' or data.priority == 'critical' then
        discord('bolos', '🔎 New BOLO (' .. (data.priority or '') .. ')', ('**%s**\n%s\nLast seen: %s'):format(data.title or '?', data.description or '', data.lastSeen or '-'), 15844367)
    end
    audit(src, 'bolo', ('posted %s BOLO: %s'):format(data.type or 'person', data.title or ''))
    return true, id
end)

reg('apex_mdt:closeBolo', function(src, id)
    if not DB_READY then return false end
    MySQL.query.await("UPDATE apex_mdt_bolos SET status='archived' WHERE id=?", { id })
    audit(src, 'bolo', ('closed BOLO #%s'):format(tostring(id)))
    return true
end)

-- ═══════════════════════════════════════════════════════════
-- CITATIONS / CHARGES / BOOKING
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:getCitations', function(src, citizenId)
    if not DB_READY then return { citations = {} } end
    local rows
    if citizenId then rows = MySQL.query.await('SELECT * FROM apex_mdt_citations WHERE citizen_id=? ORDER BY id DESC', { citizenId })
    else rows = MySQL.query.await('SELECT * FROM apex_mdt_citations ORDER BY id DESC LIMIT 100') end
    return { citations = rows or {} }
end)

reg('apex_mdt:createCitation', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local id = MySQL.insert.await([[INSERT INTO apex_mdt_citations (citizen_id, citizen_name, plate, charges, amount, officer) VALUES (?,?,?,?,?,?)]],
        { data.citizenId, data.citizenName, data.plate, json.encode(data.charges or {}), math.floor(tonumber(data.amount) or 0), getName(src) })
    bumpStat(src, 'citations')
    audit(src, 'citation', ('issued citation to %s for %s%d'):format(data.citizenName or '?', Config.currency.symbol, math.floor(tonumber(data.amount) or 0)))
    notify(src, (L and L('notify_invoice_sent', (Config.currency.symbol .. tostring(math.floor(tonumber(data.amount) or 0)))) or 'Citation issued'), 'success')
    return true, id
end)

reg('apex_mdt:book', function(src, data)
    if not DB_READY then return false end
    data = data or {}   -- { citizenId, citizenName, charges = {ids}, months, fine }
    local months = math.floor(tonumber(data.months) or 0)
    local fine   = math.floor(tonumber(data.fine) or 0)
    local seconds = math.min((Config.booking.maxJailSeconds or 3600), months * (Config.booking.monthsToSeconds or 30))
    -- Create an arrest report from the booking.
    MySQL.insert('INSERT INTO apex_mdt_reports (mode, type, title, author, author_name, involved, charges, narrative, status) VALUES (?,?,?,?,?,?,?,?,?)',
        { 'police', 'arrest', ('Booking - %s'):format(data.citizenName or '?'), getIdentifier(src), getName(src),
          json.encode({ { type = 'citizen', id = data.citizenId, name = data.citizenName } }), json.encode(data.charges or {}),
          ('Booked %s. Sentence: %d months. Fine: %s%d.'):format(data.citizenName or '?', months, Config.currency.symbol, fine), 'approved' })
    if Config.booking.sendInvoice and fine > 0 then
        MySQL.insert('INSERT INTO apex_mdt_citations (citizen_id, citizen_name, charges, amount, officer) VALUES (?,?,?,?,?)',
            { data.citizenId, data.citizenName, json.encode(data.charges or {}), fine, getName(src) })
    end
    bumpStat(src, 'arrests')
    audit(src, 'booking', ('booked %s - %d months, fine %s%d'):format(data.citizenName or '?', months, Config.currency.symbol, fine))
    -- Hand off to a jail script via event (server owners wire their jail here).
    TriggerEvent('apex_mdt:playerBooked', { officer = src, citizenId = data.citizenId, seconds = seconds, fine = fine, charges = data.charges })
    notify(src, (L and L('notify_booked', data.citizenName or '?', months, Config.currency.symbol .. fine) or 'Booked.'), 'success')
    return true, { seconds = seconds, fine = fine }
end)

-- ═══════════════════════════════════════════════════════════
-- EVIDENCE
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:getEvidence', function(src, caseRef)
    if not DB_READY then return { evidence = {} } end
    local rows
    if caseRef and caseRef ~= '' then rows = MySQL.query.await('SELECT * FROM apex_mdt_evidence WHERE case_ref=? ORDER BY id DESC', { caseRef })
    else rows = MySQL.query.await('SELECT * FROM apex_mdt_evidence ORDER BY id DESC LIMIT 100') end
    for _, r in ipairs(rows or {}) do r.custody = safeJson(r.custody, {}) end
    return { evidence = rows or {} }
end)

reg('apex_mdt:addEvidence', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local custody = { { by = getName(src), action = 'logged', at = os.time() } }
    local id = MySQL.insert.await([[INSERT INTO apex_mdt_evidence (case_ref, type, label, description, location, image, custody, added_by) VALUES (?,?,?,?,?,?,?,?)]],
        { data.caseRef, data.type, data.label, data.description, data.location, data.image, json.encode(custody), getName(src) })
    audit(src, 'evidence', ('logged evidence %s (case %s)'):format(data.label or '?', data.caseRef or '-'))
    return true, id
end)

reg('apex_mdt:touchEvidence', function(src, id, action)
    if not DB_READY then return false end
    local r = MySQL.single.await('SELECT custody FROM apex_mdt_evidence WHERE id=?', { id }); if not r then return false end
    local custody = safeJson(r.custody, {})
    custody[#custody + 1] = { by = getName(src), action = action or 'accessed', at = os.time() }
    MySQL.query.await('UPDATE apex_mdt_evidence SET custody=? WHERE id=?', { json.encode(custody), id })
    return true
end)

-- ═══════════════════════════════════════════════════════════
-- BULLETINS + COMMS
-- (the dashboard payload already returns bulletins inline; no getBulletins call)
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:postBulletin', function(src, data)
    local jobName, grade = getJobInfo(src)
    if not isSupervisor(jobName, grade) then return false, 'no_permission' end
    local mode = resolveMode(jobName) or 'police'
    local id = MySQL.insert.await('INSERT INTO apex_mdt_bulletins (mode, title, body, priority, author) VALUES (?,?,?,?,?)',
        { mode, data.title, data.body, data.priority or 'medium', getName(src) })
    if feat('notifyOnBulletin') then for s, u in pairs(units) do if u.mode == mode and u.duty then notify(s, L and L('notify_new_bulletin') or 'New bulletin', 'info') end end end
    audit(src, 'bulletin', ('posted bulletin: %s'):format(data.title or ''))
    return true, id
end)

reg('apex_mdt:deleteBulletin', function(src, id)
    local jobName, grade = getJobInfo(src)
    if not isSupervisor(jobName, grade) then return false, 'no_permission' end
    MySQL.query.await('DELETE FROM apex_mdt_bulletins WHERE id=?', { id })
    return true
end)

reg('apex_mdt:getMessages', function(src, channel)
    if not DB_READY then return { messages = {} } end
    return { messages = MySQL.query.await('SELECT * FROM apex_mdt_messages WHERE channel=? ORDER BY id DESC LIMIT 50', { channel or 'general' }) or {} }
end)

reg('apex_mdt:sendMessage', function(src, channel, body, image)
    if not DB_READY then return false end
    if type(image) == 'string' and (#image > 400000 or not image:find('^data:image/')) then image = nil end  -- guard size/format
    local jobName = select(1, getJobInfo(src)); local mode = resolveMode(jobName) or 'police'
    local id = MySQL.insert.await('INSERT INTO apex_mdt_messages (channel, author, body, image) VALUES (?,?,?,?)', { channel or 'general', getName(src), body, image })
    local jcfg = jobCfg(jobName) or {}
    local row = { id = id, channel = channel or 'general', author = getName(src), body = body, image = image, dept = jcfg.short or (jobName or ''):upper(), created_at = os.date('%Y-%m-%d %H:%M:%S') }
    -- 'interagency' reaches every on-duty unit (police ↔ ems); other channels
    -- stay within the sender's own mode.
    local cross = (channel == 'interagency')
    for s, u in pairs(units) do if cross or u.mode == mode then TriggerClientEvent('apex_mdt:newMessage', s, row) end end
    return true
end)

-- ═══════════════════════════════════════════════════════════
-- ROSTER + STATS + AUDIT
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:getRoster', function(src)
    if not DB_READY then return { roster = {}, onDuty = {} } end
    local jobName = select(1, getJobInfo(src)); local mode = resolveMode(jobName) or 'police'
    -- The persisted staff list (everyone who has used the MDT for a job in this mode).
    local jobsInMode = {}
    for j, cfg in pairs(Config.jobs) do if cfg.mode == mode then jobsInMode[#jobsInMode + 1] = j end end
    local roster = {}
    if #jobsInMode > 0 then
        local placeholders = string.rep('?,', #jobsInMode):sub(1, -2)
        local rows = MySQL.query.await('SELECT identifier, job, callsign, division, stats, duty_seconds FROM apex_mdt_staff WHERE job IN ('..placeholders..')', jobsInMode) or {}
        for _, r in ipairs(rows) do
            r.stats = safeJson(r.stats, defaultStats())
            roster[#roster + 1] = r
        end
    end
    return { roster = roster, onDuty = unitsList(mode) }
end)

reg('apex_mdt:getStats', function(src)
    if not DB_READY then return {} end
    local jobName = select(1, getJobInfo(src)); local mode = resolveMode(jobName) or 'police'
    local out = { mode = mode }
    if mode == 'police' then
        out.reports   = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_reports WHERE mode='police'") or 0
        out.arrests   = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_reports WHERE type='arrest'") or 0
        out.warrants  = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_warrants WHERE status='active'") or 0
        out.citations = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_citations") or 0
        out.bolos     = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_bolos WHERE status='active'") or 0
        -- last 7 days report counts (chart)
        out.daily = MySQL.query.await("SELECT DATE(created_at) d, COUNT(*) n FROM apex_mdt_reports WHERE created_at > (NOW() - INTERVAL 7 DAY) GROUP BY DATE(created_at) ORDER BY d") or {}
    else
        out.admissions = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_admissions WHERE status='admitted'") or 0
        out.surgeries  = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_surgeries WHERE status!='done'") or 0
        out.deaths     = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_deaths") or 0
        out.invoices   = MySQL.scalar.await("SELECT COUNT(*) FROM apex_mdt_invoices WHERE status='unpaid'") or 0
        out.daily = MySQL.query.await("SELECT DATE(created_at) d, COUNT(*) n FROM apex_mdt_admissions WHERE created_at > (NOW() - INTERVAL 7 DAY) GROUP BY DATE(created_at) ORDER BY d") or {}
    end
    return out
end)

reg('apex_mdt:getAudit', function(src)
    local jobName, grade = getJobInfo(src)
    if not isSupervisor(jobName, grade) then return { audit = {}, denied = true } end
    if not DB_READY then return { audit = {} } end
    return { audit = MySQL.query.await('SELECT * FROM apex_mdt_audit ORDER BY id DESC LIMIT 200') or {} }
end)

reg('apex_mdt:updateProfile', function(src, data)
    local s = loadStaff(src); if not s then return false end
    if data.callsign then s.callsign = tostring(data.callsign):sub(1, 16) end
    if data.division then s.division = tostring(data.division):sub(1, 32) end
    if data.blood    then s.blood    = tostring(data.blood):sub(1, 5) end
    if data.phone    then s.phone    = tostring(data.phone):sub(1, 20) end
    persistStaff(s)
    local u = units[src]; if u then u.callsign = s.callsign; u.division = s.division; broadcastDispatch(u.mode) end
    return true, { callsign = s.callsign, division = s.division, blood = s.blood, phone = s.phone, fingerprint = s.fingerprint }
end)

-- First-time account setup (photo is the live mugshot; we persist the
-- profile fields + a generated fingerprint and flip setup_done).
reg('apex_mdt:completeSetup', function(src, data)
    local s = loadStaff(src); if not s then return false end
    data = data or {}
    s.setup_done = 1
    if data.callsign and data.callsign ~= '' then s.callsign = tostring(data.callsign):sub(1, 16) end
    if data.division then s.division = tostring(data.division):sub(1, 32) end
    if data.blood    then s.blood    = tostring(data.blood):sub(1, 5) end
    if data.phone    then s.phone    = tostring(data.phone):sub(1, 20) end
    if not s.fingerprint or s.fingerprint == '' then
        local chars, fp = '0123456789ABCDEF', ''
        for _ = 1, 12 do local r = math.random(#chars); fp = fp .. chars:sub(r, r) end
        s.fingerprint = fp
    end
    persistStaff(s)
    audit(src, 'setup', 'completed MDT account setup')
    return true, { callsign = s.callsign, division = s.division, blood = s.blood, phone = s.phone, fingerprint = s.fingerprint }
end)

-- Save a real in-game photo (base64 data-URI captured via screenshot-basic).
RegisterNetEvent('apex_mdt:savePhoto', function(dataUri)
    local src = source
    if type(dataUri) ~= 'string' then return end
    if #dataUri < 32 or #dataUri > 6000000 then return end           -- sanity bounds
    if not dataUri:find('^data:image/') then return end              -- must be a data URI
    local s = loadStaff(src); if not s then return end
    s.photo = dataUri
    if DB_READY then MySQL.query('UPDATE apex_mdt_staff SET photo = ? WHERE identifier = ?', { dataUri, s.identifier }) end
    audit(src, 'photo', 'updated profile photo')
end)

-- Save a citizen/patient MUGSHOT (the character's face) keyed by their identifier.
RegisterNetEvent('apex_mdt:saveMugshot', function(targetId, dataUri)
    local src = source
    if type(targetId) ~= 'string' or targetId == '' then return end
    if type(dataUri) ~= 'string' or #dataUri < 32 or #dataUri > 6000000 or not dataUri:find('^data:image/') then return end
    if not resolveMode(select(1, getJobInfo(src))) then return end   -- must be police/EMS staff
    if DB_READY then
        MySQL.query('INSERT INTO apex_mdt_mugshots (identifier, photo, captured_by) VALUES (?,?,?) ON DUPLICATE KEY UPDATE photo = VALUES(photo), captured_by = VALUES(captured_by)',
            { targetId, dataUri, getName(src) })
    end
    audit(src, 'mugshot', 'captured mugshot for ' .. targetId)
end)

-- Supervisor: manage another staff member (promote/demote/division).
reg('apex_mdt:manageStaff', function(src, targetId, action, value)
    local jobName, grade = getJobInfo(src)
    if not isSupervisor(jobName, grade) then return false, 'no_permission' end
    -- Promotion/demotion is delegated to the framework (job grade) - we
    -- fire an event server owners can wire to esx society / qb gangs.
    TriggerEvent('apex_mdt:staffAction', { by = getName(src), targetId = targetId, action = action, value = value })
    audit(src, 'roster', ('%s on %s'):format(action or '?', tostring(targetId)))
    return true
end)

-- ═══════════════════════════════════════════════════════════
-- EMS - TRIAGE / ADMISSIONS / SURGERY / PHARMACY / BILLING / MORGUE
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:searchPatients', function(src, query)
    -- Patients are the same citizen table; medical extras come from flags/admissions.
    return { results = searchCitizens(query, 30) }
end)

reg('apex_mdt:getPatient', function(src, id)
    local c = getCitizenRow(id); if not c then return { ok = false } end
    c.flags = citizenFlags(id)
    c.avatar = avatarUrl(id)
    if DB_READY then
        c.admissions   = MySQL.query.await('SELECT * FROM apex_mdt_admissions WHERE patient_id=? ORDER BY id DESC LIMIT 25', { id }) or {}
        c.prescriptions = MySQL.query.await('SELECT * FROM apex_mdt_prescriptions WHERE patient_id=? ORDER BY id DESC LIMIT 25', { id }) or {}
        c.invoices     = MySQL.query.await('SELECT * FROM apex_mdt_invoices WHERE citizen_id=? ORDER BY id DESC LIMIT 25', { id }) or {}
        c.notes        = MySQL.query.await("SELECT * FROM apex_mdt_notes WHERE target_type='patient' AND target_id=? ORDER BY id DESC", { id }) or {}
        for _, a in ipairs(c.admissions) do a.vitals = safeJson(a.vitals, {}) end
    end
    audit(src, 'lookup', 'viewed patient ' .. (c.name or id))
    return { ok = true, patient = c }
end)

reg('apex_mdt:admitPatient', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local id = MySQL.insert.await([[INSERT INTO apex_mdt_admissions (patient_id, patient_name, ward, bed, doctor, triage, diagnosis, vitals, notes, status)
        VALUES (?,?,?,?,?,?,?,?,?,'admitted')]],
        { data.patientId, data.patientName, data.ward, math.floor(tonumber(data.bed) or 0), getName(src), data.triage,
          data.diagnosis, json.encode(data.vitals or {}), data.notes })
    bumpStat(src, 'patients')
    audit(src, 'admission', ('admitted %s → %s'):format(data.patientName or '?', data.ward or '?'))
    notify(src, (L and L('notify_admitted', data.ward or '?') or 'Admitted'), 'success')
    return true, id
end)

reg('apex_mdt:getBeds', function(src)
    if not DB_READY then return { occupied = {} } end
    local rows = MySQL.query.await("SELECT id, patient_name, ward, bed, doctor, triage, status FROM apex_mdt_admissions WHERE status='admitted'") or {}
    return { occupied = rows }
end)

reg('apex_mdt:dischargePatient', function(src, admissionId)
    if not DB_READY then return false end
    MySQL.query.await("UPDATE apex_mdt_admissions SET status='discharged', discharged_at=NOW() WHERE id=?", { admissionId })
    audit(src, 'admission', ('discharged admission #%s'):format(tostring(admissionId)))
    notify(src, L and L('notify_discharged') or 'Discharged', 'info')
    return true
end)

reg('apex_mdt:treatPatient', function(src, targetServerId, amount)
    -- Heal hook: tell the patient's client to restore health (server owners
    -- can also wire their own injury system via apex_mdt:patientTreated).
    local tid = tonumber(targetServerId)
    if tid then TriggerClientEvent('apex_mdt:heal', tid, tonumber(amount) or 100) end
    TriggerEvent('apex_mdt:patientTreated', { medic = src, patient = tid, amount = amount })
    bumpStat(src, 'patients')
    return true
end)

reg('apex_mdt:getSurgeries', function(src)
    if not DB_READY then return { surgeries = {} } end
    local rows = MySQL.query.await('SELECT * FROM apex_mdt_surgeries ORDER BY FIELD(status,"scheduled","in_progress","done"), id DESC LIMIT 100') or {}
    for _, r in ipairs(rows) do r.team = safeJson(r.team, {}) end
    return { surgeries = rows }
end)

reg('apex_mdt:scheduleSurgery', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local id = MySQL.insert.await('INSERT INTO apex_mdt_surgeries (patient_id, patient_name, type, team, scheduled_at, notes) VALUES (?,?,?,?,?,?)',
        { data.patientId, data.patientName, data.type, json.encode(data.team or {}), data.scheduledAt, data.notes })
    audit(src, 'surgery', ('scheduled %s for %s'):format(data.type or '?', data.patientName or '?'))
    return true, id
end)

reg('apex_mdt:setSurgeryStatus', function(src, id, status, outcome)
    if not DB_READY then return false end
    MySQL.query.await('UPDATE apex_mdt_surgeries SET status=?, outcome=? WHERE id=?', { status, outcome, id })
    if status == 'done' then bumpStat(src, 'surgeries') end
    return true
end)

reg('apex_mdt:getPharmacy', function(src)
    if not DB_READY then return { stock = Config.medications, prescriptions = {} } end
    local rx = MySQL.query.await("SELECT * FROM apex_mdt_prescriptions WHERE dispensed=0 ORDER BY id DESC LIMIT 100") or {}
    return { stock = Config.medications, prescriptions = rx }
end)

reg('apex_mdt:prescribe', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local id = MySQL.insert.await('INSERT INTO apex_mdt_prescriptions (patient_id, patient_name, medication, qty, prescriber) VALUES (?,?,?,?,?)',
        { data.patientId, data.patientName, data.medication, math.floor(tonumber(data.qty) or 1), getName(src) })
    audit(src, 'pharmacy', ('prescribed %s x%s to %s'):format(data.medication or '?', tostring(data.qty or 1), data.patientName or '?'))
    return true, id
end)

reg('apex_mdt:dispense', function(src, rxId)
    if not DB_READY then return false end
    local rx = MySQL.single.await('SELECT * FROM apex_mdt_prescriptions WHERE id=?', { rxId }); if not rx then return false end
    MySQL.query.await('UPDATE apex_mdt_prescriptions SET dispensed=1 WHERE id=?', { rxId })
    -- RP hook: server owners can wire this to actually hand the patient the
    -- medication item / apply an effect (resource-agnostic, never breaks if unused).
    TriggerEvent('apex_mdt:medicationDispensed', { by = src, patientId = rx.patient_id, patientName = rx.patient_name, medication = rx.medication, qty = rx.qty })
    audit(src, 'pharmacy', ('dispensed %s'):format(rx.medication or '?'))
    notify(src, (L and L('notify_dispensed', rx.medication or '?') or 'Dispensed'), 'success')
    return true
end)

reg('apex_mdt:getInvoices', function(src, citizenId)
    if not DB_READY then return { invoices = {} } end
    local rows
    if citizenId then rows = MySQL.query.await('SELECT * FROM apex_mdt_invoices WHERE citizen_id=? ORDER BY id DESC', { citizenId })
    else rows = MySQL.query.await('SELECT * FROM apex_mdt_invoices ORDER BY id DESC LIMIT 100') end
    for _, r in ipairs(rows or {}) do r.items = safeJson(r.items, {}) end
    return { invoices = rows or {} }
end)

reg('apex_mdt:createInvoice', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local total = math.floor(tonumber(data.total) or 0)
    if data.insurance then total = math.floor(total * (1 - (Config.billing.insuranceCoverPct or 0))) end
    local id = MySQL.insert.await('INSERT INTO apex_mdt_invoices (citizen_id, citizen_name, items, total, insurance, issued_by) VALUES (?,?,?,?,?,?)',
        { data.citizenId, data.citizenName, json.encode(data.items or {}), total, data.insurance and 1 or 0, getName(src) })
    audit(src, 'billing', ('invoiced %s %s%d'):format(data.citizenName or '?', Config.currency.symbol, total))
    notify(src, (L and L('notify_invoice_sent', Config.currency.symbol .. total) or 'Invoice sent'), 'success')
    return true, id
end)

reg('apex_mdt:getDeaths', function(src)
    if not DB_READY then return { deaths = {} } end
    return { deaths = MySQL.query.await('SELECT * FROM apex_mdt_deaths ORDER BY id DESC LIMIT 100') or {} }
end)

reg('apex_mdt:recordDeath', function(src, data)
    if not DB_READY then return false end
    data = data or {}
    local id = MySQL.insert.await('INSERT INTO apex_mdt_deaths (citizen_id, citizen_name, cause, examiner, autopsy, shared_police) VALUES (?,?,?,?,?,?)',
        { data.citizenId, data.citizenName, data.cause, getName(src), data.autopsy, data.sharePolice and 1 or 0 })
    if feat('notifyOnDeath') then
        discord('deaths', '☠️ Death Recorded', ('**%s** - %s\nExaminer: %s'):format(data.citizenName or '?', data.cause or '', getName(src)), 3289650)
    end
    if data.sharePolice and feat('enableDataSharing') then
        for s, u in pairs(units) do if u.mode == 'police' and u.duty then notify(s, ('Coroner: death of %s - %s'):format(data.citizenName or '?', data.cause or ''), 'warning') end end
    end
    audit(src, 'death', ('recorded death of %s (%s)'):format(data.citizenName or '?', data.cause or ''))
    return true, id
end)

-- ═══════════════════════════════════════════════════════════
-- PLAYER DOWN - automatic EMS call from the client death watcher
-- ═══════════════════════════════════════════════════════════
-- mode is forced to 'ems' on purpose: the generic apex_mdt:createCall
-- callback derives the mode from the CALLER's job, and someone bleeding out
-- on the floor is usually a civilian - that would file the call as police.
RegisterNetEvent('apex_mdt:playerDown', function(data)
    local src = source
    if not (feat('enableEmsDownCall') and feat('enableDispatch')) then return end
    data = data or {}
    createCall({
        mode = 'ems', type = 'cardiac', code = 'Code Blue', label = 'Player Down',
        priority = 'critical', desc = 'Automatic alert - citizen unresponsive.',
        location = data.location or 'Unknown', coords = data.coords, caller = getName(src),
    }, src)
end)

-- ═══════════════════════════════════════════════════════════
-- SHOTS FIRED (auto weapons call)
-- ═══════════════════════════════════════════════════════════
-- Every client reports its own shots (client/main.lua). Up to 1.2.2 this
-- handler dropped anyone whose job was not a police job, so a civilian's
-- gunfire could never become a call - only an on-duty officer shooting did.
-- The call is always filed as POLICE ('shots' is a Config.callTypes.police
-- type; EMS has none) whatever the shooter's job. Who counts is decided by
-- Config.weaponsCall.shooters, and a server-side cooldown stops a modified
-- client from flooding the CAD.
local shotStamp = {}   -- src -> GetGameTimer() of the last accepted report
RegisterNetEvent('apex_mdt:shotsFired', function(data)
    local src = source
    if not (feat('enableAutoWeaponsCall') and feat('enableDispatch')) then return end
    local wc = Config.weaponsCall or {}
    local u  = units[src]
    local isUnit = u ~= nil and u.duty ~= false
    if wc.shooters == 'units' and not isUnit then return end
    if wc.shooters == 'civilians' and isUnit and u.mode == 'police' then return end

    local now = GetGameTimer()
    local cooldown = tonumber(wc.cooldownMs) or 30000
    if shotStamp[src] and (now - shotStamp[src]) < cooldown then return end
    shotStamp[src] = now

    data = type(data) == 'table' and data or {}
    local coords
    local c = data.coords
    if type(c) == 'table' and type(c.x) == 'number' and type(c.y) == 'number' and type(c.z) == 'number' then
        coords = { x = c.x, y = c.y, z = c.z }
    end
    local location = type(data.location) == 'string' and data.location:sub(1, 60) or nil
    if not location or location == '' then location = 'Unknown' end

    -- One shootout = one call: more gunfire near a Shots Fired call that was
    -- opened moments ago is folded into it (the units already have the blip).
    local radius  = tonumber(wc.mergeRadius) or 75.0
    local window  = tonumber(wc.mergeSeconds) or 120
    if coords and radius > 0 and window > 0 then
        local t = os.time()
        for _, c2 in pairs(calls) do
            if c2.mode == 'police' and c2.type == 'shots' and c2.status ~= 'closed' and c2.coords
               and (t - (c2.time or 0)) < window then
                local dx, dy, dz = c2.coords.x - coords.x, c2.coords.y - coords.y, c2.coords.z - coords.z
                if (dx * dx + dy * dy + dz * dz) <= radius * radius then
                    c2.shots = (c2.shots or 1) + 1
                    return
                end
            end
        end
    end

    local desc
    if isUnit then
        desc = ('Automatic alert - gunfire detected near %s.'):format(u.callsign or getName(src))
    else
        desc = 'Automatic alert - gunfire reported in the area.'
    end
    createCall({
        mode = 'police', type = 'shots', code = '10-71', label = 'Shots Fired',
        priority = 'critical', desc = desc, location = location, coords = coords,
        caller = (wc.anonymousCaller ~= false and not isUnit) and 'Anonymous' or getName(src),
        discord = wc.discord == true,
    }, src)
end)

AddEventHandler('playerDropped', function() shotStamp[source] = nil end)

-- ═══════════════════════════════════════════════════════════
-- PANIC
-- ═══════════════════════════════════════════════════════════
RegisterNetEvent('apex_mdt:panic', function(coords)
    local src = source
    local jobName = select(1, getJobInfo(src)); local mode = resolveMode(jobName); if not mode then return end
    local name = getName(src)
    local u = units[src]
    local data = {
        mode = mode, type = 'panic', code = mode == 'ems' and 'Mayday' or '10-99',
        label = mode == 'ems' and 'EMS IN DANGER' or 'OFFICER DOWN',
        priority = 'critical', desc = ('Panic from %s'):format(u and u.callsign or name),
        location = 'GPS Location', coords = coords, caller = name,
    }
    createCall(data, src)
    -- on-screen panic alert to other units (gated by Config.features.notifyOnPanic)
    if feat('notifyOnPanic') then
        for s, un in pairs(units) do
            if un.mode == mode and un.duty then
                TriggerClientEvent('apex_mdt:panicAlert', s, { name = name, callsign = u and u.callsign, coords = coords })
            end
        end
    end
    discord('panic', '🚨 PANIC', ('**%s** (%s) activated panic.'):format(name, u and u.callsign or '-'), 15089755)
    audit(src, 'panic', 'activated panic button')
end)

-- ═══════════════════════════════════════════════════════════
-- BODYCAM (install / activate / view live feeds)
-- ═══════════════════════════════════════════════════════════
local function isBcInstalled(s) return s and (s.bodycam_installed == 1 or s.bodycam_installed == true) end

reg('apex_mdt:bodycamStatus', function(src)
    local s = loadStaff(src)
    return { installed = isBcInstalled(s), active = bodycams[src] ~= nil }
end)

reg('apex_mdt:bodycamInstall', function(src)
    local s = loadStaff(src); if not s then return false end
    s.bodycam_installed = 1; persistStaff(s)
    audit(src, 'bodycam', 'installed a bodycam')
    return true
end)

reg('apex_mdt:bodycamSetActive', function(src, active)
    local s = loadStaff(src); if not isBcInstalled(s) then return false, 'not_installed' end
    if active then
        local u = units[src]
        bodycams[src] = { name = getName(src), callsign = (u and u.callsign) or s.callsign }
    else
        bodycams[src] = nil
    end
    return true, active == true
end)

reg('apex_mdt:bodycamList', function(src)
    local out = {}
    for s, b in pairs(bodycams) do
        out[#out + 1] = { serverId = s, name = b.name, callsign = b.callsign, self = (s == src) }
    end
    return { feeds = out }
end)

-- ═══════════════════════════════════════════════════════════
-- ACCESS CHECK (used by client before opening)
-- ═══════════════════════════════════════════════════════════
reg('apex_mdt:canOpen', function(src)
    local jobName = select(1, getJobInfo(src))
    local mode = resolveMode(jobName)
    if feat('restrictByJob') and not mode then return false, 'no_access' end
    if Config.requireItem and Config.openItem and Config.openItem ~= '' and getItemCount(src, Config.openItem) <= 0 then return false, 'no_item' end
    if feat('requireDutyToOpen') and not (units[src] and units[src].duty) then return false, 'not_on_duty' end
    return true, mode or 'police'
end)

-- ═══════════════════════════════════════════════════════════
-- LIFECYCLE
-- ═══════════════════════════════════════════════════════════
local function cleanup(src)
    local id = getIdentifier(src)
    if units[src] then accrueDuty(src) end
    local u = units[src]
    if u then local mode = u.mode; units[src] = nil; broadcastDispatch(mode) end
    bodycams[src] = nil
    -- staff is cached per (identifier, job): persist + drop every entry for this id
    if id then
        local prefix = id .. '|'
        local drop = {}
        for k, s in pairs(staffCache) do
            if k == id or k:sub(1, #prefix) == prefix then persistStaff(s); drop[#drop + 1] = k end
        end
        for _, k in ipairs(drop) do staffCache[k] = nil end
    end
end
AddEventHandler('playerDropped', function() cleanup(source) end)
AddEventHandler('esx:playerDropped', function(src) cleanup(src) end)

-- Job change (police ↔ ambulance): drop stale duty/unit state for the OLD job
-- and flush cached staff so the next bootstrap loads the NEW job cleanly. The
-- client triggers this on esx:setJob / QBCore:Client:OnJobUpdate, then refreshes
-- its open tablet - so the mode/theme/info switch without a script restart.
RegisterNetEvent('apex_mdt:jobChangedSv', function()
    local src = source
    if units[src] then accrueDuty(src) end
    local u = units[src]
    if u then local mode = u.mode; units[src] = nil; broadcastDispatch(mode) end
    local id = getIdentifier(src)
    if id then
        local prefix = id .. '|'
        local drop = {}
        for k, s in pairs(staffCache) do
            if k == id or k:sub(1, #prefix) == prefix then persistStaff(s); drop[#drop + 1] = k end
        end
        for _, k in ipairs(drop) do staffCache[k] = nil end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ADMIN - wipe a player's MDT account (re-runs first-run setup next open)
-- Usage (console or ace `command.mdtreset`):
--   mdtreset <serverId|identifier> [job]     job omitted = every department
-- ═══════════════════════════════════════════════════════════
RegisterCommand('mdtreset', function(src, args)
    local target, job = args[1], args[2]
    if not target then
        print('^3[apex_mdt]^7 usage: mdtreset <serverId|identifier> [job]')
        return
    end
    local sid = tonumber(target)
    local id  = sid and getIdentifier(sid) or target
    if not id or id == '' then print('^1[apex_mdt]^7 could not resolve a player identifier from "'..tostring(target)..'"'); return end
    -- 1) remove the persisted registration (per-job or all)
    if DB_READY then
        if job and job ~= '' then MySQL.query.await('DELETE FROM apex_mdt_staff WHERE identifier = ? AND job = ?', { id, job })
        else MySQL.query.await('DELETE FROM apex_mdt_staff WHERE identifier = ?', { id }) end
    end
    -- 2) drop the live cache so it is NOT re-persisted on disconnect
    local prefix = id .. '|'
    for k in pairs(staffCache) do
        if k == id or k:sub(1, #prefix) == prefix then
            if not job or job == '' or staffCache[k].job == job then staffCache[k] = nil end
        end
    end
    -- 3) if they're online: take them off duty + force the tablet shut so the
    --    next open re-fetches a clean (un-registered) profile.
    if sid and sid > 0 then
        if units[sid] then local m = units[sid].mode; units[sid] = nil; broadcastDispatch(m) end
        TriggerClientEvent('apex_mdt:close', sid)
        TriggerClientEvent('apex_mdt:notify', sid, 'Your MDT account was reset by an admin.', 'warning')
    end
    if src and src ~= 0 then audit(src, 'admin', ('reset MDT account %s%s'):format(id, (job and job ~= '') and (' ['..job..']') or '')) end
    print(('^2[apex_mdt]^7 reset MDT account for %s%s'):format(id, (job and job ~= '') and (' ('..job..')') or ' (all departments)'))
end, true)   -- restricted: console + ace `command.mdtreset` only

-- ═══════════════════════════════════════════════════════════
-- USABLE ITEM (tablet)
-- ═══════════════════════════════════════════════════════════
CreateThread(function()
    Wait(2000)
    if not Config.openItem or Config.openItem == '' then return end
    if ESX then
        ESX.RegisterUsableItem(Config.openItem, function(src) TriggerClientEvent('apex_mdt:open', src) end)
    elseif QBCore then
        QBCore.Functions.CreateUseableItem(Config.openItem, function(src) TriggerClientEvent('apex_mdt:open', src) end)
    end
end)

-- ─── Export bridges (used by server/exports.lua) ─────────
_GET_IDENTIFIER = getIdentifier
_GET_JOBINFO    = getJobInfo
_RESOLVE_MODE   = resolveMode
_UNITS          = function() return units end
_AUDIT          = audit
_DISCORD        = discord
