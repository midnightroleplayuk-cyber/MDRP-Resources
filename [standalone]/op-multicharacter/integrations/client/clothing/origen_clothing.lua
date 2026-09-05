if Config.Clothing ~= "origen_clothing" then return end

local function resolveOrigenAppearance(skin)
    if type(skin) ~= "table" then return nil end

    if type(skin.skin) == "table" then
        return skin.skin
    end

    if skin.components or skin.drawables or skin.headBlend or skin.props then
        return skin
    end

    return nil
end

local function setOrigenAppearance(ped, appearance)
    return pcall(function()
        exports['origen_clothing']:SetAppearance(ped, appearance)
    end)
end

function applySkinToPed(ped, skin)
    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    local appearance = resolveOrigenAppearance(skin)
    if not appearance then
        debugPrint("^1[applySkinToPed]^0 Invalid origen appearance data.")
        return
    end

    CreateThread(function()
        local timeout = GetGameTimer() + 3000
        while not DoesEntityExist(ped) and GetGameTimer() < timeout do
            Wait(25)
        end

        if not DoesEntityExist(ped) then
            debugPrint("^1[applySkinToPed]^0 Ped does not exist, aborting origen skin apply.")
            return
        end

        Wait(150)

        local ok, err = setOrigenAppearance(ped, appearance)
        if not ok then
            debugPrint("^1[applySkinToPed]^0 origen SetAppearance failed:", err)
            Wait(300)
            setOrigenAppearance(ped, appearance)
        end
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

    local gender = isMale and "male" or "female"
    local currentCoords = GetEntityCoords(PlayerPedId())
    exports['origen_clothing']:startPedCreation(currentCoords, gender, PlayerPedId(), false, function()
        Fr.CharacterCreated()
    end)
end