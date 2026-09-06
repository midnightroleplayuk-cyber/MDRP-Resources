

--- SQL Stuff
local SQL_DRIVER = Config.sql.driver
local function SqlQuery(query, data)
    if SQL_DRIVER == 'mysql' then
        return MySQL.Sync.fetchAll(query, data or {})
    end

    if SQL_DRIVER == 'oxmysql' then
        if Config.sql.newOxMysql then
            return exports[SQL_DRIVER]:fetchSync(query, data or {})
        end
        return exports[SQL_DRIVER]:query_async(query, data or {})
    else
        return exports[SQL_DRIVER]:executeSync(query, data or {})
    end
end

local function SqlMutate(query, data)
    if SQL_DRIVER == 'mysql' then
        return MySQL.Sync.insert(query, data)
    end

    if SQL_DRIVER == 'oxmysql' then
        return exports[SQL_DRIVER]:insertSync(query, data)
    else
        return exports[SQL_DRIVER]:executeSync(query, data)
    end
end


DB = {
    -- Pots placement
    GetPlacedPots = function()
        local query = [[
            SELECT *
            FROM kq_weed_pots;
        ]]

        return SqlQuery(query, {})
    end,

    AddPlacedPot = function(player, tag, coords, rotation, routingBucket, metadata)
        local mutation = [[
            INSERT INTO kq_weed_pots (`placed_by`, `tag`, `coords`, `rotation`, `routing_bucket`, `metadata`)
            VALUES (@placed_by, @tag, @coords, @rotation, @routing_bucket, @metadata)
            ON DUPLICATE KEY UPDATE
              placed_by = @placed_by,
              metadata = @metadata;
        ]]

        local data = {
            ['@placed_by'] = GetPlayerLicense(player),
            ['@tag'] = tag,
            ['@coords'] = json.encode(coords),
            ['@rotation'] = json.encode(rotation),
            ['@routing_bucket'] = routingBucket,
            ['@metadata'] = json.encode(metadata),
        }


        return SqlMutate(mutation, data)
    end,

    DeletePlacedPot = function(tag)
        local mutation = [[
            DELETE FROM kq_weed_pots
            WHERE tag = @tag;
        ]]

        local data = {
            ['@tag'] = tag,
        }

        return SqlMutate(mutation, data)
    end,

    -- Table placement
    GetPlacedTables = function()
        local query = [[
            SELECT *
            FROM kq_weed_tables;
        ]]

        return SqlQuery(query, {})
    end,

    AddPlacedTable = function(player, tag, coords, rotation, routingBucket, metadata)
        local mutation = [[
            INSERT INTO kq_weed_tables (`placed_by`, `tag`, `coords`, `rotation`, `routing_bucket`, `metadata`)
            VALUES (@placed_by, @tag, @coords, @rotation, @routing_bucket, @metadata)
            ON DUPLICATE KEY UPDATE
              placed_by = @placed_by;
        ]]

        local data = {
            ['@placed_by'] = GetPlayerLicense(player),
            ['@tag'] = tag,
            ['@coords'] = json.encode(coords),
            ['@rotation'] = json.encode(rotation),
            ['@routing_bucket'] = routingBucket,
            ['@metadata'] = json.encode(metadata),
        }


        return SqlMutate(mutation, data)
    end,

    DeletePlacedTable = function(tag)
        local mutation = [[
            DELETE FROM kq_weed_tables
            WHERE tag = @tag;
        ]]

        local data = {
            ['@tag'] = tag,
        }

        return SqlMutate(mutation, data)
    end,

    -- Press placement
    GetPlacedPresses = function()
        local query = [[
            SELECT *
            FROM kq_weed_presses;
        ]]

        return SqlQuery(query, {})
    end,

    AddPlacedPress = function(player, tag, coords, rotation, routingBucket, metadata)
        local mutation = [[
            INSERT INTO kq_weed_presses (`placed_by`, `tag`, `coords`, `rotation`, `routing_bucket`, `metadata`)
            VALUES (@placed_by, @tag, @coords, @rotation, @routing_bucket, @metadata)
            ON DUPLICATE KEY UPDATE
              placed_by = @placed_by;
        ]]

        local data = {
            ['@placed_by'] = GetPlayerLicense(player),
            ['@tag'] = tag,
            ['@coords'] = json.encode(coords),
            ['@rotation'] = json.encode(rotation),
            ['@routing_bucket'] = routingBucket,
            ['@metadata'] = json.encode(metadata),
        }


        return SqlMutate(mutation, data)
    end,

    DeletePlacedPress = function(tag)
        local mutation = [[
            DELETE FROM kq_weed_presses
            WHERE tag = @tag;
        ]]

        local data = {
            ['@tag'] = tag,
        }

        return SqlMutate(mutation, data)
    end,

    -- Plants
    GetPlants = function()
        local query = [[
            SELECT *
            FROM kq_weed_plants;
        ]]

        return SqlQuery(query, {})
    end,

    DeletePlantData = function(tag)
        local mutation = [[
           DELETE FROM kq_weed_plants
           WHERE tag = @tag;
        ]]

        local data = {
            ['@tag'] = tag,
        }

        Debug('Deleting plant data', tag)
        return SqlMutate(mutation, data)
    end,

    SavePlantData = function(tag, state, metadata)
        local mutation = [[
            INSERT INTO kq_weed_plants (`tag`, `state`, `metadata`)
            VALUES (@tag, @state, @metadata)
            ON DUPLICATE KEY UPDATE
              state    = @state,
              metadata = @metadata;
        ]]

        local data = {
            ['@tag'] = tag,
            ['@state'] = json.encode(state),
            ['@metadata'] = json.encode(metadata),
        }

        Debug('Saving plant data', tag)

        return SqlMutate(mutation, data)
    end,

    DeleteOldPlantData = function()
        local mutation = [[
           DELETE FROM kq_weed_plants
            WHERE updated_at < DATE_SUB(NOW(), INTERVAL @days DAY);
        ]]

        local data = {
            ['@days'] = math.max(2, Config.saving.deletePlantsOlderThan or 7)
        }

        return SqlMutate(mutation, data)
    end,

}

DB.SqlMutate = SqlMutate
DB.SqlQuery = SqlQuery
