local runtime = require 'shared.runtime'

-- Show a notification
--- @param message string
--- @param type string
function ShowNotification(message, type)
    -- Notify systems that take a separate title get it from the locale file so
    -- the resource name can be translated alongside the message body.
    local title = locale('notify.title')

    if runtime.setup.notify == 'lation_ui' then
        exports.lation_ui:notify({ title = title, message = message, type = type or 'info', icon = 'fas fa-car' })
    elseif runtime.setup.notify == 'ox_lib' then
        lib.notify({ description = message, type = type or 'inform', position = 'top', icon = 'fas fa-car' })
    elseif runtime.setup.notify == 'esx' then
        ESX.ShowNotification(message)
    elseif runtime.setup.notify == 'qb' then
        QBCore.Functions.Notify(message, type or 'primary')
    elseif runtime.setup.notify == 'okok' then
        exports['okokNotify']:Alert(title, message, 5000, type or 'info', false)
    elseif runtime.setup.notify == 'wasabi_notify' then
        exports.wasabi_notify:notify(title, message, 5000, type or 'info', false, 'fas fa-car')
    elseif runtime.setup.notify == 'custom' then
        -- Add custom notification export/event here
    end
end

-- Display a progress bar
--- @param data table
function ProgressBar(data)
    local label = data.label
    if runtime.setup.progress == 'lation_ui' then
        if exports.lation_ui:progressBar({
            label = label,
            description = data.description or nil,
            icon = data.icon or nil,
            duration = data.duration,
            useWhileDead = data.useWhileDead,
            canCancel = data.canCancel,
            steps = data.steps or nil,
            disable = data.disable,
            anim = {
                dict = data.anim.dict or nil,
                clip = data.anim.clip or nil,
                flag = data.anim.flag or nil
            },
            prop = {
                model = data.prop.model or nil,
                bone = data.prop.bone or nil,
                pos = data.prop.pos or nil,
                rot = data.prop.rot or nil
            }
        }) then
            return true
        end
        return false
    elseif runtime.setup.progress == 'ox_lib' then
        -- Want to use ox_lib's progress circle instead of bar?
        -- Change "progressBar" to "progressCircle" below & done!
        if lib.progressBar({
            label = label,
            duration = data.duration,
            position = data.position or 'bottom',
            useWhileDead = data.useWhileDead,
            allowSwimming = data.allowSwimming or false,
            canCancel = data.canCancel,
            disable = data.disable,
            anim = {
                dict = data.anim.dict or nil,
                clip = data.anim.clip or nil,
                flag = data.anim.flag or nil
            },
            prop = {
                model = data.prop.model or nil,
                bone = data.prop.bone or nil,
                pos = data.prop.pos or nil,
                rot = data.prop.rot or nil
            }
        }) then
            return true
        end
        return false
    elseif runtime.setup.progress == 'qbcore' then
        local p = promise.new()
        QBCore.Functions.Progressbar(label, label, data.duration, data.useWhileDead, data.canCancel, {
            disableMovement = data.disable.move,
            disableCarMovement = data.disable.car,
            disableMouse = false,
            disableCombat = data.disable.combat
        }, {
            animDict = data.anim.dict or nil,
            anim = data.anim.clip or nil,
            flags = data.anim.flag or nil
        }, {
            model = data.prop.model or nil,
            bone = data.prop.bone or nil,
            coords = data.prop.pos or nil,
            rotation = data.prop.rot or nil
        }, {},
        function()
            ClearPedTasks(cache.ped)
            p:resolve(true)
        end,
        function()
            ClearPedTasks(cache.ped)
            p:resolve(false)
        end)
        return Citizen.Await(p)
    else
        -- Add 'custom' progress bar here
    end
end

-- Register menu
--- @param data table
function RegisterMenu(data)
    if runtime.setup.menu == 'lation_ui' then
        exports.lation_ui:registerMenu(data)
    elseif runtime.setup.menu == 'ox_lib' then
        lib.registerContext(data)
    elseif runtime.setup.menu == 'custom' then
        -- Add 'custom' menu system here
    end
end

-- Show menu
--- @param menuId string
function ShowMenu(menuId)
    if runtime.setup.menu == 'lation_ui' then
        exports.lation_ui:showMenu(menuId)
    elseif runtime.setup.menu == 'ox_lib' then
        lib.showContext(menuId)
    elseif runtime.setup.menu == 'custom' then
        -- Add 'custom' menu system here
    end
end

-- Display an input dialog
--- @param data table
function ShowInput(data)
    if runtime.setup.dialogs == 'lation_ui' then
        return exports.lation_ui:input({ title = data.title, options = data.options })
    elseif runtime.setup.dialogs == 'ox_lib' then
        return lib.inputDialog(data.title, data.options)
    elseif runtime.setup.dialogs == 'custom' then
        -- Add your custom input dialog here
    end
end

RegisterNetEvent('lation_chopshop:notify', function(message, notifyType)
    if not message then return end
    ShowNotification(message, notifyType)
end)

-- A notification whose message embeds an inventory item. The server only knows
-- the item's spawn name, so it sends that plus the locale key and the label is
-- resolved here -- otherwise players are shown the raw spawn code.
RegisterNetEvent('lation_chopshop:notifyItem', function(key, notifyType, amount, item)
    if not key then return end
    ShowNotification(locale(key, amount, GetItemLabel(item)), notifyType)
end)
