Framework = Framework or {};

CreateThread(function()
    if Config.Framework ~= 'standalone' then
        return
    end

    function Framework:fetchPlayer(source)
        return source
    end

    function Framework:getIdentifier()
        return GetPlayerIdentifiers(source)[1]
    end

    function Framework:getPlayerName(source)
        return GetPlayerName(source)
    end

    function Framework:isAdmin(source)
        source = tonumber(source)
        if not source then return false end

        if IsPlayerAceAllowed(source, 'command') then
            return true
        end

        return false
    end

    ---@param source number Server ID of the player being checked
    ---@return boolean Whether this player can appear in the closest players list and be invited to groups
    function Framework:canBeInvitedToGroup(source)
        -- Add your custom logic here
        return true
    end

    RegisterServerCallback({
        eventName = eventName .. 'server:getIdentifier',
        eventCallback = function(source)
            if not source then
                return { status = false, message = "NO_SOURCE" }
            end

            return { status = true, identifier = Framework:getIdentifier(source) }
        end
    })
end)
