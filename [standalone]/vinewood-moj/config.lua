Config = {}

-- 'auto', 'qbx', 'qb' or 'esx'
Config.Framework = 'auto'

-- Name shown on the system header and in notifications.
Config.ServiceName = 'Ministry of Justice'
Config.CourtsName = 'HM Courts & Tribunals Service'
-- Crest shown top left. A URL or nui:// path to a PNG/SVG, or false for the built-in crest.
Config.Crest = false

Config.Command = 'moj'          -- staff system (judges, clerks, CPS, defence, probation, prison)
Config.Keybind = false          -- e.g. 'F7'
Config.PortalCommand = 'mycase' -- anyone: their own hearings, fines, orders and unpaid work

---------------------------------------------------------------------------
-- Who can do what. job = minimum grade. Supervisor = minimum grade for
-- overrides (early release, cancelling warrants, deleting cases).
---------------------------------------------------------------------------
Config.Roles = {
    judge     = { jobs = { judge = 0, magistrate = 0 }, supervisor = 0, label = 'Judiciary' },
    clerk     = { jobs = { court = 0, clerk = 0 },     supervisor = 2, label = 'Court clerk' },
    cps       = { jobs = { cps = 0 },                  supervisor = 2, label = 'Crown Prosecution Service' },
    defence   = { jobs = { lawyer = 0, solicitor = 0 }, supervisor = 99, label = 'Defence solicitor' },
    probation = { jobs = { probation = 0 },            supervisor = 2, label = 'Probation Service' },
    prison    = { jobs = { prison = 0, doc = 0 },      supervisor = 2, label = 'HM Prison Service' },
    police    = { jobs = { police = 0, sheriff = 0 },  supervisor = 3, label = 'Police' },
}
Config.RequireOnDuty = false

---------------------------------------------------------------------------
-- vinewood-mdt link. Switches on by itself when the MDT is running.
---------------------------------------------------------------------------
Config.MDT = {
    enabled = true,
    resource = 'vinewood-mdt',
    CaseFromCharge = true,       -- a CPS "charge" decision in the MDT opens a court case here
    WriteNotes = true,           -- court results are added to the person's MDT timeline as notes
    MirrorWarrants = true,       -- warrants issued by the court appear in the MDT (and flag Wanted)
    UpdateBail = true,           -- court bail conditions replace the MDT's police bail conditions
    AlertPolice = true,          -- exclusion zone and curfew breaches go to police as MDT calls
}

