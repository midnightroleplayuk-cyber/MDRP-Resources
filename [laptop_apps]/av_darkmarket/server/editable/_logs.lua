local webhook = "" -- Add your webhook here

function buyLog(source,items)
    if not source or not items then return end
    if string.len(webhook) > 1 then
        local identifier = exports['av_laptop']:getIdentifier(source)
        local name = exports['av_laptop']:getName(source)
        local description = {
            "** Player Name:** "..name,
            "** Player Identifier:** "..identifier,
            "** Items Bought:** ",
        }
        for _, v in pairs(items) do
            table.insert(description, "x"..v['amount'].." "..v['name'])
        end
        local message = {
            {
                ['title'] = "Dark Market",
                ['description'] = table.concat(description, "\n"),
                ['color'] = "5793266",
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
            } 
        }
        exports['av_laptop']:Discord(webhook, message)
    end
end