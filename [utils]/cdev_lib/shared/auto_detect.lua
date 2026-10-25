--[[
    Auto-detection for Framework, Target and Inventory when set to "auto".
    Only overrides the options that are literally "auto"; others are left as in config.
    When Debug is true, prints what was detected to the console.
]]

if not PublicSharedConfig then
    return
end

local function resourceStarted(name)
    local state = GetResourceState(name)
    return state == "started" or state == "starting"
end

local resourceName = GetCurrentResourceName()
local debugMode = PublicSharedConfig.Debug
local detectedFramework, detectedTarget, detectedInventory
local frameworkSource, targetSource, inventorySource

-- Framework (only if set to "auto")
-- Detection order: qbx_core (Qbox) first, then qb-core (QBCore), then es_extended (ESX).
-- Qbox uses same API as QBCore; we set PublicQBCoreConfig.ResourceName so config_init loads the correct resource.
if PublicSharedConfig.Framework == "auto" then
    if resourceStarted("qbx_core") then
        PublicSharedConfig.Framework = "qbcore"
        detectedFramework = "qbox"
        frameworkSource = "qbx_core"
        -- Do NOT set ResourceName to "qbx_core": QBX uses provide 'qb-core' and registers
        -- GetCoreObject under that name, so config must keep ResourceName = "qb-core".
    elseif resourceStarted("qb-core") then
        PublicSharedConfig.Framework = "qbcore"
        detectedFramework = "qbcore"
        frameworkSource = "qb-core"
    elseif resourceStarted("es_extended") then
        PublicSharedConfig.Framework = "esx"
        detectedFramework = "esx"
        frameworkSource = "es_extended"
    else
        PublicSharedConfig.Framework = "custom"
        if debugMode then
            print("^0[" .. resourceName .. "]^7   ^3Framework:^7 auto - none detected, using ^7custom^7")
        end
    end
end

-- Target (only if set to "auto")
if PublicSharedConfig.Target == "auto" then
    if resourceStarted("qb-target") then
        PublicSharedConfig.Target = "qbcore"
        detectedTarget = "qbcore"
        targetSource = "qb-target"
    elseif resourceStarted("ox_target") then
        PublicSharedConfig.Target = "ox"
        detectedTarget = "ox"
        targetSource = "ox_target"
    elseif resourceStarted("qtarget") then
        PublicSharedConfig.Target = "qtarget"
        detectedTarget = "qtarget"
        targetSource = "qtarget"
    else
        PublicSharedConfig.Target = "custom"
        if debugMode then
            print("^0[" .. resourceName .. "]^7   ^3Target:^7 auto - none detected, using ^7custom^7")
        end
    end
end

-- Inventory (only if set to "auto")
if PublicSharedConfig.Inventory == "auto" then
    if resourceStarted("qb-inventory") then
        PublicSharedConfig.Inventory = "qbcore"
        detectedInventory = "qbcore"
        inventorySource = "qb-inventory"
    elseif resourceStarted("ox_inventory") then
        PublicSharedConfig.Inventory = "ox"
        detectedInventory = "ox"
        inventorySource = "ox_inventory"
    else
        PublicSharedConfig.Inventory = "custom"
        if debugMode then
            print("^0[" .. resourceName .. "]^7   ^3Inventory:^7 auto - none detected, using ^7custom^7")
        end
    end
end

if debugMode and (detectedFramework or detectedTarget or detectedInventory) then
    print("^0[" .. resourceName .. "]^7 ^2(DEBUG) Auto-detection:^7")
    if detectedFramework then
        print("^0[" .. resourceName .. "]^7   ^2Framework:^7 " .. detectedFramework .. " ^8(resource: " .. tostring(frameworkSource) .. ")^7")
    end
    if detectedTarget then
        print("^0[" .. resourceName .. "]^7   ^2Target:^7 " .. detectedTarget .. " ^8(resource: " .. tostring(targetSource) .. ")^7")
    end
    if detectedInventory then
        print("^0[" .. resourceName .. "]^7   ^2Inventory:^7 " .. detectedInventory .. " ^8(resource: " .. tostring(inventorySource) .. ")^7")
    end
end
