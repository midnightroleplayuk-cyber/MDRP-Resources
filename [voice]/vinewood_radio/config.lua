Config = {}

Config.Debug = false
Config.Brand = 'Airwave'            -- title used on notifications

-- How players open the terminal
Config.Command = 'radio'
Config.OpenKey = 'F10'              -- default keybind (players can rebind in Settings > Key Bindings > FiveM)

-- Physical item. Server re-checks this every revalidation; lose the item and the radio powers down.
Config.Item = {
    required = true,
    name = 'radio',
}

-- Only these services can register a terminal. Everyone else (civilians, gangs, etc.) is refused.
--   jobs     = { jobName = minimumGrade }
--   jobTypes = Qbox/QB job "type" values that also count (e.g. 'leo', 'ems')
--   issiPrefix = first digit of the radio's ISSI (individual number used for PTP calls)
Config.Services = {
    police = {
        label = 'Police',
        jobs = { police = 0, sheriff = 0 },
        jobTypes = { 'leo' },
        issiPrefix = '1',
    },
    ambulance = {
        label = 'Ambulance',
        jobs = { ambulance = 0 },
        jobTypes = { 'ems' },
        issiPrefix = '2',
    },
    fire = {
        label = 'Fire & Rescue',
        jobs = { fire = 0 },
        jobTypes = {},
        issiPrefix = '3',
    },
}

Config.CallsignMaxLength = 24      -- characters (max 32)

Config.RequireOnDuty = true          -- off-duty staff get "Not registered" (ESX has no duty, treated as on duty)
Config.RevalidateInterval = 30       -- seconds between server checks of job/duty/item for powered radios

-- Every pma-voice radio channel in this range is locked to Config.Services, for ANY radio script.
-- Stops civilians tuning a generic radio onto emergency frequencies.
Config.ReservedChannels = { min = 1, max = 500 }

-- Talkgroups, grouped into folders like a real Sepura terminal.
--   services : which services see the folder (a group can override with its own services)
--   channel  : pma-voice radio channel (must be unique)
--   minGrade : number, or { serviceKey = grade } — optional rank lock
Config.Talkgroups = {
    {
        label = 'Police',
        services = { 'police' },
        groups = {
            { id = 'pol_ops1',    name = 'OPS 1',     channel = 1 },
            { id = 'pol_ops2',    name = 'OPS 2',     channel = 2 },
            { id = 'pol_tac1',    name = 'TAC 1',     channel = 3 },
            { id = 'pol_tac2',    name = 'TAC 2',     channel = 4 },
            { id = 'pol_roads',   name = 'ROADS',     channel = 5 },
            { id = 'pol_arv',     name = 'ARV',       channel = 6 },
            { id = 'pol_cid',     name = 'CID',       channel = 7 },
            { id = 'pol_custody', name = 'CUSTODY',   channel = 8 },
        },
    },
    {
        label = 'Ambulance',
        services = { 'ambulance' },
        groups = {
            { id = 'amb_ops1',   name = 'AMB OPS 1', channel = 20 },
            { id = 'amb_ops2',   name = 'AMB OPS 2', channel = 21 },
            { id = 'amb_hems',   name = 'HEMS',      channel = 22 },
            { id = 'amb_clin',   name = 'CLINICAL',  channel = 23 },
        },
    },
    {
        label = 'Fire',
        services = { 'fire' },
        groups = {
            { id = 'frs_ops1',   name = 'FRS OPS 1',  channel = 30 },
            { id = 'frs_ops2',   name = 'FRS OPS 2',  channel = 31 },
            { id = 'frs_ground', name = 'FIREGROUND', channel = 32 },
        },
    },
    {
        label = 'Interop',
        services = { 'police', 'ambulance', 'fire' },
        groups = {
            { id = 'ess_1',    name = 'ESS 1',     channel = 40 },
            { id = 'ess_2',    name = 'ESS 2',     channel = 41 },
            { id = 'ess_major',name = 'MAJOR INC', channel = 42 },
            { id = 'ess_gold', name = 'GOLD CMD',  channel = 43, minGrade = { police = 4, ambulance = 3, fire = 3 } },
        },
    },
}

