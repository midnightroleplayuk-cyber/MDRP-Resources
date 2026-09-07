--? For support, join our Discord server: https://discord.gg/jAnEnyGBef

return {
	Framework = "qbox", -- Options: "esx", "qbox", "qbcore", "custom", or "auto" (auto-detects avaible options)
	Locale = "en", -- Options: "en", "de"
	DebugMode = "prod", -- Options: "prod" (minimal logs), "dev" (detailed logs), false (disable logs)

	EnableSounds = true, -- Plays sounds when interacting with the shop interface
	ImagePath = "nui://ox_inventory/web/images/", -- Path to the item images --? Local folder: "item_images/"
	WeaponAsItem = true, -- Treat weapons as items

	Shops = {
		["shop"] = {
			PointRadius = 25.0, -- The radius within which markers, peds, and other game elements related to the shop are displayed

			Locations = {
				vector4(372.8008, 328.1116, 103.5665, 262.1354), -- Clinton Ave
				vector4(2555.5110, 380.7313, 108.6229, 0.9597), -- Palomino Ave
				vector4(-3040.5376, 583.9359, 7.9089, 17.7445), -- Inseno Road
				vector4(-3243.9229, 1000.0519, 12.8307, 0.7583), -- Barbareno Rd
				vector4(-2193.4412, 4290.1064, 49.1743, 63.6331), -- Great Ocean Hwy
				vector4(1959.1536, 3741.4165, 32.3437, 298.7749), -- Niland Ave
				vector4(2676.5083, 3280.1863, 55.2411, 335.5104), -- Senora Fwy
				vector4(1728.5699, 6416.7671, 35.0372, 243.3380), -- Senora Fwy 2
				vector4(1134.2589, -983.0569, 46.4158, 278.9547), -- El Rancho Blvd
				vector4(-1221.4543, -908.0496, 12.3263, 36.5340), -- San Andreas Ave
				vector4(-1486.7350, -377.5593, 40.1634, 132.9464), -- Prosperity St
				vector4(-2966.3162, 391.5883, 15.0433, 86.4455), -- Great Ocean Hwy
				vector4(24.5062, -1345.5989, 29.4970, 263.3659), -- Inoccence Blvd
				vector4(-561.7218, 286.8480, 82.1765, 266.4413), -- Milton Rd
				vector4(-47.2886, -1758.5280, 29.4210, 45.3676), -- Davis Ave
				vector4(1165.0068, -323.6485, 69.2051, 101.2836), -- West Mirrow Drive
				vector4(-706.0665, -914.6005, 19.2156, 82.3892), -- Palomino Ave
				vector4(-1819.4907, 793.5951, 138.0846, 132.5959), -- Banham Canyon Dr
				vector4(549.2471, 2669.6699, 42.1565, 96.9846), -- Route 68
				vector4(1392.0671, 3606.1155, 34.9809, 203.5101), -- Algonquin Blvd
				vector4(1984.2482, 3054.3589, 47.2151, 240.0611), -- Panorama Dr
			},

			--? For icons, use Iconify: https://icon-sets.iconify.design
			Categories = {
				{ name = "All Products", type = "all", icon = "ic:round-clear-all" }, --! Required for all shops
				{ name = "Food", type = "food", icon = "mdi:food-drumstick" },
				{ name = "Drinks", type = "drinks", icon = "ion:water-sharp" },
				--{ name = "Electronics", type = "electronics", icon = "ic:round-phone-iphone" },
				--{ name = "Tools", type = "tools", icon = "ion:hammer" },
				--{ name = "Healing", type = "healing", icon = "material-symbols:healing" },
			},

			Items = {
				-- Food
				--{ name = "fries", label = "Fries", category = "food", price = 30 },
				{ name = "burger", label = "Burger", category = "food", price = 40 },
				--{ name = "burger_chicken", label = "Chicken Burger", category = "food", price = 50 },

				-- Drinks
				{ name = "water", label = "Water Bottle", category = "drinks", price = 25 },
				{ name = "sprunk", label = "Sprunk Can", category = "drinks", price = 35 },
				--{ name = "WEAPON_PETROLCAN", label = "Petrol Can", category = "drinks", price = 35 },

				-- Electronics
				--{ name = "radio", label = "Radio", category = "electronics", price = 300 },
				--{ name = "phone", label = "Phone", category = "electronics", price = 800 },
				--{ name = "usb_black", label = "USB", category = "electronics", price = 10000 },

				-- Tools
				{ name = "kq_weed_bag_empty", label = "Empty Baggie", category = "all", price = 1 },
				--{ name = "ziptie", label = "Zip tie", category = "tools", price = 150 },
				--{ name = "paperbag", label = "Paper bag", category = "tools", price = 200 },

				-- Healing
				--{ name = "weed", label = "Weed", category = "healing", price = 15 },
				--{ name = "bandage", label = "Bandage", category = "healing", price = 50 },
				--{ name = "medikit", label = "Medikit", category = "healing", price = 200 },
			},

			Requirement = {
				Job = {
					required = false, -- Whether a job is required to access the shop
					jobs = {
						{
							label = "Police", -- The display name of the required job
							name = "police", -- The name of the required job
							grade = 0, -- Minimum job grade required to access the shop
						},
					},
				},
				License = {
					required = false, -- Whether a license is required to access the shop
					buyDialog = true, -- Displays a dialog prompting the player to purchase the required license
					label = "Weapon License", -- The display name of the required license
					type = "weapon", -- The type of the required license (e.g., "weapon")
					price = 1000, -- The cost of the license
				},
			},

			Locales = { --? More locales including the currency symbol, button text and more can be found in "locales/"
				MainHeader = {
					title = "Shop",
					tag = "24/7",
					description = "Welcome to your local market, where we're always here for you, day or night!\nExplore a curated selection of premium goods, tailored to meet your every need.",
				},
				CartHeader = {
					title = "Shopping",
					tag = "Cart",
					description = "Review your chosen items and proceed to secure, easy\ncheckout with multiple payment options.",
				},
			},

			Blip = {
				enabled = true, -- If true, displays a map blip for the shop locations
				name = "Shop [24/7]", -- Name displayed on the map
				sprite = 59, -- Blip icon type --? Reference: https://docs.fivem.net/docs/game-references/blips
				color = 0, -- Blip color --? Reference: https://docs.fivem.net/docs/game-references/blips/#blip-colors
				scale = 0.7, -- Size of the blip
			},

			Indicator = {
				Ped = {
					enabled = true, -- If true, spawns a ped (NPC) at the locations
					model = `mp_m_shopkeep_01`, -- Ped model type --? Reference: https://docs.fivem.net/docs/game-references/ped-models
					scenario = "WORLD_HUMAN_AA_SMOKE", -- Animation scenario for the ped --? Reference: https://github.com/DioneB/gtav-scenarios
				},
				Marker = {
					enabled = false, -- If true, displays a marker at the shop locations
					type = 20, -- Marker type --? Reference: https://docs.fivem.net/docs/game-references/markers
					size = vec3(0.7, 0.7, 0.7), -- Size of the marker
					color = { 65, 133, 235, 120 }, -- RGBA color of the marker
					bobUpAndDown = false, -- If true, marker moves up and down
					faceCamera = false, -- If true, marker faces the player's camera
					rotate = true, -- If true, marker rotates
				},
			},

			Interaction = {
				OpenKey = 3, -- Default: 38 (E key) --? Reference: https://docs.fivem.net/docs/game-references/controls

				HelpText = {
					enabled = false, -- If true, displays floating help text near the interaction point
					distance = 2.5, -- Distance within which help text appears and is interactable
				},
				FloatingText = {
					enabled = false, -- If true, displays floating text above the shop NPC
					distance = 2.5, -- Distance within which floating text is visible and interactable
				},
				Target = { -- Uses ox_target by default --? (modifiable in config/functions.lua)
					enabled = true, -- If true, enables targeting system
					boxZoneSize = vec3(4, 4, 4), -- Size of the target zone
					drawSprite = true, -- If true, displays a sprite for the target zone
					distance = 2.5, -- Interaction distance
				},
			},
		},

		["Phone_Shop"] = {
			PointRadius = 25.0,

			Locations = {
				vector4(85.427, -225.704, 54.628, 75.238),
			},

			Categories = {
				{ name = "All Products", type = "all", icon = "ic:round-clear-all" },
				{ name = "Phones", type = "Phones", icon = "mdi:phone" },
			},

			Items = {
				-- Phones
				{ name = "phone", label = "LB Phone", category = "Phones", price = 600 },
			
			},

			Requirement = {
				Job = {
					required = false,
					jobs = {
						{
							label = "Police",
							name = "police",
							grade = 0,
						},
						{
							label = "Sheriff",
							name = "sheriff",
							grade = 0,
						},
					},
				},
				License = {
					required = false,
					buyDialog = false,
					label = "Weapon License",
					type = "weapon",
					price = 1000,
				},
			},

			Locales = {
				MainHeader = {
					title = "Phone Store",
					tag = "MN Electronics",
					description = "Welcome to your local electronics shop, where we're always here for you, day or night!\nExplore a curated selection of premium goods, tailored to meet your every need.",
				},
				CartHeader = {
					title = "Shopping",
					tag = "Cart",
					description = "Review your chosen items and proceed to secure, easy\ncheckout with multiple payment options.",
				},
			},

			Blip = {
				enabled = true,
				name = "MN Electronics",
				sprite = 110,
				color = 0,
				scale = 0.7,
			},

			Indicator = {
				Ped = {
					enabled = false,
					model = `mp_m_weapexp_01`,
					scenario = "WORLD_HUMAN_GUARD_STAND",
				},
				Marker = {
					enabled = false,
					type = 20,
					size = vec3(0.7, 0.7, 0.7),
					color = { 65, 133, 235, 120 },
					bobUpAndDown = false,
					faceCamera = false,
					rotate = true,
				},
			},

			Interaction = {
				OpenKey = 3,

				HelpText = {
					enabled = true,
					distance = 2.5,
				},
				FloatingText = {
					enabled = false,
					distance = 2.5,
				},
				Target = {
					enabled = true,
					boxZoneSize = vec3(4, 4, 4),
					drawSprite = true,
					distance = 2.5,
				},
			},
		},
	},
}
