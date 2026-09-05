QBox = GetResourceState('qbx_core') == 'started' and true or false

if not QBox then return end

if ServerConfig.EnableQBgangsIntegrations then
    RegisterNetEvent('QBCore:Server:OnGangUpdate', function(id, data)
        local Player = Framework.Functions.GetPlayer(tonumber(id))
        if Player then
            Player.Functions.SetGang(tostring(data.name), tonumber(data.grade.level))
        else
            print('[ERROR] Unable to update player gang. Specified player is offline:', id)
        end
    end)
end

RegisterCommand('getgangslist', function()
    local gangs = exports['qbx_core']:GetGangs()
    print(json.encode(gangs))
end)

Framework = exports['qb-core']:GetCoreObject()
Fr.usersTable = "players"
Fr.identificatorTable = "citizenid"
Fr.Table = 'player_vehicles'
Fr.VehProps = 'mods'
Fr.OwnerTable = "citizenid"
Fr.StoredTable = 'state'
Fr.PlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
Fr.IsPlayerDead = function(source)
    local Player = Fr.getPlayerFromId(source)
    if not Player or not Player.PlayerData or not Player.PlayerData.metadata then
        return false
    end

    local isLastStand = Player.PlayerData.metadata["inlaststand"]
    local isDead = Player.PlayerData.metadata["isdead"]
    return isDead == true or isLastStand == true
end

Fr.VehiclePurchased = function(model, jobId, plate, mods)
    local readyModel = joaat(model)
    local insertQuery = [[
        INSERT INTO `player_vehicles`
        (`license`, `vehicle`, `hash`, `citizenid`, `plate`, `mods`, `gang`, `configName`, `state`)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)
    ]]

    local params
    if not mods then
        params = {
            "", model, readyModel, nil, plate,
            json.encode({model = readyModel, plate = plate}),
            jobId, model
        }
    else
        params = {
            "", model, readyModel, nil, plate,
            mods, jobId, model
        }
    end

    if Config.GarageScript == 'jg-advancedgarages' then 
        insertQuery = [[
            INSERT INTO `player_vehicles`
            (`license`, `vehicle`, `hash`, `citizenid`, `plate`, `mods`, `gang`, `configName`, `state`, `gang_vehicle`, `gang_vehicle_rank`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?)
        ]]

        params[4] = "gang_" .. jobId
        params[9] = 1
        params[10] = 1
    end

    MySQL.Async.insert(insertQuery, params, function(insertId)
        if not insertId then
            print(("[^1ERROR^7] Vehicle insert failed for plate %s"):format(plate))
        else
            local insertInfo = ("[^2INFO^7] Vehicle inserted with ID: %s, plate: %s"):format(insertId, plate)
            if mods then 
                print(insertInfo)
            else
                debugPrint(insertInfo)
            end
        end
    end)
end

Fr.UpdateVehicleState = function(plate, state, networkId)
    MySQL.Async.execute('UPDATE `'.. Fr.Table ..'` SET `'.. Fr.StoredTable ..'` = @state, vehicleid = @networkid WHERE plate = @plate',
    {['@plate'] = plate, ['@networkid'] = networkId, ['@state'] = state})
end

Fr.IsPlateTaken = function(plate)
    local p = promise.new()
    
    MySQL.scalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate},
    function(result)
        p:resolve(result ~= nil)
    end)

    return Citizen.Await(p)
end

Fr.RegisterServerCallback = function(...)
    return Framework.Functions.CreateCallback(...)
end
Fr.GetPlayerFromIdentifier = function(identifier)
    return Framework.Functions.GetPlayerByCitizenId(identifier)
end
Fr.getPlayerFromId = function(...)
    return Framework.Functions.GetPlayer(...)
end
Fr.GetMoney = function(Player, account)
    if account == "money" then account = "cash" end
    return Player.PlayerData.money[account]
end
Fr.GetDirtyMoney = function(Player)
    local blackMoney = Player.Functions.GetItemByName(Config.DirtyMoney.itemName)
    return blackMoney and blackMoney.amount or 0
end
Fr.ManageMoney = function(Player, account, action, amount)
    if account == "money" then account = "cash" end
    if action == "add" then
        return Player.Functions.AddMoney(account, amount)
    else
        return Player.Functions.RemoveMoney(account, amount)
    end
end
Fr.ManageDirtyMoney = function(Player, action, amount)
    if action == "add" then
        return Player.Functions.AddItem(Config.DirtyMoney.itemName, amount)
    else
        return Player.Functions.RemoveItem(Config.DirtyMoney.itemName, amount)
    end
