if Bridge.Framework ~= 'es_extended' then return end

local Core = exports['es_extended']:getSharedObject()
Framework.Core = Core
Framework.Resource = 'es_extended'
Framework.PlayerLoadedEvent = 'esx:playerLoaded'
Framework.JobUpdateEvent = 'esx:setJob'

local function GetRawPlayer(src)
    return Core.GetPlayerFromId(src)
end

local function GetAccount(player, account)
    if account == 'cash' or account == 'money' then
        return type(player.getMoney) == 'function' and player.getMoney() or 0
    end
    local data = player.getAccount(account)
    return data and data.money or 0
end

function Framework.GetPlayers()
    return Core.GetPlayers()
end

function Framework.GetPlayer(src)
    local player = GetRawPlayer(src)
    if not player then return nil end
    local firstName = player.get('firstName') or ''
    local lastName = player.get('lastName') or ''
    local jobName, onDuty = Framework.NormalizeEsxDutyJob(player.job.name)
    return {
        source = src,
        citizenid = player.identifier,
        identifier = player.identifier,
        name = firstName ~= '' and lastName ~= '' and (firstName .. ' ' .. lastName) or player.getName(),
        charinfo = { firstname = firstName, lastname = lastName },
        job = {
            name = jobName,
            rawName = player.job.name,
            label = player.job.label,
            grade = player.job.grade,
            gradeLabel = player.job.grade_label,
            onduty = onDuty
        },
        functions = {
            AddMoney = function(account, amount, reason)
                if account == 'cash' or account == 'money' then player.addMoney(amount, reason)
                else player.addAccountMoney(account, amount, reason) end
                return true
            end,
            RemoveMoney = function(account, amount, reason)
                local normalized = account == 'cash' and 'money' or account
                if GetAccount(player, normalized) < amount then return false end
                if normalized == 'money' then player.removeMoney(amount, reason)
                else player.removeAccountMoney(normalized, amount, reason) end
                return true
            end,
            GetMoney = function(account) return GetAccount(player, account) end,
            AddItem = function(item, amount) player.addInventoryItem(item, amount); return true end,
            RemoveItem = function(item, amount) player.removeInventoryItem(item, amount); return true end
        }
    }
end

function Framework.GetPlayerByCitizenId(identifier)
    local player = Core.GetPlayerFromIdentifier(identifier)
    return player and Framework.GetPlayer(player.source) or nil
end

function Framework.CreateCallback(name, cb)
    Core.RegisterServerCallback(name, cb)
end

function Framework.SetMetaData(src, key, value)
    local player = GetRawPlayer(src)
    if player then player.set(key, value) end
end

function Framework.GetMetaData(src, key)
    local player = GetRawPlayer(src)
    return player and player.get(key) or nil
end

function Framework.SetJob(src, job, grade)
    local player = GetRawPlayer(src)
    if player then player.setJob(job, tonumber(grade) or 0) end
end

local function GetMedicalMetadata(player)
    if type(player.getMeta) == 'function' then
        local ok, value = pcall(player.getMeta, 'plt_medical')
        if ok and type(value) == 'table' then return value end
    end
    if type(player.get) == 'function' then
        local value = player.get('plt_medical')
        if type(value) == 'table' then return value end
    end
end

local function SetMedicalMetadata(player, value)
    if type(player.setMeta) == 'function' then
        local ok = pcall(player.setMeta, 'plt_medical', value)
        if ok then return end
    end
    if type(player.set) == 'function' then
        player.set('plt_medical', value)
    end
end

function Framework.GetMedicalState(src)
    local player = GetRawPlayer(src)
    if not player then return nil, 0 end

    local metadata = GetMedicalMetadata(player)
    if metadata then
        return Framework.NormalizeMedicalState(metadata.state), tonumber(metadata.startedAt) or 0
    end

    local isDead = player.get('is_dead') == true or player.get('isDead') == true or player.get('dead') == true
    local inLaststand = player.get('inlaststand') == true
    if isDead then return Framework.MedicalState.DEAD, 0 end
    if inLaststand then return Framework.MedicalState.LASTSTAND, 0 end
    return Framework.MedicalState.ALIVE, 0
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

    SetMedicalMetadata(player, { state = state, startedAt = startedAt })

    local isDead = state == Framework.MedicalState.DEAD
    local inLaststand = state == Framework.MedicalState.LASTSTAND
    player.set('dead', isDead)
    player.set('is_dead', isDead)
    player.set('inlaststand', inLaststand)

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
    local player = GetRawPlayer(src)
    if not player then return false end
    local group = type(player.getGroup) == 'function' and player.getGroup() or 'user'
    if group == permission or group == 'admin' or group == 'superadmin' or group == 'owner' then return true end
    return IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'command')
end

function Framework.ResetNeeds(src)
    if not GetRawPlayer(src) then return end
    TriggerClientEvent('esx_status:set', src, 'hunger', 1000000)
    TriggerClientEvent('esx_status:set', src, 'thirst', 1000000)
    TriggerClientEvent('esx_status:set', src, 'stress', 0)
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
    Core.RegisterUsableItem(name, cb)
end

function Framework.RemoveMoney(src, account, amount, reason)
    if amount <= 0 then return true end
    local player = GetRawPlayer(src)
    if not player or GetAccount(player, account) < amount then return false end
    if account == 'cash' or account == 'money' then player.removeMoney(amount, reason)
    else player.removeAccountMoney(account, amount, reason) end
    return true
end

function Framework.AddMoney(src, account, amount, reason)
    local player = GetRawPlayer(src)
    if not player then return false end
    if account == 'cash' or account == 'money' then player.addMoney(amount, reason)
    else player.addAccountMoney(account, amount, reason) end
    return true
end

function Framework.GetPlayerMoney(src, account)
    local player = GetRawPlayer(src)
    return player and GetAccount(player, account) or 0
end

function Framework.GetPlayerIdentifier(src)
    local player = GetRawPlayer(src)
    return player and player.identifier or nil
end
