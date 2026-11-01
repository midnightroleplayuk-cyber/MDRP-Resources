# Shared player-interaction items

These inventory items belong to `sky_jobs_base` because shared player
interactions use them without requiring a specific police or ambulance resource:

- `handcuffs`
- `handcuffs_keys`
- `zipties`
- `wire_cutter`
- `restraint_tool` (assisted release of handcuffs and zipties)
- `legcuffs`
- `headbag`
- `drug_test_kit`
- `advanced_drug_test_kit`
- `fake_drug_sample_clean`

Ready-to-copy item definitions for supported inventories are maintained in the
Sky-Systems documentation under **Jobs Base > Inventory Items**.

## Restraint checks in Chezza and Hex Inventory

Jobs Base already owns the cuff state (`ishandcuffed`) and the client export
`isPlayerCuffed(serverId?)`. These optional shipped client hooks connect inventories
whose stock checks only know the original Jaksam export. They do not add another
cuff state or change a banking/inventory item provider.

For **Chezza Inventory 4.3.9**, add this entry to the inventory's existing
`client_scripts` in `fxmanifest.lua`, before `client/*.lua`:

```lua
'@sky_jobs_base/config/inventory/chezza_restraints.lua',
```

Its shared configuration must load first. The hook replaces Chezza's stock
`Config.isHandcuffed` callback: own-player inventory checks and the target-rob
server ID use Sky's existing getter; MSK and the real started Jaksam remain
supported. If that callback already contains custom restraint providers, merge
those custom checks into the editable shipped hook before enabling it.
The hook also disables the Jaksam-only trunk bridge when the original is not
started; it does not claim Sky job-fleet trunk ownership support.

For **Hex Inventory 1.1.7**, add this entry to the inventory's existing
`client_scripts`, immediately after `client/os_functions.lua`:

```lua
'@sky_jobs_base/config/inventory/hex_restraints.lua',
```

This wraps the existing opening callback, preserving its arguments and all
original death, animation, legacy and phone checks. A cuffed Sky player is denied
before the original callback runs. Neither hook forces another provider's global
inventory lock on or off.

Install Jobs Base before adding either reference. No other inventory source file
needs replacing. Keep the integration entry when updating the inventory and the
hook file in Jobs Base when updating Sky. The hooks are loaded by the inventory,
not by Jobs Base itself; normal gameplay does not depend on Job Creator.

For assisted restraint release, merge `restraint_tool` from `items_ox.lua` into
ox_inventory's item definitions, or register it in your inventory's normal format.
It reuses the supplied `wire_cutter.png` image. Keep inventory-side consumption
disabled (`consume = 0` for ox_inventory); Jobs Base handles the optional consumption.
Jobs Base registers its usable-item binding automatically, so no second use callback
is needed. Use it beside another restrained player to start the server-validated
minigame. By default the same tool works for both restraint types without granting job actions.

Change `Config.PoliceCuffs.breakout.item` to use your own item, and set `consumeItem`
to remove one tool at the beginning of each attempt. These settings are also in
`/jobconfig` under Jobs Base > Interactions > Handcuffs > Free another player.
Leave `ziptiesItem = ""` to use `item` for both types. Set it to another item name
for separate tools, for example `item = "lockpick"` and `ziptiesItem = "wire_cutter"`.
Explicitly using the same item name in both fields also works and registers it once.
With separate tools, only the matching type can open the restraint and be consumed.
The minigame uses the difficulty under Escape attempts, even when random self-escape
opportunities are disabled. If a different script already owns your chosen item's
use action, disable `breakout.registerUsableItem` and integrate the
`breakRestraints` client export into that action instead
of registering competing callbacks. The default `restraint_tool` has a dedicated
name to avoid replacing existing key, cutter or vehicle-lockpick use actions.

The supplied `handcuffs.png`, `handcuffs_keys.png`, `zipties.png`, `wire_cutter.png`,
`legcuffs.png`, `headbag.png`, `drug_test_kit.png`, `advanced_drug_test_kit.png`, and
`fake_drug_sample_clean.png` files can be copied into your inventory image directory.

The advanced test adds up the active dose records reported by `sky_crimesystem` for each drug.
The clean fake sample is a normal stackable inventory item, so players can
transfer it with their inventory. Using it consumes one sample and falsifies
the carrier's next valid drug test during the configured activation window.

## Other enabled item-backed systems

Review these defaults in `config/config.lua` and either register their item
names or disable/remove the corresponding item binding:

