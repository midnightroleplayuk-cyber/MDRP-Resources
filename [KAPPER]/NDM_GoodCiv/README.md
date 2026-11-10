# NDM GoodCiv

Civilian first-responder volunteers for FiveM, inspired by real-world GoodSAM style apps.

When a player is down they type **`/goodciv`**. Nearby **GoodCiv volunteers** (players who signed up) get an alert, drive to the patient, give first aid, and either **bring them round on scene** or drive them to hospital. A patient who was brought round stays badly hurt, with health held low, until they **check in at a hospital**.

Works **fully standalone** (GoodCiv runs its own down state, revive and hospital check-in), or alongside **QBCore**, **QBox**, **ESX** and their ambulance and hospital scripts. No dependencies.

## Features

- `/goodciv` to request a volunteer while down. `/goodcivsignup` to volunteer.
- **Own down state** when no ambulance script is running. You go down where you fall, stay down until help arrives, and can respawn at hospital after a timer. If an ambulance script is running, GoodCiv uses its death, last stand and revive instead.
- Alerts with accept / decline keys and a countdown. Only volunteers within range are alerted, and only when fewer than `Config.Medics.MinOnDuty` medics are on duty.
- Treatment panel:
  - **Assess**: check breathing before deciding what to do.
  - **Tourniquet**: controls catastrophic bleeding (optional item, consumed).
  - **CPR**: a rhythm minigame. Compressions at 100 to 120 per minute give the best chance of getting the patient breathing again.
  - **Recovery position** for patients who are breathing but unresponsive.
  - **Bring round**: gets a stable patient back on their feet. They are left **injured**.
  - **Load into vehicle / unload** and **hand over at hospital**.
- **Injured state**: health capped (default 25%), injured walk, no sprinting, and other heals are clamped back down. A GPS waypoint is set to the nearest check-in point. It survives reconnects.
- **Hospital check-in** in one of these ways:
  - GoodCiv check-in points: the hospitals in `config.lua` plus any you place **in-city with `/goodcivconfig`**. Walk up, press **E**, pay the fee, get treated.
  - Your server's hospital script: its revive / heal events or the `CheckIn` export clear the injury.
- Safe transport: speed limit with a patient onboard, and crashes can put a stable patient back into cardiac arrest.
- The server owns the patient's condition and checks distance and timing for every action.
- Rewards for volunteers (framework servers).

## Install

1. Put the folder in your resources as `ndm_goodciv` and add `ensure ndm_goodciv` **after** your framework, inventory, ambulance and hospital scripts (down-state detection checks which scripts are running at start).
2. OneSync must be on.
3. Give admins the creator / revive permission:
   ```
   add_ace group.admin goodciv.admin allow
   ```
4. Review `config.lua`, in particular `Config.Down`, `Config.CheckIn` and `Config.Medics`.
5. Optionally add the `tourniquet` item (see below), or set `Config.Treatment.Tourniquet.Item = nil`.

## How it works

1. **Going down.** With `Config.Down.Mode = 'auto'`, GoodCiv handles the down state itself unless one of `Config.Down.MedicalScripts` is running. A downed player sees a card with `/goodciv` and a respawn timer (`Config.Down.RespawnAfter`, hold **E** to respawn at the nearest hospital).
2. **Requesting.** The player types `/goodciv` (or your death screen triggers one of `Config.Dispatch.ListenEvents`, or calls the export). The call is forwarded to your dispatch. If not enough medics are on duty, volunteers within `Config.Alerts.Radius` are alerted. Set `Config.Medics.MinOnDuty = 999` to always alert volunteers.
3. **Responding.** Up to `Config.Alerts.MaxResponders` volunteers accept, follow the GPS, and press **G** next to the patient to open the treatment panel. It always suggests the next step.
4. **Bring round or transport.** Once the patient is breathing with bleeding controlled, a volunteer can:
   - **Bring round** on scene. The patient gets up injured and must check in at a hospital.
   - **Load** them into a vehicle and hand over at a hospital (**G** there). Handover revives the patient and counts as check-in (`Config.CheckIn.HandoverCountsAsCheckIn`).
5. **Check-in.** The injured patient walks or is driven to a check-in point and presses **E**, or is treated by your hospital script.

The call ends early if the patient is revived by someone else, a medic comes on duty before anyone accepts, the patient respawns or leaves, or `Config.Alerts.IncidentLifetime` runs out.

## Check-in points (`/goodcivconfig`)

1. Stand where patients should check in (the reception desk or a bed) and type `/goodcivconfig`.
2. Enter a name, fee and zone radius, then click **Add at my position**. The zone radius is the area where volunteers can hand patients over.
3. While the panel is open, nearby points are drawn in the world (green arrow = check-in spot, blue ring = handover zone). Each of your points can be renamed, re-priced, moved to your position, teleported to or deleted.

