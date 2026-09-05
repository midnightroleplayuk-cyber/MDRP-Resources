QBox = GetResourceState('qbx_core') == 'started' and true or false

if not QBox then return end
Framework = exports['qb-core']:GetCoreObject()

Fr.usersTable = "players"
Fr.identificatorTable = "citizenid"
Fr.Table = 'player_vehicles'
Fr.VehProps = 'mods'
Fr.OwnerTable = "citizenid"
Fr.StoredTable = 'state'
Fr.PlayerLoaded = 'op-multicharacter:charInitialized'
Fr.identifierType = "license2"

local hasDonePreloading = {}

Fr.GetIdent = function(playerId) 
    local identifier = GetPlayerIdentifierByType(playerId, "license2")

    if not identifier then
        identifier = GetPlayerIdentifierByType(playerId, "license")
    end

    return identifier
end

Fr.ValidateCharacterDetails = function(data)
    local formattedFirstName = formatName(data.name)
    local formattedLastName = formatName(data.lastname)

    local query = [[
        SELECT 1
        FROM players
        WHERE JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')) = ?
          AND JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))  = ?
        LIMIT 1
    ]]

    local result = MySQL.query.await(query, { formattedFirstName, formattedLastName })
    return result[1] ~= nil
end

lib.callback.register('op-multicharacter:validateInfo', function(source, data)
    local validated = Fr.ValidateCharacterDetails(data)
    return {status = validated}
end)

Fr.CanLogout = function(playerId)
    if inMultiChar[tostring(playerId)] then return false end
        
    return true
end

Fr.LogOut = function(playerId, cb)
    if not Fr.CanLogout(playerId) then return cb(false) end
    
    if not ServerConfig.Commands.logout.enable then 
        cb(false)
    end 

    local xPlayer = Fr.getPlayerFromId(tonumber(playerId))
    local data = Fr.GetPlayerBasicDataForLog(xPlayer)

    Framework.Player.Logout(tonumber(playerId))
    debugPrint("Player " .. playerId .. " Just logged out using command!")
    cb(true)
    if data then
        ServerConfig.formatWebHook("character_unloaded", data.name, data.id, json.encode(data.ids))
    end
end

Fr.getPlayerFromId = function(...)
    return Framework.Functions.GetPlayer(...)
end

Fr.GetGroup = function(src)
    return Framework.Functions.GetPermission(src)
end

Fr.addItem = function(xPlayer, itemname, quantity)
    if not xPlayer then return nil end
    
    return xPlayer.Functions.AddItem(itemname, quantity)
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    Wait(1000) 
    hasDonePreloading[Player.PlayerData.source] = true
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    hasDonePreloading[src] = false
end)

Fr.PlayCharacter = function(playerId, charId)
    if Framework.Player.Login(playerId, charId) then
        repeat
            Wait(10)
        until hasDonePreloading[playerId]
        debugPrint('^2[qb-core]^7 ' .. GetPlayerName(playerId) .. ' (Citizen ID: ' .. charId .. ') has successfully loaded!')
        Framework.Commands.Refresh(src)

        TriggerClientEvent(Fr.PlayerLoaded, tonumber(playerId))
    end
end

Fr.NewCharacter = function(playerId, charId, data)
    playerId = tonumber(playerId)
    if not playerId then return end

    hasDonePreloading[playerId] = nil

    local gender = 0
    if data.sex == "f" then
        gender = 1
    end

    local newData = {
        cid = charId,
        charinfo = {
            birthdate = data.dateofbirth,
            nationality = data.nationality,
            firstname = data.firstname,
            lastname = data.lastname,
            gender = gender
        }
    }

    if Framework.Player.Login(playerId, nil, newData) then
        local start = GetGameTimer()
        local timeout = 25000 

        while not hasDonePreloading[playerId] do
            Wait(10)

            if not GetPlayerName(playerId) then
                hasDonePreloading[playerId] = nil
                return
            end

            if GetGameTimer() - start > timeout then
                debugPrint(('[Fr] ^1Preloading timeout^7 (NEW CHAR) playerId=%s charId=%s'):format(playerId, charId))
                hasDonePreloading[playerId] = nil
                return
            end
        end

        debugPrint(('^2[qb-core]^7 %s has successfully loaded!'):format(GetPlayerName(playerId) or 'unknown'))
        Framework.Commands.Refresh(playerId)
        TriggerClientEvent(Fr.PlayerLoaded, playerId)
    end
end

