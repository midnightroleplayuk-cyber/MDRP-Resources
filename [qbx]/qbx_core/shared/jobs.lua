---Job names must be lower case (top level table key)
---@type table<string, Job>
return {
    ['unemployed'] = {
        label = 'Civilian',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Freelancer',
                payment = 10
            },
        },
    },
    ['police'] = {
        label = 'Midnight Police Constabulary',
        type = 'leo',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Student Constable',
                payment = 370
            },
            [1] = {
                name = 'Police Constable',
                payment = 380
            },
            [2] = {
                name = 'Taser Officer',
                payment = 390
            },
            [3] = {
                name = 'Traffic',
                payment = 420
            },
            [4] = {
                name = 'CID',
                payment = 420
            },
            [5] = {
                name = 'Armed Response',
                payment = 420
            },
            [6] = {
                name = 'SGT',
                payment = 480
            },
            [7] = {
                name = 'Inspector',
                payment = 540
            },
            [8] = {
                name = 'Chief Inspector',
                payment = 600,
                isboss = true,
            },
            [9] = {
                name = 'Superintendent',
                payment = 690,
                isboss = true,
            },
            [10] = {
                name = 'Chief Superintendent',
                payment = 720,
                isboss = true,
            },
            [11] = {
                name = 'Assistant Chief Constable',
                payment = 780,
                isboss = true,
            },
            [12] = {
                name = 'Deputy Chief Constable',
                isboss = true,
                bankAuth = true,
                payment = 815
            },
            [13] = {
                name = 'Chief Constable',
                isboss = true,
                bankAuth = true,
                payment = 840
            },
        },
    },

    ['bcso'] = {
        label = 'BCSO',
        type = 'leo',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Officer',
                payment = 75
            },
            [2] = {
                name = 'Sergeant',
                payment = 100
            },
            [3] = {
                name = 'Lieutenant',
                payment = 125
            },
            [4] = {
                name = 'Chief',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['sasp'] = {
        label = 'SASP',
        type = 'leo',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Officer',
                payment = 75
            },
            [2] = {
                name = 'Sergeant',
                payment = 100
            },
            [3] = {
                name = 'Lieutenant',
                payment = 125
            },
            [4] = {
                name = 'Chief',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['ambulance'] = {
        label = 'EMS',
        type = 'ems',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Paramedic',
                payment = 75
            },
            [2] = {
                name = 'Doctor',
                payment = 100
            },
            [3] = {
                name = 'Surgeon',
                payment = 125
            },
            [4] = {
                name = 'Chief',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['fire'] = {
        label = 'Midnight Fire & Rescue',
        type = 'fire',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            -- Firefighter Team
            [0] = {
                name = 'Trainee Firefighter',
                payment = 300
            },
            [1] = {
                name = 'Firefighter',
                payment = 450
            },
            -- Bronze Command
            [2] = {
                name = 'Crew Manager',
                payment = 600
            },
            [3] = {
                name = 'Watch Manager',
                payment = 630
            },
            -- Silver Command
            [4] = {
                name = 'Station Manager',
                payment = 660
            },
            [5] = {
                name = 'Group Manager',
                payment = 690
            },
            -- Gold Command
            [7] = {
                name = 'Assistant Chief Fire Officer',
                isboss = true,
                bankAuth = true,
                payment = 700
            },
            [8] = {
                name = 'Deputy Chief Fire Officer',
                isboss = true,
                bankAuth = true,
                payment = 710
            },
            [9] = {
                name = 'Chief Fire Officer',
                isboss = true,
                bankAuth = true,
                payment = 720
            },
        },
    },
    ['realestate'] = {
        label = 'Real Estate',
        type = 'realestate',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'House Sales',
                payment = 75
            },
            [2] = {
                name = 'Business Sales',
                payment = 100
            },
            [3] = {
                name = 'Broker',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['taxi'] = {
        label = 'Taxi',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Driver',
                payment = 75
            },
            [2] = {
                name = 'Event Driver',
                payment = 100
            },
            [3] = {
                name = 'Sales',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['bus'] = {
        label = 'Bus',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Driver',
                payment = 50
            },
        },
    },
    ['cardealer'] = {
        label = 'Vehicle Dealer',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Showroom Sales',
                payment = 75
            },
            [2] = {
                name = 'Business Sales',
                payment = 100
            },
            [3] = {
                name = 'Finance',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['mechanic'] = {
        label = 'Mechanic',
        type = 'mechanic',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Novice',
                payment = 75
            },
            [2] = {
                name = 'Experienced',
                payment = 100
            },
            [3] = {
                name = 'Advanced',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['judge'] = {
        label = 'Honorary',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Judge',
                payment = 100
            },
        },
    },
    ['lawyer'] = {
        label = 'Law Firm',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Associate',
                payment = 50
            },
        },
    },
    ['reporter'] = {
        label = 'Reporter',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Journalist',
                payment = 50
            },
        },
    },
    ['trucker'] = {
        label = 'Trucker',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Driver',
                payment = 50
            },
        },
    },
    ['tow'] = {
        label = 'Towing',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Driver',
                payment = 50
            },
        },
    },
    ['garbage'] = {
        label = 'Garbage',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Collector',
                payment = 50
            },
        },
    },
    ['vineyard'] = {
        label = 'Vineyard',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Picker',
                payment = 50
            },
        },
    },
    ['hotdog'] = {
        label = 'Hotdog',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Sales',
                payment = 50
            },
        },
    },
}
