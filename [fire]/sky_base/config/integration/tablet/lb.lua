if Sky.Config.tablet ~= "lb" then return end

local RESOURCE = "lb-tablet"

local function normalize_ui_path(app)
    local ui = app.ui or app.uiPath
    if type(ui) ~= "string" or ui == "" then
        return nil
    end

    local resource = app.resource or GetCurrentResourceName()
    local escapedResource = resource:gsub("([^%w])", "%%%1")
    ui = ui:gsub("^nui://" .. escapedResource .. "/", "")
    ui = ui:gsub("^https://cfx%-nui%-" .. escapedResource .. "/", "")
    return ui
end

function Sky.Functions.RegisterCustomTabletApp(app)
    if IsDuplicityVersion() then
        return false, "client_only"
    end
    if type(app) ~= "table" or type(app.identifier) ~= "string" or app.identifier == "" then
        return false, "invalid_app"
    end

    local payload = {
        identifier = app.identifier,
        resource = app.resource or GetCurrentResourceName(),
        name = app.name,
        description = app.description,
        developer = app.developer,
        defaultApp = app.defaultApp == true,
        size = app.size,
        icon = app.icon,
        price = app.price,
        images = app.images,
        removable = app.removable,
        ui = normalize_ui_path(app),
        onInstall = app.onInstall,
        onOpen = app.onOpen,
        onClose = app.onClose,
        onUninstall = app.onUninstall
    }
    if app.fixBlur ~= nil then
        payload.fixBlur = app.fixBlur == true
    end

    return exports[RESOURCE]:AddCustomApp(payload)
end

function Sky.Functions.RemoveCustomTabletApp(identifier)
    if IsDuplicityVersion() then
        return false, "client_only"
    end
    return exports[RESOURCE]:RemoveCustomApp(identifier)
end

function Sky.Functions.SendCustomTabletAppMessage(identifier, event, data)
    if IsDuplicityVersion() then
        return false, "client_only"
    end

    -- Backwards compatibility with the old two-argument Sky wrapper.
    if type(event) == "table" and data == nil then
        data = event
        event = data.event or data.type or "message"
    end
    event = type(event) == "string" and event ~= "" and event or "message"
    return exports[RESOURCE]:SendCustomAppMessage(identifier, event, data or {})
end

function Sky.Functions.SendTabletAppNotification(data, source)
    data = type(data) == "table" and data or {}
    local payload = {}
    for key, value in pairs(data) do
        payload[key] = value
    end
    payload.source = source or payload.source or payload.src
    payload.app = payload.app or payload.identifier
    payload.title = payload.title or ""
    payload.content = payload.content or payload.message or payload.text or ""

    return exports[RESOURCE]:SendNotification(payload)
end

-- LB custom apps close themselves through the injected JavaScript closeApp API.
function Sky.Functions.CloseExternalTablet()
    return true
end
