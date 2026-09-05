function SendWebHook(title, color, message)
    local embedMsg = {}
    timestamp = os.date("%c")
    embedMsg = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] =  message,
            ["footer"] ={
                ["text"] = timestamp.." (Server Time).",
            },
        }
    }
    PerformHttpRequest(ServerConfig.WebHook,
    function(err, text, headers)end, 'POST', json.encode({username = "OP Garages", embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end

WHData = {
    carAdded = {
        head = "CAR ADDED TO DATABASE",
        desc = "**Model:** `%s`\n**Plate:** `%s`\n**Player/Job/Gang:** `%s`\n**Administrator:** `%s`"
    },
    vehDel = {
        head = "CAR DELETED",
        desc = "**Plate:** `%s`\n**Administrator:** `%s`"
    },
    subOwnerAdded = {
        head = "SUBOWNER ADDED",
        desc = "**Plate:** `%s`\n**Owner:** `%s`\n**Assigned To:** `%s`"
    },
    subOwnerDel = {
        head = "SUBOWNER DELETED",
        desc = "**Plate:** `%s`\n**Owner:** `%s`"
    },
    platechanged = {
        head = "PLATE UPDATE",
        desc = "**Old Plate:** `%s`\n**New Plate:** `%s`\n**Admin:** `%s`"
    },
    impoundJob = {
        head = "VEHICLE IMPOUNDED",
        desc = "**Plate:** `%s`\n**Officer:** %s\n**Job:** `%s`\n**Impound Location:** `%s`\n**Reason:** %s\n**Price Before Date:** `$%s`\n**Price After Date:** `$%s`"
    },
    impoundRetrieve = {
        head = "VEHICLE RETRIEVED FROM IMPOUND",
        desc = "**Plate:** `%s`\n**Player:** %s\n**Job:** `%s`\n**Paid:** `$%s`"
    },
    impoundSendToGarage = {
        head = "VEHICLE SENT TO GARAGE FROM IMPOUND",
        desc = "**Plate:** `%s`\n**Player:** %s\n**Job:** `%s`\n**Paid:** `$%s`"
    },
    impoundReturnToOwner = {
        head = "IMPOUND VEHICLE RETURNED TO OWNER",
        desc = "**Plate:** `%s`\n**Released By:** %s\n**Job:** `%s`"
    }
}