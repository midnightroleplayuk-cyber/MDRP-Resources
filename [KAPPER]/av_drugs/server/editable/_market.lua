Config = Config or {}

lib.callback.register('av_drugs:getMarket', function(source) -- used to fetch available items when opens market tab
    local items = {}
    local identifier = exports['av_laptop']:getIdentifier(source)
    for k, v in pairs(Config.Market) do
        if v['canAccess'] and v['canAccess'](source,identifier) then
            v['name'] = k
            items[#items+1] = v
        end
    end
    return items
end)

Config.Market = {
    ['baggies'] = {-- item name
        label = "Baggies",
        price = 1,
        account = 'cosmo',
        accountLabel = "Cosmo",
        image = false, -- just in case u want to use a different image (URL) from the one in the inventory, if false it will use itemname.png from inventory images
        canAccess = function(source, identifier) -- this gets triggered server side (line 7)
            local isCop = exports['av_laptop']:hasJob(source, Config.PoliceJobs)
            if isCop then return false end
            return true
        end,
        setMetadata = function(source, identifier) -- adds metadata for item or return false
            return false
        end,
    },
    ['moonshine_still'] = {-- item name
        label = "Moonshine Still",
        price = 1000,
        account = 'cosmo',
        accountLabel = "Cosmo",
        image = false, -- just in case u want to use a different image (URL) from the one in the inventory, if false it will use itemname.png from inventory images
        canAccess = function(source, identifier) -- this gets triggered server side (line 7)
            -- Return true or false, add your own check here:
            return not exports['av_laptop']:hasJob(source, Config.PoliceJobs) -- if Player have any of this job names/types block the item
        end,
        setMetadata = function(source, identifier) -- adds metadata for item or return false
            return false
        end,
    },
    ['fentanyl_table'] = {-- item name
        label = "Fentanyl Table",
        price = 1000,
        account = 'cosmo',
        accountLabel = "Cosmo",
        image = false, -- just in case u want to use a different image (URL) from the one in the inventory, if false it will use itemname.png from inventory images
        canAccess = function(source, identifier) -- this gets triggered server side (line 7)
             -- Return true or false, add your own check here:
            return not exports['av_laptop']:hasJob(source, Config.PoliceJobs) -- if Player have any of this job names/types block the item
        end,
        setMetadata = function(source, identifier) -- adds metadata for item or return false
            return false
        end,
    },
    ['heroin_table'] = {-- item name
        label = "Heroin Table",
        price = 1000,
        account = 'cosmo',
        accountLabel = "Cosmo",
        image = false, -- just in case u want to use a different image (URL) from the one in the inventory, if false it will use itemname.png from inventory images
        canAccess = function(source, identifier) -- this gets triggered server side (line 7)
             -- Return true or false, add your own check here:
            return not exports['av_laptop']:hasJob(source, Config.PoliceJobs) -- if Player have any of this job names/types block the item
        end,
        setMetadata = function(source, identifier) -- adds metadata for item or return false
            return false
        end,
    },
    ['ketamine_table'] = {-- item name
        label = "Ketamine Table",
        price = 1000,
        account = 'cosmo',
        accountLabel = "Cosmo",
        image = false, -- just in case u want to use a different image (URL) from the one in the inventory, if false it will use itemname.png from inventory images
        canAccess = function(source, identifier) -- this gets triggered server side (line 7)
             -- Return true or false, add your own check here:
            return not exports['av_laptop']:hasJob(source, Config.PoliceJobs) -- if Player have any of this job names/types block the item
        end,
        setMetadata = function(source, identifier) -- adds metadata for item or return false
            return false
        end,
    },
    ['meth_key'] = {
        label = "Meth Lab Key",
        price = 100000,
        account = "cosmo",
        accountLabel = "Cosmo",
        image = false,
        max = 1, -- max items same player can buy at the same time and per server restart
        canAccess = function(source, identifier)
            local isCop = exports['av_laptop']:hasJob(source, Config.PoliceJobs)
            if isCop then return false end
            local ownsLabs = isLabOwner(identifier, false) -- instead of false we could specify the lab type (drug), false will consider any lab
            if ownsLabs then return false end -- Don't show lab key if player already owns one
            local level = getPlayerLevel(identifier,"fentanyl")
            return level >= 10 -- Only accessible for players with fentanyl level 10+ (1000xp)
        end,
        setMetadata = function(source, identifier)
            return {owner = identifier, labType = "methlab", description = "Sets the entrance for your Meth Lab"}
        end,
    },
    ['coke_key'] = {
        label = "Coke Lab Key",
        price = 100000,
        account = "cosmo",
        accountLabel = "Cosmo",
        image = false,
        max = 1, -- max items same player can buy at the same time and per server restart
        canAccess = function(source, identifier)
            local isCop = exports['av_laptop']:hasJob(source, Config.PoliceJobs)
            if isCop then return false end
            local ownsLabs = isLabOwner(identifier, false) -- instead of false we could specify the lab type (drug), false will consider any lab
            if ownsLabs then return false end -- Don't show lab key if player already owns one
            local level = getPlayerLevel(identifier,"heroin")
            return level >= 10 -- Only accessible for players with heroin level 10+ (1000xp)
        end,
        setMetadata = function(source, identifier)
            return {owner = identifier, labType = "cokelab", description = "Sets the entrance for your Coke Lab"}
        end,
    },
    ['lsd_key'] = {
        label = "LSD Lab Key",
        price = 100000,
        account = "cosmo",
        accountLabel = "Cosmo",
        image = false,
        max = 1, -- max items same player can buy at the same time and per server restart
        canAccess = function(source, identifier)
            local isCop = exports['av_laptop']:hasJob(source, Config.PoliceJobs)
            if isCop then return false end
            local ownsLabs = isLabOwner(identifier, false) -- instead of false we could specify the lab type (drug), false will consider any lab
            if ownsLabs then return false end -- Don't show lab key if player already owns one
            local level = getPlayerLevel(identifier,"ketamine")
            return level >= 10 -- Only accessible for players with ketamine level 10+ (1000xp)
        end,
        setMetadata = function(source, identifier)
            return {owner = identifier, labType = "lsdlab", description = "Sets the entrance for your LSD Lab"}
        end,
    },
}

-- Use this function to retrieve how many labs exists for the same type
-- local methLabs = getLabsByType("methlab")
function getLabsByType(type)
    dbug("getLabsByType(type)", type)
    if not type then return false end
    local count = 0
    if allLabs and next(allLabs) then
        for k, v in pairs(allLabs) do
            if v['type'] == type then
                count += 1
            end
        end
    end
    return count
end