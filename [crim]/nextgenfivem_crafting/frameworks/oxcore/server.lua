local function init()
    if GetResourceState('ox_core') ~= 'started' then
        Log.error('ox_core must be started before this resource.', 0)
    end

    local chunk = LoadResourceFile('ox_core', 'lib/init.lua')

    if not chunk then
        Log.error('failed to load resource file @ox_core/lib/init.lua', 0)
    end

    load(chunk, '@@ox_core/lib/init.lua', 't')()

    RegisterNetEvent('ox:playerLogout', function(src)
        TriggerEvent(ResourceName .. ':playerLeft', src)
    end)
end

local function getPlayerIdentifier(src)
    local player = Ox.GetPlayer(src)

    if player and player.charId then
        return player.charId
    end

    return nil
end

local function getPlayerAccess(src)
    local player = Ox.GetPlayer(src)

    if not player then
        return {}
    end

    local access = {}

    local playerGroups = player.getGroups()

    for group in pairs(playerGroups) do
        table.insert(access, 'group-' .. group)
    end

    if FW.CanUseEditor(src) then
        table.insert(access, '*')
    end

    return access
end

local function getAllPlayers()
    local sources = {}
    local players = Ox.GetPlayers() or {}

    for _, player in ipairs(players) do
        table.insert(sources, player.userId)
    end

    return sources
end

local function getAccessIdentifiers()
    local accessIdentifiers = {
        { identifier = 'admin', label = 'Admin' }
    }

    local groups = GlobalState.groups

    if groups then
        for k, v in pairs(groups) do
            table.insert(accessIdentifiers, {
                identifier = 'group-' .. k,
                label = v.label
            })
        end
    end

    return accessIdentifiers
end

local function canUseEditor(src)
    return (
        IsPlayerAceAllowed(src, 'command') or
        IsPlayerAceAllowed(src, 'crafting.editor') or
        IsPlayerAceAllowed(src, 'command.craftingeditor') or
        exports.qbx_core:HasPermission(src, 'admin')
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
