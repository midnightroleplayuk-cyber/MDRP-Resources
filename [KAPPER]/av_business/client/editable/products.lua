RegisterNetEvent("av_business:products", function(data)
    local zoneType = data['zoneType']
    local animType = data['animType'] or false
    if not zoneType then warn("av_business:products received null instead of type") return end
    local job = data['zoneJob']
    if not job then warn("av_business:products received null instead of job") return end
    local products = lib.callback.await('av_business:getProducts', false, zoneType, job)
    local inventory = exports['av_laptop']:getInventoryPath()
    local ingredients = lib.callback.await('av_business:getSettings', false, "ingredients")
    local options = {}
    for _, v in pairs(products) do
        local ingredientsLabel = ""
        if v['ingredients'] and v['ingredients'][1] then
            for k, ingredient in pairs(v['ingredients']) do
                if tonumber(k) == 1 then
                    ingredientsLabel = getItemLabel(ingredient, ingredients)
                else
                    ingredientsLabel = ingredientsLabel.." | "..getItemLabel(ingredient, ingredients)
                end
            end
        end
        local description = v['description']
        if string.len(ingredientsLabel) > 1 then
            description = Lang['ingredients']..": "..ingredientsLabel
        end
        local imageExt = (Config.ItemImageFormats and Config.ItemImageFormats[1]) or "png" -- ox_lib menus can not fallback, so the preferred extension is used
        local image = (v['image'] and string.len(v['image']) > 1 and v['image']) or ("https://cfx-nui-"..inventory..v['name'].."."..imageExt) or false
        dbug("Item, image", v['name'], image)
        options[#options+1] = {
            title = v['label'],
            description = description,
            event = "av_business:craft",
            image = image,
            args = {
                item = v['name'],
                job = job,
                zoneType = zoneType,
                ingredients = v['ingredients'],
                ingredientsList = ingredients,
                label = v['label'],
                animType = animType,
                prop = v['prop'],
                description = v['description'],
                promoId = data['promoId'] or false
            }
        }
    end
    exports['av_laptop']:registerContext({
        id = 'products',
        title = data['label'] or "Products",
        options = options,
    })
    exports['av_laptop']:showContext('products')
end)

function getItemLabel(name,ingredients)
    if not name then return '' end
    local label = name
    ingredients = ingredients or lib.callback.await('av_business:getSettings', false, "ingredients")
    for i = 1, #ingredients do
        local ingredient = ingredients[i]
        if name == ingredient.value then
            label = ingredient.label
            break
        end
    end
    return label:gsub("^%l", string.upper)
end