Thanks for purchasing my script!
Please remember:
   - You're not allowed to resell, share, or redistribute this script in any way.
   - Full Terms of Service: tkscripts.com/tos

Requirements:
   - es_extended / qb-core / qbox
   - mysql-async / oxmysql
   - Strecher Model (https://www.lcpdfr.com/downloads/dev-resources/vehicle-parts/51552-dev-stryker-stretcher-dev/)
   - Wheelchair Model (https://www.gta5-mods.com/vehicles/wheelchair-add-on-sp-fivem)

Installing the script:
   1. Download the file and extract "tk_ambulancejob" into your resources folder
   2. Add "start tk_ambulancejob" into your server.cfg file
   3. Import the SQL file(s) into your server's database
   4. Edit config.lua to your liking
   5. Restart your server

More questions?
   - Join our Discord and open a ticket: https://discord.gg/YndnF9tkqu
   - Check out our documentation: https://tk-scripts.gitbook.io/docs


Items (ox_inventory):
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


Items (qb-inventory):
	bandage = {name = 'bandage', label = 'Bandage', weight = 50, type = 'item', image = 'bandage.png', unique = false, useable = true, shouldClose = true},
	ifak = {name = 'ifak', label = 'IFAK', weight = 200, type = 'item', image = 'ifak.png', unique = false, useable = true, shouldClose = true},
	tourniquet = {name = 'tourniquet', label = 'Tourniquet', weight = 100, type = 'item', image = 'tourniquet.png', unique = false, useable = true, shouldClose = true},
	gauze = {name = 'gauze', label = 'Gauze', weight = 50, type = 'item', image = 'gauze.png', unique = false, useable = true, shouldClose = true},
	burn_gel = {name = 'burn_gel', label = 'Burn Gel', weight = 100, type = 'item', image = 'burn_gel.png', unique = false, useable = true, shouldClose = true},
	surgical_kit = {name = 'surgical_kit', label = 'Surgical Kit', weight = 500, type = 'item', image = 'surgical_kit.png', unique = false, useable = true, shouldClose = true},
	saline_bag = {name = 'saline_bag', label = 'Saline Bag', weight = 300, type = 'item', image = 'saline_bag.png', unique = false, useable = true, shouldClose = true},
	leg_brace = {name = 'leg_brace', label = 'Leg Brace', weight = 300, type = 'item', image = 'leg_brace.png', unique = false, useable = true, shouldClose = true},
	arm_brace = {name = 'arm_brace', label = 'Arm Brace', weight = 300, type = 'item', image = 'arm_brace.png', unique = false, useable = true, shouldClose = true},
	body_brace = {name = 'body_brace', label = 'Body Brace', weight = 1000, type = 'item', image = 'body_brace.png', unique = false, useable = true, shouldClose = true},
	neck_brace = {name = 'neck_brace', label = 'Neck Brace', weight = 300, type = 'item', image = 'neck_brace.png', unique = false, useable = true, shouldClose = true},
	ice_pack = {name = 'ice_pack', label = 'Ice Pack', weight = 150, type = 'item', image = 'ice_pack.png', unique = false, useable = true, shouldClose = true},
	painkillers = {name = 'painkillers', label = 'Painkillers', weight = 50, type = 'item', image = 'painkillers.png', unique = false, useable = true, shouldClose = true},
	defibrillator = {name = 'defibrillator', label = 'Defibrillator', weight = 1000, type = 'item', image = 'defibrillator.png', unique = false, useable = true, shouldClose = true},
	adrenaline_syringe = {name = 'adrenaline_syringe', label = 'Adrenaline Syringe', weight = 100, type = 'item', image = 'adrenaline_syringe.png', unique = false, useable = true, shouldClose = true},
	wheelchair = {name = 'wheelchair', label = 'Wheelchair', weight = 2500, type = 'item', image = 'wheelchair.png', unique = true, useable = true, shouldClose = true},
	walking_stick = {name = 'walking_stick', label = 'Walking Stick', weight = 1000, type = 'item', image = 'walking_stick.png', unique = true, useable = true, shouldClose = true},
	med_bag = {name = 'med_bag', label = 'Medical Bag', weight = 500, type = 'item', image = 'med_bag.png', unique = true, useable = true, shouldClose = true},
	body_bag = {name = 'body_bag', label = 'Body Bag', weight = 500, type = 'item', image = 'body_bag.png', unique = false, useable = true, shouldClose = true},
	ecg = {name = 'ecg', label = 'ECG Monitor', weight = 1000, type = 'item', image = 'ecg.png', unique = false, useable = false, shouldClose = false},

