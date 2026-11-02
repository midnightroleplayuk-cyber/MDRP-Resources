-- Map with zone names for reference: https://s3-attachments.int-cdn.lcpdfrusercontent.com/monthly_2019_06/5cw11krz9kcz.jpg.7f8a67aa01fa3ae14abf2e5d8bbc5ecd.jpg
-- Zones ID: https://docs.fivem.net/natives/?_0x98CD1D2934B76CC1
--[[
    How corner selling works?:
    1) You need one of the Config.Sells items in your inventory
    2) Drive to one of the whitelisted zones (every drug have a list of whitelisted zones or "ALL" to sell anywhere)
    3) Use the target system on your vehicle trunk
    4) If you have the drug item you will be able to see the "Sell X drug"
    5) Vehicle trunk will open and the sell loop will start
    6) Every X seconds the script will pick a random NPC from the street to buy you drugs
    7) Use the target system with that NPC and select the Offer option
    8) NPC can reject your offer or accept it and call cops
    9) For dispatch events/exports is on you to add it, my script doesn't sends any alert to cops (check client/editable/dispatch.lua)
    10) Player receives money and we go back to step 6

    If you are NOT using qb-target or ox_target you can find the target functions in client/editable/target.lua
]]

local isSelling = {} -- used to prevent any lua menu usage
Config = Config or {}

Config.Sells = {
    ['fentanyl_baggy'] = { -- item name, drug used for sell
        drug = "fentanyl", -- drug linked to this item
        label = "Fentanyl", -- used for Target
        icon = "fa-solid fa-flask", -- Used for target
        minCops = 0, -- Min cops online to sell this specific drug
        zones = { -- Zones where player can sell this type of drug, use 'ALL' to allow to sell anywhere
            ['ALL'] = true,
        },
        basePrice = 25, -- base price per bag, price get higher based on drug purity
        maxPrice = 100, -- max price per bag, even when price get higher based on purity it won't be higher than this
        maxBags = 5, -- max bags the NPC will buy from player
    },
    ['ketamine_baggy'] = { -- item name, drug used for sell
        drug = "ketamine", -- drug linked to this item
        label = "Ketamine", -- used for Target
        icon = "fa-solid fa-flask", -- Used for target
        minCops = 0, -- Min cops online to sell this specific drug
        zones = { -- Zones where player can sell this type of drug, use 'ALL' to allow to sell anywhere
            ['ALL'] = true,
        },
        basePrice = 25, -- base price per bag, price get higher based on drug purity
        maxPrice = 100, -- max price per bag, even when price get higher based on purity it won't be higher than this
        maxBags = 5, -- max bags the NPC will buy from player
    },
    ['heroin_baggy'] = { -- item name, drug used for sell
        drug = "heroin", -- drug linked to this item
        label = "Heroin", -- used for Target
        icon = "fa-solid fa-flask", -- Used for target
        minCops = 0, -- Min cops online to sell this specific drug
        zones = { -- Zones where player can sell this type of drug, use 'ALL' to allow to sell anywhere
            ['ALL'] = true,
        },
        basePrice = 25, -- base price per bag, price get higher based on drug purity
        maxPrice = 100, -- max price per bag, even when price get higher based on purity it won't be higher than this
        maxBags = 5, -- max bags the NPC will buy from player
    },
    ['coke_baggy'] = { -- item name, drug used for sell
        drug = "coke", -- drug linked to this item
        label = "Coke", -- used for Target
        icon = "fa-solid fa-flask", -- Used for target
        minCops = 0, -- Min cops online to sell this specific drug
        zones = { -- Zones where player can sell this type of drug, use 'ALL' to allow to sell anywhere
            ['ROCKF'] = true,
            ['WVINE'] = true,
            ['DTVINE'] = true,
            ['HAWICK'] = true,
            ['MIRR'] = true,
            ['RICHM'] = true,
            ['GOLF'] = true,
        },
        basePrice = 50, -- base price per bag, price get higher based on drug purity
        maxPrice = 300, -- max price per bag, even when price get higher based on purity it won't be higher than this
        maxBags = 5, -- max bags the NPC will buy from player
    },
    ['meth_baggy'] = { -- item name, drug used for sell
        drug = "meth", -- drug linked to this item
        label = "Meth", -- used for Target
        icon = "fa-solid fa-flask", -- Used for target
        minCops = 0, -- Min cops online to sell this specific drug
        zones = { -- Zones where player can sell this type of drug, use 'ALL' to allow to sell anywhere
            ['ROCKF'] = true,
            ['WVINE'] = true,
            ['DTVINE'] = true,
            ['HAWICK'] = true,
            ['MIRR'] = true,
            ['RICHM'] = true,
            ['GOLF'] = true,
        },
        basePrice = 40, -- base price per bag, price get higher based on drug purity
        maxPrice = 250, -- max price per bag, even when price get higher based on purity it won't be higher than this
        maxBags = 5, -- max bags the NPC will buy from player
    },
    ['lsd_baggy'] = { -- item name, drug used for sell
        drug = "lsd", -- drug linked to this item
        label = "LSD", -- used for Target
        icon = "fa-solid fa-flask", -- Used for target
        minCops = 0, -- Min cops online to sell this specific drug
        zones = { -- Zones where player can sell this type of drug, use 'ALL' to allow to sell anywhere
            ['ROCKF'] = true,
            ['WVINE'] = true,
            ['DTVINE'] = true,
            ['HAWICK'] = true,
            ['MIRR'] = true,
            ['RICHM'] = true,
            ['GOLF'] = true,
        },
        basePrice = 35, -- base price per bag, price get higher based on drug purity
        maxPrice = 230, -- max price per bag, even when price get higher based on purity it won't be higher than this
        maxBags = 5, -- max bags the NPC will buy from player
    },
}

