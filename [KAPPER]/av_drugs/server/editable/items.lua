Config = Config or {}
CreateThread(function()
    while not exports['av_laptop']:isReady() do
        Wait(10)
    end
    dbug('Registering items...')
    if Config.Tables and next(Config.Tables) then
        for k, _ in pairs(Config.Tables) do
            exports['av_laptop']:registerItem(k)
        end
    end
    if Config.Packaging and next(Config.Packaging) then
        for k, _ in pairs(Config.Packaging) do
            exports['av_laptop']:registerItem(k)
        end
    end
    if Config.LabKeys and next(Config.LabKeys) then
        for k, _ in pairs(Config.LabKeys) do
            exports['av_laptop']:registerItem(k)
        end
    end
    if Config.DrugItems and next(Config.DrugItems) then
        for k, _ in pairs(Config.DrugItems) do
            exports['av_laptop']:registerItem(k)
        end
    end
    dbug('All items ready to use.')
end)

AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
    if not playerId or not name then return end
    metadata = metadata or {}
    if Config.Tables and Config.Tables[name] then
        return useTable(playerId,name,metadata,slotId)
    end
    if Config.Packaging and Config.Packaging[name] then
        return useBatch(playerId,name,metadata,slotId)
    end
    if Config.LabKeys and Config.LabKeys[name] then
        return useLabKey(playerId,name,metadata,slotId)
    end
    if Config.DrugItems and Config.DrugItems[name] then
        return onDrugUse(playerId,name,metadata,slotId)
    end
end)

function useTable(source,itemName,metadata,slot)
    dbug('useTable(source, metadata, slot)', source, metadata and json.encode(metadata), slot)
    dbug("Table: "..itemName..", identifier?: ", metadata and metadata['identifier'] or 'N/A')
    if metadata and not metadata['identifier'] then
        dbug("Generate identifier for table...")
        metadata['identifier'] = lib.string.random('...............')
        exports['av_laptop']:setItemMetadata(source, itemName, slot, metadata)
        dbug("setItemMetadata complete...", source, itemName, slot, json.encode(metadata))
    end
    if metadata and metadata['identifier'] then
        local identifier = metadata['identifier']
        if allTables and not allTables[identifier] then
            dbug("placing table on client side...")
            local model = Config.Tables[itemName] and Config.Tables[itemName]['model'] or false
            if model then
                TriggerClientEvent('av_drugs:placeTable', source, itemName, identifier, model, slot)
            else
                print("^1[ERROR]^7 Table "..itemName.." doesn't have a prop name in Config.Tables, this is NOT a script problem!")
                print("^1[ERROR]^7 Table "..itemName.." doesn't have a prop name in Config.Tables, this is NOT a script problem!")
                print("^1[ERROR]^7 Table "..itemName.." doesn't have a prop name in Config.Tables, this is NOT a script problem!")
            end
        else
            dbug("table already placed...")
            TriggerClientEvent('av_laptop:notification',source,Lang['table_title'], Lang['already_placed'], 'error')
        end
    end
end

function useLabKey(source,itemName,metadata,slot)
    dbug('useLabKey')
    dbug("Item: "..itemName..", lab type?: ", metadata and metadata['labType'] or "N/A", "key owner? ", metadata and metadata['owner'] or 'N/A')
    if not metadata['labType'] or not metadata['owner'] then
        print("This key doesn't have any lab info, please don't use a /giveitem command to give this item.")
        return
    end
    local owner = exports['av_laptop']:getIdentifier(source)
    if not metadata['owner'] or metadata['owner'] ~= owner then
        TriggerClientEvent('av_laptop:notification',source, Lang['app_title'], Lang['not_key_owner'], 'error')
        return
    end
    local labInfo = Config.LabTypes and Config.LabTypes[metadata['labType']] or false
    if labInfo then
        TriggerClientEvent('av_drugs:setLabEntrance',source,itemName,metadata['labType'],slot)
    else
        print("^3[WARNING]^7 Lab type ^1"..metadata['labType'].."^7 doesn't match an index key in Config.LabTypes")
        print("^3[WARNING]^7 Lab type ^1"..metadata['labType'].."^7 doesn't match an index key in Config.LabTypes")
        print("^3[WARNING]^7 Lab type ^1"..metadata['labType'].."^7 doesn't match an index key in Config.LabTypes")
    end
end