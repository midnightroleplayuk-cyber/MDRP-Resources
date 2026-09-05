if Config.Clothing ~= "skinchanger" and Config.Clothing ~= "p_appearance" then
    return
end

function convertSkin(identifier)
    if ESX then
        local result = MySQL.query.await("SELECT `skin` FROM `users` WHERE `identifier` = ?", { identifier })
        local raw = result and result[1] and result[1].skin
        if type(raw) ~= "string" or raw == "" then
            return nil
        end

        local ok, decoded = pcall(json.decode, raw)
        if not ok or type(decoded) ~= "table" or next(decoded) == nil then
            debugPrint("^1[convertSkin]^0 Failed to decode skin for", tostring(identifier))
            return nil
        end

        return { skin = decoded }
    elseif QBCore or QBox then
        local result = MySQL.query.await(
            "SELECT * FROM `playerskins` WHERE `citizenid` = ? AND active = 1 ORDER BY `id` DESC LIMIT 1",
            { identifier }
        )
        local raw = result and result[1] and result[1].skin
        if type(raw) ~= "string" or raw == "" then
            return nil
        end

        local ok, decoded = pcall(json.decode, raw)
        if not ok or type(decoded) ~= "table" or next(decoded) == nil then
            debugPrint("^1[convertSkin]^0 Failed to decode playerskins for", tostring(identifier))
            return nil
        end

        return { skin = decoded }
    end
end
