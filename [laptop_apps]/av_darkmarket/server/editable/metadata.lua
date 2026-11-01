local metadataItems = {
    -- this is just an EXAMPLE
    ['weed1g'] = function(playerId,amount)
        local metadata = {}
        local purity = math.random(10,50)
        local strain = lib.string.random(".....")
        metadata['purity'] = purity
        metadata['strain'] = strain
        return metadata
    end,
    ['laptop'] = function(playerId,amount)
        local metadata = {
            durability = 99
        }
        return metadata
    end,
}

--[[
    playerId:number Player server id
    item:string Item name
    amount:number Amount of items to generate
]]
function setItemMetadata(playerId,item,amount)
    if metadataItems[item] then
        return metadataItems[item](playerId,amount)
    end
    return nil
end