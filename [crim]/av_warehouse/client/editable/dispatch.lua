local usingCustom = false -- Change this to true after u added your custom dispatch to disable the default

function sendDispatch(playerCoords)
    dbug('sendDispatch(playerCoords)', playerCoords.x, playerCoords.y, playerCoords.z)
    -- Add your dispatch here, don't delete the return line

    return usingCustom
end

-- Default dispatch event
local blips = {}
RegisterNetEvent('av_warehouse:dispatch', function(coords,identifier)
    if not isCop() then return end
    TriggerEvent('av_warehouse:notification', Lang['dispatch_title'], Lang['dispatch_message'], "warning")
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, Config.Dispatch['sprite'])
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 5)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.Dispatch['label'])
	EndTextCommandSetBlipName(blip)
    blips[identifier] = blip
    lib.timer(Config.Dispatch['timer'] * 60 * 1000, function()
        RemoveBlip(blips[identifier])
        blips[identifier] = nil
    end,true)
end)