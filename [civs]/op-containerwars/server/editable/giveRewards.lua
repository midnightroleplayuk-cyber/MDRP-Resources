function addCarReward(rewardData, identifier)
    return insertVehicleToDatabase(identifier, rewardData.modelName)
end

function insertVehicleToDatabase(player, model)
    local xPlayer = Fr.GetPlayerFromIdentifier(player)
    if xPlayer then
        local vehtype = "car"
        local plate = generatePlate() 
        local owner = player
        local HashModel = joaat(model)
        local veh = json.encode({model = HashModel, plate = plate})
        if ESX then
            MySQL.insert('INSERT INTO `'..Fr.Table..'` (`'..Fr.OwnerTable..'`, `plate`, `vehicle`) VALUES (?, ?, ?)',
            {owner, plate, veh})

            return plate
        elseif QBCore or QBox then
            local vehData = json.decode(veh)
            local sourceFromPlayer = Fr.GetSourceFromPlayerObject(xPlayer)
            local license = GetPlayerLicense(sourceFromPlayer)
            MySQL.insert('INSERT INTO `'..Fr.Table..'` (`license`, `'..Fr.OwnerTable..'`, `plate`, `mods`, `vehicle`, `hash`) VALUES (?, ?, ?, ?, ?, ?)',
            {license, owner, plate, veh, model, HashModel})

            return plate
        end
    end
end

function GetPlayerLicense(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, string.len("license:")) == "license:" then
            return id
        end
    end
    return nil
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

    local isTaken = IsPlateTaken(generatedPlate)
    if isTaken then 
        return generatePlate()
    end

    return generatedPlate
end

function IsPlateTaken(plate)
    local p = promise.new()
    
    MySQL.scalar('SELECT plate FROM `'..Fr.Table..'` WHERE plate = ?', {plate},
    function(result)
        p:resolve(result ~= nil)
    end)

    return Citizen.Await(p)
end