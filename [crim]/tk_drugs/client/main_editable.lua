local doingProgress = false

---@param ped number
---@param anim table?
---@param obj number
---@param ptfx number
local function StopProgress(ped, anim, obj, ptfx)
    if DoesEntityExist(obj) then DeleteEntity(obj) end

    if anim then
        ClearPedTasks(ped)
    end

    if ptfx then
        StopParticleFxLooped(ptfx, false)
    end

    doingProgress = false
end

---@param anim table?
---@param duration number?
---@return boolean|nil success
function DoProgress(anim, duration)
    local ped = PlayerPedId()

    if doingProgress or IsPedInAnyVehicle(ped, true) or IsEntityDead(ped) then return end
    doingProgress = true

    if anim?.dict and not Utils.LoadDict(anim.dict) then return end

    duration = anim?.duration or duration or 5000
    local startTime = GetGameTimer()
    local controls = {20, 21, 30, 31, 32, 33, 34, 35, 24, 48, 257, 25, 263, 22, 44, 37, 288, 289, 170, 167, 318, 137, 36, 47, 264, 257, 266, 267, 268, 269, 140, 141, 142, 143, 75, 73}

    local obj, ptfx

    if anim?.prop?.model then
        if not Utils.LoadModel(anim.prop.model) then return end

        local pos = anim.prop.pos or vec3(0.0, 0.0, 0.0)
        local rot = anim.prop.rot or vec3(0.0, 0.0, 0.0)

        local pC = GetEntityCoords(ped)
        obj = CreateObject(anim.prop.model, pC.x, pC.y, pC.z + 0.2, true, true, true)
        AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, anim.prop.bone), pos, rot, true, true, false, true, 1, true)
    end

    if anim?.ptfx?.name then
        if not Utils.LoadPtfx(anim.ptfx.asset) then return end

        local offset = anim.ptfx.offset or vec3(0.0, 0.0, 0.0)
        local rot = anim.ptfx.rot or vec3(0.0, 0.0, 0.0)
        local color = anim.ptfx.color or {r = 1.0, g = 1.0, b = 1.0}

        UseParticleFxAsset(anim.ptfx.asset)
        ptfx = StartNetworkedParticleFxLoopedOnEntityBone(anim.ptfx.name, obj, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, GetEntityBoneIndexByName(anim.ptfx.name, 'VFX'), anim.ptfx.scale, false, false, false)
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

---@param text string
---@param notifyType string
function Notify(text, notifyType)
    if Config.NotificationType == 'mythic' then
        exports['mythic_notify']:DoHudText(notifyType, text)
    elseif Config.NotificationType == 'ox' then
        lib.notify({
            title = 'Notify',
            description = text,
            type = notifyType
        })
    else
        ShowNotification(text, notifyType)
    end
end

---@param str string
---@return number lines
local function GetLineCount(str)
    local lines = 1

    for i = 1, #str do
        local c = str:sub(i, i)
        if c == '\n' then
            lines += 1
        end
    end

    return lines
end

---@param text string
---@return number factor
local function GetLongestLineFactor(text)
    local longest = 0

    for line in string.gmatch(text, "([^\n]*)\n?") do
        local length = string.len(line)
        longest = math.max(longest, length)
    end

    return longest / 410
end

---@param coords vector3
---@param text string
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

    local factor = GetLongestLineFactor(text)
    local lineCount = GetLineCount(text)

    DrawRect(0.0, 0.0+0.0125*lineCount, 0.017+factor, 0.03*lineCount, 0, 0, 0, 75)
    ClearDrawOrigin()
end

---@param text string
function DisplayHelpText(text)
    AddTextEntry('help_text', text)
    DisplayHelpTextThisFrame('help_text', false)
end

---@param text string
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

---@param options table
---@return table data
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

