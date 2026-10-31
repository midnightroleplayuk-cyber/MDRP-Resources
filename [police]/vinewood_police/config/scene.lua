---------------------------------------------------------------------------
-- Scene kit: cones, barriers and signs, and slowing or stopping traffic around them.
---------------------------------------------------------------------------
Config.Scene = {
    Command = 'scenekit',
    -- Police tape: strung between points you choose (lamp posts, cones, fences...), drawn with
    -- web/textures/policeline.png. Shown to everyone, cleared with the rest of your scene.
    Tape = {
        Texture = 'web/textures/policeline.png',
        Width = 0.12,            -- metres from edge to edge
        Sag = 0.06,              -- how far it dips mid-span (per 10 m)
        Flutter = 0.015,         -- movement in the wind (0 = still)
        WaistHeight = 1.0,       -- aimed at the ground, the tape is tied this high
        MaxPoints = 10,          -- points on one length of tape
        MaxSpan = 25.0,          -- longest straight span between two points
        MaxPerOfficer = 6,       -- lengths of tape per officer
        DrawDistance = 80.0,
    },
    MaxPerOfficer = 25,
    Lifetime = 90,            -- minutes before an officer's props clear themselves
    PlaceRange = 10.0,        -- how far from you a prop can go
    -- traffic: placing one of these switches your scene's traffic setting to 'slow' or 'closed'
    -- (only if it's still on Normal). group: groups the buttons in the scene kit.
    Props = {
        { id = 'cone',        label = 'Police cone',          model = 'prop_policeconevw',       group = 'Cones and lights' },
        { id = 'cone_light',  label = 'Cone with lamp',       model = 'prop_air_conelight',      group = 'Cones and lights' },
        { id = 'light',       label = 'Scene light',          model = 'prop_worklight_03b',      group = 'Cones and lights' },
        { id = 'sign_closed', label = 'Road closed sign',     model = 'vw_policeroadclosed',     group = 'Signs', traffic = 'closed' },
        { id = 'sign_accident', label = 'Police accident sign', model = 'vw_policeaccident',     group = 'Signs', traffic = 'slow' },
        { id = 'sign_check',  label = 'Police checkpoint sign', model = 'vw_policeroadcheckpoint', group = 'Signs', traffic = 'slow' },
        { id = 'barrier',     label = 'Police barrier',       model = 'prop_barrier_work05',     group = 'Barriers' },
        { id = 'barrier_mp',  label = 'Crowd barrier',        model = 'prop_mp_barrier_02b',     group = 'Barriers' },
        { id = 'tent',        label = 'Forensic tent',        model = 'forensic_tent',           group = 'Crime scene', minRank = 'pc' },
    },
    -- Traffic around an officer's props: NPC traffic slows to SlowSpeed (m/s) or stops altogether.
    ZoneMargin = 12.0,        -- metres beyond the outermost prop
    SlowSpeed = 4.0,
}
