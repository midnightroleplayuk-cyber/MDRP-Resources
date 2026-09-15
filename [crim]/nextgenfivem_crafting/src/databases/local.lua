local dbPath = "/data/"
local dbFiles = {
    players = dbPath .. "players.json",
    categories = dbPath .. "categories.json",
    blueprints = dbPath .. "blueprints.json",
    recipes = dbPath .. "recipes.json",
    benchTypes = dbPath .. "bench-types.json",
    benchLocations = dbPath .. "bench-locations.json",
    benchLocationCrafts = dbPath .. "bench-location-crafts.json"
}

local function loadJSON(filePath)
    local content = LoadResourceFile(GetCurrentResourceName(), filePath)

    return json.decode(content) or {}
end

local saveDelay = 1500
local saveIds = {}

local function saveJSON(filePath, data)
    local currId = saveIds[filePath] and saveIds[filePath] + 1 or 1

    saveIds[filePath] = currId

    SetTimeout(saveDelay, function()
        if saveIds[filePath] ~= currId then return end

        SaveResourceFile(GetCurrentResourceName(), filePath, json.encode(data), -1)
    end)

    return true
end

local db = {}

function Init()
    local resourcePath = GetResourcePath(GetCurrentResourceName())

    local file = io.open(resourcePath .. dbPath, 'r')

    if not file then
        os.execute('mkdir "'.. resourcePath .. dbPath ..'"')
    else
        file:close()
    end

    db.players = loadJSON(dbFiles.players)
    db.categories = loadJSON(dbFiles.categories)
    db.blueprints = loadJSON(dbFiles.blueprints)
    db.recipes = loadJSON(dbFiles.recipes)
    db.benchTypes = loadJSON(dbFiles.benchTypes)
    db.benchLocations = loadJSON(dbFiles.benchLocations)
    db.benchLocationCrafts = loadJSON(dbFiles.benchLocationCrafts)

    if not db.players then db.players = {} end
    if not db.categories then db.categories = {} end
    if not db.blueprints then db.blueprints = {} end
    if not db.recipes then db.recipes = {} end
    if not db.benchTypes then db.benchTypes = {} end
    if not db.benchLocations then db.benchLocations = {} end
    if not db.benchLocationCrafts then db.benchLocationCrafts = {} end

    for _, benchType in pairs(db.benchTypes) do
        if benchType.access and type(benchType.access) == "string" then
            benchType.access = { benchType.access }
        end
    end

    while not LoadInitialData do
        Wait(500)
    end

    LoadInitialData()
end

local function generateUUID()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

