--- User-editable server hooks.
--- Override any function below to customize permissions, job flow, sessions, and events.

Hooks = Hooks or {}

--- Return true if the player can participate in chopping activities.
--- @param source number
--- @param notify boolean
--- @return boolean
function Hooks.CanDoChopping(source, notify)
    if IsBlacklistedJob(source) then
        if notify then
            TriggerClientEvent('lation_chopshop:notify', source, locale('notify.blacklisted-job'), 'error')
        end
        return false
    end

    return true
end

--- Return true if the player can request a chop job.
--- @param source number
--- @return boolean
function Hooks.CanRequestJob(source)
    if not source then return false end
    return Hooks.CanDoChopping(source, true)
end

--- Return true if the player can interact with an active chop vehicle.
--- @param source number
--- @param netId number|nil
--- @return boolean
function Hooks.CanParticipate(source, netId)
    return Contracts.canParticipate(source, netId)
end

--- Return the player's active job contract.
--- @param source number
--- @return table|nil
function Hooks.GetContract(source)
    return Contracts.get(source)
end

--- Return true if the player started the chop on this vehicle.
--- @param source number
--- @param netId number
--- @return boolean
function Hooks.IsInitiator(source, netId)
    return Contracts.isInitiator(source, netId)
end

--- Called when a vehicle part is removed during chopping.
--- @param source number
--- @param entity number
--- @param model string
--- @param typeId string  part nativeType: 'wheel', 'door' or 'mock'
--- @param boneId string
function Hooks.VehiclePartRemoved(source, entity, model, typeId, boneId)
    -- print(('Vehicle model & part removed: %s, %s'):format(model, typeId))
end
