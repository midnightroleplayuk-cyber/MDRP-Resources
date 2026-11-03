-- Make sure to read and UNDERSTAND the docs before modifying this file
-- Make sure to read and UNDERSTAND the docs before modifying this file
-- Make sure to read and UNDERSTAND the docs before modifying this file

local Framework = exports['av_laptop']:getFramework()
local Database = {}

CreateThread(function()
    -- Database values used for qb-core and qbox:
    Database.VehiclesTable = "player_vehicles"  -- "player_vehicles" in qb/qbox or "owned_vehicles" in ESX
    Database.OwnerColumn = "citizenid"  -- "citizenid" in qb/qbox or "owner" in ESX
    Database.ModsColumn = "mods"    -- column where vehicle mods are stored, "vehicle" in ESX and "mods" for qb/qbox
    Database.ModelColumn = "vehicle"    -- "vehicle" for qb/qbox and "model" in ESX (import esx_db.sql first!!)
    Database.PlatesColumn = "plate" -- Plate column
    Database.GarageColumn = "garage" -- garage column
    Database.DefaultGarage = "pillboxgarage" -- Garage name where the vehicle will be stored
    while not Framework do Wait(10) end
    -- Database values used for ESX only:
    if Framework == "esx" then
        Database.VehiclesTable = "owned_vehicles"
        Database.OwnerColumn = "owner"
        Database.ModsColumn = "vehicle"
        Database.ModelColumn = "model"
        Database.GarageColumn = "parking"
        Database.DefaultGarage = "SanAndreasAvenue"
    end
end)

function addVehicle(identifier, model)
    local plates = generatePlate()
    vehicleMods['plate'] = plates
    vehicleMods['model'] = GetHashKey(model)
    local colString, valString, queryParams
    dbug('addVehicle(identifier, model, plate, framework)', identifier, model, plates, Framework)
    if not identifier or not model then return false end
    if Framework == "esx" then
        colString = string.format("(%s, %s, %s, stored, type, %s, %s)", 
            Database.OwnerColumn, Database.PlatesColumn, Database.ModsColumn, Database.ModelColumn, Database.GarageColumn)
        valString = "(?, ?, ?, ?, ?, ?, ?)"
        queryParams = { identifier, plates, json.encode(vehicleMods), 1, 'car', model, Database.DefaultGarage }
    else
        local player = MySQL.single.await('SELECT license, citizenid FROM players WHERE citizenid = ?', { identifier })
        if not player then
            warn("addVehicle() was triggered but the player with identifier:"..identifier.." doesn't exist anymore")
            return false
        end
        colString = string.format("(license, %s, %s, hash, %s, %s, state, %s)", 
            Database.OwnerColumn, Database.ModelColumn, Database.ModsColumn, Database.PlatesColumn, Database.GarageColumn)
        valString = "(?, ?, ?, ?, ?, ?, ?, ?)"
        queryParams = { player.license, player.citizenid, model, GetHashKey(model), json.encode(vehicleMods), plates, 1, Database.DefaultGarage }
    end
    if colString and valString and queryParams then
        MySQL.insert('INSERT INTO '..Database.VehiclesTable..' '..colString..' VALUES '..valString, queryParams)
        dbug('Added vehicle for player (identifier, model, plates)', identifier, model, plates)
        return true
    end
    warn("Something went wrong with addVehicle function")
    return false
end

function generatePlate()
    dbug('generatePlate()')
    -- No clue what "1AA11A." is? Read ox_lib docs here: https://coxdocs.dev/ox_lib/Modules/String/Shared#stringrandom
    local plate = lib.string.random("1AA11A.A", 8)
    local result = MySQL.scalar.await('SELECT '..Database.PlatesColumn..' FROM '..Database.VehiclesTable..' WHERE '..Database.PlatesColumn..' = ?', {plate})
    if result then
        return generatePlate()
    else
        return plate:upper()
    end
end