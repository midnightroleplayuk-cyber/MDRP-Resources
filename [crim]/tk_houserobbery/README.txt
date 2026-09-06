Hey! Thanks for purchasing my script. Remember:
   - You are not allowed to resell or release my scripts

Requirements:
   - es_extended / qb-core / qbox
   - By default for minigames (you can edit the minigames in client/main_editable.lua):
     - bl_ui: https://github.com/Byte-Labs-Studio/bl_ui
	 - pd-safe: https://github.com/VHall1/pd-safe

Installing the script:
   1. Download the file and extract "tk_houserobbery" into your resources folder
   2. Add "start tk_houserobbery" into your server.cfg file
   3. Edit config.lua to your liking
   4. Restart your server

More questions?
   - Join our Discord and open a ticket: https://discord.gg/YndnF9tkqu
   - Check out our documentation: https://tk-scripts.gitbook.io/docs


Items (ox_inventory):
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


Items (qb-inventory):
   silver_coin = {name = 'silver_coin', label = 'Silver Coin', weight = 50, type = 'item', image = 'silver_coin.png', unique = false, useable = false},
   gold_coin = {name = 'gold_coin', label = 'Gold Coin', weight = 50, type = 'item', image = 'gold_coin.png', unique = false, useable = false},
   charlotte_ring = {name = 'charlotte_ring', label = 'Charlotte Ring', weight = 50, type = 'item', image = 'charlotte_ring.png', unique = false, useable = false},
   simbolos_chain = {name = 'simbolos_chain', label = 'Simbolos Chain', weight = 100, type = 'item', image = 'simbolos_chain.png', unique = false, useable = false},
   action_figure = {name = 'action_figure', label = 'Action Figure', weight = 100, type = 'item', image = 'action_figure.png', unique = false, useable = false},
   nominos_ring = {name = 'nominos_ring', label = 'Nominos Ring', weight = 50, type = 'item', image = 'nominos_ring.png', unique = false, useable = false},
   boss_chain = {name = 'boss_chain', label = 'Boss Chain', weight = 200, type = 'item', image = 'boss_chain.png', unique = false, useable = false},
   branded_cigarette = {name = 'branded_cigarette', label = 'Branded Cigarette', weight = 10, type = 'item', image = 'branded_cigarette.png', unique = false, useable = false},
   branded_cigarette_box = {name = 'branded_cigarette_box', label = 'Branded Cigarette Box', weight = 200, type = 'item', image = 'branded_cigarette_box.png', unique = false, useable = false},
   ninja_figure = {name = 'ninja_figure', label = 'Ninja Figure', weight = 50, type = 'item', image = 'ninja_figure.png', unique = false, useable = false},
   painting = {name = 'painting', label = 'Painting', weight = 100, type = 'item', image = 'painting.png', unique = false, useable = false},
   statue = {name = 'statue', label = 'Statue', weight = 200, type = 'item', image = 'statue.png', unique = false, useable = false},
   ancient_egypt_artifact = {name = 'ancient_egypt_artifact', label = 'Ancient Egypt Artifact', weight = 200, type = 'item', image = 'ancient_egypt_artifact.png', unique = false, useable = false},
   ruby = {name = 'ruby', label = 'Ruby', weight = 100, type = 'item', image = 'ruby.png', unique = false, useable = false},
   diamond = {name = 'diamond', label = 'Diamond', weight = 100, type = 'item', image = 'diamond.png', unique = false, useable = false},
   danburite = {name = 'danburite', label = 'Danburite', weight = 100, type = 'item', image = 'danburite.png', unique = false, useable = false},
   television = {name = 'television', label = 'Television', weight = 5000, type = 'item', image = 'television.png', unique = true, useable = false},
   coffee_machine = {name = 'coffee_machine', label = 'Coffee Machine', weight = 1000, type = 'item', image = 'coffee_machine.png', unique = true, useable = false},
   computer = {name = 'computer', label = 'Computer', weight = 2500, type = 'item', image = 'computer.png', unique = true, useable = false},
   microwave = {name = 'microwave', label = 'Microwave', weight = 3500, type = 'item', image = 'microwave.png', unique = true, useable = false},
   music_player = {name = 'music_player', label = 'Music Player', weight = 2000, type = 'item', image = 'music_player.png', unique = true, useable = false},
   lockpick = {name = 'lockpick', label = 'Lockpick', weight = 10, type = 'item', image = 'lockpick.png', unique = false, useable = false},
   cutter = {name = 'cutter', label = 'Cutter', weight = 1000, type = 'item', image = 'cutter.png', unique = false, useable = false},


