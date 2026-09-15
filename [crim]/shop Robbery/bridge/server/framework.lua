Bridge = Bridge or {}
Bridge.Framework = Bridge.Framework or {}

local detectedFramework

local function resourceStarted(name)
    return GetResourceState(name) == 'started'
end

local function detectFramework()
    if detectedFramework then return detectedFramework end

    if Config.Framework ~= 'auto' then
        detectedFramework = Config.Framework
        return detectedFramework
    end

    if resourceStarted('qbx_core') then
        detectedFramework = 'qbox'
    elseif resourceStarted('qb-core') then
        detectedFramework = 'qb'
    elseif resourceStarted('es_extended') then
        detectedFramework = 'esx'
    else
        detectedFramework = 'standalone'
    end

    return detectedFramework
end

function Bridge.ResourceStarted(name)
    return resourceStarted(name)
end

function Bridge.ShouldLoadFramework(name)
    return detectFramework() == name
end

function Bridge.SetFramework(name, framework)
    Bridge.Framework = framework or {}
    Bridge.Framework.name = name

    Utils.Debug('Loaded %s framework bridge', name)
end

function Bridge.GetFramework()
    return Bridge.Framework.name or detectFramework()
end

function Bridge.GetPlayer(src)
    if Bridge.Framework.getPlayer then
        return Bridge.Framework.getPlayer(src)
    end

    return { source = src }
end

function Bridge.GetIdentifier(src)
    if Bridge.Framework.getIdentifier then
        return Bridge.Framework.getIdentifier(src)
    end

    return GetPlayerIdentifierByType(src, 'license') or ('source:%s'):format(src)
end

function Bridge.GetJob(src)
    if Bridge.Framework.getJob then
        return Bridge.Framework.getJob(src)
    end

    return nil, false
end

function Bridge.GetPoliceCount()
    local count = 0
    local players = GetPlayers()

    for i = 1, #players do
        local src = tonumber(players[i])
        local job, onDuty = Bridge.GetJob(src)

        if job and onDuty and lib.table.contains(Config.PoliceJobs, job) then
            count = count + 1
        end
    end

    return count
end

function Bridge.IsAdmin(src)
    if src == 0 then return true end

    if Bridge.Framework.isAdmin then
        local allowed = Bridge.Framework.isAdmin(src)
        if allowed ~= nil then return allowed end
    end

    return IsPlayerAceAllowed(src, 'fa_shoprobbery.admin')
end
