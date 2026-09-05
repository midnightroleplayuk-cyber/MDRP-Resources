if Config.Clothing ~= "p_appearance" then return end

local function decodeSkin(skinData)
    if type(skinData) == "string" then
        skinData = json.decode(skinData)
    end

    if type(skinData) ~= "table" then
        return nil
    end

    local skin = skinData

    while type(skin) == "table" and (skin.skin or skin.appearance) do
        skin = skin.skin or skin.appearance

        if type(skin) == "string" then
            skin = json.decode(skin)
        end
    end

    if type(skin) ~= "table" then
        return nil
    end

    return skin
end

local function normalise(value, division)
    if type(value) ~= "number" then
        return 0.0
    end

    return (value / division) + 0.0
end

local function getPedFromArg(ped)
    if type(ped) == "number" and DoesEntityExist(ped) then
        return ped
    end

    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        return playerPed
    end

    return nil
end

local function applyPlayerSkin(skin)
    exports["p_appearance"]:LoadSkin(skin)

    CreateThread(function()
        local delays = {750, 1500, 3000}

        for _, delay in ipairs(delays) do
            Wait(delay)

            local playerPed = PlayerPedId()
            if DoesEntityExist(playerPed) then
                exports["p_appearance"]:LoadSkin(skin)
            end
        end
    end)

    return true
end

local function applySkinManually(targetPed, skin)
    if not DoesEntityExist(targetPed) then return false end

    skin.mom = skin.mom or 0
    skin.dad = skin.dad or 0
    skin.grandparents = skin.grandparents or 0
    skin.face_md_weight = skin.face_md_weight or 50
    skin.skin_md_weight = skin.skin_md_weight or 50
    skin.face_g_weight = skin.face_g_weight or 0

    SetPedHeadBlendData(
        targetPed,
        skin.mom,
        skin.dad,
        skin.grandparents,
        skin.mom,
        skin.dad,
        skin.grandparents,
        normalise(skin.face_md_weight, 100),
        normalise(skin.skin_md_weight, 100),
        normalise(skin.face_g_weight, 100),
        false
    )

    local faceFeatures = {
        "nose_1", "nose_2", "nose_3", "nose_4", "nose_5", "nose_6",
        "eyebrows_5", "eyebrows_6", "cheeks_1", "cheeks_2", "cheeks_3",
        "eye_squint", "lip_thickness", "jaw_1", "jaw_2",
        "chin_1", "chin_2", "chin_3", "chin_4", "neck_thickness"
    }

    for index, key in ipairs(faceFeatures) do
        SetPedFaceFeature(targetPed, index - 1, normalise(skin[key] or 0, 10))
    end

    SetPedEyeColor(targetPed, skin.eye_color or 0)

    SetPedComponentVariation(targetPed, 2, skin.hair_1 or 0, skin.hair_2 or 0, 2)
    SetPedHairColor(targetPed, skin.hair_color_1 or 0, skin.hair_color_2 or 0)

    local overlays = {
        [0] = {"blemishes_1", "blemishes_2"},
        [1] = {"beard_1", "beard_2"},
        [2] = {"eyebrows_1", "eyebrows_2"},
        [3] = {"age_1", "age_2"},
        [4] = {"makeup_1", "makeup_2"},
        [5] = {"blush_1", "blush_2"},
        [6] = {"complexion_1", "complexion_2"},
        [7] = {"sun_1", "sun_2"},
        [8] = {"lipstick_1", "lipstick_2"},
        [9] = {"moles_1", "moles_2"},
        [10] = {"chest_1", "chest_2"},
    }

    for overlayId, keys in pairs(overlays) do
        SetPedHeadOverlay(targetPed, overlayId, skin[keys[1]] or 0, normalise(skin[keys[2]] or 0, 10))
    end

    local overlayColours = {
        [1] = {"beard_3", "beard_4"},
        [2] = {"eyebrows_3", "eyebrows_4"},
        [4] = {"makeup_3", "makeup_4"},
        [5] = {"blush_3", nil},
        [8] = {"lipstick_3", "lipstick_4"},
        [10] = {"chest_3", nil},
    }

    for overlayId, keys in pairs(overlayColours) do
        SetPedHeadOverlayColor(targetPed, overlayId, 1, skin[keys[1]] or 0, keys[2] and skin[keys[2]] or 0)
    end

    if (skin.bodyb_1 or -1) == -1 then
        SetPedHeadOverlay(targetPed, 11, 255, normalise(skin.bodyb_2 or 0, 10))
    else
        SetPedHeadOverlay(targetPed, 11, skin.bodyb_1 or 0, normalise(skin.bodyb_2 or 0, 10))
    end

    if (skin.bodyb_3 or -1) == -1 then
        SetPedHeadOverlay(targetPed, 12, 255, normalise(skin.bodyb_4 or 0, 10))
    else
        SetPedHeadOverlay(targetPed, 12, skin.bodyb_3 or 0, normalise(skin.bodyb_4 or 0, 10))
    end

    local components = {
        [1] = {"mask_1", "mask_2"},
        [3] = {"arms", "arms_2"},
        [4] = {"pants_1", "pants_2"},
        [5] = {"bags_1", "bags_2"},
        [6] = {"shoes_1", "shoes_2"},
        [7] = {"chain_1", "chain_2"},
        [8] = {"tshirt_1", "tshirt_2"},
        [9] = {"bproof_1", "bproof_2"},
        [10] = {"decals_1", "decals_2"},
        [11] = {"torso_1", "torso_2"},
    }

    for componentId, keys in pairs(components) do
        SetPedComponentVariation(targetPed, componentId, skin[keys[1]] or 0, skin[keys[2]] or 0, 2)
    end

    local props = {
        [0] = {"helmet_1", "helmet_2"},
        [1] = {"glasses_1", "glasses_2"},
        [2] = {"ears_1", "ears_2"},
        [6] = {"watches_1", "watches_2"},
        [7] = {"bracelets_1", "bracelets_2"},
    }

    for propId, keys in pairs(props) do
        local drawable = skin[keys[1]]

        if drawable == nil or drawable == -1 then
            ClearPedProp(targetPed, propId)
        else
            SetPedPropIndex(targetPed, propId, drawable, skin[keys[2]] or 0, true)
        end
    end

    return true
end

function applySkinToPed(ped, skinData)
    local skin = decodeSkin(skinData)
    local targetPed = getPedFromArg(ped)

    if not skin then
        debugPrint("^1[p_appearance]^0 Invalid skin data.")
        return false
    end

    if not targetPed then
        debugPrint("^1[p_appearance]^0 Invalid ped.")
        return false
    end

    skin.sex = skin.sex or 0
    skin.model = skin.model or (skin.sex == 1 and "mp_f_freemode_01" or "mp_m_freemode_01")

    if targetPed == PlayerPedId() or IsPedAPlayer(targetPed) then
        Wait(500)
        return applyPlayerSkin(skin)
    end

    return applySkinManually(targetPed, skin)
end

function openCreationMenu(isMale)
    local model = isMale and `mp_m_freemode_01` or `mp_f_freemode_01`

    lib.requestModel(model, 30000)
    SetPlayerModel(PlayerId(), model)

    Wait(250)

    local playerPed = PlayerPedId()
    SetModelAsNoLongerNeeded(model)
    SetPedDefaultComponentVariation(playerPed)

    exports["p_appearance"]:OpenMenu()

    Wait(1000)

    Fr.CharacterCreated()
end
