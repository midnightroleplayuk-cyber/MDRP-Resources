# NDM_PublicDefib

Public access defibrillators (AEDs) in cabinets around the city. Anyone can take one to help someone
in cardiac arrest, but only while no medics are on duty (the same count GoodCiv uses).

## Requirements
- ox_lib, ox_target, qbx_core
- osp_ambulance (patient state, revive)
- NDM_GoodCiv (optional, for the medic count; falls back to qbx_core duty counts)

## Setup
1. Stand at each cabinet spot, run `/defibpos` (needs the `publicdefib.admin` ace) and add it to
   `Config.Cabinets`. The default entry is a placeholder.
2. Optional: set `Config.CabinetProp` (or `prop` per cabinet) to spawn a cabinet model, and put a
   Discord webhook in `server/webhooks.lua`.
3. `ensure NDM_PublicDefib` after osp_ambulance and NDM_GoodCiv.

```
add_ace group.admin publicdefib.admin allow
```

## How it works
1. **Take defibrillator** at a cabinet (only unlocked when no medics are on duty).
2. **Attach defibrillator pads** on the downed player.
3. **Analyse**: the AED decides on the server:
   - a real shockable rhythm in osp_ambulance is always "shock advised",
   - a patient in cardiac arrest has a chance (lower with each analysis),
   - a patient who is still breathing (last stand) gets no shock.
4. **Deliver shock**: a chance to bring them round (osp partial revive: still injured, they still need
   hospital). Otherwise do CPR (e.g. GoodCiv CPR) and analyse again after 30 seconds.
5. **Return defibrillator** to the same cabinet. A used defib leaves the cabinet waiting for the medical
   service to **Restock** it (or it restocks itself after an hour).

## Locked down
- No inventory item: the server tracks who has which defib, so it can't be duplicated, traded or stashed.
- Every step is checked on the server: distance, timing of the progress bars, patient state, who
  attached the pads.
- The server rolls the analysis and the shock. The client never decides anything, and osp's open
  shock event isn't used.
- Taking it more than 250 m from its cabinet, keeping it over 10 minutes, going down or logging off
  loses it (cabinet needs restocking, logged as lost).
- One defib per player, 5 minute cooldown per player (by licence), one set of pads per patient,
  max 3 shocks per pad session.
- Discord logs for taken / returned / lost / shocks / restocks. `/defibreset [number|all]` for admins.
