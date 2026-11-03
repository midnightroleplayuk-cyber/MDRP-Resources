function canCook(source, identifier, itemName, playerIdentifier) -- player source, table identifier, table name (from _items.lua table)
    if not identifier or not itemName then return false end
    if isCooking[identifier] then -- this table is already cooking
        TriggerClientEvent('av_laptop:notification',source,Lang['table_title'], Lang['isCooking'], 'error')
        return false 
    end
    if allCooldowns[identifier] then -- this table is in cooldown
        TriggerClientEvent('av_laptop:notification',source,Lang['table_title'], Lang['inCooldown'], 'error')
        return false 
    end
    if allCooldowns[playerIdentifier] then -- player is in cooldown
        TriggerClientEvent('av_laptop:notification',source,Lang['table_title'], Lang['player_cooldown'] or "You are in a cooldown, try again later.", 'error')
        return false 
    end
    if not globalCooking then
        TriggerClientEvent('av_laptop:notification',source,Lang['table_title'], Lang['globalCooking'], 'error')
        return false
    end
    local stash = exports['av_laptop']:getStashItems(identifier)
    if not stash or not next(stash) then
        TriggerClientEvent('av_laptop:notification',source,Lang['table_title'], Lang['empty_stash'], 'error')
        return false
    end
    local neededItems = Config.Tables[itemName] and Config.Tables[itemName]['ingredients'] or {}
    local correctItems = checkIngredients(neededItems, stash)
    if correctItems then
        return true
    else
        TriggerClientEvent('av_laptop:notification',source,Lang['table_title'], Lang['incorrect_ingredients'], 'error')
        return false
    end
end

function processTable(identifier, info) -- triggered when cooking time is complete
    dbug('processTable()', identifier, json.encode(info))
    local drugInfo = info['drugInfo']
    local products = Config.Tables[info['item']] and Config.Tables[info['item']]['products']
    if products and next(products) then
        dbug('addProducts...')
        local playerXP = getPlayerXP(info['cooker'],drugInfo['name']) or 0
        local strain = getStrain(info['cooker'])
        local purity = calculatePurity(info['cooker'],info['item'],info['input'],playerXP)
        dbug('playerXP/Purity', playerXP, purity)
        if allTables and allTables[identifier] then
            allTables[identifier]['lastCook'] = os.time()
            allTables[identifier]['highestPurity'] = allTables[identifier]['highestPurity'] or 0
            if purity and purity > allTables[identifier]['highestPurity'] then
                dbug('overwrite highest purity in table')
                allTables[identifier]['highestPurity'] = purity
                save('tables')
            end
        end
        for k, v in pairs(products) do
            local count = math.random(v['min'],v['max'])
            local metadata = {
                strain = strain
            }
            metadata[Config.PurityField] = purity..Lang['percentage']
            dbug('addToStash (identifier, item, amount, metadata)', identifier, v['name'], count, json.encode(metadata))
            exports['av_laptop']:addToStash(identifier, v['name'], count, metadata, slot)
        end
    else
        print("^3[WARNING] No products found for table "..info['name'])
    end
    local minutes = Config.Tables[info['item']] and Config.Tables[info['item']]['cooldownTime'] or 60
    dbug('Add table to cooldown '..minutes..' minutes')
    addToCooldown(identifier,minutes)
end