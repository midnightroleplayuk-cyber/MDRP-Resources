-- GoodCiv carrier registry: who has opted in to receive alerts.
Carriers = {}

local active = {} -- [src] = true

local function kvpKey(src)
    return ('goodciv:carrier:%s'):format(Bridge.GetIdentifier(src))
end

local function certKey(src)
    return ('goodciv:certified:%s'):format(Bridge.GetIdentifier(src))
end

local function trainingOn()
    return Config.Training and Config.Training.Enabled
end

function Carriers.IsCertified(src)
    if not trainingOn() then return true end
    return GetResourceKvpInt(certKey(src)) == 1
end

function Carriers.SetCertified(src, certified)
    if certified then
        SetResourceKvpInt(certKey(src), 1)
    else
        DeleteResourceKvp(certKey(src))
        if active[src] then Carriers.Set(src, false) end
    end
end

---Why src can't be a carrier right now, or nil if they can.
function Carriers.Ineligible(src)
    if Bridge.IsBlockedJob(src) then return L('carrier_blocked_job') end
    if not Carriers.IsCertified(src) then return L('carrier_not_certified') end
    if Config.Carriers.AcePermission and not IsPlayerAceAllowed(src, Config.Carriers.AcePermission) then
        return L('carrier_no_perm')
    end
    if Config.Carriers.RequiredItem and not Bridge.HasItem(src, Config.Carriers.RequiredItem) then
        return L('carrier_no_item', Config.Carriers.RequiredItem)
    end
end

function Carriers.Set(src, enabled)
    active[src] = enabled or nil
    Player(src).state:set('goodciv:carrier', enabled, true)
    if Config.Carriers.Persist then
        if enabled then
            SetResourceKvpInt(kvpKey(src), 1)
        else
            DeleteResourceKvp(kvpKey(src))
        end
    end
end

function Carriers.IsCarrier(src)
    return active[src] == true
end

