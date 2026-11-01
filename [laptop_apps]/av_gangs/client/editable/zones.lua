local points = {}
local busyPoint = false
local hideUI = false

function registerZones(data)
    for _, v in pairs(data) do
        points[#points+1] = lib.points.new({
            coords = {x = v['entry']['x'], y = v['entry']['y'], z = v['entry']['z']},
            distance = 2,
            gang = v['gang'],
            identifier = v['identifier'],
            type = v['type'],
        })
    end
    refreshZones()
end

function refreshZones()
    for _, v in pairs(points) do
        function v:nearby()
            if self.currentDistance <= 2 and not busyPoint then
                if not exports['av_laptop']:isTextUIOpen() and not hideUI then
                    exports['av_laptop']:showTextUI(Config.InteractionPrefix.." "..Lang['door_text'])
                end
                if IsControlJustReleased(0, Config.InteractionKey) then
                    if exports['av_laptop']:isTextUIOpen() then
                        hideUI = true
                        exports['av_laptop']:hideTextUI()
                    end
                    busyPoint = true
                    doorOptions(self.identifier, self.type, self.gang)
                    lib.timer(3000, function()
                        busyPoint = false
                        hideUI = false
                    end, true)
                end
            end
        end
        function v:onExit()
            hideUI = false
            if exports['av_laptop']:isTextUIOpen() then
                exports['av_laptop']:hideTextUI()
            end
        end
    end
end

function isCloseToProperty()
    local myCoords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(points) do
        local dist = #(myCoords - v['coords'])
        if dist <= (Config.PropertyDistance or 5.0) then
            return true
        end
    end
end

function wipeZones(gang)
    local isClose = isCloseToProperty()
    for k, v in pairs(points) do
        if v['gang'] == gang then
            v:remove()
            table.remove(points, k)
        end
    end
    refreshZones()
    Wait(250)
    if isClose and exports['av_laptop']:isTextUIOpen() then
        hideUI = false
        exports['av_laptop']:hideTextUI()
    end
end

RegisterNetEvent('av_gangs:newZone', function(data)
    points[#points+1] = lib.points.new({
        coords = {x = data['entry']['x'], y = data['entry']['y'], z = data['entry']['z']},
        distance = 2,
        gang = data['gang'],
        identifier = data['identifier'],
        type = data['type'],
        isOpen = data['isOpen'] or false,
    })
    refreshZones()
end)

RegisterNetEvent('av_gangs:deleteZone', function(identifier)
    local isClose = isCloseToProperty()
    for k, v in pairs(points) do
        if v['identifier'] == identifier then
            v:remove()
            table.remove(points, k)
            break
        end
    end
    refreshZones()
    Wait(250)
    if isClose and exports['av_laptop']:isTextUIOpen() then
        hideUI = false
        exports['av_laptop']:hideTextUI()
    end
end)