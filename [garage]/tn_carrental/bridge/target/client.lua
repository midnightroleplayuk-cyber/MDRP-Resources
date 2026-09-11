Bridge = Bridge or {}
Bridge.Target = Bridge.Target or {}

local registeredTargets = {}

local function getTarget()
    if Config.Target ~= 'auto' then return Config.Target end
    if GetResourceState('ox_target') == 'started' then return 'ox_target' end
    if GetResourceState('qb-target') == 'started' then return 'qb-target' end
    if GetResourceState('qtarget') == 'started' then return 'qtarget' end
    return 'none'
end

function Bridge.Target.HasTarget()
    local target = getTarget()

    if target == 'ox_target' then
        return GetResourceState('ox_target') == 'started'
    end

    if target == 'qb-target' then
        return GetResourceState('qb-target') == 'started'
    end

    if target == 'qtarget' then
        return GetResourceState('qtarget') == 'started'
    end

    return false
end

function Bridge.Target.AddRentalPed(ped, station)
    if not Bridge.Target.HasTarget() then return false end
    local target = getTarget()

    local targetId = 'tn_carrental_' .. station.id
    registeredTargets[#registeredTargets + 1] = { ped = ped, id = targetId }

    if target == 'ox_target' then
        exports.ox_target:addLocalEntity(ped, {
            {
                name = targetId,
                label = Locale.openRental,
                icon = 'fa-solid fa-car',
                onSelect = function()
                    OpenRentalUi(station.id)
                end
            }
        })
        return true
    end

    if target == 'qb-target' then
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    type = 'client',
                    icon = 'fas fa-car',
                    label = Locale.openRental,
                    action = function()
                        OpenRentalUi(station.id)
                    end
                }
            },
            distance = 2.0
        })
        return true
    end

    if target == 'qtarget' then
        exports.qtarget:AddTargetEntity(ped, {
            options = {
                {
                    icon = 'fas fa-car',
                    label = Locale.openRental,
                    action = function()
                        OpenRentalUi(station.id)
                    end
                }
            },
            distance = 2.0
        })
        return true
    end

    return false
end

function Bridge.Target.RemoveAll()
    local targetSystem = getTarget()

    for _, target in ipairs(registeredTargets) do
        if targetSystem == 'ox_target' and GetResourceState('ox_target') == 'started' then
            exports.ox_target:removeLocalEntity(target.ped, target.id)
        elseif targetSystem == 'qb-target' and GetResourceState('qb-target') == 'started' then
            exports['qb-target']:RemoveTargetEntity(target.ped)
        elseif targetSystem == 'qtarget' and GetResourceState('qtarget') == 'started' then
            exports.qtarget:RemoveTargetEntity(target.ped)
        end
    end

    registeredTargets = {}
end
