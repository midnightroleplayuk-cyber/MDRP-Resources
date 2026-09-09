function SendWebHook(title, color, message)
    local embedMsg = {}
    timestamp = os.date("%c")
    embedMsg = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] =  message,
            ["footer"] ={
                ["text"] = timestamp.." (Server Time).",
            },
        }
    }
    PerformHttpRequest(ServerConfig.WebHook,
    function(err, text, headers)end, 'POST', json.encode({username = "OP Container Wars", embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end

WHData = {
    warStarted = {
        head = "CONTAINER WAR STARTED",
        desc = "**Config name:** `%s`\n**Drop Config:** `%s`\n**Administrator:** `%s`"
    },
    containerEnded = {
        head = "CONTAINER END",
        desc = "**Container id:** `%s`\n**Price:** `%s`\n**Winner:** `%s`\n**Reward:** ```%s```"
    },
    bidPlaced = {
        head = "BID PLACED",
        desc = "**Container id:** `%s`\n**Player:** `%s`\n**Price:** `%s`"
    },
    rewardClaimSell = {
        head = "REWARD CLAIMED/SOLD",
        desc = "**Container id:** `%s`\n**Player:** `%s`\n**Action:** `%s`\n**Reward Data:** ```%s```"
    },
}