-- Rex Darts - QBCore item. Paste the entry into qb-core/shared/items.lua
-- (wrapped in a table only so this file is valid Lua; copy the entry inside).
-- ESX: INSERT INTO items (name, label, weight) VALUES ('dartboard', 'Dartboard', 3);
return {
    dartboard = {
        name = 'dartboard', label = 'Dartboard', weight = 2500, type = 'item', image = 'dartboard.png',
        unique = true, useable = true, shouldClose = true, combinable = nil,
        description = 'Hang it on a wall and challenge the room.',
    },
}