---------------------------------------------------------------------------
-- vinewood-interviews: interview recordings for a case can be played on courtroom screens
-- (every speaker's audio and the CCTV, in sync). Read-only; switches on by itself when running.
---------------------------------------------------------------------------
Config.Interviews = {
    enabled = true,
    resource = 'vinewood-interviews',
}

---------------------------------------------------------------------------
-- Courts. kind = 'magistrates' or 'crown'. coords are used for the waypoint
-- a defendant gets with their hearing notice.
---------------------------------------------------------------------------
-- The starting list only: copied into the database the first time the resource starts.
-- After that, create, rename and delete courts in game with /courtrooms → Courts.
Config.Courts = {
    { id = 'lsmc', label = "Los Santos Magistrates' Court", kind = 'magistrates', coords = vec3(-545.0, -204.0, 38.2) },
    { id = 'lscc', label = 'Los Santos Crown Court', kind = 'crown', coords = vec3(-545.0, -204.0, 38.2) },
    -- Civil claims are heard in the County Court.
    { id = 'lscounty', label = 'Los Santos County Court', kind = 'county', coords = vec3(-545.0, -204.0, 38.2) },
}

Config.CaseRefPrefix = { magistrates = 'MC', crown = 'T', county = 'CV' }

Config.Listing = {
    -- Courts sit between these hours (server time, 24h). Hearings are listed into the next sitting.
    SittingFrom = 18,
    SittingTo = 23,
    SlotMinutes = 20,                -- gap between hearings in the same court
    FirstHearingHours = 24,          -- bailed defendants: first hearing at least this long after charge
    RemandHearingMinutes = 30,       -- in custody or arrested on warrant: listed this soon
    TrialHours = 48,                 -- not guilty plea: trial listed at least this long after
    SentenceHours = 0,               -- 0 = sentence straight after a guilty plea or verdict
    ReminderMinutes = { 60, 15 },    -- defendants online get reminders this long before
}

---------------------------------------------------------------------------
-- Auto court: when no judge deals with a hearing, the system does.
---------------------------------------------------------------------------
Config.AutoCourt = {
    enabled = true,
    GraceMinutes = 10,          -- after the listed time, wait this long for a judge to open the hearing
    JudgeTakeoverMinutes = 20,  -- a judge is online but hasn't opened it: auto court takes it after this
    PleaTimeoutSeconds = 120,   -- defendant gets a plea prompt; no answer = not guilty entered for them
    -- Defendant not in the city when an auto hearing is due:
    --   'wait'    = hold it until they next log in, then deal with it
    --   'warrant' = treat it as failing to appear (warrant issued)
    Offline = 'wait',
    -- Not guilty pleas need a trial. If no judge has held it TrialWaitHours after it was due:
    --   'wait'    = keep waiting for a judge (judges are reminded)
    --   'convict' = trial on the papers: convicted, no plea credit, sentenced automatically
    --   'acquit'  = case dismissed
    NotGuilty = 'convict',
    TrialWaitHours = 72,
    BreachAction = 'extra_hours', -- community order breach with no judge: 'extra_hours' or 'resentence'
}

---------------------------------------------------------------------------
-- Look of the system: what device it opens on.
-- 'tablet' = handheld tablet (your character holds one), 'laptop' = laptop screen and keyboard,
-- 'none' = plain window.
---------------------------------------------------------------------------
Config.UI = {
    Device = {
        staff = 'tablet',     -- /moj and the tablet item
        portal = 'tablet',    -- /mycase
        laptop = 'laptop',    -- courtroom laptops
    },
    TabletAnim = true,        -- hold a tablet while /moj or /mycase is open
    TabletProp = 'prop_cs_tablet',

    -- Optional ox_inventory item that opens the system. Add it to ox_inventory/data/items.lua:
    --   ['moj_tablet'] = { label = 'Justice tablet', weight = 600, stack = false, close = true,
    --       client = { export = 'vinewood-moj.useTablet' } },
    -- Staff get the court system, everyone else gets their own justice account.
    TabletItem = 'moj_tablet',  -- false = no item
    RequireTabletItem = false,  -- true = /moj only works while carrying the item (courtroom laptops always work)
}

---------------------------------------------------------------------------
-- Courtrooms: built in game with /courtrooms. Laptops open the system for court staff,
-- microphones carry voices across the room (pma-voice).
---------------------------------------------------------------------------
Config.Courtrooms = {
    enabled = true,
    AdminCommand = 'courtrooms',
    -- Any of these aces can build courtrooms. 'command' is what qbx/qb give admins by default.
    AdminAces = { 'vinewood-moj.admin', 'command' },
    -- true = the roles in LaptopOnlyRoles can only open the system from a courtroom laptop.
    -- false = everyone can use /moj anywhere, as well as the laptops.
    CourtRolesNeedLaptop = false,
    -- Only these roles are tied to the courtroom. Everyone else (defence solicitors, CPS, police,
    -- probation, prison) keeps /moj wherever they are to check cases, hearings and warrants.
    LaptopOnlyRoles = { 'judge', 'clerk' },
    -- Roles a new laptop can be set to. A laptop with none ticked is open to all of these.
    LaptopRoles = { 'judge', 'clerk', 'cps', 'defence' },
    LaptopProp = 'prop_laptop_01a',
    MicProp = 'prop_table_mic_01', -- desk microphone for the bench, dock, witness box and advocates' tables
    TargetRadius = 0.7,       -- size of the ox_target sphere on each laptop and microphone
    MicReach = 1.6,           -- stand or sit this close to a microphone for it to pick you up
    MicRange = nil,           -- how far a microphone carries (GTA units). nil = the room's radius
    -- Courtroom speakers (PA). Someone at a live mic is heard by everyone in that courtroom through
    -- its speakers, at a set volume, the way pma-voice plays radio. GTA's own distance fade doesn't
    -- apply, so the back of the room hears as well as the front. Footage on the screens also plays
    -- from the speakers. Place speakers in /courtrooms → the room → Place a speaker.
    PA = true,
    SpeakerProp = 'prop_speaker_02',
    SpeakerVolume = 0.85,     -- volume right next to a speaker (0-1)
    SpeakerRange = 12.0,      -- metres over which it fades from a speaker...
    SpeakerMinVolume = 0.35,  -- ...down to this (anywhere in the room still hears it)
    NoSpeakerVolume = 0.7,    -- a room with no speakers placed: everyone in it hears mics at this volume
    -- When a judge opens a hearing from a courtroom laptop, the defendant is sent to that room.
    WaypointToRoom = true,

    -- TV screens for showing video evidence. Placed in /courtrooms ("Place a screen").
    -- target = the model's render target. Screens using the same target show the same picture,
    -- which is what you want: everything in one courtroom shows the exhibit being played.
    ScreenModels = {
        { model = 'prop_tv_flat_01', target = 'tvscreen', label = 'Flat screen TV (large)' },
        { model = 'prop_tv_flat_michael', target = 'tvscreen', label = 'Flat screen TV (wall)' },
        { model = 'prop_trev_tv_01', target = 'tvscreen', label = 'Flat screen TV (small)' },
        { model = 'prop_huge_display_01', target = 'big_disp', label = 'Large display' },
    },
    -- Who can put footage on the screens, from a laptop in that courtroom.
    ScreenRoles = { 'judge', 'clerk', 'cps', 'defence' },
    -- 'overlay' (default): the picture is drawn over each TV you place or pick, so only those TVs show it and the
    -- same model works in any number of rooms. After placing a screen you fit the picture to it.
    -- 'rendertarget': uses the model's own screen texture. GTA applies that to EVERY TV of that model in view,
    -- so only use it with a model that isn't used anywhere else.
    ScreenRender = 'overlay',
    -- What can be played on the screens. Set any to false to switch it off. Add your own in server/videolinks.lua.
    -- Medal clips play as their direct video file (no Medal player, so no cookie popup; synced and
    -- quieter with distance). false = always use Medal's own embedded player.
    MedalDirect = true,
    Providers = {
        medal = true,         -- medal.tv clips and share links
        youtube = true,       -- videos, shorts, live, youtu.be, with ?t= timestamps
        twitch = true,        -- clips and past broadcasts (not live channels)
        streamable = true,
        vimeo = true,
        dailymotion = true,
        tiktok = true,        -- full tiktok.com/@user/video/... links
        gdrive = true,        -- Google Drive files shared as "Anyone with the link"
        dropbox = true,       -- Dropbox links to a video or image file
        imgur = true,         -- single images and videos (not albums)
        gyazo = true,
        images = true,        -- photos and screenshots (.png .jpg .webp .gif) from any source above or VideoHosts
    },
    -- Direct video and image files (.mp4 .webm .mov / .png .jpg .webp .gif) are allowed from these hosts.
    -- Direct video files are the best option: synced for everyone and quieter with distance.
    VideoHosts = { 'fivemanage.com', 'cdn.discordapp.com', 'media.discordapp.net', 'i.imgur.com', 'files.catbox.moe',
        'dl.dropboxusercontent.com', 'i.gyazo.com' },
    AllowAnyVideoHost = false,  -- true = any https link to a video or image file
    ScreenResolution = { 1280, 720 },
    MaxPlayMinutes = 15,        -- screens go back to the court slate after this long
    ScreenVolume = 0.8,         -- direct video files: volume at the screen (fades out across the room)
}

---------------------------------------------------------------------------
-- Court custody desk: defendants who must be produced are booked in at a desk placed in a
-- courtroom (/courtrooms, "Place a custody desk") before their hearing can go ahead.
---------------------------------------------------------------------------
Config.CustodyDesk = {
    enabled = true,
    Roles = { 'police', 'prison', 'clerk' },     -- who can book defendants in
    -- Always produced through the desk when the defendant is:
    RequireFor = { police_custody = true, remand = true },
    -- Also serious cases (Crown Court, or any indictable-only charge), even when on bail: they
    -- surrender to the custody of the court at the desk.
    Serious = true,
    BookInRange = 12.0,          -- the defendant has to be this close to the desk
    -- Bailed defendants in serious cases who haven't surrendered this long after their hearing
    -- time: failed to surrender, warrant issued. People in custody are never given a warrant,
    -- police and prison are told they haven't been produced instead.
    SurrenderMinutes = 30,
    NotProducedAlertMinutes = 10,
}

---------------------------------------------------------------------------
-- Front desk (reception): for everyone not coming from custody. People on bail and the parties to
-- civil claims check in for their hearing; court staff see who has arrived. Placed in
-- /courtrooms → Courts → Place a desk → Front desk.
---------------------------------------------------------------------------
Config.FrontDesk = {
    enabled = true,
    Roles = { 'clerk', 'judge' },   -- who can open the front desk system (anyone can check themselves in)
    CheckInBefore = 120,            -- minutes before a hearing you can check in
    CheckInAfter = 60,              -- ...and up to this long after its listed time
}

---------------------------------------------------------------------------
-- Civil claims (County Court): one person takes another to court for money, property,
-- a broken agreement or an injunction. Solicitors issue them for their clients.
---------------------------------------------------------------------------
Config.Civil = {
    enabled = true,
    OpenRoles = { 'defence' },        -- who can issue a claim for a client
    AllowLitigantInPerson = true,     -- anyone can take someone to court themselves from /mycase (false = solicitors only)
    Court = 'lscounty',               -- court id from Config.Courts
    Types = {
        { id = 'debt', label = 'Money owed (debt)' },
        { id = 'damages', label = 'Damages for loss or injury' },
        { id = 'contract', label = 'Breach of contract' },
        { id = 'property', label = 'Property or possession' },
        { id = 'injunction', label = 'Injunction (an order to stop someone doing something)' },
        { id = 'other', label = 'Other' },
    },
    -- Court fee for issuing, paid by whoever issues the claim. Banded on the amount claimed.
    Fees = {
        { upTo = 300, fee = 35 }, { upTo = 1000, fee = 70 }, { upTo = 5000, fee = 205 },
        { upTo = 10000, fee = 455 }, { upTo = 100000, pct = 5 }, { pct = 5, max = 10000 },
    },
    NonMoneyFee = 332,                -- claims for something other than money (injunction, property)
    ResponseDays = 3,                 -- real days the defendant has to respond
    AutoDefaultJudgment = true,       -- no response by then: judgment for the claimant automatically
    PayDays = 7,                      -- real days to pay a judgment
    -- Unpaid after PayDays: a County Court Judgment (CCJ) is registered and shown on the MDT.
    RegisterCCJ = true,
    Account = 'bank',

    -- Businesses as claimants or defendants. A business is a job on your framework; its bosses
    -- (isboss grades) act for it from /mycase, and its money is the business (society) account.
    Businesses = true,
    BusinessesCanIssue = true,        -- bosses can take people or other businesses to court for their business
    -- 'auto' finds Renewed-Banking, okokBanking, wasabi_banking, qb-banking, qb-management or esx_addonaccount.
    BusinessBank = 'auto',
    -- Jobs that aren't businesses (can't sue or be sued as a business). Public services are left out,
    -- so a police or court boss brings claims as themselves, not "for the police".
    ExcludeBusinesses = { 'unemployed', 'police', 'sheriff', 'bcso', 'lspd', 'sasp', 'state', 'ambulance', 'ems', 'fire',
        'judge', 'magistrate', 'court', 'clerk', 'cps', 'lawyer', 'solicitor', 'probation', 'prison', 'doc' },
    -- Businesses that aren't jobs (e.g. a company account in your banking script): { id = 'account name', label = 'Name' }
    ExtraBusinesses = {},
}

