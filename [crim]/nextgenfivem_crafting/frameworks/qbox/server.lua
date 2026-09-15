local function init()
    RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(src)
        TriggerEvent(ResourceName .. ':playerLeft', src)
    end)

    RegisterNetEvent('QBCore:Server:PlayerDropped', function(player)
        TriggerEvent(ResourceName .. ':playerLeft', player.PlayerData.source)
    end)
end

local function getPlayerIdentifier(src)
    local player = exports.qbx_core:GetPlayer(src)
    if player and player.PlayerData then
        return player.PlayerData.citizenid
    end
    return nil
end

local function getPlayerAccess(src)
    local player = exports.qbx_core:GetPlayer(src)

    if not player then
        return {}
    end

    local access = {}

    if player.PlayerData and player.PlayerData.job and player.PlayerData.job.name then
        table.insert(access, {
            identifier = 'job-' .. player.PlayerData.job.name,
            rank = tostring(player.PlayerData.job.grade.level)
        })
    end

    if player.PlayerData and player.PlayerData.gang and player.PlayerData.gang.name then
        table.insert(access, {
            identifier = 'gang-' .. player.PlayerData.gang.name,
            rank = tostring(player.PlayerData.gang.grade.level)
        })
    end

    if FW.CanUseEditor(src) then
        table.insert(access, '*')
    end

    return access
end

local function getAllPlayers()
    local sources = {}
    local players = exports.qbx_core:GetQBPlayers() or {}

    for src, _ in pairs(players) do
        table.insert(sources, src)
    end

    return sources
end

local function getAccessIdentifiers()
    local accessIdentifiers = {
        { identifier = 'admin', label = 'Admin' }
    }

    local jobs = exports.qbx_core:GetJobs()
    if jobs then
        for k, v in pairs(jobs) do
            local accessIdentifier = {
                identifier = 'job-' .. k,
                label = v.label
            }

            if v.grades then
                accessIdentifier.ranks = {}

                for gradeId, grade in pairs(v.grades) do
                    if gradeId and grade then
                        table.insert(accessIdentifier.ranks, {
                            identifier = tostring(gradeId),
                            label = grade.name or tostring(gradeId)
                        })
                    end
                end
            end

            table.insert(accessIdentifiers, accessIdentifier)
        end
    end

    local gangs = exports.qbx_core:GetGangs()
    if gangs then
        for k, v in pairs(gangs) do
            local accessIdentifier = {
                identifier = 'gang-' .. k,
                label = v.label
            }

            if v.grades then
                accessIdentifier.ranks = {}

                for gradeId, grade in pairs(v.grades) do
                    if gradeId and grade then
                        table.insert(accessIdentifier.ranks, {
                            identifier = tostring(gradeId),
                            label = grade.name or tostring(gradeId)
                        })
                    end
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
