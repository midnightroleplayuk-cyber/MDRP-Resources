------------------------------------------------------------------------------------
--------------------------------- night_discordapi ---------------------------------
------------------------------------------------------------------------------------
-------------------------------------- Config --------------------------------------
------------------------------------------------------------------------------------

-- Please read the documentation and/or watch the installation video tutorial (available on the documentation page) before asking us for support.

-- Documentation Page: https://docs.nights-software.com/resources/discordAPI/ (<- INSTALLATION GUIDE HERE)
-- Support Discord: https://discord.nights-software.com/

Config = {
    -- We no longer provide a default bot. Please create your own bot and put its token here.
    -- https://docs.nights-software.com/resources/discordAPI/#-creating-your-own-discord-bot
    Discord_Bot_Token = "FILL_IN_YOUR_BOT_TOKEN_HERE",
    Discord_Guild_Names = {
        ["989438923925229598"] = "Nights Software", -- Your primary server/guild ID (legacy scripts will get information regarding this guild)
        -- ["1001055923912653544"] = "My Community Discord", -- Add another guild. Make sure to invite the bot into this guild.
    },
    Discord_Role_Names = { -- Add Discord roles by their role ID here, name them how you want but make sure to MATCH the NAMES in other configs of our resources.
        -- Example:
        ["989863231482916874"] = "Administrator",
        ["963138401656242206"] = "Your_Police_Role",
        ["744819251814334485"] = "Your_Ambulance_Role",
        ["744819251788906505"] = "Your_Fire_Role",
        ["1002578457823297536"] = "Allowlisted",
        ["468677647228363421"] = "Banned",
    },
    Discord_API_Log_Level = 1, -- Level 0 - Only shows INFO, ERROR and WARN messages | Any higher level will include DEBUG messages
}