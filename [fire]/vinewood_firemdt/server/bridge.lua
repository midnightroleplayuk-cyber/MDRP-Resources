-- Framework bridge: Qbox / QBCore / ESX
Bridge = {}

local fw = Config.Framework
if fw == 'auto' then
    if GetResourceState('qbx_core') == 'started' then fw = 'qbx'
    elseif GetResourceState('qb-core') == 'started' then fw = 'qb'
    elseif GetResourceState('es_extended') == 'started' then fw = 'esx'
    else fw = 'standalone' end
end
Bridge.framework = fw

local QB, ESX
if fw == 'qb' then QB = exports['qb-core']:GetCoreObject() end
if fw == 'esx' then ESX = exports.es_extended:getSharedObject() end

---@return table|nil { name, grade, onduty, fullname, identifier }
function Bridge.GetPlayer(src)
    if fw == 'qbx' then
        local p = exports.qbx_core:GetPlayer(src)
        if not p then return end
        local pd = p.PlayerData
        return {
            name = pd.job.name, grade = pd.job.grade.level or 0, onduty = pd.job.onduty,
            fullname = ('%s %s'):format(pd.charinfo.firstname, pd.charinfo.lastname),
            identifier = pd.citizenid,
        }
    elseif fw == 'qb' then
        local p = QB.Functions.GetPlayer(src)
        if not p then return end
        local pd = p.PlayerData
        return {
            name = pd.job.name, grade = pd.job.grade.level or 0, onduty = pd.job.onduty,
            fullname = ('%s %s'):format(pd.charinfo.firstname, pd.charinfo.lastname),
            identifier = pd.citizenid,
        }
    elseif fw == 'esx' then
        local p = ESX.GetPlayerFromId(src)
        if not p then return end
        return {
            name = p.job.name, grade = p.job.grade or 0, onduty = true,
            fullname = p.getName(), identifier = p.identifier,
        }
    end
    -- standalone: everyone is a firefighter grade 0 (for testing only)
    return { name = 'fire', grade = 0, onduty = true, fullname = GetPlayerName(src), identifier = tostring(src) }
end

print(('[vinewood_firemdt] framework: %s'):format(fw))
