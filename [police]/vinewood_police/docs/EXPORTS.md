# Exports, events, statebags and commands

## Server exports
`exports.vinewood_police:Name(...)`. Player arguments are server ids unless noted.

| Export | Returns |
|---|---|
| `IsReady()` | `true` once start-up has finished |
| `IsOnDuty(src)` | `true` / `false` for police; `nil` for anyone not in a police job |
| `GetOfficer(src)` | `{ src, identifier, name, label, job, grade, rank, rankLabel, rankShort, rankLevel, collar, callsign, onDuty }` or `nil` |
| `HasPermission(src, perm)` | boolean, against `Config.Permissions` |
| `HasQualification(srcOrIdentifier, qual)` | boolean (held and in date) |
| `GetQualifications(srcOrIdentifier)` | `{ { id, label, grantedAt, grantedBy, expiresAt, valid } }` |
| `GetDuty(src)` | `{ callsign, collar, unit, unitLabel, vehicle, station, status, since, name }` or `nil` |
| `GetOnDutyOfficers()` | `{ [src] = duty }` |
| `GetOnDutyCount()` | number of police signed on |
| `AddShiftStat(src, key, n)` | adds to the officer's end-of-shift report |
| `GetPlayerState(src, key?)` | server-owned state: duty, cuffed, escort, escorting, detained, custody |
| `GetCuffs(src)` / `IsCuffed(src)` | `{ mode, doubleLocked, byLabel, at }` / boolean |
| `GetEscortedBy(src)` | escorting officer's server id or `nil` |
| `ReleaseRestraints(src, reason)` | removes cuffs and ends escort (audited as your resource) |
| `GetCustody(src)` / `IsUnderArrest(src)` | `{ arrestId, ref, mdtRecordId, at, byLabel, offences }` / boolean |
| `GetDetention(src)` | `{ ref, booked, cell, out, nextWelfare, property }` or `nil` |
| `ReleaseFromCustody(src, outcome)` | ends police custody: property back, out of the cell |
| `GetDischarges(filters)` | armoury discharges: `{ unreviewed = true, identifier = '...' }` |
| `GetIntegrationStatus()` | `{ [name] = { available, resource, version, limited, reason } }` |
| `AddAuditEntry(entry)` | adds to the audit log, marked as your resource |

## Server events
| Event | Arguments |
|---|---|
| `vinewood_police:server:ready` | none |
| `vinewood_police:server:dutyChanged` | `src, onDuty, duty` |
| `vinewood_police:server:arrested` | `src, { ref, arrestId, officer, offences, mdtRecordId }` |
| `vinewood_police:server:stateRestored` | `src, { [key] = value }` |
| `vinewood_police:server:integrationChanged` | `name, available` |
| `vinewood_police:server:locationsChanged` | `key` (stations, custody, callouts, hostileZones) |

## Client events
| Event | Arguments |
|---|---|
| `vinewood_police:client:dutyChanged` | `onDuty, duty` |
| `vinewood_police:client:locationsChanged` | none |

## Statebags (only the server writes these)
Player: `vpo_duty`, `vpo_cuffed`, `vpo_escort`, `vpo_escorting`, `vpo_detained`, `vpo_custody`. A client writing to one is reverted and logged.
Global: `vpo_locations`, `vpo_incidents`, `vpo_scene_zones`, `vpo_stingers`, `vpo_dogs`, `vpo_npc_peds`, `vpo_enc_peds`, `vpo_npc_cuffed`.

## Client hooks (`client/hooks.lua`, open under escrow)
- `VPO.Hooks.OnRestrained(restrained, cuffs)`: block or unblock inventory, phone and radio (ox_inventory, qb-inventory and lb-phone included).
- `VPO.Hooks.OnEscorted(escorted, officerServerId)`

## Commands
| Command | Who | What |
|---|---|---|
| `/police` | police | hub: duty, notebook, locker, on duty, forms |
| `/cuff [front]`, `/uncuff`, `/escort` | police | on the closest person |
| `/stopvehicle` | police | stop the vehicle in front (keybind in config) |
| `/stopsearch` | police | stop and search record |
| `/scenekit` | police | cones, signs, barriers, tent, traffic |
| `/custody` | police | custody panel (in a suite) |
| `/evidence` | police | evidence store (custody desk or locker) |
| `/calls` | police | open calls |
| `/incident` | police | major incidents |
| `/cases` | PC+ | CID case files |
| `/dog` | dog handlers | deploy or recall |
| `/stinger` | Stinger trained | lay or withdraw |
| `/quals`, `/qualgrant`, `/qualrevoke`, `/collar` | sergeants | qualifications and collar numbers |
| `/standards` | Inspector+ | professional standards |
| `/management` | Inspector+ | hire, rank, suspend, dismiss, collar numbers |
| `/complaint` | anyone | complain about an officer |
| `/vpo` | admins | admin panel: locations editor, callouts on/off, start a callout, uncuff, admin check, integrations |
| `vpo status \| locations \| callouts on\|off\|off clear \| callout <scenario> \| uncuff <id>` | admin ace / console | the same as commands |
