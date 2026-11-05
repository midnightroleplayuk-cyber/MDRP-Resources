# HF1 TV v0.5.0 - Placeable television experiment

## Required
- ox_lib, ox_target, ox_inventory, oxmysql
- Add the item definition in `ox_inventory_item.lua` to `ox_inventory/data/items.lua` and restart ox_inventory.
- Import `placement.sql` into your FiveM MySQL database before starting the resource.
- Ensure dependencies before `ensure hf1_tv` in server.cfg.
- To give yourself a test item, use your server's normal ox_inventory item-giving mechanism: item name `tv`.
- `/tvplace` is a testing shortcut, but the server still requires a television item and consumes one on successful placement.
- Use the item, choose from all 17 supported models (some are overlay/laptop props and experimental), aim at a wall (flat TVs) or floor (standing TVs), mouse wheel to rotate floor models, E to confirm, X to cancel.
- Pick up through ox_target. Server verifies license ownership and inventory capacity before returning item.
- Admins with `group.admin` ACE can use `/tvadminremove` to select the nearest placed TV and permanently remove it (no item refund).
- If your server's admins are granted via a different ACE principal, assign `group.admin` appropriately in server.cfg. The check is `IsPlayerAceAllowed(source, 'group.admin')`.
- Database remembers model, position, heading, owner; playback URLs are **not** saved. TVs spawn off after resource/server restarts.

## Important limitations
- This is an in-game test build. GTA prop pivots vary: wall orientation/offset and floor height may need tuning per model.
- World streaming/interior instancing is not yet handled; all placed TVs are local client objects synchronized via the server.
- GTA named render targets are shared **by model**. Two TVs of the same model near a client cannot display independent videos at once with this renderer.
- The owner is a license identifier, not a character identifier. All characters sharing the same license can pick up that owner's TV.
- No placement cap or housing/property permissions are enforced yet; restrict item distribution until tested.
- Test on a staging server first; back up your database and the working v0.4.4.1 ZIP.

**Item identifier:** `tv` (display label remains Television). If you previously added `television` to items.lua, replace its key with `tv` and restart ox_inventory.

## v0.5.0.2 Placement controls
Uses ox_lib textUI at right-center (no GTA top-left help text). Aim at a surface to position the ghost. G toggles wall snapping; E places; X cancels; arrow up/down adjust height by 5 cm; arrow left/right adjust wall clearance by 2.5 cm; mouse wheel rotates in manual mode. In wall-snap mode heading is aligned to the wall automatically. The existing server-side placement validation, database persistence, owner-only pickup and ACE-protected admin removal are unchanged.
\n\n### v0.5.0.3 NPC-style placement\n- ox_lib instruction panel at top-centre.\n- Aim and left-click to lock the preview to a chosen surface; click again to reposition.\n- WASD fine movement, Q/R height, left/right arrows or mouse wheel rotation, up/down arrows wall clearance. Shift fast, Ctrl precision.\n- G toggles wall snapping. E confirms and saves; X or Backspace cancels.\n- This changes placement interaction only; existing ownership, persistence and playback remain unchanged.\n

### v0.5.0.4 placement controls
- F toggles Walk / Adjust mode while placement remains active. Walk mode enables normal WASD movement to approach walls and desks; left-click still selects a surface.
- Wall-mounted models accept vertical wall surfaces only; standing TVs and monitor models accept horizontal surfaces (desks, shelves, floors).
- E places the selected TV; X cancels. Wall snapping (G) applies to wall-mounted models only.
- The top-centre ox_lib panel shows the mode and permitted surface type.

### v0.5.0.5 free placement
- No surface-type restriction. Left-click sets the preview wherever the camera points, including fallback points when a desk/MLO wall has no collision hit.
- G toggles optional wall alignment when a wall normal is available. Free placement works even without detected collision.
- Short ox_lib top-centre controls; F walk/adjust, E place, X cancel, Q/R height, WASD fine move, arrows adjust.
- Server still checks distance, item ownership and spacing. Clicks beyond server's allowed range may be rejected; move closer using F.
\n\n### v0.5.0.6 Aim beam\nThe placement camera now draws a cyan beam to the current aiming point and a small cyan target marker. Left-click locks the TV preview to that target; click again to choose another position. Missing raycast collision falls back to a point along the camera ray, so no 'valid surface' requirement is reintroduced. Other placement controls are unchanged.\n

### v0.5.0.7 targeting fix
- Replaced immediate reads of asynchronous raycasts with a synchronous collision probe.
- TV preview follows the live aim point until left-click locks the position.
- Small cyan marker shows the aiming point; small amber marker shows the TV model origin.
- Desk/floor models compensate for their bounding-box bottom, so the base is placed on the selected surface.
- G still toggles wall snapping. E confirms; F toggles walking.
- If an MLO surface has no collision, aiming uses the end of the camera ray; manually adjust the preview.

### v0.5.0.8 raycast self-hit fix
Aim ray now excludes the TV preview object, avoiding a feedback loop where the beam hits the TV itself. When a custom interior has no collision, mouse wheel before clicking adjusts the aim distance. Left click locks the selected position; E places.
