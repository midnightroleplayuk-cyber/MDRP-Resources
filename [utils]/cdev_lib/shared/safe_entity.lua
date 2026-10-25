--- Safe wrappers for entity natives (avoids GET_ENTITY_MODEL / coords crashes during target raycasts).
SafeEntity = {}

function SafeEntity.isValid(entity)
    return entity and entity ~= 0 and DoesEntityExist(entity)
end

function SafeEntity.getModel(entity)
    if not SafeEntity.isValid(entity) then
        return nil
    end

    local ok, model = pcall(GetEntityModel, entity)
    return ok and model or nil
end

function SafeEntity.getCoords(entity)
    if not SafeEntity.isValid(entity) then
        return nil
    end

    local ok, coords = pcall(GetEntityCoords, entity)
    return ok and coords or nil
end

--- Runs a canInteract callback safely; returns false if the entity is invalid or the callback errors.
function SafeEntity.runCanInteract(callback, entity, ...)
    if not SafeEntity.isValid(entity) then
        return false
    end

    if not callback then
        return true
    end

    local ok, result = pcall(callback, entity, ...)
    return ok and result == true
end

--- Wraps a canInteract callback for qb-target / qtarget (entity-only signature).
function SafeEntity.wrapCanInteract(callback)
    if not callback then
        return nil
    end

    return function(entity, ...)
        return SafeEntity.runCanInteract(callback, entity, ...)
    end
end
