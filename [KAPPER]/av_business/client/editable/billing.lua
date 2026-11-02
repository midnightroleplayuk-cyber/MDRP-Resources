-- Returns a table with the job items or services for the Products autocomplete field
function getBillingItems(business)
    dbug('getBillingItems(business)', business)
    local items = {}
    local resp = lib.callback.await('av_business:getItems', false, business)
    if resp and next(resp) then
        for _, product in pairs(resp) do
            items[#items+1] = {
                item = product['label'],
                price = product['price'] and tonumber(product['price']) or 1
            }
        end
    end
    if business == "police" then
        -- This is the code used for the Docs example...
        -- local fines = exports['ps-mdt']:getFines()
        -- if fines and next(fines) then
        --     for _, category in pairs(fines) do
        --         for _, option in pairs(category) do
        --             items[#items+1] = {
        --                 item = option['title'],
        --                 price = option['fine'] and tonumber(option['fine']) or 1 -- or whatever default price u want
        --             }
        --         end
        --     end
        -- end
    end
    -- Need to return a table with products {item: string, price: number}
    return items
end