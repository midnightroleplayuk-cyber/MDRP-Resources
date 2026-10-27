-- Paste into ox_inventory/data/items.lua (inside the returned table).
-- The icon is served by this resource, so no image needs copying.

['rsvx_safe'] = {
    label = 'Safe',
    weight = 15000,
    stack = false,
    close = true,
    consume = 0, -- the server removes it only after a successful placement
    description = 'A heavy-duty safe. Use it to place it down and store your valuables.',
    client = {
        image = 'nui://rsvx_safe/ui/rsvx_safe.png',
        event = 'rsvx_safe:use',
    },
},

-- Needed to crack other players' safes (Config.Robbery.item).
['safecracker'] = {
    label = 'Safe Cracker',
    weight = 1500,
    stack = true,
    close = true,
    description = 'A stethoscope and a set of picks. Not for honest work.',
    client = { image = 'nui://rsvx_safe/ui/safecracker.png' },
},
