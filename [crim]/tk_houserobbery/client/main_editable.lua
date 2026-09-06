local doingProgress = false

local function StopProgress(ped, anim, obj, ptfx)
    if DoesEntityExist(obj) then DeleteEntity(obj) end

    if anim then
        ClearPedTasks(ped)
    end

    if ptfx then
        StopParticleFxLooped(ptfx, false)
    end

    doingProgress = false
    Utils.Debug('Progress stopped', doingProgress)
end

function DoProgress(anim, duration)
    local ped = PlayerPedId()
    Utils.Debug('DoProgress called', doingProgress, IsPedInAnyVehicle(ped, true), IsEntityDead(ped))

    if doingProgress or IsPedInAnyVehicle(ped, true) or IsEntityDead(ped) then
        Utils.Debug('DoProgress bail', doingProgress, IsPedInAnyVehicle(ped, true), IsEntityDead(ped))
        return
    end
    doingProgress = true
    Utils.Debug('Progress started', doingProgress)

    anim = type(anim) == 'table' and anim[math.random(#anim)] or anim

    if anim?.dict and not Utils.LoadDict(anim.dict) then
        Utils.Debug('Progress anim dict failed to load')
        return
    end

    duration = anim?.duration or duration or 5000
    local startTime = GetGameTimer()
    local controls = {20, 21, 30, 31, 32, 33, 34, 35, 24, 48, 257, 25, 263, 22, 44, 37, 288, 289, 170, 167, 318, 137, 36, 47, 264, 257, 266, 267, 268, 269, 140, 141, 142, 143, 75, 73}

    local obj, ptfx

    if anim?.prop?.model then
        if not Utils.LoadModel(anim.prop.model) then
            Utils.Debug('Progress prop model failed to load')
            return
        end

        local pos = anim.prop.pos or vec3(0.0, 0.0, 0.0)
        local rot = anim.prop.rot or vec3(0.0, 0.0, 0.0)

        local pC = GetEntityCoords(ped)
        obj = CreateObject(anim.prop.model, pC.x, pC.y, pC.z + 0.2, true, true, true)
        AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, anim.prop.bone), pos, rot, true, true, false, true, 1, true)
    end

    if anim?.ptfx?.name then
        if not Utils.LoadPtfx(anim.ptfx.asset) then
            Utils.Debug('Progress ptfx failed to load')
            return
        end

        local offset = anim.ptfx.offset vec3(0.0, 0.0, 0.0)
        local rot = anim.ptfx.rot or vec3(0.0, 0.0, 0.0)
        local color = anim.ptfx.color or {r = 1.0, g = 1.0, b = 1.0}

        UseParticleFxAsset(anim.ptfx.asset)
        ptfx = StartNetworkedParticleFxLoopedOnEntityBone(anim.ptfx.name, obj, offset, rot, GetEntityBoneIndexByName(anim.ptfx.name, 'VFX'), anim.ptfx.scale, false, false, false)
        SetParticleFxLoopedColour(ptfx, color.r, color.g, color.b, false)
    end

    if anim?.scenario then
        TaskStartScenarioInPlace(ped, anim.scenario, 0, true)
    end

    while true do
        for _,v in pairs(controls) do DisableControlAction(0, v, true) end

        if anim?.dict and anim?.name and not IsEntityPlayingAnim(ped, anim.dict, anim.name, 3) then
            TaskPlayAnim(ped, anim.dict, anim.name, 2.0, 2.0, -1, anim.flag or 49, 0, false, false, false)
        end

        if IsDisabledControlJustPressed(0, 73) or IsEntityDead(ped) then
            StopProgress(ped, anim, obj, ptfx)
            return false
        end

        if startTime + duration < GetGameTimer() then
            StopProgress(ped, anim, obj, ptfx)
            return true
        end

        Wait(0)
    end
end

local function GetLineCount(str)
    local lines = 1
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == '\n' then lines = lines + 1 end
    end

    return lines
end

