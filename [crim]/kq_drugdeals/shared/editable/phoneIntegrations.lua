local baseUrl = 'https://cfx-nui-' .. GetCurrentResourceName() .. '/nui/dist/nui.html?inphone=1'
local assetUrl = 'nui://' .. GetCurrentResourceName() .. '/nui/dist/assets/'
local assetWebUrl = 'https://cfx-nui-' .. GetCurrentResourceName() .. '/nui/dist/assets/'

local apps = {
    plug = {
        key = 'kq_drugdeals_app',
        nameKey = 'app.name',
        descriptionKey = 'app.description',
        tagsKey = 'app.tags',
        url = baseUrl,
        icon = assetUrl .. 'plug-icon.png',
        iconWeb = assetWebUrl .. 'plug-icon.png',
        iconRounded = assetUrl .. 'plug-icon-rounded.png',
        iconSvg = assetUrl .. 'plug-icon.svg',
        enabled = Config.app.customApp.enabled,
    },
    police = {
        key = 'kq_drugdeals_police',
        nameKey = 'app.police_name',
        descriptionKey = 'app.police_description',
        tagsKey = 'app.police_tags',
        url = baseUrl .. '&app=police',
        icon = assetUrl .. 'lspd-icon.png',
        iconWeb = assetWebUrl .. 'lspd-icon.png',
        iconRounded = assetUrl .. 'lspd-icon-rounded.png',
        iconSvg = assetUrl .. 'lspd-icon.svg',
        enabled = Config.police.enabled and Config.police.customApp.enabled,
    },
}

local appScale = {
    ['yseries'] = 1.2,
    ['lb-phone'] = 1.1,
    ['lb-tablet'] = 1.1,
    ['qs-smartphone-pro'] = 1.1,
    ['17mov_Phone'] = 1.1,
    ['gksphone'] = 1.1,
    ['high-phone'] = 1.1,
    ['sd-phone'] = 1.1,
    ['codem-phone'] = 1.1,
    ['okokPhone'] = 1.1,
}

local function AppUrl(resource, app)
    local scale = appScale[resource]

    if not scale or scale == 1.0 then
        return app.url
    end

    return app.url .. '&scale=' .. scale
end

