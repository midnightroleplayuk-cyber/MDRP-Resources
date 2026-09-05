-- ------------------------------------------------------------------------------
-- OP Clothing - Pricing
-- ------------------------------------------------------------------------------

Config.Pricing = {
    -- Default pay account (player can still pick cash/bank at checkout)
    -- ESX: 'cash' | 'bank'   QB/QBox: 'cash' | 'bank'
    Account = 'cash',
    Default = 25,

    Modules = {
        clothing = 25,
        barber   = 40,
        tattoo   = 150,
        surgeon  = 250,
    },

    Categories = {
        mask       = 30,
        torso      = 60,
        undershirt = 30,
        jacket     = 80,
        pants      = 60,
        shoes      = 50,
        bag        = 40,
        accessory  = 35,
        decals     = 20,
        armor      = 100,
        hat        = 40,
        glasses    = 35,
        ears       = 25,
        watch      = 75,
        bracelet   = 40,

        hair       = 45,
        beard      = 30,
        eyebrows   = 25,
        eyecolor   = 20,
    },

    SaveOutfit = 0, -- cost to save a personal outfit preset
}