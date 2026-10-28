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
        label = 'Midnight Health Service',
        type = 'ems',
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            -- Amulance Team
            [0] = {
                name = 'Apprentice EMT',
                payment = 420
            },
            [1] = {
                name = 'Student Nurse',
                payment = 420
            },
            [2] = {
                name = 'EMT',
                payment = 450
            },
            [3] = {
                name = 'Nurse',
                payment = 450
            },
            [4] = {
                name = 'Paramedic',
                payment = 500
            },
            [5] = {
                name = 'Advanced Paramedic',
                payment = 510
            },
            [6] = {
                name = 'Doctor',
                payment = 520
            },
            [7] = {
                name = 'HEMS - Crit Care Paramedic',
                isboss = false,
                bankAuth = false,
                payment = 530
            },
            [8] = {
                name = 'HART - Advanced Paramedic',
                isboss = false,
                bankAuth = false,
                payment = 530
            },
            [9] = {
                name = 'HEMS - Crit Care Doctor',
                isboss = false,
                bankAuth = false,
                payment = 540
            },
            [10] = {
                name = 'HART - Crit Care Doctor',
                isboss = false,
                bankAuth = false,
                payment = 540
            },
            [11] = {
                name = 'HART Team Lead',
                isboss = false,
                bankAuth = false,
                payment = 560
            },
            [12] = {
                name = 'HEMS Team Lead',
                isboss = false,
                bankAuth = false,
                payment = 560
            },
            [13] = {
                name = 'Ambulance Team Lead',
                isboss = false,
                bankAuth = false,
                payment = 560
            },
            [14] = {
                name = 'Training & Development',
                isboss = false,
                bankAuth = false,
                payment = 570
            },
            [15] = {
                name = 'Hospital Operations Manager',
                isboss = false,
                bankAuth = false,
                payment = 570
            },
            [16] = {
                name = 'Ambulance Operations Manager',
                isboss = false,
                bankAuth = false,
                payment = 570
            },
            [17] = {
                name = 'Human Resources',
                isboss = false,
                bankAuth = false,
                payment = 640
            },
            [18] = {
                name = 'Director of Operations',
                isboss = true,
                bankAuth = false,
                payment = 700
            },
            [19] = {
                name = 'Deputy Chief Medicial Officer',
                isboss = true,
                bankAuth = true,
                payment = 710
            },
            [20] = {
                name = 'Chief Medical Officer',
                isboss = true,
                bankAuth = true,
                payment = 720
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
    ['mannys'] = {
        label = 'Mannys',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'New Hire',
                payment = 50
            },
            [1] = {
                name = 'Staff Member',
                payment = 75
            },
            [2] = {
                name = 'Senior Staff',
                payment = 100
            },
            [3] = {
                name = 'Manager',
                payment = 125
            },
            [4] = {
                name = 'Mannys Owner',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['burgershot'] = {
        label = 'Burgershot',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'New Hire',
                payment = 50
            },
            [1] = {
                name = 'Staff Member',
                payment = 75
            },
            [2] = {
                name = 'Senior Staff',
                payment = 100
            },
            [3] = {
                name = 'Manager',
                payment = 125
            },
            [4] = {
                name = 'Burgershot Owner',
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
    ['fastfix'] = {
        label = 'FastFix Mechanic',
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
