const tabTitles = { 'player': 'Self Actions', 'jobs': 'Job Management', 'online': 'Online Players', 'spawner': 'Vehicle Spawner', 'owned': 'Owned Vehicles', 'customize': 'Vehicle Customize', 'world': 'Vehicle Cheats', 'aimbot': 'Combat - Aimbot', 'players': 'Combat - ESP', 'misc': 'Settings', 'weapons': 'Weapon Menu', 'keybinds': 'Keybind Manager' };
let allJobs = [];
let currentJob = null;
let jobTargetPlayer = null;

const vehicles = {
    super: [
        { name: 'Adder', model: 'adder' }, { name: 'Autarch', model: 'autarch' }, { name: 'Banshee 900R', model: 'banshee2' },
        { name: 'Bullet', model: 'bullet' }, { name: 'Cheetah', model: 'cheetah' }, { name: 'Cyclone', model: 'cyclone' },
        { name: 'Deveste Eight', model: 'deveste' }, { name: 'Emerus', model: 'emerus' }, { name: 'Entity XF', model: 'entityxf' },
        { name: 'Entity XXR', model: 'entity2' }, { name: 'FMJ', model: 'fmj' }, { name: 'GP1', model: 'gp1' },
        { name: 'Itali GTO', model: 'italigto' }, { name: 'Itali RSX', model: 'italirsx' }, { name: 'Krieger', model: 'krieger' },
        { name: 'Nero', model: 'nero' }, { name: 'Nero Custom', model: 'nero2' }, { name: 'Osiris', model: 'osiris' },
        { name: 'Penetrator', model: 'penetrator' }, { name: 'Reaper', model: 'reaper' }, { name: 'RE-7B', model: 're7b' },
        { name: 'S80RR', model: 's80' }, { name: 'SC1', model: 'sc1' }, { name: 'Scramjet', model: 'scramjet' },
        { name: 'Sultan RS', model: 'sultanrs' }, { name: 'T20', model: 't20' }, { name: 'Taipan', model: 'taipan' },
        { name: 'Tempesta', model: 'tempesta' }, { name: 'Tezeract', model: 'tezeract' }, { name: 'Thrax', model: 'thrax' },
        { name: 'Turismo R', model: 'turismor' }, { name: 'Tyrant', model: 'tyrant' }, { name: 'Tyrus', model: 'tyrus' },
        { name: 'Vacca', model: 'vacca' }, { name: 'Vagner', model: 'vagner' }, { name: 'Visione', model: 'visione' },
        { name: 'Voltic', model: 'voltic' }, { name: 'X80 Proto', model: 'prototipo' }, { name: 'XA-21', model: 'xa21' },
        { name: 'Zentorno', model: 'zentorno' }, { name: 'Zorrusso', model: 'zorrusso' }
    ],
    sports: [
        { name: '9F', model: 'ninef' }, { name: '9F Cabrio', model: 'ninef2' }, { name: 'Alpha', model: 'alpha' },
        { name: 'Banshee', model: 'banshee' }, { name: 'Bestia GTS', model: 'bestiagts' }, { name: 'Carbonizzare', model: 'carbonizzare' },
        { name: 'Comet', model: 'comet2' }, { name: 'Comet Retro', model: 'comet3' }, { name: 'Comet Safari', model: 'comet4' },
        { name: 'Comet SR', model: 'comet5' }, { name: 'Coquette', model: 'coquette' }, { name: 'Elegy RH8', model: 'elegy2' },
        { name: 'Elegy Retro', model: 'elegy' }, { name: 'Feltzer', model: 'feltzer2' }, { name: 'Flash GT', model: 'flashgt' },
        { name: 'Furore GT', model: 'furoregt' }, { name: 'Fusilade', model: 'fusilade' }, { name: 'GB200', model: 'gb200' },
        { name: 'Hotring Sabre', model: 'hotring' }, { name: 'Imorgon', model: 'imorgon' }, { name: 'Jester', model: 'jester' },
        { name: 'Jester Classic', model: 'jester3' }, { name: 'Jester RR', model: 'jester4' }, { name: 'Khamelion', model: 'khamelion' },
        { name: 'Komoda', model: 'komoda' }, { name: 'Lynx', model: 'lynx' }, { name: 'Massacro', model: 'massacro' },
        { name: 'Neo', model: 'neo' }, { name: 'Neon', model: 'neon' }, { name: 'Omnis', model: 'omnis' },
        { name: 'Pariah', model: 'pariah' }, { name: 'Penumbra', model: 'penumbra' }, { name: 'Penumbra FF', model: 'penumbra2' },
        { name: 'Rapid GT', model: 'rapidgt' }, { name: 'Rapid GT Cabrio', model: 'rapidgt2' }, { name: 'Raptor', model: 'raptor' },
        { name: 'Revolter', model: 'revolter' }, { name: 'Ruston', model: 'ruston' }, { name: 'Schafter V12', model: 'schafter3' },
        { name: 'Schlagen GT', model: 'schlagen' }, { name: 'Seven-70', model: 'seven70' }, { name: 'Specter', model: 'specter' },
        { name: 'Sultan', model: 'sultan' }, { name: 'Sultan Classic', model: 'sultan2' }, { name: 'Surano', model: 'surano' },
        { name: 'Tropos Rallye', model: 'tropos' }, { name: 'Verlierer', model: 'verlierer2' }, { name: 'ZR350', model: 'zr350' }
    ],
    muscle: [
        { name: 'Blade', model: 'blade' }, { name: 'Buccaneer', model: 'buccaneer' }, { name: 'Buffalo', model: 'buffalo' },
        { name: 'Buffalo S', model: 'buffalo2' }, { name: 'Chino', model: 'chino' }, { name: 'Clique', model: 'clique' },
        { name: 'Coquette BlackFin', model: 'coquette3' }, { name: 'Deviant', model: 'deviant' }, { name: 'Dominator', model: 'dominator' },
        { name: 'Dominator GTX', model: 'dominator3' }, { name: 'Dukes', model: 'dukes' }, { name: 'Duke O Death', model: 'dukes2' },
        { name: 'Ellie', model: 'ellie' }, { name: 'Faction', model: 'faction' }, { name: 'Gauntlet', model: 'gauntlet' },
        { name: 'Gauntlet Classic', model: 'gauntlet3' }, { name: 'Gauntlet Hellfire', model: 'gauntlet4' }, { name: 'Hermes', model: 'hermes' },
        { name: 'Hotknife', model: 'hotknife' }, { name: 'Hustler', model: 'hustler' }, { name: 'Impaler', model: 'impaler' },
        { name: 'Imperator', model: 'imperator' }, { name: 'Lurcher', model: 'lurcher' }, { name: 'Moonbeam', model: 'moonbeam' },
        { name: 'Nightshade', model: 'nightshade' }, { name: 'Phoenix', model: 'phoenix' }, { name: 'Picador', model: 'picador' },
        { name: 'Pisswasser Dominator', model: 'dominator2' }, { name: 'Ratloader', model: 'ratloader' }, { name: 'Ruiner', model: 'ruiner' },
        { name: 'Sabre Turbo', model: 'sabregt' }, { name: 'Sacrificer', model: 'slamvan3' }, { name: 'Slam Van', model: 'slamvan' },
        { name: 'Stallion', model: 'stallion' }, { name: 'Tampa', model: 'tampa' }, { name: 'Tulip', model: 'tulip' },
        { name: 'Vamos', model: 'vamos' }, { name: 'Vigero', model: 'vigero' }, { name: 'Virgo', model: 'virgo' },
        { name: 'Voodoo', model: 'voodoo' }, { name: 'Yosemite', model: 'yosemite' }
    ],
    offroad: [
        { name: 'Brawler', model: 'brawler' }, { name: 'Dubsta 6x6', model: 'dubsta3' }, { name: 'Dune Buggy', model: 'dune' },
        { name: 'Everon', model: 'everon' }, { name: 'Freecrawler', model: 'freecrawler' }, { name: 'Guardian', model: 'guardian' },
        { name: 'Hellion', model: 'hellion' }, { name: 'Insurgent', model: 'insurgent' }, { name: 'Insurgent Pick-Up', model: 'insurgent2' },
        { name: 'Kalahari', model: 'kalahari' }, { name: 'Kamacho', model: 'kamacho' }, { name: 'Liberator', model: 'monster' },
        { name: 'Marshall', model: 'marshall' }, { name: 'Menacer', model: 'menacer' }, { name: 'Mesa', model: 'mesa' },
        { name: 'Nightshark', model: 'nightshark' }, { name: 'Outlaw', model: 'outlaw' }, { name: 'Patriot', model: 'patriot' },
        { name: 'Rancher XL', model: 'rancherxl' }, { name: 'Rebel', model: 'rebel' }, { name: 'Riata', model: 'riata' },
        { name: 'Sandking', model: 'sandking' }, { name: 'Sandking XL', model: 'sandking2' }, { name: 'Technical', model: 'technical' },
        { name: 'Trophy Truck', model: 'trophytruck' }, { name: 'Vagrant', model: 'vagrant' }, { name: 'Zhaba', model: 'zhaba' }
    ],
    motorcycle: [
        { name: 'Akuma', model: 'akuma' }, { name: 'Avarus', model: 'avarus' }, { name: 'Bagger', model: 'bagger' },
        { name: 'Bati 801', model: 'bati' }, { name: 'Bati 801RR', model: 'bati2' }, { name: 'BF400', model: 'bf400' },
        { name: 'Carbon RS', model: 'carbonrs' }, { name: 'Chimera', model: 'chimera' }, { name: 'Cliffhanger', model: 'cliffhanger' },
        { name: 'Daemon', model: 'daemon' }, { name: 'Defiler', model: 'defiler' }, { name: 'Deathbike', model: 'deathbike' },
        { name: 'Diablous', model: 'diablous' }, { name: 'Double T', model: 'double' }, { name: 'Enduro', model: 'enduro' },
        { name: 'Esskey', model: 'esskey' }, { name: 'Faggio', model: 'faggio' }, { name: 'Faggio Sport', model: 'faggio3' },
        { name: 'FCR 1000', model: 'fcr' }, { name: 'Gargoyle', model: 'gargoyle' }, { name: 'Hakuchou', model: 'hakuchou' },
        { name: 'Hakuchou Drag', model: 'hakuchou2' }, { name: 'Hexer', model: 'hexer' }, { name: 'Innovation', model: 'innovation' },
        { name: 'Lectro', model: 'lectro' }, { name: 'Manchez', model: 'manchez' }, { name: 'Nemesis', model: 'nemesis' },
        { name: 'Nightblade', model: 'nightblade' }, { name: 'Oppressor', model: 'oppressor' }, { name: 'Oppressor MK2', model: 'oppressor2' },
        { name: 'PCJ-600', model: 'pcj' }, { name: 'Ruffian', model: 'ruffian' }, { name: 'Sanchez', model: 'sanchez' },
        { name: 'Sanctus', model: 'sanctus' }, { name: 'Shinobi', model: 'shinobi' }, { name: 'Shotaro', model: 'shotaro' },
        { name: 'Sovereign', model: 'sovereign' }, { name: 'Stryder', model: 'stryder' }, { name: 'Thrust', model: 'thrust' },
        { name: 'Vader', model: 'vader' }, { name: 'Vindicator', model: 'vindicator' }, { name: 'Vortex', model: 'vortex' },
        { name: 'Wolfsbane', model: 'wolfsbane' }, { name: 'Zombie Bobber', model: 'zombiea' }, { name: 'Zombie Chopper', model: 'zombieb' }
    ],
    helicopter: [
        { name: 'Akula', model: 'akula' }, { name: 'Annihilator', model: 'annihilator' }, { name: 'Buzzard', model: 'buzzard' },
        { name: 'Buzzard Attack', model: 'buzzard2' }, { name: 'Cargobob', model: 'cargobob' }, { name: 'FH-1 Hunter', model: 'hunter' },
        { name: 'Frogger', model: 'frogger' }, { name: 'Havok', model: 'havok' }, { name: 'Maverick', model: 'maverick' },
        { name: 'Police Maverick', model: 'polmav' }, { name: 'Savage', model: 'savage' }, { name: 'Sea Sparrow', model: 'seasparrow' },
        { name: 'Skylift', model: 'skylift' }, { name: 'Sparrow', model: 'sparrow' }, { name: 'SuperVolito', model: 'supervolito' },
        { name: 'Swift', model: 'swift' }, { name: 'Swift Deluxe', model: 'swift2' }, { name: 'Valkyrie', model: 'valkyrie' },
        { name: 'Volatus', model: 'volatus' }
    ],
    plane: [
        { name: 'Alpha-Z1', model: 'alphaz1' }, { name: 'Avenger', model: 'avenger' }, { name: 'B-11 Strikeforce', model: 'strikeforce' },
        { name: 'Besra', model: 'besra' }, { name: 'Cargoplane', model: 'cargoplane' }, { name: 'Cuban 800', model: 'cuban800' },
        { name: 'Dodo', model: 'dodo' }, { name: 'Duster', model: 'duster' }, { name: 'Howard', model: 'howard' },
        { name: 'Hydra', model: 'hydra' }, { name: 'Lazer', model: 'lazer' }, { name: 'LF-22 Starling', model: 'starling' },
        { name: 'Luxor', model: 'luxor' }, { name: 'Luxor Deluxe', model: 'luxor2' }, { name: 'Mallard', model: 'stunt' },
        { name: 'Mammatus', model: 'mammatus' }, { name: 'Miljet', model: 'miljet' }, { name: 'Mogul', model: 'mogul' },
        { name: 'Nimbus', model: 'nimbus' }, { name: 'P-45 Nokota', model: 'nokota' }, { name: 'P-996 Lazer', model: 'lazer' },
        { name: 'Pyro', model: 'pyro' }, { name: 'Rogue', model: 'rogue' }, { name: 'Seabreeze', model: 'seabreeze' },
        { name: 'Shamal', model: 'shamal' }, { name: 'Titan', model: 'titan' }, { name: 'Tula', model: 'tula' },
        { name: 'Ultralight', model: 'microlight' }, { name: 'V-65 Molotok', model: 'molotok' }, { name: 'Velum', model: 'velum' },
        { name: 'Vestra', model: 'vestra' }, { name: 'Volatol', model: 'volatol' }
    ],
    military: [
        { name: 'APC', model: 'apc' }, { name: 'Barrage', model: 'barrage' }, { name: 'Chernobog', model: 'chernobog' },
        { name: 'Crusader', model: 'crusader' }, { name: 'Half-Track', model: 'halftrack' }, { name: 'Khanjali', model: 'khanjali' },
        { name: 'Rhino', model: 'rhino' }, { name: 'Scarab', model: 'scarab' }, { name: 'Stromberg', model: 'stromberg' },
        { name: 'Thruster', model: 'thruster' }, { name: 'TM-02 Khanjali', model: 'khanjali' }
    ],
    boat: [
        { name: 'Dinghy', model: 'dinghy' }, { name: 'Jetmax', model: 'jetmax' }, { name: 'Kraken', model: 'submersible2' },
        { name: 'Marquis', model: 'marquis' }, { name: 'Police Predator', model: 'predator' }, { name: 'Seashark', model: 'seashark' },
        { name: 'Speeder', model: 'speeder' }, { name: 'Squalo', model: 'squalo' }, { name: 'Submersible', model: 'submersible' },
        { name: 'Suntrap', model: 'suntrap' }, { name: 'Toro', model: 'toro' }, { name: 'Tropic', model: 'tropic' },
        { name: 'Tug', model: 'tug' }, { name: 'Yacht', model: 'yacht' }
    ],
    emergency: [
        { name: 'Ambulance', model: 'ambulance' }, { name: 'FBI', model: 'fbi' }, { name: 'FBI 2', model: 'fbi2' },
        { name: 'Fire Truck', model: 'firetruk' }, { name: 'Lifeguard', model: 'lguard' }, { name: 'Police', model: 'police' },
        { name: 'Police 2', model: 'police2' }, { name: 'Police 3', model: 'police3' }, { name: 'Police 4', model: 'police4' },
        { name: 'Police Bike', model: 'policeb' }, { name: 'Police Buffalo', model: 'policet' }, { name: 'Police Rancher', model: 'pranger' },
        { name: 'Police Roadcruiser', model: 'policeold1' }, { name: 'Police Riot', model: 'riot' }, { name: 'Police Van', model: 'policet' },
        { name: 'Sheriff', model: 'sheriff' }, { name: 'Sheriff 2', model: 'sheriff2' }, { name: 'Unmarked Cruiser', model: 'police4' }
    ]
};

