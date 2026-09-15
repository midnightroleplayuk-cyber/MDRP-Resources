# Apex Gangs — Items

All items are **optional** — the script works without them (set `Config.graffiti.item = false` to drop the spray requirement, and raid loot items only drop if they exist). Add the ones you want for the full experience.

## Items used

| Item | Used by | Notes |
|---|---|---|
| `spraycan` | Graffiti | required to spray a tag (`Config.graffiti.item`). Set `consumeItem = true` to use one per tag. |
| `spray_remover` | Graffiti | optional remover item (`Config.graffiti.removerItem`). |
| `gang_supplies` | Raid loot | dropped to attackers on a successful raid. |
| `weapon_parts` | Raid loot | dropped to attackers on a successful raid. |

---

## ox_inventory (`data/items.lua`)

```lua
['spraycan'] = {
    label = 'Spray Can', weight = 400, stack = true, close = true,
    description = 'Tag walls with your gang colours.',
    client = { export = 'apex_gangs.useSprayItem' },
},
['spray_remover'] = {
    label = 'Spray Remover', weight = 500, stack = true, close = true,
    description = 'Scrub rival tags off the wall.',
},
['gang_supplies'] = { label = 'Gang Supplies', weight = 1000, stack = true, close = false },
['weapon_parts']  = { label = 'Weapon Parts',  weight = 800,  stack = true, close = false },
```

> The `spraycan` client export is optional — you can also open the gang menu's **Graffiti** tab to spray. To wire a usable item, register it in your framework so it triggers the client event `apex_gangs:graffiti:useItem` (which opens the menu).

---

## ESX (`items` SQL table)

```sql
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('spraycan',      'Spray Can',      4, 0, 1),
('spray_remover', 'Spray Remover',  5, 0, 1),
('gang_supplies', 'Gang Supplies', 10, 0, 1),
('weapon_parts',  'Weapon Parts',   8, 0, 1);
```

Register the spray can as usable (e.g. in an `esx` server script):

```lua
ESX.RegisterUsableItem('spraycan', function(source)
    TriggerClientEvent('apex_gangs:graffiti:useItem', source)
end)
```

---

## QBCore / QBox (`shared/items.lua`)

```lua
spraycan      = { name = 'spraycan',      label = 'Spray Can',     weight = 400,  type = 'item', image = 'spraycan.png',      unique = false, useable = true,  shouldClose = true,  description = 'Tag walls with your gang colours.' },
spray_remover = { name = 'spray_remover', label = 'Spray Remover', weight = 500,  type = 'item', image = 'spray_remover.png', unique = false, useable = true,  shouldClose = true,  description = 'Scrub rival tags.' },
gang_supplies = { name = 'gang_supplies', label = 'Gang Supplies', weight = 1000, type = 'item', image = 'gang_supplies.png', unique = false, useable = false, shouldClose = false, description = 'Crew supplies.' },
weapon_parts  = { name = 'weapon_parts',  label = 'Weapon Parts',  weight = 800,  type = 'item', image = 'weapon_parts.png',  unique = false, useable = false, shouldClose = false, description = 'Spare weapon parts.' },
```

```lua
QBCore.Functions.CreateUseableItem('spraycan', function(source)
    TriggerClientEvent('apex_gangs:graffiti:useItem', source)
end)
```

> Put matching PNGs in your inventory's `images/` folder for the icons to show.
