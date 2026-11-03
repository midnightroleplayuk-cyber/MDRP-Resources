local webhook = ""

function sendLog(playerId, type, data)
    local color = "5763719"
    local title = Lang['new_warehouse']
    if type == "crate" then
        color = "12370112"
        title = Lang['crate_opened']
    end
    local description = {
        "**"..Lang['player_name']..":** "..data.name,
        "**"..Lang['player_identifier']..":** "..data.identifier
    }
    if data and data.crateIdentifier then
        local msg = "**"..Lang['crate_identifier']..":** "..data.crateIdentifier
        table.insert(description, msg)
    end
    if data and data.rewards then
        local msg = "**"..Lang['crate_rewards']..":** "..data.rewards
        table.insert(description, msg)
    end
    if data and data.coords then
        local msg = "**"..Lang['warehouse_entry']..":** "..data.coords.x.." "..data.coords.y.." "..data.coords.z
        table.insert(description, msg)
    end
    local message = {
        {
            ['title'] = title,
            ['description'] = table.concat(description, "\n"),
            ['color'] = color,
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({ username = 'AV Scripts', embeds = message }),
        { ['Content-Type'] = 'application/json' })
end