Player = {
    Fetch = function(src, playerId)
        return db.players[playerId]
    end,

    Update = function(src, playerId, data)
        if not db.players[playerId] then
            db.players[playerId] = {
                identifier = playerId,
                level = 0,
                categories = {},
                blueprints = {},
                history = {}
            }
        end

        db.players[playerId].level = data.level ~= nil and data.level or db.players[playerId].level

        saveJSON(dbFiles.players, db.players)
        return true
    end,

    GetCategoryLevel = function(src, playerId, categoryId)
        return db.players[playerId] and db.players[playerId].categories[categoryId] or 0
    end,

    SetCategoryLevel = function(src, playerId, categoryId, level)
        if not db.players[playerId] then return false end

        db.players[playerId].categories[categoryId] = level

        saveJSON(dbFiles.players, db.players)
        return true
    end,

    FetchCategoryLevels = function(src, playerId)
        if not db.players[playerId] then return false end

        local categories = {}

        for categoryId, level in pairs(db.players[playerId].categories) do
            local category = db.categories[categoryId]

            if category then
                table.insert(categories, {
                    uuid = categoryId,
                    title = category.title,
                    level = level
                })
            end
        end

        return categories
    end,

    FetchBlueprints = function(src, playerId)
        if not db.players[playerId] then return false end

        local blueprints = {}

        for blueprintId, _ in pairs(db.players[playerId].blueprints) do
            local blueprint = db.blueprints[blueprintId]

            if blueprint then
                table.insert(blueprints, {
                    blueprint = blueprintId,
                    label = blueprint.label
                })
            end
        end

        return blueprints
    end,

    HasBlueprint = function(src, playerId, blueprintId)
        return db.players[playerId] and db.players[playerId].blueprints[blueprintId] ~= nil
    end,

    AddBlueprint = function(src, playerId, blueprintId)
        if not db.players[playerId] then
            db.players[playerId] = {
                identifier = playerId,
                level = 0,
                categories = {},
                blueprints = {},
                history = {}
            }
        end

        db.players[playerId].blueprints[blueprintId] = true
        saveJSON(dbFiles.players, db.players)
        return true
    end,

    RemoveBlueprint = function(src, playerId, blueprintId)
        if not db.players[playerId] then return false end

        db.players[playerId].blueprints[blueprintId] = nil

        saveJSON(dbFiles.players, db.players)

        return true
    end,

    AddHistory = function(src, playerId, historyData)
        if not db.players[playerId] then return false end

        if not db.players[playerId].history then
            db.players[playerId].history = {}
        end

        table.insert(db.players[playerId].history, table.merge({
            timestamp = os.time()
        }, historyData))

        return true
    end,

    GetRecentRecipeCrafts = function(playerId, recipeId, sinceEpoch)
        if not db.players[playerId] or not db.players[playerId].history then return 0 end

        local used = 0
        for _, h in ipairs(db.players[playerId].history) do
            if h.recipe == recipeId and (h.timestamp or 0) >= sinceEpoch then
                used = used + (h.quantity or 0)
            end
        end
        return used
    end,

    GetRecentRecipeCraftEvents = function(playerId, recipeId, sinceEpoch)
        if not db.players[playerId] or not db.players[playerId].history then return {} end

        local rows = {}
        for _, h in ipairs(db.players[playerId].history) do
            if h.recipe == recipeId and (h.timestamp or 0) >= sinceEpoch then
                table.insert(rows, { quantity = h.quantity or 0, ts = h.timestamp })
            end
        end
        table.sort(rows, function(a, b) return a.ts < b.ts end)
        return rows
    end,

    Clear = function()
        db.players = {}
        saveJSON(dbFiles.players, db.players)
    end
}

Categories = {
    Fetch = function()
        local categories = {}

        for _, category in pairs(db.categories) do
            table.insert(categories, category)
        end

        return categories
    end,

    FetchOne = function(categoryId)
        return db.categories[categoryId]
    end,

    SearchCategory = function(search)
        for _, category in pairs(db.categories) do
            if category.title:lower():find(search:lower()) then
                return category
            end
        end
    end,

    Create = function(data)
        local id = generateUUID()

        data.uuid = id
        db.categories[id] = data

        saveJSON(dbFiles.categories, db.categories)
        return id
    end,

    Update = function(data)
        if not db.categories[data.uuid] then return false end

        for k,v in pairs(data) do
            db.categories[data.uuid][k] = v
        end

        saveJSON(dbFiles.categories, db.categories)
        return true
    end,

    Delete = function(categoryId)
        db.categories[categoryId] = nil

        for recipeId, recipe in pairs(db.recipes) do
            if recipe.category == categoryId then
                db.recipes[recipeId] = nil
            end
        end

        saveJSON(dbFiles.categories, db.categories)
        saveJSON(dbFiles.recipes, db.recipes)

        return true
    end,

    FetchRecipes = function(categoryId)
        local recipes = {}

        for _, recipe in pairs(db.recipes) do
            if recipe.category == categoryId then
                table.insert(recipes, recipe)
            end
        end

        table.sort(recipes, function(a, b)
            return a.order < b.order
        end)

        return recipes
    end,

    Clear = function()
        db.categories = {}
        saveJSON(dbFiles.categories, db.categories)
    end
}

