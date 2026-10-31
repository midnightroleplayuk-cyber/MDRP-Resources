Config = {}

Config.Language = 'en'

Config.Webhook = {
    Enabled = true,
    URL = 'https://discord.com/api/webhooks/1551961490523684934/Ljtp-t7UVZgZj_jSLF13SmSya6Q5QwG-6Qx0hFs6bZ1cUexTGC9G-HTt5M91in4tfdiX',
    Username = 'Driving Test Bot',
    Avatar = '',
    ColorPass = 2222627,
    ColorFail = 15548997
}

-- Two separate places:
--   Desk       - apply for a provisional licence and have the photo taken
--   ExamCentre - book and sit the theory and practical tests
-- Migration from the old 'citydriving' resource name
Config.Legacy = {
    MirrorEvents = true   -- also fire citydriving:server:licenceUpdated for older MDTs
}

Config.Debug = false   -- extra console logging for the photo pipeline

Config.Locations = {
    Desk = {
        Enabled = true,
        Coords = vector3(214.62, -1400.57, 29.57),
        Heading = 141.51,
        Size = vec3(4.0, 4.0, 3.0),
        Distance = 8.0,        -- how close before they can use it
        Label = 'DVLA Desk',
        Icon = 'fa-solid fa-id-card',
        Blip = { Enabled = true, Sprite = 498, Colour = 38, Scale = 0.7 }
    },
    ExamCentre = {
        Enabled = true,
        Coords = vec3(208.69, -1382.76, 30.93),   -- CHANGE ME: where tests are booked
        Heading = 273.0,
        Size = vec3(4.0, 4.0, 3.0),
        Distance = 8.0,
        Label = 'Driving Test Centre',
        Icon = 'fa-solid fa-car-side',
        Blip = { Enabled = false, Sprite = 525, Colour = 3, Scale = 0.7 }
    }
}

-- kept for backwards compatibility with older configs
Config.ExamCenter = {
    Coords = Config.Locations.ExamCentre.Coords,
    Heading = Config.Locations.ExamCentre.Heading,
    Radius = 8.0
}

Config.Proximity = {
    Keybind = 38,
    Distance = 8.0
}

Config.AllowRetake = true
Config.RetryCooldownSeconds = 0

Config.QuestionCountPerExam = 10

-- Speed unit used everywhere: the test HUD, the menu and the MaxSpeed values
-- in Config.VehicleCategories below. 'mph' or 'kmh'.
Config.SpeedUnit = 'mph'

Config.VehicleCategories = {
    car = {
        Label = 'Car (B)',
        Enabled = true,
        VehicleModel = 'remus',
        VehicleSpawn = vector4(219.05, -1375.71, 30.56, 209.76),
        MaxSpeed = 60,   -- in Config.SpeedUnit
        TimeLimitSeconds = 300,
        MaxMistakesTheory = 3,
        MaxMistakesPractical = 5
    },
    bike = {
        Label = 'Motorcycle (A)',
        Enabled = true,
        VehicleModel = 'bati',
        VehicleSpawn = vector4(219.05, -1375.71, 30.56, 209.76),
        MaxSpeed = 60,   -- in Config.SpeedUnit
        TimeLimitSeconds = 300,
        MaxMistakesTheory = 3,
        MaxMistakesPractical = 5
    },
    truck = {
        Label = 'Truck (C)',
        Enabled = true,
        VehicleModel = 'packer',
        VehicleSpawn = vector4(219.05, -1375.71, 30.56, 209.76),
        MaxSpeed = 54,   -- in Config.SpeedUnit
        TimeLimitSeconds = 420,
        MaxMistakesTheory = 4,
        MaxMistakesPractical = 6
    }
}

