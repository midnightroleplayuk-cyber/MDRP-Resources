Utils = {}

function Utils.GetTarget()
    if Config.Target ~= 'auto' then
        return Config.Target
    end

    if GetResourceState('ox_target') == 'started' then
        return 'ox_target'
    end

    if GetResourceState('qb-target') == 'started' then
        return 'qb-target'
    end

    return nil
end

function Utils.GetInventory(frameworkName)
    if Config.Inventory
        and Config.Inventory ~= ''
        and Config.Inventory ~= 'auto' then
        return Config.Inventory
    end

    if GetResourceState('ox_inventory') == 'started' then
        return 'ox_inventory'
    end

    if frameworkName == 'qbcore' then
        if GetResourceState('qb-inventory') == 'started' then
            return 'qb-inventory'
        end

        if GetResourceState('lj-inventory') == 'started' then
            return 'lj-inventory'
        end

        if GetResourceState('ps-inventory') == 'started' then
            return 'ps-inventory'
        end

        if GetResourceState('qs-inventory') == 'started' then
            return 'qs-inventory'
        end

        if GetResourceState('codem-inventory') == 'started' then
            return 'codem-inventory'
        end
    elseif frameworkName == 'esx' and GetResourceState('qs-inventory') == 'started' then
        return 'qs-inventory'
    end

    return 'framework'
end

function Utils.ShouldUseTargetItemCheck(targetResource, frameworkName)
    local mode = Config.TargetItemCheck
    if mode == true or mode == false then
        return mode
    end

    local inventoryName = Utils.GetInventory(frameworkName)
    if targetResource == 'ox_target' then
        return inventoryName == 'ox_inventory'
    end

    if targetResource == 'qb-target' then
        return (inventoryName == 'framework' and frameworkName == 'qbcore')
            or inventoryName == 'qb-inventory'
            or inventoryName == 'lj-inventory'
            or inventoryName == 'ps-inventory'
    end

    return false
end

function Utils.Notify(message, notifyType)
    notifyType = notifyType or 'inform'

    if Config.Notify == 'ox' then
        lib.notify({
            title = Locale('resource_name'),
            description = message,
            type = notifyType
        })
    elseif Config.Notify == 'esx' then
        TriggerEvent('esx:showNotification', message)
    elseif Config.Notify == 'qb' then
        local qb = exports['qb-core']:GetCoreObject()
        qb.Functions.Notify(message, notifyType, 5000)
    elseif Config.Notify == 'okok' then
        exports['okokNotify']:Alert(Locale('resource_name'), message, 5000, notifyType)
    elseif Config.Notify == 'wasabi' then
        exports.wasabi_notify:notify(Locale('resource_name'), message, 5000, notifyType)
    elseif Config.Notify == 'brutal_notify' then
        exports['brutal_notify']:SendAlert(Locale('resource_name'), message, 5000, notifyType, false)
    end
end

function Utils.AddTargetModel(targetResource, model, options, distance)
    if targetResource == 'ox_target' then
        exports.ox_target:addModel(model, options)
        return
    end

    if targetResource == 'qb-target' then
        exports['qb-target']:AddTargetModel(model, {
            options = options,
            distance = distance or 2.0
        })
    end
end

function Utils.RemoveTargetModel(targetResource, model, optionData)
    if targetResource == 'ox_target' then
        local optionNames = optionData and optionData.name
        exports.ox_target:removeModel(model, optionNames)
        return
    end

    if targetResource == 'qb-target' then
        local labels = optionData and optionData.label
        exports['qb-target']:RemoveTargetModel(model, labels)
    end
end

function Utils.AddTargetEntity(targetResource, entity, options, distance)
    if targetResource == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, options)
        return
    end

    if targetResource == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = options,
            distance = distance or 2.0
        })
    end
end

function Utils.RemoveTargetEntity(targetResource, entity, optionData)
    if targetResource == 'ox_target' then
        local optionNames = optionData and optionData.name
        exports.ox_target:removeLocalEntity(entity, optionNames)
        return
    end

    if targetResource == 'qb-target' then
        local labels = optionData and optionData.label
        exports['qb-target']:RemoveTargetEntity(entity, labels)
    end
end
