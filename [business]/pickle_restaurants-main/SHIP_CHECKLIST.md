# pickle_restaurants — Pre-Ship Review Checklist

A hands-on walkthrough for reviewing the resource before shipping `1.0.0`. There is no
`config.lua` — everything is configured in-game. Run through this on a **clean database**.

Each item is a mini test: **do the thing → confirm the expected result.** ⚙ = a
"TUNE IN-GAME" value you should calibrate for your map/models before ship.

---

## ✅ Already resolved & verified (no action needed)

These were fixed or confirmed in code this pass — listed so you don't re-check them:

- **Demo hack removed.** The `DEMO_KEEP_PREP` "REVERT ME" flag in cooking is gone; leaving a
  prep station now always saves/closes normally (this was the top ship-blocker).
- **Legacy migration layer removed** — the entire pre-"unified menu" pipeline, the legacy
  `pickle_restaurant_recipes` SQL table + its `ALTER` guards, ~22 one-time `*_seeded`
  backfills, and the itemgen grace-retain list. The last shims went with the 1.0 sweep too:
  the aggregated-`count` meta format, the pre-collapse no-`tool` finish fallback (with
  `metaFlavor`), and the `TEMP_NPC_CONTEXT/` porting scratch. Live-table columns were folded into their
  `CREATE`s (`restaurants.groups`, `menu.variant`, orders `refunded`/`paid_account`/
  `redeemed`, standalone `accounts.bank`) — verified in code.
