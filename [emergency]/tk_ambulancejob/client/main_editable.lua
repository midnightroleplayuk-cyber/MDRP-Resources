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
    local controls = not anim?.allowControls and {20, 21, 30, 31, 32, 33, 34, 35, 24, 48, 257, 25, 263, 22, 44, 37, 288, 289, 170, 167, 318, 137, 36, 47, 264, 257, 266, 267, 268, 269, 140, 141, 142, 143, 75, 73} or {}

    local obj, ptfx

    if anim?.prop?.model then
        if not Utils.LoadModel(anim.prop.model) then return end

        local pos = anim.prop.pos or vec3(0.0, 0.0, 0.0)
        local rot = anim.prop.rot or vec3(0.0, 0.0, 0.0)

        local pC = GetEntityCoords(ped)
        obj = CreateObject(anim.prop.model, pC.x, pC.y, pC.z + 0.2, true, true, true)
        AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, anim.prop.bone or 60309), pos, rot, true, true, false, true, 1, true)
    end

    if anim?.ptfx?.name then
        if not Utils.LoadPtfx(anim.ptfx.asset) then return end

        local offset = anim.ptfx.offset or vec3(0.0, 0.0, 0.0)
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
            title = _U('notify'),
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

function SendDistressSignal(coords)
    if Config.Dispatch == 'tk' then
        exports.tk_dispatch:addCall({
            title = 'Distress Signal',
            code = '10-61',
            priority = 'Priority 1',
            coords = coords,
            showLocation = true,
            showGender = true,
            playSound = true,
            blip = {
                color = 1,
                sprite = 303,
                scale = 1.0,
            },
            jobs = {'ambulance'}
        })
    elseif Config.Dispatch == 'cd' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'ambulance'},
            coords = coords,
            title = 'Distress Signal',
            message = 'A '..data.sex..' needs help',
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 303,
                scale = 1.2,
                colour = 1,
                flashes = false,
                text = '911 - Distress Signal',
                time = 5,
                radius = 0,
            }
        })
    else
        local streetName,_ = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        streetName = GetStreetNameFromHashKey(streetName)
        local gender = GetGender()

        TriggerServerEvent('tk_ambulancejob:sendDistressSignal', coords, streetName, gender)
    end
end

