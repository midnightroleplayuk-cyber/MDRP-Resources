/**
 * Mock Data for tw-litejobpack NUI
 * Load this BEFORE app.js to intercept postNUI and inject mock data.
 * Usage: Add <script src="./js/mock.js"></script> before app.js in index.html
 * Remove or comment out for production builds.
 */
(function () {
    const IN_FIVEM = !!window.GetParentResourceName;

    // In browser: always active. In FiveM: wait for MOCK_PANEL_OPEN message.
    if (!IN_FIVEM) {
        console.log('[MOCK] Mock mode active — intercepting NUI calls');
    }

    // ===========================
    // MOCK JOBS (all 23)
    // ===========================
    const MOCK_JOBS = [
        {
            id: 'miner', name: 'Miner', subtitle: 'Underground Mining Operations',
            icon: './img/jobs/miner_icon.svg', image: './img/jobs/miner_bg.png', video: null,
            description: ['Extract valuable ores from underground deposits', 'Use mining equipment to break rocks', 'Transport materials to processing facility', 'Work as a team for bonus rewards'],
            items: [{ name: 'Pickaxe', image: './img/items/pickaxe.png' }, { name: 'Mining Helmet', image: './img/items/helmet.png' }, { name: 'Ore Cart', image: './img/items/cart.png' }],
            location: { label: 'Quarry Mine', x: 2954.0, y: 2774.0, z: 39.0 },
        },
        {
            id: 'lumberjack', name: 'Lumberjack', subtitle: 'Forest Logging Operations',
            icon: './img/jobs/lumberjack_icon.svg', image: './img/jobs/lumberjack_bg.png', video: null,
            description: ['Cut down trees in designated logging areas', 'Process logs into lumber at the sawmill', 'Load and transport wood to buyers', 'Manage sustainable forestry practices'],
            items: [{ name: 'Chainsaw', image: './img/items/chainsaw.png' }, { name: 'Safety Vest', image: './img/items/vest.png' }, { name: 'Flatbed Truck', image: './img/items/flatbed.png' }],
            location: { label: 'Paleto Forest', x: -537.0, y: 5327.0, z: 74.0 },
        },
        {
            id: 'cleanup', name: 'Cleanup Collector', subtitle: 'City Sanitation Services',
            icon: './img/jobs/cleanup_icon.svg', image: './img/jobs/cleanup_bg.png', video: null,
            description: ['Collect cleanup from residential areas', 'Sort recyclable materials for bonus pay', 'Operate cleanup truck along routes', 'Maintain city cleanliness standards'],
            items: [{ name: 'Cleanup Bag', image: './img/items/cleanup_bag.png' }, { name: 'Work Gloves', image: './img/items/gloves.png' }, { name: 'Cleanup Truck', image: './img/items/cleanup_truck.png' }],
            location: { label: 'Sanitation Depot', x: -322.0, y: -1545.0, z: 31.0 },
        },
        {
            id: 'trucker', name: 'Trucker', subtitle: 'Long Haul Delivery',
            icon: './img/jobs/trucker_icon.svg', image: './img/jobs/trucker_bg.png', video: null,
            description: ['Deliver cargo across the state', 'Handle fragile and hazardous materials', 'Meet delivery deadlines for bonuses', 'Discover illegal cargo opportunities'],
            items: [{ name: 'Delivery Manifest', image: './img/items/manifest.png' }, { name: 'Truck Keys', image: './img/items/keys.png' }],
            location: { label: 'Trucking Depot', x: 155.0, y: -3210.0, z: 5.9 },
        },
        {
            id: 'fishing', name: 'Fisherman', subtitle: 'Deep Sea & Shore Fishing',
            icon: './img/jobs/fishing_icon.svg', image: './img/jobs/fishing_bg.png', video: null,
            description: ['Fish at various locations around the island', 'Catch rare species for bonus rewards', 'Complete fishing minigame challenges', 'Sell your catch at the market'],
            items: [{ name: 'Fishing Rod', image: './img/items/fishing_rod.png' }, { name: 'Bait Box', image: './img/items/bait.png' }],
            location: { label: 'Fishing Dock', x: -1850.0, y: -1248.0, z: 8.6 },
        },
        {
            id: 'taxi', name: 'Taxi Driver', subtitle: 'City Transportation',
            icon: './img/jobs/taxi_icon.svg', image: './img/jobs/taxi_bg.png', video: null,
            description: ['Pick up passengers across the city', 'Complete trips within time bonuses', 'Earn tips for safe driving', 'Unlock illegal fare routes'],
            items: [{ name: 'Taxi License', image: './img/items/license.png' }, { name: 'GPS Device', image: './img/items/gps.png' }],
            location: { label: 'Taxi Depot', x: 895.0, y: -179.0, z: 74.7 },
        },
        {
            id: 'powerlines', name: 'Powerlines', subtitle: 'Electrical Repair Services',
            icon: './img/jobs/powerlines_icon.svg', image: './img/jobs/powerlines_bg.png', video: null,
            description: ['Repair electrical panels and poles', 'Complete wiring minigames', 'Restore power to different districts', 'Handle high-voltage equipment safely'],
            items: [{ name: 'Wire Cutters', image: './img/items/wirecutters.png' }, { name: 'Multimeter', image: './img/items/multimeter.png' }],
            location: { label: 'Power Station', x: 724.0, y: 133.0, z: 80.0 },
        },
        {
            id: 'farmer', name: 'Farmer', subtitle: 'Agricultural Operations',
            icon: './img/jobs/farmer_icon.svg', image: './img/jobs/farmer_bg.png', video: null,
            description: ['Harvest crops from farming fields', 'Process and package farm products', 'Deliver goods to market', 'Manage seasonal crop rotations'],
            items: [{ name: 'Sickle', image: './img/items/sickle.png' }, { name: 'Basket', image: './img/items/basket.png' }],
            location: { label: "Grapeseed Farm", x: 2414.0, y: 4992.0, z: 46.0 },
        },
        {
            id: 'hunting', name: 'Hunter', subtitle: 'Wildlife Hunting',
            icon: './img/jobs/hunting_icon.svg', image: './img/jobs/hunting_bg.png', video: null,
            description: ['Track and hunt wild animals', 'Process pelts and meat', 'Store catches in vehicle trunk', 'Respect hunting zone boundaries'],
            items: [{ name: 'Hunting Rifle', image: './img/items/rifle.png' }, { name: 'Hunting Knife', image: './img/items/knife.png' }],
            location: { label: 'Hunting Lodge', x: -663.0, y: 5760.0, z: 17.3 },
        },
        {
            id: 'diving', name: 'Diver', subtitle: 'Underwater Salvage',
            icon: './img/jobs/diving_icon.svg', image: './img/jobs/diving_bg.png', video: null,
            description: ['Dive for underwater treasures', 'Manage oxygen levels carefully', 'Collect valuable salvage items', 'Return to boat before air runs out'],
            items: [{ name: 'Scuba Tank', image: './img/items/scuba.png' }, { name: 'Dive Bag', image: './img/items/divebag.png' }],
            location: { label: 'Marina Dock', x: -807.0, y: -1496.0, z: 1.6 },
        },
        {
            id: 'cleaner', name: 'Cleaner', subtitle: 'Professional Cleaning',
            icon: './img/jobs/cleaner_icon.svg', image: './img/jobs/cleaner_bg.png', video: null,
            description: ['Clean stains and messes around the city', 'Use professional cleaning equipment', 'Cover assigned cleaning zones', 'Earn bonuses for speed'],
            items: [{ name: 'Mop', image: './img/items/mop.png' }, { name: 'Cleaning Solution', image: './img/items/solution.png' }],
            location: { label: 'Cleaning Co.', x: -55.0, y: -1757.0, z: 29.0 },
        },
        {
            id: 'powerwash', name: 'Powerwasher', subtitle: 'High Pressure Cleaning',
            icon: './img/jobs/powerwash_icon.svg', image: './img/jobs/powerwash_bg.png', video: null,
            description: ['Power wash dirty surfaces', 'Use high-pressure water equipment', 'Clean buildings and vehicles', 'Complete zones for payment'],
            items: [{ name: 'Pressure Washer', image: './img/items/washer.png' }, { name: 'Hose', image: './img/items/hose.png' }],
            location: { label: 'Powerwash Depot', x: -70.0, y: -1761.0, z: 29.0 },
        },
        {
            id: 'windowscleaner', name: 'Window Cleaner', subtitle: 'Glass Cleaning Services',
            icon: './img/jobs/windowscleaner_icon.svg', image: './img/jobs/windowscleaner_bg.png', video: null,
            description: ['Clean windows on buildings', 'Work at various heights', 'Use professional squeegee tools', 'Earn bonuses for streak-free finish'],
            items: [{ name: 'Squeegee', image: './img/items/squeegee.png' }, { name: 'Bucket', image: './img/items/bucket.png' }],
            location: { label: 'Window Co.', x: -42.0, y: -1748.0, z: 29.0 },
        },
        {
            id: 'cardetailer', name: 'Car Detailer', subtitle: 'Mobile Car Detailing Service',
            icon: './img/jobs/cardetailer_icon.svg', image: './img/jobs/cardetailer_bg.png', video: null,
            description: ['Wash dirty customer cars with pressure wand', 'Polish and wax for bonus pay', 'Water tank with hose on your van', 'Higher levels unlock premium cars'],
            items: [{ name: 'Pressure Wand', image: './img/items/roller.png' }, { name: 'Wax Cloth', image: './img/items/cloth.png' }],
            location: { label: 'Car Detailing Depot', x: -700.0, y: -934.0, z: 19.0 },
        },
        {
            id: 'landscaping', name: 'Landscaping', subtitle: 'Landscaping & Gardening',
            icon: './img/jobs/landscaping_icon.svg', image: './img/jobs/landscaping_bg.png', video: null,
            description: ['Trim hedges and mow lawns', 'Plant flowers and trees', 'Maintain public parks', 'Use landscaping equipment'],
            items: [{ name: 'Hedge Trimmer', image: './img/items/trimmer.png' }, { name: 'Garden Shears', image: './img/items/shears.png' }],
            location: { label: 'Garden Center', x: -1233.0, y: -1474.0, z: 4.3 },
        },
        {
            id: 'dogwalking', name: 'Dog Walker', subtitle: 'Pet Walking Services',
            icon: './img/jobs/dogwalking_icon.svg', image: './img/jobs/dogwalking_bg.png', video: null,
            description: ['Walk dogs through designated routes', 'Keep dogs happy and exercised', 'Handle multiple dogs at once', 'Return dogs safely to owner'],
            items: [{ name: 'Dog Leash', image: './img/items/leash.png' }, { name: 'Dog Treats', image: './img/items/treats.png' }],
            location: { label: 'Pet Center', x: -1298.0, y: -1187.0, z: 4.9 },
        },
        {
            id: 'delivery', name: 'Delivery Driver', subtitle: 'Package Delivery',
            icon: './img/jobs/delivery_icon.svg', image: './img/jobs/delivery_bg.png', video: null,
            description: ['Deliver packages to addresses', 'Meet delivery time windows', 'Handle fragile items carefully', 'Navigate efficient routes'],
            items: [{ name: 'Package', image: './img/items/package.png' }, { name: 'Scanner', image: './img/items/scanner.png' }],
            location: { label: 'Delivery Hub', x: 70.0, y: -1399.0, z: 29.3 },
        },
        {
            id: 'newspaper', name: 'Newspaper Delivery', subtitle: 'Morning Paper Route',
            icon: './img/jobs/newspaper_icon.svg', image: './img/jobs/newspaper_bg.png', video: null,
            description: ['Deliver newspapers to mailboxes', 'Cover your assigned neighborhood', 'Throw papers accurately', 'Complete route before deadline'],
            items: [{ name: 'Newspaper Stack', image: './img/items/newspaper.png' }, { name: 'Bicycle', image: './img/items/bicycle.png' }],
            location: { label: 'News Office', x: -1080.0, y: -247.0, z: 37.7 },
        },
        {
            id: 'forklift', name: 'Forklift Operator', subtitle: 'Warehouse Logistics',
            icon: './img/jobs/forklift_icon.svg', image: './img/jobs/forklift_bg.png', video: null,
            description: ['Operate forklift in warehouse', 'Move pallets to designated areas', 'Stack cargo efficiently', 'Meet loading quotas'],
            items: [{ name: 'Forklift Key', image: './img/items/forklift_key.png' }, { name: 'Hard Hat', image: './img/items/hardhat.png' }],
            location: { label: 'Warehouse District', x: 1088.0, y: -1990.0, z: 30.9 },
        },
        {
            id: 'warehouse', name: 'Warehouse Worker', subtitle: 'Storage & Distribution',
            icon: './img/jobs/warehouse_icon.svg', image: './img/jobs/warehouse_bg.png', video: null,
            description: ['Sort and organize warehouse goods', 'Load trucks for delivery', 'Track inventory levels', 'Manage storage operations'],
            items: [{ name: 'Clipboard', image: './img/items/clipboard.png' }, { name: 'Hand Truck', image: './img/items/handtruck.png' }],
            location: { label: 'Warehouse', x: 1068.0, y: -2006.0, z: 31.0 },
        },
        {
            id: 'orange', name: 'Orange Picker', subtitle: 'Citrus Harvesting',
            icon: './img/jobs/orange_icon.svg', image: './img/jobs/orange_bg.png', video: null,
            description: ['Pick oranges from orchards', 'Fill baskets with fresh fruit', 'Transport oranges to packing', 'Work in Grapeseed orchards'],
            items: [{ name: 'Picking Basket', image: './img/items/orange_basket.png' }, { name: 'Gloves', image: './img/items/gloves.png' }],
            location: { label: 'Orange Orchard', x: 2557.0, y: 4663.0, z: 34.0 },
        },
        {
            id: 'scrapyard', name: 'Scrapyard Worker', subtitle: 'Metal Recycling',
            icon: './img/jobs/scrapyard_icon.svg', image: './img/jobs/scrapyard_bg.png', video: null,
            description: ['Collect and process scrap metal', 'Dismantle vehicles for parts', 'Sort recyclable materials', 'Operate crushing equipment'],
            items: [{ name: 'Angle Grinder', image: './img/items/grinder.png' }, { name: 'Safety Goggles', image: './img/items/goggles.png' }],
            location: { label: 'Scrapyard', x: 2335.0, y: 3135.0, z: 48.2 },
        },
    ];

    // ===========================
    // MOCK PLAYER DATA
    // ===========================
    const MOCK_PLAYER = {
        identifier: 'steam:1100001ABCDEF',
        name: 'John Doe',
        avatar: 'https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png',
        owner: true,
        currencySymbol: '$',
    };

    // ===========================
    // MOCK JOB LEVELS (per job)
    // ===========================
    const MOCK_JOB_LEVELS = {};
    MOCK_JOBS.forEach(j => {
        const lvl = Math.floor(Math.random() * 10) + 1;
        const xp = Math.floor(Math.random() * 900) + 100;
        MOCK_JOB_LEVELS[j.id] = { level: lvl, xp: xp, nextXp: 1000, totalXP: lvl * 1000 + xp };
    });

    // ===========================
    // MOCK LOBBY MEMBERS
    // ===========================
    const MOCK_LOBBY = [
        { playerSource: 1, playerIdentifier: 'steam:1100001ABCDEF', playerName: 'John Doe', playerLevel: 5, playerImage: 'https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png', playerOwner: true },
        { playerSource: 2, playerIdentifier: 'steam:1100002BCDEFG', playerName: 'Jane Smith', playerLevel: 3, playerImage: 'https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png', playerOwner: false },
    ];

    // ===========================
    // MOCK NEARBY PLAYERS
    // ===========================
    const MOCK_NEARBY = [
        { playerSource: 3, playerIdentifier: 'steam:1100003CDEFGH', playerName: 'Bob Wilson', playerLevel: 2, playerImage: 'https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png', playerOwner: false },
        { playerSource: 4, playerIdentifier: 'steam:1100004DEFGHI', playerName: 'Alice Brown', playerLevel: 7, playerImage: 'https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png', playerOwner: false },
    ];

    // ===========================
    // MOCK LEADERBOARD
    // ===========================
    function generateLeaderboard(jobId) {
        const names = ['ProGamer', 'ShadowWolf', 'CrystalMiner', 'NightOwl', 'SpeedDemon', 'BlueFox', 'IronHeart', 'StormRider', 'GoldenEagle', 'SilverBlade', 'DarkPhoenix', 'FrostByte', 'RedViper', 'AceHunter', 'LoneRanger', 'MadHatter', 'ThunderClap', 'ViperKing', 'GhostRider', 'TitanFall'];
        return names.map((name, i) => ({
            playerSource: 100 + i,
            playerIdentifier: `steam:LB${i}`,
            playerName: name,
            playerLevel: 20 - i,
            playerImage: 'https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png',
        }));
    }

    // ===========================
    // MOCK QUEST DATA
    // ===========================
    const MOCK_QUESTS = [
        { id: 'daily_miner_collect', jobId: 'miner', progress: 3, target: 5, completed: false, reward: { type: 'money', amount: 500 }, icon: './img/jobs/miner_icon.svg' },
        { id: 'weekly_miner_process', jobId: 'miner', progress: 12, target: 30, completed: false, reward: { type: 'xp', amount: 1000 }, icon: './img/jobs/miner_icon.svg' },
        { id: 'monthly_miner_earn', jobId: 'miner', progress: 10000, target: 10000, completed: true, reward: { type: 'money', amount: 2000 }, icon: './img/jobs/miner_icon.svg' },
        { id: 'daily_lumber_collect', jobId: 'lumberjack', progress: 5, target: 5, completed: true, reward: { type: 'money', amount: 750 }, icon: './img/jobs/lumberjack_icon.svg' },
        { id: 'weekly_lumber_process', jobId: 'lumberjack', progress: 8, target: 25, completed: false, reward: { type: 'xp', amount: 1500 }, icon: './img/jobs/lumberjack_icon.svg' },
        { id: 'daily_scrap_collect', jobId: 'cleanup', progress: 2, target: 5, completed: false, reward: { type: 'money', amount: 400 }, icon: './img/jobs/cleanup_icon.svg' },
        { id: 'daily_hunting_collect', jobId: 'hunting', progress: 0, target: 3, completed: false, reward: { type: 'xp', amount: 2000 }, icon: './img/jobs/hunting_icon.svg' },
    ];

    // ===========================
    // MOCK UPGRADE JOBS
    // ===========================
    const MOCK_UPGRADE_JOBS = MOCK_JOBS.slice(0, 8).map(j => {
        const pLevel = MOCK_JOB_LEVELS[j.id].level;
        const levels = [
            { level: 1, label: 'Basic Tools',   price: 0,    state: 'active',    canPurchase: false, requiredLevel: 1 },
            { level: 2, label: 'Intermediate',   price: 500,  state: 'locked',    canPurchase: pLevel >= 2, requiredLevel: 2 },
            { level: 3, label: 'Advanced',       price: 1500, state: 'locked',    canPurchase: pLevel >= 3, requiredLevel: 3 },
            { level: 4, label: 'Expert',         price: 3000, state: 'locked',    canPurchase: pLevel >= 4, requiredLevel: 4 },
            { level: 5, label: 'Master',         price: 5000, state: 'locked',    canPurchase: pLevel >= 5, requiredLevel: 5 },
        ];
        return {
            id: j.id,
            name: j.name,
            icon: j.icon,
            description: j.subtitle || '',
            level: pLevel,
            maxLevel: 5,
            levelProgress: Math.floor((MOCK_JOB_LEVELS[j.id].xp / MOCK_JOB_LEVELS[j.id].nextXp) * 100),
            toolImage: './img/upgrade-icon.svg',
            toolName: j.name + ' Tools',
            toolDesc: 'Efficiency upgrade',
            upgradeLevels: levels,
            allLevelsUnlocked: false,
            nextUpgrade: {
                price: 500,
                requiredLevel: 2,
            },
        };
    });

    // ===========================
    // MOCK PERKS DATA
    // ===========================
    const MOCK_AVAILABLE_PERKS = {
        trunk_capacity: {
            name: 'Heavy Lifter', desc: 'Increases vehicle trunk capacity.',
            tiers: { 1: { cost: 1, multiplier: 1.25, desc: '+25% trunk capacity.' }, 2: { cost: 2, multiplier: 1.50, desc: '+50% trunk capacity.' }, 3: { cost: 3, multiplier: 2.00, desc: '+100% trunk capacity.' } }
        },
        strong_muscles: {
            name: 'Strong Muscles', desc: 'Increases movement speed while carrying heavy loads.',
            tiers: { 1: { cost: 1, multiplier: 1.10, desc: 'Walk 10% faster while carrying.' }, 2: { cost: 2, multiplier: 1.20, desc: 'Walk 20% faster while carrying.' }, 3: { cost: 4, multiplier: 1.20, desc: 'Unlock sprinting while carrying.' } }
        },
        negotiator: {
            name: 'Negotiator', desc: 'Earn more money from job payouts.',
            tiers: { 1: { cost: 1, multiplier: 1.05, desc: '+5% earnings from all jobs.' }, 2: { cost: 2, multiplier: 1.10, desc: '+10% earnings from all jobs.' }, 3: { cost: 3, multiplier: 1.15, desc: '+15% earnings from all jobs.' } }
        },
        lucky_strike: {
            name: 'Lucky Strike', desc: 'Chance to earn double money on processing.',
            tiers: { 1: { cost: 2, multiplier: 0.10, desc: '10% chance for x2 payout.' }, 2: { cost: 3, multiplier: 0.20, desc: '20% chance for x2 payout.' }, 3: { cost: 4, multiplier: 0.30, desc: '30% chance for x2 payout.' } }
        },
        xp_boost: {
            name: 'Quick Learner', desc: 'Gain more XP from all job actions.',
            tiers: { 1: { cost: 1, multiplier: 1.10, desc: '+10% XP from all jobs.' }, 2: { cost: 2, multiplier: 1.20, desc: '+20% XP from all jobs.' }, 3: { cost: 3, multiplier: 1.30, desc: '+30% XP from all jobs.' } }
        },
        speed_demon: {
            name: 'Speed Demon', desc: 'Improves job vehicle engine performance.',
            tiers: { 1: { cost: 2, multiplier: 1.10, desc: '+10% engine power.' }, 2: { cost: 3, multiplier: 1.20, desc: '+20% engine power.' }, 3: { cost: 4, multiplier: 1.35, desc: '+35% engine power.' } }
        },
        breath_capacity: {
            name: 'Deep Breather', desc: 'Increases underwater breath capacity.',
            tiers: { 1: { cost: 2, multiplier: 1.25, desc: '+25% breath capacity.' }, 2: { cost: 3, multiplier: 1.50, desc: '+50% breath capacity.' }, 3: { cost: 5, multiplier: 2.00, desc: '+100% breath capacity.' } }
        },
        repair_speed: {
            name: 'Grease Monkey', desc: 'Fix vehicles faster.',
            tiers: { 1: { cost: 2, multiplier: 0.90, desc: '10% faster repairs.' }, 2: { cost: 3, multiplier: 0.75, desc: '25% faster repairs.' }, 3: { cost: 5, multiplier: 0.50, desc: '50% faster repairs.' } }
        },
        store_discount: {
            name: 'Silver Tongue', desc: 'Get off-duty store discounts.',
            tiers: { 1: { cost: 3, multiplier: 0.05, desc: '5% off at stores.' }, 2: { cost: 4, multiplier: 0.10, desc: '10% off at stores.' }, 3: { cost: 5, multiplier: 0.15, desc: '15% off at stores.' } }
        },
    };

    // ===========================
    // MOCK JOB STATISTICS
    // ===========================
    const MOCK_STATISTICS = {
        totalEarn: 45750,
        totalExp: 12800,
        history: [
            { jobId: 'miner', jobName: 'Miner', earnings: 1250, xp: 500, date: '2026-03-07', duration: '25 min' },
            { jobId: 'trucker', jobName: 'Trucker', earnings: 2100, xp: 800, date: '2026-03-07', duration: '35 min' },
            { jobId: 'fishing', jobName: 'Fisherman', earnings: 890, xp: 350, date: '2026-03-06', duration: '20 min' },
            { jobId: 'cleanup', jobName: 'Cleanup Collector', earnings: 1500, xp: 600, date: '2026-03-06', duration: '30 min' },
            { jobId: 'lumberjack', jobName: 'Lumberjack', earnings: 1800, xp: 700, date: '2026-03-05', duration: '28 min' },
        ],
    };

    // ===========================
    // MOCK ADMIN DASHBOARD (realistic data matching server structure)
    // ===========================
    const MOCK_ADMIN_DASHBOARD = {
        economy: {
            todayMoney: 47250,
            todayXp: 3180,
            weekMoney: 218740,
            weekXp: 14520,
            allMoney: 12480000,
            allXp: 892000,
            jobsToday: 56,
        },
        jobBreakdown: [
            { jobId: 'miner', jobName: 'Miner', totalMoney: 52300, completions: 187, uniquePlayers: 34 },
            { jobId: 'trucker', jobName: 'Trucker', totalMoney: 41200, completions: 142, uniquePlayers: 28 },
            { jobId: 'lumberjack', jobName: 'Lumberjack', totalMoney: 33800, completions: 121, uniquePlayers: 22 },
            { jobId: 'cleanup', jobName: 'Cleanup Collector', totalMoney: 28900, completions: 108, uniquePlayers: 19 },
            { jobId: 'fishing', jobName: 'Fisherman', totalMoney: 24600, completions: 94, uniquePlayers: 18 },
            { jobId: 'hunting', jobName: 'Hunter', totalMoney: 19400, completions: 67, uniquePlayers: 14 },
            { jobId: 'diving', jobName: 'Diver', totalMoney: 15200, completions: 52, uniquePlayers: 11 },
            { jobId: 'taxi', jobName: 'Taxi Driver', totalMoney: 12800, completions: 48, uniquePlayers: 9 },
        ],
        activeLobbies: [
            {
                ownerName: 'Alex Turner', jobId: 'miner', state: 'active', playerCount: 3,
                players: [{ name: 'Alex Turner', source: 1 }, { name: 'Jake Wilson', source: 5 }, { name: 'Sam Rivera', source: 8 }],
            },
            {
                ownerName: 'Chris Evans', jobId: 'trucker', state: 'active', playerCount: 2,
                players: [{ name: 'Chris Evans', source: 3 }, { name: 'Diana Park', source: 12 }],
            },
            {
                ownerName: 'Mike Chen', jobId: 'lumberjack', state: 'lobby', playerCount: 1,
                players: [{ name: 'Mike Chen', source: 7 }],
            },
            {
                ownerName: 'Emma Garcia', jobId: 'fishing', state: 'active', playerCount: 2,
                players: [{ name: 'Emma Garcia', source: 14 }, { name: 'Liam Brooks', source: 16 }],
            },
            {
                ownerName: 'Ryan Foster', jobId: 'cleanup', state: 'active', playerCount: 3,
                players: [{ name: 'Ryan Foster', source: 4 }, { name: 'Noah Kim', source: 9 }, { name: 'Ava Johnson', source: 11 }],
            },
        ],
        marketPrices: {
            miner: { current: 62.50, base: 50.00, multiplier: 1.25, trend: 'up', percent: 125, min: 25.00, max: 100.00 },
            lumberjack: { current: 38.00, base: 40.00, multiplier: 0.95, trend: 'down', percent: 95, min: 20.00, max: 80.00 },
            fishing: { current: 45.00, base: 45.00, multiplier: 1.00, trend: 'stable', percent: 100, min: 22.50, max: 90.00 },
            hunting: { current: 78.40, base: 60.00, multiplier: 1.31, trend: 'up', percent: 131, min: 30.00, max: 120.00 },
            diving: { current: 88.00, base: 80.00, multiplier: 1.10, trend: 'up', percent: 110, min: 40.00, max: 160.00 },
            cleanup: { current: 28.50, base: 30.00, multiplier: 0.95, trend: 'down', percent: 95, min: 15.00, max: 60.00 },
        },
        onlineCount: 42,
    };

    // ===========================
    // MOCK DAILY BONUS & WEATHER
    // ===========================
    const MOCK_DAILY_BONUS = { miner: 1.25, fishing: 1.15 };
    const MOCK_WEATHER = { weather: 'CLEAR', multipliers: { cleaner: 1.0, powerwash: 0.85 } };
    const MOCK_SHIFT = { shift: 'day', label: 'Day Shift', multipliers: { default: 1.0 } };

    // ===========================
    // MOCK ACHIEVEMENTS
    // ===========================
    const MOCK_ACHIEVEMENTS = {
        enabled: true,
        definitions: [
            { id: 'first_job', label: 'First Steps', desc: 'Complete your first job', type: 'jobs_completed', jobId: '*', target: 1, xpReward: 100 },
            { id: 'ten_jobs', label: 'Getting Started', desc: 'Complete 10 jobs', type: 'jobs_completed', jobId: '*', target: 10, xpReward: 500 },
            { id: 'fifty_jobs', label: 'Veteran Worker', desc: 'Complete 50 jobs', type: 'jobs_completed', jobId: '*', target: 50, xpReward: 2000 },
            { id: 'miner_10', label: 'Rock Breaker', desc: 'Complete 10 mining jobs', type: 'jobs_completed', jobId: 'miner', target: 10, xpReward: 750 },
            { id: 'trucker_10', label: 'Road Warrior', desc: 'Complete 10 trucker deliveries', type: 'jobs_completed', jobId: 'trucker', target: 10, xpReward: 750 },
            { id: 'fishing_10', label: 'Master Angler', desc: 'Complete 10 fishing trips', type: 'jobs_completed', jobId: 'fishing', target: 10, xpReward: 750 },
            { id: 'coop_5', label: 'Team Player', desc: 'Complete 5 coop jobs', type: 'coop_completed', jobId: '*', target: 5, xpReward: 1000 },
            { id: 'earn_50k', label: 'Money Maker', desc: 'Earn $50,000 total', type: 'money_earned', jobId: '*', target: 50000, xpReward: 1500 },
        ],
        achievements: { first_job: true, ten_jobs: true },
        stats: {
            '*:jobs_completed': 23,
            'miner:jobs_completed': 7,
            'trucker:jobs_completed': 4,
            'fishing:jobs_completed': 12,
            '*:coop_completed': 3,
            '*:money_earned': 32500,
        },
    };

    // ===========================
    // MOCK CONTRACT TIERS
    // ===========================
    const MOCK_CONTRACT_TIERS = [
        { id: 'bronze', label: 'Bronze', targetMult: 1.0, timeMinutes: 10, rewardMult: 1.25, locked: false, minLevel: 1 },
        { id: 'silver', label: 'Silver', targetMult: 1.5, timeMinutes: 15, rewardMult: 1.50, locked: false, minLevel: 3 },
        { id: 'gold', label: 'Gold', targetMult: 2.5, timeMinutes: 20, rewardMult: 2.00, locked: true, minLevel: 8 },
    ];

    // ===========================
    // postNUI INTERCEPTOR
    // ===========================
    // app.js loads AFTER mock.js (it's a module) and overwrites window.postNUI.
    // We use a polling approach to wrap it after app.js defines it.
    function mockResponse(name, data) {
        switch (name) {
            case 'checkNUI':
                return { ok: true };
            case 'closeNUI':
                return { ok: true };
            case 'startJob':
                setTimeout(() => dispatchNUI('JOB_STARTED', {}), 300);
                return { ok: true };
            case 'getLeaderboard':
                return { success: true, players: generateLeaderboard(data?.jobId || 'miner') };
            case 'invitePlayer':
                console.log('[MOCK] Invite player:', data);
                return { success: true };
            case 'kickPlayer':
                console.log('[MOCK] Kick player:', data);
                return { success: true };
            case 'respondInvite':
                return { success: true };
            case 'admin:refreshDashboard':
                return { success: true, data: MOCK_ADMIN_DASHBOARD };
            case 'admin:searchPlayer':
                return {
                    success: true, players: [
                        { identifier: 'steam:1100001ABCDEF', name: 'Alex Turner', source: 1, online: true },
                        { identifier: 'steam:1100002BCDEFG', name: 'Jake Wilson', source: 5, online: true },
                        { identifier: 'steam:1100003CDEFGH', name: 'Diana Park', source: 12, online: true },
                        { identifier: 'steam:1100004DEFGHI', name: 'Marcus Reed', source: null, online: false },
                        { identifier: 'steam:1100005EFGHIJ', name: 'Sophie Chen', source: null, online: false },
                    ]
                };
            case 'admin:getPlayerDetail':
                return {
                    success: true,
                    levels: {
                        miner: { jobName: 'Miner', level: 7, xp: 3400, totalXP: 8200 },
                        trucker: { jobName: 'Trucker', level: 4, xp: 1800, totalXP: 4100 },
                        lumberjack: { jobName: 'Lumberjack', level: 5, xp: 2100, totalXP: 5400 },
                        cleanup: { jobName: 'Cleanup Collector', level: 3, xp: 900, totalXP: 2200 },
                        fishing: { jobName: 'Fisherman', level: 6, xp: 2800, totalXP: 6900 },
                        hunting: { jobName: 'Hunter', level: 2, xp: 400, totalXP: 1100 },
                        diving: { jobName: 'Diver', level: 1, xp: 50, totalXP: 50 },
                        taxi: { jobName: 'Taxi Driver', level: 3, xp: 1200, totalXP: 2800 },
                        powerlines: { jobName: 'Powerlines', level: 4, xp: 1500, totalXP: 3600 },
                    },
                    history: [
                        { jobId: 'miner', region: 'Quarry', earnedMoney: 1850, earnedXp: 520, date: '2026-03-17T14:25:00Z' },
                        { jobId: 'trucker', region: 'Interstate', earnedMoney: 2400, earnedXp: 680, date: '2026-03-17T11:10:00Z' },
                        { jobId: 'fishing', region: 'Del Perro Pier', earnedMoney: 1100, earnedXp: 380, date: '2026-03-16T20:45:00Z' },
                        { jobId: 'lumberjack', region: 'Paleto Forest', earnedMoney: 1650, earnedXp: 470, date: '2026-03-16T16:30:00Z' },
                        { jobId: 'cleanup', region: 'Vinewood', earnedMoney: 1300, earnedXp: 410, date: '2026-03-15T13:20:00Z' },
                        { jobId: 'miner', region: 'Quarry', earnedMoney: 2100, earnedXp: 590, date: '2026-03-15T09:55:00Z' },
                        { jobId: 'hunting', region: 'Chiliad', earnedMoney: 1950, earnedXp: 540, date: '2026-03-14T18:40:00Z' },
                        { jobId: 'taxi', region: 'Downtown LS', earnedMoney: 980, earnedXp: 290, date: '2026-03-14T10:15:00Z' },
                    ],
                    perkPoints: 7,
                };
            case 'admin:close':
                return 'ok';
            case 'admin:setPlayerLevel':
                console.log('[MOCK] Set player level:', data);
                return { success: true, message: 'Level updated' };
            case 'admin:setPerkPoints':
                console.log('[MOCK] Set perk points:', data);
                return { success: true, message: 'Perk points updated' };
            case 'admin:setMarketPrice':
                console.log('[MOCK] Set market price:', data);
                if (MOCK_ADMIN_DASHBOARD.marketPrices[data?.jobId]) {
                    MOCK_ADMIN_DASHBOARD.marketPrices[data.jobId].current = data.price;
                    MOCK_ADMIN_DASHBOARD.marketPrices[data.jobId].multiplier = data.price / MOCK_ADMIN_DASHBOARD.marketPrices[data.jobId].base;
                    MOCK_ADMIN_DASHBOARD.marketPrices[data.jobId].percent = Math.round(MOCK_ADMIN_DASHBOARD.marketPrices[data.jobId].multiplier * 100);
                }
                return { success: true, message: 'Price updated' };
            case 'admin:resetMarket':
                console.log('[MOCK] Reset market:', data);
                if (data?.jobId === 'all') {
                    for (const key in MOCK_ADMIN_DASHBOARD.marketPrices) {
                        const mp = MOCK_ADMIN_DASHBOARD.marketPrices[key];
                        mp.current = mp.base; mp.multiplier = 1.0; mp.percent = 100; mp.trend = 'stable';
                    }
                } else if (MOCK_ADMIN_DASHBOARD.marketPrices[data?.jobId]) {
                    const mp = MOCK_ADMIN_DASHBOARD.marketPrices[data.jobId];
                    mp.current = mp.base; mp.multiplier = 1.0; mp.percent = 100; mp.trend = 'stable';
                }
                return { success: true, message: 'Market reset' };
            case 'admin:getEconomyConfig':
                return {
                    success: true,
                    jobs: [
                        {
                            id: 'miner', name: 'Miner', color: '#8B7355', enabled: true,
                            payment: { mode: 'perItem', coopMode: 'full', coopBonus: 1.0 },
                            payRates: [{ key: 'perOre', label: 'Per Ore', value: 50, source: 'payment' }],
                            qualityTiers: [
                                { name: 'Normal', chance: 65, multiplier: 1.0 },
                                { name: 'Silver', chance: 25, multiplier: 1.5 },
                                { name: 'Gold', chance: 10, multiplier: 2.5 },
                            ],
                            levelPayBonus: 0.05, levelChanceBonus: 0.5, economyItem: 'ore',
                        },
                        {
                            id: 'lumberjack', name: 'Lumberjack', color: '#2E7D32', enabled: true,
                            payment: { mode: 'perItem', coopMode: 'full', coopBonus: 1.0 },
                            payRates: [{ key: 'perLog', label: 'Per Log', value: 40, source: 'payment' }],
                            qualityTiers: [
                                { name: 'Pine', chance: 60, multiplier: 1.0 },
                                { name: 'Oak', chance: 30, multiplier: 1.4 },
                                { name: 'Redwood', chance: 10, multiplier: 2.0 },
                            ],
                            levelPayBonus: 0.04, levelChanceBonus: 0.4, economyItem: 'wood',
                        },
                        {
                            id: 'trucker', name: 'Trucker', color: '#1565C0', enabled: true,
                            payment: { mode: 'perDelivery', coopMode: 'split', coopBonus: 1.15 },
                            payRates: [
                                { key: 'perDelivery', label: 'Per Delivery', value: 350, source: 'payment' },
                                { key: 'distanceBonus', label: 'Distance Bonus', value: 2, source: 'bonus' },
                            ],
                            qualityTiers: null,
                            levelPayBonus: 0.06, levelChanceBonus: 0, economyItem: null,
                        },
                        {
                            id: 'fishing', name: 'Fisherman', color: '#0097A7', enabled: true,
                            payment: { mode: 'perItem', coopMode: 'full', coopBonus: 1.0 },
                            payRates: [{ key: 'perFish', label: 'Per Fish', value: 45, source: 'payment' }],
                            qualityTiers: [
                                { name: 'Common', chance: 55, multiplier: 1.0 },
                                { name: 'Rare', chance: 30, multiplier: 1.8 },
                                { name: 'Legendary', chance: 15, multiplier: 3.0 },
                            ],
                            levelPayBonus: 0.05, levelChanceBonus: 0.6, economyItem: 'fish',
                        },
                        {
                            id: 'cleanup', name: 'Cleanup Collector', color: '#6D4C41', enabled: true,
                            payment: { mode: 'perItem', coopMode: 'full', coopBonus: 1.0 },
                            payRates: [{ key: 'perBag', label: 'Per Bag', value: 30, source: 'payment' }],
                            qualityTiers: null,
                            levelPayBonus: 0.04, levelChanceBonus: 0, economyItem: null,
                        },
                        {
                            id: 'hunting', name: 'Hunter', color: '#33691E', enabled: true,
                            payment: { mode: 'perItem', coopMode: 'full', coopBonus: 1.0 },
                            payRates: [
                                { key: 'perPelt', label: 'Per Pelt', value: 60, source: 'payment' },
                                { key: 'perMeat', label: 'Per Meat', value: 25, source: 'payment' },
                            ],
                            qualityTiers: [
                                { name: 'Damaged', chance: 30, multiplier: 0.5 },
                                { name: 'Good', chance: 50, multiplier: 1.0 },
                                { name: 'Perfect', chance: 20, multiplier: 2.0 },
                            ],
                            levelPayBonus: 0.05, levelChanceBonus: 0.8, economyItem: 'pelts',
                        },
                    ],
                };
            case 'admin:saveEconomyConfig':
                console.log('[MOCK] Save economy config:', data);
                return { success: true, message: 'Economy config saved successfully' };
            case 'purchasePerk':
                console.log('[MOCK] Purchase perk:', data);
                return { success: true };
            case 'upgradeJobLevel':
                console.log('[MOCK] Upgrade job level:', data);
                return { success: true };
            case 'downgradeJobLevel':
                console.log('[MOCK] Downgrade job level:', data);
                return { success: true };
            case 'setLanguage':
                (async () => {
                    try {
                        const r = await fetch('./locales/' + (data?.locale || 'en') + '.json');
                        if (r.ok) dispatchNUI('SET_LOCALE', await r.json());
                    } catch (e) { console.warn('[MOCK] Failed to load locale:', data?.locale); }
                })();
                return { success: true };
            case 'saveSettings':
                return { success: true };
            case 'selectArea':
                return { success: true };
            case 'markLocation':
                return { success: true };
            case 'getContractTiers':
                return { enabled: true, tiers: MOCK_CONTRACT_TIERS, baseTarget: 5 };
            case 'selectContract':
                return { success: true };
            case 'acceptContract':
                return { success: true };
            case 'achievements:fetch':
                return MOCK_ACHIEVEMENTS;

            // Job Editor mock responses
            case 'jobeditor:selectJob':
                console.log('[MOCK] Job Editor: select job', data?.jobId);
                setTimeout(() => {
                    const jobId = data?.jobId || 'miner';
                    const editorData = {
                        miner: {
                            npcModel: 's_m_y_construct_02', npcScenario: 'WORLD_HUMAN_CLIPBOARD',
                            npcCoords: { x: 2954.13, y: 2774.39, z: 43.3, w: 349.75 },
                            blipSprite: 618, blipColor: 47,
                            vehModel: 'bison', vehPlate: 'MINE01',
                            vehSpawns: [{ x: 2944.04, y: 2773.83, z: 43.17, w: 170.0 }, { x: 2948.33, y: 2776.63, z: 43.55, w: 170.0 }],
                        },
                        lumberjack: {
                            npcModel: 's_m_y_ranger_01', npcScenario: 'WORLD_HUMAN_STAND_IMPATIENT',
                            npcCoords: { x: -537.22, y: 5327.81, z: 74.15, w: 215.0 },
                            blipSprite: 77, blipColor: 25,
                            vehModel: 'flatbed', vehPlate: 'WOOD01',
                            vehSpawns: [{ x: -540.5, y: 5330.1, z: 74.0, w: 30.0 }],
                        },
                        trucker: {
                            npcModel: 's_m_m_trucker_01', npcScenario: 'WORLD_HUMAN_CLIPBOARD',
                            npcCoords: { x: 155.32, y: -3210.88, z: 5.91, w: 90.0 },
                            blipSprite: 477, blipColor: 38,
                            vehModel: 'hauler', vehPlate: 'HAUL01',
                            vehSpawns: [{ x: 150.0, y: -3215.0, z: 5.9, w: 90.0 }, { x: 160.0, y: -3215.0, z: 5.9, w: 90.0 }, { x: 170.0, y: -3215.0, z: 5.9, w: 90.0 }],
                        },
                        cleanup: {
                            npcModel: 's_m_y_cleanup', npcScenario: 'WORLD_HUMAN_STAND_MOBILE',
                            npcCoords: { x: -322.45, y: -1545.12, z: 31.02, w: 320.0 },
                            blipSprite: 318, blipColor: 21,
                            vehModel: 'trash', vehPlate: 'TRASH1',
                            vehSpawns: [{ x: -325.0, y: -1550.0, z: 31.0, w: 320.0 }],
                        },
                        fishing: {
                            npcModel: 's_m_y_baywatch_01', npcScenario: 'WORLD_HUMAN_STAND_FISHING',
                            npcCoords: { x: -1850.22, y: -1248.44, z: 8.62, w: 140.0 },
                            blipSprite: 68, blipColor: 3,
                            vehModel: null, vehPlate: null, vehSpawns: [],
                        },
                        taxi: {
                            npcModel: 's_m_m_cntrybar_01', npcScenario: 'WORLD_HUMAN_LEANING',
                            npcCoords: { x: 895.11, y: -179.33, z: 74.7, w: 55.0 },
                            blipSprite: 198, blipColor: 46,
                            vehModel: 'taxi', vehPlate: 'TAXI01',
                            vehSpawns: [{ x: 900.0, y: -175.0, z: 74.7, w: 55.0 }, { x: 905.0, y: -175.0, z: 74.7, w: 55.0 }],
                        },
                        hunting: {
                            npcModel: 's_m_y_ranger_01', npcScenario: 'WORLD_HUMAN_GUARD_STAND',
                            npcCoords: { x: -750.0, y: 5550.0, z: 33.5, w: 180.0 },
                            blipSprite: 141, blipColor: 25,
                            vehModel: null, vehPlate: null, vehSpawns: [],
                        },
                        diving: {
                            npcModel: 's_m_y_baywatch_01', npcScenario: 'WORLD_HUMAN_STAND_IMPATIENT',
                            npcCoords: { x: -1600.0, y: -1050.0, z: 13.0, w: 220.0 },
                            blipSprite: 729, blipColor: 3,
                            vehModel: 'dinghy', vehPlate: 'DIVE01',
                            vehSpawns: [{ x: -1605.0, y: -1055.0, z: 1.0, w: 220.0 }],
                        },
                    };
                    const d = editorData[jobId] || editorData.miner;
                    const jobName = MOCK_JOBS.find(j => j.id === jobId)?.name || jobId;
                    const payload = {
                        id: jobId,
                        name: jobName,
                        enabled: true,
                        interaction: { distance: 2.5, key: 38, text: 'Press E to start' },
                        npc: {
                            model: d.npcModel,
                            scenario: d.npcScenario,
                            coords: d.npcCoords,
                            blip: { enabled: true, sprite: d.blipSprite, color: d.blipColor, scale: 0.8, label: jobName },
                        },
                    };
                    if (d.vehModel) {
                        payload.vehicle = {
                            model: d.vehModel,
                            color: { primary: 0, secondary: 0 },
                            plate: d.vehPlate,
                            spawnLocations: d.vehSpawns,
                        };
                    }
                    payload.coordinates = [
                        { path: 'npc.coords', label: 'NPC Position', value: d.npcCoords },
                    ];
                    d.vehSpawns.forEach((s, i) => {
                        payload.coordinates.push({ path: 'runtime.vehicle.spawnLocations[' + (i + 1) + ']', label: 'Vehicle Spawn #' + (i + 1), value: s });
                    });
                    dispatchNUI('JOBEDITOR_JOB_LOADED', payload);
                }, 100);
                return 'ok';
            case 'jobeditor:openFromAdmin':
                setTimeout(() => {
                    const mockJobs = MOCK_JOBS.map(j => ({ id: j.id, name: j.name, icon: j.icon || '' }));
                    dispatchNUI('JOBEDITOR_OPEN', { jobs: mockJobs });
                }, 100);
                return 'ok';
            case 'jobeditor:close':
                return 'ok';
            case 'jobeditor:goToCoord':
                console.log('[MOCK] Go to coord:', data?.coord);
                return 'ok';
            case 'jobeditor:setFromCamera':
                return { x: 2954.13 + (Math.random() * 2 - 1), y: 2774.39 + (Math.random() * 2 - 1), z: 43.3, w: 180.0 };
            case 'jobeditor:updateNpcModel':
                console.log('[MOCK] Update NPC model:', data?.model);
                return 'ok';
            case 'jobeditor:updateNpcScenario':
                console.log('[MOCK] Update NPC scenario:', data?.scenario);
                return 'ok';
            case 'jobeditor:updateCoord':
                console.log('[MOCK] Update coord:', data?.path, data?.value);
                return 'ok';
            case 'jobeditor:updateVehicleModel':
                console.log('[MOCK] Update vehicle model:', data?.model);
                return 'ok';
            case 'jobeditor:updateVehicleColor':
                console.log('[MOCK] Update vehicle color:', data);
                return 'ok';
            case 'jobeditor:updateVehiclePlate':
                console.log('[MOCK] Update vehicle plate:', data?.plate);
                return 'ok';
            case 'jobeditor:spawnVehiclePreview':
                console.log('[MOCK] Spawn vehicle preview:', data?.index);
                return 'ok';
            case 'jobeditor:save':
                console.log('[MOCK] Save job editor changes');
                return { success: true, replacements: 5 };
            case 'closeStatistics':
                return 'ok';
            case 'tutorial:skip':
                return 'ok';
            case 'tutorial:next':
                return 'ok';
            default:
                console.log('[MOCK] Unhandled postNUI:', name);
                return null;
        }
    }

    // In FiveM: don't intercept postNUI — real NUI callbacks must work.
    // Only wrap postNUI in browser mode so mock buttons return fake responses.
    if (!IN_FIVEM) {
        let _wrapAttempts = 0;
        const _wrapInterval = setInterval(() => {
            _wrapAttempts++;
            if (window.postNUI && !window.postNUI.__mocked) {
                const _originalPostNUI = window.postNUI;
                window.postNUI = async function (name, data) {
                    console.log('[MOCK] postNUI called:', name, data);
                    const result = mockResponse(name, data);
                    if (result !== null) return result;
                    try { return await _originalPostNUI(name, data); } catch (e) { return null; }
                };
                window.postNUI.__mocked = true;
                clearInterval(_wrapInterval);
                console.log('[MOCK] postNUI interceptor installed');
            }
            if (_wrapAttempts > 100) clearInterval(_wrapInterval);
        }, 50);
    }

    // ===========================
    // DISPATCH NUI MESSAGE (simulates SendNUIMessage from Lua)
    // ===========================
    function dispatchNUI(action, payload) {
        window.postMessage({ action, payload }, '*');
    }

    // ===========================
    // MOCK CONTROL PANEL (floating dev toolbar)
    // ===========================
    function createMockPanel() {
        const panel = document.createElement('div');
        panel.id = 'mockPanel';
        panel.innerHTML = `
            <style>
                #mockPanel {
                    position: fixed; top: 10px; left: 10px; z-index: 9990;
                    background: rgba(0,0,0,0.9); border: 1px solid #444; border-radius: 8px;
                    padding: 10px; font-family: monospace; font-size: 12px; color: #fff;
                    max-height: 90vh; overflow-y: auto; min-width: 220px;
                    user-select: none;
                }
                #mockPanel h3 { margin: 0 0 8px; color: #0af; font-size: 13px; }
                #mockPanel button {
                    display: block; width: 100%; margin: 3px 0; padding: 6px 8px;
                    background: #333; border: 1px solid #555; color: #fff; border-radius: 4px;
                    cursor: pointer; font-size: 11px; text-align: left;
                }
                #mockPanel button:hover { background: #555; }
                #mockPanel .section { margin-top: 8px; border-top: 1px solid #333; padding-top: 6px; }
                #mockPanel .section-title { color: #888; font-size: 10px; text-transform: uppercase; margin-bottom: 4px; }
                #mockPanel .collapse-btn { background: none; border: none; color: #0af; cursor: pointer; font-size: 11px; padding: 0; }
                #mockPanel.collapsed { min-width: auto; padding: 6px 10px; }
                #mockPanel.collapsed #mockPanelContent { display: none; }
                #mockPanel .toggle-btn { background: none; border: none; color: #0af; cursor: pointer; font-size: 13px; padding: 0; float: right; }
                #mockPanel .close-btn { background: #a33; border: 1px solid #c55; color: #fff; border-radius: 4px; cursor: pointer; font-size: 11px; padding: 4px 10px; margin-left: 6px; }
                #mockPanel .close-btn:hover { background: #c44; }
            </style>
            <h3>MOCK PANEL
                <button class="toggle-btn" onclick="document.getElementById('mockPanel').classList.toggle('collapsed')">▼</button>
                <button class="close-btn" onclick="window.postMessage({action:'MOCK_PANEL_CLOSE'},'*')">X</button>
            </h3>
            <div id="mockPanelContent">

            <div class="section-title">Main UI</div>
            <button onclick="window._mock.openJobCenter()">Open Job Center</button>
            <button onclick="window._mock.openJobStart('miner')">Open Job Start (Miner)</button>
            <button onclick="window._mock.openJobStart('trucker')">Open Job Start (Trucker)</button>
            <button onclick="window._mock.openJobStart('fishing')">Open Job Start (Fishing)</button>
            <button onclick="window._mock.close()">Close UI</button>

            <div class="section">
                <div class="section-title">Modals</div>
                <button onclick="window._mock.finishJobModal()">Finish Job Modal</button>
                <button onclick="window._mock.finishJobCoopWaiting()">Finish Job (Coop Waiting)</button>
                <button onclick="window._mock.activeJobModal()">Active Job Options</button>
                <button onclick="window._mock.ownerLeftModal()">Owner Left Modal</button>
                <button onclick="window._mock.invitePopup()">Invite Popup</button>
                <button onclick="window._mock.illegalOffer()">Illegal Offer (Trucker)</button>
                <button onclick="window._mock.openContract()">Contract Modal</button>
            </div>

            <div class="section">
                <div class="section-title">Panels</div>
                <button onclick="window._mock.openPerks()">Perks / Skill Tree</button>
                <button onclick="window._mock.openUpgrade()">Level Unlocks</button>
                <button onclick="window._mock.openQuests()">Quest Panel</button>
                <button onclick="window._mock.openAdmin()">Admin Panel</button>
                <button onclick="window._mock.openJobEditor()">Job Editor</button>
                <button onclick="window._mock.openStatistics()">Statistics</button>
                <button onclick="window._mock.openTutorial()">Tutorial</button>
                <button onclick="window._mock.openSettings()">Settings</button>
                <button onclick="window._mock.openPreview()">Job Preview</button>
                <button onclick="window._mock.openAchievements()">Achievements</button>
            </div>

            <div class="section">
                <div class="section-title">In-Game HUD</div>
                <button onclick="window._mock.jobProgress()">Job Progress Panel</button>
                <button onclick="window._mock.truckFill()">Truck Fill (Cleanup)</button>
                <button onclick="window._mock.truckTracker()">Truck Tracker (Warehouse)</button>
                <button onclick="window._mock.trailerHealth()">Trailer Health (Trucker)</button>
                <button onclick="window._mock.oxygen()">Oxygen (Diving)</button>
                <button onclick="window._mock.taximeter()">Taximeter (Taxi)</button>
                <button onclick="window._mock.actionProgress()">Action Progress Ring</button>
                <button onclick="window._mock.crosshair()">Crosshair</button>
                <button onclick="window._mock.drawText()">DrawText</button>
                <button onclick="window._mock.notification()">Notification</button>
                <button onclick="window._mock.hideAllHUD()">Hide All HUD</button>
            </div>

            <div class="section">
                <div class="section-title">Minigames</div>
                <button onclick="window._mock.panelMinigame()">Powerlines Panel</button>
                <button onclick="window._mock.poleMinigame()">Powerlines Pole</button>
                <button onclick="window._mock.pipeGame()">Pipelines Pipe</button>
                <button onclick="window._mock.fishingMinigame()">Fishing Minigame</button>
            </div>
            </div>
        `;
        document.body.appendChild(panel);
    }

    // ===========================
    // MOCK ACTION FUNCTIONS
    // ===========================
    const MOCK_THEME = {
        AccentColor:  '#47a3ff',
        SuccessColor: '#2ecc71',
        ErrorColor:   '#ef4444',
        WarningColor: '#ffde59',
    };

    window._mock = {
        openJobCenter() {
            dispatchNUI('SET_UI_SETTINGS', { soundEffect: true, locale: 'en', uiTheme: MOCK_THEME });
            dispatchNUI('SET_JOBS', MOCK_JOBS);
            dispatchNUI('SET_JOB_LEVELS', MOCK_JOB_LEVELS);
            dispatchNUI('SET_DAILY_BONUS', MOCK_DAILY_BONUS);
            dispatchNUI('SET_WEATHER_DATA', MOCK_WEATHER);
            dispatchNUI('SET_SHIFT_DATA', MOCK_SHIFT);
            dispatchNUI('SET_JOB_STATISTICS', MOCK_STATISTICS);
            dispatchNUI('OPEN_MENU', {
                identifier: MOCK_PLAYER.identifier,
                name: MOCK_PLAYER.name,
                avatar: MOCK_PLAYER.avatar,
                owner: true,
                currencySymbol: '$',
            });
        },

        openJobStart(jobId) {
            dispatchNUI('SET_UI_SETTINGS', { soundEffect: true, locale: 'en', uiTheme: MOCK_THEME });
            dispatchNUI('SET_JOBS', MOCK_JOBS);
            dispatchNUI('SET_JOB_LEVELS', MOCK_JOB_LEVELS);
            dispatchNUI('SET_DAILY_BONUS', MOCK_DAILY_BONUS);
            dispatchNUI('SET_WEATHER_DATA', MOCK_WEATHER);
            dispatchNUI('SET_SHIFT_DATA', MOCK_SHIFT);
            dispatchNUI('SET_JOB_STATISTICS', MOCK_STATISTICS);
            dispatchNUI('SET_NEARBY_PLAYERS', MOCK_NEARBY);
            dispatchNUI('SET_LEADERBOARD', { jobId, players: generateLeaderboard(jobId) });
            dispatchNUI('OPEN_JOB_START', {
                jobId,
                playerData: {
                    playerIdentifier: MOCK_PLAYER.identifier,
                    playerName: MOCK_PLAYER.name,
                    playerImage: MOCK_PLAYER.avatar,
                    owner: true,
                },
                isOwner: true,
                playerSource: 1,
                players: MOCK_LOBBY,
                leaderboard: generateLeaderboard(jobId),
            });
        },

        close() {
            dispatchNUI('CLOSE_MENU', {});
        },

        finishJobModal() {
            dispatchNUI('OPEN_FINISH_JOB_MODAL', {
                itemsProcessed: 15,
                totalPayment: 2350,
                jobId: 'miner',
                coopState: 'normal',
                waitingFor: [],
                isOwner: true,
                ownerName: 'John Doe',
            });
        },

        finishJobCoopWaiting() {
            dispatchNUI('OPEN_FINISH_JOB_MODAL', {
                itemsProcessed: 8,
                totalPayment: 1500,
                jobId: 'trucker',
                coopState: 'waiting',
                waitingFor: ['Jane Smith', 'Bob Wilson'],
                isOwner: true,
                ownerName: 'John Doe',
            });
        },

        activeJobModal() {
            dispatchNUI('SHOW_ACTIVE_JOB_OPTIONS', { isOwner: true, jobId: 'miner' });
        },

        ownerLeftModal() {
            dispatchNUI('SHOW_OWNER_LEFT_MODAL', { ownerName: 'ProGamer', reason: 'disconnect' });
        },

        invitePopup() {
            dispatchNUI('INVITE_RECEIVED', {
                inviteId: 'inv_001',
                ownerName: 'ProGamer',
                jobId: 'trucker',
                jobName: 'Trucker',
                timeout: 30,
            });
        },

        illegalOffer() {
            dispatchNUI('SHOW_ILLEGAL_OFFER', {
                title: 'Stolen Cargo Found!',
                description: 'You discovered stolen merchandise in the trailer. Delivering it to the black market would be risky but very profitable.',
                reward: 'x2 Money',
                risk: '90% Police Alert',
                isOwner: true,
            });
        },

        openProgressPanel() {
            dispatchNUI('OPEN_PERKS_SIDE', {
                perkPoints: 20,
                playerPerks: { trunk_capacity: 2, negotiator: 1 },
                availablePerks: MOCK_AVAILABLE_PERKS,
                playerName: MOCK_PLAYER.name,
                playerImage: MOCK_PLAYER.avatar,
                currentJobLevel: { level: 5 },
            });
            dispatchNUI('OPEN_QUESTS_PANEL', {
                quests: MOCK_QUESTS,
                jobId: '',
                currencySymbol: '$',
            });
            dispatchNUI('SET_UPGRADE_JOBS', MOCK_UPGRADE_JOBS);
            dispatchNUI('SET_UPGRADE_PLAYER_DATA', { name: MOCK_PLAYER.name, rank: 'Veteran', money: 25000 });
            dispatchNUI('OPEN_PROGRESS_PANEL');
        },

        openPerks() {
            this.openProgressPanel();
        },

        openUpgrade() {
            this.openProgressPanel();
        },

        openQuests() {
            this.openProgressPanel();
        },

        openAdmin() {
            dispatchNUI('ADMIN_OPEN', MOCK_ADMIN_DASHBOARD);
        },

        openJobEditor() {
            const mockJobs = MOCK_JOBS.map(j => ({ id: j.id, name: j.name, icon: j.icon || '' }));
            dispatchNUI('JOBEDITOR_OPEN', { jobs: mockJobs });
        },

        openStatistics() {
            dispatchNUI('OPEN_STATISTICS', {
                overview: {
                    totalEarnings: 45200, totalXP: 12800, totalSessions: 38, totalDuration: 86400,
                    averageSessionDuration: 2273, averageEarningsPerSession: 1189,
                    bestDay: { date: '2026-03-15', earnings: 8500 },
                    favoriteJob: { jobId: 'miner', sessions: 12 },
                },
                perJob: {
                    miner: { sessions: 12, totalEarnings: 18500, totalXP: 5200, totalDuration: 28800, level: 5 },
                    lumberjack: { sessions: 8, totalEarnings: 9600, totalXP: 2800, totalDuration: 19200, level: 3 },
                    trucker: { sessions: 6, totalEarnings: 8400, totalXP: 2100, totalDuration: 14400, level: 4 },
                    fishing: { sessions: 7, totalEarnings: 5200, totalXP: 1600, totalDuration: 16800, level: 2 },
                    cleanup: { sessions: 5, totalEarnings: 3500, totalXP: 1100, totalDuration: 7200, level: 2 },
                },
                recentHistory: [
                    { jobId: 'miner', region: 'Quarry', earnedMoney: 2100, earnedXp: 590, date: '2026-03-20 14:25' },
                    { jobId: 'trucker', region: 'Interstate', earnedMoney: 1800, earnedXp: 480, date: '2026-03-20 11:10' },
                    { jobId: 'fishing', region: 'Del Perro', earnedMoney: 1100, earnedXp: 380, date: '2026-03-19 20:45' },
                    { jobId: 'lumberjack', region: 'Paleto', earnedMoney: 1650, earnedXp: 470, date: '2026-03-19 16:30' },
                    { jobId: 'cleanup', region: 'Vinewood', earnedMoney: 950, earnedXp: 310, date: '2026-03-18 13:20' },
                ],
                earningsChart: [
                    { date: '2026-03-14', earnings: 3200 },
                    { date: '2026-03-15', earnings: 8500 },
                    { date: '2026-03-16', earnings: 4100 },
                    { date: '2026-03-17', earnings: 6200 },
                    { date: '2026-03-18', earnings: 2800 },
                    { date: '2026-03-19', earnings: 5600 },
                    { date: '2026-03-20', earnings: 3900 },
                ],
            });
        },

        openTutorial() {
            dispatchNUI('OPEN_TUTORIAL', {
                jobId: 'miner',
                currentStep: 0,
                allowSkip: true,
                steps: [
                    { title: 'tutorial.miner.step1.title', description: 'tutorial.miner.step1.desc' },
                    { title: 'tutorial.miner.step2.title', description: 'tutorial.miner.step2.desc' },
                    { title: 'tutorial.miner.step3.title', description: 'tutorial.miner.step3.desc' },
                    { title: 'tutorial.miner.step4.title', description: 'tutorial.miner.step4.desc' },
                ],
            });
        },

        openSettings() {
            dispatchNUI('SET_PLAYER_SETTINGS', { soundEffect: true, locale: 'en' });
            dispatchNUI('OPEN_SETTINGS_SIDE', {});
        },

        openAchievements() {
            this.openJobStart('miner');
            setTimeout(() => {
                // Simulate clicking the Achievements button in jobStart UI
                const btn = document.querySelector('.menuAchievementButton');
                if (btn) btn.click();
            }, 500);
        },

        openContract() {
            this.openJobStart('miner');
            setTimeout(() => {
                // Simulate clicking the Contract button in jobStart UI
                const btn = document.querySelector('.menuContractButton');
                if (btn) btn.click();
            }, 500);
        },

        openPreview() {
            const steps = [
                { title: 'Step 1: Get Equipment', description: ['Go to the tool rack', 'Pick up your mining pickaxe', 'Equip your safety helmet'] },
                { title: 'Step 2: Mine Ores', description: ['Approach ore deposits', 'Use pickaxe to mine', 'Collect extracted ores'] },
                { title: 'Step 3: Process & Deliver', description: ['Take ores to processing', 'Wait for refinement', 'Collect your payment'] },
            ];
            dispatchNUI('OPEN_JOB_PREVIEW', { totalSteps: steps.length, steps });
            setTimeout(() => {
                dispatchNUI('PREVIEW_STEP_CHANGED', { currentStep: 1, totalSteps: steps.length, title: steps[0].title, description: steps[0].description });
                dispatchNUI('PREVIEW_TRANSITION_DONE', {});
            }, 100);
        },

        // In-Game HUD
        jobProgress() {
            dispatchNUI('UPDATE_JOB_PROGRESS', {
                jobLabel: 'Mining',
                tasks: [
                    { label: 'Mine Ores', current: 7, total: 10, completed: false },
                    { label: 'Process Ores', current: 3, total: 10, completed: false },
                ],
                percent: 50,
                description: 'Extract and process ores from the quarry.',
                subtasks: ['Deliver to processing NPC', 'Collect payment'],
                holdKey: 'H',
                holdTime: 2000,
            });
        },

        truckFill() {
            dispatchNUI('UPDATE_TRUCK_FILL', { current: 10, max: 16, jobId: 'cleanup' });
        },

        truckTracker() {
            dispatchNUI('UPDATE_TRUCK_TRACKER', {
                label: 'Delivery Route',
                status: 'En Route',
                progress: 65,
                current: 3,
                total: 5,
                delivered: false,
                duration: 1000,
            });
        },

        trailerHealth() {
            dispatchNUI('SHOW_TRAILER_HEALTH', { health: 72 });
        },

        oxygen() {
            dispatchNUI('SHOW_OXYGEN', { current: 100, max: 100, level: 1 });
            setTimeout(() => {
                dispatchNUI('UPDATE_OXYGEN', { current: 65, max: 100, warning: false, critical: false, isUnderwater: true });
            }, 100);
        },

        taximeter() {
            dispatchNUI('SHOW_TAXIMETER', { fare: 45.50, bonusTime: 25, distance: 3.2, isIllegal: false });
            // Animate fare going up
            let fare = 45.50;
            const interval = setInterval(() => {
                fare += 0.50;
                dispatchNUI('UPDATE_TAXIMETER', { fare, bonusTime: Math.max(0, 25 - Math.floor((fare - 45.50) / 0.5)), distance: 3.2 + (fare - 45.50) * 0.1 });
                if (fare > 60) clearInterval(interval);
            }, 1000);
        },

        actionProgress() {
            dispatchNUI('SHOW_ACTION_PROGRESS', { label: 'Mining...', cancelLabel: 'X', duration: 5000 });
            setTimeout(() => dispatchNUI('HIDE_ACTION_PROGRESS', {}), 5000);
        },

        crosshair() {
            dispatchNUI('SHOW_CROSSHAIR', {});
            setTimeout(() => dispatchNUI('HIDE_CROSSHAIR', {}), 5000);
        },

        drawText() {
            console.log('[MOCK] drawText called');
            dispatchNUI('SHOW_DRAWTEXT', { text: 'Start Mining', key: 'E' });
            // Debug: check if element exists in DOM after a tick
            setTimeout(() => {
                const el = document.querySelector('.drawTextContainer');
                const card = document.querySelector('.drawTextCard');
                console.log('[MOCK] container element:', el);
                console.log('[MOCK] card element:', card);
                if (el) {
                    const style = window.getComputedStyle(el);
                    console.log('[MOCK] container computed:', {
                        display: style.display,
                        visibility: style.visibility,
                        opacity: style.opacity,
                        width: style.width,
                        height: style.height,
                        top: style.top,
                        right: style.right,
                        zIndex: style.zIndex,
                        position: style.position
                    });
                }
                if (card) {
                    const cs = window.getComputedStyle(card);
                    console.log('[MOCK] card computed:', {
                        display: cs.display,
                        opacity: cs.opacity,
                        width: cs.width,
                        height: cs.height,
                        background: cs.background
                    });
                }
            }, 500);
            setTimeout(() => {
                console.log('[MOCK] hiding drawText');
                dispatchNUI('HIDE_DRAWTEXT', {});
            }, 8000);
        },

        notification() {
            dispatchNUI('SHOW_NOTIFICATION', { text: 'You earned $250 from mining!', type: 'success', duration: 4000 });
            setTimeout(() => dispatchNUI('SHOW_NOTIFICATION', { text: 'Level Up! You are now level 6.', type: 'info', duration: 4000 }), 500);
            setTimeout(() => dispatchNUI('SHOW_NOTIFICATION', { text: 'Your oxygen is running low!', type: 'warning', duration: 4000 }), 1000);
        },

        hideAllHUD() {
            dispatchNUI('HIDE_JOB_PROGRESS', {});
            dispatchNUI('HIDE_TRUCK_FILL', {});
            dispatchNUI('HIDE_TRUCK_TRACKER', {});
            dispatchNUI('HIDE_TRAILER_HEALTH', {});
            dispatchNUI('HIDE_OXYGEN', {});
            dispatchNUI('HIDE_TAXIMETER', {});
            dispatchNUI('HIDE_ACTION_PROGRESS', {});
            dispatchNUI('HIDE_CROSSHAIR', {});
            dispatchNUI('HIDE_DRAWTEXT', {});
        },

        // Minigames
        panelMinigame() {
            dispatchNUI('START_PANEL_MINIGAME', { gridRows: 4, gridCols: 5, timeLimit: 45, debug: false });
        },

        poleMinigame() {
            dispatchNUI('START_POLE_MINIGAME', { wireCount: 4, wireWidth: 0.74, maxWeldFails: 3, time: 64 });
        },

        pipeGame() {
            dispatchNUI('OPEN_PIPE_GAME', { mode: 'close' });
            // Animate pressure dropping
            let pressure = 50;
            const interval = setInterval(() => {
                pressure -= 2;
                dispatchNUI('SET_PIPE_PRESSURE', { pressure });
                if (pressure <= 0) {
                    clearInterval(interval);
                    setTimeout(() => dispatchNUI('CLOSE_PIPE_GAME', {}), 500);
                }
            }, 200);
        },

        fishingMinigame() {
            dispatchNUI('START_FISHING_MINIGAME', { fishName: 'Largemouth Bass', difficulty: 'medium' });
        },
    };

    // ===========================
    // AUTO-INIT: Set background and open Job Center on load
    // ===========================
    // ===========================
    // LOCALE LOADER (fetch en.json for browser dev mode)
    // ===========================
    async function loadLocale() {
        try {
            const resp = await fetch('./locales/en.json');
            if (!resp.ok) throw new Error('HTTP ' + resp.status);
            const localeData = await resp.json();
            dispatchNUI('SET_LOCALE', localeData);
            console.log('[MOCK] Locale loaded (' + Object.keys(localeData).length + ' top-level keys)');
        } catch (e) {
            console.warn('[MOCK] Failed to load locale:', e.message);
        }
    }

    // Toggle mock panel sidebar visibility
    function toggleMockList() {
        const panel = document.getElementById('mockPanel');
        if (panel) {
            panel.classList.toggle('collapsed');
        }
    }

    window._mock.toggleList = toggleMockList;

    if (!IN_FIVEM) {
        // Browser mode: auto-init
        window.addEventListener('DOMContentLoaded', () => {
            const mockStyle = document.createElement('style');
            mockStyle.textContent = `
                #render { display: none !important; }
                [data-hlsl] {
                    backdrop-filter: blur(10px) !important;
                    -webkit-backdrop-filter: blur(10px) !important;
                    background: rgba(255, 255, 255, 0.06) !important;
                }
            `;
            document.head.appendChild(mockStyle);

            createMockPanel();
            loadLocale();
            console.log('[MOCK] Panel created. Click buttons to test UI states.');
        });
    } else {
        // FiveM mode: listen for MOCK_PANEL_OPEN / MOCK_PANEL_TOGGLE messages
        window.addEventListener('message', (event) => {
            if (!event.data || !event.data.action) return;
            if (event.data.action === 'MOCK_PANEL_OPEN') {
                const existing = document.getElementById('mockPanel');
                if (existing) {
                    existing.classList.remove('collapsed');
                    return;
                }
                createMockPanel();
                loadLocale();
            } else if (event.data.action === 'MOCK_PANEL_CLOSE') {
                const panel = document.getElementById('mockPanel');
                if (panel) panel.remove();
                postNUI('mockpanel:close');
            } else if (event.data.action === 'MOCK_PANEL_TOGGLE') {
                toggleMockList();
            }
        });
    }
})();
