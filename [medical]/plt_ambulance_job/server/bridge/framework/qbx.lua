if Bridge.Framework ~= 'qbx_core' and Bridge.Framework ~= 'qbx-core' then return end
if GetResourceState('qb-core') ~= 'started' then return end

local Core = exports['qb-core']:GetCoreObject()
Framework.Core = Core
Framework.Resource = Bridge.Framework
Framework.PlayerLoadedEvent = 'QBCore:Server:OnPlayerLoaded'
Framework.JobUpdateEvent = 'QBCore:Server:OnJobUpdate'
Framework.PlayerDataEvent = 'QBCore:Server:OnPlayerUpdated'

local function GetRawPlayer(src)
    return Core.Functions.GetPlayer(src)
end

function Framework.GetPlayers()
    return Core.Functions.GetPlayers()
end

function Framework.GetPlayer(src)
    local player = GetRawPlayer(src)
    if not player then return nil end
    local data = player.PlayerData
    local charinfo = data.charinfo or {}
    local grade = data.job.grade or {}
    return {
        source = src,
        PlayerData = data,
        citizenid = data.citizenid,
        identifier = data.citizenid,
        name = ((charinfo.firstname or '') .. ' ' .. (charinfo.lastname or '')):gsub('^%s*(.-)%s*$', '%1'),
        charinfo = charinfo,
        job = {
            name = data.job.name,
            label = data.job.label,
            grade = type(grade) == 'table' and grade.level or grade,
            gradeLabel = type(grade) == 'table' and grade.name or nil,
            onduty = data.job.onduty
        },
        functions = {
            AddMoney = function(account, amount, reason) return player.Functions.AddMoney(account, amount, reason) end,
            RemoveMoney = function(account, amount, reason) return player.Functions.RemoveMoney(account, amount, reason) end,
            GetMoney = function(account) return player.Functions.GetMoney(account) end,
            AddItem = function(item, amount, slot, info) return player.Functions.AddItem(item, amount, slot, info) end,
            RemoveItem = function(item, amount, slot) return player.Functions.RemoveItem(item, amount, slot) end,
            SetJobDuty = function(duty) return player.Functions.SetJobDuty(duty) end
        }
    }
end

function Framework.GetPlayerByCitizenId(citizenId)
    local player = Core.Functions.GetPlayerByCitizenId(citizenId)
    return player and Framework.GetPlayer(player.PlayerData.source) or nil
end

function Framework.CreateCallback(name, cb)
    Core.Functions.CreateCallback(name, cb)
end

function Framework.SetMetaData(src, key, value)
    local player = GetRawPlayer(src)
    if player then player.Functions.SetMetaData(key, value) end
end

function Framework.GetMetaData(src, key)
    local player = GetRawPlayer(src)
    return player and (player.PlayerData.metadata or {})[key] or nil
end

function Framework.SetJob(src, job, grade)
    local player = GetRawPlayer(src)
    if player then player.Functions.SetJob(job, tonumber(grade) or 0) end
end

function Framework.GetMedicalState(src)
    local player = GetRawPlayer(src)
    if not player then return nil, 0 end
    local metadata = player.PlayerData.metadata or {}
    local state = Framework.MedicalState.ALIVE
    if metadata.isdead == true then
        state = Framework.MedicalState.DEAD
    elseif metadata.inlaststand == true then
        state = Framework.MedicalState.LASTSTAND
    end
    return state, tonumber(metadata.plt_medical_started_at) or 0
end

