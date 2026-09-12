---@return string #presigned-url
local function fivemanageGetPresignedUrl()
    assert(configCore.screenshot.fivemanage.active, "Fivemanage screenshots are not active in configs/screenshotConfig.lua")
    assert(configCore.screenshot.fivemanage.api ~= "", "Fivemanage API key is not set in configs/screenshotConfig.lua")

    local p = promise.new()
    PerformHttpRequest("https://fmapi.net/api/v2/presigned-url?fileType=image", function(errorCode, resultData, _, errorData)
        if errorData then
            local errorText = ("Fivemanage API request failed with code %s | Error Data: %s"):format(tostring(errorCode), tostring(errorData))
            p:reject(errorText)
            return
        end

        p:resolve(json.decode(resultData))
    end, 'GET', '', {
        Authorization = configCore.screenshot.fivemanage.api
    }, { followLocation = true })

    local result = Citizen.Await(p)
    assert(result.status == "ok", "Fivemanage API request failed")

    return result.data.presignedUrl
end

---@param src number
---@param data { webhook: string, quality?: number, encoding?: 'jpg' | 'png' | 'webp' }
---@diagnostic disable-next-line dublicate-function
tgiCore.Screenshot = function(src, data)
    local requestData = {}
    if configCore.screenshot.fivemanage.active then
        requestData.url = fivemanageGetPresignedUrl()
        requestData.method = "fivemanage"
    elseif configCore.screenshot.nonefivem.active then
        assert(GetResourceState("nocloud") == "started", "nocloud resource must be started for nonefivem screenshots")

        requestData.method = "nonefivem"
        requestData.data = {
            scriptName = configCore.screenshot.nonefivem.scriptName
        }
    else
        local webhook = data.webhook and data.webhook ~= "" and data.webhook or configCore.screenshot.discordWebhook
        requestData.url = webhook
    end

    return lib.callback.await("tgiann-core:screenshot", src, requestData)
end

Export("Screenshot", tgiCore.Screenshot)

lib.callback.register("tgiann-core:server:screenshot", tgiCore.Screenshot)
