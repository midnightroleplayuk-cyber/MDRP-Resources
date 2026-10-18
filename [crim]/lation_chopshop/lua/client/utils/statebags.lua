-- Safe entity lookup for state bag change handlers.
--
-- GetEntityFromStateBagName faults inside the game process when the bag's
-- entity is already gone (deleted, streamed out, ownership mid-migration). It
-- surfaces as "native <hash>: exception at address ..." and kills the handler
-- that raised it, so the change it was carrying is silently dropped. Every one
-- of our handlers registers with a nil bag filter, so they also receive
-- `player:` and `global` bags the native was never meant to resolve here.
--
-- Parsing the net id out of the bag name ourselves avoids the native entirely
-- and rejects anything that is not a live, locally known entity.

local M = {}

--- Resolve an entity bag name to a local entity handle.
--- @param bagName string
--- @return number? entity nil for non-entity bags and entities we can't see
function M.getEntity(bagName)
    if type(bagName) ~= 'string' then return end

    local netId = tonumber(bagName:match('^entity:(%d+)$'))
    if not netId then return end

    if not NetworkDoesNetworkIdExist(netId) then return end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    return entity
end

return M