-- Provisional licence: applied for at the desk, photo taken there, and swapped
-- for the full licence when the practical is passed.
Config.Provisional = {
    Enabled = true,
    ItemName = 'provisional_licence',
    Price = 75,                 -- 0 = free
    PaymentAccount = 'bank',    -- 'bank' or 'cash'
    RequiredForExams = true,    -- must hold one before booking theory/practical
    ShowEntitlement = true,     -- full licences list untaken categories as provisional (P:)
    ValidYears = 10,
    Photo = {
        Enabled = true,
        -- API key lives in server/config.lua (server-only, never sent to clients)
        Encoding = 'png',       -- png | jpg | webp
        Quality = 1.0,
        CountdownSeconds = 3,
        -- the picture is cropped and shrunk before leaving the client
        Output = {
            Width = 420,
            Height = 540,
            Quality = 1.0
        },
        Camera = {
            Distance = 0.95,     -- how far in front of the face (higher = further back)
            HeightOffset = 0.0,  -- raise/lower the camera
            Fov = 40.0,          -- higher = wider shot
            AimOffset = -0.08    -- how far below the head to aim (negative includes shoulders)
        }
    }
}

-- Replacement licence at the desk (lost, stolen or destroyed)
Config.Replacement = {
    Enabled = true,
    Price = 40,
    PaymentAccount = 'bank',    -- 'bank' or 'cash'
    AllowIfHeld = false,        -- true lets them order one while still carrying theirs
    RetakePhoto = false         -- true always takes a fresh photo; false reuses the old one
}

-- Updating the photo on a licence you already hold
Config.PhotoUpdate = {
    Enabled = true,
    Price = 20,
    PaymentAccount = 'bank'   -- 'bank' or 'cash'
}

-- Penalty points and driving bans (for MDT / police integration)
Config.Penalties = {
    Enabled = true,
    PointsExpireYears = 4,      -- points drop off after this long (0 = never)
    TottingThreshold = 12,      -- points that trigger an automatic ban
    AutoBanDays = 180,          -- length of that automatic ban
    BanBlocksLicence = true,    -- a banned driver counts as unlicensed to other scripts
    WipePointsOnBan = true,     -- clear points once a totting ban is handed down
    BanRemovesItem = false      -- true physically takes the licence out of their inventory
}

-- Practical exam rules
Config.Practical = {
    -- Hitting a pedestrian ends the test immediately
    HitPedestrian = {
        Enabled = true,
        InstantFail = true      -- false = counts as a mistake instead
    },
    -- Crashing (hitting a vehicle, wall, prop...) ends the test immediately
    Crash = {
        Enabled = true,
        InstantFail = true,     -- false = counts as a mistake instead
        BodyHealthTrigger = 985.0  -- damage needed to count (1000 = pristine, lower = harder knock needed)
    }
}

Config.DrivingLicence = {
    ConsumeOnUse = false,   -- licences are never used up when shown; leave false
    Enabled = true,
    ItemName = 'driving_licence',
    AutoIssueOnPass = true,
    ValidYears = 10,
    Authority = 'DVLA',
    Country = 'UNITED KINGDOM',
    PlaceholderPhoto = 'assets/licence/placeholder-photo.svg',
    PlaceholderSignature = 'assets/licence/placeholder-signature.svg',
    CloseKey = 177, -- control to dismiss the licence (177 = Backspace / right mouse)
    -- Address on the licence. 'rxhousing' uses the player's owned RxHousing property,
    -- 'charinfo' uses street/city/postcode from the character (if your server sets them).
    AddressSource = 'rxhousing',
    HousingResource = 'RxHousing',
    ShowAnim = {
        Enabled = true,
        Dict = 'paper_1_rcm_alt1-9',   -- arm held out, showing an ID
        Clip = 'player_one_dual-9',
        Prop = 'prop_franklin_dl',     -- GTA's driving licence prop
        Bone = 57005,                  -- right hand
        Offset = vec3(0.10, 0.02, -0.03),
        Rotation = vec3(-90.0, 170.0, 79.0),
        DurationMs = 3500              -- how long the card stays in hand
    },
    ShareNearby = {
        Enabled = true,
        Distance = 5.0,
        DurationMs = 12000
    },
    CategoryCodes = {
        car   = 'AM / B / B1 / F / K / P',
        bike  = 'A / A1 / A2',
        truck = 'C / C1 / D / D1'
    }
}

