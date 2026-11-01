local webhooks = { -- add your webhooks: 
    ['newEvent'] = "", -- post a new event
    ['results'] = "", -- post results
    ['levels'] = "", -- post a msg when someone redeems a level from the progression tab
}
local your_website = "https://av-scripts.tebex.io/" -- the blue text for the results post

local places = {
    "1st", "2nd", "3rd", "4th", "5th"
}

function newEvent(source,event) -- triggered when a new event is created, use it for discord or whatever else u want
--    print(json.encode(event, {indent = true}))
    local url = webhooks['newEvent']
    if not url or url == "" then return end
    local password = "No"
    if event['password'] then password = "Yes" end
    local startsIn = '<t:'..event['startsin']..":R>"
    local fields = {
        {
            name= Lang['starts_in'],
            value= startsIn,
            inline= true,
        },
        {
            name= Lang['password'],
            value= password,
            inline= true,
        },
        {
            name= Lang['buy_in'],
            value= (event['buyin'] and event['buyin'] or 0).." "..event['accountLabel'],
            inline= true,
        },
        {
            name= Lang['class'],
            value= string.upper(event['class']),
            inline= true,
        },
        {
            name= Lang['laps'],
            value= event['laps'] or "",
            inline= true,
        },
        {
            name= Lang['type'],
            value= string.upper(event['type']),
            inline= true,
        },
        {
            name= Lang['description'],
            value= event['description'] or "",
            inline= false,
        },
    }
    local message = {
        {
            ['title'] = event['title'],
            ['url'] = your_website,
            ['description'] = '',
            ['fields'] = fields,
            ['color'] = 0x193772,
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        }
    }
    PerformHttpRequest(url, function() end, 'POST', json.encode({ username = 'AV Scripts', embeds = message }),
        { ['Content-Type'] = 'application/json' })
end

function eventEnd(eventName, trackName, class, numRacers, laps, results)
--    print(eventName, trackName, class, numRacers, laps, json.encode(results, {indent = true}))
    local url = webhooks['results']
    if not url or url == "" then return end
    local laps = laps or 0
    local fields = {
        {
            name = Lang['track_name'],
            value = trackName,
            inline = true,
        },
        {
            name = Lang['class'],
            value = string.upper(class),
            inline = true,
        },
        {
            name = Lang['racers'],
            value = numRacers,
            inline = true,
        },
        {
            name= '',
            value= '**Ranking:**',
            inline= false,
        },
        
    }
    if results and next(results) then
        for i = 1, 5 do
            if results[i] then
                fields[#fields+1] = {
                    name= places[i],
                    value= results[i]['name'],
                    inline= true,
                }
                if laps > 0 then
                    fields[#fields+1] = {
                        name= Lang['best_lap'],
                        value= results[i]['bestTime'],
                        inline= true,
                    }
                end
                fields[#fields+1] = {
                    name= Lang['total_time'],
                    value= results[i]['time'],
                    inline= true,
                }
                fields[#fields+1] = {
                    name= Lang['vehicle'],
                    value= results[i]['vehicle'],
                    inline= true,
                }
            end
        end
    end
    local message = {
        {
            ['title'] = eventName,
            ['url'] = your_website,
            ['description'] = '',
            ['fields'] = fields,
            ['color'] = 0x193772,
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    PerformHttpRequest(url, function() end, 'POST', json.encode({ username = 'AV Scripts', embeds = message }),
        { ['Content-Type'] = 'application/json' })
end