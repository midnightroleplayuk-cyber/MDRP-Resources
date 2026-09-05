if Config.Clothing ~= "um-clothing" then return end

function applySkinToPed(ped, skin)
    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    local ok, err = pcall(function()
        exports['um-clothing']:setPedAppearance(ped, skin.skin)
    end)
    if not ok then
        debugPrint("^1[applySkinToPed]^0 um-clothing setPedAppearance failed:", err)
    end
end

function openCreationMenu(isMale)
    DoScreenFadeOut(0)
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

    Citizen.CreateThread(function()
        if type(Config.SwitchHud) == "function" then
            Config.SwitchHud(false)
        end
        exports['um-clothing']:startPlayerCustomization(function(skin)
            if skin then
                Fr.CharacterCreated()
                TriggerServerEvent('op-multicharacter:saveSkin', skin)
            else
                Fr.CharacterCreated()
            end
        end, {
            ped = true,
            headBlend = true,
            faceFeatures = true,
            headOverlays = true,
            components = true,
            componentConfig = {
                masks = true,
                upperBody = true,
                lowerBody = true,
                bags = true,
                shoes = true,
                scarfAndChains = true,
                bodyArmor = true,
                shirts = true,
                decals = true,
                jackets = true,
            },
            props = true,
            propConfig = {
                hats = true,
                glasses = true,
                ear = true,
                watches = true,
                bracelets = true,
            },
            tattoos = true,
            enableExit = false,
            automaticFade = false,
        })
    end)

    Wait(4000)
    DoScreenFadeIn(500)
end