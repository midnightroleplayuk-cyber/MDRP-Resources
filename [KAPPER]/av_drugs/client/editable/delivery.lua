local delivery = nil
local points = {}

CreateThread(function()
    for k, v in pairs(Config.Locations) do
        local coords = v['Delivery']
        points[#points+1] = lib.points.new({
            coords = vec3(coords[1], coords[2], coords[3]),
            distance = 5,
        })
    end
    for k, v in pairs(points) do
        function v:nearby()        
            if self.currentDistance < 2 then
                if not exports['av_laptop']:isTextUIOpen() then
                    exports['av_laptop']:showTextUI(Lang['knock']) 
                end
                if IsControlJustReleased(0, 38) and not LocalPlayer.state.busy then
                    animation()
                    lib.timer(500, function()
                        LocalPlayer.state.busy = false
                    end, true)
                    TriggerServerEvent("av_drugs:getDelivery")
                    if delivery and DoesBlipExist(delivery) then
                        RemoveBlip(delivery)
                        delivery = nil
                    end
                end
            end
        end
        function v:onExit()
            if exports['av_laptop']:isTextUIOpen() then
                exports['av_laptop']:hideTextUI()
            end
        end
    end
end)

RegisterNetEvent('av_drugs:marketBlip', function()
    if delivery then return end
    local random = math.random(1,#Config.Locations)
    local blipInfo = Config.Locations[random]
    delivery = AddBlipForCoord(blipInfo.Delivery[1], blipInfo.Delivery[2], blipInfo.Delivery[3])
    SetBlipSprite(delivery, blipInfo.BlipIcon)
    SetBlipScale(delivery, blipInfo.BlipScale)
    SetBlipDisplay(delivery, 4)
    SetBlipColour(delivery, blipInfo.BlipColor)
    SetBlipAsShortRange(delivery, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Lang['blip_text'])
    EndTextCommandSetBlipName(delivery)
    TriggerEvent('av_laptop:notificationUI', Lang['app_title'], Lang['pick_your_shit'], 'inform')
end)

function animation()
    local ped = PlayerPedId()
    lib.requestAnimDict("timetable@jimmy@doorknock@", 5000)
    FreezeEntityPosition(ped,true)
    TaskPlayAnim(ped, "timetable@jimmy@doorknock@", 'knockdoor_idle', 2.0, 2.0, 3000, 1, 0, true, true, true)
    FreezeEntityPosition(ped,false)
    Wait(2000)
end