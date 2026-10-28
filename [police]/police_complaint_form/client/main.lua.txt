local uiOpen = false
local zoneAdded = false
local zoneId = nil

local function openUi(mode)
    if uiOpen then return end
    uiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', mode = mode })
    TriggerServerEvent('uk_complaints:requestData', mode)
end

local function closeUi()
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

RegisterCommand(Config.PublicCommand, function() openUi('submit') end, false)
RegisterCommand(Config.OfficerCommand, function()
    TriggerServerEvent('uk_complaints:requestAccess')
end, false)

RegisterNetEvent('uk_complaints:openPanel', function() openUi('officer') end)
RegisterNetEvent('uk_complaints:receive', function(data)
    SendNUIMessage({ action = 'data', data = data })
end)
RegisterNetEvent('uk_complaints:notify', function(msg, kind)
    lib.notify({
        title = kind == 'success' and '✅ Success' or kind == 'error' and '❌ Error' or 'ℹ️ Info',
        description = msg, type = kind, duration = 5000
    })
    SendNUIMessage({ action = 'toast', message = msg, kind = kind })
end)
RegisterNetEvent('uk_complaints:forceClose', closeUi)

RegisterNUICallback('close', function(_, cb) closeUi() cb({ok=true}) end)
RegisterNUICallback('submit', function(data, cb)
    TriggerServerEvent('uk_complaints:submit', data)
    cb({ok=true})
end)
RegisterNUICallback('refresh', function(_, cb)
    TriggerServerEvent('uk_complaints:requestData', 'refresh')
    cb({ok=true})
end)
RegisterNUICallback('setStatus', function(data, cb)
    TriggerServerEvent('uk_complaints:setStatus', data.id, data.status)
    cb({ok=true})
end)
RegisterNUICallback('addNote', function(data, cb)
    TriggerServerEvent('uk_complaints:addNote', data.id, data.note)
    cb({ok=true})
end)

local function addZone()
    if not Config.Desk.Enabled or zoneAdded then return end
    zoneId = exports.ox_target:addSphereZone({
        coords = Config.Desk.Coords,
        radius = Config.Desk.Distance,
        options = {
            {
                name = 'public',
                icon = Config.Desk.PublicIcon,
                label = Config.Desk.PublicLabel,
                onSelect = function() openUi('submit') end
            },
            {
                name = 'staff',
                icon = Config.Desk.StaffIcon,
                label = Config.Desk.StaffLabel,
                groups = { [Config.PoliceJobName] = Config.Permissions.ReviewAccess },
                onSelect = function() TriggerServerEvent('uk_complaints:requestAccess') end
            }
        }
    })
    zoneAdded = true
end

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do Wait(500) end
    addZone()
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        if uiOpen then SetNuiFocus(false, false) end
        if zoneAdded then exports.ox_target:removeZone(zoneId) end
    end
end)