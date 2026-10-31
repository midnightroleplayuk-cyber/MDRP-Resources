---------------------------------------------------------------------------
-- Scene kit: cones, barriers and signs, and slowing or stopping traffic around them.
---------------------------------------------------------------------------
Config.Scene = {
    Command = 'scenekit',
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
