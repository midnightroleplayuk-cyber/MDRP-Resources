local delivery = nil
local points = {}
local busy = false

-- Create Blip on map
RegisterNetEvent('av_darkmarket:setGPS', function()
    if delivery and DoesBlipExist(delivery) then
        RemoveBlip(delivery)
    end
    local random = math.random(1,#Config.Locations)
    local blipInfo = Config.Locations[random]
    delivery = AddBlipForCoord(blipInfo.Delivery[1], blipInfo.Delivery[2], blipInfo.Delivery[3])
    dbug('setGPS(x,y,z)', blipInfo.Delivery[1], blipInfo.Delivery[2], blipInfo.Delivery[3])
    SetBlipSprite(delivery, blipInfo.BlipIcon)
    SetBlipScale(delivery, blipInfo.BlipScale)
    SetBlipDisplay(delivery, 4)
    SetBlipColour(delivery, blipInfo.BlipColor)
    SetBlipAsShortRange(delivery, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Lang['blip_text'])
    EndTextCommandSetBlipName(delivery)
end)

-- Create Zone
CreateThread(function()
    for _, v in pairs(Config.Locations) do
        local coords = v['Delivery']
        points[#points+1] = lib.points.new({
            coords = vec3(coords[1], coords[2], coords[3]),
            distance = 1.25,
        })
    end
    for _, v in pairs(points) do
        function v:onEnter()
            if not exports['av_laptop']:isTextUIOpen() then
                exports['av_laptop']:showTextUI(Lang['knock'])
            end
        end
        function v:nearby()
            if self.currentDistance < 2 then
                if IsControlJustReleased(0, 38) and not busy then
                    busy = true
                    animation()
                    if delivery and DoesBlipExist(delivery) then
                        RemoveBlip(delivery)
                    end
                    lib.timer(2000, function()
                        busy = false
                    end,true)
                    openStash()
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

function animation()
    lib.requestAnimDict("timetable@jimmy@doorknock@", 5000)
    FreezeEntityPosition(cache.ped,true)
    TaskPlayAnim(cache.ped, "timetable@jimmy@doorknock@", 'knockdoor_idle', 2.0, 2.0, 3000, 1, 0, true, true, true)
    FreezeEntityPosition(cache.ped,false)
    Wait(2000)
end

function openStash()
    dbug('openStash()')
    local identifier = lib.callback.await('av_darkmarket:getIdentifier')
    if not identifier then return end
    exports['av_laptop']:openStash("dark_market"..identifier, Lang['inventory_label'] or "Market", Config.Stash and Config.Stash['weight'] or 100000, Config.Stash and Config.Stash['slots'] or 50)
end