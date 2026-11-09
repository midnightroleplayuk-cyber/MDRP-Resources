# vinewood_gangs

Gangs, territory, graffiti and contracts for Qbox, QBCore and ESX. Built on ox_lib and oxmysql.

## Install

1. Drop `vinewood_gangs` into your resources folder.
2. Ensure it after ox_lib, oxmysql and your framework:
   ```
   ensure ox_lib
   ensure oxmysql
   ensure qbx_core
   ensure vinewood_gangs
   ```
3. Start the server. The database is set up automatically from `sql/install.sql`. If you'd rather do it
   by hand, import `sql/install.sql` into your database once before starting (it's safe to run twice).
4. Give staff access to `/gangadmin` (anyone in `group.admin` has it by default):
   ```
   add_principal identifier.fivem:123456 group.admin
   ```
5. Add the items from the `install` folder to your inventory (spray can, burner phone, and optionally
   the gang tablet). `install/README.md` explains which file to use for ox_inventory, qb-core or ESX,
   and the item images are in `install/images`.

## The tablet

The tablet opens on a home screen: the gang's card (logo, name, rank and tier) and a grid of apps. Tap an
app to open it; **Home** (top left), the home bar at the bottom, or Esc go back. Apps the gang hasn't
unlocked yet show a lock badge. `/gangadmin` opens the same device with the staff apps.

## Players

Everything is done from the gang tablet: **F6**, `/gangtablet`, or an item (`Config.Tablet.item`).

| Tab | What it does |
|---|---|
| Overview | Rank, members online, territory held, treasury, reputation, and what's happening on the street |
| Members | Invite nearby players, promote, demote, kick, hand over leadership; leaders also see suspected leaks |
| Ranks | Rename ranks and choose what each can do |
| Territory | Zoomable map of every area, who holds it, and every gang's influence there |
| Treasury | Pay in, withdraw, wash dirty money, recent activity |
| Shop | Buy spray cans, burner phones and anything else you add |
| Contracts | Jobs from NPC contacts, the job in progress, contact trust |
| Rackets | Businesses paying you, what's waiting to collect, shops in your areas |
| Safehouses | Your safehouses, upkeep, upgrades, and ones on the market |
| Business | Enterprises in your safehouses, stock, staff, selling, and supply orders |
| Diplomacy | Deals with other gangs, proposals, rivalries, who can be trusted |
| Black market | Live auctions, bidding, buy now, dead drops waiting to be collected |
| Tags | Design tags, see approval status, spray them, and every tag you have up (with waypoints and remove) |
| Settings | Name, colour and logo (boss), leave or disband |

## Staff panel: `/gangadmin`

- **Gangs > Starting a gang:** whether players can start their own gang from the tablet or only staff can,
  the price (0 for free) and whether it's paid from bank or cash. Applies straight away; config is the start.
- **Gangs:** create a gang for an online player, set its tier, add or remove reputation, adjust its influence in
  any area, change ranks, add or remove members, disband.
- **Rackets:** which gang protects each business and what's owed; release any business; add a shop at the
  counter you're standing at (with its hourly rate), go to any shop, and delete shops added in game.
- **Safehouses:** set up new ones in game, go to, evict a gang, or delete.
- **Businesses:** every gang enterprise, its stock and output; shut any down.
- **Contracts > Job types & board:** everything in `config/contracts.lua`, changed in game and applied straight
  away: each job type's title, base reward, dirty or clean, time limit, car and debtor models and debtor odds; the
  risk levels (reward multiplier, trust and reputation); trust tiers; contacts and which jobs they give; and the
  board (jobs per gang, how long offers last, refresh rate, route length, police alert chance). Reset to config
  puts it back.
- **Contracts > Custom jobs:** make your own jobs: title, contact, job type (courier run, stolen car or debt
  collection), risk, time limit, fixed spots (set where you're standing) or random ones, and the reward: money,
  items (given to whoever completes it) and bonus reputation. Choose every gang or one, a minimum tier, how often
  it turns up on boards, and whether it can only be done once. "Offer now" puts it straight on a gang's board.
- **Contract spots:** every pickup/drop-off, stolen-car and debtor spot. Add new ones where you're standing
  (they're used by new jobs straight away), go to any spot, and delete the ones added in game.
- **Black market:** open or close the black market (closed: no new auctions, and the tablet app is hidden). The
  Black market settings tab changes everything in `config/auctions.lua` in game: contraband items (from the inventory search,
  with how many and a reserve price), how often each lot type comes up (0 turns it off) and their numbers, and the
  auction and dead-drop timings. The "connections" lot adds control to the winner's weakest hex.
- **Diplomacy:** every deal proposed or running; cancel any without penalty.
- **Street events:** what the director is running (with the hidden details), start one now, or end one.
- **Informants:** every CHIS code and the character behind it, tips given, money paid; cut anyone off.
- **Auctions:** lots up for bidding, who leads, dead drops waiting; hold an auction now or cancel a lot.
- **Turf:** influence per gang, adjust it, run a tick, show outlines in the world, and draw new areas by walking their corners.
- **Reviews:** approve or reject gang logos and tag designs.
- **Tags in world:** go to any tag or remove it.

## Safehouses: interiors and shells

A safehouse can use an **interior already on the map** (an MLO or any building) or a **shell** from a shell pack.
In `/gangadmin` > Safehouses > **Set up a safehouse**, pick which:

- **Interior on the map:** stand at the outside door, the spawn inside, the stash and the inside door, pressing E.
- **Shell:** pick the shell, stand at the outside door and press E. You're put inside a private copy of the
  shell to mark the spawn, stash and inside door. They're saved relative to the shell.

Shells are spawned only on the game of whoever goes in, inside that safehouse's own instance, and removed when
they leave. Every shell safehouse shares one hidden spot under the map (`shellOrigin`); instances keep them
apart, so any number of gangs can use the same shell. List the shell models your server streams in
`config/safehouses.lua` > `shells` (common free starter shells are listed; remove any you don't have).

**MLO safehouses you walk into:** choose **An MLO you walk into** when setting one up. Stand outside the front door
(where police breach), then at the stash, then aim at each of the building's doors and press E to add it (the door
you're aiming at is outlined; Backspace undoes, Enter finishes). The script locks those doors itself in every
player's game, so no door-lock resource is needed. Members with safehouse access press E at any of the doors to lock
or unlock them all; they're locked by default, and while nobody owns the safehouse. The stash works where it stands.
A police breach at the front door opens the doors (and the stash, for police) until the raid's open time is up,
then they lock again. "An interior on the map, teleport in" and shells work as before.

## Air drops

Staff call them in from `/gangadmin` > Street events > **Call in an air drop**: where they're standing or at
their waypoint, arriving in 0 to 30 minutes, with no cost or cooldown. A smuggler's plane (a Cuban 800) flies in low
and drops the crate. **Who can get it:** all gangs, gangs of a
tier and up (e.g. Organisation and up), one gang, or everyone. For the gang options, only those gangs' members see
it on the map and are told it's coming, and nobody else can open it (players who aren't in a gang, staff included,
are never told). **Everyone** means every player on the server, in a gang or not. A
crate parachutes down inside a red search circle on the map, with red smoke on the ground. Breaking it open takes
**2 minutes**, with a countdown for the opener. Getting hurt, knocked down, killed or moving away stops it, and the
crate is free for anyone to try. While someone's working on it, everyone nearby sees the time left above the crate
and the blip flashes on the map, so rival crews know there's a window to stop them. Unopened crates disappear after a while, and police get
an approximate call when one lands. Staff can also see and cancel drops there.

**Scheduled drops:** Street events > **Scheduled air drops** > New schedule. Every few hours, daily at set times
(server time), or once at a date and time; one or more spots (each drop picks one at random); who can get it; how
long until the plane arrives; a minimum number of players online; and the usual loot or exact contents. Each can
be switched on and off. A drop that comes due while the server is off is skipped rather than fired late.

**Loot:** the Loot button (Street events) edits the loot table every crate uses: items from the inventory search
or money, each with a min, max and weight, plus how many picks a crate gets. It's saved and applies straight away
(Reset to config brings back `config/airdrops.lua`). When calling a drop you can also **choose exactly what's in
it** instead, which is good for events and prizes. Timings and who sees the search circle are in `config/airdrops.lua`. Set `playersCanCall = true` there to
also give gangs an Air drop app on the tablet (ranks with "Call in air drops", paid from the treasury, with
cooldowns).

## Staff access

`/gangadmin` has two levels. **Management** can do everything: your server admins (`Config.Admin.group`),
anyone with the ACE `vinewood_gangs.management`, or anyone given it in game. **Staff** can only use the groups
of tools management tick in `/gangadmin` > **Staff access** (view, teleport, reviews, removing tags, gangs and
members, reputation and influence, building in the world, street events, informants, settings). Give access
to online players there too; it's tied to their licence. The ACE `vinewood_gangs.staff` also gives Staff. The
server checks every action, and Staff only see the apps they can use.

## Heists

Staff build heists in game from `/gangadmin` > **Heists**: pick a template (bank vault, armoured truck, store,
jewellery, or custom), walk to each spot and press **Set here**, then set the police needed, crew, gang tier,
time limit, cooldown and loot. Tick **Live** to make it appear in gangs' tablets.

- **Items** are picked in game from a search of your inventory (ox_inventory, qb-core or ESX): loot can be
  money to the treasury or any item, and any step can need an item (and use it up), such as a hacking
  laptop for a panel. Without one, a step uses the default in `config/heists.lua` > `tools`.
- **Steps** run in order: hack a panel, thermite a door, drill a vault, grab loot, wait out a time lock. Loot
  steps next to each other can be grabbed at once by different crew. Each step can trip a silent or loud alarm,
  and unlock a door in ox_doorlock or qb-doorlock when it's done.
- **Minigames:** hack (find the matching code), thermite (memorise the tiles), drill (drill without
  overheating). Difficulty and time are set per step; a failed minigame can trip the alarm.
- **Armoured truck:** the truck spawns with armed guards and drives. Stop it (wreck the engine or deal with the
  driver), thermite the back, grab the cash.
- **Finishing:** once every step's done, the crew get clear of the area. Heists pay out, earn influence and
  reputation, and draw a lot of heat and an MDT lead.

Gangs see live heists in the tablet's **Heists** app (unlocked at Organisation). Rules shared by every heist
(tools, loot types, truck, alarm timing) are in `config/heists.lua`.

**Who can do it:** gangs only, or **anyone**. On a heist open to anyone, players with no gang can take it on: their
crew is whoever with no gang is at the start with them (the crew size still applies), loot money goes to whoever
grabs it (dirty or clean as set) instead of a treasury, a contact who wants paying takes it from the player's cash,
and gang tiers, rank permissions, influence, reputation and police intel don't apply to them.

**Picking spots on the map:** air drops (calling one in, and schedule spots) can be placed by clicking the map. In
the heist builder, **Pick on map** takes you to the spot you click (landing on the ground) and fills it in, keeping
the panel where it was; heights matter in heists, so fine-tune with Place in game or Where I stand.

**How a heist starts:** press E at a marker on the start point, or **talk to a contact** standing there (set in the
builder: their name, look and what they say). Either way the usual rules apply (tier, rank permission, crew nearby,
cooldowns, police on duty).

**Placing NPCs in game:** the start contact and NPC steps have **Place in game**: the panel steps aside and a
see-through preview of the actual NPC follows where you look. Mouse wheel turns them (hold Shift for fine turns),
E places them, X cancels, and the panel comes back where you were. Guards can be **placed one by one**, each with
their own spot and facing (Backspace undoes the last, Enter finishes).

**NPC steps** can go anywhere in a heist:

- **Talk to someone:** an NPC stands at the spot; the crew walks up and presses E, and they say your line. They can
  want paying (from the dirty treasury) or want an item. Good for an inside man or a fixer to kick the job off.
- **Intimidate someone:** aim a weapon at them (within 12 m) until they comply, for as long as you set (8 s by
  default). Killing them completes the step too, but sets off the loud alarm.
- **Deal with guards:** armed NPCs spawn around the spot when the crew gets close (how many, model, weapon, armour,
  accuracy and spread are set per step). Everyone fights the same guards; the step is done when they're all down.

Choosing who the NPC is: a picker with categories (bank and business, security, shop staff, criminals, workers,
medical, military, police, civilians), pictures, and a search; or type any ped model (add-on peds included). The
list is in `config/peds.lua`, so you can add or remove NPCs. If a model doesn't exist in the game, a default NPC is
used instead (and the F8 console says so). NPC defaults (talk time, aim distance, spawn distance) are in
`config/heists.lua` under `npc`. The bank
template now starts with an inside man and the bank manager.

## Street dealing

Gang members carrying drugs can walk up to a pedestrian inside an area and press E to offer a deal. After a
few seconds the buyer either buys 1 to 3 (paid in cash, and the gang gains influence there), says no, says no
and calls the police, or turns out to be an undercover officer (drugs seized, exact location to police, heat).

- Buyers are keener on your own turf and warier on a rival's, where there are more police calls; every sale on
  a rival's turf takes influence off them and they're told someone's dealing there.
- Working one area too hard dries it up: after about 30 sales in an hour, buyers and prices halve.
- Police crackdowns (street events) double witness calls; market booms and crashes move prices.
- There's a cooldown between offers, an hourly cap per player, and each pedestrian is only approached once in a
  while. Rank permission: "Sell drugs on the street".

What can be sold is managed in game: `/gangadmin` > **Street dealing**. Search your inventory's items, pick
one, and set its name, price range, how many sell at once and which gang business can bag it up. Saving
replaces the starting list in `config/drugs.lua` (Reset to config brings it back). The items `weed_bag`,
`coke_bag` and `meth_bag` are in `install/` if your server has no drug items of its own. Gangs with a weed grow or cocaine lab can bag up stock from the Business tab.
Everything is in `config/drugs.lua`.

## Hex turf (territory)

San Andreas is split into a honeycomb of hexes (150 m by default), and the hexes a gang holds are its turf:
tags, rackets, street dealing, street events, gang tiers and the maps all work on them.

- **Starting turf:** staff give each gang its compound in game: `/gangadmin` > Gangs > the gang > **Turf**. Either
  **Pick on the map** (zoom in, click a hex, give it; staff see every gang's turf there), or stand in a hex and
  press "Give them the hex I'm standing in". Two hexes by default; the first is the **main** hex.
- **Control (0 to 100%):** selling the **turf drug** (OG Kush by default) on your own hex builds its control. Every
  hex loses some each hour while at least one member of that gang is online (a setting in Turf), and a rival dealing on it costs you more. Other knocks cost control too: a rival
  crossing out your tag, police cleaning it, a safehouse raid, a failed heist, or a street-event crew. A hex at
  0% is lost, except the compound.
- **Expanding:** once a hex reaches 100%, the ground touching it can be bought from the tablet's **Territory** app,
  for an amount of the turf drug from the buyer's pockets plus dirty money (rank permission "Buy new turf").
- **Tags:** only on your own turf; the first must go on the main hex, and every 3 hexes unlocks another tag.
- **Fog of war:** gangs only see their own hexes. A rival's hex shows up on your tablet and map once your gang deals
  on it (or tries to buy it). Nothing about unrevealed turf is ever sent to players' games.

Dealers see what each sale did: "Davis (4, -7): +3% control (now 45%)", or which drug builds control if the one
they sold doesn't. Turf settings warn you if a turf drug isn't a real item on your server or isn't on the Street
dealing list. Each turf drug has its own **% control per unit** (leave it blank for the default), so a premium
strain can build turf faster than a cheap one. Tick **Any drug builds control** to count every other drug too, at
the default rate.

**Resizing hexes in game:** `/gangadmin` > Turf > **Hex size**. Enter the new size, choose whether existing turf
keeps the same number of hexes or the same ground, and press Resize: it happens live for everyone. The size set in
game is kept across restarts until someone changes the size in `config/hexes.lua`, then the config wins.

**Changing the hex size (or grid origin)** in `config/hexes.lua` after gangs hold turf is safe too: on the next start
the script moves existing turf onto the new grid in the same place (`onResize`: `'centre'` keeps each gang's number
of hexes, `'fill'` keeps the same ground as more, smaller hexes), along with control, main and compound hexes,
found rival hexes and tags. The console says what it did.

The turf drug, control rates, decay, expansion cost and tag rate are set in game in `/gangadmin` > **Turf**
(`config/hexes.lua` is the starting point). The turf drug also needs to be on the Street dealing list.

## Washing money

Safehouses, business set-up and equipment need **clean** money, but most gang income is dirty. The
Treasury tab has a **Wash dirty money** section for anyone with treasury withdrawal rights:

| Method | Cut | Daily limit | Time | Needs |
|---|---|---|---|---|
| A cleaner | 30% | £25,000 | 30 minutes | Nothing |
| Your protected businesses | 12% | £6,000 per shop paying you | 60 minutes | Rackets (Firm tier) |

Dirty money leaves the treasury straight away; the clean money lands when the batch is done, even across a
restart. Washing adds a little heat, and bigger batches are more likely to file a financial lead on the MDT.
Everything is in `config/laundering.lua`.

## Gang tiers

Gangs grow through four tiers. Each needs **reputation plus milestones**, so a gang can't grind one
activity to skip ahead:

| Tier | Reputation | Milestones | Unlocks |
|---|---|---|---|
| 1. Street crew | 0 | | Tablet, graffiti, low-risk contracts, treasury |
| 2. Firm | 100 | 5 contracts, 10 tags, 3 members | Rackets, a safehouse, medium-risk contracts |
| 3. Organisation | 400 | Hold an area, 12 hours of area control, £15,000 from rackets, own a safehouse | Businesses and supply runs, diplomacy, a second safehouse |
| 4. Syndicate | 1,000 | Hold 2 areas, 30 contracts, £150,000 in business sales | Black market, high-risk contracts |

Reputation comes from tags, crossing out rivals, contracts, rackets, street sales, street events and every
hour an area is held. It's lost for failed jobs, police raids, being crossed out, losing a shop to a rival
and breaking deals. Milestones stay met once met, but if a gang's reputation drops below 70% of its tier's
requirement it slips back a tier: what it owns keeps working, but it can't start anything new at that
level until its reputation recovers.

The tablet's Overview shows each gang's standing and a checklist for the next tier; locked tabs explain
what's needed. Promotions are announced to every gang. Everything is enforced on the server.
Tiers, requirements and reputation values are in `config/progression.lua`; set `enabled = false` to open
everything from the start.

**Updating an existing server:** gangs that already exist start at tier 1. Their safehouses and businesses
keep working, but set each gang's tier from `/gangadmin` > Gangs > (gang) so they can carry on as before.

## How territory works

Gangs earn influence in an area through what they do there. Spraying a tag, dealing, finishing contracts
and intimidation all count, and each tag adds a little more every tick while it stays up. Rivals crossing
out tags, police raids and cleaners take it away. Influence decays over time, more slowly when the server
is quiet. A gang takes an area at 100 influence with a 25-point lead, and holds it while above 60.

**On the in-game map**, every area is shaded in its owner's colour (grey when unclaimed), with a marker
naming the area and who holds it. It updates live as areas change hands. GTA's map can only draw
rectangles, so areas are filled with small squares that follow their outline, and each gang gets the
nearest of GTA's map colours to its own. Who sees it, minimap or not, and how fine the squares are is set in
`Config.Territory.map`; the total number of squares is capped so large servers stay within GTA's limits.

**In the tablet**, the Territory tab draws every area over a map of San Andreas (`web/images/map.jpg`, the
standard 2048 x 2048 GTA V atlas). Scroll to zoom, drag to move, and click an area in the list to jump to it.
The picture and its alignment are set in `Config.Territory.tabletMap`; swap the file for another map of the
same layout, or set `image = false` for a plain grid. The tab also shows every gang's influence in each area as bars, with a line on how it
could change hands ("Contested: Los Vagos are within 25 of the lead"). Set
`Config.Territory.showAllInfluence = false` to show each gang only its own influence.

Other scripts add influence with one line:

```lua
exports.vinewood_gangs:RecordActivity({ type = 'drug_sale', gangId = gangId, coords = coords })
```

Activity types and their values are in `config/activities.lua`.

## Protection rackets

Businesses are listed in `config/rackets.lua`, each with a point at the counter and an hourly rate.
A member with the Rackets permission walks up and presses E to talk business:

- **Offer protection** or **lean on them**. Leaning gives better odds but more heat and a bigger chance
  the owner calls the police. Odds depend on your influence in the area, whether you hold it, and whether
  a rival already protects the shop.
- A refusal puts that shop off-limits to your gang for an hour, and may bring a police call and an MDT lead.
- A protected shop adds its rate to what it owes every hour, up to three hours' worth. Someone has to go
  and **collect**: the money goes into the dirty treasury and adds influence.
- To **take a shop off a rival**, you need more influence in the area than they have. They lose influence
  and are told who did it.
- Shops stop paying if nobody collects for six hours, or if the gang's influence in the area drops below 10.

Gangs need at least 25 influence in an area before owners will listen. Shops outside every area can't be worked.

## Safehouses

Staff set them up in game: `/gangadmin` > Safehouses > Set up a safehouse. Stand at the outside door,
then where players should appear inside, then the stash, then the inside door, pressing E at each, and
give it a name, address, price and daily upkeep. Any interior works (MLO, IPL or shell): each safehouse
gets its own routing bucket, so several gangs can share one interior without seeing each other.

- The boss buys from the clean treasury. Upkeep comes out daily; after three unpaid days it's repossessed.
- Members with the Safehouses permission can go in and use the stash (ox_inventory or qb-inventory).
  The stash is opened by the server, and a new owner always gets an empty one.
- Upgrades: a bigger stash (two levels), CCTV that warns the gang when police start a raid, and a
  reinforced door that takes twice as long to breach.
- **Raids:** police at the door can breach it if vinewood-mdt has an active search warrant (s.8 PACE,
  s.23 MDA or s.46 Firearms) whose address matches the safehouse's address or name. Once breached, police
  can go in and search the stash for 10 minutes. The gang loses influence, and the warrant is marked
  executed on the MDT. Without the MDT running, officers of grade 3 and above can raid without a warrant.
- When police intelligence on a gang reaches the most precise level, the lead can name one of its
  safehouse addresses, so heavy activity eventually gives a location away.
- Anyone who logs in inside an interior after a restart is moved back outside.

## Enterprises and supply chains

A gang with the Business permission can set up one enterprise in each safehouse, paid from the clean
treasury: a **weed grow**, **cocaine lab** or **counterfeit cash** operation (all in
`config/enterprises.lua`). Everything is managed from the tablet; stock is tracked by the script, not as
inventory items, so it works with any inventory.

- **Production** turns supplies into product every 10 minutes. Equipment upgrades (clean money) and up to
  four staff (wages from dirty money each hour) speed it up. Unpaid staff walk out. Output adds heat.
- **Selling:** wholesale pays straight away at a market price that drifts every hour. Street distribution
  sells steadily in every area the gang holds, at a better price, building influence and more heat.
  Counterfeit cash is wholesale only.
- **Supplies** come from NPC suppliers, paid from dirty money:
  - *Delivered:* 50% dearer, arrives after 30 minutes, 8% chance the police seize it (which files an MDT lead).
  - *Collected:* someone starts the run from the tablet, picks up a van and drives it to the safehouse.
    Each rival gang with someone online has a 40% chance of being tipped off and seeing the van on their
    map. A rival who drives it to one of *their* safehouses fences the load for 60% of its value.
    Vans destroyed or not home within 20 minutes are lost.
- **Raids:** a police raid on the safehouse seizes all product and half the supplies, and sends staff home.
- Selling, losing or having a safehouse repossessed shuts down whatever runs inside it.

Vans use plates starting `SUP`. They're left unlocked so they can be hijacked; whether rivals can start
the engine is up to your keys script. Runners get keys through `Config.Contracts.giveKeys`.

## Diplomacy

Members with the Diplomacy permission propose deals to other gangs from the tablet:

| Deal | Lasts | Effect |
|---|---|---|
| Alliance | Until broken | Neither side can cross out the other's tags, take their rackets or fence their supply vans. Allies aren't tipped off about each other's runs. |
| Ceasefire | 24, 48 or 72 hours | The same protection, for a set time. |
| Trade agreement | 3 or 7 days | Both gangs get 10% off supply orders (stacking to 20%). |
| Neutral area | 2 days, 7 days or until broken | Neither side can hit the other inside one chosen area. |

A deal can carry a one-off payment either way from the clean treasury, taken when it's signed, and a short
message. Proposals lapse after 24 hours.

Either side can **break** a deal at any time. The other gang is told, every gang hears about it, the breaker
loses reputation and trust (with the betrayed gang, and a little with everyone else they have deals with),
and every gang can see how many deals a gang has broken. Deals that run their full length build trust.

Gangs can also **declare rivals**. Hitting a declared rival (crossing out tags, taking rackets) earns 25%
more influence. You can't declare a gang a rival while you have a deal with them.

## Black-market auctions

Every 90 minutes to 3 hours (with at least two players on), a broker auctions two or three lots for
15 minutes. Every gang is told, and bids from the Black market tab by anyone with treasury withdrawal rights.

| Lot | What the winner gets |
|---|---|
| Bulk supplies | A free load for a matching business, collected by van like any order (and just as easy to hijack). Only gangs with that business can bid. |
| A prize job | A high-risk contract paying 2.5x, straight onto their board for three hours. |
| A bent copper | 40 heat wiped. |
| Connections in an area | +60 influence there. |
| Rare contraband | Items you list in `Config.Auctions.items`, left at a dead drop. The winner has a two-minute head start before other gangs may be tipped off; whoever searches the drop first gets the items. Uncollected drops refund half. |

Bids come out of dirty money immediately and the outbid gang is refunded on the spot. Bidders are
anonymous ("another gang leads"). A bid in the last minute extends the lot by a minute. Every lot has a
**buy now** price (2.5x the reserve) that ends it at once. The leading bid is stored in the database, so a
restart never loses anyone's money.

Item lots only appear once you add items to `Config.Auctions.items`, using names from your own inventory.
Staff can hold an auction on demand or cancel any lot (refunding the leader) from `/gangadmin` > Black market.

## Informants

Any gang member with a burner phone can call a police handler and, after a clear warning, become a
**Covert Human Intelligence Source**. The police (and the MDT) only ever know them by a code such as
`CHIS-4F2A`.

From the phone they can sell information about their own gang, for cash:

| Tip | What the police get |
|---|---|
| A safehouse | Its address, as place intelligence |
| A business | What's being made and where |
| The rackets | Which shops pay the gang |
| A member | That character named as a gang member, as person intelligence |
| A run in progress | An immediate dispatch alert where the van or runner is, plus intelligence |

Tips are filed on vinewood-mdt graded 3x5x2: source **2** (untested) until the informant has given five
tips, then **1** (reliable); handling code **C** to protect the source. Each kind of tip has a cooldown,
each target can only be leaked once a day, and there's a daily limit.

About a third of tips cause the gang's leaders (anyone who can manage members) to get a suspicious
activity report a little later, e.g. *"the police seemed to know about the supply run"*. It never names
anyone. Leaders can pay £10,000 of dirty money to look into a leak and get a shortlist of three people
who were online at the time; the real informant is on it 70% of the time. What happens next is roleplay.

Staff can see every code and the character behind it in `/gangadmin` > Informants, and cut anyone off.
Turn the whole feature off with `Config.Modules.informants = false` if your server doesn't allow it.

## Street events (the director)

Every 30 to 60 minutes the director may start an event that changes how the rest of the script behaves
for a while. Every gang member is told, and the tablet's Overview lists what's happening.

| Event | Effect |
|---|---|
| Supplier shortage | Supplies for one business type cost 50% more. |
| Market boom / crash | One product sells for 35% more, or 30% less, wholesale and on the street. |
| Police crackdown | Targets the area with the most recent activity. Heat and witness calls there are doubled. |
| Outside crew | Moves into the quietest held area and drains every gang's influence there each tick. Influence earned in the area pushes it out; the gang that does most gets a £15,000 bounty and reputation. If nobody does, the area's owner loses influence and every shop there loses what it owes. |
| Lost shipment | A van appears and every gang sees it on the map. The first to get it to their own safehouse gets its value. |
| Undercover operation | Quietly targets the gang with the most heat: its heat rises 50% faster, and when it ends the police get a precise lead. Players only hear a rumour. |
| Hot work | Contracts pay 1.5× for an hour. |

With one gang or fewer online, crews and hot work become more likely and lost shipments less so. Each
event has a cooldown, at most three run at once, and nothing starts on an empty server. Staff can see the
real details, start any event and end any early from `/gangadmin` > Street events. Events don't survive
a restart.

## Areas

Tags can go on walls, floors and ramps (`Config.Graffiti.surfaces`), and only inside an area, where they earn
influence (`Config.Graffiti.onlyInAreas`; set it to false to allow decorative tags anywhere). Placement snaps to whatever you aim at:
on a flat surface it lies flush, and floor tags read upright from where they were sprayed. Hold Shift and
scroll to push a tag into or out of the surface, for buildings whose collision sits in front of the visible wall.


## Integrations

| Resource | What happens |
|---|---|
| vinewood-dispatch | Witnesses call in graffiti, stolen cars on contracts, fights, and shop owners report extortion. Alerts only fire when police are on duty. |
| vinewood-mdt | Rising gang heat, large treasury movements, extortion reports and informant tips file graded intelligence on the MDT, against the area. The gang (and possibly a safehouse address) is named only on the most precise leads. Safehouse raids need an active search warrant from the MDT. |

Resource names and chances are in `Config.Integrations` and `Config.Witnesses`.

## Exports (server)

```lua
exports.vinewood_gangs:RecordActivity(data)
exports.vinewood_gangs:GetPlayerGang(source)     -- { id, name, label, grade } or nil
exports.vinewood_gangs:GetZoneAt(coords)         -- area key or nil
exports.vinewood_gangs:GetZoneOwner(zoneKey)     -- gang id or nil
exports.vinewood_gangs:HasPermission(citizenid, permission)
exports.vinewood_gangs:LedgerTransact(gangId, 'clean' | 'dirty', amount, type, opts)
exports.vinewood_gangs:CreateIntelLead(lead)
```

Client: `exports.vinewood_gangs:openTablet()`, `GetGang()`, `HasGangPermission(permission)`, `GetCurrentZone()`.

## Config files

| File | Covers |
|---|---|
| `config/config.lua` | Modules, gangs, influence, heat, treasury, tablet, logos, integrations |
| `config/hexes.lua` | Hex turf: grid size, compound size, and the starting turf settings (changed in game in /gangadmin > Turf) |
| `config/ranks.lua` | Permissions and the default ranks for new gangs |
| `config/activities.lua` | Influence and heat for each activity |
| `config/graffiti.lua` | Spraying, limits, cleaning jobs, fonts |
| `config/contracts.lua` | Contacts, job types, rewards, trust levels, locations, vehicle keys |
| `config/rackets.lua` | Businesses, rates, odds, cooldowns, police chances |
| `config/safehouses.lua` | Limits, upkeep grace, stash sizes, upgrade prices, raid rules |
| `config/enterprises.lua` | Enterprise types, rates, prices, wages, market, supply orders and runs |
| `config/diplomacy.lua` | Deal types and lengths, payments, trust and reputation effects, rival bonus |
| `config/director.lua` | How often street events happen, their weights, lengths, cooldowns and effects |
| `config/informants.lua` | Burner phone, tip payments and cooldowns, grading, leak reports and investigations |
| `config/auctions.lua` | Auction timing, lot types and prices, contraband items, bidding rules, dead drops |
| `config/progression.lua` | Gang tiers, their reputation and milestone requirements, unlocks, reputation per activity |

`config/contracts.lua` ships with 24 pickup/drop-off spots, 8 stolen-car spots and 11 debtor spots across the
map; add your own in game from `/gangadmin` > Contract spots. `config/rackets.lua` ships with 26 shops
across the map (24/7s, LTDs, liquor stores, barbers, clothes shops); add your own in game from
`/gangadmin` > Rackets.

## Security

Everything that matters is decided on the server: money, influence, heat, permissions, tag placement and
every contract step. Rank checks stop members acting on anyone at or above their rank or handing out
permissions they don't have. Contract deliveries faster than a car could drive are rejected. All text
shown in the tablet is inserted as text, never HTML. Staff callbacks re-check permission on every call.

## Upgrading from a version with drawn areas

Territory is hexes only now; the area drawing tool and influence system are gone. Your old area data is left in
the database but no longer used. To remove it, run `sql/optional_remove_old_areas.sql` (it's never run
automatically). Give each gang its compound in `/gangadmin` > Gangs > the gang > Turf.

## What you can edit

The resource is protected by the Cfx asset escrow. These files are left open for you to edit:

- `config/*.lua`: every setting (most can also be changed in game in `/gangadmin`)
- `bridge/server/framework.lua`: framework, inventory and money hooks (for a custom framework or inventory)
- `bridge/server/integrations.lua`: dispatch, MDT and door-lock hooks (for a different dispatch or MDT script)
- `client/bridge.lua`: client-side framework and job hooks
- `install/`: item definitions and images to add to your inventory
- `locales/en.json`: every message players see (copy it to translate)
- `sql/`: the database files
- `web/`: the tablet's look (style.css) and images

## Dirty money

Street dealing pays the dealer in dirty money. How a player is given it is set by `Config.DirtyMoney` in
`config/config.lua` (and `Bridge.AddDirtyMoney` in `bridge/server/framework.lua`, which you can edit):
ESX uses the `black_money` account, ox_inventory gives `black_money` items (one per £1), and QBCore with
qb-inventory gives a `markedbills` bag worth the amount. You can switch it to another item or account, or back to
clean cash (`moneyType` in `config/drugs.lua`).
