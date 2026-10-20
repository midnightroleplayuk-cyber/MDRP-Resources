SavedVehicles = {}

RegisterNetEvent("oELS:toggleLights")

AddEventHandler("oELS:toggleLights", function(lights, state)
	local vehicle = GetPlayerVehicle(source)
    TriggerClientEvent("oELS:toggleLights", -1, source, vehicle, lights, state)
end)

RegisterNetEvent("oELS:toggleSirens")

AddEventHandler("oELS:toggleSirens", function(state)
	local vehicle = GetPlayerVehicle(source)
    TriggerClientEvent("oELS:toggleSirens", -1, source, vehicle, state)
end)

RegisterNetEvent("oELS:toggleSecondSirens")

AddEventHandler("oELS:toggleSecondSirens", function(state)
	local vehicle = GetPlayerVehicle(source)
    TriggerClientEvent("oELS:toggleSecondSirens", -1, source, vehicle, state)
end)

RegisterNetEvent("oELS:toggleBullhorn")

AddEventHandler("oELS:toggleBullhorn", function(state)
	local vehicle = GetPlayerVehicle(source)
    TriggerClientEvent("oELS:toggleBullhorn", -1, source, vehicle, state)
end)

RegisterNetEvent("oELS:toggleAlleyLights")

AddEventHandler("oELS:toggleAlleyLights", function(state)
	local vehicle = GetPlayerVehicle(source)
    TriggerClientEvent("oELS:toggleAlleyLights", -1, source, vehicle, state)
end)

RegisterNetEvent("oELS:toggleIndicators")

AddEventHandler("oELS:toggleIndicators", function(state)
	local vehicle = GetPlayerVehicle(source)
    TriggerClientEvent("oELS:toggleIndicators", -1, source, vehicle, state)
end)

AddEventHandler("entityRemoved", function(entity)
	if SavedVehicles[entity] then
		TriggerClientEvent("oELS:VehicleRemoved", -1, SavedVehicles[entity])
		SavedVehicles[entity] = nil
	end
end)

function GetPlayerVehicle(player)
	local ped = GetPlayerPed(player)
	local veh = GetVehiclePedIsIn(ped, false)
	local net = NetworkGetNetworkIdFromEntity(veh)
	if not SavedVehicles[veh] then SavedVehicles[veh] = net end
	return net
end
