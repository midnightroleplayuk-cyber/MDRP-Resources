if Config.Clothing ~= "kartik-clothing" then return end

function convertSkin(identifier)
    local ok, skin = pcall(function()
        return exports['kartik-clothing']:getPlayerAppearance(identifier)
    end)
    if ok and type(skin) == "table" then
        return { skin = skin, model = skin.model or "mp_m_freemode_01" }
    end
end

lib.callback.register("op-multicharacter:getActiveSkin", function(source)
    local Player = Fr.getPlayerFromId(source)
    if not Player then return nil end

    local id = Player.identifier
        or (Player.PlayerData and Player.PlayerData.citizenid)
        or nil

    if type(id) ~= "string" or id == "" then return nil end

    return convertSkin(id)
end)
