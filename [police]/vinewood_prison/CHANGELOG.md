# Changelog

## 2.4.1
- Visits seats: while sitting to check a seat, W and S move it forward and back, A and D move it left and right (relative to the way the seat faces); arrows still set height and turn. Tap for a small step, hold to keep moving. Finer steps (2 cm, 2.5 degrees)

## 2.4.0
- Door lockdown: one button on the tablet's Cells and doors page locks every door in the prison (cells, wing gates, normal and perimeter doors) and holds them. Unlocking at the door, keycards, wing unlock-all, the regime and lock picking are all refused until it is lifted. Duty Governor and above (`lockdown.prison`) start and lift it and can still open a single door. Lifting leaves doors locked
- A full prison lockdown turns door lockdown on, and lifting it turns door lockdown off before the regime reopens cells
- Cells and doors shows the lockdown controls even when no wings are set up

## 2.3.2
- Fixes doors that said locked but still swung open. The 2.3.1 real-door check registered a temporary ID on doors that were already registered; removing it detached the door from its real registration. The check now skips any door the game already has registered
- Doors re-attach themselves if they ever drop out of GTA's door system, so affected doors recover without re-picking
- Lock changes use the same door-system flags as ox_doorlock

## 2.3.1
- Door picker checks whether the lit object is a real door GTA can lock. Frames and plain swinging props are labelled "not a working door" so you can scroll to the actual door before saving
- `/prisondoorcheck` flags saved doors that aren't real doors ("NOT A WORKING DOOR: re-pick it")
- `Config.AdminDoorBypass = false` lets admins test doors as staff do: rank and keycard only, no admin bypass

## 2.3.0
- Clothing systems: the player's own look is saved at reception and given back at release through their clothing script, then written back to it so a later relog can't bring the uniform back. Supports 17mov Character System (via its illenium bridge), illenium-appearance, fivem-appearance, qs-appearance and ESX skinchanger / esx_skin; anything else uses GTA's clothing functions as before (`Config.Reception.Clothing`)
- The full look is kept with those systems: hair, tattoos and face as well as clothes
- Release waits for the move to the discharge point to settle before restoring clothes

## 2.2.0
- Normal door type for offices, stores and staff rooms: no wing unless you pick one, so wing lock-all and the regime leave it alone; keycard level 2 by default; key 4 while placing (perimeter moves to 5)
- "When the server starts: Locked / Unlocked" when adding doors and when editing one; the Doors list shows each door's starting state
- Wing choice has a "No wing" option for any door type

## 2.1.0
- Doors locked on join: each door is now attached to its actual object once it has loaded near you, and re-attached whenever it reloads, then the server's lock state is applied. Fixes doors showing unlocked after joining until the resource restarted or the player relogged
- Visits tables are placed seat by seat on the real chairs, like the interview seats: the prisoner's seat, then one to four visitor seats. F sits you in the seat to check it, arrows adjust height and turn, E saves the seat, Enter saves the table. Tables placed before keep working with the old opposite-side seat

## 2.0.2
- Picking doors: any object under your crosshair (up to 15 m) can be selected, whatever its shape, so sliding gates and wide gates work like they do in ox_doorlock
- Walking up to a door now also finds gate-shaped objects (up to 10 m wide, 6 m tall)
- Scroll cycles through the objects at that spot when a frame or panel lights up instead of the door; the helper shows how many there are

## 2.0.1
- Doors lock for everyone, not just the person locking: locking now forces the door shut and latched on every player's screen (a door standing open used to stay open while marked locked)
- Each player's game rechecks doors within 40 m every 2 seconds against the server's lock state and corrects any that are out of step
- Doors and points reload when a character loads (multicharacter), not only on connect

## 2.0.0
Renamed so nothing uses "HMP", "HM Prison" or similar Crown wording.

- Database tables use the `prison_` prefix. Existing installs are renamed automatically on first start, with all data kept
- Commands: `/prisontablet`, `/prisoneditor`, `/prisoncheck`, `/prisontest`, `/prisonsearch`, `/prisonsearchcell`, `/prisonalarm`, `/prisoncuff`, `/prisonescort`, `/prisonvan`, `/prisonrecapture`, `/prisongang`, `/prisonpass`, `/prisonhangup`, `/prisondoorcheck`, `/prisonsoundtest`
- Items: `prison_tablet`, `prison_keycard`; placeholder contraband `prison_spice`, `prison_hooch`, `prison_shiv`
- Default job `prison` (was the old prison service job name); default prison "Vinewood Prison", code `VINEWOOD`
- Dispatch codes start `PRISON-`; Discord embeds and docs say "Vinewood Prison"

