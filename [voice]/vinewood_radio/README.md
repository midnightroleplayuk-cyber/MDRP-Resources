# vinewood_radio

Two radios in one resource:
- **Septra terminal** (`radio`) — British TETRA-style emergency services radio with Sepura tones.
- **Comtel handheld** (`walkie`) — generic civilian/gang radio with plain tones and optional private gang frequencies.

Only one can be powered at a time per player (pma-voice has a single radio channel); switching one on turns the other off.

The Septra is a British TETRA-style emergency services radio. Talkgroup folders, point-to-point (individual) calls, emergency button, Sepura tones, and server-side locks so only emergency services can register a terminal or join emergency channels.

## Requirements
- ox_lib
- oxmysql
- pma-voice
- Qbox, QBCore or ESX (auto-detected)

Remove any other radio resource that uses the same item (qb-radio, pma-radio, etc.).

## Install
1. Drop `vinewood_radio` into your resources and `ensure vinewood_radio` **after** ox_lib, oxmysql, pma-voice and your framework. The `vinewood_radio` table is created automatically on first start (or run `install/vinewood_radio.sql` yourself).
2. Add the items. Ready-made files are in `install/`:

| Inventory | File | Images go to |
|---|---|---|
| ox_inventory (any framework) | `install/ox_inventory/items.txt` → `ox_inventory/data/items.lua` | `ox_inventory/web/images/` |
| qb-inventory / QB-style | `install/qb-core/items.txt` → `qb-core/shared/items.lua` | your inventory's image folder |
| ESX default inventory | run `install/esx/items.sql` | your inventory's image folder |

   Items: `radio` (Septra, emergency services), `walkie` (Comtel, anyone), `earpiece` (lets a walkie go quiet). If you rename them, update `Config.Item.name`, `Config.CivRadio.item` and `Config.Speaker.civEarpieceItem`.

3. Set your jobs in `Config.Services` and your talkgroups in `Config.Talkgroups`.

## Controls
| Action | How |
|---|---|
| Open / close | `/radio` or F10 (rebindable), Esc to close |
| Power on | Click the top knob, or hold the red key |
| Power off | Hold the red key or the knob |
| Change talkgroup | Up/Down on home screen, or scroll on the knob / screen |
| Volume | Left/Right on home screen |
| Talk | pma-voice radio key (default Left Alt). While the radio is open on screen: hold Left Alt or hold the side PTT button |
| Individual call | Green key, type ISSI, Call. Or Contacts > select |
| During a call | You're taken off the talkgroup until the call ends, then rejoined automatically (`Config.PTP.leaveTalkgroup`) |
| Emergency | Hold the red button on top |
| Loudspeaker | `#` on the home screen, or Settings > Audio |
| Menu | Left soft key. Enter / Backspace / arrows / digits also work |
| Who's on channel | Right soft key (Channel). ◀ / ▶ flips to other talkgroups with units on, then All units. Call/green to PTP the selected unit |

## Who can use it
A terminal only registers if the player has the item, a job in `Config.Services`, and is on duty (`Config.RequireOnDuty`). Anyone else gets "Not registered". The server re-checks every `Config.RevalidateInterval` seconds and on job/duty change; going off duty, changing job or losing the item powers the radio off.

Every pma-voice channel in `Config.ReservedChannels` (default 1–500) is locked with `addChannelCheck`, so a civilian with another radio script still can't tune in. If another script allows decimal channels (e.g. 1.5) restrict those in that script.

## Handheld radio (civilians / gangs)
Anyone with the `walkie` item can use it — no job needed. Open with `/walkie` (optional keybind in `Config.CivRadio.openKey`).

| Action | How |
|---|---|
| Power | Click the top knob (or hold red) to turn on, hold knob/red to turn off |
| Loudspeaker / earpiece | Orange top button or `#` (needs the earpiece item to go quiet) |
| Tune | Type a frequency (`*` is the decimal point), then green, `#` or the centre button. ▲/▼ steps, scroll on the knob/screen also works |
| Clear | Red key removes the last digit |
| Volume | ◀ / ▶ on the D-pad, or Left/Right arrows |
| Talk | pma-voice radio key. While open on screen: hold Left Alt or the orange side button |

- Frequencies run `Config.CivRadio.min`–`max` (default 501–999). Anything inside the emergency range is refused.
- **Private frequencies**: add them to `Config.CivRadio.private`, e.g. `[600] = { gangs = { 'ballas' } }`. Only those gangs (or `jobs`) can join, enforced by pma-voice channel checks for every radio script. Anyone else sees "Encrypted". If someone leaves the gang they're dropped off the frequency on the next check.
- Sounds: `mic_click_on` when you (or someone else) start talking, `mic_click_off` when you stop. No Sepura sounds. Toggle in `Config.CivRadio.tones`.
- Police can carry one too (undercover, etc.). Powering it on switches their Septra off and vice versa.

## Push to talk
The radio registers its own binding: **Settings > Key Bindings > FiveM > "Radio: push to talk"** (default Left Alt, `Config.PushToTalk.defaultKey`). It works with the radio closed and while it's open on screen; the open UI reads whatever key the player has bound. The side PTT button on either radio also works with the mouse.

Unbind pma-voice's own **"Talk over Radio"** so players don't have two talk keys. For new players you can do this server-wide with `setr voice_defaultRadio ""` in server.cfg.