Config.TheoryQuestions = {
    car = {
        {
            id = 1,
            category = 'car',
            question = 'At a pelican crossing, what must you do when the amber light is flashing?',
            options = {
                'Wait for the green light before you cross',
                'Give way to pedestrians already on the crossing',
                'Accelerate to clear the crossing quickly',
                'Stop and wait for the red light'
            },
            correctAnswer = 1
        },
        {
            id = 2,
            category = 'car',
            question = 'What does a single yellow line along the side of the road mean?',
            options = {
                'No parking at any time',
                'No parking at times shown on nearby signs',
                'Parking allowed for 30 minutes only',
                'Loading and unloading only'
            },
            correctAnswer = 1
        },
        {
            id = 3,
            category = 'car',
            question = 'You are driving at 70 mph on a motorway in good conditions. What is the minimum safe distance?',
            options = {
                '20 metres',
                '40 metres',
                '73 metres',
                '100 metres'
            },
            correctAnswer = 2
        },
        {
            id = 4,
            category = 'car',
            question = 'When may you overtake another vehicle on the left?',
            options = {
                'When the vehicle in front is signalling to turn right',
                'When driving faster than the other vehicle',
                'When the other driver waves you past',
                'Never - you must always overtake on the right'
            },
            correctAnswer = 0
        },
        {
            id = 5,
            category = 'car',
            question = 'What is the national speed limit for cars on a single carriageway?',
            options = {
                '40 mph',
                '50 mph',
                '60 mph',
                '70 mph'
            },
            correctAnswer = 2
        },
        {
            id = 6,
            category = 'car',
            question = 'You approach a roundabout. When MUST you give way?',
            options = {
                'To vehicles approaching on your left',
                'To vehicles approaching on your right',
                'To pedestrians on the zebra crossing',
                'Only when there is a Give Way sign'
            },
            correctAnswer = 1
        },
        {
            id = 7,
            category = 'car',
            question = 'Your car breaks down on the motorway. What should you do?',
            options = {
                'Flag down another driver for help',
                'Use your hazard lights and move to the hard shoulder',
                'Try to repair your car in the lane',
                'Abandon your car and walk to the nearest exit'
            },
            correctAnswer = 1
        },
        {
            id = 8,
            category = 'car',
            question = 'What is the maximum legal blood alcohol concentration for driving in England, Wales and Northern Ireland?',
            options = {
                '50 milligrams per 100 millilitres of blood',
                '80 milligrams per 100 millilitres of blood',
                '100 milligrams per 100 millilitres of blood',
                '20 milligrams per 100 millilitres of blood'
            },
            correctAnswer = 1
        },
        {
            id = 9,
            category = 'car',
            question = 'When MUST you use your headlights?',
            options = {
                'Between sunset and sunrise',
                'At night or when visibility is seriously reduced',
                'Only when there are no street lights',
                'Only when other vehicles use theirs'
            },
            correctAnswer = 1
        },
        {
            id = 10,
            category = 'car',
            question = 'You see a pedestrian with a white stick and red bands. What does this mean?',
            options = {
                'The person is deaf only',
                'The person is blind only',
                'The person is both deaf and blind',
                'The person is an elderly pedestrian'
            },
            correctAnswer = 2
        },
        {
            id = 11,
            category = 'car',
            question = 'The dual carriageway you are turning right onto has a very narrow central reservation. What should you do?',
            options = {
                'Wait in the central reservation until it is clear then complete the turn',
                'Block oncoming traffic so you can complete the turn in one go',
                'Treat it as a single turn and wait for a gap in both directions',
                'Drive around the central reservation via the next roundabout'
            },
            correctAnswer = 0
        },
        {
            id = 12,
            category = 'car',
            question = 'You are driving on a road with several lanes. You see these signs above each lane. What does this mean?',
            image = 'assets/signs/motorway-lane-signs.svg',
            options = {
                'The motorway is closed ahead',
                'Check the signs and move to the correct lane for your route',
                'Speed cameras are operating in all lanes',
                'All lanes have the same destination'
            },
            correctAnswer = 1
        },
        {
            id = 13,
            category = 'car',
            question = 'A contraflow system is where',
            options = {
                'Traffic is banned from entering during rush hour',
                'Buses and taxis use lanes that other traffic cannot',
                'Traffic travels in one direction, but roadworks have diverted you onto the opposite side',
                'Vehicles can only turn right at junctions'
            },
            correctAnswer = 2
        },
        {
            id = 14,
            category = 'car',
            question = 'What does the two-second rule mean?',
            options = {
                'You should check your mirrors every two seconds',
                'You should be at least two seconds behind the vehicle in front',
                'You should signal two seconds before turning',
                'You must stop within two seconds at a red light'
            },
            correctAnswer = 1
        },
        {
            id = 15,
            category = 'car',
            question = 'At an accident, a casualty is unconscious but breathing normally. You should',
            options = {
                'Move them to a comfortable position',
                'Give them something to drink',
                'Check their airway is clear and leave them as they are',
                'Give them chest compressions immediately'
            },
            correctAnswer = 2
        },
        {
            id = 16,
            category = 'car',
            question = 'A green flashing beacon on a vehicle means',
            options = {
                'A police patrol car',
                'A doctor on an emergency call',
                'An ambulance on call',
                'A vehicle carrying explosives'
            },
            correctAnswer = 1
        },
        {
            id = 17,
            category = 'car',
            question = 'The minimum tyre tread depth for cars and light vans is',
            options = {
                '1.0 mm across 3/4 of the tread',
                '1.6 mm across the central 3/4 of the tread around the complete circumference',
                '2.0 mm across the whole tread',
                '0.8 mm across the central tread'
            },
            correctAnswer = 1
        },
        {
            id = 18,
            category = 'car',
            question = 'You are going through a long tunnel. What must you do?',
            options = {
                'Switch off your headlights to save battery',
                'Keep close to the vehicle in front',
                'Switch on dipped headlights',
                'Use your mobile phone to inform others you are in the tunnel'
            },
            correctAnswer = 2
        },
        {
            id = 19,
            category = 'car',
            question = 'Anti-lock brakes work by',
            options = {
                'Locking the front wheels only when braking hard',
                'Applying maximum braking force when you press the brake pedal',
                'Preventing the wheels from locking, so you keep steering control while braking',
                'Reducing the wear on your brake pads'
            },
            correctAnswer = 2
        },
        {
            id = 20,
            category = 'car',
            question = 'You are following a large vehicle approaching crossroads. The driver signals to turn left. What should you do?',
            options = {
                'Overtake on the right because it is safe',
                'Follow closely as the vehicle will be slowing down',
                'Wait; do not overtake when at or approaching a junction',
                'Flash your headlights to let the driver know you are there'
            },
            correctAnswer = 2
        }
    },
    bike = {
        {
            id = 1,
            category = 'bike',
            question = 'What is the most common reason for a motorcycle accident?',
            options = {
                'Drivers failing to see the motorcycle',
                'Mechanical failure of the motorcycle',
                'Road surface conditions',
                'Excessive speed by the rider'
            },
            correctAnswer = 0
        },
        {
            id = 2,
            category = 'bike',
            question = 'When riding a motorcycle, you should wear brightly coloured or fluorescent clothing because',
            options = {
                'It keeps you cool in summer',
                'It helps other road users see you',
                'It makes you look fashionable',
                'It is a legal requirement at all times'
            },
            correctAnswer = 1
        },
        {
            id = 3,
            category = 'bike',
            question = 'On a motorcycle, which of the following is most effective in stopping quickly?',
            options = {
                'Using only the front brake',
                'Using only the rear brake',
                'Using both brakes together',
                'Changing down gears only'
            },
            correctAnswer = 2
        },
        {
            id = 4,
            category = 'bike',
            question = 'When riding at high speed you should',
            options = {
                'Sit as close as possible to the vehicle in front',
                'Increase your following distance',
                'Keep both feet on the ground',
                'Use only the rear brake'
            },
            correctAnswer = 1
        },
        {
            id = 5,
            category = 'bike',
            question = 'When must you use dipped headlights on a motorcycle?',
            options = {
                'Only at night in built-up areas',
                'Between sunset and sunrise',
                'At all times when riding (day and night)',
                'Only when other vehicles are approaching'
            },
            correctAnswer = 2
        },
        {
            id = 6,
            category = 'bike',
            question = 'If your motorcycle starts to aquaplane, you should',
            options = {
                'Brake firmly to slow down',
                'Accelerate to regain control',
                'Ease off the throttle and steer straight',
                'Swerve to avoid the puddle'
            },
            correctAnswer = 2
        },
        {
            id = 7,
            category = 'bike',
            question = 'When carrying a pillion passenger, you should',
            options = {
                'Ride faster so the passenger feels secure',
                'Allow more time for braking and acceleration',
                'Ignore signs because you are two up',
                'Use only the rear brake'
            },
            correctAnswer = 1
        },
        {
            id = 8,
            category = 'bike',
            question = 'Before making a U-turn on a motorcycle, you should',
            options = {
                'Check mirrors, signal, check over shoulder, then proceed',
                'Signal and turn immediately',
                'Slow down and turn without checking',
                'Always use only left signals'
            },
            correctAnswer = 0
        },
        {
            id = 9,
            category = 'bike',
            question = 'What is the minimum legal depth of tread on a motorcycle tyre over 50cc?',
            options = {
                '0.5 mm',
                '1.0 mm across a continuous band',
                '1.6 mm across 3/4 of the tread',
                '2.0 mm over the full circumference'
            },
            correctAnswer = 1
        },
        {
            id = 10,
            category = 'bike',
            question = 'When riding in heavy traffic, you should position yourself',
            options = {
                'In the gutter to stay out of the way',
                'Where you can be seen and can see ahead',
                'As close to the vehicle ahead as possible',
                'In the middle of the road to block other traffic'
            },
            correctAnswer = 1
        },
        {
            id = 11,
            category = 'bike',
            question = 'On a motorcycle the engine braking effect is greatest when',
            options = {
                'The engine is cold',
                'The throttle is fully open',
                'The motorcycle is in a lower gear',
                'The clutch is pulled in'
            },
            correctAnswer = 2
        },
        {
            id = 12,
            category = 'bike',
            question = 'Why should you keep well back from large vehicles on the road?',
            options = {
                'To save fuel by slipstreaming',
                'To see more of the road ahead and be seen by the driver',
                'To avoid noise from the vehicle',
                'To allow faster vehicles to overtake you'
            },
            correctAnswer = 1
        },
        {
            id = 13,
            category = 'bike',
            question = 'At a roundabout, a motorcyclist is more at risk because',
            options = {
                'They have to travel faster',
                'They can be hidden in blind spots by other traffic',
                'Roundabouts are too slippery for bikes',
                'They must always stay in the right lane'
            },
            correctAnswer = 1
        },
        {
            id = 14,
            category = 'bike',
            question = 'A motorcycle rear wheel skid is most likely to happen when',
            options = {
                'You accelerate too hard',
                'You brake too hard at the rear',
                'Both of the above',
                'You ride on wet roads only'
            },
            correctAnswer = 2
        },
        {
            id = 15,
            category = 'bike',
            question = 'When riding past parked vehicles, you should',
            options = {
                'Ride as close to the kerb as possible',
                'Keep well out to avoid suddenly opened doors',
                'Keep to the middle line of the road',
                'Sound your horn continuously'
            },
            correctAnswer = 1
        },
        {
            id = 16,
            category = 'bike',
            question = 'Your helmet must be worn when',
            options = {
                'Only on motorways',
                'Only when carrying a pillion passenger',
                'At all times when riding on the road',
                'Only at speeds over 30 mph'
            },
            correctAnswer = 2
        },
        {
            id = 17,
            category = 'bike',
            question = 'When turning right on a motorcycle, you should',
            options = {
                'Lean your body into the turn',
                'Keep your body upright and let the bike lean',
                'Brake whilst you are turning',
                'Accelerate hard through the turn'
            },
            correctAnswer = 0
        },
        {
            id = 18,
            category = 'bike',
            question = 'Before overtaking a lorry on a motorcycle, you should',
            options = {
                'Stay close to the lorry slipstream then pass quickly',
                'Drop back so you can see past and check it is safe',
                'Overtake on the left side of the lorry',
                'Flash your lights and sound your horn at all times'
            },
            correctAnswer = 1
        },
        {
            id = 19,
            category = 'bike',
            question = 'The main benefit of an ABS braking system on a motorcycle is that it',
            options = {
                'Reduces fuel consumption',
                'Prevents skidding when braking hard so you keep control',
                'Means you never need to check your brakes',
                'Stops you faster than non-ABS in all conditions'
            },
            correctAnswer = 1
        },
        {
            id = 20,
            category = 'bike',
            question = 'A motorcycle with its headlight on during the day is',
            options = {
                'Wasting battery life unnecessarily',
                'More likely to be seen by other road users',
                'Breaking the law',
                'A sign that the rider has forgotten to turn it off'
            },
            correctAnswer = 1
        }
    },
    truck = {
        {
            id = 1,
            category = 'truck',
            question = 'What is the maximum weight for a Category C vehicle with a trailer?',
            options = {
                '7.5 tonnes',
                '18 tonnes',
                '44 tonnes',
                'There is no limit'
            },
            correctAnswer = 2
        },
        {
            id = 2,
            category = 'truck',
            question = 'You are driving a lorry on a motorway. What is the national speed limit?',
            options = {
                '50 mph',
                '60 mph',
                '70 mph',
                '80 mph'
            },
            correctAnswer = 1
        },
        {
            id = 3,
            category = 'truck',
            question = 'For a goods vehicle exceeding 7.5 tonnes, the tachograph must record',
            options = {
                'Only distance travelled',
                'Driving time, breaks, rest and other work periods',
                'Only fuel consumption',
                'Only tyre pressure readings'
            },
            correctAnswer = 1
        },
        {
            id = 4,
            category = 'truck',
            question = 'When driving a large vehicle, blind spots are',
            options = {
                'Non-existent on modern vehicles',
                'Larger than cars, especially to the rear and sides',
                'Only a problem when reversing',
                'Only an issue when towing a trailer'
            },
            correctAnswer = 1
        },
        {
            id = 5,
            category = 'truck',
            question = 'A lorry with an audible warning device when reversing must NOT reverse',
            options = {
                'On a public road at any time',
                'Between 11.30 pm and 7 am in a built-up area, unless it is safe',
                'In a goods yard',
                'Without the assistance of a banksperson'
            },
            correctAnswer = 1
        },
        {
            id = 6,
            category = 'truck',
            question = 'You are driving a heavy lorry and have to brake sharply. What is the main hazard?',
            options = {
                'The brakes could overheat',
                'The load could shift',
                'The engine could stall',
                'The rear tyres could burst'
            },
            correctAnswer = 1
        },
        {
            id = 7,
            category = 'truck',
            question = 'What does a kerb weight of a vehicle mean?',
            options = {
                'The maximum weight the vehicle can tow',
                'The weight of the vehicle with a full load',
                'The weight of the vehicle with fuel and necessary fluids but without driver, passengers or load',
                'The maximum weight permitted on the axles'
            },
            correctAnswer = 2
        },
        {
            id = 8,
            category = 'truck',
            question = 'You are driving a large goods vehicle on a single carriageway. The national speed limit is',
            options = {
                '40 mph',
                '50 mph',
                '60 mph',
                '70 mph'
            },
            correctAnswer = 1
        },
        {
            id = 9,
            category = 'truck',
            question = 'When loading a lorry, heavy items should be placed',
            options = {
                'At the back of the load space',
                'As close to the centre/axles as possible and near the floor',
                'On top of light items',
                'On the roof rack'
            },
            correctAnswer = 1
        },
        {
            id = 10,
            category = 'truck',
            question = 'When driving a long vehicle, you need to take extra care when turning left because',
            options = {
                'The trailer may take a short cut (cut-in) and mount the kerb',
                'The engine is on the left side',
                'Lorries are not allowed to turn left at roundabouts',
                'The handbrake operates on the left wheels only'
            },
            correctAnswer = 0
        },
        {
            id = 11,
            category = 'truck',
            question = 'A Category C licence allows you to drive',
            options = {
                'Vehicles up to 3.5 tonnes only',
                'Vehicles over 3.5 tonnes with a trailer up to 750 kg MAM',
                'Any size vehicle with no limits',
                'Buses only'
            },
            correctAnswer = 1
        },
        {
            id = 12,
            category = 'truck',
            question = 'You are driving a lorry fitted with air brakes. The warning light comes on. What does this mean?',
            options = {
                'The air pressure is too low for the brakes to work safely',
                'You have used the brakes too much',
                'The air filter needs changing',
                'The system is fully charged'
            },
            correctAnswer = 0
        },
        {
            id = 13,
            category = 'truck',
            question = 'When driving a large vehicle on a gradient, you should',
            options = {
                'Accelerate hard up the hill',
                'Select an appropriate gear before the gradient and use engine braking',
                'Coast down the gradient in neutral',
                'Follow close behind the vehicle in front'
            },
            correctAnswer = 1
        },
        {
            id = 14,
            category = 'truck',
            question = 'A compulsory driver CPC (Certificate of Professional Competence) is',
            options = {
                'Optional if you have an older licence',
                'Required for all new lorry and bus drivers carrying out professional driving',
                'Only needed when driving abroad',
                'Needed only for hazardous goods'
            },
            correctAnswer = 1
        },
        {
            id = 15,
            category = 'truck',
            question = 'When securing a load on a lorry, the driver is responsible for ensuring',
            options = {
                'The load is secure and will not move or fall off during transit',
                'The load looks tidy',
                'The load is wrapped in plastic',
                'The load weight is evenly distributed only if it is heavy'
            },
            correctAnswer = 0
        },
        {
            id = 16,
            category = 'truck',
            question = 'On a long steep descent, why should you select a low gear?',
            options = {
                'To save fuel',
                'To use engine braking to avoid overheating the wheel brakes',
                'To reduce engine noise',
                'To allow overtaking by cars'
            },
            correctAnswer = 1
        },
        {
            id = 17,
            category = 'truck',
            question = 'A vehicle with an increased turning circle is most likely to cause problems when',
            options = {
                'Driving on a motorway',
                'Turning at tight junctions, roundabouts and corners',
                'Reversing in a straight line',
                'Overtaking on a dual carriageway'
            },
            correctAnswer = 1
        },
        {
            id = 18,
            category = 'truck',
            question = 'The purpose of a diff-lock on a lorry is to',
            options = {
                'Improve fuel consumption',
                'Improve traction in slippery conditions by preventing wheel spin on one axle',
                'Lock the doors automatically',
                'Differentiate between load weights'
            },
            correctAnswer = 1
        },
        {
            id = 19,
            category = 'truck',
            question = 'Daily walk-around checks of a lorry should include',
            options = {
                'A full interior vacuum',
                'Checking tyres, lights, mirrors, fuel, oil, water and security of load/curtains',
                'Only checking the windscreen wipers',
                'Washing the outside of the vehicle'
            },
            correctAnswer = 1
        },
        {
            id = 20,
            category = 'truck',
            question = 'Why do large vehicles need extra room on roundabouts?',
            options = {
                'They cannot drive around roundabouts',
                'They cut corners due to length and inner rear wheel off-tracking',
                'They have to use the right lane only',
                'They must stop halfway around the roundabout'
            },
            correctAnswer = 1
        }
    }
}

