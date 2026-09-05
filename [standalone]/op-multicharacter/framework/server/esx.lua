ESX = GetResourceState('es_extended') == 'started' and true or false

if not ESX then return end
Framework = nil

local ok, result = pcall(function()
    return exports["es_extended"]:getSharedObject()
end)

if ok and result then
    Framework = result
else
    -- ESX 1.6 / older forks: shared object via event (export may be missing).
    TriggerEvent("esx:getSharedObject", function(obj)
        Framework = obj
    end)

    local waited = 0
    while Framework == nil and waited < 10000 do
        Wait(50)
        waited = waited + 50
        if not ok then
            pcall(function()
                Framework = exports["es_extended"]:getSharedObject()
            end)
        end
    end

    if not Framework then
        print("^1[op-multicharacter]^0 Failed to get ESX shared object (ESX 1.6?). Multichar server ESX bridge will not work.^0")
        return
    end
end

Fr.usersTable = "users"
Fr.identificatorTable = "identifier"
Fr.Table = 'owned_vehicles'
Fr.VehProps = 'vehicle'
Fr.OwnerTable = "owner"
Fr.StoredTable = "stored"
Fr.PlayerLoaded = 'esx:playerLoaded'
Fr.identifierType = GetConvar("esx:identifier", "license") or "license"
Fr.Prefix = "char"

Fr.ValidateCharacterDetails = function(data)
    local formattedFirstName = formatName(data.name)
    local formattedLastName = formatName(data.lastname)

    local query = 'SELECT 1 FROM users WHERE firstname = ? AND lastname = ? LIMIT 1'
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

    TriggerEvent('esx:playerLogout', tonumber(playerId), function()
        debugPrint("Player " .. playerId .. " Just logged out using command!")

        cb(true)
        if data then
            ServerConfig.formatWebHook("character_unloaded", data.name, data.id, json.encode(data.ids))
        end
    end)
end

Fr.getPlayerFromId = function(...)
    return Framework.GetPlayerFromId(...)
end

Fr.GetGroup = function(src)
    local xPlayer = Fr.getPlayerFromId(src)
    return xPlayer and xPlayer.getGroup and xPlayer.getGroup() or nil
end

Fr.addItem = function(xPlayer, itemname, quantity)
    if not xPlayer then return nil end

    return xPlayer.addInventoryItem(itemname, quantity)
end

Fr.PlayCharacter = function(playerId, charId)
    TriggerEvent("esx:onPlayerJoined", playerId, charId)
    -- ESX 1.6 / some forks don't expose Players + GetIdentifier the same way as Legacy.
    pcall(function()
        if Framework and Framework.Players and type(Framework.GetIdentifier) == "function" then
            Framework.Players[Framework.GetIdentifier(playerId)] = charId
        end
    end)
end

Fr.NewCharacter = function(playerId, charId, data)
    TriggerEvent('esx:onPlayerJoined', playerId, charId, data)
end

Fr.GetPlayerBasicDataForLog = function(xPlayer)
    if not xPlayer then
        return nil
    end

    local name = xPlayer.name
    if name == GetPlayerName(xPlayer.source) then
        --name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
    end

    local idTable = Fr.getIdents(xPlayer.source)

    local data = {
        name = name,
        id = xPlayer.identifier,
        ids = idTable
    }

    return data
end

Fr.DeleteChar = function(src, login)
    local identifier = GetPlayerIdentifierByType(src, Fr.identifierType)
    identifier = identifier:gsub(("%s:"):format(Fr.identifierType), "") 
    local finalChar = login .. ":" .. identifier

    local query = "DELETE FROM `users` WHERE `identifier` = '"..finalChar.."'"
    MySQL.query.await(query)
end

