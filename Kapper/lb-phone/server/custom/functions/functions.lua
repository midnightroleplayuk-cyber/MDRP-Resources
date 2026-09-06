---@param username string
---@return boolean
function IsUsernameValid(username)
    if #username < 3 or #username > 20 then
        debugprint("Invalid username length", username)
        return false
    end

    if not Config.UsernameFilter or not Config.UsernameFilter.LuaPattern then
        return true
    end

    if not username:match(Config.UsernameFilter.LuaPattern) then
        debugprint("Invalid username", username)
        return false
    end

    return true
end

local MIME_TYPES <const> = {
    Video = "video/webm",
    Image = "image/webp",
    Audio = "audio/webm;codecs=opus"
}

---@param source number
---@param uploadType "Audio" | "Image" | "Video"
---@return string | { upload: string, result: string } | nil
function GetPresignedUrl(source, uploadType)
    local apiKey = API_KEYS[uploadType]
    local uploadMethod = Config.UploadMethod[uploadType]

    if uploadMethod == "LBPresigned" then
        if GetResourceState("lb-presigned") ~= "started" then
            infoprint("error", "lb-presigned resource is not started. Please start it to use the LBPresigned upload method.")
            return
        end

        local res = exports["lb-presigned"]:GeneratePresignedUrl(MIME_TYPES[uploadType])

        return {
            upload = res.presignedUrl,
            result = res.fileUrl
        }
    elseif uploadMethod == "Qbox" then
        return Citizen.Await(promise.new(function(p)
            PerformHttpRequest("https://api.qbox.re/v1/file/presigned-url", function(status, body, headers, errorData)
                if status ~= 200 then
                    p:resolve()

                    infoprint("error", "Failed to create presigned URL using Qbox")
                    print("Status:", status)
                    print("Body:", body)
                    print("Headers:", json.encode(headers or {}, { indent = true }))

                    if errorData then
                        print("Error:", errorData)
                    end

                    return
                end

                local data = json.decode(body)

                p:resolve(data?.data?.presignedUrl)
            end, "GET", nil, {
                Accept = "application/json",
                authorization = "Bearer " .. apiKey
            })
        end))
    end

    infoprint("warning", "GetPresignedUrl has not been set up. Set it up in lb-phone/server/custom/functions/functions.lua, or change your upload method to Fivemanage.")
end

---@param source number
---@param plate string
---@param vehicle? number # The vehicle handle, if Config.ServerSideSpawn is enabled
function GiveVehicleKey(source, plate, vehicle)
end
