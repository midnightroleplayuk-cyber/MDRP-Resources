Config = Config or {}
Config.DefaultCooldown = 60 -- in minutes, cooldown after cooking ends
Config.Stashes = { -- Stashes values for labs ingredients and products
    ingredients = {
        weight = 5000,
        slots = 5
    },
    products = {
        weight = 10000,
        slots = 10
    }
}
-- This is a list of metadata fields the lab will search in every ingredient and save it for process, you can access this data in customProcess(...., metadata)
-- EXAMPLE: for laundromat we need the metadata field "worth" from markedbills to add the required cash to the product stash
Config.MetadataFields = {
    "worth", "purity",
}

-- List of ingredients that can be used for labs
-- This list is used in admin panel > market tab
-- value:string Your item name
-- label:string Item label
Ingredients = {
    {value = "drug_package", label = "Drug Package"}, -- This is just an EXAMPLE using a drug item av_runs
    {value = "markedbills", label = "Marked Bills"}, -- for laundromat
}

-- List of possible outputs for labs, we don't want an infinite list with all your sv items bc that's too annoying
-- This list is used in admin panel > market tab
-- value:string the item name, same as your framework/inventory item list
-- label:string Item label so u can identify it easily from the list
OutputItems = {
    {value = "heroin_batch", label = "Heroin Batch"}, -- This is just an EXAMPLE using a drug item from av_drugs
    {value = "cash", label = "Cash"}, -- or value money if using ESX
}

--[[ 
    Use this function to process your lab by running your own code
    Don't use this function if you aren't experienced enough because no support will be provided... 
        is your responsability to make it work the way you want, otherwise use the default method from the script
    identifier: string = Lab identifier
    lab: table = Lab info
    productInfo:table = Product info (ingredients, etc)
    itemsMetadata:table = Contains the values for Config.MetadataFields
    
    Important: 
    - Is on you to add the final product to productStash use exports['av_laptop']:addToStash(productStash, itemName, amount, metadata)
    - processed should return true if the lab was processed by your code, otherwise return false and the default script process will run
]]--
function customProcess(identifier, lab, productInfo, gang, productStash, itemsMetadata)
    local processed = false
    local type = productInfo and productInfo['type'] or false

    -- This is just an EXAMPLE where we take the "worth" field from the metadata in the "markedbills" items, and we use that value to convert it into cash
    if type and type == "laundromat" then
        dbug("Running custom process for laundromat...")
        local toAdd = itemsMetadata and itemsMetadata['worth'] or 0
        dbug('Adding '..toAdd..' cash to output stash')
        if toAdd > 0 then
            exports['av_laptop']:addToStash(productStash, "cash", toAdd)
            processed = true
        end
    end
    return processed
end

--[[
    Use this function to retrieve lab purity using your own code or leave it as it is
    identifier: string = Lab identifier
    lab: table = Lab info
    productInfo:table = Product info (ingredients, etc)
]]
function getPurity(identifier, lab, productInfo, gang, itemsMetadata)
    local purity = nil
    local type = productInfo and productInfo['type'] or false
    -- This is an Example where we try to retrieve the field "purity" from the items metadata in the ingredients stash
    if type and type == "drugs" then
        -- local temp_purity = itemsMetadata and itemsMetadata['purity']
        -- if temp_purity and tonumber(temp_purity) > 100 then
        --     temp_purity = 100
        -- end
        -- purity = temp_purity
    end
    return purity
end