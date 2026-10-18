if Config.Clothing ~= "kartik-clothing" then return end

function applySkinToPed(ped, skin)
    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    if type(skin.skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin.skin data (expected table, got " .. type(skin.skin) .. ").")
        return
    end

    local ok, err = pcall(function()
        exports['kartik-clothing']:setPedAppearance(ped, skin.skin)
    end)
    if not ok then
        debugPrint("^1[applySkinToPed]^0 kartik-clothing setPedAppearance failed:", err)
    end
end

function reapplySavedAppearance()
    if isInsideNew then return end

    local ok, data = pcall(function()
        return lib.callback.await("op-multicharacter:getActiveSkin", false)
    end)
    if not ok or type(data) ~= "table" or type(data.skin) ~= "table" then return end

    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    applySkinToPed(ped, data)
end

local function revealWorldForClothingCreator()
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

    revealWorldForClothingCreator()

    exports['kartik-clothing']:startPlayerCustomization(function()
        Fr.CharacterCreated()
    end, { gender = isMale and "male" or "female" })
end