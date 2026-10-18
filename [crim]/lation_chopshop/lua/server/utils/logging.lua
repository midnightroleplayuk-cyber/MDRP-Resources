local runtime = require 'shared.runtime'

local fmsdk = GetResourceState('fmsdk') == 'started'

-- Log a player event to the configured service, if any.
--- @param source number Player ID (0 or nil for server-originated events)
--- @param title string Log title
--- @param message string Message contents
function PlayerLog(source, title, message)
    if runtime.logs.service == 'fivemanage' then
        if not fmsdk then return end
        -- A screenshot needs a real player to capture; fall back to a plain
        -- message for server-originated events.
        if runtime.logs.screenshots and source and source > 0 then
            exports.fmsdk:takeServerImage(source, {
                name = title,
                description = message,
            })
        else
            exports.fmsdk:LogMessage('info', message)
        end
    elseif runtime.logs.service == 'discord' then
        local embed = {
            {
                ["color"] = 16711680,
                ["title"] = "**".. title .."**",
                ["description"] = message,
                ["footer"] = {
                    ["text"] = os.date("%a %b %d, %I:%M%p"),
                    ["icon_url"] = runtime.logs.discord.footer
                }
            }
        }
        PerformHttpRequest(runtime.logs.discord.link, function()
        end, 'POST', json.encode({username = runtime.logs.discord.name, embeds = embed, avatar_url = runtime.logs.discord.image}),
        {['Content-Type'] = 'application/json'})
    end
end