---------------------------------------------------------------------------
-- Prison (custody). Time is served while the prisoner is in the city.
---------------------------------------------------------------------------
Config.Prison = {
    -- Who holds the prisoner:
    --   'auto'             Vinewood HMP, rcore_prison or pickle_prisons if running, otherwise the built-in prison
    --   'vinewood_prison'  Vinewood HMP: it runs the whole sentence (time, release, escapes) and reports back
    --   'builtin'          this resource (teleport, perimeter, time left on screen)
    --   'rcore_prison', 'pickle_prisons', 'wasabi_police_v2'
    --   'custom'           your own script, with the hooks in Config.Prison.Custom below
    -- Whichever holds them, the court still sets the sentence, counts time served and decides release.
    Script = 'auto',
    MinutesPerMonth = 1,          -- 1 month of sentence = 1 minute served in the city
    MinimumMinutes = 5,
    ReleasePoint = 0.5,           -- automatic release at the halfway point, onto licence
    RemandCounts = true,          -- time on remand comes off the sentence
    Name = 'HMP Bolingbroke',

    -- Built-in prison only
    Spawn = vec4(1661.05, 2524.68, 45.56, 260.5),
    ReleaseAt = vec4(1847.2, 2585.9, 45.67, 270.0),
    Perimeter = { centre = vec3(1690.0, 2590.0, 45.0), radius = 165.0 },
    ConfiscateItems = true,       -- ox_inventory ConfiscateInventory / ReturnInventory

    -- Other prison scripts
    RemandMinutes = 600,          -- time given to the prison script for remand (we let them out when bail is granted)
    -- The prison script stops holding someone before the court's release point (its own timer, a guard
    -- releasing them, a breakout). rcore_prison tells us which it was: breakouts are always escapes.
    -- For scripts that don't (wasabi_police_v2, custom with IsJailed):
    --   'release' = accept it: they're released (onto licence if sentenced)
    --   'escape'  = unlawfully at large: warrant issued, back to prison when police execute it
    EarlyExit = 'release',
    Scripts = {
        -- timeScale converts court minutes into the script's unit (1 = minutes).
        -- prison = estate code to send people to (nil = its default). category = 'A'..'D' or nil for its default.
        vinewood_prison = { timeScale = 1, prison = nil },
        rcore_prison = { timeScale = 1 },
        pickle_prisons = { timeScale = 1, prison = 'default' },
        wasabi_police_v2 = { timeScale = 1 },
    },
    Custom = {
        Jail = function(src, minutes, info)
            -- exports['my_prison']:Jail(src, minutes, info.reason)
        end,
        Release = function(src)
            -- exports['my_prison']:Release(src)
        end,
        IsJailed = nil,           -- optional: function(src) return true end
    },
}

