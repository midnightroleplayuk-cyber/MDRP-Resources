# vinewood_multichar

Cinematic character selection for Qbox, QBCore and ESX Legacy, with an in-game scene editor, slot management, ACE bonuses and Discord role slots.

## Install

1. Drop `vinewood_multichar` into your resources and ensure it **after** your framework, ox_lib, oxmysql and your clothing script:
   ```
   ensure ox_lib
   ensure oxmysql
   ensure qbx_core
   ensure illenium-appearance
   ensure vinewood_multichar
   ```
2. Remove or stop any other multicharacter resource.
3. Framework switch-off:
   - **Qbox**: in `qbx_core/config/client.lua` set `characters.useExternalCharacters = true`.
   - **QBCore**: stop `qb-multicharacter`.
   - **ESX**: set `Config.Multichar = true` in es_extended and stop `esx_multicharacter`. Character identifiers use the `char1:`, `char2:` prefix.
4. Tables are created on first start (`sql/install.sql` is there if you prefer to run it yourself).
5. Give admins access in `server.cfg`:
   ```
   add_ace group.admin vinewood.multichar.admin allow
   add_ace group.admin vinewood.multichar.staff allow
   add_ace group.vip   vinewood.multichar.vip   allow
   ```

## Slots

Slots are worked out in this order:

1. **Base** slots for everyone.
2. **Bonuses**: ACE permissions, Discord roles, and personal "extra" overrides. With *stacking* on they add together; off, only the biggest counts.
3. A personal **"exactly"** override replaces all of the above.
4. Capped at **Maximum slots**.

Everything is editable in `/charadmin`. Personal overrides accept an online server id, or an offline `license:` / `discord:` identifier. There's also a server export for Tebex or other scripts:
```lua
exports.vinewood_multichar:SetSlotOverride('license:abc123', 'add', 2, 'Tebex VIP')
exports.vinewood_multichar:GetAllowedSlots(source)
```

## Discord role slots

1. Create a bot at https://discord.com/developers/applications, copy its token, and invite it to your server (no special permissions needed, it only reads members).
2. In `server/config_server.lua` set `Enabled = true`, `BotToken` and `GuildId`. This file is server-only, so the token never reaches players.
3. Restart, open `/charadmin` → Discord, pick roles from the dropdown and set how many extra slots each gives.

Already running Badger_Discord_API? Set `Provider = 'badger'` instead.

## Building scenes

`/charadmin` → Scenes → **New scene**. The editor opens with a free camera.

| Panel mode | Fly mode |
|---|---|
| **Tab** to fly | **WASD** move, **Q/E** down/up, **Shift** fast, **Alt** slow |
| Edit everything in the side panel | **Scroll** field of view, **C** add keyframe at your view, **Tab** back to panel |

**Placing** (spots and props): aim with the mouse, **Scroll** rotate (**Alt** for fine), **Ctrl + Scroll** raise/lower, **G** snap props to ground, **Left click** place, **Right click** cancel.

- **Character spots**: where each slot's character stands. Pick a pose preset, a custom animation (dict/clip/flag) or a scenario, and optionally a hand prop with bone and offsets. Use **Camera from view** to frame a spot yourself, or leave it on the automatic three-quarter shot.
- **Props**: any model name. Fine-tune position/rotation in the panel.
- **Intro camera path** (Path tab): keyframes joined by a smooth spline.
  - *Continuous* motion runs through every keyframe without slowing (one overall feel for the whole move); *Stop at each keyframe* eases in and out of each one. "Pause here" always stops the camera.
  - Per keyframe: travel time, pause, field of view, **roll** (or **Z / X** in fly mode, **R** to level) and **Aim**, which tracks a character spot so the camera stays locked on while it moves.
  - **Orbit move** builds an arc of tracking keyframes around a spot (distance, sweep, start/end height, direction).
  - **Even out speed** spreads the total time by distance so the camera moves at a constant speed.
  - **Glide into first character** carries the path straight into the first character's shot with no stop.
- **Camera feel**: transition time and easing between characters, handheld sway and depth of field.

With fewer spots than slots, characters take turns on the same spot with a fade. **Preview all** runs the full sequence; **Backspace** stops it.

## Clothing scripts

`Config.Clothing = 'auto'` picks up whichever of these is running:

| Script | Preview peds | New character creator |
|---|---|---|
| op-clothing | `SetPedSkin` | `OpenCharacterCreator` |
| rcore_clothing | `getSkinByIdentifier` + `setPedSkin` | QBCore / esx_skin events |
| qs-appearance | illenium-compatible | `qb-clothes:client:CreateFirstCharacter` |
| illenium-appearance | `setPedAppearance` | `qb-clothes:client:CreateFirstCharacter` / esx_skin |
| fivem-appearance | `setPedAppearance` | as above |
| qb-clothing | `loadPlayerClothing` | `qb-clothes:client:CreateFirstCharacter` |
| skinchanger (ESX) | built in | esx_skin |

Anything else: set `Config.Clothing = 'custom'` and fill in `fromCustom` in `server/clothing.lua` plus `Open.ApplyPreviewSkin` / `Open.OpenCustomCreator` in `client/open.lua`.

## Hooks

`client/open.lua` is where to change spawning (spawn selectors, apartments), clothing on new characters, HUD hiding and weather sync pausing.

## Commands

- `/charadmin`: admin menu (ACE `vinewood.multichar.admin`)
- `/switchcharacter`: back to the selection screen (cooldown and optional ACE in `config.lua`)
