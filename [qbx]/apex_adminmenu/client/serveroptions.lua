-- Function to split time into hours and minutes
local function splitTime(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format('%02.f', math.floor(seconds / 3600))
        local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

        return hours, mins
    end
end

-- Function to handle ban list item selection
local banListHandle = function(name, license, author, reason, length)
    local hours, mins = splitTime(length)
    
    local options = {
        {
            icon = 'fas fa-user',
            label = Strings.ban_list_name:format(name),
            close = false
        },
        {
            icon = 'fas fa-id-card',
            label = Strings.ban_list_license..' '..string.sub(license, 0, -20)..'...',
            close = false
        },
        {
            icon = 'fas fa-user-shield',
            label = Strings.ban_list_by:format(author),
            close = false
        },
        {
            icon = 'fas fa-comment',
            label = Strings.ban_list_reason:format(reason),
            close = false
        },
        {
            icon = 'fas fa-clock',
            label = Strings.ban_list_length:format(hours, mins)
        },
        {
            icon = 'fas fa-ban',
            label = Strings.ban_list_unban
        }
    }
    
    SendNUIMessage({
        action = 'openSubMenu',
        title = Strings.ban_list_menu,
        items = options,
        parent = Strings.ban_list_menu
    })
    
    -- Register NUI callback for this menu
    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == Strings.ban_list_menu and data.index == 5 then
            ShowDialog(Strings.dialog_unban, (Strings.dialog_unban_content):format(name), function(confirmed)
                if confirmed then
                    local unban = lib.callback.await('apex_adminmenu:unban', 100, license)
                    if unban then
                        TriggerEvent('apex_adminmenu:notify', Strings.successfully_unbanned, (Strings.successfully_unbanned_desc):format(name), 'success', 'fa-check')
                    else
                        TriggerEvent('apex_adminmenu:notify', Strings.notify_error, (Strings.unsuccessful_unban):format(name), 'error', 'fa-xmark')
                    end
                end
            end)
        end
        cb('ok')
    end)
end

-- Function to show ban list
BanList = function()
    local data = lib.callback.await('apex_adminmenu:getBanList', 100)
    if not data or #data < 1 then
        TriggerEvent('apex_adminmenu:notify', Strings.ban_list_no_data, Strings.ban_list_no_data_desc, 'error')
    else
        local banList = {}
        for i = 1, #data do
            banList[#banList + 1] = {
                icon = 'fas fa-user-slash',
                label = data[i].name,
                license = data[i].license,
                author = data[i].author,
                reason = data[i].reason,
                time_left = data[i].time_left
            }
        end
        
        SendNUIMessage({
            action = 'openSubMenu',
            title = Strings.ban_list_menu,
            items = banList,
            parent = Strings.server_management
        })
        
        -- Register NUI callback for this menu
        RegisterNUICallback('menuSelected', function(data, cb)
            if data.menu == Strings.ban_list_menu then
                for i = 1, #banList do
                    if data.index == i - 1 then
                        banListHandle(banList[i].label, banList[i].license, banList[i].author, banList[i].reason, banList[i].time_left)
                        break
                    end
                end
            end
            cb('ok')
        end)
    end
end

-- Function to delete all cars without drivers
delCars = function()
    local vehiclePool = GetGamePool('CVehicle')
    local count = 0
    for i = 1, #vehiclePool do
        if GetPedInVehicleSeat(vehiclePool[i], -1) == 0 then
            DeleteEntity(vehiclePool[i])
            count = count + 1
        end
    end
    TriggerEvent('apex_adminmenu:notify', Strings.notify_deleted_car, Strings.notify_deleted_car_desc .. " (" .. count .. " vehicles)", 'success','fa-check')
end

-- Function to delete all peds
delPeds = function()
    local pedsPool = GetGamePool('CPed')
    local count = 0
    for i = 1, #pedsPool do
        if DoesEntityExist(pedsPool[i]) and not IsPedAPlayer(pedsPool[i]) then
            DeleteEntity(pedsPool[i])
            count = count + 1
        end
    end
    TriggerEvent('apex_adminmenu:notify', Strings.notify_deleted_ped, Strings.notify_deleted_ped_desc .. " (" .. count .. " peds)", 'success','fa-check')
end

-- Function to delete all objects
delObjects = function()
    local objectsPool = GetGamePool('CObject')
    local count = 0
    for i=1, #objectsPool do
        if DoesEntityExist(objectsPool[i]) then
            DeleteEntity(objectsPool[i])
            count = count + 1
        end
    end
    TriggerEvent('apex_adminmenu:notify', Strings.notify_deleted_objects, Strings.notify_deleted_objects_desc .. " (" .. count .. " objects)", 'success','fa-check')
end

-- Function to handle entity deletion
local entityDelHandler = function()
    ShowInputDialog(Strings.dialog_objects, {
        { 
            type = 'select', 
            label = Strings.objects_list_label, 
            options = {
                { value = 'objects', label = Strings.dialog_clear_objects },
                { value = 'cars', label = Strings.dialog_clear_cars },
                { value = 'peds', label = Strings.dialog_clear_peds }
            }
        }
    }, 'entityDelete')
end

-- Function to send announcement
local Announcement = function()
    local jobOptions = {}
    jobOptions[#jobOptions + 1] = { label = Strings.dialog_announce_everyone, value = "" }
    
    for i = 1, #Config.Jobs do
        jobOptions[#jobOptions + 1] = {
            label = Config.Jobs[i].label,
            value = Config.Jobs[i].name
        }
    end
    
    ShowInputDialog(Strings.dialog_announce, {
        { type = 'input', label = Strings.dialog_announce_label, placeholder = Strings.dialog_announce_placeholder },
        { type = 'select', label = Strings.dialog_announce_select, options = jobOptions }
    }, 'announcement')
end

-- Function to change weather
local changeWeather = function(type)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(type)
    SetWeatherTypeNow(type)
    SetWeatherTypeNowPersist(type)
    if type == 'XMAS' then
        SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
    else
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
    end
end

-- Event to sync weather across clients
RegisterNetEvent('apex_adminmenu:weathersync', function(type)
    changeWeather(type)
end)

-- Main server options menu
ServerOptions = function()
    local options = {
        {
            icon = 'fas fa-bullhorn',
            label = Strings.server_announcement,
            description = Strings.server_announcement_desc
        },
        {
            icon = 'fas fa-ban',
            label = Strings.ban_list,
            description = Strings.ban_list_desc
        },
        {
            icon = 'fas fa-trash',
            label = Strings.objects_list,
            description = Strings.objects_list_desc
        },
        {
            icon = 'fas fa-cloud',
            label = Strings.weather_menu,
            description = Strings.weather_menu_desc,
            values = Config.Weathers,
            defaultIndex = 0,
            close = false
        },
        {
            icon = 'fas fa-crosshairs',
            label = 'Object Remover',
            description = 'Aim with a laser pointer and delete world objects'
        }
    }

    SendNUIMessage({
        action = 'openSubMenu',
        title = Strings.server_management,
        items = options,
        parent = 'main'
    })

    -- Register NUI callback for this menu
    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == Strings.server_management then
            if data.index == 0 then
                Announcement()
            elseif data.index == 1 then
                BanList()
            elseif data.index == 2 then
                entityDelHandler()
            elseif data.index == 4 then
                if StartObjectRemover then StartObjectRemover() end
            end
        end
        cb('ok')
    end)
end
