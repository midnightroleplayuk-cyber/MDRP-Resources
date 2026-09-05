while Framework == nil do Wait(5) end

local function normalizeJobId(jobId)
    if jobId == nil then return nil end
    return tostring(jobId)
end

local function normalizeTurfIndex(turfIndex)
    if turfIndex == nil then return nil end
    return tostring(turfIndex)
end

local function getTurfZone(turfIndex)
    local key = normalizeTurfIndex(turfIndex)
    if not key then return nil end
    return turfzones[key]
end

local function getOrganisation(jobId)
    local key = normalizeJobId(jobId)
    if not key then return nil end
    return organisations[key]
end

local function rebuildLoyalityList(loyalityList, mutator)
    local out = {}
    for _, v in pairs(loyalityList or {}) do
        local keep = mutator(v)
        if keep then
            table.insert(out, v)
        end
    end
    return out
end

function decreaseSelected(jobId, decreaseAmount, turfIndex)
    local jobIdKey = normalizeJobId(jobId)
    local turfKey = normalizeTurfIndex(turfIndex)
    local turfZone = getTurfZone(turfIndex)
    local currentOrg = getOrganisation(jobId)

    if turfZone and currentOrg then
        turfZone.loyalityList = rebuildLoyalityList(turfZone.loyalityList, function(v)
            if tostring(v.jobId) == jobIdKey then
                if v.influencePoints >= decreaseAmount then
                    v.influencePoints = v.influencePoints - decreaseAmount
                    return true
                end
                return false
            end
            return true
        end)
        if markTurfDirty then markTurfDirty(turfKey) end
        if notifyTurfZoneUpdated then notifyTurfZoneUpdated(turfKey, 'loyality') end
    else
        if not turfZone then
            print('Unable to decrease Zone Loyality 02 - no turf inside global var', turfKey or turfIndex)
        elseif not currentOrg then
            print('Unable to decrease Zone Loyality 02 - no current org', turfKey or turfIndex, jobIdKey or jobId)
        else
            print('Unable to decrease Zone Loyality 02', turfKey or turfIndex)
        end
    end
end
exports("decreaseSelected", decreaseSelected)

function increaseSelected(jobId, amount, turfIndex)
    local jobIdKey = normalizeJobId(jobId)
    local turfKey = normalizeTurfIndex(turfIndex)
    local turfZone = getTurfZone(turfIndex)
    local currentOrg = getOrganisation(jobId)

    if turfZone and currentOrg then
        local updated = false
        local copyTurf = rebuildLoyalityList(turfZone.loyalityList, function(v)
            if tostring(v.jobId) == jobIdKey then
                updated = true
                v.influencePoints = v.influencePoints + amount
            end
            return true
        end)

        if not updated then
            table.insert(copyTurf, {
                gangName = currentOrg.label,
                jobId = tonumber(jobIdKey),
                influencePoints = amount
            })
        end

        turfZone.loyalityList = copyTurf
        if markTurfDirty then markTurfDirty(turfKey) end
        if notifyTurfZoneUpdated then notifyTurfZoneUpdated(turfKey, 'loyality') end
    else
        if not turfZone then
            print('Unable to increase Zone Loyality 03 - no turf inside global var', turfKey or turfIndex)
        elseif not currentOrg then
            print('Unable to increase Zone Loyality 03 - no current org', turfKey or turfIndex, jobIdKey or jobId)
        else
            print('Unable to increase Zone Loyality 03', turfKey or turfIndex)
        end
    end
end
exports("increaseSelected", increaseSelected)

function increaseZoneLoyalityOnlyTwo(firstjobId, secondjobId, amount, turfIndex, decreaseAmount)
    local firstJobIdKey = normalizeJobId(firstjobId)
    local secondJobIdKey = normalizeJobId(secondjobId)
    local turfKey = normalizeTurfIndex(turfIndex)
    local turfZone = getTurfZone(turfIndex)
    local currentOrg = getOrganisation(firstjobId)

    if turfZone and currentOrg then
        local updatedMyOrg = false
        local copyTurf = rebuildLoyalityList(turfZone.loyalityList, function(v)
            if tostring(v.jobId) == firstJobIdKey then
                updatedMyOrg = true
                v.influencePoints = v.influencePoints + amount
                return true
            end

            if tostring(v.jobId) == secondJobIdKey then
                if v.influencePoints >= decreaseAmount then
                    v.influencePoints = v.influencePoints - decreaseAmount
                    return true
                end
                return false
            end

            return true
        end)

        if not updatedMyOrg then
            table.insert(copyTurf, {
                gangName = currentOrg.label,
                jobId = tonumber(firstJobIdKey),
                influencePoints = amount
            })
        end

        turfZone.loyalityList = copyTurf
        if markTurfDirty then markTurfDirty(turfKey) end
        if notifyTurfZoneUpdated then notifyTurfZoneUpdated(turfKey, 'loyality') end
    else
        print('Unable to increase Zone Loyality 04', turfKey or turfIndex, 'org:', firstJobIdKey or firstjobId)
    end
end

function increaseZoneLoyality(jobId, amount, turfIndex, decreaseAmount)
    local jobIdKey = normalizeJobId(jobId)
    local turfKey = normalizeTurfIndex(turfIndex)
    local turfZone = getTurfZone(turfIndex)
    local currentOrg = getOrganisation(jobId)

    if turfZone and currentOrg then
        local updatedMyOrg = false
        local copyTurf = rebuildLoyalityList(turfZone.loyalityList, function(v)
            if tostring(v.jobId) == jobIdKey then
                updatedMyOrg = true
                v.influencePoints = v.influencePoints + amount
                return true
            end

            if v.influencePoints >= decreaseAmount then
                v.influencePoints = v.influencePoints - decreaseAmount
                return true
            end

            return false
        end)

        if not updatedMyOrg then
            table.insert(copyTurf, {
                gangName = currentOrg.label,
                jobId = tonumber(jobIdKey),
                influencePoints = amount
            })
        end

        turfZone.loyalityList = copyTurf
        if markTurfDirty then markTurfDirty(turfKey) end
        if notifyTurfZoneUpdated then notifyTurfZoneUpdated(turfKey, 'loyality') end
    else
        if not turfZone then
            print('Unable to increase Zone Loyality - no turf inside global var', turfKey or turfIndex)
        elseif not currentOrg then
            print('Unable to increase Zone Loyality - no current org', turfKey or turfIndex, jobIdKey or jobId)
        else
            print('Unable to increase Zone Loyality', turfKey or turfIndex)
        end
    end
end
exports("increaseZoneLoyality", increaseZoneLoyality)
