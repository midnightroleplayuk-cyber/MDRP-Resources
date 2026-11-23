# NDM_PublicDefib

Public access defibrillators (AEDs) in cabinets around the city. Anyone can take one to help someone
in cardiac arrest, but only while no medics are on duty (the same count GoodCiv uses).

## Requirements
- ox_lib, ox_target, qbx_core
- osp_ambulance (patient state, revive)
- NDM_GoodCiv (optional, for the medic count; falls back to qbx_core duty counts)

## Setup
1. `ensure NDM_AED_Prop` (the cabinet model) and `ensure NDM_PublicDefib` after osp_ambulance and
   NDM_GoodCiv.
2. Give admins the ace:
   ```
   add_ace group.admin publicdefib.admin allow
   ```
3. Place cabinets in game:
   - `/defibplace`: aim at a wall, a see-through cabinet follows your aim and sticks flat to the wall.
     Arrow Up / Down for height, E to place, Backspace to cancel. Name it and it's saved on the
     server (KVP) and appears for everyone straight away.
     Press G to switch to **interaction spot only**: no model is spawned, a green dot shows where the
     target goes. Use it where the map / MLO already has a defib cabinet: aim at it and press E.
   - `/defibcabinets`: list every cabinet with its state, teleport to it, reset it, or remove one
     you placed.
   - Cabinets in `Config.Cabinets` still work too (`/defibpos` copies where you stand facing the wall).
4. Optional: a Discord webhook in `server/webhooks.lua`.

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
