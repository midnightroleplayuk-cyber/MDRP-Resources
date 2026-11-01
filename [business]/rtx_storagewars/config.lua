Config = {}

Config.Framework = "standalone"  -- types (standalone, qbcore, esx)

Config.ESXFramework = {
	newversion = true, -- use this if you using new esx version (if you get error with old esxsharedobjectmethod in console)
	getsharedobject = "esx:getSharedObject",
	resourcename = "es_extended"
}

Config.StorageWarsDifferentInterior = false -- enable this function if you are using a different interior

Config.StorageWarsInteriorCoords = {coords = vector3(1212.25900000, -3155.32100000, 10.34871000), doorhash = -1065701939} -- change these coordinates if you are using a different interior, the coordinates must be the coordinates of the interior inside.

Config.QBCoreFrameworkResourceName = "qb-core" -- qb-core resource name, change this if you have different name of main resource of qbcore

Config.InterfaceColor = "#7c22b8" -- change interface color, color must be in hex

Config.Language = "English" -- text language from code (English)

Config.Target = true -- enable this if you want use target

Config.Targettype = "oxtarget" -- types - qtarget, qbtarget, oxtarget

Config.TargetSystemsNames = {qtarget = "qtarget", qbtarget = "qb-target", oxtarget = "ox_target"}

Config.TargetIcons = {registericon = "fa-solid fa-bars-progress", searchicon = "fa-solid fa-magnifying-glass", lockicon = "fa-solid fa-lock"} 

Config.StorageWarsInteractionSystem = 1 -- 1 == Our custom interact system, 2 == 3D Text Interact, 3 == Gta V Online Interaction Style

Config.StorageWarsAuctionRegisterLocation = {coords = vector3(1215.63, -3200.93, 6.44), distance = 2.5} -- location for register in the auction

Config.StorageWarsAuctionRegisterKey = "E" -- storage wars key for register

Config.StorageWarsAuctionRegisterFee = 100 -- Auction registration fee

Config.StorageWarsStartTime = 1 -- the time after which the storage auction is activate (in minutes)

Config.StorageWarsWaitingTime = 1 -- the time after which the storage auction is started (in minutes)

Config.StorageWarsFirstBidWaitingTime = 60 -- the time to wait for the first bid, if the timer expires and no one bids, the auction will be cancelled. (in seconds)

Config.StorageWarsBidWaitingTime = 15 -- the time to wait for the next bid, if the timer expires and no one bids, the auction will be ended. (in seconds)

Config.StorageWarsStatsHideTime = 5000 -- the time to wait for hide end stats of auction (in miliseconds)

Config.StorageWarsSearchTime = 120 -- the time the player has to search the lockers. (in seconds)

Config.StorageWarsWinnerMarker = {enabled = true, markercolor = {r = 255, g = 102, b = 255}, markersize = {x = 0.25, y = 0.25, z = 0.25}, markertype = 29}

Config.StorageWarsBidKey = "F" -- storage wars key for bid

Config.StorageWarsCustomBidKey = "G" -- storage wars key for custom bid

Config.StorageWarsSearchKey = "E" -- storage wars key for custom bid

Config.StorageWarsLockerCloseKey = "G" -- storage wars key for close locker

Config.StorageWarsSearchDistance = 4.0 -- distance for search

Config.StorageWarsSearchTimeProgress = 5 -- (in seconds)

Config.StorageWarsLockerCloseDistance = 1.25 -- distance for close locker

Config.StorageWarsActivationAtSpecificTime = false -- turn this feature on if you want the auction to start at a specific time, this is real time not in-game time. (you set the times in Config.StorageWarsActivationsTimes)

Config.StorageWarsRegistrationOnlyForPeopleWithPermission = false -- enable this feature if you want only people who have a permissio to join the auction, you can set this in other.lua. (for example add_ace identifier.steam:11000013cc73739 "storagewars.register" allow)

Config.StorageWarsStartOnlyViaCommand = false -- enable this function if you want to enable storage wars only via /startstoragewars command permissions for this command can be set in other.lua

Config.StorageWarsBidAnimation = {animdict = "friends@fra@ig_1", animname = "over_here_idle_a"} -- to change the bidding animation

Config.StorageWarsMinimumPlayers = 2 -- minimum number of players to start the auction

Config.StorageWarsBlip = {
	enabled = true, -- enable this if you want display blip on map
	blipiconid = 50, -- icon type
	blipdisplay = 4, -- icon display
	blipcolor = 3, -- icon color
	blipshortrange = true, -- icon range
	blipscale = 1.0, -- icon scale
	bliptext = "Storage Wars", -- text of blip
	blipcoords = vector3(1214.54, -3180.6, 9.58),
}	

