RegisterNetEvent('av_business:consumable', function(metadata, itemName, effects) -- consumable items like drinks, joints, food
    local itemType = metadata['itemType']
    local ingredients = metadata['ingredients'] or {}
    local prop = metadata['prop']
    effects = effects or {}
    dbug("av_business:consumable (itemType, prop, ingredients?, effects?)", itemType, prop, json.encode(ingredients), effects and json.encode(effects) or "none")
    local completed = doAnimation(prop or itemType)
    if completed and itemType then
        useEffects(ingredients, itemType, itemName, effects)
    end
end)

RegisterNetEvent("av_business:box", function(metadata) -- boxes
    if not metadata or (not metadata.serial) then
        dbug("av_business:box received null instead of serial, make sure to craft the boxes using the business zones.")
        return
    end
    local name = metadata.serial
    local label = metadata.description or metadata.serial
    exports['av_laptop']:openStash(name, label, Config.Boxes['weight'], Config.Boxes['slots'])
end)