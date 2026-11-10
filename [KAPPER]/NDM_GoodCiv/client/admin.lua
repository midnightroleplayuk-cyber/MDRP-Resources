-- /goodcivconfig: in-city creator for hospital check-in points. The server checks
-- the ace on open and on every change; this side only shows the panel and markers.
Admin = {}

local open = false

function Admin.IsOpen() return open end

local function payload()
    local list = {}
    local coords = GetEntityCoords(PlayerPedId())
    for _, h in ipairs(GoodCiv.Hospitals) do
        list[#list + 1] = {
            id = h.id,
            label = h.label,
            custom = h.custom,
            fee = h.fee,
            radius = h.radius,
            distance = math.floor(#(coords - h.coords)),
        }
    end
    table.sort(list, function(a, b) return a.distance < b.distance end)
    return {
        hospitals = list,
        defaults = { fee = Config.CheckIn.Fee, radius = 30 },
        economy = Bridge.Name ~= 'standalone',
    }
end

function Admin.Refresh()
    if open then Nui.Send('config', payload()) end
end

local function close()
    open = false
    Nui.Focus(false)
    Nui.Send('config', false)
end

RegisterNetEvent('goodciv:client:openConfig', function()
    if GetInvokingResource() then return end
    open = true
    Nui.Focus(true)
    Nui.Send('config', payload())
end)

RegisterNUICallback('cfgClose', function(_, cb) cb('ok') close() end)

RegisterNUICallback('cfgAdd', function(data, cb)
    cb('ok')
    TriggerServerEvent('goodciv:server:cfgAdd', data)
end)

RegisterNUICallback('cfgUpdate', function(data, cb)
    cb('ok')
    TriggerServerEvent('goodciv:server:cfgUpdate', data)
end)

RegisterNUICallback('cfgMove', function(data, cb)
    cb('ok')
    TriggerServerEvent('goodciv:server:cfgMove', data.id)
end)

RegisterNUICallback('cfgRemove', function(data, cb)
    cb('ok')
    TriggerServerEvent('goodciv:server:cfgRemove', data.id)
end)

RegisterNUICallback('cfgTeleport', function(data, cb)
    cb('ok')
    local h = GoodCiv.GetHospital(data.id)
    if not h then return end
    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, h.drop.x, h.drop.y, h.drop.z, false, false, false)
    SetEntityHeading(ped, h.drop.w)
    Admin.Refresh()
end)

-- While the panel is open, show every point's check-in spot and handover zone nearby.
CreateThread(function()
    while true do
        if not open then
            Wait(500)
        else
            local coords = GetEntityCoords(PlayerPedId())
            for _, h in ipairs(GoodCiv.Hospitals) do
                if #(coords - h.coords) < 150.0 then
                    DrawMarker(1, h.coords.x, h.coords.y, h.coords.z - 1.0, 0, 0, 0, 0, 0, 0,
                        h.radius * 2.0, h.radius * 2.0, 1.0, 78, 168, 255, 40, false, false, 2, false, nil, nil, false)
                    DrawMarker(2, h.drop.x, h.drop.y, h.drop.z + 0.4, 0, 0, 0, 0, 180.0, 0, 0.4, 0.4, 0.4,
                        34, 197, 139, 200, true, true, 2, false, nil, nil, false)
                end
            end
            Wait(0)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and open then Nui.Focus(false) end
end)
