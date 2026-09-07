RESTARTING = false
local deleteModels = {
    'kq_coca_plant_full',
    'kq_coca_plant_some',
    'kq_coca_plant_empty',
    'kq_wood_pit',
    'kq_pit_leaves',
    'kq_pit_leaves_c1',
    'kq_pit_leaves_c2',
    'kq_pit_leaves_c3',
    'kq_coca_barrel',
    'kq_cement_bag',
    'kq_coca_bowl',
    'kq_coca_paste',
    'kq_coca_paste_acid',
    'kq_coca_paste_mid',
    'kq_coca_paste_dry',
}


local function ContainsHash(tab, val)
    for index, value in ipairs(tab) do
        if GetHashKey(value) == val then
            return true
        end
    end
    
    return false
end

local function DebugDeleteAllProps()
    local entities = GetGamePool('CObject')
    for k, entity in pairs(entities) do
        if DoesEntityExist(entity) then
            if ContainsHash(deleteModels, GetEntityModel(entity)) then
                SetEntityAsMissionEntity(entity, true, true)
                DeleteEntity(entity)
            end
        end
    end
end
DebugDeleteAllProps()

--- SAFE RESTART FUNCTIONALITY
RegisterNetEvent(GetCurrentResourceName() .. ':client:safeRestart')
AddEventHandler(GetCurrentResourceName() .. ':client:safeRestart', function(caller)
    RESTARTING = true
    Citizen.Wait(1000)

    DebugDeleteAllProps()
    
    if caller == GetPlayerServerId(PlayerId()) then
        Citizen.Wait(2000)
        
        ExecuteCommand('ensure ' .. GetCurrentResourceName())
    end
end)
