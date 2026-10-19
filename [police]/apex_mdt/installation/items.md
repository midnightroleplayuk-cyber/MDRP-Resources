# Apex MDT - Item Setup

The tablet can be opened with `/mdt`, the `F6` keybind, or a usable inventory
item (`Config.openItem`, default `tablet`). Registering the item is **optional** - the command and keybind work without it.

## ox_inventory (`data/items.lua`)

```lua
['tablet'] = {
    label = 'MDT Tablet',
    weight = 1000,
    stack = false,
    close = true,
    description = 'Police / EMS Mobile Data Terminal',
    client = { export = 'apex_mdt.useTablet' }, -- optional; the usable item is also registered server-side
},
```

## ESX (`esx_inventoryhud` / legacy) - `items` SQL table

```sql
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('tablet', 'MDT Tablet', 1, 0, 1);
```

The server already calls `ESX.RegisterUsableItem('tablet', ...)` automatically,
so once the item exists players can "use" it to open the tablet.

## QBCore (`qb-core/shared/items.lua`)

```lua
tablet = { name = 'tablet', label = 'MDT Tablet', weight = 1000, type = 'item', image = 'tablet.png', unique = false, useable = true, shouldClose = true, description = 'MDT Tablet' },
```

The server calls `QBCore.Functions.CreateUseableItem('tablet', ...)` automatically.

## Give an item

```
# ESX
/giveitem <id> tablet 1
# QBCore
/giveitem <id> tablet 1
```

> Change the item name in `Config.openItem`. Set it to `''` to disable the
> usable-item entirely (command + keybind still work).
