# Apex Phone (apex_phone) v1.5.3

A full smartphone for FiveM with two complete operating systems in one resource:

- **PearOS 27** (iOS style, Liquid Glass) on the PearPhone 18 Pro Max and the PearPhone Fold
- **Nova UI 9** (Android style) on the NOVA S26 Ultra and the NOVA Fold8

The item a player uses decides which system opens. Apps, account, phone number, messages and calls are shared
between both systems, so a PearPhone player can call, text and video call a NOVA player normally.

Also included: AirPods Pro 3 and NOVA Buds 4 Pro earbuds (3D props on the head), eSIM cards with QR activation and up to 3
lines per phone, an in-world phone shop with a 3D product viewer, an in-game admin panel (`/phoneadmin`) with a
custom job app builder, the Vera assistant (optional, Google Gemini), an Arcade with 23 games, server leaderboards
and online matches, the Fitness, Journal, Stocks, Translate, Voice Memos and Tips apps, and an SDK so you can build
your own app for the phone (`docs/SDK.md`).

---

## Requirements

| Resource | Required | Notes |
|---|---|---|
| `oxmysql` | **Yes** | The only hard dependency. |
| Framework | Auto | `qbx_core` (QBox), `qb-core` (QBCore) or `es_extended` (ESX), detected at start. Standalone mode is also available (`Config.Framework = 'standalone'`). |
| Voice | Optional | `pma-voice`, `saltychat` or `mumble-voip` for call audio (`Config.Voice = 'auto'`). Only pma-voice has been used in production; the other two follow their public APIs. |
| `ox_inventory` | Optional | Recommended. Items, metadata and the shop use it first. `qb-inventory` and the ESX / QB inventories also work through the framework. |
| `ox_target` | Optional | Phone shop interaction (`Config.Shop.interaction.mode = 'auto'` falls back to a key press). |
| `ox_lib` | Optional | Used for the confirmation dialog of `/phonewipe` when running. |
| `screenshot-basic` | Optional | Only for the Face Key face photo. The Camera app does not need it. |

Optional integrations, detected automatically when started: `qb-houses` (Home app), `qb-weathersync` (Weather app).

## Installation

1. Put the `apex_phone` folder in your `resources` folder.
2. In `server.cfg`, start it **after** `oxmysql`, your framework and your voice resource:
   ```
   ensure oxmysql
   ensure qb-core        # or qbx_core / es_extended
   ensure pma-voice
   ensure apex_phone
   ```
3. Stop any other phone resource (`qb-phone`, `esx_phone`, ...) so two phones do not fight over the same key.
4. **No SQL file is needed.** Every `apex_phone_*` table is created automatically on the first start
   (`CREATE TABLE IF NOT EXISTS` in the server files), and missing columns or indexes are added on later starts.
5. Add the items (see below), then restart the server or run `restart ox_inventory` and `restart apex_phone`.
6. Give your staff the admin permission (see **Admin permission**).

### Inventory items

By default the phone only opens with one of the device items in the inventory (`Config.RequireItem = true`).

- **ox_inventory:** copy every entry of [`inventory_items.lua`](inventory_items.lua) **inside** the `return { ... }`
  of `ox_inventory/data/items.lua`. The item images are served by this resource
  (`nui://apex_phone/inventory_images/<item>.png`), so you do not have to copy any PNG.
- **QBCore / QBox with qb-inventory (or ps-, lj-, qs-inventory):** paste the entries of
  [`installation/qb-core_items.lua`](installation/qb-core_items.lua) inside `QBShared.Items` of `qb-core/shared/items.lua`
  and restart qb-core. These inventories load an item's icon from **their own** `html/images/<image>` folder, so `image`
  must be a plain file name (`pear18_black.png`), never a `nui://` address. The phone checks this on every start
  (`Config.InventoryImages`): a PNG missing from the inventory's images folder is copied there from
  `inventory_images/` (run `restart qb-inventory` once afterwards), and the server console says exactly what is wrong
  (item not created, `useable = false`, image not a file name). `phoneitems` in the console repeats the check.
- **Other inventories:** create items with the same names (list in [`ITENS_OX_INVENTORY.md`](ITENS_OX_INVENTORY.md))
  and use the PNG files from `inventory_images/` as icons. Usable items are registered through the framework.

Full item guide: [`ITENS_OX_INVENTORY.md`](ITENS_OX_INVENTORY.md).

## Opening the phone

| Input | Action |
|---|---|
| `F1` (`Config.OpenKey`) | Open / close. Opens the first device in the inventory (or the last one used). Players can rebind it in the FiveM key settings. |
| Use a device item | Opens that device (its OS, frame colour and prop). Using the same item again closes it. |
| `Esc` | Close |
| `Config.Command` | Optional chat command to open (empty by default). |
| `Config.VeraKey` | Optional key for the Vera assistant with the phone closed (empty by default). Never use F2 with ox_inventory. |

## Commands

All commands below are admin only (or the server console).

| Command | What it does |
|---|---|
| `/phoneadmin` | In-game admin panel: phone settings, enabled apps, phone shop, custom job apps, webhooks and the change log. Everything saved there is stored in the database and overrides `config.lua`; "Reset" goes back to the config. |
| `/phonegive [id] [item]` | Gives one phone item to a player. |
| `/apexdevices [id]` | Gives every device and both earbuds (`Config.DeviceGrantCommand`, empty disables it). |
| `/phoneopen [id] [app]` | Opens a player's phone, optionally on an app. |
| `/phonenumber [id] [new]` | Shows or changes a player's number. |
| `/phonereset [id]` | Factory resets a player's phone account. |
| `/phonenotify <target> <app> <text>` | Sends a phone notification. |
| `/testnotif [id] [app]` | Sends a test notification. |
| `/phonepos` | Live editor for the phone position in the hand. |
| `/phonewipe` | Wipes **all** phone data of all players. Shows a summary and a 4 digit code; `/phonewipe confirm <code>` runs it. A backup copy of every table (`zbak_apexphone_<date>_*`) is made first unless you add `nobackup`; add `all` to also wipe the admin panel settings. `/phonewipe backups` lists backups, `/phonewipe dropbackup <stamp>` deletes one. Restart `apex_phone` afterwards. |
| `/phoneshowcase seed\|clear\|status` | Fills the server with English demo data (14 fictional people, chats, posts, bills...) for screenshots and videos; `clear` removes exactly what `seed` created. |
| `phoneshop_items` | Server console only: re-checks which shop items exist in the inventory. |
| `/givesim [id] [number]` | Gives a SIM card item (only with `Config.PhysicalSim.enabled = true`; `Config.PhysicalSim.giveCommand`). |
| `/phoneintegrations` | Prints to the server console which integration provider each category is using right now. |
| `phoneitems` | Console or admin (1.2.0): checks the phone items in `qb-core/shared/items.lua` and their PNGs in the inventory's images folder, copies missing PNGs there and prints what to fix. |
| `phonesounds` | Console or admin (1.2.0): the `Config.WorldSounds` state, who is listening to a speakerphone and how many phones are ringing. |
| `phonedelivery` | Console or admin: why the Garage delivery is on or off, the mode (valet / road), the key resources fed and the last attempt. |

Players can use `/camtest` to print a camera viewfinder diagnostic to the F8 console, `/phonevoice` to print
which voice system the phone detected, the active call channel and the pma-voice state (use it when someone reports
"no audio in calls"), and `/phonefix` (1.1.8) to reset a stuck phone on the spot: it closes the phone and any shop /
admin layer left open, releases the NUI focus and cursor, the camera and Face Key, leaves the voice channel of a call
that no longer exists, clears a pending device request and the hand pose. It never touches data. The F8 console lists
what it reset, so support can see what was stuck.

### Admin permission

Admin = the framework admin permission (QBCore `admin`/`god`, QBox `admin`, ESX group `admin`/`superadmin`)
**or** the ACE `apex_phone.admin`, for example in `server.cfg`:

```
add_ace group.admin apex_phone.admin allow
```

## Configuration

| File | What is in it |
|---|---|
| `config.lua` | Everything: framework, keys, scale and position on screen, default language and theme, devices, wallpapers, PIN rules, SIM and eSIM, calls and voice, camera, messages, media limits, maps, services, billing, marketplace, garages, social apps, music library, Eats restaurants, browser, Vera AI, admin panel, custom apps and the phone shop. |
| `config_recado.lua` | Limits of the Recado messenger app (pins, forwards, polls, channels, communities, GIF provider). |
| `config_arcade.lua` | Arcade (1.5.0): leaderboards kept per board, score limits of every game, online match rules (turn time, invites, "players near me" range). |
| `config_fitness.lua` | Fitness (1.5.0): sampling, daily goals, limits of what the client may report, awards, how long daily rows are kept. |
| `config_journal.lua` | Journal (1.5.0): entries per character, text length, photos on or off. |
| `config_stocks.lua` | Stocks (1.5.0): the simulated market (tick, fee, order limits, history) and the 14 fictional companies. |
| `config_translate.lua` | Translate (1.5.0): translations per character and day, text length, cache. Uses the Gemini key of `Config.AI`. |
| `config_voicememos.lua` | Voice Memos (1.5.0): recording length, recordings per character, size. |
| `config_recording.lua` | Recording limits per phone (1.5.0): video and Voice Recorder length per model / item / system, video sound, storage per character, upload pace. |
| `shared/admin_schema.lua` | Which settings the admin panel is allowed to change. |
| `client/framework.lua`, `server/framework.lua` | Framework bridge (players, money, jobs, items, notifications). |
| `server/shop_bridge.lua` | Money and item bridge of the phone shop (ox_inventory first). |
| `server/ai_key.lua` | The Gemini API key for Vera (server side only). |
| `locales/*.lua` | In-game texts outside the phone (notifications, chat, command help, key names). |

Useful keys in `config.lua`:

- `Config.Framework = 'auto'`: forces `'qb'`, `'qbx'`, `'esx'` or `'standalone'` if you run more than one.
- `Config.DefaultLanguage = 'en'`: language of new accounts. 16 languages: `en`, `es`, `zh-Hans`, `zh-Hant`, `ja`,
  `fr`, `de`, `ru`, `pt`, `it`, `ko`, `nl`, `tr`, `pl`, `sv`, `da`. Each player can change it in Settings > General >
  Language & Region; accounts that already exist keep the language they chose. A code that is not in the list falls
  back to English (phone and in-game texts). See "Languages" below for adding your own language.
- `Config.Currency = { symbol = '$', position = 'before', thousands = ',', decimal = '.' }`: the currency shown in
  the whole phone (Wallet, Bills, Marketplace, Eats, Onion/crypto, work apps) and in server notifications. For euros:
  `{ symbol = '€', position = 'after', thousands = ' ', decimal = ',' }`. The phone shop starts from it too
  (`Config.Shop.currency`); a symbol saved in the admin panel's shop settings still wins for the shop.
  Number formatting inside the phone follows the player's language.
- `Config.OpenKey`, `Config.Scale`, `Config.Offset`, `Config.AllowWalking`, `Config.BlockWhenDead`.
- `Config.KeepVoice = true`: the push-to-talk keeps working while the phone or the phone shop is open (the game keeps
  the keyboard; every other game control is disabled frame by frame and the player stands still unless
  `Config.AllowWalking` is on). `false` restores the old behaviour, where nobody could talk with the phone open.
