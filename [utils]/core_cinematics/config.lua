--[[

 ██████╗ ██████╗ ██████╗ ███████╗     ██████╗██╗███╗   ██╗███████╗███╗   ███╗ █████╗ ████████╗██╗ ██████╗███████╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝    ██╔════╝██║████╗  ██║██╔════╝████╗ ████║██╔══██╗╚══██╔══╝██║██╔════╝██╔════╝
██║     ██║   ██║██████╔╝█████╗      ██║     ██║██╔██╗ ██║█████╗  ██╔████╔██║███████║   ██║   ██║██║     ███████╗
██║     ██║   ██║██╔══██╗██╔══╝      ██║     ██║██║╚██╗██║██╔══╝  ██║╚██╔╝██║██╔══██║   ██║   ██║██║     ╚════██║
╚██████╗╚██████╔╝██║  ██║███████╗    ╚██████╗██║██║ ╚████║███████╗██║ ╚═╝ ██║██║  ██║   ██║   ██║╚██████╗███████║
 ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═════╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝╚══════╝

--]]

Config = {

    -- Set to false to let every player open and use the editor without any
    -- ACE permission check. Admin projects (see AdminAcePerm) are still
    -- gated so they don't become public.
    RequireAcePermission = true,

    -- Permission ace required to use the editor (when RequireAcePermission
    -- is true). Falls back to the generic 'command' ACE for any admin who
    -- can run server commands.
    --
    -- If your server uses a custom permission system instead of ACE, you can
    -- grant access at runtime via server exports:
    --     exports.core_cinematics:grantAccess(src)   -- allow this session
    --     exports.core_cinematics:revokeAccess(src)  -- remove the grant
    --     exports.core_cinematics:hasAccess(src)     -- query current access
    -- Grants are per-session and cleared on disconnect. ACE access still
    -- works alongside grants — a player with either is allowed in.
    AcePerm = 'core_cinematics.use',

    -- Higher-tier ace required to create / see / load "admin" projects.
    -- Admin projects are hidden from anyone without this ace. Falls back to
    -- the generic 'command' ACE if not granted explicitly.
    AdminAcePerm = 'core_cinematics.admin',

    -- Language (file from locales/ folder: en, de, es, fr, etc.)
    Locale = 'en',

    -- Timeline settings
    DefaultFPS   = 30,   -- frames per second
    MaxDuration  = 600,  -- max timeline duration in seconds

    -- Camera movement speed while in Edit Mode
    MoveSpeed       = 12.0,  -- base units per second
    MoveSpeedFast   = 60.0,  -- SHIFT held units per second
    RotateSpeed     = 3.0,   -- base mouse look sensitivity (smooth, precise)
    RotateSpeedFast = 8.0,   -- SHIFT held mouse look sensitivity (fast panning)
    FovMin          = 5.0,
    FovMax          = 120.0,
    DefaultFov      = 50.0,

    -- Vehicle recording: radius around the player to capture vehicles
    RecordRadius = 150.0,  -- units (metres); all vehicles within this range from you get recorded

    -- When a recorded ped dies (shot, crash ejection, etc.) we keep capturing
    -- it for this many extra frames so the ragdoll fall is recorded instead of
    -- the puppet vanishing the instant the source ped dies. At DefaultFPS=30
    -- this is ~2 seconds — enough for a body to settle.
    PedDeathCaptureFrames = 60,

    -- Live clothing capture: a ped's outfit is captured once when it's first
    -- seen, then re-sampled every this-many seconds during the take. If the
    -- ped swapped a component/prop/texture mid-recording, a timestamped
    -- appearance keyframe is stored and replayed at the right moment on
    -- playback (so an outfit/texture switch shows up instead of being frozen
    -- to the record-start look). Set higher to reduce sampling cost, lower to
    -- catch faster wardrobe changes.
    ClothingRecheckInterval = 10.0,  -- seconds

    -- Camera path preview: max distance (metres) at which the keyframe path is drawn in the 3D world.
    -- Applies to both the director's own path and remote directors' paths received via path sharing.
    PathDrawDistance = 150.0,

    -- Tutorial: when true, the "Enable interactive tutorial" checkbox in the New Project
    -- dialog is UNCHECKED by default. When false (default), it's checked.
    DisableTutorialByDefault = false,

    -- Auto-save: how often (milliseconds) the NUI saves the current project in the background.
    AutosaveInterval = 30000,

    -- Companion video exporter (core-cinematics-recorder.exe). The recorder is
    -- a small Windows app that listens on this URL; the editor's Export panel
    -- talks to it via PerformHttpRequest. Only used when the user opens the
    -- Export view — completely optional, the editor works fine without it.
    ExporterUrl = 'http://127.0.0.1:7861',

    -- Routing buckets used for cinematic preview (isolates each director from
    -- server traffic/NPCs and from OTHER directors who happen to be editing in
    -- the same world location).
    --
    -- The server allocates one bucket per active editor session from this
    -- range, so two players opening the editor in the same alleyway never see
    -- each other's recorded ped / vehicle puppets. Free buckets are returned
    -- to the pool when the editor closes / the player disconnects. Set the
    -- range as wide as the number of concurrent editor sessions you expect
    -- (each bucket only costs a bit of server bookkeeping).
    --
    -- The server also captures whichever routing bucket the player was in
    -- BEFORE opening the editor and restores that same bucket on close — so
    -- servers that use buckets for other features (instances, dungeons, etc.)
    -- never get their players dumped into bucket 0.
    --
    -- Legacy `CinematicBucket = 69` is still respected as a single-bucket
    -- fallback when CinematicBucketRange is nil — every director shares 69
    -- like the original behaviour. Set CinematicBucketRange to enable
    -- per-session allocation.
    CinematicBucket      = 69,
    CinematicBucketRange = { 100, 199 },

    -- Drift smoke (tire smoke during drifts / burnouts)
    -- Applied automatically to vehicles in cinematic playback when they drift
    DriftSmoke = {
        Enabled          = true,    -- master switch — false disables both playback smoke and the live test thread
        PlayerThreadOn   = false,   -- start the live player-vehicle thread enabled? (runtime toggle: /drifttest)
        Density          = 7,       -- particles spawned per bone per cycle (lower = more subtle)
        Scale            = 0.12,    -- size of each particle (lower = thinner haze)
        BackOnly         = true,    -- true = rear wheels only; false = all 4 wheels
        -- Playback slip detection (only used inside cinematic playback, not the live thread)
        PlaybackMinSpeed = 3.0,     -- m/s — below this, drift case never fires
        PlaybackCosLimit = 0.94,    -- cos(slip angle); raise toward 1.0 to require less drift to trigger
        BurnoutRpmHi     = 0.85,    -- recorded RPM > this + low fwd speed = burnout case fires
        BurnoutSpeed     = 12.0,    -- m/s — burnout case requires fwd speed below this
        RedlineRpm       = 0.97,    -- recorded RPM > this always counts as wheel-spin (regardless of speed)
    },

    -- Default interpolation mode used when a NEW project is created.
    -- Valid values: 'native' | 'eased' | 'spline'
    DefaultInterpolationMode = 'eased',

    -- Default per-keyframe easing applied when Add Keyframe is clicked.
    -- Valid values: 'cut' | 'linear' | 'ease' | 'easein' | 'easeout'
    DefaultKeyframeEasing = 'ease',

    -- Transitions.
    --
    -- A transition fills the gap between two keyframes with a generated move
    -- (whip pan, rise & descend, zoom punch, hard edge wipe). What it produces
    -- is ordinary keyframes, so anything it makes can be edited afterwards like
    -- keyframes you placed yourself.
    --
    -- Streaming pre-warm applies to ALL keyframes, not only generated ones. When
    -- the camera is about to jump somewhere far away, the engine is asked to
    -- start loading that area early — otherwise the first moments after the cut
    -- render as low-detail geometry with textures still streaming in. Costs
    -- nothing when a project stays in one place; it simply never triggers.
    -- Keyframes generated by a transition are skipped when picking the target:
    -- they're staging poses (a character switch tops out ~900m up), not where
    -- the shot lands. The pre-warm aims at the real destination on the ground
    -- and starts the moment the move begins, which is the only way a cross-map
    -- jump has time to finish streaming.
    Transitions = {
        PrewarmEnabled     = true,
        -- Long enough to cover a whole transition, so the request goes out as
        -- the camera starts leaving rather than partway through the move.
        PrewarmLookahead   = 8.0,    -- seconds ahead of the playhead to look
        PrewarmMinDistance = 150.0,  -- metres — jumps shorter than this don't need it
        PrewarmRadius      = 350.0,  -- metres of world to request around the target
    },

    -- External keyframes.
    --
    -- Each entry here becomes a keyframe type in the editor's "Add Keyframe →
    -- External" menu. Drop one on the timeline and it fires the moment the
    -- playhead reaches that frame during playback or export — letting a
    -- cinematic drive the rest of your server ("start the gang war the second
    -- the camera crests the hill").
    --
    -- Per entry:
    --   id           (required) — unique key, saved into the project
    --   label        (required) — name shown in the editor menu / timeline
    --   clientEvent  (optional) — TriggerEvent(name, payload) on the director's client
    --   serverEvent  (optional) — TriggerEvent(name, payload) on the SERVER
    --                             (relayed through core_cinematics, payload.director = source)
    --   export       (optional) — { resource = 'x', func = 'y' }: calls
    --                             exports.x:y(payload) on the director's client
    --   serverExport (optional) — { resource = 'x', func = 'y', args = {...} }:
    --                             calls exports.x:y(...) on the SERVER. With
    --                             `args` set they're passed verbatim (so you can
    --                             wire an existing export with its own
    --                             signature); without args it gets the payload.
    --
    -- payload = { id, label, frame, time (seconds), director (server side only) }
    -- Add as many entries as you like; any combination of the triggers works.
    -- Entries removed from this list stop firing but stay on any timeline that
    -- used them (they just do nothing).
    ExternalKeyframes = {
        -- { id = 'gang_war_start', label = 'Gang war start (zone 5950)',
        --   clientEvent  = 'core_gangs:client:gvCinematicWar',              -- mutes the war UI (gangvideo.lua)
        --   serverExport = { resource = 'core_gangs', func = 'startWar', args = { 5950 } } },
        -- { id = 'fireworks', label = 'Fireworks',
        --   clientEvent = 'myevents:client:fireworks',
        --   export = { resource = 'myevents', func = 'StartFireworks' } },
    },

    -- Control ID used while recording to SAVE the take. Defaults to BACKSPACE (177).
    -- Common alternates: 191 = ENTER, 23 = F, 38 = E.
    -- Full list: https://docs.fivem.net/docs/game-references/controls/
    RecordingStopKey = 177,

    -- Overlay-layer recording reference.
    -- While you record a NEW overlay layer, the rest of the scene that's
    -- already captured (the main recording + every other overlay layer)
    -- replays around you in real time as semi-transparent "ghost" cars and
    -- peds, synced to your take. Lets you nail the timing and placement of a
    -- new pass against what's already there (e.g. weave a second car through
    -- the first one's path). The ghosts are a pure visual aid — they have no
    -- collision, are never part of the recording, and vanish the instant you
    -- stop.
    OverlayRecordingReference = {
        Enabled = true,   -- master switch
        Alpha   = 130,    -- ghost opacity, 0 (invisible) .. 255 (solid). ~130 = half see-through
    },

    -- Weather/time-sync resources we warn about in the World panel.
    -- Each entry is a Lua pattern matched (case-insensitive) against running resource names.
    WeatherConflictPatterns = {
        'weathersync', 'weather%-sync', 'weather_sync',
        'easytime',    'easyweather',
        'vsync',       'vsyncr',
        'cd_easytime', 'cd_easyweather',
        'wasabi_weathersync',
        'qb%-weathersync', 'qbx%-weathersync',
        'es_extended_weather', 'rprogress_weathersync',
    },

    -- Camera shake types.
    -- PROC_* are procedural smooth-noise shakes (Rockstar-editor style handheld
    -- feel) applied per-frame on the camera's own rotation — recommended.
    -- They render during playback in the Eased & Smooth interpolation modes.
    -- The rest are GTA's built-in preset shakes (snappier / more mechanical).
    ShakeTypes = {
        { id = 'PROC_HANDHELD',              label = 'Handheld (Smooth)' },
        { id = 'PROC_BREATH',                label = 'Breathing (Subtle)' },
        { id = 'PROC_PUNCHY',                label = 'Handheld (Punchy)' },
        { id = 'PROC_VEHICLE',               label = 'Vehicle Rumble' },
        { id = 'HAND_SHAKE',                 label = 'Hand Shake' },
        { id = 'SMALL_EXPLOSION_SHAKE',      label = 'Small Explosion' },
        { id = 'MEDIUM_EXPLOSION_SHAKE',     label = 'Medium Explosion' },
        { id = 'LARGE_EXPLOSION_SHAKE',      label = 'Large Explosion' },
        { id = 'JOLT_SHAKE',                 label = 'Jolt' },
        { id = 'VIBRATE_SHAKE',              label = 'Vibrate' },
        { id = 'DRUNK_SHAKE',                label = 'Drunk' },
        { id = 'SKY_DIVING_SHAKE',           label = 'Skydiving' },
        { id = 'FAMILY5_DRUG_TRIP_SHAKE',    label = 'Drug Trip' },
        { id = 'DEATH_FAIL_IN_EFFECT_SHAKE', label = 'Death Fail' },
        { id = 'ROAD_VIBRATION_SHAKE',       label = 'Road Vibration' },
        { id = 'MOTORBIKE_SHAKE',            label = 'Motorbike' },
    },

    -- 3D Text fonts shown in the editor dropdown.
    -- 'family' is the CSS font-family value applied to the text.
    -- 'url' (optional) is a Google Fonts stylesheet link — loaded automatically in both the UI and the text billboard.
    -- Add your own entries here; any valid Google Fonts URL works.
    Fonts = {
        -- ── System fonts (no download needed) ────────────────────────────────
        { label = 'Arial',               family = 'Arial' },
        { label = 'Impact',              family = 'Impact' },
        { label = 'Georgia',             family = 'Georgia' },
        { label = 'Courier New',         family = "'Courier New'" },
        { label = 'Verdana',             family = 'Verdana' },
        -- ── Bold / Display — great for titles ────────────────────────────────
        { label = 'Bebas Neue',          family = "'Bebas Neue'",            url = 'https://fonts.googleapis.com/css2?family=Bebas+Neue&display=swap' },
        { label = 'Anton',               family = "'Anton'",                 url = 'https://fonts.googleapis.com/css2?family=Anton&display=swap' },
        { label = 'Russo One',           family = "'Russo One'",             url = 'https://fonts.googleapis.com/css2?family=Russo+One&display=swap' },
        { label = 'Oswald',              family = "'Oswald'",                url = 'https://fonts.googleapis.com/css2?family=Oswald:wght@400;600;700&display=swap' },
        { label = 'Big Shoulders',       family = "'Big Shoulders Display'", url = 'https://fonts.googleapis.com/css2?family=Big+Shoulders+Display:wght@700;900&display=swap' },
        { label = 'Archivo Black',       family = "'Archivo Black'",         url = 'https://fonts.googleapis.com/css2?family=Archivo+Black&display=swap' },
        { label = 'Alfa Slab One',       family = "'Alfa Slab One'",         url = 'https://fonts.googleapis.com/css2?family=Alfa+Slab+One&display=swap' },
        { label = 'Fjalla One',          family = "'Fjalla One'",            url = 'https://fonts.googleapis.com/css2?family=Fjalla+One&display=swap' },
        { label = 'Black Ops One',       family = "'Black Ops One'",         url = 'https://fonts.googleapis.com/css2?family=Black+Ops+One&display=swap' },
        -- ── Cinematic / Epic (Trajan-style inscription, trailer titles) ──────
        { label = 'Marcellus',           family = "'Marcellus'",             url = 'https://fonts.googleapis.com/css2?family=Marcellus&display=swap' },
        { label = 'Cinzel',              family = "'Cinzel'",                url = 'https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&display=swap' },
        { label = 'Cinzel Decorative',   family = "'Cinzel Decorative'",     url = 'https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@700;900&display=swap' },
        { label = 'Staatliches',         family = "'Staatliches'",           url = 'https://fonts.googleapis.com/css2?family=Staatliches&display=swap' },
        { label = 'Unica One',           family = "'Unica One'",             url = 'https://fonts.googleapis.com/css2?family=Unica+One&display=swap' },
        { label = 'Six Caps',            family = "'Six Caps'",              url = 'https://fonts.googleapis.com/css2?family=Six+Caps&display=swap' },
        -- ── Cinematic / Elegant ──────────────────────────────────────────────
        { label = 'Playfair Display',    family = "'Playfair Display'",      url = 'https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&display=swap' },
        { label = 'Cormorant Garamond',  family = "'Cormorant Garamond'",    url = 'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@700&display=swap' },
        { label = 'Abril Fatface',       family = "'Abril Fatface'",         url = 'https://fonts.googleapis.com/css2?family=Abril+Fatface&display=swap' },
        { label = 'Yeseva One',          family = "'Yeseva One'",            url = 'https://fonts.googleapis.com/css2?family=Yeseva+One&display=swap' },
        { label = 'Philosopher',         family = "'Philosopher'",           url = 'https://fonts.googleapis.com/css2?family=Philosopher:wght@400;700&display=swap' },
        -- ── Modern / Tech / Sci-Fi ───────────────────────────────────────────
        { label = 'Orbitron',            family = "'Orbitron'",              url = 'https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap' },
        { label = 'Exo 2',               family = "'Exo 2'",                 url = 'https://fonts.googleapis.com/css2?family=Exo+2:wght@400;700;900&display=swap' },
        { label = 'Rajdhani',            family = "'Rajdhani'",              url = 'https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;700&display=swap' },
        { label = 'Montserrat',          family = "'Montserrat'",            url = 'https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700;900&display=swap' },
        { label = 'Teko',                family = "'Teko'",                  url = 'https://fonts.googleapis.com/css2?family=Teko:wght@500;700&display=swap' },
        { label = 'Audiowide',           family = "'Audiowide'",             url = 'https://fonts.googleapis.com/css2?family=Audiowide&display=swap' },
        { label = 'Monoton',             family = "'Monoton'",               url = 'https://fonts.googleapis.com/css2?family=Monoton&display=swap' },
        -- ── Moody / Stylised ─────────────────────────────────────────────────
        { label = 'Special Elite',       family = "'Special Elite'",         url = 'https://fonts.googleapis.com/css2?family=Special+Elite&display=swap' },
        { label = 'UnifrakturMaguntia',  family = "'UnifrakturMaguntia'",    url = 'https://fonts.googleapis.com/css2?family=UnifrakturMaguntia&display=swap' },
        { label = 'Pirata One',          family = "'Pirata One'",            url = 'https://fonts.googleapis.com/css2?family=Pirata+One&display=swap' },
        -- ── Sporty / Stylised ────────────────────────────────────────────────
        { label = 'Racing Sans One',     family = "'Racing Sans One'",       url = 'https://fonts.googleapis.com/css2?family=Racing+Sans+One&display=swap' },
        { label = 'Permanent Marker',    family = "'Permanent Marker'",      url = 'https://fonts.googleapis.com/css2?family=Permanent+Marker&display=swap' },
    },

    -- Predefined animations for Scene Editor dropdown
    PredefinedAnimations = {
        -- Idle / Standing
        { label = 'Lean Wall',       dict = 'amb@world_human_leaning@male@wall@back@hands_together@idle_a', anim = 'idle_a' },
        { label = 'Smoke',           dict = 'amb@world_human_smoking@male@male_a@idle_a',                   anim = 'idle_a' },
        { label = 'Clipboard',       dict = 'amb@world_human_clipboard@male@idle_a',                        anim = 'idle_a' },
        { label = 'Drinking',        dict = 'amb@world_human_drinking@coffee@male@idle_a',                  anim = 'idle_a' },
        { label = 'Phone Call',      dict = 'cellphone@',                                                   anim = 'cellphone_call_listen_base' },
        { label = 'Cheering',        dict = 'amb@world_human_cheering@male_a',                              anim = 'base' },
        { label = 'Push-ups',        dict = 'amb@world_human_push_ups@male@idle_a',                         anim = 'idle_a' },
        { label = 'Sit Ground',      dict = 'amb@world_human_picnic@male@idle_a',                           anim = 'idle_a' },
        { label = 'Guard Stand',     dict = 'amb@world_human_guard_stand@male@base',                        anim = 'base' },
        { label = 'Sweeping',        dict = 'amb@world_human_janitor@male@idle_a',                          anim = 'idle_a' },
        -- Emotes
        { label = 'Wave',            dict = 'friends@frj@ig_1',                                             anim = 'wave_a' },
        { label = 'Hands Up',        dict = 'missminuteman_1ig_2',                                          anim = 'handsup_base' },
        { label = 'Point Forward',   dict = 'gestures@m@standing@casual',                                   anim = 'gesture_point' },
        -- Action
        { label = 'Mechanic',        dict = 'mini@repair',                                                  anim = 'fixing_a_ped' },
        { label = 'Salute',          dict = 'anim@mp_player_intcelebrationmale@salute',                     anim = 'salute' },
        { label = 'Fishing',         dict = 'amb@world_human_stand_fishing@idle_a',                         anim = 'idle_a' },
        { label = 'Cop Idle',        dict = 'amb@world_human_cop_idles@male@idle_a',                        anim = 'idle_a' },
    },

    -- Common weapons for Scene Editor dropdown
    CommonWeapons = {
        { label = 'Unarmed',         hash = `WEAPON_UNARMED` },
        { label = 'Pistol',          hash = `WEAPON_PISTOL` },
        { label = 'Combat Pistol',   hash = `WEAPON_COMBATPISTOL` },
        { label = 'Heavy Pistol',    hash = `WEAPON_HEAVYPISTOL` },
        { label = 'SMG',             hash = `WEAPON_SMG` },
        { label = 'Assault Rifle',   hash = `WEAPON_ASSAULTRIFLE` },
        { label = 'Carbine Rifle',   hash = `WEAPON_CARBINERIFLE` },
        { label = 'Pump Shotgun',    hash = `WEAPON_PUMPSHOTGUN` },
        { label = 'Sniper Rifle',    hash = `WEAPON_SNIPERRIFLE` },
        { label = 'RPG',             hash = `WEAPON_RPG` },
        { label = 'Baseball Bat',    hash = `WEAPON_BAT` },
        { label = 'Knife',           hash = `WEAPON_KNIFE` },
        { label = 'Flashlight',      hash = `WEAPON_FLASHLIGHT` },
    },

    -- Color filters via timecycle modifiers
    ColorFilters = {
        { id = 'none',           label = 'None',              timecycle = '' },
        { id = 'desat',          label = 'Desaturated',       timecycle = 'hud_def_desat_cult' },
        { id = 'sepia',          label = 'Sepia',             timecycle = 'int_lesters' },
        { id = 'bw',             label = 'Black & White',     timecycle = 'NG_blackout' },
        { id = 'warm',           label = 'Warm',              timecycle = 'DRUG_flying_base' },
        { id = 'cold',           label = 'Cold',              timecycle = 'MP_corona_heist_DOF' },
        { id = 'cinematic',      label = 'Cinematic',         timecycle = 'cinema' },
        { id = 'bloom',          label = 'Bloom',             timecycle = 'Bloom' },
        { id = 'drug',           label = 'Drug Trip',         timecycle = 'drug_wobbly' },
        { id = 'damage',         label = 'Damage',            timecycle = 'damage' },
        { id = 'dying',          label = 'Dying',             timecycle = 'dying' },
        { id = 'nightvision',    label = 'Night Vision',      timecycle = 'NVG' },
        { id = 'securitycam',    label = 'Security Cam',      timecycle = 'scanline_cam_cheap' },
        { id = 'spectator',      label = 'Spectator',         timecycle = 'spectator1' },
        { id = 'stunt',          label = 'Stunt',             timecycle = 'stunt_cam_base' },
        { id = 'introblue',      label = 'Intro Blue',        timecycle = 'NG_filmic01' },
        { id = 'introgreen',     label = 'Intro Green',       timecycle = 'NG_filmic02' },
        { id = 'introyellow',    label = 'Intro Yellow',      timecycle = 'NG_filmic03' },
        { id = 'pulse',          label = 'Pulse',             timecycle = 'WeaponDarkIn' },
        { id = 'underwater',     label = 'Underwater',        timecycle = 'art_underwater' },
        { id = 'michealdark',    label = 'Dark Moody',        timecycle = 'prologue_ending_fog' },
        { id = 'explosion',      label = 'Explosion Flash',   timecycle = 'ExplosionJosh' },
    },

}

-- LOCALE SYSTEM
-- Loads locale JSON and provides _L(key, params) for dot-notation lookups.
-- Works on both server and client (config.lua is shared).

local _localeData = {}

do
    local name = Config.Locale or 'en'
    local raw = LoadResourceFile(GetCurrentResourceName(), 'locales/' .. name .. '.json')
    if raw then
        _localeData = json.decode(raw) or {}
    end
end

function GetLocaleData()
    return _localeData
end

function _L(key, params)
    local parts = {}
    for part in string.gmatch(key, '[^%.]+') do
        parts[#parts + 1] = part
    end

    local val = _localeData
    for i = 1, #parts do
        if type(val) ~= 'table' then return key end
        val = val[parts[i]]
    end

    if type(val) ~= 'string' then return key end

    if params then
        val = val:gsub('{(%w+)}', function(k)
            return tostring(params[k] or ('{' .. k .. '}'))
        end)
    end

    return val
end
