-----------------------------------------------------------------------------------------------------------------------------------
--                                       ONLY EDIT THIS FILE IF YOU KNOW WHAT YOU ARE DOING                                      --
--                                         WE WILL NOT HELP YOU, OR ANSWER ANY QUESTIONS                                         --
-----------------------------------------------------------------------------------------------------------------------------------

---@class UploadMethod
---@field url string # Upload URL. Supports PRESIGNED_URL, which will automatically get replaced with the URL returned by GetPresignedUrl (server/custom/functions/functions.lua)
---@field httpMethod? "POST" | "PUT" # Defaults to "POST" if not defined
---@field headers? table<string, any> # These placeholders are supported: API_KEY, PLAYER_IDENTIFIER, PLAYER_NAME, RESOURCE_NAME, PLAYER_DATA (json encoded)
---@field uploadType? "formdata" | "binary" | "base64" # Defaults to "formdata" if not defined
---@field success? { path: string } # The path to the file. Supports nested paths, e.g. "data.0.url" (translates to data[0].url)
---@field error? { path: string, value: any } # The path to the error value and the value to check for
---@field field? string # The field name (only needed if using "formdata")
---@field suffix? string # Add a suffix to the url? Only needed if your upload server doesn't return the correct file extension
---@field bodyTemplate? table<string, any> # JSON body template for base64 uploads. These placeholders are supported: BASE64_DATA, FILE_EXTENSION, PLAYER_DATA, RESOURCE_NAME
---@field sendPlayer? string # The formdata field to send player's metadata (json encoded)
---@field sendResource? boolean # The formdata field to send the resource name

---@type table<string, { Default: UploadMethod?, Video?: UploadMethod, Image?: UploadMethod, Audio?: UploadMethod }>
UploadMethods = {
    Custom = {
        Video = {
            url = "https://your-custom-url.com/upload?api=API_KEY",
            field = "file", -- The field name (formData)
            headers = { -- headers to send when uploading
                ["Authorization"] = "Key API_KEY"
            },
            error = {
                path = "success", -- The path to the error value (res.success)
                value = false -- If the path is equal to this value, it's an error
            },
            success = {
                path = "url" -- The path to the video file (res.url)
            },
        },
        Image = {
            url = "https://your-custom-url.com/upload?api=API_KEY",
            field = "file", -- The field name (formData)
            headers = { -- headers to send when uploading
                ["Authorization"] = "Key API_KEY"
            },
            error = {
                path = "success", -- The path to the error value (res.success)
                value = false -- If the path is equal to this value, it's an error
            },
            success = {
                path = "url" -- The path to the image file (res.url)
            },
        },
        Audio = {
            url = "https://your-custom-url.com/upload?api=API_KEY",
            field = "file", -- The field name (formData)
            headers = { -- headers to send when uploading
                ["Authorization"] = "Key API_KEY"
            },
            error = {
                path = "success", -- The path to the error value (res.success)
                value = false -- If the path is equal to this value, it's an error
            },
            success = {
                path = "url" -- The path to the audio file (res.url)
            },
        },
    },
    Fivemanage = {
        Default = {
            url = "PRESIGNED_URL",
            field = "file",
            success = {
                path = "data.url"
            },
            sendPlayer = "metadata"
        },
    },
    LBPresigned = { -- https://github.com/lbphone/lb-presigned
        Default = {
            url = "PRESIGNED_URL",
            httpMethod = "PUT",
            uploadType = "binary",
        }
    },
    Qbox = {
        Default = {
            url = "PRESIGNED_URL",
            httpMethod = "POST",
            uploadType = "formdata",
            field = "file",
            success = {
                path = "data.url"
            }
        }
    }
}