- `Config.LookKey = 'LMENU'`: hold left Alt with the phone open to look around with the mouse (the pointer hides
  while the key is held). Players can rebind it in Settings > Key Bindings > FiveM; `''` removes it. Since 1.2.0 the
  phone page listens for Alt itself too, so it works with the mouse over the phone and with `Config.AllowWalking` and
  `Config.KeepVoice` both off (before, the key only reached the game when the game had the keyboard).
- `Config.WorldSounds` (1.2.0): the ringtone, message / notification chimes and alarms of a phone are heard by the players
  around it, fading with distance (`range`, `volume`); a phone on silent makes no sound for anybody. `speaker = true`
  turns the call screen's "Speaker" button into a real speakerphone with pma-voice / mumble-voip: players within
  `speakerRange` metres of the phone are put on the call channel while they stay close (they hear the other side and are
  heard by it) and taken out when they walk away, when the speaker is turned off or when the call ends. Players already
  in a call of their own are never pulled in. `phonesounds` in the server console shows the state.
- `Config.InventoryImages` (1.2.0, QBCore / QBox without ox_inventory): on start the phone checks its items in
  `qb-core/shared/items.lua` and copies missing PNGs into the inventory's `html/images/` folder (see "Inventory items").
- Typing in any text field of the phone keeps the keyboard inside the phone: no letter reaches the game (walking,
  chat, inventory, other resources' keys) and the open/close key never closes the phone while a field is focused,
  even when another resource turns the game input back on. Esc leaves the field, a second Esc closes the phone.
- `Config.GarageDelivery`: "Request Delivery" in the Garage app brings a stored vehicle to the player with its keys
  (price, account, cooldown, distance, key resource). `mode = 'valet'` (1.2.0, default): a valet NPC drives it from a
  road `valet.minDistance`..`valet.maxDistance` metres away up to the player, gets out and walks off; the phone says
  "Your vehicle has arrived". If the valet cannot get there in `valet.timeout` seconds (blocked road, player kept moving,
  no road nearby) the vehicle is moved to the nearest free road next to the player and the phone says so. `mode = 'road'`
  = the 1.1.9 behaviour (the vehicle appears parked on the nearest free road). Needs OneSync; works with every supported
  garage (`integrations/README.md`, "Delivery"). `phonedelivery` in the server console says why it is on or off, the
  mode and the last attempt.
- `Config.Music.Search = true` (internal provider): players search any song on YouTube or paste a YouTube link in the
  Music app and the story music sticker, with no API key. `Config.Music.Library` stays as the Home shelves.
  `Search = false` keeps the curated Library only. `phonemusic` / `phonemusic <text>` in the server console checks it.
- `Config.Camera.VideoMaxSeconds`, `VideoBitrate`, `VideoHeight`, `VideoMaxBytes`, `VideoAudio`: limits of the videos
  recorded by the Camera app (see "Camera video").
- `Config.Wallpapers` (files in `html/img/wallpapers/` or image links) and `Config.WallpaperLinks` (players adding
  wallpapers from links / pasted images; see "Wallpapers from links").
- `Config.Devices` / `Config.DeviceOrder`: items, props, frame colour and OS of every device.
- `Config.NumberFormat = '555-####'`, `Config.SyncNumberToCharInfo`, `Config.Sim` (eSIM item, lines per phone).
- `Config.Voice = 'auto'`, `Config.CallTimeout`.
- `Config.Shop`: phone shop locations, vendors, blips, categories, products and prices. The map blip is named
  "Phone shop" in the player's phone language (key `Loja de telemóveis` of `locales/<code>.lua`); set
  `Config.Shop.blip.label = 'My text'` for one fixed name on every shop, or `blipLabel = '...'` in a shop entry (also in
  `/phoneadmin` > Shop > Locations). Blips and the vendor prompt are renamed on the spot when the player changes language.
- `Config.Music.Library`: songs of the built in music catalogue (YouTube video ids).
- `Config.WelcomeMail` / `Config.BillMail` / `Config.Sim.carrier`: carrier and system mail texts.
- `Config.Debug = false`: set to `true` for extra logs in the server console, F8 and the NUI.

Webhooks for the admin log and the custom job apps are set in `/phoneadmin` (stored in the database, never in the files).

## Languages

Every text a player can see is translatable from files that stay readable in the escrowed build:

| File | What it translates |
|---|---|
| `html/js/i18n-<code>.js` | Everything inside the phone (all apps, the setup assistant, the lock screen, the admin panel). One file per language, loaded only when the language is chosen. |
| `locales/<code>.lua` | Everything outside the phone: in-game notifications, chat messages, command help, key-binding names, the phone shop blip and vendor prompt, the console replies of the admin commands. Generated from the matching `i18n-<code>.js`. |

The **key** of every entry is the original Portuguese text as it appears in the code; the **value** is the translation.
Never change a key: an entry whose key was edited no longer matches anything and the original text shows up instead.
`%s` / `%d` in a key are values filled in at run time and must appear in the translation too (`%1$s`, `%2$s` reorder them).

Shipped: `en`, `es`, `zh-Hans`, `zh-Hant`, `ja`, `fr`, `de`, `ru`, `pt`, `it`, `ko`, `nl`, `tr`, `pl`, `sv` and, since
1.1.8, `da` (Danish). Every language has the complete set of keys (the game-side `locales/*.lua` files were regenerated
in 1.1.8: a few admin command replies were only translated to English before).

**Adding your own language** (no build file needs to change):

1. Copy `html/js/i18n-en.js` to `html/js/i18n-<code>.js`, change the code in `I18N.add("en", {` and translate the values.
2. Copy `locales/en.lua` to `locales/<code>.lua`, change `Locales["en"]` to `Locales["<code>"]` and translate the values.
3. Add `'locales/<code>.lua'` to `client_scripts` in `fxmanifest.lua` (right after `'locales/da.lua'`).
4. Add the language to `Config.ExtraLanguages` in `config.lua`, e.g. `{ { code = 'no', name = 'Norsk' } }`. It then
   appears in the setup assistant and in Settings > General > Language, and `Config.DefaultLanguage = 'no'` is valid.

`/phonelang` (F8) prints which language the client is using and where it came from (config, admin panel, the phone).

## Integrations (garage, bank, society, housing, billing, dispatch)

The Garage, Wallet, Home, Bills and Services apps can work with the scripts your server already runs
(for example jg-advancedgarages, Renewed-Banking, ps-housing, esx_billing and common dispatch / MDT resources).
Set them in `Config.Integrations` (`'auto'` by default: the first supported resource that is started, otherwise the
phone's built-in behaviour). Nothing is a hard dependency: a stopped or failing resource falls back to the built-in
behaviour with one console warning.

- Full guide, supported resources and the provider interface: [`integrations/README.md`](integrations/README.md).
- Your own adapter: `integrations/custom.lua` (open in the escrowed build).
- The known providers in `server/integrations/*.lua` are also open, so you can adapt them.
- `/phoneintegrations` (admin or console) prints the active provider per category to the server console.

## Stolen / borrowed phones (optional)

`Config.StolenPhones.enabled = true` gives every phone item an owner (saved in the item metadata the first time
it is used). Whoever uses someone else's phone opens the owner's phone behind the owner's lock screen (passcode
only, Face Key never works for another person). Money, account settings, passcode, eSIM lines and reset are always
blocked on someone else's phone; what else is allowed (messages, social, calls, routing of incoming calls/SMS,
owner notification) is set in the same section. Needs ox_inventory or qb-inventory (per-slot metadata). Off by default.

## Physical SIM cards (optional)

`Config.PhysicalSim.enabled = true` moves the phone number onto a `sim_card` item that sits in the phone's SIM tray.
Move the SIM to another phone and the number goes with it; a phone without a SIM shows "No SIM" but still opens.
Photos, notes and settings stay with the phone. Insert / eject in Settings or by using the SIM card item; admins can
give cards with `/givesim [id] [number]`. Existing characters keep their number (it becomes a SIM inside their phone).
Turns on phone ownership too. Needs ox_inventory, qb-inventory, ps-inventory or lj-inventory and
`Config.RequireItem = true`. Add the `sim_card` item from `inventory_items.lua`. Off by default (can also be switched
in `/phoneadmin`, then restart `apex_phone`). One SIM per phone: the number in the phone in your hand is the one in use.

- **Contacts on the SIM** (`contactsOnSim = true`, the default since 1.3.0): the contacts live on the card as well, so
  whoever has the card in a phone sees them, and they survive a lost phone and a re-issued card. The first time a card
  is used with this on, the contacts of the account it belongs to are copied onto it (the phone keeps its own copy).
  `false` = contacts stay with the phone (the device owner's account), exactly as in 1.2.0.
- **Lost or stolen number** (`recover`, 1.3.0): a number belongs to the character it was issued to (shop, migration,
  starter SIM, eSIM card, `/givesim`). When that card is not in the player's hands any more (phone stolen, lost or
  destroyed), Settings > Mobile Service (PearOS) / Connections > SIM manager (Nova UI) shows **Recover my number**: the
  carrier cancels the old card for good and hands out a new SIM card with the same number (messages, calls and the
  contacts on the card come back), put straight into the phone in hand when its tray is empty. Whoever still has the
  old card loses the number at once and inserting it says "cancelled by the carrier". `price` (bank money, default 100),
  `free = true` (never charge), `blockOld` (cancel the old card for good; table `apex_phone_sims_blocked`),
  `enabled = false` (no player option). Admins: `/givesim [id] [number]` re-issues a number that belongs to that
  character for free (a number the player already has is refused). Export `RecoverSimCard(src, number)`; server event
  `apex_phone:simRecovered (src, number, oldIccid, newIccid)`; RPCs `psim.recoverable` / `psim.recover`.

## Radio app

A walkie-talkie inside the phone (`Config.Radio`, on by default). Players tune a frequency and talk to everyone on it
through your voice resource (pma-voice; SaltyChat and mumble-voip follow their public APIs and were not tested in game).

- Talk modes (`talkMode`): `'ptt'` hold to talk, `'toggle'` press to start / press to stop, `'open'` open mic with a
  mute toggle. `allowPlayerMode = true` lets each player choose.
- Default talk key: Caps Lock (`pttKey`), rebindable in the FiveM key settings.
- Restricted frequency ranges per job (and duty / ACE), private channels locked with a code, presets, callsigns,
  member list, optional earbuds or item requirement, radio animation.
- Exports: server `GetRadioChannel`, `SetRadioChannel`, `GetChannelMembers`; client `GetRadioFrequency`,
  `IsRadioTransmitting`, `GetRadioTalkMode`.

## Contact sharing

Share your contact card with nearby players from the phone, or with ox_target / qb-target ("Share contact" and
"Ask for contact" on other players). The receiver accepts or declines; each player chooses who may send them cards
(Everyone / Contacts only / Off). Settings in `Config.ContactShare`. Exports: `ShareContact(src, target)`,
`RequestContact(src, target)`; server event `apex_phone:contactShared`.

## Camera walking

`Config.CameraWalk = true` lets players walk, run and jump with the Camera app open (even with
`Config.AllowWalking = false`); looking around stays on dragging in the viewfinder.

## Wallpapers from links ("upload image")

There is no file picker inside the FiveM NUI, so images come in as links or by pasting:

- **Players:** Settings > Wallpaper > **Add image from link** (also the **Link** category of "Add new wallpaper" and the
  **Link** tile in the lock screen editor). Paste a direct image link (Discord, Imgur, Fivemanage, ...) and the phone shows a
  preview; "Use as wallpaper" applies it to the lock screen and the home screen. A copied image can also be pasted with
  Ctrl+V in that field: it is reduced like a photo, saved to Photos and used as the wallpaper.
