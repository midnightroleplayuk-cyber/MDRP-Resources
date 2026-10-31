# Items

Ready-made item definitions are in `install/`, with icons in `install/images/`:

| File | For |
|---|---|
| `ox_inventory_items.lua` | ox_inventory: paste into `ox_inventory/data/items.lua`, copy the images to `ox_inventory/web/images/` |
| `qb_items.lua` | QBCore / Qbox with qb-inventory (or ps / lj): paste into `qb-core/shared/items.lua` |
| `esx_items.sql` | ESX's default inventory: run it on your database |

| Item | What it does |
|---|---|
| `handcuffs` | Use it to take the cuffs out (they're in your hand), then E or the cuff key cuffs the person in front. Backspace or using it again puts them away. |
| `police_notice` | Paper copy of a fixed penalty, traffic offence report, vehicle seizure notice, or (without the MDT) stop and search record. Use it to read it again. |
| `bail_notice` | vinewood-mdt 2.19.2+: the bail notice. Use it to read it again (conditions and answer date, always up to date). |
| `stop_search_record` | vinewood-mdt 2.19.2+: the stop and search record. Use it to read it again. |
| `mobile_id` | Only if `Config.NPC.FingerprintItem = 'mobile_id'`. |
| `mdt_tablet` | Only if vinewood-mdt `Config.Item = 'mdt_tablet'`. |

Weapons, `ammo-9`, `ammo-rifle`, `bandage` and `radio` are ox_inventory's own items. On qb-inventory the ammo is `pistol_ammo` and `rifle_ammo`: change them in `config/equipment.lua`.

Using items doesn't use them up. Item names can be changed: `Config.Restraint.HandcuffsItem.Item`, `Config.NoticeItem`, and in vinewood-mdt `Config.BailNoticeItem` and `Config.StopSearch.ReceiptItem`.