function Draw3DText(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 410
    local lineCount = GetLineCount(text)
    DrawRect(0.0, 0.0+0.0125*lineCount, 0.017+factor, 0.03*lineCount, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function Notify(text, notifyType)
    if Config.NotificationType == 'mythic' then
        exports['mythic_notify']:DoHudText(notifyType, text)
    elseif Config.NotificationType == 'ox' then
        lib.notify({
            title = 'House Robbery',
            description = text,
            type = notifyType
        })
    else
        ShowNotification(text, notifyType)
    end
end

function DisplayHelpText(text)
    AddTextEntry('help_text', text)
    DisplayHelpTextThisFrame('help_text', false)
end

function ShowTextUI(text)
    if Config.UseOxLib then
        lib.showTextUI(text, {position = 'right-center'})
    else
        exports['qb-core']:DrawText(text, 'left')
    end
end

function HideTextUI()
    if Config.UseOxLib then
        lib.hideTextUI()
    else
        exports['qb-core']:HideText()
    end
end

local function ConvertTargetOptions(options)
    local data = {options = options, distance = options[1]?.distance or 2.0}

    for k,v in ipairs(data.options) do
        v.num = k
        v.action = v.onSelect
        v.distance = nil
        v.onSelect = nil
    end

    return data
end

function AddEntityZone(entity, options)
    if Config.Target == 'ox' then
        exports.ox_target:addLocalEntity(entity, options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddTargetEntity(entity, formattedOptions)
    end
end

function RemoveEntityZone(entity)
    if Config.Target == 'ox' then
        exports.ox_target:removeLocalEntity(entity)
    else
        exports['qb-target']:RemoveTargetEntity(entity)
    end
end

function AddGlobalPed(options)
    if Config.Target == 'ox' then
        exports.ox_target:addGlobalPed(options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddGlobalPed(formattedOptions)
    end
end

function AddGlobalVehicle(options)
    if Config.Target == 'ox' then
        exports.ox_target:addGlobalVehicle(options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddGlobalVehicle(formattedOptions)
    end
end

function RemoveGlobalVehicle(options)
    if Config.Target == 'ox' then
        exports.ox_target:removeGlobalVehicle(options)
    else
        exports['qb-target']:RemoveGlobalVehicle(options)
    end
end

function AddModelZone(models, options)
    if Config.Target == 'ox' then
        exports.ox_target:addModel(models, options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddTargetModel(models, formattedOptions)
    end
end

local function ConvertBoxZone(options)
    local center = options.coords
    local length = options.size.x
    local width = options.size.y
    local heading = options.rotation or 0.0

    local convertedOptions = {
        name = options.options[1]?.name or ("zone_" .. tostring(math.random(1000, 9999))),
        heading = heading,
        minZ = center.z - (options.size.z / 2),
        maxZ = center.z + (options.size.z / 2),
    }

    local targetOptions = {
        options = {},
        distance = options.options[1].distance or 2.0
    }

    for _,v in ipairs(options.options) do
        targetOptions.options[#targetOptions.options + 1] = {
            label = v.label,
            icon = v.icon,
            canInteract = v.canInteract,
            action = v.onSelect,
        }
    end

    return {
        name = convertedOptions.name,
        center = center,
        length = length,
        width = width,
        options = convertedOptions,
        targetOptions = targetOptions
    }
end

function AddBoxZone(options)
    if Config.Target == 'ox' then
        return exports.ox_target:addBoxZone(options)
    else
        local zone = ConvertBoxZone(options)
        return exports['qb-target']:AddBoxZone(zone.name, zone.center, zone.length, zone.width, zone.options, zone.targetOptions)
    end
end

function RemoveTargetZone(id)
    if Config.Target == 'ox' then
        exports.ox_target:removeZone(id)
    else
        exports['qb-target']:RemoveZone(id)
    end
end

local lastAlert = GetGameTimer()
local alertCooldown = 30000 -- 30 seconds

function AlertPolice(coords)
    if lastAlert + alertCooldown > GetGameTimer() then return end
    lastAlert = GetGameTimer()

    if Config.Dispatch == 'tk' then
        exports.tk_dispatch:addCall({
            title = 'House Robbery',
            coords = coords,
            showLocation = true,
            showGender = true,
            playSound = true,
            blip = {
                color = 3,
                sprite = 357,
                scale = 1.0,
            },
            jobs = {'police'}
        })
    elseif Config.Dispatch == 'cd' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'},
            coords = coords,
            title = 'House Robbery',
            message = 'A '..data.sex..' robbing a house',
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431,
                scale = 1.2,
                colour = 3,
                flashes = false,
                text = '911 - House Robbery',
                time = 5,
                radius = 0,
            }
        })
    else
        local streetName,_ = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        streetName = GetStreetNameFromHashKey(streetName)
        local gender = GetGender()

        TriggerServerEvent('tk_houserobbery:alertPolice', coords, streetName, gender)
    end
end

---Called when trying to use a phone booth
---@return boolean canUse true if the phone booth can be used
function CanUsePhoneBooth()
    return true
end

---Called when trying to open a phone booth (pressing E or clicking on target option)
---@return boolean canOpen true if the phone booth can be opened
function CanOpenPhoneBooth()
    return true
end

---Player accepts job from phone booth
---@param coords vector3 The coordinates of the job location
function AcceptJob(coords)
    SetNewWaypoint(coords.x, coords.y)
    Notify(_U('gps_set'), 'inform')
end

---Called when trying to lockpick a door
---@param houseIndex number The index of the house to lockpick
---@return boolean canLockpick true if the door can be lockedpicked
function CanLockpickDoor(houseIndex)
    return true
end

---Returns the data for a shop
---@param shopData table Data of the shop
---@return table items List of items in the shop
function GetShopItems(shopData)
    local items = {}

    for _,item in pairs(shopData.items) do
        items[#items+1] = {
            name = item.name,
            label = GetItemLabel(item.name),
            price = item.price,
            description = item.description,
            image = Config.ImagePath .. '/' .. item.name .. '.png'
        }
    end

    return items
end

---Returns the data for a sell shop
---@param shopData table Data of the sell shop
---@return table items List of items in the sell shop
function GetSellShopItems(shopData)
    local items = {}

    for _,item in pairs(shopData.items) do
        local amount = GetItemAmount(item.name)
        if amount > 0 then
            items[#items+1] = {
                name = item.name,
                label = GetItemLabel(item.name),
                price = item.price,
                description = item.description,
                image = Config.ImagePath .. '/' .. item.name .. '.png',
                count = amount
            }
        end
    end

    return items
end

---Player tries to open the shop
---@param shopData table The data of the shop to open
---@return boolean canOpen Whether the shop can be opened or not
function CanOpenShop(shopData)
    return true
end

---Plays a voice line for the shop ped
---@param ped number The ped ID of the shopkeeper
---@param shopData table The data of the shop to open
function PlayShopPedVoiceLine(ped, shopData)
    PlayPedAmbientSpeechNative(ped, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE')
end

---Minigame for lockpicking a house door
---@return boolean success Whether the lockpicking was successful or not
function DoDoorLockpickMinigame()
    if GetResourceState('pd-safe') ~= 'started' then
        print('[WARNING] pd-safe resource not started. Skipping lockpick minigame. Install pd-safe or change minigame in client/main_editable.lua')
        return true
    end

    return Config.DebugMode or exports['pd-safe']:createSafe({math.random(0,99), math.random(0,99), math.random(0,99)}) -- minigames are skipped if debug mode is enabled
end

---Minigame for lockpicking a safe
---@return boolean success Whether the lockpicking was successful or not
function DoSafeLockpickMinigame()
    if GetResourceState('pd-safe') ~= 'started' then
        print('[WARNING] pd-safe resource not started. Skipping lockpick minigame. Install pd-safe or change minigame in client/main_editable.lua')
        return true
    end

    return Config.DebugMode or exports['pd-safe']:createSafe({math.random(0,99), math.random(0,99), math.random(0,99)})
end

---Minigame for disabling the security system
---@return boolean success Whether the minigame was successful or not
function DoSecurityDisableMinigame()
    if GetResourceState('bl_ui') ~= 'started' then
        print('[WARNING] bl_ui resource not started. Skipping minigame. Install bl_ui or change minigame in client/main_editable.lua')
        return true
    end

    return Config.DebugMode or exports.bl_ui:Untangle(3, {
        numberOfNodes = 10,
        duration = 5000,
    })
end

RegisterNetEvent('tk_houserobbery:alertPolice', function(coords, street, gender)
    local blipSettings = Config.Blip

    if blipSettings.playSound then
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end

    Notify(_U('drugs_sold', gender, street))

    local alpha = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipSettings.sprite)
    SetBlipColour(blip, blipSettings.color)
    SetBlipAlpha(blip, alpha)
    SetBlipScale(blip, blipSettings.scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('drugs_sold_title'))
    EndTextCommandSetBlipName(blip)

    local blipTime = blipSettings.time
    local startTime = GetGameTimer()
    local elapsedTime = 0

    while alpha > 0 do
        Wait(100)

        elapsedTime = (GetGameTimer() - startTime) / 1000

        if elapsedTime >= blipTime then
            alpha = 0
        else
            alpha = math.max(0, 250 - (elapsedTime / blipTime * 250))
        end

        SetBlipAlpha(blip, math.floor(alpha))

        if alpha <= 0 then
            RemoveBlip(blip)
            break
        end
    end
end)