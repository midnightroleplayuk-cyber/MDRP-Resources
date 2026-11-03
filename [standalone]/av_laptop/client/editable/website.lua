local useWhitelist = false -- true to restrict sites to only whitelisted in allWebsites table
local allWebsites = {
    ["uwucatcafe.com"] = true,
}

RegisterNUICallback("website", function(data,cb)
    if not useWhitelist then
        cb(true)
        return
    end
    local isValid = allWebsites and allWebsites[data] or false
    dbug("verifying website "..data..", is valid? ", isValid)
    cb(isValid)
end)