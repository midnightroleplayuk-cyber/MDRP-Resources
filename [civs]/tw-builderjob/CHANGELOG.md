# Changelog — Twostone Builders (tw-builderjob)

## v1.0.5

### New

**Add Region 12 delivery sites in game — `/j12site`.** Walk to the spot, place the
unload slots with a ghost preview, name it and save. The zone and the map blip are
generated for you and the site goes live immediately: no restart, no file editing.

- `/j12site` — open the editor (ENTER place, arrows turn and raise, TAB next model,
  BACKSPACE undo, K save, DELETE close)
- `/j12site list` — every drop-off with its distance from the depot
- `/j12site del <key>` / `off <key>` / `on <key>`

Only admins can use it (identifier in `Config.Admins`). Sites are stored in
`config/data/job12_sites.json`, up to 12 by default (`Config.Job12.maxJsonSites`),
and the three shipped drop-offs cannot be overwritten or deleted.

**Longer hauls, fairer pay.** Two new settings for Region 12:

- `Config.Job12.minDriveMeters` — prefer destinations at least this far from the
  depot whenever one is free. `0` = off.
- `payMult` per site (0.5–2.0) — a long run can pay more than a short one. Until
  now every destination paid the same.

**Random excavation pit.** `Config.ExcavatorJob.randomSite = true` gives each crew a
random free pit instead of the first one in the list. Default `false` keeps the old
behaviour. A pit is still only offered when it is free, fully measured, and fits the
crew size.

### Fixed

- **Crane and pump props sometimes stayed behind after a job.** When the vehicle was
  handed back, the chain could be left standing: the teardown message never reached
  the operator's own props, the vehicle was deleted before the message went out, and
  the clients' cleanup was skipped while they were outside the zone. All four causes
  are closed, and leftovers from older sessions are now cleared on resource restart
  as well.
- **Region 12 drop-off zones were never validated.** A drop-off whose zone is missing
  from `config/coordinate.lua` has no blip and is not synced to other players; the
  server now prints a clear config error for it at startup.
- **Cargo could be taken from the wrong depot shelf cell.** The shelf position was
  derived from an alphabetical index, so adding a model to `cargoPool` out of
  alphabetical order silently shifted every cell.
- **Security:** the Region 8 site saver accepted writes without an admin check. It
  only ran with debug commands enabled, so released servers were not exposed, but it
  is now behind the same admin gate as every other tool.

## v1.0.4

### Fixed

- **Finished build camera played for the wrong crew.** It was sent to everyone in
  the zone instead of the crew that finished, so a second crew on the same site
  thought their own job was over — and lost control of their character for seven
  seconds. Several regions share one zone, so it could also interrupt a different
  job entirely. It now plays only for the crew that completed the work.
- **Region 9 finished with "0 tasks".** On a site shared by several crews the task
  score was credited to the crew that opened the site first, so any crew joining
  later ended the job with an empty task count in the completion screen and in the
  history. The HUD counter was always correct, and money and XP were never
  affected.
- **Region 1 completion screen and payout disagreed.** Region 1 reduces the reward
  when a solo player starts a part-built site, but the reduction only reached the
  completion screen — the payment always used the full region reward. Both now use
  the same number, and the behaviour is a setting (see below).
- **Ground route arrows pointed the wrong way.** They had no distance limit and
  could aim kilometres away in a straight line, Region 8 switched them on before
  you reached the site, and with two active jobs the target was picked at random.
  There is now a 150 m limit, the nearest target wins, and Region 8 behaves like
  every other region.

### New setting

```lua
Config.HeadStartPenalty = false   -- config/config.lua
```

`false` (default) keeps the payout exactly as it was in v1.0.3: the full region
reward, with the completion screen showing that same amount. `true` makes the
head start reduction real — a solo player who finds the site part-built is paid
less, and the screen shows the reduced amount.

## v1.0.3

### New

**Ground route arrows.** While you work on foot, arrows on the ground point to the next
slot or to the pile you need. They stop 4 m before the target and are hidden while you
drive. Toggle: `/builderjobsettings` → Gameplay → *Ground route arrows*.

**Hint cards.** A short card explains a region the first time you start a job there, and
the next step in the multi-stage regions. ENTER closes it for the session, DELETE hides
that card for good. Toggle: `/builderjobsettings` → Gameplay → *Hint cards*.

**Finished build camera.** When the job is done, the camera circles the finished build
for about seven seconds before you return the vehicle. No text, no sound; skipped while
you are holding a crane or pump remote. Toggle: `/builderjobsettings` → Gameplay →
*Finished build camera*.

**Partial pay.** The crew leader can end a job early with `/builderjobreset`. Everyone
online in the crew is paid for the share of the work that is finished, and gets the
matching XP. Region 5 and Region 9 are excluded because they already pay per piece.

**Server theme colour.** `Config.AccentColor` in `config/config.lua` takes one hex
colour (`'#RRGGBB'`) and recolours the whole interface plus the ground route arrows.
Leave it at `'#E5B93B'` to keep the stock look. An invalid value prints a warning and
falls back to the stock colour.

**Look-at targeting.** In Regions 1, 9 and 10 the slot you are looking at is the one that
lights up and the one the piece goes into, instead of whichever slot is nearest. In
Regions 9 and 10 a slot with an empty slot underneath is only chosen when nothing else
fits, so pieces no longer end up floating.

**Map conflict detection (two layers).** Both print to the server / client console only:
- A ground check compares each region's pile points against a reference measurement and
  warns when another map or MLO resource has changed the terrain under a site.
- A file scan lists foreign resources that stream a map file with the same name as one
  of ours, and our own packs that ship two different copies of the same file.

### Improved

- **Outline colours now mean something.** Red = that is the target, get closer; green =
  press E now. Applies to every region and to the crane.
- **Rejections explain themselves.** "Task rejected (error)" is gone. The server's reason
  now reaches the player: which stage is locked and what has to be finished first, which
  slot needs filling underneath, whether the pile is empty, whether the tipper is raised,
  and so on. All 14 languages.
- **Settings panel.** New *Gameplay* tab holds the three player-facing switches above.
  Picking a detail level (or the Auto level) no longer resets them.
- **Region 4 piles.** The pile models now get five seconds to load instead of one, and a
  failed model prints one line naming it. On a cold cache the old limit could silently
  leave a pile invisible.

### Fixed

- The server could send a rejection reason that never reached the player: the client's
  callback helper dropped every value after the first. Any script that answered with
  `false, 'reason'` was showing a generic error instead.
- Turning off the route arrows, the finished build camera or the hint cards did not
  stick. Choosing a detail level, or simply opening the settings panel with the Auto
  level on, switched them back on.
- Hint cards could be marked as "already seen" without ever being displayed.

### Notes for server owners

- No database change. Existing saves keep working.
- `config/data/map_baseline.lua` is new and holds the reference ground measurement for
  the 12 regions. Do not edit it by hand.
- To hide the job blip on the map: `config/data/regions.lua`, `Config.Job.blip.show = false`.

## v1.0.2

NPC rental mode and vehicle photos, ASSETS MISSING false alarm, custom bucket support,
Chinese (14th language), TMC framework bridge, Region 4 crash, Region 9 payout and job
card, MySQL table setup, custom rental vehicle model.

## v1.0.1

First public release after the launch build.
