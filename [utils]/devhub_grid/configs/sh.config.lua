-- ============================================================
-- Grid System: Shared Config & Debug Helpers
-- Loaded first on BOTH client and server (configs/sh.*.lua in fxmanifest).
-- Must define debugPrint/safeEncode before any other file calls them.
-- ============================================================

Config = Config or {}

-- bool | Enable verbose debug logging across the whole resource.
-- Leave false in production. Set true to trace zone / prop / placement
-- issues such as "no free space inside the vehicle" reports.
Config.Debug = false

-- Gated debug logger. Silent unless Config.Debug is true.
function debugPrint(...)
    if Config.Debug then
        print('^2devhub_grid^7', ...)
    end
end

-- Safe JSON encoder for logging tables (never throws).
function safeEncode(value)
    local ok, encoded = pcall(json.encode, value)
    if ok then return encoded end
    return '<safeEncode failed: ' .. tostring(encoded) .. '>'
end

debugPrint("^5sh.config.lua: file loaded, Config.Debug =^7", tostring(Config.Debug))
