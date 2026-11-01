if Sky.Config.phone ~= "yseries" then return end

local RESOURCE = "yseries"

function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = false }
end

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
        local sep = url:find("?", 1, true) and "&" or "?"
        url = ("%s%sskyPhoneRoute=%s"):format(url, sep, app.route)
    end
    return url
end
local function normalize_icon(icon)
    if not icon then return nil end
    if type(icon) == "table" then
        local result = {}
        for k, v in pairs(icon) do
            if type(v) == "string" then
                if v:find("^nui://") then
                    result[k] = v:gsub("^nui://([^/]+)/", "https://cfx-nui-%1/")
                else
                    result[k] = v
                end
            end
        end
        return result
    end
    if type(icon) == "string" then
        local url = icon
        if url:find("^nui://") then
            url = url:gsub("^nui://([^/]+)/", "https://cfx-nui-%1/")
        end
        return { yos = url, humanoid = url }
    end
    return nil
end
local clientRegisteredApps = {}
local function client_yseries_ready()
    if GetResourceState(RESOURCE) ~= "started" then return false end
    if not exports.yseries then return false end
    return type(exports.yseries.AddCustomApp) == "function"
end
local function client_register_app(app)
    if not app or not app.key then return end
    if not client_yseries_ready() then return end
    if clientRegisteredApps[app.key] then
        pcall(function() exports[RESOURCE]:RemoveCustomApp(app.key) end)
        clientRegisteredApps[app.key] = nil
    end
    local ok, err = pcall(function() exports[RESOURCE]:AddCustomApp(app) end)
    if ok then
        clientRegisteredApps[app.key] = true
    else
        -- log removed
end
end
function Sky.Functions.ChangeNumber(src, newNumber)
    if not IsDuplicityVersion() then return end
    local phoneImei = exports[RESOURCE]:GetPhoneImeiBySourceId(src)
    if phoneImei then exports[RESOURCE]:ChangePhoneNumber(phoneImei, newNumber) end
end
function Sky.Functions.IsNumberUsed(phoneNumber)
    if not IsDuplicityVersion() then return false end
    if not phoneNumber then return false end
    local ok, src = pcall(function() return exports[RESOURCE]:GetPlayerSourceIdByPhoneNumber(phoneNumber) end)
    return ok and src ~= nil
end
local SERVER_CACHE = {}
if IsDuplicityVersion() then
    RegisterNetEvent("sky_police_yseries:requestApps", function()
        local src = source
        -- Read from GlobalState (replicated, cross-resource) instead of local cache.
        local apps = GlobalState.sky_police_yseries_apps or {}
        local count = 0
        for _ in pairs(apps) do count = count + 1 end
        for key, app in pairs(apps) do
            TriggerClientEvent("sky_police_yseries:registerApp", src, app)
        end
    end)
end
function Sky.Functions.RegisterCustomPhoneApp(app)
    if type(app) ~= "table" or not app.identifier then return false end
    local payload = {
        key        = app.identifier,
        name       = app.name,
        ui         = build_app_url(app),
        icon       = normalize_icon(app.icon),
        defaultApp = app.defaultApp == true,
    }
    if app.game ~= nil then payload.game = app.game == true end
    if app.allowedJobs  then payload.allowedJobs  = app.allowedJobs  end
    if app.disabledJobs then payload.disabledJobs = app.disabledJobs end
    if IsDuplicityVersion() then
        local apps = GlobalState.sky_police_yseries_apps or {}
        apps[payload.key] = payload
        GlobalState.sky_police_yseries_apps = apps
        TriggerClientEvent("sky_police_yseries:registerApp", -1, payload)
    else
        CreateThread(function()
            while GetResourceState(RESOURCE) ~= "started" do Wait(500) end
            while not exports.yseries or type(exports.yseries.AddCustomApp) ~= "function" do Wait(500) end
            local dl = exports[RESOURCE]:GetDataLoaded()
            while not dl do Wait(500); dl = exports[RESOURCE]:GetDataLoaded() end
            local ok, err = pcall(function() exports[RESOURCE]:AddCustomApp(payload) end)
        end)
    end
    return true
end
function Sky.Functions.SendCustomPhoneAppMessage(identifier, data, source)
    if not IsDuplicityVersion() then return end
    if not identifier then return false end
    local target = tonumber(source) or -1
    TriggerClientEvent("sky_police_yseries:appMessage", target, identifier, data or {})
    return true
