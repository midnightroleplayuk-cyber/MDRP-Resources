RESTARTING = false

local function DebugDeleteAllObjects()
    local entities = GetGamePool('CObject')
    for k, entity in pairs(entities) do
        if DoesEntityExist(entity) then
            if GetEntityScript(entity) == GetCurrentResourceName() then
                SetEntityAsMissionEntity(entity, true, true)
                DeleteEntity(entity)
            end
        end
    end
end
DebugDeleteAllObjects()

--- SAFE RESTART FUNCTIONALITY
RegisterNetEvent(GetCurrentResourceName() .. ':client:safeRestart')
AddEventHandler(GetCurrentResourceName() .. ':client:safeRestart', function(caller)
    RESTARTING = true
    Citizen.Wait(600)

    DebugDeleteAllObjects()

    for k, obj in pairs(SyncObject.all()) do
        if obj.onDelete then
            pcall(obj.onDelete, obj)
        end
    end

    if caller == GetPlayerServerId(PlayerId()) then
        Citizen.Wait(1500)

        if not Config.debug then
            Citizen.Wait(1500)
        end

        ExecuteCommand('ensure ' .. GetCurrentResourceName())
    end
end)
