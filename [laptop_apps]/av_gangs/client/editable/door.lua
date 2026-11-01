-- Door menu, just in case u don't use ox_lib context menu, make sure to send all required args
function gangDoor(identifier, type, gang, isOpen, isExit)
    local currentZone = getZoneGang()
    dbug('gangDoor(identifier,type,gang,isOpen,isExit?,currentZone?)', identifier, type, gang, isOpen, isExit, currentZone)
    local options = {}
    if isExit then
        options[#options+1] = {
            title = Lang['exit_property'],
            event = 'av_gangs:exit',
            args = {}
        }
    else
        if Config.PropertyInZone then
            if (currentZone and PlayerGang and PlayerGang.name == currentZone) then
                options[#options+1] = {
                    title = Lang['enter_property'],
                    event = 'av_gangs:enter',
                    args = {
                        identifier = identifier, type = type, gang = gang
                    }
                }
            end
        else
            options[#options+1] = {
                title = Lang['enter_property'],
                event = 'av_gangs:enter',
                args = {
                    identifier = identifier, type = type, gang = gang
                }
            }
        end
    end
    local description = Lang['locked']
    if isOpen then
        description = Lang['unlocked']
    end
    if Config.PropertyInZone then
        if (currentZone and PlayerGang and PlayerGang.name == currentZone) then
            options[#options+1] = {
                title = Lang['door_state'],
                event = 'av_gangs:toggleDoor',
                description = description,
                args = {
                    identifier = identifier, type = type, gang = gang, isExit = isExit
                }
            }
        end
    else
        options[#options+1] = {
            title = Lang['door_state'],
            event = 'av_gangs:toggleDoor',
            description = description,
            args = {
                identifier = identifier, type = type, gang = gang, isExit = isExit
            }
        }
    end
    if options and next(options) then
        exports['av_laptop']:registerContext({
            id = 'gang_door',
            title = Lang['door_options'],
            options = options
        })
        exports['av_laptop']:showContext('gang_door')
    else
        TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['property_not_in_zone'], 'error')
    end
end

RegisterNetEvent('av_gangs:enter', function(data)
    enter(data['identifier'], data['type'], data['gang'])
end)

RegisterNetEvent('av_gangs:toggleDoor', function(data)
    local isOpen = lib.callback.await('av_gangs:toggleDoor', false, data)
    if type(isOpen) == "string" then
        print("^3[WARNING]^7 Something went wrong with this function, report it to your server admin.")
        return
    end
    gangDoor(data['identifier'], data['type'], data['gang'], isOpen, data['isExit'])
end)