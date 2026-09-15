# QB Inventory items

Add the missing entries to `qb-core/shared/items.lua`. Do not add duplicates of items already provided by your server.

The `money` and `black_money` entries are required only when QB Inventory is paired with standalone framework mode. Their names can be changed in `ServerConfig.StandaloneMoneyItems`.

```lua
money = { name = 'money', label = 'Cash', weight = 0, type = 'item', image = 'money.png', unique = false, useable = false, shouldClose = false, description = '' },
black_money = { name = 'black_money', label = 'Dirty Money', weight = 0, type = 'item', image = 'black_money.png', unique = false, useable = false, shouldClose = false, description = '' },
drill = { name = 'drill', label = 'Drill', weight = 3500, type = 'item', image = 'drill.png', unique = false, useable = false, shouldClose = true, description = 'A heavy-duty drill.' },
lockpick = { name = 'lockpick', label = 'Lockpick', weight = 100, type = 'item', image = 'lockpick.png', unique = false, useable = false, shouldClose = true, description = 'A tool used to pick locks.' },
thermite = { name = 'thermite', label = 'Thermite', weight = 1000, type = 'item', image = 'thermite.png', unique = false, useable = false, shouldClose = true, description = 'An incendiary compound.' },
cigarettes = { name = 'cigarettes', label = 'Cigarettes', weight = 100, type = 'item', image = 'cigarettes.png', unique = false, useable = false, shouldClose = true, description = '' },
lighter = { name = 'lighter', label = 'Lighter', weight = 50, type = 'item', image = 'lighter.png', unique = false, useable = false, shouldClose = true, description = '' },
scratch_ticket = { name = 'scratch_ticket', label = 'Scratch Ticket', weight = 10, type = 'item', image = 'scratch_ticket.png', unique = false, useable = false, shouldClose = true, description = '' },
beer = { name = 'beer', label = 'Beer', weight = 500, type = 'item', image = 'beer.png', unique = false, useable = false, shouldClose = true, description = '' },
rolex = { name = 'rolex', label = 'Rolex', weight = 200, type = 'item', image = 'rolex.png', unique = false, useable = false, shouldClose = true, description = '' },
goldbar = { name = 'goldbar', label = 'Gold Bar', weight = 1500, type = 'item', image = 'goldbar.png', unique = false, useable = false, shouldClose = true, description = '' },
```