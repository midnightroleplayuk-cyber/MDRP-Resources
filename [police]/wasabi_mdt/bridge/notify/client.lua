local notify = {}

local notificationSystem = 'ox_lib'

local notificationPriority = {
    'wasabi_notify',
    'wasabi_uikit',
    'lation_ui',
    'ox_lib',
}

local notificationSystems = {
    ['wasabi_notify'] = function(params)
        if params.style == 'inform' or params.style == 'primary' then params.type = 'info' end
        return exports.wasabi_notify:notify(params.title, params.description, 3500, params.type, false, nil, nil)
    end,
    ['wasabi_uikit'] = function(params)
        if params.style == 'inform' or params.style == 'primary' then params.type = 'info' end
        return exports.wasabi_uikit:Notification(params.title, params.description, params.type, nil, nil)
    end,
    ['lation_ui'] = function(params)
        return exports.lation_ui:notify({
            title = params.title,
            message = params.description,
            position = 'top-right',
            duration = 3500,
            type = params.type,
        })
    end,
    ['ox_lib'] = function(params)
        return lib.notify({ title = params.title, description = params.description, type = params.type })
    end,
}

function notify.init()
    for _, resourceName in ipairs(notificationPriority) do
        if GetResourceState(resourceName):find('start') then
            notificationSystem = resourceName
            break
        end
    end
end

RegisterNetEvent('wasabi_mdt:Client:notify', function(params)
    if not notificationSystems[notificationSystem] then notificationSystem = 'ox_lib' end
    notificationSystems[notificationSystem](params)
end)

setmetatable(notify, {
    __call = function(_, params)
        if not notificationSystems[notificationSystem] then notificationSystem = 'ox_lib' end
        return notificationSystems[notificationSystem](params)
    end,
})

Modules.register('notify', notify)
