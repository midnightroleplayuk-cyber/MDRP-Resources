-- Rex Darts - ox_inventory item. Paste the entry into ox_inventory/data/items.lua
-- (wrapped in a table only so this file is valid Lua; copy the entry inside).
return {
    ['dartboard'] = {
        label = 'Dartboard',
        weight = 2500,
        stack = false,
        close = true,
        description = 'Hang it on a wall and challenge the room.',
        server = { export = 'rex_darts.useItem' },
    },
}
