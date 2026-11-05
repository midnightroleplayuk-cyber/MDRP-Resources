-- Add this ENTRY inside ox_inventory/data/items.lua:
['tv'] = {
    label = 'Television',
    weight = 5000,
    stack = false,
    close = true,
    consume = 0, -- The server consumes it ONLY after a valid placement is confirmed.
    client = { export = 'hf1_tv.useTelevision' }
},
