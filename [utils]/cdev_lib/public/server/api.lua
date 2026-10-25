clib_API = {}

-- 🌎 Webhook URL for sending logs to Discord (only if DiscordLogs is true in config)
clib_API.DiscordWebhookURL = ""

-- 🌎 Discord credentials for checking if a player is VIP (optional)
clib_API.DiscordGuildId = ""
clib_API.DiscordBotToken = ""

-- 📣 Event that is triggered on the server when a player spawns
RegisterNetEvent(clib_Config.getFrameworkConfig().ServerPlayerLoadEvent, function(sourceId)
    TriggerEvent("cdev_lib:api:playerLoaded", clib_Config.isESX and sourceId or source)
end)

-- 📣 Event that is triggered on the server when the player job is updated
RegisterNetEvent(clib_Config.getFrameworkConfig().ServerPlayerJobUpdateEvent, function(source, job)
    if clib_Config.isQBCore then
        TriggerEvent("cdev_lib:api:jobUpdate", source, job.name, job.grade.level)
    elseif clib_Config.isESX then
        TriggerEvent("cdev_lib:api:jobUpdate", source, job.name, job.grade)
    else
        -- 🔧 If using custom, implement your own code here
    end
end)

local vipCache = {}

-- 🧍 Methods for handling character data on the server
clib_API.Character = {
    -- 🆔 Return the unique identifier for the character belonging to the player with the given source
    GetCharacterIdentifierFromSource = function(source)
        if clib_Config.isQBCore then
            return clib.frameworks.QBCore.Functions.GetPlayer(source).PlayerData.citizenid
        elseif clib_Config.isESX then
            return clib.frameworks.ESX.GetPlayerFromId(source).identifier
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 🆔 Return the source of the player with the given character identifier
    GetCharacterSourceFromIdentifier = function(citizenId)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayerByCitizenId(citizenId)
            return player and player.PlayerData.source or nil
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromIdentifier(citizenId)
            return player and player.source or nil
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 🔑 Return the license attributed for the player with the given source
    GetPlayerLicenseFromSource = function(source)
        if clib_Config.isQBCore then
            return clib.frameworks.QBCore.Functions.GetPlayer(source).PlayerData.license
        elseif clib_Config.isESX then
            return clib.frameworks.ESX.GetPlayerFromId(source).license
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 📝 Return the name of the character belonging to the player with the given source
    GetCharacterNameFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player and (player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname) or
                "Unknown"
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player and player.name or "Unknown"
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,

    GetCharacterNameFromIdentifier = function(citizenId)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayerByCitizenId(citizenId)
            if not player then
                player = clib.frameworks.QBCore.Functions.GetOfflinePlayerByCitizenId(citizenId)
            end
            return player and (player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname) or
                "Unknown"
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromIdentifier(citizenId)
            return player and player.name or "Unknown"
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 👔 Set the job of the character belonging to the player with the given source
    SetCharacterJobForSource = function(source, job, grade)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.SetJob(job, grade)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.setJob(job, grade)
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 👔 Clear job (make unemployed) for the character belonging to the player with the given source
    ClearCharacterJobForSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.SetJob("unemployed", 0)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.setJob("unemployed", 0)
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 👔 Return the job and grade of the character belonging to the player with the given source
    GetCharacterJobFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player.PlayerData.job.name, player.PlayerData.job.grade.level
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player.job.name, player.job.grade
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 💸 Return the cash of the character belonging to the player with the given source
    GetCharacterGangFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player.PlayerData.gang.name, player.PlayerData.gang.grade.level
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player.gang.name, player.gang.grade
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    GetCharacterCashFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player.PlayerData.money.cash
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player.getMoney()
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 💸 Add cash to the character belonging to the player with the given source
    AddCharacterCashForSource = function(source, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.AddMoney("cash", amount)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.addMoney(amount)
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 💸 Remove cash from the character belonging to the player with the given source
    RemoveCharacterCashFromSource = function(source, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.RemoveMoney("cash", amount)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.removeMoney(amount)
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 💸 Add bank money to the character belonging to the player with the given source
    AddCharacterBankForSource = function(source, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.AddMoney("bank", amount)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.addAccountMoney("bank", amount)
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 💸 Remove bank money from the character belonging to the player with the given source
    RemoveCharacterBankFromSource = function(source, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            player.Functions.RemoveMoney("bank", amount)
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            player.removeAccountMoney("bank", amount)
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    -- 💸 Return the bank money of the character belonging to the player with the given source
    GetCharacterBankFromSource = function(source)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            return player.Functions.GetMoney("bank")
        elseif clib_Config.isESX then
            local player = clib.frameworks.ESX.GetPlayerFromId(source)
            return player.getAccount("bank").money
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,

    -- 💎 Custom currency (e.g. crypto, vip_coins) for shop systems.
    -- Used when shop items have customCurrency in config; implement per currencyType in the blocks below.
    -- QBCore/Qbox: money types beyond cash/bank (e.g. crypto) are read from PlayerData.money[currencyType].
    GetCustomCurrencyFromSource = function(source, currencyType)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            if not player or not player.PlayerData.money then return 0 end
            local amount = player.PlayerData.money[currencyType]
            return (type(amount) == "number" and amount >= 0) and amount or 0
        elseif clib_Config.isESX then
            -- 🔧 ESX: add accounts or custom logic per currencyType (e.g. "crypto")
            return 0
        else
            -- 🔧 If using custom, implement your own code here
            return 0
        end
    end,
    AddCustomCurrencyForSource = function(source, currencyType, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            if player and amount > 0 then
                player.Functions.AddMoney(currencyType, amount)
            end
        elseif clib_Config.isESX then
            -- 🔧 ESX: add account or custom logic per currencyType
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,
    RemoveCustomCurrencyFromSource = function(source, currencyType, amount)
        if clib_Config.isQBCore then
            local player = clib.frameworks.QBCore.Functions.GetPlayer(source)
            if player and amount > 0 then
                player.Functions.RemoveMoney(currencyType, amount)
            end
        elseif clib_Config.isESX then
            -- 🔧 ESX: remove from account or custom logic per currencyType
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,

    -- Determine if a character has VIP status in your server (optional)
    IsVIP = function(source)
        if not clib_Config.public.UseVIPSystem then
            return false
        end
        if vipCache[source] ~= nil and GetGameTimer() < vipCache[source][2] + (5 * 60 * 1000) then
            return vipCache[source][1]
        end

        vipCache[source] = { false, GetGameTimer() }

        local discordIdentifier = clib_Wrappers.GetPlayerIdentifierByType(source, "discord", true)

        if not discordIdentifier then
            return false
        end

        local member = makeDiscordAPIRequest(
            "https://discord.com/api/guilds/" .. clib_API.DiscordGuildId .. "/members/" .. discordIdentifier,
            "Bot " .. clib_API.DiscordBotToken)

        if not member then
            clib_Logs.warning(
                "Couldn't fetch Discord roles, please check your discord settings in cdev_lib/public/server/api.lua and cdev_lib/public/config/config.lua")
            return false
        end

        if member.user.id == discordIdentifier then
            for _, role in pairs(member.roles) do
                for _, checkRole in pairs(clib_Config.public.VIPRoleIds) do
                    if role == checkRole then
                        vipCache[source] = { true, GetGameTimer() }
                        return true
                    end
                end
            end
        end

        return false
    end
}

-- 👔 Methods for handling jobs
clib_API.Jobs = {
    -- 📝 Used to register a new job to the framework
    -- ⚙️ properties is a table containing the following properties:
    --  - name: The name of the job
    --  - label: The label of the job
    --  - defaultDuty: Whether the job is on duty by default
    --  - offDutyPay: Whether the job receives pay when off duty
    --  - grades: A table containing the grades of the job
    --    - Each grade is a table with a string key (grade number) containing the following properties:
    --      - name: The label of the grade
    --      - payment: The payment of the grade
    ---@alias GradeTable { [string]: { name: string, payment: number } }
    ---@param properties { name: string, label: string, defaultDuty: boolean, offDutyPay: boolean, grades: GradeTable }
    RegisterJob = function(properties)
        if not properties.grades then
            properties.grades = {}
        end

        if clib.config.isQBCore then
            clib.frameworks.QBCore.Functions.AddJob(properties.name, {
                label = properties.label,
                defaultDuty = properties.defaultDuty,
                offDutyPay = properties.offDutyPay,
                grades = properties.grades,
            })
        elseif clib.config.isESX then
            local timeout = GetGameTimer()

            while table.length(ESX.GetJobs()) == 0 and timeout < timeout + 10000 do
                Wait(0)
            end

            for job, _ in pairs(ESX.GetJobs()) do
                if job == properties.name then
                    return
                end
            end

            clib_DB.Insert("INSERT INTO jobs(name, label) VALUES(?, ?)", { properties.name, properties.label })

            for level, grade in pairs(properties.grades) do
                clib_DB.Insert(
                    "INSERT INTO job_grades(job_name, grade, name, label, salary, skin_male, skin_female) VALUES(?, ?, ?, ?, ?, ?, ?)"
                    ,
                    { properties.name, level, grade.name, grade.name:gsub("^%l", string.upper), grade.payment, "{}",
                        "{}"
                    })
            end

            clib.frameworks.ESX.RefreshJobs()
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,

    DeleteJobByName = function(jobName)
        if clib.config.isESX then
            clib_DB.Query("DELETE FROM jobs WHERE name = ?", { jobName })
            clib_DB.Query("DELETE FROM job_grades WHERE job_name = ?", { jobName })
            clib.frameworks.ESX.RefreshJobs()
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,

    GetJobs = function()
        if clib.config.isQBCore then
            return clib.frameworks.QBCore.Shared.Jobs or nil
        elseif clib.config.isESX then
            -- 🔧 If using ESX, implement your own code here
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,

    GetJobInfo = function(jobName)
        if clib.config.isQBCore then
            return clib.frameworks.QBCore.Shared.Jobs[jobName] or nil
        elseif clib.config.isESX then
            -- 🔧 If using ESX, implement your own code here
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,

}

clib_API.Gangs = {
    GetGangs = function()
        if clib.config.isQBCore then
            return clib.frameworks.QBCore.Shared.Gangs or nil
        elseif clib.config.isESX then
            -- 🔧 If using ESX, implement your own code here
        else
            -- 🔧 If using custom, implement your own code here
        end
    end,

    GetGangInfo = function(gangName)
        if clib.config.isQBCore then
            return clib.frameworks.QBCore.Shared.Gangs[gangName] or nil
        elseif clib.config.isESX then
            -- 🔧 If using ESX, implement your own code here
        else
            -- 🔧 If using custom, implement your own code here
        end
    end
}

-- 👮 Methods for handling permissions
clib_API.Permission = {
    -- ✅ Check if the player with the given source has the given permission level (see yourframework_config.lua)
    HasPermissionLevel = function(source, level)
        if level == PERMISSION_NONE then
            return true
        end

        if IsPlayerAceAllowed(source, "command") then
            return true
        end

        if clib.config.isQBCore then
            local perms = clib.frameworks.QBCore.Functions.GetPermission(source)

            for perm, _ in pairs(perms) do
                local permLevel = clib.config.getFrameworkConfig().PermissionLevel[perm]

                if permLevel and permLevel >= level then
                    return true
                end
            end
        elseif clib.config.isESX then
            local perms = clib.frameworks.ESX.GetPlayerFromId(source).getGroup()
            local permLevel = clib.config.getFrameworkConfig().PermissionLevel[perms]

            if permLevel and permLevel >= level then
                return true
            end
        else
            -- 🔧 If using custom, implement your own code here
            return true
        end
    end,
    -- ✅ Check if the player with the given source has the given permission name
    HasPermissionName = function(source, name)
        if clib.config.isQBCore then
            local perms = clib.frameworks.QBCore.Functions.GetPermission(source)

            for perm, _ in pairs(perms) do
                if perm == name then
                    return true
                end
            end
        elseif clib.config.isESX then
            local perms = clib.frameworks.ESX.GetPlayerFromId(source).getGroup()

            if perms == name then
                return true
            end
        else
            -- 🔧 If using custom, implement your own code here
            return true
        end
    end,
}

-- 💬 Methods for handling notifications on server side (ideally change client api and leave this untouched)
clib_API.SNotify = {
    AddDefaultNotification = function(source, title, message, seconds)
        TriggerClientEvent("cdev_lib:api:notify:default", source, title, message, seconds)
    end,
    AddWarningNotification = function(source, title, message, seconds)
        TriggerClientEvent("cdev_lib:api:notify:warning", source, title, message, seconds)
    end,
}

clib_API.Sound = {
    Play3DSound = function(soundName, location, volume)
        local id = soundName .. math.random(1, 1000000)

        -- 2d sound resources are really loud so we'll reduce the volume manually here, you might not want to do this with an actual 3d sound resource
        volume = volume * 0.1

        exports.xsound:PlayUrlPos(-1, id, soundName, volume, location)

        -- TriggerClientEvent("xsound:stateSound", -1, "distance", { soundId = id, distance = 50.0 })
    end
}

clib_API.Inventory = {
    HasItem = function(source, item, amount)
        if clib_Config.public.Inventory == "qbcore" then
            return exports["qb-inventory"]:HasItem(source, item, amount)
        elseif clib_Config.public.Inventory == "ox" then
            return exports["ox_inventory"]:GetItemCount(source, item) >= amount
        elseif clib_Config.public.Inventory == "quasar" then
            return exports['qs-inventory']:GetItemTotalAmount(source, item) >= amount
        else
            -- 🔧 If using custom, implement your own code here
            return false
        end
    end,
    HasItemInGlovebox = function(plate, itemName, amount)
        if clib_Config.public.Inventory == "qbcore" then
            local result = clib_DB.Query('SELECT items FROM inventories WHERE identifier = ?', { "glovebox-" .. plate })
            if #result == 0 then return false end

            local gloveboxItems = json.decode(result[1].items)
            if not gloveboxItems then return false end

            for _, item in pairs(gloveboxItems) do
                if string.lower(item.name) == string.lower(itemName) then
                    return tonumber(item.amount) >= amount
                end
            end

            return false
        elseif clib_Config.public.Inventory == "ox" then
            -- ox_inventory uses "glovebox" + plate, not "glove" (see ox_inventory issue #1791). Save/delay note: see HasItemInTrunk.
            local items = exports["ox_inventory"]:GetInventoryItems("glovebox" .. plate)

            for _, item in pairs(items or {}) do
                if string.lower(item.name) == string.lower(itemName) then
                    return tonumber(item.count) >= amount
                end
            end

            return false
        else
            -- 🔧 If using custom, implement your own code here
            return false
        end
    end,
    HasItemInTrunk = function(plate, itemName, amount)
        if clib_Config.public.Inventory == "qbcore" then
            local result = clib_DB.Query('SELECT items FROM inventories WHERE identifier = ?', { "trunk-" .. plate })
            if #result == 0 then return false end

            local trunkItems = json.decode(result[1].items)
            if not trunkItems then return false end

            for _, item in pairs(trunkItems) do
                if string.lower(item.name) == string.lower(itemName) then
                    return tonumber(item.amount) >= amount
                end
            end

            return false
        elseif clib_Config.public.Inventory == "ox" then
            -- K9 / ox_inventory: Vehicle trunk data is saved to DB on a schedule (cron in ox_inventory).
            -- If the stash was unloaded, GetInventoryItems can return data up to ~5 min old, so the dog may
            -- still "detect" items after removal. To reduce this delay, in ox_inventory edit:
            --   modules/inventory/server.lua  ->  find  lib.cron.new('*/5 * * * *', ...)
            --   Change  */5  to  */2  to save every 2 min (do not go below 2 min: DB load and crash risk).
            local items = exports["ox_inventory"]:GetInventoryItems("trunk" .. plate)

            for _, item in pairs(items or {}) do
                if string.lower(item.name) == string.lower(itemName) then
                    return tonumber(item.count) >= amount
                end
            end

            return false
        else
            -- 🔧 If using custom, implement your own code here
            return false
        end
    end,
    RemoveItem = function(source, item, amount, slot, info)
        if clib_Config.public.Inventory == "qbcore" then
            return exports["qb-inventory"]:RemoveItem(source, item, amount, slot)
        elseif clib_Config.public.Inventory == "ox" then
            return exports["ox_inventory"]:RemoveItem(source, item, amount, info, slot)
        elseif clib_Config.public.Inventory == "quasar" then
            return exports['qs-inventory']:RemoveItem(source, item, amount, slot, info)
        end
    end,
    AddItem = function(source, item, amount, slot, info)
        if clib_Config.public.Inventory == "qbcore" then
            return exports["qb-inventory"]:AddItem(source, item, amount, slot, info)
        elseif clib_Config.public.Inventory == "ox" then
            return exports["ox_inventory"]:AddItem(source, item, amount, info, slot)
        elseif clib_Config.public.Inventory == "quasar" then
            return exports['qs-inventory']:AddItem(source, item, amount, slot, info)
        end
    end,
    RegisterStash = function(id, label, slots, maxWeight, owner)
        if clib_Config.public.Inventory == "ox" then
            id = tostring(id)
            exports["ox_inventory"]:RegisterStash(id, label, slots, maxWeight, owner)
        end
    end,
    OpenStash = function(source, data)
        if clib_Config.public.Inventory == "qbcore" then
            exports['qb-inventory']:OpenInventory(source, data.id, data)
        elseif clib_Config.public.Inventory == "ox" then
            exports["ox_inventory"]:forceOpenInventory(source, 'stash', data.id)
        end
    end
}

-- 📦 Database queries
clib_API.Queries = {
    CreateSettingsTable = function()
        clib_DB.Query([[
            CREATE TABLE IF NOT EXISTS `cdev_dynamic_settings` (
              `name` varchar(100) NOT NULL,
              `value` varchar(255) NOT NULL,
              PRIMARY KEY (`name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
        ]])
    end,
    FetchSettingsTable = function()
        return clib_DB.Query("SELECT * FROM cdev_dynamic_settings")
    end,
    UpsertDynamicSetting = function(key, value)
        clib_DB.Update("INSERT INTO cdev_dynamic_settings(name, value) VALUES(?, ?) ON DUPLICATE KEY UPDATE value = ?",
            {
                key,
                value,
                value,
            })
    end,
}
