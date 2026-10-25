local D = Config.Detections

local function exempt()
    return D.ignoreOnDuty and State.IsEmergency()
end

local function hasWitness(coords, radius)
    local me = PlayerPedId()
    for _, ped in ipairs(GetGamePool('CPed')) do
        if ped ~= me and not IsPedAPlayer(ped) and IsPedHuman(ped) and not IsPedDeadOrDying(ped, true) then
            if #(GetEntityCoords(ped) - coords) <= radius then return true end
        end
    end
    return false
end

local function inIgnoredZone(coords, zones)
    for _, zone in ipairs(zones or {}) do
        if #(coords - zone.coords) <= zone.radius then return true end
    end
    return false
end

---------------------------------------------------------------------
-- Shots fired
---------------------------------------------------------------------
if D.shooting.enabled then
    CreateThread(function()
        local cfg = D.shooting
        local ignored = {}
        for _, w in ipairs(cfg.ignoredWeapons) do ignored[joaat(w)] = true end
        local lastAlert, lastCheck = 0, 0

        while true do
            local sleep = 500
            local ped = PlayerPedId()
            if IsPedArmed(ped, 4) then
                sleep = 0
                if IsPedShooting(ped) then
                    local now = GetGameTimer()
                    if now - lastAlert > cfg.cooldown * 1000 and now - lastCheck > 1000 and not exempt() then
                        lastCheck = now
                        local coords = GetEntityCoords(ped)
                        local weapon = GetSelectedPedWeapon(ped)
                        local silenced = cfg.ignoreSilenced and IsPedCurrentWeaponSilenced(ped)
                        if not ignored[weapon] and not silenced and not inIgnoredZone(coords, cfg.ignoreZones)
                            and (not cfg.requireWitness or hasWitness(coords, cfg.witnessRadius)) then
                            lastAlert = now
                            local inVehicle = IsPedInAnyVehicle(ped, false)
                            Dispatch.SendPreset(inVehicle and 'shooting_vehicle' or 'shooting')
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

---------------------------------------------------------------------
-- Fights
---------------------------------------------------------------------
if D.fight.enabled then
    CreateThread(function()
        local cfg = D.fight
        local lastAlert = 0
        while true do
            local ped = PlayerPedId()
            if IsPedInMeleeCombat(ped) and not IsPedArmed(ped, 4) then
                local now = GetGameTimer()
                if now - lastAlert > cfg.cooldown * 1000 and not exempt() then
                    local coords = GetEntityCoords(ped)
                    if not cfg.requireWitness or hasWitness(coords, cfg.witnessRadius) then
                        lastAlert = now
                        Dispatch.SendPreset('fight')
                    end
                end
            end
            Wait(750)
        end
    end)
end

---------------------------------------------------------------------
-- Carjacking
---------------------------------------------------------------------
if D.carjack.enabled then
    CreateThread(function()
        local cfg = D.carjack
        local lastAlert = 0
        while true do
            local sleep = 1000
            local ped = PlayerPedId()
            local target = GetVehiclePedIsTryingToEnter(ped)
            if target ~= 0 then
                sleep = 100
                if IsPedJacking(ped) then
                    local now = GetGameTimer()
                    if now - lastAlert > cfg.cooldown * 1000 and not exempt() then
                        lastAlert = now
                        Dispatch.SendPreset('vehicle_theft', { vehicle = target })
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

---------------------------------------------------------------------
-- Road traffic collisions
---------------------------------------------------------------------
if D.rtc.enabled then
    CreateThread(function()
        local cfg = D.rtc
        local ignoredClass = {}
        for _, c in ipairs(cfg.ignoreClasses) do ignoredClass[c] = true end
        local factor = Utils.SpeedFactor()
        local lastAlert, prevSpeed = 0, 0

        while true do
            local sleep = 1000
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped and not ignoredClass[GetVehicleClass(veh)] then
                sleep = 200
                local speed = GetEntitySpeed(veh) * factor
                if prevSpeed >= cfg.minSpeed and (prevSpeed - speed) >= cfg.speedDrop
                    and HasEntityCollidedWithAnything(veh) then
                    local now = GetGameTimer()
                    if now - lastAlert > cfg.cooldown * 1000 and not exempt() then
                        lastAlert = now
                        Dispatch.SendPreset('rtc', { vehicle = veh })
                    end
                end
                prevSpeed = speed
            else
                prevSpeed = 0
            end
            Wait(sleep)
        end
    end)
end

---------------------------------------------------------------------
-- Vehicle fires
---------------------------------------------------------------------
if D.vehicleFire.enabled then
    CreateThread(function()
        local cfg = D.vehicleFire
        local reported = {}
        while true do
            local here = GetEntityCoords(PlayerPedId())
            local now = GetGameTimer()
            for _, veh in ipairs(GetGamePool('CVehicle')) do
                local coords = GetEntityCoords(veh)
                if #(coords - here) <= cfg.radius then
                    -- engine fires burn from 0 down to -4000, then the car is a burnt-out shell
                    local engine = GetVehicleEngineHealth(veh)
                    local burning = IsEntityOnFire(veh) or (engine < 0.0 and engine > -3999.0)
                    if burning and (not reported[veh] or now - reported[veh] > cfg.cooldown * 1000) then
                        reported[veh] = now
                        Dispatch.SendPreset('vehicle_fire', { vehicle = veh, coords = coords })
                    end
                end
            end
            for veh in pairs(reported) do
                if not DoesEntityExist(veh) then reported[veh] = nil end
            end
            Wait(3000)
        end
    end)
end

---------------------------------------------------------------------
-- Down / death detection (shared by emergency services and civilians)
---------------------------------------------------------------------

local QBCore
local esxDead = false
AddEventHandler('esx:onPlayerDeath', function() esxDead = true end)
AddEventHandler('esx:onPlayerSpawn', function() esxDead = false end)

local function frameworkDown()
    local ok, meta = pcall(function()
        if GetResourceState('qbx_core') == 'started' then
            local data = exports.qbx_core:GetPlayerData()
            return data and data.metadata
        elseif GetResourceState('qb-core') == 'started' then
            QBCore = QBCore or exports['qb-core']:GetCoreObject()
            return QBCore.Functions.GetPlayerData().metadata
        end
    end)
    if ok and meta and (meta.isdead or meta.inlaststand) then return true end
    return esxDead
end

-- Ambulance / medical scripts that keep the player alive in their own downed state
local ospDown = false
RegisterNetEvent('osp_ambulance:OnPlayerDead', function() ospDown = true end)
RegisterNetEvent('osp_ambulance:OnPlayerSpawn', function() ospDown = false end)

local medicalChecks = {
    { resource = 'osp_ambulance', check = function()
        local data = exports.osp_ambulance:GetAmbulanceData(GetPlayerServerId(PlayerId()))
        return data and (data.isDead or data.inLastStand)
    end },
    { resource = 'wasabi_ambulance_v2', check = function() return exports['wasabi_ambulance_v2']:isPlayerDead() end },
    { resource = 'wasabi_ambulance', check = function() return exports.wasabi_ambulance:isPlayerDead() end },
}

local function medicalDown()
    if ospDown then return true end
    for _, m in ipairs(medicalChecks) do
        if GetResourceState(m.resource) == 'started' then
            local ok, down = pcall(m.check)
            if ok and down then return true end
        end
    end
    return false
end

-- State bag values: true, a number above 0 (wasabi uses 0 for alive) or a non-empty string ('dead', 'lastStand')
local function truthyState(value)
    if type(value) == 'number' then return value > 0 end
    if type(value) == 'string' then return value ~= '' and value ~= 'alive' end
    return value == true
end

local function isDown(ped)
    if IsEntityDead(ped) or IsPedFatallyInjured(ped) then return true end
    local bag = LocalPlayer.state
    for _, key in ipairs(D.down.stateBagKeys) do
        if truthyState(bag[key]) then return true end
    end
    return medicalDown() or frameworkDown()
end

-- Remember recent damage, so the alert can say what happened.
-- Hits from a person or vehicle are kept separately, so a punch followed by falling over reads as an assault.
local lastHit, lastAttack = nil, nil  -- { weapon, attacker, time }
AddEventHandler('gameEventTriggered', function(name, args)
    if name ~= 'CEventNetworkEntityDamage' then return end
    local me = PlayerPedId()
    if args[1] ~= me then return end
    local hit = { weapon = args[7], attacker = args[2], time = GetGameTimer() }
    lastHit = hit
    local attacker = args[2]
    if attacker and attacker ~= 0 and attacker ~= me and DoesEntityExist(attacker)
        and (IsEntityAPed(attacker) or IsEntityAVehicle(attacker)) then
        lastAttack = hit
    end
end)

local specialCauses = {
    [`WEAPON_RUN_OVER_BY_CAR`] = 'vehicle',
    [`WEAPON_RAMMED_BY_CAR`] = 'vehicle',
    [`WEAPON_FALL`] = 'fall',
    [`WEAPON_DROWNING`] = 'drowning',
    [`WEAPON_DROWNING_IN_VEHICLE`] = 'drowning',
    [`WEAPON_FIRE`] = 'fire',
    [`WEAPON_EXPLOSION`] = 'explosion',
    [`WEAPON_ELECTRIC_FENCE`] = 'electric',
    [`WEAPON_STUNGUN`] = 'unknown',
    [`WEAPON_KNIFE`] = 'stabbing',
    [`WEAPON_SWITCHBLADE`] = 'stabbing',
    [`WEAPON_DAGGER`] = 'stabbing',
    [`WEAPON_MACHETE`] = 'stabbing',
    [`WEAPON_BOTTLE`] = 'stabbing',
}

local groupCauses = {
    [`GROUP_PISTOL`] = 'shot', [`GROUP_SMG`] = 'shot', [`GROUP_RIFLE`] = 'shot',
    [`GROUP_MG`] = 'shot', [`GROUP_SHOTGUN`] = 'shot', [`GROUP_SNIPER`] = 'shot',
    [`GROUP_HEAVY`] = 'explosion', [`GROUP_THROWN`] = 'explosion',
    [`GROUP_MELEE`] = 'assault', [`GROUP_UNARMED`] = 'assault',
}

local function classify(hit)
    local attacker = hit.attacker
    if attacker and attacker ~= 0 and DoesEntityExist(attacker) and IsEntityAVehicle(attacker) then
        return 'vehicle'
    end
    local weapon = hit.weapon
    if not weapon or weapon == 0 then return 'unknown' end
    return specialCauses[weapon] or groupCauses[GetWeapontypeGroup(weapon)] or 'unknown'
end

-- Only name a cause if there was real damage just before going down.
-- Admin /kill, bleed-outs and scripted deaths have no damage event, so they read as unresponsive.
local function causeOfInjury()
    local now = GetGameTimer()
    if lastAttack and now - lastAttack.time < 10000 then return classify(lastAttack) end
    if lastHit and now - lastHit.time < 3000 then return classify(lastHit) end
    return 'unknown'
end

---------------------------------------------------------------------
-- Officer / paramedic / firefighter down
---------------------------------------------------------------------
if D.down.enabled then
    CreateThread(function()
        local wasDown = false
        while true do
            local ped = PlayerPedId()
            local down = State.IsEmergency() and isDown(ped)
            if down and not wasDown then
                local preset = D.down.presets[State.service]
                if preset then Dispatch.SendPreset(preset) end
            end
            wasDown = down
            Wait(1000)
        end
    end)
end

---------------------------------------------------------------------
-- Civilians (and off-duty staff) down: ambulance, plus police when violent
---------------------------------------------------------------------
if D.civilianDown.enabled then
    local cfg = D.civilianDown

    CreateThread(function()
        local wasDown, lastAlert = false, 0
        while true do
            local ped = PlayerPedId()
            local down = not State.IsEmergency() and isDown(ped)

            if down and not wasDown then
                local cause = causeOfInjury()
                local coords = GetEntityCoords(ped)
                local now = GetGameTimer()

                -- give them a moment: no alert if they're revived or get up straight away
                Wait(cfg.delay * 1000)
                ped = PlayerPedId()

                lastHit, lastAttack = nil, nil

                if isDown(ped) and not State.IsEmergency()
                    and now - lastAlert > cfg.cooldown * 1000
                    and not inIgnoredZone(coords, cfg.ignoreZones)
                    and (not cfg.requireWitness or hasWitness(coords, cfg.witnessRadius)) then
                    lastAlert = GetGameTimer()

                    local text = cfg.causes[cause] or cfg.causes.unknown
                    local services = { 'ambulance' }
                    if cfg.alsoPolice[cause] then services[#services + 1] = 'police' end

                    Dispatch.SendPreset('person_down', {
                        title = text.title,
                        description = text.description,
                        priority = text.priority,
                        services = services,
                        coords = coords,
                        weapon = cause == 'shot' and Utils.GetWeaponType(ped) or nil,
                    })
                end
                down = isDown(ped)
            end

            wasDown = down
            Wait(1000)
        end
    end)
end
