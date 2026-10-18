local runtime = require 'shared.runtime'

-- Owned-vehicle table plus the column that stores its owner, per framework.
-- GetIdentifier(source) returns exactly this owner value (esx identifier /
-- qb-qbx citizenid), so we can scope every query to the acting
-- player and never touch a different player's vehicle.
local function ownedVehicleTable()
    if Framework == 'esx' then
        return 'owned_vehicles', 'owner'
    elseif Framework == 'qb' or Framework == 'qbx' then
        return 'player_vehicles', 'citizenid'
    end
end

-- Returns boolean if the vehicle with this plate is owned by THIS player
--- @param source number Player ID
--- @param plate string Vehicle plate
--- @return boolean
function IsOwnedVehicle(source, plate)
    if not source or not plate then return false end

    local tableName, ownerColumn = ownedVehicleTable()
    if not tableName then return false end

    local identifier = GetIdentifier(source)
    if not identifier then return false end

    local results = MySQL.query.await(
        ('SELECT 1 FROM %s WHERE plate = ? AND %s = ? LIMIT 1'):format(tableName, ownerColumn),
        { plate, identifier }
    )
    return results and #results > 0
end

-- Backs up deleted vehicle data to a SQL file
--- @param tableName string Name of the database table
--- @param vehicleData table Vehicle data to backup
function BackupDeletedVehicle(tableName, vehicleData)
    local resourceName = GetCurrentResourceName()
    local fileName = 'lua/server/database/deleted_vehicles.sql'
    local existing = LoadResourceFile(resourceName, fileName)

    local columns, values = {}, {}
    for k, v in pairs(vehicleData) do
        table.insert(columns, '`' .. k .. '`')
        if v == nil or v == "" then
            table.insert(values, "NULL")
        elseif type(v) == "number" then
            table.insert(values, tostring(v))
        elseif type(v) == "boolean" then
            table.insert(values, v and "1" or "0")
        else
            table.insert(values, "'" .. tostring(v):gsub("'", "''") .. "'")
        end
    end

    local sql = ("INSERT INTO `%s` (%s) VALUES (%s);\n"):format(
        tableName,
        table.concat(columns, ', '),
        table.concat(values, ', ')
    )

    local newContent = (existing or '') .. sql
    SaveResourceFile(resourceName, fileName, newContent, #newContent)
end

-- Deletes owned vehicle from database
--- @param source number Player ID
--- @param plate string Vehicle plate
function DeleteOwnedVehicle(source, plate)
    if not source or not plate then return end
    if not runtime.start.deleteOwned then return end

    local tableName, ownerColumn = ownedVehicleTable()
    if not tableName then return end

    local identifier = GetIdentifier(source)
    if not identifier then return end

    -- Scope to the acting player's own vehicle: a plate match alone could delete
    -- someone else's persisted vehicle.
    local results = MySQL.query.await(
        ('SELECT * FROM %s WHERE plate = ? AND %s = ?'):format(tableName, ownerColumn),
        { plate, identifier }
    )
    if results and #results > 0 then
        BackupDeletedVehicle(tableName, results[1])
        MySQL.query.await(
            ('DELETE FROM %s WHERE plate = ? AND %s = ?'):format(tableName, ownerColumn),
            { plate, identifier }
        )
    end
end

lib.callback.register('lation_chopshop:isOwnedVehicle', IsOwnedVehicle)