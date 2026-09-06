---@type { [string]: boolean }
local loadedDicts = {}
local phoneModel = Config.PhoneModel or `prop_amb_phone`
local rotation = Config.PhoneRotation or vector3(0.0, 0.0, 180.0)
local offset = Config.PhoneOffset or vector3(0.0, -0.005, 0.0)
local animationsDisabled = false
---@type AnimationAction?
local currentAction
---@type number?
local phoneObject
---@type number?
local phoneVariation
---@type number?
local textureVariation
---@type string?
local oldFrameColor
local playerPed = PlayerPedId()
local playingAnim = false

---@type PhoneAnimationConfig
local defaultAnimations = {
    default = {
        onFoot = {
            open = { dict = "cellphone@", anim = "cellphone_text_in", flag = 2 | 16 | 32 },
            base = { dict = "cellphone@", anim = "cellphone_text_read_base", flag = 2 | 16 | 32 , blendInSpeed = 1000.0, },
            close = { dict = "cellphone@", anim = "cellphone_text_out", flag = 16 | 32 }
        },
        inVehicle = {
            open = { dict = "cellphone@in_car@ds", anim = "cellphone_text_in", flag = 2 | 16 | 32 },
            base = { dict = "cellphone@in_car@ds", anim = "cellphone_text_read_base", flag = 2 | 16 | 32 , blendInSpeed = 1000.0 },
            close = { dict = "cellphone@in_car@ds", anim = "cellphone_text_out", flag = 16 | 32 }
        },
    },
    call = {
        onFoot = {
            open = { dict = "cellphone@", anim = "cellphone_call_in", flag = 2 | 16 | 32 },
            base = { dict = "cellphone@", anim = "cellphone_call_listen_base", flag = 2 | 16 | 32 , },
            close = { dict = "cellphone@", anim = "cellphone_call_out", flag = 16 | 32 }
        },
        inVehicle = {
            open = { dict = "cellphone@in_car@ds", anim = "cellphone_call_in", flag = 2 | 16 | 32 },
            base = { dict = "cellphone@in_car@ds", anim = "cellphone_call_listen_base", flag = 2 | 16 | 32 , },
            close = { dict = "cellphone@in_car@ds", anim = "cellphone_call_out", flag = 16 | 32 }
        },
    },
    camera = {
        onFoot = {
            open = { dict = "cellphone@self", anim = "selfie_in", flag = 2 | 16 | 32 },
            base = { dict = "cellphone@self", anim = "selfie", flag = 2 | 16 | 32 , blendInSpeed = 1000.0, blendOutSpeed = -1000.0, },
            close = { dict = "cellphone@self", anim = "selfie_out", flag = 16 | 32 }
        },
        inVehicle = {
            open = { dict = "cellphone@self", anim = "selfie_in", flag = 2 | 16 | 32 },
            base = { dict = "cellphone@self", anim = "selfie", flag = 2 | 16 | 32 , },
            close = { dict = "cellphone@self", anim = "selfie_out", flag = 16 | 32 }
        },
    }
}

---@type PhoneAnimationConfig
local animationsConfig = PhoneAnimations and Config.AnimationStyle and PhoneAnimations[Config.AnimationStyle] or defaultAnimations

---@param animations PhoneAnimationConfig
local function PatchDefaultAnimations(animations)
    for action, animData in pairs(defaultAnimations) do
        if not animationsConfig[action] then
            animationsConfig[action] = animData
        else
            for key, data in pairs(animData) do
                if not animationsConfig[action][key] then
                    animationsConfig[action][key] = data
                else
                    for subKey, subData in pairs(data) do
                        if not animationsConfig[action][key][subKey] then
                            animationsConfig[action][key][subKey] = subData
                        end
                    end
                end
            end
        end
    end
end

CreateThread(function()
    while not loaded do
        Wait(500)
    end

    phoneModel = Config.PhoneModel or phoneModel

    if not IsModelValid(phoneModel) then
        phoneModel = `prop_amb_phone`
    end
end)

---@param dict string
local function LoadDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end

    loadedDicts[dict] = true

    return dict
end

local disableDoorAnimation = Interval:new(function()
    SetPedResetFlag(playerPed, 58, true)
end, 0, false)

