local blips = {}

RegisterNetEvent("av_business:refreshBlips", function(data)
    for k, v in pairs(data) do
        if v['online'] then
            if blips[k] and DoesBlipExist(blips[k]) then
                RemoveBlip(blips[k])
            end
            blips[k] = AddBlipForCoord(v['x'], v['y'], v['z'])
            SetBlipSprite(blips[k], v['sprite'])
            SetBlipScale(blips[k], 0.7)
            SetBlipDisplay(blips[k], 4)
            SetBlipColour(blips[k], v['color'])
            SetBlipAsShortRange(blips[k], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v['label'])
            EndTextCommandSetBlipName(blips[k])
        end
        if blips[k] and not v['online'] then
            RemoveBlip(blips[k])
            blips[k] = nil
        end
    end
end)

exports("getBlips", function()
    return blips
end)