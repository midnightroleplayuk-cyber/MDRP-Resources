Config = Config or {}

--[[
    This is an example of the fields that each item table should contain:
    fields with ? are optional
    {
        name:string = "drug_package", -- item name
        label:string = "Drug Ingredients", -- item label
        stock:number = 5, -- stock per server restart / stock refresh
        price:number = 1, -- price
        metadata?:table or null = Table with fixed metadata to add OR use the function in server/editable/metadata.lua
        account:string = "cosmo", -- account used for purchase 
        accountLabel:string = "Cosmo", -- account label for UI
        probability:number = 100, -- From 0 to 100%, prob from getting the item added to the shop in every refresh
        image?:string = "url.png" -- or false, image url just in case u don't want to use the one from your inventory path
        extension?:string = "webp"-- or false, the image file extension, just in case you have a mix between png and webp images in your inv, png is used by default
        canAccess?:function(playerId) -- runs a server side check and returns true to give access to item or false to hide it, if not present it will default to true
    },

     {
        name = "dummy_item",
        label = "Dummy Item",
        stock = 99, price = 9999999, account = "cosmo", accountLabel = "Cosmo", 
        probability = 100,
        canAccess = function(playerId)
            return true
        end,
    },

]]

-- Please avoid using Discord/imgur to host images, use Fivemerr or Fivemanage :)

Config.Categories = {
    ['hacker'] = { -- key index should be unique
        label = "Hacker", -- category label, how the player will see it in laptop
        canAccess = function(playerId) -- runs a server side check and returns true to give access to player or false to hide category and all items
            return true
        end,
        items = {
            {name = "dongle", label = "Dongle", stock = 5, price = 50, account = "gne", accountLabel = "GNE", probability = 50},
            {name = "hacking_device", label = "Hacking Device", stock = 5, price = 100, account = "cosmo", accountLabel = "Cosmo", probability = 50},
            {name = "laptop", label = "Laptop", stock = 99, price = 50, account = "cosmo", accountLabel = "Cosmo", probability = 100},
        }
    },
    ["drugs"] = { -- key index should be unique
        label = "Drugs", -- category label, how the player will see it in laptop
        canAccess = function(playerId) -- runs a server side check and returns true to give access to player or false to hide category and all items
            return true
        end,
        items = {
            {name = "water", label = "Water", stock = 5, price = 1, account = "cosmo", accountLabel = "Cosmo", probability = 50},
        }
    },
    ["weapons"] = { -- key index should be unique
        label = "Weapons", -- category label, how the player will see it in laptop
        canAccess = function(playerId) -- runs a server side check and returns true to give access to player or false to hide category and all items
            return true
        end,
        items = {
            {name = "weapon_pistol", label = "Pistol", stock = 5, price = 5000, account = "cosmo", accountLabel = "Cosmo", metadata = {ammo = 99}, probability = 100},
            {name = "weapon_assaultrifle", label = "Assault Rifle", stock = 5, price = 5000, account = "cosmo", accountLabel = "Cosmo", metadata = {ammo = 99}, probability = 50},
            {name = "weapon_heavypistol", label = "Assault Rifle", stock = 5, price = 5000, account = "cosmo", accountLabel = "Cosmo", metadata = {ammo = 99}, probability = 50},
        }
    },
}