-- ============================================================
-- SNIPPET for QBCore / QBox WITHOUT ox_inventory: this file is NOT loaded by the fxmanifest.
-- Paste the entries below INSIDE the `QBShared.Items = { ... }` table of qb-core/shared/items.lua, then restart
-- qb-core (or the whole server). With ox_inventory use inventory_items.lua instead.
--
-- Images: qb-inventory (and ps-inventory, lj-inventory, qs-inventory...) load an item's icon from THEIR OWN
-- html/images/<image> folder, so `image` must be a plain file name (never a nui:// address). On start apex_phone
-- checks these items and copies any missing PNG from apex_phone/inventory_images/ into the inventory's images folder
-- (Config.InventoryImages); run `restart qb-inventory` once after that. The console command `phoneitems` repeats the
-- check and says exactly what is missing. You can also copy the PNGs by hand:
--   apex_phone/inventory_images/*.png  →  qb-inventory/html/images/
--
-- Using a device item OPENS the phone with that device's OS, frame colour and prop; using it again closes it.
-- Item names must match Config.Devices, Config.EarbudsItem, Config.SlateBuds.item, Config.Sim.item and
-- Config.PhysicalSim.item. Labels and descriptions are yours to translate.
-- ============================================================

    -- Earbuds: use = put on / take off the 3D earbuds, then connect them in the phone (Bluetooth)
    ['airpods']            = { name = 'airpods',            label = 'AirPods Pro 3',                    weight = 60,  type = 'item', image = 'airpods.png',            unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'White wireless earbuds. Use to put them on, then connect them in the phone via Bluetooth.' },
    ['slate_buds']         = { name = 'slate_buds',         label = 'NOVA Buds 4 Pro',                     weight = 60,  type = 'item', image = 'slate_buds.png',         unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'Black wireless earbuds with a matching charging case. Use to put them on, then connect them in the phone via Bluetooth.' },

    -- eSIM card: use = open the phone camera and scan the QR code to add a line (Config.Sim)
    ['esim']               = { name = 'esim',               label = 'eSIM Card',                      weight = 5,   type = 'item', image = 'esim.png',               unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Prepaid eSIM card. Use it and scan the QR code with your phone to add a new number.' },

    -- PearPhone 18 Pro Max (PearOS, iOS style)
    ['pear18_black']       = { name = 'pear18_black',       label = 'PearPhone 18 Pro Max · Black',   weight = 231, type = 'item', image = 'pear18_black.png',       unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'PearPhone 18 Pro Max smartphone in black.' },
    ['pear18_white']       = { name = 'pear18_white',       label = 'PearPhone 18 Pro Max · White',   weight = 231, type = 'item', image = 'pear18_white.png',       unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'PearPhone 18 Pro Max smartphone in white.' },
    ['pear18_ice']         = { name = 'pear18_ice',         label = 'PearPhone 18 Pro Max · Ice Blue', weight = 231, type = 'item', image = 'pear18_ice.png',        unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'PearPhone 18 Pro Max smartphone in ice blue.' },
    ['pear18_wine']        = { name = 'pear18_wine',        label = 'PearPhone 18 Pro Max · Wine',    weight = 231, type = 'item', image = 'pear18_wine.png',        unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'PearPhone 18 Pro Max smartphone in wine.' },

    -- NOVA S26 Ultra (Nova UI, Android style): same apps and data as the PearPhone, they talk to each other
    ['s26_black']          = { name = 's26_black',          label = 'NOVA S26 Ultra · Black',         weight = 214, type = 'item', image = 's26_black.png',          unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'NOVA S26 Ultra Android smartphone in black.' },
    ['s26_white']          = { name = 's26_white',          label = 'NOVA S26 Ultra · White',         weight = 214, type = 'item', image = 's26_white.png',          unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'NOVA S26 Ultra Android smartphone in white.' },
    ['s26_violet']         = { name = 's26_violet',         label = 'NOVA S26 Ultra · Violet',        weight = 214, type = 'item', image = 's26_violet.png',         unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'NOVA S26 Ultra Android smartphone in violet.' },
    ['s26_sky']            = { name = 's26_sky',            label = 'NOVA S26 Ultra · Sky Blue',      weight = 214, type = 'item', image = 's26_sky.png',            unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'NOVA S26 Ultra Android smartphone in sky blue.' },

    -- Foldables: PearPhone Fold (PearOS) and NOVA Fold8 (Nova UI), both open like a book
    ['pearfold_night']     = { name = 'pearfold_night',     label = 'PearPhone Fold · Night Sky',     weight = 239, type = 'item', image = 'pearfold_night.png',     unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'PearPhone Fold foldable smartphone in night sky. Opens like a book into a wide inner screen.' },
    ['pearfold_star']      = { name = 'pearfold_star',      label = 'PearPhone Fold · Star White',    weight = 239, type = 'item', image = 'pearfold_star.png',      unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'PearPhone Fold foldable smartphone in star white. Opens like a book into a wide inner screen.' },
    ['novaflip_lavender']  = { name = 'novaflip_lavender',  label = 'NOVA Fold8 · Lavender',          weight = 188, type = 'item', image = 'novaflip_lavender.png',  unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'NOVA Fold8 foldable Android smartphone in lavender. Opens like a book into a wide inner screen.' },
    ['novaflip_grey']      = { name = 'novaflip_grey',      label = 'NOVA Fold8 · Grey',              weight = 188, type = 'item', image = 'novaflip_grey.png',      unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'NOVA Fold8 foldable Android smartphone in grey. Opens like a book into a wide inner screen.' },
    ['novaflip_cream']     = { name = 'novaflip_cream',     label = 'NOVA Fold8 · Cream',             weight = 188, type = 'item', image = 'novaflip_cream.png',     unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'NOVA Fold8 foldable Android smartphone in cream. Opens like a book into a wide inner screen.' },
    ['novaflip_pistachio'] = { name = 'novaflip_pistachio', label = 'NOVA Fold8 · Pistachio',         weight = 188, type = 'item', image = 'novaflip_pistachio.png', unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'NOVA Fold8 foldable Android smartphone in pistachio. Opens like a book into a wide inner screen.' },

    -- Physical SIM card (only used when Config.PhysicalSim.enabled = true). The number lives in the item metadata.
    ['sim_card']           = { name = 'sim_card',           label = 'SIM Card',                       weight = 5,   type = 'item', image = 'sim_card.png',           unique = true,  useable = true, shouldClose = true, combinable = nil, description = 'A phone number on a card. Use it to put it in the phone in your hand.' },
