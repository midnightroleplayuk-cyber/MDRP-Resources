# kp_sling

Displays the configured `WEAPON_CARBINERIFLE_MK2` prop on the front of the player's torso, with the muzzle angled down, while it is in ox_inventory and not equipped. Equipping the weapon hides its prop; putting it away shows the prop again. Removing it from ox_inventory removes its prop. The defaults are starting values; the behavior and attachment can be changed in `config.lua` without editing `client.lua`.

## Installation

1. Place this folder in your server's resources directory.
2. Ensure `ox_inventory` starts before `kp_sling`.
3. Add `ensure kp_sling` to `server.cfg`.

The resource uses ox_inventory's client inventory-update event and `GetPlayerItems` / `getCurrentWeapon` exports. It does not require ox_lib or a Qbox export; Qbox servers using ox_inventory can use it directly.

## Configuration

Edit `config.lua`:

- `Config.Weapons` is the list of inventory weapon-to-prop mappings. Each entry has an ox_inventory `item` name and GTA `model` name. Add or remove entries to configure the weapons shown. An entry can override the default `bone`, `position`, and `rotation`.
- `Config.Attachments.bone` is the default ped bone ID (`24818`, `SKEL_Spine2`). `position` (`x`, `y`, `z`) is the default offset from the bone; positive `y` places the default prop forward. `rotation` (`x`, `y`, `z`, in degrees) controls its orientation. The defaults are intended to put the carbine on the front with its muzzle down; adjust them in game for your ped/model.
- `Config.Enabled` enables or disables sling props.
- `Config.HideEquippedWeapon` hides a configured weapon's prop while that weapon is equipped.
- `Config.NetworkedProps` creates props as networked entities so other clients can see them.
- `Config.PropCollision` enables prop collision. `Config.PropGravity` enables gravity. Both default to `false` for attached props.
- `Config.PollInterval` sets the fallback reconciliation interval in milliseconds. Inventory and weapon-change events trigger reconciliation immediately.
- `Config.ModelLoadTimeout` sets the maximum model load wait in milliseconds before a prop is skipped.
- `Config.Debug` enables attach/removal messages in the client console.

Each configured `model` must be a valid GTA object model name. The default mapping uses the Carbine Rifle Mk II inventory name `WEAPON_CARBINERIFLE_MK2` and prop model `w_ar_carbineriflemk2`. The client console reports invalid or unavailable models.