Fr.GetCharactersList = function(playerId)
    local identifier = Fr.GetIdent(playerId)
    local slots = Fr.GetPlayerSlots(identifier, playerId)

    local rawCharacters = Fr.GetPlayerInfo(identifier, slots)
    local characters = nil
    local newCharId = 1

    debugPrint("Player Characters", json.encode(rawCharacters))

    if rawCharacters then
        local characterCount = #rawCharacters
        characters = {}

        local usedIds = {}

        for i = 1, characterCount do
            local v = rawCharacters[i]
            local cid = tonumber(v.cid)

            if cid then
                usedIds[cid] = true
            else
                debugPrint("^3[WARN]^0 Character without valid cid:", json.encode(v))
            end
        end

        newCharId = 1
        while usedIds[newCharId] do
            newCharId = newCharId + 1
        end

        for i = 1, characterCount, 1 do
            local v = rawCharacters[i]
            local charinfo = json.decode(v.charinfo or "{}")
            local jobData = json.decode(v.job or "{}")
            local gangData = json.decode(v.gang or "{}")
            local accountData = json.decode(v.money or "{}")

            local job = jobData and jobData.label or "Unemployed"
            local grade = jobData and jobData.grade and jobData.grade.name or ""
            local gang = gangData and gangData.label or nil
            local gangGradeName = gangData and gangData.grade and gangData.grade.name or nil

            local skin = {}

            if type(convertSkin) == "function" then
                skin = convertSkin(v.citizenid)
            else
                debugPrint("^3[WARN]^0 Compatible appearance script not found! Skipped convert ped appearance.")
            end

            if type(skin) == "table" then
                if type(getTattoos) == "function" then
                    skin.tattoos = getTattoos(v.citizenid)
                end
            else
                debugPrint("^1[WARN]^0 Expected 'skin' to be a table, got:", type(skin))
                skin = {}
            end

            local position = nil

            if v.position and type(v.position) == "string" then
                local ok, decoded = pcall(json.decode, v.position)
                if ok and type(decoded) == "table" then
                    position = decoded
                end
            end

            if type(Fr.GetCharacterGang) == "function" then
                local returnedGang = Fr.GetCharacterGang(v.citizenid)
                if returnedGang then
                    gang = returnedGang.name
                    gangGradeName = returnedGang.rank
                end
            end

            local pos = position or {}

            characters[i] = {
                id = v.citizenid,
                login = v.citizenid,
                bank = accountData.bank or 0,
                money = accountData.cash or 0,
                job = job,
                job_grade = grade,
                gang = gang,
                gangName = gangGradeName,
                firstname = charinfo.firstname or "Unknown",
                lastname = charinfo.lastname or "",
                dateofbirth = charinfo.birthdate or charinfo.dateofbirth,
                skin = skin,
                disabled = false,
                sex = charinfo.gender == 0 and "male" or "female",
                lastPos = vec4(pos.x or 0.0, pos.y or 0.0, pos.z or 0.0, pos.w or 0.0)
            }
        end
    end

    debugPrint(
        tostring(playerId) .. " | Final player data:",
        json.encode({ chars = characters, slots = slots, newCharId = newCharId })
    )

    return { chars = characters, slots = slots, newCharId = newCharId }
end

Fr.GetPlayerSlots = function(identifier, src)
    if not ServerConfig.DiscordRanks.enable then
        local slots = MySQL.scalar.await("SELECT slots FROM multicharacter_slots WHERE identifier = ?", { identifier })
            or Config.Misc.DefaultCharsAmount

        debugPrint("[01] Player " .. identifier .. " Slots:", slots)
        return slots
    end

    local finalSlots = Config.Misc.DefaultCharsAmount
    local playerDiscord = Fr.GetDiscordId(src)

    debugPrint("Player " .. src .. " discord id:", playerDiscord)

    if not playerDiscord then
        debugPrint("[04] Player " .. src .. " Slots:", finalSlots)
        return finalSlots
    end

    local roles = DiscordGetMemberSync(tostring(playerDiscord))

    if not roles or #roles == 0 then
        debugPrint("[02] Player " .. src .. " Slots:", finalSlots)
        return finalSlots
    end

    local roleSlots = ServerConfig.DiscordRanks.ranks or {}
    local bestRole, bestSlots = nil, finalSlots

    for _, roleId in ipairs(roles) do
        roleId = tostring(roleId)
        local slotsForRole = tonumber(roleSlots[roleId])

        if slotsForRole and slotsForRole > bestSlots then
            bestSlots = slotsForRole
            bestRole = roleId
        end
    end

    finalSlots = bestSlots

    if bestRole then
        debugPrint(("[03] Player %s Slots: %s (best role: %s)"):format(src, finalSlots, bestRole))
    else
        debugPrint("[03] Player " .. src .. " Slots:", finalSlots)
    end

    return finalSlots
end

Fr.GetPlayerInfo = function(identifier, slots)
    debugPrint("Requesting data from database, char limit:", slots, "Identifier", identifier)
    return MySQL.query.await(
    "SELECT * FROM players WHERE license = ? LIMIT ?",
    { identifier, slots })
end

Fr.GetIdentifier = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.PlayerData.citizenid
end

Fr.VehiclePurchased = function(model, playerId)
    local readyModel = joaat(model)
    local ident = Fr.GetIdentifier(playerId)
    local ident2 = Fr.GetIdent(playerId)

    if not ident then return print('[ERROR] Unable to assign vehicle to player with id:', playerId) end

    local plate = generatePlate()

    local query = [[
        INSERT INTO `player_vehicles`
        (`license`, `vehicle`, `hash`, `citizenid`, `plate`, `mods`)
        VALUES (?, ?, ?, ?, ?, ?)
    ]]

    local params = {
        ident2,
        model,
        readyModel,
        ident,
        plate,
        json.encode({ model = readyModel, plate = plate })
    }

    MySQL.Async.insert(query, params, function(insertId)
        if not insertId then
            debugPrint(("[^1ERROR^7] Failed to insert vehicle with plate %s into owned_vehicles"):format(plate))
        else
            local insertInfo = ("[^2INFO^7] Inserted vehicle into owned_vehicles. ID: %s, Plate: %s"):format(insertId, plate)
            debugPrint(insertInfo)
        end
    end)
