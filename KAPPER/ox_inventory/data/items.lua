return {
	-- ═════════════════════════════════════════════════════
	-- APEX SCRATCHCARDS — auto-added. Item names match
	-- apex_scratchcards' shared/config.lua (usable-item callbacks
	-- are registered by the resource itself; no server.export needed).
	-- Images live in ox_inventory/web/images/.
	-- ═════════════════════════════════════════════════════
	['scratch_green'] = { label = 'Green Bingo Scratchcard', weight = 10, stack = true, close = true, description = 'Match 3 identical symbols to win.', client = { image = 'scratch_green.png' } },
	['scratch_blue'] = { label = 'Blue Bingo Scratchcard', weight = 10, stack = true, close = true, description = 'Match 3 identical symbols to win.', client = { image = 'scratch_blue.png' } },
	['scratch_diamond'] = { label = 'Dollars Diamond Scratchcard', weight = 10, stack = true, close = true, description = 'Match 3 identical amounts to win that amount.', client = { image = 'scratch_diamond.png' } },
	['scratch_symbols'] = { label = 'The Scratcher', weight = 10, stack = true, close = true, description = 'Find 3 copies of the shown symbol.', client = { image = 'scratch_symbols.png' } },
	['scratch_lucky7'] = { label = 'Lucky Sevens Scratchcard', weight = 10, stack = true, close = true, description = 'Match a winning number — lucky 7 pays double.', client = { image = 'scratch_lucky7.png' } },
	['scratch_gold'] = { label = 'Golden Fortune Scratchcard', weight = 10, stack = true, close = true, description = 'Reveal a prize and multiply it up to 10×.', client = { image = 'scratch_gold.png' } },
	['scratch_blackjack'] = { label = 'Scratch 21', weight = 10, stack = true, close = true, description = 'Beat the dealer without going over 21.', client = { image = 'scratch_blackjack.png' } },
	['scratch_vault'] = { label = 'The Vault Scratchcard', weight = 10, stack = true, close = true, description = 'Crack the 3-digit code to open the vault.', client = { image = 'scratch_vault.png' } },
	['lottery_ticket'] = { label = 'Lottery Ticket', weight = 10, stack = true, close = true, description = 'Pick your numbers and join the shared prize pool.', client = { image = 'lottery_ticket.png' } },

	-- ═════════════════════════════════════════════════════
	-- APEX HUNTING — auto-added. Item names match apex_hunting’s
	-- shared/config.lua. Images live in ox_inventory/web/images/.
	-- Rifles are DEFAULT GTA WEAPONS (weapon_musket, weapon_sniperrifle,
	-- weapon_marksmanrifle, weapon_heavysniper) — already in weapons.lua,
	-- so only ammo + game + junk are registered here. Ammo (rifle_ammo)
	-- is consumed per hunt by the apex server; its icon reuses the
	-- bundled ammo-rifle.png so no custom art is needed.
	-- ═════════════════════════════════════════════════════
	['rifle_ammo'] = { label = 'Rifle Ammo', weight = 25, stack = true, close = false, client = { image = 'ammo-rifle.png' } },

	-- Game (animals)
	['game_rabbit'] = { label = 'Rabbit', weight = 1500, stack = true, close = false, client = { image = 'game_rabbit.png' } },
	['game_hare'] = { label = 'Hare', weight = 1800, stack = true, close = false, client = { image = 'game_hare.png' } },
	['game_pheasant'] = { label = 'Pheasant', weight = 1200, stack = true, close = false, client = { image = 'game_pheasant.png' } },
	['game_squirrel'] = { label = 'Squirrel', weight = 600, stack = true, close = false, client = { image = 'game_squirrel.png' } },
	['game_boar'] = { label = 'Wild Boar', weight = 12000, stack = true, close = false, client = { image = 'game_boar.png' } },
	['game_coyote'] = { label = 'Coyote', weight = 9000, stack = true, close = false, client = { image = 'game_coyote.png' } },
	['game_fox'] = { label = 'Red Fox', weight = 7000, stack = true, close = false, client = { image = 'game_fox.png' } },
	['game_deer'] = { label = 'Deer', weight = 18000, stack = true, close = false, client = { image = 'game_deer.png' } },
	['game_elk'] = { label = 'Elk', weight = 22000, stack = true, close = false, client = { image = 'game_elk.png' } },
	['game_goat'] = { label = 'Mountain Goat', weight = 14000, stack = true, close = false, client = { image = 'game_goat.png' } },
	['game_blackbear'] = { label = 'Black Bear', weight = 30000, stack = true, close = false, client = { image = 'game_blackbear.png' } },
	['game_grizzly'] = { label = 'Grizzly Bear', weight = 38000, stack = true, close = false, client = { image = 'game_grizzly.png' } },
	['game_stag'] = { label = 'White Stag', weight = 20000, stack = true, close = false, client = { image = 'game_stag.png' } },
	['game_cougar'] = { label = 'Cougar', weight = 16000, stack = true, close = false, client = { image = 'game_cougar.png' } },
	['game_bison'] = { label = 'Great Bison', weight = 60000, stack = true, close = false, client = { image = 'game_bison.png' } },
	['game_sasquatch'] = { label = 'Sasquatch', weight = 90000, stack = true, close = false, client = { image = 'game_sasquatch.png' } },

	-- Junk / finds
	['broken_arrow'] = { label = 'Broken Arrow', weight = 150, stack = true, close = false, client = { image = 'broken_arrow.png' } },
	['animal_bone'] = { label = 'Animal Bone', weight = 200, stack = true, close = false, client = { image = 'animal_bone.png' } },
	['tattered_pelt'] = { label = 'Tattered Pelt', weight = 300, stack = true, close = false, client = { image = 'tattered_pelt.png' } },
	['old_trap'] = { label = 'Rusty Trap', weight = 900, stack = true, close = false, client = { image = 'old_trap.png' } },
	['hidden_stash'] = { label = 'Buried Stash', weight = 3500, stack = false, close = false, client = { image = 'hidden_stash.png' } },
	['gold_nugget'] = { label = 'Gold Nugget', weight = 100, stack = true, close = false, client = { image = 'gold_nugget.png' } },

	-- ═══════════════════════════════════════════════════════════
	-- APEX FISHING — auto-added. Item names match apex_fishing's
	-- shared/config.lua. Images live in ox_inventory/web/images/.
	-- Rods use the apex_fishing.StartCast export and consume = 0 so
	-- they are NOT removed when used (bait is consumed per cast by
	-- the apex server instead).
	-- ═══════════════════════════════════════════════════════════
	['fishing_bait'] = { label = 'Fishing Bait', weight = 30, stack = true, close = false, client = { image = 'fishing_bait.png' } },

	['fishing_rod_basic']  = { label = 'Basic Rod',  weight = 250, stack = false, consume = 0, close = true, client = { image = 'fishing_rod_basic.png',  export = 'apex_fishing.StartCast' } },
	['fishing_rod_pro']    = { label = 'Pro Rod',    weight = 280, stack = false, consume = 0, close = true, client = { image = 'fishing_rod_pro.png',    export = 'apex_fishing.StartCast' } },
	['fishing_rod_carbon'] = { label = 'Carbon Rod', weight = 300, stack = false, consume = 0, close = true, client = { image = 'fishing_rod_carbon.png', export = 'apex_fishing.StartCast' } },
	['fishing_rod_master'] = { label = 'Master Rod', weight = 320, stack = false, consume = 0, close = true, client = { image = 'fishing_rod_master.png', export = 'apex_fishing.StartCast' } },

	['fish_sardine']    = { label = 'Sardine',      weight =   150, stack = true, close = true, client = { image = 'fish_sardine.png' } },
	['fish_anchovy']    = { label = 'Anchovy',      weight =   120, stack = true, close = true, client = { image = 'fish_anchovy.png' } },
	['fish_mackerel']   = { label = 'Mackerel',     weight =   400, stack = true, close = true, client = { image = 'fish_mackerel.png' } },
	['fish_herring']    = { label = 'Herring',      weight =   350, stack = true, close = true, client = { image = 'fish_herring.png' } },
	['fish_bass']       = { label = 'Sea Bass',     weight =  1400, stack = true, close = true, client = { image = 'fish_bass.png' } },
	['fish_trout']      = { label = 'Trout',        weight =  1200, stack = true, close = true, client = { image = 'fish_trout.png' } },
	['fish_salmon']     = { label = 'Salmon',       weight =  2200, stack = true, close = true, client = { image = 'fish_salmon.png' } },
	['fish_grouper']    = { label = 'Grouper',      weight =  5500, stack = true, close = true, client = { image = 'fish_grouper.png' } },
	['fish_tuna']       = { label = 'Bluefin Tuna', weight =  6500, stack = true, close = true, client = { image = 'fish_tuna.png' } },
	['fish_swordfish']  = { label = 'Swordfish',    weight =  9000, stack = true, close = true, client = { image = 'fish_swordfish.png' } },
	['fish_marlin']     = { label = 'Blue Marlin',  weight = 11000, stack = true, close = true, client = { image = 'fish_marlin.png' } },
	['fish_mahi']       = { label = 'Mahi-Mahi',    weight =  7500, stack = true, close = true, client = { image = 'fish_mahi.png' } },
	['fish_shark']      = { label = 'Tiger Shark',  weight = 25000, stack = true, close = true, client = { image = 'fish_shark.png' } },
	['fish_giantsquid'] = { label = 'Giant Squid',  weight = 18000, stack = true, close = true, client = { image = 'fish_giantsquid.png' } },
	['fish_leviathan']  = { label = 'Leviathan',    weight = 75000, stack = true, close = true, client = { image = 'fish_leviathan.png' } },
	['fish_kraken']     = { label = 'Young Kraken', weight = 95000, stack = true, close = true, client = { image = 'fish_kraken.png' } },

	['old_shoe']        = { label = 'Old Shoe',         weight =  200, stack = true,  close = true, client = { image = 'old_shoe.png' } },
	['tin_can']         = { label = 'Rusty Tin Can',    weight =  150, stack = true,  close = true, client = { image = 'tin_can.png' } },
	['plastic_bottle']  = { label = 'Plastic Bottle',   weight =   80, stack = true,  close = true, client = { image = 'plastic_bottle.png' } },
	['seaweed']         = { label = 'Tangled Seaweed',  weight =  100, stack = true,  close = true, client = { image = 'seaweed.png' } },
	['money_briefcase'] = { label = 'Sunken Briefcase', weight = 3500, stack = false, close = true, client = { image = 'money_briefcase.png' } },
	['rolex_watch']     = { label = 'Antique Watch',    weight =  100, stack = true,  close = true, client = { image = 'rolex_watch.png' } },
	-- ═══════════════════════ END APEX FISHING ══════════════════

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

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['cleaning_kit'] = {
		label = 'Cleaning Kit',
		weight = 200,
		stack = true,
		close = true,
		description = 'Industrial detergent and solvents used to fuel a laundromat money-laundering machine.',
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

	['identification'] = {
		label = 'Identification',
		client = {
			image = 'card_id.png'
		}
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
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
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

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
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

	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		client = {
			image = 'card_bank.png'
		}
	},

	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},

	["alive_chicken"] = {
		label = "Living chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["blowpipe"] = {
		label = "Blowtorch",
		weight = 2,
		stack = true,
		close = true,
	},

	["bread"] = {
		label = "Bread",
		weight = 1,
		stack = true,
		close = true,
	},

	["burncream"] = {
		label = "Burn Cream",
		weight = 1,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Cannabis",
		weight = 3,
		stack = true,
		close = true,
	},

	["carokit"] = {
		label = "Body Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["carotool"] = {
		label = "Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Cloth",
		weight = 1,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Copper",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Cut wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["defib"] = {
		label = "Defibrillator",
		weight = 1,
		stack = true,
		close = true,
	},

	["diamond"] = {
		label = "Diamond",
		weight = 1,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "Gas",
		weight = 1,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Fabric",
		weight = 1,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Fish",
		weight = 1,
		stack = true,
		close = true,
	},

	["fixkit"] = {
		label = "Repair Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "Repair Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "Gas Bottle",
		weight = 2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Gold",
		weight = 1,
		stack = true,
		close = true,
	},

	["icepack"] = {
		label = "Ice Pack",
		weight = 1,
		stack = true,
		close = true,
	},

	["iron"] = {
		label = "Iron",
		weight = 1,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},

	["medbag"] = {
		label = "Medical Bag",
		weight = 1,
		stack = true,
		close = true,
	},

	["medikit"] = {
		label = "Medikit",
		weight = 2,
		stack = true,
		close = true,
	},

	["packaged_chicken"] = {
		label = "Chicken fillet",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Packaged wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Processed oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["sedative"] = {
		label = "Sedative",
		weight = 1,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Slaughtered chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["stone"] = {
		label = "Stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["stretcher"] = {
		label = "Foldable Stretcher",
		weight = 1,
		stack = true,
		close = true,
	},

	["suturekit"] = {
		label = "Suture Kit",
		weight = 1,
		stack = true,
		close = true,
	},

	["tweezers"] = {
		label = "Tweezers",
		weight = 1,
		stack = true,
		close = true,
	},

	["washed_stone"] = {
		label = "Washed stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Wool",
		weight = 1,
		stack = true,
		close = true,
	},
		["remote"] = {
		label = "Remote",
		weight = 1,
		stack = true,
		close = true,
	},

	-- ====================================================
	-- Apex Backpack (RecordKit) — containers & lock items
	-- Image filenames must exist in ox_inventory/web/images
	-- ====================================================
	['apex_backpack_scout'] = {
		label = 'Scout Backpack', weight = 1000, stack = false, close = true, consume = 0,
		description = 'A tactical backpack. Use it to open its storage.',
		client = { image = 'apex_backpack_scout.png', export = 'apex_backpack.openContainer' },
	},
	['apex_backpack_ranger'] = {
		label = 'Ranger Backpack', weight = 1200, stack = false, close = true, consume = 0,
		description = 'A tactical backpack. Use it to open its storage.',
		client = { image = 'apex_backpack_ranger.png', export = 'apex_backpack.openContainer' },
	},
	['apex_backpack_raider'] = {
		label = 'Raider Backpack', weight = 1400, stack = false, close = true, consume = 0,
		description = 'A tactical backpack. Use it to open its storage.',
		client = { image = 'apex_backpack_raider.png', export = 'apex_backpack.openContainer' },
	},
	['apex_backpack_nomad'] = {
		label = 'Nomad Backpack', weight = 1500, stack = false, close = true, consume = 0,
		description = 'A tactical backpack. Use it to open its storage.',
		client = { image = 'apex_backpack_nomad.png', export = 'apex_backpack.openContainer' },
	},
	['apex_backpack_operator'] = {
		label = 'Operator Backpack', weight = 1800, stack = false, close = true, consume = 0,
		description = 'A tactical backpack. Use it to open its storage.',
		client = { image = 'apex_backpack_operator.png', export = 'apex_backpack.openContainer' },
	},
	['apex_wallet'] = {
		label = 'Wallet', weight = 150, stack = false, close = true, consume = 0,
		description = 'Holds your cash and documents only.',
		client = { image = 'wallet.png', export = 'apex_backpack.openContainer' },
	},
	['apex_padlock'] = {
		label = 'Combination Padlock', weight = 200, stack = true, close = true, consume = 0,
		description = 'Use it on a backpack to protect it with a PIN.',
		client = { image = 'apex_padlock.png', export = 'apex_backpack.usePadlock' },
	},
	['apex_fingerprint'] = {
		label = 'Biometric Lock', weight = 200, stack = true, close = true, consume = 0,
		description = 'Use it on a backpack to lock it to your fingerprint.',
		client = { image = 'apex_fingerprint.png', export = 'apex_backpack.useFingerprint' },
	},
	['obd_tablet'] = {
    label = 'OBD-II Tablet',
    weight = 1500,
    stack = false, close = true,
    client = { export = 'apex_obd.UseTablet' },

	},
['spy_tablet'] = {
        label = 'Spy Tablet',
        description = 'Secure surveillance operations tablet.',
        weight = 1200,
        stack = false,
        close = true,
        consume = 0,
        server = {
            export = 'blackrock_spy.useSpyTablet'
        }
    },
['hidden_mic'] = {
        label = 'Hidden Microphone',
        description = 'Concealed audio surveillance device.',
        weight = 200,
        stack = true,
        close = true,
        consume = 0,
        server = {
            export = 'blackrock_spy.useHiddenMic'
        }
    },

    -- ═══════════════════════════════════════════════════════════
    -- APEX SCAMMER — auto-added. Names match apex_scammer Config.items.
    -- 'laptop' & 'printer' are useable (trigger the resource); the rest
    -- are crafting inputs / sellable goods used inside the laptop UI.
    -- ═══════════════════════════════════════════════════════════
    ['laptop'] = {
        label = 'Laptop',
        description = 'A lightweight machine for... off-book work.',
        weight = 2200,
        stack = false,
        close = true,
    },
    ['printer'] = {
        label = 'Portable Printer',
        description = 'Set it down anywhere and print.',
        weight = 5000,
        stack = false,
        close = true,
    },
    ['msr'] = {
        label = 'MSR Swiper',
        description = 'Reads and writes magnetic stripes.',
        weight = 600,
        stack = false,
        close = true,
    },
    ['burnerphone'] = {
        label = 'Burner Phone',
        description = 'Untraceable. For now.',
        weight = 400,
        stack = true,
        close = true,
    },
    ['blank'] = {
        label = 'Blank Card',
        description = 'An empty plastic card.',
        weight = 20,
        stack = true,
        close = false,
    },
    ['ccard'] = {
        label = 'Cloned Card',
        description = 'A freshly written clone.',
        weight = 20,
        stack = true,
        close = false,
    },
    ['checkpaper'] = {
        label = 'Check Paper',
        description = 'Security paper for printing checks.',
        weight = 10,
        stack = true,
        close = false,
    },
    ['fcheck'] = {
        label = 'Forged Check',
        description = 'Looks real enough.',
        weight = 10,
        stack = true,
        close = false,
    },
    ['simcard'] = {
        label = 'SIM Card',
        description = 'A blank carrier SIM.',
        weight = 10,
        stack = true,
        close = false,
    },
    ['sim'] = {
        label = 'Swapped SIM',
        description = 'Someone else\'s number, now yours.',
        weight = 10,
        stack = true,
        close = false,
    },
    ['phishkit'] = {
        label = 'Phishing Kit',
        description = 'Spoofed templates and a bulk mailer.',
        weight = 300,
        stack = true,
        close = true,
    },
    ['stolendata'] = {
        label = 'Stolen Data',
        description = 'A bundle of harvested identities.',
        weight = 10,
        stack = true,
        close = false,
    },

    -- ─── apex_gangs ───────────────────────────────────────
    ['spraycan'] = {
        label = 'Spray Can',
        description = 'Tag walls with your gang colours.',
        weight = 400,
        stack = true,
        close = true,
        client = { export = 'apex_gangs.useSprayItem' },
    },
    ['spray_remover'] = {
        label = 'Spray Remover',
        description = 'Scrub rival tags off the wall.',
        weight = 500,
        stack = true,
        close = true,
    },
    ['gang_supplies'] = {
        label = 'Gang Supplies',
        description = 'Crew supplies.',
        weight = 1000,
        stack = true,
        close = false,
    },
    ['weapon_parts'] = {
        label = 'Weapon Parts',
        description = 'Spare weapon parts.',
        weight = 800,
        stack = true,
        close = false,
    },

	-- ─── Elevate Banking / Billing ───────────────────────────
	['elevate_atm_card'] = {
		label = 'Elevate Debit Card',
		weight = 5,
		stack = false,
		close = true,
		image = 'elevate_atm_card.png',
		description = 'A debit card linked to an Elevate Bank account. Required to use any ATM.',
		client = {
			event = 'elevate_banking:client:useCard',
			anim = { dict = 'mp_common', clip = 'givetake1_a' },
		},
	},

	['elevate_invoice'] = {
		label = 'Invoice',
		weight = 5,
		stack = false,
		close = true,
		description = 'A printed invoice. Inspect it to view details and pay.',
		client = {
			export = 'elevate_billing.useInvoice',
		},
	},

	['elevate_printer'] = {
		label = 'Invoice Printer',
		weight = 1200,
		stack = false,
		close = true,
		description = 'Required to issue invoices.',
	},

	['atm_receipt'] = {
		label = 'ATM Receipt',
		weight = 100,
		stack = false,
		close = true,
		image = 'atm_receipt.png',
		description = 'A printed receipt from the ATM.',
		server = { export = 'elevate_banking.use_atm_receipt' },
	},

}
