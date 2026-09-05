Thanks for purchasing my script!
Please remember:
   - You're not allowed to resell, share, or redistribute this script in any way.
   - Full Terms of Service: tkscripts.com/tos

Requirements:
   - es_extended / qb-core / qbox
   - mysql-async / oxmysql

Installing the script:
   1. Download the file and extract "tk_evidence" into your resources folder
   2. Add "start tk_evidence" into your server.cfg file
   3. Import the SQL file(s) into your server's database
   4. Edit config.lua to your liking
   5. Restart your server

More questions?
   - Join our Discord and open a ticket: https://discord.gg/YndnF9tkqu
   - Check out our documentation: https://tk-scripts.gitbook.io/docs

ox_inventory items:
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

qb-inventory items:
   	gsr_cloth = {name = 'gsr_cloth', label = "GSR Cloth", weight = 100, type = 'item', image = 'gsr_cloth.png', unique = false, useable = true},
	gsr_test_kit = {name = 'gsr_test_kit', label = "GSR Test Kit", weight = 100, type = 'item', image = 'gsr_test_kit.png', unique = false, useable = true},
	uv_light = {name = 'uv_light', label = "UV Flashlight", weight = 250, type = 'item', image = 'uv_light.png', unique = false, useable = true},
	evidence_camera = {name = 'evidence_camera', label = "Evidence Camera", weight = 500, type = 'item', image = 'evidence_camera.png', unique = false, useable = true},
	fingerprint_scanner = {name = 'fingerprint_scanner', label = "Fingerprint Scanner", weight = 250, type = 'item', image = 'fingerprint_scanner.png', unique = false, useable = true},
	bullet_casing = {name = 'bullet_casing', label = "Bullet Casing", weight = 1, type = 'item', image = 'bullet_casing.png', unique = true},
	bullet_fragment = {name = 'bullet_fragment', label = "Bullet Fragment", weight = 1, type = 'item', image = 'bullet_fragment.png', unique = true},
	blood_sample = {name = 'blood_sample', label = "Blood Sample", weight = 1, type = 'item', image = 'blood_sample.png', unique = true},
	fingerprint = {name = 'fingerprint', label = "Fingerprint Sample", weight = 1, type = 'item', image = 'fingerprint.png', unique = true},
	evidence = {name = 'evidence', label = "Evidence", weight = 1, type = 'item', image = 'evidence.png', unique = true},
	bullet_hole = {name = 'bullet_hole', label = "Impact Sample", weight = 1, type = 'item', image = 'bullet_hole.png', unique = true},