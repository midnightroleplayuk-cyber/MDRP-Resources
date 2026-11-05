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

## v0.2.1 render-target diagnostics
If `/tvtest` shows nothing, run `/tvdebug` and copy the `Link attempt` and `Render ID` lines from F8. If you restarted only the resource, fully quit FiveM and reconnect once to clear client-side render-target state. Do not run ptelevision or qb_tv_stage1 concurrently. This update adds logging and protected native calls; it does not claim to resolve a failed native link automatically.

## v0.2.2 Render target fix
Accept signed render target IDs (including negative values), and handle FiveM native 0/1 link-state results explicitly. This fixes a confirmed false rejection of the `tvscreen` target. Restart the resource, then try Test pattern first.

## v0.2.3 hotfix
- Replaced unavailable client-side `os.time()` with FiveM `GetCloudTimeAsInt()` to prevent the playback command from crashing.
- Retains v0.2.2 render-target validation fix.
- Test pattern should now be delivered to DUI; streaming embeds remain experimental.


## v0.2.4 YouTube diagnostic patch

The test pattern works, confirming the GTA render target and DUI pipeline. YouTube now uses the standard youtube.com/embed endpoint instead of youtube-nocookie.com, avoids passing an invalid cfx-nui origin, and calculates start offset from server-supplied timestamps. The on-screen status reports iframe load (which does **not** prove playback succeeded). YouTube may still refuse playback due to embed, codec, age or autoplay restrictions. Try a public embeddable video; if it remains blank, report the exact on-screen status and whether the YouTube player UI appears.


## v0.2.5 Playback diagnosis
- Fix server URL validation: Lua patterns do not support regex `?` quantifiers, so YouTube/Twitch/TikTok links were silently rejected.
- Reject invalid requests with client notification and server log.
- Pass initial playback state in DUI page fragment to avoid SendDuiMessage before page JS is ready.
- Confirm with Test Pattern, then a public YouTube video. If the YouTube iframe remains blank, check embedded browser restrictions; do not assume this fixes CEF platform playback.


## v0.2.6 YouTube audio experiment
YouTube uses `enablejsapi=1` and iframe postMessage commands for `setVolume`, `unMute`, and `playVideo`. After starting a video, select **Interact with TV → Enable Audio / Unmute**. The command is local to the viewer; every player may need to enable sound individually. FiveM CEF may still block unmuting because the ox_lib menu interaction is not a trusted user gesture inside the YouTube iframe. Volume changes remain server-synchronized, but volume does not automatically unmute YouTube. The console's `allowfullscreen` warning is harmless.


### v0.2.7: automatic sound attempt
YouTube now requests unmuted autoplay (`mute=0`) and sends `unMute`, `setVolume`, and `playVideo` to the iframe repeatedly during initialization. Direct videos already attempt audible autoplay before falling back to muted playback. Browser autoplay policies may still prevent sound; use **Enable Audio / Unmute** from the TV menu if necessary. This is an attempted improvement, not a bypass of Chromium or YouTube restrictions.


## v0.2.8 - positional audio
- One **Toggle Mute** menu action, local to each player.
- Starts YouTube embeds muted to avoid the brief 100%-volume burst, then sets volume before unmuting.
- Every 250ms the client sends the selected TV volume multiplied by a distance-based gain.
- `Config.FullVolumeDistance` sets the near-field zone; `Config.PerformanceRadius` is the zero-volume cutoff and DUI unload boundary.
- Distance fades are per viewer; the server-selected base volume stays shared.
- Browser restrictions may still prevent autoplay/unmute on some videos.
- `tvscreen` is a shared GTA render target; this version does not guarantee independent content on multiple TVs of the same model in one client.


## v0.2.9 - initial audio state correction
- Initial DUI URL now includes the viewer's distance-adjusted volume and local mute state, before the iframe starts.
- The YouTube player initializes its volume from this value instead of zero.
- Repeatedly requests setVolume/unMute/playVideo during the iframe startup window, even if an earlier volume update arrived before the player was ready.
- The first Toggle Mute now represents the actual requested local mute state rather than compensating for a missed startup unmute.
- YouTube/CEF may still reject audible autoplay on some content.


## v0.3.0 Twitch FiveM-only diagnostic
- Supports Twitch live channels (`https://www.twitch.tv/channel`) and VODs (`https://www.twitch.tv/videos/123456789`).
- Corrects VOD embed ID format (`v123456789`) and logs the parent hostname visibly on the TV.
- Twitch's official embed **requires an approved parent domain**; the local `cfx-nui` origin may be rejected. This release does not bypass that requirement.
- Twitch embeds start muted; **YouTube-only auto-audio and volume behavior is unchanged**. Twitch volume and distance attenuation are **not yet implemented** because they require a working authorized Twitch player API.
- If Twitch refuses playback, note the on-screen message, Twitch error, and whether a live channel or VOD was tested. A hosted HTTPS player may be necessary.


## v0.3.1 - FiveM-only HLS diagnostic
Adds an **HLS stream (.m3u8) - experimental** choice in Play a URL. Supply an HTTPS `.m3u8` URL that you are authorized to access. This tests whether FiveM CEF supports that stream directly through HTML5 video; error code and stalled messages are displayed on the TV. No external domain or Twitch embed is needed for this diagnostic.

**This is not Twitch channel URL playback.** Twitch channel pages are not direct media URLs. Twitch playback requires legitimately authorized playable stream URLs and may require HLS JavaScript playback support, CORS and appropriate codecs. The script does not obtain Twitch access tokens, bypass access controls or proxy Twitch streams. YouTube functionality is unchanged.

## v0.3.2 - HLS.js MSE compatibility diagnostic
The HLS option now loads HLS.js v1.6.13 from jsDelivr at runtime and attempts playback through Media Source Extensions. It reports CDN load failures, missing MSE support, playlist parsing, CORS/network errors and codec errors on the TV. An internet connection to jsDelivr is required for this experimental build. This is not a Twitch URL converter and does not retrieve protected Twitch stream URLs. YouTube playback is unchanged.

Test with an authorized, public HTTPS HLS playlist that permits cross-origin access. A failed stream may be caused by access restrictions rather than browser capabilities.


## v0.3.4 Twitch direct-DUI test

Twitch URLs now open the Cloudflare Pages player directly in a DUI instead of
inside the local `html/player.html` iframe. Upload the matching v0.3.4
Cloudflare ZIP to Pages Production before installing this FiveM resource.
The hosted page accepts native `SendDuiMessage` volume/mute updates and still
starts muted when distance volume is zero. Twitch's embedded player may still
block playback or automatic sound in FiveM CEF; this is an experiment.
YouTube and all non-Twitch playback still use the original local player.
