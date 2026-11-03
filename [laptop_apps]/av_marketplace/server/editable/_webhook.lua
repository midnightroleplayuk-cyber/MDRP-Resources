-- Add your webhook here
local webhook = ""

function sendLog(source, data)
    local name = exports['av_laptop']:getName(source)
    local description = {
        "** Player Name:** "..name,
        "** Username:** "..data['username'],
        "** Identifier:** "..data['owner'],
        "** Title:** "..data['title'],
        "** Price:** "..data['price'],
        "** Category:** "..data['category'],
        "** Description:** ".. data['description'],
    }
    local message = {
        {
            ['title'] = "Marketplace Ad",
            ['description'] = table.concat(description, "\n"),
            ['color'] = "5793266",
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ["image"] = {
                url = data['image']
            }
        } 
    }
    exports['av_laptop']:Discord(webhook, message)
end