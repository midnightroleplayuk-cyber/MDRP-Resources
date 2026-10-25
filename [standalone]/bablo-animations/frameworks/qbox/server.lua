Framework = Framework or {};

CreateThread(function()
    if Config.Framework ~= 'qbox' then
        return
    end

    function Framework:getCore()
        return exports['qb-core']:GetCoreObject();
    end

    function Framework:Notify(message)
        Framework:getCore():Notify(message)
    end

    local QBX = Framework:getCore();

    function Framework:fetchPlayer(source)
        return QBX.Functions.GetPlayer(source)
    end

    function Framework:getPlayerName(source)
        source = tonumber(source)
        if not source then
            return "Unknown Player"
        end

        local player = self:fetchPlayer(source)
        if not player then
            return "Unknown Player"
        end

        if not player.PlayerData or not player.PlayerData.charinfo then
            return "Unknown Player"
        end

        local firstName = player.PlayerData.charinfo.firstname
        local lastName = player.PlayerData.charinfo.lastname

        if firstName and lastName and firstName ~= '' and lastName ~= '' then
            return firstName .. ' ' .. lastName
        elseif firstName and firstName ~= '' then
            return firstName
        elseif lastName and lastName ~= '' then
            return lastName
        end

        return "Unknown Player"
    end

    function Framework:isAdmin(source)
        source = tonumber(source)
        if not source then return false end

        if QBX.Functions.HasPermission(source, 'admin') or QBX.Functions.HasPermission(source, 'god') then
            return true
        end

        if IsPlayerAceAllowed(source, 'command') then
            return true
        end

        return false
    end

    ---@param source number Server ID of the player being checked
    ---@return boolean Whether this player can appear in the closest players list and be invited to groups
    function Framework:canBeInvitedToGroup(source)
        source = tonumber(source)
        if not source then return false end

        local player = self:fetchPlayer(source)
        if not player then return false end

        -- Add your custom logic here, e.g.:
        -- local playerData = player.PlayerData
        -- if playerData.metadata['isdead'] then return false end
        -- if playerData.job.name == 'police' and playerData.job.onduty then return false end

        return true
    end
end)