--- Admin delete by full character identifier (e.g. char1:abc123license).
---@return boolean ok
---@return string|nil detail deleted id or error key
Fr.AdminDeleteChar = function(charId)
    charId = tostring(charId or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if charId == "" then
        return false, "missing"
    end

    local existing = MySQL.scalar.await("SELECT identifier FROM users WHERE identifier = ? LIMIT 1", { charId })
    if not existing then
        return false, "not_found"
    end

    for _, playerId in ipairs(GetPlayers()) do
        local src = tonumber(playerId)
        local xPlayer = src and Fr.getPlayerFromId(src) or nil
        if xPlayer and tostring(xPlayer.identifier) == tostring(existing) then
            DropPlayer(src, "Your character was deleted by an administrator.")
        end
    end

    MySQL.query.await("DELETE FROM `users` WHERE `identifier` = ?", { existing })
    return true, existing
end

--- Resolve license / license2 hash for a connecting player (ESX 1.6 often has only one).
local function getPlayerLicenseHash(playerId)
    local tried = {}
    local order = { Fr.identifierType, "license", "license2" }

    for i = 1, #order do
        local idType = order[i]
        if idType and not tried[idType] then
            tried[idType] = true
            local raw = GetPlayerIdentifierByType(playerId, idType)
            if type(raw) == "string" and raw ~= "" then
                return raw:gsub("^[^:]+:", ""), idType
            end
        end
    end

    local ids = GetPlayerIdentifiers(playerId)
    for _, id in ipairs(ids or {}) do
        local prefix, value = id:match("^([^:]+):(.+)$")
        if value and (prefix == "license" or prefix == "license2") then
            return value, prefix
        end
    end

    return nil, nil
end

--- Supports:
---  - Legacy ESX / flat:   "abc123hash" (+ optional users.Char slot)
---  - Numeric prefix:      "1:abc123hash" / "2:abc123hash"
---  - Modern multichar:    "char1:abc123hash"
---@return number|nil slot
---@return string|nil login  value passed to esx:onPlayerJoined / chooseCharacter
local function parseCharacterIdentity(dbIdentifier, charColumn)
    if type(dbIdentifier) ~= "string" or dbIdentifier == "" then
        return nil, nil
    end

    -- Modern multichar: char1:licensehash
    local slotStr, rest = dbIdentifier:match("^char(%d+):(.+)$")
    if slotStr and rest and rest ~= "" then
        return tonumber(slotStr), "char" .. slotStr
    end

    -- Numeric prefix forks: 1:licensehash / 2:licensehash
    local numSlot, numRest = dbIdentifier:match("^(%d+):(.+)$")
    if numSlot and numRest and numRest ~= "" then
        return tonumber(numSlot), tostring(numSlot)
    end

    -- Flat hash (ESX 1.6 style in this DB) — one row per license, slot from Char col.
    if not dbIdentifier:find(":", 1, true) then
        local slot = tonumber(charColumn) or 1
        return slot, dbIdentifier
    end

    return nil, nil
end

local function getEsxJobs()
    if not Framework then return {} end
    -- Must call GetJobs() with no args (same as 2.0.0). Passing Framework as
    -- first arg can break forks that treat the arg as a filter.
    if type(Framework.GetJobs) == "function" then
        local ok, jobs = pcall(function()
            return Framework.GetJobs()
        end)
        if ok and type(jobs) == "table" then return jobs end
    end
    if type(Framework.Jobs) == "table" then
        return Framework.Jobs
    end
    return {}
end

--- Resolve ESX job/grade display labels (2.0.0 path + key fallbacks).
local function resolveEsxJobLabels(jobsList, jobName, jobGrade)
    local rawJob = (type(jobName) == "string" and jobName ~= "") and jobName or "unemployed"
    -- Match 2.0.0: tostring(job_grade) without forcing 0 (nil → handled below).
    local gradeKey = jobGrade ~= nil and tostring(jobGrade) or "0"
    local gradeNum = tonumber(jobGrade) or tonumber(gradeKey) or 0

    if type(jobsList) ~= "table" then
        return rawJob, gradeKey
    end

    local jobData = jobsList[rawJob]
    if type(jobData) ~= "table" then
        return rawJob, gradeKey
    end

    local grades = jobData.grades
    -- Same gate as 2.0.0: only rewrite labels when grade entry exists.
    local gradeData = type(grades) == "table" and (grades[gradeKey] or grades[gradeNum]) or nil
    if type(gradeData) ~= "table" and type(grades) == "table" then
        for _, g in pairs(grades) do
            if type(g) == "table" and tonumber(g.grade) == gradeNum then
                gradeData = g
                break
            end
        end
    end

    if type(gradeData) == "table" then
        local jobLabel = jobData.label or rawJob
        if rawJob == "unemployed" then
            return jobLabel, ""
        end
        return jobLabel, gradeData.label or gradeData.name or gradeKey
    end

    return rawJob, gradeKey
end

Fr.GetCharactersList = function(playerId)
    local identifier = getPlayerLicenseHash(playerId)
    if type(identifier) ~= "string" or identifier == "" then
        print(("^1[op-multicharacter]^0 GetCharactersList: no license/license2 for player %s^0")
            :format(tostring(playerId)))
        return {
            chars = {},
            slots = (Config.Misc and Config.Misc.DefaultCharsAmount) or 1,
            newCharId = 1,
        }
    end

    local slots = Fr.GetPlayerSlots(identifier, playerId)
    local rawCharacters = Fr.GetPlayerInfo(identifier, slots)

    debugPrint("Player RAW Characters", json.encode(rawCharacters))

    local characters = {}
    local usedIds = {}
    local newCharId = 1

    if type(rawCharacters) == "table" then
        local jobsList = getEsxJobs()

        for i = 1, #rawCharacters do
            local v = rawCharacters[i]
            local accounts = {}

            if type(v.accounts) == "string" then
                local ok, decoded = pcall(json.decode, v.accounts)
                if ok and type(decoded) == "table" then
                    accounts = decoded
                else
                    accounts = { bank = 0, money = 0 }
                end
            elseif type(v.accounts) == "table" then
                accounts = v.accounts
            end

            local id, login = parseCharacterIdentity(v.identifier, v.Char or v["Char"])
            if not id then
                debugPrint("^1[WARNING] Failed to parse identifier → " .. tostring(v.identifier) .. "^0 Skipping..")
            else
                -- Avoid slot collisions when mixing flat + prefixed rows.
                while usedIds[id] do
                    id = id + 1
                end
                usedIds[id] = true
                if not login or login == "" then
                    login = (Fr.Prefix or "char") .. tostring(id)
                end

                local job, grade = resolveEsxJobLabels(jobsList, v.job, v.job_grade)

                local skin = {}
                if type(convertSkin) == "function" then
                    local skinOk, skinResult = pcall(convertSkin, v.identifier)
                    if skinOk and type(skinResult) == "table" then
                        skin = skinResult
                    else
                        debugPrint("^3[WARN]^0 convertSkin failed for", tostring(v.identifier), skinResult)
                        skin = {}
                    end
                end

                if type(skin) == "table" and type(getTattoos) == "function" then
                    local tatOk, tats = pcall(getTattoos, v.identifier)
                    if tatOk then
                        skin.tattoos = tats
                    end
                end

                local position = nil
                if v.position and type(v.position) == "string" then
                    local ok, decoded = pcall(json.decode, v.position)
                    if ok and type(decoded) == "table" then
                        position = decoded
                    end
                elseif type(v.position) == "table" then
                    position = v.position
                end

                local gang, gangGradeName = "None", "None"
                if type(Fr.GetCharacterGang) == "function" then
                    local gangOk, returnedGang = pcall(Fr.GetCharacterGang, v.identifier)
                    if gangOk and returnedGang then
                        gang = returnedGang.name
                        gangGradeName = returnedGang.rank
                    end
                end

                local pos = position or {}
                local sexRaw = v.sex
                local sex = "male"
                if sexRaw == "f" or sexRaw == "female" or tonumber(v.is_male) == 0 then
                    sex = "female"
                end

                characters[#characters + 1] = {
                    id = v.identifier,
                    login = login,
                    bank = accounts.bank or 0,
                    money = accounts.money or 0,
                    job = job,
                    job_grade = grade,
                    gang = gang or "None",
                    gangName = gangGradeName or "None",
                    firstname = v.firstname,
                    lastname = v.lastname,
                    dateofbirth = v.dateofbirth,
                    skin = skin,
                    disabled = v.disabled,
                    sex = sex,
                    lastPos = vec4(pos.x or 0.0, pos.y or 0.0, pos.z or 0.0, pos.heading or 0.0),
                }
            end
        end

        newCharId = 1
        while usedIds[newCharId] do
            newCharId = newCharId + 1
        end
    end

    debugPrint(
        tostring(playerId) .. " | Final player data:",
        json.encode({ chars = characters, slots = slots, newCharId = newCharId })
    )

    return { chars = characters, slots = slots, newCharId = newCharId }
end

Fr.GetPlayerSlots = function(identifier, src)
    local defaultSlots = (Config.Misc and Config.Misc.DefaultCharsAmount) or 1

    if not ServerConfig.DiscordRanks.enable then
        local slots = MySQL.scalar.await(
            "SELECT slots FROM multicharacter_slots WHERE identifier = ?",
            { identifier }
        )

        -- Legacy ESX 1.6 DBs (this dump): MaxChars column on users instead of multicharacter_slots.
        if not slots then
            local ok, maxChars = pcall(function()
                return MySQL.scalar.await([[
                    SELECT MAX(CAST(MaxChars AS UNSIGNED))
                    FROM users
                    WHERE identifier = ?
                       OR identifier LIKE ?
                       OR identifier LIKE ?
                ]], {
                    identifier,
                    "char%:" .. identifier,
                    "%:" .. identifier,
                })
            end)
            if ok and maxChars then
                slots = tonumber(maxChars)
            end
        end

        slots = tonumber(slots) or defaultSlots
        debugPrint("[01] Player " .. identifier .. " Slots:", slots)
        return slots
    end

    local finalSlots = defaultSlots
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
    identifier = tostring(identifier)
    slots = tonumber(slots) or ((Config.Misc and Config.Misc.DefaultCharsAmount) or 1)

    -- Flat hash (ESX 1.6), modern charN:hash, and numeric N:hash.
    local sql = ([[
        SELECT * FROM users
        WHERE identifier = ?
           OR identifier LIKE ?
           OR identifier LIKE ?
        LIMIT %d
    ]]):format(slots)

    return MySQL.query.await(sql, {
        identifier,
        "char%:" .. identifier,
        "%:" .. identifier,
    })
end

Fr.GetIdentifier = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.identifier
end

Fr.VehiclePurchased = function(model, playerId)
    local readyModel = joaat(model)
    local ident = Fr.GetIdentifier(playerId)

    if not ident then return print('[ERROR] Unable to assign vehicle to player with id:', playerId) end

    local plate = generatePlate()

    local query = [[
        INSERT INTO `owned_vehicles`
        (`owner`, `plate`, `vehicle`)
        VALUES (?, ?, ?)
    ]]

    local params = {
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
    
    MySQL.scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate},
    function(result)
        p:resolve(result ~= nil)
    end)

    return Citizen.Await(p)
