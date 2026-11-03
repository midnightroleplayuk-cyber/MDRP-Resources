local isBusy = false
RegisterNetEvent("av_business:useCleaningItem", function(item)
    if isBusy then
        dbug("useCleaningItem() isBusy, ignoring...")
        return
    end
    local settings = Config.CleaningProducts[item]
    dbug("useCleaningItem(item, settings?, inJobZone?)", item, settings and "yes" or "no", inJobZone and "yes" or "no")
    if not inJobZone then
        TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['cleaning_not_in_zone'], "error")
        return
    end
    if settings then
        isBusy = true
        local result = exports['av_laptop']:progressBar({
            duration = settings['time'] or 5000,
            label = settings['label'] or "Cleaning",
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = not settings['canWalk'],
                car = not settings['canDrive'],
            },
            anim = settings['anim'],
            prop = settings['prop']
        })
        if result then
            TriggerServerEvent("av_business:cleanBusiness")
        end
        lib.timer(1000, function()
            isBusy = false
        end)
    end
end)