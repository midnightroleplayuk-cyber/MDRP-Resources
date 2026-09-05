QBCore = GetResourceState('qb-core') == 'started' and true or false
local isQBox = GetResourceState('qbx_core') == 'started' and true or false

if not QBCore then return end
if isQBox then return end

Fr = {}

Framework = exports['qb-core']:GetCoreObject()
Fr.PlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
Fr.VehicleEncode = "mods"
Fr.identificatorTable = "citizenid"
Fr.StoredTable = 'state'
Fr.JobUpdateEvent = "QBCore:Client:OnJobUpdate"
Fr.OwnerTable = "citizenid"

function getGangName()
    if GetResourceState('op-crime') == 'started' then
        local orgData = exports['op-crime']:getPlayerOrganisation()

        if not orgData then return nil end

        return tostring(orgData.id)
    elseif GetResourceState('rcore_gangs') == 'started' then
        local gang = exports.rcore_gangs:GetPlayerGang()
        if not gang then return nil end

        return gang.name
    else
        local pd = Fr.GetPlayerData()
        local name = pd and pd.gang and pd.gang.name
        if name and name ~= "" and name ~= "none" then
            return name
        end
        return nil
    end
end

function getGangGrade(cb) 
    if GetResourceState('op-crime') == 'started' then
        exports['op-crime']:playerGaragePermission(function(canOpen)
            if Config.Misc.ReverseGradeCheck then
                if canOpen then 
                    cb(50)
                else
                    cb(0)
                end
            else
                if canOpen then 
                    cb(0)
                else
                    cb(50)
                end
            end
        end)
    elseif GetResourceState('rcore_gangs') == 'started' then
        local gang = exports.rcore_gangs:GetPlayerGang()
        if not gang then return cb(nil) end
        cb(0)
    else
        local pd = Fr.GetPlayerData()
        if pd and pd.gang and pd.gang.grade ~= nil then
            cb(type(pd.gang.grade) == "table" and pd.gang.grade.level or pd.gang.grade)
        else
            cb(nil)
        end
    end
end

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gangData)
    PlayerData.gang = gangData
    reloadGangGarages(gangData)
end)

Fr.TriggerServerCallback = function(...)
    return Framework.Functions.TriggerCallback(...)
end
Fr.GetVehicleProperties = function(vehicle)
    return ScriptFunctions.GetVehicleProperties(vehicle)
end
Fr.DeleteVehicle = function(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end

    -- Garage preview cars are local (non-networked). AdvancedParking / framework
    -- delete paths often fail on them and leak entities → after 1-2h CreateVehicle fails.
    if not NetworkGetEntityIsNetworked(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteEntity(vehicle)
        if DoesEntityExist(vehicle) then
            DeleteVehicle(vehicle)
        end
        return
    end

    if Config.Addons.AdvancedParking then
        return exports["AdvancedParking"]:DeleteVehicle(vehicle, false)
    end
    return Framework.Functions.DeleteVehicle(vehicle)
end
Fr.SpawnVehicle = function(vehicleModel, coords, heading, networked, cb)
    local model = type(vehicleModel) == 'number' and vehicleModel or joaat(vehicleModel)
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
    networked = networked == nil and true or networked

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if not vector or not playerCoords then
        return
    end

    CreateThread(function()
        ScriptFunctions.RequestModel(model)

        local vehicle = CreateVehicle(model, vector.xyz, heading, networked, true)

        if networked then
            local id = NetworkGetNetworkIdFromEntity(vehicle)
            SetNetworkIdCanMigrate(id, true)
            SetEntityAsMissionEntity(vehicle, true, true)
        end

        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(model)
        SetVehRadioStation(vehicle, 'OFF')

        RequestCollisionAtCoord(vector.xyz)

        local timeout = GetGameTimer() + 5000 -- 5 sekund

        while not HasCollisionLoadedAroundEntity(vehicle) do
            if GetGameTimer() > timeout then
                print(('[Fr.SpawnVehicle] Collision timeout for vehicle %s'):format(model))
                break
            end

            Wait(0)
        end

        if cb then
            cb(vehicle)
        end
    end)
end
Fr.SetVehicleProperties = function(vehicle, props, fixVehicle)
    return ScriptFunctions.SetVehicleProperties(vehicle, props, fixVehicle)
end
Fr.GetPlayerData = function()
    return Framework.Functions.GetPlayerData()
end