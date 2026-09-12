if config.items.active then
    for item, _ in pairs(config.items.items) do
        tgiCore.CreateUseableItem(item, function(source)
            if not canOpen(source, config.items.items[item]) then
                return Notify(source, "cantOpen", "error")
            end
            SetPlayerRadioItem(source, item)
            TriggerClientEvent('tgiann-radio-v2:use', source, item)
        end)
    end
end

local function checkTable(table, val)
    if type(val) ~= "table" then val = { val } end
    for i = 1, #table do
        for x = 1, #val do
            if table[i] == val[x] then
                return true
            end
        end
    end
    return false
end

function getPlayerJob(src)
    if not config.framework then return "" end
    local xPlayer = tgiCore.getPlayer(src)
    if not xPlayer then return "" end
    return tgiCore.getJob(xPlayer)
end

function getCid(src)
    if not config.framework then return GetPlayerIdentifiers(src)[1] end
    local xPlayer = tgiCore.getPlayer(src)
    if not xPlayer then return GetPlayerIdentifiers(src)[1] end
    return tgiCore.getCid(xPlayer)
end

function canOpen(src, data)
    local checkJob = data.jobs and next(data.jobs)
    if checkJob then
        local job = getPlayerJob(src)
        local gradeList = data.jobs[job.name]
        if gradeList then
            if type(gradeList) == "table" then
                local grade = config.framework == "esx" and tonumber(job.grade) or tonumber(job.grade.level)
                if checkTable(gradeList, grade) then
                    return true
                end
            else
                return true
            end
        end
    end

    local checkDiscord = data.discord and #data.discord > 0
    if checkDiscord then
        local discordIds = tgiCore.GetDiscordRoles(src)
        if checkTable(data.discord, discordIds) then
            return true
        end
    end

    local checkAcePerms = data.acePerms and #data.acePerms > 0
    if checkAcePerms then
        for i = 1, #data.acePerms do
            if IsPlayerAceAllowed(src, data.acePerms[i]) then
                return true
            end
        end
    end

    if not checkJob and not checkDiscord and not checkAcePerms then
        return true
    end

    return false
end

local nonFrameworkItem = next(config.items.items)

lib.callback.register("tgiann-raido-v2:openRadio", function(source)
    if not config.items.active or not config.framework then
        return nonFrameworkItem
    end

    -- Items without a custom distance win when the player carries more than one radio
    local haveItemAmount = 0
    local xPlayer = tgiCore.getPlayer(source)
    local pick
    for itemName, itemCfg in pairs(config.items.items) do
        local itemData = tgiCore.getItemByName(xPlayer, itemName)
        if itemData.amount > 0 then
            haveItemAmount = haveItemAmount + 1
            if canOpen(source, itemCfg) and (not pick or (config.items.items[pick].distance and not itemCfg.distance)) then
                pick = itemName
            end
        end
    end
    if pick then
        SetPlayerRadioItem(source, pick)
        return pick
    end
    return false, haveItemAmount > 0 and "cantOpen" or "noRadio"
end)

if config.micClickCommand.active then
    lib.addCommand(config.micClickCommand.name, {
        help = t("micClickDesc"),
    }, function(source)
        TriggerClientEvent("tgiann-radio-v2:micClickSound", source)
    end)
end

if config.micClickSyncCommand.active then
    lib.addCommand(config.micClickSyncCommand.name, {
        help = t("micClickSyncDesc"),
    }, function(source)
        TriggerClientEvent("tgiann-radio-v2:micClickSyncSound", source)
    end)
end

for command, commandData in pairs(config.commands) do
    if commandData.active then
        if config.framework then
            if commandData.args then
                for x = 1, #commandData.args do
                    commandData.args[x].help = t(commandData.args[x].help)
                end
            end
            tgiCore.CommandsAdd(commandData.command, t(commandData.desc), commandData.args or {}, commandData.args and true or false, function(source, args)
                TriggerClientEvent("tgiann-radio-v2:usingCommand", source, command, args)
            end, commandData.perms)
        else
            RegisterCommand(commandData.command, function(source)
                TriggerClientEvent("tgiann-radio-v2:usingCommand", source, command, args)
            end, false)
        end
    end
end
