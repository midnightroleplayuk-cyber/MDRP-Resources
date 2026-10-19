# Apex Admin Menu

A complete administration suite for FiveM: a fast in-game **Quick Menu**, a full
in-game **Admin Panel**, and an optional **Web Panel** relay you open in any
browser.

Runs natively on **ESX Legacy, QBCore and QBox** (auto-detected), auto-installs
its own database schema, secures every server event server-side, and writes every
action to a searchable audit log that can mirror to Discord.

---

## Requirements

| Resource | Required? | Notes |
|---|---|---|
| [`oxmysql`](https://github.com/overextended/oxmysql) | **Yes** | Staff, bans, warnings, jails, logs, blips |
| [`ox_lib`](https://github.com/overextended/ox_lib) | **Yes** | Callbacks and UI helpers |
| [`screenshot-basic`](https://github.com/citizenfx/screenshot-basic) | Optional | Only for report screenshots and the staff face shot; Watch screen (Monitoring, in-game and in the web panel) captures through the resource's own NUI and uses it only as a fallback. Every call site checks `GetResourceState` first, so the resource runs perfectly without it. |
| ESX Legacy / QBCore / QBox | Optional | Auto-detected. Not required for the core panel. |

FiveM artifacts **build 6683+** recommended.

---

## Installation

1. Drop the `apex_adminmenu` folder into your `resources/` directory (or any
   folder your `server.cfg` starts).

   **`fxmanifest.lua` must sit directly inside the `apex_adminmenu` folder.**
   Any category folder (`[apex]`, `[additional]`, `[standalone]`, …) is fine —
   what is not fine is an extra folder in between:

   ```text
   ✅ resources/[additional]/apex_adminmenu/fxmanifest.lua
   ✅ resources/apex_adminmenu/fxmanifest.lua

   ❌ resources/[additional]/apex_adminmenu/apex_adminmenu/fxmanifest.lua
   ❌ resources/[additional]/[apex_adminmenu]/fxmanifest.lua
   ```

   The ❌ layout is what Windows' **Extract All** produces: it makes a folder
   named after the zip and unpacks the zip's own `apex_adminmenu/` folder
   inside it, so you end up with the name twice. Open the folder you just
   dropped in — if you see another `apex_adminmenu` instead of
   `fxmanifest.lua`, move the inner one up a level and delete the empty
   wrapper. See [Troubleshooting](#troubleshooting) for the exact error this
   causes.

2. Add it to `server.cfg`, **after** your framework and after `oxmysql`/`ox_lib`:

   ```cfg
   ensure oxmysql
   ensure ox_lib
   ensure screenshot-basic   # optional but recommended
   ensure apex_adminmenu
   ```

3. **The SQL installs itself.** `server/sqlinstall.lua` runs on start and executes
   every statement in `install_admin_panel.sql` and `install_me.sql`. It is
   idempotent (`IF NOT EXISTS`) so restarting is always safe. Import them by hand
   only if you prefer to.

4. **Give yourself access.** Two ways, and either is enough:

   - **ACE permission** — add to `server.cfg`:
     ```cfg
     add_ace group.admin apex.adminmenu.allow allow
     ```
   - **Framework group** — any group listed in `Config.AdminPerms.UserGroups.Groups`
     (`admin`, `god`, `mod`, `superadmin` by default).

5. **Become owner in the panel's own staff system** (this is what grants the
   fine-grained permissions). Either promote yourself from inside the panel once
   you have access from step 4, or insert the row directly:

   ```sql
   INSERT INTO apex_staff (license, nickname, group_name)
   VALUES ('license:xxxxxxxxxxxxxxxx', 'YourName', 'owner');
   ```

6. Restart and open it in game.

---

## Opening it

| What | Default | How to change |
|---|---|---|
| Quick Menu | **F9** or `/adminmenu` | `Config.OpenKey` · `Config.Commands.AdminMenu` |
| Admin Panel | **F6**, `/adminpanel` or `/admin` | FiveM &rarr; Settings &rarr; Key Bindings &rarr; FiveM · `Config.Commands.AdminPanel` |

Both commands are renameable, and `aliases` adds extra names for the same
command — that is what `/admin` is. They are registered **client-side**, and
FiveM resolves client commands before it forwards anything to the server, so
an alias here wins over a server-side command of the same name in another
resource (e.g. `qb-adminmenu`'s `/admin`). You do not have to uninstall the
other menu for the alias to take effect.

---

## Configuration

Everything lives in `configs/` and stays **fully open on the escrowed build**.

| File | What it holds |
|---|---|
| `configs/config.lua` | The main config — language, keybind, menu position, permissions, commands, weather/ban/job presets, noclip, dimensions, owned-vehicles schema, reports, webhooks |
| `configs/compat.lua` | The third-party compatibility layer — inventory, clothing/skin, vehicle keys, fuel |
| `configs/strings.lua` | The canonical **English** string list (every UI label) |
| `configs/modifyme.lua` | Small tweaks meant to be edited |
| `configs/peds.lua` | Ped model list for the ped changer |
| `locales/*.lua` | Translation overlays — `en` and `pt` ship, English is always the fallback |

### Key options

```lua
Config.Locale      = 'en'          -- 'en' | 'pt' (add your own in locales/)
Config.OpenKey     = 'F9'          -- Quick Menu key
Config.MenuPosition = 'top-right'  -- top-left | top-right | bottom-left | bottom-right

-- Third-party integrations. 'auto' scans your running resources and picks
-- the right provider by itself. Every supported id is listed in compat.lua.
Config.Inventory        = 'auto'
Config.SkinMenu         = 'auto'
Config.UsingVehicleKeys = 'auto'
Config.FuelSystem       = false    -- 'ox' | 'legacyfuel' | false
```

### Adding a language

Copy `locales/en.lua` to `locales/<code>.lua`, translate the values, and set
`Config.Locale = '<code>'`. A locale only needs the keys it translates — anything
missing falls back to English, so partial translations are safe.

---

## Permissions

There are two layers, and they work together:

1. **Who may open the menu at all** — `Config.AdminPerms` (framework group and/or
   ACE permission).
2. **What each staff member may do** — the panel's own staff system
   (`apex_staff` / `apex_staff_groups`), where each group holds a JSON permission
   list supporting `*`, `namespace.*` and `namespace.action`.

`Config.PermissionLevels` additionally gates individual Quick Menu actions by
framework group.

Every panel callback and every panel event **re-checks the permission
server-side**. Knowing an event name is not enough to run an action.

### Which permission opens the Quick Menu?

The Quick Menu (**F9** / `/adminmenu`) is gated by `Config.AdminPerms` only — it
does **not** read the panel's staff groups, so giving someone `players.*` or a
staff rank in the Staff page will not open it. A player needs either:

* a framework group listed in `Config.AdminPerms.UserGroups.Groups`
  (`admin`, `god`, `mod`, `superadmin` by default) — QBCore: `/addpermission <id> mod`,
  ESX: the `group` column in `users`; or
* the ACE permission in `Config.AdminPerms.AcePerms.AcePerm`
  (`add_ace group.admin apex.adminmenu.allow allow`).

### Opening one menu for some staff only

`Config.MenuAccess` narrows down, per menu, who may open it, on top of being
staff. Each menu has two lists, and a menu with at least one non-empty list
opens only for players matching one of them:

* `groups`: panel group names (`owner`, `admin`, `moderator`, `helper`, or a
  group you created on the Staff page; `superadmin` and `god` count as owner,
  `mod` as moderator). A listed group also lets in everyone ranked above it,
  so `{ 'admin' }` means admins and owners.
* `licenses`: exact identifiers (`license:...`, `discord:...`, `steam:...`).

```lua
Config.MenuAccess = {
    QuickMenu  = { groups = { 'admin' } },                  -- F9: admins and owners; moderators keep the panel
    AdminPanel = { licenses = { 'license:0123456789ab...' } }, -- F6: that one account only
}
```

Staff kept out of a menu are told so ("You do not have access to this menu.").
What a player can do inside a menu is still decided by the group permissions
and `Config.PermissionLevels`.

### Letting a junior admin in without giving them everything

Use a **framework group**, not ACE. Put the person in a group that is listed in
`Config.AdminPerms.UserGroups.Groups`, then list that group only on the actions
they should have in `Config.PermissionLevels`:

```lua
Config.AdminPerms.UserGroups.Groups = { 'admin', 'god', 'mod', 'superadmin' }

Config.PermissionLevels = {
    kickPlayers   = { 'admin', 'god', 'superadmin' },   -- 'mod' left out → denied
    teleportPlayers = { 'admin', 'mod', 'god', 'superadmin' },
    ...
}
```

Two things to know:

* **ACE admins are not restrictable this way.** `Config.PermissionLevels` matches
  on the framework group, and a player who only holds the ACE permission has
  none — they fall back to full admin access. Keep ACE for your owners.
* Only the actions listed in `Config.PermissionLevels` are gated. Anything not
  listed there is allowed to everyone who can open the menu, so add an entry for
  each action you want restricted.

See `ADMIN_PANEL_README.md` for the full page-by-page permission table.

---

## Commands

The first block is configurable (name and on/off) under `Config.Commands`:

| Command | Description |
|---|---|
| `/ban <id> [reason]` | Permanent ban. Use the menu for a timed ban. |
| `/kick <id> [reason]` | Kick a player. |
| `/noclip` | Toggle noclip on yourself. |
| `/searchinv <id>` | Open a player's inventory. Requires `Config.Inventory`. |
| `/clearinv <id>` | Clear a player's inventory. Requires `Config.Inventory`. |
| `/skinmenu <id>` | Open the skin menu on a player's screen. Requires `Config.SkinMenu`. |

**Your framework has a command with the same name?** That is expected and it
is not a problem. ESX Legacy ships its own `/noclip`, and `qb-adminmenu` its
own `/kick` and `/ban`. Since v2.2.10 these six are registered on the client as
well as the server, and a client resolves its own commands first, so the Apex
command is the one that answers. To let the other resource keep a name, set
`enabled = false` for that command in `Config.Commands`, or rename it there.
`apexdoctor` lists any such overlap as information, not as an error.

Always registered:

| Command | Description |
|---|---|
| `/adminmenu` | Open the Quick Menu (also bound to `Config.OpenKey`, default **F9**). Renameable via `Config.Commands.AdminMenu`. |
| `/adminpanel`, `/admin` | Open the full Admin Panel (also bound to **F6**). Renameable via `Config.Commands.AdminPanel`; `/admin` is an alias in that same block. |
| `/report` | Open the report window (players). |
| `/reports` | Open the reports centre (staff). |
| `/reportmode` | Toggle the on-screen report tracker. |
| `/spawnveh <model>` | Spawn a vehicle. |
| `/apexdoctor` | **Start here for any install problem.** Checks dependencies, database, schema, framework, command conflicts and web-panel convars, and says how to fix whatever it finds. Server console only. |
| `/apexcompat` | Print the detected third-party providers to the console — the first thing to run if an integration misbehaves. |
| `/apexdiscord` | Show every Discord route, whether it is valid, and where it resolved from. |
| `/apexdiscordtest <url>` | Send a test embed to a raw webhook URL. |
| `/apexwebhook` | List the routes. `apexwebhook <category> <url>` sets one, `<category> clear` removes one, `reset` clears them all. Server console only. |
| `/apexwho` | Show the web-panel relay / identity info for a player. |
| `/apexperms <id>` | **Run this when someone says "X does nothing".** Prints how the panel sees that player: their group, where it came from (Staff page row, framework group, ACE) and every permission it grants, plus a yes/no for the common ones. Server console only. |
| `/apexstaff <id or license:…> [group]` | Make a player staff from the console (defaults to `owner`). `apexstaff remove <license:…>` / `apexstaff list`. This is how the first owner is created, and the way back in if the staff table ever locks everyone out. Server console only. |
| `/apexstaffdiag` | Print the Staff page exactly as the panel builds it: one line per card with the account key the cards are merged on and the spelling each source stored. **Run this if someone appears twice** and send the output. Server console only. |
| `/apexpaneldiag` | **F8 (client) console.** Prints the running version, whether the panel is open and has NUI focus, keep-input, the Esc guard, and what the page itself sees (keyboard focus, active element, open overlay or modal). Run it with the panel open when "nothing reacts" and paste the lines. |

Keybinds registered by default (all re-bindable in FiveM &rarr; Settings &rarr; Key Bindings):

| Key | Action |
|---|---|
| **F9** | Quick Menu |
| **F6** | Admin Panel |
| **Page Up** | Reports · accept next pending |
| **Page Down** | Reports · resolve current |

The custom keybinds a staff member sets in *Settings → Keybinds* (noclip,
quick menu, staff tag, spectate closest…) are game shortcuts: they stay quiet
while any UI has the keyboard, so typing a bound letter into the staff chat, a
report answer or a job label never fires the action.

---

## Exports

Server-side, from `server/zz_exports.lua`:

```lua
exports['apex_adminmenu']:IsStaff(source)                      -- → bool
exports['apex_adminmenu']:HasAdminPerm(source, 'moderation.ban')-- → bool
exports['apex_adminmenu']:GetStaffGroup(source)                -- → name, table | nil
exports['apex_adminmenu']:Log(src, cat, action, target, lic, details)
exports['apex_adminmenu']:Discord(category, embed)
exports['apex_adminmenu']:Announce({ message, type, target, position, duration, title })
exports['apex_adminmenu']:AddAlert(severity, title, message)
exports['apex_adminmenu']:CaptureEvent(name, src, ...)
```

---

## Discord logging

Logging is always written to the database, so the webhook is purely a mirror.

### One webhook

Set `Config.Webhooks.url` in `configs/config.lua` and pick which categories to log
(`playerActions`, `vehicleActions`, `moneyActions`, `utilityActions`,
`adminActivity`).

### A separate channel per category

There are nine routes — `moderation`, `economy`, `player`, `vehicle`, `staff`,
`console`, `reports`, `login` and `global`. Any route left empty falls back to
`Config.Webhooks.url`, so you can split them off one at a time.

Three places set them, most specific first:

1. **F6 &rarr; Settings &rarr; Discord** — stored in the database. Needs the
   `settings.*` permission; without it the URLs are hidden and the page says so.
2. **Server console** — `apexwebhook <category> <url>`. Also stored in the
   database, prints whether the write succeeded, and fires a confirmation embed.
3. **`Config.Webhooks.routes` in `configs/config.lua`** — used whenever the
   database has nothing for that category. Nothing in the panel can erase this
   file, so it is the safest place for a permanent setup.

```lua
Config.Webhooks = {
    url    = "https://discord.com/api/webhooks/…",   -- catch-all
    routes = {
        moderation = "https://discord.com/api/webhooks/…",  -- own channel
        economy    = "https://discord.com/api/webhooks/…",  -- own channel
        -- anything left "" uses `url` above
    },
}
```

Run `apexdiscord` in the server console at any time to see every route, whether
it is valid, and **which of the three sources it resolved from**.

---

## Web Panel (optional)

`server/webpanel.lua` connects the resource to the Apex web panel, the admin panel
you open in a normal browser. Two convars in `server.cfg`, **above** the
`ensure apex_adminmenu` line:

```cfg
set apex_panel_url "https://<the address you open the web panel at>"
set apex_panel_key "<the server key from the panel's Setup tab>"
ensure apex_adminmenu
```

What goes where:

* **`apex_panel_url` is the web panel's own address** — exactly what is in the
  browser's address bar when you are logged into the panel, scheme included
  (`https://…`), with no path after the host. It is **not** your FiveM server's
  IP or `:30120` port, and `https://your-panel-url` is a placeholder, not a value.
* **`apex_panel_key`** is generated by the panel: open the web panel, go to the
  **Setup** (server) tab, add this server and copy the key it shows. The key is
  what ties your server to your panel account; the URL only says where to send it.
* Restart the server (a resource restart is enough once the convars are in the
  file). The console then prints `Web panel relay starting → <url>`. If it prints
  `apex_panel_url … is still the placeholder` or `… points at the FiveM server`,
  the URL is wrong; fix it and restart.
* `apexpaneltest` in the server console proves whether this server can reach the
  panel at all; `apexdoctor` includes the same check in its report.

The connection is outbound only (the server posts a heartbeat to the panel and
reads commands from the reply), so no port needs to be opened. Leave both convars
unset and the resource behaves as a purely in-game admin menu — nothing is
contacted and nothing is sent anywhere.

**Live Watch** (the web panel's Monitoring page) uses the same screen stream as
the in-game Monitoring page: the watched player's game renders a small frame
through the resource's own NUI, with `screenshot-basic` only as a fallback. It
needs nothing installed on the player's side.

---

## Custom vehicle thumbnails

Drop pictures in `html/images/` named after the spawn code in lowercase
(`html/images/adder.png`). A local file always beats the fallback URL. Restart the
resource after adding files — FiveM only serves files that existed at start-up.
See `html/images/README.txt`.

---

## Troubleshooting

### Start here: `apexdoctor`

Run it in the **server console** (txAdmin's live console counts):

```cfg
apexdoctor
```

It checks the things that actually break installs — `ox_lib` and `oxmysql`
started *and* connected, the schema, which framework attached, whether
`Config.Commands` gives one name to two commands, whether the web-panel convars
are a matched pair — and prints what to do about anything it finds. A healthy
server says `No install problems found.`

Lines marked `--` are information, not problems. The one you will see on most
ESX servers is `command overlaps : 1, handled (nothing to fix)`: es_extended has
a `/noclip` of its own, and the Apex one answers because it is registered on the
client. Up to v2.2.9 that same situation was reported as `FAIL command conflicts`
with a red banner on every start, telling you to stop "the other admin menu",
which was your framework. That report was wrong and is gone.

The same checks run automatically a few seconds after start-up, but they only
print when something is **wrong**, so a healthy console stays quiet.

### "Nothing works": the staff chat swallows messages, Announce does nothing, job changes do not save, keybinds reset

Every one of those is a **permission the staff member's group does not have**,
and up to v2.2.11 the panel refused in silence. Since v2.2.12 a refused action
shows a red toast *inside the panel* that names the action, the missing key
and the group, for example:

> Announce needs the permission `utility.announce` or `utility.*`. Your staff
> group "Server Management" (servermanagement) does not have it. The owner can
> add it on Staff → Groups → edit servermanagement.

Things to know:

* **A group created on the Staff page starts with no permissions at all.** Its
  members can open the panel and do nothing else. Open *Staff → Groups → edit*
  and tick what the group may do; the editor lists every permission by page,
  with an *All permissions (`*`)* switch for owner-level groups.
* **Owner shows "All permissions"**, which is the single entry `*`. That is not
  one permission missing thirteen, it is everything. The default Admin group's
  14 entries are the same idea written out per page.
* The staff chat needs `chat.write` to send and `chat.read` to see messages;
  Announce needs `utility.announce`; the Jobs page needs `jobs.read` to view and
  `jobs.write` to save; the Staff page needs `staff.read` to view and
  `staff.write` to edit groups and members. The full table is in
  `ADMIN_PANEL_README.md`.
* From the server console, `apexperms <id>` prints the group and every
  permission the panel grants that player. If it says *NONE* or *is NOT staff*,
  that is the whole problem. `apexstaff <id> owner` makes them owner.
* Keybinds: *Settings → Keybinds* now answers every change with "Keybinds
  saved." or the database error that prevented it (the row lives in
  `apex_staff_keybinds`). Pressing **Esc** in the key-capture overlay cancels the
  capture and no longer closes the panel.

### I installed the update and nothing changed

Check which build is actually running before anything else:

* the panel's sidebar shows the version under your name (`v2.2.15`), and the
  F8 console prints `Admin Panel v2.2.15 opened` every time the panel opens;
* `apexdoctor` in the server console prints the version in its banner.

The server console also prints `[apex_adminmenu] vX.Y.Z started` a few seconds
after the resource starts, and the panel compares its own page build with the
server's: a sidebar line reading `server v… · page v…` plus a yellow warning
means the client is still running cached page files.

If those say an older number, the new files are not the ones being served.
Delete the old `apex_adminmenu` folder completely before copying the new one
(do not merge folders), make sure there is exactly one `apex_adminmenu` folder
on the server, and **restart the server** rather than only the resource the
first time — the client caches the panel's page, and since 2.2.14 every page
asset carries the version in its URL so a restart is enough from now on. A
player who was connected during the update should reconnect.

If the version is right and a problem remains, send the output of
`apexstaffdiag` (staff listed twice) or F8 `apexpaneldiag` with the panel open
(buttons or typing not reacting) together with the report.

### The same staff member is listed twice, once online and once offline

Fixed in 2.2.13. The Staff page merges three sources — rows in `apex_staff`,
players online with a staff framework group, and framework users with a staff
group in the database — and each spells the same account differently: a
connected player is `license:3f2a…`, an ESX `users` row is the bare `3f2a…`
(ESX strips the prefix), a QBox `players` row is `license2:…`. Compared as raw
strings, one owner became two cards. The three lists are now matched by the
account behind the string, so one person is one card, online or offline, and the
web panel's Staff list and Jobs → members use the same matching. Rows written by
the "Add staff" picker in the bare ESX spelling also resolve for permissions
now. Since 2.2.14 the page itself merges such cards as well, `apexstaffdiag`
prints the merge keys, and the trash icon on a **FRAMEWORK** card explains that
the person is staff through their framework group (there is no Staff-page row
to remove; change the group in the framework) instead of claiming "removed".

### A "Press a key for …" box that never reacts, and the panel stops taking clicks or typing

Fixed in 2.2.13. The panel is an iframe inside the resource's NUI page, and the
browser engine only delivers key presses to the document that holds keyboard
focus. Two things could take that focus away from the panel: opening it with the
key (F6) rather than a click, and another NUI opening on top of it (the F9 Quick
Menu, the Reports pane, another resource's UI). The key-capture overlay then
waited for keys it could never receive, Esc was reserved for the overlay, and the
overlay covered every button — the only way out was restarting the resource. The
same lost focus is why typing in the staff chat did nothing.

Now: the panel claims keyboard focus when it opens and again whenever the game
hands the NUI focus back to it; the key-capture overlay also receives the key
from the game side (the raw-key natives do not care which document is focused),
has a **Cancel** button and closes itself after 20 seconds without a key; the
Quick Menu refuses to open underneath the panel and the Reports pane closes it
first; and a second NUI that closes on top of the panel no longer leaves it dead
— the panel takes the focus back within a quarter of a second. Since 2.2.14 the
page also checks twice a second that it holds the keyboard and pulls it back
when the host page has it, and the staff chat's message box takes the keyboard
as soon as the page opens. If another resource keeps the keyboard while the
panel is open, close that resource's UI first; F8 `apexpaneldiag` shows who has
it.

### The web panel's Live Watch shows "Nobody being watched" while in-game Monitoring works

Fixed in 2.2.13. The browser's Live Watch used its own capture on the watched
player, through `screenshot-basic` only. On a server without that optional
resource the eye icon started a watch that the client immediately reported as
unavailable, so the tile closed again and the page sat on "Nobody being
watched" — while the in-game Monitoring page, which captures through the
resource's own NUI, worked. The web panel now rides the same stream as the
in-game page, so both show the same frames and nothing extra is needed. Frames
reach the browser on the relay heartbeat (about every 1.5 s).

### What do I put in `apex_panel_url`?

The address of the **web panel** as you open it in your browser, with `https://`
and nothing after the host — not the FiveM server's IP or port, and not the
`https://your-panel-url` placeholder. The key comes from the panel's Setup tab.
See *Web Panel (optional)* above; since 2.2.13 the console and `apexdoctor` say
so when the URL still looks like a placeholder or points at the game server.

### The resource will not start at all

If `apexdoctor` says "Unknown command", the resource is not running, and there
are only two possible reasons:

1. **A dependency started after it.** `oxmysql` and `ox_lib` are hard
   dependencies — FiveM refuses to start `apex_adminmenu` without them and says
   so in one line that is easy to lose in the boot spam:

   ```text
   Could not find dependency oxmysql for resource apex_adminmenu.
   ```

   This bites servers that start resources by category. `ensure [standalone]`
   or `ensure [qb]` runs in the order those lines appear, so if `oxmysql` lives
   in a category that is ensured *later* than the one holding `apex_adminmenu`,
   a working install "suddenly stops starting" after a folder reshuffle. Put
   explicit lines above everything else:

   ```cfg
   ensure oxmysql
   ensure ox_lib
   # ... your categories ...
   ensure apex_adminmenu
   ```

2. **The folder layout is wrong** — see the next section.

### `Could not open resource metadata file - no such file`

```text
Couldn't load resource apex_adminmenu: Couldn't load resource apex_adminmenu
from resources:/apex_adminmenu/: Could not open resource metadata file - no such file.
```

The server found the folder but there is no `fxmanifest.lua` **directly**
inside it. It is a folder-layout problem, never a code or licence problem, and
the category folder (`[additional]`, `[apex]`, …) is not the cause. Three
things produce it:

1. **The folder name is doubled** — `apex_adminmenu/apex_adminmenu/fxmanifest.lua`.
   By far the most common. Windows' *Extract All* creates a folder named after
   the zip and then unpacks the zip's own `apex_adminmenu/` folder into it.
   **Fix:** move the inner `apex_adminmenu` up one level, delete the empty
   wrapper.

2. **`fxmanifest.lua` is really `fxmanifest.lua.txt`** — Windows hides known
   extensions, so a file re-saved in Notepad looks correct in Explorer.
   **Fix:** View → *File name extensions* in Explorer, then rename it back.

3. **The folder was renamed**, e.g. to `apex_adminmenu-2.1.3` or
   `apex_adminmenu (1)`, while `server.cfg` still says `ensure apex_adminmenu`.
   **Fix:** the folder name and the `ensure` line must match exactly.

One command tells you which it is — run it in the server console:

```cfg
dir resources/[additional]/apex_adminmenu
```

You should see `fxmanifest.lua`, `client`, `server`, `configs`, `html`. If you
see another `apex_adminmenu` instead, it is cause #1.

> **Do not "fix" it by renaming the outer folder to `[apex_adminmenu]`.** That
> does make the server start — FiveM treats any `[bracketed]` folder as a
> *category* and then finds the real resource inside it — but you now have a
> category named after a resource, and the next update dropped in the same way
> nests one level deeper again. Move the inner folder up instead.

### `Web panel rejected the heartbeat (HTTP 500)` repeating in the console

HTTP **500** means the request reached your panel and the panel's own code
threw on it. Your `apex_panel_url` and `apex_panel_key` are fine — a wrong URL
or key gives 0, 401, 403 or 404, not 500.

Since 2.2.1 the relay no longer narrates every flap: it stays quiet unless four
heartbeats in a row fail, then reports once and holds off for five minutes. It
also no longer relays its own error lines back to the panel, sends only the
newest screen-watch frame per player, and never leaves a field empty for a
player who is still loading in — all three of which could make a strict panel
throw. If 500s continue after updating, the fault is on the panel side.

`apexpaneltest` in the server console proves whether this server can reach the
panel at all, independently of the relay.

### `event esx:onPlayerSpawn was not safe for net`

Fixed in 2.2.1. The event-log feature hooked ESX and QBCore core events with
`AddEventHandler` alone. Those events are sent by the *client*, and FiveM
refuses to run a network-delivered event in a resource that did not call
`RegisterNetEvent` — it printed that line on every single player spawn and
then discarded the event, so the warning and a missing log entry were the same
bug. Framework events are now registered properly (and rate-limited per
player); engine events like `playerDropped` and `rconCommand` deliberately are
not, so no client can forge them into the audit log.

### `[ESX] [WARNING] Ignoring invalid .setJob() usage`

The job existed for the panel but not for the framework. ESX validates job and
grade against its own in-memory table, and a job added to the `jobs` database
table *after* `es_extended` started — or one with no rows in `job_grades` — is
not in it. ESX then ignores the call and prints that warning, so from the
admin's side the job simply never changed and nothing said why.

Since 2.2.1 the panel validates every job change against the framework's own
table and tells the admin the reason when one is refused — including the list of
grades the job actually has. The same validation was added for QBCore and QBox,
which had the identical bug without even a console warning.

Saving a job now also calls `ESX.RefreshJobs()` (falling back to the
`refreshjobs` console command), so a job or a grade created in the panel is live
immediately instead of waiting for the next restart. A job you added to the
database by hand still needs `/refreshjobs`; the Jobs list marks anything ESX
has not loaded yet with a red clock badge.

### A job or grade I just saved disappeared from the list

Fixed in 2.2.6. Two caches, one symptom on each framework:

* **ESX** reads `jobs` / `job_grades` into memory once at boot. The panel wrote
  the new grade to those tables and then re-read the list from that stale
  in-memory pool, so the row vanished a second after being saved (and
  `setJob` kept refusing it). The panel now shows the database — what the
  server will boot into — refreshes ESX after every save and delete, and
  flags anything the running ESX has not picked up.
* **QBCore / QBox** hand out a *copy* of the core object, so the panel was
  reading a snapshot of `Shared.Jobs` taken at start-up, and `AddJob` refuses a
  name the core already knows (`job_exists`) — which made every edit to an
  existing job a silent no-op. Edits now go through `UpdateJob`, and the core
  object is re-fetched when it changes.

### `/admin` opens a different menu (or nothing)

Another admin resource — `qb-adminmenu` ships one — registers `/admin` too.
Apex registers its commands client-side, which wins over a server-side command
of the same name (since v2.2.10 that covers `/noclip`, `/kick`, `/ban` and the
other staff commands as well as the menu ones). What the server cannot see is a
second menu that registers the same name on the **client** too: then the two
really do fight, and the one that loaded last answers. Stop the other menu
(`ensure qb-adminmenu stop`, or delete the folder), or point Apex at a name
nothing else uses by editing `Config.Commands.AdminPanel.aliases`.

### The menu does not open at all

Check permissions first — the command is silent by design when you fail the
check. Give yourself access via step 4 of [Installation](#installation), then
`/apexcompat` in the server console to confirm the resource is running and see
what it detected.

---

## Support

- Store: <https://apexscripts.xyz>
- Discord: <https://discord.com/invite/apexscripts>
