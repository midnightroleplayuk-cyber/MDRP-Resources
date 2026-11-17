# worm_pawnshop

Shipment broker job: pick up orders on an in-world computer, fill them from your pawn storage, carry the
sealed box to a waiting truck and get paid. Black market orders pay more, clean some of your dirty money,
and may bring the police.

This guide takes you from "I just bought it" to "it works in game". Do the steps in order and don't skip any.

---

## What you got

Your download has **2 folders**. You need both:

| Folder | What it is |
|---|---|
| `worm_lib` | Our library. It talks to your framework and your inventory, and draws the interaction prompts and the task list. |
| `worm_pawnshop` | The pawnshop job itself. |

## What your server needs

- **ox_lib**: download it from https://github.com/overextended/ox_lib/releases (the `ox_lib.zip` file, not the source code).
- **oxmysql**
- **One framework**: QBox, QBCore or ESX.
- **One inventory**: ox_inventory, qb-inventory, qs-inventory, codem-inventory or tgiann-inventory.

You don't need to set anything up for the framework or the inventory. worm_lib finds them by itself.
You don't need ox_target or qb-target either: the computer, the storage and the truck use worm_lib's own
"look at it and press **E**" prompt.

---

## Step 1: Put the folders in

Copy both folders into your `resources` folder.

⚠️ **Do not rename `worm_pawnshop`.** The folder must be called exactly `worm_pawnshop`, or it won't start.

## Step 2: Add them to server.cfg

Open `server.cfg` and add these lines **after** your framework and your inventory:

```cfg
ensure ox_lib
ensure oxmysql
# ... your framework (qbx_core / qb-core / es_extended) ...
# ... your inventory ...

ensure worm_lib
ensure worm_pawnshop
```

The order matters: `worm_lib` must start **before** `worm_pawnshop`.

## Step 3: Database

Nothing to do. The tables are created by themselves the first time the script starts.

