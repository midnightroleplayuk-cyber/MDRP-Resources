Framework = Framework or {};

CreateThread(function()
    if Config.Framework ~= 'esx' then
        return
    end

    function Framework:getCore()
        return exports['es_extended']:getSharedObject();
    end

    local ESX = Framework:getCore();

    function Framework:fetchPlayer(source)
        return ESX.GetPlayerFromId(source)
    end

    function Framework:getPlayerName(source)
        source = tonumber(source)

        local player = self:fetchPlayer(source)

        if player.getName then
            return player.getName()
        end

        return "Unknown Player"
    end

    function Framework:isAdmin(source)
        source = tonumber(source)
        if not source then return false end

        local xPlayer = self:fetchPlayer(source)
        if xPlayer then
            local group = xPlayer.getGroup()
            if group == 'admin' or group == 'superadmin' or group == 'god' then
                return true
            end
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

        local xPlayer = self:fetchPlayer(source)
        if not xPlayer then return false end

        -- Add your custom logic here, e.g.:
        -- if xPlayer.getJob().name == 'police' then return false end

        return true
    end
end)