-- Point-to-point (individual) calls between terminals
Config.PTP = {
    enabled = true,
    ringTime = 30,              -- seconds before an unanswered call drops
    crossService = true,        -- police can call ambulance/fire ISSIs and vice versa
    callChannelBase = 8000,     -- pma-voice call channels used for PTP (8001, 8002, ...)
    leaveTalkgroup = true,      -- like a real terminal: both parties stop hearing the talkgroup during a call, rejoin after
}

-- Orange/red emergency button on top of the radio
Config.Emergency = {
    enabled = true,
    holdTime = 1000,            -- ms the button must be held
    scope = 'talkgroup',        -- 'talkgroup' | 'service' | 'all'
    cooldown = 30,              -- seconds between activations per player
    blip = true,
    blipTime = 90,              -- seconds
}

Config.PowerHoldTime = 1000     -- ms to hold the red key / knob to power off

-- Push to talk. Players can rebind this in Settings > Key Bindings > FiveM ("Radio: push to talk").
-- It works with the radio closed AND while it's open on screen (the UI follows whatever key is bound).
-- Tip: unbind pma-voice's own "Talk over Radio" key (or set `setr voice_defaultRadio ""`) so only one key talks.
Config.PushToTalk = {
    defaultKey = 'LMENU',       -- default bind for new players (FiveM key name, LMENU = Left Alt)
    command = 'radiotalk',      -- pma-voice's command (runs +radiotalk / -radiotalk)
}

-- On-screen list of everyone on your talkgroup, highlighting who's talking (Septra only)
Config.RadioList = {
    enabled = true,
    visibleByDefault = true,    -- players can toggle it; their choice is remembered
    command = 'radiolist',
    key = '',                   -- optional default bind, e.g. 'F11'
    moveCommand = 'radiolistmove', -- drag the list somewhere else / resize it; saved per player
    maxRows = 12,
}

Config.Sounds = {
    volume = 0.6,               -- master tone volume (multiplied by radio volume)
    listenerClose = true,       -- others on the talkgroup hear CLOSE when someone releases PTT
    outgoingRing = true,        -- caller also hears the PTP tone while ringing
    disablePmaClicks = true,    -- turn off pma-voice's own mic clicks (we play Sepura tones instead)
}

Config.ManagePmaRadio = true    -- toggles pma-voice 'radioEnabled' with the terminal's power

Config.UI = {
    scale = 0.78,               -- radio height as a fraction of screen height
    offset = 40,                -- px from right edge of screen
    hud = true,                 -- small status strip bottom-right while the radio is powered but closed
}

---------------------------------------------------------------------------
-- Civilian / gang handheld radio (Comtel, separate item, no Sepura tones)
---------------------------------------------------------------------------
Config.CivRadio = {
    enabled = true,
    item = 'walkie',
    command = 'walkie',
    openKey = '',               -- optional default keybind, e.g. 'F9'
    min = 501,                  -- must sit above Config.ReservedChannels.max
    max = 999,
    decimals = true,            -- allow 512.5 style frequencies (one decimal place)

    -- Frequencies only certain gangs/jobs can join. Locked server-side for every radio script.
    --   gangs = QB/Qbox gang names, jobs = job names (ESX has no gangs, use jobs)
    private = {
        -- [600] = { gangs = { 'ballas' } },
        -- [601] = { gangs = { 'families' } },
        -- [650] = { jobs = { 'mechanic' } },
    },

    tones = {
        clickTx = true,         -- mic_click_on / mic_click_off when you press and release talk
        clickRx = true,         -- same clicks when someone else starts and stops talking
        keyBeep = true,         -- keypad button beep
    },
}

