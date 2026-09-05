Config.Commands = {

    {
        command = "clearchat",
        help    = "Clears your local chat window.",
        params  = {},
        type    = "client",
    },
   --[[  {
        command = "ids",
        help    = "Toggles player ID tags above nearby players.",
        params  = {},
        type    = "client",
    }, ]]

--[[     {
        command  = "me",
        help     = "Perform a roleplay action visible to nearby players.",
        type     = "server",
        params   = {
            { name = "action", help = "What is your character doing?" },
        },
        callback = function(src, args)
            local msg = table.concat(args, " ")
            if msg == "" then return end
            TriggerClientEvent("cx-chat:meAboveHead", -1, { serverId = src, text = msg })
        end,
    }, ]]

--[[     {
        command  = "ooc",
        help     = "Send an out-of-character message to everyone.",
        type     = "server",
        params   = {
            { name = "message", help = "Your OOC message" },
        },
        callback = function(src, args)
            local name = Config.GetCharacterName(src)
            local msg  = table.concat(args, " ")
            if msg == "" then return end
            TriggerClientEvent("cx-chat:addMessage", -1, {
                message  = msg,
                name     = name,
                color    = "#c8c9e0",
                tag      = "OOC",
                tagColor = "#60aaff",
                channel  = "ooc",
                isSystem = false,
            })
        end,
    }, ]]

--[[     {
        command  = "pm",
        help     = "Send a private message to a player.",
        type     = "server",
        params   = {
            { name = "id",      help = "Target player's server ID" },
            { name = "message", help = "Your message" },
        },
        callback = function(src, args)
            local tid = tonumber(args[1])
            table.remove(args, 1)
            local msg = table.concat(args, " ")
            if not tid or msg == "" then return end

            local senderName = Config.GetCharacterName(src)
            local targetName = Config.GetCharacterName(tid)

            if not targetName or targetName == "Unknown" then
                TriggerClientEvent("cx-chat:addMessage", src, {
                    message  = "Player not found.",
                    color    = "#ef4444",
                    isSystem = true,
                })
                return
            end

            TriggerClientEvent("cx-chat:addMessage", src, {
                message  = "To " .. targetName .. ": " .. msg,
                color    = "#e879a0",
                tag      = "PM",
                tagColor = "#e879a0",
                isSystem = true,
            })
            TriggerClientEvent("cx-chat:addMessage", tid, {
                message   = "From " .. senderName .. ": " .. msg,
                color     = "#e879a0",
                tag       = "PM",
                tagColor  = "#e879a0",
                isSystem  = true,
                playSound = true,
            })
        end,
    }, ]]

    --[[ {
        command  = "announce",
        help     = "Send a job announcement to all players.",
        type     = "server",
        params   = {
            { name = "message", help = "Your announcement" },
        },
        callback = function(src, args)
            local msg = table.concat(args, " ")
            if msg == "" then return end
            TriggerEvent("cx-chat:server:jobAnnounce", src, msg, true)
        end,
    }, ]]

   --[[  {
        command  = "mk",
        help     = "Show markdown formatting examples.",
        type     = "server",
        params   = {},
        callback = function(src, args)
            local examples = {
                "Use **double asterisks** for **Bold Text**",
                "Use *single asterisks* for *Italic Text*",
                "Use __double underscores__ for __Underlined Text__",
                "Use `backticks` for `Inline Code`",
            }
            Citizen.CreateThread(function()
                for _, text in ipairs(examples) do
                    TriggerClientEvent("cx-chat:addMessage", src, {
                        message  = text,
                        color    = "#cbd5e1",
                        tag      = "SHOWCASE",
                        tagColor = "#fbff00",
                        isSystem = true,
                    })
                    Wait(2000)
                end
            end)
        end,
    }, ]]

    --[[ {
        command  = "dice",
        help     = "Roll dice (e.g., /dice 1d20)",
        type     = "server",
        params   = {
            { name = "dice", help = "Format: XdY (e.g., 2d6 = 2 six-sided dice)" },
        },
        callback = function(src, args)
            if not Config.Minigames.enabled or not Config.Minigames.dice.enabled then return end

            local dice = args[1] or "1d6"
            local count, sides = dice:match("(%d+)d(%d+)")
            count = tonumber(count)
            sides = tonumber(sides)

            if not count or not sides or count < 1 or count > 10 or sides < 2 or sides > Config.Minigames.dice.maxSides then
                TriggerClientEvent("cx-chat:addMessage", src, {
                    message  = "Usage: /dice XdY (e.g., /dice 2d6) - Max 10 dice, max " .. Config.Minigames.dice.maxSides .. " sides",
                    color    = "#ef4444",
                    isSystem = true,
                })
                return
            end

            TriggerClientEvent("cx-chat:playDiceAnimation", src)
            Wait(2000)

            local rolls = {}
            local total = 0
            for i = 1, count do
                local roll = math.random(1, sides)
                table.insert(rolls, roll)
                total = total + roll
            end

            local name      = Config.GetCharacterName(src)
            local rollText  = table.concat(rolls, " + ")
            local diceEmoji = sides == 6 and "🎲" or "🎯"

            TriggerClientEvent("cx-chat:addMessage", -1, {
                message  = string.format("%s rolled **%dd%d**: %s = **%d**", name, count, sides, rollText, total),
                color    = "#3dd68c",
                tag      = diceEmoji .. " DICE",
                tagColor = "#3dd68c",
                isSystem = false,
            })
        end,
    },

    {
        command  = "coinflip",
        help     = "Flip a coin",
        type     = "server",
        params   = {},
        callback = function(src, args)
            if not Config.Minigames.enabled or not Config.Minigames.coinflip.enabled then return end

            local result = math.random(0, 1) == 1 and "Heads" or "Tails"
            local name   = Config.GetCharacterName(src)

            TriggerClientEvent("cx-chat:addMessage", -1, {
                message  = string.format("%s flipped a coin: **%s** 🪙", name, result),
                color    = "#60aaff",
                tag      = "COINFLIP",
                tagColor = "#60aaff",
                isSystem = false,
            })
        end,
    },

    {
        command  = "rps",
        help     = "Challenge someone to Rock, Paper, Scissors",
        type     = "server",
        params   = {
            { name = "id",     help = "Player ID to challenge" },
            { name = "choice", help = "Your choice: rock, paper, or scissors" },
        },
        callback = function(src, args)
            if not Config.Minigames.enabled or not Config.Minigames.rps.enabled then return end

            local targetId = tonumber(args[1])
            local choice   = args[2] and args[2]:lower()

            if not targetId or not choice then
                TriggerClientEvent("cx-chat:addMessage", src, {
                    message  = "Usage: /rps [player id] [rock/paper/scissors]",
                    color    = "#ef4444",
                    isSystem = true,
                })
                return
            end

            if choice ~= "rock" and choice ~= "paper" and choice ~= "scissors" then
                TriggerClientEvent("cx-chat:addMessage", src, {
                    message  = "Invalid choice! Use: rock, paper, or scissors",
                    color    = "#ef4444",
                    isSystem = true,
                })
                return
            end

            local targetName = Config.GetCharacterName(targetId)
            if not targetName or targetName == "Unknown" then
                TriggerClientEvent("cx-chat:addMessage", src, {
                    message  = "Player not found.",
                    color    = "#ef4444",
                    isSystem = true,
                })
                return
            end

            TriggerEvent("cx-chat:rpsChallenge", src, targetId, choice)
        end,
    }, ]]

}
