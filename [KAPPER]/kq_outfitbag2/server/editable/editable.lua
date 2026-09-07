-- Export used for ox_inventory
exports('UseBag', function(event, item, inventory)
    -- Player is attempting to use the item.
    if event == 'usingItem' then
        local player = inventory.id
        TriggerClientEvent('kq_outfitbag2:client:place', player, item.name, item.name)
        return true
    end
end)


RegisterServerEvent('kq_outfitbag2:server:log')
AddEventHandler('kq_outfitbag2:server:log', function(outfit, name)
    local data = '{\n'
    
    data = data .. '  name = "' .. name .. '",\n'
    data = data .. '  model = ' .. GetEntityModel(GetPlayerPed(source)) .. ',\n'
    data = data .. '  drawable = {\n'
    
    for k, drawable in pairs(outfit.drawable) do
        data = data .. '    ' .. k .. ' = { drawable = ' .. drawable.drawable ..  ', texture = ' .. drawable.texture .. ', palette = ' .. drawable.palette .. ' }, \n'
    end
    
    data = data .. '  },\n'
    data = data .. '  props = {\n'
    
    for k, drawable in pairs(outfit.props) do
        data = data .. '    ' .. k .. ' = { prop = ' .. drawable.prop ..  ', texture = ' .. drawable.texture .. ' }, \n'
    end
    
    data = data .. '  },\n},'
    
    SaveResourceFile(GetCurrentResourceName(), 'outfit-outputs/' .. name .. '.txt', data, -1)
end)

---

local sqlDriver = Config.sql.driver

function GetSavedPlayerOutfits(player)
    local identifier = _GetPlayerIdentifier(player)

    local query = 'SELECT * FROM kq_extra WHERE `tag` = @tag AND `player` = @player ORDER BY `id`'
    local data = {
        ['@tag'] = DB_TAG,
        ['@player'] = identifier,
    }

    return SqlQuery(query, data)
end

function SaveOutfit(player, outfit)
    local identifier = _GetPlayerIdentifier(player)

    local mutation = 'INSERT INTO kq_extra (`player`, `tag`, `data`) VALUES(@player, @tag, @data);'
    local data = {
        ['@player'] = identifier,
        ['@tag'] = DB_TAG,
        ['@data'] = json.encode(outfit),
    }
    
    SqlMutate(mutation, data)
end

function DeleteOutfit(player, outfitId)
    local identifier = _GetPlayerIdentifier(player)

    local mutation = 'DELETE FROM kq_extra WHERE `player` = @player AND `tag` = @tag AND `id` = @id;'
    local data = {
        ['@player'] = identifier,
        ['@tag'] = DB_TAG,
        ['@id'] = outfitId,
    }

    SqlMutate(mutation, data)
end

function SqlQuery(query, data)
    if sqlDriver == 'mysql' then
        return MySQL.Sync.fetchAll(query, data or {})
    end

    if sqlDriver == 'oxmysql' then
        if Config.sql.newOxMysql then
            return exports[sqlDriver]:fetchSync(query, data)
        end
        return exports[sqlDriver]:query_async(query, data)
    else
        return exports[sqlDriver]:executeSync(query, data)
    end
end

function SqlMutate(query, data)
    if sqlDriver == 'mysql' then
        MySQL.Sync.insert(query, data)
        return
    end

    if sqlDriver == 'oxmysql' then
        exports[sqlDriver]:insertSync(query, data)
    else
        exports[sqlDriver]:executeSync(query, data)
    end
end

if not Config.esxSettings.enabled and not Config.qbSettings.enabled then
    function _GetPlayerIdentifier(player)
        return GetPlayerIdentifierByType(player, 'license')
    end
end
