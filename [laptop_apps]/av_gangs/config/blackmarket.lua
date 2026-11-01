Config = Config or {}
Config.MoneyAccount = 'bank' -- account used to buy labs and upgrades, if u want to use another payment method edit server/editable/money.lua
Config.MaxProperties = {
    ['offices'] = 2, -- Max offices a gang can own
    ['warehouse'] = 3, -- Max warehouse a gang can own
    ['labs'] = 1, -- Max labs a gang can own
}
Config.SellPercentage = 50 -- Percentage of the original price the gang will receive on property sell

-- List of all available products in blackmarket tab, this shop can't be used for items is only for interiors...
Config.Categories = {
    -- label:string is the text in the dropdown menu
    -- level:string min level required to access that category
    -- haveAccess:function return true to show the category or false to hide it from player
    ['labs'] = {
        label = "Labs",
        level = 0,
        haveAccess = function()
            -- add your own check here and return true or false
            -- EXAMPLE:
            --[[
            local myGang = exports['av_gangs']:getGang() -- retrieve player gang
            if myGang and myGang['name'] == "ballas" then -- if player is part of ballas gang return true to show the category or false to hide it
                return true
            else
                return false
            end
            ]]
            return true
        end
    },
    ['offices'] = {
        label = "Offices",
        level = 0,
        haveAccess = function()
            return true
        end
    },
    ['warehouse'] = {
        label = "Warehouse",
        level = 0,
        haveAccess = function()
            return true
        end
    },
}