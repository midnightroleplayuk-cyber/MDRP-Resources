Thanks for purchasing my script!
Please remember:
   - You're not allowed to resell, share, or redistribute this script in any way.
   - Full Terms of Service: tkscripts.com/tos

Requirements:
   - es_extended / qb-core / qbox
   - mysql-async / oxmysql
   - By default for cuff minigames: bl_ui (https://github.com/Byte-Labs-Studio/bl_ui)

Installing the script:
   1. Download the file and extract "tk_policejob" into your resources folder
   2. Add "start tk_policejob" into your server.cfg file
   3. Import the SQL file(s) into your server's database
   4. Edit config.lua to your liking
   5. Restart your server

More questions?
   - Join our Discord and open a ticket: https://discord.gg/YndnF9tkqu
   - Check out our documentation: https://tk-scripts.gitbook.io/docs


Items (ox_inventory):
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

Items (qb-inventory):
	cone = {name = 'cone', label = 'Cone', weight = 100, type = 'item', image = 'cone.png', unique = false, useable = true, shouldClose = true},
	barrier = {name = 'barrier', label = 'Barrier', weight = 100, type = 'item', image = 'barrier.png', unique = false, useable = true, shouldClose = true},
	worklight = {name = 'worklight', label = 'Worklight', weight = 100, type = 'item', image = 'worklight.png', unique = false, useable = true, shouldClose = true},
	spike_strips = {name = 'spike_strips', label = 'Spike Strips', weight = 100, type = 'item', image = 'spike_strips.png', unique = false, useable = true, shouldClose = true},
	speed_camera = {name = 'speed_camera', label = 'Speed Camera', weight = 1000, type = 'item', image = 'speed_camera.png', unique = false, useable = true, shouldClose = true},
	breathalyzer = {name = 'breathalyzer', label = 'Breathalyzer', weight = 100, type = 'item', image = 'breathalyzer.png', unique = false, useable = true, shouldClose = true},
	fingerprint_scanner = {name = 'fingerprint_scanner', label = 'Fingerprint Scanner', weight = 100, type = 'item', image = 'fingerprint_scanner.png', unique = false, useable = true, shouldClose = true},
	handcuffs = {name = 'handcuffs', label = 'Handcuffs', weight = 100, type = 'item', image = 'handcuffs.png', unique = false, useable = true, shouldClose = true},
	bodycam = {name = 'bodycam', label = 'Bodycam', weight = 100, type = 'item', image = 'bodycam.png', unique = false, useable = true, shouldClose = true},
	dash_cam = {name = 'dash_cam', label = 'Dashcam', weight = 100, type = 'item', image = 'dash_cam.png', unique = false, useable = true, shouldClose = true},
	glass_riot_shield = {name = 'glass_riot_shield', label = 'Glass Riot Shield', weight = 1000, type = 'item', image = 'glass_riot_shield.png', unique = false, useable = true, shouldClose = true},
	metal_riot_shield = {name = 'metal_riot_shield', label = 'Metal Riot Shield', weight = 1000, type = 'item', image = 'metal_riot_shield.png', unique = false, useable = true, shouldClose = true},
	night_vision_goggles = {name = 'night_vision_goggles', label = 'Night Vision Goggles', weight = 250, type = 'item', image = 'night_vision_goggles.png', unique = false, useable = true, shouldClose = true},
	thermal_vision_goggles = {name = 'thermal_vision_goggles', label = 'Thermal Vision Goggles', weight = 250, type = 'item', image = 'thermal_vision_goggles.png', unique = false, useable = true, shouldClose = true},