local phones = {
    ['yseries'] = {
        server = false,
        add = function(app)
            exports.yseries:AddCustomApp({
                key = app.key,
                name = L(app.nameKey),
                defaultApp = false,
                ui = AppUrl('yseries', app),
                description = L(app.tagsKey),
                icon = {
                    yos = app.iconRounded,
                    humanoid = app.iconRounded,
                },
            })
        end,
        remove = function(app)
            exports.yseries:RemoveCustomApp(app.key)
        end,
        notifyServer = function(app, src, data)
            exports.yseries:SendNotification({
                app = app.key,
                title = data.title,
                text = data.content,
                timeout = 5000,
            }, 'source', src)
        end
    },
    ['lb-phone'] = {
        server = false,
        add = function(app)
            exports['lb-phone']:AddCustomApp({
                identifier = app.key,
                name = L(app.nameKey),
                description = L(app.descriptionKey),
                defaultApp = false,
                developer = 'KuzQuality.com',
                ui = AppUrl('lb-phone', app),
                icon = app.icon,
                size = 72000,
            })
        end,
        remove = function(app)
            exports['lb-phone']:RemoveCustomApp(app.key)
        end,
        notify = function(app, data)
            exports['lb-phone']:SendNotification({
                app = app.key,
                title = data.title,
                content = data.content,
                thumbnail = nil,
            })
        end
    },
    ['lb-tablet'] = {
        server = false,
        add = function(app)
            exports['lb-tablet']:AddCustomApp({
                identifier = app.key,
                name = L(app.nameKey),
                description = L(app.descriptionKey),
                defaultApp = false,
                developer = 'KuzQuality.com',
                ui = AppUrl('lb-tablet', app),
                icon = app.icon,
                size = 52000,
            })
        end,
        remove = function(app)
            exports['lb-tablet']:RemoveCustomApp(app.key)
        end,
        notify = function(app, data)
            exports['lb-tablet']:SendNotification({
                app = app.key,
                title = data.title,
                content = data.content,
                thumbnail = app.icon,
            })
        end
    },
    ['qs-smartphone-pro'] = {
        server = false,
        add = function(app)
            exports['qs-smartphone-pro']:addCustomApp({
                app = app.key,
                label = L(app.nameKey),
                description = L(app.descriptionKey),
                defaultApp = false,
                creator = 'KuzQuality.com',
                category = 'social',
                isGame = false,
                age = '18+',
                timeout = 5000,
                job = false,
                blockedJobs = {},
                ui = AppUrl('qs-smartphone-pro', app),
                icon = app.icon,
                extraDescription = {}
            })
        end,
        remove = function(app)
            exports['qs-smartphone-pro']:removeCustomApp(app.key)
        end,
        notifyServer = function(app, src, data)
            local number = exports['qs-smartphone-pro']:GetPhoneNumberFromIdentifier(GetPlayerUniqueIdentifier(src), false)

            if not number then
                return
            end

            exports['qs-smartphone-pro']:sendNotification(number, {
                app = app.key,
                head = data.title,
                msg = data.content,
            }, false)
        end
    },
    ['17mov_Phone'] = {
        server = false,
        add = function(app)
            exports['17mov_Phone']:AddApplication({
                name = app.key,
                label = L(app.nameKey),
                ui = AppUrl('17mov_Phone', app),
                icon = app.iconSvg,
                iconBackground = '#141615',
                rating = 4.1,
                resourceName = GetCurrentResourceName(),
            })
        end,
        remove = function(app)
            exports['17mov_Phone']:RemoveApplication(app.key)
        end,
        notifyServer = function(app, src, data)
            exports['17mov_Phone']:SendNotificationToSrc(src, {
                app = app.key,
                title = data.title,
                message = data.content,
            })
        end
    },
    ['gksphone'] = {
        server = true,
        add = function(app)
            exports['gksphone']:AddCustomApp({
                name = app.key,
                icons = app.icon,
                categori = "mix",
                appurl = AppUrl('gksphone', app),
                url = '/customapp',
                blockedjobs = {},
                allowjob = {},
                signal = false,
                show = true,
                labelLangs = {
                    af = L(app.nameKey),
                    ar = L(app.nameKey),
                    cs = L(app.nameKey),
                    de = L(app.nameKey),
                    en = L(app.nameKey),
                    es = L(app.nameKey),
                    fr = L(app.nameKey),
                    id = L(app.nameKey),
                    nl = L(app.nameKey),
                    ["pt-PT"] = L(app.nameKey),
                    ro = L(app.nameKey),
                    sv = L(app.nameKey),
                    th = L(app.nameKey),
                    tr = L(app.nameKey),
                    uk = L(app.nameKey),
                    ["zh-TW"] = L(app.nameKey)
                }
            })
        end,
        remove = function(app) end,
        notifyServer = function(app, src, data)
            exports['gksphone']:sendNotification(src, {
                title = data.title,
                message = data.content,
                icon = app.icon,
                duration = 5000,
            })
        end
    },
    ['high-phone'] = {
        server = true,
        add = function(app)
            exports['high-phone']:addApplication(app.key, {
                developer = "KuzQuality.com",
                preAdded = false,
                removable = true,
                inAppStore = true,
                size = 19.34,
                preview = {},
                icon = {
                    imageUrl = app.icon,
                    background = "#0E0F0E"
                },
                externalUrl = AppUrl('high-phone', app)
            }, {
                ["en"] = {
                    label = L(app.nameKey),
                    description = L(app.descriptionKey)
                }
            })
        end,
        remove = function(app) end,
        notifyServer = function(app, src, data)
            exports['high-phone']:sendNotification(src, {
                application = { name = app.key },
                title = data.title,
                content = data.content,
                icon = { imageUrl = app.icon },
                duration = 5000,
            })
        end
    },
    ['sd-phone'] = {
        server = false,
        add = function(app)
            exports['sd-phone']:addCustomApp({
                identifier = app.key,
                name = L(app.nameKey),
                description = L(app.descriptionKey),
                developer = 'KuzQuality.com',
                defaultApp = false,
                ui = AppUrl('sd-phone', app),
                icon = app.iconWeb,
                size = 19340,
            })
        end,
        remove = function(app)
            exports['sd-phone']:removeCustomApp(app.key)
        end,
        notify = function(app, data)
            exports['sd-phone']:showNotification({
                app = app.key,
                appId = app.key,
                title = data.title,
                body = data.content,
                time = 'now',
            })
        end
    },
    ['codem-phone'] = {
        server = false,
        add = function(app)
            exports['codem-phone']:AddCustomApp({
                identifier = app.key,
                name = L(app.nameKey),
                icon = app.iconSvg,
                ui = AppUrl('codem-phone', app),
                description = L(app.descriptionKey),
                defaultApp = false,
                notification = true,
                addAppStore = true,
                onOpen = function() end,
                onClose = function() end
            })
        end,
        remove = function(app)
            exports['codem-phone']:RemoveCustomApp(app.key)
        end,
        notifyServer = function(app, src, data)
            exports['codem-phone']:SendNotify(src, {
                app = app.key,
                title = data.title,
                message = data.content,
            })
        end
    },
    ['okokPhone'] = {
        server = 'shared',
        add = function(app)
            exports['okokPhone']:loadApp({
                id = app.key,
                label = L(app.nameKey),
                description = L(app.descriptionKey),
                custom = true,
                icon = app.icon,
                previewImagesCount = 0,
                notifications = true,
                resourceName = GetCurrentResourceName(),
                webUrl = AppUrl('okokPhone', app),
            })
        end,
        remove = function(app) end,
        notify = function(app, data)
            TriggerEvent('okokPhone:client:NotifyDI', {
                title = data.title,
                text = data.content,
                app = app.key,
                icon = app.icon,
                duration = 5000,
            })
        end
    },
}

