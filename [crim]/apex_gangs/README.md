# Apex Gangs

The most complete standalone **gang system** for FiveM — in-game gang creation, member & rank management, granular permissions, capturable territory, standalone graffiti, gang levels & upgrades, shared safe & garage, scout/raid operations, tasks and a gang medic. Everything is created and managed **in-game**; you almost never touch a config file.

**Compatible with ESX Legacy, QBCore, and QBox** (auto-detected at runtime). Server Artifacts **5181+**, Game Build **2189+**.

---

## ✨ Features

- **In-game gang creation** — admins create / edit / delete gangs live (name, label, colour, HQ, ranks, max members, starting level).
- **Members** — invite, kick, promote, demote, transfer leadership, leave. Anti-abuse: you can never promote someone to a rank at or above your own.
- **Custom ranks + granular permissions** — each gang defines its own ranks, each rank holds any subset of 26 permissions.
- **HQ & interaction points** — place HQ, safe, garage, medic and task points with an in-world editor (laser-pick or "use my coords"), exactly like the Apex Boss Menu.
- **Capturable territory** — redzone-style barrier walls in each gang's colour, live king-of-the-hill capture & contest, passive income, blips.
- **Standalone graffiti** — spray gang tags on walls (scaleform fonts streamed with the resource — no extra script needed). Per-gang limits, cooldowns, rival removal, auto-expiry.
- **Levels & XP** — gangs earn XP from tasks, captures, raids, graffiti, scouting; levels unlock more members, vault space, garage slots and more.
- **Upgrades** — spend treasury money on stacking upgrades (recruitment, vault, garage, raid rewards, HQ security, gang medic…).
- **Shared safe** — per-gang money treasury (mirrors society accounts) **and** an item stash (ox / qb / qs / ps / codem / origen / tgiann / mf / chezza).
- **Shared garage** — store/take gang vehicles, persistent, per-gang limit, keys on take. Self-contained or bridged to external garages.
- **Scout & Raid** — gather intel on rivals, then raid them for money, items, XP and influence. Cooldowns, scout-gating, server-authoritative resolution.
- **Tasks** — rotating gang contracts across four types (explore / territory / combat / logistics).
- **Gang medic** — unlockable healer/reviver for members.
- **Live sync** — members, ranks, permissions, zones, turf, graffiti, vault, garage, tasks, levels all update in real time for everyone.
- **Discord logs** — every action can be sent to a per-category webhook.
- **Per-player theming** — accent/background colour, window size, opacity (saved locally); admins can set a server default.

---

## 📦 Installation

1. Drop `apex_gangs` into your `resources` folder (e.g. `resources/[RecordKit]/apex_gangs`).
2. Add `ensure apex_gangs` to your `server.cfg` (after your framework + `oxmysql` + `ox_lib`).
3. The database tables are **created automatically** on first start. (A manual `[SQL]/install.sql` is included if you prefer.)
4. (Optional) Add the items in [`installation/items.md`](installation/items.md) — `spraycan`, `spray_remover`, and the raid-loot items.
5. (Optional) Fill in the Discord webhooks and tweak gameplay values in `shared/config.lua`.

**Dependencies:** `oxmysql`, `ox_lib`. Everything else (notify / target / inventory / garage / vehicle-keys resources) is **auto-detected** and optional.

---

## 🎮 Commands

| Command | Who | What |
|---|---|---|
| `/gangmenu` | members | open your gang menu |
| `/gangadmin` | admins | open the god-mode admin menu (manage every gang) |
| `/gangmanager` | admins | open the in-world zone/territory editor |
| `/ganginteract` (or **F6**) | members | the gang interactions radial |
| `/setgang [id] [gang] [grade]` | admins | set a player's gang |
| `/leavegang` | members | leave your gang |
| `/gangperms [id]` | anyone (on themselves) | print exactly which permission check passes or fails |
| `apex_gangs_reload` | console/admin | hot-reload config to all clients |

Command names come from `Config.adminCommand` / `Config.creatorCommand` /
`Config.menuCommand` — rename them there if they clash with another resource.

Access is configurable in `Config.access` (ACE perms, framework groups, or jobs).

### "It says I am not authorised"

Run **`/gangperms`** in-game (or `gangperms <server id>` from the server
console). It prints every ACE the gate probes with an ALLOW/deny beside it,
your framework staff group, your identifiers, and the final verdict for each
command — so you can see which line to add instead of guessing.

A staff group is checked in four ACE spellings (`admin`, `group.admin`,
`qbcore.admin`, `qbx.admin`) plus the live framework group, on ESX Legacy,
QBCore and QBox alike. The stock `add_ace group.admin command allow` that
every framework ships is already enough — you do not have to add anything.

> ⚠️ An `add_ace` line in `server.cfg` only takes effect when the cfg is read,
> i.e. at server **start-up**. Restarting the resource is not enough. To apply
> one immediately, paste it into the live server console.

---

## 🗄️ Gang storage (`Config.gangStore`)

- `native` *(default)* — uses the framework's own gang system on **QBCore/QBox**; on **ESX** (which has no native gangs) membership lives purely in the `apex_gangs_*` tables, so it works **without editing your ESX core**.
- `job` — models each gang as a job/grade (works on every framework, including very old ESX via the `users` table).
- `standalone` — apex_gangs is the only source of truth on every framework.

---

## 🔌 Exports (selection)

**Server:** `GetPlayerGang(src)`, `IsLeader(src, gang)`, `IsAdmin(src)`, `HasPermission(src, perm, gang)`, `CreateGang(name, label, color)`, `SetMemberGang(target, gang, grade, actor)`, `GetMembers(gang)`, `CountMembers(gang, onlineOnly)`, `GetTreasury/AddTreasury/RemoveTreasury(gang[, amount])`, `AwardXP(gang, reason[, amount])`, `Log(category, payload)`, `Notify(src, msg, kind)`, `OpenMenu/OpenAdmin/OpenCreator(src)`.

**Client:** `OpenMenu()`, `CloseMenu()`, `IsOpen()`, `StartGraffiti(text, font, color)`, `StoreVehicle()`, `Notify(msg, kind)`.

**Hooks:** edit `shared/integrations.lua` to plug into logging, XP, turf captures, raids, garages and vehicle-keys without touching protected code.

---

## 🎨 Theme

The UI palette is Apex blue `#1F5EFF` on a hue-free dark stack. Change `Config.theme.brand` + `Config.theme.bg` and the whole NUI (and the in-world markers) re-tint at runtime.

---

*Apex Scriptz — built to match the Apex Boss Menu design language.*
