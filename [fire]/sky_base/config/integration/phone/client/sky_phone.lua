if Sky.Config.phone ~= "sky" then return end

local RESOURCE = "sky_phone"

local custom_app_resources = {}

local function normalize_asset_url(value, resource)
    if type(value) ~= "string" or value == "" or value:find("^https?://") or value:find("^nui://") then
        return value
    end
    local prefix = resource .. "/"
    return value:sub(1, #prefix) == prefix and value or prefix .. value
end

local function build_app_url(app, resource)
    local url = normalize_asset_url(app.url or app.ui or app.uiPath or "source/html/index.html", resource)
    if app.route and not url:find("skyPhoneRoute=", 1, true) then
        url = url .. (url:find("?", 1, true) and "&" or "?") .. "skyPhoneRoute=" .. tostring(app.route)
    end
    if not url:find("skyPhone=", 1, true) then
        url = url .. (url:find("?", 1, true) and "&" or "?") .. "skyPhone=sky_phone"
    end
    return url
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    if type(app) ~= "table" then
        Sky.Debug("error", "sky_phone custom app registration expected an app table, got %s.", type(app))
        return false, "invalid_app"
    end

    local resource = app.resource or GetInvokingResource() or GetCurrentResourceName()
    local removable = app.removable
    if removable == nil then removable = app.defaultApp ~= true end
    local permissions = { table.unpack(app.permissions or {}) }
    local has_notifications = false
    for _, permission in ipairs(permissions) do
        if permission == "notifications" then has_notifications = true end
    end
    if app.notification ~= false and not has_notifications then
        permissions[#permissions + 1] = "notifications"
    end

    local registered, registration_error = exports[RESOURCE]:AddCustomApp({
        schemaVersion = 1,
        id = app.identifier,
        name = app.name,
        description = app.description,
        developer = app.developer,
        category = app.category or ((app.game == true or app.games == true) and "games" or "utilities"),
        ui = build_app_url(app, resource),
        assetResource = resource,
        bridgeMode = app.bridgeMode or "legacy",
        icon = normalize_asset_url(app.icon, resource),
        defaultInstalled = app.defaultApp == true,
        removable = removable,
        orientation = app.orientation or (app.landscape == true and "landscape" or "portrait"),
        permissions = permissions,
        gridOrder = app.gridOrder,
        iconBackground = app.skyPhoneIconBackground
            or (type(app.iconBackground) == "string" and app.iconBackground or nil),
        onInstall = app.onInstall,
        onDelete = app.onDelete or app.onUninstall,
        onOpen = app.onOpen or app.onUse,
        onClose = app.onClose,
        compatibility = {
            provider = "sky_base",
            apiVersion = 1,
            fixBlur = app.fixBlur ~= false,
            resourceName = resource
        }
    })
    if registered then custom_app_resources[app.identifier] = resource end
    return registered, registration_error
end

function Sky.Functions.RemoveCustomPhoneApp(identifier)
    local removed, removal_error = exports[RESOURCE]:RemoveCustomApp(identifier)
    if removed or removal_error == "app_not_found" then custom_app_resources[identifier] = nil end
    return removed, removal_error
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    return exports[RESOURCE]:SendCustomAppMessage(identifier, data or {})
end

function Sky.Functions.OpenCustomPhoneApp(identifier, data)
    return exports[RESOURCE]:OpenCustomApp(identifier, data)
end

function Sky.Functions.SendPhoneAppNotification(data)
    if type(data) ~= "table" then return false, "invalid_notification" end
    local app_id = data.app or data.identifier
    local text = data.content or data.message or data.text
    local delivered, delivery_error = exports[RESOURCE]:SendCustomAppNotification(app_id, {
        title = data.title, text = text, subtitle = data.subtitle,
        critical = data.critical, persistent = data.persistent, sound = data.sound
    })
    if delivered or (delivery_error ~= "app_not_found" and delivery_error ~= "app_owner_mismatch") then
        return delivered, delivery_error
    end
    return exports["lb-phone"]:SendNotification({ app = app_id, title = data.title, content = text })
end

function Sky.Functions.SetPhoneInputFocus(focused)
    if type(focused) ~= "boolean" then
        Sky.Debug("warn", "sky_phone input focus expected a boolean, got %s.", type(focused))
        return false, "invalid_focus"
    end
    local game_input
    if focused then game_input = false end
    return exports[RESOURCE]:SetPhoneGameInputEnabled(game_input)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == "sky_phone" then
        custom_app_resources = {}
        return
    end
    for identifier, owner in pairs(custom_app_resources) do
        if owner == resource then
            local removed, removal_error = Sky.Functions.RemoveCustomPhoneApp(identifier)
            if not removed and removal_error ~= "app_not_found" then
                Sky.Debug("error", "sky_phone failed to remove custom app %s while %s stopped: %s.",
                    identifier, resource, tostring(removal_error or "unknown_error"))
            end
        end
    end
end)

RegisterNetEvent("sky_base:sky_phone:sendNotification", function(data)
    local delivered, delivery_error = Sky.Functions.SendPhoneAppNotification(data)
    if not delivered then
        Sky.Debug("error", "sky_phone client notification delivery failed: %s.", tostring(delivery_error or "unknown_error"))
    end
end)