Upgrading an existing server:
1. Rename the job in your framework to `prison`, or set `Config.Jobs` and `Config.GradeRanks` back to your job name
2. Rename the two items in `ox_inventory/data/items.lua` to `prison_tablet` and `prison_keycard` (client export `vinewood_prison.useTablet`). Items already in inventories under the old names need swapping
3. Set `Config.DefaultPrison` to your prison's code, or change the code in the editor
4. Items in the old evidence store stay in the old stash; new seizures go to the renamed one

## 1.6.1
- Tablet, Cells and doors: a "Perimeter and other doors" group lists doors that aren't on a wing (perimeter gates), with lock and unlock buttons

## 1.6.0
- Editor opens on a Setup checklist: what a prison must have to receive prisoners, what is strongly recommended, the points each switched-on feature needs, and server checks (missing items, pma-voice). Each line explains what it is for, shows done or progress, and has a button that goes straight to the right page with the type picked
- Choosing a point type fills in a sensible name (Reception desk, Phone, Visits table)

## 1.5.3
- ox_target / qb-target: every point always shows its option. If it isn't for you, choosing it says why (e.g. "Reception staff only") instead of showing an empty target
- Permissions are refreshed at the moment you choose an option, so a fresh login can use the reception desk straight away
- Prison screens open just after the target menu closes, so they keep mouse focus
- Points with separate staff and prisoner options (hiding spots, phones, the market) still show only the one that applies to you

## 1.5.2
- Door sounds now use GTA's own recordings by default, played in 3D at the nearest door: the door buzzer (DOOR_BUZZ) and a cell unlock for unlocking, the buzzer and a heavy door close for locking. Replaces the generated sounds
- Each sound in `Config.DoorSounds` (UnlockAll, LockAll, Unlock, Lock) is a list of steps; each step is a GTA sound or your own file in web/build/sounds
- `/prisonsoundtest` plays GTA's door, buzzer and lock sounds one by one where you stand, showing the line to copy into the config

## 1.5.1
- Notifications stay up long enough to read: at least 6 seconds, plus time for longer messages, up to 15 seconds (`Config.Notify`, with an optional position)

## 1.5.0
- Door sounds: a prison buzzer and bolts when cell doors are unlocked together, a short buzz and heavy bolt when they lock (regime, wing lock-all and unlock-all, lockdowns), and a clunk for single doors. Played from the doors' positions and quieter with distance (`Config.DoorSounds`). Sounds generated for this resource, free to ship
- `Config.Regime.Cells`: 'regime' (unlock and lock with the regime, default), 'lockonly' (only locks at lock-up; staff unlock), 'manual' (never touches cell doors). Restarts follow the same rule

## 1.4.3
- Overlapping door prompts: the nearest door takes E (rechecked as you move), so E no longer locks the door next to the one you're at
- Door prompts name the door: "[E] Lock / unlock A-1-02 door"
- `/prisondoorcheck`: shows each prison door's name, saved state, the game's door state and whether the door object is at its saved spot (green when all is well, red when not)

## 1.4.2
- CCTV opens at exactly the saved view; the viewer's zoom range now matches placement (15 to 90 degrees) and the overlay shows the zoom level
- Operator-style control: WASD pans and tilts at a steady rate, the mouse fine-adjusts, movement and zoom are eased, panning slows as you zoom in, R resets to the saved view
- Arrow keys change camera; Backspace returns to the tablet's CCTV page
- New `Config.CCTV` settings: PanSpeed, MouseSensitivity, ZoomStep, Smoothing

## 1.4.1
- Overlapping prompts: the most important one shows and takes E (doors, then desks and points, then cell search and stash), instead of whichever came first
- "Search cell" only shows when you're standing inside the cell (within 1.6 m of its spot; `Config.Security.Search.CellPromptRadius`), not in the doorway
- `/prisonsearchcell` searches the cell you're in; `Config.Security.Search.CellPrompt = false` turns the prompt off and leaves the command

## 1.4.0
- Doors: choose Single or Double before placing (Q switches while placing). Single: E or Enter saves the lit door on its own. Double: E on each half, saves when both are picked; the halves must be within 3.5 m of each other
- Fixes separate doors being saved as one double door when E was pressed on neighbouring doors
- Make single: on any double door's row, or in its edit panel. The second half is freed to add as its own door
- Re-pick as single or as double when editing a door

## 1.3.3
- Adding doors only links to cells on the same floor as the door (door's bottom edge against the cell spot's floor, within 1.8 m), measured flat along the landing, so ground-floor doors no longer attach to cells upstairs
- Cell markers in door mode only show for your own floor

## 1.3.2
- Editor: the side panel stays in view while long lists scroll, so Edit forms no longer open out of sight; the row being edited is highlighted and the panel flashes when it switches to editing

