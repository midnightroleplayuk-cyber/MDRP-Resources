# Rockstar Editor

## Recording tape

Rockstar Editor support uses server-created, networked tape objects with artwork embedded in streamed YDR models. Those are actual world objects for the recording system to capture. There is no dependency on a running drawing loop to reconstruct their appearance during playback.

Editor support is enabled by default. In auto mode, nearby standard tape now requests recording objects before recording starts; the procedural ribbon remains the fallback while objects load. Keep the entire `stream` folder and its YTYP registration in fxmanifest.lua. The supplied files cover all 61 shipped UK/English designs, with separate readable faces. Existing placed spans do not need replacing.

1. Restart the resource with the complete updated folder installed.
2. Stand near the tape and wait for models to stream.
3. Run `/tapeeditor on`, wait for models to stream, then run `/tapeeditor status` and confirm the nearby spans you intend to film are loaded. Status now excludes distant spans from its denominator and reports custom-wording exclusions separately. If a span is unavailable, F8 prints whether its update, network object, identity or model is missing.
4. Record a **new** clip, including a lift or sprint tear if required, then check it in Editor before filming a longer scene.

Existing clips cannot gain tape retroactively. The server must allow client replays; `sv_disableClientReplays` must not be enabled. The resource does not change server convars. See the [Cfx server security documentation](https://docs.fivem.net/docs/developers/server-security/).

`/tapeeditor off` stops your request for recording objects. Another nearby viewer can still keep the shared objects active. `/tapeeditor auto` prepares objects whenever standard tape is within Editor.Distance, even before GTA reports recording. A five-second client subscription grace avoids repeated requests at the range edge; the server still enforces its own distance and object budgets. Allow a moment for newly placed tape to stream before recording. This command does not start, save or stop recording. Its name is configurable under Commands.tapeeditor.

## Limits and behaviour

Defaults are Editor.Enabled=true, Mode='auto', Distance=60 metres, MaxTapes=16, MaxObjects=384 and UpdateMs=100. The tape/object limits apply across the server, with nearby spans selected first. Each span uses approximately one object per 1.25 metres, with additional pieces when lifted or torn. A span is included completely or falls back to the normal procedural renderer. A fallback span is visible during gameplay but cannot be relied on in a clip. Use status to check readiness, particularly in large scenes or across multiple populated locations.

Objects follow authoritative endpoints, access lifting/lowering, tears and contact offsets. Recording wind uses a shared timed sway using Wind.Enabled, Strength, Amplitude, Speed and VerticalRatio, rather than each viewer's weather native. Motion updates are bounded by UpdateMs. Segment lengths are quantised in 5 cm steps with small overlap; they do not depend on replay preserving custom entity scale. The physical ribbon is 7.5 cm tall. Decorative procedural attachment folds/tails are still live-only details.

No invisible collision wall is added. Walking deflects the ribbon and stops at it; fast crossings can tear it. Target actions and permissions still use the server's tape record. Network object creation is performed by the server and remains subject to the host's entity policies. Removed/out-of-range spans, expired viewer requests and resource shutdown delete their recording objects. Unsupported custom textures retain the normal renderer until matching model assets are built.

Actual FiveM recording/playback has not been verified in this workspace. Make a short test clip on your server before filming a longer scene.

## Optional live wording

Spans with runtime custom wording deliberately use the procedural live renderer and are excluded from recording objects. `/tapetext clear` restores a nearby span to its baked design for recording; `/tapetext off` only affects future placement. The default one-hand lift shares its target with the recording geometry.
