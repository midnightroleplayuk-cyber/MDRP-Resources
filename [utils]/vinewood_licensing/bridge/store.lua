-- =============================================================
--  Driver store: the script's own source of truth.
--
--  Licence categories and the DVLA record (photo, entitlement,
--  points, bans) live in `vinewood_licensing_drivers`, so the
--  script works the same on Qbox, QBCore and ESX.
--
--  On Qbox/QBCore the categories are also mirrored into
--  metadata.licences, so other resources reading that keep
--  working, and existing characters are imported from it.
-- =============================================================

Store = {}

local cache = {}      -- [cid] = { licences = {}, dvla = {} }
local ready = false

CreateThread(function()
    if GetResourceState('oxmysql') ~= 'started' then
        print('^1[vinewood_licensing]^7 oxmysql is required')
        return
    end
    local ok, err = pcall(function()
        MySQL.query.await([[
            CREATE TABLE IF NOT EXISTS vinewood_licensing_drivers (
                citizenid VARCHAR(64) NOT NULL PRIMARY KEY,
                licences LONGTEXT DEFAULT NULL,
                dvla LONGTEXT DEFAULT NULL,
                updated_at INT NOT NULL
            )
        ]])
    end)
    ready = ok
    if not ok then print('^1[vinewood_licensing]^7 could not create drivers table: ' .. tostring(err)) end
end)

local function decode(v)
    if type(v) ~= 'string' then return type(v) == 'table' and v or {} end
    local ok, decoded = pcall(json.decode, v)
    return ok and type(decoded) == 'table' and decoded or {}
end

local function load(cid, src)
    if not cid then return { licences = {}, dvla = {} } end
    if cache[cid] then return cache[cid] end

    local entry = { licences = {}, dvla = {} }
    if ready then
        local row
        pcall(function()
            row = MySQL.single.await('SELECT licences, dvla FROM vinewood_licensing_drivers WHERE citizenid = ?', { cid })
        end)
        if row then
            entry.licences = decode(row.licences)
            entry.dvla = decode(row.dvla)
        end
    end

    -- First time on this character: import whatever the framework already holds
    if next(entry.licences) == nil and src and FW.SupportsMetadata() then
        local meta = FW.GetMetadata(src, 'licences')
        if type(meta) == 'table' then
            for k, v in pairs(meta) do
                if v == true and Config.VehicleCategories[k] then entry.licences[k] = true end
            end
        end
        local dvla = FW.GetMetadata(src, 'dvla')
        if type(dvla) == 'table' and next(entry.dvla) == nil then entry.dvla = dvla end
    end

    cache[cid] = entry
    return entry
end

local function persist(cid)
    if not cid then return end
    local entry = cache[cid]
    if not entry or not ready then return end
    pcall(function()
        MySQL.prepare.await([[
            INSERT INTO vinewood_licensing_drivers (citizenid, licences, dvla, updated_at)
            VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE licences = VALUES(licences), dvla = VALUES(dvla), updated_at = VALUES(updated_at)
        ]], { cid, json.encode(entry.licences or {}), json.encode(entry.dvla or {}), os.time() })
    end)
end

--- Licence categories held, e.g. { car = true }
function Store.Licences(src, cid)
    cid = cid or FW.Cid(src)
    return load(cid, src).licences
end

function Store.SetLicences(src, licences)
    local cid = FW.Cid(src)
    if not cid then return end
    local entry = load(cid, src)
    entry.licences = licences or {}
    persist(cid)
    -- keep the framework copy in step for other resources
    if FW.SupportsMetadata() then FW.SetMetadata(src, 'licences', entry.licences) end
end

--- The DVLA record: photo, provisional entitlement, points, ban.
function Store.Record(src, cid)
    cid = cid or FW.Cid(src)
    return load(cid, src).dvla
end

function Store.SetRecord(src, record)
    local cid = FW.Cid(src)
    if not cid then return end
    local entry = load(cid, src)
    entry.dvla = record or {}
    persist(cid)
    if FW.SupportsMetadata() then FW.SetMetadata(src, 'dvla', entry.dvla) end
end

--- Offline read straight from the table.
function Store.Offline(cid)
    if not cid or not ready then return nil end
    local row
    pcall(function()
        row = MySQL.single.await('SELECT licences, dvla FROM vinewood_licensing_drivers WHERE citizenid = ?', { cid })
    end)
    if not row then return nil end
    return { licences = decode(row.licences), dvla = decode(row.dvla) }
end

function Store.Drop(cid)
    if cid then cache[cid] = nil end
end
