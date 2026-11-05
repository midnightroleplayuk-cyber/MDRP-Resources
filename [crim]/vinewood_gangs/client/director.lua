if not Config.Modules.director then return end

local drops = {} -- drops[netId] = { blip, untilAt }
local prompt, busy = nil, false

local function setPrompt(key)
    if key == prompt then return end
    if prompt then lib.hideTextUI() end
    if key then lib.showTextUI(locale(key)) end
    prompt = key
end

RegisterNetEvent('vinewood_gangs:client:directorDrop', function(netId, where, seconds)
    drops[netId] = { untilAt = GetGameTimer() + seconds * 1000 }
end)

local function ourEntrances()
    local gang = GetPlayerGang()
    local out = {}
    if not gang then return out end
    for _, h in ipairs(GlobalState.vg_safehouses or {}) do
        if h.gangId == gang.id then out[#out + 1] = vector3(h.entrance.x, h.entrance.y, h.entrance.z) end
    end
    return out
end

CreateThread(function()
    while true do
        local sleep, want, plate = 1000, nil, nil
        local now = GetGameTimer()

        -- Blip on the missing van for everyone who was told about it
        for netId, d in pairs(drops) do
            if now > d.untilAt then
                if d.blip and DoesBlipExist(d.blip) then RemoveBlip(d.blip) end
                drops[netId] = nil
            elseif not d.blip and NetworkDoesNetworkIdExist(netId) then
                local veh = NetToVeh(netId)
                if DoesEntityExist(veh) then
                    d.blip = AddBlipForEntity(veh)
                    SetBlipSprite(d.blip, 477)
                    SetBlipColour(d.blip, 46)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentSubstringPlayerName(locale('blip_drop'))
                    EndTextCommandSetBlipName(d.blip)
                end
            elseif d.blip and not DoesEntityExist(GetBlipInfoIdEntityIndex(d.blip)) then
                RemoveBlip(d.blip)
                drops[netId] = nil
            end
        end

        -- In the van, at one of our safehouses
        if not busy then
            local veh = GetVehiclePedIsIn(cache.ped, false)
            if veh ~= 0 then
                plate = tonumber((GetVehicleNumberPlateText(veh) or ''):match('DRP(%d+)'))
                if plate then
                    sleep = 250
                    local pos = GetEntityCoords(veh)
                    for _, e in ipairs(ourEntrances()) do
                        if #(pos - e) < 15.0 then want, sleep = 'drop_prompt', 0 break end
                    end
                end
            end
        end
        setPrompt(want)

        if want and IsControlJustPressed(0, 38) then
            busy = true
            setPrompt(nil)
            if lib.progressBar({ duration = 6000, label = locale('supply_unloading'), canCancel = true, disable = { car = true, combat = true } }) then
                local ok, res = lib.callback.await('vinewood_gangs:server:directorUnload', false, plate)
                if ok then
                    lib.notify({ description = locale('drop_claimed', Utils.FormatMoney(res)), type = 'success' })
                    TaskLeaveVehicle(cache.ped, GetVehiclePedIsIn(cache.ped, false), 0)
                else
                    lib.notify({ description = locale(res or 'failed'), type = 'error' })
                end
            end
            busy = false
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, d in pairs(drops) do if d.blip and DoesBlipExist(d.blip) then RemoveBlip(d.blip) end end
    if prompt then lib.hideTextUI() end
end)
