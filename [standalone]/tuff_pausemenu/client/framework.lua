Client = Client or {}
Client.Framework = Client.Framework or {}

Client.Framework.Notify = function(description, notifyType)
    if lib and lib.notify then
        lib.notify({
            description = description,
            type = notifyType or "inform"
        })

        return
    end

    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(description)
    EndTextCommandThefeedPostTicker(false, false)
end

Client.Framework.HideHUD = function()
    if GetResourceState("tuff-hud") == "started" then
        exports["tuff-hud"]:Hide()
    end
end

Client.Framework.ShowHUD = function()
    if GetResourceState("tuff-hud") == "started" then
        exports["tuff-hud"]:Show()
    end
end

Client.Framework.GetPlayerData = function()
    if not Framework then
        return nil
    end

    if Settings.Framework == "ESX" and Framework.GetPlayerData then
        return Framework.GetPlayerData()
    end

    if (Settings.Framework == "QBCore" or Settings.Framework == "Qbox") and Framework.Functions and Framework.Functions.GetPlayerData then
        return Framework.Functions.GetPlayerData()
    end

    return nil
end

Client.Framework.GetAccountMoney = function(accounts, accountNames)
    if type(accounts) ~= "table" then
        return 0
    end

    for _, account in pairs(accounts) do
        local accountName = account.name or account.account

        for i = 1, #accountNames do
            if accountName == accountNames[i] then
                return account.money or account.amount or account.cash or 0
            end
        end
    end

    return 0
end

Client.Framework.GetCharacterName = function(playerData)
    if Settings.Framework == "ESX" then
        local firstName = Client.Functions.Trim(playerData and (playerData.firstName or playerData.firstname))
        local lastName = Client.Functions.Trim(playerData and (playerData.lastName or playerData.lastname))
        local fullName = Client.Functions.Trim(("%s %s"):format(firstName, lastName))

        if fullName ~= "" then
            return fullName
        end

        local esxName = Client.Functions.Trim(playerData and playerData.name)
        if esxName ~= "" then
            return esxName
        end
    end

    if Settings.Framework == "QBCore" or Settings.Framework == "Qbox" then
        local charinfo = playerData and playerData.charinfo

        if type(charinfo) == "table" then
            local firstName = Client.Functions.Trim(charinfo.firstname)
            local lastName = Client.Functions.Trim(charinfo.lastname)
            local fullName = Client.Functions.Trim(("%s %s"):format(firstName, lastName))

            if fullName ~= "" then
                return fullName
            end
        end
    end

    return GetPlayerName(PlayerId())
end

Client.Framework.GetJobLabel = function(playerData)
    local job = playerData and playerData.job

    if type(job) ~= "table" then
        return Client.Functions.GetString({ "Menu", "Fallbacks", "NoJob" }, "No job")
    end

    if Settings.Framework == "ESX" then
        local label = Client.Functions.Trim(job.label or job.name or Client.Functions.GetString({ "Menu", "Fallbacks", "Unemployed" }, "Unemployed"))
        local grade = Client.Functions.Trim(job.grade_label or job.grade_name or tostring(job.grade or ""))

        if grade ~= "" then
            return ("%s - %s"):format(label, grade)
        end

        return label
    end

    if Settings.Framework == "QBCore" or Settings.Framework == "Qbox" then
        local label = Client.Functions.Trim(job.label or job.name or Client.Functions.GetString({ "Menu", "Fallbacks", "Unemployed" }, "Unemployed"))
        local gradeData = job.grade
        local grade = ""

        if type(gradeData) == "table" then
            grade = Client.Functions.Trim(gradeData.name or tostring(gradeData.level or ""))
        else
            grade = Client.Functions.Trim(tostring(gradeData or ""))
        end

        if grade ~= "" then
            return ("%s - %s"):format(label, grade)
        end

        return label
    end

    return Client.Functions.GetString({ "Menu", "Fallbacks", "NoJob" }, "No job")
end

Client.Framework.GetMoneyData = function(playerData)
    if Settings.Framework == "ESX" then
        local cash = Client.Framework.GetAccountMoney(playerData and playerData.accounts, { "money", "cash" })
        local bank = Client.Framework.GetAccountMoney(playerData and playerData.accounts, { "bank" })

        if cash == 0 and playerData and playerData.money then
            cash = playerData.money
        end

        return cash, bank
    end

    if Settings.Framework == "QBCore" or Settings.Framework == "Qbox" then
        local moneyData = (playerData and (playerData.money or playerData.Money)) or {}
        return moneyData.cash or 0, moneyData.bank or 0
    end

    return 0, 0
end
