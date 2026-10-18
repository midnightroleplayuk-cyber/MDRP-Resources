-- nobs_ukpd_missionplaza custody interlocks for ox_doorlock (server script). Never both doors of a pair unlocked:
-- A1 (airlock outer) <-> A2 (cage gate) and E1 (cell hall response door) <-> S1 (custody staff entry).
-- When a player unlocks one door while its partner is unlocked, the door they just unlocked is locked again and they
-- are told why. Run it from any server resource that starts after ox_doorlock (e.g. the optional nobs_ukpd_missionplaza_doorlock
-- helper: fxmanifest server_script 'interlock_ox.lua' + dependency 'ox_doorlock').
local INTERLOCKS = {
    { 'nobs_ukpd_d11_a1', 'nobs_ukpd_d11_a2' },
    { 'nobs_ukpd_d11_e1', 'nobs_ukpd_d11_s1' }
}
local partner, resolved = {}, false

local function resolve()
    partner = {}
    for _, p in ipairs(INTERLOCKS) do
        local a, b = exports.ox_doorlock:getDoorFromName(p[1]), exports.ox_doorlock:getDoorFromName(p[2])
        if a and b then partner[a.id] = b.id; partner[b.id] = a.id end
    end
    resolved = next(partner) ~= nil
end

AddEventHandler('onResourceStart', function(name) if name == 'ox_doorlock' then resolved = false end end)

-- ox_doorlock: TriggerEvent('ox_doorlock:stateChanged', source, doorId, isLocked, authMethod)
-- The revert is deferred one tick (SetTimeout 0) so it never re-enters ox_doorlock from inside its own event chain.
AddEventHandler('ox_doorlock:stateChanged', function(src, doorId, isLocked)
    if isLocked then return end
    if not resolved then resolve() end
    local other = partner[doorId]
    if not other then return end
    SetTimeout(0, function()
        local d, o = exports.ox_doorlock:getDoor(doorId), exports.ox_doorlock:getDoor(other)
        if d and o and d.state == 0 and o.state == 0 then
            exports.ox_doorlock:setDoorState(doorId, 1)
            if type(src) == 'number' and src > 0 then
                TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Interlock: lock the other door first' })
            end
        end
    end)
end)
