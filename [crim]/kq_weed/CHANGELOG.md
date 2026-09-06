# Update 1.0.1
- Added official `vms_housing` property detection
- Added a `base_sql_import.sql` file to allow for manual import of the database when the automatic import fails (Very rare)
- Optimized the .net.dll initalization to hopefully make the resmon even lower
  - The "high" resmon of ~0.02 at idle is caused by simply having a C# (.net) script file loaded. The resource consumption is simply from having a .net process run, even when the script is not performing any active actions
  - We have put a portion of the code into C# as a safety measure to prevent our resource from being stolen (via Escrow exploit as mentioned by CFX today)
  - If this fix turns out not sufficient we will consider removing this safeguard and moving all the C# code to lua, which would make it run at 0.00 @ idle, at a cost of the safety of the resource. We will keep monitoring this issue. Thank you all for understanding 🙏

**⚙️ Updated files**
- `All non-editable .lua files`
- `server/editable/editable.lua`

___
# Update 1.1.0
- Added a max placement limit for pots, tables and presses
- Made the weed collection mini-game spawn a maximum of 20 buds per plant (even when player is set to receive more)
- Made the weed pressing mini-game spawn a maximum of 40 buds on the tray (even when more are required/taken from the player)
- Added an option to disable the entity outline or use an alternative system (glow or box outline)
  - This is especially useful for servers with many QuantV users. As QuantV crashes when the Native FiveM Entity Outline is used (Can be fixed by enabling the "Fix FiveM Outline crash" in Reshade)
- Added missing and new messages to locales (related to placement & vendors)

**⚙️ Updated files**
- All non-editable .lua files
- `server/editable/editable.lua`
- `config.lua` ⚠️
- `locales/en.json` ⚠️

___
# Update 1.2.0
- Added missing locale for the weed plant HUD (Config.misc.showPlantStatusUI)
- Added official `sn_properties` support
- Added a weather/rain disable while inside grow ops

**⚙️ Files to update**
- All non-editable .lua files
- `client/editable/editable.lua`
- `config.lua` ⚠️
- `locales/en.json` ⚠️

___
# Update 1.3.0 - Insect infestations 🦟
- Added insect infestations
- Each plant now has a chance of getting infested with insects
- When plants get infested bugs will fly around them and their color will change
- While plants are infested they'll lose health and eventually die
- Interact with the plants to spray them with Pesticide Spray (`kq_weed_pesticide_spray`)
- Brand-new Mini-game has been added for this action
- "Resistance" option in fertilizers now also affects the insect damage
- Few new `Config.misc` options have been added, so make sure to update your config.lua

Other changes
- Added `Config.misc.hudFontId`
- Added `Config.misc.hudScale`
- Fixed an issue where pickup up objects (pot, table, press) would allow for item dupe on servers with overloaded databases

**⚙️ Files to update**
- All non-editable .lua files
- `client/editable/editable.lua`
- `server/editable/editable.lua`
- `config.lua` ⚠️
- `config.strains.lua` ⚠️
- `locales/en.json` ⚠️

**Make sure to add the new item and item icon to your framework/inventory!**

___
# Update 1.3.1
- Fixed vms_housing integration issues
- Added `requiredItem` option to the grow ops and lockups
  - This allows you to require players to have an item in their inventory to open the doors

**⚙️ Files to update**
- All non-editable .lua files
- `server/editable/editable.lua`

___
# Update 1.3.2
- Added loaf_housing integration
- Fixed harmless errors which sometimes would occur on server join
- Fixed item icon naming `kq_weed_brick_blue_dream` (from `kq_weed_blue_dream`)

**⚙️ Files to update**
- All non-editable .lua files
- `server/editable/editable.lua`

___
# Update 1.4.0
- Added 8 new vibrant plant colors
- Improved object initalization for slow devices to get rid of the final (harmless) errors
- Fixed an issue when using whitelisted areas in combination with client-based housing systems

**⚙️ Files to update**
- All non-editable files
- `client/editable/editable.lua`
- `server/editable/editable.lua`
- `stream/[plants]/kq_weed_plants.ytd`

___
# Update 1.5.0
- Added an option to delete (player placed) pots after the weed plant is collected
  - To utilize this make sure to enable Config.removePotAfterCollection in the config file