end
function Sky.Functions.SendPhoneAppNotification(data, source)
    if not IsDuplicityVersion() then return end
    data = data or {}
    local target = tonumber(source or data.source or data.src)
    if not target or target <= 0 then
        if data.phoneNumber then
            target = exports[RESOURCE]:GetPlayerSourceIdByPhoneNumber(data.phoneNumber)
        end
        if not target or target <= 0 then return false end
    end
    exports[RESOURCE]:SendNotification({
        app   = data.app or data.identifier,
        title = data.title,
        text  = data.content or data.message or data.text,
        timeout = data.timeout or data.closeTimeout,
        icon  = data.icon,
        data  = data.data,
    }, "source", target)
    return true
end
function Sky.Functions.GetPhoneNumber(source)
    if not IsDuplicityVersion() then return nil end
    return exports[RESOURCE]:GetPhoneNumberBySourceId(source)
end
function Sky.Functions.GetSourceFromNumber(phoneNumber)
    if not IsDuplicityVersion() then return nil end
    if not phoneNumber then return nil end
    return exports[RESOURCE]:GetPlayerSourceIdByPhoneNumber(phoneNumber)
end
function Sky.Functions.HasAirplaneMode(phoneNumber)
    if IsDuplicityVersion() then return false end
    return exports[RESOURCE]:AirplaneModeEnabled() == true
end
if not IsDuplicityVersion() then
    function Sky.Functions.SetPhoneInputFocus(focused)
        exports[RESOURCE]:SetNuiFocusKeepInput(not focused)
        return true
    end

    RegisterNetEvent("sky_police_yseries:registerApp", function(app)
        client_register_app(app)
    end)
    RegisterNetEvent("sky_police_yseries:appMessage", function(key, data)
        if not key or not clientRegisteredApps[key] then return end
        local env = (type(data) == "table" and data.action ~= nil) and data or { action = "message", data = data }
        pcall(function() exports[RESOURCE]:SendAppMessage(key, env) end)
    end)
    CreateThread(function()
        while not client_yseries_ready() do Wait(500) end
        local dl = exports[RESOURCE]:GetDataLoaded()
        while not dl do Wait(500); dl = exports[RESOURCE]:GetDataLoaded() end

        -- Read GlobalState directly (replicated to clients automatically).
        local apps = GlobalState.sky_police_yseries_apps or {}
        for key, app in pairs(apps) do client_register_app(app) end

        -- Also ask the server (in case GlobalState replication is delayed).
        TriggerServerEvent("sky_police_yseries:requestApps")

        -- Listen for future GlobalState changes (new apps registered after join).
        AddStateBagChangeHandler("sky_police_yseries_apps", nil, function(_, _, value)
            if type(value) ~= "table" then return end
            for key, app in pairs(value) do client_register_app(app) end
        end)
    end)
    AddEventHandler("onResourceStart", function(resource)
        if resource == "yseries" then
            clientRegisteredApps = {}
            CreateThread(function()
                while not client_yseries_ready() do Wait(500) end
                local dl = exports[RESOURCE]:GetDataLoaded()
                while not dl do Wait(500); dl = exports[RESOURCE]:GetDataLoaded() end
                TriggerServerEvent("sky_police_yseries:requestApps")
            end)
        end
    end)
    RegisterNetEvent("yseries:phone-item-added", function()
        CreateThread(function()
            local waited = 0
            while not client_yseries_ready() do Wait(500); waited = waited + 500; if waited > 5000 then return end end
            local dl = exports[RESOURCE]:GetDataLoaded()
            while not dl do Wait(500); dl = exports[RESOURCE]:GetDataLoaded() end
            -- Clear local cache so apps re-register fresh on the new phone.
            for key, _ in pairs(clientRegisteredApps) do
                pcall(function() exports[RESOURCE]:RemoveCustomApp(key) end)
                clientRegisteredApps[key] = nil
            end
            TriggerServerEvent("sky_police_yseries:requestApps")
        end)
    end)
    RegisterNetEvent("yseries:phone-item-removed", function()
    end)
    RegisterNUICallback("toggle-NuiFocusKeepInput", function(focus, cb)
        if type(focus) ~= "boolean" then
            Sky.Debug("warn", "YSeries input focus expected a boolean, got %s.", type(focus))
            cb({ success = false, error = "invalid_focus" })
            return
        end
        Sky.Functions.SetPhoneInputFocus(not focus)
        cb({})
    end)
end
