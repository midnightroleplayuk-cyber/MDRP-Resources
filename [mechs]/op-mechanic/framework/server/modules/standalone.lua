if Config.Framework ~= 'standalone' then return end

function Fr.GetPlayer(src)
    return { source = src, identifier = ('license:%s'):format(src) }
end

function Fr.GetJob(src)
    return { name = 'mechanic', grade = 4, label = 'Mechanic' }
end

function Fr.HasJob(src, jobName, minGrade)
    local job = Fr.GetJob(src)
    if not job or job.name ~= jobName then
        return false
    end
    return (job.grade or 0) >= (minGrade or 0)
end

function Fr.GetMoney(_src, _account)
    return 999999
end

function Fr.RemoveMoney(_src, _account, _amount, _reason)
    return true
end

-- Society money: use integrations/server/banking/* (internal ledger when Banking = none).

function Fr.AddMoney(_src, _account, _amount, _reason)
    return true
end

function Fr.GetJobGrades(_jobName)
    return {
        { grade = 0, label = 'Recruit', name = 'recruit' },
        { grade = 1, label = 'Mechanic', name = 'mechanic' },
        { grade = 2, label = 'Senior', name = 'senior' },
        { grade = 3, label = 'Manager', name = 'manager' },
        { grade = 4, label = 'Boss', name = 'boss' },
    }
end

function Fr.GetEmployees(_jobName)
    local out = {}
    local players = GetPlayers()
    for i = 1, #players do
        local src = tonumber(players[i])
        if src then
            local profile = Fr.GetCharacterProfile(src)
            out[#out + 1] = {
                identifier = profile and profile.identifier or ('license:%s'):format(src),
                name = profile and profile.name or GetPlayerName(src),
                grade = 4,
                gradeLabel = 'Boss',
                online = true,
                onduty = Fr.IsOnDuty and Fr.IsOnDuty(src) or false,
                serverId = src,
            }
        end
    end
    return out
end

function Fr.GetPlayerByIdentifier(identifier)
    local players = GetPlayers()
    for i = 1, #players do
        local src = tonumber(players[i])
        if src and Fr.GetIdentifier(src) == identifier then
            return Fr.GetPlayer(src)
        end
    end
    return nil
end

function Fr.SetJob(_target, _jobName, _grade)
    return true
end

function Fr.Notify(src, message, nType, time)
    TriggerClientEvent(OPM.Net.ClientNotify or 'opm:client:notify', src, message, nType, time)
end

function Fr.GetIdentifier(src)
    return ('license:%s'):format(src)
end

---@param src number
---@return string|nil
function Fr.GetGroup(_src)
    return 'admin'
end

--- Character profile for online player (invoice target).
---@param src number
---@return table|nil
function Fr.GetCharacterProfile(src)
    if not src or GetPlayerName(src) == nil then
        return nil
    end
    local name = GetPlayerName(src) or ('Player %s'):format(src)
    return {
        identifier = Fr.GetIdentifier(src),
        name = name,
        firstname = name,
        lastname = '',
        serverId = src,
    }
end

--- Standalone: search currently online players by name.
---@param query string
---@param opts table|nil
---@return table[]
function Fr.SearchPlayers(query, opts)
    opts = opts or {}
    local q = tostring(query or ''):gsub('^%s+', ''):gsub('%s+$', '')
    if #q < 2 then
        return {}
    end

    local limit = math.min(tonumber(opts.limit) or 8, 20)
    local needle = string.lower(q)
    local out = {}
    local players = GetPlayers()
    for i = 1, #players do
        if #out >= limit then
            break
        end
        local src = tonumber(players[i])
        if src then
            local name = GetPlayerName(src) or ('Player %s'):format(src)
            local identifier = Fr.GetIdentifier(src)
            if string.find(string.lower(name), needle, 1, true)
                or string.find(string.lower(identifier), needle, 1, true)
            then
                out[#out + 1] = {
                    identifier = identifier,
                    name = name,
                    firstname = name,
                    lastname = '',
                }
            end
        end
    end
    return out
end

function Fr.HasItem(_src, _item, _count)
    return true
end

function Fr.RemoveItem(_src, _item, _count)
    return true
end

function Fr.AddItem(_src, _item, _count)
    return true
end

function Fr.SaveVehicleProps(_plate, _props)
    return true
end

if OPM and OPM.Utils and OPM.Utils.Debug then
    OPM.Utils.Debug('Using standalone server framework')
end