Config.PracticalCheckpoints = {
    car = {
        { coords = vector3(106.92, -1345.58, 29.60), radius = 6.0, type = 'drive' },
        { coords = vector3(71.78, -1181.30, 29.60), radius = 8.0, type = 'drive' },
        { coords = vector3(107.14, -1022.49, 29.58), radius = 8.0, type = 'drive' },
        { coords = vector3(179.83, -844.84, 31.05), radius = 10.0, type = 'drive' },
        { coords = vector3(263.30, -862.62, 29.16), radius = 10.0, type = 'drive' },
        { coords = vector3(254.84, -931.40, 29.26), radius = 10.0, type = 'drive' },
        { coords = vector3(205.19, -1118.22, 29.43), radius = 8.0, type = 'drive' },
        { coords = vector3(213.94, -1271.99, 29.52), radius = 8.0, type = 'drive' },
        { coords = vector3(167.34, -1377.60, 29.57), radius = 8.0, type = 'drive' },
        { coords = vector3(246.18, -1399.91, 30.49), radius = 10.0, type = 'drive' }
    },
    bike = {
       { coords = vector3(106.92, -1345.58, 29.60), radius = 6.0, type = 'drive' },
        { coords = vector3(71.78, -1181.30, 29.60), radius = 8.0, type = 'drive' },
        { coords = vector3(107.14, -1022.49, 29.58), radius = 8.0, type = 'drive' },
        { coords = vector3(179.83, -844.84, 31.05), radius = 10.0, type = 'drive' },
        { coords = vector3(263.30, -862.62, 29.16), radius = 10.0, type = 'drive' },
        { coords = vector3(254.84, -931.40, 29.26), radius = 10.0, type = 'drive' },
        { coords = vector3(205.19, -1118.22, 29.43), radius = 8.0, type = 'drive' },
        { coords = vector3(213.94, -1271.99, 29.52), radius = 8.0, type = 'drive' },
        { coords = vector3(167.34, -1377.60, 29.57), radius = 8.0, type = 'drive' },
        { coords = vector3(246.18, -1399.91, 30.49), radius = 10.0, type = 'drive' }
    },
    truck = {
       { coords = vector3(106.92, -1345.58, 29.60), radius = 6.0, type = 'drive' },
        { coords = vector3(71.78, -1181.30, 29.60), radius = 8.0, type = 'drive' },
        { coords = vector3(107.14, -1022.49, 29.58), radius = 8.0, type = 'drive' },
        { coords = vector3(179.83, -844.84, 31.05), radius = 10.0, type = 'drive' },
        { coords = vector3(263.30, -862.62, 29.16), radius = 10.0, type = 'drive' },
        { coords = vector3(254.84, -931.40, 29.26), radius = 10.0, type = 'drive' },
        { coords = vector3(205.19, -1118.22, 29.43), radius = 8.0, type = 'drive' },
        { coords = vector3(213.94, -1271.99, 29.52), radius = 8.0, type = 'drive' },
        { coords = vector3(167.34, -1377.60, 29.57), radius = 8.0, type = 'drive' },
        { coords = vector3(246.18, -1399.91, 30.49), radius = 10.0, type = 'drive' }
    }
}