## 1.3.1
- Adding doors shows which cell each door will attach to: a line from the door to the cell's spot, labelled "Attaches to A-1-04", and a Cell line in the helper
- Left and right arrows choose a different nearby cell without a door
- Nearby cells are marked while placing doors: green with their door's name when done, white when they still need one

## 1.3.0
- Officer tablet shown inside a rugged tablet device, scaled to any screen size, with a power-on and power-off effect
- Working device buttons: power closes the tablet; P1, P2, P3 and the home key run actions set in `Config.Tablet.Buttons` (any tablet page, or a general alarm that needs a second press to confirm)
- `Config.Tablet.Device = false` brings back the plain window

## 1.2.2
- Editor lists now update when you come back from any world tool (cells, doors, points, cameras, door re-pick); the editor keeps its page and form while hidden
- Doors: set type, wing, keycard level, name and locked-after-restart before placing, each with Auto; switch type with 1 to 4 while placing; the helper shows the name, type and level each door will get

## 1.2.1
- Editor tool helper is drawn by the prison's own interface, so other resources' prompts can no longer replace or hide it; shows what you're pointing at as you move
- Adding doors: walk up to a door and it's picked up automatically (or aim at it); Enter saves the lit door without pressing E first; doors already set up can't be added twice; fly mode (G) works in door mode

## 1.2.0
- LB Phone: prison calls ring the person's real phone with the prison as the caller, over lb-phone's own call system, and appear in their recent calls
- Phone caller name per prison in the editor (defaults to the prison name); used by native calls and the pop-up
- `Config.Phone.NativeCalls` to switch native calls off

## 1.1.1
- Prison phone works with LB Phone, Quasar Smartphone PRO, Quasar Smartphone, NPWD, YSeries / YFlip / YPhone, GKSPHONE v2, High Phone and RoadPhone, with the framework phone number as the fallback
- Direct number lookups where the phone supports them; numbers kept as typed and matched ignoring formatting
- Adapters are chosen by priority when more than one phone resource is running; the console shows which is in use

## 1.1.0
- ox_target and qb-target support for every editor point (auto-detected), with [E] prompts as the fallback
- Editor world tools: add doors in a row with kind, wing, label and cell link filled in from where each door is; place cells by walking or flying, with numbers counting up; place points where you aim with scroll radius; place CCTV cameras with a free camera
- Door picker: Enter, numpad Enter or right mouse saves; help text stays on screen while picking (prompts are paused in editor tools)
- Phone point tells staff it is for prisoners; `/prisontest` puts editors into test custody to try prisoner features

## 1.0.2
- Door picker outlines the door you aim at, like ox_doorlock, and warns if it is already set up
- Double doors: select both halves; they lock, unlock and save together (migration 0007)
- Doors can be re-picked when editing

## 1.0.1
- Boundary draw mode: place, move, insert and delete corners in the world with a live wall preview, optional fly mode, save in one go

## 1.0.0
- AI officers at posts when the regime runs itself; ambient AI prisoners when cells are unlocked
- Automated response to fights, alarms and cell bells when no staff are on duty
- Movements: court, hospital and inter-prison transfers, contractor transfers, escort leash, overdue alerts
- Escort helpers: cuff, escort, seat in vehicle
- Escapes: perimeter alarm, dispatch, lockdown, MDT status, sentence time stops; recapture by police or staff; voluntary return
- Lockpicking doors with a skill check
- Parole: eligibility, scored applications, governor review with licence conditions, automatic decisions
- Editor lists exported presets; preset version check
- Setup check at start and `/prisoncheck`

## 0.5.0
- Visits with allowances, legal visits, drug dog, seated visits, item passing, bans and NPC family visits
- Prison phone: PINs, approved contacts, credit, pma-voice calls, monitoring and call log
- Gangs: reputation, recruitment, alliances, rivalries, territory control and market discounts
- Healthcare: requests, confidential notes, prescriptions, medication rounds; safer custody plans with timed checks

## 0.4.0
- Contraband, cell and hiding-spot stashes, cell, area, rub-down, full and random searches, evidence store
- Black market with scarcity and heat pricing
- Intelligence reports; alarms, incidents, fight and Code Blue detection, concerted indiscipline
- Wing and prison lockdowns; CCTV; dispatch adapter

## 0.3.0
- Task engine; eight jobs with levels and work orders; four courses and qualifications; gym, library and showers

## 0.2.0
- Regime and roll checks; incentives; adjudications and segregation; accounts, wages, deposits; canteen and kiosk

## 0.1.0
- Foundation: bridge, migrations, editor, doors, reception, sentences, release, tablet