Config.StorageWarsActivationsTimes = {
	{hour = 15, minute = 00}, -- The auction will start automatically at 15:00 real time
	{hour = 20, minute = 20}, -- The auction will start automatically at 20:20 real time
}

Config.Storages = { -- dont change anything here (only if you want use storage wars on different map)
	[1] = {
		doorcoords = vector3(1229.993, -3197.914, 4.833544),
		npcpos = {coords = vector3(1231.2989501953, -3196.3107910156, 4.5280919075012), heading = 216.90914916992},
		searchcoords = vector3(1227.26, -3197.97, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,
	},
	[2] = {
		doorcoords = vector3(1229.993, -3190.23, 4.503903),
		npcpos = {coords = vector3(1231.3629150391, -3188.8107910156, 4.5280919075012), heading = 236.62576293945},
		searchcoords = vector3(1227.65, -3190.16, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},	
	[3] = {
		doorcoords = vector3(1229.993, -3182.548, 4.503903),
		npcpos = {coords = vector3(1231.4578857422, -3181.1340332031, 4.5280919075012), heading = 180.27674865723},
		searchcoords = vector3(1227.57, -3182.57, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},	
	[4] = {
		doorcoords = vector3(1229.993, -3194.072, 7.139107),
		npcpos = {coords = vector3(1230.6137695313, -3191.8247070313, 7.1684141159058), heading = 233.4898223877},
		searchcoords = vector3(1227.55, -3193.99, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},	
	[5] = {
		doorcoords = vector3(1229.993, -3186.389, 7.235034),
		npcpos = {coords = vector3(1230.6597900391, -3188.4946289063, 7.1684141159058), heading = 340.92178344727},
		searchcoords = vector3(1227.73, -3186.28, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},	
	[6] = {
		doorcoords = vector3(1229.993, -3178.706, 7.137117),
		npcpos = {coords = vector3(1230.6229248047, -3181.3386230469, 7.168417930603), heading = 315.26983642578},
		searchcoords = vector3(1227.38, -3178.66, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},			
	[7] = {
		doorcoords = vector3(1223.919921875, -3178.7067871094, 4.4962248802185),
		npcpos = {coords = vector3(1223.0955810547, -3177.0710449219, 4.5280842781067), heading = 137.21318054199},
		searchcoords = vector3(1226.21, -3178.76, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},
	[8] = {
		doorcoords = vector3(1223.9173583984, -3186.3898925781, 4.4967799186707),
		npcpos = {coords = vector3(1222.9322509766, -3184.5307617188, 4.5280838012695), heading = 144.57591247559},
		searchcoords = vector3(1226.4, -3186.36, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},	
	[9] = {
		doorcoords = vector3(1223.9173583984, -3194.0729980469, 4.4967799186707),
		npcpos = {coords = vector3(1222.9885253906, -3192.2421875, 4.5280981063843), heading = 136.29995727539},
		searchcoords = vector3(1226.64, -3194.07, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},	
	[10] = {
		doorcoords = vector3(1223.9173583984, -3182.5485839844, 7.1391072273254),
		npcpos = {coords = vector3(1223.248046875, -3180.4909667969, 7.1684093475342), heading = 129.94177246094},
		searchcoords = vector3(1225.89, -3182.52, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},
	[11] = {
		doorcoords = vector3(1223.9173583984, -3190.2314453125, 7.1479411125183),
		npcpos = {coords = vector3(1223.2895507813, -3188.3103027344, 7.1684217453003), heading = 122.31195831299},
		searchcoords = vector3(1226.15, -3190.15, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},
	[12] = {
		doorcoords = vector3(1223.9173583984, -3197.9145507813, 7.9630899429321),
		npcpos = {coords = vector3(1223.2612304688, -3195.7775878906, 7.1684188842773), heading = 116.38111877441},
		searchcoords = vector3(1226.6, -3197.75, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},
	[13] = {
		doorcoords = vector3(1214.3758544922, -3190.3422851563, 5.6171426773071),
		npcpos = {coords = vector3(1216.1658935547, -3189.7299804688, 4.5280842781067), heading = 27.118465423584},
		searchcoords = vector3(1214.32, -3193.28, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},
	[14] = {
		doorcoords = vector3(1214.3768310547, -3196.41796875, 7.1581358909607),
		npcpos = {coords = vector3(1216.1414794922, -3196.8901367188, 7.1684112548828), heading = 169.82025146484},
		searchcoords = vector3(1214.44, -3194.04, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},
	[15] = {
		doorcoords = vector3(1214.3768310547, -3183.0124511719, 4.4990620613098),
		npcpos = {coords = vector3(1216.0809326172, -3183.7456054688, 4.528085231781), heading = 115.03742980957},
		searchcoords = vector3(1214.32, -3180.07, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},
	[16] = {
		doorcoords = vector3(1214.3758544922, -3176.9367675781, 8.5987243652344),
		npcpos = {coords = vector3(1216.2087402344, -3176.3486328125, 7.168417930603), heading = 21.577724456787},
		searchcoords = vector3(1214.37, -3179.41, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,		
	},
	[17] = {
		doorcoords = vector3(1232.7830810547, -3177.4995117188, 7.6271924972534),
		npcpos = {coords = vector3(1232.3741455078, -3175.5693359375, 7.1684103012085), heading = 121.02425384521},
		searchcoords = vector3(1235.87, -3177.55, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[18] = {
		doorcoords = vector3(1236.8920898438, -3185.6928710938, 4.4987697601318),
		npcpos = {coords = vector3(1238.6584472656, -3186.1662597656, 4.5280914306641), heading = 153.05674743652},
		searchcoords = vector3(1236.82, -3182.65, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[19] = {
		doorcoords = vector3(1228.0672607422, -3171.3120117188, 4.5039029121399),
		npcpos = {coords = vector3(1226.0441894531, -3171.9057617188, 4.5280923843384), heading = 189.55763244629},
		searchcoords = vector3(1228.09, -3168.33, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[20] = {
		doorcoords = vector3(1223.9509277344, -3171.3120117188, 4.5058927536011),
		npcpos = {coords = vector3(1222.1936035156, -3171.8852539063, 4.5280904769897), heading = 196.67977905273},
		searchcoords = vector3(1223.99, -3168.46, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[21] = {
		doorcoords = vector3(1219.7489013672, -3171.3120117188, 4.5108137130737),
		npcpos = {coords = vector3(1221.4857177734, -3171.9060058594, 4.5280904769897), heading = 165.02995300293},
		searchcoords = vector3(1219.75, -3168.53, 3.57),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[22] = {
		doorcoords = vector3(1229.9930419922, -3169.3879394531, 7.1437935829163),
		npcpos = {coords = vector3(1230.4210205078, -3167.529296875, 7.1684112548828), heading = 241.05123901367},
		searchcoords = vector3(1227.04, -3169.32, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[23] = {
		doorcoords = vector3(1229.9930419922, -3165.5466308594, 7.1572160720825),
		npcpos = {coords = vector3(1230.5028076172, -3163.8046875, 7.1684112548828), heading = 251.99328613281},
		searchcoords = vector3(1226.99, -3165.65, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[24] = {
		doorcoords = vector3(1229.9930419922, -3161.705078125, 7.1391072273254),
		npcpos = {coords = vector3(1230.5650634766, -3159.8503417969, 7.1684141159058), heading = 232.24789428711},
		searchcoords = vector3(1226.88, -3161.67, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[25] = {
		doorcoords = vector3(1217.8250732422, -3161.7060546875, 7.1417603492737),
		npcpos = {coords = vector3(1217.2716064453, -3159.7219238281, 7.1684141159058), heading = 121.38903808594},
		searchcoords = vector3(1220.99, -3161.74, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[26] = {
		doorcoords = vector3(1217.822265625, -3165.5473632813, 7.1391072273254),
		npcpos = {coords = vector3(1217.2503662109, -3163.7177734375, 7.1684141159058), heading = 117.95469665527},
		searchcoords = vector3(1221.09, -3165.66, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},
	[27] = {
		doorcoords = vector3(1217.822265625, -3169.3889160156, 7.1423687934875),
		npcpos = {coords = vector3(1217.4693603516, -3167.5368652344, 7.1684141159058), heading = 104.89720153809},
		searchcoords = vector3(1221.09, -3165.66, 6.21),
		storagetype = "",
		unlocked = false,
		sold = false,			
	},		
}

Config.StorageType = {
	["a"] = { -- type 1
		minimumbid = 1000, -- minimum start bid for this type of storage
		defaultbid = 500, -- default bid for this type of storage
		minimumitemsinstorage = 5, -- minimum items in storage
		maximumitemsinstorage = 10, -- maximum items in storage
		randomitems = {
			{
				itemlabel = "Remote Control", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "tvremote", -- item name
				itemcount = 1, -- item count
				
			},
			{
				itemlabel = "Neons Kit", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "neonkit", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Radio", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "carradio", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Knife", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "weapon", -- types - (item, event)
				itemname = "weapon_knife", -- item name
				itemcount = 1, -- item count
				
			},				
			{
				itemlabel = "Phone", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "nokia", -- item name
				itemcount = 1, -- item count
				
			},
			{
				itemlabel = "Television", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "vehicletv", -- item name
				itemcount = 1, -- item count
				
			},		
			{
				itemlabel = "Inflatable", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "inflatable", -- item name
				itemcount = 1, -- item count
				
			},					
			{
				itemlabel = "Fireworks", 
				itemrare = "legendary", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "fireworks_rocket", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Pistol", 
				itemrare = "legendary", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "weapon_pistol", -- item name
				itemcount = 1, -- item count
				
			},				
		},
	},
	["b"] = {
		minimumbid = 1000, -- minimum start bid for this type of storage
		defaultbid = 500, -- default bid for this type of storage
		minimumitemsinstorage = 5, -- minimum items in storage
		maximumitemsinstorage = 10, -- maximum items in storage
		randomitems = {
			{
				itemlabel = "Remote Control", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "tvremote", -- item name
				itemcount = 1, -- item count
				
			},
			{
				itemlabel = "Neons Kit", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "neonkit", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Radio", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "carradio", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Knife", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "weapon", -- types - (item, event)
				itemname = "weapon_knife", -- item name
				itemcount = 1, -- item count
				
			},				
			{
				itemlabel = "Phone", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "nokia", -- item name
				itemcount = 1, -- item count
				
			},
			{
				itemlabel = "Television", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "vehicletv", -- item name
				itemcount = 1, -- item count
				
			},		
			{
				itemlabel = "Inflatable", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "inflatable", -- item name
				itemcount = 1, -- item count
				
			},					
			{
				itemlabel = "Fireworks", 
				itemrare = "legendary", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "fireworks_rocket", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Pistol", 
				itemrare = "legendary", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "weapon_pistol", -- item name
				itemcount = 1, -- item count
				
			},				
		},	
	},	
	["c"] = {
		minimumbid = 1000, -- minimum start bid for this type of storage
		defaultbid = 500, -- default bid for this type of storage
		minimumitemsinstorage = 5, -- minimum items in storage
		maximumitemsinstorage = 10, -- maximum items in storage
		randomitems = {
			{
				itemlabel = "Remote Control", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "tvremote", -- item name
				itemcount = 1, -- item count
				
			},
			{
				itemlabel = "Neons Kit", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "neonkit", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Radio", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "carradio", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Knife", 
				itemrare = "normal", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "weapon", -- types - (item, event)
				itemname = "weapon_knife", -- item name
				itemcount = 1, -- item count
				
			},				
			{
				itemlabel = "Phone", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "nokia", -- item name
				itemcount = 1, -- item count
				
			},
			{
				itemlabel = "Television", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "vehicletv", -- item name
				itemcount = 1, -- item count
				
			},		
			{
				itemlabel = "Inflatable", 
				itemrare = "special", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "inflatable", -- item name
				itemcount = 1, -- item count
				
			},					
			{
				itemlabel = "Fireworks", 
				itemrare = "legendary", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "fireworks_rocket", -- item name
				itemcount = 1, -- item count
				
			},	
			{
				itemlabel = "Pistol", 
				itemrare = "legendary", -- types  (normal, special, legendary) (normal = 70%, special = 25%, legendary = 5%)
				itemtype = "item", -- types - (item, event)
				itemname = "weapon_pistol", -- item name
				itemcount = 1, -- item count
				
			},				
		},	
	},	
}

Config.ItemTypesPercentage = { -- (you can't define percentages for the normal type, as it is calculated from the rest of the other types.)
	["legendary"] = 5, -- percentage for legendary type
	["special"] = 25, -- percentage for special type
}


Config.PlayerLoadedEvent = { -- load methods of water wctivities
	esx = "esx:playerLoaded", 
	qbcore = "QBCore:Client:OnPlayerLoaded",
	standalone = "playerLoaded",
	customevent = true, -- enable this if you dont want load water wctivities after player loaded to server. (enable this for example for servers with multicharacter)
	standaloneevent = false, -- enable this if you dont want load water wctivities after player loaded to server. (for standalone version)
}

function DrawText3D(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords()) 
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 240
		DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 255, 102, 255, 150)
	end
end


function Notify(text)
	exports["rtx_notify"]:Notify("Storage Wars", text, 5000, "info") -- if you get error in this line its because you dont use our notify system buy it here https://rtx.tebex.io/package/5402098 or you can use some other notify system just replace this notify line with your notify system
	--exports["mythic_notify"]:SendAlert("inform", text, 5000)
end