const colors = ['#ff0000', '#ff4400', '#ff8800', '#ffcc00', '#ffff00', '#88ff00', '#00ff00', '#00ff88', '#00ffff', '#0088ff', '#0000ff', '#4400ff', '#8800ff', '#ff00ff', '#ff0088', '#ffffff', '#cccccc', '#888888', '#444444', '#000000', '#8b4513', '#daa520', '#ffd700', '#c0c0c0'];

let currentCategory = 'super';
let selectedPlayer = null;
let playerList = [];
let serverVehicles = null;
let weaponTargetPlayer = null;

// WEAPON DATA - All GTA V weapons with matching image files
const weaponList = {
    melee: [
        { name: "Knife", model: "WEAPON_KNIFE" }, { name: "Bat", model: "WEAPON_BAT" }, { name: "Crowbar", model: "WEAPON_CROWBAR" },
        { name: "Hammer", model: "WEAPON_HAMMER" }, { name: "Flashlight", model: "WEAPON_FLASHLIGHT" }, { name: "Golf Club", model: "WEAPON_GOLFCLUB" },
        { name: "Nightstick", model: "WEAPON_NIGHTSTICK" }, { name: "Hatchet", model: "WEAPON_HATCHET" }, { name: "Machete", model: "WEAPON_MACHETE" },
        { name: "Switchblade", model: "WEAPON_SWITCHBLADE" }, { name: "Battle Axe", model: "WEAPON_BATTLEAXE" }, { name: "Pool Cue", model: "WEAPON_POOLCUE" },
        { name: "Wrench", model: "WEAPON_WRENCH" }, { name: "Stone Hatchet", model: "WEAPON_STONE_HATCHET" }, { name: "Bottle", model: "WEAPON_BOTTLE" },
        { name: "Dagger", model: "WEAPON_DAGGER" }, { name: "Knuckle", model: "WEAPON_KNUCKLE" }, { name: "Candy Cane", model: "WEAPON_CANDYCANE" }
    ],
    handguns: [
        { name: "Pistol", model: "WEAPON_PISTOL" }, { name: "Pistol MK2", model: "WEAPON_PISTOL_MK2" }, { name: "Combat Pistol", model: "WEAPON_COMBATPISTOL" },
        { name: "AP Pistol", model: "WEAPON_APPISTOL" }, { name: "Pistol .50", model: "WEAPON_PISTOL50" }, { name: "SNS Pistol", model: "WEAPON_SNSPISTOL" },
        { name: "SNS Pistol MK2", model: "WEAPON_SNSPISTOL_MK2" }, { name: "Heavy Pistol", model: "WEAPON_HEAVYPISTOL" }, { name: "Vintage Pistol", model: "WEAPON_VINTAGEPISTOL" },
        { name: "Marksman Pistol", model: "WEAPON_MARKSMANPISTOL" }, { name: "Revolver", model: "WEAPON_REVOLVER" }, { name: "Revolver MK2", model: "WEAPON_REVOLVER_MK2" },
        { name: "Double Action", model: "WEAPON_DOUBLEACTION" }, { name: "Ceramic Pistol", model: "WEAPON_CERAMICPISTOL" }, { name: "Navy Revolver", model: "WEAPON_NAVYREVOLVER" },
        { name: "Gadget Pistol", model: "WEAPON_GADGETPISTOL" }, { name: "Stun Gun", model: "WEAPON_STUNGUN" }, { name: "Flare Gun", model: "WEAPON_FLAREGUN" },
        { name: "Tec Pistol", model: "WEAPON_TECPISTOL" }, { name: "Pistol XM3", model: "WEAPON_PISTOLXM3" }, { name: "Ray Pistol", model: "WEAPON_RAYPISTOL" }
    ],
    smg: [
        { name: "Micro SMG", model: "WEAPON_MICROSMG" }, { name: "SMG", model: "WEAPON_SMG" }, { name: "SMG MK2", model: "WEAPON_SMG_MK2" },
        { name: "Assault SMG", model: "WEAPON_ASSAULTSMG" }, { name: "Combat PDW", model: "WEAPON_COMBATPDW" }, { name: "Machine Pistol", model: "WEAPON_MACHINEPISTOL" },
        { name: "Mini SMG", model: "WEAPON_MINISMG" }
    ],
    shotguns: [
        { name: "Pump Shotgun", model: "WEAPON_PUMPSHOTGUN" }, { name: "Pump Shotgun MK2", model: "WEAPON_PUMPSHOTGUN_MK2" }, { name: "Sawed-Off", model: "WEAPON_SAWNOFFSHOTGUN" },
        { name: "Bullpup Shotgun", model: "WEAPON_BULLPUPSHOTGUN" }, { name: "Assault Shotgun", model: "WEAPON_ASSAULTSHOTGUN" }, { name: "Musket", model: "WEAPON_MUSKET" },
        { name: "Heavy Shotgun", model: "WEAPON_HEAVYSHOTGUN" }, { name: "Double Barrel", model: "WEAPON_DBSHOTGUN" }, { name: "Sweeper", model: "WEAPON_AUTOSHOTGUN" },
        { name: "Combat Shotgun", model: "WEAPON_COMBATSHOTGUN" }
    ],
    assault: [
        { name: "Assault Rifle", model: "WEAPON_ASSAULTRIFLE" }, { name: "Assault Rifle MK2", model: "WEAPON_ASSAULTRIFLE_MK2" }, { name: "Carbine Rifle", model: "WEAPON_CARBINERIFLE" },
        { name: "Carbine Rifle MK2", model: "WEAPON_CARBINERIFLE_MK2" }, { name: "Advanced Rifle", model: "WEAPON_ADVANCEDRIFLE" }, { name: "Special Carbine", model: "WEAPON_SPECIALCARBINE" },
        { name: "Special Carbine MK2", model: "WEAPON_SPECIALCARBINE_MK2" }, { name: "Bullpup Rifle", model: "WEAPON_BULLPUPRIFLE" }, { name: "Bullpup Rifle MK2", model: "WEAPON_BULLPUPRIFLE_MK2" },
        { name: "Compact Rifle", model: "WEAPON_COMPACTRIFLE" }, { name: "Military Rifle", model: "WEAPON_MILITARYRIFLE" }, { name: "Heavy Rifle", model: "WEAPON_HEAVYRIFLE" }
    ],
    lmg: [
        { name: "MG", model: "WEAPON_MG" }, { name: "Combat MG", model: "WEAPON_COMBATMG" }, { name: "Combat MG MK2", model: "WEAPON_COMBATMG_MK2" },
        { name: "Gusenberg", model: "WEAPON_GUSENBERG" }
    ],
    sniper: [
        { name: "Sniper Rifle", model: "WEAPON_SNIPERRIFLE" }, { name: "Heavy Sniper", model: "WEAPON_HEAVYSNIPER" }, { name: "Heavy Sniper MK2", model: "WEAPON_HEAVYSNIPER_MK2" },
        { name: "Marksman Rifle", model: "WEAPON_MARKSMANRIFLE" }, { name: "Marksman Rifle MK2", model: "WEAPON_MARKSMANRIFLE_MK2" }, { name: "Precision Rifle", model: "WEAPON_PRECISIONRIFLE" }
    ],
    heavy: [
        { name: "RPG", model: "WEAPON_RPG" }, { name: "Grenade Launcher", model: "WEAPON_GRENADELAUNCHER" }, { name: "Minigun", model: "WEAPON_MINIGUN" },
        { name: "Firework", model: "WEAPON_FIREWORK" }, { name: "Railgun", model: "WEAPON_RAILGUN" }, { name: "Homing Launcher", model: "WEAPON_HOMINGLAUNCHER" },
        { name: "Compact Launcher", model: "WEAPON_COMPACTLAUNCHER" }, { name: "Ray Carbine", model: "WEAPON_RAYCARBINE" }, { name: "Ray Minigun", model: "WEAPON_RAYMINIGUN" },
        { name: "EMP Launcher", model: "WEAPON_EMPLAUNCHER" }
    ],
    throwables: [
        { name: "Grenade", model: "WEAPON_GRENADE" }, { name: "Sticky Bomb", model: "WEAPON_STICKYBOMB" }, { name: "Molotov", model: "WEAPON_MOLOTOV" },
        { name: "Smoke Grenade", model: "WEAPON_SMOKEGRENADE" }, { name: "Pipe Bomb", model: "WEAPON_PIPEBOMB" }, { name: "Snowball", model: "WEAPON_SNOWBALL" },
        { name: "BZ Gas", model: "WEAPON_BZGAS" }, { name: "Flare", model: "WEAPON_FLARE" }, { name: "Proximity Mine", model: "WEAPON_PROXMINE" },
        { name: "Ball", model: "WEAPON_BALL" }
    ]
};

