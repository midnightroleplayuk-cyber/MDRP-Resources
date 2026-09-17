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
end

function DoProgress(anim)
    local ped = PlayerPedId()

    if doingProgress or IsPedInAnyVehicle(ped, true) or IsEntityDead(ped) then return end
    doingProgress = true

    if anim?.dict and not Utils.LoadDict(anim.dict) then return end

    local duration = anim?.duration or 5000
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

function GetVehicleName(vehModel)
    vehModel = tonumber(vehModel)
    if not vehModel then
        return _U('unknown')
    end

    local makeName = GetMakeNameFromVehicleModel(vehModel)
    local displayName = GetDisplayNameFromVehicleModel(vehModel)

    if not makeName or not displayName then
        return _U('unknown')
    end

    local make = GetLabelText(makeName)
    local model = GetLabelText(displayName)

    --return ('%s %s'):format(make, model)

    return model
end

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

local function GetLongestLineFactor(text)
    local longest = 0

    for line in string.gmatch(text, '([^\n]*)\n?') do
        local length = string.len(line)
        longest = math.max(longest, length)
    end

    return longest / 410
end

function Draw3DText(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)

    local factor = GetLongestLineFactor(text)
    local lineCount = GetLineCount(text)

    DrawRect(0.0, 0.0+0.0125*lineCount, 0.017+factor, 0.03*lineCount, 0, 0, 0, 75)
    ClearDrawOrigin()
end

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

function AddGlobalPlayer(options)
    if not next(options) then
        return
    end

    if Config.Target == 'ox' then
        exports.ox_target:addGlobalPlayer(options)
    else
        local formattedOptions = ConvertTargetOptions(options)
        exports['qb-target']:AddGlobalPlayer(formattedOptions)
    end
end

function RemoveGlobalPlayer(options)
    if Config.Target == 'ox' then
        exports.ox_target:removeGlobalPlayer(options)
    else
        exports['qb-target']:RemoveGlobalPlayer(options)
    end
end

function AddGlobalVehicle(options)
    if not next(options) then
        return
    end

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
        name = options.options[1]?.name or ('zone_' .. tostring(math.random(1000, 9999))),
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

function SetVehicleProperties(vehicle, properties)
    if Config.UseOxLib then
        lib.setVehicleProperties(vehicle, properties)
    elseif Config.Framework == 'esx' then
        ESX.Game.SetVehicleProperties(vehicle, properties)
    elseif Config.Framework == 'qb' then
        QBCore.Functions.SetVehicleProperties(vehicle, properties)
    end
end

function GetVehicleProperties(vehicle)
    if Config.UseOxLib then
        return lib.getVehicleProperties(vehicle)
    elseif Config.Framework == 'esx' then
        return ESX.Game.GetVehicleProperties(vehicle)
    elseif Config.Framework == 'qb' then
        return QBCore.Functions.GetVehicleProperties(vehicle)
    end
end

function RegisterMenu(menu)
    if Config.UseOxLib then
        lib.registerContext(menu)
    else
        Menu.Register(menu)
    end
end

function OpenMenu(menu)
    if Config.UseOxLib then
        lib.showContext(menu)
    else
        Menu.Open(menu)
    end
end

function OpenDialog(title, options)
    if Config.UseOxLib then
        return lib.inputDialog(title, options)
    else
        return Menu.OpenDialog(title, options)
    end
end

function IsVehicleLocked(vehicle)
    return GetVehicleDoorLockStatus(vehicle) == 2
end

local function IsWeapon(item)
    return item and string.upper(string.sub(item, 0, 7)) == 'WEAPON_'
end

local function GetShopItems(items)
    local shopItems = {}
    local grade = GetGradeId()

    for _,v in pairs(items) do
        if not v.grade or grade >= v.grade then
            shopItems[#shopItems + 1] = {
                name = v.name,
                price = v.price,
                amount = v.amount,
                type = IsWeapon(v.name) and 'weapon' or 'item',
                slot = #shopItems+1,
                info = {},
            }
        end
    end

    return shopItems
