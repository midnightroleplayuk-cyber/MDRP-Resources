// ─────────────────────────────────────────────────────────────────────────────
// TRANSITIONS
//
// A transition is a KEYFRAME MACRO, not a runtime concept. You pick two
// existing keyframes — the last of the outgoing shot (`from`) and the first of
// the incoming one (`to`) — and the macro fills the gap between them with real
// keyframes carrying the right pos/rot/fov/easing/cut/effects.
//
// That means:
//   • everything a transition produces stays hand-editable afterwards
//   • three of the four need ZERO Lua support — they're just camera keyframes
//     plus effects that already exist (motionBlur, shake, timeScale, fov)
//   • the export path can't desync, because there is nothing new to evaluate
//
// The one exception is the wipe, which needs a screen overlay. It's carried on
// a keyframe as `effects.wipe` and driven by frame window on the Lua side —
// NOT lerped, because effects are held (not interpolated) across a cut and a
// wipe has to survive exactly that.
//
// Easing semantics (from the Lua evaluator, don't get these backwards):
//   • kf.easing describes the curve LEAVING that keyframe, i.e. the segment
//     kf → next.
//   • kf.cut = true means "hard cut INTO me": the previous keyframe's pose is
//     held for the whole preceding segment, then the camera snaps here.
// ─────────────────────────────────────────────────────────────────────────────