let currentWeaponCategory = 'melee';

window.addEventListener('message', function (event) {
    const data = event.data; // Added this line for consistency with the provided snippet
    if (data.action === "open") {
        document.getElementById("menu").style.display = "block";

        if (data.keybinds) {
            loadKeybinds(data.keybinds);
        }
        if (data.serverVehicles) { // Changed event.data to data
            serverVehicles = data.serverVehicles; // Changed event.data to data
            // console.log('[AC-TEST] Received server vehicles:', Object.keys(serverVehicles).length, 'categories');
            updateCategoryTabs();
        }

        initVehicleList();
        initWeaponList(); // Init Weapons
        initColorPickers();
        requestPlayerList();

        if (event.data.currentJob) {
            updateCurrentJobUI(event.data.currentJob);
        }
    }
    if (event.data.action === "updateJobs") {
        allJobs = event.data.jobs || [];
        renderJobList(allJobs);
    }
    if (data.action === "updateResources") {
        window.currentResourceList = data.resources || [];
    }

    if (data.type === "copyToClipboard") {
        const el = document.createElement('textarea');
        el.value = data.text;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
        showCopyNotification("Coordinates copied to clipboard!");
    }

    if (data.type === "updateCheatState") {
        const el = document.getElementById(data.id);
        if (el) { el.checked = data.enabled; }
    }

    if (data.type === "updateScanner") {
        const infoBox = document.getElementById('scanner-info');
        if (infoBox) {
            currentScannerData = data.fullInfo;
            infoBox.innerHTML = data.htmlInfo;
        }
    }
    if (event.data.action === "updatePlayers") {
        playerList = event.data.players || [];
        renderPlayerList();
    }
    if (event.data.action === "updateOwnedVehicles") {
        renderOwnedVehicles(event.data.vehicles);
    }
    if (event.data.action === "updateStressMetrics") {
        document.getElementById('metric-cpu').textContent = event.data.cpu + '%';
        document.getElementById('metric-ram').textContent = event.data.ram + ' MB';
        document.getElementById('metric-ping').textContent = event.data.ping + 'ms';
        document.getElementById('metric-bots').textContent = event.data.bots;
        document.getElementById('metric-scripts').textContent = event.data.scripts || '0';
        document.getElementById('metric-top-resource').textContent = event.data.topResource || 'NONE';

        // Update global resource list for the popup
        window.currentResourceList = (event.data.resourceList || []).map((res, idx) => ({ ...res, originalIndex: idx + 1 }));

        // Visual indicator for stress level
        const cpu = parseFloat(event.data.cpu);
        const cpuEl = document.getElementById('metric-cpu');
        if (cpu > 80) cpuEl.style.color = 'var(--accent-red)';
        else if (cpu > 50) cpuEl.style.color = 'var(--warning)';
        else cpuEl.style.color = 'var(--success)';

        const resEl = document.getElementById('metric-top-resource');
        if (event.data.topResource && event.data.topResource !== 'NONE') resEl.style.color = 'var(--accent-red)';
        else resEl.style.color = 'var(--text-secondary)';
    }
    if (event.data.action === "close") {
        document.getElementById("menu").style.display = "none";
        weaponTargetPlayer = null;
        jobTargetPlayer = null;
    }
});

// Update category tabs based on available vehicles
function updateCategoryTabs() {
    const container = document.querySelector('#spawner-tab .category-tabs');
    if (!container || !serverVehicles) return;

    const categoryLabels = {
        super: '🏎️ Super', sports: '🚗 Sports', muscle: '💪 Muscle',
        offroad: '⛰️ Offroad', motorcycle: '🏍️ Bikes', helicopter: '🚁 Heli',
        plane: '✈️ Plane', military: '🎖️ Military', boat: '⛵ Boats',
        emergency: '🚓 Police', sedan: '🚙 Sedan', suv: '🚙 SUV',
        coupe: '🚘 Coupe', compact: '🚗 Compact', van: '🚐 Van', utility: '🔧 Utility'
    };

    let tabsHtml = '';
    let first = true;
    for (const [category, vehicles] of Object.entries(serverVehicles)) {
        if (vehicles && vehicles.length > 0) {
            const label = categoryLabels[category] || category.charAt(0).toUpperCase() + category.slice(1);
            const activeClass = first ? 'active' : '';
            tabsHtml += `<div class="category-tab ${activeClass}" data-category="${category}">${label} (${vehicles.length})</div>`;
            if (first) {
                currentCategory = category;
                first = false;
            }
        }
    }
    container.innerHTML = tabsHtml;

    // Re-attach click handlers
    document.querySelectorAll('.category-tab').forEach(tab => {
        tab.addEventListener('click', function () {
            document.querySelectorAll('.category-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            currentCategory = this.dataset.category;
            renderVehicles(currentCategory);
        });
    });
}

function requestPlayerList() {
    fetch(`https://${GetParentResourceName()}/getPlayers`, { method: 'POST', body: JSON.stringify({}) });
}

function renderPlayerList() {
    const container = document.getElementById('player-list');
    const searchTerm = document.getElementById('player-search').value.toLowerCase();

    const filtered = playerList.filter(p => p.name.toLowerCase().includes(searchTerm) || p.id.toString().includes(searchTerm));

    document.getElementById('total-players').textContent = playerList.length + ' players';
    document.getElementById('player-count-badge').textContent = playerList.length;
    document.getElementById('online-count').textContent = playerList.length + ' Online';

    if (filtered.length === 0) {
        container.innerHTML = '<div style="text-align:center;padding:30px;color:var(--text-muted);"><i class="fas fa-user-slash" style="font-size:24px;"></i><p style="margin-top:10px;">No players found</p></div>';
        return;
    }

    container.innerHTML = filtered.map(p => {
        const pingClass = p.ping < 80 ? 'ping-good' : (p.ping < 150 ? 'ping-medium' : 'ping-bad');
        const isSelected = selectedPlayer && selectedPlayer.id === p.id;

        return `
                <div class="player-card ${isSelected ? 'selected' : ''}" onclick="selectPlayer(${p.id})" style="padding: 10px;">
                    <div class="player-header" style="margin-bottom: 0;">
                        <div class="player-avatar"><i class="fas fa-user"></i></div>
                        <div class="player-info">
                            <div class="player-name">${p.name}</div>
                            <div class="player-id">ID: ${p.id}</div>
                        </div>
                        <div class="player-ping ${pingClass}">${p.ping}ms</div>
                    </div>
                </div>`;
    }).join('');
}

function formatMoney(amount) {
    if (amount === undefined || amount === null) return '$0';
    return '$' + amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function copyToClipboard(text, type) {
    const el = document.createElement('textarea');
    el.value = text;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
    showNotification('success', `${type} Copied!`);
}

function selectPlayer(id) {
    const player = playerList.find(p => p.id === id);
    if (!player) return;

    selectedPlayer = { id: player.id, name: player.name, ping: player.ping };

    document.getElementById('actions-panel').classList.add('active');

    // Hide old containers
    const extraDetails = document.getElementById('extra-player-details');
    if (extraDetails) extraDetails.style.display = 'none';

    // Target the main info container
    const container = document.getElementById('selected-player-info');
    const jobLabel = player.job ? `${player.job.label} - ${player.job.grade_label}` : 'Unemployed';

    // ULTRA COMPACT HORIZONTAL DESIGN
    container.innerHTML = `
        <div class="compact-header">
             <div class="name-section">
                <span class="player-name-large">${player.name}</span>
                <span class="player-sub-info">
                    <i class="fas fa-id-card" style="color: #58a6ff;"></i> ID: ${player.id}
                    <span style="margin: 0 4px; opacity: 0.4;">|</span>
                    <i class="fas fa-wifi" style="color: #2ecc71;"></i> ${player.ping}ms
                </span>
             </div>
             <div class="id-badges">
                ${player.citizenid ? `<span class="badge-pill" onclick="copyToClipboard('${player.citizenid}', 'Citizen ID')"><i class="fas fa-passport" style="color: #f39c12;"></i> ${player.citizenid} <i class="fas fa-copy"></i></span>` : ''}
                ${player.fivem ? `<span class="badge-pill" onclick="copyToClipboard('${player.fivem}', 'FiveM ID')"><i class="fab fa-gamepad" style="color: #e74c3c;"></i> <i class="fas fa-copy"></i></span>` : ''}
             </div>
        </div>

        <div class="compact-stats-row">
            <div class="stat-pill">
                <span class="pill-label"><i class="fas fa-briefcase" style="color: #f39c12; margin-right: 6px;"></i> JOB</span>
                <span class="pill-value" style="color: #ffffff;">${jobLabel}</span>
            </div>
            <div class="stat-pill">
                <span class="pill-label"><i class="fas fa-wallet" style="color: #2ecc71; margin-right: 6px;"></i> CASH</span>
                <span class="pill-value money-green">${player.money ? formatMoney(player.money.cash) : '$0'}</span>
            </div>
            <div class="stat-pill">
                <span class="pill-label"><i class="fas fa-university" style="color: #58a6ff; margin-right: 6px;"></i> BANK</span>
                <span class="pill-value money-blue">${player.money ? formatMoney(player.money.bank) : '$0'}</span>
            </div>
        </div>

        <div class="compact-info-row">
            <div class="mini-stat"><i class="fas fa-heart" style="color: #e74c3c;"></i> <span style="color: #ffffff;">${player.health || 100}%</span></div>
            <div class="mini-stat"><i class="fas fa-shield-alt" style="color: #3498db;"></i> <span style="color: #ffffff;">${player.armor || 0}%</span></div>
            <div class="mini-stat"><i class="fas fa-car" style="color: #f1c40f;"></i> <span style="color: #ffffff;">${player.vehicle || 'Foot'}</span></div>
            <div class="mini-stat"><i class="fas fa-map-marker-alt" style="color: #9b59b6;"></i> <span style="color: #ffffff;">${player.distance ? Math.round(player.distance) + 'm' : '-'}</span></div>
        </div>
    `;

    renderPlayerList();
}

function playerAction(action) {
    if (!selectedPlayer) return alert('Select a player first!');
    fetch(`https://${GetParentResourceName()}/playerAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: action, targetId: selectedPlayer.id, targetName: selectedPlayer.name })
    });
}

document.getElementById('player-search').addEventListener('input', renderPlayerList);

// Tab switching
document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', function () {
        if (this.classList.contains('active')) return;
        const tab = this.dataset.tab;
        document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
        this.classList.add('active');
        document.querySelectorAll('.content-area').forEach(c => c.classList.remove('active'));
        document.getElementById(tab + '-tab').classList.add('active');
        document.getElementById('page-title').textContent = tabTitles[tab] || 'Menu';
        if (tab !== 'weapons') weaponTargetPlayer = null; // Reset target if switching away from weapons
        if (tab !== 'jobs') {
            jobTargetPlayer = null;
            if (tab !== 'weapons') document.getElementById('page-title').textContent = tabTitles[tab] || 'Menu';
        } else {
            document.getElementById('page-title').textContent = jobTargetPlayer ? 'Give Job to: ' + jobTargetPlayer.name : tabTitles[tab] || 'Menu';
        }
        if (tab === 'online') requestPlayerList();
        if (tab === 'jobs') requestJobsList();
        if (tab === 'items') refreshItems();
        if (tab === 'owned') requestOwnedVehicles();
    });
});

// Global delegated event listener for all toggles
document.addEventListener('change', function (event) {
    if (event.target && event.target.type === 'checkbox') {
        const id = event.target.id;
        if (!id) return; // Ignore toggles without IDs (some might be purely visual/local)

        fetch(`https://${GetParentResourceName()}/toggle`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: id, enabled: event.target.checked })
        });
        // console.log('[AC-TEST] Toggle Changed:', id, event.target.checked);
    }
});

