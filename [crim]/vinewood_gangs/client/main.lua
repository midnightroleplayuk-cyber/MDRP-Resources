-- Client entry point. Keep client logic presentational: the server owns all state.

local PlayerGang -- own gang data only, pushed by the server

RegisterNetEvent('vinewood_gangs:client:setGang', function(data)
    PlayerGang = data
    TriggerEvent('vinewood_gangs:client:gangUpdated', data)
end)

function GetPlayerGang() return PlayerGang end

---Asks the server for our gang and updates everything that shows it.
function RefreshPlayerGang()
    local data = lib.callback.await('vinewood_gangs:server:myGang', false)
    PlayerGang = data
    TriggerEvent('vinewood_gangs:client:gangUpdated', data)
    return data
end

-- Resource (re)start while already in game
CreateThread(function()
    Wait(2000)
    RefreshPlayerGang()
end)

-- Character loaded (qb-core / Qbox, and ESX)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(1000)
    RefreshPlayerGang()
end)
RegisterNetEvent('esx:playerLoaded', function()
    Wait(1000)
    RefreshPlayerGang()
end)

exports('GetGang', function() return PlayerGang end)

---Does my rank have this permission? (Used by other client files, and as an export.)
function HasGangPermission(permission)
    if not PlayerGang then return false end
    for _, p in ipairs(PlayerGang.permissions or {}) do
        if p == '*' or p == permission then return true end
    end
    return false
end

exports('HasGangPermission', HasGangPermission)

RegisterNetEvent('vinewood_gangs:client:invite', function(data)
    local choice = lib.alertDialog({
        header = locale('invite_header'),
        content = locale('invite_body', data.inviter, data.gang, data.expires),
        centered = true,
        cancel = true,
        labels = { confirm = locale('join'), cancel = locale('decline') },
    })

    local ok, err = lib.callback.await('vinewood_gangs:server:respondInvite', false, choice == 'confirm')
    if not ok and err then
        lib.notify({ description = locale(err), type = 'error' })
    end
end)

-- Markdown info panel used by /gmembers and staff commands
RegisterNetEvent('vinewood_gangs:client:info', function(title, body)
    lib.alertDialog({ header = title, content = body, size = 'lg' })
end)
