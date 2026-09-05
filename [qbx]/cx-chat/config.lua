Config = {}
Config.Version = "1.0.3"
-- Supported frameworks: "qbcore", "qbox", "esx".
Config.Framework = "qbox"

-- Do not edit unless you know what you're doing!
Config.GetCharacterName = function(src)
    if Config.Framework == "qbcore" or Config.Framework == "qbox" then
        local QBCore = exports['qb-core']:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then return Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname end
    elseif Config.Framework == "esx" then
        local ESX = exports['es_extended']:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then return xPlayer.getName() end
    end
    return GetPlayerName(src) or "Unknown"
end
-- This is the default theme for players.
Config.Theme = "amethyst"
Config.CustomTheme = {
    bg      = "rgba(10, 10, 15, 0.9)",
    bg2     = "rgba(15, 15, 20, 0.95)",
    bg3     = "rgba(20, 20, 25, 0.8)",
    line    = "rgba(255, 255, 255, 0.05)",
    hi      = "#0ea5e9",
    text    = "#cbd5e1",
    bright  = "#ffffff",
    dim     = "#475569",
    radius  = "10px",
}

Config.ServerName      = "Midnight Roleplay"
Config.MaxMessages     = 100
Config.MessageCooldown = 3000
Config.ChatWidth       = 460
Config.ChatHeight      = 240

Config.Timestamps = { enabled = true, format  = "HH:MM" }
Config.MessageFormatting = { enabled = true }

Config.StaffBadge = {
    enabled = false,
    permission = "chat.staff",
    label = "STAFF",
    color = "#e879a0"
}

Config.Channels = {
    { name = "global", label = "Main", color = "#8a6eff" },
   -- { name = "ooc",    label = "OOC",    color = "#60aaff" },
   -- { name = "trade",  label = "Trade",  color = "#3dd68c" },
   -- { name = "staff",  label = "Staff",  color = "#e879a0" },
}
Config.DefaultChannel = "global"
Config.TabChannels = { "global"}

-- Set to true to disable regular chat messages. Only /commands will be allowed.
-- Hides channel tabs (OOC, Trade, Global) and shows a local notice when players try to send a message.
Config.DisableChatMessages = true

Config.JoinLeave = {
    enabled    = false,
    joinColor  = "#3dd68c",
    leaveColor = "#ff5370",
    joinDelay  = 3000
}

Config.MOTD = {
    enabled     = false,
    color       = "#ffffff",
    prefix      = "MOTD",
    prefixColor = "#f8258f",
    lines       = {
        "Thanks for downloading **cx-chat**, you can change/disable this message in `config.lua`",
    }
}

Config.MeAboveHead = {
    enabled  = true,
    duration = 5000,
    color    = { r = 138, g = 110, b = 255, a = 255 },
    scale    = 0.4,
}

Config.OpenKey = "T"

Config.IDDisplay = {
    enabled   = false,
    distance  = 25.0,
    color     = { r = 255, g = 255, b = 255, a = 255 },
    scale     = 0.35,
    showOwnID = false,
}

Config.ProfanityFilter = {
    enabled = false,
    mode    = "replace", -- "replace" keeps the message but masks words; "block" rejects it entirely
    words   = { "badword1", "badword2", "slur" },
    replace = "****"
}

Config.ReportSystem = {
    enabled = false,
    categories = {
        { value = "player", label = "Report a Player" },
        { value = "bug",    label = "Report a Bug/Glitch" },
        { value = "help",   label = "General Assistance" }
    }
}

Config.AnnouncementJobs = {
    ["ambulance"] = { label = "EMS ANNOUNCEMENT", color = "#ff5370" },
    ["police"]    = { label = "POLICE ANNOUNCEMENT", color = "#0ea5e9" },
}

-- Message Reactions
Config.Reactions = {
    enabled = false,
    emojis = { "👍", "❤️", "😂", "😮", "😢", "🔥" },
    maxPerMessage = 10,
    showCount = true,
}

-- Chat Mentions
Config.Mentions = {
    enabled = false,
    sound = true, -- play sound when mentioned
    highlightColor = "#fbbf24", -- color for @mentions
    notifyColor = "#f8258f", -- color for notification
}

-- Message Pinning
Config.Pinning = {
    enabled = false,
    maxPinned = 3, -- max pinned messages at once
    permission = "cx-chat.pin", -- who can pin messages
    showIcon = true, -- show pin icon on messages
}

-- Typing Indicators
Config.TypingIndicators = {
    enabled = false,
    timeout = 3000, -- ms before hiding indicator
    dmOnly = true, -- only show in DMs
}

-- Message Editing
Config.MessageEditing = {
    enabled = false,
    timeLimit = 120, -- seconds after sending (2 minutes)
    showEditTag = true,
    deletePermission = "cx-chat.delete",
    mutePermission = "cx-chat.mute",
    muteDuration = 300, -- default mute duration in seconds
}

-- Copy Message Content
Config.CopyMessage = {
    enabled = true,
    showTooltip = true,
}

-- In-Chat Minigames
Config.Minigames = {
    enabled = false,
    dice = {
        enabled = true,
        maxSides = 100, -- /dice 1d100
    },
    coinflip = {
        enabled = false,
        animations = true,
    },
    rps = {
        enabled = false,
        timeout = 30000, -- 30s to accept challenge
    },
}

-- Quick Actions Menu - Right-click player names
Config.QuickActions = {
    enabled = false,
    actions = {
        pm = true, -- send private message
        report = true, -- report player
        copy_id = true, -- copy server ID
    },
}
