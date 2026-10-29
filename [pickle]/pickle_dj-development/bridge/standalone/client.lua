if GetResourceState('es_extended') == 'started' then return end
if GetResourceState('qb-core') == 'started' then return end

function ShowNotification(text, type)
	lib.notify({
		title = 'Notification',
		description = text,
		type = type or 'success'
	})
end

RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text, type)
    ShowNotification(text, type)
end)

local firstLoad = true

RegisterNetEvent('playerSpawned', function()
    if not firstLoad then return end
    firstLoad = false
    TriggerServerEvent('pickle_dj:requestDJStations')
    TriggerServerEvent("pickle_dj:initializePlayer")
end)

-- Inventory Fallback

CreateThread(function()
    Wait(100)

    Inventory = {}

    Inventory.Items = {}
    
    Inventory.Ready = true
end)