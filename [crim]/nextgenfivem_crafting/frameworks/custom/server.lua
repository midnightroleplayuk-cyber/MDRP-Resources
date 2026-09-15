local function init()
    RegisterNetEvent('PLAYER_LOGOUT_EVENT', function(src)
        TriggerEvent(ResourceName .. ':playerLeft', src)
    end)
end

local function getPlayerIdentifier(src)
    -- Return the player's identifier

    return nil
end

local function getPlayerAccess(src)
    local access = {}

    -- Add the player's job to their access and other access identifiers

    if FW.CanUseEditor(src) then
        table.insert(access, '*')
    end

    return {}
end

local function getAllPlayers()
    local sources = {}

    -- Add all player sources to the sources table

    return sources
end

local function getAccessIdentifiers()
    local accessIdentifiers = {
        { identifier = 'admin', label = 'Admin', ranks = {} }
    }

    -- Add all job access identifiers to the accessIdentifiers table

    return accessIdentifiers
end

local function canUseEditor(src)
    return (
        IsPlayerAceAllowed(src, 'command') or
        IsPlayerAceAllowed(src, 'crafting.editor') or
        IsPlayerAceAllowed(src, 'command.craftingeditor')
    )
end

return {
    init = init,
    getPlayerIdentifier = getPlayerIdentifier,
    getPlayerAccess = getPlayerAccess,
    getAllPlayers = getAllPlayers,
    getAccessIdentifiers = getAccessIdentifiers,
    canUseEditor = canUseEditor
}
