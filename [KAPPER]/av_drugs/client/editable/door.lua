function doorOptions(type, drug, identifier, isExit) -- if isExit = true then type and drug will be null
    dbug('doorOptions(type, drug, identifier, isExit)',type, drug, identifier, isExit)
    local options = {}
    local data = lib.callback.await('av_drugs:getDoorStatus', false, identifier)
    if not data then
        print("^3[WARNING]^7 This lab doesn't exist server side", identifier)
        return
    end
    if data['isOwner'] or data['hasKeys'] then
        doorOwner(type, drug, identifier, data['isOpen'], isExit)
        return
    end
    if data['isOpen'] and not isExit then
        TriggerEvent('av_drugs:enter', {identifier = identifier})
        return
    end
    if isExit then
        TriggerEvent('av_drugs:wipe')
        return
    end
    if not isExit and canRaid() then
        local security = lib.callback.await('av_drugs:getLabLevel', false, identifier, 'security')
        security = security and tonumber(security) or 0
        local res = minigame(security)
        if res then
            TriggerEvent('av_drugs:enter', {identifier = identifier, hasKeys = true})
            TriggerServerEvent('av_drugs:raided', identifier)
            return
        end
    else
        TriggerEvent('av_laptop:notification', Lang['door_title'],Lang['closed_notification'], "error")
    end
end

function doorOwner(type, drug, identifier, isOpen, isExit)
    local options = {}
    if isOpen then
        options[#options+1] = {
            title = Lang['lock_option'],
            description = Lang['lock_description'],
            serverEvent = "av_drugs:toggleDoor",
            args = {identifier = identifier}
        }
    else
        options[#options+1] = {
            title = Lang['unlock_option'],
            description = Lang['unlock_description'],
            serverEvent = "av_drugs:toggleDoor",
            args = {identifier = identifier}
        }
    end
    if isExit then
        options[#options+1] = {
            title = Lang['exit_property'],
            event = "av_drugs:wipe"
        }
    else
        options[#options+1] = {
            title = Lang['enter_property'],
            event = "av_drugs:enter",
            args = {identifier = identifier, hasKeys = true}
        }
    end
    exports['av_laptop']:registerContext({
        id = 'door_owner',
        title = Lang['door_options'],
        options = options
    })
    exports['av_laptop']:showContext('door_owner')
end