Config.Airdrops = {
    enabled = true,

    -- Who calls them in. Staff always can: /gangadmin > Street events > Call in an air drop (no cost or cooldown).
    -- true also gives gangs an Air drop app on the tablet, for ranks with "Call in air drops", using the
    -- cost and cooldowns below.
    playersCanCall = false,

    -- Gang calls only (when playersCanCall = true)
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
    alertPolice = true,       -- police get an approximate "package dropped from a light aircraft" call when it lands
    despawn     = 20,         -- minutes before an unopened crate is gone

    -- The smuggler's plane and the crate (props from the base game)
    plane       = { model = 'cuban800', speed = 55.0, height = 180.0 },
    crate       = { model = 'prop_mil_crate_01', parachute = 'p_cargo_chute_s', fallSpeed = 7.0 },
    -- Breaking it open is meant to be a fight: it takes a while, and getting hurt, knocked down or moving away
    -- stops it, so another crew can have a go. Anyone nearby sees the time left above the crate.
    openTime    = 120,        -- seconds to break the crate open
    openRange   = 2.0,        -- metres the opener can move before it stops

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
