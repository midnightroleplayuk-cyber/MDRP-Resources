# Apex Admin Panel

The full administration panel, separate from the Quick Menu (F9).

## Installation

The schema installs itself. `server/sqlinstall.lua` runs on resource start and
executes every statement in the bundled `.sql` files, so **you do not have to
import anything by hand**. It is idempotent (`IF NOT EXISTS`), so restarting is
always safe.

If you prefer to import manually anyway:

```
mysql -u <user> -p <db> < install_admin_panel.sql
mysql -u <user> -p <db> < install_me.sql
```

(or paste the contents into Adminer / HeidiSQL).

Then start the resource:

```
ensure apex_adminmenu
```

### Giving yourself the first owner account

Either add your group to `Config.AdminPerms.UserGroups` / the ACE permission and
promote yourself from inside the panel, or insert the row directly (replace
`license:xxx` with your own license identifier):

```sql
INSERT INTO apex_staff (license, nickname, group_name)
VALUES ('license:xxx', 'YourName', 'owner');
```

## Opening the panel

- Command: **`/adminpanel`**
- Key: **`F6`** (re-bindable in `FiveM > Settings > Key Bindings > FiveM`)

The Quick Menu is a separate UI on **`F9`** (`Config.OpenKey`).

## Pages and the permission each one needs

| Page       | Required permission |
|------------|---------------------|
| Home       | `players.read` |
| Players    | `players.read` |
| Monitoring | `players.spectate` (+ `players.read` for its player list) |
| Moderation | `moderation.*` or a specific one (`moderation.ban`, `moderation.warn`, `moderation.jail`) |
| Chats      | `chat.read` to see messages, `chat.write` to send (`chat.*` for both) |
| Items      | `items.read` or `players.*` |
| Vehicles   | `vehicles.read` or `vehicles.*` |
| Console    | `console.read` (view) + `console.exec` (run) |
| Resources  | `resources.read` (list) + `resources.write` (start/stop) |
| Events     | `events.write` |
| Staff      | `staff.read` (view) + `staff.write` (edit) |
| Blips      | `blips.read` + `blips.write` |
| Logs       | `logs.read` or `staff.*` |
| Settings   | any staff member |

## Permission system

Groups live in `apex_staff_groups` and hold a JSON list of permissions.
Supported forms:

- `*` — everything
- `players.*` — every action in the `players` namespace
- `moderation.ban` — that single action

**Owner** is seeded as `["*"]`.

In the panel, `players.spectate` covers every way of seeing what a player sees:
the Monitoring page ("Watch screen"), the in-game **Spectate** camera and the
one-off **Screenshot**. (The F9 Quick Menu is gated as a whole by
`Config.AdminPerms`, like every other Quick Menu action.) It is separate from `players.read`, so a group can keep the
Players page without being able to watch screens. The default **Admin** group
has it through `players.*`; **Moderator** and **Helper** do not — add
`players.spectate` to a group in *Staff → Groups* to grant it. The panel hides
the Monitoring page and those buttons from anyone without it. The web panel's
Live Watch shares the same screen stream (the panel authenticates its own
admins), so a player watched from the browser and from the game is captured
once.

Every panel callback and every panel event re-checks the permission
**server-side**. Nothing is trusted from the client: knowing the event name is
not enough to run an action.

### Editing groups

*Staff → Groups → edit* (or **+** for a new group) opens an editor with the
label, internal name, rank (0 = top), colour and a checklist of every
permission, grouped by page. Each block has its own *all* box (`players.*`),
and *All permissions* at the top is the owner-level `*`. The line under the
checklist shows exactly what will be stored.

**A new group starts with no permissions.** Until you tick something, its
members can open the panel and nothing else. The card says *None · nothing
works* for such a group, *All* for `*`, and the count otherwise.

### When something is refused

A refused action shows a red toast inside the panel naming the action, the
permission it needs and the group that lacks it. Page loads do the same
("Jobs page needs the permission jobs.read…"). The strip at the top of the
Staff page shows your own group and how many permissions it holds.

From the server console, `apexperms <id>` prints the same information for any
online player, and `apexstaff <id> owner` makes someone owner.

### Permission keys

| Namespace | Keys |
|-----------|------|
| `players` | `read`, `teleport`, `revive`, `heal`, `freeze`, `spectate`, `flag` |
| `moderation` | `kick`, `ban`, `warn`, `jail` |
| `money` | `give` |
| `items` | `read`, `give` |
| `vehicles` | `read`, `spawn`, `fix`, `delete` |
| `jobs` | `read`, `write` |
| `utility` | `announce`, `time`, `weather` |
| `chat` | `read` (see messages), `write` (send) |
| `reports` | `read`, `assist` |
| `console` | `read`, `exec` |
| `resources` | `read`, `write` |
| `events` | `read`, `write` |
| `blips` | `read`, `write` |
| `logs` | `read` |
| `settings` | `write` (server settings, webhooks, event rules) |
| `staff` | `read`, `write` |

`<namespace>.*` grants the whole row; `*` grants everything.

## Logs

Every action — from the panel *and* from the Quick Menu — is written to
`apex_staff_log`:

| Category | Source |
|----------|--------|
| `panel` | actions started in the admin panel |
| `quickmenu` | actions started in the Quick Menu (F9) |
| `player`, `vehicle`, `money`, `utility`, `moderation`, `staff`, `report` | semantic categories |

The **Logs** page filters by category, by admin (license) or by free text.

## Map

The Home map uses public GTA map tiles. Every online player gets a marker,
clickable for a TP / Revive popup. Tabs:

- **Players** (default) — live player markers
- **Heatmap** / **Zones** — placeholders for future expansion

If your server runs without outbound internet access on clients, the map simply
renders empty tiles; nothing else is affected.

## Blips

Blips created in the panel are stored in `apex_blips` and synced to every online
client (drawn on the GTA minimap). Saving or deleting hot-reloads the blips for
everyone — no restart.

## Settings

Each staff member gets their own JSON row in `apex_staff_settings`:

- avatar URL
- per-category notification toggles
- UI scale
- **Staff Tag Builder** with a `[{group}] {name}` format string and a live preview
