----------------------------------------
------------WORK IN PROGRESS------------
----------------------------------------

Config.CrimeTradersTraders = { 
    ['trader_1'] = {
        name = 'Marcus',
        image = './images/avatars/trader_1.webp',
        taskVideo = './images/avatars/trader_1_anim.mp4',
        order = 1,
        shopItems = {
            ['1'] = { -- level
                {
                    name = 'weapon_pistol',
                    price = 150,
                    amount = 1
                },
            },
            ['5'] = { -- level
                {
                    name = 'weapon_assaultrifle',
                    price = 300,
                    amount = 1
                },
            },
            ['10'] = { -- level
                {
                    name = 'weapon_carbinerifle',
                    price = 300,
                    amount = 1
                },
            },
            ['15'] = { -- level
                {
                    name = 'weapon_sniperrifle',
                    price = 300,
                    amount = 1
                },
            },
        }
    },
    ['trader_2'] = {
        name = 'Leona',
        image = './images/avatars/trader_2.webp',
        taskVideo = './images/avatars/trader_2_anim.mp4',
        order = 2,
        shopItems = {
            ['1'] = { -- level
                {
                    name = 'weapon_grenade',
                    price = 300,
                    amount = 1
                },
            },
            ['5'] = { -- level
                {
                    name = 'weapon_stickybomb',
                    price = 300,
                    amount = 1
                },
            },
            ['10'] = { -- level
                {
                    name = 'weapon_molotov',
                    price = 300,
                    amount = 1
                },
            },
        }
    },
    ['trader_3'] = {
        name = 'Victor',
        image = './images/avatars/trader_3.webp',
        taskVideo = './images/avatars/trader_3_anim.mp4',
        order = 3,
        shopItems = {
            ['1'] = { -- level
                {
                    name = 'money', -- to give money put money as name
                    price = 300,
                    amount = 5000
                },
            },
        }
    }
}

Config.XpRequirements = {
    [1] = 0,
    [2] = 100,
    [3] = 250,
    [4] = 500,
    [5] = 1000,
    [6] = 2000,
    [7] = 3500,
    [8] = 5500,
    [9] = 8000,
    [10] = 12000,
    [11] = 16000,
    [12] = 21000,
    [13] = 27000,
    [14] = 35000,
    [15] = 45000,
}

Config.CrimeActions = {}