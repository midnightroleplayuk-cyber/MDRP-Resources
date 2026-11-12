DB = {}

local schema = {
    [[CREATE TABLE IF NOT EXISTS `vinewood_multichar_scenes` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `name` VARCHAR(64) NOT NULL,
        `enabled` TINYINT(1) NOT NULL DEFAULT 1,
        `weight` INT NOT NULL DEFAULT 1,
        `data` LONGTEXT NOT NULL,
        `updated_by` VARCHAR(64) DEFAULT NULL,
        `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],
    [[CREATE TABLE IF NOT EXISTS `vinewood_multichar_slots` (
        `identifier` VARCHAR(80) NOT NULL,
        `mode` VARCHAR(8) NOT NULL DEFAULT 'add',
        `slots` INT NOT NULL DEFAULT 0,
        `note` VARCHAR(128) DEFAULT NULL,
        `name` VARCHAR(64) DEFAULT NULL,
        `set_by` VARCHAR(64) DEFAULT NULL,
        `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`identifier`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],
    [[CREATE TABLE IF NOT EXISTS `vinewood_multichar_settings` (
        `k` VARCHAR(64) NOT NULL,
        `v` LONGTEXT NOT NULL,
        PRIMARY KEY (`k`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],
}

local ready = false
local readyPromise = promise.new()

CreateThread(function()
    for _, q in ipairs(schema) do
        MySQL.query.await(q)
    end
    ready = true
    readyPromise:resolve(true)
end)

function DB.Await()
    if not ready then Citizen.Await(readyPromise) end
end

-- Settings (JSON blob per key) -------------------------------------------------
function DB.GetSetting(key, default)
    DB.Await()
    local v = MySQL.scalar.await('SELECT v FROM vinewood_multichar_settings WHERE k = ?', { key })
    if not v then return default end
    local ok, decoded = pcall(json.decode, v)
    return ok and decoded or default
end

function DB.SetSetting(key, value)
    DB.Await()
    MySQL.query.await('INSERT INTO vinewood_multichar_settings (k, v) VALUES (?, ?) ON DUPLICATE KEY UPDATE v = VALUES(v)', { key, json.encode(value) })
end

-- Logging ----------------------------------------------------------------------
function DB.Log(title, description)
    print(('^3[vinewood_multichar]^7 %s: %s'):format(title, description))
    if ServerConfig.LogWebhook == '' then return end
    PerformHttpRequest(ServerConfig.LogWebhook, function() end, 'POST', json.encode({
        username = 'Vinewood Multichar',
        embeds = { { title = title, description = description, color = 15903035, timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ') } },
    }), { ['Content-Type'] = 'application/json' })
end