- **Server owners:** `Config.Wallpapers` accepts links next to the file names: `'https://i.imgur.com/xxxx.jpg'` or
  `{ url = 'https://…', name = 'Los Santos' }`. Linked wallpapers appear in the wallpaper lists of both systems.
- `Config.WallpaperLinks = { enabled, hosts, maxLength, paste }` turns the player option off, restricts the hosts
  (`hosts = { 'cdn.discordapp.com', 'media.discordapp.net', 'i.imgur.com' }`) or forbids pasted images.

⚠️ Discord attachment links (`cdn.discordapp.com/attachments/...?ex=...`) expire after about 24 hours: the wallpaper stops
loading and the player has to paste a new link. For permanent wallpapers use files in `html/img/wallpapers/` or a permanent
image host (Imgur, Fivemanage, your own CDN).

## Photos from links (1.3.0)

The same door, in the Photos app: **Library > Add from link** (PearOS: the link button in the header and in the empty
gallery; Nova UI: Images > "..." > **Add from link**, and the empty gallery). The player pastes a direct https image link
or a copied image (Ctrl+V); the link is only accepted once the image really loads, and it is saved as a photo of the
gallery, so it can be shared, posted on Tweeter / Instashot, used as a contact photo or as a wallpaper. The photo info
sheet marks such photos as "External link".

`Config.PhotoLinks = { enabled, hosts, maxLength, paste }` has the same options as `Config.WallpaperLinks` (an old
`config.lua` without this table uses the WallpaperLinks values). `enabled = false` removes the option from Photos. The
`hosts` list is enforced by the **server** too (`photos.add` refuses other hosts with `{ error = 'host' }`), and it applies
to every link saved into a gallery, including a mail attachment or a received photo that is itself a link; with both
`PhotoLinks.enabled` and `WallpaperLinks.enabled` false the server refuses every http(s) link (`{ error = 'disabled' }`).
Discord attachment links expire after about 24 hours here too.

## Wallet transfers by number, server ID or citizen ID (1.3.0)

"Send" in the Wallet accepts a phone number, the server ID of a player who is online or a citizen ID (online or not;
read from the framework database). Before confirming, the phone asks the server who that is (`bank.resolve`) and shows
the name and what matched ("Number 555-0142", "ID 12", "Citizen ABC12345"); the transfer itself resolves the typed text
again on the server, so nothing is trusted from the client. The "I transferred you ..." text message is only sent when
the receiver has a phone number. Banking integrations (`Config.Integrations.bank`) keep receiving the citizen id and
the number as before (the number is `nil` when the receiver was given by ID and has no phone).

## Video calls (FaceCall) and `Config.VideoCall` (1.3.1)

FiveM has no player-to-player video, so in a FaceCall / video call each phone shrinks its own self-view to a small
JPEG and sends it through the server to the other participant. `Config.VideoCall` in `config.lua` sets how smooth that
picture is and how much network it uses; the phone, the client and the server all read their limits from that one
block, so a frame rate you set is never cut by the Lua rate limits.

- Defaults: `fps = 8`, `width = 144`, `height = 192`, `maxKB = 8`. That is at most 64 KB/s upload per player in a call,
  half of FXServer's 128 KB/s limit for client events (going over it kicks the player). `fps x maxKB` is capped at 96.
- The frames are cross-faded on the receiving phone, so 8 pictures per second look fluid. 1.3.0 sent 4 per second.
- `pipQuality` / `pipFps`: resolution and redraw cap of your own small window during the call (lighter on the GPU).
  The Live Photo button on the call screen still shoots at full resolution.
- If you raise `width` / `height`, raise `maxKB` too. For a picture that fills a tall phone screen without side
  cropping, try `width = 112, height = 240`. `fps = 4` gives back the 1.3.0 behaviour.
- Restart the whole resource after changing it: the server, the clients and the phone page must use the same values.

## Lock screen and home customisation (PearOS 27, 1.4.0)

Everything below is on the PearPhone (PearOS). The NOVA phones (Nova UI) keep their own editor. Nothing needs to be
configured: the choices are saved on the player's phone account like the other settings.

- **Gallery.** Hold an empty part of the lock screen for half a second (after Face Key or the passcode). The saved lock
  screens show under **Collections**, with page dots; the last card is **Add New** (a black card with a "+") and opens
  the wallpaper picker. Swipe a card up to delete it.
- **Customize.** In the editor the date, the clock and the widget row sit in thin frames. Drag the handle on the
  clock's bottom-right corner down or up to make the clock bigger or smaller (it gets taller past the screen width, like
  iOS). Tap the clock for the floating **Font & Color** card: fonts, weight (variable fonts), colours with a tint slider
  and a rainbow for any colour, **Glass / Solid**, and the globe button for the numeral system (Western, Arabic-Indic,
  Persian, Devanagari, Bengali, Gurmukhi, Gujarati, Tamil, Telugu, Kannada, Malayalam, Thai, Lao, Khmer, Tibetan,
  Burmese, Chinese). The "..." button sets alignment and position or resets the clock; the thumbnail changes the
  wallpaper of that screen; photo wallpapers get the styles Natural, Black & White, Duotone and Colour Wash (swipe the
  card).
- **Add Widgets.** Search, suggestions with the app icon on each widget, and one section per app. New lock widgets:
  Mail and Messages (unread count), Wallet (bank balance), Notes and Timer, next to the existing ones. Up to 4 places
  (a round widget takes 1, a wide one 2); the "-" on a placed widget removes it.
- **Controls.** The two buttons at the bottom of the lock screen show a "-" in the editor; an empty side shows a dashed
  "+". Tap a button for the controls gallery: search, flashlight, camera, phone, calculator, alarms, timer, notes,
  music, wallet, photos, dark mode, do not disturb, none, and **any installed app**. Dark mode and do not disturb work
  without unlocking; the others open after Face Key or the passcode, the camera opens straight away.
- **New wallpapers** (Add New): **Weather** (follows the in-game weather and time of day), **Astronomy** (Earth, Moon,
  Mars, Solar System), **Colour** (any hue, styles Vibrant, Tone, Deep, Vapour, Bright), **Emoji** (up to 6 emoji in a
  grid, rings, spiral or large) and **Photo Shuffle** (the player's photos or favourites, changing on wake, every hour
  or every day). They are drawn on the phone, so they cost no account space. Emoji use the Windows colour emoji font;
  where it is missing the wallpaper draws coloured confetti instead of empty boxes.
- **Home icons.** Home > Edit > **Customize** (or Settings > Display & Brightness > Icons): Default, Dark, Clear or
  Tinted icons, hue and saturation sliders for Tinted, three colours taken from the wallpaper and an eyedropper,
  Light / Dark / Auto, and small or large icons (large hides the names). Icons of other resources' apps follow the
  style when their image can be read; otherwise they keep their normal look.