---@param entity number
---@param options table
function AddEntityZone(entity, options)
    if Config.Target == 'ox' then
        exports.ox_target:addLocalEntity(entity, options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddTargetEntity(entity, formattedOptions)
    end
end

---@param entity number
function RemoveEntityZone(entity)
    if Config.Target == 'ox' then
        exports.ox_target:removeLocalEntity(entity)
    else
        exports['qb-target']:RemoveTargetEntity(entity)
    end
end

---@param options table
function AddGlobalPed(options)
    if Config.Target == 'ox' then
        exports.ox_target:addGlobalPed(options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddGlobalPed(formattedOptions)
    end
end

---@param options table
function AddGlobalVehicle(options)
    if Config.Target == 'ox' then
        exports.ox_target:addGlobalVehicle(options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddGlobalVehicle(formattedOptions)
    end
end

---@param options table
function RemoveGlobalVehicle(options)
    if Config.Target == 'ox' then
        exports.ox_target:removeGlobalVehicle(options)
    else
        exports['qb-target']:RemoveGlobalVehicle(options)
    end
end

---@param models string[]
---@param options table
function AddModelZone(models, options)
    if Config.Target == 'ox' then
        exports.ox_target:addModel(models, options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddTargetModel(models, formattedOptions)
    end
end

---@param options table
---@return table zone
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

---@param options table
---@return number zone
function AddBoxZone(options)
    if Config.Target == 'ox' then
        return exports.ox_target:addBoxZone(options)
    else
        local zone = ConvertBoxZone(options)
        return exports['qb-target']:AddBoxZone(zone.name, zone.center, zone.length, zone.width, zone.options, zone.targetOptions)
    end
end

---@param id number
function RemoveTargetZone(id)
    if Config.Target == 'ox' then
        exports.ox_target:removeZone(id)
    else
        exports['qb-target']:RemoveZone(id)
    end
end

---Checks whether the player can open the drug selling menu
---@param ped number Entity player is trying to sell drugs to
---@return boolean canSell Whether the player can sell drugs
function CanSellDrugs(ped)
    return true
end

---Checks whether a specific drug can be sold
---@param ped number Entity player is trying to sell drugs to
---@param itemName string Name of the drug
---@param amount number Amount of the drug
---@return boolean canSell Whether the drug can be sold
function CanSellDrug(ped, itemName, amount)
    return true
end

---Returns the list of drugs the player currently has
---@return table drugs List of drugs the player currently has
function GetPlayerDrugs()
    local drugs = {}
    local counts = Config.Inventory ~= 'ox' and GetAllItemAmounts() or nil

    for _,item in pairs(Config.Selling.items) do
        local count = counts and (counts[item.name] or 0) or GetItemAmount(item.name)
        if count > 0 then
            local price = math.random(item.price.min, item.price.max)
            drugs[#drugs+1] = {
                name = item.name,
                label = Main.GetCachedItemLabel(item.name),
                count = count,
                price = price,
                image = string.format(Config.ImagePath, item.name)
            }
        end
    end

    return drugs
end

---Handles drug sale animation
---@param targetPed number Entity player is trying to sell drugs to
---@param drugName string Name of the drug
---@param amount number Amount of the drug
---@param expectedPrice number Expected price of the drug
---@param favoriteEffects table List of favorite effects
---@return boolean success Whether the drug sale was successful
function DoDrugSale(targetPed, drugName, amount, expectedPrice, favoriteEffects)
    local ped = PlayerPedId()
    local animDict, animName = 'mp_safehouselost@', 'package_dropoff'
    local drugModel, moneyModel = Config.Selling.props?.drug or 'prop_meth_bag_01', Config.Selling.props?.money or 'prop_anim_cash_note'

    Utils.LoadModel(drugModel)
    Utils.LoadModel(moneyModel)

    PlayPedAmbientSpeechNative(targetPed, 'Generic_Hi', 'Speech_Params_Force')
    TaskTurnPedToFaceEntity(ped, targetPed, 500)
    TaskTurnPedToFaceEntity(targetPed, ped, 500)
    Wait(1000)

    local drugObj = SpawnProp(drugModel, GetEntityCoords(ped), 0.0, false)
    local moneyObj = SpawnProp(moneyModel, GetEntityCoords(targetPed), 0.0, false)
    AttachEntityToEntity(drugObj, ped, 90, 0.07, 0.01, -0.01, 136.33, 50.23, -50.26, true, true, false, true, 1, true)
    AttachEntityToEntity(moneyObj, targetPed, GetPedBoneIndex(targetPed, 28422), 0.07, 0, -0.01, 18.12, 7.21, -12.44, true, true, false, true, 1, true)

    PlayAnim(ped, animDict, animName, -1, 32, 0.0, 4500)
    PlayAnim(targetPed, animDict, animName, -1, 32, 0.0, 4500)
    Wait(2500)

    DeleteEntity(drugObj)
    DeleteEntity(moneyObj)
    Wait(2000)

    ClearPedTasks(ped)
    ClearPedTasks(targetPed)
    PlayPedAmbientSpeechNative(targetPed, 'Generic_Thanks', 'Speech_Params_Force')

    return true
end

---Checks whether equipment can be placed
---@param equipmentIndex string Index of equipment in Config.EquipmentItems
---@return boolean canPlace Whether the equipment can be placed
function CanPlaceEquipment(equipmentIndex)
    if Config.PlaceOnlyInsideLabs and not Labs.GetCurrentLabId() then
        Utils.Debug('place equipment stopped, player is not inside a lab')
        return false
    end

    return true
end

---Checks whether a plant can be placed
---Called every frame while placement is in progress
---@param configIndex string Index of plant in Config.Plants
---@param coords? vector3 Coordinates of the plant
---@param plants? table List of plants already placed
---@return boolean canPlace Whether the plant can be placed
function CanPlacePlant(configIndex, coords, plants)
    return true
end

---Checks whether a booster can be placed
---@param configIndex string Index of booster in Config.Boosters
---@return boolean canPlace Whether the booster can be placed
function CanPlaceBooster(configIndex)
    return true
end

---Checks whether equipment can be removed
---@param data table Data of the equipment
---@return boolean canRemove Whether the equipment can be removed
function CanRemoveEquipment(data)
    return true
end

---Checks whether a plant can be removed
---@param data table Data of the plant
---@return boolean canRemove Whether the plant can be removed
function CanRemovePlant(data)
    return true
end

---Checks whether a booster can be removed
---@param data table Data of the booster
---@return boolean canRemove Whether the booster can be removed
function CanRemoveBooster(data)
    return true
end

---Checks whether equipment can be used
---@param data table Data of the equipment
---@return boolean canUse Whether the equipment can be used
function CanUseEquipment(data)
    return true
end

---Checks whether the plant menu can be opened
---@param data table Data of the plant
---@return boolean canOpen Whether the plant menu can be opened
function CanOpenPlantMenu(data)
    return true
end

---Checks whether a shop can be opened
---@param shopData table Data of the shop
---@return boolean canOpen Whether the shop can be opened
function CanOpenShop(shopData)
    return true
end

---Checks whether a plug drug offer can be accepted
---@param data table {customerId, drugName?, amount?, pricePerUnit?, conversationId?}
---@return boolean canAccept Whether the offer can be accepted
function CanAcceptPlugDrugOffer(data)
    return true
end

---Returns the list of items available in a shop
---@param shopData table Data of the shop
---@return table items List of items available in the shop
function GetShopItems(shopData)
    local items = {}

    for _,item in pairs(shopData.items) do
        items[#items+1] = {
            name = item.name,
            label = Main.GetCachedItemLabel(item.name),
            price = item.price,
            description = item.description,
            image = string.format(Config.ImagePath, item.name)
        }
    end

    return items
end

---Called before the native SetLocalPlayerInvisibleLocally is called
---Edit to add anticheat compatibility or other integrations
function SetPlayerInvisible()

end

---Called after the native SetPlayerVisibleLocally is called
---Edit to add anticheat compatibility or other integrations
function SetPlayerVisible()

end

---Called when a shop ped greeting voice line should be played
---@param shopData table Data of the shop
function PlayShopPedVoiceLine(ped, shopData)
    PlayPedAmbientSpeechNative(ped, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE')
end

---Called when a drug sale is accepted and an acceptance voice line should be played
---@param ped number The ped that players is selling drugs to
function PlayAcceptSaleVoiceLine(ped)

end

---Called when a drug sale is rejected and a rejection voice line should be played
---@param ped number The ped that players is selling drugs to
function PlayRejectSaleVoiceLine(ped)
    PlayPedAmbientSpeechNative(ped, 'Generic_Insult_High', 'Speech_Params_Force')
end

---Called when a drug sale triggers a police alert and an alerting voice line should be played
---@param ped number The ped that players is selling drugs to
function PlayAlertPoliceVoiceLine(ped)
    PlayPedAmbientSpeechNative(ped, 'Generic_Call_911', 'Speech_Params_Force')
end

---Called when the player begins placing equipment, a plant, or a booster
---@param data table Data of the equipment/plant/booster
function StartPlacingEquipment(data)

end

---Called when the player confirms or cancels placement of equipment, a plant, or a booster
---@param data table Data of the equipment/plant/booster
function StopPlacingEquipment(data)

end

---Triggers a police alert for a drug sale
---@param alertData table {coords, title?, code?, priority?, message?, jobs?, blip?}
function AlertPolice(alertData)
    local coords = alertData.coords
    local title = alertData.title or 'Drug Sale'
    local code = alertData.code or '10-58'
    local priority = alertData.priority or 'Priority 3'
    local jobs = alertData.jobs or {'police'}

    if Config.Dispatch == 'tk' then
        exports.tk_dispatch:addCall({
            title = title,
            code = code,
            priority = priority,
            coords = coords,
            showLocation = true,
            showGender = true,
            playSound = true,
            blip = alertData.blip or {
                color = 3,
                sprite = 51,
                scale = 1.0,
            },
            jobs = jobs
        })
    elseif Config.Dispatch == 'cd' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = jobs,
            coords = coords,
            title = title,
            message = alertData.message or title,
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = alertData.blip or {
                sprite = 51,
                scale = 1.2,
                colour = 3,
                flashes = false,
                text = '911 - '..title,
                time = 5,
                radius = 0,
            }
        })
    else
        local streetName,_ = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        streetName = GetStreetNameFromHashKey(streetName)
        local gender = GetGender()

        TriggerServerEvent('tk_drugs:alertPolice', coords, streetName, gender, {
            title = title,
            code = code,
            priority = priority,
            message = alertData.message,
            jobs = jobs,
            blip = alertData.blip,
        })
    end
end

---Calculates the success chance for a drug sale
---@param drugName string name of the drug
---@param amount number amount of the drug
---@return number successChance The success chance for the drug sale
function CalculateSaleSuccessChance(drugName, amount)
    local drugData = Selling.GetDrugData(drugName)
    local baseChance = drugData?.baseChance or 85
    local maxAmount = drugData?.maxAmount or 10

    local minChance = math.max(1, math.floor(baseChance * 0.5))
    local amountFactor = math.min(1, amount / maxAmount)
    local successChance = baseChance + (amountFactor * amountFactor) * (minChance - baseChance)

    return math.max(1, math.floor(successChance))
end

---Called when a custom drug effect is triggered
---@param effectName string name of the custom drug effect
function DoCustomDrugEffect(effectName)

end

---Called when the player consumes a drug
---@param drugName string name of the drug consumed
---@param effects table list of effects from the drug
function DrugConsumed(drugName, effects)

end

---Returns the routing bucket for an object
---@param data table Data of the object
---@return number bucket The routing bucket for the object
function GetObjectBucket(data)
    return data.bucket or 0
end

RegisterNetEvent('tk_drugs:alertPolice', function(coords, street, gender, alertData)
    local blipSettings = (alertData and alertData.blip) or Config.PoliceAlerts.selling.blip

    if blipSettings.playSound then
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end

    local message = alertData and alertData.message
    if message then
        Notify(message:format(gender, street))
    end

    local alpha = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipSettings.sprite)
    SetBlipColour(blip, blipSettings.color)
    SetBlipAlpha(blip, alpha)
    SetBlipScale(blip, blipSettings.scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString((alertData and alertData.title) or 'Drug Sale')
    EndTextCommandSetBlipName(blip)

    while alpha ~= 0 do
        Wait(100)

        alpha -= 1
        SetBlipAlpha(blip, alpha)

        if alpha <= 0 then
            RemoveBlip(blip)
        end
    end
end)