if Sky.Config.phone ~= "qb" then return end

function Sky.Functions.ChangeNumber(src, newNumber)
    if Sky.Config.framework == "qbox" then
        if not exports.qbx_core:GetPlayer(src) then return false, "player_unavailable" end
        exports.qbx_core:SetCharInfo(src, "phone", newNumber)
        exports.qbx_core:Save(src)
        return
    end

    local xPlayer = QBCore.Functions.GetPlayer(src)
    local charInfo = xPlayer.PlayerData.charinfo
    charInfo.phone = newNumber
    xPlayer.Functions.SetPlayerData("charinfo", charInfo)
    xPlayer.Functions.Save()
    xPlayer.Functions.UpdatePlayerData(false)
    TriggerClientEvent('QBCore:Player:UpdatePlayerData', src)
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    local pattern = '%"phone%":"%' .. phoneNumber .. '%"%'
    local result = Sky.Query('SELECT citizenid FROM players WHERE charinfo LIKE ?', {pattern})
    if result[1] then
        return true
    else
        return false
    end
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    Sky.Debug("error", "[sky_base] custom phone app registration is not supported for qb phone")
    return false, "unsupported_phone"
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    Sky.Debug("error", "[sky_base] custom phone app messages are not supported for qb phone")
end

function Sky.Functions.SendPhoneAppNotification(data)
    Sky.Debug("error", "[sky_base] custom phone app notifications are not supported for qb phone")
    return false, "unsupported_phone"
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    Sky.Debug("error", "[sky_base] get source from number is not supported for qb phone")
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    Sky.Debug("error", "[sky_base] has airplane mode is not supported for qb phone")
end
