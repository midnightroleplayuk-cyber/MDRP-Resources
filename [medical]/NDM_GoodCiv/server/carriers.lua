-- GoodCiv carrier registry: who has opted in to receive alerts.
Carriers = {}

local active = {} -- [src] = true

local function kvpKey(src)
    return ('goodciv:carrier:%s'):format(Bridge.GetIdentifier(src))
end

---Why src can't be a carrier right now, or nil if they can.
function Carriers.Ineligible(src)
    if Bridge.IsBlockedJob(src) then return L('carrier_blocked_job') end
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

-- Sign-up through an NPC placed with hf1_npcs (or any other script): same checks as the command.
RegisterNetEvent('goodciv:server:toggleCarrier', function()
    Carriers.Toggle(source)
end)

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
end)

exports('IsCarrier', Carriers.IsCarrier)
exports('SetCarrier', Carriers.Set)
