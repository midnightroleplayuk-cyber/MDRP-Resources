if Bridge.Framework ~= 'es_extended' then return end

local Core = exports['es_extended']:getSharedObject()
Framework.Core = Core
Framework.Resource = 'es_extended'
Framework.PlayerLoadedEvent = 'esx:playerLoaded'
Framework.JobUpdateEvent = 'esx:setJob'

function Framework.IsPlayerLoaded()
    local data = Core.GetPlayerData()
    return data and data.identifier ~= nil
end

function Framework.GetPlayerData()
    local data = Core.GetPlayerData()
    if not data or not data.job then return nil end
    local jobName, onDuty = Framework.NormalizeEsxDutyJob(data.job.name)
    return {
        citizenid = data.identifier,
        name = data.firstName and ((data.firstName or '') .. ' ' .. (data.lastName or '')) or GetPlayerName(PlayerId()),
        charinfo = { firstname = data.firstName, lastname = data.lastName },
        job = {
            name = jobName,
            rawName = data.job.name,
            label = data.job.label,
            grade = data.job.grade,
            gradeLabel = data.job.grade_label,
            onduty = onDuty,
            dept = nil
        },
        money = data.accounts
    }
end

function Framework.TriggerCallback(name, cb, ...)
    Core.TriggerServerCallback(name, cb, ...)
end

function Framework.SetVehicleProperties(vehicle, properties)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or type(properties) ~= 'table' then return false end
    local ok, result = pcall(Core.Game.SetVehicleProperties, vehicle, properties)
    return ok and result or false
end

function Framework.GetPlate(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

function Framework.GetClosestPlayer()
    return Core.Game.GetClosestPlayer()
end

function Framework.GetClosestVehicle(coords)
    return Core.Game.GetClosestVehicle(coords)
end

function Framework.ShowTextUI(message)
    AddTextEntry('amb_helptext', message)
    BeginTextCommandDisplayHelp('amb_helptext')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function Framework.HideTextUI()
    ClearAllHelpMessages()
end
