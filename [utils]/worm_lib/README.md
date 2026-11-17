# worm_lib

Our shared library. Every Wormhole script uses it to talk to your framework, your inventory, your notify,
dispatch and progress bar, so the scripts themselves never have to care which ones you run.

It also ships a few things scripts can use directly: an **interaction** system (aim at a dot, press E),
a **task list** (top left) and a **key hint** strip (bottom right).

This guide covers installing it and every export it shares. If you only bought a script, you only need
**Install** and **Something's wrong?**. The rest is for developers.

---

## What your server needs

- **ox_lib**: download it from https://github.com/overextended/ox_lib/releases (the `ox_lib.zip` file, not the source code).
- **One framework**: QBox, QBCore or ESX.
- **One inventory**: ox_inventory, qb-inventory, qs-inventory, codem-inventory or tgiann-inventory.

You don't need to set anything up for the framework or the inventory. worm_lib finds them by itself.

---

## Install

### Step 1: Put the folder in

Copy `worm_lib` into your `resources` folder.

⚠️ **Do not rename `worm_lib`.** Our scripts call `exports.worm_lib`, so the folder must be called exactly that.

### Step 2: Add it to server.cfg

`worm_lib` must start **after** ox_lib, your framework and your inventory, and **before** any script that uses it:

```cfg
ensure ox_lib
# ... your framework (qbx_core / qb-core / es_extended) ...
# ... your inventory ...

ensure worm_lib
# ... Wormhole scripts (worm_hunting, ...) ...
```

### Step 3: Start the server

Watch the console. You should see a green `[Wormhole Lib] inventory: <name>` line.
`No framework found` or `No inventory found` in red means the order in Step 2 is wrong.

That's it. Nothing else to install: the UI comes already built.

---

## Settings

Everything is in `shared/config.lua`. Every line has a comment.

