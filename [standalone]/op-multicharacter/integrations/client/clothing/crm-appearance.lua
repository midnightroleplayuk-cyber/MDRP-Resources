if Config.Clothing ~= "crm-appearance" then return end

function applySkinToPed(ped, skin)
    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    local ok, err = pcall(function()
        exports["crm-appearance"]:crm_set_ped_appearance(ped, skin.skin)
    end)
end

function openCreationMenu(isMale)
    Fr.OnPlayerLoadEvents()

    local gender = "male"
    if not isMale then gender = "female" end
    
    Wait(250)
    Config.SwitchHud(false)
    TriggerEvent('crm-appearance:init-new-character', 'crm-'..gender, function()
        Fr.CharacterCreated()
    end) 
end
