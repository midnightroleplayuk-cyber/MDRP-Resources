if GetResourceState('es_extended') == 'started' then return end
if GetResourceState('qb-core') == 'started' then return end

function RegisterUsableItem(...)
    -- Disabled for standalone
end

function ShowNotification(target, text)
	TriggerClientEvent(GetCurrentResourceName()..":showNotification", target, text)
end

function GetIdentifier(source)
    local license = GetPlayerIdentifierByType(source, "license")
    return license
end

function GetPlayerCharacterName(source)
    return GetPlayerName(source)
end

function GetPlayerJob(source)
    return {label = "unknown_job", rank_label = "unknown_grade"}
end

function SetPlayerJob(source, job, grade)
    -- Disabled for standalone
end

function IsPlayerAdmin(source)
    local source = tonumber(source)
    for i=1, #Config.AdminGroups do 
        if IsPlayerAceAllowed(source, Config.AdminGroups[i]) then 
            return true 
        end
    end
    return false
end

function AddSocietyMoney(name, amount)  
    -- Disabled for standalone
end

-- Inventory Fallback

CreateThread(function()
    Wait(100)
    
    if InitializeInventory then return InitializeInventory() end -- Already loaded through inventory folder.
    
    Inventory = {}

    Inventory.Items = {}
    
    Inventory.Ready = false

    Inventory.CanCarryItem = function(source, name, count)
        return true
    end

    Inventory.GetInventory = function(source)
        return {}
    end

    Inventory.UpdateInventory = function(source)
        -- Disabled for standalone
    end

    Inventory.AddItem = function(source, name, count, metadata) -- Metadata is not required.
        -- Disabled for standalone
    end

    Inventory.RemoveItem = function(source, name, count)
        -- Disabled for standalone
    end

    Inventory.AddWeapon = function(source, name, count, metadata) -- Metadata is not required.
        -- Disabled for standalone
    end

    Inventory.RemoveWeapon = function(source, name, count)
        -- Disabled for standalone
    end

    Inventory.GetItemCount = function(source, name)
        return 1 -- Always return 1 for standalone
    end

    Inventory.HasWeapon = function(source, name, count)
        return true -- Always return true for standalone
    end

    Inventory.Items = {}
    Inventory.Ready = true
end)