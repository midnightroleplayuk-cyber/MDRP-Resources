while Framework == nil do Wait(5) end

if Config.AdminMenu.EnableCommands then
    RegisterCommand(Config.AdminMenu.DeleteVehicle, function(source, args, rawCommand)
        local isAllowed = isAllowedAdmin(source) 

        if isAllowed then
            local playerPed = GetPlayerPed(source)
            local plate = args[1]

            if not plate then
                return TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('argumentsNoMatch'), "error", 5000)
            end

            MySQL.Async.execute('DELETE FROM `'..Fr.Table..'` WHERE `plate` = @plate', {
                ['@plate'] = plate,
            })
            TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('command_translation_rmcar_success'), "success", 5000)
            
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            if DoesEntityExist(vehicle) then
                local vehplate = GetVehicleNumberPlateText(vehicle)
                vehplate = vehplate:match("^%s*(.-)%s*$")
                if vehplate == plate then
                    TaskLeaveVehicle(playerPed, vehicle, 1)
                    Wait(1000)
                    local vehNet = NetworkGetNetworkIdFromEntity(vehicle)
                    local vehEntity = NetworkGetEntityFromNetworkId(vehNet)
                    DeleteEntity(vehEntity)
                    DeleteEntity(vehicle)
                end
            end
            
            local admin = GetPlayerName(source) .. " (".. Fr.GetIndentifier(source) ..")"
            local desc = string.format(WHData.vehDel.desc, plate, admin)
            SendWebHook(WHData.vehDel.head, 16711680, desc)
        else
            TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('notAllowedToUse'), "error", 5000)
        end
    end)

    RegisterCommand(Config.AdminMenu.AddCarCommand, function(source, args, rawCommand)
        local isAllowed = isAllowedAdmin(source) 

        if source == 0 then return end

        if isAllowed then
            local plate = generatePlate() 
            local model = joaat(args[2])
            local playerOrJob = args[1]
            local veh = json.encode({model = model, plate = plate})

            if not model or not playerOrJob then
                return TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('argumentsNoMatch'), "error", 5000)
            end

            local xPlayer = Fr.getPlayerFromId(playerOrJob)
            if not xPlayer then
                return TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('carAdded_not'), "error", 5000)
            end

            TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('carAdded'), "success", 5000)
            insertVehicleToDatabase(playerOrJob, veh, plate, source)

            local admin = GetPlayerName(source) .. " (".. Fr.GetIndentifier(source) ..")"
            local desc = string.format(WHData.carAdded.desc, args[2], plate, Fr.GetIndentifier(playerOrJob), admin)
            SendWebHook(WHData.carAdded.head, 65390, desc)
        else
            TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('notAllowedToUse'), "error", 5000)
        end
    end)

    RegisterCommand(Config.AdminMenu.AddJobCarCommand, function(source, args, rawCommand)
        local isAllowed = isAllowedAdmin(source) 

        if source == 0 then return end

        if isAllowed then
            local plate = generatePlate() 
            local model = joaat(args[1])
            local Job = args[2]
            local JobGrade = args[3]
            local isPrivate = args[4]
            local veh = json.encode({model = model, plate = plate})

            if not model or not Job or not JobGrade then
                return TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('argumentsNoMatch'), "error", 5000)
            end

            local xIdent = nil
            if isPrivate then
                xIdent = Fr.GetIndentifier(tonumber(isPrivate))
                if not xIdent then
                    return TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('carAdded_not'), "error", 5000)
                end
            end

            TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('carAdded'), "success", 5000)
            insertVehicleToDatabaseJob(Job, JobGrade, veh, plate, xIdent, source)

            isPrivate = not isPrivate and "False" or isPrivate

            local admin = GetPlayerName(source) .. " (".. Fr.GetIndentifier(source) ..")"
            local desc = string.format(WHData.carAdded.desc, args[2], plate, Job .. " (" .. JobGrade ..") [" .. isPrivate .. "]", admin)
            SendWebHook(WHData.carAdded.head, 65390, desc)
        else
            TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('notAllowedToUse'), "error", 5000)
        end
    end)

    RegisterCommand(Config.AdminMenu.AddGangCarCommand, function(source, args, rawCommand)
        local isAllowed = isAllowedAdmin(source) 

        if source == 0 then return end

        if isAllowed then
            local plate = generatePlate() 
            local model = joaat(args[1])
            local Gang = args[2]
            local GangGrade = args[3]
            local isPrivate = args[4]
            local veh = json.encode({model = model, plate = plate})

            if not model or not Gang or not GangGrade then
                return TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('argumentsNoMatch'), "error", 5000)
            end

            local xIdent = nil
            if isPrivate then
                xIdent = Fr.GetIndentifier(tonumber(isPrivate))
                if not xIdent then
                    return TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('carAdded_not'), "error", 5000)
                end
            end

            TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('carAdded'), "success", 5000)
            insertVehicleToDatabaseGang(Gang, GangGrade, veh, plate, xIdent, source)

            local admin = GetPlayerName(source) .. " (".. Fr.GetIndentifier(source) ..")"

            isPrivate = not isPrivate and "False" or isPrivate

            local desc = string.format(WHData.carAdded.desc, args[2], plate, Gang .. " (" .. GangGrade ..") [" .. isPrivate .. "]", admin)
            SendWebHook(WHData.carAdded.head, 65390, desc)
        else
            TriggerClientEvent('op-uniqueNotif:sendNotify', source, TranslateIt('notAllowedToUse'), "error", 5000)
        end
    end)
