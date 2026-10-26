if IsDuplicityVersion() then return end

if not Config.Modules or not Config.Modules['SitAnyChair'] then return end

local targetSystem = nil

CreateThread(function()
    Wait(1000)

    if GetResourceState('ox_target') == 'started' then
        targetSystem = 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        targetSystem = 'qb-target'
    end

    if targetSystem then
        InitializeSitSystem()
    else
        InitializeProximitySitSystem()
    end
end)

local defaultSitEmote = 'sitchair2'

local ChairHashLookup = {}
if Config.SitAnyChair then
    for name, data in pairs(Config.SitAnyChair) do
        local hash = type(name) == 'number' and name or GetHashKey(name)
        -- Use one lookup key for signed and unsigned representations of a model.
        hash = hash & 0xFFFFFFFF
        ChairHashLookup[hash] = {
            name = name,
            xOffset = data.xOffset or 0.0,
            yOffset = data.yOffset or 0.0,
            zOffset = data.zOffset or 0.0,
            rotOffset = data.rotOffset or 0.0,
            sitEmote = data.sitEmote or defaultSitEmote,
        }
    end
end

local isSitting = false
local currentChairEntity = nil

local function GetChairData(entity)
    if not DoesEntityExist(entity) then return nil end
    local model = GetEntityModel(entity)
    return ChairHashLookup[model & 0xFFFFFFFF]
end

local function LoadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end

    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 500 do
        Wait(10)
        timeout = timeout + 1
    end

    return HasAnimDictLoaded(dict)
end

local sitEmoteData = {
    ['sitchair'] = { dict = 'timetable@ron@ig_3_couch', anim = 'base' },
    ['sitchair2'] = { dict = 'timetable@ron@ig_5_p3', anim = 'ig_5_p3_base' },
    ['sitchair3'] = { dict = 'timetable@reunited@ig_10', anim = 'base_amanda' },
    ['sitchair4'] = { dict = 'timetable@ron@ron_ig_2_alt1', anim = 'ig_2_alt1_base' },
    ['sitchair5'] = { dict = 'timetable@jimmy@mics3_ig_15@', anim = 'mics3_15_base_tracy' },
    ['sitchair6'] = { dict = 'timetable@maid@couch@', anim = 'base' },
    ['sitchair7'] = { dict = 'anim@scripted@freemode_npc@fix_astu_ig3_pooh_jimmy@jimmy@', anim = 'sit_base_jimmy' },
    ['sitchair8'] = { dict = 'anim@scripted@freemode_npc@fix_dre_studio_entourage@', anim = 'lonely_ballas' },
}

function StandUp()
    if not isSitting then return end

    local ped = PlayerPedId()
    local chairEntity = currentChairEntity

    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)

    if chairEntity and DoesEntityExist(chairEntity) then
        SetEntityCollision(chairEntity, true, true)
    end

    isSitting = false
    currentChairEntity = nil
end

local function SitDown(entity, overrideEmote, animOffsets)
    if isSitting then return end
    if not DoesEntityExist(entity) then return end

    local chairData = GetChairData(entity)
    if not chairData then
        chairData = {
            xOffset = 0.0,
            yOffset = 0.0,
            zOffset = 0.0,
            rotOffset = 0.0,
            sitEmote = defaultSitEmote,
        }
    end

    if overrideEmote then
        chairData.sitEmote = overrideEmote
    end

    local animXOffset = animOffsets and animOffsets.xOffset or 0.0
    local animYOffset = animOffsets and animOffsets.yOffset or 0.0
    local animZOffset = animOffsets and animOffsets.zOffset or 0.0
    local animRotOffset = animOffsets and animOffsets.rotOffset or 0.0

    local ped = PlayerPedId()
    local emoteData = sitEmoteData[chairData.sitEmote] or sitEmoteData[defaultSitEmote]

    if not LoadAnimDict(emoteData.dict) then return end

    local chairCoords = GetEntityCoords(entity)
    local chairHeading = GetEntityHeading(entity)

    local baseYOffset = -0.55
    local baseZOffset = -0.5

    local headingRad = math.rad(chairHeading)
    local totalXOffset = animXOffset + chairData.xOffset
    local totalYOffset = baseYOffset + animYOffset + chairData.yOffset
    local totalZOffset = baseZOffset + animZOffset + chairData.zOffset

    local wx = chairCoords.x + (totalYOffset * math.sin(-headingRad)) + (totalXOffset * math.cos(headingRad))
    local wy = chairCoords.y + (totalYOffset * math.cos(-headingRad)) + (totalXOffset * math.sin(headingRad))
    local wz = chairCoords.z + totalZOffset

    local heading = chairHeading + 180.0 + (chairData.rotOffset or 0.0) + animRotOffset

    isSitting = true
    currentChairEntity = entity

    SetEntityCollision(entity, false, false)
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, wx, wy, wz, false, false, false, false)
    SetEntityHeading(ped, heading)

    Wait(100)

    FreezeEntityPosition(ped, false)
    TaskPlayAnim(ped, emoteData.dict, emoteData.anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)

    Wait(300)

    FreezeEntityPosition(ped, true)

    CreateThread(function()
        if Interaction and Interaction.ShowSitPrompt then
            Interaction.ShowSitPrompt(true)
        end

        while isSitting do
            Wait(0)

            if IsControlJustPressed(0, 73) then
                StandUp()
                break
            end
        end

        if Interaction and Interaction.HideSitPrompt then
            Interaction.HideSitPrompt()
        end
    end)
