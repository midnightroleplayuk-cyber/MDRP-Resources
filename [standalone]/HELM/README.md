# Helm for FiveM

Helm connects your FiveM server to the Helm staff panel at **https://helm-panel.onrender.com**. Your staff
can see who is online, moderate players, handle reports and read an activity log, from a browser or in game.

This file covers installing the resource and setting up your community. It takes about 15 minutes.

---

## What you need

- A FiveM server running **QBox** or **QBCore**. ESX and standalone servers are supported, but QBox and
  QBCore are the tested setups.
- **oxmysql**, which most QBox and QBCore servers already run.
- A Discord account, and ideally a Discord server for your community.
- **baseevents** (optional). Without it, deaths and vehicle activity are not logged.

---

## 1. Create your community on the panel

1. Go to **https://helm-panel.onrender.com/register**.
2. Enter your community name and the invite code you received with your purchase.
3. Sign in with Discord. You are now the **Owner** of your community.

## 2. Add your server and get its token

1. In the panel, open **Servers**, then **Add a server**.
2. Give it a name and pick your framework.
3. Copy the token that starts with `hs_`. You can show it again later from the Servers page.

Treat the token like a password. Anyone who has it can pretend to be your server.

## 3. Install the resource

1. Put the `helm` folder in your server's `resources` folder.
2. Add the token in **one** of these two places:
   - **server.cfg** (recommended): `set helm_token "hs_your_token_here"`
   - **server_config.lua**: replace `hs_replace_me` with your token.

   Never put the token in `config.lua`. That file is sent to every player's game.
3. Add this to `server.cfg` after oxmysql and your framework:
   ```
   ensure helm
   ```
4. Restart the server. Within about 20 seconds, the server shows as **Online** on the panel's Servers page.

If it stays offline, type `helm_detect` in the server console. It prints the framework, inventory and
revive event Helm found. Red `[helm]` lines in the console explain connection problems.

## 4. Link your game account (every staff member)

This lets Helm recognise you in game, and is needed for in-game notifications and spectating from the panel.

1. On the panel, open the menu at the top right, then **Game account**, then **Generate code**.
2. Join your server and type `/helmlink CODE`.

## 5. Add your staff

On **Staff & roles** you can:

- **Add staff by Discord ID.** They sign in with Discord. Right-click their name in Discord and choose
  Copy User ID; you need Developer Mode switched on under Discord settings, Advanced.
- **Add staff by email and password**, for people without Discord.
- **Create roles** and choose exactly what each role can do (see the permissions table below).
- **Link roles to Discord roles.** Anyone with that Discord role becomes staff with the matching panel role
  when they sign in. This needs the Helm bot in your Discord server; use **Add Helm bot to Discord** on the Servers page,
  which adds the bot and links your Discord server.

If someone forgets their password, use **Reset link** in the Password column and send them the link. It works
once, for one hour.

---

## In-game commands

| Command | Who | What it does |
|---|---|---|
| `F7` or `/helm` | Staff | Opens the staff menu: warn, kick, ban, revive, go to, bring, spectate, tools and reports. |
| `/report message` | Everyone | Sends a report to staff. |
| `/report 12 message` | Everyone | Reports the player with server ID 12. |
| `/helmlink CODE` | Staff | Links your game account to your panel account. |
| `/helmspec` | Staff | Stops spectating. Backspace also works. |
| `/helmnoclip` | Staff | Toggles noclip. You can bind a key to it in FiveM's key bindings. |
| `/helmalerts` | Staff | Turns in-game staff alerts on or off for you. |
| `helm_detect` | Console | Shows the framework, inventory and revive event Helm detected. |

## Discord commands

If the host has linked your Discord server and the Helm bot is in it, staff can use these in Discord. Use the
player's in-game server ID:

| Command | What it does |
|---|---|
| `/warn id reason` | Warn a player |
| `/kick id reason` | Kick a player |
| `/ban id reason [hours]` | Ban a player (no hours = permanent) |
| `/revive id` | Revive a player |
| `/teleport id location` | Send a player to the hospital, Legion Square, police station, airport, Paleto Bay or Sandy Shores airfield |

Each command needs the matching panel permission and its tick under **Discord commands** on the person's role (Staff & roles). Only the person using the command sees the reply.

## What your staff get on the panel