end

Fr.AddMoney = function(xPlayer, account, amount)
    if not xPlayer then return end
    return xPlayer.addAccountMoney(account, amount)
end

Fr.FormatNewCharId = function(charId)
    return Fr.Prefix .. charId
end

if not ServerConfig.EnableDiscordRanks then
    if ServerConfig.Commands.setslots.enable then 
        Framework.RegisterCommand(ServerConfig.Commands.setslots.command, ServerConfig.Commands.setslots.allowed, 
        function(xPlayer, args)
            local identifier = args.player
            local amount = tonumber(args.slots)
            setSlots(identifier, amount, xPlayer.source) 

            TriggerClientEvent('op-multicharacter:sendNotify', xPlayer.source, TranslateIt('command_setslots_success', amount), "success", 5)
        end, true, {
            help = TranslateIt('command_setslots_help'),
            validate = true,
            arguments = {
                { name = "player", help = TranslateIt('command_setslots_player'), type = "string" },
                { name = "slots", help = TranslateIt('command_setslots_slots'), type = "number" },
            },
        })
    end
end

if ServerConfig.Commands.logout.enable then 
    Framework.RegisterCommand(ServerConfig.Commands.logout.command, ServerConfig.Commands.logout.allowed, 
    function(xPlayer, args)
        if not xPlayer then return end

        Fr.LogOut(tostring(xPlayer.source), function(res)
            if res then 
                TriggerClientEvent('op-multicharacter:sendNotify', xPlayer.source, TranslateIt('command_logout_success'), "success", 5)
                TriggerClientEvent('op-multicharacter:completeLogout', xPlayer.source)
            else 
                TriggerClientEvent('op-multicharacter:sendNotify', xPlayer.source, TranslateIt('command_logout_error'), "error", 5)
            end
        end)
    end, true, {
        help = TranslateIt('command_logout_help'),
        validate = false,
        arguments = {},
    })