function initVehicleList() { renderVehicles(currentCategory); }

// ---- Helper: Simple hash-based stat generator ----
function vehStatPercent(model, salt, min, max) {
    let hash = 0;
    const str = model + String(salt);
    for (let i = 0; i < str.length; i++) {
        hash = ((hash << 5) - hash) + str.charCodeAt(i);
        hash |= 0;
    }
    return min + (Math.abs(hash) % (max - min + 1));
}

// ---- Helper: Category label lookup ----
function getCategoryLabel(cat) {
    const labels = {
        super: 'Super', sports: 'Sports', muscle: 'Muscle',
        offroad: 'Off-Road', motorcycle: 'Bikes', helicopter: 'Heli',
        plane: 'Plane', military: 'Military', boat: 'Boats',
        emergency: 'Police', sedan: 'Sedan', suv: 'SUV',
        coupe: 'Coupe', compact: 'Compact', van: 'Van', utility: 'Utility'
    };
    return labels[cat] || cat;
}

// ---- Build premium card HTML ----
function buildVehCardHTML(v, catLabel, delay, onClick) {
    const speed = vehStatPercent(v.model, 1, 55, 98);
    const accel = vehStatPercent(v.model, 2, 50, 95);
    const braking = vehStatPercent(v.model, 3, 45, 92);
    const imgSrc = `https://docs.fivem.net/vehicles/${v.model}.webp`;
    const fallbackText = encodeURIComponent((v.name || v.model).substring(0, 6));
    const displayName = v.name || v.model;
    const escapedModel = v.model.replace(/'/g, "\\'");

    return `
        <div class="veh-card" style="animation-delay:${delay}s" onclick="${onClick}">
            <div class="veh-card-media">
                <div class="veh-card-badge">${catLabel || 'Vehicle'}</div>
                <div class="veh-card-media-inner">
                    <div class="veh-card-media-gradient"></div>
                    <img class="veh-card-img" src="${imgSrc}" alt="${displayName}" loading="lazy"
                        onerror="this.onerror=null; this.parentElement.innerHTML='<div class=veh-card-img-fallback style=display:flex><i class=\\'fas fa-car\\'></i></div>';">
                </div>
            </div>
            <div class="veh-card-body">
                <div class="veh-card-title" title="${displayName}">${displayName}</div>
                <div class="veh-card-code">
                    <i class="fas fa-tag"></i>
                    <span class="veh-card-codechip">${v.model}</span>
                    <button class="veh-card-copy-btn" onclick="event.stopPropagation(); copyModelName('${escapedModel}')" title="Copy model name">
                        <i class="fas fa-copy"></i>
                    </button>
                </div>
                <div class="veh-card-stats">
                    <div class="veh-stat">
                        <div class="veh-stat-row"><span>Speed</span><span class="veh-stat-val">${speed}</span></div>
                        <div class="veh-stat-track"><div class="veh-stat-fill" style="width:${speed}%"></div></div>
                    </div>
                    <div class="veh-stat">
                        <div class="veh-stat-row"><span>Accel</span><span class="veh-stat-val">${accel}</span></div>
                        <div class="veh-stat-track"><div class="veh-stat-fill" style="width:${accel}%"></div></div>
                    </div>
                    <div class="veh-stat">
                        <div class="veh-stat-row"><span>Braking</span><span class="veh-stat-val">${braking}</span></div>
                        <div class="veh-stat-track"><div class="veh-stat-fill" style="width:${braking}%"></div></div>
                    </div>
                </div>
                <div class="veh-card-actions">
                    <button class="veh-card-spawn" onclick="event.stopPropagation(); spawnVehicle('${escapedModel}')">
                        <i class="fas fa-chevron-circle-right"></i>
                        <span>Spawn</span>
                    </button>
                </div>
            </div>
        </div>`;
}

// ---- Empty state HTML ----
function vehEmptyState(icon, msg) {
    return `<div style="grid-column:1/-1;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:30px 20px;color:var(--text-muted);gap:10px;">
        <div style="width:50px;height:50px;border-radius:50%;background:rgba(255,58,58,0.08);display:flex;align-items:center;justify-content:center;font-size:22px;color:var(--accent-red);">
            <i class="fas ${icon}"></i>
        </div>
        <p style="font-size:13px;text-align:center;">${msg}</p>
    </div>`;
}

// Render Premium Vehicle Cards
function renderVehicles(category) {
    const container = document.getElementById('vehicle-list');
    const vehicleList = (serverVehicles && serverVehicles[category]) ? serverVehicles[category] : (vehicles[category] || []);
    const catLabel = getCategoryLabel(category);

    if (vehicleList.length === 0) {
        container.innerHTML = vehEmptyState('fa-car-crash', 'No vehicles in this category');
        return;
    }

    container.innerHTML = vehicleList.map((v, idx) => {
        const delay = Math.min(idx * 0.02, 0.4);
        return buildVehCardHTML(v, catLabel, delay, `spawnVehicle('${v.model.replace(/'/g, "\\'")}')`);
    }).join('');
}

// Vehicle Search - Premium Cards
function searchVehicles(query) {
    const container = document.getElementById('vehicle-list');
    const searchTerm = query.toLowerCase().trim();

    if (!searchTerm) {
        renderVehicles(currentCategory);
        return;
    }

    let results = [];
    const sourceVehicles = serverVehicles || vehicles;

    for (const [category, vehicleList] of Object.entries(sourceVehicles)) {
        if (vehicleList && vehicleList.length > 0) {
            const matches = vehicleList.filter(v => {
                const name = (v.name || '').toLowerCase();
                const model = (v.model || '').toLowerCase();
                return name.includes(searchTerm) || model.includes(searchTerm);
            });
            // Tag each result with its original category for the badge
            matches.forEach(m => m._category = category);
            results = results.concat(matches);
        }
    }

    // Remove duplicates by model
    const seen = new Set();
    results = results.filter(v => {
        if (seen.has(v.model)) return false;
        seen.add(v.model);
        return true;
    });

    if (results.length === 0) {
        container.innerHTML = vehEmptyState('fa-search', `No vehicles found for "${query}"`);
        return;
    }

    container.innerHTML = results.map((v, idx) => {
        const delay = Math.min(idx * 0.02, 0.4);
        const catLabel = getCategoryLabel(v._category || '');
        return buildVehCardHTML(v, catLabel, delay, `spawnVehicle('${v.model.replace(/'/g, "\\'")}')`);
    }).join('');
}

// Copy model name to clipboard
function copyModelName(modelName) {
    navigator.clipboard.writeText(modelName).then(() => {
        // Show success feedback
        showCopyNotification('Copied: ' + modelName);
    }).catch(err => {
        console.error('Copy failed:', err);
        // Fallback for older browsers
        const textArea = document.createElement('textarea');
        textArea.value = modelName;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
        showCopyNotification('Copied: ' + modelName);
    });
}

// Show copy notification
function showCopyNotification(message) {
    // Remove existing notification
    const existing = document.querySelector('.copy-notification');
    if (existing) existing.remove();

    const notification = document.createElement('div');
    notification.className = 'copy-notification';
    notification.innerHTML = '<i class="fas fa-check"></i> ' + message;
    document.body.appendChild(notification);

    // Auto remove after 2 seconds
    setTimeout(() => {
        notification.classList.add('fade-out');
        setTimeout(() => notification.remove(), 300);
    }, 2000);
}

function initColorPickers() {
    // Initialize RGB sliders
    const redSlider = document.getElementById('red-slider');
    const greenSlider = document.getElementById('green-slider');
    const blueSlider = document.getElementById('blue-slider');
    const nativePicker = document.getElementById('native-color-picker');

    if (redSlider) {
        redSlider.addEventListener('input', updateColorFromSliders);
        greenSlider.addEventListener('input', updateColorFromSliders);
        blueSlider.addEventListener('input', updateColorFromSliders);
        nativePicker.addEventListener('input', updateFromNativePicker);
    }
}

function updateColorFromSliders() {
    const r = document.getElementById('red-slider').value;
    const g = document.getElementById('green-slider').value;
    const b = document.getElementById('blue-slider').value;

    document.getElementById('red-value').textContent = r;
    document.getElementById('green-value').textContent = g;
    document.getElementById('blue-value').textContent = b;

    const hex = rgbToHex(parseInt(r), parseInt(g), parseInt(b));
    document.getElementById('hex-input').value = hex;
    document.getElementById('color-preview').style.background = hex;
    document.getElementById('native-color-picker').value = hex;
}

function updateFromNativePicker() {
    const hex = document.getElementById('native-color-picker').value;
    const rgb = hexToRgb(hex);

    document.getElementById('red-slider').value = rgb.r;
    document.getElementById('green-slider').value = rgb.g;
    document.getElementById('blue-slider').value = rgb.b;
    document.getElementById('red-value').textContent = rgb.r;
    document.getElementById('green-value').textContent = rgb.g;
    document.getElementById('blue-value').textContent = rgb.b;
    document.getElementById('hex-input').value = hex.toUpperCase();
    document.getElementById('color-preview').style.background = hex;
}

function applyColorFromHex() {
    let hex = document.getElementById('hex-input').value;
    if (!hex.startsWith('#')) hex = '#' + hex;
    const rgb = hexToRgb(hex);
    if (rgb) {
        document.getElementById('red-slider').value = rgb.r;
        document.getElementById('green-slider').value = rgb.g;
        document.getElementById('blue-slider').value = rgb.b;
        updateColorFromSliders();
    }
}

function setQuickColor(hex) {
    document.getElementById('native-color-picker').value = hex;
    updateFromNativePicker();
}

function applyRainbow() {
    fetch(`https://${GetParentResourceName()}/toggle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: 'rainbow-car', enabled: true })
    });
}

function applyVehicleColor(type) {
    const hex = document.getElementById('hex-input').value;
    fetch(`https://${GetParentResourceName()}/applyColor`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: type, color: hex })
    });
}