(function (global) {
    'use strict';

    // ── Math helpers ─────────────────────────────────────────────────────────

    function lerp(a, b, t) { return a + (b - a) * t; }

    function clamp(v, lo, hi) { return v < lo ? lo : (v > hi ? hi : v); }

    function addV(p, x, y, z) { return { x: p.x + x, y: p.y + y, z: p.z + z }; }

    function midV(a, b) {
        return { x: (a.x + b.x) / 2, y: (a.y + b.y) / 2, z: (a.z + b.z) / 2 };
    }

    function dist2D(a, b) {
        const dx = b.x - a.x, dy = b.y - a.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    // GTA camera yaw: 0 = north (+Y), increasing counter-clockwise.
    function headingTo(from, to) {
        const dx = to.x - from.x, dy = to.y - from.y;
        if (dx === 0 && dy === 0) return 0;
        return Math.atan2(-dx, dy) * 180 / Math.PI;
    }

    // Negative pitch = looking down.
    function pitchTo(from, to) {
        const flat = dist2D(from, to);
        if (flat < 0.01) return (to.z > from.z) ? 89 : -89;
        return Math.atan2(to.z - from.z, flat) * 180 / Math.PI;
    }

    // Shortest signed difference b-a on a 360 wrap, so a generated yaw offset
    // never sends the camera the long way round (the Lua rot lerp is shortest
    // path too — this keeps the JS preview and the evaluator agreeing).
    function angleDelta(a, b) {
        let d = (b - a) % 360;
        if (d > 180) d -= 360;
        if (d < -180) d += 360;
        return d;
    }

    // ── Transition catalogue ─────────────────────────────────────────────────
    //
    // needsDestination: true  → the macro interpolates the camera THROUGH space,
    //                           so the incoming pose has to be a real place.
    //                   false → only the exit pose matters; the destination can
    //                           be anywhere, including the same spot.
    // minSeconds:       refuse to generate below this — the result is mush.

    const CATALOG = [
        {
            id:               'whip',
            label:            'Whip Pan',
            icon:             'fa-solid fa-arrows-left-right',
            needsDestination: true,
            minSeconds:       0.25,
            defaultSeconds:   0.7,
            blurb:            'Fast yaw out, cut at peak blur, whip in from the matching side. The workhorse hidden cut.',
        },
        {
            id:               'rise',
            label:            'Rise & Descend',
            icon:             'fa-solid fa-helicopter',
            needsDestination: true,
            minSeconds:       0.8,
            defaultSeconds:   4.0,
            blurb:            'Climb, travel, descend into the new location. No cut — one continuous move. Calmer than the switch.',
        },
        {
            id:               'gtaswitch',
            label:            'Character Switch',
            icon:             'fa-solid fa-shuffle',
            needsDestination: true,
            // Floor is what the move mechanically needs (four staged keyframes),
            // not what looks best — a hard block on the transition people
            // actually want is worse than letting them make it look rushed.
            // `defaultSeconds` is what the picker offers to stretch the gap to.
            minSeconds:       1.0,
            defaultSeconds:   5.0,
            blurb:            'The GTA V switch. Rips straight up, tops out looking down at the map, streaks across at altitude, then plunges into the new location.',
        },
        {
            id:               'zoompunch',
            label:            'Zoom Punch',
            icon:             'fa-solid fa-magnifying-glass-plus',
            needsDestination: false,
            minSeconds:       0.2,
            defaultSeconds:   0.5,
            blurb:            'Crash-zoom in, cut, crash-zoom out. Punchy accent — works anywhere, even on the same spot.',
        },
        {
            id:               'wipe',
            label:            'Hard Edge Wipe',
            icon:             'fa-solid fa-square',
            needsDestination: false,
            minSeconds:       0.3,
            defaultSeconds:   0.6,
            blurb:            'A hard-edged bar sweeps across and the cut happens behind it. Angle and colour are yours.',
        },
    ];

    function byId(id) {
        for (let i = 0; i < CATALOG.length; i++) {
            if (CATALOG[i].id === id) return CATALOG[i];
        }
        return null;
    }

    // ── Generators ───────────────────────────────────────────────────────────
    //
    // Every generator gets the same shape:
    //   ctx = { from, to, fps, span, mk, fovMin, fovMax }
    // where `span` is (to.frame - from.frame) in frames and `mk(frame, pos, rot,
    // fov)` mints a blank keyframe with a fresh id.
    //
    // They return { insert: [kf…], patch: [{ target, easing }…] } — patches are
    // applied to the from/to keyframes the user already had, so we never
    // silently move or delete their work.

    // Frame at a fraction of the transition, always strictly inside the gap so
    // we can't collide with `from` or `to` and produce a zero-length segment.
    function at(ctx, frac) {
        const f = ctx.from.frame + Math.round(ctx.span * frac);
        return clamp(f, ctx.from.frame + 1, ctx.to.frame - 1);
    }

    const GENERATORS = {

        // Yaw hard in one direction, cut while the frame is unreadable, then
        // continue the SAME screen-direction motion at the destination so the
        // eye reads it as one move.
        whip(ctx, opts) {
            const deg   = opts.degrees != null ? opts.degrees : 60;
            const blur  = opts.blur    != null ? opts.blur    : 1.0;
            const shake = { type: opts.shake || 'PROC_PUNCHY', amplitude: opts.shakeAmp != null ? opts.shakeAmp : 0.55 };

            const outKf = ctx.mk(
                at(ctx, 0.42),
                { ...ctx.from.pos },
                { x: ctx.from.rot.x, y: ctx.from.rot.y, z: ctx.from.rot.z + deg },
                clamp(ctx.from.fov * 1.08, ctx.fovMin, ctx.fovMax)
            );
            outKf.easing            = 'easein';
            outKf.effects.motionBlur = blur;
            outKf.effects.shake      = shake;

            const inKf = ctx.mk(
                at(ctx, 0.5),
                { ...ctx.to.pos },
                { x: ctx.to.rot.x, y: ctx.to.rot.y, z: ctx.to.rot.z - deg },
                clamp(ctx.to.fov * 1.08, ctx.fovMin, ctx.fovMax)
            );
            inKf.cut               = true;   // the actual cut, buried in the blur
            inKf.easing            = 'easeout';
            inKf.effects.motionBlur = blur;
            inKf.effects.shake      = shake;

            // Guard the degenerate case where 0.42 and 0.5 round to the same
            // frame on a very short whip — the cut must land after the out-whip.
            if (inKf.frame <= outKf.frame) inKf.frame = outKf.frame + 1;

            return {
                insert: [outKf, inKf],
                patch:  [
                    { target: ctx.from, easing: 'easein' },
                    // The whip supplies the cut. Leaving a "cut to here" on the
                    // landing keyframe would freeze the whip-in pose and snap,
                    // throwing away the half of the move that sells it.
                    { target: ctx.to, cut: false },
                ],
            };
        },

        // Continuous travel: no cut at all. The altitude also buys the streaming
        // pre-warm the time it needs, which is why this is the one to reach for
        // on a genuine cross-map jump.
        rise(ctx, opts) {
            const flat = dist2D(ctx.from.pos, ctx.to.pos);
            // Auto height scales with the trip but stays sane at both extremes.
            const h    = opts.height != null ? opts.height : clamp(flat * 0.35, 80, 400);
            const apex = opts.apexPitch != null ? opts.apexPitch : -55;
            const aFov = opts.arcFov != null ? opts.arcFov : 65;

            const mid     = midV(ctx.from.pos, ctx.to.pos);
            const apexPos = addV(mid, 0, 0, h);

            const climb = ctx.mk(
                at(ctx, 0.22),
                addV(ctx.from.pos, 0, 0, h * 0.75),
                { x: lerp(ctx.from.rot.x, apex, 0.7), y: 0, z: headingTo(ctx.from.pos, ctx.to.pos) },
                clamp(lerp(ctx.from.fov, aFov, 0.6), ctx.fovMin, ctx.fovMax)
            );
            climb.easing = 'ease';

            const cruise = ctx.mk(
                at(ctx, 0.55),
                apexPos,
                { x: apex, y: 0, z: headingTo(apexPos, ctx.to.pos) },
                clamp(aFov, ctx.fovMin, ctx.fovMax)
            );
            cruise.easing = 'ease';

            const descend = ctx.mk(
                at(ctx, 0.82),
                addV(ctx.to.pos, 0, 0, h * 0.35),
                { x: lerp(apex, ctx.to.rot.x, 0.6), y: 0, z: ctx.to.rot.z + angleDelta(ctx.to.rot.z, headingTo(apexPos, ctx.to.pos)) * 0.35 },
                clamp(lerp(aFov, ctx.to.fov, 0.5), ctx.fovMin, ctx.fovMax)
            );
            descend.easing = 'easeout';

            // Ordering guard for short spans — each stage must be a frame apart.
            if (cruise.frame  <= climb.frame)  cruise.frame  = climb.frame + 1;
            if (descend.frame <= cruise.frame) descend.frame = cruise.frame + 1;

            return {
                insert: [climb, cruise, descend],
                // Slow start out of the shot, so the lift reads as deliberate.
                patch:  [{ target: ctx.from, easing: 'easein' }],
            };
        },

        // The GTA V character switch.
        //
        // What makes it read as *that* move rather than a nice drone shot is the
        // speed profile and the near-nadir look, not the arc:
        //   1. it rips upward off the outgoing shot (hard acceleration)
        //   2. it tops out looking almost straight DOWN at a very wide FOV —
        //      this is the beat where you read "the map"
        //   3. it streaks across at that altitude, camera still pointing down
        //   4. it plunges into the new location and decelerates hard
        //
        // Rise & Descend keeps a shallow pitch and an even speed, which is why
        // it feels like a helicopter and this doesn't. The two altitude
        // keyframes (over the origin, then over the destination) are what give
        // the flat high-speed traverse instead of a lazy parabola.
        gtaswitch(ctx, opts) {
            const flat  = dist2D(ctx.from.pos, ctx.to.pos);
            // Goes much higher than Rise & Descend — the whole point is to get
            // above the city, so the floor is high even on a short hop.
            const h     = opts.height != null ? opts.height : clamp(flat * 0.6, 250, 900);
            const nadir = opts.pitch  != null ? opts.pitch  : -84;   // near straight down
            const wide  = opts.fov    != null ? opts.fov    : 90;    // very wide at altitude
            const blur  = opts.blur   != null ? opts.blur   : 0.9;

            const heading = headingTo(ctx.from.pos, ctx.to.pos);

            // 1 — rip upward. Already most of the way to looking down.
            const lift = ctx.mk(
                at(ctx, 0.16),
                addV(ctx.from.pos, 0, 0, h * 0.45),
                { x: lerp(ctx.from.rot.x, nadir, 0.65), y: 0,
                  z: ctx.from.rot.z + angleDelta(ctx.from.rot.z, heading) * 0.5 },
                clamp(lerp(ctx.from.fov, wide, 0.7), ctx.fovMin, ctx.fovMax)
            );
            lift.easing             = 'ease';
            lift.effects.motionBlur = blur;

            // 2 — top out over where you came from, looking down.
            const overFrom = ctx.mk(
                at(ctx, 0.36),
                addV(ctx.from.pos, 0, 0, h),
                { x: nadir, y: 0, z: heading },
                clamp(wide, ctx.fovMin, ctx.fovMax)
            );
            // Linear on purpose: the traverse should hold a constant speed, not
            // ease in and out of its own midpoint.
            overFrom.easing             = 'linear';
            overFrom.effects.motionBlur = blur;

            // 3 — streak across at altitude. Same height and pitch as step 2, so
            //     the move is a flat translation and the ground rushes past.
            const overTo = ctx.mk(
                at(ctx, 0.64),
                addV(ctx.to.pos, 0, 0, h),
                { x: nadir, y: 0, z: heading },
                clamp(wide, ctx.fovMin, ctx.fovMax)
            );
            overTo.easing             = 'ease';
            overTo.effects.motionBlur = blur;

            // 4 — plunge, decelerating into the new shot.
            const drop = ctx.mk(
                at(ctx, 0.86),
                addV(ctx.to.pos, 0, 0, h * 0.3),
                { x: lerp(nadir, ctx.to.rot.x, 0.6), y: 0,
                  z: ctx.to.rot.z + angleDelta(ctx.to.rot.z, heading) * 0.4 },
                clamp(lerp(wide, ctx.to.fov, 0.55), ctx.fovMin, ctx.fovMax)
            );
            drop.easing             = 'easeout';
            drop.effects.motionBlur = blur * 0.6;

            // Ordering guard for short spans — each stage a frame apart.
            if (overFrom.frame <= lift.frame)     overFrom.frame = lift.frame + 1;
            if (overTo.frame   <= overFrom.frame) overTo.frame   = overFrom.frame + 1;
            if (drop.frame     <= overTo.frame)   drop.frame     = overTo.frame + 1;

            return {
                insert: [lift, overFrom, overTo, drop],
                // Hard acceleration off the outgoing shot — this is the half
                // that makes it feel like a switch rather than a lift-off.
                patch:  [{ target: ctx.from, easing: 'easein' }],
            };
        },

        // Standalone: `to` may be the same pose as `from`, in which case this is
        // an accent rather than a location change.
        zoompunch(ctx, opts) {
            const punch = opts.punch != null ? opts.punch : 0.45;   // fov multiplier going in
            const flare = opts.flare != null ? opts.flare : 1.7;    // fov multiplier coming out
            const blur  = opts.blur  != null ? opts.blur  : 0.6;

            const inKf = ctx.mk(
                at(ctx, 0.45),
                { ...ctx.from.pos },
                { ...ctx.from.rot },
                clamp(ctx.from.fov * punch, ctx.fovMin, ctx.fovMax)
            );
            inKf.easing             = 'easein';
            inKf.effects.motionBlur = blur;
            inKf.effects.shake      = { type: 'JOLT_SHAKE', amplitude: 0.4 };

            const outKf = ctx.mk(
                at(ctx, 0.5),
                { ...ctx.to.pos },
                { ...ctx.to.rot },
                clamp(ctx.to.fov * flare, ctx.fovMin, ctx.fovMax)
            );
            outKf.cut               = true;
            outKf.easing            = 'easeout';
            outKf.effects.motionBlur = blur;

            if (outKf.frame <= inKf.frame) outKf.frame = inKf.frame + 1;

            return {
                insert: [inKf, outKf],
                patch:  [
                    { target: ctx.from, easing: 'easein' },
                    { target: ctx.to,   cut: false },   // the punch owns the cut
                ],
            };
        },

        // Cover-and-reveal. The camera does not move during the sweep — the bar
        // does the work — so this one is distance-independent and safe anywhere.
        //
        // The wipe lives as a frame WINDOW anchored on its keyframe rather than
        // as an interpolated value, because effects are held (not lerped) across
        // a cut and this effect has to run straight through one.
        wipe(ctx, opts) {
            const angle    = opts.angle    != null ? opts.angle    : 15;
            const color    = opts.color    || '#000000';
            const softness = opts.softness != null ? opts.softness : 0.06;

            const startFrame = at(ctx, 0.12);
            const endFrame   = at(ctx, 0.94);
            // The sweep AND the hold have to fit inside this window — the whole
            // effect must be finished before the landing keyframe, or the bar is
            // still covering the screen once the new shot has begun.
            const window     = Math.max(4, endFrame - startFrame);

            // A covered screen is the one moment in a cinematic where you can
            // afford to wait, so the wipe holds there instead of sweeping
            // straight through: bar in, HOLD while the destination streams in,
            // bar out. Without the hold the reveal lands on half-loaded
            // geometry and the wipe has hidden nothing.
            let holdFrames = opts.hold != null
                ? Math.round(opts.hold * ctx.fps)
                : Math.round(window * 0.45);
            // Always leave at least 2 frames of travel on each side, otherwise
            // there's no wipe left — just a cut to black and back.
            holdFrames = clamp(holdFrames, 0, window - 4);

            const wipeFrames = Math.max(4, window - holdFrames);   // sweep in + out

            const sweep = ctx.mk(
                startFrame,
                { ...ctx.from.pos },
                { ...ctx.from.rot },
                ctx.from.fov
            );
            sweep.easing        = ctx.from.easing || 'ease';
            sweep.effects.wipe  = {
                type:     'hardedge',
                angle:    angle,
                color:    color,
                softness: softness,
                frames:   wipeFrames,
                hold:     holdFrames,
                // Playback only: keep holding past `hold` if the world still
                // isn't there. Never applies to export, which stays deterministic.
                waitForStream: opts.waitForStream !== false,
            };

            // Cut lands at the midpoint of the sweep-in — the instant the bar
            // covers the frame completely, and the moment the hold begins.
            const cutKf = ctx.mk(
                startFrame + Math.round(wipeFrames * 0.5),
                { ...ctx.to.pos },
                { ...ctx.to.rot },
                ctx.to.fov
            );
            cutKf.cut    = true;
            cutKf.easing = 'ease';

            if (cutKf.frame <= sweep.frame)    cutKf.frame = sweep.frame + 1;
            if (cutKf.frame >= ctx.to.frame)   cutKf.frame = ctx.to.frame - 1;

            // The sweep owns the cut; a leftover one on the landing keyframe
            // would fire a second, unhidden jump after the bar has cleared.
            return { insert: [sweep, cutKf], patch: [{ target: ctx.to, cut: false }] };
        },
    };

    // ── Public API ───────────────────────────────────────────────────────────

    const Transitions = {

        catalog() { return CATALOG.slice(); },

        get(id) { return byId(id); },

        // Why a given pair can't take a given transition — null when it can.
        // Checked before generating so the UI can explain itself instead of
        // producing something unusable.
        // Structured form. `code` separates the two very different reasons a
        // transition can be unavailable:
        //   'structural' — nothing the picker can do; the keyframes are wrong
        //   'duration'   — the move just needs more room, which is fixable by
        //                  stretching the gap, so the UI offers that instead of
        //                  greying the option out and leaving a dead end
        check(id, from, to, fps) {
            const msg = this.validate(id, from, to, fps);
            if (!msg) return { ok: true, code: null, message: null };
            const def     = byId(id);
            const seconds = (from && to) ? (to.frame - from.frame) / (fps || 30) : 0;
            const isDur   = !!def && from && to && to.frame > from.frame && seconds < def.minSeconds;
            return { ok: false, code: isDur ? 'duration' : 'structural', message: msg };
        },

        validate(id, from, to, fps) {
            const def = byId(id);
            if (!def)              return 'Unknown transition.';
            if (!from || !to)      return 'Select the keyframe the transition starts from and the one it lands on.';
            if (to.frame <= from.frame) return 'The landing keyframe must come after the starting one.';

            // A vehicle/ped-locked keyframe stores pos and rot as an offset in
            // its target's local frame, not in world space. Generating a move
            // from those numbers would put the camera somewhere meaningless, so
            // refuse rather than emit something broken.
            if (from.lockedVehicle || to.lockedVehicle) {
                return 'Transitions need world-space keyframes — unlock the keyframe from its vehicle or ped first.';
            }

            const seconds = (to.frame - from.frame) / (fps || 30);
            if (seconds < def.minSeconds) {
                return `${def.label} needs at least ${def.minSeconds}s between the two keyframes (you have ${seconds.toFixed(2)}s).`;
            }
            if (def.needsDestination && dist2D(from.pos, to.pos) < 1.0 && Math.abs(to.pos.z - from.pos.z) < 1.0) {
                return `${def.label} moves the camera through space — the two keyframes are in the same place.`;
            }
            return null;
        },

        // Distance-aware suggestion, so the picker opens on something coherent
        // instead of making the user learn which one suits which jump.
        suggest(from, to) {
            if (!from || !to) return 'zoompunch';
            const d = dist2D(from.pos, to.pos);
            // Cross-city is the switch's home ground — that's the jump it was
            // designed for. Rise & Descend stays the calmer option below it.
            if (d > 400) return 'gtaswitch';
            if (d > 120) return 'rise';
            if (d > 40)  return 'whip';
            return 'zoompunch';
        },

        // Build the keyframes for a transition. `mk` mints a blank keyframe
        // (frame, pos, rot, fov) — passed in so ids come from the editor's own
        // counter rather than this module keeping a second one.
        build(id, from, to, opts, env) {
            const def = byId(id);
            if (!def) return null;
            const gen = GENERATORS[id];
            if (!gen) return null;

            const ctx = {
                from:   from,
                to:     to,
                fps:    env.fps || 30,
                span:   to.frame - from.frame,
                mk:     env.mk,
                fovMin: env.fovMin != null ? env.fovMin : 5,
                fovMax: env.fovMax != null ? env.fovMax : 120,
            };
            return gen(ctx, opts || {});
        },
    };

    global.Transitions = Transitions;

})(window);
