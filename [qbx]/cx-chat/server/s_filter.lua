local violations = {}

local function GetIds(src)
    local lic, disc = "N/A", "N/A"
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:match("^license:") then
            lic  = id
        elseif id:match("^discord:") then
            disc = "<@" .. id:gsub("discord:", "") .. ">"
        end
    end
    return lic, disc
end

local function LogProfanity(src, text, word)
    local name     = Config.GetCharacterName(src)
    local lic, disc = GetIds(src)

    CXLog("profanity", {
        description = string.format("Profanity violation by %s: %s", name, text),
        metadata    = { word = word, player = name, id = src, license = lic },
        embed = {
            title  = "🛡️ Profanity Violation",
            color  = 16711680,
            fields = {
                { name = "Character", value = name,               inline = true  },
                { name = "Player",    value = GetPlayerName(src), inline = true  },
                { name = "Server ID", value = tostring(src),      inline = true  },
                { name = "Ping",      value = GetPlayerPing(src) .. "ms", inline = true },
                { name = "Word",      value = "`" .. word .. "`", inline = true  },
                { name = "Message",   value = "```" .. text .. "```", inline = false },
                { name = "IDs",       value = "**Lic:** `" .. lic .. "`\n**Disc:** " .. disc, inline = false },
            }
        }
    })
end

local function HandleViolation(src)
    local now  = GetGameTimer()
    local name = GetPlayerName(src) or "Unknown"

    if not violations[src] or (now - violations[src].timer) > 300000 then
        violations[src] = { count = 1, timer = now }
    else
        violations[src].count = violations[src].count + 1
    end

    local count = violations[src].count

    SetTimeout(100, function()
        if count >= 3 then
            if GetPlayerName(src) then
                DropPlayer(src, "Terminated: Repeated profanity violations (3/3 warnings).")
            end
            violations[src] = nil
        else
            TriggerClientEvent("cx-chat:addMessage", -1, {
                message  = string.format("@%s, please watch your language!", name),
                color    = "#fbbf24",
                tag      = "WARNING",
                tagColor = "#fbbf24",
                isSystem = true,
            })
            TriggerClientEvent("cx-chat:addMessage", src, {
                message   = "Violation recorded: " .. count .. "/3.",
                color     = "#fbbf24",
                isSystem  = true,
                playSound = true,
            })
        end
    end)
end

local function ireplace(str, word, replacement)
    local result = {}
    local lower  = str:lower()
    local lword  = word:lower()
    local i = 1
    while i <= #str do
        local s, e = lower:find(lword, i, true)
        if s then
            table.insert(result, str:sub(i, s - 1))
            table.insert(result, replacement)
            i = e + 1
        else
            table.insert(result, str:sub(i))
            break
        end
    end
    return table.concat(result)
end

function FilterText(src, text)
    if not Config.ProfanityFilter or not Config.ProfanityFilter.enabled then
        return text, false
    end

    local mode  = Config.ProfanityFilter.mode or "block"
    local lower = text:lower()

    if mode == "replace" then
        local filtered = text
        local warned   = false
        for _, word in ipairs(Config.ProfanityFilter.words) do
            if lower:find(word:lower(), 1, true) then
                if not warned then
                    LogProfanity(src, text, word)
                    HandleViolation(src)
                    warned = true
                end
                filtered = ireplace(filtered, word, Config.ProfanityFilter.replace or "****")
                lower    = filtered:lower()
            end
        end
        return filtered, false
    else
        for _, word in ipairs(Config.ProfanityFilter.words) do
            if lower:find(word:lower(), 1, true) then
                LogProfanity(src, text, word)
                HandleViolation(src)
                return nil, true
            end
        end
        return text, false
    end
end

AddEventHandler("playerDropped", function()
    violations[source] = nil
end)
