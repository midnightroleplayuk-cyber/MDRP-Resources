-- Guard: when qbx_core is running, the dedicated QBox bridge
-- takes over (qbx_core ships a qb-core shim that would otherwise
-- match this check and load both bridges in parallel).
if GetResourceState('qb-core') ~= 'started' then return end
if GetResourceState('qbx_core') == 'started' then return end
QBCore = exports['qb-core']:GetCoreObject()
Framework = 'qb'

-- GetCoreObject hands back a COPY (exports are serialised across resource
-- boundaries), so everything we read off QBCore.Shared — Jobs, Items — is a
-- snapshot from the moment this line ran. qb-core fires this event whenever
-- a job, gang or item is added at runtime; re-fetch so a job created in the
-- panel is still there the next time the panel asks for the list.
RegisterNetEvent('QBCore:Server:UpdateObject', function()
    if source ~= '' then return end   -- server-side event only
    QBCore = exports['qb-core']:GetCoreObject()
end)

GetPlayer = function(source)
    return QBCore.Functions.GetPlayer(source)
end

GetPlayerFromIdentifier = function(identifier)
    local player = QBCore.Functions.GetPlayerByCitizenId(identifier)
    if not player then return false end
    return player
end

GetPlayers = function()
    return QBCore.Functions.GetPlayers()
end

RegisterCallback = function(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

KickPlayer = function(source, reason)
    QBCore.Functions.Kick(source, reason, true, true)
end

HasPermission = function(source, group)
    local player = GetPlayer(source)
    if QBCore.Functions.HasPermission(source, group) then
        return true
    else
        return false
    end
end

HasGroup = function(source, filter)
    local groups = { 'job', 'gang' }
    local player = GetPlayer(source)
    -- Not logged in yet → no groups. Without this the job-announcement
    -- loop in server/events.lua errors on anyone at character select.
    if not player or not player.PlayerData then return nil end
    local type = type(filter)

    -- `data.grade` is also optional on a freshly-created character, so
    -- every read below is defensive rather than assuming the shape.
    local function gradeLevel(data)
        return (data and data.grade and data.grade.level) or 0
    end

    if type == 'string' then
        for i = 1, #groups do
            local data = player.PlayerData[groups[i]]
            if data and data.name == filter then
                return data.name, gradeLevel(data)
            end
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            for i = 1, #groups do
                local data = player.PlayerData[groups[i]]
                if data and data.name then
                    local grade = filter[data.name]
                    if grade and grade <= gradeLevel(data) then
                        return data.name, gradeLevel(data)
                    end
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local group = filter[i]

                for j = 1, #groups do
                    local data = player.PlayerData[groups[j]]
                    if data and data.name == group then
                        return data.name, gradeLevel(data)
                    end
                end
            end
        end
    end
end

-- QBCore's own SetJob returns false when the job isn't in QBShared.Jobs (or
-- the grade doesn't exist on it) and otherwise changes nothing. Throwing
-- that answer away meant the panel reported success on a job change that
-- never happened — the QBCore version of the ESX
-- "Ignoring invalid .setJob() usage" warning, just without the warning.
SetJob = function(source, job, grade)
    local player = GetPlayer(source)
    if not player or not player.Functions then return false, 'Player not loaded' end

    grade = tonumber(grade) or 0

    local shared = QBCore and QBCore.Shared and QBCore.Shared.Jobs
    local def    = shared and shared[job]
    if shared and not def then
        return false, ('QBCore has no job named "%s".'):format(tostring(job))
    end
    if def and def.grades and def.grades[tostring(grade)] == nil and def.grades[grade] == nil then
        local have = {}
        for g in pairs(def.grades) do have[#have + 1] = tostring(g) end
        table.sort(have)
        return false, ('Job "%s" has no grade %d. Available: %s'):format(
            tostring(job), grade, #have > 0 and table.concat(have, ', ') or '(none)')
    end

    local ok = player.Functions.SetJob(job, grade)
    if ok == false then
        return false, ('QBCore refused the job change to "%s" (grade %d).'):format(tostring(job), grade)
    end
    return true
end

-- NOTE on the nil guards below: QBCore.Functions.GetPlayer returns nil
-- for a source that is connected but not yet logged in (sitting on the
-- multicharacter screen). server/callbacks.lua walks GetPlayers() and
-- calls GetIdentifier on every one of them, so a single player at
-- character select used to throw and take the WHOLE player-list
-- callback with it — the panel showed an empty server. The ESX and QBox
-- bridges already guarded this; QBCore was the odd one out.
GetIdentifier = function(source)
    local player = QBCore.Functions.GetPlayer(source)
    if not player or not player.PlayerData then return nil end
    return player.PlayerData.citizenid
end

GetName = function(source)
    local player = QBCore.Functions.GetPlayer(source)
    local ci = player and player.PlayerData and player.PlayerData.charinfo
    if not ci then return GetPlayerName(source) or ('ID ' .. tostring(source)) end
    return ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
end

HasItem = function(source, item)
    -- When ox_inventory is running it owns the inventory outright, so the
    -- count has to come from ox — reading player.Functions.GetItemByName
    -- (what this used to do in BOTH branches) returns stale or nil data on
    -- a QBCore server using ox. The QBox bridge already did this correctly.
    if GetResourceState('ox_inventory') == 'started' then
        local ok, count = pcall(function()
            return exports.ox_inventory:GetItemCount(source, item)
        end)
        return (ok and tonumber(count)) or 0
    end

    local player = GetPlayer(source)
    if not player or not player.Functions then return 0 end
    local found = player.Functions.GetItemByName(item)
    return (found and (found.amount or found.count)) or 0
end

AddItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    TriggerClientEvent('inventory:client:ItemBox', source,  item, 'add')
    return player.Functions.AddItem(item, count, slot, metadata)
end

AddWeapon = function(source, weapon, ammo)
    local player = GetPlayer(source)
    return player.Functions.AddItem(weapon, 1, nil, nil)
end

RemoveItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    player.Functions.RemoveItem(item, count, slot, metadata)
end

AddMoney = function(source, type, amount)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    player.Functions.AddMoney(type, amount)
end

RemoveMoney = function(source, type, amount)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    player.Functions.RemoveMoney(type, amount)
end

GetPlayerAccountFunds = function(source, type)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    return player.PlayerData.money[type]
end
