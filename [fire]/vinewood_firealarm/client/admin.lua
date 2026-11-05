RegisterCommand(Config.AdminCommand, function()
    local data = lib.callback.await('vinewood_firealarm:admin:open', false)
    if not data then return lib.notify({ type = 'error', description = 'You don\'t have permission to manage fire alarms' }) end
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openAdmin', systems = data.systems, maxZones = data.maxZones, tones = data.tones })
end, false)

RegisterNUICallback('adminClose', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

local function relay(name, ...)
    local res, extra = lib.callback.await('vinewood_firealarm:admin:' .. name, false, ...)
    return res, extra
end

RegisterNUICallback('adminSave', function(data, cb)
    local systems, idOrErr = relay('save', data)
    if systems then cb({ ok = true, systems = systems, id = idOrErr }) else cb({ ok = false, msg = idOrErr or 'Save failed' }) end
end)

RegisterNUICallback('adminDelete', function(data, cb)
    cb({ ok = true, systems = relay('delete', data.id) })
end)

RegisterNUICallback('adminDeleteDevice', function(data, cb)
    cb({ ok = true, systems = relay('deleteDevice', data.id, data.devId) })
end)

RegisterNUICallback('adminUpdateDevice', function(data, cb)
    cb({ ok = true, systems = relay('updateDevice', data.id, data.devId, data.fields) })
end)

RegisterNUICallback('adminTrigger', function(data, cb)
    cb({ ok = true, systems = relay('trigger', data.id, data.zone) })
end)

RegisterNUICallback('adminReset', function(data, cb)
    cb({ ok = true, systems = relay('reset', data.id) })
end)

RegisterNUICallback('adminRefresh', function(_, cb)
    local data = lib.callback.await('vinewood_firealarm:admin:open', false)
    cb({ ok = data and true or false, systems = data and data.systems or nil })
end)

RegisterNUICallback('adminTeleport', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'adminHide' })
    local ped = PlayerPedId()
    DoScreenFadeOut(250) Wait(300)
    SetEntityCoords(ped, data.x + 0.0, data.y + 0.0, data.z - 0.9, false, false, false, false)
    DoScreenFadeIn(250)
end)

-- Place a new device, or move an existing one (data.devId set)
RegisterNUICallback('adminPlace', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'adminHide' })
    CreateThread(function()
        local res = Placement.Start(data.type, data.mode)
        local systems
        if res then
            if data.devId then
                systems = relay('updateDevice', data.id, data.devId, res)
            else
                res.type, res.zone, res.label = data.type, data.zone, data.label
                systems = relay('addDevice', data.id, res)
            end
            lib.notify({ type = 'success', description = data.devId and 'Device moved' or 'Device placed' })
        end
        if not systems then systems = (lib.callback.await('vinewood_firealarm:admin:open', false) or {}).systems end
        if systems then
            SetNuiFocus(true, true)
            SendNUIMessage({ action = 'adminShow', systems = systems, select = data.id })
        end
    end)
end)
