ESX = GetResourceState('es_extended') == 'started' and true or false

if not ESX then return end
Framework = exports["es_extended"]:getSharedObject()

Fr.usersTable = "users"
Fr.identificatorTable = "identifier"
Fr.Table = 'owned_vehicles'
Fr.VehProps = 'vehicle'
Fr.OwnerTable = "owner"
Fr.StoredTable = "stored"
Fr.PlayerLoaded = 'esx:playerLoaded'

Fr.VehiclePurchased = function(model, jobId, plate, mods)
    local readyModel = joaat(model)

    local query = [[
        INSERT INTO `owned_vehicles`
        (`owner`, `plate`, `vehicle`, `gang`, `configName`)
        VALUES (?, ?, ?, ?, ?)
    ]]

    local params
    if not mods then
        params = {
            "",
            plate,
            json.encode({ model = readyModel, plate = plate }),
            jobId,
            model
        }
    else
        params = {
            "",
            plate,
            mods,
            jobId,
            model
        }
    end

    if Config.GarageScript == 'jg-advancedgarages' then 
        query = [[
            INSERT INTO `owned_vehicles`
            (`owner`, `plate`, `vehicle`, `gang`, `configName`, `gang_vehicle`, `gang_vehicle_rank`)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ]]

        params[1] = "gang_" .. jobId
        params[6] = 1
        params[7] = 1
    end

    MySQL.Async.insert(query, params, function(insertId)
        if not insertId then
            print(("[^1ERROR^7] Failed to insert vehicle with plate %s into owned_vehicles"):format(plate))
        else
            local insertInfo = ("[^2INFO^7] Inserted vehicle into owned_vehicles. ID: %s, Plate: %s"):format(insertId, plate)
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
    
    MySQL.scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate},
    function(result)
        p:resolve(result ~= nil)
    end)

    return Citizen.Await(p)
end

Fr.IsPlayerDead = function(source)
    return Player(source).state.isDead
end
Fr.RegisterServerCallback = function(...)
    return Framework.RegisterServerCallback(...)
end
Fr.GetPlayerFromIdentifier = function(identifier)
    return Framework.GetPlayerFromIdentifier(identifier)
end
Fr.getPlayerFromId = function(...)
    return Framework.GetPlayerFromId(...)
end
Fr.GetMoney = function(xPlayer, account)
    return xPlayer.getAccount(account).money
end
Fr.GetDirtyMoney = function(xPlayer)
    return xPlayer.getAccount("black_money").money
end
Fr.ManageMoney = function(xPlayer, account, action, amount)
    if action == "add" then
        return xPlayer.addAccountMoney(account, amount)
    else
        return xPlayer.removeAccountMoney(account, amount)
    end
end
Fr.ManageDirtyMoney = function(xPlayer, action, amount)
    if action == "add" then
        return xPlayer.addAccountMoney("black_money", amount)
    else
        return xPlayer.removeAccountMoney("black_money", amount)
    end