end

function OpenShop(shopName, shopData)
    if Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('shop', {
            id = 1,
            type = shopName,
        })
    elseif Config.Inventory == 'qs' then
        local shopItems = GetShopItems(shopData.items)

        local shop = {
            label = 'Shop',
            items = shopItems,
            slots = #shopItems
        }

        TriggerServerEvent('inventory:server:OpenInventory', 'shop', shopName, shop)
    elseif Config.Inventory == 'qb_new' then
        local shopItems = GetShopItems(shopData.items)
        shopData.items = shopItems
        TriggerServerEvent('tk_policejob:openShop', shopName, shopData)
    elseif Config.Inventory == 'qb_old' then
        local shopItems = GetShopItems(shopData.items)

        local shop = {
            label = 'Shop',
            items = shopItems,
            slots = #shopItems
        }

        TriggerServerEvent('inventory:server:OpenInventory', 'shop', shopName, shop)
    else
        Shop.Open(shopData)
    end
end

local function RegisterStorage(storageName, storageData)
    local p = promise.new()
    TriggerCallback('tk_policejob:registerStorage', function(success)
        p:resolve(success)
    end, storageName, storageData)
    return Citizen.Await(p)
end

function OpenStorage(storageName, storageData)
    if storageData.type == 'locker' then
        local input = OpenDialog(_U('locker_id'), {_U('locker_id')})
        if not input or not input[1] then return end
        local lockerId = input[1]
        storageName = storageName .. '_' .. lockerId

        if Config.Inventory == 'ox' then
            local success = RegisterStorage(storageName, storageData)
            if not success then
                return
            end
        end
    end

    if Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('stash', storageName)
        return
    end

    if storageData.type == 'personal' then
        storageName = storageName .. '_' .. GetIdentifier()
    end

    if Config.Inventory == 'qs' then
        local stashData = {
            maxweight = storageData.weight or 1000000,
            slots = storageData.slots or 100,
        }

        TriggerServerEvent('inventory:server:OpenInventory', 'stash', storageName, stashData)
        TriggerEvent('inventory:client:SetCurrentStash', storageName)
    elseif Config.Inventory == 'qb_old' then
        TriggerEvent('inventory:client:SetCurrentStash', storageName)
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', storageName, {
            maxweight = storageData.weight or 1000000,
            slots = storageData.slots or 100,
        })
    elseif Config.Inventory == 'qb_new' then
        TriggerServerEvent('tk_policejob:openStorage', storageName, storageData)
    else
        print('[WARNING] Storage not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

function SearchPlayer(targetId)
    if Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('player', targetId)
    elseif Config.Inventory == 'qs' then
        TriggerServerEvent('inventory:server:OpenInventory', 'otherplayer', targetId)
    elseif Config.Inventory == 'qb_new' then
        TriggerServerEvent('tk_policejob:searchPlayer', targetId)
    elseif Config.Inventory == 'qb_old' then
        TriggerServerEvent('inventory:server:OpenInventory', 'otherplayer', targetId)
    else
        print('[WARNING] Inventory not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

function JailPlayer(targetId)
    local input = OpenDialog(_U('jailing'), {_U('jail_time')})
    if not input or not input[1] then return end

    local time = tonumber(input[1])
    if not time or time <= 0 then return end

    if Config.Jail == 'tk' then
        exports.tk_jail:jail(targetId, time)
    else
        print('[WARNING] Jail not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

function SendBill(targetId, amount, reason)
    if Config.Billing == 'esx' then
        TriggerServerEvent('esx_billing:sendBill', targetId, 'society_police', reason, amount)
    elseif Config.Billing == 'qb' then
        TriggerServerEvent('tk_policejob:sendBill', targetId, amount, reason)
    else
        print('[WARNING] Billing not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

function OpenFineMenu(targetId)
    if Config.Billing == 'okok' then
        TriggerEvent('okokBilling:ToggleCreateInvoice')
        return
    end

    Fining.OpenMenu(targetId)
end

function SendVehicleToImpound(vehicle)
    local input = OpenDialog(_U('impound'), {_U('impound_time_input'), _U('impound_price_input')})
    if not input or tonumber(input[1]) <= 0 or tonumber(input[2]) <= 0 then
        Notify(_U('invalid_values'), 'error')
        return
    end

    local time = tonumber(input[1])
    local price = tonumber(input[2])

    local success = DoProgress({
        duration = 5000,
        dict = 'random@arrests',
        name = 'generic_radio_chatter',
    })

    if not success then return end

    if not Impound.CanImpound(vehicle) then
        Notify(_U('impound_failed'), 'error')
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

    DeleteEntity(vehicle)
    TriggerServerEvent('tk_policejob:impoundVehicle', plate, vehName, 60*time, price)
    Notify(_U('impound_success', vehName, plate, time, price), 'success')
end

local function OpenClothingShop()
    if Config.Clothing == 'illenium' then
        TriggerEvent('illenium-appearance:client:openClothingShopMenu')
    elseif Config.Clothing == 'qb' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    elseif Config.Clothing == 'op' then
        local opts = {}
        TriggerEvent('op-clothing:client:openCharacterCreator', opts)
    end

end

function OpenWardrobe(stationIndex)
    local mainMenuOptions = {
        {
            title = _U('saved_outfits'),
            icon = 'fas fa-tshirt',
            onSelect = function()
                Clothing.OpenSavedOutfitsMenu(stationIndex)
            end
        },
        {
            title = _U('clothing_shop'),
            icon = 'fas fa-shopping-bag',
            onSelect = function()
                OpenClothingShop()
            end
        }
    }

    RegisterMenu({
        id = 'clothing_main',
        title = _U('clothing_menu'),
        options = mainMenuOptions
    })

    OpenMenu('clothing_main')
end

function OpenBossMenu()
    if Config.Bossmenu == 'tk' then
        exports.tk_bosstablet:openBossMenu()
    elseif Config.Bossmenu == 'esx' then
        local society = GetJobName()
        TriggerEvent('esx_society:openBossMenu', society, function(menu)
            ESX.CloseContext()
        end, {wash = false})
    elseif Config.Bossmenu == 'qb' then
        TriggerEvent('qb-bossmenu:client:OpenMenu')
    else
        print('[WARNING] Boss menu not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

function ToggleDuty()
    if Config.Framework == 'qb' then
        TriggerServerEvent('QBCore:ToggleDuty')
    elseif Config.Framework == 'esx' and GetResourceState('esx_service') == 'started' then
        local jobName = GetJobName()
        ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
            if isInService then
                TriggerServerEvent('esx_service:disableService', jobName)
            else
                ESX.TriggerServerCallback('esx_service:enableService', function() end, jobName)
            end
        end)
    else
        print('[WARNING] Duty toggle not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

function GetAlcoholLevel()
    --[[ local p = promise.new()
    TriggerEvent('esx_status:getStatus', 'drunk', function(status)
        p:resolve(status?.val or 0.0)
    end)
    return Citizen.Await(p) ]]

    print('[WARNING] Get alcohol level function not edited, returning default value (0.13)!\nYou can edit "GetAlcoholLevel" in client/main_editable.lua to fix this')
    return 0.13
end

---Called after all other checks for cuffing are done
---@param targetId number the target player id
---@return boolean canHandcuff whether the player can handcuff the target
function CanHandcuff(targetId)
    return true
end

---Called when player is cuffed or uncuffed
---@param toggle boolean true if cuffed, false if uncuffed
function TogglePlayerCuffs(toggle)
    if Config.Inventory == 'ox' then
        LocalPlayer.state:set('invBusy', toggle, true)
    elseif Config.Inventory == 'qb_new' or Config.Inventory == 'qb_old' then
        LocalPlayer.state:set('inv_busy', toggle, true)
    end

    -- ladder climbing
    SetPedConfigFlag(PlayerPedId(), 146, toggle)
end

function DoCuffingMinigame()
    if GetResourceState('bl_ui') ~= 'started' then
        return false
    end

    return exports.bl_ui:Progress(1, 91)
end

function DoCuffLockpickMinigame()
    if GetResourceState('bl_ui') ~= 'started' then
        print('[WARNING] Minigame script (bl_ui) not found on server, handcuff lockpicking will not work')
        return false
    end

    return exports.bl_ui:RapidLines(3, 75, 3)
end

function GenerateVehiclePlate(vehicle)
    return 'LSPD' .. math.random(1000, 9999)
end

function GetRadarVehiclePlate(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

---@param vehicle number the vehicle entity
---@return boolean isPoliceVehicle whether the vehicle is a police vehicle
function IsPoliceVehicle(vehicle)
    if GetVehicleClass(vehicle) == 18 then
        return true
    end

    return Entity(vehicle).state.isPoliceVehicle
end

---Called when a vehicle is spawned by police garage
---@param vehicle number the vehicle entity
function SpawnedGarageVehicle(vehicle)

end

---Called when a vehicle is spawned by police impound
---@param vehicle number the vehicle entity
function SpawnedImpoundVehicle(vehicle)

end

---Called when a vehicle is returned to the garage
---@param vehicle number the vehicle entity
function VehicleReturned(vehicle)

end

---@class VehicleData
---@field label string the vehicle label
---@field model string the vehicle model
---@field price number the vehicle price

---Players tries to purchase a vehicle from garage
---@param vehicle VehicleData the vehicle data
---@return boolean canPurchase if player can purchase the vehicle, false if not
function CanPurchaseVehicle(vehicle)
    return true
end

---@param vehicle VehicleData the vehicle data
---@return boolean canSee whether the player can see the vehicle
function CanSeeGarageVehicle(vehicle)
    return true
end

---@param itemData table the item data
---@param shopData table the shop data
---@return boolean canPurchase whether the player can purchase the item
function CanPurchaseItem(itemData, shopData)
    return true
end

function IsHandsUp(targetId)
    local playerIndex = GetPlayerFromServerId(targetId)
    local targetPed = GetPlayerPed(playerIndex)

    local handsUp = IsEntityPlayingAnim(targetPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(targetPed, 'missminuteman_1ig_2', 'handsup_enter', 3)
    Utils.Debug('IsHandsUp', targetId, handsUp)
    return handsUp
end

---@param targetPed number the target ped
---@return boolean canTackle whether the target ped can be tackled
function CanTacklePed(targetPed)
    return true
end

---@param spikeStrip number the spike strip entity
---@return boolean isValid whether the spike strip is valid
function IsValidSpikeStrip(spikeStrip)
    return IsEntityVisible(spikeStrip)
end

function ApplyBlipSettings(blip, blipType, targetId)
    local config = Config.Blips[blipType]
    if not config then return end

    SetBlipSprite(blip, config.sprite)
    SetBlipDisplay(blip, config.display)
    SetBlipScale(blip, config.scale)
    SetBlipColour(blip, config.color)
    SetBlipCategory(blip, config.category)
    SetBlipAsShortRange(blip, config.shortRange)

    if config.cone then
        SetBlipShowCone(blip, true)
    end

    if config.indicator then
        ShowHeadingIndicatorOnBlip(blip, true)
    end
end

---@param cameraType 'bodycam' | 'dashcam'
function ViewCamera(cameraType)

end

---@param cameraType 'bodycam' | 'dashcam'
function StopViewingCamera(cameraType)

end

RegisterCommand('tracker', function()
    if not Utils.IsPolice() then
        Notify(_U('not_police'))
        return
    end

    if Tracker.IsActive() then
        Tracker.Deactivate()
    else
        Tracker.Activate()
    end
end, false)