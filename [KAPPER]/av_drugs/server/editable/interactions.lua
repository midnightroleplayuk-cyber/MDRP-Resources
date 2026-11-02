RegisterServerEvent('av_drugs:finishInteraction', function(data)
    dbug('av_drugs:finishInteraction')
    local src = source
    local ingredients = data and data['ingredients'] or false
    local output = data and data['output'] or false
    local canCook = true
    if not output or not ingredients then
        dbug("missing output or ingredients(?)", output, ingredients)
        return
    end
    if ingredients and next(ingredients) then
        for k, v in pairs(ingredients) do
            canCook = exports['av_laptop']:hasItem(src, v['name'], v['amount'])
            if not canCook then break end
        end
    end
    if not canCook then
        TriggerClientEvent('av_laptop:notification', src, Lang['app_title'], Lang['missing_ingredients'], "error")
        return
    end
    local inventory = exports['av_laptop']:getInventoryItems(src)
    local strain = false
    local purity = false
    if inventory and next(inventory) then
        for k, v in pairs(inventory) do
            for _, item in pairs(ingredients) do
                if v['name'] == item['name'] then
                    strain = v['metadata'] and v['metadata']['strain'] or false
                    purity = v['metadata'] and v['metadata'][Config.PurityField] or false
                    if strain or purity then break end
                end
            end
        end
    end
    dbug('strain-purity', strain, purity)
    if ingredients and next(ingredients) then
        for k, v in pairs(ingredients) do
            exports['av_laptop']:removeItem(src, v['name'], v['amount'])
        end
    end
    if output and next(output) then
        local metadata = {}
        if strain then
            metadata['strain'] = strain
        end
        if purity then
            metadata[Config.PurityField] = purity
        end
        for k, v in pairs(output) do
            exports['av_laptop']:addItem(src, v['name'], v['amount'], metadata)
        end
    end
end)