if not Config.Modules.auctions then return end

local drops = {} -- drops[id] = { point, title, untilAt, blip }
local prompt, busy = nil, false

local function setPrompt(key)
    if key == prompt then return end
    if prompt then lib.hideTextUI() end
    if key then lib.showTextUI(locale(key)) end
    prompt = key
end

local function removeDrop(id)
    local d = drops[id]
    if d and d.blip and DoesBlipExist(d.blip) then RemoveBlip(d.blip) end
    drops[id] = nil
end

RegisterNetEvent('vinewood_gangs:client:auctionDrop', function(id, point, title, seconds)
    removeDrop(id)
    local blip = AddBlipForCoord(point.x, point.y, point.z)
    SetBlipSprite(blip, 586)
    SetBlipColour(blip, 46)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(locale('blip_auction_drop'))
    EndTextCommandSetBlipName(blip)
    drops[id] = { point = vector3(point.x, point.y, point.z), title = title, untilAt = GetGameTimer() + seconds * 1000, blip = blip }
end)

RegisterNetEvent('vinewood_gangs:client:auctionDropGone', function(id) removeDrop(id) end)

CreateThread(function()
    while true do
        local sleep, want, target = 1000, nil, nil
        local now = GetGameTimer()
        local pos = GetEntityCoords(cache.ped)
        for id, d in pairs(drops) do
            if now > d.untilAt then
                removeDrop(id)
            else
                local dist = #(pos - d.point)
                if dist < 50.0 then
                    sleep = 0
                    DrawMarker(2, d.point.x, d.point.y, d.point.z + 0.2, 0, 0, 0, 0, 180.0, 0, 0.3, 0.3, 0.3, 242, 169, 59, 180, true, true, 2, false, nil, nil, false)
                end
                if dist < 2.0 and not busy and not IsPedInAnyVehicle(cache.ped, false) then want, target = 'auction_drop_prompt', id end
            end
        end
        setPrompt(want)

        if target and IsControlJustPressed(0, 38) then
            busy = true
            setPrompt(nil)
            if lib.progressBar({
                duration = 5000, label = locale('auction_drop_searching'), canCancel = true,
                disable = { move = true, car = true, combat = true },
                anim = { dict = 'amb@prop_human_bum_bin@base', clip = 'base' },
            }) then
                local ok, res = lib.callback.await('vinewood_gangs:server:auctionPickup', false, target)
                if ok then
                    lib.notify({ description = locale('auction_drop_got', res), type = 'success' })
                    removeDrop(target)
                else
                    lib.notify({ description = locale(res or 'failed'), type = 'error' })
                    if res == 'auction_drop_gone' then removeDrop(target) end
                end
            end
            busy = false
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(drops) do removeDrop(id) end
    if prompt then lib.hideTextUI() end
end)
