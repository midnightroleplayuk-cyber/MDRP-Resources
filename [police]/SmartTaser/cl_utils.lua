function alert(msg) 
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

function safetyToggled(newStatus)
    
end

function getNumberOfLoadedCartridges()
    return tasers[weapon].loadedCartridges or 0
end

exports("getNumberOfLoadedCartridges", getNumberOfLoadedCartridges)