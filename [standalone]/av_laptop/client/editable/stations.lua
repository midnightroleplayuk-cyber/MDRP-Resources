local currentStation = nil
local points = {}
local events = {
    ['charge'] = 'av_laptop:chargeStation',
    ['reset'] = 'av_laptop:resetStation',
}

registerContext({
  id = 'reset_menu',
  title = Lang['reset_station'],
  options = {
    {
      title = Lang['open_stash'],
      icon = 'box',
      event = "av_laptop:openResetStash",
    },
    {
      title = Lang['reset_laptop'],
      icon = 'laptop',
      event = "av_laptop:resetLaptop",
    },
  }
})

if useZones then
    for k, v in pairs(Stations) do
        points[#points+1] = lib.points.new({
            label = Lang['interact'],
            distance = 1.5,
            coords = v['coords'],
            job = v['job'],
            args = k,
            type = v['type']
        })
    end
    for _, v in pairs(points) do
        function v:onExit()
            if isTextUIOpen() then
                hideTextUI()
            end
        end
        function v:nearby()
            if self.currentDistance <= 1.5 and (not self.job or self.job == PlayerJob?.name) and not LocalPlayer.state.busy then
                if not isTextUIOpen() then
                    showTextUI(self.label)
                end
                if IsControlJustPressed(0,38) then
                    hideTextUI()
                    TriggerEvent(events[self.type], self.args)
                end
            end
        end
    end
end

RegisterNetEvent('av_laptop:chargeStation', function(station)
    if not station then print('av_laptop:chargeStation received a null argument') return end
    if not Stations[station] then print('av_laptop:chargeStation received a non existing station name') return end
    exports['av_laptop']:openStash(station, station, Stations[station]['maxWeight'], Stations[station]['slots'])
end)

RegisterNetEvent('av_laptop:resetStation', function(station)
    currentStation = station
    showContext("reset_menu")
end)

RegisterNetEvent('av_laptop:resetLaptop', function()
    if not currentStation then print('av_laptop:resetLaptop received a null argument') return end
    if not Stations[currentStation] then print('av_laptop:resetLaptop received a non existing station name') return end
    LocalPlayer.state:set("busy", true, true)
    if progressBar({
        duration = math.random(5000,10000),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        },
    }) then TriggerServerEvent('av_laptop:resetLaptop',currentStation) end
    LocalPlayer.state:set("busy", false, true)
end)

RegisterNetEvent('av_laptop:openResetStash', function()
    if not currentStation then print('av_laptop:openResetStash received a null argument') return end
    if not Stations[currentStation] then print('av_laptop:openResetStash received a non existing station name') return end
    exports['av_laptop']:openStash(currentStation, currentStation, Stations[currentStation]['maxWeight'], Stations[currentStation]['slots'])
end)