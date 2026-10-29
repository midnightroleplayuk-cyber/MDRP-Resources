# 🚧 Night Police Tape

**Hang police tape between any two points: walls, poles, trees or posts on open ground. Tape sags, moves in the wind and gives way when people and vehicles push into it.**

---

## ✨ Features

### 🎯 Placing
- **Two-click placing**: aim at the first point, confirm, aim at the second, confirm
- **Live preview** of the tape, its sag and the chosen style before it is hung
- **Posts on open ground**: aim at the ground and a post goes there, with the tape tied near its top. Walls, fences, poles and trees take the tape directly
- **Green and red markers** show at a glance whether a spot will work
- **50 styles**: police, fire, crime scene, caution and plain tapes, with wording for many countries. Switch any of them off in the config

### 🌬️ Alive, not static
- **Sag** that scales with the length of the tape
- **Wind**: tape bows downwind and ripples, following the game's weather
- **Stretch**: people and vehicles push the tape aside and it springs back once they are through. It wraps the real shape of what pushes it: a truck's bumper, a car's windscreen, a person's legs or hips. Several people and vehicles can push it from both sides at once
- **Tearing** (optional): drive into tape fast enough and it tears down for everybody

### 🛡️ Built for live servers
- **Permissions** through Discord roles, ACE, ESX jobs or QBCore jobs and groups
- **Required item** (optional) for ESX, ox_inventory, QBCore and Qbox, with an optional refund when the tape comes down
- **Saved across restarts** in `data/tapes.json`
- **Server-checked**: distances, lengths and permissions are checked on the server, and every player's requests are rate limited
- **Crowding limit**: a cap on how much tape fits in one area
- **Lifetime** (optional): tapes come down by themselves after a set time
- **Admin clear command** for an area or the whole server
- **Locales**: English, Dutch, German, French and Spanish included

---

## 📋 Requirements

