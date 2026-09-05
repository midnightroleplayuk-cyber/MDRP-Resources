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

    anim = type(anim) == 'table' and anim[math.random(#anim)] or anim

    if anim?.dict and not Utils.LoadDict(anim.dict) then return end

    duration = anim?.duration or 5000
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
        if c == '\n' then
            lines += 1
        end
    end

    return lines
end

local function GetLongestLineFactor(text)
    local longest = 0

    for line in string.gmatch(text, "([^\n]*)\n?") do
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

function GetPlayerItems()
    if Config.Inventory == 'ox' then
        return exports.ox_inventory:GetPlayerItems()
    elseif Config.Inventory == 'qs' then
        return exports['qs-inventory']:getUserInventory()
    elseif Config.Framework == 'qb' then
        return QBCore.Functions.GetPlayerData().items
    end
end

---Called when checking if the player can leave evidence
---@param evidenceType string type of evidence
---@param evidenceCoords vector3 coordinates of the evidence
---@param weaponName? string name of the weapon the player is holding
---@return boolean canLeave whether the player can leave evidence or not
function CanLeaveEvidence(evidenceType, evidenceCoords, weaponName)
    return true
end

---Called when saving GSR on player
---@param weaponHash number hash of the weapon player is holding
---@return boolean canSave whether the GSR can be saved or not
function CanSaveGSR(weaponHash) -- called when saving GSR on player
    return true
end

---Called when checking if the player can see evidence
---@return boolean canSee whether the player can see evidence or not
function CanSeeEvidence()
    return true
end

---Called when checking if the player can see the collect option
---@return boolean canSee whether the player can see the collect option or not
function CanSeeCollectOption()
    return true
end

---Called when checking if the player can see the remove option
---@return boolean canSee whether the player can see the remove option or not
function CanSeeRemoveOption()
    return true
end

---Called when player tries to collect evidence
---@param evidenceData table data of the evidence
---@return boolean canCollect whether the player can collect evidence or not
function CanCollectEvidence(evidenceData)
    return true
end

---Called when player collects evidence
---@param evidence table data of the evidence
function EvidenceCollected(evidence)

end

---Checks if the player has gloves on
---@return boolean hasGloves whether the player has gloves on or not
function HasGloves(ped)
    ped = ped or PlayerPedId()
    local noGloves = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
    local drawable = GetPedDrawableVariation(ped, 3)

    for _,v in pairs(noGloves) do
        if drawable == v then
            return false
        end
    end

    return true
end