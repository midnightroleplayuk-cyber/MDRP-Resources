--[[
    worm_pawnshop - shared settings (client + server)

    Computers, storage points, delivery spots and truck offsets are placed in
    game with /pawndev and saved to data/*.json; the values here are only the
    starting defaults.
]]

return {
    locale = 'en',
    debug = false,

    currency = { symbol = '£', locale = 'en-US' },

    -- Who can open dev mode (ace permission or framework group)
    admin = {
        ace = 'worm_pawnshop.dev',
        groups = { 'admin', 'god' },
    },

    --#region storage --------------------------------------------------------------
    stash = {
        prefix = 'pawnshop_',      -- stash id = prefix .. citizenid
        label = 'Pawn Storage',
        slots = 50,
        weight = 200000,
        radius = 1.2,              -- interaction radius of a storage point
        -- Storage points. Entries here are always active; points added in game with /pawndev
        -- are stored separately in data/delivery.json and merged with these.
        points = {
            vec3(433.76, -1904.67, 26.5)
        },
    },
    --#endregion

    --#region box pickup -------------------------------------------------------------
    -- When a shipment starts the box is not put in the storage: it spawns as a prop at one of
    -- these points (random) and the player picks it up there.
    pickup = {
        prop = 'prop_cs_cardbox_01',
        distance = 2.0,            -- target distance
        blip = { sprite = 478, colour = 5, scale = 0.75 },
        -- Pickup points. Added in game with /pawndev > Box pickup points.
        -- { coords = vec4(box x, y, z, heading), stand = vec4(player x, y, z, heading) }
        -- stand is where the player stands for the pickup animation (optional; defaults to in front of the box).
        -- When empty, the storage points are used instead.
        points = {
            { coords = vec4(437.3332, -1902.9568, 26.9181, 219.9708), stand = vec4(436.8281, -1902.2949, 26.4374, 213.0119) },
        },
    },
    --#endregion

    --#region items ----------------------------------------------------------------
    items = {
        box = 'pawn_shipment_box', -- see README.md: this item must exist in your inventory
    },

    -- Item pictures shown next to every item in the computer UI.
    -- path = 'auto' asks the running inventory (worm_lib) for the url,
    -- or give a pattern where %s is the item name, e.g. 'nui://ox_inventory/web/images/%s.png'
    -- fallback is used when the inventory does not know the item.
    images = {
        path = 'auto',
        fallback = 'nui://ox_inventory/web/images/%s.png',
    },
    --#endregion

    --#region orders ---------------------------------------------------------------
    orders = {
        cycleMinutes = 10,        -- offers refresh at this interval (per player pool, shared cycle boundary)
        deadlineMinutes = 30,     -- time from accept to delivery; the order expires afterwards
        prepare = { min = 45, max = 120 }, -- random preparation time after "Prepare" (seconds)
        loading = { min = 5, max = 10 },   -- loading bar after preparation (seconds)
        perType = { min = 2, max = 4 },    -- offers generated per order type
        itemsPerOrder = { min = 1, max = 4 },
        refundItemsOnCancel = true,       -- cancelling after the shipment started: put the items back
        refundItemsOnExpire = false,
        oneActivePerPlayer = true,
    },

    -- Which account pays the accept fee / receives the payout: 'cash' | 'bank'
    accounts = { fee = 'bank', payout = 'bank' },

    -- Talking to the driver (target on the driver door handle) launders part of the dirty money the player carries.
    dirtyMoney = {
        enabled = true,
        -- mode: 'item' (1 unit = $1; ox black_money) | 'item_worth' (qb markedbills, info.worth) | 'account' (ESX black_money account)
        spec = { mode = 'item', item = 'black_money', field = 'worth', account = 'black_money' },
        percent = 25,             -- this share of the dirty money is cleaned
        cut = { min = 2, max = 5 }, -- the driver keeps this share (%) of the cleaned amount
        onlyIllegal = true,      -- true: launder only on illegal orders
    },

    -- Order types: add as many as you like (type A, type B...). Item names in
    -- `pools` must exist in your inventory; labels/images come from the inventory.
    orderTypes = {
        {
            key = 'local', label = 'Local', color = '#4cc9f0', legal = true,
            acceptFeePct = 0.10,  -- share of the payout charged when accepting
            payoutMult = 1.0,     -- payout multiplier
            jitterPct = 10,       -- random +/- variation of the payout (%)
            titles = { 'Scrap Order', 'Electronics Order', 'Material Order' },
            pools = {
                { item = 'scrapmetal', min = 3, max = 10, price = { 18, 30 } },
                { item = 'copper',     min = 2, max = 8,  price = { 25, 40 } },
                { item = 'plastic',    min = 4, max = 12, price = { 8, 15 } },
                { item = 'phone',      min = 1, max = 3,  price = { 90, 140 } },
                { item = 'radio',      min = 1, max = 2,  price = { 70, 110 } },
            },
        },
        {
            key = 'interstate', label = 'Interstate', color = '#a78bfa', legal = true,
            acceptFeePct = 0.15, payoutMult = 1.25, jitterPct = 12,
            titles = { 'Wholesale Order', 'Collector Order' },
            pools = {
                { item = 'phone',      min = 3, max = 6,  price = { 110, 160 } },
                { item = 'radio',      min = 2, max = 5,  price = { 90, 130 } },
                { item = 'lockpick',   min = 2, max = 6,  price = { 40, 70 } },
                { item = 'goldchain',  min = 1, max = 3,  price = { 350, 520 } },
            },
        },
        {
            key = 'black', label = 'Black Market', color = '#f43f5e', legal = false,
            acceptFeePct = 0.15, payoutMult = 1.6, jitterPct = 15,
            titles = { 'Valuables Order', 'No-Questions Order', 'Night Order' },
            -- legal = false: chance of a police dispatch on delivery
            dispatch = {
                chance = 35,            -- %
                stage = 'close',        -- 'place' (box dropped in) | 'close' (door closed)
                code = '10-66', title = 'Suspicious Delivery',
                message = 'Boxes were seen being loaded into a truck',
                jobs = { 'police' }, blip = { sprite = 478, colour = 1, scale = 1.0, time = 60 },
            },
            pools = {
                { item = 'goldchain',    min = 2, max = 5, price = { 400, 600 } },
                { item = 'rolex',        min = 1, max = 3, price = { 500, 800 } },
                { item = 'diamond_ring', min = 1, max = 2, price = { 900, 1400 } },
                { item = 'lockpick',     min = 3, max = 8, price = { 60, 90 } },
            },
        },
    },
    --#endregion

    --#region computers ------------------------------------------------------------
    -- Added with /pawndev > Computers; written to data/computers.json.
    -- You can also add entries by hand:
    -- { id = 'main', model = 'prop_monitor_w_large', coords = vec4(x, y, z, heading), spawn = true,
    --   screen = { w = 1280, h = 800 }, panel = nil, stand = nil, cameraFrom = nil, cameraAt = nil }
    computers = {
        {
            id = 'pc_1',
            model = 'v_res_mousemat',
            coords = vec4(432.9223, -1903.4791, 26.3354, 315.5897),
            spawn = false,
            screen = { w = 1422, h = 889 },
            panel = {
                origin = vec3(-0.7965, 0.3942, 0.1645),
                right = vec3(0.6277, -0.0020, 0.0000),
                up = vec3(0.0000, 0.0022, 0.3876),
            },
        },
    },

    computerDefaults = {
        model = 'prop_monitor_w_large',
        screen = { w = 1422, h = 889 },    -- DUI resolution. 1422x889 is the native layout size (no scaling, fastest);
                                            -- larger values scale the layout up for sharper text at a higher cost
        useDistance = 1.6,     -- target distance
        idleScreen = false,    -- true: draw the lock screen on nearby monitors; false: no browser opens until the computer is used
        idleDistance = 7.5,   -- the lock screen (when enabled) is drawn from this distance
        cameraFov = 45.0,
        jobs = {},             -- empty = everyone can use it; e.g. { 'pawnshop' }
    },
    --#endregion

    --#region delivery ------------------------------------------------------------
    delivery = {
        vehicle = {
            model = 'mule',
            doors = { 5 },             -- rear door indices that get opened/closed (boxville: 5)
            windows = { 0, 1 },        -- windows rolled down (front left / front right)
            driver = 'a_m_m_socenlat_01',
            passenger = 'a_m_y_stlat_01',
            plate = false,             -- false = random plate.
            -- Target point behind the vehicle (vehicle-local offset; tuned in /pawndev > Truck)
            rearTarget = { offset = vec3(0.1984, -3.6267, 0.3057), distance = 2.5 },
            -- Where the box sits in the cargo area (vehicle-local; tuned in /pawndev > Truck)
            boxAttach = { pos = vec3(0.1031, -3.5343, 0.0855), rot = vec3(0.0, 0.0, 0.0) },
            -- Where the player stands for the loading animation (vehicle-local; heading relative to the truck; tuned in /pawndev > Truck)
            loadSpot = { pos = vec3(-0.0222, -4.3678, -0.2220), heading = 0.0 },
            leaveDelay = { min = 2, max = 2 },  -- seconds after the rear door is closed before it drives off
            drivingStyle = 786603,
            speed = 18.0,
            spawnDistance = 150.0,     -- the truck is created when the player gets this close (the area must be loaded to place it exactly)
            despawnDistance = 160.0,   -- deleted once this far from the player
            despawnAfter = 90,         -- or this many seconds after it left
            waitTimeout = 0,           -- 0 = the truck waits until the order deadline
        },
        -- Delivery zones. Each order gets the first zone whose max it does not exceed
        -- (max = false means no upper limit). zoneBy: 'fee' (accept fee) | 'payout'.
        zoneBy = 'fee',
        zones = {
            { key = 'near', label = 'Nearby',      max = 150 },
            { key = 'city', label = 'Across town', max = 400 },
            { key = 'far',  label = 'Out of town', max = false },
        },
        -- Delivery spots. Tag a spot with a zone: { coords = vec4(...), zone = 'far' }.
        -- A plain vec4 (no zone) can be used by every zone. Spots added with /pawndev are merged in.
        -- If a zone has no spots of its own, untagged spots are used, then any spot.
        spots = {
            { coords = vec4(-1349.25, 739.31, 183.55, 295.76), zone = 'city' },
            { coords = vec4(-2393.1, 2258.93, 32.08, 243.31), zone = 'far' },
            { coords = vec4(-1306.85, 5158.31, 59.93, 348.63), zone = 'far' },
        },
        blip = { sprite = 477, colour = 5, scale = 0.8, label = 'Delivery Truck' },
    },
    --#endregion
}
