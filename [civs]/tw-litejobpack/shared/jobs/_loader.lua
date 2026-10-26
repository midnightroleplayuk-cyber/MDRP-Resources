Config.Jobs = Config.Jobs or {}

local jobFiles = {
    'miner',
    'lumberjack',
    'farmer',
    'fruitpicker',
    'cleaner',
    'powerwash',
    'windowscleaner',
    'cardetailer',
    'scrapyard',
    'hunting',
    'newspaper',
    'cleanup',
    'trucker',
    'taxi',
    'dogwalking',
    'powerlines',
    'delivery',
    'warehouse',
    'landscaping',
    'fishing',
    'diving',
    'forklift',
    'tiretechnician',
    'treasurehunter',
    'metaldetector',
    'gruppe6',

}


local countRangeFields = {
    crateCount = true, panelCount = true, poleCount = true,
    pipeGroupCount = true, toiletCount = true, brokenPipeCount = true,
    taskCount = true, ballCount = true, repairCount = true,
    boxes = true, pallets = true, bagsPerBank = true,
}

local truncateArrays = {

    rockSpawns = 3, treeSpawns = 4, scrapSpawns = 3,
    plantSpawns = 3, treeLocations = 4,

    locations = 3, deliveryLocations = 3,
    pickupLocations = 3, dropoffLocations = 3,
    illegalLocations = 2, homeLocations = 3, locationPool = 4,

    panelLocations = 2, poleLocations = 2,
    toiletLocations = 2, pipeGroupLocations = 2,
    repairLocations = 6,

    stains = 2, pestSpots = 2, carLocations = 3, washSpots = 3, polishPoints = 2,

    searchZones = 2,

    banks = 2,
}

local reduceNumbers = {
    spawnCount = 3,
    hitsRequired = 3,
    maxBags = 2,
    count = 3,
    spotsPerRound = 3,
    maxBanks = 2,
}

local skipFields = {
    cargoPositions = true, trunkPositions = true,
    toolPositions = true, vehiclePositions = true,
    vehicle = true, tools = true, npc = true,
    coords = true, coord = true, spawn = true, blip = true,
    sellConfig = true, sellItems = true,
    fishTypes = true, rod = true, rope = true,
    pestTypes = true, levelConfig = true,
    gear = true, taskTypes = true, binModels = true,
    binDetection = true, lootTable = true, animation = true,
    anchor = true, processing = true, scale = true,
    deliveryPoint = true, vehicleSpawns = true,
    props = true, propSwap = true, drawText = true,
    tiers = true, items = true, animalCarryConfig = true, carModels = true,
}

local function ApplyTestOverrides(job)
    if not job.runtime then return end

    local function processTable(tbl)
        if type(tbl) ~= 'table' then return end

        for k, v in pairs(tbl) do
            if type(k) == 'string' and skipFields[k] then

            elseif type(v) == 'table' then

                if type(k) == 'string' and countRangeFields[k]
                    and type(v.min) == 'number' and type(v.max) == 'number' then
                    v.min = math.min(v.min, 1)
                    v.max = math.min(v.max, 2)

                elseif type(k) == 'string' and truncateArrays[k] and #v > truncateArrays[k] then
                    local maxLen = truncateArrays[k]
                    for i = #v, maxLen + 1, -1 do
                        v[i] = nil
                    end

                    for _i, item in ipairs(v) do
                        if type(item) == 'table' then
                            processTable(item)
                        end
                    end
                else

                    processTable(v)
                end
            elseif type(v) == 'number' and type(k) == 'string' and reduceNumbers[k] then
                tbl[k] = math.min(v, reduceNumbers[k])
            end
        end
    end

    processTable(job.runtime)
end

local resourceName = GetCurrentResourceName()

for _i, jobFile in ipairs(jobFiles) do
    local jobPath = ('@%s/shared/jobs/%s.lua'):format(resourceName, jobFile)
    local job = LoadResourceFile(resourceName, ('shared/jobs/%s.lua'):format(jobFile))

    if job then

        local fn, err = load(job, jobPath, 't', _G)
        if fn then
            local success, result = pcall(fn)
            if success and result and result.id then


                if Config.Test then
                    ApplyTestOverrides(result)
                end

                result._sourceFile = jobFile
                Config.Jobs[result.id] = result

            else
                local errMsg = not success and tostring(result) or "no id field or nil return"
                print(('[JobPack] ^1ERROR^7 Failed to load job %s: %s'):format(jobFile, errMsg))
            end
        else
            print(('[JobPack] ^1ERROR^7 Failed to parse job %s: %s'):format(jobFile, err or 'unknown error'))
        end
    else
        print(('[JobPack] ^1WARNING^7 Job file not found: %s'):format(jobFile))
    end
end

local totalCount = 0
local enabledCount = 0
for _i, job in pairs(Config.Jobs) do
    totalCount = totalCount + 1
    if job.enabled then
        enabledCount = enabledCount + 1
    end
end
print(('[JobPack] Total jobs loaded: %d (%d enabled, %d disabled)'):format(totalCount, enabledCount, totalCount - enabledCount))

if Config.Test then
    print('[JobPack] ^3TEST MODE ACTIVE^7 - Task counts reduced to 1-2 for quick testing')
end