Recipes = {
    FetchOne = function(recipeId)
        return db.recipes[recipeId]
    end,

    FetchIngredients = function(recipeId)
        local ingredients = {}

        for _, ingredient in pairs(db.recipes[recipeId].ingredients) do
            table.insert(ingredients, ingredient)
        end

        return ingredients
    end,

    FetchBlueprints = function(recipeId)
        if not db.recipes[recipeId] then return false end

        local blueprints = {}

        if db.recipes[recipeId].blueprints then
            for _, blueprint in pairs(db.recipes[recipeId].blueprints) do
                table.insert(blueprints, blueprint)
            end
        end

        return blueprints
    end,

    Create = function(data)
        local id = generateUUID()

        db.recipes[id] = {
            uuid = id,
            title = data.title,
            description = data.description,
            category = data.category,
            requiredLevel = data.requiredLevel,
            requiredCategoryLevel = data.requiredCategoryLevel,
            craftingTime = data.craftingTime,
            xpReward = data.xpReward,
            propModel = data.propModel,
            propRotX = data.propRot.x,
            propRotY = data.propRot.y,
            propRotZ = data.propRot.z,
            propOffsetX = data.propOffset.x,
            propOffsetY = data.propOffset.y,
            propOffsetZ = data.propOffset.z,
            ingredients = data.ingredients,
            blueprints = data.blueprints,
            results = data.results
        }

        saveJSON(dbFiles.recipes, db.recipes)
        return id
    end,

    Delete = function(recipeId)
        db.recipes[recipeId] = nil
        saveJSON(dbFiles.recipes, db.recipes)
        return true
    end,

    Update = function(data)
        if not db.recipes[data.uuid] then return false end

        for k,v in pairs(data) do
            db.recipes[data.uuid][k] = v
        end

        saveJSON(dbFiles.recipes, db.recipes)
        return true
    end,

    SetCategory = function(id, category)
        if not id or not category then return false end

        if not db.recipes[id] then return false end

        db.recipes[id].category = category

        saveJSON(dbFiles.recipes, db.recipes)

        return true
    end,

    UpdateCategoryOrder = function(category, order)
        if not category or not order or #order == 0 then return false end

        if not db.categories[category] then return false end

        for _, item in ipairs(order) do
            if not db.recipes[item.recipe] then return false end
        end

        for _, item in ipairs(order) do
            db.recipes[item.recipe].order = item.order
        end

        saveJSON(dbFiles.recipes, db.recipes)
    end,

    Clear = function()
        db.recipes = {}
        saveJSON(dbFiles.recipes, db.recipes)
    end
}

Blueprints = {
    Fetch = function()
        local blueprints = {}

        for _, blueprint in pairs(db.blueprints) do
            table.insert(blueprints, blueprint)
        end

        return blueprints
    end,

    FetchOne = function(id)
        return db.blueprints[id]
    end,

    SearchBlueprint = function(search)
        for _, blueprint in pairs(db.blueprints) do
            if blueprint.label:lower():find(search:lower()) then
                return blueprint
            end
        end

        return nil
    end,

    GetTotal = function()
        local count = 0

        for _, _ in pairs(db.blueprints) do
            count = count + 1
        end

        return count
    end,

    Create = function(data)
        local id = generateUUID()

        data.uuid = id
        db.blueprints[id] = data

        saveJSON(dbFiles.blueprints, db.blueprints)
        return id
    end,

    Update = function(data)
        if not db.blueprints[data.uuid] then return false end

        for k,v in pairs(data) do
            db.blueprints[data.uuid][k] = v
        end

        saveJSON(dbFiles.blueprints, db.blueprints)
        return true
    end,

    Delete = function(id)
        db.blueprints[id] = nil
        saveJSON(dbFiles.blueprints, db.blueprints)
        return true
    end,

    Clear = function()
        db.blueprints = {}
        saveJSON(dbFiles.blueprints, db.blueprints)
        return true
    end
}

