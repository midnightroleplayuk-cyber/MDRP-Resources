Config = Config or {}

Config.Settings = {
    debug = false,
    command = "flagthatshit",
    craftDuration = 4, -- seconds to play crafting animation
    craftAnim = {
        dict = "mp_arresting",
        anim = "a_uncuff",
    },
    enableCrafting = true, -- Show the crafting recipe panel in the weapon bench
    craftingRecipe = {
        ingredients = { "popetrolbottle", "pobeerbottle" },
        -- Bandana is always required (any from Config.Bandanas)
        -- Result determined by matching bandana to Molotov BANDANA variants via Config.WeaponBandanaMap
        resultOriginal = "WEAPON_MOLOTOV", -- ORIGINAL weapon name to find the weapon group
    },
}