function Framework.SetMedicalState(src, state, startedAt)
    local player = GetRawPlayer(src)
    if not player then return nil, 0 end

    state = Framework.NormalizeMedicalState(state)
    local currentState, currentStartedAt = Framework.GetMedicalState(src)
    local requestedStartedAt = tonumber(startedAt)
    if state == Framework.MedicalState.ALIVE then
        startedAt = 0
    elseif requestedStartedAt and requestedStartedAt > 0 then
        startedAt = math.floor(requestedStartedAt)
    elseif currentState ~= Framework.MedicalState.ALIVE and currentStartedAt > 0 then
        startedAt = currentStartedAt
    else
        startedAt = os.time()
    end

    local metadata = player.PlayerData.metadata or {}
    local isDead = state == Framework.MedicalState.DEAD
    local inLaststand = state == Framework.MedicalState.LASTSTAND
    local function SetValue(key, value)
        if metadata[key] ~= value then
            metadata[key] = value
            player.Functions.SetMetaData(key, value)
        end
    end

    if state ~= Framework.MedicalState.ALIVE then SetValue('plt_medical_started_at', startedAt) end
    if state == Framework.MedicalState.DEAD then
        SetValue('isdead', true)
        SetValue('inlaststand', false)
    else
        SetValue('isdead', false)
        SetValue('inlaststand', inLaststand)
    end
    if state == Framework.MedicalState.ALIVE then SetValue('plt_medical_started_at', 0) end

    local playerState = Player(src) and Player(src).state
    if playerState then
        playerState:set('medicalState', state, true)
        playerState:set('medicalStateStartedAt', startedAt, true)
        playerState:set('isDead', isDead, true)
        playerState:set('isdead', isDead, true)
        playerState:set('inlaststand', inLaststand, true)
    end
    return state, startedAt
end

function Framework.HasPermission(src, permission)
    if Core.Functions.HasPermission then
        local ok, allowed = pcall(Core.Functions.HasPermission, src, permission)
        if ok and allowed then return true end
    end
    if Core.Functions.GetPermission then
        local ok, permissions = pcall(Core.Functions.GetPermission, src)
        if ok and type(permissions) == 'string' then
            local value = permissions:lower()
            if value == tostring(permission):lower() or value == 'admin' or value == 'god' then return true end
        elseif ok and type(permissions) == 'table' then
            local wanted = tostring(permission):lower()
            if permissions[wanted] == true or permissions.admin == true or permissions.god == true then return true end
            for _, entry in pairs(permissions) do
                if type(entry) == 'string' then
                    local value = entry:lower()
                    if value == wanted or value == 'admin' or value == 'god' then return true end
                end
            end
        end
    end
    return IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'command')
        or IsPlayerAceAllowed(src, 'group.admin') or IsPlayerAceAllowed(src, 'group.god')
end

function Framework.ResetNeeds(src)
    local player = GetRawPlayer(src)
    if not player then return end

    player.Functions.SetMetaData('hunger', 100)
    player.Functions.SetMetaData('thirst', 100)
    player.Functions.SetMetaData('stress', 0)
    local playerState = Player(src) and Player(src).state
    if playerState then
        playerState:set('hunger', 100, true)
        playerState:set('thirst', 100, true)
        playerState:set('stress', 0, true)
    end
    TriggerClientEvent('hud:client:UpdateNeeds', src, 100, 100)
    TriggerClientEvent('hud:client:UpdateStress', src, 0)
    if type(player.Functions.UpdatePlayerData) == 'function' then player.Functions.UpdatePlayerData() end
end

function Framework.SetDeathStatus(src, status)
    Framework.SetMedicalState(src, status and Framework.MedicalState.DEAD or Framework.MedicalState.ALIVE)
    if not status then Framework.ResetNeeds(src) end
end

function Framework.SetLaststandStatus(src, status)
    if status then
        Framework.SetMedicalState(src, Framework.MedicalState.LASTSTAND)
    elseif Framework.GetMedicalState(src) == Framework.MedicalState.LASTSTAND then
        Framework.SetMedicalState(src, Framework.MedicalState.ALIVE)
    end
end

function Framework.CreateUseableItem(name, cb)
    Core.Functions.CreateUseableItem(name, cb)
end

function Framework.RemoveMoney(src, account, amount, reason)
    if amount <= 0 then return true end
    local player = GetRawPlayer(src)
    return player and player.Functions.RemoveMoney(account, amount, reason) or false
end

function Framework.AddMoney(src, account, amount, reason)
    local player = GetRawPlayer(src)
    return player and player.Functions.AddMoney(account, amount, reason) or false
end

function Framework.GetPlayerMoney(src, account)
    local player = GetRawPlayer(src)
    return player and player.Functions.GetMoney(account) or 0
end

function Framework.GetPlayerIdentifier(src)
    local player = GetRawPlayer(src)
    return player and player.PlayerData.citizenid or nil
end
