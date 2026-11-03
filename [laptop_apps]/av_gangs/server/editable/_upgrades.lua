Config = Config or {}
Config.CookingTime = 1 -- in minutes, time it takes for a lab to complete the cooking process

-- Prices per upgrade level
Config.UpgradesPrices = {
    ['stash'] = {
        value = 'stash',
        label = "Stash Size",
        prices = {
            [1] = {level = 1, price = 2000},
            [2] = {level = 2, price = 5000},
            [3] = {level = 3, price = 10000},
        },
    },
    ['production'] = {
        value = 'production',
        label = "Production",
        prices = {
            [1] = {level = 1, price = 2000},
            [2] = {level = 2, price = 5000},
            [3] = {level = 3, price = 10000},
        },
    },
    ['security'] = {
        value = 'security',
        label = "Security",
        prices = {
            [1] = {level = 1, price = 2000},
            [2] = {level = 2, price = 5000},
            [3] = {level = 3, price = 10000},
        }
    },
}

-- Available upgrades based on property type (labs, warehouse, office)
Config.Upgrades = {
    ['labs'] = {
        ['production'] = { 
            default = {
                cooldown = 120, -- in minutes, cooldown before the next cook
                purity = {min = 40, max = 50}, -- min and max purity the drug can have by default
                amount = {min = 1, max = 2}, -- output per cook cycle × ingredient sets in stash (e.g. 3 sets × random(1,2) = 3-6 items)
            },
            cooldown = { -- upgrades for cooldown (in minutes)
                [1] = 100,
                [2] = 80,
                [3] = 60,
            },
            purity = { -- upgrades for purity, needs a min and a max, will be random every time
                [1] = {min = 70, max = 80},
                [2] = {min = 80, max = 95},
                [3] = {min = 95, max = 100},
            },
            amount = { -- output per cook cycle × ingredient sets in stash (e.g. 3 sets × random(1,2) = 3-6 items)
                [1] = {min = 2, max = 3},
                [2] = {min = 3, max = 5},
                [3] = {min = 5, max = 8},
            },
        },
        ['stash'] = {
            default = {
                weight = 5000, -- default 5kg
                slots = 5, -- default 5 slots
            },
            slots = {
                [1] = 10,
                [2] = 20,
                [3] = 30,
            },
            weight = {
                [1] = 10000,
                [2] = 20000,
                [3] = 30000,
            },
        }
    },
    ['warehouse'] = {
        ['stash'] = {
            default = {
                weight = 5000, -- default 5kg
                slots = 5, -- default 5 slots
            },
            slots = {
                [1] = 10,
                [2] = 20,
                [3] = 30,
            },
            weight = {
                [1] = 10000,
                [2] = 20000,
                [3] = 30000,
            },
        }
    },
    ['offices'] = {
        ['stash'] = {
            default = {
                weight = 5000, -- default 5kg
                slots = 5, -- default 5 slots
            },
            slots = {
                [1] = 10,
                [2] = 20,
                [3] = 30,
            },
            weight = {
                [1] = 10000,
                [2] = 20000,
                [3] = 30000,
            },
        }
    },
}