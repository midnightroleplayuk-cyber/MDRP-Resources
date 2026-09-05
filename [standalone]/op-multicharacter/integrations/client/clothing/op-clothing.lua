if Config.Clothing ~= "op-clothing" then return end

function applySkinToPed(ped, skin)
    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    local ok, err = pcall(function()
        exports['op-clothing']:SetPedSkin(ped, skin.skin)
    end)
end

--- Re-fetch newest active skin after Qbox finishes the real player ped.
function reapplySavedAppearance()
    if isInsideNew then return end

    local ok, data = pcall(function()
        return lib.callback.await("op-multicharacter:getActiveSkin", false)
    end)
    if not ok or type(data) ~= "table" or type(data.skin) ~= "table" then return end

    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    if data.model and GetEntityModel(ped) ~= joaat(data.model) then
        local modelHash = type(safeRequestModel) == "function" and safeRequestModel(data.model) or nil
        if modelHash then
            SetPlayerModel(PlayerId(), modelHash)
            SetPedDefaultComponentVariation(PlayerPedId())
            SetModelAsNoLongerNeeded(modelHash)
            ped = PlayerPedId()
            Wait(100)
        end
    end

    applySkinToPed(ped, data)
end

local function revealWorldForClothingCreator()
    -- Multichar may still have NUI blackscreen / music chrome / faded native screen
    -- from the identity → clothing TP. op-clothing UI is transparent in the center,
    -- so any leftover overlay looks like a permanent black void behind the ped.
    if OPMC and type(OPMC.endCharMenuSession) == "function" then
        OPMC.endCharMenuSession()
    else
        SendNUIMessage({ action = "setCharMenuSession", data = false })
    end

    SendNUIMessage({ action = "setBlackScreen", data = false })
    SendNUIMessage({ action = "setloadervisible", data = false })
    SendNUIMessage({ action = "setCreatorMenuVisible", data = false })
    SendNUIMessage({ action = "setCharacterVisible", data = false })
    SendNUIMessage({ action = "setcharVisible", data = false })

    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        FreezeEntityPosition(playerPed, false)
        SetEntityCollision(playerPed, true, true)
        SetEntityVisible(playerPed, true, false)
        SetEntityInvincible(playerPed, false)
        SetEntityAlpha(playerPed, 255, false)
        ResetEntityAlpha(playerPed)
    end
    SetPlayerControl(PlayerId(), true, 0)

    if IsScreenFadedOut() or IsScreenFadingOut() then
        DoScreenFadeIn(400)
        local deadline = GetGameTimer() + 3000
        while not IsScreenFadedIn() and GetGameTimer() < deadline do
            Wait(0)
        end
    end
end

function openCreationMenu(isMale)
    if type(Config.SwitchHud) == "function" then
        Config.SwitchHud(false)
    end

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

    revealWorldForClothingCreator()

    -- Re-apply visibility after model swap (SetPlayerModel can reset flags).
    playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        SetEntityVisible(playerPed, true, false)
        FreezeEntityPosition(playerPed, false)
        SetEntityCollision(playerPed, true, true)
    end

    if type(Config.SwitchHud) == "function" then
        Config.SwitchHud(false)
    end

    exports['op-clothing']:OpenCharacterCreator({
        allowCancel = false,
        allowModelChange = true,
    }, function(appearance)
        Fr.CharacterCreated()
    end)
end