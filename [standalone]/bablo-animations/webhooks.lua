-- Here you can configure the webhooks here is all the diffrent types of webhooks if you only would like some and not all you can either set it as false or leave it as ''.
-- The webhooks are used to log diffrent actions in the server to discord or Fivemanage.

while not eventName do Wait(0) end

-- Fivemanage Configuration
-- Get your API key from https://fivemanage.com
-- Documentation: https://docs.fivemanage.com/sdk/fivem/logs
Fivemanage = {
    enabled = false,              -- Set to true to enable Fivemanage logging
    apiKey = '',                  -- Your Fivemanage Logs API key
    dataset = 'bablo-animations', -- Dataset name for organizing logs in Fivemanage dashboard
    useSDK = false,               -- Set to true if you have fmsdk resource installed, false for direct HTTP
}

Webhooks = {
    ['PLACED_ANIMATION'] = {
        title = 'Placed Animation',
        template = '%s placed animation %s',
        webhook = '',
        fivemanageLevel = 'info' -- Log level: debug, info, warn, error
    },
    ['PLAYED_ANIMATION'] = {
        title = 'Played Animation',
        template = '%s played animation %s',
        webhook = '',
        fivemanageLevel = 'info'
    },
    ['JOINED_GROUP'] = {
        title = 'Joined Group',
        template = '%s joined %s group',
        webhook = '',
        fivemanageLevel = 'info'
    },
    ['LEFT_GROUP'] = {
        title = 'Left Group',
        template = '%s left %s group',
        webhook = '',
        fivemanageLevel = 'info'
    },
    ['SET_WALKINGSTYLE'] = {
        title = 'Set Walking Style',
        template = '%s set walking style to %s',
        webhook = '',
        fivemanageLevel = 'info'
    },
    ['SET_EXPRESSION'] = {
        title = 'Set Expression',
        template = '%s set expression to %s',
        webhook = '',
        fivemanageLevel = 'info'
    },
    ['SET_WEAPON_STYLE'] = {
        title = 'Set Weapon Style',
        template = '%s set weapon style to %s',
        webhook = '',
        fivemanageLevel = 'info'
    },
}

local function sendFivemanageLog(source, name, messageData, playerName, message)
    if not Fivemanage.enabled or not Fivemanage.apiKey or Fivemanage.apiKey == '' then
        return
    end

    local webhookData = Webhooks[name]
    local level = webhookData.fivemanageLevel or 'info'

    if Fivemanage.useSDK then
        local success, err = pcall(function()
            exports.fmsdk:Log(Fivemanage.dataset, level, message, {
                playerSource = source,
                action = name,
                playerName = playerName,
                data = messageData,
                resource = 'bablo-animations'
            })
        end)
        if not success then
            Trace('Fivemanage SDK error:', err)
        end
        return
    end

    local payload = {
        level = level,
        message = message,
        metadata = {
            playerSource = source,
            action = name,
            title = webhookData.title,
            playerName = playerName,
            data = tostring(messageData),
            resource = 'bablo-animations',
            timestamp = os.date("%Y-%m-%d %H:%M:%S")
        }
    }

    PerformHttpRequest('https://api.fivemanage.com/api/logs', function(err, text, headers)
        if err ~= 200 and err ~= 201 then
            Trace('Fivemanage log failed! HTTP Error:', err, 'Response:', text)
        end
    end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = Fivemanage.apiKey
    })
end

local function sendDiscordWebhook(source, name, messageData, playerName, message)
    local webhookData = Webhooks[name]

    if not webhookData.webhook or webhookData.webhook == '' then
        return
    end

    local payload = {
        embeds = {
            {
                title = webhookData.title or "Webhook",
                description = message,
                color = 8039935,
                footer = {
                    text = 'Bablo Animations | ' .. os.date("%Y-%m-%d %H:%M:%S")
                }
            }
        }
    }

    PerformHttpRequest(webhookData.webhook, function(err, text, headers)
        if err == 401 then
            Trace("ERROR: Unauthorized - The webhook URL might be invalid or expired.")
        elseif err == 429 then
            Trace("ERROR: Rate limited - Too many requests. Wait and try again later.")
        elseif err ~= 200 and err ~= 204 then
            Trace("Webhook failed! HTTP Error:", err, "Response:", text)
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

function sendWebhook(source, name, messageData)
    if not Config.Logs then return end

    if not Webhooks[name] then
        Trace('Webhook error: Webhook config not found for', name)
        return
    end

    local hasDiscord = Webhooks[name].webhook and Webhooks[name].webhook ~= ''
    local hasFivemanage = Fivemanage.enabled and Fivemanage.apiKey and Fivemanage.apiKey ~= ''

    if not hasDiscord and not hasFivemanage then
        Trace('Webhook error: No webhook URL or Fivemanage configured for', name)
        return
    end

    local playerName
    if Config.Framework == 'standalone' then
        playerName = GetPlayerName(source)
    else
        playerName = GetPlayerName(source) .. ' (' .. source .. ') ' .. Framework:getPlayerName(source)
    end

    local message = Webhooks[name].template and string.format(Webhooks[name].template, playerName, tostring(messageData)) or
        "ERROR: No template found"

    if hasDiscord then
        sendDiscordWebhook(source, name, messageData, playerName, message)
    end

    if hasFivemanage then
        sendFivemanageLog(source, name, messageData, playerName, message)
    end
end

RegisterNetEvent(eventName .. 'server:sendWebhook')
AddEventHandler(eventName .. 'server:sendWebhook', function(name, data)
    Trace('Sending webhook', name, json.encode(data))

    sendWebhook(source, name, data)
end)
