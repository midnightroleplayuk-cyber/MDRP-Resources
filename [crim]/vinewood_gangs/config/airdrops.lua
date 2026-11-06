Config.Airdrops = {
    enabled = true,

    -- Calling one in (tablet > Air drop). Rank permission: "Call in air drops".
    cost        = 25000,      -- taken from the gang treasury
    account     = 'dirty',    -- 'dirty' or 'clean'
    item        = false,      -- also needs an item, e.g. { item = 'flare', count = 1 }, or false
    cooldown    = 120,        -- minutes before the same gang can call another
    globalGap   = 20,         -- minutes between any two drops on the server
    maxActive   = 1,          -- drops in the air or on the ground at once
    delay       = { 3, 5 },   -- minutes before the plane arrives (random in this range)
    bounds      = { minX = -3800, maxX = 4300, minY = -3700, maxY = 7800 }, -- where drops can land

    -- What everyone sees
    showTo      = 'everyone', -- who gets the blip: 'everyone', 'gangs' (anyone in a gang) or 'caller' (just that gang)
    radius      = 120.0,      -- size of the search area on the map (the crate is somewhere inside it)
    alertPolice = true,       -- police get an approximate "cargo dropped from a military plane" call when it lands
    despawn     = 20,         -- minutes before an unopened crate is gone

    -- The plane and crate (props from the base game)
    plane       = { model = 'titan', speed = 70.0, height = 320.0 },
    crate       = { model = 'prop_mil_crate_01', parachute = 'p_cargo_chute_s', fallSpeed = 7.0 },
    openTime    = 12,         -- seconds to break the crate open

    -- Loot: each roll picks one entry by chance; rolls = how many picks per crate.
    --   item  = an inventory item (count min-max), or money = true (paid to the opener's gang dirty treasury,
    --           or as cash if they're not in a gang)
    rolls = 4,
    loot = {
        { money = true,                min = 5000, max = 15000, chance = 40 },
        { item = 'weapon_pistol',      min = 1,    max = 1,     chance = 15 },
        { item = 'pistol_ammo',        min = 2,    max = 5,     chance = 25 },
        { item = 'armour',             min = 1,    max = 2,     chance = 20 },
        { item = 'thermite',           min = 1,    max = 2,     chance = 15 },
        { item = 'goldbar',            min = 1,    max = 3,     chance = 10 },
        { item = 'weapon_carbinerifle', min = 1,   max = 1,     chance = 4 },
    },
}