- **Cooking numeric-cheese decode removed** — `LegacyCheeseItem`, `legacy_cheese_item`,
  `LEGACY_FINISH_OUTPUTS`, the decode shims, and dead `cheeseModel` refs. Toppings resolve
  via `top` metadata + `sig`. *(This one still needs the in-game re-tests in §C6 — a fresh
  boot can't exercise it.)*
- **`dealerships_` context-menu ids renamed** to `restaurants_` in `core/client.lua`.
- **XP integration dropped** — `bridge/xp` deleted (it was never called; the phone's
  achievements/leveling covers progression).
- **All debug/tuning console commands removed** — every `/pickle_*` and `/virtual_*` debug/
  calibration command AND all of their scaffolding: the `debugForce`/`debugProps` preview
  rigs (rendertarget + screens), the `virtual` vlog/vpos tracing and `VirtualDebugOn`, the
  `stackdbg` layout dump, and both halves of the `DeliveryDebug` relay tracing. Nothing
  inert is left behind. Bake any tuning into the config tables.
- **NPC facial reactions wired** — a served customer walks off with a happy face, an impatient
  one with an angry face (`SetFacialIdleAnimOverride`).
- **itemgen replaced by static `__INSTALL/` files** — the module + its command
  are gone; `__INSTALL/items/{ox_inventory.lua, esx_items.sql, qbcore_items.lua}` define
  the exact item set: handout items (bag/meal/drink/receipt) + every raw input the kitchen
  consumes. Cooked/assembled foods are intentionally NOT items (they stay tray/pool
  intermediates, packaged into a container before sale).
- **`cheese` column fully removed.** The tray DB column, its unique-key dimension, the
  `TrayCache`/reservation/`item|cheese|sig` keys, `CheeseVal`, `trayKey`, and every `cheese`
  param/field across core + cooking (server & client) + sales + the NUI (`Cooking.tsx`,
  rebuilt) are gone. Melting cheese still works — it's config-driven off the ingredient's
  `melts` and rides each build layer's `top` metadata, nothing hardcoded. **Re-test via §C6.**
- **All server/core Lua compiles** (`luac5.4 -p`); the NUI **rebuilds clean** (`npm run build`).

---

## 🧭 Decisions / remaining work

- [ ] **NPC `happy` reaction** — now shows a happy vs angry face; confirm the expressions read
  well in-game (⚙ the mood clips `mood_happy_1` / `mood_angry_1` are swappable).

---

## A. Install & boot

- [x] Start the server against an **empty database**. Expect: boots with no errors; console
  prints `Booted: N restaurants, N props, N recipes.` On a clean DB that's `0, 0, N`.
- [x] Install the items from the **`install/`** folder for your inventory (`ox_inventory.lua`
  / `esx_items.sql` / `qbcore_items.lua`). Confirm the handout items (bag / meal / drink /
  receipt) and raw inputs (buns, patties, cups, mix, sauces…) exist; cooked foods
  (burger, fries, cooked patty…) are deliberately **not** installed — they stay tray-only.
- [x] Confirm the resource boots on your **framework** (ESX / QBCore / standalone) — only the
  matching bridge should load; no bridge errors in console.

## B. Admin setup (`/restaurants`)

- [ ] As an admin, open `/restaurants`. **Create a restaurant**, set yourself as owner, give
  it a name → confirm a codename slug is derived and it appears in the list.
- [ ] **Place props**: from the panel, place a grill (stovetop), a fryer, a soda fountain, a
  kitchen-prep table, a counter, and one screen (menu or orders). Each closes the panel →
  gizmo preview → `E` to place, then reopens the panel. ⚙ nudge positions to your map.
- [ ] Place a **seat** (invisible anchor, ghost-ped preview) and a **virtual point** (station
  anchor inside a kitchen shell) if you use them.
- [ ] **Menu editor** (foods/tools/ingredients is the only authoring surface): create a new
  interactive food with steps, a bag food, a tool, and an ingredient. Everything **auto-saves**
  (no save buttons) and shows a confirmation toast. Reload the panel → your edits persisted.
- [ ] **Brand/theme**: set a brand image + crop, change the theme (primary colour / dark|paper
  / radius) → the panel restyles live; the crop UI numbers match what lands on the prop.
- [ ] "**Reset menu to defaults**" restores the shipped foods/tools/ingredients.

## C. Cooking stations

### C1. Grill (stovetop) — patties + cheese ⚙ camera framing
- [ ] Walk to the grill, interact → scripted camera leans in, ped hides.
- [ ] Drag a **raw patty** onto the grill. It cooks `raw → cooked → burnt` on the timer;
  only the down (grill) side's timer runs.
- [ ] **Click the patty to flip** — it flips as one rigid body, banked time carries over.
- [ ] Drag a **cheese slice** onto the cooked-up face → it seats, then melts (applied →
  melted) after its timer. It only applies once that face is cooked.

### C2. Oven (stovetop doors) ⚙
- [ ] Click an oven **door** → it swings open (tweened, server-synced). Cooking pauses while open.
- [ ] Seat a bake/pizza in a slot → it cooks inside; a batch bake (cookie tray) lays out as a
  grid on its tray.

### C3. Fryer ⚙
- [ ] Drag fries/nuggets/a doughnut into a basket. Click to **lower** (starts frying) / **raise**
  (pauses). Collect cooked → you get the batch yield (e.g. a serving of fries).

### C4. Soda fountain ⚙ tap geometry / ice / pour offsets
- [ ] Place a cup under a tap — it **locks to the nearest free tap** (doesn't trail the cursor).
- [ ] Click a **drink tap** → colored stream pours, cup fills (empty → filling → filled), tinted
  by the drink's colour. Click the **middle nozzle** → ice cubes free-fall into the rim.
- [ ] Drag the **lid** onto a filled cup → caps it; it collects as the single drink item with
  the flavor as metadata (check the inventory slot).

### C5. Kitchen prep — building ⚙ stack tweaks / box hinge / condiments
- [ ] Drag components onto the table; they **stack** under the cursor. Grab a part → it lifts
  everything above it.
- [ ] Drag a pile together into a recipe → "**Make**" produces the product (correct one ranked
  first).
- [ ] **Serving tray**: drop it, arrange piles on the paper, "Make Meal" → one meal; leaving the
  station auto-makes trays.
- [ ] **Pizza box**: drop it, click the lid to swing open/closed, drop a pizza in (a non-pizza
  outlines red and is refused), "Box It Up" closes then makes a boxed meal; "Take Out" removes it.
- [ ] **Restaurant bag**: drop craft components, "Bag It Up" → one bag item labelled as the craft.
- [ ] **Baking**: rub the baking-mix over a cake tin / cookie tray (coverage fills the sheet /
  6 dough balls), drag the filled tray to the hotbar to collect the oven-ready input.
- [ ] **Finish tool** (frosting): pick a flavor on the card, rub it over a cooked cake/doughnut →
  the flavored result fades in at full coverage.
- [ ] **Condiment** (ketchup): drag the bottle over a stack → it flips, squeezes once, adds a
  sauce layer. Confirm it **can't** be the bottom layer.

### C6. 🚩 Cheese/variation re-tests (must pass — a fresh boot can't exercise these)
These validate the full `cheese`-column removal (tray key, reservations, inventory slots, NUI)
and that config-driven cheese melt still round-trips. If any fails, the refactor regressed:
- [ ] **Cheese survives the sale.** Grill-cheese a patty (let it melt), build it into a burger
  at prep, sell it at the register, and take the food — the sold item still has cheese.
- [ ] **Variations stay distinct.** Make a plain burger and a cheeseburger (and a plain vs a
  pepperoni pizza). In the tray they're **separate entries**; selling one consumes the *right*
  instance, not whichever is on top.
- [ ] **Variations survive inventory.** Move a topped/varied item to your inventory and back —
  the topping/variation is intact (ox_inventory / qb; bare ESX falls back to the base recipe).
- [ ] **Finishes still classify.** A plain `cooked_doughnut` is **not** treated as frosted; a
  frosted one **is** terminal (can't be decomposed). Frosting/sprinkles render correctly.
- [ ] **Decompose intact.** Drag a topped product / meal back onto the prep table → it un-makes
  into an editable build with its topping + layout preserved.

### C7. Tray & expiration
- [ ] Cooked & uncooked tabs group items by variation. Burnt items sort to the back.
- [ ] A cooked item **counts down** and turns red in its last minute, then auto-clears at 0
  (per-recipe `expire_seconds`, else the global default). Collect-to-inventory and the two-click
  bin both work.

## D. Selling

- [ ] **Register (physical counter)** — interact → in-world POS DUI, camera + virtual cursor.
  Ring up an order (pick a customer, add items/modifiers/combos), take payment → customer is
  charged **cash**, gets a receipt, ticket appears; commission is paid. ⚙ cam/sensitivity.
- [ ] **Virtual register anchor** — opens the **fullscreen NUI** register instead.
- [ ] **Complete / cancel** a ticket → completing hands the food (with its variation); cancelling
  refunds via the single path (no double-refund on repeat clicks).
- [ ] **Kiosk** — interact → in-world order DUI; the customer pays their **own** order (no
  commission). ⚙ cam/sensitivity.
- [ ] **NPC customers** — with a restaurant open and staff clocked in, NPCs walk up and place
  real tickets off the priced menu; serve them (they pay on serve, may tip). Impatient ones leave.

## E. Management panel (boss/owner)

- [ ] **Assign the restaurant a JOB first** (admin panel → the restaurant → Job). Until one is
  assigned nobody but an admin or the owner can work there — that is deliberate, and the panel
  says so. Confirm the job's real grade ladder (labels included) appears whatever framework
  you run; on a frameworkless server author the ladder in Settings → Jobs instead.
- [ ] Open the boss panel; each tab is permission-gated. **Hire** a nearby player onto the job at
  a grade, **promote** them, **fire** them — then check the framework's own job UI agrees (there
  is no separate employee list any more).
- [ ] **Ranks** tab (boss only): set each grade's permissions, commission % and salary. A
  non-boss grade must NOT be able to open it, and only a boss may hire/promote to a boss grade.
- [ ] **Payroll** tab: tips accrue to the pool (serve an NPC that tips) and are paid to STAFF,
  never to the balance — pay the pool out and confirm each recipient is paid and the pool zeroes.
  **Run payroll** pays each rank's salary from the balance, and refuses the whole run (paying
  nobody) when the balance can't cover it. Payslip history lists both kinds.
- [ ] Set `payroll_interval_minutes` > 0 → salaries run on that cadence with no console noise.
- [ ] **Price list**: set/remove prices (incl. a per-flavor drink price) → boards update.
- [ ] **Supplies**: buy stock from balance; deposit/withdraw between pocket and pool.
- [ ] **Finances**: deposit/withdraw cash ↔ balance; ledger shows the entries.
- [ ] **Combos**: create a numbered combo (slots × options), price it → it appears on the board
  and sells, fulfilled from its component items.
- [ ] **Rename** is owner-only (a manager can't).

## F. Phone app ("Pickle Eats")

- [ ] Open the app on your phone bridge (lb-phone / gksphone / qs-smartphone / qb-phone). With
  no phone installed, nothing errors — the app just doesn't appear.
- [ ] If it never appears, run **`pickle_phoneapp`** in the server console: it prints which
  phone resources are installed plus the app id / page URL / icon to add by hand. Only
  lb-phone and gksphone publish a stable custom-app API; on Quasar and qb-phone the bridge
  probes for one and falls back to that manual route (stock qb-phone has no iframe app host
  at all — its notifications and phone number still work).
- [ ] Browse a storefront, **place a delivery order** → charged to **bank**, appears in the
  kitchen (KDS) queue; apply a promo / loyalty redemption if configured.
- [ ] Favorite & reorder; leave a review (1–5, order-gated); earn a loyalty punch.
- [ ] Staff: **clock in/out**; owner: check the analytics tab; create a promotion (broadcasts live).
- [ ] **Reserve a table** → the booking HOLDS that many real seat anchors for one timeslot
  (no instance, no teleport). Sit on one as the holder; walk another player up to it and
  confirm they're refused and offered "Ask to sit here"; accept the request from the holder's
  side and confirm the guest can now sit. Cancel the booking → the seats free up.
- [ ] Book a second table at a **different time** while one is live → refused. Book more seats
  in the **same** slot → the existing reservation grows instead.
- [ ] Leave a "now" booking past `reservation_hold_minutes` → the sweep expires it and the
  seats stop reading "Reserved".

## G. Delivery

- [ ] A driver claims a delivery order → gets a waypoint; the customer can track it live (GPS
  ping is rate-limited and only from the assigned driver). Delivering hands the food.
- [ ] Customer ⇄ driver **chat** works both ways.
- [ ] Disconnect the driver mid-run → the claim releases and the order can be re-claimed.

## H. Screens, branding & DUIs

- [ ] **Menu board** pages through the priced menu + combos; **orders board** shows live
  PREPARING/READY tickets newest-first. ⚙ tune each board's aspect/orientation in the
  `SCREENS` table (`modules/screens/client.lua`) so content lands upright on your prop.
- [ ] **Packaging brands** (cup/box/tray/kiosk) paint the nearest branded restaurant's image;
  ⚙ tune each texture's resolution/orientation in `Config.RenderTargets` (`core/shared.lua`).
  Screens read as albedo (only as bright as the room) — a dim screen is an
  **emissive-shader/asset** fix, not a code one.

## I. Seating

- [ ] Sit on a placed seat anchor → chair animation, movement locked; `E` stands. Two players
  can't share one seat. ⚙ pose/offset.

## J. Framework / inventory matrix (spot-check)

- [ ] Repeat a **cook → build → sell → carry** loop on each framework you support (ESX /
  QBCore / standalone) and each inventory (ox_inventory + your fallback) — item images resolve,
  slot metadata (variations) survives, money routes to the right wallet.

## K. NUI build

- [ ] `cd web && npm run build` produces `nui/`, and the built output is **committed**. The game
  serves `nui/`, not `web/src`, so an un-built change won't show up in-game.
