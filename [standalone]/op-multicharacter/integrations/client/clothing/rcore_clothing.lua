if Config.Clothing ~= "rcore_clothing" then return end

local PedDefaults = {
    ['male'] = {
        [0 --[[HEAD]]] = 0,
        [1 --[[MASK]]] = 0,
        [2 --[[HAIR]]] = 2,
        [3 --[[ARMS]]] = 0,
        [4 --[[PANTS]]] = 0,
        [5 --[[BAG]]] = 0,
        [6 --[[SHOES]]] = 3,
        [7 --[[NECKWEAR]]] = 0,
        [8 --[[UNDERSHIRT]]] = 15,
        [9 --[[VEST]]] = 0,
        [10 --[[DECAL]]] = 0,
        [11 --[[SHIRT]]] = 1,
    },
    ['female'] = {
        [0 --[[HEAD]]] = 0,
        [1 --[[MASK]]] = 0,
        [2 --[[HAIR]]] = 1429,
        [3 --[[ARMS]]] = 14,
        [4 --[[PANTS]]] = 1,
        [5 --[[BAG]]] = 0,
        [6 --[[SHOES]]] = 195,
        [7 --[[NECKWEAR]]] = 0,
        [8 --[[UNDERSHIRT]]] = 0,
        [9 --[[VEST]]] = 0,
        [10 --[[DECAL]]] = 0,
        [11 --[[SHIRT]]] = 1419,
    }
}

function applySkinToPed(ped, skin)
    debugPrint("RCORE Setting apperance for ped", ped)

    if type(skin) ~= "table" then
        debugPrint("^1[applySkinToPed]^0 Invalid skin data (expected table, got " .. type(skin) .. ").")
        return
    end

    local ok, err = pcall(function()
        exports['rcore_clothing']:setPedSkin(ped, skin.skin)
    end)
end

function openCreationMenu(isMale)
    local model = isMale and `mp_m_freemode_01` or `mp_f_freemode_01`

    lib.requestModel(model, 30000)
    SetPlayerModel(PlayerId(), model)

    Wait(150)
    SetModelAsNoLongerNeeded(model)

    --local playerPed = PlayerPedId()
    --SetPedDefaultComponentVariation(playerPed)
    --if model == `mp_m_freemode_01` then
    --    SetPedHeadBlendData(playerPed, 0, 0, 0, 0, 0, 0, 0, 0, 0, false)
    --elseif model == `mp_f_freemode_01` then
    --    SetPedHeadBlendData(playerPed, 45, 21, 0, 20, 15, 0, 0.3, 0.1, 0, false)
    --end

    --local defaultSkin = isMale and PedDefaults['male'] or PedDefaults['female']
    --applySkinToPed(playerPed, defaultSkin)
    debugPrint("applySkinToPed is removed.")

    Wait(50)
    
    --TriggerEvent('rcore_clothing:openCharCreator')
    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end

AddEventHandler('rcore_clothing:charcreator:done', function()
    if not isInsideNew then return end 
    
    Fr.CharacterCreated()
end)
