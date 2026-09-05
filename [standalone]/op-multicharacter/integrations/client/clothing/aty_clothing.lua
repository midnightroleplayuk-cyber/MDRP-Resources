if Config.Clothing ~= "aty_clothing" then return end

function applySkinToPed(ped, skin)
    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    local ok, err = pcall(function()
        -- Apply complete skin to ped
        exports['aty_clothing']:setPedSkin(ped, skin.skin, true)
    end)
end

function openCreationMenu(isMale)
    DoScreenFadeOut(0)
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

    --exports['aty_clothing']:OpenClothingMenu("creator", { title = "Character Creator" })

    TriggerEvent('esx_skin:openSaveableMenu', function()
        Fr.CharacterCreated()
    end, function()
        Fr.CharacterCreated()
    end)
end
