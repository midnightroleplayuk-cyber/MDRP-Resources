Config = {}

Config.Debug = false

-- 'auto' detects qbx_core, qb-core or es_extended. 'standalone' uses ACE permissions only.
Config.Framework = 'auto'

-- Jobs allowed to start/stop interviews. job = minimum grade.
Config.PoliceJobs = {
    police = 1,
    sheriff = 0,
}

-- Jobs allowed to open the evidence viewer and play back recordings.
Config.ReviewJobs = {
    police = 4,
    sheriff = 0,
}

Config.RequireOnDuty = true

-- ACEs that count as admin: room setup (/interviewadmin) and deleting recordings only.
-- Admins still need a police/review job above to start, end or view interviews.
-- Grant it in server.cfg:  add_ace group.admin vinewood.interviews.admin allow
-- Don't add FiveM's broad 'command' ACE here: many servers give it to every player.
Config.AdminAces = { 'vinewood.interviews.admin' }

-- Standalone mode only: ACEs that stand in for the job checks above.
Config.StandaloneAces = {
    police = 'vinewood.interviews.police',
    review = 'vinewood.interviews.review',
}

Config.AdminCommand = 'interviewadmin'
Config.ViewerCommand = 'interviews'
Config.MicTestCommand = 'interviewmictest'

-- Target system: 'auto' picks ox_target, then qb-target, then qtarget. If none is running,
-- players walk up to the point and press E instead. Force one with 'ox', 'qb', 'qtarget' or 'keypress'.
Config.Target = 'auto'

Config.InteractDistance = 1.5

-- Sessions end automatically after this long, or once the recording area has been empty this long.
Config.MaxDurationMinutes = 90
Config.AutoStopEmptySeconds = 120

Config.Upload = {
    -- Your Fivemanage MEDIA API key.
    -- Recommended: leave this blank and add to server.cfg, above "ensure vinewood-interviews":
    --     set FIVEMANAGE_MEDIA_API_KEY "your-key"
    -- Only paste the key here if you can't edit server.cfg, and never share this file if you do.
    ApiKey = 'SwMM3lrxnKw7NLKKc6nuqFudyV1jmr8L',
    Endpoint = 'https://api.fivemanage.com/api/v3/file',
    PresignedEndpoint = 'https://api.fivemanage.com/api/v3/file/presigned-url',
}

Config.Audio = {
    Enabled = true,
    -- When the mic is captured. Silence is written in between, so every track stays in sync.
    --   'voice' - only while the game says the player is talking (push-to-talk / voice activity). Default.
    --   'level' - whenever the mic hears speech louder than LevelThresholdDb, regardless of in-game voice.
    --             Use this if your voice script doesn't report talking to the game.
    --   'off'   - the whole time the player is in the recording area.
    Gate = 'voice',
    LevelThresholdDb = -45,
    Bitrate = 48000,
    -- Each speaker's audio is uploaded in chunks this long, so a crash only loses the last chunk.
    SegmentSeconds = 300,
    -- How long to wait for final uploads after a session ends before marking missing tracks as failed.
    ProcessingGraceSeconds = 120,
}

--[[
    CCTV replay
    Chosen per interview ("Audio and CCTV replay"). Everyone inside the recording area reports their
    position, heading, animation and talking state. Reviewers watch an in-game reconstruction from the
    room's ceiling camera, synced with the audio.
]]
Config.Replay = {
    Enabled = true,
    SampleMs = 250,     -- how often players are sampled
    KeyframeMs = 4000,  -- a sample is always sent this often, even when nothing changes
    BatchMs = 2000,     -- how often samples are sent to the server
    -- Looping animations to recognise and reproduce. Add whatever your cuff/sit/emote scripts use.
    Anims = {
        { dict = 'mp_arresting', name = 'idle', flag = 49 },                              -- cuffed
        { dict = 'anim@move_m@prisoner_cuffed', name = 'idle', flag = 49 },               -- cuffed (alt)
        { dict = 'random@arrests@busted', name = 'idle_a', flag = 1 },                    -- kneeling, hands on head
        { dict = 'missminuteman_1ig_2', name = 'handsup_base', flag = 49 },               -- hands up
        { dict = 'amb@world_human_hang_out_street@female_arms_crossed@base', name = 'base', flag = 49 }, -- arms crossed
        { dict = 'timetable@ron@ig_5_p3', name = 'ig_5_p3_base', flag = 1 },              -- seated
        { dict = 'anim@amb@office@boardroom@crew@male@var_b@base@', name = 'base', flag = 1 }, -- seated at table
        { dict = 'anim@heists@prison_heistig1_p1_guard_checks_bus', name = 'loop', flag = 1 },
    },
    -- Anyone recorded in a seat scenario is replayed with this seated animation, because scenarios
    -- won't play on the frozen replay copies. Nudge SeatZOffset if replay sitters float or sink.
    SeatAnim = { dict = 'timetable@ron@ig_5_p3', name = 'ig_5_p3_base' },
    SeatZOffset = 0.0,
    -- Scenarios to recognise (sitting on map chairs etc).
    Scenarios = {
        'PROP_HUMAN_SEAT_CHAIR',
        'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER',
        'PROP_HUMAN_SEAT_CHAIR_UPRIGHT',
        'PROP_HUMAN_SEAT_BENCH',
        'WORLD_HUMAN_STAND_IMPATIENT',
    },
}

