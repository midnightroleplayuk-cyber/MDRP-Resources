local function getImpoundWebhookUrl()
    if ServerConfig.ImpoundWebHook and ServerConfig.ImpoundWebHook ~= "" then
        return ServerConfig.ImpoundWebHook
    end

    return ServerConfig.WebHook
end

local function formatWebhookPlayer(playerId)
    local name = Fr.GetPlayerName(playerId) or "Unknown"
    local identifier = Fr.GetIndentifier(playerId) or "unknown"
    return string.format("%s (`%s`)", name, identifier)
end

local function getPlayerJobName(playerId)
    local xPlayer = Fr.getPlayerFromId(playerId)
    if not xPlayer then return "unknown" end

    local playerJob = Fr.GetPlayerJob(xPlayer)
    return playerJob and playerJob.name or "unknown"
end

local function sendImpoundWebhook(title, color, message)
    local webhookUrl = getImpoundWebhookUrl()
    if not webhookUrl or webhookUrl == "" then return end

    local embedMsg = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = message,
            ["footer"] = {
                ["text"] = os.date("%c") .. " (Server Time).",
            },
        }
    }

    PerformHttpRequest(webhookUrl, function() end, 'POST', json.encode({
        username = "OP Garages - Impound",
        embeds = embedMsg
    }), { ['Content-Type'] = 'application/json' })
end

-- Called when a job member impounds/tows a vehicle through the IV menu.
function vehicleImpounded(playerId, plate, jobName, reason, priceAfter, priceBefore, impoundLocation)
    local officer = formatWebhookPlayer(playerId)
    local location = impoundLocation and tostring(impoundLocation) or "unknown"
    local finalReason = reason and tostring(reason) or "No reason provided"

    local desc = string.format(
        WHData.impoundJob.desc,
        plate,
        officer,
        jobName or getPlayerJobName(playerId),
        location,
        finalReason,
        priceBefore or 0,
        priceAfter or 0
    )

    sendImpoundWebhook(WHData.impoundJob.head, 16753920, desc)
end

-- Called when someone pays at the impound lot.
-- action: "retrieve" = spawn vehicle | "send_to_garage" = send back to garage without spawning
function vehicleTowedBack(playerId, plate, price, action)
    local player = formatWebhookPlayer(playerId)
    local jobName = getPlayerJobName(playerId)
    local paid = price or 0

    if action == "send_to_garage" then
        local desc = string.format(WHData.impoundSendToGarage.desc, plate, player, jobName, paid)
        sendImpoundWebhook(WHData.impoundSendToGarage.head, 3447003, desc)
        return
    end

    local desc = string.format(WHData.impoundRetrieve.desc, plate, player, jobName, paid)
    sendImpoundWebhook(WHData.impoundRetrieve.head, 65390, desc)
end

-- Called when a job member uses "Return to Owner" from the impound menu.
function vehicleReturnedToOwner(playerId, plate)
    local player = formatWebhookPlayer(playerId)
    local jobName = getPlayerJobName(playerId)
    local desc = string.format(WHData.impoundReturnToOwner.desc, plate, player, jobName)

    sendImpoundWebhook(WHData.impoundReturnToOwner.head, 10181046, desc)
end