---------------------------------------------------------------------------
-- Voice effects: how people sound when you hear them on each radio.
-- Uses GTA's radio FX submix, swapped into pma-voice when that radio is on.
--   freq_low / freq_hi     input band-pass (Hz). Narrower = tinnier
--   fudge                  distortion amount (0 = clean, 1+ = crunchy)
--   rm_mod_freq / rm_mix   ring modulator (adds a metallic/digital edge)
--   o_freq_lo / o_freq_hi  output band-pass (Hz)
--   volume                 output level
-- Tune live in-game with /radiofx (needs Config.Debug = true), then copy the values here.
---------------------------------------------------------------------------
Config.VoiceEffects = {
    enabled = true,

    -- Septra / Airwave: clean but narrow, slightly "digital" codec sound
    tetra = {
        freq_low = 300.0, freq_hi = 3400.0,
        fudge = 0.15,
        rm_mod_freq = 30.0, rm_mix = 0.08,
        o_freq_lo = 320.0, o_freq_hi = 3300.0,
        volume = 1.0,
    },

    -- Comtel handheld: cheap analogue, rougher and more distorted
    civ = {
        freq_low = 450.0, freq_hi = 2700.0,
        fudge = 1.1,
        rm_mod_freq = 0.0, rm_mix = 0.0,
        o_freq_lo = 500.0, o_freq_hi = 2500.0,
        volume = 1.0,
    },
}

---------------------------------------------------------------------------
-- Loudspeaker / earpiece
-- A radio on loudspeaker lets people standing near it hear transmissions.
-- Civ radios are on loudspeaker unless the player has the earpiece item.
-- Emergency terminals come with an earpiece but can switch to loudspeaker.
---------------------------------------------------------------------------
Config.Speaker = {
    enabled = true,
    range = 6.0,                -- metres around a loudspeaker radio that bystanders can hear it
    volume = 0.7,               -- bystander volume at point-blank (fades to 0 at range)
    skipNearTalker = 12.0,      -- bystanders this close to the talker already hear them in person
    updateInterval = 500,       -- ms between bystander checks while someone transmits
    voiceTarget = 1,            -- pma-voice's Mumble voice target id (1 unless you've edited pma-voice)
    tetraDefault = false,       -- emergency terminals power on in earpiece mode
    civEarpieceItem = 'earpiece', -- having this item lets a civ radio switch to earpiece
}

---------------------------------------------------------------------------
-- Animations and props, per radio
--   prop      : model held in the hand. Custom props: put the .ydr/.ytyp in this resource's
--               stream/ folder and uncomment the data_file line in fxmanifest.lua
--   hold      : played while the radio is open on screen
--   talk      : played while transmitting with the radio closed
--               talk.prop = true shows the hold prop in hand while talking (handheld style),
--               or a table { model?, bone, offset, rotation } for a different hand/position while talking
--   inVehicle : allow animations while sat in a vehicle
-- flag: 49 = upper body + loop + movement, 50 = upper body + loop (secondary task)
---------------------------------------------------------------------------
Config.Animations = {
    enabled = true,

    tetra = {
        prop = {
            model = 'prop_cs_hand_radio',
            bone = 28422,                       -- right hand
            offset = vec3(0.0, 0.0, 0.0),
            rotation = vec3(0.0, 0.0, 0.0),
        },
        hold = { dict = 'cellphone@', clip = 'cellphone_text_read_base', flag = 49 },
        -- generic_radio_chatter raises the LEFT hand to a shoulder mic, so by default no prop is shown.
        -- To show the radio in the left hand instead, replace prop = false with e.g.:
        --   prop = { bone = 60309, offset = vec3(0.08, 0.03, -0.02), rotation = vec3(-90.0, 0.0, 0.0) }
        -- (60309 = left hand; tune offset/rotation in game)
        talk = { dict = 'random@arrests', clip = 'generic_radio_chatter', flag = 50, prop = false },
        inVehicle = false,
    },

    civ = {
        prop = {
            model = 'prop_cs_hand_radio',
            bone = 28422,
            offset = vec3(0.0, 0.0, 0.0),
            rotation = vec3(0.0, 0.0, 0.0),
        },
        hold = { dict = 'cellphone@', clip = 'cellphone_text_read_base', flag = 49 },
        talk = { dict = 'cellphone@', clip = 'cellphone_call_listen_base', flag = 49, prop = true }, -- handheld up to the face
        inVehicle = false,
    },
}