--[[
    Officer seat CCTV (real footage)
    Mark a seat as the officer seat in /interviewadmin. When a recording is on "Audio and CCTV" and a
    police officer sits there, their screen switches to the ceiling camera and it is recorded as real
    footage until they stand up. Needs the 'screencapture' resource. The CCTV replay still records
    as a backup.
]]
Config.Video = {
    Enabled = true,
    MaxWidth = 1280,
    MaxHeight = 720,
    SettleMs = 1200, -- let the camera view load before recording starts
}

-- Interview room seats placed with /interviewadmin. Players target a seat to sit down.
Config.Seats = {
    Enabled = false,
    Max = 12,                                      -- per room
    Scenario = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER',  -- keep this in Config.Replay.Scenarios so replays show it
    -- Used if the scenario above doesn't start (some MLO spots won't take it). Keep it in Config.Replay.Anims.
    FallbackDict = 'timetable@ron@ig_5_p3',
    FallbackAnim = 'ig_5_p3_base',
    AllowWhenCuffed = true,
    StandKey = 73,                                 -- X
}

-- Vinewood MDT link. When the MDT is running, the start dialog searches it for the interviewee
-- and lists their cases, so the interview is tied to their record and case reference.
Config.MDT = {
    Enabled = true,
    Resource = 'vinewood-mdt',
}

--[[
    Discord evidence log
    When an interview ends and its audio has finished uploading, the case details and a link to
    every audio file are posted to a Discord channel. Anyone with an audio link can play it,
    so use a channel only police can see.
]]
Config.Discord = {
    Enabled = true,
    -- Your Discord webhook URL.
    -- Recommended: leave this blank and add to server.cfg, above "ensure vinewood-interviews":
    --     set vwi_discord_webhook "https://discord.com/api/webhooks/..."
    Webhook = '',
    Username = 'Interview Recorder',
    AvatarUrl = nil,
    MentionRoleId = nil,   -- e.g. '123456789012345678' to ping a CID role
    Colour = 0x1D4FA0,
    IncludeNotes = true,
    MinSeconds = 15,       -- don't post recordings shorter than this (accidental starts)
    ResendCooldownSeconds = 60,
}

Config.Camera = {
    DefaultFov = 60.0,
    -- Optional CCTV grade on the camera image, e.g. 'scanline_cam_cheap'. false = clean image.
    Timecycle = false,
    TimecycleStrength = 0.6,
    -- Max distance an admin can fly the placement camera from their ped.
    MaxPlacementDistance = 40.0,
}

Config.Text = {
    title = 'Interview recorder',
    startLabel = 'Start interview recording',
    stopLabel = 'End interview recording',
    reviewLabel = 'Review recorded interviews',
    startDialog = 'Start interview recording',
    startButton = 'Start recording',
    cancel = 'Cancel',
    modeReplayHint = 'Voices, real footage while an officer sits in the officer seat, and a CCTV replay',
    modeAudioHint = 'Voices only',
    noCamera = 'This room has no ceiling camera, so only audio can be recorded.',
    keepRecording = 'Keep recording',
    endButton = 'End recording',
    elapsedLabel = 'Recorded so far',
    officers = 'Officers present',
    officerHint = 'Add another officer by name',
    add = 'Add',
    remove = 'Remove',
    solicitor = 'Solicitor',
    solicitorHint = 'Leave blank if none present',
    mdtSearchHint = 'Start typing their name to find them on the MDT',
    mdtLinked = 'Linked to their MDT record',
    unlink = 'Unlink',
    mdtCases = 'Their cases on the MDT. Pick one to fill in the case reference.',
    mdtNoCases = 'No cases on the MDT for this person yet.',
    mdtNoMatch = 'No one on the MDT matches. You can still type the name.',
    mdtInCity = 'In the city',
    caseRef = 'Case reference',
    caseRefHint = 'VW/2026/0142',
    interviewee = 'Interviewee',
    intervieweeHint = 'Name of the person being interviewed',
    notes = 'Notes',
    started = 'Recording started. State the date, time, location and everyone present.',
    stopped = 'Recording ended. Files are uploading and will appear in the evidence viewer shortly.',
    confirmStopTitle = 'End interview recording?',
    confirmStop = 'State the time aloud before ending the recording.',
    previewHint = 'Leave preview',
    micFailed = 'Your microphone could not be recorded. Run /interviewmictest to check it.',
    micTestStart = 'Hold your push-to-talk and speak for 4 seconds. It will play back.',
    micTestFail = 'Microphone test failed: %s',
    mode = 'Recording',
    modeReplay = 'Audio and CCTV',
    modeAudio = 'Audio only',
    sitLabel = 'Sit down',
    standHint = 'Stand up',
    cctvRecording = 'Showing and recording the interview camera',
    seatTaken = 'Someone is already sitting there.',
}

Config.Errors = {
    generic = 'Something went wrong. Check the server console.',
    room_incomplete = 'This room is not set up yet. An admin needs to set the button and recording area.',
    no_access = 'You are not authorised to use the interview recorder.',
    already_active = 'An interview is already being recorded in this room.',
    too_far = 'Move closer to the recorder.',
    db = 'The recording could not be created. Check the server console.',
    no_session = 'No interview is being recorded here.',
    no_camera = 'This room has no camera set.',
    room_busy = 'You cannot edit a room while an interview is being recorded in it.',
    no_replay = 'There is no CCTV replay for this recording.',
}