end

if ServerConfig.Commands.delchar and ServerConfig.Commands.delchar.enable then
    Framework.RegisterCommand(ServerConfig.Commands.delchar.command, ServerConfig.Commands.delchar.allowed,
    function(xPlayer, args)
        if not xPlayer then return end
        local charId = args.charid
        local ok, detail = Fr.AdminDeleteChar(charId)
        if ok then
            TriggerClientEvent('op-multicharacter:sendNotify', xPlayer.source, TranslateIt('command_delchar_success', detail), "success", 5)
            local adminData = Fr.GetPlayerBasicDataForLog(xPlayer)
            if adminData then
                ServerConfig.formatWebHook(
                    "character_deleted_admin",
                    adminData.name,
                    detail,
                    json.encode(adminData.ids)
                )
            end
        elseif detail == "missing" then
            TriggerClientEvent('op-multicharacter:sendNotify', xPlayer.source, TranslateIt('command_delchar_usage'), "error", 5)
        else
            TriggerClientEvent('op-multicharacter:sendNotify', xPlayer.source, TranslateIt('command_delchar_not_found', tostring(charId)), "error", 5)
        end
    end, true, {
        help = TranslateIt('command_delchar_help'),
        validate = true,
        arguments = {
            { name = "charid", help = TranslateIt('command_delchar_charid'), type = "string" },
        },
    })
end