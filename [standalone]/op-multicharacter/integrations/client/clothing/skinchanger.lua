if Config.Clothing ~= "skinchanger" then
    return
end

local function resolveSkinchangerAppearance(skin)
    if type(skin) ~= "table" then
        return nil
    end

    -- Standard multichar wrapper: { skin = { tshirt_1 = ..., sex = 0, ... } }
    if type(skin.skin) == "table" and next(skin.skin) ~= nil then
        return skin.skin
    end

    -- Flat skinchanger payload stored at root (no nested .skin)
    if skin.sex ~= nil
        or skin.tshirt_1 ~= nil
        or skin.torso_1 ~= nil
        or skin.pants_1 ~= nil
        or skin.hair_1 ~= nil
    then
        return skin
    end

    return nil
end

function applySkinToPed(ped, skin)
    local appearance = resolveSkinchangerAppearance(skin)
    if not appearance then
        debugPrint("^1[applySkinToPed]^0 Invalid/empty skinchanger skin — skipped.")
        return
    end

    if not ped or ped == 0 or not DoesEntityExist(ped) then
        debugPrint("^1[applySkinToPed]^0 Ped does not exist — skipped.")
        return
    end

    TriggerEvent("skinchanger:loadSkinOnPed", ped, appearance)
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
    else
        SetPedHeadBlendData(playerPed, 45, 21, 0, 20, 15, 0, 0.3, 0.1, 0, false)
    end

    -- Multichar keeps DoScreenFadeOut + NUI blackscreen through the creator TP
    -- (skipFadeIn). esx_skin has no reveal of its own — clear overlays here.
    SendNUIMessage({ action = "setBlackScreen", data = false })
    SendNUIMessage({ action = "setloadervisible", data = false })

    FreezeEntityPosition(playerPed, false)
    SetEntityCollision(playerPed, true, true)
    SetEntityVisible(playerPed, true, false)
    SetEntityInvincible(playerPed, false)
    SetPlayerControl(PlayerId(), true, 0)

    DoScreenFadeIn(500)
    local fadeDeadline = GetGameTimer() + 3000
    while not IsScreenFadedIn() and GetGameTimer() < fadeDeadline do
        Wait(0)
    end

    if type(Config.SwitchHud) == "function" then
        Config.SwitchHud(false)
    end

    TriggerEvent('esx_skin:openSaveableMenu', function()
        Fr.CharacterCreated()
    end, function()
        Fr.CharacterCreated()
    end)
end
