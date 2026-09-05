if Config.Clothing ~= "4bit_appearance" then return end

function applySkinToPed(ped, skin)
    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    local ok, err = pcall(function()
        exports["4bit_appearance"]:applyAppearanceToPed(ped, skin.skin, true)
    end)
end

function openCreationMenu(isMale)
    local model = isMale and `mp_m_freemode_01` or `mp_f_freemode_01`

    lib.requestModel(model, 30000)
    SetPlayerModel(PlayerId(), model)

    Wait(150)
    SetModelAsNoLongerNeeded(model)

    local playerPed = PlayerPedId()
    SetPedDefaultComponentVariation(playerPed)
    if model == `mp_m_freemode_01` then
        SetPedHeadBlendData(playerPed, 0, 0, 0, 0, 0, 0, 0, 0, 0, false)
    elseif model == `mp_f_freemode_01` then
        SetPedHeadBlendData(playerPed, 45, 21, 0, 20, 15, 0, 0.3, 0.1, 0, false)
    end

    local gender = "male"

    if not isMale then 
        gender = "female"
    end
    
    local result = exports['4bit_appearance']:openShopAwait('4bit_character_creator')
    Fr.CharacterCreated()
end