local isServer = IsDuplicityVersion()

function HasPhoneIntegration()
    for resource, phone in pairs(phones) do
        if (phone.notify or phone.notifyServer) and GetResourceState(resource) == 'started' then
            return true
        end
    end

    return false
end

-- Whether the Plug app is registered into any started phone resource
function HasRegisteredPhoneApp()
    if not apps.plug.enabled then
        return false
    end

    for resource, phone in pairs(phones) do
        if phone.add and GetResourceState(resource) == 'started' then
            return true
        end
    end

    return false
end

local function CleanField(value, limit)
    if type(value) ~= 'string' then
        return ''
    end

    return value:sub(1, limit)
end

if isServer then
    RegisterNetEvent('kq_drugdeals:server:phoneNotification', function(data)
        if type(data) ~= 'table'
            or not Config.app.customApp.enabled
            or not Config.app.customApp.notifications then
            return
        end

        local src = source
        local payload = {
            title = CleanField(data.title, 100),
            content = CleanField(data.content, 300),
        }

        for resource, phone in pairs(phones) do
            if phone.notifyServer and GetResourceState(resource) == 'started' then
                pcall(phone.notifyServer, apps.plug, src, payload)
            end
        end
    end)
else
    function SendPhoneNotification(data)
        local relay = false

        for resource, phone in pairs(phones) do
            if GetResourceState(resource) == 'started' then
                if phone.notify then
                    pcall(phone.notify, apps.plug, data)
                end

                relay = relay or phone.notifyServer ~= nil
            end
        end

        if relay then
            TriggerServerEvent('kq_drugdeals:server:phoneNotification', data)
        end
    end
end

local function ShouldExecute(phone)
    if phone.server == 'shared' then
        return true
    end

    if isServer then
        return phone.server == true
    end

    return not phone.server
end

for resource, phone in pairs(phones) do
    if ShouldExecute(phone) and GetResourceState(resource) == 'started' then
        Citizen.SetTimeout(4000, function()
            for _, app in pairs(apps) do
                if app.enabled then
                    phone.add(app)
                end
            end
        end)
    end
end

AddEventHandler('onResourceStop', function(resource)
    for phoneResource, phone in pairs(phones) do
        if ShouldExecute(phone) and resource == phoneResource then
            for _, app in pairs(apps) do
                if app.enabled then
                    phone.remove(app)
                end
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
    for phoneResource, phone in pairs(phones) do
        if ShouldExecute(phone) and resource == phoneResource then
            Citizen.SetTimeout(4000, function()
                for _, app in pairs(apps) do
                    if app.enabled then
                        phone.add(app)
                    end
                end
            end)
        end
    end
end)
