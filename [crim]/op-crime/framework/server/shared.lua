Framework = nil
Fr = {}

jobCache = {}

Fr.getOnlineJobCount = function(jobName)
    local count = 0
    for _, jobData in pairs(jobCache) do
        if jobData.name == jobName then
            count = count + 1
        end
    end
    return count
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Online members index (orgId -> { [src]=true })
-- Avoids O(N) pair() iterations of playersJobs on every server-to-client event.
-- ──────────────────────────────────────────────────────────────────────────────
Fr.onlineByOrg = {}

Fr.attachOnline = function(src, orgId)
    if not src then return end
    orgId = tonumber(orgId)
    if not orgId then return end

    local bucket = Fr.onlineByOrg[orgId]
    if not bucket then
        bucket = {}
        Fr.onlineByOrg[orgId] = bucket
    end
    bucket[src] = true
end

Fr.detachOnline = function(src, orgId)
    if not src then return end
    if orgId ~= nil then
        orgId = tonumber(orgId)
        local bucket = Fr.onlineByOrg[orgId]
        if bucket then
            bucket[src] = nil
            if next(bucket) == nil then Fr.onlineByOrg[orgId] = nil end
        end
        return
    end

    for oid, bucket in pairs(Fr.onlineByOrg) do
        if bucket[src] then
            bucket[src] = nil
            if next(bucket) == nil then Fr.onlineByOrg[oid] = nil end
        end
    end
end

Fr.reattachOnline = function(src, newOrgId, oldOrgId)
    if oldOrgId ~= nil and tonumber(oldOrgId) ~= tonumber(newOrgId) then
        Fr.detachOnline(src, oldOrgId)
    end
    Fr.attachOnline(src, newOrgId)
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Player name cache (identifier -> name)
-- Avoids hammering players/users table for every offline lookup.
-- ──────────────────────────────────────────────────────────────────────────────
Fr.nameCache = {}
local NAME_CACHE_TTL = 300

Fr.cacheName = function(identifier, name)
    if not identifier or not name then return end
    Fr.nameCache[identifier] = { name = name, ts = os.time() }
end

Fr.getCachedName = function(identifier)
    local entry = Fr.nameCache[identifier]
    if not entry then return nil end
    if (os.time() - entry.ts) > NAME_CACHE_TTL then
        Fr.nameCache[identifier] = nil
        return nil
    end
    return entry.name
end

function Fr.FireRegisteredItem(src, itemEvent)
    src = tonumber(src)
    TriggerClientEvent('op-crime:' .. itemEvent, src)
end

function generatePlate() 
    math.randomseed(GetGameTimer())
    local charSet = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

    local generatedPlate = nil

    for i = 1, 8 do
        if generatedPlate == nil then
            generatedPlate = charSet[math.random(#charSet)]
        else 
            generatedPlate = generatedPlate .. charSet[math.random(#charSet)] 
        end	
    end

    local isTaken = Fr.IsPlateTaken(generatedPlate)
    if isTaken then 
        return generatePlate()
    end

    return generatedPlate
end