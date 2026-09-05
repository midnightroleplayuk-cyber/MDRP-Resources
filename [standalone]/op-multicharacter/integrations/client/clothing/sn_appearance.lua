if Config.Clothing ~= "sn_appearance" then return end

function applySkinToPed(ped, skin)
    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    TriggerEvent('qb-clothing:client:loadPlayerClothing', skin.skin, ped)
    exports.sn_appearance:setAppearance(skin.skin, ped)
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
    
    exports.sn_appearance:openMenu(function(changed, appearance)
        exports.sn_appearance:saveAppearance(appearance, charge)
        if isInsideNew then 
            Fr.CharacterCreated()
        end 
    end, {
        label = 'Character Creator',
        categories = { 'peds', 'face', 'faceFeatures', 'skin', 'hair', 'makeup', 'clothing', 'accessories'},
        charge = 0,
        canLeave = false,
        bucket = false,
    })
end