end

function insertVehicleToDatabaseGang(Gang, GangGrade, veh, plate, isPrivate, source)
    local owner = isPrivate or nil 
    if ESX then
        MySQL.insert('INSERT INTO `'..Fr.Table..'` (`'..Fr.OwnerTable..'`, `plate`, `vehicle`, `gang`, `gangGrade`, `gangPrivate`, `'.. Fr.StoredTable ..'`) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {"", plate, veh, Gang, GangGrade, owner, 0})
    elseif QBCore or QBox then
        local vehData = json.decode(veh)
        MySQL.insert('INSERT INTO `'..Fr.Table..'` (`license`, `'..Fr.OwnerTable..'`, `plate`, `mods`, `vehicle`, `hash`, `gang`, `gangGrade`, `gangPrivate`, `'.. Fr.StoredTable ..'`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        {nil, nil, plate, veh, vehData.model, vehData.model, Gang, GangGrade, owner, 0})
    end
end

function insertVehicleToDatabaseJob(Job, JobGrade, veh, plate, isPrivate, source)
    local owner = isPrivate or nil 
    if ESX then
        MySQL.insert('INSERT INTO `'..Fr.Table..'` (`'..Fr.OwnerTable..'`, `plate`, `vehicle`, `job`, `jobGrade`, `jobPrivate`, `'.. Fr.StoredTable ..'`) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {"", plate, veh, Job, JobGrade, owner, 0})
    elseif QBCore or QBox then
        local vehData = json.decode(veh)
        MySQL.insert('INSERT INTO `'..Fr.Table..'` (`license`, `'..Fr.OwnerTable..'`, `plate`, `mods`, `vehicle`, `hash`, `job`, `jobGrade`, `jobPrivate`, `'.. Fr.StoredTable ..'`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        {nil, nil, plate, veh, vehData.model, vehData.model, Job, JobGrade, owner, 0})
    end
end

function insertVehicleToDatabase(playerOrJob, veh, plate, source)
    local xPlayer = Fr.getPlayerFromId(tonumber(playerOrJob))
    if xPlayer then
        local owner = Fr.GetIndentifier(tonumber(playerOrJob))
        if ESX then
            MySQL.insert('INSERT INTO `'..Fr.Table..'` (`'..Fr.OwnerTable..'`, `plate`, `vehicle`, `'.. Fr.StoredTable ..'`) VALUES (?, ?, ?, ?)',
            {owner, plate, veh, 0})
        elseif QBCore or QBox then
            local vehData = json.decode(veh)
            local sourceFromPlayer = Fr.GetSourceFromPlayerObject(xPlayer)
            local license = GetPlayerLicense(sourceFromPlayer)
            MySQL.insert('INSERT INTO `'..Fr.Table..'` (`license`, `'..Fr.OwnerTable..'`, `plate`, `mods`, `vehicle`, `hash`, `'.. Fr.StoredTable ..'`) VALUES (?, ?, ?, ?, ?, ?, ?)',
            {license, owner, plate, veh, vehData.model, vehData.model, 0})
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