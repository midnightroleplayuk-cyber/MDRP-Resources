# Rex Darts — Synced darts on every vanilla dartboard

**Rex Studio** · https://rex-studio.com · Discord: https://discord.gg/kMdMhDKwrA · Documentation: [DOCS_SUBPAGE]

501, 301, Around the Clock and Cricket for 1 to 4 players, on every vanilla dartboard of the map
(Yellow Jack Inn, MC clubhouses, any MLO that uses the vanilla props) and on boards you hang yourself.
You aim with the mouse against a swaying hand, steady it with Focus, and set the power on a hold/release bar.
The **server** decides where the dart lands and scores it from the real board geometry: singles, doubles,
trebles, 25 and bull.

Frameworks: **ESX** · **QBCore** · **QBox** · **standalone** (bets off). Targets: **ox_target** · **qb-target** · or a built-in **[E] prompt**.

---

## Features

- **4 game modes**: 501, 301 (double out on/off), Around the Clock (doubles and trebles skip numbers, configurable), Cricket (15-20 + bull, marks and points).
- **1 to 4 players**, "first to 1 / 3 / 5 legs", starting player rotates every leg, round limit per mode.
- **Solo practice** (no stake, no stats).
- **Aiming minigame**: mouse aim, procedural hand sway, Focus (steady hand) budget per visit, ping-pong power bar with a perfect window.
- **Screen-space reticle**: orange ring with dark outlines and a centre dot, always drawn on top of the board, readable on every segment; its size follows the current sway.
- **4 throw cameras**, switchable in a match with C / V and remembered per player: Player (thrower's eyes), Close-up, Over the shoulder, Cinematic side view (also used automatically while a visit is resolved). Smooth interpolation, every FOV / position configurable. The aim works the same with every view (ray from the rendered camera onto the board).
- **Dart in hand**: the thrower holds the next dart (seen by every player and spectator in range), it leaves the hand at release and flies from there into the board; HUD shows the darts left in the visit.
- **Spectator camera**: `/dartscam` (bindable) puts spectators and waiting players on the cinematic view of the game.
- **Real scoring** from the landing point (regulation ring ratios, 20 segments in the official order).
- **Server-authoritative**: the client only sends the aim point and the power. The server checks turn, state, distance to the oche, rate limit and value ranges, then adds its own scatter and scores the dart.
- **Bets**: stake per player held in escrow, house cut (optionally paid to a society), refunds on cancel or resource stop, forfeit = stake lost.
- **Live scoreboard NUI**: scores, legs, 3-dart average, current visit (T20 / S19 / ...), visit total, turn timer, mini board with the darts of the visit, checkout route (e.g. `T20 T19 D12`), cricket marks grid.
- **Spectators** within range see the darts fly and stick and get the scoreboard (optional).
- **Callouts**: 180, ton+, bust, game shot.
- **Results screen** and **leaderboard** (wins, games, 3-dart average, 180s, best checkout) stored with oxmysql.
- **Board locations**: every vanilla board works automatically (model based, no coordinates needed), extra boards from the config, admin-placed permanent boards, **placeable `dartboard` item** (wall snap, saved in the database, owner can take it back).
- **/dartscalibrate**: draws the scoring rings on a board in game so you can fine-tune the offset and size per model (saved to `data/calibration.json`).
- English and French locales, every string editable.
- 0.00 ms idle: model targets (or a 1.5 s scan for the [E] prompt), local non-networked dart props, per-frame loops only while you throw.

## Requirements

- OneSync (legacy or infinity)
- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql) (stats, leaderboard, placed boards)
- Optional: ox_target or qb-target, ox_inventory

## Installation

1. Drop the `rex_darts` folder in your `resources` folder.
2. `server.cfg` (order matters):

```cfg
set onesync on
ensure ox_lib
ensure oxmysql
# ensure ox_target            # optional (or qb-target)
ensure rex_darts

add_ace group.admin rexdarts.admin allow
```

3. The SQL tables are created automatically on start (`install/rex_darts.sql` if you prefer to import them by hand).
4. Optional item `dartboard`:
   - **ox_inventory**: copy the entry of `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`.
   - **QBCore / QBox**: copy the entry of `install/qb_items.lua` into your shared items.
   - **ESX**: `INSERT INTO items (name, label, weight) VALUES ('dartboard', 'Dartboard', 3);`

## Configuration (`config.lua`)

