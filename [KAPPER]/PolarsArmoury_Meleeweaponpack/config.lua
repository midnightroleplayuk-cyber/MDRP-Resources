Config = Config or {}

Config.Settings = {
    dict = "anim@heists@humane_labs@finale@keycards", -- animation name more can be found here ( https://forge.plebmasters.de/ )
    anim = "ped_a_enter_loop",
    effectName = "BikerFilter", -- screen effect name, more can be found here ( https://wiki.rage.mp/index.php?title=Screen_FX )
    maxEffectLength = 60, -- how long the screen effect will last for
    sprays = {
        ["WEAPON_PEPPERSPRAY"] = { -- item name
            effectPerHit = 5,  -- how much damage is done per trigger pull
            range = 15, -- distance 
        },
        ["WEAPON_ACIDSPRAY"] = {
            damage = 10,
            effectPerHit = 5,
            range = 15,
        },
        ["WEAPON_SPRAYPAINT"] = { -- item name
            effectPerHit = 5,  -- how much damage is done per trigger pull
            range = 15, -- distance 
        },
    }
}

-- Converting the sprays into hashes
local newSprays = {}
for weaponName in pairs(Config.Settings.sprays) do
    local hash = joaat(weaponName)

    newSprays[hash] = Config.Settings.sprays[weaponName]
end

Config.Settings.sprays = newSprays