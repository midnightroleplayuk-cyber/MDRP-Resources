local CAYO_PERICO_SPAWN_LOCATIONS <const> = {
    vector4(4598.8237, -4475.4131, 2.9002, 272.9770),
    vector4(4707.2827, -4464.3730, 6.2928, 268.4773),
    vector4(4855.9087, -4462.7256, 7.7182, 282.6064),
    vector4(5006.5415, -4552.1567, 8.3415, 212.9783),
    vector4(5131.4448, -4584.1104, 4.3020, 220.2149),
    vector4(5166.1523, -4693.0278, 1.8392, 4.3738),
    vector4(5119.9648, -4621.6299, 2.2892, 74.1784),
    vector4(5014.7046, -4634.8291, 4.9656, 148.0110),
    vector4(4988.7188, -4761.5308, 12.9436, 165.6532),
    vector4(5049.9673, -4889.2188, 15.4160, 248.2871),
    vector4(5145.2290, -4995.6030, 10.3032, 173.3521),
    vector4(5191.7544, -5110.5376, 3.7157, 292.2820),
    vector4(5152.7109, -5268.0054, 8.9388, 140.8557),
    vector4(5044.9302, -5200.2583, 2.2652, 9.8930),
    vector4(4991.7388, -5165.4199, 2.2283, 215.6515),
    vector4(4942.1699, -5267.2148, 2.9725, 180.1120),
    vector4(4853.0654, -5413.3242, 17.9668, 157.1860),
    vector4(4923.0723, -5474.8091, 30.0654, 308.2514),
    vector4(4971.1836, -5507.2646, 30.0790, 187.4170),
    vector4(5001.5405, -5606.2769, 24.3186, 278.9176),
    vector4(5143.4385, -5575.5127, 39.9583, 289.9014),
    vector4(5186.5869, -5501.6851, 47.4971, 234.8895),
    vector4(5318.4766, -5494.3599, 53.0784, 273.9213),
    vector4(5365.0942, -5550.5723, 51.7618, 207.8264),
    vector4(5410.0889, -5720.7417, 37.2108, 298.6440),
    vector4(5481.6255, -5825.9458, 18.6289, 37.0951),
    vector4(5387.8813, -5431.5820, 45.3137, 314.8591),
    vector4(5426.1875, -5348.6470, 30.8480, 10.7427),
    vector4(5528.5918, -5289.2905, 12.0520, 352.2754),
    vector4(5498.0312, -5164.8589, 13.1049, 51.7445),
    vector4(5397.5957, -5116.5781, 12.9672, 84.4087),
    vector4(5266.6567, -5080.1255, 13.9239, 34.1018),
    vector4(5260.7476, -5282.4302, 27.4572, 224.6745),
    vector4(4943.1812, -5607.2212, 23.3433, 51.9790),
    vector4(4782.3950, -5567.6636, 23.2560, 102.6193),
    vector4(4761.4707, -5686.4087, 21.1947, 179.4478),
    vector4(4859.2646, -5734.7715, 26.9646, 223.1559),
    vector4(4904.1699, -5803.8511, 24.1767, 254.3895),
    vector4(4956.9321, -5732.6733, 19.5365, 329.7887),
}

---Function to find a spawn point for a car
---@param minDist? number Minimum distance from the player. Default 150
---@return vector3?, number?
local function FindCarLocation(minDist)
    if not minDist then
        minDist = 150
    end

    local position, heading
    local coords = GetEntityCoords(PlayerPedId())
    local isAtCayoPerico = #(coords - vector3(5000.0, -5000.0, 2.0)) < 2500.0

    if isAtCayoPerico then
        table.sort(CAYO_PERICO_SPAWN_LOCATIONS, function(a, b)
            return #(coords - a.xyz) < #(coords - b.xyz)
        end)

        local spawnLocation = CAYO_PERICO_SPAWN_LOCATIONS[1]

        position = spawnLocation.xyz
        heading = spawnLocation.w

        if #(coords - position) > 500.0 then
            debugprint("FindCarLocation: No position found (too far away)")
            return
        end
    else
        local success
        local nth = 0

        while true do
            nth += 1
            success, position, heading = GetNthClosestVehicleNodeWithHeading(coords.x, coords.y, coords.z, nth, 0, 0, 0)

            if not success then
                debugprint("FindCarLocation: No position found")
                return
            end

            local distance = #(coords - position)

            if distance > 500.0 then
                debugprint("FindCarLocation: No position found (too far away)")
                return
            end

            if distance > minDist then
                break
            end
        end
    end

    return position, heading
end