lib.callback.register('av_drugs:sell', function(source, drug, zone)
    dbug('av_drugs:sell (netId, drug, zone)', drug, zone)
    local src = source
    local inventory = exports['av_laptop']:getInventoryItems(src)
    local drugInfo = Config.Sells and Config.Sells[drug] or false
    if not drugInfo then
        print("Why is drugInfo false?, report it pls...")
        return false
    end
    if inventory and next(inventory) then
        dbug("search drug in inventory...")
        local count, metadata, slot = 0, nil, nil
        for k, v in pairs(inventory) do
            if v['name'] == drug then
                count = v['count'] or v['amount']
                slot = v['slot']
                metadata = v['metadata'] or v['info']
                break
            end
        end
        dbug("(count, metadata, slot)", count, json.encode(metadata), slot)
        if count and count > 0 then
            dbug("player have enough drugs to sell...")
            local maxBags = drugInfo['maxBags'] or 1
            local amountToSell = math.random(1, maxBags)
            if amountToSell > count then
                amountToSell = math.random(1,count)
            end
            local toPay, purity, strain = processDrugInfo(drugInfo['basePrice'], drugInfo['maxPrice'], amountToSell, metadata)
            if not purity then
                purity = 0
            end
            dbug("Sold x"..amountToSell.." bags of "..drug.." with "..purity.."% of purity for $"..toPay)
            exports['av_laptop']:removeItem(src, drug, amountToSell, slot, metadata) -- UNCOMMENT AFTER DEBUG
            exports['av_laptop']:addMoney(src, Config.DrugMoney, toPay)
            addProgress(src, drugInfo['drug'], zone, strain, amountToSell, toPay)
            -- local gang = exports['av_gangs']:getGang(src)
            -- if gang then
            --     local toAdd = 10
            --     exports['av_gangs']:addXP(gang.name,toAdd)
            -- end
        end
    else
        dbug("Player inventory is empty (?)")
    end
    return true
end)

function processDrugInfo(basePrice, maxPrice, amount, metadata)
    dbug('processDrugInfo')
    local price = basePrice or 1
    local purity = metadata and metadata[Config.PurityField] or "1%"
    local strain = metadata and metadata['strain'] or false
    local amount = amount or 1
    if purity then
        purity = removeSymbol(purity)
        purity = tonumber(purity)
        if purity and purity >= 0 and purity <= 100 then
            price = basePrice + (maxPrice - basePrice) * (purity / 100)
        end
    end
    if price > maxPrice then
        price = maxPrice
    elseif price < basePrice then
        price = basePrice
    end
    price = math.floor(price)
    return amount * price, purity, strain
end