| Option | Description |
| --- | --- |
| `Config.Framework` | `auto`, `esx`, `qb`, `qbox`, `standalone` |
| `Config.Locale` | `en`, `fr` (add your own in `locales/`) |
| `Config.Target` | `auto`, `ox_target`, `qb-target`, `none` |
| `Config.BoardModels` | playable models with the board centre offset and double-ring radius |
| `Config.ThrowDistance` / `OcheTolerance` | oche distance (2.37 m) and the server tolerance |
| `Config.SpawnBoards` | extra boards spawned by the script (for MLOs without a board) |
| `Config.Modes` | enable / disable modes, start score, round limits |
| `Config.MaxPlayers`, `AllowSolo`, `LegsChoices`, `DoubleOutDefault`, `CheckoutHints`, `TurnTime` | match rules |
| `Config.Throw` | sway, Focus, power bar speed, perfect window, server scatter, anti-spam interval |
| `Config.Bets` | account, min / max, presets, house cut, society |
| `Config.Item` | placeable board item, persistence, max per player |
| `Config.Stats` | leaderboard size and cache |
| `Config.Camera` | default view, cycle order, remember choice, interpolation, per-view position / FOV, cinematic between throws, spectator camera |
| `Config.Keys.camNext` / `camPrev` | switch view (default V / C), `Config.KeyLabels` = key names shown in the HUD |
| `Config.HandDart` | dart held in the hand: bone, offset, rotation, release timing |
| `Config.Anims`, `Config.DartModels`, `Config.DartPitch` | vanilla anims / props used |

## Controls (thrower)

| Key | Action |
| --- | --- |
| Mouse | aim |
| LMB (hold, release) | power, throw |
| Shift | steady hand (Focus) |
| C / V | previous / next camera |
| Backspace | forfeit |

## Commands

| Command | Who | Description |
| --- | --- | --- |
| `/dartsleave` | player | forfeit / leave the current game |
| `/dartsreset` | player | closes the darts window, HUD and camera and gives the mouse back (if anything ever gets stuck) |
| `/dartscam` | player | toggle the cinematic camera on the game you watch (bind it in Settings > Key Bindings > FiveM) |
| `/dartsplace` | admin | place a permanent board on the wall you look at |
| `/dartscalibrate` | admin | ring overlay on the nearest board: arrows move, PgUp/PgDn depth, numpad +/- size, Enter saves |
| `/dartshand` | admin | tune the dart held in the hand live (see below) |
| `/dartsadmin` | admin | list running games |

## Exports (server)

```lua
exports.rex_darts:GetMatches()            -- table of public match states, by board key
exports.rex_darts:GetPlayerMatch(source)  -- public state of the player's match or nil
exports.rex_darts:ForceLeave(source)      -- remove a player (forfeit / refund in lobby)
exports.rex_darts:GiveBoardPlacement(source) -- start a free board placement for a player
```

## Events (server)

```lua
AddEventHandler('rex_darts:matchFinished', function(data)
    -- data = { key, mode, winner (source or nil), payout, players = { { name, legs, darts, avg, best, max, checkout, winner } } }
end)
```

## Open files (escrow)

`config.lua`, `locales/*.lua`, `bridge/*.lua`, `install/*`, `data/calibration.json`. Money, items, society
and notifications all go through `bridge/server.lua` / `bridge/client.lua`, so you can plug any economy.

## Notes

- The board centre offsets come from the model bounding boxes. They should be close; if the darts land a few
  millimetres off the painted rings on one of the models, run `/dartscalibrate` once.
- If the darts appear reversed in the board, set `Config.DartPitch = 90.0`.
- **Dart in hand (`/dartshand`)**: your ped takes the aiming stance with a dart in the hand.
  Arrows = offset X / Y, PgUp / PgDn = offset Z, hold **Shift** to rotate instead, hold **Ctrl** for fine steps
  (2.5 mm / 1°), **F** flips the dart end for end, **G** switches bone (SKEL_R_Hand / PH_R_Hand / right thumb),
  **Enter** prints the three `Config.HandDart` lines in the F8 console and copies them to the clipboard,
  **Backspace** exits. Changes apply live to running games, paste the lines in `config.lua` to keep them.
- In `/dartscalibrate`, if the rings disappear on the board but show on the wall around it, the scoring plane is
  behind the board face: press PgUp until they show on the board.

## Changelog

- **1.0.3**: the mouse focus is always released: every exit path (leave, forfeit, lobby cancelled or timed out,
  kick, match end, death, walking away, resource stop) goes through one cleanup; ESC / Backspace always close the
  window; failsafe check every second; results window closes itself after 20 s; `/dartsreset` for players.
- **1.0.2**: the dart in hand is attached to the hand bone SKEL_R_Hand (57005) instead of the prop-holder bone
  PH_R_Hand, which the darts animation can move away from the hand; standard hand-prop attach flags; `/dartshand`
  live tuning tool.
- **1.0.1**: screen-space reticle (always visible over the board, size follows the sway), 4 selectable throw
  cameras with C / V and saved choice, aim projected through the active camera, dart held in the hand for everyone
  in range, darts-left counter in the HUD, `/dartscam` spectator camera.
- **1.0.0**: first release.

## Support

Discord: https://discord.gg/kMdMhDKwrA · Documentation: [DOCS_SUBPAGE]
