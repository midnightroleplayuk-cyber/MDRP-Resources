
function GetLootForVehicle(entity, class)
    local netId = NetworkGetNetworkIdFromEntity(entity)
    local vehicleCoords = GetEntityCoords(entity)
    local model = GetEntityModel(entity)
    
    local availableLootTypes = {}
    
    -- Check if vehicle model belongs to a specific model group
    for _, group in ipairs(Config.loot.modelOverwrite) do
        for _, groupModel in ipairs(group.models) do
            if model == GetHashKey(groupModel) then
                for _, lootType in ipairs(group.types) do
                    availableLootTypes[lootType] = true
                end
                break
            end
        end
    end
    
    if table.length(availableLootTypes) == 0 then
        -- Check if vehicle is in a loot class
        if class and Config.loot.class[class] then
            for _, lootType in ipairs(Config.loot.class[class]) do
                availableLootTypes[lootType] = true
            end
        end
        
        -- Check if vehicle is in a loot area
        for _, data in pairs(Config.loot.areas) do
            local distance = #(vehicleCoords - data.coords)
            if distance <= data.radius then
                for _, lootType in ipairs(data.types) do
                    availableLootTypes[lootType] = true
                end
            end
        end
        
        -- Add global loot types
        for _, lootType in ipairs(Config.loot.global) do
            availableLootTypes[lootType] = true
        end
    end
    
    local lootPool = {}
    for lootType, _ in pairs(availableLootTypes) do
        table.insert(lootPool, lootType)
    end
    
    table.sort(lootPool)
    
    if #lootPool == 0 then return nil end
    
    local lootType = lootPool[(netId % #lootPool) + 1]
    return Config.lootTypes[lootType]
end
