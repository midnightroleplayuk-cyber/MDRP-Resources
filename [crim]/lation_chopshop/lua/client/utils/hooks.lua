--- User-editable client hooks.
--- Override any function below to customize chop eligibility and interactions.

Hooks = Hooks or {}

local runtime = require 'shared.runtime'

--- Return true if the player can start chopping this vehicle.
--- @param model string
--- @param entity number
--- @return boolean
function Hooks.CanStartChopping(model, entity)
    if not model or not entity then return false end

    if IsBlacklistedJob(true) then return false end

    if not runtime.start.allowOwned then
        local plate = GetVehicleNumberPlateText(entity)
        if not plate or plate == '' then return false end

        local isOwned = lib.callback.await('lation_chopshop:isOwnedVehicle', false, plate)

        if isOwned then
            ShowNotification(locale('notify.owned-vehicle'), 'error')
            return false
        end
    end

    return true
end

--- Return true if the player can interact with a chop target on this vehicle.
--- @param entity number
--- @param bone string
--- @param isBusy boolean
--- @return boolean
function Hooks.CanInteractWithVehiclePart(entity, bone, isBusy)
    if not entity or not bone then return false end
    if not DoesEntityExist(entity) then return false end

    if isBusy then return false end

    if IsBlacklistedJob(false) then return false end

    if IsPedArmed(cache.ped, 7) then
        return false
    end

    if IsPedDeadOrDying(cache.ped, true) then
        return false
    end

    return true
end

--- Called when chopping starts on a vehicle.
--- @param entity number
--- @param model string
function Hooks.StartedChopping(entity, model)
    -- print(('Chopping has started on entity/model: %s/%s'):format(entity, model))
end