local function BringCar(data, cb)
    local minDist = Config.Valet.Drive and math.random(75, 150) or 0
    local location, heading = FindCarLocation(minDist)

    if not location or not heading then
        debugprint("BringCar: No location found")
        return cb(false)
    end

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        debugprint("BringCar: Player is in a vehicle")
        return cb(false)
    end

    local plate = data.plate
    local vehicleData = AwaitCallback("garage:valetVehicle", plate, location, heading)

    if not vehicleData then
        debugprint("BringCar: No vehicle data found")
        return cb(false)
    end

    local vehicle, ped

    if Config.ServerSideSpawn then
        local vehNetId, pedNetId = vehicleData.vehNetId, vehicleData.pedNetId

        if not vehNetId or (Config.Valet.Drive and not pedNetId) then
            debugprint("BringCar: Server did not create vehicle/ped (no vehNetId/pedNetId)")
            return cb(false)
        end

        vehicle = WaitForNetworkId(vehNetId)

        if Config.Valet.Drive then
            ped = WaitForNetworkId(pedNetId)
        end

        Wait(1000) -- wait for the driver to enter the vehicle

        if vehicle and TakeControlOfEntity(vehicle) then
            if ped and TakeControlOfEntity(ped) then
                TaskWarpPedIntoVehicle(ped, vehicle, -1)
            end

            ApplyVehicleMods(vehicle, vehicleData)
        end
    else
        vehicle = CreateFrameworkVehicle(vehicleData, location)

        if vehicle and Config.Valet.Drive then
            local model = LoadModel(Config.Valet.Model)

            ped = CreatePedInsideVehicle(vehicle, 4, model, -1, true, false)

            SetModelAsNoLongerNeeded(model)
        end

        if vehicle then
            Entity(vehicle).state.plate = plate
        end
    end

    if not vehicle or not DoesEntityExist(vehicle) then
        debugprint("BringCar: vehicle does not exist")
        return cb(false)
    end

    if GetResourceState("jg-advancedgarages") == "started" then
        TriggerServerEvent("jg-advancedgarages:server:register-vehicle-outside", plate, VehToNet(vehicle))
    end

    SetEntityHeading(vehicle, heading)

    GiveVehicleKey(vehicle, plate)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, "OFF")
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineOn(vehicle, true, true, true)
    SetEntityAsMissionEntity(vehicle, true, true)

    cb(true)

    if not ped or not DoesEntityExist(ped) then
        debugprint("BringCar: ped does not exist")
        return
    end

    if not Config.Valet.Drive then
        return
    end

    -- make the ped bring the vehicle
    local plyCoords = GetEntityCoords(PlayerPedId())

    TaskVehicleDriveToCoord(ped, vehicle, plyCoords.x, plyCoords.y, plyCoords.z, 20.0, 0, Config.Valet.Model, 786603, 1.0, 1)
    SetPedKeepTask(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 17, true)
    SetPedAlertness(ped, 0)

    -- create blip for the vehicle
    local blip = AddBlipForEntity(vehicle)

    SetBlipSprite(blip, 225)
    SetBlipColour(blip, 5)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(plate)
    EndTextCommandSetBlipName(blip)

    -- wait for the ped to arrive
    while #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) > 10.0 do
        Wait(1000)
    end

    RemoveBlip(blip)

    -- make the ped exit the vehicle, then wander in area, and set as no longer needed
    TaskLeaveVehicle(ped, vehicle, 0)
    TaskWanderStandard(ped, 10.0, 10)
    SetEntityAsNoLongerNeeded(ped)

    Wait(1000)

    SetVehicleDoorsLocked(vehicle, 0)
end

---Function to find a car
---@param plate string
---@return vector3 | false
local function FindCar(plate)
    local vehicles = GetGamePool("CVehicle")

    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        if DoesEntityExist(vehicle) and GetVehicleNumberPlateText(vehicle):gsub("%s+", "") == plate:gsub("%s+", "") then
            return GetEntityCoords(vehicle)
        end
    end

    local location = AwaitCallback("garage:findCar", plate)

    return location
end

function GetVehicleLabel(model)
    local vehicleLabel = GetDisplayNameFromVehicleModel(model):lower()

    if not vehicleLabel or vehicleLabel == "null" or vehicleLabel == "carnotfound" then
        return "Unknown"
    end

    local text = GetLabelText(vehicleLabel)

    if text and text:lower() ~= "null" then
        vehicleLabel = text:gsub("µ", " ")
    end

    return vehicleLabel
end

RegisterNUICallback("Garage", function(data, cb)
    local action = data.action

    debugprint("Garage:" .. (action or ""))

    if action == "getVehicles" then
        local cars = AwaitCallback("garage:getVehicles")

        for i = 1, #cars do
            cars[i].model = GetVehicleLabel(cars[i].model)
            -- If you're implementing your own lock system, you can use this to set the locked state
            -- cars[i].locked = true
        end

        cb(cars)
    elseif action == "valet" then
        if not Config.Valet.Enabled then
            return
        end

        BringCar(data, cb)
    elseif action == "setWaypoint" then
        local coords = FindCar(data.plate)

        if coords then
            SetNewWaypoint(coords.x, coords.y)
            TriggerEvent("phone:sendNotification", {
                app = "Garage",
                title = L("BACKEND.GARAGE.VALET"),
                content = L("BACKEND.GARAGE.MARKED"),
            })
        else
            debugprint("not found")
        end

        cb("ok")
    elseif action == "toggleLocked" then
        --IMPLEMENT YOUR LOCK SYSTEM HERE, don't forget to callback with the new locked state
        -- cb(true)
    end
end)