BenchTypes = {
    Fetch = function(data)
        local filteredBenchTypes = {}
        for id, benchType in pairs(db.benchTypes) do
            local match = true
            if data.columnFilters then
                for key, value in pairs(data.columnFilters) do
                    if benchType[key] ~= value then
                        match = false
                        break
                    end
                end
            end
            if match then
                table.insert(filteredBenchTypes, benchType)
            end
        end

        table.sort(filteredBenchTypes, function(a, b)
            if data.orderDirection == "asc" then
                return a[data.orderColumn] < b[data.orderColumn]
            else
                return a[data.orderColumn] > b[data.orderColumn]
            end
        end)

        local paginatedResult = {}
        for i = 1, data.count do
            local index = data.offset + i
            if filteredBenchTypes[index] then
                local benchType = filteredBenchTypes[index]

                benchType.locationCount = 0

                for _, location in pairs(db.benchLocations) do
                    if location.benchType == benchType.uuid then
                        benchType.locationCount = benchType.locationCount + 1
                    end
                end

                table.insert(paginatedResult, benchType)
            end
        end

        return { rows = paginatedResult, pageCount = math.ceil(#filteredBenchTypes / data.count) }
    end,

    FetchAll = function()
        local allBenchTypes = {}
        for _, benchType in pairs(db.benchTypes) do
            table.insert(allBenchTypes, benchType)
        end
        return allBenchTypes
    end,

    FetchOne = function(id)
        if not db.benchTypes[id] then return false end

        return db.benchTypes[id]
    end,

    FetchLocations = function(id)
        local locations = {}
        for _, location in pairs(db.benchLocations) do
            if location.benchType == id then
                table.insert(locations, location)
            end
        end
        return locations
    end,

    Search = function(search)
        for _, benchType in pairs(db.benchTypes) do
            if benchType.name:lower():find(search:lower()) then
                return benchType
            end
        end

        return nil
    end,

    Create = function(data)
        local id = generateUUID()

        data.uuid = id
        data.createdAt = os.time() * 1000

        db.benchTypes[id] = data

        saveJSON(dbFiles.benchTypes, db.benchTypes)
        return id
    end,

    Delete = function(id)
        db.benchTypes[id] = nil

        for locationId, location in pairs(db.benchLocations) do
            if location.benchType == id then
                db.benchLocations[locationId] = nil
            end
        end

        saveJSON(dbFiles.benchTypes, db.benchTypes)
        saveJSON(dbFiles.benchLocations, db.benchLocations)
        return true
    end,

    Update = function(data)
        if not db.benchTypes[data.uuid] then return false end

        for k,v in pairs(data) do
            db.benchTypes[data.uuid][k] = v
        end

        saveJSON(dbFiles.benchTypes, db.benchTypes)
        return true
    end,

    GetSharedLevel = function(benchTypeId)
        for _, bt in pairs(db.benchTypes) do
            if bt.uuid == benchTypeId and bt.sharedLevelData then
                return bt.sharedLevelData.global
            end
        end
        return nil
    end,

    SetSharedLevel = function(benchTypeId, level)
        if not db.benchTypes[benchTypeId] then return false end
        if not db.benchTypes[benchTypeId].sharedLevelData then
            db.benchTypes[benchTypeId].sharedLevelData = {}
        end
        db.benchTypes[benchTypeId].sharedLevelData.global = level
        saveJSON(dbFiles.benchTypes, db.benchTypes)
        return true
    end,

    GetSharedCategoryLevel = function(benchTypeId, categoryId)
        if not db.benchTypes[benchTypeId] or not db.benchTypes[benchTypeId].sharedLevelData then return nil end
        return db.benchTypes[benchTypeId].sharedLevelData[categoryId]
    end,

    SetSharedCategoryLevel = function(benchTypeId, categoryId, level)
        if not db.benchTypes[benchTypeId] then return false end
        if not db.benchTypes[benchTypeId].sharedLevelData then
            db.benchTypes[benchTypeId].sharedLevelData = {}
        end
        db.benchTypes[benchTypeId].sharedLevelData[categoryId] = level
        saveJSON(dbFiles.benchTypes, db.benchTypes)
        return true
    end,

    Clear = function()
        db.benchTypes = {}
        saveJSON(dbFiles.benchTypes, db.benchTypes)
    end
}

BenchLocations = {
    Fetch = function(data)
        local filteredBenchLocations = {}
        for _, location in pairs(db.benchLocations) do
            local match = true
            if data.columnFilters then
                for key, value in pairs(data.columnFilters) do
                    if location[key] ~= value then
                        match = false
                        break
                    end
                end
            end
            if match then
                table.insert(filteredBenchLocations, location)
            end
        end

        table.sort(filteredBenchLocations, function(a, b)
            if data.orderDirection == "asc" then
                return a[data.orderColumn] < b[data.orderColumn]
            else
                return a[data.orderColumn] > b[data.orderColumn]
            end
        end)

        local paginatedResult = {}
        for i = 1, data.count do
            local index = data.offset + i
            if filteredBenchLocations[index] then
                table.insert(paginatedResult, filteredBenchLocations[index])
            end
        end

        return { rows = paginatedResult, pageCount = math.ceil(#filteredBenchLocations / data.count) }
    end,

    FetchAll = function()
        local allBenchLocations = {}
        for id, location in pairs(db.benchLocations) do
            table.insert(allBenchLocations, location)
        end
        return allBenchLocations
    end,

    FetchOne = function(id)
        return db.benchLocations[id]
    end,

    Create = function(data)
        local id = generateUUID()

        db.benchLocations[id] = {
            uuid = id,
            benchType = data.benchType,
            locationX = data.location.x,
            locationY = data.location.y,
            locationZ = data.location.z,
            locationH = data.location.w,
            createdBy = data.createdBy,
            createdAt = os.time(),
            isPortable = data.isPortable,
            sharedLevels = data.sharedLevels,
            sharedQueue = data.sharedQueue,
            routingBucket = data.routingBucket,
        }

        saveJSON(dbFiles.benchLocations, db.benchLocations)
        return id
    end,

    Update = function(data)
        if not db.benchLocations[data.uuid] then return false end

        for k,v in pairs(data) do
            db.benchLocations[data.uuid][k] = v
        end

        saveJSON(dbFiles.benchLocations, db.benchLocations)
        return true
    end,

    Delete = function(id)
        db.benchLocations[id] = nil
        saveJSON(dbFiles.benchLocations, db.benchLocations)
        return true
    end,

    AddPlayerCraft = function(src, data)
        if not data then return false end

        db.benchLocationCrafts[data.craftId] = {
            craftId = data.craftId,
            userId = data.userId,
            recipe = data.recipe,
            quantity = data.quantity,
            startedAt = data.startedAt,
            completedAt = data.completedAt,
            pausedAt = 0, -- Default to 0, meaning not paused
            removedItems = data.removedItems,
            resultItems = data.resultItems,
            location = data.location
        }

        saveJSON(dbFiles.benchLocationCrafts, db.benchLocationCrafts)

        return true
    end,

    RemovePlayerCraft = function(craftId)
        if not craftId then return false end

        if not db.benchLocationCrafts[craftId] then return false end

        db.benchLocationCrafts[craftId] = nil

        saveJSON(dbFiles.benchLocationCrafts, db.benchLocationCrafts)

        return true
    end,

    UpdatePlayerCraft = function(craftId, updatedData)
        if not craftId or not updatedData then return false end

        if not db.benchLocationCrafts[craftId] then return false end

        for key, value in pairs(updatedData) do
            db.benchLocationCrafts[craftId][key] = value
        end

        saveJSON(dbFiles.benchLocationCrafts, db.benchLocationCrafts)

        return true
    end,

    GetPlayerCrafts = function(userId, location)
        if not userId or not location then return nil end

        local crafts = {}

        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.userId == userId and craft.location == location then
                local craftData = {
                    craftId = craft.craftId,
                    recipe = craft.recipe,
                    quantity = craft.quantity,
                    startedAt = craft.startedAt,
                    completedAt = craft.completedAt,
                    pausedAt = craft.pausedAt,
                    removedItems = craft.removedItems or {},
                    resultItems = craft.resultItems or {}
                }
                table.insert(crafts, craftData)
            end
        end

        table.sort(crafts, function(a, b)
            return a.startedAt < b.startedAt
        end)

        return crafts
    end,

    GetPlayerQueueCount = function(userId, location)
        if not userId or not location then return 0 end
        
        local currentTime = os.time()
        local count = 0
        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.userId == userId and craft.location == location and craft.completedAt > currentTime then
                count = count + 1
            end
        end
        
        return count
    end,

    -- Count all active crafts for a player across ALL locations
    GetPlayerGlobalQueueCount = function(userId)
        if not userId then return 0 end

        local currentTime = os.time()
        local count = 0
        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.userId == userId and craft.completedAt > currentTime then
                count = count + 1
            end
        end

        return count
    end,

    SumQueuedCraftsSince = function(userId, recipeId, sinceEpoch)
        local used = 0
        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.userId == userId and craft.recipe == recipeId and craft.startedAt >= sinceEpoch then
                used = used + (craft.quantity or 0)
            end
        end
        return used
    end,

    GetQueuedCraftEventsSince = function(userId, recipeId, sinceEpoch)
        local rows = {}
        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.userId == userId and craft.recipe == recipeId and craft.startedAt >= sinceEpoch then
                table.insert(rows, { quantity = craft.quantity or 0, ts = craft.startedAt })
            end
        end
        table.sort(rows, function(a, b) return a.ts < b.ts end)
        return rows
    end,

    GetPlayerCraft = function(craftId)
        if not craftId or not db.benchLocationCrafts[craftId] then return nil end

        local craft = db.benchLocationCrafts[craftId]

        local craftData = {
            craftId = craft.craftId,
            userId = craft.userId,
            recipe = craft.recipe,
            quantity = craft.quantity,
            startedAt = craft.startedAt,
            completedAt = craft.completedAt,
            pausedAt = craft.pausedAt,
            removedItems = craft.removedItems or {},
            resultItems = craft.resultItems or {},
            location = craft.location
        }

        return craftData
    end,

    PausePlayerCrafts = function(userId, location)
        if not userId or not location then return false end

        local res = false

        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.userId == userId and craft.location == location and (craft.pausedAt == nil or craft.pausedAt == 0) then
                craft.pausedAt = os.time()
                res = true
            end
        end

        if res then
            saveJSON(dbFiles.benchLocationCrafts, db.benchLocationCrafts)
        end

        return res
    end,

    PauseAllPlayerCrafts = function()
        local res = false

        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.pausedAt == nil or craft.pausedAt == 0 then
                craft.pausedAt = os.time()
                res = true
            end
        end

        if res then
            saveJSON(dbFiles.benchLocationCrafts, db.benchLocationCrafts)
        end
    end,

    PauseAllCraftsForPlayer = function(userId)
        if not userId then return false end
        
        local res = false

        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.userId == userId and (craft.pausedAt == nil or craft.pausedAt == 0) then
                craft.pausedAt = os.time()
                res = true
            end
        end

        if res then
            saveJSON(dbFiles.benchLocationCrafts, db.benchLocationCrafts)
        end

        return res
    end,

    GetLocationCrafts = function(location)
        if not location then return nil end

        local crafts = {}

        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.location == location then
                local craftData = {
                    craftId = craft.craftId,
                    userId = craft.userId,
                    recipe = craft.recipe,
                    quantity = craft.quantity,
                    startedAt = craft.startedAt,
                    completedAt = craft.completedAt,
                    pausedAt = craft.pausedAt,
                    removedItems = craft.removedItems or {},
                    resultItems = craft.resultItems or {}
                }
                table.insert(crafts, craftData)
            end
        end

        table.sort(crafts, function(a, b)
            return a.startedAt < b.startedAt
        end)

        return crafts
    end,

    GetLocationQueueCount = function(locationId)
        if not locationId then return 0 end

        local currentTime = os.time()
        local count = 0
        for _, craft in pairs(db.benchLocationCrafts) do
            if craft.location == locationId and craft.completedAt > currentTime then
                count = count + 1
            end
        end

        return count
    end,

    Clear = function()
        db.benchLocations = {}
        saveJSON(dbFiles.benchLocations, db.benchLocations)
    end
}