function rgbToHex(r, g, b) {
    return '#' + [r, g, b].map(x => x.toString(16).padStart(2, '0')).join('').toUpperCase();
}

function hexToRgb(hex) {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}

// Vehicle Mod Functions
function applyMod(modType, value) {
    fetch(`https://${GetParentResourceName()}/applyMod`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ modType: parseInt(modType), value: parseInt(value) })
    });
}

function toggleTurbo(enabled) {
    fetch(`https://${GetParentResourceName()}/toggleTurbo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ enabled: enabled })
    });
}

function maxTune() {
    fetch(`https://${GetParentResourceName()}/maxPerformance`, { method: 'POST' });
}

let wheelIndex = 0;
let spoilerIndex = 0;
let bumperFIndex = 0;
let bumperRIndex = 0;

function changeWheels(direction) {
    wheelIndex = Math.max(0, wheelIndex + direction);
    document.getElementById('wheel-index').textContent = wheelIndex;
    fetch(`https://${GetParentResourceName()}/applyMod`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ modType: 23, value: wheelIndex })
    });
}

function applyWheelType(type) {
    fetch(`https://${GetParentResourceName()}/applyWheelType`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: parseInt(type) })
    });
}

function changeMod(modType, direction) {
    let indexEl, currentIndex;
    if (modType === 0) {
        indexEl = document.getElementById('spoiler-index');
        spoilerIndex = Math.max(-1, spoilerIndex + direction);
        currentIndex = spoilerIndex;
    } else if (modType === 1) {
        indexEl = document.getElementById('bumper-f-index');
        bumperFIndex = Math.max(-1, bumperFIndex + direction);
        currentIndex = bumperFIndex;
    } else {
        indexEl = document.getElementById('bumper-r-index');
        bumperRIndex = Math.max(-1, bumperRIndex + direction);
        currentIndex = bumperRIndex;
    }
    indexEl.textContent = currentIndex;
    applyMod(modType, currentIndex);
}

function toggleXenon(enabled) {
    fetch(`https://${GetParentResourceName()}/toggleXenon`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ enabled: enabled })
    });
}

function applyPlateStyle(style) {
    fetch(`https://${GetParentResourceName()}/applyPlateStyle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ style: parseInt(style) })
    });
}

function changePlate() {
    fetch(`https://${GetParentResourceName()}/changePlate`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text: document.getElementById('plate-text').value })
    });
}

function repairVehicle() { fetch(`https://${GetParentResourceName()}/repairVehicle`, { method: 'POST' }); }

function flipVehicle() { fetch(`https://${GetParentResourceName()}/flipVehicle`, { method: 'POST' }); }

function cleanVehicle() { fetch(`https://${GetParentResourceName()}/cleanVehicle`, { method: 'POST' }); }

function toggleNeon(enabled) {
    fetch(`https://${GetParentResourceName()}/toggleNeon`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ enabled: enabled })
    });
}

function updateNeonSide() {
    fetch(`https://${GetParentResourceName()}/updateNeonSides`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            front: document.getElementById('neon-front').checked,
            rear: document.getElementById('neon-rear').checked,
            left: document.getElementById('neon-left').checked,
            right: document.getElementById('neon-right').checked
        })
    });
}

function applyTint(level) {
    fetch(`https://${GetParentResourceName()}/applyTint`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ level: parseInt(level) })
    });
}

function spawnTestGang() {
    const count = document.getElementById('gang-count').value || 5;
    fetch(`https://${GetParentResourceName()}/spawnTestGang`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ count: parseInt(count) })
    });
}

// SELF ACTIONS
function freezeTime() {
    fetch(`https://${GetParentResourceName()}/freezeTime`, { method: 'POST', body: '{}' });
}

function selfRevive() {
    fetch(`https://${GetParentResourceName()}/selfRevive`, { method: 'POST' });
}

// Dev Utilities
function devTeleport() {
    const coords = document.getElementById('tp-coords').value;
    if (!coords) return;
    fetch(`https://${GetParentResourceName()}/devTeleport`, {
        method: 'POST',
        body: JSON.stringify({ coords: coords })
    });
}

function devSpawn(type) {
    const model = document.getElementById('spawn-model').value;
    if (!model) return;
    fetch(`https://${GetParentResourceName()}/devSpawn`, {
        method: 'POST',
        body: JSON.stringify({ type: type, model: model })
    });
}

function selfHeal() {
    fetch(`https://${GetParentResourceName()}/selfHeal`, { method: 'POST' });
}


function closeMenu() {
    document.getElementById("menu").style.display = "none";
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST', body: JSON.stringify({}) });
    weaponTargetPlayer = null; // Reset target
}

// ============ VEHICLE SPAWNER FUNCTIONS ============
function spawnVehicle(model) {
    fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            model: model,
            godmode: document.getElementById('spawn-godmode')?.checked || false,
            maxed: document.getElementById('spawn-maxed')?.checked ?? true,
            deletePrev: document.getElementById('spawn-delete-prev')?.checked ?? true,
            inside: document.getElementById('spawn-inside')?.checked ?? true
        })
    });
    // console.log('[AC-TEST] Spawning vehicle: ' + model);
}

function spawnCustomVehicle() {
    const modelInput = document.getElementById('custom-vehicle');
    if (modelInput && modelInput.value) {
        spawnVehicle(modelInput.value);
    }
}

function showPreview(event, name, model) {
    const preview = document.getElementById('vehicle-preview');
    const img = document.getElementById('preview-img');
    const nameEl = document.getElementById('preview-name');

    if (preview && img && nameEl) {
        img.src = `https://docs.fivem.net/vehicles/${model}.webp`;
        img.onerror = function () { this.src = 'https://via.placeholder.com/200x100?text=' + name; };
        nameEl.textContent = name;
        preview.style.left = (event.clientX + 20) + 'px';
        preview.style.top = (event.clientY - 60) + 'px';
        preview.classList.add('show');
    }
}

function hidePreview() {
    const preview = document.getElementById('vehicle-preview');
    if (preview) preview.classList.remove('show');
}

function initWeaponList() {
    renderWeaponList(currentWeaponCategory);
}

function setWeaponCategory(cat, el) {
    currentWeaponCategory = cat;
    // Update tabs UI
    document.querySelectorAll('#weapon-tabs .category-tab').forEach(t => t.classList.remove('active'));
    el.classList.add('active');
    renderWeaponList(cat);
}

function renderWeaponList(category) {
    const container = document.getElementById('weapon-list-container');
    const list = weaponList[category] || [];

    if (list.length === 0) {
        container.innerHTML = '<div style="grid-column:span 3;text-align:center;padding:10px;color:var(--text-muted)">No weapons found</div>';
        return;
    }

    container.innerHTML = list.map(w => `
                <div class="vehicle-item" onclick="giveWeapon('${w.model}')">
                    <div style="height:60px; display:flex; align-items:center; justify-content:center; margin-bottom:5px; background:linear-gradient(145deg, rgba(255,58,58,0.05), rgba(0,0,0,0.3)); border-radius:4px;">
                        <img src="nui://ac-test/html/images/${w.model}.png" 
                             alt="${w.name}" 
                             style="max-width:90%; max-height:55px; object-fit:contain;"
                             onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        <i class="fas fa-gun" style="display:none; font-size:24px; color:var(--accent-red);"></i>
                    </div>
                    <span>${w.name}</span>
                </div>
            `).join('');
}

// Helper to get appropriate icon for weapon type
function getWeaponIcon(model) {
    const m = model.toLowerCase();
    if (m.includes('knife') || m.includes('machete') || m.includes('hatchet') || m.includes('axe') || m.includes('switchblade')) return 'knife';
    if (m.includes('bat') || m.includes('club') || m.includes('cue') || m.includes('crowbar') || m.includes('hammer') || m.includes('wrench') || m.includes('nightstick')) return 'gavel';
    if (m.includes('pistol') || m.includes('revolver') || m.includes('stungun') || m.includes('flaregun')) return 'gun';
    if (m.includes('smg') || m.includes('pdw') || m.includes('minismg') || m.includes('machinepistol') || m.includes('tec')) return 'gun';
    if (m.includes('shotgun') || m.includes('musket')) return 'gun';
    if (m.includes('rifle') || m.includes('carbine') || m.includes('gusenberg')) return 'crosshairs';
    if (m.includes('sniper') || m.includes('marksman') || m.includes('precision')) return 'bullseye';
    if (m.includes('mg') || m.includes('minigun')) return 'crosshairs';
    if (m.includes('rpg') || m.includes('grenade') || m.includes('launcher') || m.includes('firework') || m.includes('railgun') || m.includes('homing')) return 'rocket';
    if (m.includes('bomb') || m.includes('molotov') || m.includes('sticky') || m.includes('pipe') || m.includes('grenade') || m.includes('snowball')) return 'bomb';
    if (m.includes('flashlight')) return 'flashlight';
    return 'gun';
}

