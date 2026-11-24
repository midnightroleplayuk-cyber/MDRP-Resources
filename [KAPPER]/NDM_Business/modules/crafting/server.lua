local STATION_REACH = 3.5
local FINISH_GRACE = 250
local ABANDON_AFTER = 60000

local Active = {} -- [src] = active craft
local nextToken = 0

local function contextFor(src, pointId)
    local point = NDM.Points.Get(pointId)
    local definition = point and NDM.PointTypeById[point.type]
    if not definition or (point.type ~= 'crafting' and not definition.station) then
        return nil, 'This station is not available.'
    end
    local venue = NDM.Venue.Get(point.venue_id)
    if not venue or not NDM.Venue.HasPerm(venue.id, src, 'work') then return nil, 'You do not work here.' end
    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped) - vector3(point.x, point.y, point.z)) > STATION_REACH then
        return nil, 'You are too far from the station.'
    end
    return point, venue
end

local function recipesFor(venue, pointType)
    local catalog = {}
    for _, entry in ipairs(NDM.Supply.Catalog(venue)) do catalog[entry.item] = entry end

    local recipes = {}
    for _, recipe in ipairs(NDM.CraftingConfig.recipes[venue.type] or {}) do
        local valid = recipe.output and catalog[recipe.output.item] ~= nil
        if pointType ~= 'crafting' and recipe.station ~= pointType then valid = false end
        for item in pairs(recipe.ingredients or {}) do
            if not catalog[item] then valid = false end
        end
        if valid then recipes[#recipes + 1] = recipe end
    end
    return recipes, catalog
end

local function recipeById(venue, id, pointType)
    for _, recipe in ipairs((recipesFor(venue, pointType))) do
        if recipe.id == id then return recipe end
    end
    return nil
end

local function canCraft(venue, recipe)
    for item, quantity in pairs(recipe.ingredients) do
        if NDM.Stock.Get(venue.id, item) < quantity then return false end
    end
    return NDM.Stock.Get(venue.id, recipe.output.item) + recipe.output.count <= NDM.SupplyConfig.maxStock
end

local function restore(active)
    for item, quantity in pairs(active.recipe.ingredients) do
        NDM.Stock.Add(active.venueId, item, quantity)
    end
end

lib.callback.register('ndm_business:crafting:list', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local point, venue = contextFor(src, payload.point)
    if not point then return { ok = false, error = venue } end

    local recipes, catalog = recipesFor(venue, point.type)
    local list = {}
    for _, recipe in ipairs(recipes) do
        local needs = {}
        for item, quantity in pairs(recipe.ingredients) do
            needs[#needs + 1] = ('%dx %s (%d)'):format(quantity, catalog[item].label, NDM.Stock.Get(venue.id, item))
        end
        table.sort(needs)
        list[#list + 1] = {
            id = recipe.id,
            label = recipe.label,
            description = table.concat(needs, ', '),
            available = canCraft(venue, recipe),
        }
    end
    return { ok = true, venue = venue.label, recipes = list }
end)

-- Ingredients leave stock now, so two staff cannot both spend the same items.
lib.callback.register('ndm_business:crafting:start', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    if Active[src] then return { ok = false, error = 'You are already crafting.' } end
    local point, venue = contextFor(src, payload.point)
    if not point then return { ok = false, error = venue } end

    local recipe = recipeById(venue, payload.recipe, point.type)
    if not recipe then return { ok = false, error = 'That recipe is not available.' } end
    if not canCraft(venue, recipe) then return { ok = false, error = 'There is not enough stock.' } end

    local removed = {}
    for item, quantity in pairs(recipe.ingredients) do
        if not NDM.Stock.Remove(venue.id, item, quantity) then
            for takenItem, takenQuantity in pairs(removed) do
                NDM.Stock.Add(venue.id, takenItem, takenQuantity)
            end
            return { ok = false, error = 'There is not enough stock.' }
        end
        removed[item] = quantity
    end

    nextToken = nextToken + 1
    local token = nextToken
    local duration = math.max(1000, math.floor(tonumber(recipe.duration) or 5000))
    Active[src] = {
        token = token,
        recipe = recipe,
        venueId = venue.id,
        pointId = point.id,
        startedAt = GetGameTimer(),
        duration = duration,
    }

    SetTimeout(duration + ABANDON_AFTER, function()
        local active = Active[src]
        if active and active.token == token then
            Active[src] = nil
            restore(active)
        end
    end)
    return { ok = true, duration = duration, label = recipe.label }
end)

lib.callback.register('ndm_business:crafting:finish', function(src)
    local active = Active[src]
    if not active then return { ok = false, error = 'You are not crafting anything.' } end
    if GetGameTimer() - active.startedAt < active.duration - FINISH_GRACE then
        return { ok = false, error = 'That is not finished yet.' }
    end

    Active[src] = nil
    local point, venue = contextFor(src, active.pointId)
    if not point then
        restore(active)
        return { ok = false, error = venue }
    end
    if NDM.Stock.Get(venue.id, active.recipe.output.item) + active.recipe.output.count > NDM.SupplyConfig.maxStock then
        restore(active)
        return { ok = false, error = 'The stock room is full.' }
    end

    NDM.Stock.Add(venue.id, active.recipe.output.item, active.recipe.output.count)
    return { ok = true, label = active.recipe.label }
end)

lib.callback.register('ndm_business:crafting:cancel', function(src)
    local active = Active[src]
    if active then
        Active[src] = nil
        restore(active)
    end
    return true
end)

AddEventHandler('playerDropped', function()
    local active = Active[source]
    if active then
        Active[source] = nil
        restore(active)
    end
end)
