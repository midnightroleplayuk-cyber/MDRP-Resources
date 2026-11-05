# qb_tv_stage1 — FiveM TV render-target test

A new diagnostic resource for QBCore / Qbox. It is **framework-independent at the rendering layer**, so it runs on both. It does not yet implement YouTube, Twitch, menus, server synchronisation, or entity-specific screens.

## Install
1. Extract `qb_tv_stage1` into `resources/[local]/` (any resources directory is fine).
2. In `server.cfg`, add `ensure qb_tv_stage1` after your core framework. Do **not** run ptelevision simultaneously while testing: it may use the same named render targets.
3. Restart the server or run `ensure qb_tv_stage1`.
4. Stand close to a supported TV prop and enter `/tvtest`.
5. The screen should display **TV TEST OK**, moving white dot, and changing clock.
6. Run `/tvdebug` and copy the F8 console lines if the TV is blank. `/tvstop` stops the test.

## Important limitations
- Stage 1 tests **named render targets only**. Some listed props may not actually support the `tvscreen` target despite being in the source configuration. Test a known GTA TV such as `prop_tv_flat_01` first.
- A named render target is shared by a model; all visible instances of the same model may display the pattern. Per-TV rendering needs further design.
- The original model definitions, target names, scales and offsets were copied from the supplied open-source ptelevision config. Scale/offset are reserved for later non-render-target fallback.
- The resource does not spawn TVs. You need a supported prop already in the world.
- No dependency on ox_lib, qb-core or qbx_core for this stage. Compatible with either framework.
- If the test page is blank but `/tvdebug` reports a valid render ID and available DUI, check other resources rendering to `tvscreen`, verify the prop actually supports the target, and check F8 for runtime errors.

## Diagnostics
`/tvtest` creates a 1280x720 local DUI and draws its runtime texture to the nearest supported prop's named render target. `/tvdebug` reports model hash, entity handle, target registration/linking, render ID and DUI availability.

## Credits
TV prop model metadata adapted from Pickle Mods' open-source ptelevision (user-supplied source). This is a separate diagnostic implementation, not a patch of the original scripts.