function searchWeapons(query) {
    const container = document.getElementById('weapon-list-container');
    const searchTerm = query.toLowerCase().trim();

    if (!searchTerm) {
        renderWeaponList(currentWeaponCategory);
        return;
    }

    let results = [];
    for (const [cat, list] of Object.entries(weaponList)) {
        results = results.concat(list.filter(w => w.name.toLowerCase().includes(searchTerm) || w.model.toLowerCase().includes(searchTerm)));
    }

    // Add custom weapon search support (if user types exact hash/model not in list)
    if (results.length === 0 && searchTerm.length > 5) {
        results.push({ name: searchTerm.toUpperCase(), model: searchTerm.toUpperCase() });
    }

    container.innerHTML = results.map(w => `
                <div class="vehicle-item" onclick="giveWeapon('${w.model}')">
                    <div style="height:60px; display:flex; align-items:center; justify-content:center; margin-bottom:5px; background:linear-gradient(145deg, rgba(255,58,58,0.05), rgba(0,0,0,0.3)); border-radius:4px;">
                        <img src="nui://ac-test/html/images/${w.model}.png" 
                             alt="${w.name}" 
                             style="max-width:90%; max-height:55px; object-fit:contain;"
                             onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        <i class="fas fa-gun" style="display:none; font-size:24px; color:var(--accent-red);"></i>
                    </div>
                    <span>${w.name}</span>
                </div>
            `).join('');
}

function prepareGiveWeaponToPlayer() {
    if (!selectedPlayer) return alert('Select a player first!');
    weaponTargetPlayer = selectedPlayer;

    // Switch to weapons tab
    document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
    document.querySelector('[data-tab="weapons"]').classList.add('active');

    document.querySelectorAll('.content-area').forEach(c => c.classList.remove('active'));
    document.getElementById('weapons-tab').classList.add('active');

    document.getElementById('page-title').textContent = 'Give Weapon to: ' + selectedPlayer.name;
}

function giveWeapon(model) {
    if (weaponTargetPlayer) {
        // Give to specific player
        fetch(`https://${GetParentResourceName()}/giveWeaponToPlayer`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ weapon: model, targetId: weaponTargetPlayer.id })
        });
        // Optional: Don't reset immediately if they want to give multiple weapons
        // weaponTargetPlayer = null; 
        // document.getElementById('page-title').textContent = 'Weapon Spawner';
    } else {
        // Give to self
        fetch(`https://${GetParentResourceName()}/giveWeapon`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ weapon: model })
        });
    }
}

function giveAmmo() {
    fetch(`https://${GetParentResourceName()}/giveAmmo`, { method: 'POST' });
}

// Action Trigger
function triggerAction(action) {
    fetch(`https://${GetParentResourceName()}/triggerAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: action })
    });
}

// Update Int Value
function updateInt(id, value) {
    fetch(`https://${GetParentResourceName()}/updateInt`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id, value: parseInt(value) })
    });
}

// Update Float Value
function updateFloat(id, value) {
    fetch(`https://${GetParentResourceName()}/updateFloat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id, value: parseFloat(value) })
    });
}

function removeAllWeapons() {
    if (confirm('Remove all weapons?')) {
        fetch(`https://${GetParentResourceName()}/removeAllWeapons`, { method: 'POST' });
    }
}

// ============ LOAD SIMULATOR FUNCTIONS ============
function startSimulation() {
    const count = document.getElementById('bot-count').value || 100;
    const movement = document.getElementById('bot-movement').checked;
    const scripts = document.getElementById('bot-script-stress').checked;
    const realistic = document.getElementById('bot-realistic-actions').checked;

    fetch(`https://${GetParentResourceName()}/startLoadSimulation`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            count: parseInt(count),
            movement: movement,
            scripts: scripts,
            realistic: realistic
        })
    });

    document.getElementById('start-simulation-btn').style.display = 'none';
    document.getElementById('stop-simulation-btn').style.display = 'flex';
    // console.log('[AC-TEST] Starting load simulation with ' + count + ' bots (Realistic: ' + realistic + ')');
}

function stopSimulation() {
    fetch(`https://${GetParentResourceName()}/stopLoadSimulation`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });

    document.getElementById('start-simulation-btn').style.display = 'flex';
    document.getElementById('stop-simulation-btn').style.display = 'none';

    // Reset metrics optimistically
    document.getElementById('metric-bots').textContent = '0';
    // console.log('[AC-TEST] Stopping load simulation');
}

// Category tab handlers
document.querySelectorAll('.category-tab').forEach(tab => {

    tab.addEventListener('click', function () {
        document.querySelectorAll('.category-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');
        currentCategory = this.dataset.category;
        renderVehicles(currentCategory);
    });
});

// ============ OWNED VEHICLES FUNCTIONS ============
let myVehicles = [];
let lastOwnedFetchTime = 0;

function requestOwnedVehicles(force = false) {
    const now = Date.now();
    if (!force && (now - lastOwnedFetchTime < 10000) && myVehicles.length > 0) {
        // Use cached vehicles instead of hitting DB
        renderOwnedVehicles(myVehicles);
        return;
    }
    
    lastOwnedFetchTime = now;
    fetch(`https://${GetParentResourceName()}/getOwnedVehicles`, { method: 'POST' });
    const list = document.getElementById('owned-vehicle-list');
    if (list) list.innerHTML = '<div style="text-align: center; padding: 20px; color: var(--text-muted); grid-column: span 3;"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';
}

// Multi-select logic
let selectedVehicles = new Set();
let isBulkDelete = false;

function toggleSelectVehicle(plate, event) {
    if (event) event.stopPropagation();
    if (selectedVehicles.has(plate)) {
        selectedVehicles.delete(plate);
    } else {
        selectedVehicles.add(plate);
    }
    renderOwnedVehicles(myVehicles);
}

function renderOwnedVehicles(vehicles) {
    myVehicles = vehicles || [];
    const list = document.getElementById('owned-vehicle-list');
    if (!list) return;

    if (myVehicles.length === 0) {
        list.innerHTML = vehEmptyState('fa-car-side', 'No owned vehicles found');
        return;
    }

    list.innerHTML = myVehicles.map((v, idx) => {
        const isSelected = selectedVehicles.has(v.plate);
        const delay = Math.min(idx * 0.02, 0.4);
        const modelStr = String(v.model);
        const imgSrc = `https://docs.fivem.net/vehicles/${modelStr}.webp`;

        return `
            <div class="veh-card ${isSelected ? 'veh-card-selected' : ''}" style="animation-delay:${delay}s; position:relative;">
                <!-- Selection Checkbox -->
                <div style="position:absolute;top:8px;right:8px;z-index:10;">
                    <label class="checkbox" style="background:rgba(0,0,0,0.6);padding:2px;border-radius:4px;">
                        <input type="checkbox" ${isSelected ? 'checked' : ''} onchange="toggleSelectVehicle('${v.plate}', event)">
                        <span class="checkmark"></span>
                    </label>
                </div>

                <div class="veh-card-media">
                    <div class="veh-card-badge"><i class="fas fa-key" style="margin-right:3px;"></i> Owned</div>
                    <div class="veh-card-media-inner" style="height:100px;">
                        <div class="veh-card-media-gradient"></div>
                        <img class="veh-card-img" src="${imgSrc}" alt="${modelStr}" loading="lazy"
                            onerror="this.onerror=null; this.parentElement.innerHTML='<div class=veh-card-img-fallback style=display:flex><i class=\\'fas fa-car\\'></i></div>';">
                    </div>
                </div>
                <div class="veh-card-body" style="padding:8px 10px 10px 10px;">
                    <div class="veh-card-title" style="font-size:14px;letter-spacing:0.05em;" title="${v.plate}">
                        <i class="fas fa-id-card" style="font-size:11px;color:var(--accent-red);margin-right:4px;"></i>${v.plate}
                    </div>
                    <div class="veh-card-code">
                        <i class="fas fa-tag"></i>
                        <span class="veh-card-codechip">${v.model}</span>
                        <button class="veh-card-copy-btn" onclick="event.stopPropagation(); copyModelName('${v.model}')" title="Copy model name">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="veh-card-actions" style="margin-top:6px;">
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:5px;">
                            <button class="veh-card-spawn" onclick="event.stopPropagation(); spawnOwnedVehicle('${v.model}', '${v.plate}')" style="font-size:9px;height:30px;">
                                <i class="fas fa-key"></i> Take
                            </button>
                            <button class="veh-card-spawn" onclick="event.stopPropagation(); showDeleteConfirmation('${v.plate}')" style="font-size:9px;height:30px;background:rgba(255,58,58,0.05);border-color:rgba(255,58,58,0.2);color:var(--accent-red);">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </div>
                    </div>
                </div>
            </div>`;
    }).join('');
}

function searchOwnedVehicles(query) {
    if (!myVehicles) return;
    const term = query.toLowerCase();
    const filtered = myVehicles.filter(v =>
        v.plate.toLowerCase().includes(term) ||
        v.model.toLowerCase().includes(term)
    );

    const list = document.getElementById('owned-vehicle-list');
    if (filtered.length === 0) {
        list.innerHTML = vehEmptyState('fa-search', 'No matches found');
        return;
    }

    list.innerHTML = filtered.map((v, idx) => {
        const isSelected = selectedVehicles.has(v.plate);
        const delay = Math.min(idx * 0.02, 0.4);
        const modelStr = String(v.model);
        const imgSrc = `https://docs.fivem.net/vehicles/${modelStr}.webp`;

        return `
            <div class="veh-card ${isSelected ? 'veh-card-selected' : ''}" style="animation-delay:${delay}s; position:relative;">
                <div style="position:absolute;top:8px;right:8px;z-index:10;">
                    <label class="checkbox" style="background:rgba(0,0,0,0.6);padding:2px;border-radius:4px;">
                        <input type="checkbox" ${isSelected ? 'checked' : ''} onchange="toggleSelectVehicle('${v.plate}', event)">
                        <span class="checkmark"></span>
                    </label>
                </div>
                <div class="veh-card-media">
                    <div class="veh-card-badge"><i class="fas fa-key"></i> Owned</div>
                    <div class="veh-card-media-inner" style="height:100px;">
                        <div class="veh-card-media-gradient"></div>
                        <img class="veh-card-img" src="${imgSrc}" alt="${modelStr}" loading="lazy"
                            onerror="this.onerror=null; this.parentElement.innerHTML='<div class=veh-card-img-fallback style=display:flex><i class=\\'fas fa-car\\'></i></div>';">
                    </div>
                </div>
                <div class="veh-card-body" style="padding:8px 10px 10px 10px;">
                    <div class="veh-card-title" style="font-size:14px;letter-spacing:0.05em;" title="${v.plate}">
                        <i class="fas fa-id-card" style="font-size:11px;color:var(--accent-red);margin-right:4px;"></i>${v.plate}
                    </div>
                    <div class="veh-card-code">
                        <i class="fas fa-tag"></i>
                        <span class="veh-card-codechip">${v.model}</span>
                        <button class="veh-card-copy-btn" onclick="event.stopPropagation(); copyModelName('${v.model}')" title="Copy model name">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                    <div class="veh-card-actions" style="margin-top:6px;">
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:5px;">
                            <button class="veh-card-spawn" onclick="event.stopPropagation(); spawnOwnedVehicle('${v.model}', '${v.plate}')" style="font-size:9px;height:30px;">
                                <i class="fas fa-key"></i> Take
                            </button>
                            <button class="veh-card-spawn" onclick="event.stopPropagation(); showDeleteConfirmation('${v.plate}')" style="font-size:9px;height:30px;background:rgba(255,58,58,0.05);border-color:rgba(255,58,58,0.2);color:var(--accent-red);">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </div>
                    </div>
                </div>
            </div>`;
    }).join('');
}

