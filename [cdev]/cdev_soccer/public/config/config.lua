PublicSharedSoccerConfig = {
    -- "pl" for normal PolyZone
    -- "ox" for ox_lib zones
    PolyZone = "ox",
    -- check fxmanifest after to see if everything implemented correctly

    Keybinds = {
        ShootBall = { "mouse_button", "mouse_right" },
        SecondaryAction = { "mouse_button", "mouse_left" },
        GoaleeStance = { "keyboard", "lcontrol" },
        Scoreboard = { "keyboard", "tab" },
        Instructions = { "keyboard", "f9" },
    },

      Permissions = {
        PermCreateField = PERMISSION_HIGH,
        -- New permission settings for manager menu
        RequirePermissionForManager = false, -- Enable/disable permission check
        AllowedJobsForManager = { -- Jobs that can access manager menu
            "soccer",
            "manager"
        },
        -- Optional: require specific grade (set to 0 to ignore grades)
        MinimumGradeForManager = 0 
    },

    Style = {
        StaminaOffsetLeft = "1rem", 
        StaminaOffsetBottom = "7rem",
        KeyInstructionOffsetLeft = "2rem", 
        KeyInstructionOffsetBottom = "20rem",
    },

    UseTarget = true,
    UseGabzMBA = false,
    DisableGunUsage = true,
    WantNPCMarker = true,

    -- In-match ball markers (independent toggles). Pre-match position markers are unaffected.
    BallMarker = {
        -- Arrow above a free (uncontrolled) ball
        ShowFreeBallArrow = true,
        FreeBallColor = { r = 0, g = 255, b = 0, a = 150 },
        FreeBallArrowOffsetZ = 0.4,

        -- Ground ring under the player carrying the ball
        ShowCarrierRing = true,
        CarrierColor = { r = 0, g = 255, b = 0, a = 150 },
        CarrierRingSize = 1.0,
    },

    Drawtext = {
        ManagerMenuControl = 38,
    },

    Addons = {
        rcore_stats = false,
    },

    isUsingLoadExport = false, -- if you are using load export, set this to true

    CountdownStartMatch = 10,
    GoalIntermissionDuration = 5,
    OutIntermissionDuration = 3,
    WinnerIntermissionDuration = 5,
    StaminaCostSprintPerTick = 0.16,
    StaminaRecoverPerTick = 0.16,
    StaminaCostTackle = 25,
    StaminaCostDribble = 15,
    ScoreGoal = 100,
    ScoreGoalEveryone = 15,
    ScoreAssist = 75,
    ScoreShot = 30,
    ScorePass = 50,
    ScoreDefense = 50,

    -- It's not recommended to change these values unless you're sure of it as they will heavily impact gameplay
    ShootStrength = 40.0,
    ShootUpStrengthMultiplier = 10.0,
    ShootUpCAP = 20.0, -- Upwards strength is limited to this value to prevent the ball from flying too high

    BallEntityIgnoreRequestControlFilter = false,

    -- Ball render distance (SetEntityLodDist). Increase if the ball disappears from far away on large MLO pitches.
    -- Values above 40000 may cause visual glitches.
    BallLodDistance = 40000.0,

    -- For development and support feedback only, do not use.
    Debug = false,

    -- Default scoreboard name + logo per side when no player has set custom branding.
    -- Keys must match RED_TEAM (0) and BLUE_TEAM (1) from public/config/fields.lua.
    DefaultTeamBranding = {
        [0] = {
            name = "Midnight Reds",
            imageUrl = "https://iili.io/nkCH8DG.png",
        },
        [1] = {
            name = "Midnight Blues",
            imageUrl = "https://iili.io/nkCHiU7.png",
        },
    },
}
