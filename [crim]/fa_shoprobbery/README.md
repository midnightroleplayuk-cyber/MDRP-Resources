# Cloud Shop integration

Prepared for the supplied **cloud-shop 3.0.1**, with FA Shop Robbery 1.0.6.

## Installation

1. Back up your cloud-shop resource.
2. Copy this folder's `client/` and `config/functions.lua` into your cloud-shop resource, replacing the matching files. Keep your existing `config/main.lua` and other files.
3. If you customized these files, merge the integration changes instead of overwriting your customizations. The change in `config/functions.lua` adds `Robbery.CanUse(shopCoords)` to the target's `canInteract` check.
4. Start `fa_shoprobbery` before `cloud-shop`. Restart cloud-shop after installation.

No manifest change or additional resource is needed: cloud-shop already includes `client/modules/*.lua`. These are replacement files, not a standalone resource.

## Configuration and behavior

Set `RESOURCE` and `MATCH_DISTANCE` in `client/modules/fa-shoprobbery.lua` if needed (defaults: `fa_shoprobbery`, 2 metres).

Locations are matched to **enabled FA clerk coordinates**, not register/safe coordinates. Enable and position the FA clerk at the corresponding cloud-shop location. Unmatched locations keep their normal NPC and shop behavior. Multiple locations under the same shop key are checked separately.

Matched locations do not spawn a cloud-shop NPC. FA owns the clerk, animations, death and respawn. Floating text resolves the current FA entity rather than caching it. Target, key interaction and opening checks require a living, idle FA clerk. Active shopping closes within roughly 200 ms after the clerk becomes unavailable; the client also checks availability before submitting payment. Cloud-shop's normal ambient speech remains unchanged and does not control FA clerks.

If FA is stopped, availability checks fall back to normal cloud-shop behavior. Restart cloud-shop after restarting/stopping FA to rebuild nearby NPCs. Start FA first to avoid briefly spawning a duplicate NPC.

## Validation on your FiveM server

- Check target and key interactions at a matched and an unmatched location.
- Start intimidation with shopping open: verify focus/HUD recovery, UI closure and rejected subsequent payment submissions.
- Check hostile/dead clerks, reset and respawn: shopping should return only when the replacement clerk is idle.
- Leave/re-enter the location and restart both resources: check for duplicate NPCs/interactions.
- Verify your normal job/license requirements and purchases still work.

This is a **client-side clerk/UI integration**. It does not add server-side robbery restrictions to `cloud-shop:processTransaction`; modified clients and requests already being processed remain governed by cloud-shop's existing server logic. Live FiveM validation is required.
