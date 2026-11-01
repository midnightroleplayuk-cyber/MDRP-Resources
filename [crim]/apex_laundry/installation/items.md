# Apex Laundry — Items

The laundromat moves **two inventory items** around. Configure their
names in `shared/config.lua` → `Config.items`:

```lua
Config.items = {
    dirtyMoney = 'black_money',     -- fed INTO the machine
    cleanMoney = 'money',           -- only used when Config.economy.payout = 'item'
    cleaner    = 'cleaning_kit',    -- the consumable that fuels the machine
}
```

> The laundered (clean) payout and the upgrade cost can be paid in
> **money accounts** instead of items — see `Config.economy.payout`
> and `Config.economy.upgradePayment`. With the defaults (`'cash'`),
> you only need the **dirty money** item and the **cleaner** item.

---

## ox_inventory — `data/items.lua`

```lua
['cleaning_kit'] = {
    label = 'Cleaning Kit',
    weight = 200,
    stack = true,
    close = true,
    description = 'Industrial detergent and solvents for a laundromat machine.',
},
-- black_money usually already exists in ox_inventory. If not:
['black_money'] = {
    label = 'Dirty Money',
    weight = 0,
    stack = true,
    close = true,
},
```

Put the icons in `ox_inventory/web/images/` (`cleaning_kit.png`, etc.).

---

## ESX — `items` table (SQL)

```sql
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('cleaning_kit', 'Cleaning Kit', 1, 0, 1);
-- black_money is built into ESX; no insert needed.
```

---

## QBCore / QBox — `qb-core/shared/items.lua`

```lua
['cleaning_kit'] = {
    name = 'cleaning_kit', label = 'Cleaning Kit', weight = 200,
    type = 'item', image = 'cleaning_kit.png', unique = false, useable = false,
    shouldClose = true, description = 'Detergent + solvents for a laundromat machine.',
},
-- black_money / markedbills usually already exists in QB. Match the
-- name you use to Config.items.dirtyMoney.
```

---

## Giving items for testing

```
# ESX
/giveitem <id> cleaning_kit 50
/giveitem <id> black_money 100000

# QBCore / QBox
/giveitem <id> cleaning_kit 50
/giveitem <id> black_money 100000

# ox_inventory
/setitem <id> cleaning_kit 50
```
