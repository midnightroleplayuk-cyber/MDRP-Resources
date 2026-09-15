local QBCore

local function init()
    QBCore = exports['qb-core']:GetCoreObject()

    RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(src)
        TriggerEvent(ResourceName .. ':playerLeft', src)
    end)
 
    RegisterNetEvent('QBCore:Server:PlayerDropped', function(player)
        TriggerEvent(ResourceName .. ':playerLeft', player.PlayerData.source)
    end)
end

local function getPlayerIdentifier(src)
    local Player = QBCore?.Functions.GetPlayer(src)

    return Player?.PlayerData?.citizenid
end

local function getPlayerAccess(src)
    local player = QBCore?.Functions.GetPlayer(src)

    if not player then
        return {}
    end

    local access = {}

    if player.PlayerData?.job?.name then
        table.insert(access, {
            identifier = 'job-' .. player.PlayerData.job.name,
            rank = tostring(player.PlayerData.job.grade.level)
        })
    end

    if player.PlayerData?.gang?.name then
        table.insert(access, {
            identifier = 'gang-' .. player.PlayerData.gang.name,
            rank = tostring(player.PlayerData.gang.grade.level)
        })
    end

    if FW.CanUseEditor(src) then
        table.insert(access, {
            identifier = '*'
        })
    end

    return access
end

local function getAllPlayers()
    local sources = {}

    for src,_ in pairs(QBCore?.Functions.GetQBPlayers()) do
        table.insert(sources, src)
    end

    return sources
end

local function getAccessIdentifiers()
    local accessIdentifiers = {
        { identifier = 'admin', label = 'Admin' }
    }

    if QBCore?.Shared?.Jobs then
        for k, v in pairs(QBCore.Shared.Jobs) do
            local accessIdentifier = {
                identifier = 'job-' .. k,
                label = v.label,
            }

            if v.grades then
                accessIdentifier.ranks = {}

                for gradeId, grade in pairs(v.grades) do
                    table.insert(accessIdentifier.ranks, {
                        identifier = gradeId,
                        label = grade.name
                    })
                end
            end

            table.insert(accessIdentifiers, accessIdentifier)
        end
    end

    if QBCore?.Shared?.Gangs then
        for k, v in pairs(QBCore.Shared.Gangs) do
            local accessIdentifier = {
                identifier = 'gang-' .. k,
                label = v.label,
            }

            if v.grades then
                accessIdentifier.ranks = {}

                for gradeId, grade in pairs(v.grades) do
                    table.insert(accessIdentifier.ranks, {
                        identifier = gradeId,
                        label = grade.name
                    })
                end
            end

            table.insert(accessIdentifiers, accessIdentifier)
        end
    end

    return accessIdentifiers
end

local function canUseEditor(src)
    return (
        IsPlayerAceAllowed(src, 'command') or
        IsPlayerAceAllowed(src, 'crafting.editor') == 1 or
        IsPlayerAceAllowed(src, 'command.craftingeditor') == 1 or
        QBCore?.Functions.HasPermission(src, 'admin')
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
