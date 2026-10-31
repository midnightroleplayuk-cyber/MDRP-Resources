# Vinewood Police Operations

A British police job for FiveM: Qbox, QBCore and ESX. From signing on at the station to a detainee in a cell, an NPC who gives a false name at a roadside stop, a Taser discharge going to professional standards and a CID case file.

Built to sit alongside the Vinewood suite (MDT, Dispatch, Licensing, Vehicle Services, Interviews, Prison, MoJ). Every one of those is optional: without them, vinewood_police keeps its own records.

## What's in it

**Duty and kit**
- **Signing on** at a station with callsign, collar number, unit and vehicle. Unit types can require qualifications (armed response, roads, dogs, custody).
- **Officer statuses** and an on-duty roster.
- **End-of-shift report**, plus a pocket notebook whose entries can't be edited, only corrected.
- **Ranks and qualifications:** qualifications have expiry and supervisor sign-off.
- **Management** (`/management`): hire, promote and demote, suspend from duty, dismiss (offline too) and set collar numbers, all limited by rank.
- **Equipment lockers** for everyday kit. **Armouries** for Tasers, firearms and ammunition, with serial numbers and rounds counted back in. A missing round needs an account.
- **Uniforms** by rank and unit, made in game from what you're wearing. Officers change at **changing rooms** or lockers.

**On the street**
- **Handcuffing:** front (Vinewood rigid cuffs and pose) or rear, with double-lock and welfare check.
- **Escort**, and putting prisoners in or taking them out of vehicles. Cuffs survive relogs and restarts.
- **Arrest:** offences, grounds, PACE Code G necessity and the caution.
- **Person search** (with consent, or detained), seizing into evidence, and **stop and search** records with GOWISELY.
- **Scene kit:** Vinewood cones, road signs, forensic tent and **police tape** strung between posts, plus lamps and barriers. Signs can slow or close NPC traffic around the scene.

**Roads policing**
- **Vehicle stops** from your car (`/stopvehicle`), and a roadside panel showing keeper, licence, points, insurance, MOT, tax, markers and the driver's licence.
- **Tickets:** fixed penalties and traffic offence reports.
- **Breath and drug tests**, vehicle **seizure** with recovery and impound, and **Stinger**.
- **NPC drivers** with persistent records (licence, insurance, warrants, stolen cars) and believable behaviour: nervous, uncooperative, false details, running, fighting (only where safe), failing to stop.

**Custody**
- **Booking in:** grounds, risk and observation level.
- **Property** bags, and **cells** that keep people in.
- **Welfare checks** with overdue alerts, and a custody log.
- **Automatic release** when the MDT records bail, NFA or a caution; remand to vinewood_prison.
- **NPC detainees:** cells, interview (no comment, deny or admit, depending on the evidence) and outcomes.
- **Evidence store** with continuity.

**Calls and investigations**
- **Dynamic NPC callouts**, scaled by officers on duty and sent through vinewood-dispatch: shoplifting, disturbances, concern for welfare, burglary alarms, collisions, armed shop robberies (handguns only while ARV is on duty), street robberies, stolen vehicles and missing people.
- **Backup** and automatic urgent assistance.
- **Major incidents:** cordons on the map and ground, roles, and a scene log that records everyone crossing the inner cordon.
- **CID case files:** OIC, people, linked references and exhibits, actions given to officers.

**Specialists and standards**
- **Dog section:** searches for drugs, and detains runners.
- **Use of force forms**, started automatically after cuffing, Taser or firearm use.
- **Public complaints**, and a professional standards panel: discharge and use of force reviews, complaints, officer records and a searchable audit log.

**Built in**
- **In-game admin editor** (`vpo locations`) for stations, lockers, armouries, changing rooms, custody suites, cells, callout places, no-hostile zones and uniforms.
- **Server-authoritative:** every action is checked on the server, rate limited and audited.
- **One NUI hub**, in British English, plus a **Police radial menu** (ox_lib) with the everyday actions.

## Files you edit
Everything in `config/`, `locales/`, `bridge/`, `integrations/` and `client/hooks.lua` is left open under escrow.

## More
- `INSTALL.md`: requirements and installation
- `SETUP.md`: your first hour, from empty server to first arrest
- `EXPORTS.md`: exports, events, statebags and commands
- `TESTS.md`: the test checklist
- `ITEMS.md`: ready-made items for ox_inventory, qb-inventory and ESX
- `CHANGELOG.md`