**⚙️ Files to update**
- `server/classes/pot.lua`
- `config.lua`

___
# Update 1.6.0
- Added the ability to use the tables and presses to craft/process any item!
- You can now bag and brick cocaine from `kq_cocaine`  !
- You can now bag meth and amphetamines from `kq_meth` and `kq_meth_amphetamines` !
  - You must enable these in `config.extras.lua`
  - Make sure to also add all the new items mentioned in `config.extras.lua` to your inventory/framework
  - All drug scripts received an update with new item icons to support their bagged/bricked versions
- Added new custom props for cocaine and meth, chunks and bags

- Fixed an issue where press & table could become unusable when someone who's using them logs off
- Fixed a backend issue with event data processing

**⚙️ Files to update**
- `config.extras.lua` <- New file
- `client/functions.lua`
- `client/activities/bagging.lua`
- `client/activities/pressing.lua`
- `client/classes/press.lua`
- `client/classes/syncObject.lua`
- `client/classes/workbench.lua`
- `client/placement/placement.lua`
- `locales/en.json`
- `server/classes/press.lua`
- `server/classes/workbench.lua`
- `shared/utils.lua`
- `stream/[extras]` <- New files
- `fxmanifest.lua` <- Make sure to update too!

___
# Update 1.7.0
- Greatly optimized the network traffic data
  - Reduced the pot/plant network data size by ~75%
  - Previously a pot would store 550-750 bytes of data. Now its around 175 bytes per pot

**⚙️ Files to update**
- `shared/packer.lua` <- New file
- `client/classes/syncObject.lua`
- `server/classes/syncObject.lua`

___
# Update 1.8.0
- Added "budsPerBaggie" strain config option
  - This allows you to take multiple buds per baggie when bagging weed
  - The minigame will still represent the buds as a single object

**⚙️ Files to update**
- `client/classes/workbench.lua`
- `server/classes/workbench.lua`
- `config.strains.lua`

___
# Update 1.9.0
- Added "chunksPerBaggie" to config.extras recipes
- Added optional required item for watering the plant
- Added rtx_housing support
- Fixed an issue where placed objects would not get deleted on the clients, after a pickup when they were the last one on the server

**⚙️ Files to update**
- `config.extras.lua`
- `config.lua` <- New fields in Config.watering
- `client/functions.lua`
- `client/classes/pot.lua`
- `client/classes/syncObject.lua`
- `client/classes/workbench.lua`
- `server/classes/pot.lua`
- `server/classes/syncObject.lua`
- `server/classes/workbench.lua`
- `server/editable/editable.lua`
- `locales/en.json` <- New `pot.no_water_item` locale option added!

___
# Update 1.10.0 - Wild weed & joints

**Wild weed** (optional)
- Wild weed plants now spawn scattered around configurable areas for players to find and collect
- Collecting one uses the existing bud collection mini-game
- Each area is configured on its own in the new `config.wildweed.lua`
- Added a `CanCollectWildWeed` skill check

**Smoking joints** (optional)
- Joints can now be smoked
- Smoking slowly regenerates health and applies a screen effect

**Updated object synchronization & initialization system**
- Rebuilt the way pots, tables, presses, grow ops and lockups are synchronized to the players
  - Instead of using Statebags, we switched to using LatentEvents
  - By using LatentEvents instead of Statebags only players who are near the action, get the network data. 
  - Unlike statebags which update the entire dataset each time there's a small change. Our new system sends "deltas", meaning that it only sends the change, not the entire rebuilt data
  - This system is much more light-weight on both, the clients, and server

**Other changes**
- Player inventory is now fetched through the client framework/inventory exports. Instead of being routed through the server via callbacks

⚠ Make sure to update `kq_link` to `1.28.0`!

**⚙️ Files to update**
- All non-editable .lua files
- `config.lua` <- New `Config.weedEffect` section
- `config.wildweed.lua` <- New file
- `client/editable/debug.lua`
- `server/editable/editable.lua` <- New `CanCollectWildWeed` skill check
- `locales/en.json` <- New `wild` locale section
- `_installation/ox_item.txt` / `_installation/qbcore_item.txt` <- Joints are now usable items
