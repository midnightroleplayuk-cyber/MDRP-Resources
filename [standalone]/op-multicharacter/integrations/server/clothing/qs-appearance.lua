if Config.Clothing ~= "qs-appearance" then return end

function convertSkin(identifier)
    if ESX then
        local result = MySQL.query.await("SELECT `skin` FROM `users` WHERE `identifier` = ?", {identifier})
        if result and result[1] and result[1].skin then
            local skin = json.decode(result[1].skin)
            return {skin = skin, model = skin.model}
        end
    elseif QBCore or QBox then
        local result = MySQL.query.await("SELECT * FROM `playerskins` WHERE `citizenid` = ? AND active = 1 ORDER BY `id` DESC LIMIT 1", {identifier})
        if result and result[1] and result[1].skin then
            return {skin = json.decode(result[1].skin), model = result[1].model}
        end 
    end
end