---Carriers that can be alerted for an incident at coords.
function Carriers.GetAvailable(coords, exclude)
    local list = {}
    for src in pairs(active) do
        local downed = (Player(src).state['goodciv:patient'] or {}).downed
        if not exclude[src] and not downed and not Carriers.Ineligible(src)
            and not Incidents.IsPatient(src) and not Incidents.GetResponding(src) then
            local ped = GetPlayerPed(src)
            if ped ~= 0 then
                local dist = #(GetEntityCoords(ped) - coords)
                if Config.Alerts.Radius <= 0 or dist <= Config.Alerts.Radius then
                    list[#list + 1] = src
                end
            end
        end
    end
    return list
end

local function restore(src)
    if not Config.Carriers.Persist then return end
    if GetResourceKvpInt(kvpKey(src)) == 1 and not Carriers.Ineligible(src) then
        Carriers.Set(src, true)
    end
end

---Toggle carrier status for src, with feedback toasts.
function Carriers.Toggle(src)
    if Carriers.IsCarrier(src) then
        Carriers.Set(src, false)
        TriggerClientEvent('goodciv:client:toast', src, 'info', L('carrier_off'))
        return
    end
    local reason = Carriers.Ineligible(src)
    if reason then
        TriggerClientEvent('goodciv:client:toast', src, 'error', reason)
        return
    end
    Carriers.Set(src, true)
    TriggerClientEvent('goodciv:client:toast', src, 'success', L('carrier_on'))
end

if Config.Carriers.Command then
    RegisterCommand(Config.Carriers.Command, function(src)
        if src == 0 then return end
        Carriers.Toggle(src)
    end, false)
end

---------------------------------------------------------------------------
-- Sign-up NPC + training quiz
---------------------------------------------------------------------------
local quizOpen = {}    -- [src] = true while a quiz has been sent and not answered
local retryAt = {}     -- [identifier] = os.time() when they may retry

---Questions without the answers, for the client.
local function publicQuestions()
    local list = {}
    for i, q in ipairs(Config.Training.Questions) do
        list[i] = { question = q.question, options = q.options }
    end
    return list
end

-- The sign-up NPC (hf1_npcs target event) lands here.
RegisterNetEvent('goodciv:server:toggleCarrier', function()
    local src = source
    if Carriers.IsCarrier(src) or Carriers.IsCertified(src) then
        return Carriers.Toggle(src)
    end
    if Bridge.IsBlockedJob(src) then
        return TriggerClientEvent('goodciv:client:toast', src, 'error', L('carrier_blocked_job'))
    end
    local wait = (retryAt[Bridge.GetIdentifier(src)] or 0) - os.time()
    if wait > 0 then
        return TriggerClientEvent('goodciv:client:toast', src, 'error', L('training_cooldown', math.ceil(wait / 60)))
    end
    quizOpen[src] = true
    TriggerClientEvent('goodciv:client:startTraining', src, publicQuestions(), Config.Training.PassMark)
end)

RegisterNetEvent('goodciv:server:trainingCancelled', function()
    quizOpen[source] = nil
end)

RegisterNetEvent('goodciv:server:submitTraining', function(answers)
    local src = source
    if not quizOpen[src] then return end
    quizOpen[src] = nil
    if type(answers) ~= 'table' then return end

    local questions = Config.Training.Questions
    local score = 0
    for i, q in ipairs(questions) do
        if tonumber(answers[i]) == q.answer then score = score + 1 end
    end

    if score >= Config.Training.PassMark then
        Carriers.SetCertified(src, true)
        TriggerClientEvent('goodciv:client:toast', src, 'success', L('training_passed', score, #questions))
        local reason = Carriers.Ineligible(src)
        if reason then
            TriggerClientEvent('goodciv:client:toast', src, 'error', reason)
        else
            Carriers.Set(src, true)
            TriggerClientEvent('goodciv:client:toast', src, 'success', L('carrier_on'))
        end
    else
        local cooldown = Config.Training.RetryCooldown or 0
        if cooldown > 0 then retryAt[Bridge.GetIdentifier(src)] = os.time() + cooldown end
        TriggerClientEvent('goodciv:client:toast', src, 'error',
            L('training_failed', score, #questions, Config.Training.PassMark, math.ceil(cooldown / 60)))
    end
end)

-- Admin: /goodcivcert [id] [on|off]  (needs the goodciv.admin ace, or the server console)
RegisterCommand('goodcivcert', function(src, args)
    if src ~= 0 and not IsPlayerAceAllowed(src, 'goodciv.admin') then return end
    local target = tonumber(args[1])
    if not target or GetPlayerPing(target) == 0 then
        local msg = 'Usage: /goodcivcert [server id] [on|off]'
        if src == 0 then print(msg) else TriggerClientEvent('goodciv:client:toast', src, 'error', msg) end
        return
    end
    local on = args[2] ~= 'off'
    Carriers.SetCertified(target, on)
    local msg = ('%s is %s GoodCiv certified.'):format(Bridge.GetName(target), on and 'now' or 'no longer')
    if src == 0 then print(msg) else TriggerClientEvent('goodciv:client:toast', src, 'success', msg) end
end, false)

-- Sign-up peds: the client sends the index of the ped it used; check the player is actually next to it.
RegisterNetEvent('goodciv:server:signupPed', function(index)
    local src = source
    local cfg = Config.SignupPeds
    if not cfg or not cfg.Enabled or type(index) ~= 'number' then return end
    local entry = cfg.Locations[index]
    if not entry then return end
    local ped = GetPlayerPed(src)
    if ped == 0 then return end
    local c = entry.coords
    if #(GetEntityCoords(ped) - vector3(c.x, c.y, c.z)) > (cfg.Distance or 2.5) + 3.0 then return end
    Carriers.Toggle(src)
end)

-- Restore opt-in once the character is loaded (identifier depends on framework).
RegisterNetEvent('goodciv:server:ready', function()
    restore(source)
end)

AddEventHandler('playerDropped', function()
    active[source] = nil
    quizOpen[source] = nil
end)

exports('IsCarrier', Carriers.IsCarrier)
exports('SetCarrier', Carriers.Set)
exports('IsCertified', Carriers.IsCertified)
exports('SetCertified', Carriers.SetCertified)
