# hf1_bootscript — QBox / ox stack

## Installation
1. Copy `hf1_bootscript` into your server resources directory.
2. Ensure `qbx_core`, `ox_lib`, `ox_target`, `ox_inventory`, and your appearance resource start before this resource.
3. Add `ensure hf1_bootscript` to `server.cfg`.
4. Edit `shared/config.lua` to set job grades, PIN, item names, vehicles and outfits.
5. IMPORTANT: set `Config.Traffic` to the REAL event/export used by your particular no-bs traffic prop script. The example is a placeholder and will not work unless that event exists.
6. Set `Config.Appearance` to `illenium-appearance` or `fivem-appearance`. Clothing drawables/textures are placeholders, not real police outfits.

## How it works
- Target the rear boot bone of a listed vehicle while on duty as police. A widescreen NUI opens.
- Clothing overlays configured components/props over the original full appearance, and returns to the original appearance when all borrowed clothing is returned.
- Police items are available on all configured cars. Traffic and firearms appear only for their respective vehicle lists and grades.
- Traffic closes the tablet and invokes the configured client event/export.
- Firearms require server-side grade validation and a server-side 4-digit PIN with rate-limited attempts. Item issuance and returns are server validated and use ox_inventory.

## Important limitations / testing notes
- Item issue tracking is in-memory and resets on server/resource restart; it is not a persistent stock/armoury ledger. If you need persistent ownership, audit logging, plate-bound stock or prevention of duplicated gear after restart, add a database-backed issuance ledger.
- Items are generated/removed from player inventory, not from a real trunk stash. Set proper item definitions in ox_inventory. Weapon metadata/serials are handled by ox_inventory defaults.
- Clothing changes are client-side and the saved original appearance is lost on resource/client restart. Persist it or integrate with your clothing system if needed. Applying a full appearance while other appearance scripts are active can cause conflicts.
- The example outfit component drawables may be invalid for your player model. Configure male/female or model-specific outfit handling if your pack needs it.
- ox_target `bones={'boot'}` requires a vehicle with a recognized boot bone. Custom vehicle models without one may require a target offset fallback.
## Security PIN setup (recommended)
The PIN is checked only server-side. Add `set hf1_boot_pin "YOUR4DIGITS"` to `server.cfg` and use a private code.

## Test checklist
- On-duty vs off-duty, police vs civilian, grades at thresholds.
- Each car list, each tab, distance checks and custom boot bone.
- Correct/incorrect PIN, lockout, unauthorized callback attempts.
- Inventory full, unknown items, weapon issue/return, server restart.
- Clothing overlay and return for both freemode genders, disconnect while wearing clothing.
- Configure and test no-bs menu integration.


## v1.1 integration notes
- **OP Clothing**: `Config.Appearance = 'op-clothing'` attempts the documented illenium-compatible `getPedAppearance` / `setPedAppearance` export signatures on the `op-clothing` resource. The OP docs confirm compatibility, but the exact export host name was not verified; check your installation. If your compatibility exports live under `illenium-appearance`, set that resource name instead. Test equip/return before production.
- **BS Prop Placer**: The attached `bs-propplacer/config.lua` confirms `Config.OpenCommand = 'signs'`. This build uses `ExecuteCommand('signs')` after closing the boot tablet. Its client is escrow-protected, so the command is the confirmed integration point, not an invented event. Start `bs-propplacer` before `hf1_bootscript`.
- **Police logo**: Replace `web/logo.png` with your force crest (prefer a transparent PNG, e.g. 256x256). Configure `Config.Tablet.logo`, `forceName` and `title` in `shared/config.lua`. If changing the logo filename, also include it in `fxmanifest.lua` `files`.
- No BS Prop Placer files are redistributed in this archive; install your purchased resource separately.


## v1.2 changes
- Opening the tablet plays a key-fob opening animation and opens the vehicle boot (door index 5). Closing the tablet, opening /signs, walking away, or stopping the resource shuts the boot without a player closing animation. Vehicle door behaviour depends on the custom vehicle model.
- Police items and firearms display one USE button until taken, then one RETURN button. State is server-tracked per citizen ID while the resource is running, and synced each time the boot opens. Items must be returned through the tablet before another can be taken.
- Item icons use ox_inventory images: `https://cfx-nui-ox_inventory/web/images/<item>.png`. Optional `image = 'filename_without_extension'` can be set per item in config. Missing images hide automatically.
- Issuance records are in memory and reset on resource restart; consider persistent storage for production.
