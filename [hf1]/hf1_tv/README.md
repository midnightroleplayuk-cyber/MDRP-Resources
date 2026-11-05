# hf1_tv 0.2.0 (experimental)

New FiveM TV resource for QBCore and Qbox. It does not depend on framework internals; requires `ox_lib` and `ox_target`.

## Install
1. Stop `ptelevision` and `qb_tv_stage1` (they can conflict over named render targets).
2. Extract the `hf1_tv` folder to `resources`.
3. In server.cfg: `ensure ox_lib`, `ensure ox_target`, then `ensure hf1_tv`.
4. Approach a supported GTA TV and choose **Interact with TV** using ox_target.
5. Choose Test pattern first, then Play a URL.

## Configuration
`Config.PerformanceRadius = 30.0` controls the range where a client creates a DUI and renders the TV. Outside it, the resource renders nothing (the prop's underlying texture may still appear). `Config.SearchRadius` controls the nearest TV selection and should be at least the performance radius. `Config.Models` retains the 17 model hashes and render-target settings from the uploaded Stage 1 resource.

## Playback notes
- Direct MP4/WebM playback is the best initial end-to-end test. Server timestamps approximate sync when joining; exact frame sync is not guaranteed.
- YouTube embeds start muted because of autoplay policy. Shorts and standard/live video links are normalized to the embed player. Restricted/age-gated videos can fail.
- Twitch's player enforces its `parent` host allowlist. CFX NUI hosts may be rejected; this cannot be bypassed by client code.
- TikTok videos use official embed URLs. TikTok Live is best effort only and is frequently blocked by embedded browser restrictions.
- Websites can refuse to be embedded (X-Frame-Options/CSP). The mouse controller is experimental and keyboard typing into DUI is **not** supported by FiveM's standard native API. The controller's dashed area maps pointer coordinates to the TV's DUI, not a live preview.
- GTA named render targets are model-wide, not entity-specific. Two TVs of the same model with different content near a client cannot be independently displayed through this implementation. A per-entity 3D screen renderer would be needed for that.
- This release is **not yet tested in a live FiveM server**. It is a testable build, not a guarantee all external sites will play.

## Security
Arbitrary HTTPS websites can expose players to untrusted content. Set `Config.AllowedWebsiteHosts` to a strict allowlist before deploying publicly. Server validates proximity and URL format; for production, add rate limits and permissions.

## Commands
`/tvtest` plays the test pattern on the closest TV. `/tvdebug` prints nearest TV and active DUI information to F8.

## Next steps
Per-entity rendering for concurrent TVs, tighter timestamp sync, validated URL normalization, improved browser interaction, optional ox_inventory items.