- **FiveM server** with OneSync (on by default on current servers)
- *Optional:* [night_discordapi](https://store.nights-software.com) for Discord role permissions
- *Optional:* ESX, QBCore or Qbox for job permissions and the required item
- *Optional:* ox_inventory for the required item

---

## 📦 Installation

1. Extract `night_police_tape` into your `resources` folder.
2. Make sure the `data` folder exists inside it, and that the server can write to it. Tapes are saved to `data/tapes.json`.
3. Add it to your `server.cfg`:
   ```cfg
   ensure night_police_tape
   ```
4. Set up permissions in `config/config.lua` (everyone may use tape by default).
5. Set who counts as an admin for `/cleartapes` in `Config.Clear.AdminRoles` (see [Admin clear](#admin-clear)).
6. Restart your server.

---

## 🎮 Usage

### Placing tape
| Action | Keyboard and mouse | Controller |
|--------|--------------------|------------|
| Start placing | `/policetape` (bind a key in Settings) | - |
| Confirm a point | `E` or left click | `A` |
| Change style | `←` `→` or the mouse wheel | D-pad left and right |
| Back / cancel | `Backspace` | `B` |

Placing only works on foot. Weapons are put away while placing.

### Looking at a tape
| Action | Key |
|--------|-----|
| Remove it | Hold `Left Alt` |
| Change its style | `G` |

The same actions are also chat commands: `/removetape` and `/restyletape`. Players can rebind every key in **Settings → Key Bindings → FiveM**. The on-screen hints follow their bindings.

### For admins
- `/cleartapes`: removes every tape within 25 m of you
- `/cleartapes 60`: removes every tape within 60 m
- `/cleartapes all`: removes every tape on the server. From the server console, use `cleartapes all`

---

## ⚙️ Configuration

Everything lives in `config/config.lua`, and every option is explained there. The main ones are below.

### Language
```lua
Config.Locale = 'en'   -- 'en', 'nl', 'de', 'fr' or 'es'
```
To add a language, copy `locales/en.lua`, rename it, translate it and set `Config.Locale` to its name. Lines you leave out stay English.

### Permissions
```lua
Config.EveryoneHasPermission = false
Config.Enable_Ace_Permissions = true
Config.PermissionRoles = { 'police', 'ambulance', 'fire' }
```
Turn on whichever systems you use: Discord roles, ACE, ESX jobs, QBCore jobs or QBCore groups. A player needs one of `Config.PermissionRoles` in any of them. Only players with permission see the remove and restyle hints when looking at a tape.

### Required item
```lua
Config.Item = {
    Enabled = true,
    System = 'auto',          -- 'auto', 'esx', 'ox', 'qb' or 'qbox'
    Name = 'police_tape',
    RemoveOnPlace = true,     -- take one item per tape
    ReturnOnRemove = true,    -- give it back when the tape is taken down
}
```
Add the item to your inventory yourself. The config shows the line to add for each inventory.

### Styles
Each style in `Config.Textures` can be switched off with `enabled = false`. Hidden styles cannot be placed or picked when restyling, and saved tapes in a hidden style switch to the first enabled one.

### Panel colour
```lua
Config.UI = {
    Accent = { 59, 130, 246 },  -- the panel's colour (RGB)
    Tint = 0.7,                 -- 0 = neutral dark glass, 1 = glass fully tinted by the accent
}
```
The on-screen panel uses the Nights Software interface kit, the same look as ERS. Every line, highlight and key colour is worked out from `Accent`, and text is lightened as needed so it stays readable with dark colours.

### Posts
```lua
Config.AnchorProp = 'prop_roadpole_01a'   -- '' turns posts off
```
Any prop can be the post. The tape is tied near its top, measured from the model itself.

### Stretch and tearing
```lua
Config.Stretch = {
    Enabled = true,
    MaxStretch = 1.15,   -- tape can get 15% longer, then whoever pushes slips through
    NPCs = true,
    Vehicles = true,
    Tear = { Enabled = false, Speed = 50.0 },   -- km/h
}
```
Stretching is visual and worked out on each player's own game, so it costs the server nothing. Tearing is the exception. The driver's game reports the hit, and the server checks the vehicle's speed and position before it takes the tape down for everybody.

### Admin clear
```lua
Config.Clear = {
    DefaultRadius = 25.0,
    MaxRadius = 200.0,
    AdminRoles = { 'Administrator', 'admin', 'superadmin', 'god' },
}
```
`/cleartapes` uses the same permission systems as placing tape, with its own roles. A player is an admin if they hold one of `AdminRoles` as a Discord role, an ACE permission, an ESX job or group, or a QBCore job or permission, in whichever systems you turned on. `Config.EveryoneHasPermission` does not make everyone an admin.

Players ACE allows the command are admins too, so this also works without any permission system:
```cfg
add_ace group.admin command.cleartapes allow
```

### Lifetime
```lua
Config.Lifetime = {
    Minutes = 0,         -- 0 keeps tapes until someone removes them
    Scripted = false,    -- whether tapes from the PlaceTape export expire too
}
```

### Limits
- `Config.MinLength` and `Config.MaxLength`: shortest and longest tape
- `Config.MaxObjectsPerArea` and `Config.AreaSquareMeters`: how much tape fits in one area
- `Config.RateLimit`: how many requests one player can send. The defaults are far above normal play

---

## 🔌 Exports

### Server-side
> Server exports have **no permission or distance checks**. Access control is up to your resource.

**PlaceTape**: hang a tape. Returns its id, or `nil` if it was too short, too long or the area is full.
```lua
local id = exports['night_police_tape']:PlaceTape(ax, ay, az, bx, by, bz, textureId, postA, postB)
```
| Parameter | Type | Description |
|-----------|------|-------------|
| `ax, ay, az` | `number` | First end, where the tape is tied |
| `bx, by, bz` | `number` | Second end |
| `textureId` | `string \| nil` | A style id from `Config.Textures`, e.g. `'police'`. `nil` uses the first enabled style |
| `postA, postB` | `boolean \| number \| nil` | Stand a post under that end. `true` uses the post's own height; a number from 0.1 to 5 is the height above the ground the tape is tied at, in metres |

**RemoveTape**: take a tape down. Returns `true` if it existed.
```lua
exports['night_police_tape']:RemoveTape(id)
```

**ClearTapes**: take down every tape within a radius, or all of them. Returns how many came down.
```lua
local count = exports['night_police_tape']:ClearTapes(vector3(x, y, z), 30.0)
local everything = exports['night_police_tape']:ClearTapes()
```

### Client-side
> Client exports go through the same checks as players do: permission, item and distance.

```lua
exports['night_police_tape']:StartPlacement()   -- start placing for this player, after the server's permission and item checks
exports['night_police_tape']:PlaceTape(ax, ay, az, bx, by, bz, textureId, postA, postB)
exports['night_police_tape']:RemoveTape(id)
```

---

## 🐛 Troubleshooting

**Tapes are gone after a restart**
- Check that `data/` exists inside the resource and that the server can write to it.

**"You do not have permission to use police tape."**
- Check that the permission system you use is turned on, and that the player has one of `Config.PermissionRoles`.

**Tape does not react when people or vehicles walk into it**
- Check `Config.Stretch.Enabled`, and `NPCs` or `Vehicles`. Tapes only react within `Config.Stretch.Distance` of the player.

**"Only admins can clear police tape."**
- Check that the player holds one of `Config.Clear.AdminRoles` in a permission system you turned on, or give them the command by ACE.

**Tearing does nothing**
- `Config.Stretch.Tear.Enabled`, `Config.Stretch.Enabled` and `Config.Stretch.Vehicles` must all be on. Only the driver of the vehicle can tear tape.

**Anything else**
- Set `Config.Debug = true` and check the server console and F8.

---

## 📜 License

© Nights Software. All rights reserved.

**Escrow protected:** core scripts
**Modifiable:** `config/config.lua`, `locales/*.lua`, `client/c_functions.lua`, `server/s_functions.lua`

---

## 🤝 Support

- **Store:** [nights-software.com](https://store.nights-software.com)
