RegisterNetEvent("av_business:craft", function(data)
    local myJob = data['job'] or data['group'] or data['groups'] 
    if not myJob then
        local temp_job = exports['av_laptop']:getJob()
        myJob = temp_job and temp_job.name or ""
    end
    local customDescription = Config.CustomDescriptionJobs and Config.CustomDescriptionJobs[myJob] or false
    local ingredients = nil
    local ingredientsList = data['ingredientsList'] or lib.callback.await('av_business:getSettings', false, "ingredients")
    if data['ingredients'] and data['ingredients'][1] then
        ingredients = {}
        for _, v in pairs(data['ingredients']) do
            ingredients[#ingredients+1] = {
                value = v,
                label = getItemLabel(v, ingredientsList)
            }
        end
    end
    local itemType = data and (data['zoneType'] or data['type']) or nil
    local max = Config.MaxItemsPerCraft and Config.MaxItemsPerCraft[itemType] or nil
    local options = {}
    options[#options+1] = {
        type = 'number',
        label = Lang['craft_amount'] or "Amount",
        max = max,
        min = 1
    }
    if ingredients then
        options[#options+1] = {
           type = "multi-select",
           label = Lang['ingredients'] or "Ingredients",
           options = ingredients or {},
           searchable = true,
           required = Config.NeedsAllItems or nil
        }
    end
    if customDescription then
        options[#options+1] = {
            type = "input",
            label = Lang['metadata_description'] or "Description to print on product",
            default = data['description'] or "",
            max = 100,
        }
    end
    local input = exports['av_laptop']:inputDialog(data['label'] or "Crafting Options", options)
    if input then
        local indexCounter = 1
        local amountInput = input[indexCounter] 
        indexCounter = indexCounter + 1
        local ingredientsInput = nil
        if ingredients then
            ingredientsInput = input[indexCounter]
            indexCounter = indexCounter + 1
        end
        local descriptionInput = nil
        if customDescription then
            descriptionInput = input[indexCounter]
            indexCounter = indexCounter + 1
        end
        if amountInput and amountInput > 0 then
            if ingredientsInput and Config.NeedsAllItems then
                if #ingredients ~= #ingredientsInput then
                    TriggerEvent('av_laptop:notification', Lang['app_title'], Lang['missing_ingredients'], 'error')
                    return
                end
            end
            local canCook = lib.callback.await('av_business:hasItems', false, amountInput, ingredientsInput, data['item'])
            if canCook then
                startCrafting(data, amountInput, ingredientsInput, descriptionInput)
            else
                TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['missing_ingredients'], "error")
            end
        end
    end
end)

function startCrafting(data, amount, ingredients, description)
    local animType = data and (data['animType'] or data['zoneType']) or false
    dbug("startCrafting(animType?)", animType)
    local settings = animType and Config.Crafting[animType] or {}
    local prop = formatPropsToFloat(settings['prop'])
    if prop and not next(prop) then
        prop = nil
    end
    if exports['av_laptop']:progressBar({
        duration = settings['duration'] or Config.CraftingTime,
        label = settings['label'] or Config.CraftingLabel,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
        },
        anim = {
            dict = settings['dict'] or Config.CraftingDict,
            clip = settings['clip'] or Config.CraftAnimation
        },
        prop = prop,
    }) then
        TriggerServerEvent("av_business:addItem", data, amount, ingredients, description)
    end
end