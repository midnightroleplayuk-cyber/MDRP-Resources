local function getWebhookUrl()
    local webhook = Config.webHook
    if type(webhook) ~= 'string' or webhook == '' then
        return nil
    end

    return webhook
end

local function normalizeImageData(imageData)
    if type(imageData) == 'table' then
        imageData = imageData.data or imageData.image or imageData.base64
    end

    if type(imageData) ~= 'string' or imageData == '' then
        return nil
    end

    local base64 = imageData:match('base64,(.+)') or imageData
    base64 = base64:gsub('%s+', '')

    return base64 ~= '' and base64 or nil
end

local function buildDiscordImageMultipart(payload, imageBase64, filename)
    local boundary = ('----OSPAmbulance%s%s%s'):format(
        os.time(),
        math.random(100000, 999999),
        math.random(100000, 999999)
    )

    -- The body stays text-only. Raw image bytes can abort CFX's CURL callback.
    local body =
        '--' .. boundary .. '\r\n' ..
        'Content-Disposition: form-data; name="payload_json"\r\n' ..
        'Content-Type: application/json\r\n\r\n' ..
        payload .. '\r\n' ..
        '--' .. boundary .. '\r\n' ..
        'Content-Disposition: form-data; name="files[0]"; filename="' .. filename .. '"\r\n' ..
        'Content-Type: image/webp\r\n' ..
        'Content-Transfer-Encoding: base64\r\n\r\n' ..
        imageBase64 .. '\r\n' ..
        '--' .. boundary .. '--\r\n'

    return body, boundary
end

local function createDiscordImagePayload(filename, description, embed)
    return json.encode({
        username = Config.webHookName,
        avatar_url = Config.webHookLogo,
        attachments = {
            {
                id = 0,
                filename = filename,
                description = description,
            },
        },
        embeds = { embed },
    })
end

