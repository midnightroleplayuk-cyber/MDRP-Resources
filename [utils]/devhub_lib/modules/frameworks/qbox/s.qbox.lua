if Shared.Framework ~= "QBOX" then return end  

CreateThread(function()
    Wait(5000)

    Core.GetIdentifier = function(source)
        local Player = exports.qbx_core:GetPlayer(tonumber(source))
        if not Player then return false end
        return Player.PlayerData.citizenid
    end
    
    Core.AddCash = function(source, amount)
        local Player = exports.qbx_core:GetPlayer(tonumber(source))
        return Player.Functions.AddMoney('cash', amount)
    end
    
    Core.RemoveCash = function(source, amount)
        local Player = exports.qbx_core:GetPlayer(tonumber(source))
        return Player.Functions.RemoveMoney('cash', amount)
    end
    
    Core.GetCash = function(source)
        local Player = exports.qbx_core:GetPlayer(tonumber(source))
        return Player.Functions.GetMoney('cash')
    end

    Core.GetBank = function(source)
        local Player = exports.qbx_core:GetPlayer(tonumber(source))
        return Player.Functions.GetMoney('bank')
    end
    
    Core.AddBank = function(source, amount)
        local Player = exports.qbx_core:GetPlayer(tonumber(source))
        return Player.Functions.AddMoney('bank', amount)
    end

    Core.RemoveBank = function(source, amount)
        local Player = exports.qbx_core:GetPlayer(tonumber(source))
        return Player.Functions.RemoveMoney('bank', amount)
    end

    Core.GetJob = function(source)
        local xPlayer = exports.qbx_core:GetPlayer(tonumber(source))
        local jobData = {
            name = xPlayer.PlayerData?.job?.name or "unemployed",
            label = xPlayer.PlayerData?.job?.label or "Unemployed",
            grade = xPlayer.PlayerData.job?.grade?.level or 0,
            onDuty = xPlayer.PlayerData?.job?.onduty or false,
        }
        return jobData
    end

    Core.IsPolice = function(source)
        local xPlayer = exports.qbx_core:GetPlayer(tonumber(source))
        if xPlayer.PlayerData?.job?.name == "police" or xPlayer.PlayerData?.job?.name == "sheriff" or xPlayer.PlayerData?.job?.name == "state" then 
            return true
        end
        return false
    end

    Core.GetFullName = function(source)
        local xPlayer = exports.qbx_core:GetPlayer(tonumber(source))
        return xPlayer.PlayerData?.charinfo?.firstname .. " " .. xPlayer.PlayerData?.charinfo?.lastname
    end

    Core.GetUserInfo = function(source)
        local xPlayer = exports.qbx_core:GetPlayer(tonumber(source))
        local userInfo = {
            dateOfBirth = xPlayer.PlayerData?.charinfo?.birthdate or "Unknown",
            sex = xPlayer.PlayerData?.charinfo?.gender or "Unknown",
            height = xPlayer.PlayerData?.charinfo?.height or "Unknown", -- qbox dosn't have height by default
            nationality = xPlayer.PlayerData?.charinfo?.nationality or "Unknown",
        }
        return userInfo
    end

    Core.GetUserSkin = function(source)
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
        if not xPlayer then
            return { eyesColor = 0, skinColor = 0 }
        end

        local result = Core.SQL.AwaitSingle('SELECT skin FROM playerskins WHERE citizenid = ? AND active = ? LIMIT 1', { xPlayer.PlayerData.citizenid, 1 })
        local skin = result?.skin or {}
        if type(skin) == "string" then
            local ok, decoded = pcall(json.decode, skin)
            skin = ok and decoded or {}
        end

        local function numberFrom(...)
            for i = 1, select("#", ...) do
                local value = select(i, ...)
                if type(value) == "table" then
                    value = value.texture or value.value or value.item
                end
                value = tonumber(value)
                if value then return value end
            end

            return 0
        end

        return {
            eyesColor = numberFrom(skin?.eyes_color, skin?.eye_color, skin?.eyesColor, skin?.eyeColor), -- number
            skinColor = numberFrom(skin?.facemix?.skinMix, skin?.headBlend?.skinMix, skin?.skin_color, skin?.skinColor), -- number
        }
    end

    LoadedSystems["framework"] = true
end)