--- Arm networked hostile peds on the client (server cannot call SetPedAsEnemy / TaskCombatPed / GiveWeaponToPed).

local Hostile = {}

local GROUP = 'IJ_HOSTILE'
local groupHash

local function ensureGroup()
    if groupHash then return groupHash end
    AddRelationshipGroup(GROUP)
    groupHash = joaat(GROUP)
    local playerHash = joaat('PLAYER')
    SetRelationshipBetweenGroups(5, playerHash, groupHash)
    SetRelationshipBetweenGroups(5, groupHash, playerHash)
    return groupHash
end

local function resolveWeapon(weapon)
    if not weapon then return `WEAPON_PISTOL` end
    if type(weapon) == 'number' then return weapon end
    return joaat(weapon)
end

local function waitForPed(netId, timeoutMs)
    return lib.waitFor(function()
        if NetworkDoesEntityExistWithNetworkId(netId) then
            local ped = NetToPed(netId)
            if ped and ped ~= 0 and DoesEntityExist(ped) then
                return ped
            end
        end
    end, false, timeoutMs or 8000)
end

--- @param netIds number[] network ids of peds
--- @param weapon string|number|nil weapon name or hash
--- @param opts? { ammo?: number, combat?: boolean, aiBlip?: boolean }
function Hostile.armPeds(netIds, weapon, opts)
    if not netIds or #netIds == 0 then return end
    opts = opts or {}
    local ammo = opts.ammo or 200
    local doCombat = opts.combat ~= false
    local weaponHash = resolveWeapon(weapon)
    local gHash = ensureGroup()

    CreateThread(function()
        for _, netId in pairs(netIds) do
            local ped = waitForPed(netId)
            if ped then
                SetPedRelationshipGroupHash(ped, gHash)
                SetPedCombatAttributes(ped, 46, true)
                SetPedFleeAttributes(ped, 0, false)
                SetPedCombatRange(ped, 2)
                SetPedAsEnemy(ped, true)
                GiveWeaponToPed(ped, weaponHash, ammo, false, true)
                SetPedKeepTask(ped, true)
                if opts.aiBlip ~= false then
                    SetPedHasAiBlip(ped, true)
                    SetPedAiBlipHasCone(ped, false)
                end
                if doCombat then
                    if opts.chase then
                        TaskVehicleChase(ped, cache.ped)
                    else
                        TaskCombatPed(ped, cache.ped, 0, 16)
                    end
                end
            end
        end
    end)
end

--- Arm drivers already seated in networked vehicles.
--- @param vehicleNetIds number[]
--- @param weapon string|number|nil
--- @param opts? { chase?: boolean, ammo?: number }
function Hostile.armVehicleDrivers(vehicleNetIds, weapon, opts)
    if not vehicleNetIds or #vehicleNetIds == 0 then return end
    opts = opts or {}
    local ammo = opts.ammo or 200
    local weaponHash = resolveWeapon(weapon)
    local gHash = ensureGroup()

    CreateThread(function()
        for _, netId in pairs(vehicleNetIds) do
            local veh = lib.waitFor(function()
                if NetworkDoesEntityExistWithNetworkId(netId) then
                    local e = NetToVeh(netId)
                    if e and e ~= 0 and DoesEntityExist(e) then return e end
                end
            end, false, 8000)
            if not veh then goto continue end

            local ped = lib.waitFor(function()
                local driver = GetPedInVehicleSeat(veh, -1)
                if driver and driver ~= 0 and DoesEntityExist(driver) then return driver end
            end, false, 5000)

            if ped then
                SetPedRelationshipGroupHash(ped, gHash)
                SetPedCombatAttributes(ped, 46, true)
                SetPedFleeAttributes(ped, 0, false)
                SetPedAsEnemy(ped, true)
                GiveWeaponToPed(ped, weaponHash, ammo, false, true)
                SetPedKeepTask(ped, true)
                if opts.chase then
                    TaskVehicleChase(ped, cache.ped)
                else
                    TaskCombatPed(ped, cache.ped, 0, 16)
                end
            end
            ::continue::
        end
    end)
end

return Hostile
