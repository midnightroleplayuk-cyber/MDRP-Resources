-- ============================================================
-- SNIPPET: this file is NOT loaded by the fxmanifest.
-- Copy the entries below INSIDE the `return { ... }` of ox_inventory/data/items.lua,
-- then run: restart ox_inventory  and  restart apex_phone
--
-- You do not need to copy any image: the PNG icons are served by apex_phone itself
-- (nui://apex_phone/inventory_images/...) and the 3D props are streamed from apex_phone/stream/.
-- Full guide: ITENS_OX_INVENTORY.md
--
-- Using a device item OPENS the phone with that device's OS, frame colour and prop.
-- Using the same item again closes it; using another device switches without closing.
-- Only these devices open the phone (Config.RequireItem = true, Config.PhoneItem = '').
-- Item names must match Config.Devices, Config.EarbudsItem, Config.SlateBuds.item and Config.Sim.item.
-- Labels and descriptions are yours to translate.
-- ============================================================
return {
    -- Earbuds: use = put on / take off the 3D earbuds, then connect them in the phone (Bluetooth)
    ['airpods'] = {
        label = 'AirPods Pro 3',
        weight = 60, stack = false, close = true, consume = 0,
        description = 'White wireless earbuds. Use to put them on, then connect them in the phone via Bluetooth.',
        client = { export = 'apex_phone.useEarbuds', image = 'nui://apex_phone/inventory_images/airpods.png' },
    },
    ['slate_buds'] = {
        label = 'NOVA Buds 4 Pro',
        weight = 60, stack = false, close = true, consume = 0,
        description = 'Black wireless earbuds with a matching charging case. Use to put them on, then connect them in the phone via Bluetooth.',
        client = { export = 'apex_phone.useSlateBuds', image = 'nui://apex_phone/inventory_images/slate_buds.png' },
    },

    -- eSIM card: use = open the phone camera and scan the QR code to add a line (Config.Sim)
    ['esim'] = {
        label = 'eSIM Card',
        weight = 5, stack = true, close = true,
        description = 'Prepaid eSIM card. Use it and scan the QR code with your phone to add a new number.',
        client = { export = 'apex_phone.useEsim', image = 'nui://apex_phone/inventory_images/esim.png' },
    },

    -- PearPhone 18 Pro Max (PearOS, iOS style)
    ['pear18_black'] = {
        label = 'PearPhone 18 Pro Max · Black',
        weight = 231, stack = false, close = true, consume = 0,
        description = 'PearPhone 18 Pro Max smartphone in black.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/pear18_black.png' },
    },
    ['pear18_white'] = {
        label = 'PearPhone 18 Pro Max · White',
        weight = 231, stack = false, close = true, consume = 0,
        description = 'PearPhone 18 Pro Max smartphone in white.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/pear18_white.png' },
    },
    ['pear18_ice'] = {
        label = 'PearPhone 18 Pro Max · Ice Blue',
        weight = 231, stack = false, close = true, consume = 0,
        description = 'PearPhone 18 Pro Max smartphone in ice blue.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/pear18_ice.png' },
    },
    ['pear18_wine'] = {
        label = 'PearPhone 18 Pro Max · Wine',
        weight = 231, stack = false, close = true, consume = 0,
        description = 'PearPhone 18 Pro Max smartphone in wine.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/pear18_wine.png' },
    },

    -- NOVA S26 Ultra (Nova UI, Android style): same apps and data as the PearPhone, they talk to each other
    ['s26_black'] = {
        label = 'NOVA S26 Ultra · Black',
        weight = 214, stack = false, close = true, consume = 0,
        description = 'NOVA S26 Ultra Android smartphone in black.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/s26_black.png' },
    },
    ['s26_white'] = {
        label = 'NOVA S26 Ultra · White',
        weight = 214, stack = false, close = true, consume = 0,
        description = 'NOVA S26 Ultra Android smartphone in white.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/s26_white.png' },
    },
    ['s26_violet'] = {
        label = 'NOVA S26 Ultra · Violet',
        weight = 214, stack = false, close = true, consume = 0,
        description = 'NOVA S26 Ultra Android smartphone in violet.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/s26_violet.png' },
    },
    ['s26_sky'] = {
        label = 'NOVA S26 Ultra · Sky Blue',
        weight = 214, stack = false, close = true, consume = 0,
        description = 'NOVA S26 Ultra Android smartphone in sky blue.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/s26_sky.png' },
    },

    -- Foldables: PearPhone Fold (PearOS) and NOVA Fold8 (Nova UI), both open like a book
    ['pearfold_night'] = {
        label = 'PearPhone Fold · Night Sky',
        weight = 239, stack = false, close = true, consume = 0,
        description = 'PearPhone Fold foldable smartphone in night sky. Opens like a book into a wide inner screen.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/pearfold_night.png' },
    },
    ['pearfold_star'] = {
        label = 'PearPhone Fold · Star White',
        weight = 239, stack = false, close = true, consume = 0,
        description = 'PearPhone Fold foldable smartphone in star white. Opens like a book into a wide inner screen.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/pearfold_star.png' },
    },
    ['novaflip_lavender'] = {
        label = 'NOVA Fold8 · Lavender',
        weight = 188, stack = false, close = true, consume = 0,
        description = 'NOVA Fold8 foldable Android smartphone in lavender. Opens like a book into a wide inner screen.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/novaflip_lavender.png' },
    },
    ['novaflip_grey'] = {
        label = 'NOVA Fold8 · Grey',
        weight = 188, stack = false, close = true, consume = 0,
        description = 'NOVA Fold8 foldable Android smartphone in grey. Opens like a book into a wide inner screen.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/novaflip_grey.png' },
    },
    ['novaflip_cream'] = {
        label = 'NOVA Fold8 · Cream',
        weight = 188, stack = false, close = true, consume = 0,
        description = 'NOVA Fold8 foldable Android smartphone in cream. Opens like a book into a wide inner screen.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/novaflip_cream.png' },
    },
    ['novaflip_pistachio'] = {
        label = 'NOVA Fold8 · Pistachio',
        weight = 188, stack = false, close = true, consume = 0,
        description = 'NOVA Fold8 foldable Android smartphone in pistachio. Opens like a book into a wide inner screen.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/novaflip_pistachio.png' },
    },

    -- Physical SIM card (only used when Config.PhysicalSim.enabled = true).
    -- The phone NUMBER lives on this card: metadata { iccid, number } (the tooltip shows "Number: 555-1234").
    -- Using it puts it in the phone in your hand (if that phone already has a SIM, they swap). stack = false: every card
    -- is a different number. Cards given without metadata (/giveitem) get a new number the first time they are inserted.
    -- Optional: an "Eject SIM" button on the phones (works without unlocking the phone, like pulling the tray). Add to
    -- each phone item above:  buttons = { { label = 'Eject SIM', action = function(slot) exports.apex_phone:ejectSim(slot) end } },
    ['sim_card'] = {
        label = 'SIM Card',
        weight = 5, stack = false, close = true, consume = 0,
        description = 'A phone number on a card. Use it to put it in the phone in your hand.',
        client = { export = 'apex_phone.useSimCard', image = 'nui://apex_phone/inventory_images/sim_card.png' },
    },
}