- `Config.EmployeeGpsJammer`: `gps_jammer`
- `Config.DrugTests.simple`: `drug_test_kit` for the police job group
- `Config.DrugTests.advanced`: `advanced_drug_test_kit` for the ambulance job group
- `Config.DrugTests.fakeSample`: `fake_drug_sample_clean` for a transferable clean fake sample
- `Config.DrugTests.requireOnDuty`: optionally restrict both tests to on-duty members
- `Config.Tablet.item`: `tablet`
- `Config.ColleagueMapBlips.item`: `gps` when `requireItem = true`
- `Config.PropPlacement.items`:
  - `job_traffic_cone`
  - `job_worklight_stand`
  - `job_worklight`
  - `police_barrier`
  - `police_road_barrier`
  - `police_evidence_marker`
  - `police_stinger_spikes`
  - `police_checkpoint_tent`
  - `ambulance_barrier`
  - `ambulance_medical_crate`
  - `ambulance_defibrillator`
  - `ambulance_medical_bag`

No preview images are supplied for these additional items. Use matching images
from your inventory pack or change the configured item names.

## Printed documents and printer supplies

The release includes `items_ox.lua`, `job_document.png`, `printer_paper.png` and `printer_ink.png` in
this directory. For ox_inventory, merge the entries from `items_ox.lua` into
`ox_inventory/data/items.lua` and copy the images to `ox_inventory/web/images/`.
For other supported inventories, register the same item names using that
inventory's format: `job_document` must be unique/non-stackable and reusable,
and `printer_paper` / `printer_ink` are stackable refill items with `consume = 0`.
Supply items are required only when their consumption is enabled in the job's printer settings.
Reload the inventory definitions
according to its own installation instructions.

Printed documents require individual item metadata. Jobs Base registers item
use automatically; do not add a second usable-item callback. A printed copy
can be transferred to another player, who can read that copy without access
to the original digital record. Later edits or revoked digital sharing do not
change an existing printed copy.

## Case containers and the briefcase prop

Jobs Base also defines two shared, non-stackable container items:

- `sky_briefcase` — 24 slots / 25,000 weight units. The case starts hidden;
  **Show briefcase** attaches `prop_ld_case_01` to the right hand on demand.
- `sky_case_folder` — 12 slots / 8,000 weight units. This is an inventory-only
  case folder; it is not attached as a prop by default.

The default `sky_briefcase` allowlist accepts only `sky_case_folder`,
`job_document`, `doj_document` and `doj_law_book`. Set
`allowlistEnabled = false` on the briefcase entry in `config/item_containers.lua`
to allow other items; its self-blacklist remains active.

Copy both item definitions from `items_ox.lua` into
`ox_inventory/data/items.lua` (or the equivalent item catalog for another
provider), and copy `sky_briefcase.png` and `sky_case_folder.png` into the
inventory image directory. Each physical item receives its own container id in metadata, so the
contents travel with that exact item when it is moved to another player.

The active inventory is used in one of these ways:

| Inventory capability | Container behavior |
| --- | --- |
| ox_inventory / Qbox | Native ox container metadata and `container` inventory. On ox versions before the runtime `setContainerProperties` export, Jobs Base uses the same native metadata path plus a server-side swap filter for configured item restrictions. |
| CodeM V2, Core, One, Origen, PS, QB Inventory, QS, Tgiann | Unique item metadata plus the provider's registered stash API. Item filters depend on provider support. |
| Jaksam Inventory, AK47 Inventory | Unique item metadata plus the provider's registered stash API and its native item whitelist/blacklist filters. |
| ESX native, VRP native, JPR, CodeM V1, custom adapters without both metadata and stash support | The item can be registered as a normal item, but Jobs Base logs that a per-item container cannot be opened until the adapter supplies metadata and stash support. |

The briefcase starts hidden on each character session. Once shown, it follows
inventory ownership without touching the item itself. Other scripts can control it:

- `exports["sky_jobs_base"]:showPedItem("sky_briefcase")`
- `exports["sky_jobs_base"]:hidePedItem("sky_briefcase")`
- `exports["sky_jobs_base"]:togglePedItem("sky_briefcase")`

The supplied ox item definition includes two context-menu buttons, **Show
briefcase** and **Hide briefcase**, through this field on `sky_briefcase`:

```lua
buttons = require "@sky_jobs_base.config.inventory.ox_briefcase_buttons",
```

Keep that field when merging the item definition into `ox_inventory/data/items.lua`.
The module uses the inventory's `ox:locale` and the bundled Jobs Base translations;
its callbacks use the exports above. It loads as item data without calling Jobs
Base's runtime API at inventory startup. No ox core changes or runtime item/button
registration export are needed. Reload inventory item definitions after adding it.

Loading the inventory or opening the container does not display an owned
briefcase. Show and Hide persist across inventory updates for the character
session. Removing the last briefcase removes its prop. Logging out resets the
next character session to hidden. A hide/removal during model loading also
cancels the pending attachment.

The same calls are available through `Sky_Jobs.PedAttachments` and the local
events `sky_jobs_base:itemContainers:show` / `hide` / `toggle`. Custom
attachment entries can add a model, bone, offset, rotation and optional native
clothing component or prop lists in `Config.ItemContainers`.

Container labels can be changed per item when the active inventory preserves
metadata: call `exports["sky_jobs_base"]:renameContainer(slot, label)` from a
client custom action. The server only accepts slots containing a configured
container item.