end
Fr.GetIndentifier = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.PlayerData.citizenid
end
Fr.PreloadNames = function(identifiers)
    if type(identifiers) ~= "table" or #identifiers == 0 then return end
    local CHUNK = 500
    for start = 1, #identifiers, CHUNK do
        local chunk = {}
        for i = start, math.min(start + CHUNK - 1, #identifiers) do
            local v = identifiers[i]
            if v then chunk[#chunk + 1] = trim(v) end
        end
        if #chunk > 0 then
            local placeholders = ("?,"):rep(#chunk):sub(1, -2)
            local ok, rows = pcall(MySQL.query.await,
                "SELECT citizenid, charinfo FROM players WHERE citizenid IN (" .. placeholders .. ")",
                chunk
            )
            if ok and rows then
                for _, r in pairs(rows) do
                    local ci = r.charinfo
                    if type(ci) == "string" then ci = json.decode(ci) end
                    if ci and ci.firstname and ci.lastname then
                        Fr.cacheName(r.citizenid, ci.firstname .. " " .. ci.lastname)
                    end
                end
            end
        end
    end
end

Fr.GetPlayerName = function(sourceOrIdentifier)
    local xPlayer = Fr.getPlayerFromId(sourceOrIdentifier)
    local name

    if xPlayer then
        name = xPlayer.PlayerData.charinfo.firstname .." ".. xPlayer.PlayerData.charinfo.lastname
        Fr.cacheName(xPlayer.PlayerData.citizenid, name)
        return name
    end

    local key = trim(sourceOrIdentifier)
    local cached = Fr.getCachedName(key)
    if cached then return cached end

    local result = MySQL.query.await(
        "SELECT charinfo FROM players WHERE citizenid = ? LIMIT 1",
        { key }
    )
    if result and result[1] then
        local charinfo = result[1].charinfo
        if type(charinfo) == "string" then charinfo = json.decode(charinfo) end
        if charinfo and charinfo.firstname and charinfo.lastname then
            name = charinfo.firstname .. " " .. charinfo.lastname
        else
            name = "Unknown"
        end
    else
        name = "Unknown"
    end

    Fr.cacheName(key, name)
    return name
end
Fr.GetGroup = function(source)
    return exports.qbx_core:GetPermission(source)
end
Fr.addItem = function(xPlayer, itemname, quantity, metadata)
    quantity = tonumber(quantity) or 0
    itemname = tostring(itemname)

    if quantity <= 0 then
        quantity = 1
    end

    if Config.Inventory.inventoryScript == "ox_inventory" and metadata then
        local src = xPlayer.PlayerData.source
        local success, response = exports.ox_inventory:AddItem(src, itemname, quantity, metadata or {})
        return success, response
    else
        return xPlayer.Functions.AddItem(itemname, quantity)
    end
end
Fr.removeItem = function(xPlayer, itemname, quantity)
    quantity = tonumber(quantity) or 0
    itemname = tostring(itemname)

    if quantity <= 0 then
        quantity = 1
    end

    return xPlayer.Functions.RemoveItem(itemname, quantity)
end
Fr.getItem = function(xPlayer, itemname)
    local item = xPlayer.Functions.GetItemByName(itemname)
    local table
    if item then
        table = {amount = item.amount, name = itemname, weight = item.weight, label = item.label}
    else 
        table = {amount = 0, name = itemname, weight = 0, label = ""}
    end
    return table
end
Fr.getInventory = function(xPlayer)
    return xPlayer.PlayerData.items
end
Fr.getItemInfo = function(itemName) 
    return Framework.Shared.Items[itemName]
end
Fr.RegisterItem = function(itemName, itemEvent)
    Framework.Functions.CreateUseableItem(itemName, function(src, item)
        if type(src) ~= 'number' and type(item) == 'number' then
            src = item
        end
        Fr.FireRegisteredItem(src, itemEvent)
    end)
end
Fr.GetSourceFromPlayerObject = function(xPlayer)
    if xPlayer then
        return xPlayer.PlayerData.source
    else
        return nil
    end
end
Fr.GetPlayerJob = function(xPlayer)
    local job = {
        name = xPlayer.PlayerData.job.name,
        grade = xPlayer.PlayerData.job.grade.level
    }
    return job
end
Fr.AddMoneyToOfflineUser = function(identifier, amount, typeMoney)
    debugPrint("^3[DEBUG]^7 Fr.AddMoneyToOfflineUser called")
    debugPrint("^3[DEBUG]^7 identifier:", identifier)
    debugPrint("^3[DEBUG]^7 amount:", amount)
    debugPrint("^3[DEBUG]^7 typeMoney:", typeMoney)

    if typeMoney == "money" then
        debugPrint("^2[DEBUG]^7 Entering MONEY branch")

        local trimmedId = trim(identifier)
        debugPrint("^3[DEBUG]^7 trimmed citizenid:", trimmedId)

        local result = MySQL.query.await(
            "SELECT money FROM players WHERE citizenid = ? LIMIT 1",
            { trimmedId }
        )

        debugPrint("^3[DEBUG]^7 SQL result:", json.encode(result))

        if result and result[1] then
            debugPrint("^2[DEBUG]^7 Player found")

            local moneyObject = result[1].money
            debugPrint("^3[DEBUG]^7 Raw money field:", json.encode(moneyObject))

            if type(moneyObject) == "string" then
                moneyObject = json.decode(moneyObject)
                debugPrint("^3[DEBUG]^7 Decoded moneyObject:", json.encode(moneyObject))
            end

            if moneyObject and moneyObject.bank then
                debugPrint("^3[DEBUG]^7 Current bank:", moneyObject.bank)

                moneyObject.bank = moneyObject.bank + amount

                debugPrint("^2[DEBUG]^7 New bank:", moneyObject.bank)

                MySQL.Async.execute(
                    "UPDATE players SET money = @newMoney WHERE citizenid = @citizenid",
                    {
                        ['@newMoney'] = json.encode(moneyObject),
                        ['@citizenid'] = trimmedId
                    },
                    function(rowsChanged)
                        debugPrint("^2[DEBUG]^7 Money updated. Rows changed:", rowsChanged)
                    end
                )
            else
                debugPrint("^1[DEBUG]^7 moneyObject invalid or missing bank field")
            end
        else
            debugPrint("^1[DEBUG]^7 No player found for citizenid:", trimmedId)
        end

    elseif typeMoney == "blackmoney" then
        debugPrint("^2[DEBUG]^7 Entering BLACKMONEY branch")

        local trimmedId = trim(identifier)
        debugPrint("^3[DEBUG]^7 trimmed citizenid:", trimmedId)

        local result = MySQL.query.await(
            "SELECT inventory FROM players WHERE citizenid = ? LIMIT 1",
            { trimmedId }
        )

        debugPrint("^3[DEBUG]^7 SQL result:", json.encode(result))

        if result and result[1] then
            local inventoryObject = result[1].inventory

            debugPrint("^3[DEBUG]^7 Raw inventory:", json.encode(inventoryObject))

            if type(inventoryObject) == "string" then
                inventoryObject = json.decode(inventoryObject)
                debugPrint("^3[DEBUG]^7 Decoded inventory:", json.encode(inventoryObject))
            end

            if not inventoryObject then
                inventoryObject = {}
                debugPrint("^3[DEBUG]^7 Inventory was nil, created empty table")
            end

            local usedSlots = {}
            local freeSlot = 1

            for _, item in pairs(inventoryObject) do
                if item.slot then
                    usedSlots[item.slot] = true
                    debugPrint("^3[DEBUG]^7 Used slot:", item.slot)
                end
            end

            while usedSlots[freeSlot] do
                freeSlot = freeSlot + 1
            end

            debugPrint("^2[DEBUG]^7 Free slot found:", freeSlot)

            local newItem = {
                slot = freeSlot,
                name = Config.DirtyMoney.itemName,
                type = "item",
                count = amount,
                info = {},
                metadata = {}
            }

            debugPrint("^3[DEBUG]^7 Adding item:", json.encode(newItem))

            table.insert(inventoryObject, newItem)

            MySQL.Async.execute(
                "UPDATE players SET inventory = @newInventory WHERE citizenid = @citizenid",
                {
                    ['@newInventory'] = json.encode(inventoryObject),
                    ['@citizenid'] = trimmedId
                },
                function(rowsChanged)
                    debugPrint("^2[DEBUG]^7 Inventory updated. Rows changed:", rowsChanged)
                end
            )
        else
            debugPrint("^1[DEBUG]^7 No player found for citizenid:", trimmedId)
        end
    else
        debugPrint("^1[DEBUG]^7 Unknown typeMoney:", typeMoney)
    end
end