- **Liquid Glass.** Panels, sheets and buttons use the iOS 27 glass materials (regular and clear, tinted, reacting to
  touch). Inside the game there is no live blur (it is not available in FiveM's browser): the glass shows a pre-blurred
  copy of the wallpaper, exactly as the rest of the phone already did.

## Camera video

The VIDEO mode of the Camera app records the viewfinder for real (WebM, VP8 + Opus) WITH SOUND from the player's
microphone when FiveM grants it (the first time FiveM shows a small microphone request in the corner of the game screen;
without the microphone the video is saved silent and the phone says why). The limits are PER PHONE: config_recording.lua
(Config.Recording) sets the length of a video and of a Voice Recorder recording for each model, item or system
(defaults: PearPhone Fold 60 s / 10 min, PearPhone 18 Pro Max and NOVA S26 Ultra 45 s / 5 min, NOVA Fold8 30 s / 3 min,
any other phone 15 s / 2 min). The server applies the limit of the device in the player's hand; the bitrate is chosen
from the size budget so a full-length video always fits. Videos are uploaded at a pace below FXServer's
rateLimiter_netEventSize_rate (default 128 KiB/s; going over it disconnects the player), so a 45 s video takes about a
minute to upload with the default convars: raise rateLimiter_netEventSize_rate / _burst to upload faster.
Videos stay in apex_phone_photos (up to 20 videos and 150 MB per character by default), play in the gallery with their
own player, can be shared with AirShare / Quick Share and published on Instashot (posts and stories), Reels and Twix.
`/rectest` prints a one-line recording diagnostic to F8 (`/rectest nomic` skips the microphone). The old
`Config.Camera.Video*` values are only used when `Config.Recording` is missing.

Everything below can also be changed live in `/phoneadmin` > Recordings:

- **Quality** (`Config.Recording.quality`): `standard` (640 px, 24 fps, about 0.37 Mbit/s, the old default), `high`
  (default: 720 px, 30 fps, about 1 Mbit/s, VP8) or `ultra` (1080 px, 30 fps, about 2.5 Mbit/s, VP9 with VP8 fallback,
  for servers that raised the rateLimiter convars). Any `video.height` / `fps` / `kbps` above 0 and `codec` other than
  `'auto'` win over the preset. With the default convars a 15 s video at `high` uploads in about 45 s and a 45 s video
  in about 2 minutes, in the background.
- **One video** is capped by `video.maxMB` (12 MB) and by MySQL's `max_allowed_packet`: the server checks it at start and
  warns in the console when it is too small (XAMPP ships 1 MB; MariaDB 16 MB, MySQL 8 64 MB are fine).
- **Who may record video** (`Config.Recording.permission`): `mode = 'all'` (default), `'ace'`, `'job'` or `'ace_or_job'`.
  ACE example: `add_ace group.journalist apex_phone.video allow`. Jobs: `jobs = 'police, weazel:2'` (`:2` = minimum
  grade). Checked on the server; without permission the VIDEO mode says why. Photos are never affected.
- **Videos on the social apps** (`Config.Recording.social`): one switch for all and one per place (Instashot posts,
  stories, Reels, Twix), plus the longest (`maxSeconds`) and largest (`maxMB`) video a post accepts. Publishing copies
  the gallery video on the server (nothing is uploaded again); other players see the cover first and download the
  video only when they play it (or the Reel is on screen), and it is cached on their phone.
- **Walking while filming:** with `Config.CameraWalk = true` (default) W/A/S/D, the arrows, Shift (run) and Space (jump)
  move the character with the Camera open and while recording, even with the mouse over the phone (on foot only).

## Vera AI assistant (optional)

Vera Chat uses the Google Gemini API. Without a key the rest of the phone works normally; only the Vera chat
and voice requests fail with a "no key" error. To turn Vera off completely set `Config.AI.enabled = false`.

1. Create a free API key at Google AI Studio (https://aistudio.google.com/app/apikey).
2. Put it in `server.cfg` (recommended, use `set` and never `setr`):
   ```
   set apex_phone_gemini_key "YOUR_KEY_HERE"
   ```
   or in `server/ai_key.lua` (`Config.AI.ApiKey`). The convar wins over the file.
3. Restart `apex_phone`.

Never put the key in `config.lua`: it is a shared script and every player downloads it.
Vera answers in the language of the asking player's phone (English, Spanish, German, ...), whatever language the
question was typed in.
Tune it in `Config.AI` (models, limits per player, voice wake word, `serverName` and `serverInfo`, the text the
assistant knows about your server). The free Gemini tier has a daily request limit; `Config.AI.voice.perDay` is a
server wide cap.

## Custom apps (an app of your own inside the phone)

**1.5.0: there is now an SDK.** Read [`docs/SDK.md`](docs/SDK.md) for the recommended way to build an app from
scratch: `sdk/apexphone-sdk.js` (one `window.ApexPhone` object: `ready`, `call` to your own server handlers, `storage`
per character, `notify`, `setBadge`, `sound`, the phone keyboard inside your page...), `sdk/apexphone-ui.css` (a UI kit
that makes your page look native on PearOS and Nova UI, light and dark), the server exports `RegisterAppRPC`,
`PushToApp`, `SetAppBadge`, `GetAppStorage` / `SetAppStorage`, and a complete example resource in
`sdk/example/apex_phone_example` (a "Taxi Rank" app with three tabs, a form, live pushes and settings). The
`postMessage` protocol below still works unchanged for apps written before 1.5.0.

Any resource can add an app to the phone. The app is a normal web page of your resource, shown inside the phone in an
iframe, and it talks to the phone with `postMessage`. Nothing of the phone has to be edited.

```lua
-- server, when your resource starts (it is re-sent to players who join later)
exports['apex_phone']:RegisterApp({
    id = 'myapp',                               -- letters, digits, _ - . : (up to 64)
    name = 'My App',
    url = 'nui://myresource/html/index.html',   -- your page (list it in your fxmanifest `files`)
    icon = 'nui://myresource/html/icon.png',    -- or { label = 'MA', color = '#FF9F0A' }
    category = 'Utilities', description = 'What it does', author = 'You',
    defaultInstalled = true,                    -- false = the player installs it from the AppShop
    job = 'police', minGrade = 2,               -- optional: only players with the job see the icon
    statusBar = 'auto',                         -- 'light' | 'dark' | 'auto' (status bar text colour over your page)
    wide = false,                               -- 1.1.8: true = on foldables the app gets the whole inner screen
})
```

**Size of your app (the question everybody asks).** The phone is drawn at a logical size and then scaled as a whole
with a CSS `transform` (`Config.Scale`, and Settings › Display on each phone). Your iframe therefore always sees the
same CSS pixels, whatever the player's scale: you never have to read the scale. The container is the full screen of the
device (the status bar is drawn over the top 68 px, the home indicator over the bottom 34 px: keep your own padding there):

| Device | `wide = false` (default): what your page sees | `wide = true` |
|---|---|---|
| PearPhone 18, NOVA S26 (every normal phone) | 440 × 956 | 440 × 956 |
| NOVA Fold8 closed | 440 × 956, centred on the 670 px outer screen | 670 × 956 |
| NOVA Fold8 open | 440 × 956, centred on the inner screen | 1340 × 956 |
| PearPhone Fold closed (PearOS draws apps 1.45× larger on the outer screen) | 356 × 659 | 294 × 659 (the side rail is reserved) |
| PearPhone Fold open (apps drawn 1.25× larger) | 356 × 659 | 868 × 765 |

These are `window.innerWidth × innerHeight` inside your page, measured in 1.1.8. So: design for **440 × 956** with
relative units (`%`, `vw`/`vh`, flexbox/grid) inside your own page and let it breathe a little; do not use
`transform: scale()` on your side. With `wide = true`, lay out for a width that can change and listen to your own
`window` `resize` event (the iframe is resized when the phone folds or unfolds) or to the `size` message below.

**What your page receives** (`window.addEventListener('message', e => e.data.apexphone …)`):

- `init` when it opens: `{ theme, dark, accent, player, account: { username, phone, avatar }, app,
  screen: { w, h }, form: 'bar' | 'fold', foldOpen, os: 'ios' | 'android', model }` (`screen`, `form`, `foldOpen`,
  `os`, `model` since 1.1.8).
- `size` (1.1.8) whenever the container changes: `{ screen: { w, h }, form, foldOpen, os, model }`.
- `theme` `{ theme, dark, accent }`, `player` `{ player }`, `resume` and `pause` (switcher), `rpc` `{ id, result }`,
  `contacts` `{ list }`, `location` `{ coords }`, `auraCommand` (a Vera command you registered).

**What your page can send** (`window.parent.postMessage({ apexphone: '…', … }, '*')`):

- `notify { title, msg }`, `toast { msg }`, `close`, `openApp { id }`, `setWaypoint { x, y, name }`,
  `call { number, name }`, `message { number, name }`.
- `getPlayer`, `getContacts`, `getLocation` (the last two ask the player's permission the first time).
- `rpc { name, data, id }` for the server RPCs listed in `Config.ExternalApps.rpc` (`contacts.list`, `photos.list`,
  `messages.send`, `bank.info`, `player.get`, `services.list`); the sensitive ones need the player's consent, which the
  server records.
- `widget { id, name, size, template: 'stat' | 'list' | 'progress' | 'text', data }` for a home-screen widget, and
  `activity { op: 'start' | 'update' | 'stop', id, title, subtitle, icon, progress, eta, state }` for a live activity in
  the Dynamic Island.
- `vera { pattern, reply }` to answer a sentence said to Vera (up to 20 per app).
- `typing { on }` (1.2.0): tell the phone that a text field of your page got (`true`) or lost (`false`) the focus.

**Keyboard inside your app (1.2.0).** With `Config.AllowWalking` / `Config.KeepVoice` the game keeps receiving the
keyboard while the phone is open, so letters typed into a field of your page could also fire the game's key mappings
(T opened the chat, M closed the phone...). The phone cannot see inside your iframe (it is another origin), so by default
it locks the keyboard for the game **for as long as your iframe has the focus**: typing is safe, and walking resumes as
soon as the player taps outside your app or closes it. If you prefer the player to keep walking while your app is open,
send `typing` yourself from your page and the phone will lock the keyboard only while one of your fields is focused:

```js
const tell = on => window.parent.postMessage({ apexphone: 'typing', on }, '*');
const isField = el => el && (el.matches('input, textarea, select') || el.isContentEditable);
document.addEventListener('focusin',  e => { if (isField(e.target)) tell(true); });
document.addEventListener('focusout', () => setTimeout(() => tell(isField(document.activeElement)), 50));
```

The phone's own look (fonts, colours, radii) is not injected into your page: style it yourself, and use `init.dark` /
`init.accent` to follow the player's theme.

## Exports (short list)

Server:

```lua
exports['apex_phone']:SendMail(citizenidOrNumber, { sender = 'Fleeca', subject = 'Receipt', body = '...' })
exports['apex_phone']:CreateBill(citizenidOrNumber, { senderName = 'LSPD', amount = 350, reason = 'Fine', society = 'police' })
exports['apex_phone']:SendNotification(src, { app = 'bank', title = 'Bank', msg = 'Payment received' })
exports['apex_phone']:SendMessage(fromNumber, toNumber, 'text')
exports['apex_phone']:GetNumber(citizenid) / GetCitizenId(number) / GetSourceByNumber(number)
exports['apex_phone']:OpenApp(src, 'messages') / ClosePhone(src) / IsPhoneOpen(src)
exports['apex_phone']:RegisterApp({ id = 'myapp', name = 'My App', url = 'nui://myres/html/index.html', icon = { label = 'MA', color = '#FF9F0A' } })
exports['apex_phone']:GetFramework()   -- 'qb' | 'qbx' | 'esx' | 'standalone'
-- 1.1.8: another phone system / SIM database / billing next to the phone
exports['apex_phone']:SetNumber(citizenidOrSrc, '555-0123', 'my_system')   -- true | false, 'format'|'same'|'noaccount'|'taken'|'db'
exports['apex_phone']:GetDeviceSerial(src)        -- 'APX-XXXX-XXXX-XXXX' of the device in use (needs Config.StolenPhones or Config.PhysicalSim)
exports['apex_phone']:GetDeviceLocations(citizenid)   -- { { item, label, serial, x, y, z, open }, ... } devices of the character held by online players
exports['apex_phone']:GetPlayerLines(src) / GetPlayerSim(src) / GetSimInDevice(serial) / GiveSimCard(src, number)
```

Server events: `apex_phone:accountCreated` (cid, number, src), `apex_phone:numberChanged` (cid, old, new, by),
`apex_phone:callStarted` / `callAnswered` / `callEnded`, `apex_phone:messageSent`, `apex_phone:billPaid` / `billRefused`.
A new account's number can come from your own system: `integrations/custom.lua` → `Custom.number.assign(cid, src)`
(see `integrations/README.md`, section 9). Bills from your own billing script: `Custom.billing`.

Client:

```lua
exports['apex_phone']:OpenPhone() / ClosePhone() / IsPhoneOpen() / OpenApp(id)
exports['apex_phone']:GetPhoneNumber() / StartCall('555-1234') / SetWaypoint(x, y, name)
exports['apex_phone']:SendNotification(app, title, msg)
```

Item exports used by the inventory: `apex_phone.useDevice`, `apex_phone.useEarbuds`, `apex_phone.useSlateBuds`,
`apex_phone.useEsim`.

## Troubleshooting

- **The console shows `syntax error near '<\1>'` for every file (and `attempt to index a nil value (local 'PI')`):**
  the server could not decrypt the protected files and tried to read them as plain Lua. It is an installation
  problem, not a script bug, and nothing in `config.lua` causes it. Since 1.5.1 the phone prints the reason and
  the steps in the console a few seconds after it starts (`server/integrations/escrow_check.lua`), including when
  the folder mixes two versions (an older `fxmanifest.lua` left behind). In short: (1) the hidden
  file `.fxap` in the root of the zip, next to `fxmanifest.lua`, has to be on the server, and FTP programs and
  file managers often skip it; (2) upload with transfer type Binary, never text/ASCII; (3) delete the old folder
  and upload a complete, fresh download from https://portal.cfx.re (Granted Assets) instead of copying some files
  over an older version; (4) `sv_licenseKey` must belong to the Cfx.re account that owns the asset; (5) keep
  `lua54 'yes'` in `fxmanifest.lua` and the server artifacts up to date; then restart the whole server.
- **Portuguese text shows up on my server (blip "Loja de telemóveis", a notification, a label):** the source language of
  the phone is Portuguese and a text falls back to it when the active language has no entry for it. Since 1.1.8 an
  unknown language code (`Config.DefaultLanguage = 'dk'`, an old account saved with a code that does not exist) falls
  back to English instead of Portuguese, the shop blip and the vendor prompt follow the phone language (and are renamed
  when it changes), every `locales/*.lua` carries the full key set, and Danish is included. If a Portuguese text still
  appears: it is a key missing from `html/js/i18n-<code>.js` (inside the phone) or `locales/<code>.lua` (in-game); add
  the Portuguese text as the key with your translation as the value, and tell us so we ship it. Never translate the
  keys themselves.
- **The phone does not open:** the player needs one of the device items (`Config.RequireItem = true`). Check the
  item names in your inventory match `Config.Devices`. Give one with `/phonegive`.
- **Tweeter does not post:** update first: below 1.3.1 photo posts never reach the server and the Publish button can close
  without posting. Then check, in order: (1) `server.cfg` connection string ends in `charset=utf8mb4`; (2) the phone
  tables are utf8mb4: `SELECT TABLE_NAME, TABLE_COLLATION FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND
  TABLE_NAME LIKE 'apex\_phone\_%' AND TABLE_COLLATION <> 'utf8mb4_unicode_ci';` For each one, back up, stop the server
  and run `ALTER TABLE apex_phone_posts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;` (with that table's name);
  (3) the database user can `SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX`; (4) `Config.Social.twix = true` and
  "Tweeter" is on in the admin panel ("Redes e extras"). The phone shows a code under "Not published" and the server console prints
  `social.post refused for <player> (id, app): <code>`: `noprofile` no account, `noplayer` character still loading, `off` network
  disabled, `ratelimit` too many requests, `timeout` no answer (check whether the post appeared), `db` database starting,
  `dbschema` old tables (run the ALTERs printed at boot), `dbdenied` missing permission, `dbcharset` steps 1-2,
  `dbcollation` step 2, `dbbusy` database overloaded, `foreign` / `locked` someone else's phone or locked phone.
- **Old key still opens something else / F1 does nothing:** FiveM stores key binds per command name in each
  player's profile. The key can be changed in Settings > Key Bindings > FiveM.
- **No framework detected (console warning at start):** start `apex_phone` after your framework, or force `Config.Framework`.
  Since 1.1.5 the phone keeps waiting (up to 10 minutes, with a warning every minute) and attaches itself the moment
  the framework starts, so a wrong start order only delays the phone instead of leaving it without a framework.
- **The phone shows the setup assistant ("Hello") again after a restart, as if it had been reset:** fixed in 1.1.5.
  Right after a restart the database can be busy with the schema checks and the first `account.get` could time out;
  the phone read that as "no account" and opened the assistant. Finishing it never overwrote the real account (it was
  restored with a toast), but it looked like a reset. The phone now opens the assistant only when the server explicitly
  answers that the character has no account; a slow or missing answer makes it wait and retry. The start-up schema
  checks also run in two queries instead of about a hundred, so the database is ready much sooner.
- **Database errors on start:** make sure `oxmysql` starts first and the database user can `CREATE` and `ALTER` tables.
  The full schema is in `installation/apex_phone.sql` (reference / manual install): every statement is
  `CREATE TABLE IF NOT EXISTS`, so it is safe to run on an existing database. Running it is optional, the resource
  creates and migrates the tables by itself on start.
- **Tapping Instashot, Tweeter (or Match, Marketplace, Maps, Eats, Services, Weather, Recado) does nothing, no error:**
  before 1.1.7 those apps asked for their permissions (photos, camera, location, contacts) when opened, and one
  "Don't allow" was saved in the account and blocked the app from opening for good: the tap only showed a 2-second
  toast at the bottom ("No access to Photos. Turn it on in Settings > Privacy"), easy to miss, and on a foldable's
  cover screen even more so. Since 1.1.7 a refused permission never blocks the app (like a real phone: the app opens,
  only that feature is unavailable); the player can still change it in Settings › Privacy. Players already affected
  are unblocked by the update without doing anything.
- **Instashot / Tweeter / Reels show "Create account" again, "Name in use", or an empty feed with no error:** that was
  the phone hiding a server answer such as "database still starting" or "too many requests" (1.1.5 and older).
  Since 1.1.6 the apps show the reason with a retry button. If it keeps happening, open the server console: an RPC
  error is printed there in red with the SQL message.
- **No call audio:** check `Config.Voice` and that your voice resource starts before `apex_phone`. Type `/phonevoice`
  in game: it prints the detected voice system, the call channel and, with pma-voice, whether `voice_enableCalls` is on.
- **"At times the voice stops working" / a call has no sound once in a while (1.1.7 and older):** three causes, all
  fixed in 1.1.8. (1) The client kept an old call marked active when its "ended" message was lost, so every later call
  skipped the voice channel until the player relogged: the client now follows the server's call state (a watchdog
  compares both every 2 s and re-joins or leaves the channel; the server answers `calls.sync`). (2) pma-voice could
  ignore the `addPlayerToCall` request (sent before the player was ready, `voice_enableCalls` off): the phone now
  verifies the channel was taken and retries twice, then prints the reason in F8. (3) With `Config.KeepVoice` the game
  kept receiving the keyboard while the player typed in the phone, so letters reached the game's key mappings: `T`
  opened the chat, and the chat, when closed, took the NUI focus away from the phone (no ESC, no push-to-talk). The
  phone now tells the game when a text field is focused and takes its focus back if another resource drops it.
- **The phone sometimes does not open or does not close (cursor stuck):** usually the NUI focus was taken by another
  resource (see above), or the shop / admin layer stayed marked open after the page closed it. Both heal themselves in
  1.1.8 (focus watchdog, ghost-overlay reset when the phone is opened), and `/phonefix` resets everything at once.
- **Nobody can talk while the phone or the phone shop is open:** that is `Config.KeepVoice = false` (or a 1.1.3 or
  older build). With `Config.KeepVoice = true` (default since 1.1.4) the push-to-talk key keeps working with the
  phone and the shop open; the player just cannot move while the phone is open unless `Config.AllowWalking` is on.
- **Props invisible or the client freezes:** do not run another resource that streams the same models
  (`apex_pear18_*`, `apex_s26_*`, `apex_fold_*`, `apex_airpod_*`, `apex_slate_*`, `apex_esim_card`).
- **Map tiles do not load:** the Maps app downloads tiles from the internet (`Config.Map.tileUrl`); GPS and
  waypoints still work offline.
- **Vera does not answer:** set the Gemini key (see above) and check the server console for the API error.
- **Shop item missing:** run `phoneshop_items` in the server console; it lists catalogue items that do not exist
  in the inventory.
- **QBCore: the phone item shows its picture in the "item received" box but the inventory slot is blank:** qb-inventory
  (and ps-/lj-/qs-inventory) load the icon from their own `html/images/<image>`; a `nui://apex_phone/...` address or a
  PNG that was never copied there gives a blank slot. Run `phoneitems` in the server console: it names the item and the
  fix, and copies the missing PNGs itself (then `restart qb-inventory`). See "Inventory items".
- **Nobody hears a phone ringing / the speaker button does nothing:** `Config.WorldSounds` (1.2.0) must be enabled;
  the ringing phone must not be on silent. The speakerphone needs pma-voice or mumble-voip (SaltyChat keeps its own
  phone speaker). `phonesounds` in the server console shows the state and who is listening.
- **Alt does not look around:** since 1.2.0 the phone page itself listens for Alt, so it works whatever
  `Config.AllowWalking` / `Config.KeepVoice` say; if you changed `Config.LookKey` to another key, that key only works
  through the FiveM key mapping (Settings › Key Bindings) and only when the game receives the keyboard.
- Turn on `Config.Debug = true` and read the server console and F8 for details.

## Liquid Glass (PearOS 27) and Nova UI 9 (1.5.0)

- **PearOS 27.** Every piece the real system draws in glass is glass here too: dock, folders, lock screen buttons and
  keypad, notifications, Control Center, tab bars (with the capsule that slides between tabs), navigation bar buttons,
  menus, alerts, sheets, action sheets, toasts, keyboard keys, the app switcher and Spotlight. The material has the
  September 2026 look: a lens at the edges, a darker rim, brighter highlights, a soft shadow, a weak tint, and it
  switches between light and dark by itself from the wallpaper under it. Pieces light up from under the finger when
  pressed. Inside the game the effect is built from pre blurred copies of the wallpaper (no `backdrop-filter`, which
  the FiveM browser cannot do), so it costs nothing per frame.
- Settings > Display & Brightness > **Liquid Glass**: the slider goes from ultra clear to fully tinted, with a live
  preview. Settings > Accessibility: **Reduce Transparency** (frosted, opaque glass) and **Increase Contrast**
  (strong outlines and opaque fills) really change the material.
- Over a light wallpaper the lock screen clock, date, status bar and home labels switch to a dark tone on their own
  (unless the player picked a clock colour in the lock screen gallery).
- **Nova UI 9.** New Quick Panel with resizable toggles (1x1 or 2x1, drag the handle in edit mode), glass outlines,
  sound output and devices cards; translucent volume, power menu and menus; floating bottom bars in the system apps;
  lists that fade at the edges when they scroll; Settings with the search bar at the bottom; app drawer with the
  search on top and a sort pill; Material 3 Expressive touches (shape morphing on press, FAB style, spring curves);
  icons with more depth.

## Arcade (1.5.0)

The Arcade app is a Game Center: a Games tab (hero with the cover art of the game, Daily Challenge, rows of covers
per category, "Continue"), a page per game (cover, modes, how to play, your stats, the server podium and the
achievements of that game), a Leaderboards tab (per game and mode, all time, this week and friends, a podium for the
top 3, your rank and the top 100 of the server) and a Profile tab (level and XP, games played, time, online wins,
50 achievements, matches in progress, "Challenge a contact"). Arcade Settings (gear in the hub or in the pause menu):
game volume, vibration, left handed controls, reduce effects. Scores are stored on the server
(`apex_phone_arcade_scores`) with sane limits per board in `config_arcade.lua`, so a modified client cannot invent
tables. Level, XP and achievements follow the character to any PC (synced with the other phone data).

23 games, each with its own art direction, cover and icon, a "How to play" card on the first run, a 3, 2, 1
countdown in the reflex games, touch, swipe and physical keyboard controls, pause when you leave, sounds, particles,
hit stop and slow motion on the big moments, and a result panel with your record, your rank, XP, game stats and the
server podium:

- **Classics:** Snake (continuous body, golden fruit; Classic, Portal, Fast), 2048 (4x4 and 5x5, undo), Blocks
  (modern rules: 7-bag, wall kicks, hold, next 3, ghost, lock delay, T-spins, combos, back to back; Marathon,
  Sprint 40 lines, Ultra 2 minutes), Mines (3 sizes, long press flag, chording, safe first tap), Break (neon, 12 levels,
  8 power-ups including laser and multiball), Memory (3 illustrated decks; 8, 12, 18 pairs and Against the clock).
- **Board (vs the phone, two players on one phone, online):** Chess (5 named opponents, 3 board themes, move list
  with the opening name, hint, flip, clocks with increment, daily "Mate in 1"), Checkers (5 opponents, hints),
  Connect Four (column preview, series, undo), Tic Tac Toe (best of five and the new Ultimate mode).
- **Puzzle:** Sudoku (4 levels including Expert, explained hints, check, daily puzzle), Words (daily, unlimited and a
  90 second Rapid mode, hard mode, share as blocks, EN and PT with accents), Solitaire (felt table, real cards,
  Standard and Vegas scoring, auto finish and the classic bouncing cards win), Lights Out (25 hand made levels plus
  endless generated ones, 5x5 and 6x6), Sliding Puzzle (4 illustrations or numbers; 3x3, 4x4, 5x5).
- **Action:** Glide (day and night parallax; Classic, Night, Hard), Rocks (neon, shield, triple shot, hyperspace),
  Runner (power-ups: magnet, double points, glider), Hop (voxel roads, rivers and trains, 3 characters to unlock),
  Pong (neon, games to 7 or 11), Air Hockey (LED scoreboard), Slice (8 fruits cut along the blade; Classic, Arcade,
  Zen), Stack (isometric; Classic and Fast).

**Online matches.** Connect Four, Tic Tac Toe, Chess and Checkers can be played against another player: invite a
contact (a message with an "Open" card is sent) or someone near you (`Config.Arcade.nearbyRange`). The server keeps the
board, alternates the turns, runs the 45 second clock and decides the result (it validates every move of Connect Four
and Tic Tac Toe; for Chess and Checkers both phones validate). Leaving counts as a loss. Pong and Air Hockey also have a
two players on one phone mode.

## New apps (1.5.0)

- **Fitness** (Health on Nova UI): three rings (Move, Exercise, Steps) counted from what the character really does in
  the game (walking, running, driving; steps and calories are estimates from the distance), 14 day history, goals,
  12 awards, home widgets. The client reports every 60 s and the server caps what one minute can physically be.
- **Journal:** entries with text, mood, a photo from the gallery, the place and the weather; favourites, search, a
  timeline by month and suggestions ("Write about your day", "Today's photos", "Places").
- **Stocks:** a simulated market with 14 fictional Los Santos companies, news that move the prices, 1 day / 1 week /
  1 month charts, buy and sell with the bank account (`Config.Stocks.fee`), portfolio, watchlist, price alerts and a
  home widget. The market runs on the server and is the same for everybody.
- **Translate:** between the 16 languages of the phone with the Gemini key of `Config.AI` (`Config.Translate.perDay`
  per character), a two way Conversation mode, an offline phrasebook of 120 role play phrases (PT, EN, ES, FR, DE, IT),
  favourites and history. Without a key the app says so and the phrasebook still works.
- **Voice Memos:** record with the microphone up to the limit of the phone in hand (config_recording.lua), pause and
  resume, live waveform, player with speed, rename, favourites, share to Messages and Zapp as a voice message.
  Installed on every phone and every account (system app).
- **Tips:** 11 collections and 62 tips about the phone, each with an illustration and a "Try it" button that opens the
  right screen; the Android tips talk about the drawer, the Quick Panel and the Edge panel.

All six are installed by default on new accounts and can be removed or reinstalled from the AppShop / NOVA Store.

## Known limitations

- Videos are not sent through Messages, Mail or Recado yet (they go to the social apps and AirShare / Quick Share), and
  the game cursor can appear in the recording if it crosses the middle of the screen while recording.
- Voice messages depend on the FiveM CEF granting microphone access.
- Recado video calls are simulated and messages are not end to end encrypted (they are stored in the database).
- Fonts included in `html/fonts/` are licensed under the SIL Open Font License 1.1 (license files next to them).

## Changelog

### v1.5.3
- Fix: Music > "Play in car" and the CarLink catalogue did not link with **Apex Car Radio**. The head unit was renamed
  from `apex_carplay` to `apex_carradio` (its 2.1.2) and the phone still looked for the old resource name and the old
  event names, so it answered that the head unit was not running. The phone now uses whichever of the two is running,
  checked every time, so it also works when the head unit starts after the phone.
- `Config.Music.Provider` accepts `'apex_carradio'` (`'apex_carplay'` keeps working and means the same thing).
- New: `Config.Music.CarResource` (default `'auto'`). Only set it if you renamed the head unit's folder yourself.
  Add it to your `config.lua` if you keep your own; without the line the phone behaves as `'auto'`.
- The on-screen messages that named the resource say `apex_carradio` now (all 15 languages).

### v1.5.2
- Fix: AppShop / NOVA Store app pages in other languages. The description and the editorial line under it were glued
  into one text, which no dictionary entry matches, so most apps showed their Portuguese description in every language
  (and apps without an editorial line showed the description twice). They are separate now and translate.
- Fix: the translator no longer damages Portuguese text it has no entry for. The date pattern `%s de %s de %s` (made
  for dates) removed every "de" from any untranslated sentence ("Conversas privadas e grupo, mensagens voz"), and short
  connector patterns such as `%s para %s` rewrote long sentences ("offline to o dia a dia"). Such patterns now only
  apply to short texts (names, numbers, short lists); dates still format through `L.tf`.
- Fix: app page Info > Language (and the info strip) said "Português" on every phone; it shows the phone's language.
- Fix: the short subtitle taken from the first sentence of a description ("Deixa cair os discos e alinha quatro")
  is only used when it has a translation; otherwise the genres / category show.
- Fix: police and other Services requests. The dispatch / MDT alert (ps-dispatch, cd_dispatch, apex_mdt...) received
  the Portuguese label ("911 - Polícia"); it now goes out in `Config.DefaultLanguage` (the 15 `locales/*.lua` load on
  the server too), a label of your own goes out as written and the new optional `dispatchLabel` on a service sets it
  yourself. On the officers' phones the notification said "New request · Polícia", and the request sheet, the
  "nobody on duty" alert and "You're on duty as ..." kept the Portuguese service name: all translated now.
- No database or config changes needed (config.lua only gained comments).

### v1.5.1
- New: `server/integrations/escrow_check.lua` (readable). When the server cannot decrypt the protected files, the
  console used to show only one `syntax error near '<\1>'` per file. The phone now explains it a few seconds after
  the start, and once more a minute later: whether the folder mixes two versions (`fxmanifest.lua` from an older
  install), whether `lua54 'yes'` is gone from the manifest, and the steps to fix the installation (see
  Troubleshooting). It sits in `server/integrations/` so that even an old manifest loads it. It prints nothing
  when the phone loaded normally and does nothing in the open source build.
- Fix: the six provider adapters in `server/integrations/` no longer add `attempt to index a nil value (local 'PI')`
  errors on top when `server/integrations.lua` did not load.
- No database, config, locale or NUI changes: replace the folder and restart.

### v1.5.0
- New: Liquid Glass as in PearOS 27 on every glass component (dock, folders, lock screen buttons and keypad,
  notifications, Control Center, tab bars with a sliding capsule, navigation bar buttons, menus, alerts, sheets, toasts,
  keyboard, switcher, Spotlight): lens at the edges, darker rim, brighter highlights, light/dark that follows the
  wallpaper, glow under the finger, "hard" scroll edge effect. Settings > Display & Brightness > Liquid Glass slider
  with a live preview; Accessibility > Reduce Transparency and Increase Contrast. Lock screen clock, date, status bar
  and home labels turn dark over light wallpapers. See "Liquid Glass (PearOS 27) and Nova UI 9".
- New: Nova UI 9 refresh: Quick Panel with resizable toggles, glass outlines and device cards, translucent volume
  and power menu, floating bottom bars in the system apps, lists that fade at the edges, Settings search at the
  bottom, app drawer with the search on top, Material 3 Expressive press morphing, deeper icons.
- New: Arcade as a Game Center (featured game, filters, server leaderboards all time / this week / friends, profile
  with 24 achievements, challenges to contacts) and 17 new games: Chess, Checkers, Sudoku, Words, Solitaire, Connect
  Four, Tic Tac Toe, Lights Out, Sliding Puzzle, Glide, Rocks, Runner, Pong, Air Hockey, Slice, Stack, Hop. The six
  games that already existed were rebuilt (tap to start, keyboard, difficulties, particles, sounds). Online matches
  by turns (Connect Four, Tic Tac Toe, Chess, Checkers) with invites by contact or proximity, a 45 second clock and
  server side rules. `config_arcade.lua`, tables `apex_phone_arcade_scores` and `apex_phone_arcade_stats`.
- Arcade, second pass on every game: own art direction, pre-rendered sprites, cover art and "How to play" for the 23
  games, new modes (2048 5x5, Blocks Sprint and Ultra, Memory 18 pairs and Against the clock, Sudoku Expert, Words
  Rapid, Lights Out 6x6, Sliding 5x5 and pictures, Glide Night and Hard, Slice Arcade and Zen, Stack Fast, Tic Tac Toe
  Ultimate, Chess daily puzzle), hub with covers, game pages, Daily Challenge, podiums, level and XP, 50 achievements and
  Arcade Settings. New boards in `config_arcade.lua`: `g2048:5`, `blocks:sprint`, `blocks:ultra`, `memory:18`,
  `memory:clock`, `sudoku:perito`, `words:rapido`, `lights:6`, `sliding:5`, `glide:dificil`, `slice:arcada`,
  `slice:zen`, `stack:rapido` (no SQL change: boards are rows of the same table).
- New apps: Fitness (Health on Nova UI), Journal, Stocks, Translate, Voice Memos and Tips, each with its own
  `config_<app>.lua`. See "New apps (1.5.0)".
- New: Voice Recorder on every phone (system app, existing accounts get it too); real video recording with sound,
  per-phone time limits (`config_recording.lua`, `/phoneadmin` > Recordings), uploads paced under the FXServer event
  limiter (fixes players being disconnected while saving a video), gallery video player with seek bar, `/rectest`.
- New: PearOS follows iOS 27.2 (version shown as PearOS 27.2): tab bar with the search inside the capsule, alerts with
  capsule buttons, action lists that open from the button you tapped, menus with the glyph first, sheets with round
  close and done buttons, Control Center with + and power on top, notifications grouped per app, Settings search at
  the bottom, Liquid Glass slider under Appearance. Nova UI follows One UI 9: filled Quick Panel toggles, thick
  sliders, media player with the wave, search pill on the home screen, drawer search at the bottom, dialogs in the
  text colour, compact Settings, battery number always inside the icon.
- New: SDK to build your own app from scratch: `sdk/apexphone-sdk.js`, `sdk/apexphone-ui.css`, server exports
  `RegisterAppRPC` / `UnregisterAppRPC` / `PushToApp` / `SetAppBadge` / `GetAppStorage` / `SetAppStorage`, per
  character storage for external apps (`apex_phone_app_kv`), badges, sounds and haptics, the phone keyboard inside
  your page, a complete example resource and the guide `docs/SDK.md`. Apps registered the old way keep working.
- `apps.registry` now filters registered apps by the player's job on the server (before, only the live push did).
- Removed the `dependency '/assetpacks'` line from the manifest (Keymaster adds it to the escrowed download by itself).
- AppShop and NOVA Store redesigned. AppShop: Liquid Glass on the controls that float over the content (account,
  back and share buttons, the search field, Get/Open capsules, the app strip over the story art, Play for free),
  ambient light in the colour of the app on top of every tab and app page, "hard" scroll edge bar, category tiles with
  clear glass labels, deeper icons, iOS 27 dark mode. NOVA Store: top bar that gains material when you scroll,
  translucent search pill, cards with a thin glass outline, translucent app strip over the featured art, Material 3
  Install/Open capsules. Same catalog, install flow, search and ratings as before.
- The phone shop and the `/phoneadmin` panel are no longer full screen: both are glass windows over the game, in the
  style of the Apex Inventory (tinted header band, recessed trays, framed tiles, dark buttons with a brand outline).
  The shop keeps the 3D viewer inside a framed stage, with the catalog on the left and the product sheet, payment and
  hold to buy on the right. Default colours are Apex blue on the Apex dark grey glass (#131314), with plain trays
  (no dot grid).
- Admin > Appearance now sets, for the shop and for the panel: brand colour, background colour, glass opacity (60 to
  100 %) and whether the game is blurred behind the window, with 8 ready-made palettes, a live preview and
  "use the same" buttons. Players see the new colours as soon as you save. Old saved colours keep working.
- The phone shop now comes with one location by default, West Vinewood (`vec4(-505.32, 288.64, 83.29, 95.58)`). The
  Little Seoul and Legion Square shops were removed from `Config.Shop.shops`; add more there or in /phoneadmin.
- Shop blip: the default icon is now 817 (a phone handset) on every game build. 899 (smartphone) showed as a plain
  round dot on servers where a HUD or blip script streams its own older `minimap.gfx`; you can still set
  `spriteModern = 899` in `Config.Shop.blip` if nothing on your server replaces the minimap.
- Fixed: Camera VIDEO (and Time-lapse) said "The image came out black" and threw the video away while the viewfinder
  showed the game. Inside FiveM, reading the viewfinder's WebGL pixels between two draws returns zeros, so every frame
  was counted as black. Each recorded frame is now drawn and copied in the same step (like a photo), and a frame is
  only skipped when two different checks both see black.
- Camera video quality: new presets (`standard`, `high` = new default at 720 px / 30 fps / about 1 Mbit/s, `ultra`),
  a smoother frame pump (30 real frames per second instead of about 21, no stutters) and a 150 MB video space per
  character. All of it, plus who may record video (ACE and/or jobs), lengths per phone, sound, upload pace and the
  social switches, is in `/phoneadmin` > Recordings.
- Videos can be published on Instashot (posts and stories), Reels and Twix from the gallery and from each composer.
  Reels now shows video posts and posts tagged #reel. New table `apex_phone_social_videos` (created on start; also in
  `installation/apex_phone.sql`).
- Walking with the Camera open and while recording now works with the mouse over the phone.
- Fixed: `photos.add` with a video now goes through the recording permission and limits too.
- The phone page cache version is now ?v=133.

### v1.4.1
- New: Tweeter now looks like the X app: black or white feed, X logo, "For you / Following" tabs, posts with display name,
  @handle, verified badge and the reply / repost / like / views / bookmark / share row, floating compose button, bottom
  bar (Home, Search, Vera, Notifications, Messages), full-screen compose with the 280 ring, quote, reply box, profile
  with banner and tabs, search with trends and an X-style sign-up. Tweeter direct messages use the Instashot DM screen.
- Tweeter posting: Publish works with the on-screen keyboard, held, with the field focused or not, with Enter (Shift+Enter
  is a new line), with only a photo and with emoji. Fast repeated taps make one post. A refused post keeps the draft and
  shows the reason and a code; a request that never answers gives up after 20 seconds. A refused comment keeps its text.
- Drafts are kept: the Tweeter composer and the reply box save the text, location and photo while you type, so closing the
  phone, the back button or a refused post never lose it. Cancel with text offers Delete or Save draft. A photo shared from
  Photos now waits for the app (slow server or first sign-up). Repost can be undone, reposts cannot be duplicated, likes and
  replies on a repost act on the original, Search shows who you already follow and Notifications lists replies, quotes,
  reposts, likes and follows.
- Fixed, on the server: an emoji in a bio or comment blocked account creation or the comment when the connection or the
  table is not utf8mb4 (now saved without the emoji, and the console says which one to fix); a posts table with an old
  collation made every feed fail while posts saved; a character still loading saw "Create account" and was refused;
  a database user without ALTER left Tweeter closed with a bare "internal"; long names and bios cut in the middle of
  a character; two taps on Create account. SQL errors now reach the player as a code and the console as one line with
  what to do. See "Tweeter does not post" under Troubleshooting.
- Lock screen editor: controls gallery with sections (Capture, Connectivity, Display, Focus, Ambient Music, Apps) and
  more controls (record video, airplane mode, Wi-Fi, Bluetooth, mobile data, eye comfort, low power, work and sleep
  focus, ambient music); drag and mouse wheel to frame a photo wallpaper; non-Latin clock digits fill the clock frame; the
  foldable editor has separate date and clock frames and keeps the frame in view while a sheet is open.
- Home: Clear and Tinted also restyle the home widgets, like iOS.
- The phone page cache version is now ?v=123.

### v1.4.0
- New: the PearOS 27 lock screen editor, like iOS 26/27. Gallery with Collections, page dots and an Add New card;
  clock size handle (drag to make the clock bigger or taller); floating Font & Color card with fonts, weight,
  colours, tint and rainbow sliders, Glass / Solid and 17 numeral systems; date and clock frames, "-" badges and a
  dashed "+" for empty places; bottom row with the wallpaper thumbnail, photo styles and a "..." menu. See "Lock screen
  and home customisation".
- New: Add Widgets with search, suggestions, app icons and per-app sections. New lock widgets: Mail, Messages,
  Wallet, Notes, Timer.
- New: controls gallery for the two lock screen buttons, with search, more controls (wallet, photos, dark mode, do not
  disturb) and any installed app.
- New: Weather, Astronomy, Colour, Emoji and Photo Shuffle wallpapers (the picker categories that said "coming soon").
- New: home icon styles Default / Dark / Clear / Tinted with hue, saturation, wallpaper colours and an eyedropper,
  Light / Dark / Auto, and large icons. Home > Edit > Customize, or Settings > Display & Brightness > Icons.
- New: Liquid Glass materials (regular / clear, tinted, interactive, merged segments) on the new panels, the gallery
  buttons and the lock screen buttons. In game they use the pre-blurred wallpaper copy (no live blur in FiveM).
- Fixed: the home screen "Blur" option and the automatic colour of the home "Colour" / "Gradient" options never
  produced a result (two helper functions had the same name and the wrong one won).
- Fixed: in the lock screen gallery/editor, a tap on the widgets frame (or the clock / controls) could open an invisible
  notification instead: the passcode keypad appeared inside the editor card and the notification opened on the next
  unlock. Notifications no longer take taps while the gallery is open, and the keypad never opens on top of it.
- Fixed: the Calculator lock screen button showed its icon off-centre (its class collided with the Calculator app).
- The phone page cache version is now ?v=122 (players get the new files without clearing the FiveM cache).

### v1.3.1
- Fixed: "I can't post anything on Tweeter". With the on-screen keyboard up (the default in game), a click on
  Publish / Share / Save that was held for more than a moment either closed the sheet without posting (text lost) or
  did nothing. The sheet buttons no longer take the focus from the text field, the backdrop only closes the sheet when
  the press started on it, and the keyboard waits for the mouse button to be released before going down. This affected
  every sheet with a text field (Tweeter, Instashot, edit profile, comments).
- Tweeter / Instashot: publishing keeps the sheet open ("Posting…") until the server accepts. On a refusal the draft
  stays and the alert shows the reason code; the server console prints one line per refused post
  (`social.post refused for <player> (id, app): <code>`) and F8 shows the code. An empty post says "Write something
  first.". After a character switch or a phone reset the apps no longer reuse the previous account (no more endless
  "You don't have an account on this network"), and that message now really closes the app so it asks again.
- Any alert now releases the text field before it opens, so the keyboard never covers it (on Nova UI the OK button was
  hidden behind the keys).
- Comments (Instashot and Reels): the comment field is pinned to the bottom of the sheet, stays focused after sending
  and the sheet re-fits above the keyboard after every new comment.
- Fixed: Instashot DMs, "it won't let me click on the text box". The Instashot tab bar was drawn over the whole
  message bar on every phone (PearOS and Nova UI), so every click landed on a tab. Both DM screens now hide the tab bar.
- New: Instagram-style Instashot DMs in light and dark. Inbox with search, unread and active dots and a camera
  shortcut on each row; conversation with a header (avatar, name, "Active now", tap to open the profile), a profile
  card at the start, grouped bubbles with the avatar on the last one, time separators, large emoji, full-screen photos
  with save, "Seen" / "Sent" under your last message (live), and a message bar with the camera, microphone, gallery,
  quick emojis and a blue "Send". A message is only marked as read while the receiver really has the conversation open.
- Fixed: Space did nothing in the admin panel's text fields ("Job apps" creator, "Shop" section, search, JSON import).
  The 1.2.0 Space guard for `Config.AllowWalking` treated the page as hidden whenever a panel was open (the phone is
  always put away first). Space on phone buttons and switches is still blocked while walking with the phone open. The
  shop gives up its keys when the admin panel is opened on top of it, and the panel then turns keep input off so typed
  letters never reach other resources' key bindings.
- Improved: FaceCall / video call picture. 8 smaller frames per second with a soft cross-fade instead of a 4 fps
  slideshow, in the same network budget; the self-view window renders at half resolution and at most 30 times per
  second; frames are sent without waiting for each other and back off when the client limits them. New
  `Config.VideoCall` (see "Video calls (FaceCall)"). Both players and the server need 1.3.1.

### v1.3.0
- Fixed: "I can't post on Tweeter". Tweeter, Instashot and Reels sent the whole photo (100-260 KB of base64) inside a
  single `social.post` network event, which FiveM drops: the request never reached the server, the phone waited 10 s and
  said "Not posted". Only text posts worked. A post now references the gallery photo (`photoId`; the server copies the
  image from the player's own gallery, ownership checked), the response never carries the image back, and the feed
  keeps reading images in chunks as before. Clear messages for a photo that is no longer in the gallery, a video, or a
  server that did not answer.
- New: Photos > Library > **Add from link** on both systems (`Config.PhotoLinks`), with the host whitelist now enforced
  by the server as well (`photos.add`). See "Photos from links".
- New: Physical SIM: **Recover my number** (`Config.PhysicalSim.recover`): a lost or stolen number is re-issued on a new
  card, the old card is cancelled for good (`apex_phone_sims_blocked`), `/givesim [id] [number]` re-issues for the
  rightful owner, export `RecoverSimCard`, event `apex_phone:simRecovered`.
- New: Physical SIM: **contacts on the SIM** (`Config.PhysicalSim.contactsOnSim`, on by default): the contacts follow
  the card (and survive a re-issue); the account's contacts are copied onto the card the first time it is used.
- New: Wallet transfers accept a phone number, a server ID or a citizen ID, with the receiver's name shown before
  confirming (`bank.resolve`). See "Wallet transfers".
- Admin panel: the new Physical SIM options (contacts on SIM, recovery on/off, price, cancel old card).

### v1.2.0
- New: a valet brings the vehicle. "Request Delivery" in the Garage app (`Config.GarageDelivery.mode = 'valet'`, the
  default) creates the vehicle on a road out of sight and a valet NPC drives it up to the player, gets out and walks
  away; the phone announces the arrival. When the valet cannot reach the player (blocked road, no path, player kept
  moving) the vehicle is moved to the nearest free road and the phone says so. `mode = 'road'` keeps the 1.1.9
  behaviour. `phonedelivery` prints the mode.
- New: phones are heard around them (`Config.WorldSounds`). The ringtone, message / notification chimes and alarms of
  a phone play for the players nearby, fading with distance; a phone on silent makes no sound for anybody.
- New: real speakerphone. The "Speaker" button of a call (it was cosmetic) puts the players within
  `Config.WorldSounds.speakerRange` metres on the call channel while they stay close (pma-voice / mumble-voip), so they
  hear the other side and can answer; they are taken out when they walk away, when the speaker is turned off or when
  the call ends. Players already in a call are never pulled in. `phonesounds` shows who is listening.
- Fixed: the look-around key (`Config.LookKey`, Alt) did nothing while the mouse was over the phone or with
  `Config.AllowWalking` and `Config.KeepVoice` off: the key mapping only fires when the game receives the keyboard.
  The phone page now listens for Alt itself and both paths share the same logic.
- Fixed: typing in a custom app (an iframe registered with `RegisterApp`) reached the game's key mappings. The phone
  now locks the keyboard for the game while the iframe has the focus, and apps that send `{ apexphone: 'typing', on }`
  get fine-grained control (see "Custom apps").
- Fixed: QBCore without ox_inventory, blank item icons in the inventory. New `installation/qb-core_items.lua` (paste
  into `qb-core/shared/items.lua`), and on start the phone checks every item (exists, `useable`, `image` is a file
  name) and copies missing PNGs into the inventory's `html/images/` folder (`Config.InventoryImages`); `phoneitems`
  repeats the check and prints the fix for anything wrong.

### v1.1.9
- Fixed: "Post" in the Tweeter composer never published. The Photo / counter row of the composer used a class that is also
  the root of the admin panel (a hidden full-screen layer), so the tap never reached the button. Posts with accents or
  emojis are no longer refused by the database (text is cut by characters, not bytes), and a post is never reported as
  failed because its reply notification failed.
- Fixed: typing in a phone text field could reach the game (the open/close key closed the phone on "M", T opened the
  chat, WASD walked). Another resource re-enabling the game input no longer leaks keys; the open key is ignored while
  a field is focused (Esc still closes); the phone re-sends its typing state whenever it opens.
- Fixed: sheets with content under the text field (the Tweeter composer) hid that content behind the on-screen
  keyboard. A sheet now rises above the keyboard; a sheet taller than the space shrinks and scrolls.
- New: `Config.LookKey` (left Alt): hold it to look around with the mouse while the phone is open.
- Changed: `Config.AllowWalking` defaults to `true`; jumping no longer re-taps the last focused button.
- New: "Request Delivery" in the Garage app (`Config.GarageDelivery`): the stored vehicle is brought to the nearest free
  road with its keys, on ESX / QBCore / QBox and every supported garage (OneSync required). `phonedelivery` console
  command explains the state.
- New: open song search in the Music app and the story music sticker (`Config.Music.Search`): any YouTube song or a
  pasted link, no API key; a video that refuses to play outside YouTube is swapped for another version.
- Fixed: "ResizeObserver loop limit exceeded" and "ScriptProcessorNode is deprecated" lines in the F8 console.
- Changed: small phone tables (up to 5000 rows) created by older versions outside utf8mb4 are converted on start.

### v1.1.8
- New: Danish (`da`) as the 16th language, phone and in-game texts.
- New: `Config.ExtraLanguages` to add a language of your own with two readable files (see "Languages"). An unknown
  language code now falls back to English instead of Portuguese.
- Fixed: the phone shop blip could stay "Loja de telemóveis" (Portuguese) on a server in another language: it was
  named once, when the player joined, before the phone had said its language, and it ignored `Config.Shop.blip.label`
  / a shop's `blipLabel` only in the admin panel. The blip and the vendor prompt now follow the phone language, are
  renamed when it changes, and `Config.Shop.blip.label` is documented in `config.lua`.
- Fixed: the in-game dictionaries (`locales/*.lua`) of 14 languages lacked the replies of the `/phonewipe` admin
  command and a generic "Error: %s"; those came out in Portuguese. Regenerated with the complete key set.
- Fixed: system notifications of the social apps, Zapp, groups and Messages ("@ana replied to you", "liked your post",
  "started following you", "%s added you to the group", "Missed group call", "You've been invited to a group call",
  "%d unread messages in %d conversations"...) were never translated: those apps' notifications are treated as player
  content (names and message text), and the system phrases were excluded with them. The server now marks the system
  parts (`data.sys`) and the phone translates them in every language. The Eats and Marketplace "items delivered"
  notices and the `/phonewipe` chat lines are translatable too.
- Fixed: a few phrases were built in code and leaked Portuguese in every language: the alarm countdown ("in 13 hours
  **e** 4 minutes"), group names made from member names ("Ana, Rui **e** Mãe", "**e mais** 3") and "you" in group
  events; and the sample content a new phone starts with (two notes, three reminders, two calendar events and the
  07:30 alarm) was written in Portuguese and, being player content, never translated afterwards. It is now created in
  the phone's language.
- Fixed: calls that "at times" had no voice (ESX + pma-voice report). The client follows the server's call state
  (`apex_inCall` state bag, `calls.sync` RPC, 2 s watchdog) instead of trusting that every `callState` push arrives;
  an `addPlayerToCall` that pma-voice did not take is retried twice and then explained in F8; the voice session can no
  longer stay stuck if a native throws while the volumes of muted players are restored; a stuck "busy" line heals
  itself on the server.
- Fixed: typing in the phone reached the game's key mappings (chat, inventory...) because the page never sent the
  `typing` signal the client expected since 1.1.4 (`Config.KeepVoice`). The page now reports focused text fields (and
  fields removed while focused), and the phone restores its NUI focus when another resource drops it. A shop/admin
  layer left marked open no longer blocks the phone from opening.
- New: `/phonefix` for players and support: resets a stuck phone (layers, focus, camera, voice, pending device request,
  pose) without a restart, and lists what it reset in F8.
- New (custom apps): the `init` message carries the container size, form factor, fold state, OS and model, a `size`
  message follows every fold/unfold, and `RegisterApp({ wide = true })` gives the app the whole inner screen of a
  foldable. The README has a "Custom apps" section with the sizes and the full message list.
- Fixed: a post refused by the server on Instashot / Tweeter said only "Try again"; a missing profile on that network is
  now named, and the server's reason is printed in F8.
- New (integrations): `SetNumber(citizenidOrSrc, number, by)`, `GetDeviceSerial(src)`, the `number` integration category
  (`Custom.number.assign(cid, src)` in `integrations/custom.lua` gives a new account its number from your own system),
  server events `apex_phone:accountCreated` and `apex_phone:numberChanged`. `/phonenumber` uses the same code path.

### v1.1.7
- Fixed: "everything works except the social apps" / "the social apps don't work on the foldable". Instashot and
  Tweeter ask for their permissions (photos, and camera for Instashot) the first time they open; tapping "Don't allow"
  was saved in the account and from then on the app refused to open at all, with only a brief toast at the bottom of
  the screen. The same applied to every app with permissions (Match, Marketplace, Maps, Eats, Services, Weather,
  Recado). A refused permission no longer blocks opening the app: it opens, the player is told once per session which
  access is missing, and Settings › Privacy still controls it. Features that really need the access (camera for
  stories and DMs, microphone, a location request) keep asking when used.
- Verified on the PearPhone Fold and NOVA Fold8 (cover screen and open) with the browser harness: Instashot
  (feed, Reels, Messages, Explore, Profile, post detail, post menu, new message) and Tweeter (feeds, post detail,
  new post with keyboard, search, notifications, profile) render and respond like on the PearPhone 18; the CSS and JS
  were also swept for features newer than the game's Chromium 103 (none in use).

### v1.1.6
- New: `installation/apex_phone.sql`, the full schema (81 tables) generated from the server scripts, for people who
  want to review or run the SQL themselves. Optional: the resource keeps creating and migrating the tables on start.
- Fixed: the social apps (Instashot, Tweeter, Reels) treated a server error on `social.profile` or `social.feed`
  ("database still starting" right after a restart, "too many requests", an internal error) as "no profile" / "no
  posts": the player landed on "Create account", got "Name in use" when trying, or saw an empty feed, with nothing
  explaining why. They now show the reason and a retry button, and "Name in use" is only shown for a taken or
  invalid name.

### v1.1.5
- Fixed: "the phone keeps resetting after a restart" (reported on ESX, possible on every framework). After a restart
  the first `account.get` could come back empty (client timeout while the database was busy with the start-up schema
  checks, or the framework not resolving the player yet) and the phone treated "no answer" as "no account" and opened
  the setup assistant. Now the assistant opens only on an explicit "this character has no account" answer from the
  server; a timeout, `noplayer` or `db` answer makes the phone wait and retry (silently while the character is still
  loading, with the "No connection" sheet for real outages). The RPC timeout on the client is now reported as an
  error instead of an empty answer.
- Fixed: after a restart of `apex_phone` with players in game, the players already loaded got no `session` push and no
  account pre-load (only the standalone mode did that). Every framework now re-sends the sessions of the players who
  are already in game about 2 s after the start.
- Fixed: the framework detection gave up after 60 s. It now waits up to 10 minutes and also hooks `onResourceStart`
  of `qb-core` / `qbx_core` / `es_extended`, so a framework that starts after the phone (or is restarted while the
  phone is running) is picked up immediately; a restarted framework has its core object renewed instead of leaving
  dead function references.
- Performance: the start-up schema checks (missing columns, column widths, indexes, the PIN hash columns) read the
  `information_schema` once for all phone tables (two queries) instead of about a hundred single queries. On shared
  database hosts this took tens of seconds and was what made the first `account.get` time out.

### v1.1.4
- Fixed: the Camera app's VIDEO mode saved a single still frame, so "videos" showed up as photos in the gallery. The
  viewfinder is now recorded for real (WebM) and plays in the Photos / Gallery app; videos get a cover image in the
  grid, can be shared with AirShare / Quick Share and are kept out of the photo pickers. New `Config.Camera.Video*`
  limits and a new `poster` column in `apex_phone_photos` (added automatically on start).
- Fixed: no voice with the phone or the phone shop open. With `Config.AllowWalking = false` the NUI took the keyboard
  away from the game, so the push-to-talk key never reached pma-voice / SaltyChat / mumble-voip: players could not talk
  on a call while looking at the phone, nor while buying a phone. New `Config.KeepVoice = true`: the game keeps the
  keyboard for push-to-talk only (every other control is disabled while the phone or the shop is open).
- New: `/phonevoice` prints the detected voice system, the active call channel and the pma-voice state to F8.
- New: wallpapers from image links ("upload image"). Players can paste a direct link (Discord, Imgur, ...) or a copied
  image in Settings > Wallpaper > "Add image from link" (and in the wallpaper pickers); server owners can list links in
  `Config.Wallpapers`. `Config.WallpaperLinks` controls the option. See "Wallpapers from links".

### v1.1.3
- New: `Config.Currency` (symbol, position, separators). The phone no longer shows a fixed `€`: Wallet, Bills,
  Marketplace, Eats, Onion/crypto, work apps, the phone shop and the server notifications use the configured
  currency (default `$`). Existing shop settings saved in the admin panel are kept.
- Fixed: Vera Chat always answered in Portuguese. It now answers in the language of the player's phone, and its
  error messages ("wait a few seconds", "no key", ...) are shown in that language too.
- Fixed: server console and F8 diagnostic messages were in Portuguese; they are in English now. Admin command
  replies (`/phonereset`, `/testnotif`, `/phonewipe`, ...) print in English in the server console and are still
  translated into each player's language in game.
- Fixed: choosing interests in Match did not work when the phone was in another language (the chips were read
  back as translated text); the Recado pin icon had the same problem.

### v1.1.2
- Fixed: the language chosen in the admin panel ("Language of new accounts") did not reach the phone.
  The panel's choice is published to every client a moment after the resource starts, but the phone
  asked for its defaults before that and kept the `config.lua` value: a server whose `config.lua`
  says `'es'` and whose panel says `'en'` started every new phone in Spanish, and the in-game
  notifications followed. The phone now takes the panel's value at start and again whenever an admin
  changes it; a setup assistant that is already open switches to the new language unless the player
  has picked one.
- New: `/phonelang` in F8 prints which language this client uses and where it comes from (the phone's
  own setting, the value saved on this client, the admin panel, `config.lua`).

### v1.1.1
- Fixed: the Phone Shop panel (`/phoneadmin`) refused every save with "Valor inválido em
  categories[6].icon": the eSIM category that ships in `config.lua` uses an icon name the server's
  check did not know, so nothing in the shop (locations included) could be saved. Any short icon
  name is accepted now.
- Fixed: error messages coming from the server were shown in Portuguese whatever the panel's
  language. They are translated like the rest of the panel.
- Improved: text fields in the admin panel show the translation of the Portuguese defaults from
  `config.lua` (seller role and greeting, category names, taglines, blip labels) in the panel's
  language; the original is kept until the admin types something else.

### v1.1.0
- New: integrations layer for garage, bank, society accounts, housing, billing and dispatch / MDT resources, with a
  buyer adapter (`integrations/custom.lua`) and documentation (`integrations/README.md`).
- New: Radio app (walkie-talkie) with push-to-talk, toggle and open-mic modes, restricted and private frequencies.
- New: contact sharing between nearby players (phone share sheet and ox_target / qb-target).
- New: physical SIM cards (`sim_card` item, optional) and stolen / borrowed phone ownership (optional).
- New: walking with the Camera app open (`Config.CameraWalk`).
- Improved: performance and many fixes across the apps; translations updated in all 15 languages.

### v1.0.0
- First release.

(c) Apex Scripts. All rights reserved.