Mouse buttons can't be used as the talk key while the radio is open on screen (they work fine with it closed).

## Radio list
With the Septra on, a list of everyone on your talkgroup sits on the right of the screen. Whoever is transmitting lights up green; your own row lights red when you talk. It hides while the radio is open.

- Toggle: `/radiolist`, or bind **"Radio: show/hide channel list"** in key bindings. The choice is remembered.
- Move/resize: `/radiolistmove`, or bind **"Radio: move/resize channel list"**. Drag the list anywhere, scroll to resize, `R` resets to default, `Enter` or `Esc` saves. Position is saved per player and stored as a fraction of the screen, so it stays in place across resolutions.
- Inside the radio: the **Channel** soft key opens your talkgroup's units. Press ◀ / ▶ to browse other talkgroups that have units on them (including other services' groups), ending with **All units**. Press Call or green to PTP the selected unit. Menu > Units opens the same screen. The home screen shows how many are on your channel.
- Settings in `Config.RadioList`. Civilian handhelds don't get a list.

## Tones (Septra only)
- `PTT.wav` plays when you press to talk
- `CLOSE.wav` plays when you release, and for others on the talkgroup when a transmission ends (`Config.Sounds.listenerClose`)
- `PTP.wav` rings on incoming individual calls (and for the caller if `outgoingRing`)
- pma-voice's own mic clicks are switched off (`disablePmaClicks`)

## ISSIs and the database
Each character gets a permanent 4-digit ISSI on first power-on, prefixed by service (1xxx police, 2xxx ambulance, 3xxx fire). It's stored in the `vinewood_radio` table with their callsign, last talkgroup and volume.

| Column | |
|---|---|
| `identifier` | citizenid (Qbox/QB) or ESX identifier |
| `issi` | unique radio number |
| `service` | service key from `Config.Services` |
| `callsign` | set in Settings > Callsign, up to `Config.CallsignMaxLength` (default 24, max 32) |
| `last_tg` | talkgroup rejoined on power-on |
| `volume` | radio volume |

Each character is read once when they first power on and cached for the session; changes are single-row async updates. Changing service (e.g. police to ambulance) issues a new ISSI under the new prefix. To give someone a specific ISSI, edit their row while they're offline.

Other resources (MDT, dispatch) can join on this table, e.g. `LEFT JOIN vinewood_radio r ON r.identifier = players.citizenid`.

The Comtel's last frequency and volume are stored client-side, not in the database.

## Animations and props
If the prop doesn't show in hand, set `Config.Debug = true` and open F8 when you open the radio: it prints whether the prop was created, networked and attached. If your server uses `sv_entityLockdown strict`, client-created props are blocked; the radio falls back to a local prop (only the holder sees it) and warns in F8.

`talk.prop` can be `false` (no prop), `true` (same prop and position as when holding the radio), or its own `{ model, bone, offset, rotation }`, which you need if the talk animation uses the other hand. The Septra's default talk animation raises the **left** hand to a shoulder mic, so it shows no prop; use bone `60309` (left hand) if you want a radio there.

Each radio has its own prop, hold animation (radio open on screen) and talk animation (transmitting with it closed) in `Config.Animations.tetra` / `Config.Animations.civ`. By default the Septra uses a shoulder-mic talk animation with no prop, and the Comtel raises the handset to the face.

Custom props: put the `.ydr` (and `.ytd`/`.ytyp`) in `vinewood_radio/stream/`, uncomment the `data_file 'DLC_ITYP_REQUEST'` line in `fxmanifest.lua`, and set `prop.model`. Adjust `bone`, `offset` and `rotation` to sit it in the hand. If the model isn't found, F8 shows a warning and the animation plays without a prop.

## Troubleshooting: radio shows TX but nobody hears you
Run `/radiodebug`, hold talk with the radio **closed**, then again with it **open**, and compare:
- **"Mic actually sending" stays NO while TX is YES**: the mic isn't transmitting. Usually another resource is blocking GTA control 249 (voice push-to-talk) every frame: admin/noclip/freecam tools, "disable controls" scripts, some HUDs. Find it by stopping resources one at a time. Also check GTA Settings > Voice Chat is enabled.
- **"Control 249 enabled" is NO**: confirms something is disabling it.
- **pma radioActive NO**: pma-voice didn't accept the press (radio disabled, dead, or channel 0).
- Make sure no other radio resource (qb-radio, pma-radio, mm_radio) is running.

The same lines print to F8 each time talking starts or stops.

## Server exports
```lua
exports.vinewood_radio:IsRadioOn(src)
exports.vinewood_radio:GetUnit(src)              -- { src, issi, callsign, service, serviceKey, talkgroup }
exports.vinewood_radio:GetUnitByIssi(issi)
exports.vinewood_radio:GetUnits()
exports.vinewood_radio:GetUnitsOnTalkgroup('pol_ops1')
exports.vinewood_radio:ForcePowerOff(src, 'remote')   -- "stun" a terminal
```
Client: `exports.vinewood_radio:IsRadioOn()`, `IsRadioOpen()`, `IsWalkieOn()`.

## Dispatch / MDT hook
Edit `server/hooks.lua` — `Hooks.OnEmergency` receives callsign, ISSI, talkgroup, street and coords. Plug your dispatch export in there.

## Browser preview
Open `html/index.html` in Chrome to click through the Septra with mock data, or `html/index.html?walkie` for the handheld.
