Config = Config or {}
-- Use Plebmasters to preview the crate models https://forge.plebmasters.de/objects/
-- available types : "item" or "money"
-- if using type money set the account name in the name field (e.g "black_money")
-- Make sure to edit all rewards and make them compatible with your server framework and/or economy :))

Config.Rewards = {
    [`ex_prop_crate_biohazard_bc`] = { -- chemichals
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_bull_bc_02`] = { -- silver ingots
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_elec_bc`] = { -- electronic devices
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_expl_bc`] = { -- explosives
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_gems_bc`] = { -- gems
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_jewels_bc`] = { -- jewelry
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_med_bc`] = { -- medic supplies
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_narc_bc`] = { -- drugs
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_tob_bc`] = { -- expensive bottles of wine
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_ammo_bc`] = { -- ammo
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_art_02_bc`] = { -- art
        {type = "item", name = "water", amount = {min = 1, max = 3}, metadata = {}},
        {type = "item", name = "bread", amount = {min = 1, max = 3}, metadata = {}},
    },
    [`ex_prop_crate_money_bc`] = { -- cash
        {type = "money", name = "black_money", amount = {min = 5000, max = 15000}, metadata = {}}, -- EXAMPLE OF black_money for ESX
        {type = "item", name = "markedbill", amount = {min = 3, max = 5}, metadata = {worth = math.random(1000,3000)}}, -- EXAMPLE of markedbill for qb
    },
}

-- Triggered after opening a crate
function addReward(playerId,model,identifier)
    dbug('addReward(playerId,model)',playerId,model)
    if not playerId or not model then return end
    local list = Config.Rewards[model]
    if list then
        local lucky = math.random(1,#list)
        local reward = list[lucky]
        local amount = reward['amount'] and tonumber(reward['amount']) or 1
        if reward['amount'] and type(reward['amount']) == "table" then
            amount = math.random(reward['amount']['min'], reward['amount']['max'])
        end
        dbug('Reward (type,name,amount)', reward['type'], reward['name'], amount)
        local msg = amount.."x "..reward['name']
        sendLog(playerId, 'crate', {
            name = GetPlayerName(playerId),
            identifier = getIdentifier(playerId),
            crateIdentifier = identifier,
            rewards = msg
        })
        if reward['type'] and reward['type'] == "item" then
            return addItem(playerId, reward['name'], amount, reward['name']['metadata'])
        end
        if reward['type'] and reward['type'] == "money" then
            return addMoney(playerId, reward['name'], amount)
        end
    else
        warn("Box model "..model.." doesn't exist in config/rewards.lua")
    end
end