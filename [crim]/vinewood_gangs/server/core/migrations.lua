Migrations = {}

-- sql/install.sql creates the whole database at this version.
local SCHEMA_VERSION = 18
-- The first release that used a single install.sql. Anything older came from pre-release builds.
local BASE_VERSION = 10

-- Future updates that change existing tables go here as separate files, e.g.
--   [11] = 'sql/update_011.sql',
-- so servers already running the script are upgraded in place. Bump SCHEMA_VERSION in install.sql too.
local UPDATES = {
    [11] = 'sql/update_011.sql', -- money laundering
    [12] = 'sql/update_012.sql', -- contract spots added in game
    [13] = 'sql/update_013.sql', -- racket shops added in game
    [14] = 'sql/update_014.sql', -- street dealing permission
    [15] = 'sql/update_015.sql', -- heists
    [16] = 'sql/update_016.sql', -- settings changed in game
    [17] = 'sql/update_017.sql', -- air drop permission
    [18] = 'sql/update_018.sql', -- hex territory
}

local resource = GetCurrentResourceName()

local function statements(sql)
    sql = sql:gsub('%-%-[^\n]*', '')
    local list = {}
    for stmt in (sql .. ';'):gmatch('([^;]+);') do
        stmt = stmt:match('^%s*(.-)%s*$')
        if stmt ~= '' then list[#list + 1] = stmt end
    end
    return list
end

local function runFile(path)
    local sql = LoadResourceFile(resource, path)
    if not sql then error(('Missing SQL file: %s'):format(path)) end
    for _, stmt in ipairs(statements(sql)) do
        MySQL.query.await(stmt)
    end
end

local function setVersion(v)
    MySQL.query.await("INSERT INTO `vg_meta` (`key`, `value`) VALUES ('schema_version', ?) ON DUPLICATE KEY UPDATE `value` = VALUES(`value`)", { tostring(v) })
end

function Migrations.Run()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `vg_meta` (
            `key`   VARCHAR(64)  NOT NULL PRIMARY KEY,
            `value` VARCHAR(255) NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    local current = tonumber(MySQL.scalar.await("SELECT `value` FROM `vg_meta` WHERE `key` = 'schema_version'")) or 0

    if current == 0 then
        runFile('sql/install.sql')
        setVersion(SCHEMA_VERSION)
        lib.print.info('Database set up from sql/install.sql')
        current = SCHEMA_VERSION
    elseif current < BASE_VERSION then
        lib.print.error(('Database is from a pre-release build (version %d). Drop the vg_ tables and restart to set it up fresh.'):format(current))
        return
    end

    local v = current + 1
    while v <= SCHEMA_VERSION and UPDATES[v] do
        runFile(UPDATES[v])
        setVersion(v)
        lib.print.info(('Database updated to version %d'):format(v))
        v = v + 1
    end
end