| I want to... | Look for | Values |
|---|---|---|
| Use a different notify | `notify` | `'auto'` (ox_lib if it's running), `'ox'`, `'framework'` |
| Use a different progress bar | `progress` | `'bar'`, `'circle'` (ox_lib), `'qb'` (QBCore progressbar) |
| Pick the dispatch system by hand | `dispatch` | `'auto'`, `'ps-dispatch'`, `'cd_dispatch'`, `'qs-dispatch'`, `'rcore_dispatch'`, `'linden_outlawalert'`, `'core_dispatch'`, `'origen_police'`, `'codem-dispatch'`, `'tk_dispatch'`, `'emergencydispatch'`, `'custom'`, `'none'` |
| Send alerts to my own dispatch | `dispatch = 'custom'` + `dispatchCustom` | `function(data) ... end` (client) |
| Pick the inventory by hand | `inventory.system` | `'auto'`, `'ox'`, `'qb'`, `'qs'`, `'codem'`, `'tgiann'` |
| Change where item pictures load from | `inventory.imagePath` | e.g. `ox = 'nui://ox_inventory/web/images/%s.png'` |
| Change the task list key | `Config.taskList.keybind` | `defaultKey = 'M'`, or `false` for no key |
| Change the interaction key | `Config.interaction.keybind` | `defaultKey = 'E'` |
| Pick the appearance resource for outfits | `Config.outfit.system` | `'auto'`, `'illenium-appearance'`, `'fivem-appearance'`, `'qb-clothing'`, `'esx_skin'`, `'none'` |
| Print extra info to the console | `debug` | `true` / `false` |
| Turn off the update check on start | `versionCheck` | `true` / `false` |
| Change the language | `server.cfg` | `setr ox:locale "en"` (`en` and `tr` ship with it) |

Players can rebind both keys themselves in **Settings > Key Bindings > FiveM**.

---

## Exports

Everything is a plain export: `exports.worm_lib:name(...)`. Detection happens on the first call, so it's
safe to call them as soon as worm_lib has started.

### Quick list

| Module | Side | Exports |
|---|---|---|
| Framework | server | `getFrameworkName`, `getFrameworkType`, `getCoreObject`, `getPlayer`, `getIdentifier`, `getPlayerName`, `getSourceByIdentifier`, `getPlayers`, `getJob`, `getJobData`, `setJob`, `getDuty`, `setDuty`, `getMoney`, `addMoney`, `removeMoney`, `getDirtyMoney`, `removeDirtyMoney`, `isAdmin`, `getVar`, `getSharedItems`, `onPlayerLoaded`, `onPlayerUnload` |
| Framework | client | `getFrameworkName`, `getFrameworkType`, `getPlayerData`, `isLoaded`, `getIdentifier`, `getJob`, `getJobGrade`, `getVar` |
| Inventory | server | `getInventoryName`, `AddItem`, `RemoveItem`, `GetItems`, `GetItemCount`, `hasItem`, `CanCarryItem`, `FindItem`, `GetItemBySlot`, `SetMetadata`, `RegisterUsableItem`, `RegisterStash`, `OpenStash`, `GetStashItems`, `GetStashItemCount`, `AddStashItem`, `RemoveStashItem`, `GetItemList`, `GetItemLabel`, `GetItemImage` |
| Inventory | client | `getInventoryName`, `GetItemCount`, `hasItem`, `openStash` |
| Notify | both | `notify` |
| Dispatch | both | `dispatch`, `getDispatchName` |
| Progress | client | `progress` |
| Task list | client | `showTaskList`, `updateTaskList`, `hideTaskList`, `addTask`, `updateTask`, `setTaskDone`, `completeTask`, `removeTask`, `hasTask`, `toggleTaskList`, `isTaskListOpen`, `getTaskList`, `setTaskListVisible`, `isTaskListVisible` |
| Key hints | client | `addHint`, `updateHint`, `removeHint`, `clearHints`, `hasHint`, `getHints`, `setHintsVisible`, `isHintsVisible` |
| Outfit | client | `applyOutfit`, `restoreOutfit`, `hasOutfit` |
| Interaction | client | `addInteractionBoxZone`, `addInteractionSphereZone`, `addInteractionPolyZone`, `removeInteractionZone`, `interactionZoneExists`, `addInteractionCoords`, `removeInteractionCoords`, `addInteractionGlobalPed` / `Player` / `Vehicle` / `Object` / `Option` (+ `removeInteractionGlobal…`), `addInteractionModel`, `removeInteractionModel`, `addInteractionEntity`, `removeInteractionEntity`, `addInteractionLocalEntity`, `removeInteractionLocalEntity`, `disableInteraction`, `isInteractionDisabled`, `isInteractionActive`, `getInteractionFocused`, `getInteractionOptions` |

---

### Framework (server)

| Export | Returns |
|---|---|
| `getFrameworkName()` | `'qb'` (QBCore **and** QBox) or `'esx'` |
| `getFrameworkType()` | `'qbx'`, `'qb'` or `'esx'` |
| `getCoreObject()` | the QBCore / ESX object |
| `getPlayer(src)` | the framework's player object |
| `getIdentifier(src)` | citizenid (QB) / identifier (ESX) |
| `getPlayerName(src)` | character name, `"First Last"` |
| `getSourceByIdentifier(identifier)` | the online source, or `nil` |
| `getPlayers(jobcheck?, jobs?)` | list of sources; with `jobcheck = true`, only the ones in `jobs` (`'police'` or `{ 'police', 'sheriff' }`) |
| `getJob(src)` | job name |
| `getJobData(src)` | `{ name, label, grade, gradeLabel, isboss }` |
| `setJob(src, name, grade?)` | `true` / `false` |
| `getDuty(src)` | is the player on duty (QB / QBox `onduty`; ESX has no duty, always `true`) |
| `setDuty(src, on)` | sets the duty flag (QBox `SetJobDuty`, QB `Functions.SetJobDuty`; a no-op on ESX); `true` when the framework took it |
| `getMoney(src, account?)` | number. `account`: `'cash'` (default), `'bank'`, `'black_money'` |
| `addMoney(src, amount, account?, reason?)` | `true` / `false` |
| `removeMoney(src, amount, account?, reason?)` | `true` / `false` (fails when the balance is too low) |
| `getDirtyMoney(src, spec)` | number, see below |
| `removeDirtyMoney(src, amount, spec)` | how much was actually taken |
| `isAdmin(src, aces?, groups?)` | checks the ace permissions first, then framework groups (default `{ 'admin', 'god' }`) |
| `getVar(src, name)` | `'citizenid'`, `'name'`, `'dob'`, `'gender'`, `'phone'`, `'license'`, `'callsign'` (QB only) |
| `getSharedItems()` | the framework's item registry |
| `onPlayerLoaded(cb)` / `onPlayerUnload(cb)` | runs `cb(src)` when a character loads / unloads (also on drop) |

```lua
local src = source
if exports.worm_lib:removeMoney(src, 500, 'bank', 'license fee') then
    exports.worm_lib:notify(src, 'Paid $500', 'success')
end
```

**Dirty money.** Servers keep it in different ways, so you pass a `spec` that says where it is:

```lua
{ mode = 'account', account = 'black_money' }              -- ESX style account
{ mode = 'item', item = 'black_money' }                    -- one item = $1
{ mode = 'item_worth', item = 'markedbills', field = 'worth' }  -- QB marked bills, value in metadata
```

With `item_worth`, `removeDirtyMoney` takes the smallest stacks first and lowers the `worth` of the last
one instead of over-taking.

### Framework (client)

| Export | Returns |
|---|---|
| `getFrameworkName()` / `getFrameworkType()` | same as server |
| `getPlayerData()` | the framework's player data |
| `isLoaded()` | is the character loaded |
| `getIdentifier()` | citizenid / identifier |
| `getJob()` / `getJobGrade()` | job name / grade number |
| `getVar(name)` | `'citizenid'`, `'name'`, `'dob'`, `'gender'`, `'phone'` |

Events you can listen to (client):

| Event | When |
|---|---|
| `worm_lib:client:playerLoaded` | the character finished loading |
| `worm_lib:client:playerUnloaded` | the character logged out |
| `worm_lib:client:newJob` | the job changed, gets the framework's job table |

---

### Inventory (server)

Works the same on ox_inventory, qb-inventory, qs-inventory, codem-inventory and tgiann-inventory.
Every item you get back looks like this, whatever the inventory:

```lua
{ name = 'water', count = 3, slot = 5, metadata = {}, label = 'Water', weight = 500 }
```

| Export | Returns |
|---|---|
| `getInventoryName()` | `'ox'`, `'qb'`, `'qs'`, `'codem'`, `'tgiann'` |
| `AddItem(src, item, amount, metadata?)` | `true` / `false` |
| `RemoveItem(src, item, amount, slot?, metadata?)` | `true` / `false` |
| `GetItems(src)` | list of items |
| `GetItemCount(src, item)` | number |
| `hasItem(src, item, amount?)` | `true` / `false` |
| `CanCarryItem(src, item, amount)` | `true` / `false` |
| `FindItem(src, item, metadata?)` | first matching item, or `nil` |
| `GetItemBySlot(src, slot)` | item, or `nil` |
| `SetMetadata(src, slot, metadata)` | `true` / `false` |
| `RegisterUsableItem(item, cb)` | runs `cb(src, item)` when the item is used |
| `RegisterStash(id, label, slots, weight, owner?)` | creates the stash |
| `OpenStash(src, id, data?)` | opens it for the player |
| `GetStashItems(id)` / `GetStashItemCount(id, item)` | list / number |
| `AddStashItem(id, item, amount, metadata?)` / `RemoveStashItem(id, item, amount, metadata?)` | `true` / `false` |
| `GetItemList()` | the inventory's item registry |
| `GetItemLabel(item)` | label (falls back to the name) |
| `GetItemImage(item)` | a `nui://` url to the item picture |

```lua
exports.worm_lib:RegisterUsableItem('bandage', function(src, item)
    if exports.worm_lib:RemoveItem(src, 'bandage', 1, item.slot) then
        TriggerClientEvent('myscript:heal', src)
    end
end)

exports.worm_lib:RegisterStash('police_evidence', 'Evidence', 50, 200000)
exports.worm_lib:OpenStash(src, 'police_evidence')
```

### Inventory (client)

| Export | Returns |
|---|---|
| `getInventoryName()` | same as server |
| `GetItemCount(item)` | number |
| `hasItem(item, amount?)` | `true` / `false` |
| `openStash(id, data?)` | opens a stash; `data = { label, slots, maxweight }` |

---

### Notify

```lua
-- client
exports.worm_lib:notify('Saved', 'success', 5000)

-- server
exports.worm_lib:notify(src, 'Saved', 'success', 5000)
```

`type`: `'inform'` (default), `'success'`, `'error'`, `'warning'`. Duration is in ms, default `5000`.
Which notify it uses comes from `notify` in the config.

### Dispatch

```lua
-- client: the alert is sent from the player's position
exports.worm_lib:dispatch({
    code = '10-31',
    title = 'Poaching',
    message = 'Shots fired in the forest',
    jobs = { 'police', 'ranger' },
    priority = 2,
    blip = { sprite = 141, colour = 1, scale = 1.0, time = 60, radius = 0 },
})

-- server: the alert is sent from that player's client
exports.worm_lib:dispatch(src, { title = 'Poaching', coords = vec3(-500.0, 5500.0, 80.0) })

-- server, no player behind it (a script-made call): coords are required, give the street / address too.
-- lb-tablet, redutzu-mdt, piotreq_gpt and kartik-mdt take it directly; the client-only systems are relayed through
-- `relay` (a server id) when it is online, else the first online player whose job is in `jobs`.
exports.worm_lib:dispatch(0, { code = '10-70', title = 'Structure Fire', message = 'Smoke showing', coords = vec3(-11.8, -1437.7, 30.1), street = '12 Forum Drive', jobs = { 'fire' }, relay = leaderSrc })
```

| Field | Default |
|---|---|
| `code` | `'10-31'` |
| `title` | `'Alert'` |
| `message` | same as `title` |
| `coords` | the player's position |
| `jobs` | `{ 'police' }` |
| `priority` | `2` (`1` = high) |
| `blip.sprite` / `colour` / `scale` / `time` (s) / `radius` | `478` / `1` / `1.0` / `60` / `0` |
| `sound` | `true` |

The client export returns `true` if a dispatch system got the alert. `getDispatchName()` (client and server) tells
you which one was found (`'none'` if there isn't one). Supported: ps-dispatch, cd_dispatch, qs-dispatch,
rcore_dispatch, linden_outlawalert, core_dispatch, origen_police, codem-dispatch, tk_dispatch, emergencydispatch,
lb-tablet, redutzu-mdt, piotreq_gpt, kartik-mdt — or `'custom'` with `Config.dispatchCustom` (client) / `Config.dispatchCustomServer`
(server alerts) for anything else. `street` in the data is used as the alert's location text when given.

### Progress

```lua
if exports.worm_lib:progress({
    duration = 5000,
    label = 'Skinning...',
    canCancel = true,
    disable = { move = true, car = true, combat = true },
    anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search' },
}) then
    -- finished
else
    -- cancelled
end
```

Takes the same table as `lib.progressBar`. Returns `true` when finished, `false` when cancelled.

### Task list (client)

A checklist in the top left of the screen. Players fold it with the task list key (default **M**).

```
TASK                      ◔
Pawnshop delivery        1/3
───────────────────────────
☑ Pick up the truck              done
☐ Open the truck doors   2/5     current step (lit band)
☐ Drive to the pawnshop          pending
───────────────────────────
Task list                [M]
```

```lua
exports.worm_lib:showTaskList({
    title = 'Pawnshop Delivery',
    tasks = {
        { id = 'truck', label = 'Pick up the truck' },
        { id = 'doors', label = 'Open the truck doors' },
        { id = 'drive', label = 'Drive to the pawnshop', description = 'Mind the speed limit' },
    },
})

exports.worm_lib:completeTask('truck')
exports.worm_lib:updateTask('drive', { value = '2/5' })
exports.worm_lib:hideTaskList()
```

**List options** (`showTaskList` / `updateTaskList`):

| Field | |
|---|---|
| `title` | required |
| `tasks` | list of tasks; a plain string is a label, its id becomes its position (`"1"`, `"2"`, ...) |
| `caption` | small line above the title; empty is "Task", `false` hides it |
| `color` | accent colour, six-digit hex |
| `key` | key badge in the footer; empty shows the bound key, `false` hides it |
| `footer` | footer text; empty is "Task list", `false` hides the row |
| `collapsed` | start folded (the current step stays visible) |
| `offset` | `{ x, y }` in 1080p pixels away from the default spot |
| `onKey` | function to run on the key instead of folding |

**Task fields:** `id`, `label`, `done`, `hidden` (kept but not drawn, for a step you reveal later),
`description` (dim second line), `value` (right-aligned text like `"2/5"`).

| Export | |
|---|---|
| `showTaskList(options)` | opens the list, or replaces the one on screen |
| `updateTaskList(options)` | changes fields of the open list |
| `hideTaskList()` | closes it |
| `addTask(id, task, index?)` | adds a task (or replaces the one with that id); `task` can be a label string |
| `updateTask(id, fields)` | changes a task, keeps its place |
| `setTaskDone(id, done?)` / `completeTask(id)` | marks it done |
| `removeTask(id)` / `hasTask(id)` | |
| `toggleTaskList(collapsed?)` | folds / unfolds; empty flips |
| `isTaskListOpen()` | `open, title` |
| `getTaskList()` | copy of what's on screen |
| `setTaskListVisible(bool)` / `isTaskListVisible()` | hide it for a moment (cutscene, menu) without losing it |

When your resource stops, its list closes by itself.

### Key hints (client)

A strip of key hints in the bottom right: `[G] STOP ENGINE  /  [L] VEHICLE LOCK  /  ...`

```lua
exports.worm_lib:addHint('cruise', { key = 'Y', label = 'Cruise Control', when = 'vehicle' })
-- short form: addHint(id, key, label, icon?, when?)
exports.worm_lib:addHint('lock', 'L', 'Vehicle Lock')

exports.worm_lib:removeHint('cruise')
```

| Field | |
|---|---|
| `key` | the key badge (`'E'`); with no key the icon stands in |
| `label` | text |
| `icon` | `'wasd'`, `'mouse'`, `'mouse-scroll'`, `'mouse-left'`, `'mouse-right'` or any FontAwesome name |
| `when` | `'vehicle'` (only while seated), `'foot'` (only on foot), empty = always |
| `priority` | lower comes first |

| Export | |
|---|---|
| `addHint(id, options)` | adds a hint, or replaces the one with that id |
| `updateHint(id, fields)` | changes a hint, keeps its place |
| `removeHint(id)` / `hasHint(id)` | |
| `clearHints(resource?)` | removes all hints, or only one resource's |
| `getHints()` | every hint by id |
| `setHintsVisible(bool)` / `isHintsVisible()` | hide the strip without losing the hints |

When your resource stops, its hints go with it.

### Outfit (client)

Work clothes for a job: the player's own look is snapshotted on the first call and put back exactly on restore.

```lua
exports.worm_lib:applyOutfit({
    components = { [11] = { 56, 0 }, [8] = { 15, 0 }, [4] = { 36, 0 }, [6] = { 34, 0 } },  -- [componentId] = { drawable, texture }
    props = { [0] = { -1, 0 } },                                                          -- [propId] = { drawable, texture }; -1 clears
})
exports.worm_lib:restoreOutfit()
```

| Export | |
|---|---|
| `applyOutfit(outfit)` | snapshots the ped once, then applies the components / props; `true` on success |
| `restoreOutfit()` | puts the snapshot back and asks the appearance resource (`Config.outfit.system`) to reload the rest of the skin; `false` when nothing was applied |
| `hasOutfit()` | is a work outfit on right now |

When the resource that applied the outfit stops, the outfit is restored.

---

## Interaction (client)

Our own "look at it and press E" system. A small **ring** shows on every interaction point nearby.
Move the dot in the middle of the screen onto a ring and it turns into an `[E] OPTION` prompt in the same
spot. Press the key to run it. More than one option: scroll with **↑ / ↓** or the **mouse wheel**.

```
   nearby, not focused            dot on the ring

        ◎                         [E] OPEN SHOP          ← in place of the ring
                                      SELL ITEMS         ← other options (dimmed)
            ·   ← screen centre            ·
```

It is **separate from target systems** (ox_target / qb-target). Options added with `exports.ox_target`
don't show here, and options added here don't show in the target.

### Option fields

Every add export takes `options`: one table, or a list of tables.

```lua
{
    name = 'open_shop',               -- unique; adding the same name again replaces it
    label = 'Open Shop',              -- text on screen
    icon = 'fa-solid fa-cart-shopping', -- only shown when ui.showIcons = true
    distance = 2.0,                   -- metres; default Config.interaction.defaultDistance (7.0)

    -- What happens. Only one runs, in this order:
    onSelect = function(data) end,    -- a function
    export = 'myExport',              -- exports[your resource]:myExport(data)
    event = 'client:event',           -- TriggerEvent(event, data)
    serverEvent = 'server:event',     -- TriggerServerEvent(event, data)  (entity is sent as a netId)
    command = 'mycommand',            -- ExecuteCommand(command)

    -- Who sees it
    canInteract = function(entity, distance, coords, name, bone) return true end,
    groups = 'police',                -- 'police' | { 'police', 'ems' } | { police = 2 } (min. grade)
    items = 'lockpick',               -- 'item' | { 'a', 'b' } | { a = 1, b = 2 }
    anyItem = false,                  -- with several items: one of them is enough

    -- Where the ring sits on an entity
    bones = 'boot',                   -- 'bone' | { 'bone1', 'bone2' }: one ring per bone
    boneFallback = false,             -- true: bones is a priority list, only the first found is used
    offset = vec3(0.5, 1.0, 0.5),     -- fraction of the model size (0-1), or metres with absoluteOffset
    absoluteOffset = false,
    bonesOptional = false,            -- true: no bone / offset found → ring at the entity centre
    getOffset = function(entity, model) return vec3(0.0, -3.0, 1.0) end, -- metres in the entity frame, computed per model; wins over bones/offset, nil falls through to them

    -- Sub menus
    menuName = 'doors',               -- only shown while the 'doors' menu is open
    openMenu = 'doors',               -- selecting it opens 'doors' ('home' goes back)
}
```

- `canInteract` runs on every scan. Return `false` (or throw) and the option is hidden.
- A point with no visible options shows no ring.

### Zones

Made with `lib.zones`; the ring is at the zone's `coords`. Inside the zone counts as distance 0.

```lua
local id = exports.worm_lib:addInteractionBoxZone({
    coords = vec3(441.2, -981.6, 30.7),
    size = vec3(1.5, 1.5, 1.2),
    rotation = 90.0,
    options = {
        { name = 'duty', label = 'Go On / Off Duty', groups = 'police', distance = 2.0,
          onSelect = function() TriggerServerEvent('police:toggleDuty') end },
    },
})

exports.worm_lib:addInteractionSphereZone({
    coords = vec3(195.1, -933.8, 30.7),
    radius = 1.0,
    options = { { name = 'atm', label = 'Use ATM', event = 'banking:openAtm', distance = 1.5 } },
})

exports.worm_lib:addInteractionPolyZone({
    points = { vec3(100, 100, 30), vec3(110, 100, 30), vec3(110, 110, 30), vec3(100, 110, 30) },
    thickness = 4.0,
    options = { { name = 'area', label = 'Use Area', onSelect = function() end } },
})
```

The fields are the same as `lib.zones.box / sphere / poly`, plus `options`.

| Export | |
|---|---|
| `addInteractionBoxZone(data)` / `addInteractionSphereZone(data)` / `addInteractionPolyZone(data)` | returns the zone id |
| `removeInteractionZone(id or name, suppressWarning?)` | |
| `interactionZoneExists(id or name)` | `true` / `false` |

### Coordinates

A plain point, no zone needed. The ring is exactly at the coordinate.

```lua
local id = exports.worm_lib:addInteractionCoords(vec3(25.7, -1347.3, 29.5), {
    { name = 'shop', label = 'Shop', distance = 2.0, event = 'shop:open' },
})

exports.worm_lib:removeInteractionCoords(id)
```

`coords` can be `vec3`, `vec4`, `{ x =, y =, z = }` or `{ x, y, z }`.

### Global (every entity of a type)

| Add | Remove | Applies to |
|---|---|---|
| `addInteractionGlobalPed(options)` | `removeInteractionGlobalPed(names)` | non-player peds |
| `addInteractionGlobalPlayer(options)` | `removeInteractionGlobalPlayer(names)` | other players |
| `addInteractionGlobalVehicle(options)` | `removeInteractionGlobalVehicle(names)` | vehicles |
| `addInteractionGlobalObject(options)` | `removeInteractionGlobalObject(names)` | objects |
| `addInteractionGlobalOption(options)` | `removeInteractionGlobalOption(names)` | every focused point |

`names` is `'name'` or `{ 'name1', 'name2' }`. You can only remove options your own resource added.

```lua
exports.worm_lib:addInteractionGlobalVehicle({
    name = 'repair',
    label = 'Repair Vehicle',
    bones = 'bonnet',
    distance = 2.0,
    items = 'repairkit',
    onSelect = function(data) TriggerEvent('mechanic:repair', data.entity) end,
})

exports.worm_lib:addInteractionGlobalPlayer({
    name = 'search',
    label = 'Search',
    groups = { police = 0 },
    distance = 1.5,
    serverEvent = 'police:search',   -- data.entity arrives as a netId
})

exports.worm_lib:removeInteractionGlobalVehicle('repair')
```

### Model

```lua
exports.worm_lib:addInteractionModel({ 'prop_atm_01', 'prop_atm_02', `prop_atm_03` }, {
    name = 'atm',
    label = 'ATM',
    distance = 1.5,
    event = 'banking:openAtm',
})

exports.worm_lib:removeInteractionModel('prop_atm_01')          -- every option on the model
exports.worm_lib:removeInteractionModel('prop_atm_01', 'atm')   -- only 'atm'
```

### Entity (networked, by netId)

Cleaned up on every client when the entity is deleted.

```lua
local netId = NetworkGetNetworkIdFromEntity(vehicle)

exports.worm_lib:addInteractionEntity(netId, {
    name = 'deliver',
    label = 'Deliver',
    distance = 3.0,
    onSelect = function(data) print(data.entity) end,
})

exports.worm_lib:removeInteractionEntity(netId)
exports.worm_lib:removeInteractionEntity({ netId1, netId2 }, 'deliver')
```

### Local entity (by handle)

For entities that only exist on this client (e.g. a ped made with `CreatePed(..., false, false)`).

```lua
exports.worm_lib:addInteractionLocalEntity(ped, {
    { name = 'talk', label = 'Talk', distance = 2.0, onSelect = function(data) TriggerEvent('npc:talk', data.entity) end },
    { name = 'sell', label = 'Sell Items', items = { 'phone', 'watch' }, anyItem = true, event = 'pawn:open' },
})

exports.worm_lib:removeInteractionLocalEntity(ped)
exports.worm_lib:removeInteractionLocalEntity(ped, 'sell')
```

Entities that no longer exist are cleaned up every 60 seconds.

### State

| Export | |
|---|---|
| `disableInteraction(bool)` | turns the whole system off / on (rings hidden, key does nothing); use it during menus, cameras, ... |
| `isInteractionDisabled()` | `true` / `false` |
| `isInteractionActive()` | is a ring focused right now |
| `getInteractionFocused()` | `{ entity, netId, zone, coords, distance, bone, boneName, options, selected }` or `nil` |
| `getInteractionOptions(entity?, type?, model?)` | which option lists (`global`, `model`, `entity`, `localEntity`) the entity falls into |

### Bones and offset

With `bones` the ring sits on that bone instead of the entity centre. Several bones = one ring per bone.

| Vehicle bone | Where |
|---|---|
| `handle_dside_f`, `handle_pside_f`, `handle_dside_r`, `handle_pside_r` | door handles |
| `door_dside_f`, `door_pside_f`, `door_dside_r`, `door_pside_r` | door hinges |
| `platelight` | rear plate |
| `boot` | trunk lid |
| `bonnet` | hood |
| `wheel_lf`, `wheel_rf`, `wheel_lr`, `wheel_rr` | wheels |
| `engine`, `exhaust`, `seat_dside_f`, `seat_pside_f` | engine, exhaust, seats |

```lua
{ name = 'top',  label = 'Climb Up', offset = vec3(0.5, 0.5, 1.0) }                    -- middle, top of the model
{ name = 'side', label = 'Side',     offset = vec3(1.2, 0.0, 0.0), absoluteOffset = true } -- 1.2 m to the right

-- handle if there is one, otherwise the door
{ name = 'door', label = 'Open Door', bones = { 'handle_dside_f', 'door_dside_f' }, boneFallback = true }

-- plate if there is one, otherwise the back middle
{ name = 'trunk', label = 'Trunk', bones = 'platelight', offset = vec3(0.5, 0, 0.5) }
```

Options from different resources that land on the **same bone** (or the same offset) of an entity share
one ring. The player scrolls between them.

Distance is measured to the closest surface: to the bone / offset point, to the model's bounding box,
or to the zone's edge. So `distance = 1.5` works while standing at the back of a long car.

### Sub menus

```lua
exports.worm_lib:addInteractionGlobalVehicle({
    { name = 'doors', label = 'Doors', openMenu = 'doors' },
    { name = 'd1', label = 'Driver Door',    menuName = 'doors', onSelect = function(d) SetVehicleDoorOpen(d.entity, 0, false, false) end },
    { name = 'd2', label = 'Passenger Door', menuName = 'doors', onSelect = function(d) SetVehicleDoorOpen(d.entity, 1, false, false) end },
})
```

A **Back** option is added to the top of a sub menu by itself. Options with no `menuName` are in the main
menu. Moving to another ring resets the menu.

### What your callback gets

`onSelect`, `export`, `event` and `serverEvent` all get the same table:

```lua
{
    -- the option's own fields (name, label, distance, resource, ...)
    entity = 123,         -- entity handle; netId in serverEvent (0 if not networked)
    zone = 3,             -- zone id, for zones
    coords = vec3(...),   -- where the ring is
    distance = 1.8,       -- from the player
    bone = 57,            -- if any
    boneName = 'boot',    -- if any
}
```

```lua
-- server side of a serverEvent
RegisterNetEvent('police:search', function(data)
    local target = NetworkGetEntityFromNetworkId(data.entity)
end)
```

### Interaction settings

`shared/config.lua` → `Config.interaction`

| Setting | Default | |
|---|---|---|
| `enabled` | `true` | turn the whole module off |
| `keybind.defaultKey` | `'E'` | players can rebind it |
| `defaultDistance` | `7.0` | when an option has no `distance` |
| `focusRadius` | `0.08` | how close the dot must get to a ring (fraction of screen height) |
| `maxIndicators` | `8` | max rings at once (the closest ones) |
| `scanInterval` / `idleScanInterval` | `200` / `500` | scan speed in ms (near something / nothing near) |
| `losCheck` | `true` | hide peds and vehicles behind walls |
| `ignoreCurrentVehicle` | `true` | hide the options of the car you're sitting in |
| `hideOnProgress` | `true` | hide during a progress bar |
| `centerDot` | `true` | the dot in the middle of the screen |
| `ui.showIcons` | `false` | show option icons |
| `ui.accent` | `'#ffffff'` | key box colour |
| `ui.scale` | `1.0` | size of everything |
| `locale.goBack` | `'Back'` | text of the Back option |

---

## Something's wrong?

**"No such export" errors that mention `worm_lib`**
→ Check the order in `server.cfg` (Step 2). `worm_lib` must be above every script that uses it.
→ Is the folder called exactly `worm_lib`?

**`No framework found` / `No inventory found` in the console.**
→ worm_lib started before them. Move `ensure worm_lib` below your framework and your inventory.
→ Your inventory has a different folder name? Set `inventory.system` in `shared/config.lua` by hand.

**Item pictures are broken.**
→ Set the right folder in `inventory.imagePath` in `shared/config.lua`.

**No dispatch alerts.**
→ Set `debug = true` and look at the F8 console. `dispatch (no system)` means none was found: set
`dispatch` to yours, or use `'custom'`.

**No ring shows up.**
→ Are you within the option's `distance`? Does `canInteract` return `false` or throw (F8 console)?
Do `groups` / `items` match? Is the entity behind a wall (`losCheck`)?
→ Everything is hidden while another NUI has focus, in the pause menu or during a progress bar.

**The ring shows but no `[E]` text.**
→ Look for a `worm_lib` error in the F8 console. If you changed resolution in game, restart the resource.

**Options vanished after `restart worm_lib`.**
→ A stopped resource takes its options with it. Restart the scripts that use worm_lib too.
In your own script you can add them back by yourself:

```lua
AddEventHandler('onClientResourceStart', function(resource)
    if resource == 'worm_lib' then registerInteractions() end
end)
```

Use `exports['worm_lib']` there: Lua caches export functions and can keep calling the old, stopped one.

Still stuck? Open a ticket in our Discord with your **server console log** and your **F8 console log**.