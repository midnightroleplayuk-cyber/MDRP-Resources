-- Septra terminal records (ISSI, callsign, last talkgroup, volume) per character.
-- Reads once per character on power-on, then served from Cache. Writes are single-row and async.
DB = {}

local Cache = {} -- [identifier] = { issi, service, callsign, lastTg, volume }

local SCHEMA = [[
CREATE TABLE IF NOT EXISTS `vinewood_radio` (
    `identifier` VARCHAR(64) NOT NULL,
    `issi` VARCHAR(8) NOT NULL,
    `service` VARCHAR(32) NOT NULL,
    `callsign` VARCHAR(32) NOT NULL,
    `last_tg` VARCHAR(64) DEFAULT NULL,
    `last_tg2` VARCHAR(64) DEFAULT NULL,
    `volume` TINYINT UNSIGNED NOT NULL DEFAULT 60,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`),
    UNIQUE KEY `uq_issi` (`issi`)
)]]

MySQL.ready(function()
    MySQL.query.await(SCHEMA)
    -- Older installs had VARCHAR(16); widen it so longer callsigns aren't cut off
    MySQL.query('ALTER TABLE `vinewood_radio` MODIFY `callsign` VARCHAR(32) NOT NULL')
    -- Secondary talkgroup column (added in 1.2.0). Checked first: MySQL 8 has no ADD COLUMN IF NOT EXISTS
    local has = MySQL.scalar.await([[SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vinewood_radio' AND COLUMN_NAME = 'last_tg2']])
    if (tonumber(has) or 0) == 0 then
        MySQL.query('ALTER TABLE `vinewood_radio` ADD COLUMN `last_tg2` VARCHAR(64) DEFAULT NULL AFTER `last_tg`')
    end
end)

local function nextIssi(serviceKey)
    local prefix = Config.Services[serviceKey].issiPrefix or '9'
    local rows = MySQL.query.await('SELECT `issi` FROM `vinewood_radio` WHERE `issi` LIKE ?', { prefix .. '%' }) or {}
    local used = {}
    for i = 1, #rows do used[rows[i].issi] = true end
    for n = 1, 999 do
        local issi = prefix .. ('%03d'):format(n)
        if not used[issi] then return issi end
    end
    return prefix .. tostring(math.random(1000, 9999))
end

-- Writes a new ISSI for this character. Retries if another player grabbed the same number at the same moment.
local function allocate(identifier, serviceKey, exists)
    for _ = 1, 5 do
        local issi = nextIssi(serviceKey)
        local ok, res = pcall(function()
            if exists then
                return MySQL.update.await(
                    'UPDATE `vinewood_radio` SET `issi` = ?, `service` = ?, `callsign` = ?, `last_tg` = NULL WHERE `identifier` = ?',
                    { issi, serviceKey, issi, identifier })
            end
            return MySQL.insert.await(
                'INSERT INTO `vinewood_radio` (`identifier`, `issi`, `service`, `callsign`, `volume`) VALUES (?, ?, ?, ?, 60)',
                { identifier, issi, serviceKey, issi })
        end)
        if ok and res then return issi end
    end
end

---Returns the character's record, creating it (or reissuing the ISSI on a service change) if needed.
---@return { issi: string, service: string, callsign: string, lastTg: string?, volume: number }?
function DB.Get(identifier, serviceKey)
    local rec = Cache[identifier]

    if not rec then
        local row = MySQL.single.await(
            'SELECT `issi`, `service`, `callsign`, `last_tg`, `last_tg2`, `volume` FROM `vinewood_radio` WHERE `identifier` = ?',
            { identifier })
        if row then
            rec = { issi = row.issi, service = row.service, callsign = row.callsign, lastTg = row.last_tg, lastTg2 = row.last_tg2, volume = row.volume }
        end
    end

    if not rec or rec.service ~= serviceKey then
        local issi = allocate(identifier, serviceKey, rec ~= nil)
        if not issi then return nil end
        rec = { issi = issi, service = serviceKey, callsign = issi, lastTg = nil, volume = rec and rec.volume or 60 }
    end

    Cache[identifier] = rec
    return rec
end

function DB.SetCallsign(identifier, callsign)
    local rec = Cache[identifier]
    if rec then rec.callsign = callsign end
    MySQL.update('UPDATE `vinewood_radio` SET `callsign` = ? WHERE `identifier` = ?', { callsign, identifier })
end

function DB.SetLastTalkgroup(identifier, tg)
    local rec = Cache[identifier]
    if not rec or rec.lastTg == tg then return end
    rec.lastTg = tg
    MySQL.update('UPDATE `vinewood_radio` SET `last_tg` = ? WHERE `identifier` = ?', { tg, identifier })
end

function DB.SetSecondaryTalkgroup(identifier, tg)
    local rec = Cache[identifier]
    if rec then
        if rec.lastTg2 == tg then return end
        rec.lastTg2 = tg
    end
    MySQL.update('UPDATE `vinewood_radio` SET `last_tg2` = ? WHERE `identifier` = ?', { tg, identifier })
end

function DB.SetVolume(identifier, volume)
    local rec = Cache[identifier]
    if rec then rec.volume = volume end
    MySQL.update('UPDATE `vinewood_radio` SET `volume` = ? WHERE `identifier` = ?', { volume, identifier })
end
