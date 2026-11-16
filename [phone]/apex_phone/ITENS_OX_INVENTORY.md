# Apex Phone items (ox_inventory and other inventories)

Everything the items need ships inside `apex_phone`: the 3D props are streamed from `apex_phone/stream/`
(declared in the `fxmanifest.lua`) and the icons are served from `apex_phone/inventory_images/`
(`nui://apex_phone/inventory_images/<item>.png`). You do not copy any file into your inventory resource.

## Install (ox_inventory, one step)

Copy every entry of [`inventory_items.lua`](inventory_items.lua) **inside** the `return { ... }` of
`ox_inventory/data/items.lua`, then:

```
restart ox_inventory
restart apex_phone
```

Example entry:

```lua
    ['pear18_black'] = {
        label = 'PearPhone 18 Pro Max · Black',
        weight = 231, stack = false, close = true, consume = 0,
        description = 'PearPhone 18 Pro Max smartphone in black.',
        client = { export = 'apex_phone.useDevice', image = 'nui://apex_phone/inventory_images/pear18_black.png' },
    },
```

**Other inventories (qb-inventory, ESX):** create items with the same names and use the PNG files in
`inventory_images/` as icons. The usable item handlers are registered through your framework automatically.

## Item list

| Item | Device | OS | Prop |
|---|---|---|---|
| `pear18_black` | PearPhone 18 Pro Max · Black | PearOS (iOS style) | `apex_pear18_black` |
| `pear18_white` | PearPhone 18 Pro Max · White | PearOS | `apex_pear18_white` |
| `pear18_ice` | PearPhone 18 Pro Max · Ice Blue | PearOS | `apex_pear18_ice` |
| `pear18_wine` | PearPhone 18 Pro Max · Wine | PearOS | `apex_pear18_wine` |
| `s26_black` | NOVA S26 Ultra · Black | Nova UI (Android style) | `apex_s26_black` |
| `s26_white` | NOVA S26 Ultra · White | Nova UI | `apex_s26_white` |
| `s26_violet` | NOVA S26 Ultra · Violet | Nova UI | `apex_s26_violet` |
| `s26_sky` | NOVA S26 Ultra · Sky Blue | Nova UI | `apex_s26_sky` |
| `pearfold_night` | PearPhone Fold · Night Sky | PearOS, foldable | `apex_fold_apple_night_base` + `_leaf` |
| `pearfold_star` | PearPhone Fold · Star White | PearOS, foldable | `apex_fold_apple_star_base` + `_leaf` |
| `novaflip_lavender` | NOVA Fold8 · Lavender | Nova UI, foldable | `apex_fold_flip_lavender_base` + `_leaf` |
| `novaflip_grey` | NOVA Fold8 · Grey | Nova UI, foldable | `apex_fold_flip_grey_base` + `_leaf` |
| `novaflip_cream` | NOVA Fold8 · Cream | Nova UI, foldable | `apex_fold_flip_cream_base` + `_leaf` |
| `novaflip_pistachio` | NOVA Fold8 · Pistachio | Nova UI, foldable | `apex_fold_flip_pistachio_base` + `_leaf` |
| `airpods` | AirPods Pro 3 (earbuds) | both | `apex_airpod_l_v3` / `_r_v3` |
| `slate_buds` | NOVA Buds 4 Pro (earbuds) | both | `apex_slate_bud_l` / `_r` |
| `esim` | eSIM Card | both | `apex_esim_card` (held while scanning) |
| `sim_card` | SIM Card (physical SIM, optional) | both | none (inventory item only) |

## How the items behave

- **Devices:** using a device item opens the phone with that device's OS, frame colour, default wallpaper and
  prop in the hand. Using the same item again closes it; using another device switches without closing.
  The open key (`F1`) opens the device used last, or the first one found following `Config.DeviceOrder`.
  Only these items open the phone while `Config.RequireItem = true` (add a generic item with `Config.PhoneItem`).
- **PearOS and Nova UI share everything:** apps, account, number, messages and calls are the same on both
  systems, so players on different devices talk to each other normally.
- **Foldables:** open like a book (drag the left edge of the phone, or use the Control Center / quick panel
  button). In the hand they are two pieces that fold and unfold with the phone.
- **Earbuds (`airpods`, `slate_buds`):** using the item puts the 3D earbuds on the head (visible to nearby
  players) or takes them off. Connect them in the phone (Settings > Bluetooth). When connected, music keeps playing
  with the phone closed, only for that player. Only one pair at a time. Settings in `Config.AirPods` and
  `Config.SlateBuds`.
- **eSIM (`esim`):** using it opens the phone camera; scanning the QR code on the card activates a new line
  (up to `Config.Sim.maxLines` numbers per character). Activation uses one card. Optional item metadata:
  `{ iccid = '...', number = '555-1234' }` for a pre-assigned number. Settings in `Config.Sim`.

- **SIM card (`sim_card`):** only used when `Config.PhysicalSim.enabled = true`. The phone number lives on the card
  (metadata `{ iccid, number }`, `stack = false`: every card is a different number). Using it puts it in the phone in
  your hand; if that phone already has a SIM they swap. Optional "Eject SIM" button on the phone items:
  `buttons = { { label = 'Eject SIM', action = function(slot) exports.apex_phone:ejectSim(slot) end } }`.
  Admins give cards with `/givesim [id] [number]`.

## Getting the items in game (admin)

- `/apexdevices [id]` gives every device and both earbuds (`Config.DeviceGrantCommand`).
- `/phonegive [id] [item]` gives a single item.

## Customising

- `Config.Devices`: item name, `label`, `prop`, `frame` (screen frame colour) and `os` (`'ios'` or `'android'`).
- `Config.DeviceOrder`: preference order when opening with the key.
- `Config.FrameProps`: prop used when the phone opens without one of these items.
- `Config.PropAttach` (and `Config.Devices[item].attach`): bone, position and rotation of the prop in the hand.
- `Config.Android`: names shown on the Android phone (brand, model, OS name and version, store name).

Do not run any other resource that streams the same models (`apex_pear18_*`, `apex_s26_*`, `apex_fold_*`,
`apex_airpod_*`, `apex_slate_*`, `apex_esim_card`): duplicated archetypes can freeze the client.
