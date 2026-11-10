-- Injury after being brought round, and checking in at a hospital to clear it.
Injury = {}

local C = Config.CheckIn
local injured = {}    -- [src] = true
local checkingIn = {} -- [src] = true

local function kvpKey(src)
    return ('goodciv:injured:%s'):format(Bridge.GetIdentifier(src))
end

local function toast(src, kind, msg) TriggerClientEvent('goodciv:client:toast', src, kind, msg) end

function Injury.IsInjured(src) return injured[src] == true end

---Hold src's health low until they check in.
---@param fresh boolean true when just brought round (sets a GPS waypoint)
function Injury.Apply(src, fresh)
    if not Config.Injury.Enabled then return end
    injured[src] = true
    Player(src).state:set('goodciv:injured', true, true)
    if Config.Injury.Persist then SetResourceKvpInt(kvpKey(src), 1) end
    TriggerClientEvent('goodciv:client:setInjured', src, Config.Injury.HealthPercent, fresh)
end

---Clear the injury (checked in, respawned, admin revive...).
---@param heal boolean restore full health on the client
function Injury.Clear(src, heal)
    injured[src] = nil
    Player(src).state:set('goodciv:injured', false, true)
    if Config.Injury.Persist then DeleteResourceKvp(kvpKey(src)) end
    TriggerClientEvent('goodciv:client:clearInjury', src, heal)
end

local function isDown(src)
    local state = Player(src).state
    return state['goodciv:down'] or (state['goodciv:patient'] or {}).downed
end

---------------------------------------------------------------------------
-- GoodCiv check-in points
---------------------------------------------------------------------------
RegisterNetEvent('goodciv:server:checkIn', function(id)
    local src = source
    if C.Mode == 'external' or checkingIn[src] then return end
    local h = GoodCiv.GetHospital(id)
    local ped = GetPlayerPed(src)
    if not h or ped == 0 then return end

    local spot = vector3(h.drop.x, h.drop.y, h.drop.z)
    if #(GetEntityCoords(ped) - spot) > C.Distance + 2.0 then return toast(src, 'error', L('too_far_checkin')) end
    if isDown(src) then return end
    if not Injury.IsInjured(src) and GetEntityHealth(ped) >= GetEntityMaxHealth(ped) then
        return toast(src, 'info', L('checkin_not_needed'))
    end

    local fee = h.fee or C.Fee
    if not Bridge.RemoveMoney(src, fee, C.Account) then
        return toast(src, 'error', L('checkin_no_money', fee))
    end

    checkingIn[src] = true
    TriggerClientEvent('goodciv:client:checkInRun', src, C.Duration, h.label)
    SetTimeout(C.Duration * 1000, function()
        checkingIn[src] = nil
        if GetPlayerPed(src) == 0 then return end
        Injury.Clear(src, true)
        toast(src, 'success', L('checkin_done', h.label))
    end)
end)

---------------------------------------------------------------------------
-- External hospital scripts
---------------------------------------------------------------------------
-- Sent by the client when one of Config.CheckIn.ExternalEvents fires, or the
-- client CheckIn export is called.
RegisterNetEvent('goodciv:server:externalCheckIn', function()
    local src = source
    if C.Mode == 'goodciv' or not Injury.IsInjured(src) then return end
    Injury.Clear(src, false)
    toast(src, 'success', L('checkin_external'))
end)

-- Restore on character load.
RegisterNetEvent('goodciv:server:ready', function()
    local src = source
    if Config.Injury.Enabled and Config.Injury.Persist and GetResourceKvpInt(kvpKey(src)) == 1 then
        Injury.Apply(src, false)
    end
end)

AddEventHandler('playerDropped', function()
    injured[source] = nil
    checkingIn[source] = nil
end)

-- exports.ndm_goodciv:CheckIn(src) from your hospital script once the player is treated.
exports('CheckIn', function(src, heal) Injury.Clear(src, heal ~= false) end)
exports('IsInjured', Injury.IsInjured)
exports('SetInjured', function(src) Injury.Apply(src, true) end)
