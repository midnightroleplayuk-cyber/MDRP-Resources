SkillChecks = {
    -- The watering skill multiplier (0.5, 1.0, 1.5, 2.0, etc.)
    -- How fast the pot will be watered
    GetWateringSkill = function()
        return 1.0
    end,
    -- The fertilizing skill multiplier (0.5, 1.0, 1.5, 2.0, etc.)
    -- Affects the amount of fertilizer bottle clicks required (higher amount = less clicks needed)
    GetFertilizingSkill = function()
        return 1.0
    end,
    -- The bud collecting skill multiplier (0.5, 1.0, 1.5, 2.0, etc.)
    -- Affects the speed of collecting weed buds (higher multiplier = faster collection)
    GetBudCollectingSkill = function()
        return 1.0
    end,
}

function IsPlayerUnreachable()
    return UseCache('IsPlayerUnreachable', function()
        local playerPed = PlayerPedId()
        return IsPedInAnyVehicle(playerPed) or IsPedRagdoll(playerPed) or IsEntityDead(playerPed)
    end, 250)
end

--
function DrawMinigameIntroduction(str)
    AddTextEntry('HelpMsg', str)

    BeginTextCommandDisplayHelp('HelpMsg')
    EndTextCommandDisplayHelp(0, 1, 0, 3000)
end
--

-- Timecycle used inside the Grow Ops
Timecycle = {
    active = false,
    name = 'kq_weed_growop',
    values = {
        { 'light_dir_mult', 0.0, 1.0 },
        { 'light_directional_amb_intensity', 0.5, 0.0 },
        { 'light_directional_amb_intensity_mult', 0.35, 0.0 },
        { 'light_directional_amb_bounce_enabled', 0.0, 0.0 },
        { 'light_natural_amb_down_intensity', 0.0, 0.0 },
        { 'light_natural_amb_up_intensity_mult', 0.5, 0.0 },
        { 'light_natural_push', -0.5, 0.0 },
        { 'ssao_inten', 5.56, 0.0 },
        { 'reflection_hdr_mult', 0.4, 0.0 },
        { 'sprite_size', 0.0, 0.0 },
        { 'sprite_brightness', 0.0, 0.0 },
    },
}

Timecycle.init = function()
    CreateTimecycleModifier(Timecycle.name)
    for k, data in pairs(Timecycle.values) do
        SetTimecycleModifierVar(Timecycle.name, data[1], data[2], data[3])
    end
end

Timecycle.enable = function(transition, strength)
    if Timecycle.active then
        return
    end

    Timecycle.active = true
    SetTransitionTimecycleModifier(Timecycle.name, transition or 16.0)
    SetTimecycleModifierStrength(strength or 1.0)
end

Timecycle.disable = function()
    if not Timecycle.active then
        return
    end

    Timecycle.active = false
    Citizen.CreateThread(function()

        local strength = 0.75
        while strength > 0 do
            strength = strength - 0.01
            SetTimecycleModifierStrength(strength + 0.0)
            Citizen.Wait(3)

            if Timecycle.active then
                return
            end
        end

        ClearTimecycleModifier()
    end)
end

Timecycle.init()
--

function CreateBlip(coords, sprite, color, alpha, scale, message)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, sprite)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, alpha)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(message)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)

    return blip
end

local function SetupWeedBlips()
    Citizen.CreateThread(function()
        local blipConfig = Config.misc.blips.growop
        if not blipConfig.enabled then
            return
        end

        for _, growop in pairs(Config.growops) do
            for _, location in pairs(growop.locations) do
                CreateBlip(location.coords, blipConfig.sprite, blipConfig.color, blipConfig.alpha, blipConfig.scale, blipConfig.label)
            end
        end
    end)
    Citizen.CreateThread(function()
        local blipConfig = Config.misc.blips.lockup
        if not blipConfig.enabled then
            return
        end

        for _, lockup in pairs(Config.lockups) do
            for _, location in pairs(lockup.locations) do
                CreateBlip(location.coords, blipConfig.sprite, blipConfig.color, blipConfig.alpha, blipConfig.scale, blipConfig.label)
            end
        end
    end)

    if Config.placing.checks.whitelistedAreas and Config.placing.checks.whitelistedAreas.enabled and Config.placing.checks.whitelistedAreas.showBlips then
        for k, area in pairs(Config.placing.checks.whitelistedAreas.areas or {}) do
            local blip = AddBlipForRadius(area.coords, area.radius)
            SetBlipColour(blip, 52)
            SetBlipAlpha(blip, 64)
            CreateBlip(area.coords, 496, 52, 128, 0.5, L('misc.whitelisted_area'))
        end
    end
end
SetupWeedBlips()

-- These systems do not have any server sided way of checking whether someone is inside a house.
-- So we have no other way to verify, besides just having to trust the client :(
function IsPlayerInsideHousing()
    local checks = Config.placing.checks
    local housingEnabled = checks.housing and checks.housing.enabled
    local areasEnabled = checks.whitelistedAreas and checks.whitelistedAreas.enabled

    local inHousing = false
    local inArea = false

    if housingEnabled then
        local sys = checks.housing.system
        if sys == 'origen_housing' then
            inHousing = exports['origen_housing']:insideHouse() or false
        elseif sys == 'qs-housing' then
            inHousing = exports['qs-housing']:getCurrentHouse() ~= nil
        elseif sys == 'sn_properties' then
            inHousing = exports['sn_properties']:getPropertyID() ~= nil
        else
            inHousing = true
        end
    end

    if areasEnabled then
        inArea = IsPlayerInWhitelistedArea()
    end

    if housingEnabled and areasEnabled then
        return inHousing or inArea
    elseif housingEnabled then
        return inHousing
    elseif areasEnabled then
        return inArea
    else
        return true
    end
end

function IsPlayerInWhitelistedArea()
    local checks = Config.placing.checks
    local areasCfg = checks.whitelistedAreas
    if not (areasCfg and areasCfg.enabled) then
        return false
    end

    local coords = GetEntityCoords(PlayerPedId())

    for _, area in pairs(areasCfg.areas or {}) do
        if IsWithinDistance(coords, area.coords, area.radius) then
            return true
        end
    end
    return false
end

if Config.qualityMetadata.enabled then
    AddEventHandler('onResourceStart', function(resource)
        if resource == 'ox_inventory' then
            exports.ox_inventory:displayMetadata('quality', L('misc.quality'))
        end
    end)

    Citizen.SetTimeout(500, function()
        if GetResourceState('ox_inventory') == 'started' then
            exports.ox_inventory:displayMetadata('quality', L('misc.quality'))
        end
    end)
end