local handleAnimationsInterval = Interval:new(function(self)
    local inVehicle = IsPedInAnyVehicle(playerPed, true)

    if not self.enabled then
        return
    end

    local animData = animationsConfig[currentAction][inVehicle and "inVehicle" or "onFoot"]

    if animData then
        local baseData = animData.base

        if not IsEntityPlayingAnim(playerPed, animData.open.dict, animData.open.anim, 3) and not IsEntityPlayingAnim(playerPed, baseData.dict, baseData.anim, 3) then
            TaskPlayAnim(playerPed, LoadDict(baseData.dict), baseData.anim, baseData.blendInSpeed or 1000.0, baseData.blendOutSpeed or -1000.0, -1, baseData.flag | 8 | 65536 | 1048576, 0, false, false, false)
        end
    end

    if inVehicle then
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if GetVehicleType(vehicle) == "bike" then
            SetEnableHandcuffs(playerPed, true) -- fix animation on bikes
        else
            SetEnableHandcuffs(playerPed, false)
        end
    end
end, 500, false)

function handleAnimationsInterval.onStart()
    debugprint("Started phone animations interval")

    disableDoorAnimation:toggle(true)
end

function handleAnimationsInterval.onStop()
    debugprint("Stopped phone animations interval")

    disableDoorAnimation:toggle(false)
end

function RefreshAnimationsInterval()
    handleAnimationsInterval:toggle(
        (phoneOpen or (IsInCall() and not InExportCall) or IsWalkingCamEnabled())
        and not (cameraOpen and not IsWalkingCamEnabled())
        and currentAction
        and not animationsDisabled
    )
end

-- Handle phone object

---@class AttachPhoneOptions
---@field phone? number # The phone object to attach, if not provided will use the existing phone object
---@field ped? number # If not provided, will use the player ped
---@field variation? number
---@field landscape? boolean # Whether the phone is in landscape mode or not

---@param options? AttachPhoneOptions
function AttachPhone(options)
    local phone = options and options.phone
    local ped = options and options.ped
    local variation = options and options.variation
    local landscape = options and options.landscape

    if not phone then
        if not phoneObject then
            return
        end

        phone = phoneObject
    end

    if not ped then
        ped = PlayerPedId()
        variation = phoneVariation
    end

    local itemData = variation and Config.Item.Names and Config.Item.Names[variation]
    local phoneOffset = itemData and itemData.offset or Config.PhoneOffset or vector3(0.0, -0.005, 0.0)
    local phoneRotation = itemData and itemData.rotation or Config.PhoneRotation or vector3(0.0, 0.0, 180.0)

    if landscape then
        phoneOffset = itemData and itemData.landscapeOffset or Config.LandscapeOffset or vector3(-0.03, -0.005, -0.02)
        phoneRotation = itemData and itemData.landscapeRotation or Config.LandscapeRotation or vector3(0.0, 90.0, 180.0)
    end

    AttachEntityToEntity(
        phone, ped,
        GetPedBoneIndex(ped, 28422),
        phoneOffset.x, phoneOffset.y, phoneOffset.z,
        phoneRotation.x, phoneRotation.y, phoneRotation.z,
        false, false, false, false, 2, true
    )
end

local function CreatePhoneObject()
    if phoneObject and DoesEntityExist(phoneObject) then
        return
    end

    if not IsModelValid(phoneModel) then
        debugprint("phoneModel is not valid")
        return
    end

    if phoneObject then
        DeleteEntity(phoneObject)
    end

    local coords = GetEntityCoords(playerPed, false)

    if Config.PropSpawn == "server" then
        local netId = AwaitCallback("createPhoneObject", phoneModel)

        if not netId then
            debugprint("Failed to create phone object")
            return
        end

        local entity = WaitForNetworkId(netId)

        if not entity then
            debugprint("Failed to get phone object")
            TriggerServerEvent("phone:failedControl")
            return
        end

        if not TakeControlOfEntity(entity) then
            debugprint("Failed to take control of phone object")
            TriggerServerEvent("phone:failedControl")
            return
        end

        phoneObject = entity
    else
        LoadModel(phoneModel)

        local networked = Config.PropSpawn ~= "state"

        phoneObject = CreateObject(phoneModel, coords.x, coords.y, coords.z, networked, true, true)
    end

    if textureVariation then
        SetObjectTextureVariation(phoneObject, textureVariation)
    end

    SetEntityCollision(phoneObject, false, false)
    SetModelAsNoLongerNeeded(phoneModel)
    AttachPhone()

    if Config.PropSpawn ~= "state" then
        TriggerServerEvent("phone:setPhoneObject", NetworkGetNetworkIdFromEntity(phoneObject))
    end
end

local function DeletePhoneObject()
    if not phoneObject then
        return
    end

    DeleteEntity(phoneObject)

    if Config.PropSpawn ~= "state" then
        TriggerServerEvent("phone:setPhoneObject", nil)
    end

    phoneObject = nil
end

---@return number?
function GetPhoneObject()
    return phoneObject
end

