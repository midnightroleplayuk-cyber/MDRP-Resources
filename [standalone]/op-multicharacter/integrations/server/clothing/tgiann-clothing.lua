if Config.Clothing ~= "tgiann-clothing" then return end

function convertSkin(identifier)
    local result = MySQL.query.await("SELECT * FROM tgiann_skin WHERE citizenid = ?", { identifier })
    if result and result[1] and result[1].skin then
        return {
            skin = json.decode(result[1].skin),
            model = tonumber(result[1].model)
        }
    end
end