- **Dashboard:** players online, recent activity, alerts and quick actions.
- **Live players:** everyone online, with their character, job, ping and position.
- **Players:** history, notes, warnings, kicks and bans for every player who has joined.
  - While they're online: which server and ID, the vehicle they're in with its registration, and a link to them on the live map.
  - Each character's inventory (refreshed every couple of minutes).
  - Remote actions: revive, teleport, give or remove items, set money or job, give vehicles.
  - Spectate in game, and take a screenshot of the player's screen.
- **Live map:** every online player as a dot on the map; select one to open their page or spectate.
- **Quick search:** press Ctrl+K (Cmd+K on Mac) to find players, characters, plates, reports and pages.
- **Rules:** set what happens each time a rule is broken (for example RDM: warning, then a 24 hour ban, then
  permanent). On a player's page, pick the rule under **Punish by rule** and Helm applies the right step from
  their history.
- **Reports:** claim a report, reply (the player sees it in game), and close it.
- **Ban appeals:** banned players see their ban ID and an appeal link when they try to connect. They appeal at
  `https://helm-panel.onrender.com/appeal/your-community` after signing in with Discord. Staff with the ban
  permission accept (which lifts the ban) or deny on **Ban appeals**, and can send a Discord DM with the decision.
- **Combat log:** every hit and kill between players, with weapon and distance, on each player's page. Reports link
  to the reporter's combat log, so RDM and VDM reports can be checked quickly. Turn it off with
  `Config.Logging.Combat = false`.
- **Evidence:** attach clip links, Discord message links or screenshots to any warning, kick or ban (or paste a link
  when punishing). Screenshots used as evidence are kept until removed.
- **Applications:** allowlist or staff forms on the web. Players sign in with Discord and apply at
  `https://helm-panel.onrender.com/apply/your-community`. Accepting an allowlist application allowlists the player
  (once they have joined with Discord linked), and can give them a Discord role. When accepting or denying, staff can send the applicant a private Discord message with feedback or next steps.
- **Schedules:** announcements at set times or on repeat, and daily restarts with warnings (see below).
- **Weekly summary:** every Monday morning, joins, players, bans, reports and the most active staff, posted to
  any Discord webhook with **Weekly summary** ticked.
- **Activity log:** chat, commands, deaths, money, items, vehicles and jobs, searchable by player.
- **Alerts:** large money gains, bursts of explosions, possible ban evasion, and anti-cheat checks: god mode,
  health or armour above the maximum, staying invisible, blacklisted weapons, moving impossibly fast, and spawning
  lots of entities. Checks run on your server, staff are never flagged, and nothing is punished automatically.
  Online staff get an in-game notice too. Turn individual checks off or change the weapon list in
  `Config.AntiCheat`.
- **Clean-up tools:** in the in-game menu's Tools tab: revive everyone within 30 m, delete empty vehicles within
  50 m, and delete spawned props within 30 m (needs **Clean-up tools** under in-game permissions). On a player's page,
  **Delete everything they spawned** removes a modder's props, NPCs and empty vehicles.
- **Live view:** on a player's page, **Watch live** streams their screen as video straight from their game to your
  browser (needs the spectate permission). If their network blocks it, the panel switches to a fresh picture every
  couple of seconds. Nothing is recorded or saved.
- **Discord webhooks:** post bans, reports, alerts and more to your Discord channels.
- **Punishments, Characters, Vehicles, Audit log, Backups**, and Tebex payment checks.

## Permissions

The Owner role always has everything. Every other role only gets what you tick.

| Permission | Allows |
|---|---|
| `ingame.menu` | Open the in-game staff menu (F7), use staff tools, and get staff alerts in game. Untick it to keep a role panel-only |
| `ingame.warn`, `ingame.kick`, `ingame.ban`, `ingame.freeze`, `ingame.revive`, `ingame.teleport`, `ingame.noclip`, `ingame.spectate`, `ingame.vehicles`, `ingame.reports` | Which buttons the person can use in the in-game menu. Each also needs the matching panel permission, so you can allow something on the panel but not in game |
| `players.view` | See players, Live players and punishments; get join alerts in game |
| `players.warn` / `players.kick` / `players.ban` | Warn, kick and ban (the ban permission also allows unbanning) |
| `players.allowlist` | Add or remove players from the allowlist |
| `players.spectate` | Spectate players and take screenshots of their screen |
| `world.cleanup` | Delete everything a player spawned (player page) and the in-game clean-up tools |
| `reports.view` / `reports.manage` | See reports and get them in game; claim, reply and close |
| `remote.revive` / `remote.teleport` / `remote.announce` | Revive; teleport, go to, bring and noclip; server-wide announcements |
| `characters.view` / `characters.edit` | See characters; set money and job |
| `inventory.edit` | Give, remove and wipe items |
| `vehicles.view` / `vehicles.edit` / `vehicles.give` | See and change vehicles; issue vehicles |
| `logs.view` | Activity log, alerts and audit log |
| `staff.manage` | Add staff, edit roles, create password reset links |
| `servers.manage` | Add servers and view tokens |
| `integrations.manage` | Discord webhooks |
| `rules.manage` | Create and change rules (using them on a player needs the warn, kick or ban permission for that step) |
| `schedules.manage` | Scheduled announcements and restarts |
| `applications.manage` | Application forms; accept or deny applications |
| `tebex.view` / `tebex.verify` | See store purchases; check payments |
| `backups.manage` | Create and download backups |

