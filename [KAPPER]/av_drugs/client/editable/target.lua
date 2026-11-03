-- This is for tables only

function addToTarget(entity, identifier, itemName, owner, isCooking)
    if entity and DoesEntityExist(entity) then
        local options = {
            {
                num = 1,
                distance = 1,
                name = "cook",
                type = "client",
                event = "av_drugs:startCooking",
                icon = 'fa-solid fa-fire',
                label = Lang['cook'],
                identifier = identifier,
                itemName = itemName,
                owner = owner,
                canInteract = function(entity)
                    if isCooking then return false end
                    if LocalPlayer.state.busy then return false end
                    return not exports['av_laptop']:hasJob(Config.PoliceJobs) -- don't allow police to cook
                end,
            },
            {
                num = 2,
                distance = 1,
                name = "open",
                type = "client",
                event = "av_drugs:openStash",
                icon = 'fa-solid fa-box',
                label = Lang['open'],
                identifier = identifier,
                itemName = itemName,
                canInteract = function(entity)
                    if isCooking then return false end
                    if LocalPlayer.state.busy then return false end
                    return true
                end,
            },
            {
                num = 3,
                distance = 1,
                name = "remove",
                type = "client",
                event = "av_drugs:removeTable",
                icon = 'fa-solid fa-hammer',
                label = Lang['remove'],
                identifier = identifier,
                itemName = itemName,
                owner = owner,
                canInteract = function(entity)
                    if LocalPlayer.state.busy then return false end
                    return not exports['av_laptop']:hasJob(Config.PoliceJobs) -- don't allow police to remove tables
                end,
            },
            {
                num = 4,
                distance = 1,
                name = "destroy",
                type = "client",
                event = "av_drugs:destroyTable",
                icon = 'fa-solid fa-trash-can',
                label = Lang['destroy'],
                identifier = identifier,
                owner = owner,
                canInteract = function(entity)
                    if LocalPlayer.state.busy then return false end
                    return exports['av_laptop']:hasJob(Config.PoliceJobs) -- only cops can destroy tables
                end,
            },
        }
        if Config.Target == "ox_target" then
            exports[Config.Target]:addLocalEntity(entity, options)
        else
            exports[Config.Target]:AddTargetEntity(entity, {
                options = options,
                distance = 1,
            })
        end
    end
end

function removeTarget(entity)
    if Config.Target == "ox_target" then
        exports[Config.Target]:removeLocalEntity(entity)
    else
        exports[Config.Target]:RemoveTargetEntity(entity)
    end
end