local function sendDiscordImage(webhook, imageBase64, filename, description, embed, onSuccess)
    local payload = createDiscordImagePayload(filename, description, embed)
    local body, boundary = buildDiscordImageMultipart(payload, imageBase64, filename)

    PerformHttpRequest(webhook, function(status, response, _, errorData)
        if status ~= 200 and status ~= 204 then
            print(('^1[osp_ambulance] Discord %s upload failed (HTTP %s, %s bytes): %s %s^0')
                :format(
                    description,
                    tostring(status),
                    tostring(#body),
                    tostring(response or ''),
                    tostring(errorData or '')
                ))
            return
        end

        if onSuccess then
            onSuccess()
        end
    end, 'POST', body, {
        ['Content-Type'] = 'multipart/form-data; boundary=' .. boundary,
    })
end

local function createDeathEmbed(data, filename, color)
    local embed = {
        title = data.title or 'Player Died',
        color = color,
        fields = {
            {
                name = 'Player Name (ID)',
                value = tostring(data.playerName or 'Unknown'),
                inline = true,
            },
            {
                name = 'Cause of Death',
                value = tostring(data.weaponLabel or 'Unknown'),
                inline = true,
            },
            {
                name = 'Killer Name (ID)',
                value = tostring(data.killerName or 'None (Suicide)'),
                inline = true,
            },
        },
        image = { url = 'attachment://' .. filename },
        footer = { text = data.time .. ' (Server Time)' },
    }

    if type(data.message) == 'string' and data.message ~= '' then
        embed.description = data.message
    end

    return embed
end

local function uploadImageToWebhook(data, victimImageData, killerImageData)
    local webhook = getWebhookUrl()
    local victimImage = normalizeImageData(victimImageData)

    if not webhook then
        return
    end

    if not victimImage then
        print('^1[osp_ambulance] Invalid victim image data^0')
        return
    end

    data = type(data) == 'table' and data or {}

    local victimFilename = 'victim.webp'
    local killerFilename = 'killer.webp'
    local killerImage = normalizeImageData(killerImageData)
    local color = tonumber(data.color) or 2123412

    -- Upload in order and keep both requests small enough for FiveM's HTTP timeout.
    sendDiscordImage(
        webhook,
        victimImage,
        victimFilename,
        'victim image',
        createDeathEmbed(data, victimFilename, color),
        function()
            if not killerImage then
                return
            end

            sendDiscordImage(
                webhook,
                killerImage,
                killerFilename,
                'killer image',
                {
                    title = 'Killer Screenshot',
                    color = color,
                    description = 'Killer: ' .. tostring(data.killerName or 'Unknown'),
                    image = { url = 'attachment://' .. killerFilename },
                    footer = { text = data.time .. ' (Server Time)' },
                }
            )
        end
    )
end

local SCREENSHOT_TIMEOUT = 8000
local SCREENSHOT_COOLDOWN = 1000
local SCREENSHOT_CACHE_MS = 3000
local SCREENSHOT_OPTIONS = {
    encoding = 'webp',
    quality = 0.8
}

-- screenshot-basic / screencapture crash a client if two captures overlap.
-- Rapid multi-kills request the killer twice at once, so serialize per player
-- and reuse a fresh screenshot instead of starting another capture.
local captureStates = {}

local function getCaptureState(playerId)
    local state = captureStates[playerId]
    if not state then
        state = {
            busy = false,
            queue = {},
            lastImage = nil,
            lastAt = 0,
        }
        captureStates[playerId] = state
    end
    return state
end

local function startScreenshotCapture(playerId, callback)
    local finished = false

    local function finish(image, err)
        if finished then
            return
        end

        finished = true
        callback(image, err)
    end

    local capture
    if GetResourceState('screencapture') == 'started' then
        capture = function()
            exports.screencapture:serverCapture(playerId, SCREENSHOT_OPTIONS, function(image)
                finish(image, image and nil or 'no image returned')
            end)
        end
    elseif GetResourceState('screenshot-basic') == 'started' then
        capture = function()
            exports['screenshot-basic']:requestClientScreenshot(
                playerId,
                SCREENSHOT_OPTIONS,
                function(err, image)
                    finish(image, err or (not image and 'no image returned'))
                end
            )
        end
    else
        finish(nil, 'neither screenshot-basic nor screencapture is started')
        return
    end

    local ok, err = pcall(capture)
    if not ok then
        finish(nil, err)
        return
    end

    SetTimeout(SCREENSHOT_TIMEOUT, function()
        finish(nil, 'timed out')
    end)
end

local function processCaptureQueue(playerId)
    local state = captureStates[playerId]
    if not state or state.busy then
        return
    end

    local callback = table.remove(state.queue, 1)
    if not callback then
        return
    end

    local now = GetGameTimer()
    if state.lastImage and (now - state.lastAt) < SCREENSHOT_CACHE_MS then
        callback(state.lastImage, nil)
        processCaptureQueue(playerId)
        return
    end

    state.busy = true

    startScreenshotCapture(playerId, function(image, err)
        state = captureStates[playerId]
        if not state then
            callback(image, err)
            return
        end

        if image then
            local capturedAt = GetGameTimer()
            state.lastImage = image
            state.lastAt = capturedAt
            callback(image, err)
            state.busy = false
            processCaptureQueue(playerId)
            SetTimeout(SCREENSHOT_CACHE_MS, function()
                local current = captureStates[playerId]
                if current and current.lastAt == capturedAt then
                    current.lastImage = nil
                end
            end)
            return
        end

        callback(image, err)
        SetTimeout(SCREENSHOT_COOLDOWN, function()
            state = captureStates[playerId]
            if not state then
                return
            end
            state.busy = false
            processCaptureQueue(playerId)
        end)
    end)
end

local function capturePlayerScreenshot(playerId, callback)
    playerId = tonumber(playerId)
    if not playerId then
        callback(nil, 'invalid player')
        return
    end

    local state = getCaptureState(playerId)
    state.queue[#state.queue + 1] = callback
    processCaptureQueue(playerId)
end

AddEventHandler('playerDropped', function()
    local state = captureStates[source]
    captureStates[source] = nil
    if not state then
        return
    end

    for i = 1, #state.queue do
        state.queue[i](nil, 'player dropped')
    end
end)

RegisterNetEvent('osp_ambulance:requestScreenshotSv', function(data)
    if type(data) ~= 'table' or not getWebhookUrl() then
        return
    end
    data.time = data.time or os.date('%c')
    local victimId = tonumber(data.target)
    local killerId = data.killer and tonumber(data.killer) or nil
    if not victimId then
        return
    end

    capturePlayerScreenshot(victimId, function(victimImage, victimError)
        if not victimImage then
            print(('^1[osp_ambulance] Victim screenshot failed: %s^0')
                :format(tostring(victimError)))
            return
        end

        if not killerId then
            uploadImageToWebhook(data, victimImage)
            return
        end

        capturePlayerScreenshot(killerId, function(killerImage, killerError)
            if not killerImage then
                print(('^3[osp_ambulance] Killer screenshot failed: %s; uploading victim only^0')
                    :format(tostring(killerError)))
            end

            uploadImageToWebhook(data, victimImage, killerImage)
        end)
    end)
end)