---------------------------------------------------------------------------
-- Probation: community orders, suspended sentences and licence after release.
---------------------------------------------------------------------------
Config.Probation = {
    LicenceDays = 7,              -- real days on licence after release from prison
    RequirementDays = 7,          -- real days that curfew and exclusion requirements on a community order last
    WarningsBeforeBreach = 2,     -- missed appointments / violations before breach action
    RecallMinutes = 15,           -- licence recall: fixed-term return to prison (minutes served)
    BreachExtraHours = 20,        -- added to unpaid work when a breach is dealt with by extra hours
    MonitorEverySeconds = 60,     -- curfew and exclusion zone checks
    CurfewRadius = 40.0,          -- metres from the curfew address
    ExclusionRadius = 120.0,      -- default zone size when set from the officer's position
    -- Named exclusion zones the court can pick from, as well as "here".
    ExclusionZones = {
        { id = 'legion', label = 'Legion Square', coords = vec3(195.0, -935.0, 30.7), radius = 120.0 },
        { id = 'vespucci', label = 'Vespucci Beach', coords = vec3(-1350.0, -1450.0, 4.4), radius = 250.0 },
        { id = 'grove', label = 'Grove Street', coords = vec3(105.0, -1940.0, 20.8), radius = 150.0 },
    },
    Office = { label = 'Probation Office, Mission Row', coords = vec3(441.0, -981.0, 30.7) },
}