Staff can only give roles and permissions they have themselves, and only the Owner can act on other staff.

---

## Settings (config.lua)

Every setting is explained in `config.lua`. The ones you are most likely to change:

| Setting | Default | What it does |
|---|---|---|
| `Config.MenuKey` | `'F7'` | Key that opens the staff menu. |
| `Config.ReportCommand` | `'report'` | Name of the report command. |
| `Config.EnforceAllowlist` | `false` | Refuse players who are not allowlisted. |
| `Config.BlockBanEvasion` | `false` | Refuse players on the same PC as a banned player. When off, staff are alerted instead, because family PCs can match. |
| `Config.ReviveEvent` | auto | Set this if your ambulance script isn't detected. |
| `Config.Banking` | auto | Uses LG Mods UK Banking (`LGMods_Banking`) for bank balances when it's running. |
| `Config.DefaultGarage` | `'pillboxgarage'` | Garage for vehicles given from the panel. |
| `Config.Notices.TellPlayer` | mostly on | Which staff actions the player is told about. |
| `Config.Logging` | all on | What goes to the activity log. Command arguments are off by default for privacy. |
| `Config.Screenshots.Enabled` | `true` | Allow staff to take screenshots of a player's screen. |
| `Config.AntiCheat` | all on | Which anti-cheat checks run, speed limits and the blacklisted weapons. |
| `Config.ScheduledRestarts` | `false` | Let the panel's Schedules page restart the server (see below). |

`config.lua`, `server_config.lua`, `bridge.lua` and `html/index.html` stay editable. The rest of the resource
is protected by Cfx.re Asset Escrow.

## Allowlist by Discord role (optional)

1. On the panel's **Servers** page, click **Add Helm bot to Discord** and pick your Discord server.
2. On the panel's **Servers** page, choose which Discord roles count as allowlisted.
3. Set `Config.EnforceAllowlist = true` and restart Helm.

Players need FiveM linked to Discord (FiveM settings, Accounts) for the role to be checked. Anyone who loses
the role while playing is removed with "Whitelist revoked".

## Scheduled restarts (optional)

1. On the panel's **Schedules** page, add a **Server restart**: pick the time, the days, and the warnings
   (for example 30, 10, 1 minutes before).
2. Set `Config.ScheduledRestarts = true` in config.lua and restart Helm.

At the time, Helm removes everyone with your message and stops the server. **txAdmin restarts it automatically.**
Without txAdmin, only turn this on if your host starts the server again when it stops. Warnings and
announcements work without this setting.

## If the panel is down

Helm keeps a copy of your ban list on the server (`banlist.json`), so banned players are still refused. Everyone
else can still join, and moderation actions queue up until the panel is back.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Server shows **Offline** | Check the token is set and has no spaces or line breaks. Look for red `[helm]` lines in the console. Run `helm_detect`. |
| "No server token set" in the console | Add `set helm_token "hs_..."` to server.cfg, or put the token in server_config.lua. |
| Staff menu says you're not linked | Do step 4 (`/helmlink`), or make sure your Discord ID is on your panel account. |
| Bank balance looks wrong with LG Banking | Run `helm_detect` and check it says `banking=lgmods`, or set `Config.Banking = 'lgmods'`. |
| Revive does nothing | Set `Config.ReviveEvent` to your ambulance script's revive event. |
| No deaths or vehicles in the activity log | Start the `baseevents` resource. |
| Items not changing | Check `helm_detect` found your inventory, or set `Config.Inventory`. |
| You regenerated the token | Update it in server.cfg or server_config.lua and restart Helm. The old one stops working at once. |

## Updating

Replace the `helm` folder with the new version, keeping your `config.lua` and `server_config.lua` (or
re-apply your changes), then restart the server.

## Support

Contact the seller you bought Helm from, and include what `helm_detect` prints in your server console.
