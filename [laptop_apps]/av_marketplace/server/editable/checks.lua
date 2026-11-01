local adsBlacklisted = { -- Here you can blacklist players from creating new ads
    ['identiifer123'] = true
}

local messageBlacklisted = { -- Here you can blacklist players from sending messages to the ad creator
    ['identiifer123'] = true
}

function isBlacklisted(identifier, type)
    if type == "posts" then
        return adsBlacklisted[identifier]
    elseif type == "messages" then
        return messageBlacklisted[identifier]
    end
end