(If you'd rather do it by hand, run `install.sql` and set `autoSql = false` in `config/server.lua`.)

## Step 4: Add the item

The script uses one item of its own: the **shipment box** the player carries to the truck. Your inventory has
to know it. Find **your inventory** below and follow **only that part**.

### If you use ox_inventory (QBox, or QBCore/ESX with ox)

Open `ox_inventory/data/items.lua` and paste this inside the big list (before the last `}`):

```lua
['pawn_shipment_box'] = {
   label = 'Shipment Box',
   weight = 5000,
   stack = false,
   close = true,
   consume = 0,
   description = 'A sealed shipment box. Deliver it to the truck.',
},
```

⚠️ Keep `consume = 0`. The script takes the box by itself when it goes into the truck.

### If you use qb-inventory, qs-inventory, codem-inventory or tgiann-inventory

These four use the same item format. Only the file you paste into is different:

| Inventory | Paste the item into | Pictures go into |
|---|---|---|
| qb-inventory | `qb-core/shared/items.lua` | `qb-inventory/html/images/` |
| qs-inventory | `qs-inventory/shared/items.lua` | `qs-inventory/html/images/` |
| codem-inventory | its item list (`codem-inventory/config/itemlist.lua`) | `codem-inventory/html/itemimages/` |
| tgiann-inventory | its item list (`tgiann-inventory/items/items.lua`) | the folder its other item pictures are in |

If your version of the inventory keeps items somewhere else, use whatever file its other items are in.

```lua
pawn_shipment_box = { name = 'pawn_shipment_box', label = 'Shipment Box', weight = 5000, type = 'item', image = 'pawn_shipment_box.png', unique = true, useable = true, shouldClose = true, description = 'A sealed shipment box. Deliver it to the truck.' },
```

**Picture:** put a box picture called `pawn_shipment_box.png` into your inventory's picture folder.

### The items the orders ask for

Orders ask for normal items that players already find on your server (`scrapmetal`, `copper`, `plastic`,
`phone`, `radio`, `lockpick`, `goldchain`, `rolex`, `diamond_ring`). Every one of them must exist in your
inventory. If one doesn't, swap it for one of yours in `config/shared.lua` → `orderTypes` → `pools`.

## Step 5: Dirty money

Black market orders let the player talk to the truck driver, who cleans part of the dirty money they carry.
Tell the script where your server keeps dirty money: open `config/shared.lua`, find `dirtyMoney` and set
`spec` to the line that matches your server:

| Your server | `spec` |
|---|---|
| ox_inventory `black_money` item | `{ mode = 'item', item = 'black_money' }` |
| QBCore `markedbills` (value in `info.worth`) | `{ mode = 'item_worth', item = 'markedbills', field = 'worth' }` |
| ESX `black_money` account | `{ mode = 'account', account = 'black_money' }` |

Don't want it? Set `enabled = false` in the same block.

---

## Step 6: Give yourself admin

The in-game setup tool is admin-only. Add this to `server.cfg` (or your `permissions.cfg`):

```cfg
add_ace group.admin worm_pawnshop.dev allow
```

Players in the framework groups `admin` or `god` can use it too.

## Step 7: Start the server and set up the shop

1. Start the server. Watch the console: no red errors from `worm_lib` or `worm_pawnshop` means you're good.
2. Join the server and go to the default spot in **Rancho**, south Los Santos (around `433, -1904`).
3. Everything already has a default place. If something looks off, type **`/pawndev`** and fix it in the menu.
   Do it in this order:
   1. **Computers**: *Add at my position* (spawns a monitor) or *Pick the object I am looking at* (uses a
      monitor that is already on the map). Then open it and use *Adjust the screen panel* to line the screen
      up, and *Preview* to check it.
   2. **Storage points**: where players open their own pawn storage.
   3. **Box pickup points**: where the shipment box shows up once a shipment starts.
   4. **Delivery spots**: where the truck waits. Sit in a vehicle facing the way the truck should drive off,
      then *Add here*.
   5. **Truck offsets**: where the player stands at the back of the truck and where the box sits in the cargo.
4. Everything you place is saved by itself in `worm_pawnshop/data/`. You don't have to restart.

Done. Put a few items in your storage, walk up to the computer and accept an order. 📦

---

## How a run goes

1. The player puts items into their **pawn storage** (one per character).
2. At the **computer** they accept an order (the fee is charged), press **Prepare**, wait for it to be
   prepared and loaded, then press **Start shipment**. The items are taken out of the storage.
3. The **shipment box** shows up at a pickup point. They pick it up and carry it in their hands (no running,
   no vehicles).
4. The **truck** waits at a delivery spot. At its back: open the doors, put the box in, close the doors.
   The task list in the top left shows each step.
5. They get paid, the truck drives off. On black market orders they can talk to the driver first to clean
   dirty money, and the police may get a call.

Orders expire 30 minutes after they're accepted. One active order per player.

---

## Things you may want to change

All settings are in `worm_pawnshop/config/`. Every line has a comment that tells you what it does.

| I want to... | Open | Look for |
|---|---|---|
| Change what orders ask for and pay | `config/shared.lua` | `orderTypes` (add as many types as you like) |
| Change the order timers | `config/shared.lua` | `orders` (`deadlineMinutes`, `prepare`, `cycleMinutes`, ...) |
| Pay from / to cash instead of bank | `config/shared.lua` | `accounts` |
| Lock the computer to a job | `config/shared.lua` | `computerDefaults.jobs`, e.g. `{ 'pawnshop' }` |
| Change the police call on black market orders | `config/shared.lua` | `orderTypes` → `black` → `dispatch` |
| Use a different truck or drivers | `config/shared.lua` | `delivery.vehicle` |
| Block a player from the computer, or run your own code on a delivery | `config/server.lua` | `hooks` |
| Only let one player use a computer at a time | `config/server.lua` | `lockComputers = true` |
| Turn the task list off | `config/client.lua` | `taskList.enabled = false` |
| Change the language | `config/shared.lua` | `locale` (`en` and `tr` ship with the script) |

The interaction key (**E**) and the task list key (**M**) belong to worm_lib. Players can rebind them in
**Settings > Key Bindings > FiveM**.

---

## Something's wrong?

**"No such export" errors that mention `worm_lib`**
→ Check the order in `server.cfg` (Step 2). `ox_lib` and `worm_lib` must be above `worm_pawnshop`.

**The script doesn't start at all.**
→ Is the folder called exactly `worm_pawnshop`? Is `ox_lib` started?

**No `[E]` prompt on the computer, the storage or the truck.**
→ Is `worm_lib` started? Look for a `worm_lib` error in the F8 console.
→ After `restart worm_lib`, the prompts come back by themselves within a second.

**The computer stays on the lock screen.**
→ Look in the F8 console for errors that mention `https://worm_pawnshop/app`. Is the folder name right?

**The screen is in the wrong place on the monitor.**
→ `/pawndev` → **Computers** → your computer → *Adjust the screen panel*.

**The shipment box shows up without a name or picture.**
→ You skipped Step 4. Re-check the item and the picture, then restart the server.

**An order shows an item with no name or picture.**
→ That item doesn't exist in your inventory. Add it, or swap it in `orderTypes` → `pools` (Step 4).

**Talking to the driver does nothing.**
→ The `dirtyMoney.spec` doesn't match your server (Step 5), or the player has no dirty money on them.
→ With `onlyIllegal = true` it only works on black market orders.

**No police call on black market orders.**
→ It's a chance roll (`dispatch.chance`). If it never comes, check worm_lib's `dispatch` setting.

Still stuck? Open a ticket in our Discord with your **server console log** and your **F8 console log**.
