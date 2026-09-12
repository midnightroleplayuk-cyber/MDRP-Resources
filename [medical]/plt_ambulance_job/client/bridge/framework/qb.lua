if Bridge.Framework ~= 'qb-core' and Bridge.Framework ~= 'qb_core' then return end

local Core = exports['qb-core']:GetCoreObject()
Framework.Core = Core
Framework.Resource = 'qb-core'
Framework.PlayerLoadedEvent = 'QBCore:Client:OnPlayerLoaded'
Framework.JobUpdateEvent = 'QBCore:Client:OnJobUpdate'
Framework.PlayerDataEvents = { 'QBCore:Player:SetPlayerData', 'QBCore:Client:OnPlayerUpdated' }

function Framework.IsPlayerLoaded()
    local data = Core.Functions.GetPlayerData()
    return data and data.citizenid ~= nil
end

function Framework.GetPlayerData()
    local data = Core.Functions.GetPlayerData()
    if not data or not data.job then return nil end
    local charinfo = data.charinfo or {}
    local grade = data.job.grade or {}
    return {
        citizenid = data.citizenid,
        name = ((charinfo.firstname or '') .. ' ' .. (charinfo.lastname or '')):gsub('^%s*(.-)%s*$', '%1'),
        charinfo = charinfo,
        job = {
            name = data.job.name,
            label = data.job.label,
            grade = type(grade) == 'table' and grade.level or grade,
            gradeLabel = type(grade) == 'table' and grade.name or nil,
            onduty = data.job.onduty,
            dept = data.job.dept
        },
        money = data.money
    }
end

function Framework.TriggerCallback(name, cb, ...)
    local callback = cb
    if type(cb) == 'function' then
        callback = function(...)
            local ok, err = pcall(cb, ...)
            if not ok then
                print(("[plt_ambulance] Callback '%s' handler failed: %s"):format(tostring(name), tostring(err)))
            end
        end
    end
    Core.Functions.TriggerCallback(name, callback, ...)
end

function Framework.SetVehicleProperties(vehicle, properties)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or type(properties) ~= 'table' then return false end
    local ok, result = pcall(Core.Functions.SetVehicleProperties, vehicle, properties)
    if not ok then
        print(("[plt_ambulance] SetVehicleProperties failed: %s"):format(tostring(result)))
        return false
    end
    return result
end

function Framework.GetPlate(vehicle)
    return Core.Functions.GetPlate(vehicle)
end

function Framework.GetClosestPlayer()
    return Core.Functions.GetClosestPlayer()
end

function Framework.GetClosestVehicle(coords)
    return Core.Functions.GetClosestVehicle(coords)
end

function Framework.ShowTextUI(message)
    TriggerEvent('qb-core:client:DrawText', message, 'right')
end

function Framework.HideTextUI()
    TriggerEvent('qb-core:client:HideText')
end

function Framework.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    Core.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
end
