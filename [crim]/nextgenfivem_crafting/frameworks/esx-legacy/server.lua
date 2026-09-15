local ESX

local function init()
    ESX = exports['es_extended']:getSharedObject()

    RegisterNetEvent('esx:onPlayerLogout', function(src)
        TriggerEvent(ResourceName .. ':playerLeft', src)
    end)
end

local function getPlayerIdentifier(src)
    local player = ESX.GetPlayerFromId(src)

    if not player then
        return nil
    end

    return player.identifier
end

local function getPlayerAccess(src)
    local player = ESX.GetPlayerFromId(src)

    if not player then
        return {}
    end

    local access = {}

    local job = player.getJob()

    if job then
        table.insert(access, {
            identifier = 'job-' .. job.name,
            rank = job.grade_name
        })
    end

    if FW.CanUseEditor(src) then
        table.insert(access, '*')
    end

    return access
end

local function getAllPlayers()
    local sources = {}

    for _, player in pairs(ESX.GetExtendedPlayers()) do
        table.insert(sources, player.source)
    end

    return sources
end

local function getAccessIdentifiers()
    local accessIdentifiers = {
        { identifier = 'admin', label = 'Admin' }
    }

    local jobs = ESX?.GetJobs()

    if jobs then
        for _, v in pairs(jobs) do
            local accessIdentifier = {
                identifier = 'job-' .. v.name,
                label = v.label
            }

            if v.grades then
                accessIdentifier.ranks = {}

                for _, grade in pairs(v.grades) do
                    table.insert(accessIdentifier.ranks, {
                        identifier = grade.name,
                        label = grade.label
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
        IsPlayerAceAllowed(src, 'crafting.editor') or
        IsPlayerAceAllowed(src, 'command.craftingeditor') or
        ESX.GetPlayerFromId(src)?.admin
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