function spawnOwnedVehicle(model, plate) {
    // Find mods from cached list
    const veh = myVehicles.find(v => v.plate === plate);
    const mods = veh ? veh.mods : null;

    fetch(`https://${GetParentResourceName()}/spawnOwnedVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            model: model,
            plate: plate,
            mods: mods
        })
    });
}

// Custom Modal Logic
let pendingDeletePlate = null;

function showDeleteConfirmation(plate) {
    pendingDeletePlate = plate;
    isBulkDelete = false;

    const modal = document.getElementById('confirmation-modal');
    const title = document.getElementById('modal-title');
    const message = document.getElementById('modal-message');
    const confirmBtn = document.getElementById('modal-confirm-btn');

    title.textContent = 'Vehicle Deletion';
    message.innerHTML = `Are you sure you want to permanently delete vehicle with plate <span style="color:white; font-weight:bold;">[${plate}]</span>?<br>This action cannot be undone.`;

    confirmBtn.onclick = confirmDelete;

    modal.classList.add('show');
}

function showBulkDeleteConfirmation() {
    if (selectedVehicles.size === 0) return;

    isBulkDelete = true;
    pendingDeletePlate = null;

    const modal = document.getElementById('confirmation-modal');
    const title = document.getElementById('modal-title');
    const message = document.getElementById('modal-message');
    const confirmBtn = document.getElementById('modal-confirm-btn');

    title.textContent = 'Delete Multiple Vehicles?';
    message.innerHTML = `Are you sure you want to permanently delete <span style="color:var(--accent-red); font-weight:bold;">${selectedVehicles.size}</span> selected vehicles?<br>This action cannot be undone.`;

    confirmBtn.onclick = confirmDelete;
    modal.classList.add('show');
}

function closeModal() {
    const modal = document.getElementById('confirmation-modal');
    modal.classList.remove('show');
    pendingDeletePlate = null;
    isBulkDelete = false;
}

function confirmDelete() {
    if (isBulkDelete) {
        selectedVehicles.forEach(plate => {
            deleteOwnedVehicle(plate, true);
        });
        selectedVehicles.clear();
        requestOwnedVehicles(true);
    } else if (pendingDeletePlate) {
        deleteOwnedVehicle(pendingDeletePlate);
    }
    closeModal();
}

function deleteOwnedVehicle(plate, skipRender = false) {
    fetch(`https://${GetParentResourceName()}/deleteOwnedVehicle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ plate: plate })
    });

    // Optimistically remove from list
    myVehicles = myVehicles.filter(v => v.plate !== plate);
    if (!skipRender) {
        renderOwnedVehicles(myVehicles);
    }
}

// Resource Stress Modal Logic
function openStressModal() {
    const modal = document.getElementById('resource-stress-modal');

    // Reset search
    const searchInput = document.getElementById('resource-search-input');
    if (searchInput) searchInput.value = '';

    // Initial render
    renderResourceList(window.currentResourceList || []);

    modal.classList.add('show');
    if (searchInput) searchInput.focus();
}

function filterResourceList() {
    const query = document.getElementById('resource-search-input').value.toLowerCase();
    const allResources = window.currentResourceList || [];

    const filtered = allResources.filter(res => res.name.toLowerCase().includes(query));
    renderResourceList(filtered);
}

function renderResourceList(list) {
    const container = document.getElementById('resource-list-container');

    if (!list || list.length === 0) {
        container.innerHTML = `<div style="text-align:center; padding:20px; color:var(--text-muted);">No matching resources found.</div>`;
        return;
    }

    container.innerHTML = list.map((res, index) => {
        const color = res.stress > 70 ? 'var(--accent-red)' : (res.stress > 40 ? 'var(--warning)' : 'var(--success)');
        const glow = res.stress > 70 ? '0 0 10px rgba(255,42,42,0.3)' : 'none';
        const msColor = (parseFloat(res.cpu) > 0.5) ? 'var(--accent-red)' : 'var(--text-muted)';

        return `
                    <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); border-radius: 8px; padding: 12px; margin-bottom: 8px; display: flex; align-items: center; gap: 15px;">
                        <div style="font-size: 18px; font-weight: 800; color: ${color}; width: 30px; text-align: center; font-family: 'Rajdhani';">${res.originalIndex || (index + 1)}</div>
                        <div style="flex: 1;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                                <span style="font-size: 13px; font-weight: 600; color: white;">${res.name}</span>
                                <div style="text-align: right;">
                                    <span style="font-size: 11px; color: ${msColor}; margin-right: 8px; font-family: monospace;">${res.cpu || '~0.01 ms'}</span>
                                    <span style="font-size: 12px; color: ${color}; font-weight: bold;">${res.stress}%</span>
                                </div>
                            </div>
                            <div style="height: 6px; background: rgba(255,255,255,0.05); border-radius: 3px; overflow: hidden;">
                                <div style="width: ${res.stress}%; height: 100%; background: ${color}; box-shadow: ${glow}; transition: width 0.5s ease;"></div>
                            </div>
                        </div>
                    </div>
                `;
    }).join('');
}

function closeStressModal() {
    const modal = document.getElementById('resource-stress-modal');
    modal.classList.remove('show');
}

// ============ JOB MANAGEMENT FUNCTIONS ============
function requestJobsList() {
    fetch(`https://${GetParentResourceName()}/getJobs`, { method: 'POST' });
    const container = document.getElementById('job-list-container');
    if (container) {
        container.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--text-muted); grid-column: 1 / -1;"><i class="fas fa-spinner fa-spin fa-2x"></i><br>Fetching jobs from framework...</div>';
    }
}

function updateCurrentJobUI(job) {
    currentJob = job;
    const labelEl = document.getElementById('player-job-label');
    const gradeEl = document.getElementById('player-job-grade');
    if (labelEl) labelEl.textContent = job.label || job.name;
    if (gradeEl) gradeEl.textContent = job.grade_label || `Grade ${job.grade}`;
}

function filterJobList(query) {
    const term = query.toLowerCase();
    const filtered = allJobs.filter(j =>
        j.name.toLowerCase().includes(term) ||
        j.label.toLowerCase().includes(term)
    );
    renderJobList(filtered);
}

// Developer Tools Functions
function applyWeather() {
    const weather = document.getElementById('weather-select').value;
    fetch(`https://${GetParentResourceName()}/changeWeather`, {
        method: 'POST',
        body: JSON.stringify({ weather: weather })
    });
    showCopyNotification(`Weather set to ${weather}`);
}

function applyTime() {
    const hour = document.getElementById('time-hour').value;
    fetch(`https://${GetParentResourceName()}/changeTime`, {
        method: 'POST',
        body: JSON.stringify({ hour: hour })
    });
    showCopyNotification(`Time set to ${hour}:00`);
}

function freezeTime() {
    fetch(`https://${GetParentResourceName()}/freezeTime`, {
        method: 'POST',
        body: JSON.stringify({})
    });
}

let currentScannerData = "";
function copyScannerInfo() {
    if (!currentScannerData) return;
    const el = document.createElement('textarea');
    el.value = currentScannerData;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
    showCopyNotification("Entity info copied!");
}

function renderJobList(jobs) {
    const container = document.getElementById('job-list-container');
    if (!container) return;

    if (jobs.length === 0) {
        container.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--text-muted); grid-column: 1 / -1;">No matching jobs found</div>';
        return;
    }

    container.innerHTML = jobs.map(job => `
                <div class="panel" style="margin-bottom: 0; background: rgba(255,255,255,0.02); border-color: rgba(255,255,255,0.05); border-radius: 8px;">
                    <div style="padding: 12px;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px;">
                            <div>
                                <div style="font-weight: bold; color: white; font-size: 14px;">${job.label}</div>
                                <div style="font-size: 10px; color: var(--text-muted); font-family: monospace; text-transform: uppercase;">${job.name}</div>
                            </div>
                            <div style="font-size: 10px; background: rgba(255,255,255,0.05); padding: 2px 6px; border-radius: 4px; color: var(--text-muted); font-weight: bold;">
                                ${job.grades.length} GRADES
                            </div>
                        </div>
                        <div style="display: flex; flex-wrap: wrap; gap: 5px; max-height: 120px; overflow-y: auto; padding-right: 5px;">
                            ${job.grades.map(g => `
                                <button class="spawn-btn secondary" 
                                        onclick="setMyJob('${job.name}', ${g.grade})" 
                                        style="font-size: 10px; padding: 5px 8px; flex: 1 0 calc(50% - 5px); text-align: left; line-height: 1.2;">
                                    <span style="color: var(--accent-red); margin-right: 4px; font-weight: bold;">${g.grade}</span> ${g.label || g.name}
                                </button>
                            `).join('')}
                        </div>
                    </div>
                </div>
            `).join('');
}

function setMyJob(jobName, grade) {
    if (jobTargetPlayer) {
        fetch(`https://${GetParentResourceName()}/giveJobToPlayer`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ job: jobName, grade: grade, targetId: jobTargetPlayer.id })
        });
        showCopyNotification(`Set ${jobTargetPlayer.name}'s job to ${jobName}`);
        // jobTargetPlayer = null; 
    } else {
        fetch(`https://${GetParentResourceName()}/setJob`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ job: jobName, grade: grade })
        });

        // Optimistically update UI if we have the job data
        const jobData = allJobs.find(j => j.name === jobName);
        if (jobData) {
            const gradeData = jobData.grades.find(g => g.grade === grade);
            updateCurrentJobUI({
                name: jobName,
                label: jobData.label,
                grade: grade,
                grade_label: gradeData ? gradeData.label : `Grade ${grade}`
            });
        }
    }
}

