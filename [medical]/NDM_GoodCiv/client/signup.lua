-- Sign-up peds: NPCs players talk to in order to sign up / sign off as a GoodCiv carrier.
local cfg = Config.SignupPeds
if not cfg or not cfg.Enabled or not cfg.Locations or #cfg.Locations == 0 then return end

local spawned = {} -- [index] = ped
local blips = {}
local lastUse = 0

local function started(res) return GetResourceState(res) == 'started' end

local function detectInteraction()
    if cfg.Interaction ~= 'auto' then return cfg.Interaction end
    if started('ox_target') then return 'ox_target' end
    if started('qb-target') then return 'qb-target' end
    return 'key'
end

local interaction = detectInteraction()
print(('^2[goodciv]^7 sign-up peds: %d location(s), interaction: %s'):format(#cfg.Locations, interaction))

local function isCarrier()
    return LocalPlayer.state['goodciv:carrier'] == true
end

local function use(index)
    local now = GetGameTimer()
    if now - lastUse < 1500 then return end
    lastUse = now
    TriggerServerEvent('goodciv:server:signupPed', index)
end

local function addTarget(ped, index)
    if interaction == 'ox_target' then
        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'goodciv_signup_join',
                icon = 'fa-solid fa-heart-pulse',
                label = L('signup_join'),
                distance = cfg.Distance,
                canInteract = function() return not isCarrier() end,
                onSelect = function() use(index) end,
            },
            {
                name = 'goodciv_signup_leave',
                icon = 'fa-solid fa-user-minus',
                label = L('signup_leave'),
                distance = cfg.Distance,
                canInteract = function() return isCarrier() end,
                onSelect = function() use(index) end,
            },
        })
    elseif interaction == 'qb-target' then
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    icon = 'fas fa-heart-pulse',
                    label = L('signup_join'),
                    canInteract = function() return not isCarrier() end,
                    action = function() use(index) end,
                },
                {
                    icon = 'fas fa-user-minus',
                    label = L('signup_leave'),
                    canInteract = function() return isCarrier() end,
                    action = function() use(index) end,
                },
            },
            distance = cfg.Distance,
        })
    end
end

local function removeTarget(ped)
    if interaction == 'ox_target' then
        exports.ox_target:removeLocalEntity(ped, { 'goodciv_signup_join', 'goodciv_signup_leave' })
    elseif interaction == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(ped)
    end
end

local function spawnPed(index, loc)
    local model = type(loc.model) == 'string' and joaat(loc.model) or loc.model
    if not IsModelInCdimage(model) then
        print(('^1[goodciv]^7 sign-up ped %d has an invalid model'):format(index))
        return
    end
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then
            print(('^1[goodciv]^7 sign-up ped %d: model failed to load'):format(index))
            return
        end
        Wait(0)
    end

    local c = loc.coords
    local ped = CreatePed(4, model, c.x, c.y, c.z - 1.0, c.w, false, true)
    SetModelAsNoLongerNeeded(model)
    if ped == 0 then
        print(('^1[goodciv]^7 sign-up ped %d: CreatePed failed'):format(index))
        return
    end
    GoodCiv.Debug(('sign-up ped %d spawned at %.2f, %.2f, %.2f'):format(index, c.x, c.y, c.z - 1.0))
    SetEntityHeading(ped, c.w)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdoll(ped, false)
    SetPedFleeAttributes(ped, 0, false)
    SetPedDiesWhenInjured(ped, false)
    if loc.scenario then
        TaskStartScenarioInPlace(ped, loc.scenario, 0, true)
    end

    spawned[index] = ped
    addTarget(ped, index)
end

local function despawnPed(index)
    local ped = spawned[index]
    spawned[index] = nil
    if ped and DoesEntityExist(ped) then
        removeTarget(ped)
        DeleteEntity(ped)
    end
end

-- Map blips.
for i, loc in ipairs(cfg.Locations) do
    if loc.blip then
        local b = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
        SetBlipSprite(b, loc.blip.sprite or 280)
        SetBlipColour(b, loc.blip.colour or 2)
        SetBlipScale(b, loc.blip.scale or 0.7)
        SetBlipAsShortRange(b, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(loc.label or 'GoodCiv')
        EndTextCommandSetBlipName(b)
        blips[i] = b
    end
end

-- Spawn / despawn peds by distance.
CreateThread(function()
    while true do
        local pos = GetEntityCoords(PlayerPedId())
        for i, loc in ipairs(cfg.Locations) do
            local dist = #(pos - vector3(loc.coords.x, loc.coords.y, loc.coords.z))
            if dist <= cfg.SpawnDistance then
                if not spawned[i] or not DoesEntityExist(spawned[i]) then spawnPed(i, loc) end
            elseif spawned[i] then
                despawnPed(i)
            end
        end
        Wait(1000)
    end
end)

-- "Press E" fallback when no target resource is used.
if interaction == 'key' then
    CreateThread(function()
        while true do
            local sleep = 500
            local playerPed = PlayerPedId()
            if not IsPedInAnyVehicle(playerPed, false) then
                local pos = GetEntityCoords(playerPed)
                for i, ped in pairs(spawned) do
                    if DoesEntityExist(ped) and #(pos - GetEntityCoords(ped)) <= cfg.Distance then
                        sleep = 0
                        Nui.HelpText(L(isCarrier() and 'help_signup_leave' or 'help_signup_join'))
                        if IsControlJustReleased(0, 38) then use(i) end
                        break
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for i in pairs(spawned) do despawnPed(i) end
    for _, b in pairs(blips) do RemoveBlip(b) end
end)
