Dispatch = {}

local function getFrameworkName()
    if Config.Framework == 'auto' then
        if GetResourceState('es_extended') == 'started' then
            return 'esx'
        end

        if GetResourceState('qb-core') == 'started' then
            return 'qbcore'
        end
    end

    return Config.Framework
end

local function getPolicePlayers()
    local players = {}
    local jobs = {}

    for _, jobName in ipairs(Config.PoliceJobs or {}) do
        jobs[jobName] = true
    end

    local frameworkName = getFrameworkName()

    if frameworkName == 'esx' then
        for _, player in pairs(Framework.GetPlayers()) do
            if jobs[Framework.GetJobName(player)] then
                players[#players + 1] = player.source
            end
        end
    elseif frameworkName == 'qbcore' then
        for _, playerId in pairs(Framework.GetPlayers()) do
            local player = Framework.GetPlayer(playerId)
            if player and jobs[Framework.GetJobName(player)] and player.PlayerData.job.onduty then
                players[#players + 1] = playerId
            end
        end
    end

    return players
end

local function fallbackPoliceAlert()
    for _, playerId in ipairs(getPolicePlayers()) do
        TriggerClientEvent('un_atmhack:client:policeAlert', playerId)
    end
end

local function getDispatchConfig()
    return Config.Dispatch or {}
end

local function isResourceStarted(resourceName)
    return GetResourceState(resourceName) == 'started'
end

function Dispatch.SendPoliceAlert(source, atmCoords)
    if not Config.AlertPolice then
        return
    end

    local dispatchConfig = getDispatchConfig()
    local system = dispatchConfig.System or 'default'

    if system == 'none' then
        return
    end

    if system == 'default' then
        fallbackPoliceAlert()
        return
    end

    if system == 'ps-dispatch' then
        if not isResourceStarted('ps-dispatch') then
            fallbackPoliceAlert()
            return
        end

        exports['ps-dispatch']:CustomAlert({
            coords = vector3(atmCoords.x, atmCoords.y, atmCoords.z),
            message = dispatchConfig.Message or 'ATM-hakkerointi kaynnissa',
            dispatchCode = dispatchConfig.Code or '10-90',
            description = dispatchConfig.Title or 'ATM ryosto',
            radius = 0,
            sprite = 500,
            color = 1,
            scale = 1.0,
            length = dispatchConfig.BlipTime or 60,
            job = Config.PoliceJobs or { 'police' }
        })
        return
    end

    if system == 'cd_dispatch' then
        if not isResourceStarted('cd_dispatch') then
            fallbackPoliceAlert()
            return
        end

        TriggerClientEvent('cd_dispatch:AddNotification', -1, {
            job_table = Config.PoliceJobs or { 'police' },
            coords = vector3(atmCoords.x, atmCoords.y, atmCoords.z),
            title = dispatchConfig.Code or '10-90',
            message = dispatchConfig.Message or 'ATM-hakkerointi kaynnissa',
            flash = 0,
            unique_id = tostring(math.random(0000000, 9999999)),
            sound = 1,
            blip = {
                sprite = 500,
                scale = 1.0,
                colour = 1,
                flashes = false,
                text = dispatchConfig.Title or 'ATM ryosto',
                time = (dispatchConfig.BlipTime or 60) * 1000,
                radius = 0
            }
        })
        return
    end

    if system == 'qs-dispatch' then
        print('^3[un_atmhack]^0 qs-dispatch vaatii custom-integraation. Kayta Config.Dispatch.System = "custom" ja muokkaa Dispatch.CustomAlert-funktiota.')
        fallbackPoliceAlert()
        return
    end

    if system == 'core_dispatch' then
        if not isResourceStarted('core_dispatch') then
            fallbackPoliceAlert()
            return
        end

        exports['core_dispatch']:addCall(
            dispatchConfig.Code or '10-90',
            dispatchConfig.Title or 'ATM ryosto',
            {
                { icon = dispatchConfig.Icon or 'fas fa-building-columns', info = dispatchConfig.Message or 'ATM-hakkerointi kaynnissa' }
            },
            { atmCoords.x, atmCoords.y, atmCoords.z },
            Config.PoliceJobs or { 'police' },
            dispatchConfig.BlipTime or 60,
            500,
            1
        )
        return
    end

    if system == 'lb-tablet' then
        if not isResourceStarted('lb-tablet') then
            fallbackPoliceAlert()
            return
        end

        exports['lb-tablet']:AddDispatch({
            priority = dispatchConfig.Priority or 'medium',
            code = dispatchConfig.Code or '10-90',
            title = dispatchConfig.Title or 'ATM ryosto',
            description = dispatchConfig.Message or 'ATM-hakkerointi kaynnissa',
            location = {
                label = dispatchConfig.LocationLabel or dispatchConfig.Title or 'ATM-halytys',
                coords = {
                    x = atmCoords.x,
                    y = atmCoords.y
                }
            },
            time = dispatchConfig.BlipTime or 60,
            job = (Config.PoliceJobs and Config.PoliceJobs[1]) or 'police',
            sound = dispatchConfig.Sound == false and false or (dispatchConfig.Sound or 'notification.mp3'),
            fields = {
                {
                    icon = dispatchConfig.Icon or 'fas fa-building-columns',
                    label = 'Ilmoitus',
                    value = dispatchConfig.Message or 'ATM-hakkerointi kaynnissa'
                }
            },
            blip = {
                sprite = 500,
                color = 1,
                size = 1.0,
                shortRange = false,
                label = dispatchConfig.Title or 'ATM ryosto'
            }
        })
        return
    end

    if system == 'custom' and type(Dispatch.CustomAlert) == 'function' then
        Dispatch.CustomAlert(source, atmCoords, dispatchConfig)
        return
    end

    print(('^3[un_atmhack]^0 Unknown dispatch system "%s", using default police alert.'):format(system))
    fallbackPoliceAlert()
end

function Dispatch.CustomAlert(source, atmCoords, dispatchConfig)
    fallbackPoliceAlert()
end
