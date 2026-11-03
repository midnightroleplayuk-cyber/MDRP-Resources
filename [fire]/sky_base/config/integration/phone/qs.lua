if Sky.Config.phone ~= "qs" then return end

local RESOURCE = GetResourceState("qs-smartphone") == "started" and "qs-smartphone"
    or (GetResourceState("qs-smartphone-pro") == "started" and "qs-smartphone-pro")
    or "qs-smartphone"

local warnedPushApps = {}

local function build_app_url(app)
    local resource = app.resource or GetCurrentResourceName()
    local url = app.url

    if not url then
        local path = app.uiPath or app.ui or "ui/build/index.html"
        if path:find("^nui://") then
            url = path:gsub("^nui://([^/]+)/", "https://cfx-nui-%1/")
        elseif path:find("^https?://") then
            url = path
        else
            path = path:gsub("^" .. resource .. "/", "")
            url = ("https://cfx-nui-%s/%s"):format(resource, path)
        end
    end

    if app.route and not url:find("skyPhoneRoute=", 1, true) then
        local separator = url:find("?", 1, true) and "&" or "?"
        url = ("%s%sskyPhoneRoute=%s"):format(url, separator, app.route)
    end

    return url
end

-- qs-smartphone stores the number in the framework's player record (no documented qs
-- number-change export), so mirror the existing framework phone adapters.
function Sky.Functions.ChangeNumber(src, newNumber)
    if Sky.Config.framework == "qbox" then
        if not exports.qbx_core:GetPlayer(src) then return false, "player_unavailable" end
        exports.qbx_core:SetCharInfo(src, "phone", newNumber)
        exports.qbx_core:Save(src)
    elseif Sky.Config.framework == "qb" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        local charInfo = xPlayer.PlayerData.charinfo
        charInfo.phone = newNumber
        xPlayer.Functions.SetPlayerData("charinfo", charInfo)
        xPlayer.Functions.Save()
        xPlayer.Functions.UpdatePlayerData(false)
        TriggerClientEvent("QBCore:Player:UpdatePlayerData", src)
    else
        Sky.DB.SetValue("users", "phone_number", newNumber, "identifier", Sky.FW.GetIdentifier(src))
        TriggerClientEvent("sky_base:notification", src, "Phone", "Your phone number has been changed. Please relog.", "warn", 10000)
    end
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    if Sky.Config.framework == "qb" or Sky.Config.framework == "qbox" then
        local pattern = '%"phone%":"%' .. phoneNumber .. '%"%'
        local result = Sky.Query("SELECT citizenid FROM players WHERE charinfo LIKE ?", { pattern })
        return result[1] ~= nil
    end

    local result = Sky.Query("SELECT identifier FROM users WHERE phone_number = ?", { phoneNumber })
    return result[1] ~= nil
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    local resource = app.resource or GetCurrentResourceName()

    local added, reason = exports[RESOURCE]:addCustomApp({
        id = app.identifier,
        label = app.name,
        icon = app.icon,
        category = app.category or "Utilities",
        creator = app.developer or app.creator,
        description = app.description,
        age = app.age,
        appStoreOnly = app.defaultApp ~= true,
        price = app.price,
        sizeMb = app.size or app.sizeMb,
        iframe = {
            url = build_app_url(app)
        },
        custom = {
            enabled = true,
            sourceResource = resource,
            bridge = {
                enabled = true,
                allowedOrigins = { ("https://cfx-nui-%s"):format(resource) }
            }
        }
    })

    return added, reason
end

-- qs-smartphone has no Lua->app push. Custom apps pull their data instead: on open they call
-- a NUI callback (e.g. fetchNui("getData")) on their OWN resource, which answers via cb(data).
-- Warn once per app so live-update callers (e.g. blitzer) don't spam the console every call.
function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    SendNUIMessage(data or {})
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    data = data or {}

    if not IsDuplicityVersion() then
        TriggerServerEvent("sky_base:phone:sendAppNotification", data)
        return true
    end

    local target = tonumber(source or data.source or data.src)
    if not target or target <= 0 then
        Sky.Debug("error", "qs-smartphone SendPhoneAppNotification called with invalid target source.")
        return false
    end

    return exports[RESOURCE]:sendPhoneNotification(target, {
        appId = data.app or data.identifier,
        appName = data.appName or data.apptitle,
        title = data.title,
        subtitle = data.subtitle,
        text = data.content or data.message or data.text,
        closeTimeout = data.closeTimeout
    })
end

function Sky.Functions.GetPhoneNumber(source)
    if not IsDuplicityVersion() then return nil end
    if Sky.Config.framework == "qb" or Sky.Config.framework == "qbox" then
        local rows = Sky.Query(
            "SELECT `charinfo` FROM `players` WHERE `citizenid` = ? LIMIT 1",
            { Sky.FW.GetIdentifier(source) }
        ) or {}
        local charinfo = rows[1] and json.decode(rows[1].charinfo or "{}") or {}
        return charinfo.phone
    end

    local rows = Sky.Query(
        "SELECT `phone_number` FROM `users` WHERE `identifier` = ? LIMIT 1",
        { Sky.FW.GetIdentifier(source) }
    ) or {}
    return rows[1] and rows[1].phone_number or nil
end