Points are stored in server KVP, so they survive resource updates. Built-in hospitals from `Config.Hospitals` show as `config.lua` and are edited there. Set `Config.CheckIn.UseConfigHospitals = false` to use only your own points (the config ones remain a fallback while you have none).

## Using your own hospital script

Set `Config.CheckIn.Mode`:

| Mode | Clears the injury |
| --- | --- |
| `'goodciv'` | GoodCiv check-in points only |
| `'external'` | Your hospital script only. GoodCiv points are hidden. |
| `'both'` (default) | Either |

For external check-in, GoodCiv listens to the client events in `Config.CheckIn.ExternalEvents` (qb-ambulancejob, qbx_medical and esx_ambulancejob revive events by default). Add your script's "treated / revived" event there, or call an export from your script:

```lua
-- client, once the player has been treated
exports.ndm_goodciv:CheckIn()

-- server
exports.ndm_goodciv:CheckIn(source)       -- clears the injury and heals
exports.ndm_goodciv:CheckIn(source, false) -- clears the injury, your script heals
```

## Commands and keys

| Command | Default key | Who | What it does |
| --- | --- | --- | --- |
| `/goodciv` | | Downed player | Request a GoodCiv volunteer |
| `/goodcivsignup` | | Anyone | Sign up / sign off as a GoodCiv volunteer |
| `/goodcivconfig` | | `goodciv.admin` | Open the in-city check-in point creator |
| `/goodcivrevive [id]` | | `goodciv.admin` / console | Revive a player and clear their injury |
| `goodciv_accept` | Page Up | Volunteer | Accept the newest alert |
| `goodciv_decline` | Page Down | Volunteer | Decline the newest alert |
| `goodciv_treat` | G | Volunteer | Open the treatment panel / hand over at hospital |
| | E (hold) | Downed player | Respawn at hospital once the timer is up |
| | E | Injured player | Check in at a GoodCiv check-in point |

Key mappings can be changed in Settings > Key Bindings > FiveM. Command names are in `config.lua`. txAdmin's **Heal** also revives players from GoodCiv's down state.

## Exports

Server:

```lua
exports.ndm_goodciv:RequestMedic(source)        -- raise a request (forwards to dispatch, then volunteers)
exports.ndm_goodciv:MedicFallback(source)       -- your dispatch already handled it; volunteer fallback only
exports.ndm_goodciv:IsCarrier(source)           -- is a GoodCiv volunteer
exports.ndm_goodciv:SetCarrier(source, true)    -- e.g. after a first-aid course
exports.ndm_goodciv:GetOnDutyMedicCount()
exports.ndm_goodciv:GetIncidentByPatient(source)
exports.ndm_goodciv:CheckIn(source, heal)       -- clear injury (heal defaults to true)
exports.ndm_goodciv:IsInjured(source)
exports.ndm_goodciv:SetInjured(source)
```

Client:

```lua
exports.ndm_goodciv:IsDown()     -- in GoodCiv's down state
exports.ndm_goodciv:IsInjured()
exports.ndm_goodciv:CheckIn()    -- tell GoodCiv your hospital script treated the player
```

## Tourniquet item

ox_inventory (`data/items.lua`):

```lua
['tourniquet'] = { label = 'Tourniquet', weight = 100, stack = true, close = true },
```

qb-core (`shared/items.lua`):

```lua
tourniquet = { name = 'tourniquet', label = 'Tourniquet', weight = 100, type = 'item', image = 'tourniquet.png', unique = false, useable = false, shouldClose = true, description = 'Stops catastrophic limb bleeding' },
```

ESX:

```sql
INSERT INTO items (name, label, weight) VALUES ('tourniquet', 'Tourniquet', 1);
```

## Framework notes

- **Standalone**: on-duty medics are players with the `goodciv.medic` ace. No fees or rewards (no economy). With spawnmanager, auto-respawn is paused while a player is down, so GoodCiv's respawn timer takes over.
- **QBCore / QBox**: medics are players whose `job.name` is in `Config.Medics.Jobs` with `job.onduty`. With qb-ambulancejob / qbx_medical running, their down state is used.
- **ESX**: uses `job.onDuty` on ESX Legacy 1.10+. Older ESX has no duty, so any player with a medic job counts.
- **Revive**: when an ambulance script owns the down state, `Config.Revive` is used for your framework (qb-ambulancejob, qbx_medical and esx_ambulancejob by default). Change it for wasabi, ars, etc.
- **Dispatch**: `ps-dispatch` uses its `InjuriedPerson` alert and `cd_dispatch` uses `AddNotification`. Use `Provider = 'custom'` for anything else.

## Locales

Strings live in `locales/en.lua`. Copy it to another file, change `Locales.en` to your language code, add it to `fxmanifest.lua`, and set `Config.Locale`.