end

Fr.IsPlateTaken = function(plate)
    local p = promise.new()
    
    MySQL.scalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate},
    function(result)
        p:resolve(result ~= nil)
    end)

    return Citizen.Await(p)
end

Fr.AddMoney = function(Player, account, amount)
    if account == "money" then account = "cash" end

    return Player.Functions.AddMoney(account, amount)
end

Fr.FormatNewCharId = function(charId)
    return charId
end

Fr.GetPlayerBasicDataForLog = function(Player)
    if not Player then return nil end

    local name = Player.PlayerData.charinfo.firstname .." ".. Player.PlayerData.charinfo.lastname

    local idTable = Fr.getIdents(Player.PlayerData.source)

    return {
        name = name,
        id = Player.PlayerData.citizenid,
        ids = idTable
    }
end

Fr.DeleteChar = function(src, login)
    local identifier = Fr.GetIdent(src)
    
    local res = MySQL.query.await("SELECT `citizenid` FROM `players` WHERE `license` = ? AND `citizenid` = ?", {identifier, login})

    if #res > 0 then 
        MySQL.query.await(
            "DELETE FROM `players` WHERE `license` = ? AND `citizenid` = ?",
            { identifier, login }
        )
    end
end

--- Admin delete by citizenid.
Fr.AdminDeleteChar = function(charId)
    charId = tostring(charId or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if charId == "" then
        return false, "missing"
    end

    local existing = MySQL.scalar.await("SELECT citizenid FROM players WHERE citizenid = ? LIMIT 1", { charId })
    if not existing then
        return false, "not_found"
    end

    for _, playerId in ipairs(GetPlayers()) do
        local src = tonumber(playerId)
        local Player = src and Fr.getPlayerFromId(src) or nil
        if Player and Player.PlayerData and tostring(Player.PlayerData.citizenid) == tostring(existing) then
            DropPlayer(src, "Your character was deleted by an administrator.")
        end
    end

    MySQL.query.await("DELETE FROM `players` WHERE `citizenid` = ?", { existing })
    return true, existing
end

if not ServerConfig.EnableDiscordRanks then 
    if ServerConfig.Commands.setslots.enable then 
        Framework.Commands.Add(ServerConfig.Commands.setslots.command, TranslateIt('command_setslots_help'), { 
            { name = 'player', help = TranslateIt('command_setslots_player') }, 
            { name = 'slots', help = TranslateIt('command_setslots_slots') } 
        }, true, function(source, args)
            local license = args[1]
            local amount = tonumber(args[2])
            setSlots(license, amount, source) 

            TriggerClientEvent('op-multicharacter:sendNotify', source, TranslateIt('command_setslots_success', amount), "success", 5)
        end, ServerConfig.Commands.setslots.allowed)
    end
end

if ServerConfig.Commands.logout.enable then 
    Framework.Commands.Add(ServerConfig.Commands.logout.command, TranslateIt('command_logout_help'), {}, 
    true, function(source, args)
        Fr.LogOut(tostring(source), function(res)
            if res then 
                TriggerClientEvent('op-multicharacter:sendNotify', source, TranslateIt('command_logout_success'), "success", 5)
                TriggerClientEvent('op-multicharacter:completeLogout', source)
            else 
                TriggerClientEvent('op-multicharacter:sendNotify', source, TranslateIt('command_logout_error'), "error", 5)
            end
        end)
    end, ServerConfig.Commands.logout.allowed)
end

if ServerConfig.Commands.delchar and ServerConfig.Commands.delchar.enable then
    Framework.Commands.Add(ServerConfig.Commands.delchar.command, TranslateIt('command_delchar_help'), {
        { name = 'charid', help = TranslateIt('command_delchar_charid') },
    }, true, function(source, args)
        local charId = args[1]
        local ok, detail = Fr.AdminDeleteChar(charId)
        if ok then
            TriggerClientEvent('op-multicharacter:sendNotify', source, TranslateIt('command_delchar_success', detail), "success", 5)
            local Player = Fr.getPlayerFromId(source)
            local adminData = Player and Fr.GetPlayerBasicDataForLog(Player) or nil
            if adminData then
                ServerConfig.formatWebHook(
                    "character_deleted_admin",
                    adminData.name,
                    detail,
                    json.encode(adminData.ids)
                )
            end
        elseif detail == "missing" then
            TriggerClientEvent('op-multicharacter:sendNotify', source, TranslateIt('command_delchar_usage'), "error", 5)
        else
            TriggerClientEvent('op-multicharacter:sendNotify', source, TranslateIt('command_delchar_not_found', tostring(charId)), "error", 5)
        end
    end, ServerConfig.Commands.delchar.allowed)
end