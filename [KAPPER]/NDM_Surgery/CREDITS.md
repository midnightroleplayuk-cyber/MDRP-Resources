# Credits

## pickle_surgery — Pickle Mods

The major surgery system (`client/major.lua`, `client/hands.lua`, `client/bleed.lua`,
`client/surgeries/*`, `html/*` and everything in `stream/`) is based on **pickle_surgery v1.1.1** by
Pickle Mods, used under the Pickle License (see `LICENSE`). NDM_Surgery is not endorsed by or
affiliated with Pickle Mods.

Changes made by NDM Development:
- Mini-games run on the NDM_Surgery operating tables and use its patient / anaesthesia / stitching flow.
- Results are written to the patient's osp_ambulance body damage (internal damage, fractures, bleeding, logs).
- Removed the ESX / QB / custom framework, target, inventory and XP bridges and the locale system;
  uses qbx_core, ox_lib, ox_target and ox_inventory directly.
- Events renamed to `NDM_Surgery:*`, server-side checks for distance, timing, items and job.
- Patient clothing is saved and restored instead of reloading the skin.
- Optional death on failure (`Config.MajorSurgery.killOnFail`), complications by default.
- Blood HUD rewritten without jQuery.
- Fixed the bleed target id generation.

## Assets (from pickle_surgery's ATTRIBUTIONS.md)

- Blood splatter UI background — Starline at Freepik.com
  https://www.freepik.com/free-vector/red-ink-splatter-stains_1177185.htm
- Body part conversion & torso — MrCrowley
- "Realistic Human Lungs" by thunderpig — https://skfb.ly/oBDWI
- "Small and large intestine" by antonia.sundberg — https://skfb.ly/6SDn9
- "Low poly skeleton ribs" by assetfactory — https://skfb.ly/ows8P