---@param action AnimationAction
local function PlayOpenAnim(action)
    local inVehicle = IsPedInAnyVehicle(playerPed, true)
    ---@type PhoneAnimationData
    local animData = animationsConfig[action][inVehicle and "inVehicle" or "onFoot"].open
    local dict = LoadDict(animData.dict)
    local anim = animData.anim
    local flag = animData.flag

    TaskPlayAnim(playerPed, dict, anim, animData.blendInSpeed or 8.0, animData.blendOutSpeed or -8.0, -1, flag | 8 | 32768 | 1048576, 0, false, false, false)

    playingAnim = true

    return GetAnimDuration(dict, anim) * 1000
end

local function CleanUpAssets()
    for dict, loaded in pairs(loadedDicts) do
        if loaded then
            RemoveAnimDict(dict)

            loadedDicts[dict] = nil
        end
    end

    SetModelAsNoLongerNeeded(phoneModel)
end

function PlayCloseAnim()
    if IsInCall() or InExportCall or (not cameraOpen and IsWalkingCamEnabled()) or not currentAction then
        return
    end

    playerPed = PlayerPedId()

    RefreshAnimationsInterval()

    local inVehicle = IsPedInAnyVehicle(playerPed, true)
    ---@type PhoneAnimationData
    local animData = animationsConfig[currentAction][inVehicle and "inVehicle" or "onFoot"].close

    playingAnim = false

    if animData then
        TaskPlayAnim(playerPed, LoadDict(animData.dict), animData.anim, animData.blendInSpeed or 1000.0, animData.blendOutSpeed or -8.0, 950, animData.flag | 65536 | 1048576, 0, false, false, false)
        Wait(300)
    end

    SetEnableHandcuffs(playerPed, false)

    DeletePhoneObject()
    CleanUpAssets()
end

---@param action AnimationAction
function SetPhoneAction(action)
    if (action == currentAction and not phoneOpen) or (action ~= "call" and not phoneOpen) or not animationsConfig[action] or InExportCall then
        return
    end

    playerPed = PlayerPedId()

    if playingAnim then
        currentAction = action
        RefreshAnimationsInterval()
        return
    end

    Citizen.CreateThreadNow(function()
        PlayOpenAnim(action)

        currentAction = action

        Wait(300)
        CreatePhoneObject()
        RefreshAnimationsInterval()
    end)
end

---@param enabled boolean
---@param action? AnimationAction
function TogglePhoneAnimation(enabled, action)
    animationsDisabled = enabled == false

    if enabled then
        SetPhoneAction(action or "default")
    elseif action ~= "camera" then
        PlayCloseAnim()
    end

    RefreshAnimationsInterval()
end

---@param variation number
function SetPhoneVariation(variation)
    local itemData = Config.Item.Names[variation]

    if not itemData then
        infoprint("error", "SetPhoneVariation", "Invalid phone variation: " .. tostring(variation))
        return
    end

    if phoneVariation == variation then
        if itemData.frameColor then
            SendNUIAction("setFrameColor", itemData.frameColor)
            SendNUIAction("updateConfigValue", {
                config = {
                    allowFrameColorChange = false,
                    frameColor = itemData.frameColor
                }
            })
        end

        return
    end

    phoneVariation = variation
    phoneModel = itemData.model or phoneModel
    offset = itemData.offset or Config.PhoneOffset or offset
    rotation = itemData.rotation or Config.PhoneRotation or rotation
    textureVariation = itemData.textureVariation

    debugprint("Set phone variation to " .. variation)
    LocalPlayer.state:set("lbPhoneVariation", variation, true)
    SetResourceKvpInt("phone_variation", variation)

    if itemData.frameColor then
        if settings?.display?.frameColor ~= itemData.frameColor then
            oldFrameColor = settings?.display?.frameColor
        end

        SendNUIAction("setFrameColor", itemData.frameColor)
        SendNUIAction("updateConfigValue", {
            config = {
                allowFrameColorChange = false,
                frameColor = itemData.frameColor
            }
        })
    else
        if oldFrameColor then
            SendNUIAction("setFrameColor", oldFrameColor)
        else
            SendNUIAction("setFrameColor", Config.FrameColor)
        end

        SendNUIAction("updateConfigValue", {
            config = {
                allowFrameColorChange = Config.AllowFrameColorChange,
                frameColor = Config.FrameColor
            }
        })
    end
end

exports("SetPhoneVariation", SetPhoneVariation)

---@type PhoneAnimationConfig
exports("SetAnimations", function(animations)
    animationsConfig = animations

    PatchDefaultAnimations(animationsConfig)
end)

exports("ResetAnimations", function()
    animationsConfig = PhoneAnimations and Config.AnimationStyle and PhoneAnimations[Config.AnimationStyle] or defaultAnimations

    PatchDefaultAnimations(animationsConfig)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        DeletePhoneObject()
    end
end)
