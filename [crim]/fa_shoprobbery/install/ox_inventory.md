# ox_inventory items

Add the missing entries to `ox_inventory/data/items.lua`. Do not add duplicates of items already provided by your server.

```lua
['money'] = {
    label = 'Cash',
    weight = 0,
    stack = true,
    close = false
},

['black_money'] = {
    label = 'Dirty Money',
    weight = 0,
    stack = true,
    close = false
},

['drill'] = {
    label = 'Drill',
    weight = 3500,
    stack = false,
    close = true,
    description = 'A heavy-duty drill.'
},

['lockpick'] = {
    label = 'Lockpick',
    weight = 100,
    stack = true,
    close = true,
    description = 'A tool used to pick locks.'
},

['thermite'] = {
    label = 'Thermite',
    weight = 1000,
    stack = true,
    close = true,
    description = 'An incendiary compound.'
},

['cigarettes'] = {
    label = 'Cigarettes',
    weight = 100,
    stack = true,
    close = true
},

['lighter'] = {
    label = 'Lighter',
    weight = 50,
    stack = true,
    close = true
},

['scratch_ticket'] = {
    label = 'Scratch Ticket',
    weight = 10,
    stack = true,
    close = true
},

['beer'] = {
    label = 'Beer',
    weight = 500,
    stack = true,
    close = true
},

['rolex'] = {
    label = 'Rolex',
    weight = 200,
    stack = true,
    close = true
},

['goldbar'] = {
    label = 'Gold Bar',
    weight = 1500,
    stack = true,
    close = true
},
```