RegisterNetEvent('tk_ambulancejob:sendDistressSignal', function(coords, street, gender)
    local blipSettings = Config.DistressSignal.blip

    if blipSettings.playSound then
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end

    Notify(_U('distress_signal', _U(gender), street))

    local alpha = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipSettings.sprite)
    SetBlipColour(blip, blipSettings.color)
    SetBlipAlpha(blip, alpha)
    SetBlipScale(blip, blipSettings.scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('distress_signal_title'))
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
        TriggerServerEvent('tk_ambulancejob:openShop', shopName, shopData)
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
    TriggerCallback('tk_ambulancejob:registerStorage', function(success)
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
        TriggerServerEvent('tk_ambulancejob:openStorage', storageName, storageData)
    else
        Utils.Warning('Storage not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

function SendBill(targetId, amount, reason)
    if Config.Billing == 'esx' then
        TriggerServerEvent('esx_billing:sendBill', targetId, 'society_ambulance', reason, amount)
    elseif Config.Billing == 'qb' then
        TriggerServerEvent('tk_ambulancejob:sendBill', targetId, amount, reason)
    else
        Utils.Warning('Billing not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end

    Notify(_U('bill_sent', reason, amount), 'success')
end

function OpenBillingMenu(targetId)
    if Config.Billing == 'okok' then
        TriggerEvent('okokBilling:ToggleCreateInvoice')
        return
    end

    Billing.OpenMenu(targetId)
end

local function OpenClothingShop()
    if Config.Clothing == 'illenium' then
        TriggerEvent('op-clothing:client:openCharacterCreator', opts)
    elseif Config.Clothing == 'qb' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    end
end

function OpenWardrobe(hospital)
    local mainMenuOptions = {
        {
            title = _U('saved_outfits'),
            icon = 'fas fa-tshirt',
            onSelect = function()
                Clothing.OpenSavedOutfitsMenu(hospital)
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
        Utils.Warning('Boss menu not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

function ToggleDuty()
    if Config.Framework == 'qb' then
        TriggerServerEvent('QBCore:ToggleDuty')
    else
        Utils.Warning('Duty toggle not set correctly in config!\nIf your script is not listed in config, you will have to add support for it yourself in client/main_editable.lua')
    end
end

---@param targetId? number id of the target (nil if opening own skeletal)
---@return boolean canOpen whether the skeletal menu can be opened 
function CanOpenSkeletal(targetId)
    return true
end

---@param bedId string|number the bed index in Config.Beds
---@return boolean canInteract whether the player can interact with the bed
function CanInteractWithBed(bedId)
    return true
end

---Called when a player is damaged, if this function returns false, the damage will not be applied to skeletal
---@param damager number the entity that damaged the player
---@param damageConverted number the damage caused
---@param weaponHash number the weapon hash
---@return boolean canGetDamaged whether the player can get damaged
function CanGetDamaged(damager, damageConverted, weaponHash)
    return true
end

---@param itemName string the name of the item
---@param bodyPartName string the body part name
---@param targetId? number id of the target (nil if using on self)
---@return boolean canUse whether the healing item can be used
function CanUseHealingItem(itemName, bodyPartName, targetId)
    return true
end

---@param bodyPartName string the body part name
---@param injuryType string the injury type
---@param cause number|string the cause of the injury (weapon hash or cause name like 'fall', 'vehicle_impact')
---@return boolean isLastStandInjury whether the injury should cause player to go into last stand (by default player goes into last stand from all injuries)
function IsLastStandInjury(bodyPartName, injuryType, cause)
    return true
end

---Called before last stand/death logic is done, if this function returns false, the internal death logic of the script will not be applied (doesn't affect normal GTA death logic)
---@param deathType 'last_stand' | 'death' the death type
function CanDie(deathType)
    return true
end

---Called every frame before the last stand / death animation is (re)applied to the player, if this function returns false the animation will not be forced
---@return boolean canPlayDeathAnimation whether the last stand / death animation should be (re)applied
function CanPlayDeathAnimation()
    return true
end

---Determines the location where player will respawn
---@return table|nil location the respawn location data
function GetRespawnLocation()
    local ped = PlayerPedId()
    local pC = GetEntityCoords(ped)

    local closestLocation = nil
    local closestDistance = math.huge

    for _, location in ipairs(Config.Respawn.locations) do
        local distance = #(pC - location.coords.xyz)
        if distance < closestDistance then
            closestDistance = distance
            closestLocation = location
        end
    end

    return closestLocation
end

---Called after revive animation is played and the success of the revive is rolled (so if player already doesn't successfully revive, this function is not called at all)
---@param targetId number the target player id
---@param targetBodyParts table the target body parts
---@param reviveOption number revive option index in Config.ReviveOptions
---@return boolean canRevive whether the player can be revived
function CanRevive(targetId, targetBodyParts, reviveOption)
    return true
end

---Called when a player goes into last stand
function PlayerLastStand()

end

---Called when a player dies
function PlayerDied()

end

---Player is dragging another player, called every frame
---@param targetId number target server id
function DraggingPlayer(targetId)
    local ped = PlayerPedId()
    local dict, name = 'amb@world_human_drinking@coffee@male@base', 'base'

    if not IsEntityPlayingAnim(ped, dict, name, 3) then
        TaskPlayAnim(ped, dict, name, 16.0, 16.0, -1, 50)
    end
end

---Player is being dragged by another player, called every frame
function PlayerBeingDragged()

end

-- Called when a player is revived
function PlayerRevived()
    if GetResourceState('esx_status') == 'started' then
        TriggerEvent("esx_status:set", 'hunger', 1000000)
        TriggerEvent("esx_status:set", 'thirst', 1000000)
        TriggerEvent("esx_status:set", 'stress', 0)
    end
end

function GenerateVehiclePlate(vehicle)
    return 'EMS' .. math.random(1000, 9999)
end

---@param vehicle number the vehicle entity
---@return boolean isEMSVehicle whether the vehicle is a EMS vehicle
function IsEMSVehicle(vehicle)
    return Entity(vehicle).state.isEMSVehicle
end

---Called when a vehicle is spawned by EMS garage
---@param vehicle number the vehicle entity
function SpawnedGarageVehicle(vehicle)

end

---Called when a vehicle is returned to EMS garage
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

---@param wheelchair number the wheelchair entity
function WheelchairSpawned(wheelchair)

end

function IsHandsUp(targetId)
    local playerIndex = GetPlayerFromServerId(targetId)
    local targetPed = GetPlayerPed(playerIndex)

    return IsEntityPlayingAnim(targetPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(targetPed, 'missminuteman_1ig_2', 'handsup_enter', 3)
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

AddEventHandler('gameEventTriggered', function(name, args)
    if name ~= 'CEventNetworkEntityDamage' then
        return
    end

    SkeletalDamage.HandleDamageEvent(args)
end)

RegisterCommand('tracker', function()
    if not Utils.IsEMS() then
        Notify(_U('not_ems'))
        return
    end

    if Tracker.IsActive() then
        Tracker.Deactivate()
    else
        Tracker.Activate()
    end
end, false)

if Config.Skeletal == 'menu' or Config.Skeletal == 'both' then
    RegisterCommand('skeletalmenu', function(source, args, raw)
        SkeletalUtils.OpenSkeletalMenu(PlayerPedId())
    end, false)

    RegisterCommand('skeletalmenuother', function(source, args, raw)
        local closestPlayer = Utils.GetClosestPlayer()
        if not closestPlayer or closestPlayer == -1 then
            Notify(_U('no_players_nearby'), 'error')
            return
        end

        local targetPed = GetPlayerPed(closestPlayer)
        SkeletalUtils.OpenSkeletalMenu(targetPed)
    end, false)
end

if Config.Skeletal == 'cam' or Config.Skeletal == 'both' then
    RegisterCommand('skeletalcam', function(source, args, raw)
        SkeletalCam.Open(PlayerPedId())
    end, false)

    RegisterCommand('skeletalcamother', function(source, args, raw)
        local closestPlayer = Utils.GetClosestPlayer()
        if not closestPlayer or closestPlayer == -1 then
            Notify(_U('no_players_nearby'), 'error')
            return
        end

        local targetPed = GetPlayerPed(closestPlayer)
        SkeletalCam.Open(targetPed)
    end, false)
end

if Config.Keybinds.skeletal then
    local command = Config.Skeletal == 'cam' and 'skeletalcam' or 'skeletalmenu'
    RegisterKeyMapping(command, 'Skeletal', 'keyboard', Config.Keybinds.skeletal)
end

RegisterNetEvent('tk_ambulancejob:onPlayerRevive', function()
    if GetResourceState('qb-core') ~= 'started' then return end

    TriggerEvent('hud:client:UpdateNeeds', 100, 100)
    TriggerEvent('qb-hud:client:UpdateNeeds', 100, 100)
end)
