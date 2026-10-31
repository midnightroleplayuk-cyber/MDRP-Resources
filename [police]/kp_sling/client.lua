local weaponConfig = {}
local attachedProps = {}
local warnedModels = {}
local reconcileRequested = false
local reconciling = false
local currentPed

local function debugPrint(message)
    if Config.Debug then
        print(('[kp_sling] %s'):format(message))
    end
end

local function normalizeItemName(name)
    if type(name) ~= 'string' then return nil end
    return string.upper(name)
end

for i = 1, #Config.Weapons do
    local weapon = Config.Weapons[i]
    local itemName = normalizeItemName(weapon.item)

    if itemName and type(weapon.model) == 'string' then
        weaponConfig[itemName] = {
            model = joaat(weapon.model),
            position = weapon.position or Config.Attachments.position,
            rotation = weapon.rotation or Config.Attachments.rotation,
            bone = weapon.bone or Config.Attachments.bone,
        }
    else
        print(('[kp_sling] Invalid weapon configuration at index %s.'):format(i))
    end
end

local function deleteProp(slot)
    local prop = attachedProps[slot]

    if prop then
        if DoesEntityExist(prop.entity) then
            DeleteEntity(prop.entity)
        end

        attachedProps[slot] = nil
    end
end

local function clearProps()
    for slot in pairs(attachedProps) do
        deleteProp(slot)
    end
end

local function requestWeaponModel(model)
    if not IsModelInCdimage(model) or not IsModelValid(model) then
        if not warnedModels[model] then
            warnedModels[model] = true
            print(('[kp_sling] Configured prop model %s is not a valid model.'):format(model))
        end

        return false
    end

    if HasModelLoaded(model) then return true end

    RequestModel(model)
    local deadline = GetGameTimer() + Config.ModelLoadTimeout

    while not HasModelLoaded(model) and GetGameTimer() < deadline do
        Wait(0)
    end

    if not HasModelLoaded(model) then
        if not warnedModels[model] then
            warnedModels[model] = true
            print(('[kp_sling] Timed out loading configured prop model %s.'):format(model))
        end

        return false
    end

    return true
end

local function createProp(slot, itemName, weapon, ped)
    if not requestWeaponModel(weapon.model) then return end

    local coords = GetEntityCoords(ped)
    local entity = CreateObject(
        weapon.model,
        coords.x, coords.y, coords.z,
        Config.NetworkedProps, true, false
    )

    SetModelAsNoLongerNeeded(weapon.model)

    if entity == 0 then
        if not warnedModels[weapon.model] then
            warnedModels[weapon.model] = true
            print(('[kp_sling] Failed to create the prop for %s.'):format(itemName))
        end

        return
    end

    SetEntityAsMissionEntity(entity, true, true)
    SetEntityCollision(entity, Config.PropCollision, Config.PropCollision)
    SetEntityHasGravity(entity, Config.PropGravity)

    local boneIndex = GetPedBoneIndex(ped, weapon.bone)
    local position = weapon.position
    local rotation = weapon.rotation

    AttachEntityToEntity(
        entity,
        ped,
        boneIndex,
        position.x, position.y, position.z,
        rotation.x, rotation.y, rotation.z,
        false, false, false, false, 2, true
    )

    attachedProps[slot] = {
        entity = entity,
        item = itemName,
        model = weapon.model,
    }
    debugPrint(('Attached %s from inventory slot %s.'):format(itemName, slot))
end

local function reconcile()
    if not Config.Enabled then
        clearProps()
        return
    end

    local inventory = exports.ox_inventory:GetPlayerItems()

    if type(inventory) ~= 'table' then return end

    local ped = PlayerPedId()

    if not DoesEntityExist(ped) then return end

    if currentPed and currentPed ~= ped then
        clearProps()
    end

    currentPed = ped

    local equipped = exports.ox_inventory:getCurrentWeapon()
    local desiredProps = {}

    for slot, item in pairs(inventory) do
        local itemName = item and normalizeItemName(item.name)
        local weapon = itemName and weaponConfig[itemName]
        local isEquipped = equipped and (
            (equipped.slot and equipped.slot == slot)
            or (not equipped.slot and normalizeItemName(equipped.name) == itemName)
        )

        if weapon
            and (item.count or 0) > 0
            and (not Config.HideEquippedWeapon or not isEquipped)
        then
            desiredProps[slot] = { item = itemName, weapon = weapon }
        end
    end

    for slot, prop in pairs(attachedProps) do
        local desired = desiredProps[slot]

        if not desired
            or desired.item ~= prop.item
            or desired.weapon.model ~= prop.model
            or not DoesEntityExist(prop.entity)
        then
            debugPrint(('Removed prop for inventory slot %s.'):format(slot))
            deleteProp(slot)
        end
    end

    for slot, desired in pairs(desiredProps) do
        if not attachedProps[slot] then
            createProp(slot, desired.item, desired.weapon, ped)
        elseif not IsEntityAttachedToEntity(attachedProps[slot].entity, ped) then
            local position = desired.weapon.position
            local rotation = desired.weapon.rotation

            AttachEntityToEntity(
                attachedProps[slot].entity,
                ped,
                GetPedBoneIndex(ped, desired.weapon.bone),
                position.x, position.y, position.z,
                rotation.x, rotation.y, rotation.z,
                false, false, false, false, 2, true
            )
        end
    end
end

local function scheduleReconcile()
    reconcileRequested = true

    if reconciling then return end

    reconciling = true

    CreateThread(function()
        while reconcileRequested do
            reconcileRequested = false
            reconcile()
        end

        reconciling = false
    end)
end

AddEventHandler('ox_inventory:updateInventory', scheduleReconcile)
AddEventHandler('ox_inventory:currentWeapon', scheduleReconcile)

CreateThread(function()
    while GetResourceState('ox_inventory') ~= 'started' do
        Wait(500)
    end

    while type(exports.ox_inventory:GetPlayerItems()) ~= 'table' do
        Wait(500)
    end

    scheduleReconcile()

    while true do
        Wait(Config.PollInterval)
        scheduleReconcile()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        clearProps()
    end
end)