function prepareGiveJobToPlayer() {
    if (!selectedPlayer) return alert('Select a player first!');
    jobTargetPlayer = selectedPlayer;

    // Switch to jobs tab
    document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
    const jobNavItem = document.querySelector('[data-tab="jobs"]');
    if (jobNavItem) jobNavItem.classList.add('active');

    document.querySelectorAll('.content-area').forEach(c => c.classList.remove('active'));
    const jobTab = document.getElementById('jobs-tab');
    if (jobTab) jobTab.classList.add('active');

    const pageTitle = document.getElementById('page-title');
    if (pageTitle) pageTitle.textContent = 'Give Job to: ' + selectedPlayer.name;

    // Auto refresh jobs if list is empty
    if (allJobs.length === 0) requestJobsList();
}

document.onkeyup = function (e) {
    if (e.which == 27) {
        closeMenu();
        closeModal();
        closeStressModal();
    }
};

// GLOBAL UI FUNCTIONS (Must be outside the main module scope to be called by onclick)

// Item Spawner Global State
window.allItems = [];

window.addEventListener('message', function (event) {
    if (event.data.type === "showItems") {
        window.allItems = event.data.items;
        renderItemList(window.allItems);
    }
});

function requestItems() {
    fetch(`https://${GetParentResourceName()}/requestItems`, { method: 'POST' });
}

window.refreshItems = function () {
    const container = document.getElementById('item-list-container');
    if (container) container.innerHTML = '<div style="text-align: center; padding: 20px; color: var(--text-muted); grid-column: 1 / -1;"><i class="fas fa-spinner fa-spin"></i> Loading items...</div>';
    requestItems();
};

function renderItemList(items) {
    const container = document.getElementById('item-list-container');
    if (!container) return;
    container.innerHTML = '';

    if (!items || items.length === 0) {
        container.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--text-muted); grid-column: 1 / -1;">No items found. Click Refresh.</div>';
        return;
    }

    // Limit initial render
    const displayItems = items.slice(0, 100);

    displayItems.forEach(item => {
        const div = document.createElement('div');
        div.className = 'player-card';
        div.style.flexDirection = 'column';
        div.style.alignItems = 'center';
        div.style.gap = '5px';
        div.style.textAlign = 'center'; // Center text

        // Construct Image URL (Support custom image names)
        let imageUrl;
        if (item.image) {
            // Check if item.image already has an extension
            if (item.image.includes('.')) {
                imageUrl = `nui://ox_inventory/web/images/${item.image}`;
            } else {
                imageUrl = `nui://ox_inventory/web/images/${item.image}.png`;
            }
        } else {
            imageUrl = `nui://ox_inventory/web/images/${item.name}.png`;
        }

        div.innerHTML = `
                    <div style="width: 64px; height: 64px; display: flex; align-items: center; justify-content: center; margin-bottom: 5px;">
                        <img src="${imageUrl}" style="max-width: 100%; max-height: 100%;" onerror="this.onerror=null; this.src='https://cfx-nui-ox_inventory/web/images/${item.name}.png'; this.style.display='none'; this.nextElementSibling.style.display='block';">
                        <i class="fas fa-box" style="display: none; font-size: 24px; color: var(--text-muted);"></i>
                    </div>
                    <div style="font-weight: bold; color: white; font-size: 13px;">${item.label || item.name}</div>
                    <div style="font-size: 10px; color: var(--text-muted); font-family: monospace; margin-bottom: 5px;">${item.name}</div>
                    <div style="display: flex; gap: 5px; width: 100%;">
                        <input type="number" id="qty-${item.name}" value="1" min="1" class="text-input" style="width: 50px; padding: 4px; text-align: center;">
                        <button class="spawn-btn" onclick="giveItem('${item.name}')" style="flex: 1;">Give</button>
                    </div>
                `;
        container.appendChild(div);
    });
}

window.filterItemList = function (query) {
    const lowerQuery = query.toLowerCase();
    const filtered = window.allItems.filter(item =>
        (item.label && item.label.toLowerCase().includes(lowerQuery)) ||
        item.name.toLowerCase().includes(lowerQuery)
    );

    const container = document.getElementById('item-list-container');
    if (!container) return;
    container.innerHTML = '';

    if (filtered.length === 0) {
        container.innerHTML = '<div style="text-align: center; padding: 20px; color: var(--text-muted); grid-column: 1 / -1;">No matches found</div>';
        return;
    }

    filtered.slice(0, 50).forEach(item => {
        const div = document.createElement('div');
        div.className = 'player-card';
        div.style.flexDirection = 'column';
        div.style.alignItems = 'center';
        div.style.gap = '5px';
        div.style.textAlign = 'center';

        // Construct Image URL (Support custom image names)
        let imageUrl;
        if (item.image) {
            if (item.image.includes('.')) {
                imageUrl = `nui://ox_inventory/web/images/${item.image}`;
            } else {
                imageUrl = `nui://ox_inventory/web/images/${item.image}.png`;
            }
        } else {
            imageUrl = `nui://ox_inventory/web/images/${item.name}.png`;
        }

        div.innerHTML = `
                    <div style="width: 64px; height: 64px; display: flex; align-items: center; justify-content: center; margin-bottom: 5px;">
                        <img src="${imageUrl}" style="max-width: 100%; max-height: 100%;" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                        <i class="fas fa-box" style="display: none; font-size: 24px; color: var(--text-muted);"></i>
                    </div>
                    <div style="font-weight: bold; color: white; font-size: 13px;">${item.label || item.name}</div>
                    <div style="font-size: 10px; color: var(--text-muted); font-family: monospace; margin-bottom: 5px;">${item.name}</div>
                    <div style="display: flex; gap: 5px; width: 100%;">
                        <input type="number" id="qty-${item.name}" value="1" min="1" class="text-input" style="width: 50px; padding: 4px; text-align: center;">
                        <button class="spawn-btn" onclick="giveItem('${item.name}')" style="flex: 1;">Give</button>
                    </div>
                `;
        container.appendChild(div);
    });
}

window.giveItem = function (name) {
    const qtyInput = document.getElementById(`qty-${name}`);
    const count = parseInt(qtyInput.value) || 1;

    fetch(`https://${GetParentResourceName()}/giveItem`, {
        method: 'POST',
        body: JSON.stringify({ item: name, count: count })
    });
};

// Notification System for Lua
window.addEventListener('message', function (event) {
    if (event.data.action === 'showNotification') {
        showCopyNotification(event.data.message);
    }
});

// Ensure showCopyNotification is available (if not found in legacy code, we verify/add it here)
if (typeof showCopyNotification === 'undefined') {
    window.showCopyNotification = function (text) {
        const existing = document.querySelector('.copy-notification');
        if (existing) existing.remove();

        const el = document.createElement('div');
        el.className = 'copy-notification';
        el.innerHTML = `<i class="fas fa-info-circle"></i> ${text}`;

        // Style matching the requested "design" (Toast)
        el.style.position = 'fixed';
        el.style.bottom = '30px';
        el.style.left = '50%';
        el.style.transform = 'translateX(-50%) translateY(20px)';
        el.style.background = 'rgba(25, 25, 35, 0.95)';
        el.style.border = '1px solid var(--accent-red)';
        el.style.padding = '12px 24px';
        el.style.borderRadius = '8px';
        el.style.color = 'white';
        el.style.fontSize = '14px';
        el.style.fontWeight = '500';
        el.style.boxShadow = '0 5px 20px rgba(0,0,0,0.5)';
        el.style.zIndex = '9999';
        el.style.opacity = '0';
        el.style.transition = 'all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
        el.style.display = 'flex';
        el.style.alignItems = 'center';
        el.style.gap = '10px';

        document.body.appendChild(el);

        // Animate in
        requestAnimationFrame(() => {
            el.style.opacity = '1';
            el.style.transform = 'translateX(-50%) translateY(0)';
        });

        setTimeout(() => {
            el.style.opacity = '0';
            el.style.transform = 'translateX(-50%) translateY(20px)';
            setTimeout(() => el.remove(), 300);
        }, 3000);
    }
}

function loadKeybinds(savedBinds) {
    if (!savedBinds) return;
    document.querySelectorAll('.key-input').forEach(input => {
        const action = input.getAttribute('data-action');
        if (savedBinds[action]) {
            input.value = savedBinds[action];
            if (savedBinds[action] === "UNBOUND") {
                input.style.color = "#777777";
                input.style.textShadow = "none";
            } else {
                input.style.color = ""; // resets to CSS default
                input.style.textShadow = "";
            }
        } else {
            input.value = "UNBOUND";
            input.style.color = "#777777";
            input.style.textShadow = "none";
        }
    });
}

// Canvas FOV Drawing Logic
let fovCanvas = document.getElementById('fovCanvas');
let ctx = fovCanvas.getContext('2d');

function resizeCanvas() {
    fovCanvas.width = window.innerWidth;
    fovCanvas.height = window.innerHeight;
}
window.addEventListener('resize', resizeCanvas);
resizeCanvas(); // Initial size

function drawFovCircle(fov, color) {
    ctx.clearRect(0, 0, fovCanvas.width, fovCanvas.height);
    if (!fov || fov <= 0) return;
    
    // fov is 0-500 scale. Assuming 150 = ~150px radius or screen percentage.
    // In FiveM 3D to 2D distance is usually 0.0 to 1.0. Let's assume the passed fov is radius in pixels for UI simplicity.
    // Or rather, let's map it based on screen height so it scales nicely.
    // A fov of 150 could be 150 pixels at 1080p.
    let radius = (fov / 1080) * window.innerHeight;
    
    ctx.beginPath();
    ctx.arc(fovCanvas.width / 2, fovCanvas.height / 2, radius, 0, 2 * Math.PI, false);
    ctx.lineWidth = 2;
    ctx.strokeStyle = color || 'rgba(255, 0, 0, 0.5)';
    ctx.setLineDash([5, 5]);
    ctx.stroke();
}

window.addEventListener('message', function(event) {
    let data = event.data;
    if (data.type === 'drawFov') {
        drawFovCircle(data.fov, data.color);
    } else if (data.type === 'clearFov') {
        ctx.clearRect(0, 0, fovCanvas.width, fovCanvas.height);
    }
});

// Event listeners for custom inputs (ranges and selects)
document.addEventListener('input', function(event) {
    if (event.target.classList.contains('custom-range')) {
        const id = event.target.id;
        const value = parseInt(event.target.value);
        if (!id) return;
        
        // Optionally update a visual text indicator here if you add one next to sliders
        
        fetch(`https://${GetParentResourceName()}/updateConfig`, {
            method: 'POST',
            body: JSON.stringify({ id: id, value: value })
        });
    }
});

document.addEventListener('change', function(event) {
    if (event.target.classList.contains('custom-select')) {
        const id = event.target.id;
        const value = event.target.value;
        if (!id) return;
        
        fetch(`https://${GetParentResourceName()}/updateConfig`, {
            method: 'POST',
            body: JSON.stringify({ id: id, value: value })
        });
    }
});
