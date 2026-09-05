ServerConfig = {}
ServerConfig.LogsWebhook = "https://discord.com/api/webhooks/" -- Discord webhook.

ServerConfig.DisableBuckets = false -- Disable routing bucket change

ServerConfig.DiscordRanks = {
    enable = false,
    botToken = "", -- Discord Bot Token.
    serverId = "988478565790122095",
    ranks = {
        -- SCHEMA: ["role_discord_id"] = amount of available slots
        ["1438914499506733310"] = 3,
        ["1438914514279071834"] = 2,
        ["1438914530141798400"] = 5,
    }
}

ServerConfig.DisableAutoSql = false -- Enable/Disable auto sql injection for slots data!

-- Scene Creator access (same pattern as op-clothing Config.Permissions):
-- player passes when they hold AcePermission OR belong to one of AllowedGroups
-- (framework group: ESX getGroup / QB-Core GetPermission).
ServerConfig.SceneCreator = {
    AcePermission = "op-multicharacter.scenes", -- add_ace group.admin op-multicharacter.scenes allow
    AllowedGroups = { "admin", "superadmin", "god" },
}

ServerConfig.Commands = {
    logout = {
        enable = true, 
        command = "logout",
        allowed = "admin" -- for ESX change to {"user"}
    },
    setslots = {
        enable = true, 
        command = "setslots",
        allowed = "admin" -- for ESX change to {"admin"}
    },
    -- Admin-only: permanently delete a character by id
    -- ESX: full identifier e.g. char1:licensehash  |  QB/Qbox: citizenid
    delchar = {
        enable = true,
        command = "delchar",
        allowed = "admin", -- for ESX change to {"admin"}
    },
}

ServerConfig.LogsData = {
    ['character_loaded'] = {
        color = 706333,
        header = "Player Connected",
        desc = "**Character Name:** `%s`\n**Character ID:** `%s`\n**Player Identifiers:** ```%s```"
    },
    ['character_created'] = {
        color = 706333,
        header = "Character Created",
        desc = "**Name:** `%s`\n**ID:** `%s`\n**Nationality:** `%s`\n**Birthday:** `%s`\n**Gender:** `%s`\n**Height:** `%s`\n**Player Identifiers:** ```%s```\n**Starting Items:** ```%s```"
    },
    ['character_unloaded'] = {
        color = 13044234,
        header = "Character Log Out",
        desc = "**Character Name:** `%s`\n**Character ID:** `%s`\n**Player Identifiers:** ```%s```"
    },
    ['slotsadded'] = {
        color = 706333,
        header = "Slots Added",
        desc = "**Admin:** `%s`\n**License:** `%s`\n**Amount:** `%s`"
    },
    ['character_deleted_admin'] = {
        color = 13044234,
        header = "Character Deleted (Admin)",
        desc = "**Admin:** `%s`\n**Character ID:** `%s`\n**Admin Identifiers:** ```%s```"
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- (Information) ► Formats webhook message based on LogsData entry and sends it.
-- (Information) ► Usage example:
--                 ServerConfig.formatWebHook("character_created", arg1, arg2, ...)
-- ──────────────────────────────────────────────────────────────────────────────
---@param logType string   -- key in ServerConfig.LogsData
---@param ... any          -- formatting params for desc
---@return table           -- { title = "", color = 0, message = "" }
ServerConfig.formatWebHook = function(logType, ...)
    local log = ServerConfig.LogsData[logType]
    if not log then
        print("^1[OP-MULTICHARACTER] Invalid logType: " .. tostring(logType))
        return false
    end

    local formattedDesc = string.format(log.desc, ...)

    local embed = {{
        ["color"] = log.color,
        ["title"] = log.header,
        ["description"] = formattedDesc,
        ["footer"] = { text = os.date("%c") .. " (Server Time)." }
    }}

    PerformHttpRequest(ServerConfig.LogsWebhook,
        function(err, text, headers) end,
        "POST",
        json.encode({ username = "OP Multicharacter", embeds = embed }),
        { ["Content-Type"] = "application/json" }
    )
end