# Setup

Start with the five installation steps in [README](../README.md). OneSync is required. Frameworks, inventory and ox_target are optional.

## Your configuration

Edit config.lua and restart APEX_Tape. The file contains the common settings and short explanations. Complete shipped defaults are in shared/defaults.lua; most buyers can leave that file alone.

Keep one UserConfig table. Merge examples into its Settings table instead of creating duplicate Permissions, Inventory, Commands or other keys. Unspecified values use the shipped defaults. Permissions.Jobs and Permissions.StaffGroups replace their complete lists when provided.

## Choose who can use tape

The supplied file uses Permissions.Mode='public'. For standalone ACE access, change the Permissions group inside Settings to:

```lua
Permissions={Framework='standalone',Mode='ace',StaffBypass=true,
    UseAce='apex.policetape',StaffAce='apex.policetape.admin'},
```

Add the matching grants to server.cfg, using your actual groups:

```text
add_ace group.police apex.policetape allow
add_ace group.admin apex.policetape.admin allow
```

For QBCore jobs, use:

```lua
Permissions={Framework='qb',Mode='jobs_or_staff',
    Jobs={police=0,ambulance=0,fire=0},RequireOnDuty=true,StaffBypass=true},
```

Use your server's job names and minimum grades. For ESX, use Framework='esx' and RequireOnDuty=false unless your adapter supplies on-duty status. See [integrations](integrations.md) for the full permission model.

## Optional inventory

Inventory.Enabled=false is the default. To enable it, register your tape and tool items first, choose Inventory.System ('ox', 'qb', 'esx' or 'custom'), then set Enabled=true. The supplied config shows the item names, consumption and refund settings. Your permission framework and inventory system can differ. Custom integrations need the adapters described in integrations.md.

## Target actions

Start ox_target before APEX_Tape, then aim at nearby tape with the target eye. The supplied policy limits removal to owners/admins. Lift, repair and scene actions use their own eligibility checks. Commands remain available without ox_target. See [commands](commands.md) for target settings.

## File layout

| Path | Purpose |
| --- | --- |
| config.lua | Buyer settings; retain your edits |
| fxmanifest.lua | Resource registration and packaged assets |
| shared/defaults.lua | Complete shipped defaults |
| client/, server/, shared/, locales/ | Runtime code and language dictionaries |
| html/, textures/ | Menu, tape artwork and custom wording |
| stream/ | Precompiled tape models for Rockstar Editor |
| data/ | Saved tape, backups and optional audit records |
| docs/ | Buyer guides and advanced references |
| tools/build_assets.py | Optional helper for replacing stock artwork |

## Performance

Choose PerformanceProfile in config.lua: low (20 nearby visible spans), balanced (40) or high (60). Start with balanced and profile on your actual server. These are rendering budgets, not a guarantee that every scene or player count will perform the same. Increasing object, polygon and scan limits can increase client/server work. Each encountered stock texture loads on demand; stock images total roughly 62 MiB of raw pixels before engine overhead.

## Saved data and replacement installs

Keep data/ writable. Tape is saved periodically and on graceful resource stop. Backups default to five rotating snapshots, at least 60 seconds apart. Failed writes retry; a valid backup may recover an unreadable primary after preserving the corrupt file. Recovery can lose changes newer than the backup. A process crash can lose changes since the last successful save.

Before replacing resource files, stop APEX_Tape and back up its full folder. Keep config.lua, data/ and any edited server/custom.lua or client/custom_target.lua. Extract the new download separately, replace other files, review added settings and check the startup console. Never overwrite saved data with the empty store in a download.

This edition loads the current Version=2 settings format and excludes older configuration scripts and the old update helper. When moving from an older package, start with the supplied config.lua and re-enter your settings from these guides. Test a copy of saved data on a development server first.

Vehicle network IDs do not survive a server restart. Saved vehicle-linked endpoints reload as static world anchors at their recorded positions.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Startup blocked | Read CONFIG ERROR / Startup blocked messages. Check settings types, adapters and required resources/items. |
| Cannot place or edit | Stand on foot, close panels, check permissions, distance, inventory and routing bucket. |
| Wrong height | Use /tapeheight, arrow keys or /tapelevel. Add exact custom anchor models with PoleModels. |
| No target action | Check ox_target start order, Target.Enabled and reach. Try the equivalent command. |
| Blank artwork | Confirm all files are installed. Run /tapediag while aiming and inspect the asset report. |
| Stuck menu or selection | Run /tapereset; restart and reconnect after replacing files. |
| Tape fails to save | Check data/ permissions and save/recovery errors in the console. |
| Tape absent from a recording | Use /tapeeditor on and /tapeeditor status before filming; see recording.md. |

## Check before going live

Use two clients to check placement, design changes, lifting, tearing, repair/removal, allowed and denied users, inventory costs/refunds if enabled, routing buckets and persistence after restart. Stop the resource and check prop, target-zone, focus and traffic cleanup. Test your map, ped models and vehicle pack. Automated checks do not establish live FiveM compatibility.
