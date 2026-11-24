NDM.Points = {}

local MAX_POINTS_PER_VENUE = 100
local MAX_PLACE_DISTANCE = 25.0
local Cache = {}

local function publicRow(point)
    local venue = NDM.Venue.Get(point.venue_id)
    if not venue then return nil end
    return {
        id = point.id,
        venue_id = point.venue_id,
        venueType = venue.type,
        job = venue.job,
        type = point.type,
        label = point.label,
        x = point.x,
        y = point.y,
        z = point.z,
        heading = point.heading,
        model = point.model or '',
        forSale = venue.owner_citizenid == nil and (tonumber(venue.metadata.sale_price) or 0) > 0,
    }
end

-- Re-sends a venue's points when something they display has changed.
function NDM.Points.RefreshVenue(venueId)
    for _, point in pairs(Cache) do
        if point.venue_id == venueId then
            TriggerClientEvent('ndm_business:points:updated', -1, publicRow(point))
        end
    end
end

function NDM.Points.Load()
    Cache = {}
    local count = 0
    for _, row in ipairs(MySQL.query.await('SELECT * FROM `ndm_business_points`') or {}) do
        if NDM.PointTypeById[row.type] and NDM.Venue.Get(row.venue_id) then
            Cache[row.id] = row
            count = count + 1
        end
    end
    return count
end

function NDM.Points.Get(id)
    return Cache[tonumber(id)]
end

function NDM.Points.ForVenue(venueId)
    local points = {}
    for _, point in pairs(Cache) do
        if point.venue_id == venueId then
            points[#points + 1] = {
                id = point.id,
                type = point.type,
                typeLabel = NDM.PointTypeById[point.type].label,
                label = point.label,
                x = point.x,
                y = point.y,
                z = point.z,
                model = point.model or '',
            }
        end
    end
    table.sort(points, function(a, b)
        if a.type ~= b.type then return a.type < b.type end
        return a.id < b.id
    end)
    return points
end

local function validCoords(data)
    local x, y, z, heading = tonumber(data.x), tonumber(data.y), tonumber(data.z), tonumber(data.heading)
    if not x or not y or not z or not heading then return nil end
    if x ~= x or y ~= y or z ~= z or heading ~= heading then return nil end
    if math.abs(x) > 10000 or math.abs(y) > 10000 or z < -300 or z > 3000 then return nil end
    return x + 0.0, y + 0.0, z + 0.0, (heading % 360.0) + 0.0
end

function NDM.Points.Save(src, venueId, data)
    local venue = NDM.Venue.Get(venueId)
    if not venue then return false, 'invalid_venue' end

    local x, y, z, heading = validCoords(data)
    if not x then return false, 'invalid_point' end

    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped) - vector3(x, y, z)) > MAX_PLACE_DISTANCE then
        return false, 'too_far'
    end

    local pointId = tonumber(data.pointId)
    local existing = pointId and Cache[pointId]
    if pointId and (not existing or existing.venue_id ~= venue.id) then return false, 'invalid_point' end

    local pointType = existing and existing.type or tostring(data.type or '')
    local definition = NDM.PointTypeById[pointType]
    if not definition then return false, 'invalid_point' end
    if definition.venueTypes and not definition.venueTypes[venue.type] then return false, 'invalid_point' end

    local label = tostring(data.label or ''):gsub('^%s+', ''):gsub('%s+$', ''):sub(1, 40)
    if label == '' then label = existing and existing.label or definition.label end

    -- An empty model is an invisible interaction point.
    local model = existing and existing.model or ''
    if data.model ~= nil then
        model = tostring(data.model)
        if model ~= '' and not NDM.IsPropAllowed(pointType, model) then return false, 'invalid_point' end
    end

    if existing then
        MySQL.update.await('UPDATE `ndm_business_points` SET `label` = ?, `x` = ?, `y` = ?, `z` = ?, `heading` = ?, `model` = ? WHERE `id` = ?', {
            label, x, y, z, heading, model, existing.id,
        })
        existing.label, existing.x, existing.y, existing.z, existing.heading, existing.model = label, x, y, z, heading, model
    else
        local count = 0
        for _, point in pairs(Cache) do
            if point.venue_id == venue.id then count = count + 1 end
        end
        if count >= MAX_POINTS_PER_VENUE then return false, 'too_many_points' end

        local id = MySQL.insert.await('INSERT INTO `ndm_business_points` (`venue_id`, `type`, `label`, `x`, `y`, `z`, `heading`, `model`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            venue.id, pointType, label, x, y, z, heading, model,
        })
        if not id then return false, 'error' end
        existing = { id = id, venue_id = venue.id, type = pointType, label = label, x = x, y = y, z = z, heading = heading, model = model }
        Cache[id] = existing
    end

    -- Placement is a rare admin edit and this is one small row, so every client can hold it.
    TriggerClientEvent('ndm_business:points:updated', -1, publicRow(existing))
    return true
end

function NDM.Points.Remove(venueId, pointId)
    local point = Cache[tonumber(pointId)]
    if not point or point.venue_id ~= venueId then return false, 'invalid_point' end
    MySQL.update.await('DELETE FROM `ndm_business_points` WHERE `id` = ?', { point.id })
    Cache[point.id] = nil
    TriggerClientEvent('ndm_business:points:removed', -1, point.id)
    return true
end

lib.callback.register('ndm_business:points:list', function()
    if not NDM.Ready then return nil end
    local rows = {}
    for _, point in pairs(Cache) do
        local row = publicRow(point)
        if row then rows[#rows + 1] = row end
    end
    return rows
end)