---------------------------------------------------------------------------
-- Unpaid work (community service)
---------------------------------------------------------------------------
Config.UnpaidWork = {
    HoursPerTask = 4,             -- one task done in the city counts for this many ordered hours
    TaskSeconds = 25,
    CooldownSeconds = 20,         -- between tasks, so it can't be spammed
    Sites = {
        { label = 'Legion Square clean-up', coords = vec3(195.0, -935.0, 30.7), radius = 45.0,
          scenario = 'WORLD_HUMAN_JANITOR', task = 'Litter picking' },
        { label = 'Vespucci Beach clean-up', coords = vec3(-1300.0, -1520.0, 4.4), radius = 60.0,
          scenario = 'WORLD_HUMAN_GARDENER_PLANT', task = 'Beach clean' },
        { label = 'Strawberry graffiti removal', coords = vec3(200.0, -1450.0, 29.2), radius = 50.0,
          scenario = 'WORLD_HUMAN_MAID_CLEAN', task = 'Graffiti removal' },
    },
}

---------------------------------------------------------------------------
-- Court fines, compensation and the victim surcharge
---------------------------------------------------------------------------
Config.Fines = {
    Currency = '£',
    Account = 'bank',
    DueDays = 28,
    VictimSurcharge = 10,         -- % added to every fine (minimum below). 0 = off.
    VictimSurchargeMin = 50,
    DefaultIncrease = 50,         -- % added when a fine goes into default. 0 = off.
    WarrantOnDefault = true,      -- unpaid this many days after it fell due: arrest warrant
    WarrantAfterDays = 14,
    OnPaid = function(amount, fine)
        -- exports['qb-management']:AddMoney('court', amount)
    end,
}

---------------------------------------------------------------------------
-- Court bail conditions (same ids as the MDT, so they carry over)
---------------------------------------------------------------------------
Config.BailConditions = {
    { id = 'reside',   label = 'Reside and sleep each night at', input = 'address' },
    { id = 'curfew',   label = 'Curfew between', input = 'text', placeholder = '21:00 and 07:00' },
    { id = 'contact',  label = 'Not to contact, directly or indirectly', input = 'text', placeholder = 'Named person' },
    { id = 'exclude',  label = 'Not to enter', input = 'text', placeholder = 'Area or premises' },
    { id = 'report',   label = 'Report to police station', input = 'text', placeholder = 'Mondays and Thursdays' },
    { id = 'passport', label = 'Surrender passport', input = false },
    { id = 'vehicle',  label = 'Not to drive any motor vehicle', input = false },
}

-- Who gets told about what in the city (ox_lib notifications).
Config.Notify = {
    JudgesOnOverdue = true,
    ProbationOnViolation = true,
}
