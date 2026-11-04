# NDM GoodCiv

Civilian first-responder volunteers for FiveM, inspired by real-world GoodSAM style apps.

When a player calls for a medic, the call goes through your normal dispatch. If no medics are on duty, GoodCiv alerts nearby **GoodCiv carriers**: civilians who have signed up to respond to life-threatening emergencies (unconscious, not breathing, catastrophic bleeding). They respond as civilians, give first aid, and drive the patient to hospital.

Works with **QBCore**, **QBox**, **ESX** and **standalone** through a small framework bridge. No other dependencies.

## Features

- Opt-in volunteers with `/goodciv` or by talking to a sign-up ped, remembered between sessions.
- Alerts only fire when fewer than `Config.Medics.MinOnDuty` medics are on duty.
- Hooks into existing "call EMS" events (qb-ambulancejob, esx_ambulancejob) or your own via export.
- `/medic` command that forwards to the built-in medic alert, ps-dispatch, cd_dispatch, or your own function, then falls back to GoodCiv.
- NUI alert card with accept / decline keys and a countdown, a status card for the patient, and a HUD for the responder.
- Treatment panel:
  - **Assess**: check breathing before deciding what to do.
  - **Tourniquet**: controls catastrophic bleeding (optional item, consumed).
  - **CPR**: a rhythm minigame. Compressions at 100 to 120 per minute give the best chance of getting the patient breathing again. Uncontrolled bleeding lowers the chance.
  - **Recovery position** for patients who are breathing but unresponsive.
  - **Load into vehicle / unload** and **hand over at hospital**.
- Safe transport: speed limit while the patient is onboard, and crashes can put a stable patient back into cardiac arrest.
- The server owns the patient's condition and checks distance and timing for every action.
- Rewards for responders on handover, or a smaller amount if the patient is revived on scene by someone else.

## Install

1. Put the folder in your resources as `ndm_goodciv` and add `ensure ndm_goodciv` **after** your framework, inventory and ambulance scripts.
2. OneSync must be on (the server reads player positions).
3. Review `config.lua`, in particular `Config.Medics.Jobs`, `Config.Dispatch` and `Config.Revive`.
4. Add the `tourniquet` item if you keep `Config.Treatment.Tourniquet.Item` (or set it to `nil`).

### Tourniquet item

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

## Sign-up peds

`Config.SignupPeds.Locations` places NPCs players can talk to in order to sign up or sign off as a carrier. Each entry takes a `model`, `coords` (vector4 of where a player would stand, the ped is dropped 1m onto the floor), an optional `scenario` and an optional map `blip`.

Interaction uses ox_target, then qb-target, then a "Press E" prompt (`Interaction = 'auto'`). The server checks the player is next to the ped before toggling. Set `Config.Carriers.Command = nil` to make the peds the only way to sign up.

## vinewood-dispatch

With `Config.Dispatch.Vinewood.Enabled` and vinewood-dispatch running, GoodCiv listens for vinewood's ambulance calls (`person_down`, `call_111`, `injured_person` by default). If no players are on duty in vinewood's `ambulance` service, every downed player within `PatientRadius` of the call becomes a GoodCiv patient and carriers are alerted. GoodCiv posts its progress (volunteers alerted, who is responding, handover or revive) as updates on the vinewood call, so units and dispatchers can see them in the F9 log. `Provider = 'vinewood'` sends GoodCiv's own requests (the `RequestMedic` export) to vinewood as `injured_person`. `/medic` is off by default because `/111` does the same job.

## How a call flows

1. A player goes down and uses their death screen's "call EMS" (one of `Config.Dispatch.ListenEvents`), or types `/medic`, or your script calls the export.
2. The call goes to your normal dispatch. If enough medics are on duty, that's the end of it.
3. Otherwise GoodCiv creates an incident. The patient's condition is rolled from what put them down (gunshots are much more likely to cause catastrophic bleeding than a fall).
4. Carriers within `Config.Alerts.Radius` get the alert. Up to `Config.Alerts.MaxResponders` can accept. Nobody accepting means a re-alert after `Config.Alerts.RealertAfter` seconds.
5. Responders follow the GPS, press **G** (rebindable) near the patient, and work through the treatment panel. The panel always suggests the next step.
6. Once breathing with bleeding controlled, they load the patient into a nearby vehicle and drive to the nearest hospital, then press **G** there to hand over. The patient is revived through `Config.Revive` for your framework.

The incident ends early if the patient is revived by anyone else, a medic comes on duty before anyone accepted, the patient leaves, or `Config.Alerts.IncidentLifetime` runs out.

## Commands and keys

| Command | Default key | What it does |
| --- | --- | --- |
| `/goodciv` | | Sign up / sign off as a GoodCiv carrier |
| `/medic` | | Request a medic |
| `goodciv_accept` | Page Up | Accept the newest alert |
| `goodciv_decline` | Page Down | Decline the newest alert |
| `goodciv_treat` | G | Open the treatment panel / hand over at hospital |

Keys can be rebound in Settings > Key Bindings > FiveM.

## Exports (server)

```lua
-- Raise a medic request from your own death screen / dispatch.
-- Forwards to Config.Dispatch.Provider, then falls back to GoodCiv.
exports.ndm_goodciv:RequestMedic(source)

-- Your dispatch already handled the call; only run the "no medics" fallback.
exports.ndm_goodciv:MedicFallback(source)

exports.ndm_goodciv:IsCarrier(source)          -- boolean
exports.ndm_goodciv:SetCarrier(source, true)   -- e.g. after a first-aid course
exports.ndm_goodciv:GetOnDutyMedicCount()      -- number
exports.ndm_goodciv:GetIncidentByPatient(source)
```

## Framework notes

- **QBCore / QBox**: medics are players whose `job.name` is in `Config.Medics.Jobs` with `job.onduty`. Downed state comes from `metadata.isdead` / `metadata.inlaststand`.
- **ESX**: uses `job.onDuty` on ESX Legacy 1.10+. Older ESX has no duty, so any player with a medic job counts. Downed state comes from `esx:onPlayerDeath`.
- **Standalone**: on-duty medics are players with the `goodciv.medic` ace. Handover uses a built-in revive.
- **Revive**: the defaults in `Config.Revive` target qb-ambulancejob, qbx_medical and esx_ambulancejob. If you use a different ambulance script (wasabi, ars, etc.), change the function for your framework.
- **Dispatch**: `ps-dispatch` uses its `InjuriedPerson` alert and `cd_dispatch` uses `AddNotification`, both sent from the caller's client. Use `Provider = 'custom'` for anything else.

## Locales

Strings live in `locales/en.lua`. Copy it to another file, change `Locales.en` to your language code, add it to `fxmanifest.lua`, and set `Config.Locale`.
