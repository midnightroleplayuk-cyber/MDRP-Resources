NDM.Venue = {}

local Cache = {}

local function decode(value)
    local ok, result = pcall(json.decode, value or '{}')
    return ok and type(result) == 'table' and result or {}
end

local function sanitizeRank(config, isBoss)
    config = type(config) == 'table' and config or {}
    local permissions = {}
    for _, permission in ipairs(NDM.Permissions) do
        if isBoss or (type(config.permissions) == 'table' and config.permissions[permission] == true) then
            permissions[permission] = true
        end
    end
    return {
        permissions = permissions,
        commission = math.max(0, math.min(100, math.floor(tonumber(config.commission) or 0))),
        salary = math.max(0, math.min(NDM.MaxMoney, math.floor(tonumber(config.salary) or 0))),
        boss = isBoss == true,
    }
end

local function seedRanks(job, existing)
    local ranks = existing or {}
    for _, grade in ipairs(Bridge.GetJobGrades(job)) do
        local key = tostring(grade.grade)
        if type(ranks[key]) ~= 'table' then
            ranks[key] = { permissions = NDM.DefaultRankPermissions }
        end
        ranks[key] = sanitizeRank(ranks[key], grade.isBoss)
    end
    return ranks
end

function NDM.Venue.Load()
    Cache = {}
    local rows = MySQL.query.await('SELECT * FROM `ndm_business_venues`') or {}
    local count = 0
    for _, row in ipairs(rows) do
        row.ranks = seedRanks(row.job, decode(row.ranks))
        row.metadata = decode(row.metadata)
        Cache[row.id] = row
        count = count + 1
    end
    return count
end

function NDM.Venue.Get(id)
    return Cache[tonumber(id)]
end

function NDM.Venue.All()
    return Cache
end

function NDM.Venue.Create(data)
    data = type(data) == 'table' and data or {}
    local venueType = tostring(data.type or ''):lower()
    local job = tostring(data.job or '')
    local label = tostring(data.label or ''):gsub('^%s+', ''):gsub('%s+$', ''):sub(1, 64)

    if not NDM.VenueTypes[venueType] then return nil, 'invalid_type' end
    if not Bridge.JobExists(job) then return nil, 'invalid_job' end
    if label == '' then return nil, 'invalid_label' end

    local ranks = seedRanks(job)
    local id = MySQL.insert.await([[
        INSERT INTO `ndm_business_venues` (`type`, `label`, `job`, `owner_citizenid`, `ranks`, `metadata`)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], { venueType, label, job, data.owner_citizenid, json.encode(ranks), '{}' })
    if not id then return nil, 'database_error' end

    Cache[id] = {
        id = id,
        type = venueType,
        label = label,
        job = job,
        owner_citizenid = data.owner_citizenid,
        ranks = ranks,
        metadata = {},
    }
    return Cache[id]
end

-- Deletes the venue and everything stored for it in one transaction.
function NDM.Venue.Delete(venueId)
    local id = tonumber(venueId)
    if not id or not Cache[id] then return false end
    local queries = {}
    for _, tableName in ipairs({
        'ndm_business_points', 'ndm_business_stock', 'ndm_business_prices',
        'ndm_business_club_passes', 'ndm_business_club_bans', 'ndm_business_supply_orders',
        'ndm_business_ledger',
    }) do
        queries[#queries + 1] = { query = ('DELETE FROM `%s` WHERE `venue_id` = ?'):format(tableName), values = { id } }
    end
    queries[#queries + 1] = { query = 'DELETE FROM `ndm_business_venues` WHERE `id` = ?', values = { id } }
    if not MySQL.transaction.await(queries) then return false end
    Cache[id] = nil
    return true
end

function NDM.Venue.SaveOwnership(venue)
    MySQL.update.await('UPDATE `ndm_business_venues` SET `owner_citizenid` = ?, `metadata` = ? WHERE `id` = ?', {
        venue.owner_citizenid,
        json.encode(venue.metadata),
        venue.id,
    })
end

function NDM.Venue.RankFor(venueId, grade)
    local venue = NDM.Venue.Get(venueId)
    if not venue then return nil end
    local rank = venue.ranks[tostring(tonumber(grade) or 0)]
    -- A grade missing from the job definition is still staff, but never a boss.
    return rank or sanitizeRank({ permissions = NDM.DefaultRankPermissions }, false)
end

function NDM.Venue.SetRank(venueId, grade, config)
    local venue = NDM.Venue.Get(venueId)
    grade = tonumber(grade)
    if not venue or not grade then return false end

    local isBoss = false
    for _, jobGrade in ipairs(Bridge.GetJobGrades(venue.job)) do
        if jobGrade.grade == grade then isBoss = jobGrade.isBoss end
    end

    venue.ranks[tostring(grade)] = sanitizeRank(config, isBoss)
    MySQL.update.await('UPDATE `ndm_business_venues` SET `ranks` = ? WHERE `id` = ?', {
        json.encode(venue.ranks),
        venue.id,
    })
    return true
end

-- The single authority for venue access. It is read live, so job changes apply at once.
function NDM.Venue.ResolvePerms(venueId, src)
    local venue = NDM.Venue.Get(venueId)
    if not venue then return nil, false, nil end
    if Bridge.IsAdmin(src) then return NDM.AllPermissions, true, nil end

    local citizenId = Bridge.GetCitizenId(src)
    if not citizenId then return nil, false, nil end
    if venue.owner_citizenid == citizenId then return NDM.AllPermissions, true, nil end

    local job = Bridge.GetJobInfo(src)
    if not job or job.name ~= venue.job then return nil, false, nil end
    if job.isBoss then return NDM.AllPermissions, true, job end

    local rank = NDM.Venue.RankFor(venueId, job.grade)
    if rank.boss then return NDM.AllPermissions, true, job end
    return rank.permissions, false, job
end

function NDM.Venue.HasPerm(venueId, src, permission)
    local permissions = NDM.Venue.ResolvePerms(venueId, src)
    return permissions ~= nil and permissions[permission] == true
end
