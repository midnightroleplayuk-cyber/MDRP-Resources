# Frameworks and inventories

Everything is detected at runtime. There is nothing to set.

| | Supported |
|---|---|
| Frameworks | Qbox (`qbx_core`), QBCore (`qb-core`), ESX (`es_extended`) |
| Inventories | ox_inventory, qb-inventory, qs-inventory, core_inventory, codem-inventory |
| Targeting | ox_target, qb-target, or neither (falls back to a keypress) |
| Required | ox_lib, oxmysql |

The startup console prints which framework and inventory it found.

## Where the data lives

Licence categories, the DVLA record, points and bans are stored in the script's
own table, `vinewood_licensing_drivers`. That's what makes it work the same on
all three frameworks — ESX has no character metadata to use.

On Qbox and QBCore the categories are also mirrored into `metadata.licences`, so
any other resource that already reads that keeps working, and existing characters
are imported from it automatically the first time they're loaded. Nothing to
migrate by hand.

## Inventories without item metadata

The physical licence carries the photo, number, dates and address as item
metadata. `ox_inventory`, `qb-inventory`, `qs-inventory` and `codem-inventory`
support that; `core_inventory` does not.

Where it isn't supported the item is just a token, and the card is rebuilt from
the driver record each time it's shown. Players see no difference — same photo,
same number, same dates. The only loss is the detail shown in the inventory
tooltip when hovering the item.

## Using the licence

- **ox_inventory**: the item definition calls the client export. Both items need:
  ```lua
  consume = 0,
  client = { export = 'vinewood_licensing.useLicence' }
  ```
- **Everything else**: the item is registered server-side automatically
  (`CreateUseableItem` on QB, `RegisterUsableItem` on ESX). Just add the items to
  your inventory's item list — no export line needed.

## ESX notes

- Money accounts map as `bank` to `bank` and `cash` to `money`.
- Names and dates of birth come from the `users` table for offline lookups.
- `metadata.licences` doesn't exist, so other ESX resources that check driving
  licences should use the exports in EXPORTS.md instead.
