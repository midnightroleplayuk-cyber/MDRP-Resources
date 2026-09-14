return {
    ['testburger'] = {
        label = 'Test Burger',
        weight = 220,
        degrade = 60,
        client = {
            image = 'burger_chicken.png',
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            export = 'ox_inventory_examples.testburger'
        },
        server = {
            export = 'ox_inventory_examples.testburger',
            test = 'what an amazingly delicious burger, amirite?'
        },
        buttons = {
            {
                label = 'Lick it',
                action = function(slot)
                    print('You licked the burger')
                end
            },
            {
                label = 'Squeeze it',
                action = function(slot)
                    print('You squeezed the burger :(')
                end
            },
            {
                label = 'What do you call a vegan burger?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('A misteak.')
                end
            },
            {
                label = 'What do frogs like to eat with their hamburgers?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('French flies.')
                end
            },
            {
                label = 'Why were the burger and fries running?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('Because they\'re fast food.')
                end
            }
        },
        consume = 0.3
    },

    ['burger'] = {
        label = 'Burger',
        weight = 220,
        client = {
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            notification = 'You ate a delicious burger'
        },
    },

    ['sprunk'] = {
        label = 'Sprunk',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a sprunk'
        }
    },

    ['parachute'] = {
        label = 'Parachute',
        weight = 8000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 1500
        }
    },

    ['garbage'] = {
        label = 'Garbage',
    },

    ['paperbag'] = {
        label = 'Paper Bag',
        weight = 1,
        stack = false,
        close = false,
        consume = 0
    },

    ['panties'] = {
        label = 'Knickers',
        weight = 10,
        consume = 0,
        client = {
            status = { thirst = -100000, stress = -25000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
            usetime = 2500,
        }
    },

['lockpick'] = {
	label = 'Lockpick',
	weight = 160,
	client = {
		event = 'lockpick:use'
	}
},
-- LB PHONE
["phone"] = {
    label = "Phone",
    weight = 190,
    stack = false,
    consume = 0
},

    ['mustard'] = {
        label = 'Mustard',
        weight = 500,
        client = {
            status = { hunger = 25000, thirst = 25000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
            usetime = 2500,
            notification = 'You... drank mustard'
        }
    },

    ['water'] = {
        label = 'Water',
        weight = 500,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
            usetime = 2500,
            cancel = true,
            notification = 'You drank some refreshing water'
        }
    },

    ['armour'] = {
        label = 'Bulletproof Vest',
        weight = 3000,
        stack = false,
        client = {
            anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
        }
    },

    ['clothing'] = {
        label = 'Clothing',
        consume = 0,
    },

    ['money'] = {
        label = 'Money',
    },

    ['black_money'] = {
        label = 'Dirty Money',
    },

    ['id_card'] = {
        label = 'Identification Card',
    },

    ['driver_license'] = {
        label = 'Drivers License',
    },

    ['weaponlicense'] = {
        label = 'Weapon License',
    },

    ['lawyerpass'] = {
        label = 'Lawyer Pass',
    },

    ['radio'] = {
        label = 'Radio',
        weight = 1000,
        allowArmed = true,
        consume = 0,
        client = {
            event = 'mm_radio:client:use'
        }
    },

    ['jammer'] = {
        label = 'Radio Jammer',
        weight = 10000,
        allowArmed = true,
        client = {
            event = 'mm_radio:client:usejammer'
        }
    },

    ['radiocell'] = {
        label = 'AAA Cells',
        weight = 1000,
        stack = true,
        allowArmed = true,
        client = {
            event = 'mm_radio:client:recharge'
        }
    },

    ['advancedlockpick'] = {
        label = 'Advanced Lockpick',
        weight = 500,
        client = {
            event = 'lockpick:useAdvanced'
        }
    },

    -- RENEWED KEYS
    ['vehiclekey'] = {
	label = 'Vehicle Key'
},
    ['keyring'] = {
	label = 'Key Ring',
	weight = 1,
	stack = false,
	close = false,
	consume = 0
},


    ['screwdriverset'] = {
        label = 'Screwdriver Set',
        weight = 500,
    },

    ['electronickit'] = {
        label = 'Electronic Kit',
        weight = 500,
    },

    ['cleaningkit'] = {
        label = 'Cleaning Kit',
        weight = 500,
    },

    ['repairkit'] = {
        label = 'Repair Kit',
        weight = 2500,
    },

    ['advancedrepairkit'] = {
        label = 'Advanced Repair Kit',
        weight = 4000,
    },

    ['diamond_ring'] = {
        label = 'Diamond',
        weight = 1500,
    },

    ['rolex'] = {
        label = 'Golden Watch',
        weight = 1500,
    },

    ['goldbar'] = {
        label = 'Gold Bar',
        weight = 1500,
    },

    ['goldchain'] = {
        label = 'Golden Chain',
        weight = 1500,
    },

    ['crack_baggy'] = {
        label = 'Crack Baggy',
        weight = 100,
    },

    ['cokebaggy'] = {
        label = 'Bag of Coke',
        weight = 100,
    },

    ['coke_brick'] = {
        label = 'Coke Brick',
        weight = 2000,
    },

    ['coke_small_brick'] = {
        label = 'Coke Package',
        weight = 1000,
    },

    ['xtcbaggy'] = {
        label = 'Bag of Ecstasy',
        weight = 100,
    },

    ['meth'] = {
        label = 'Methamphetamine',
        weight = 100,
    },

    ['oxy'] = {
        label = 'Oxycodone',
        weight = 100,
    },

    ['weed_ak47'] = {
        label = 'AK47 2g',
        weight = 200,
    },

    ['weed_ak47_seed'] = {
        label = 'AK47 Seed',
        weight = 1,
    },

    ['weed_skunk'] = {
        label = 'Skunk 2g',
        weight = 200,
    },

    ['weed_skunk_seed'] = {
        label = 'Skunk Seed',
        weight = 1,
    },

    ['weed_amnesia'] = {
        label = 'Amnesia 2g',
        weight = 200,
    },

    ['weed_amnesia_seed'] = {
        label = 'Amnesia Seed',
        weight = 1,
    },

    ['weed_og-kush'] = {
        label = 'OGKush 2g',
        weight = 200,
    },

    ['weed_og-kush_seed'] = {
        label = 'OGKush Seed',
        weight = 1,
    },

    ['weed_white-widow'] = {
        label = 'OGKush 2g',
        weight = 200,
    },

    ['weed_white-widow_seed'] = {
        label = 'White Widow Seed',
        weight = 1,
    },

    ['weed_purple-haze'] = {
        label = 'Purple Haze 2g',
        weight = 200,
    },

    ['weed_purple-haze_seed'] = {
        label = 'Purple Haze Seed',
        weight = 1,
    },

    ['weed_brick'] = {
        label = 'Weed Brick',
        weight = 2000,
    },

    ['weed_nutrition'] = {
        label = 'Plant Fertilizer',
        weight = 2000,
    },

    ['joint'] = {
        label = 'Joint',
        weight = 200,
    },

    ['rolling_paper'] = {
        label = 'Rolling Paper',
        weight = 0,
    },

    ['empty_weed_bag'] = {
        label = 'Empty Weed Bag',
        weight = 0,
    },

    ['firstaid'] = {
        label = 'First Aid',
        weight = 2500,
    },

    ['ifaks'] = {
        label = 'Individual First Aid Kit',
        weight = 2500,
    },

    ['painkillers'] = {
        label = 'Painkillers',
        weight = 400,
    },

    ['firework1'] = {
        label = '2Brothers',
        weight = 1000,
    },

    ['firework2'] = {
        label = 'Poppelers',
        weight = 1000,
    },

    ['firework3'] = {
        label = 'WipeOut',
        weight = 1000,
    },

    ['firework4'] = {
        label = 'Weeping Willow',
        weight = 1000,
    },

    ['steel'] = {
        label = 'Steel',
        weight = 100,
    },

    ['rubber'] = {
        label = 'Rubber',
        weight = 100,
    },

    ['metalscrap'] = {
        label = 'Metal Scrap',
        weight = 100,
    },

    ['iron'] = {
        label = 'Iron',
        weight = 100,
    },

    ['copper'] = {
        label = 'Copper',
        weight = 100,
    },

    ['aluminum'] = {
        label = 'Aluminium',
        weight = 100,
    },

    ['plastic'] = {
        label = 'Plastic',
        weight = 100,
    },

    ['glass'] = {
        label = 'Glass',
        weight = 100,
    },

    ['gatecrack'] = {
        label = 'Gatecrack',
        weight = 1000,
    },

    ['cryptostick'] = {
        label = 'Crypto Stick',
        weight = 100,
    },

    ['trojan_usb'] = {
        label = 'Trojan USB',
        weight = 100,
    },

    ['toaster'] = {
        label = 'Toaster',
        weight = 5000,
    },

    ['small_tv'] = {
        label = 'Small TV',
        weight = 100,
    },

    ['security_card_01'] = {
        label = 'Security Card A',
        weight = 100,
    },

    ['security_card_02'] = {
        label = 'Security Card B',
        weight = 100,
    },

    ['drill'] = {
        label = 'Drill',
        weight = 5000,
    },

    ['thermite'] = {
        label = 'Thermite',
        weight = 1000,
    },

    ['diving_gear'] = {
        label = 'Diving Gear',
        weight = 30000,
    },

    ['diving_fill'] = {
        label = 'Diving Tube',
        weight = 3000,
    },

    ['antipatharia_coral'] = {
        label = 'Antipatharia',
        weight = 1000,
    },

    ['dendrogyra_coral'] = {
        label = 'Dendrogyra',
        weight = 1000,
    },

    ['jerry_can'] = {
        label = 'Jerrycan',
        weight = 3000,
    },

    ['nitrous'] = {
        label = 'Nitrous',
        weight = 1000,
    },

    ['wine'] = {
        label = 'Wine',
        weight = 500,
    },

    ['grape'] = {
        label = 'Grape',
        weight = 10,
    },

    ['grapejuice'] = {
        label = 'Grape Juice',
        weight = 200,
    },

    ['coffee'] = {
        label = 'Coffee',
        weight = 200,
    },

    ['vodka'] = {
        label = 'Vodka',
        weight = 500,
    },

    ['whiskey'] = {
        label = 'Whiskey',
        weight = 200,
    },

    ['beer'] = {
        label = 'Beer',
        weight = 200,
    },

    ['sandwich'] = {
        label = 'Sandwich',
        weight = 200,
    },

    ['walking_stick'] = {
        label = 'Walking Stick',
        weight = 1000,
    },

    ['lighter'] = {
        label = 'Lighter',
        weight = 200,
    },

    ['binoculars'] = {
        label = 'Binoculars',
        weight = 800,
    },

    ['stickynote'] = {
        label = 'Sticky Note',
        weight = 0,
    },

    ['empty_evidence_bag'] = {
        label = 'Empty Evidence Bag',
        weight = 200,
    },

    ['filled_evidence_bag'] = {
        label = 'Filled Evidence Bag',
        weight = 200,
    },

    ['harness'] = {
        label = 'Harness',
        weight = 200,
    },

    ['handcuffs'] = {
        label = 'Handcuffs',
        weight = 200,
    },

--LG MDT
['mdt'] = {
    label = 'MPD PNC',
    weight = 400,
    stack = false,
    close = true,
    description = 'Police National Computer Tablet',
    client = {
        image = 'mdt.png',
    }
},

-- OP MECHANIC
-- Tools & install parts
['repair_kit'] = {
    label = 'Repair Kit',
    weight = 1000,
    stack = true,
    close = true,
    consume = 0,
    client = { export = 'op-mechanic.useRepairKit' },
},
['mechanic_tablet'] = {
    label = 'Mechanic Tablet',
    weight = 900,
    stack = false,
    close = true,
    description = 'Shop tablet - work orders, invoices, parts, fleet and finances.',
    client = {
        export = 'op-mechanic.useMechanicTablet',
    },
},
['mechanic_tools'] = {
    label = 'Mechanic Tools',
    weight = 1500,
    stack = false,
    close = true,
    description = 'Toolkit required to install workshop modifications.',
},
['wheel_parts'] = {
    label = 'Wheel Parts',
    weight = 500,
    stack = true,
    close = true,
    description = 'Parts used for wheel and rim installations.',
},
['tire_parts'] = {
    label = 'Tire Parts',
    weight = 400,
    stack = true,
    close = true,
    description = 'Parts used for tires, smoke and related work.',
},
['paint_supplies'] = {
    label = 'Paint Supplies',
    weight = 350,
    stack = true,
    close = true,
    description = 'Paint, finish and pearlescent supplies.',
},
['engine_parts'] = {
    label = 'Engine Parts',
    weight = 800,
    stack = true,
    close = true,
    description = 'Parts used for engine and turbo upgrades.',
},
['brake_parts'] = {
    label = 'Brake Parts',
    weight = 450,
    stack = true,
    close = true,
    description = 'Parts used for brake upgrades.',
},
['transmission_parts'] = {
    label = 'Transmission Parts',
    weight = 700,
    stack = true,
    close = true,
    description = 'Parts used for transmission upgrades.',
},
['suspension_parts'] = {
    label = 'Suspension Parts',
    weight = 550,
    stack = true,
    close = true,
    description = 'Parts used for suspension and stance work.',
},
['body_parts'] = {
    label = 'Body Parts',
    weight = 600,
    stack = true,
    close = true,
    description = 'Body panels, armor and general bodywork parts.',
},
['exhaust_parts'] = {
    label = 'Exhaust Parts',
    weight = 500,
    stack = true,
    close = true,
    description = 'Parts used for exhaust installations.',
},
['lighting_parts'] = {
    label = 'Lighting Parts',
    weight = 300,
    stack = true,
    close = true,
    description = 'Parts used for lights, neon and xenon.',
},
['rgb_controller'] = {
    label = 'RGB Controller',
    weight = 400,
    stack = true,
    close = true,
    description = 'Controls fitted underglow strips - colour, RGB fade, flash and per-side.',
    client = {
        export = 'op-mechanic.useRgbController',
    },
},
['interior_parts'] = {
    label = 'Interior Parts',
    weight = 350,
    stack = true,
    close = true,
    description = 'Parts used for interior and dashboard colours.',
},

-- Maintenance
['engine_oil'] = {
    label = 'Engine Oil',
    weight = 250,
    stack = true,
    close = true,
    description = 'Service oil for combustion engines.',
},
['clutch_kit'] = {
    label = 'Clutch Kit',
    weight = 900,
    stack = true,
    close = true,
    description = 'Clutch assembly for workshop maintenance.',
},
['air_filter'] = {
    label = 'Air Filter',
    weight = 120,
    stack = true,
    close = true,
    description = 'Intake air filter element.',
},
['spark_plugs'] = {
    label = 'Spark Plugs',
    weight = 80,
    stack = true,
    close = true,
    description = 'Ignition plugs (usually used in sets of 4).',
},
['brake_pads'] = {
    label = 'Brake Pads',
    weight = 400,
    stack = true,
    close = true,
    description = 'Friction pads for a full axle set.',
},
['service_suspension'] = {
    label = 'Suspension Service Kit',
    weight = 700,
    stack = true,
    close = true,
    description = 'Bushings and dampers for suspension service.',
},
['tyre_set'] = {
    label = 'Tyre Set',
    weight = 1200,
    stack = true,
    close = true,
    description = 'Set of road tyres for maintenance swaps.',
},
['alternator'] = {
    label = 'Alternator',
    weight = 850,
    stack = true,
    close = true,
    description = 'Charging system alternator for ICE vehicles.',
},
['ev_motor'] = {
    label = 'EV Drive Motor',
    weight = 2500,
    stack = true,
    close = true,
    description = 'Electric drive unit service part.',
},
['ev_battery'] = {
    label = 'EV Battery Pack',
    weight = 3000,
    stack = true,
    close = true,
    description = 'Traction battery module for EV service.',
},
['ev_coolant'] = {
    label = 'EV Coolant',
    weight = 200,
    stack = true,
    close = true,
    description = 'Coolant for EV battery thermal systems.',
},

-- Nitro
['nitrous_install_kit'] = {
    label = 'Nitrous Install Kit',
    weight = 1200,
    stack = true,
    close = true,
    description = 'Workshop kit that enables NOS bottles on a vehicle.',
},
['nitrous_bottle'] = {
    label = 'Nitrous Bottle',
    weight = 2000,
    stack = true,
    close = true,
    description = 'Full NOS bottle. Use near the front of a kit-equipped vehicle to refill.',
    client = {
        event = 'opm:client:nitro:useBottle',
    },
},
['empty_nitrous_bottle'] = {
    label = 'Empty Nitrous Bottle',
    weight = 800,
    stack = true,
    close = true,
    description = 'Spent NOS bottle.',
},

-- Field kits & care (usable)
['engine_kit'] = {
    label = 'Engine Kit',
    weight = 2000,
    stack = true,
    close = true,
    description = 'Field kit to repair a vehicle engine (F6 or use item).',
    client = {
        export = 'op-mechanic.useEngineKit',
    },
},
['body_kit'] = {
    label = 'Body Kit',
    weight = 1800,
    stack = true,
    close = true,
    description = 'Field kit to repair vehicle bodywork (F6 or use item).',
    client = {
        export = 'op-mechanic.useBodyKit',
    },
},
['cleaning_kit'] = {
    label = 'Cleaning Kit',
    weight = 500,
    stack = true,
    close = true,
    description = 'Sponge and cleaner to wash a vehicle (F6 or use item).',
    client = {
        export = 'op-mechanic.useCleaningKit',
    },
},
['car_wax'] = {
    label = 'Car Wax',
    weight = 200,
    stack = true,
    close = true,
    description = 'Protective wax - vehicle gets dirty slower for a while.',
    client = {
        export = 'op-mechanic.useCarWax',
    },
},

-- Tuning kits
['engine_swap_i4'] = {
    label = 'I4 Engine Swap',
    weight = 3500,
    stack = true,
    close = true,
    description = 'Twin-scroll I4 crate engine for workshop swaps.',
},
['engine_swap_v6'] = {
    label = 'V6 Engine Swap',
    weight = 4200,
    stack = true,
    close = true,
    description = 'Street V6 crate engine for workshop swaps.',
},
['engine_swap_v8'] = {
    label = 'V8 Engine Swap',
    weight = 5000,
    stack = true,
    close = true,
    description = 'Forged V8 crate engine for workshop swaps.',
},
['engine_swap_v12'] = {
    label = 'V12 Engine Swap',
    weight = 5800,
    stack = true,
    close = true,
    description = 'Motorsport V12 crate engine for workshop swaps.',
},
['tyre_track_slick'] = {
    label = 'Track Slick Tires',
    weight = 1600,
    stack = true,
    close = true,
    description = 'Dry-track slick compound set.',
},
['tyre_street_semi'] = {
    label = 'Street Semi-Slick Tires',
    weight = 1400,
    stack = true,
    close = true,
    description = 'Sticky road-legal semi-slick set.',
},
['tyre_trail_mud'] = {
    label = 'Trail Mud Tires',
    weight = 1500,
    stack = true,
    close = true,
    description = 'Soft-surface trail / mud tire set.',
},
['brake_race_ceramic'] = {
    label = 'Race Ceramic Brakes',
    weight = 900,
    stack = true,
    close = true,
    description = 'High-friction ceramic brake package.',
},
['brake_endurance'] = {
    label = 'Endurance Brake Kit',
    weight = 850,
    stack = true,
    close = true,
    description = 'Fade-resistant endurance brake package.',
},
['drivetrain_awd'] = {
    label = 'AWD Drivetrain Kit',
    weight = 2200,
    stack = true,
    close = true,
    description = 'All-wheel-drive conversion hardware.',
},
['drivetrain_rwd'] = {
    label = 'RWD Drivetrain Kit',
    weight = 1800,
    stack = true,
    close = true,
    description = 'Rear-wheel-drive conversion hardware.',
},
['drivetrain_fwd'] = {
    label = 'FWD Drivetrain Kit',
    weight = 1800,
    stack = true,
    close = true,
    description = 'Front-wheel-drive conversion hardware.',
},


-- TX AMBO JOB
	['bandage'] = {
		label = 'Bandage',
		weight = 50,
		stack = true,
		close = true,
	},

	['ifak'] = {
		label = 'IFAK',
		weight = 200,
		stack = true,
		close = true,
	},

	['tourniquet'] = {
		label = 'Tourniquet',
		weight = 100,
		stack = true,
		close = true,
	},

	['gauze'] = {
		label = 'Gauze',
		weight = 50,
		stack = true,
		close = true,
	},

	['burn_gel'] = {
		label = 'Burn Gel',
		weight = 100,
		stack = true,
		close = true,
	},

	['surgical_kit'] = {
		label = 'Surgical Kit',
		weight = 500,
		stack = true,
		close = true,
	},

	['saline_bag'] = {
		label = 'Saline Bag',
		weight = 300,
		stack = true,
		close = true,
	},

	['leg_brace'] = {
		label = 'Leg Brace',
		weight = 300,
		stack = true,
		close = true,
	},

	['arm_brace'] = {
		label = 'Arm Brace',
		weight = 300,
		stack = true,
		close = true,
	},

	['body_brace'] = {
		label = 'Body Brace',
		weight = 1000,
		stack = true,
		close = true,
	},

	['neck_brace'] = {
		label = 'Neck Brace',
		weight = 300,
		stack = true,
		close = true,
	},

	['ice_pack'] = {
		label = 'Ice Pack',
		weight = 150,
		stack = true,
		close = true,
	},

	['painkillers'] = {
		label = 'Painkillers',
		weight = 50,
		stack = true,
		close = true,
	},

	['defibrillator'] = {
		label = 'Defibrillator',
		weight = 1000,
		stack = true,
		close = true,
	},

	['adrenaline_syringe'] = {
		label = 'Adrenaline Syringe',
		weight = 100,
		stack = true,
		close = true,
	},

	['wheelchair'] = {
		label = 'wheelchair',
		weight = 2500,
		stack = false,
		close = true,
	},

	['walking_stick'] = {
		label = 'Walking Stick',
		weight = 1000,
		stack = false,
		close = true,
	},

	['med_bag'] = {
		label = 'Medical Bag',
		weight = 500,
		stack = false,
		close = true,
	},

	['body_bag'] = {
		label = 'Body Bag',
		weight = 500,
		stack = true,
		close = true,
	},

	['ecg'] = {
		label = 'ECG Monitor',
		weight = 1000,
		stack = true,
		close = false,
	},

    -- TX EVIDENCE
    	["gsr_cloth"] = {
		label = "GSR Cloth",
		weight = 100,
		stack = true,
		close = true,
	},

	["gsr_test_kit"] = {
		label = "GSR Test Kit",
		weight = 100,
		stack = true,
		close = true,
	},

	["uv_light"] = {
		label = "UV Flashlight",
		weight = 250,
		stack = true,
		close = true,
	},

	["evidence_camera"] = {
		label = "Evidence Camera",
		weight = 500,
		stack = true,
		close = true,
	},

	["fingerprint_scanner"] = {
		label = "Fingerprint Scanner",
		weight = 250,
		stack = true,
		close = true,
	},

	["bullet_casing"] = {
		label = "Bullet Casing",
		weight = 1,
		stack = false,
	},

	["bullet_fragment"] = {
		label = "Bullet Fragment",
		weight = 1,
		stack = false,
	},

	["blood_sample"] = {
		label = "Blood Sample",
		weight = 1,
		stack = false,
	},

	["fingerprint"] = {
		label = "Fingerprint Sample",
		weight = 1,
		stack = false,
	},

	["evidence"] = {
		label = "Evidence",
		weight = 1,
		stack = false,
	},

	["bullet_hole"] = {
		label = "Impact Sample",
		weight = 1,
		stack = false,
	},


    -- TK POLICE
       ['cone'] = {
		label = 'Cone',
		weight = 100,
		stack = true,
		close = true,
	},

	['barrier'] = {
		label = 'Barrier',
		weight = 100,
		stack = true,
		close = true,
	},

	['worklight'] = {
		label = 'Worklight',
		weight = 100,
		stack = true,
		close = true,
	},

	['spike_strips'] = {
		label = 'Spike Strips',
		weight = 100,
		stack = true,
		close = true,
	},

	['speed_camera'] = {
		label = 'Speed Camera',
		weight = 1000,
		stack = true,
		close = true,
	},

	['breathalyzer'] = {
		label = 'Breathalyzer',
		weight = 100,
		stack = true,
		close = true,
	},

	['fingerprint_scanner'] = {
		label = 'Fingerprint Scanner',
		weight = 100,
		stack = true,
		close = true,
	},

	['handcuffs'] = {
		label = 'Handcuffs',
		weight = 100,
		stack = true,
		close = true,
	},

	['bodycam'] = {
		label = 'Bodycam',
		weight = 100,
		stack = true,
		close = true,
	},

	['dash_cam'] = {
		label = 'Dashcam',
		weight = 100,
		stack = true,
		close = true,
	},

	['glass_riot_shield'] = {
		label = 'Glass Riot Shield',
		weight = 1000,
		stack = true,
		close = true,
		allowArmed = true,
	},

	['metal_riot_shield'] = {
		label = 'Metal Riot Shield',
		weight = 1000,
		stack = true,
		close = true,
		allowArmed = true,
	},

	['night_vision_goggles'] = {
		label = 'Night Vision Goggles',
		weight = 250,
		stack = true,
		close = true,
	},

	['thermal_vision_goggles'] = {
		label = 'Thermal Vision Goggles',
		weight = 250,
		stack = true,
		close = true,
	},

    -- TK MDT
    	["pol_mdt"] = {
		label = "Police PNC",
		weight = 200,
		stack = true,
		close = true,
	},

	["ems_mdt"] = {
		label = "NHS MDT",
		weight = 200,
		stack = true,
		close = true,
	},


    --LG Banking
        ['debitcard'] = {
        label = 'Debit Card',
        weight = 3,
        type = 'item',
        image = 'bank_card.png',
        unique = true,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'A Personal Debit Card.',
    },


    --TK DRUGS
    ['og_kush_seed'] = {
        label = 'OG Kush Seed',
        weight = 1,
        stack = true,
    },

    ['northern_lights_seed'] = {
        label = 'Northern Lights Seed',
        weight = 1,
        stack = true,
    },

    ['dosidos_seed'] = {
        label = 'Do-Si-Dos Seed',
        weight = 1,
        stack = true,
    },

    ['acapulco_gold_seed'] = {
        label = 'Acapulco Gold Seed',
        weight = 1,
        stack = true,
    },

    ['low_quality_og_kush'] = {
        label = 'Low-Quality OG Kush',
        weight = 1,
        stack = true,
    },

    ['medium_quality_og_kush'] = {
        label = 'Medium-Quality OG Kush',
        weight = 1,
        stack = true,
    },

    ['high_quality_og_kush'] = {
        label = 'High-Quality OG Kush',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_og_kush'] = {
        label = 'Exotic-Quality OG Kush',
        weight = 1,
        stack = true,
    },

    ['low_quality_northern_lights'] = {
        label = 'Low-Quality Northern Lights',
        weight = 1,
        stack = true,
    },

    ['medium_quality_northern_lights'] = {
        label = 'Medium-Quality Northern Lights',
        weight = 1,
        stack = true,
    },

    ['high_quality_northern_lights'] = {
        label = 'High-Quality Northern Lights',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_northern_lights'] = {
        label = 'Exotic-Quality Northern Lights',
        weight = 1,
        stack = true,
    },

    ['low_quality_dosidos'] = {
        label = 'Low-Quality Do-Si-Dos',
        weight = 1,
        stack = true,
    },

    ['medium_quality_dosidos'] = {
        label = 'Medium-Quality Do-Si-Dos',
        weight = 1,
        stack = true,
    },

    ['high_quality_dosidos'] = {
        label = 'High-Quality Do-Si-Dos',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_dosidos'] = {
        label = 'Exotic-Quality Do-Si-Dos',
        weight = 1,
        stack = true,
    },

    ['low_quality_acapulco_gold'] = {
        label = 'Low-Quality Acapulco Gold',
        weight = 1,
        stack = true,
    },

    ['medium_quality_acapulco_gold'] = {
        label = 'Medium-Quality Acapulco Gold',
        weight = 1,
        stack = true,
    },

    ['high_quality_acapulco_gold'] = {
        label = 'High-Quality Acapulco Gold',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_acapulco_gold'] = {
        label = 'Exotic-Quality Acapulco Gold',
        weight = 1,
        stack = true,
    },

    ['liquid_meth'] = {
        label = 'Liquid Meth',
        weight = 1,
        stack = true,
    },

    ['baggy'] = {
        label = 'Baggy',
        weight = 1,
        stack = true,
    },

    ['empty_tray'] = {
        label = 'Empty Tray',
        weight = 5,
        stack = true,
    },

    ['liquid_meth_tray'] = {
        label = 'Liquid Meth Tray',
        weight = 20,
        stack = true,
    },

    ['meth_tray'] = {
        label = 'Meth Tray',
        weight = 20,
        stack = true,
    },

    ['low_quality_bagged_og_kush'] = {
        label = 'Bagged Low-Quality OG Kush',
        weight = 20,
        stack = true,
    },

    ['medium_quality_bagged_og_kush'] = {
        label = 'Bagged Medium-Quality OG Kush',
        weight = 20,
        stack = true,
    },

    ['high_quality_bagged_og_kush'] = {
        label = 'Bagged High-Quality OG Kush',
        weight = 20,
        stack = true,
    },

    ['exotic_quality_bagged_og_kush'] = {
        label = 'Bagged Exotic-Quality OG Kush',
        weight = 20,
        stack = true,
    },

    ['low_quality_bagged_northern_lights'] = {
        label = 'Bagged Low-Quality Northern Lights',
        weight = 20,
        stack = true,
    },

    ['medium_quality_bagged_northern_lights'] = {
        label = 'Bagged Medium-Quality Northern Lights',
        weight = 20,
        stack = true,
    },

    ['high_quality_bagged_northern_lights'] = {
        label = 'Bagged High-Quality Northern Lights',
        weight = 20,
        stack = true,
    },

    ['exotic_quality_bagged_northern_lights'] = {
        label = 'Bagged Exotic-Quality Northern Lights',
        weight = 20,
        stack = true,
    },

    ['low_quality_bagged_dosidos'] = {
        label = 'Bagged Low-Quality Do-Si-Dos',
        weight = 20,
        stack = true,
    },

    ['medium_quality_bagged_dosidos'] = {
        label = 'Bagged Medium-Quality Do-Si-Dos',
        weight = 20,
        stack = true,
    },

    ['high_quality_bagged_dosidos'] = {
        label = 'Bagged High-Quality Do-Si-Dos',
        weight = 20,
        stack = true,
    },

    ['exotic_quality_bagged_dosidos'] = {
        label = 'Bagged Exotic-Quality Do-Si-Dos',
        weight = 20,
        stack = true,
    },

    ['low_quality_bagged_acapulco_gold'] = {
        label = 'Bagged Low-Quality Acapulco Gold',
        weight = 20,
        stack = true,
    },

    ['medium_quality_bagged_acapulco_gold'] = {
        label = 'Bagged Medium-Quality Acapulco Gold',
        weight = 20,
        stack = true,
    },

    ['high_quality_bagged_acapulco_gold'] = {
        label = 'Bagged High-Quality Acapulco Gold',
        weight = 20,
        stack = true,
    },

    ['exotic_quality_bagged_acapulco_gold'] = {
        label = 'Bagged Exotic-Quality Acapulco Gold',
        weight = 20,
        stack = true,
    },

    ['bagged_meth'] = {
        label = 'Bagged Meth',
        weight = 20,
        stack = true,
    },

    ['bagging_table'] = {
        label = 'Bagging Table',
        weight = 1000,
        stack = true,
    },

    ['cauldron'] = {
        label = 'Cauldron',
        weight = 500,
        stack = true,
    },

    ['low_quality_coca_leaf'] = {
        label = 'Low-Quality Coca Leaf',
        weight = 5,
        stack = true,
    },

    ['medium_quality_coca_leaf'] = {
        label = 'Medium-Quality Coca Leaf',
        weight = 5,
        stack = true,
    },

    ['high_quality_coca_leaf'] = {
        label = 'High-Quality Coca Leaf',
        weight = 5,
        stack = true,
    },

    ['exotic_quality_coca_leaf'] = {
        label = 'Exotic-Quality Coca Leaf',
        weight = 5,
        stack = true,
    },

    ['low_quality_coke_base'] = {
        label = 'Low-Quality Cocaine Base',
        weight = 1,
        stack = true,
    },

    ['medium_quality_coke_base'] = {
        label = 'Medium-Quality Cocaine Base',
        weight = 1,
        stack = true,
    },

    ['high_quality_coke_base'] = {
        label = 'High-Quality Cocaine Base',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_coke_base'] = {
        label = 'Exotic-Quality Cocaine Base',
        weight = 1,
        stack = true,
    },

    ['meth_cooking_table'] = {
        label = 'Meth Cooking Table',
        weight = 1000,
        stack = true,
    },

    ['phos'] = {
        label = 'Phos',
        weight = 1,
        stack = true,
    },

    ['acid'] = {
        label = 'Acid',
        weight = 1,
        stack = true,
    },

    ['pseudo'] = {
        label = 'Pseudo',
        weight = 1,
        stack = true,
    },

    ['explosive_meth'] = {
        label = 'Explosive Meth',
        weight = 1,
        stack = true,
    },

    ['mixer'] = {
        label = 'Mixer',
        weight = 1,
        stack = true,
    },

    ['petrol_can'] = {
        label = 'Petrol Can',
        weight = 500,
        stack = true,
    },

    ['meth_oven'] = {
        label = 'Meth Oven',
        weight = 2500,
        stack = true,
    },

    ['coke_oven'] = {
        label = 'Coke Oven',
        weight = 2500,
        stack = true,
    },

    ['low_quality_cocaine'] = {
        label = 'Low-Quality Cocaine',
        weight = 1,
        stack = true,
    },

    ['medium_quality_cocaine'] = {
        label = 'Medium-Quality Cocaine',
        weight = 1,
        stack = true,
    },

    ['high_quality_cocaine'] = {
        label = 'High-Quality Cocaine',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_cocaine'] = {
        label = 'Exotic-Quality Cocaine',
        weight = 1,
        stack = true,
    },

    ['low_quality_bagged_cocaine'] = {
        label = 'Bagged Low-Quality Cocaine',
        weight = 20,
        stack = true,
    },

    ['medium_quality_bagged_cocaine'] = {
        label = 'Bagged Medium-Quality Cocaine',
        weight = 20,
        stack = true,
    },

    ['high_quality_bagged_cocaine'] = {
        label = 'Bagged High-Quality Cocaine',
        weight = 20,
        stack = true,
    },

    ['exotic_quality_bagged_cocaine'] = {
        label = 'Bagged Exotic-Quality Cocaine',
        weight = 20,
        stack = true,
    },

    ['meth'] = {
        label = 'Meth',
        weight = 1,
        stack = true,
    },

    ['coca_seed'] = {
        label = 'Coca Seed',
        weight = 1,
        stack = true,
    },

    ['plant_pot'] = {
        label = 'Plant Pot',
        weight = 100,
        stack = true,
    },

    ['fertilizer'] = {
        label = 'Fertilizer',
        weight = 10,
        stack = true,
    },

    ['water_bottle'] = {
        label = 'Water Bottle',
        weight = 100,
        stack = true,
    },

    ['default_lamp'] = {
        label = 'Lamp',
        weight = 200,
        stack = true,
    },

    ['press'] = {
        label = 'Press',
        weight = 2500,
        stack = true,
    },

    ['low_quality_coke_brick'] = {
        label = 'Low-Quality Coke Brick',
        weight = 100,
        stack = true,
    },

    ['medium_quality_coke_brick'] = {
        label = 'Medium-Quality Coke Brick',
        weight = 100,
        stack = true,
    },

    ['high_quality_coke_brick'] = {
        label = 'High-Quality Coke Brick',
        weight = 100,
        stack = true,
    },

    ['exotic_quality_coke_brick'] = {
        label = 'Exotic-Quality Coke Brick',
        weight = 100,
        stack = true,
    },

    ['cubensis'] = {
        label = 'Cubensis',
        weight = 1,
        stack = true,
    },

    ['liberty_cap'] = {
        label = 'Liberty Cap',
        weight = 1,
        stack = true,
    },

    ['fly_agaric'] = {
        label = 'Fly Agaric',
        weight = 1,
        stack = true,
    },

    ['dried_cubensis'] = {
        label = 'Dried Cubensis',
        weight = 1,
        stack = true,
    },

    ['dried_liberty_cap'] = {
        label = 'Dried Liberty Cap',
        weight = 1,
        stack = true,
    },

    ['dried_fly_agaric'] = {
        label = 'Dried Fly Agaric',
        weight = 1,
        stack = true,
    },

    ['bagged_cubensis'] = {
        label = 'Bagged Cooked Cubensis',
        weight = 20,
        stack = true,
    },

    ['bagged_liberty_cap'] = {
        label = 'Bagged Cooked Liberty Cap',
        weight = 20,
        stack = true,
    },

    ['bagged_fly_agaric'] = {
        label = 'Bagged Cooked Fly Agaric',
        weight = 20,
        stack = true,
    },

    ['cooked_cubensis'] = {
        label = 'Cooked Cubensis',
        weight = 1,
        stack = true,
    },

    ['cooked_liberty_cap'] = {
        label = 'Cooked Liberty Cap',
        weight = 1,
        stack = true,
    },

    ['cooked_fly_agaric'] = {
        label = 'Cooked Fly Agaric',
        weight = 1,
        stack = true,
    },

    ['poppy_resin'] = {
        label = 'Poppy Resin',
        weight = 1,
        stack = true,
    },

    ['acetic_anhydride'] = {
        label = 'Acetic Anhydride',
        weight = 1,
        stack = true,
    },

    ['empty_syringe'] = {
        label = 'Empty Syringe',
        weight = 1,
        stack = true,
    },

    ['heroin_syringe'] = {
        label = 'Heroin Syringe',
        weight = 1,
        stack = true,
    },

    ['rye_ergot'] = {
        label = 'Rye Ergot',
        weight = 1,
        stack = true,
    },

    ['diethylamine'] = {
        label = 'Diethylamine',
        weight = 1,
        stack = true,
    },

    ['paper_sheet'] = {
        label = 'Paper Sheet',
        weight = 1,
        stack = true,
    },

    ['lsd_sheet'] = {
        label = 'LSD Sheet',
        weight = 5,
        stack = true,
    },

    ['heroin_cooking_table'] = {
        label = 'Heroin Cooking Table',
        weight = 1500,
        stack = true,
    },

    ['lsd_table'] = {
        label = 'LSD Table',
        weight = 1500,
        stack = true,
    },

    ['joint_roller_table'] = {
        label = 'Joint Roller Table',
        weight = 1500,
        stack = true,
    },

    ['rolling_paper'] = {
        label = 'Rolling Paper',
        weight = 1,
        stack = true,
    },

    ['low_quality_og_kush_joint'] = {
        label = 'Low-Quality OG Kush Joint',
        weight = 1,
        stack = true,
    },

    ['medium_quality_og_kush_joint'] = {
        label = 'Medium-Quality OG Kush Joint',
        weight = 1,
        stack = true,
    },

    ['high_quality_og_kush_joint'] = {
        label = 'High-Quality OG Kush Joint',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_og_kush_joint'] = {
        label = 'Exotic-Quality OG Kush Joint',
        weight = 1,
        stack = true,
    },

    ['low_quality_northern_lights_joint'] = {
        label = 'Low-Quality Northern Lights Joint',
        weight = 1,
        stack = true,
    },

    ['medium_quality_northern_lights_joint'] = {
        label = 'Medium-Quality Northern Lights Joint',
        weight = 1,
        stack = true,
    },

    ['high_quality_northern_lights_joint'] = {
        label = 'High-Quality Northern Lights Joint',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_northern_lights_joint'] = {
        label = 'Exotic-Quality Northern Lights Joint',
        weight = 1,
        stack = true,
    },

    ['low_quality_dosidos_joint'] = {
        label = 'Low-Quality Do-Si-Dos Joint',
        weight = 1,
        stack = true,
    },

    ['medium_quality_dosidos_joint'] = {
        label = 'Medium-Quality Do-Si-Dos Joint',
        weight = 1,
        stack = true,
    },

    ['high_quality_dosidos_joint'] = {
        label = 'High-Quality Do-Si-Dos Joint',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_dosidos_joint'] = {
        label = 'Exotic-Quality Do-Si-Dos Joint',
        weight = 1,
        stack = true,
    },

    ['low_quality_acapulco_gold_joint'] = {
        label = 'Low-Quality Acapulco Gold Joint',
        weight = 1,
        stack = true,
    },

    ['medium_quality_acapulco_gold_joint'] = {
        label = 'Medium-Quality Acapulco Gold Joint',
        weight = 1,
        stack = true,
    },

    ['high_quality_acapulco_gold_joint'] = {
        label = 'High-Quality Acapulco Gold Joint',
        weight = 1,
        stack = true,
    },

    ['exotic_quality_acapulco_gold_joint'] = {
        label = 'Exotic-Quality Acapulco Gold Joint',
        weight = 1,
        stack = true,
    },

    ['trap_phone'] = {
        label = 'Trap Phone',
        weight = 250,
        stack = true,
    },

    ['drug_shelf'] = {
        label = 'Drug Shelf',
        weight = 1000,
        stack = true,
    },

    ['drying_rack'] = {
        label = 'Drying Rack',
        weight = 500,
        stack = true,
    },

    ['meth_chiller'] = {
        label = 'Meth Chiller',
        weight = 1000,
        stack = true,
    },

    ['ac_unit'] = {
        label = 'AC Unit',
        weight = 500,
        stack = true,
    },

    ['methadone'] = {
        label = 'Methadone',
        weight = 1,
        stack = true,
    },

    ['addiction_meds'] = {
        label = 'Addiction Meds',
        weight = 1,
        stack = true,
    },

    ['banana'] = {
        label = 'Banana',
        weight = 1,
        stack = true,
    },

    ['caffeine_powder'] = {
        label = 'Caffeine Powder',
        weight = 1,
        stack = true,
    },

    ['glitter_powder'] = {
        label = 'Glitter Powder',
        weight = 1,
        stack = true,
    },

    ['speedball_syringe'] = {
        label = 'Speedball Syringe',
        weight = 1,
        stack = true,
    },

    ['wet_joint'] = {
        label = 'Wet Joint',
        weight = 1,
        stack = true,
    },

    ['glitter_bomb_meth'] = {
        label = 'Glitter Bomb Meth',
        weight = 1,
        stack = true,
    },

-- GANG TABLET
['crime_tablet'] = {
    label = 'Crime Tablet',
    weight = 1,
    type = 'item',
    image = 'tablet.png', -- Optional, if you want an image for it
    useable = true,
    description = 'A tablet for various crime-related tasks.',
    client = {
	event = 'op-crime:openCrimeTablet'
    }
},
['rope'] = {
    label = "Rope",
    weight = 250,
    client = {
      event = "op-crime:openHandcuffsMenu",
    }
},
['spray_remover'] = {
    label = "Spray Remover",
    weight = 250,
    client = {
      event = "op-crime:useRemover",
    }
},
['spray_can'] = {
    label = "Gang Spray Can",
    weight = 1500,
    client = {
      event = "op-crime:useSpray",
    }
},
['spy_binoculars'] = {
	label = "Tactical Binoculars",
	weight = 1500,
	client = {
		event = "op-crime:spybinoculars:client:toggle",
	}
},
['spy_gps']= {
	label = "GPS Tracker",
	weight = 1500,
	client = {
		event = "op-crime:spy-gps:placeGps",
	}
},
['spy_cam']= {
	label = "Hidden Camera",
	weight = 1500,
	client = {
		event = "op-crime:addSpyItem:SpyCam",
	}
},
['spy_motionsensor']= {
	label = "Motion Sensor",
	weight = 1500,
	client = {
		event = "op-crime:addSpyItem:MotionSensor",
	}
},
['spy_cam_terminal']= {
	label = "Camera Terminal",
	weight = 1500,
	client = {
		event = "op-crime:openSpyCamTerminal",
	}
},
['spy_detector']= {
	label = "Signal Detector",
	weight = 1500,
	client = {
		event = "op-crime:detectorItem",
	}
},
['cocaine'] = {
    label = "Cocaine 1g",
    weight = 1,
},
['meth'] = {
    label = "Crystal Meth 1g",
    weight = 1,
},
['weed'] = {
    label = "Weed 1g",
    weight = 1,
},

-- HOUSE ROBBERY
["silver_coin"] = {
		label = 'Silver Coin',
		weight = 50,
	},

	["gold_coin"] = {
		label = 'Gold Coin',
		weight = 50,
	},

	["charlotte_ring"] = {
		label = 'Charlotte Ring',
		weight = 50,
	},

	["simbolos_chain"] = {
		label = 'Simbolos Chain',
		weight = 100,
	},

	["action_figure"] = {
		label = 'Action Figure',
		weight = 100,
	},

	["nominos_ring"] = {
		label = 'Nominos Ring',
		weight = 50,
	},

	["boss_chain"] = {
		label = 'BOSS Chain',
		weight = 200,
	},

	["branded_cigarette"] = {
		label = 'Branded Cigarette',
		weight = 10,
	},

	["branded_cigarette_box"] = {
		label = 'Branded Cigarette Box',
		weight = 200,
	},

	["ninja_figure"] = {
		label = 'Ninja Figure',
		weight = 50,
	},

	["painting"] = {
		label = 'Painting',
		weight = 100,
	},

	["statue"] = {
		label = 'Statue',
		weight = 200,
	},

	["ancient_egypt_artifact"] = {
		label = 'Ancient Egypt Artifact',
		weight = 200,
	},

	["ruby"] = {
		label = 'Ruby',
		weight = 100,
	},

	["diamond"] = {
		label = 'Diamond',
		weight = 100,
	},

	["danburite"] = {
		label = 'Danburite',
		weight = 100,
	},

	["television"] = {
		label = 'Television',
		weight = 5000,
		stack = false
	},

   ["coffee_machine"] = {
		label = 'Coffee Machine',
		weight = 1000,
		stack = false
	},

	["computer"] = {
		label = 'Computer',
		weight = 2500,
		stack = false
	},

	["microwave"] = {
		label = 'Microwave',
		weight = 3500,
		stack = false
	},

	["music_player"] = {
		label = 'Music Player',
		weight = 2000,
		stack = false
	},

	["lockpick"] = {
		label = 'Lockpick',
		weight = 10,
		stack = true
	},

	["cutter"] = {
		label = 'Cutter',
		weight = 1000,
		stack = true
	},

-- KQ WEED
['kq_weed_pot'] = {
        label = "Weed pot",
        weight = 2000,
        stack = true,
        consume = 0,
        server = {
            export = 'kq_weed.UsePot',
        },
    },

    ['kq_weed_table'] = {
        label = "Weed Packing Table",
        weight = 8000,
        stack = true,
        consume = 0,
        server = {
            export = 'kq_weed.UseTable',
        },
    },

    ['kq_weed_press'] = {
        label = "Weed Press",
        weight = 10000,
        stack = true,
        consume = 0,
        server = {
            export = 'kq_weed.UsePress',
        },
    },

    ['kq_weed_tent'] = {
        label = "Grow tent",
        weight = 4000,
        stack = true,
        consume = 0,
    },

    ['kq_weed_watering_system'] = {
        label = "Plant watering system",
        weight = 3000,
        stack = true,
        consume = 0,
    },

    ['kq_weed_bag_empty'] = {
        label = "Plastic baggie",
        weight = 1,
        stack = true,
        consume = 0,
    },

    ['kq_weed_paper'] = {
        label = "Rolling paper",
        weight = 1,
        stack = true,
        consume = 0,
    },

    ['kq_weed_pesticide_spray'] = {
        label = "Pesticide Spray",
        weight = 500,
        stack = true,
        consume = 0,
    },

    ['kq_weed_fertilizer_speed'] = {
        label = "Fertilizer (Growth Speed)",
        weight = 500,
        stack = true,
        consume = 0,
    },

    ['kq_weed_fertilizer_yield'] = {
        label = "Fertilizer (Yield Amount)",
        weight = 500,
        stack = true,
        consume = 0,
    },

    ['kq_weed_fertilizer_resistance'] = {
        label = "Fertilizer (Resistance Booster)",
        weight = 500,
        stack = true,
        consume = 0,
    },

    ['kq_weed_fertilizer_blackmarket'] = {
        label = "Fertilizer (Blackmarket)",
        weight = 500,
        stack = true,
        consume = 0,
    },

    ['kq_weed_bud_og_kush'] = {
        label = "Weed bud (OG Kush)",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ['kq_weed_seed_og_kush'] = {
        label = "Weed seed (OG Kush)",
        weight = 1,
        stack = true,
        consume = 0,
    },

    ['kq_weed_bag_og_kush'] = {
        label = "Weed baggie (OG Kush)",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ['kq_weed_joint_og_kush'] = {
        label = "Joint (OG Kush)",
        weight = 3,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_weed.SmokeJoint',
        },
    },

    ['kq_weed_brick_og_kush'] = {
        label = "Weed brick (OG Kush)",
        weight = 100,
        stack = true,
        consume = 0,
    },



    ['kq_weed_bud_purple_haze'] = {
        label = "Weed bud (Purple Haze)",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ['kq_weed_seed_purple_haze'] = {
        label = "Weed seed (Purple Haze)",
        weight = 1,
        stack = true,
        consume = 0,
    },

    ['kq_weed_bag_purple_haze'] = {
        label = "Weed baggie (Purple Haze)",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ['kq_weed_joint_purple_haze'] = {
        label = "Joint (Purple Haze)",
        weight = 3,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_weed.SmokeJoint',
        },
    },

    ['kq_weed_brick_purple_haze'] = {
        label = "Weed brick (Purple Haze)",
        weight = 100,
        stack = true,
        consume = 0,
    },



    ['kq_weed_bud_white_widow'] = {
        label = "Weed bud (White widow)",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ['kq_weed_seed_white_widow'] = {
        label = "Weed seed (White widow)",
        weight = 1,
        stack = true,
        consume = 0,
    },

    ['kq_weed_bag_white_widow'] = {
        label = "Weed baggie (White widow)",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ['kq_weed_joint_white_widow'] = {
        label = "Joint (White widow)",
        weight = 3,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_weed.SmokeJoint',
        },
    },

    ['kq_weed_brick_white_widow'] = {
        label = "Weed brick (White widow)",
        weight = 100,
        stack = true,
        consume = 0,
    },


    ['kq_weed_bud_blue_dream'] = {
        label = "Weed bud (Blue dream)",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ['kq_weed_seed_blue_dream'] = {
        label = "Weed seed (Blue dream)",
        weight = 1,
        stack = true,
        consume = 0,
    },

    ['kq_weed_bag_blue_dream'] = {
        label = "Weed baggie (Blue dream)",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ['kq_weed_joint_blue_dream'] = {
        label = "Joint (Blue dream)",
        weight = 3,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_weed.SmokeJoint',
        },
    },

    ['kq_weed_brick_blue_dream'] = {
        label = "Weed brick (Blue dream)",
        weight = 100,
        stack = true,
        consume = 0,
    },
    ['watering_can'] = {
        label = "Watering Can",
        weight = 1,
        stack = false,
        consume = 0,
    },  
    
    
-- WHITEBOARDS
  ['place_poster'] = {
      label = 'Poster',
      server = {
        export = "of_whiteboard.place_image"  
      },
      weight = 100,
  },
  ['edit_poster'] = {
      label = 'Marker set',
      server = {
        export = "of_whiteboard.edit_image"  
      },
      weight = 100,
  },
  ['remove_poster'] = {
      label = 'Clean tools',
      server = {
        export = "of_whiteboard.remove_image"  
      },
      weight = 100,
  },

-- KQ_COCAINE
    ["coke"] = {
        label = "Cocaine",
        weight = 500,
        stack = true,
        close = true,
    },

    ["cement"] = {
        label = "Cement",
        weight = 5000,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_cocaine.UseCement',
        },
    },

    ["hydrochloric_acid"] = {
        label = "Hydrochloric acid",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["coca_blend"] = {
        label = "Coca blend",
        weight = 200,
        stack = true,
        close = true,
    },

    ["coca_leaf"] = {
        label = "Coca leaf",
        weight = 100,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_cocaine.UseLeaf',
        },
    },

    ["coca_paste"] = {
        label = "Coca paste",
        weight = 100,
        stack = true,
        close = true,
    },

    ["gasoline"] = {
        label = "Gasoline",
        weight = 3000,
        stack = true,
        close = true,
    },



-- KQ OutfitBag V2
    ["kq_outfitbag"] = {
        label = "Outfit bag",
        weight = 4,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_outfitbag2.UseBag',
        },
    },

-- KQ DEALING    
    ['kq_plugphone'] = {
        label = "Plug Phone",
        weight = 250,
        stack = false,
        consume = 0,
        server = {
            export = 'kq_drugdeals.UsePlugPhone',
        },
    },

    ['kq_trapphone'] = {
        label = "Trap Phone",
        weight = 150,
        stack = false,
        consume = 0,
        server = {
            export = 'kq_drugdeals.UseTrapPhone',
        },
    },

    ['kq_stingphone'] = {
        label = "Sting Phone",
        weight = 250,
        stack = false,
        consume = 0,
        server = {
            export = 'kq_drugdeals.UseStingPhone',
        },
    },

    ['kq_drugpackage'] = {
        label = "Sealed Drug Package",
        weight = 1000,
        stack = true,
        consume = 0,
    },

-- KQ SMASH N GRAB 
["cement"] = {
        label = "Cement",
        weight = 5000,
        stack = true,
        close = true,
        consume = 0,
    },

    ["expensive_sneakers"] = {
        label = "Designer sneakers",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["expensive_bag"] = {
        label = "Designer bag",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["laptop"] = {
        label = "Laptop",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["copper"] = {
        label = "Copper ingot",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["stolen_weapon_case"] = {
        label = "Stolen weapon case",
        weight = 2000,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_smash_n_grab2.LootItem',
        },
    },

    ["stolen_bag"] = {
        label = "Stolen bag",
        weight = 2000,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'kq_smash_n_grab2.LootItem',
        },
    },    

-- LS TRUCKING
['ls_package'] = {
    label = 'Delivery Package',
    image = 'ls_package.png',
    weight = 2500,
    stack = true,
    close = true,
    description = 'A package assigned to a Los Santos Freight Co. delivery route.'
},

['ls_package2'] = {
    label = 'Delivery Package',
    image = 'ls_package2.png',
    weight = 2500,
    stack = true,
    close = true,
    description = 'A boxed package assigned to a Los Santos Freight Co. delivery route.'
},

['ls_package3'] = {
    label = 'Delivery Package',
    image = 'ls_package3.png',
    weight = 2500,
    stack = true,
    close = true,
    description = 'A sealed package assigned to a Los Santos Freight Co. delivery route.'
},

['ls_package4'] = {
    label = 'Delivery Package',
    image = 'ls_package4.png',
    weight = 2500,
    stack = true,
    close = true,
    description = 'A heavy package assigned to a Los Santos Freight Co. delivery route.'
},

['ls_gift_package'] = {
    label = 'Gift Package',
    image = 'ls_gift_package.png',
    weight = 2500,
    stack = true,
    close = true,
    description = 'A special gift package for a Los Santos Freight Co. delivery route.'
},

['ls_crate'] = {
    label = 'Freight Crate',
    image = 'ls_crate.png',
    weight = 6000,
    stack = true,
    close = true,
    description = 'A heavy freight crate assigned to a box truck delivery route.'
},

['ls_ammo_crate'] = {
    label = 'Ammo Crate',
    image = 'ls_ammo_crate.png',
    weight = 7000,
    stack = true,
    close = true,
    description = 'A secured ammunition crate assigned to a restricted delivery route.'
},

['ls_secure_crate'] = {
    label = 'Secure Government Crate',
    image = 'ls_secure_crate.png',
    weight = 7000,
    stack = true,
    close = true,
    description = 'A secured government crate assigned to a Los Santos Freight Co. route.'
},

['ls_military_crate'] = {
    label = 'Merryweather Crate',
    image = 'ls_military_crate.png',
    weight = 8000,
    stack = true,
    close = true,
    description = 'A restricted military freight crate.'
},

['ls_military_crate2'] = {
    label = 'Military Crate',
    image = 'ls_military_crate2.png',
    weight = 8000,
    stack = true,
    close = true,
    description = 'A military freight crate assigned to a restricted route.'
},

['ls_delivery_manifest'] = {
    label = 'Delivery Manifest',
    image = 'ls_delivery_manifest.png',
    weight = 100,
    stack = false,
    close = true,
    description = 'A Los Santos Freight Co. package delivery manifest.'
},

['ls_trailer_manifest'] = {
    label = 'Trailer Manifest',
    image = 'ls_trailer_manifest.png',
    weight = 100,
    stack = false,
    close = true,
    description = 'A Los Santos Freight Co. trailer delivery manifest.'
},
    

-- OSP AMBULANCE ITEMS
['pager'] = {
    label = 'Pager',
    weight = 10,
    stack = true,
},

['tourniquet'] = {
    label = 'Tourniquet',
    weight = 10,
    stack = true,
},

['field_dressing'] = {
    label = 'Field Dressing',
    weight = 10,
    stack = true,
},

['elastic_bandage'] = {
    label = 'Elastic Bandage',
    weight = 10,
    stack = true,
},

['quick_clot'] = {
    label = 'Quick Clot',
    weight = 10,
    stack = true,
},

['packing_bandage'] = {
    label = 'Packing Bandage',
    weight = 10,
    stack = true,
},

['sewing_kit'] = {
    label = 'Sewing Kit',
    weight = 10,
    stack = true,
},

['epinephrine'] = {
    label = 'Epinephrine',
    weight = 10,
    stack = true,
},

['morphine'] = {
    label = 'Morphine',
    weight = 10,
    stack = true,
},

['propofol'] = {
    label = 'Propofol',
    weight = 10,
    stack = true,
},

['saline250ml'] = {
    label = 'Saline 250ml',
    weight = 10,
    stack = true,
},

['saline500ml'] = {
    label = 'Saline 500ml',
    weight = 10,
    stack = true,
},

['revivekit'] = {
    label = 'Emergency Revive Kit',
    weight = 10,
    stack = true,
},

['stretcher'] = {
    label = 'Stretcher',
    weight = 1000,
    stack = true,
},

['wheelchair'] = {
    label = 'wheelchair',
    weight = 1000,
    stack = true,
},

['crutch'] = {
    label = 'Crutch',
    weight = 1000,
    stack = true,
},

['bodybag'] = {
    label = 'Bodybag',
    weight = 1000,
    stack = true,
},

['ecg'] = {
    label = 'ECG',
    weight = 200,
    stack = true,
},

['neckbrace'] = {
    label = 'Neck Brace',
    weight = 200,
    stack = true,
},

['neckcast'] = {
    label = 'Neck Cast',
    weight = 200,
    stack = true,
},

['legsplint'] = {
    label = 'Leg Splint',
    weight = 200,
    stack = true,
},

['legcast'] = {
    label = 'Leg Cast',
    weight = 200,
    stack = true,
},

['armsplint'] = {
    label = 'Arm Splint',
    weight = 200,
    stack = true,
},

['armcast'] = {
    label = 'Arm Cast',
    weight = 200,
    stack = true,
},

['castsaw'] = {
    label = 'Cast Saw',
    weight = 200,
    stack = true,
},

['bloodsample'] = {
    label = 'Blood Sample',
    weight = 200,
    stack = true,
},

['blood500ml_ominus'] = {
    label = 'Blood Pack 500ml O-',
    weight = 200,
    stack = true,
},

['blood500ml_oplus'] = {
    label = 'Blood Pack 500ml O+',
    weight = 200,
    stack = true,
},

['blood500ml_bminus'] = {
    label = 'Blood Pack 500ml B-',
    weight = 200,
    stack = true,
},

['blood500ml_bplus'] = {
    label = 'Blood Pack 500ml B+',
    weight = 200,
    stack = true,
},

['blood500ml_aminus'] = {
    label = 'Blood Pack 500ml A-',
    weight = 200,
    stack = true,
},

['blood500ml_aplus'] = {
    label = 'Blood Pack 500ml A+',
    weight = 200,
    stack = true,
},

['blood500ml_abminus'] = {
    label = 'Blood Pack 500ml AB-',
    weight = 200,
    stack = true,
},

['blood500ml_abplus'] = {
    label = 'Blood Pack 500ml AB+',
    weight = 200,
    stack = true,
},

['expiredblood'] = {
    label = 'Expired Blood',
    weight = 200,
    stack = true,
},

['prescription'] = {
    label = 'Prescription',
    weight = 10,
    stack = false,
},

['cough_syrup'] = {
    label = 'Cough Syrup',
    weight = 100,
    stack = true,
},

['paracetamol'] = {
    label = 'Paracetamol',
    weight = 100,
    stack = true,
},

['tramadol'] = {
    label = 'Tramadol',
    weight = 100,
    stack = true,
},

['vicodin'] = {
    label = 'Vicodin',
    weight = 100,
    stack = true,
},

['xanax'] = {
    label = 'Xanax',
    weight = 100,
    stack = true,
},

['melatonin'] = {
    label = 'Melatonin',
    weight = 100,
    stack = true,
},

['narcan'] = {
    label = 'Narcan',
    weight = 100,
    stack = true,
},

['medical_bag'] = {
    label = 'Medical Bag',
    weight = 2000,
    stack = false,
},

-- CAR RENTAL 
['rental_paper'] = {
    label = 'Rental Paper',
    weight = 10,
    stack = false,
    close = true,
    description = 'A Rental Paper for your vehicle'
},


-- CAR BOOTSTING
['devhub_car_checker'] = {
    label = 'Car Checker',
    weight = 120,
    stack = true,
    close = true,
    description = "Device used to scan vehicle information"
},

['devhub_key_cloner'] = {
    label = 'Key Cloner',
    weight = 180,
    stack = true,
    close = true,
    description = "Device used to clone vehicle keys"
},



-- PLUTO AMBO JOB
	['plt_medkit'] = {
		label = 'Medkit',
		weight = 500,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Standard Med Kit for treatment.',
	},

	['plt_bandage'] = {
		label = 'Bandage',
		weight = 100,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'A Bandage',
	},

	['plt_painkillers'] = {
		label = 'Painkillers',
		weight = 50,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Painkillers',
	},

	['plt_painkillers_adv'] = {
		label = 'Advanced Painkillers',
		weight = 50,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Opioids can be addictive.',
	},

	['plt_antibiotics'] = {
		label = 'Antibiotics',
		weight = 50,
		stack = true,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Use as directed.',
	},

	['plt_surgical_kit'] = {
		label = 'Surgical Kit',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Surgical Tools',
	},

	['plt_stretcher'] = {
		label = 'Stretcher',
		weight = 5000,
		stack = false,
		close = true,
		description = 'Used to transport patients safely.',
	},

	['plt_oxygen_mask'] = {
		label = 'Oxygen Mask',
		weight = 300,
		stack = true,
		close = true,
		description = 'Helps patients breathe',
	},

	['plt_surgical_scissors'] = {
		label = 'Surgical Scissors',
		weight = 200,
		stack = true,
		close = true,
		description = 'Careful, They\'re sharp!',
	},

	['plt_radio'] = {
		label = 'Radio',
		weight = 200,
		stack = false,
		close = true,
		description = 'Radio for EMS',
	},

	['plt_medical_bag'] = {
		label = 'Medical Bag',
		weight = 2000,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_medical_bag' },
		description = 'A Medical Bag for Paramedics',
	},

	['plt_bp_monitor'] = {
		label = 'BP Monitor',
		weight = 500,
		stack = true,
		close = true,
		description = 'Takes an accurate Blood Pressure Reading',
	},

	['plt_flashlight'] = {
		label = 'Flashlight',
		weight = 500,
		stack = false,
		close = true,
		description = 'DAMN! That\'s Bright',
	},

	['plt_fireextinguisher'] = {
		label = 'Fire Extinguisher',
		weight = 2000,
		stack = false,
		close = true,
		description = 'Used to put out small fires.',
	},

	['plt_prescription'] = {
		label = 'Medical Prescription',
		weight = 50,
		stack = true,
		close = true,
		description = 'Prescription - MHS Use ONLY',
	},

	['iak_wheelchair'] = {
		label = 'Wheelchair',
		weight = 5000,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'It\'s Wheely-Fun!',
	},

	['plt_walking_stick'] = {
		label = 'Walking Stick',
		weight = 800,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Mobility Aid',
	},

	['plt_cane'] = {
		label = 'Cane',
		weight = 800,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'A Simple Cane',
	},

	['plt_crutches'] = {
		label = 'Crutches',
		weight = 1200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_medication' },
		description = 'Crutches',
	},

	['plt_ems_certificate'] = {
		label = 'EMS Certificate',
		weight = 50,
		stack = false,
		close = true,
		description = 'Official MHD medical certificate signed by staff.',
        client = {
            image = 'prescription.png',
        }
	},

	['as_xray_clipboard_01'] = {
		label = 'X-Ray Clipboard #01',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_xray_clipboard' },
		description = 'View X-Ray Images',
	},

	['as_xray_clipboard_02'] = {
		label = 'X-Ray Clipboard #02',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_xray_clipboard' },
		description = 'View X-Ray Images',
	},

	['as_xray_clipboard_03'] = {
		label = 'X-Ray Clipboard #03',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_xray_clipboard' },
		description = 'View X-Ray Images',
	},

	['as_xray_clipboard_04'] = {
		label = 'X-Ray Clipboard #04',
		weight = 200,
		stack = false,
		close = true,
		consume = 0,
		client = { export = 'plt_ambulance_job.plt_use_xray_clipboard' },
		description = 'View X-Ray Images',
	},

 -- CRIME SCENE
 ['devhub_bodybag'] = {
    label = 'Body Bag',
    weight = 300,
    stack = true,
    close = true,
    description = "Bag used for transporting bodies"
},

['devhub_binbag'] = {
    label = 'Bin Bag',
    weight = 100,
    stack = true,
    close = true,
    description = "Plastic garbage bag"
},

['devhub_cleaningkit'] = {
    label = 'Cleaning Kit',
    weight = 150,
    stack = true,
    close = true,
    description = "Kit for cleaning traces"
},

['devhub_antiquevase'] = {
    label = 'Antique Vase',
    weight = 250,
    stack = true,
    close = true,
    description = "Valuable antique vase"
},

['WEAPON_POCKETLIGHT'] = {
    label = 'UV Light',
    weight = 50,
    stack = true,
    close = true,
    description = "UV Torch"
},

-- DEV HUB ROBBERY

-- qb-core/shared/items.lua 


["dh_hr_tv"] = {
    ["name"] = "dh_hr_tv",
    ["label"] = "TV",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_tv.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_table"] = {
    ["name"] = "dh_hr_table",
    ["label"] = "Table",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_table.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_plant"] = {
    ["name"] = "dh_hr_plant",
    ["label"] = "Plant",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_plant.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_soap"] = {
    ["name"] = "dh_hr_soap",
    ["label"] = "Soap",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_soap.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_soap_2"] = {
    ["name"] = "dh_hr_soap_2",
    ["label"] = "Soap 2",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_soap_2.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_painting"] = {
    ["name"] = "dh_hr_painting",
    ["label"] = "Painting",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_painting.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_plant_2"] = {
    ["name"] = "dh_hr_plant_2",
    ["label"] = "Plant 2",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_plant_2.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},

["dh_hr_passport"] = {
    ["name"] = "dh_hr_passport",
    ["label"] = "Passport",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_passport.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_champagne"] = {
    ["name"] = "dh_hr_champagne",
    ["label"] = "Champagne",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_champagne.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_skull"] = {
    ["name"] = "dh_hr_skull",
    ["label"] = "Skull",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_skull.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_casino_car"] = {
    ["name"] = "dh_hr_casino_car",
    ["label"] = "Casino Car",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_casino_car.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_dress"] = {
    ["name"] = "dh_hr_dress",
    ["label"] = "Dress",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_dress.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_teddy_bear"] = {
    ["name"] = "dh_hr_teddy_bear",
    ["label"] = "Teddy Bear",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_teddy_bear.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_bedside_clock"] = {
    ["name"] = "dh_hr_bedside_clock",
    ["label"] = "Bedside Clock",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_bedside_clock.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_headphones"] = {
    ["name"] = "dh_hr_headphones",
    ["label"] = "Headphones",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_headphones.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_iron"] = {
    ["name"] = "dh_hr_iron",
    ["label"] = "Iron",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_iron.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_doll"] = {
    ["name"] = "dh_hr_doll",
    ["label"] = "Doll",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_doll.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_tiger"] = {
    ["name"] = "dh_hr_tiger",
    ["label"] = "Tiger",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_tiger.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_gold_cd"] = {
    ["name"] = "dh_hr_gold_cd",
    ["label"] = "Gold CD",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_gold_cd.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_hairdryer"] = {
    ["name"] = "dh_hr_hairdryer",
    ["label"] = "Hairdryer",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_hairdryer.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_coffee"] = {
    ["name"] = "dh_hr_coffee",
    ["label"] = "Coffee",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_coffee.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_mixer"] = {
    ["name"] = "dh_hr_mixer",
    ["label"] = "Mixer",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_mixer.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_fan"] = {
    ["name"] = "dh_hr_fan",
    ["label"] = "Fan",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_fan.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_pestle"] = {
    ["name"] = "dh_hr_pestle",
    ["label"] = "Pestle",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_pestle.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_chopboard"] = {
    ["name"] = "dh_hr_chopboard",
    ["label"] = "Chopboard",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_chopboard.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_scales"] = {
    ["name"] = "dh_hr_scales",
    ["label"] = "Scales",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_scales.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_knife"] = {
    ["name"] = "dh_hr_knife",
    ["label"] = "Knife",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_knife.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_tiger_2"] = {
    ["name"] = "dh_hr_tiger_2",
    ["label"] = "Tiger 2",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_tiger_2.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_shoe_box"] = {
    ["name"] = "dh_hr_shoe_box",
    ["label"] = "Shoe Box",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_shoe_box.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_laptop"] = {
    ["name"] = "dh_hr_laptop",
    ["label"] = "Laptop",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_laptop.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_hard_disc"] = {
    ["name"] = "dh_hr_hard_disc",
    ["label"] = "Hard Disc",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_hard_disc.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_luggage"] = {
    ["name"] = "dh_hr_luggage",
    ["label"] = "Luggage",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_luggage.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_doll_2"] = {
    ["name"] = "dh_hr_doll_2",
    ["label"] = "Doll 2",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_doll_2.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_drone"] = {
    ["name"] = "dh_hr_drone",
    ["label"] = "Drone",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_drone.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_shovel"] = {
    ["name"] = "dh_hr_shovel",
    ["label"] = "Shovel",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_shovel.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_desk_lamp"] = {
    ["name"] = "dh_hr_desk_lamp",
    ["label"] = "Desk Lamp",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_desk_lamp.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_tablet"] = {
    ["name"] = "dh_hr_tablet",
    ["label"] = "Tablet",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_tablet.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_statue"] = {
    ["name"] = "dh_hr_statue",
    ["label"] = "Statue",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_statue.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_shirt"] = {
    ["name"] = "dh_hr_shirt",
    ["label"] = "Shirt",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_shirt.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_umbrella"] = {
    ["name"] = "dh_hr_umbrella",
    ["label"] = "Umbrella",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_umbrella.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_bong"] = {
    ["name"] = "dh_hr_bong",
    ["label"] = "Bong",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_bong.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_clock"] = {
    ["name"] = "dh_hr_clock",
    ["label"] = "Clock",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_clock.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_statue_2"] = {
    ["name"] = "dh_hr_statue_2",
    ["label"] = "Statue 2",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_statue_2.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_perfume"] = {
    ["name"] = "dh_hr_perfume",
    ["label"] = "Perfume",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_perfume.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_shave_box"] = {
    ["name"] = "dh_hr_shave_box",
    ["label"] = "Shave Box",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_shave_box.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_bed_dog"] = {
    ["name"] = "dh_hr_bed_dog",
    ["label"] = "Bed Dog",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_bed_dog.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_statue_3"] = {
    ["name"] = "dh_hr_statue_3",
    ["label"] = "Statue 3",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_statue_3.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_statue_4"] = {
    ["name"] = "dh_hr_statue_4",
    ["label"] = "Statue 4",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_statue_4.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_radio"] = {
    ["name"] = "dh_hr_radio",
    ["label"] = "Radio",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_radio.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_pc"] = {
    ["name"] = "dh_hr_pc",
    ["label"] = "PC",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_pc.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_monitor"] = {
    ["name"] = "dh_hr_monitor",
    ["label"] = "Monitor",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_monitor.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_keyboard"] = {
    ["name"] = "dh_hr_keyboard",
    ["label"] = "Keyboard",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_keyboard.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_mouse"] = {
    ["name"] = "dh_hr_mouse",
    ["label"] = "Mouse",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_mouse.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_trophy"] = {
    ["name"] = "dh_hr_trophy",
    ["label"] = "Trophy",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_trophy.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_bike"] = {
    ["name"] = "dh_hr_bike",
    ["label"] = "Bike",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_bike.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_guitar"] = {
    ["name"] = "dh_hr_guitar",
    ["label"] = "Guitar",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_guitar.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_remote"] = {
    ["name"] = "dh_hr_remote",
    ["label"] = "Remote",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_remote.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_mug"] = {
    ["name"] = "dh_hr_mug",
    ["label"] = "Mug",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_mug.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_golf"] = {
    ["name"] = "dh_hr_golf",
    ["label"] = "Golf",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_golf.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_bottle"] = {
    ["name"] = "dh_hr_bottle",
    ["label"] = "Bottle",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_bottle.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_statue_5"] = {
    ["name"] = "dh_hr_statue_5",
    ["label"] = "Statue 5",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_statue_5.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_rope"] = {
    ["name"] = "dh_hr_rope",
    ["label"] = "Rope",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_rope.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_speaker"] = {
    ["name"] = "dh_hr_speaker",
    ["label"] = "Speaker",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_speaker.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_sarcophagus"] = {
    ["name"] = "dh_hr_sarcophagus",
    ["label"] = "Sarcophagus",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_sarcophagus.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_pot"] = {
    ["name"] = "dh_hr_pot",
    ["label"] = "Pot",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_pot.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_toaster"] = {
    ["name"] = "dh_hr_toaster",
    ["label"] = "Toaster",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_toaster.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_bike_2"] = {
    ["name"] = "dh_hr_bike_2",
    ["label"] = "Bike 2",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_bike_2.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_basket"] = {
    ["name"] = "dh_hr_basket",
    ["label"] = "Basket",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_basket.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_plunger"] = {
    ["name"] = "dh_hr_plunger",
    ["label"] = "Plunger",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_plunger.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_scales_2"] = {
    ["name"] = "dh_hr_scales_2",
    ["label"] = "Scales 2",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_scales_2.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_teapot"] = {
    ["name"] = "dh_hr_teapot",
    ["label"] = "Teapot",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_teapot.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_toilet_bag"] = {
    ["name"] = "dh_hr_toilet_bag",
    ["label"] = "Toilet Bag",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_toilet_bag.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_necklace"] = {
    ["name"] = "dh_hr_necklace",
    ["label"] = "Necklace",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_necklace.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_luggage_2"] = {
    ["name"] = "dh_hr_luggage_2",
    ["label"] = "Luggage 2",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_luggage_2.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_wheel"] = {
    ["name"] = "dh_hr_wheel",
    ["label"] = "Wheel",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_wheel.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_brush_pot"] = {
    ["name"] = "dh_hr_brush_pot",
    ["label"] = "Brush Pot",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_brush_pot.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["dh_hr_tool_box"] = {
    ["name"] = "dh_hr_tool_box",
    ["label"] = "Tool Box",
    ["weight"] = 0,
    ["type"] = "item",
    ["image"] = "dh_hr_tool_box.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},

}
