Functions = {}

-- default reward table keys = label, sort, name, amount, img
function Functions.GiveCustomReward(source, reward)
    -- Example code
    if reward.sort == "pet" then
        exports["some_petscript"]:GivePet(reward.name, reward.amount)
    end
end

function Functions.HandleCheating(cheaterId, scriptName, reason)
    print(cheaterId, scriptName, reason)
    -- Example code
    print(GetPlayerName(cheaterId).. " cheated in "..scriptName.. " in following action: "..reason)
    if Config.framework == "esx" then 
        local xPlayer = ESX.GetPlayerFromId(cheaterId)
        xPlayer.kick("Cheating: " ..reason)
    elseif Config.framework == "qb" then
        DropPlayer(cheaterId, "Cheating: "..reason)
    elseif Config.framework == "qbox" then
        DropPlayer(cheaterId, "Cheating: "..reason)
    end

end

if Config.vehiclekeys == "kiminaze" then
    RegisterNetEvent("sky_base:kiminaze:giveKeys", function(plate)
        local src = source
        if not src or not plate or type(plate) ~= "string" then return end
        exports["VehicleKeyChain"]:AddTempKey(src, plate)
    end)

    RegisterNetEvent("sky_base:kiminaze:removeKeys", function(plate)
        local src = source
        if not plate or type(plate) ~= "string" then return end
        exports["VehicleKeyChain"]:RemoveTempKey(src, plate)
    end)
end