end

local function GetChairHashes()
    local hashes = {}
    for hash, _ in pairs(ChairHashLookup) do
        table.insert(hashes, hash)
        -- Target resources index the raw native result, which can be signed.
        if hash >= 0x80000000 then
            table.insert(hashes, hash - 0x100000000)
        end
    end
    return hashes
end

local function GetEmoteLabel(emoteName)
    local emoteData = Config.Emotes and Config.Emotes[emoteName]
    if emoteData and emoteData[3] then
        return emoteData[3]
    end
    return emoteName
end

local sitStyles = {
    { emote = 'sitchair',  icon = 'fas fa-chair', xOffset = 0.0,  yOffset = 0.0,  zOffset = 0.0, rotOffset = 0.0 },
    { emote = 'sitchair2', icon = 'fas fa-couch', xOffset = 0.0,  yOffset = 0.0,  zOffset = 0.0, rotOffset = 0.0 },
    { emote = 'sitchair3', icon = 'fas fa-chair', xOffset = -0.2, yOffset = -0.2, zOffset = 0.0, rotOffset = 0.0 },
    { emote = 'sitchair4', icon = 'fas fa-chair', xOffset = 0.0,  yOffset = 0.0,  zOffset = 0.0, rotOffset = 0.0 },
    { emote = 'sitchair5', icon = 'fas fa-chair', xOffset = 0.0,  yOffset = 0.0,  zOffset = 0.0, rotOffset = 0.0 },
    { emote = 'sitchair6', icon = 'fas fa-couch', xOffset = -0.1, yOffset = -0.2, zOffset = 0.0, rotOffset = 0.0 },
    { emote = 'sitchair7', icon = 'fas fa-chair', xOffset = 0.0,  yOffset = 0.5,  zOffset = 0.0, rotOffset = 0.0 },
    { emote = 'sitchair8', icon = 'fas fa-chair', xOffset = 0.0,  yOffset = 0.5,  zOffset = 0.0, rotOffset = 0.0 },
}

function InitializeProximitySitSystem()
    local chairHashes = GetChairHashes()
    if #chairHashes == 0 then return end

    local chairHashSet = {}
    for _, hash in ipairs(chairHashes) do
        chairHashSet[hash] = true
    end

    local interactDist = 2.0
    local promptShowing = false
    local nearestChair = nil

    CreateThread(function()
        while true do
            local sleep = 500
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            nearestChair = nil

            if not isSitting then
                local closestDist = interactDist + 1.0
                local entityFound = nil

                local handle, entity = FindFirstObject()
                local success = true
                while success do
                    if DoesEntityExist(entity) then
                        local model = GetEntityModel(entity)
                        if chairHashSet[model & 0xFFFFFFFF] then
                            local dist = #(coords - GetEntityCoords(entity))
                            if dist < closestDist then
                                closestDist = dist
                                entityFound = entity
                            end
                        end
                    end
                    success, entity = FindNextObject(handle)
                end
                EndFindObject(handle)

                if entityFound and closestDist <= interactDist then
                    nearestChair = entityFound
                    sleep = 0

                    if not promptShowing then
                        ShowTextUI('[E] ' .. (Translate('SIT_DOWN') or 'Sit Down'))
                        promptShowing = true
                    end

                    if IsControlJustPressed(0, 38) then
                        HideTextUI()
                        promptShowing = false
                        SitDown(entityFound)
                    end
                else
                    if promptShowing then
                        HideTextUI()
                        promptShowing = false
                    end
                end
            else
                if promptShowing then
                    HideTextUI()
                    promptShowing = false
                end
            end

            Wait(sleep)
        end
    end)
end

function InitializeSitSystem()
    local chairHashes = GetChairHashes()

    if #chairHashes == 0 then return end

    if targetSystem == 'ox_target' then
        local oxOptions = {}
        for i, style in ipairs(sitStyles) do
            local styleOffsets = { xOffset = style.xOffset, yOffset = style.yOffset, zOffset = style.zOffset, rotOffset = style.rotOffset }
            local emoteLabel = GetEmoteLabel(style.emote)
            table.insert(oxOptions, {
                name = 'sit_chair_' .. style.emote,
                icon = style.icon,
                label = emoteLabel,
                distance = 2.0,
                canInteract = function(entity, distance, coords, name, bone)
                    return not isSitting and DoesEntityExist(entity)
                end,
                onSelect = function(data)
                    SitDown(data.entity, style.emote, styleOffsets)
                end,
            })
        end

        exports.ox_target:addModel(chairHashes, oxOptions)
    elseif targetSystem == 'qb-target' then
        local qbOptions = {}
        for i, style in ipairs(sitStyles) do
            local styleOffsets = { xOffset = style.xOffset, yOffset = style.yOffset, zOffset = style.zOffset, rotOffset = style.rotOffset }
            local emoteLabel = GetEmoteLabel(style.emote)
            table.insert(qbOptions, {
                type = 'client',
                icon = style.icon,
                label = emoteLabel,
                canInteract = function(entity, distance, data)
                    return not isSitting and DoesEntityExist(entity)
                end,
                action = function(entity)
                    SitDown(entity, style.emote, styleOffsets)
                end,
            })
        end

        exports['qb-target']:AddTargetModel(chairHashes, {
            options = qbOptions,
            distance = 2.0,
        })
    end
end

exports('IsSitting', function()
    return isSitting
end)

exports('StandUp', function()
    StandUp()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if isSitting then
            StandUp()
        end
    end
end)
