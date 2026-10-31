# Installing Vinewood Police Operations

## Requirements
- FiveM server with **OneSync**
- **ox_lib** and **oxmysql**
- **Qbox**, **QBCore** or **ESX Legacy**
- **ox_target** or **qb-target**
- **ox_inventory** recommended. qb-inventory 2.x works, except property bags, armoury loaded-round counting and opening boots from the roadside panel.

## Optional Vinewood resources

| Resource | Version | What it adds |
|---|---|---|
| vinewood-mdt | 2.19.1+ | Records in the MDT as the officer (custody, stop and search, exhibits, incidents, tickets), automatic release on MDT outcomes, MDT duty on ESX |
| vinewood-dispatch | 1.6.0+ | Callsigns, callouts as dispatch alerts, backup requests, ESX duty |
| vinewood_licensing | 2.0.0+ | Roadside licence checks and points without the MDT |
| vinewood-vehicleservices | 1.5.0+ | Insurance, MOT and tax at the roadside without the MDT |
| vinewood-interviews | 1.8.1+ | Interviews logged on custody records |
| vinewood_prison | 2.4.0+ | Remand ends police custody when the prison receives them |
| vinewood-moj | 1.2.0+ | Nothing extra needed: the MDT drives court and remand |

Each is picked up automatically when running, and checked again whenever it starts or stops. `vpo status` shows what was found.

## Steps
1. Put `vinewood_police` in your resources folder.
2. Ensure it **after** its dependencies and any Vinewood resources:
   ```
   ensure ox_lib
   ensure oxmysql
   ensure qbx_core            # or qb-core / es_extended
   ensure ox_inventory
   ensure ox_target
   ensure vinewood-mdt        # optional
   ensure vinewood-dispatch   # optional
   ensure vinewood_police
   ```
3. Admin tools (`vpo status`, `vpo locations`, `vpo callouts`...) work for anyone who has **any** of:
   - the `vinewood_police.admin` ace: `add_ace group.admin vinewood_police.admin allow`
   - the `command` ace, which the default server.cfg already gives `group.admin`
   - ESX group admin/superadmin, or QBCore admin/god permission (`Config.FrameworkAdmins`)

   The player still has to be in `group.admin`, e.g. `add_principal identifier.fivem:123456 group.admin`.
   If someone is refused, run `vpo acecheck <server id>` in the **server console**. It shows each check and the player's identifiers.
   Admin tools never give police powers.
4. Start the server. The database tables are created automatically, and the console lists each migration it applies. If you'd rather import by hand on a new database, `sql/install.sql` has every table in one file and marks the migrations as done. On an existing install, just start the resource: it applies only what's new.
5. Map your police job's grades to ranks in `config/ranks.lua`.
6. Follow `SETUP.md`.

## Remove other police jobs
Remove (or switch off) qb-policejob, qbx_police, esx_policejob or similar. Two scripts cuffing, escorting or toggling duty on the same players will fight. With `Config.Duty.EnforceFrameworkDuty`, other duty toggles are undone anyway.

## Items
The equipment and armoury lists in `config/equipment.lua` use ox_inventory item names (`handcuffs`, `WEAPON_STUNGUN`, `ammo-9`...). Change them to your inventory's names. The dog's drug items are in `config/specialist.lua`.

## Impound
`Config.Roads.Seizure.OnImpound` sends QB/Qbox vehicles to impound (`player_vehicles.state = 2`). For ESX or a garage script, put your garage's impound call there.

## Streamed assets
`stream/` holds the Vinewood props: rigid cuffs, police cone, road closed, accident and checkpoint signs, and forensic tent, plus the front-cuff pose. Nothing extra to install.

## Updating
If you keep your own `config/` through an update, settings added in the new version are filled in from the defaults, and the console lists which. Copy them into your config to change them.

Back up your database first. New migrations apply on start. Locations set in game are kept in the database, so config updates don't overwrite them.

## Qbox installed as qb-core
This is detected from the manifest automatically. If detection gets it wrong, set `Config.Framework = 'qbox'`.
