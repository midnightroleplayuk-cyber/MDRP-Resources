local config = require 'qbx_hudcomponents.config'
local disableHudComponents = config.disable.hudComponents
local disableControls = config.disable.controls
local displayAmmo = config.disable.displayAmmo

-- HUD components must be hidden every frame. Using SetHudComponentSize only once can
-- allow GTA/FiveM to restore some components (such as cash/bank) after Alt+Tab.
CreateThread(function()
    while true do
        for i = 1, #disableHudComponents do
            HideHudComponentThisFrame(disableHudComponents[i])
        end

        for i = 1, #disableControls do
            DisableControlAction(2, disableControls[i], true)
        end

        Wait(0)
    end
end)

if config.disable.recticle then
    lib.onCache('weapon', function(weapon)
        if not weapon then return end

        CreateThread(function()
            while cache.weapon ~= weapon do Wait(1) end -- Wait for cache.weapon to update

            while cache.weapon == weapon do
                if not IsFirstPersonAimCamActive() then
                    HideHudComponentThisFrame(14)
                end
                Wait(0)
            end
        end)
    end)
end

local function addDisableHudComponents(hudComponents)
    local hudComponentsType = type(hudComponents)

    if hudComponentsType == 'number' then
        disableHudComponents[#disableHudComponents + 1] = hudComponents
        SetHudComponentSize(hudComponents, 0.0, 0.0)
    elseif hudComponentsType == 'table' and table.type(hudComponents) == 'array' then
        for i = 1, #hudComponents do
            local component = hudComponents[i]
            disableHudComponents[#disableHudComponents + 1] = component
            SetHudComponentSize(component, 0.0, 0.0)
        end
    end
end

---@deprecated use AddDisableHudComponents instead
exports('addDisableHudComponents', addDisableHudComponents)
exports('AddDisableHudComponents', addDisableHudComponents)

local function removeDisableHudComponents(hudComponents)
    local hudComponentsType = type(hudComponents)

    if hudComponentsType == 'number' then
        for i = #disableHudComponents, 1, -1 do
            if disableHudComponents[i] == hudComponents then
                table.remove(disableHudComponents, i)
                ResetHudComponentValues(hudComponents)
                break
            end
        end
    elseif hudComponentsType == 'table' and table.type(hudComponents) == 'array' then
        for i2 = 1, #hudComponents do
            local component = hudComponents[i2]

            for i = #disableHudComponents, 1, -1 do
                if disableHudComponents[i] == component then
                    table.remove(disableHudComponents, i)
                    ResetHudComponentValues(component)
                end
            end
        end
    end
end

---@deprecated use RemoveDisableHudComponents instead
exports('removeDisableHudComponents', removeDisableHudComponents)
exports('RemoveDisableHudComponents', removeDisableHudComponents)

local function getDisableHudComponents()
    return disableHudComponents
end

---@deprecated use GetDisableHudComponents instead
exports('getDisableHudComponents', getDisableHudComponents)
exports('GetDisableHudComponents', getDisableHudComponents)

local function addDisableControls(controls)
    local controlsType = type(controls)

    if controlsType == 'number' then
        disableControls[#disableControls + 1] = controls
    elseif controlsType == 'table' and table.type(controls) == 'array' then
        for i = 1, #controls do
            disableControls[#disableControls + 1] = controls[i]
        end
    end
end

---@deprecated use AddDisableControls instead
exports('addDisableControls', addDisableControls)
exports('AddDisableControls', addDisableControls)

local function removeDisableControls(controls)
    local controlsType = type(controls)

    if controlsType == 'number' then
        for i = #disableControls, 1, -1 do
            if disableControls[i] == controls then
                table.remove(disableControls, i)
                break
            end
        end
    elseif controlsType == 'table' and table.type(controls) == 'array' then
        for i2 = 1, #controls do
            local control = controls[i2]

            for i = #disableControls, 1, -1 do
                if disableControls[i] == control then
                    table.remove(disableControls, i)
                end
            end
        end
    end
end

---@deprecated use RemoveDisableControls instead
exports('removeDisableControls', removeDisableControls)
exports('RemoveDisableControls', removeDisableControls)

local function getDisableControls()
    return disableControls
end

---@deprecated use GetDisableControls instead
exports('getDisableControls', getDisableControls)
exports('GetDisableControls', getDisableControls)

local function setDisplayAmmo(bool)
    displayAmmo = bool
end

---@deprecated use SetDisplayAmmo instead
exports('setDisplayAmmo', setDisplayAmmo)
exports('SetDisplayAmmo', setDisplayAmmo)

local function getDisplayAmmo()
    return displayAmmo
end

---@deprecated use GetDisplayAmmo instead
exports('getDisplayAmmo', getDisplayAmmo)
exports('GetDisplayAmmo', getDisplayAmmo)
