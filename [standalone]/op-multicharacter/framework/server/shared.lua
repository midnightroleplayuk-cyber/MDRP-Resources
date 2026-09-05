Framework = nil
Fr = {}

function formatName(str)
    if not str or str == "" then return "" end

    str = string.lower(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

function generatePlate() 
    math.randomseed(GetGameTimer())
    local charSet = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

    local generatedPlate = nil

    for i = 1, 8 do
        if generatedPlate == nil then
            generatedPlate = charSet[math.random(#charSet)]
        else 
            generatedPlate = generatedPlate .. charSet[math.random(#charSet)] 
        end	
    end

    local isTaken = Fr.IsPlateTaken(generatedPlate)
    if isTaken then 
        return generatePlate()
    end

    return generatedPlate
end

Fr.getIdents = function(src)
    local ids = GetPlayerIdentifiers(src)
    local idTable = {}

    for _, id in ipairs(ids) do
        local prefix, value = id:match("([^:]+):(.+)")
        if prefix and value then
            idTable[prefix] = value
        end
    end

    return idTable
end

Fr.GetDiscordId = function(src)
    if not src or type(src) ~= "number" then
        return nil
    end

    local identifier = GetPlayerIdentifierByType(src, "discord")
    if not identifier then
        return nil
    end

    local discordId = identifier:gsub("^discord:", "")

    if discordId == "" then
        return nil
    end

    return discordId
end


if not ServerConfig.DiscordRanks.enable then 
    function setSlots(identifier, amount, byWho) 
        local slots = MySQL.scalar.await("SELECT slots FROM `multicharacter_slots` WHERE identifier = ?", { identifier })

        ServerConfig.formatWebHook("slotsadded", GetPlayerName(byWho), identifier, amount)

        if slots then 
            MySQL.query.await(
                'UPDATE `multicharacter_slots` SET slots = ? WHERE identifier = ?', 
                { amount, identifier }
            )
        else
            MySQL.query.await(
                'INSERT INTO `multicharacter_slots` (identifier, slots) VALUES (?, ?)',
                { identifier, amount }
            )
        end
    end

    exports("setSlots", setSlots)
end

if GetResourceState('op-crime') == 'started' then
    Fr.GetCharacterGang = function(ident) 
        local playerGang = MySQL.query.await(
        "SELECT * FROM opcrime_players WHERE identificator = ?",
        { ident })
        
        if #playerGang > 0 then
            local gangData = exports['op-crime']:getOrganisation(playerGang[1].jobId)
            if gangData then 
                return {
                    name = gangData.label,
                    rank = playerGang[1].rank
                }
            else
                return false
            end
        else
            return false
        end
    end
end