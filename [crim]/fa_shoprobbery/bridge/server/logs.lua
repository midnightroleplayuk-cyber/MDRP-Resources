Bridge = Bridge or {}

local function sendExternalLog(provider, payload)
    local settings = ServerConfig.ExternalLogs[provider]
    if not settings or GetResourceState(settings.resource) ~= 'started' then return false end

    local ok = pcall(function()
        exports[settings.resource][settings.export]('shoprobbery', payload)
    end)

    return ok
end

local function sendFiveManageLog(payload)
    local settings = ServerConfig.FiveManage
    if not settings or settings.ApiKey == '' then return false end

    local body = {{
        level = settings.Level or 'info',
        message = payload.action,
        resource = settings.Resource or GetCurrentResourceName(),
        metadata = payload
    }}

    PerformHttpRequest(settings.ApiUrl, function(status)
        if status >= 400 then
            lib.print.warn(('[fa_shoprobbery] Fivemanage log failed with status %s'):format(status))
        end
    end, 'POST', json.encode(body), {
        ['Authorization'] = settings.ApiKey,
        ['Content-Type'] = 'application/json'
    })

    return true
end

function Bridge.Log(src, action, data)
    if ServerConfig.Logs == 'none' then return end

    local payload = {
        source = src,
        identifier = src and Bridge.GetIdentifier(src) or 'server',
        action = action,
        data = data or {}
    }

    if ServerConfig.Logs == 'ox_lib' then
        lib.logger(src or -1, action, json.encode(payload))
        return
    end

    if ServerConfig.Logs == 'discord' and ServerConfig.DiscordWebhook ~= '' then
        PerformHttpRequest(ServerConfig.DiscordWebhook, function() end, 'POST', json.encode({
            username = 'FA Shop Robbery',
            embeds = {{
                title = action,
                description = ('```json\n%s\n```'):format(json.encode(payload)),
                color = 16753920
            }}
        }), { ['Content-Type'] = 'application/json' })
        return
    end

    if ServerConfig.Logs == 'fivemanage' and sendFiveManageLog(payload) then
        return
    end

    if ServerConfig.Logs == 'fivemerr' and sendExternalLog('Fivemerr', payload) then
        return
    end

    if ServerConfig.Logs == 'custom' and sendExternalLog('Custom', payload) then
        return
    end

    lib.print.info(('[fa_shoprobbery] %s %s'):format(action, json.encode(payload)))
end