end
Fr.GetIndentifier = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.identifier
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
                "SELECT identifier, firstname, lastname FROM users WHERE identifier IN (" .. placeholders .. ")",
                chunk
            )
            if ok and rows then
                for _, r in pairs(rows) do
                    if r.firstname and r.lastname then
                        Fr.cacheName(r.identifier, r.firstname .. " " .. r.lastname)
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
        name = xPlayer.name
        local src = Fr.GetSourceFromPlayerObject(xPlayer)
        if name == GetPlayerName(src) then
            local first = xPlayer.get and (xPlayer.get('firstName') or xPlayer.get('firstname')) or nil
            local last = xPlayer.get and (xPlayer.get('lastName') or xPlayer.get('lastname')) or nil

            if (not first or not last) and xPlayer.getName then
                local full = xPlayer.getName()
                if full and full ~= "" and full ~= GetPlayerName(src) then
                    name = full
                    first, last = nil, nil
                end
            end

            if first or last then
                name = (tostring(first or "") .. " " .. tostring(last or "")):gsub("^%s+", ""):gsub("%s+$", "")
                if name == "" then
                    name = GetPlayerName(src) or "Unknown"
                end
            elseif not name or name == "" then
                name = GetPlayerName(src) or "Unknown"
            end
        end

        if xPlayer.identifier then
            Fr.cacheName(xPlayer.identifier, name)
        end
        return name
    end

    local key = trim(sourceOrIdentifier)
    local cached = Fr.getCachedName(key)
    if cached then return cached end

    local result = MySQL.query.await(
        "SELECT firstname, lastname FROM users WHERE identifier = ? LIMIT 1",
        { key }
    )
    if result and result[1] and (result[1].firstname or result[1].lastname) then
        name = (tostring(result[1].firstname or "") .. " " .. tostring(result[1].lastname or "")):gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then name = "Unknown" end
    else
        name = "Unknown"
    end

    Fr.cacheName(key, name)
    return name
end
Fr.GetGroup = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    return xPlayer.getGroup()
end
Fr.addItem = function(xPlayer, itemname, quantity, metadata)
    quantity = tonumber(quantity) or 0
    itemname = tostring(itemname)

    if quantity <= 0 then
        quantity = 1
    end

    if Config.Inventory.inventoryScript == "ox_inventory" and metadata then
        local src = xxPlayer.source
        local success, response = exports.ox_inventory:AddItem(src, itemname, quantity, metadata or {})
        return success, response
    else
        return xPlayer.addInventoryItem(itemname, quantity)
    end
end
Fr.removeItem = function(xPlayer, itemname, quantity)
    quantity = tonumber(quantity) or 0
    itemname = tostring(itemname)

    if quantity <= 0 then
        quantity = 1
    end

    return xPlayer.removeInventoryItem(itemname, quantity)
end
Fr.getItem = function(xPlayer, itemname)
    local item = xPlayer.getInventoryItem(itemname)
    local table
    if item then
        table = {amount = item.count, name = itemname, weight = item.weight, label = item.label}
    else 
        table = {amount = 0, name = itemname, weight = 0, label = ""}
    end
    return table
end
Fr.getInventory = function(xPlayer)
    return xPlayer.getInventory()
end
Fr.getItemInfo = function(itemName) 
    return Framework.Items[itemName] 
end

Fr.RegisterItem = function(itemName, itemEvent)
    Framework.RegisterUsableItem(itemName, function(playerId)
        local xPlayer = Fr.getPlayerFromId(playerId)
        TriggerClientEvent('op-crime:'.. itemEvent, Fr.GetSourceFromPlayerObject(xPlayer))
    end)
end
Fr.GetSourceFromPlayerObject = function(xPlayer)
    if xPlayer then
        return xPlayer.source
    else
        return nil
    end
end
Fr.GetPlayerJob = function(xPlayer)
    local job = {
        name = xPlayer.job.name,
        grade = xPlayer.job.grade
    }
    return job
end
Fr.AddMoneyToOfflineUser = function(identifier, amount, typeMoney)
    local field = typeMoney == "money" and "money" or (typeMoney == "blackmoney" and "black_money" or nil)
    if not field then return end

    local trimmedId = trim(identifier)
    local result = MySQL.query.await(
        "SELECT accounts FROM users WHERE identifier = ? LIMIT 1",
        { trimmedId }
    )
    if not (result and result[1]) then return end

    local accounts = result[1].accounts
    if type(accounts) == "string" then accounts = json.decode(accounts) end
    if type(accounts) ~= "table" then accounts = {} end

    accounts[field] = (tonumber(accounts[field]) or 0) + amount

    MySQL.Async.execute(
        "UPDATE `users` SET `accounts` = ? WHERE `identifier` = ?",
        { json.encode(accounts), trimmedId }
    )
end