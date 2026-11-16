-- ------------------------------------------------------------
-- RECORDING LIMITS PER PHONE (Camera app video + Voice Recorder app)
--
-- Every phone model can have its own maximum length for a VIDEO (Camera app) and for an AUDIO
-- recording (Voice Recorder app). The SERVER applies the limit of the device the player has in hand
-- (the item from Config.Devices that opened the phone); the phone only shows it ("0:07 of 0:30").
--
-- How the limit is chosen, first match wins:
--   1. devices[<item>]           the exact device item (keys of Config.Devices, e.g. 'pear18_black')
--   2. models[<model or family>] every colour of one model at once ('pear18', 's26', 'pearfold', 'novaflip'):
--                                the item name up to the first '_' (pear18_black -> pear18)
--   3. os['ios' | 'android']     every PearPhone or every NOVA
--   4. default                   anything else (generic phone item, Config.RequireItem = false)
--   5. the old settings          Config.Camera.VideoMaxSeconds / VideoMaxBytes and
--                                Config.VoiceMemos.maxSeconds / maxBytes still work when a value is missing here
-- A field that is missing in one level is taken from the next one, so a device entry can set only
-- `videoSeconds` and keep everything else.
--
-- Fields (all optional):
--   videoSeconds    longest video in seconds (3..120). The recording stops by itself at this length.
--   videoMaxChars   largest video in the database, in base64 characters (about 1.33 x the file size).
--                   Missing: worked out from the video quality below (bitrate x videoSeconds). The phone picks
--                   the bitrate from this budget so that a full-length video ALWAYS fits (it never has to cut the end).
--   audioSeconds    longest Voice Recorder recording in seconds (5..1800).
--   audioMaxChars   largest Voice Recorder recording, in base64 characters.
--                   Missing: audioSeconds x audio.charsPerSecond.
--
-- Everything in this file can also be changed live in the in-game admin panel (/phoneadmin > Recordings).
--
-- Upload speed: FXServer kicks a player that sends more than `rateLimiter_netEventSize_rate` bytes per
-- second (default 131072) for longer than the burst ("Reliable network event size overflow"). The phone
-- uploads recordings at `upload.share` of that rate, read from the server's convars (default: about 59 000
-- characters per second). Raise both convars in server.cfg to upload faster, for example:
--   set rateLimiter_netEventSize_rate 262144      (2x faster uploads)
--   set rateLimiter_netEventSize_burst 786432
--
-- VIDEO QUALITY (quality = 'standard' | 'high' | 'ultra'). Typical size of a full-length video and how long
-- it takes to upload (default convars / rate 262144 / rate 524288). The upload runs in the background: the
-- player can keep using the phone while it goes up.
--
--   preset     picture                     bitrate (video + sound)   15 s video          45 s video
--   standard   640 px high, 24 fps, VP8    340 + 32 kbit/s           0.9 MB, 16 s / 8 s / 4 s     2.8 MB, 47 s / 24 s / 12 s
--   high       720 px high, 30 fps, VP8    1000 + 48 kbit/s          2.6 MB, 45 s / 22 s / 11 s   7.9 MB, 133 s / 67 s / 33 s
--   ultra      1080 px high, 30 fps, VP9   2500 + 64 kbit/s          6.4 MB, 109 s / 54 s / 27 s  9.4 MB *, 159 s / 79 s / 40 s
--   (MB = MB of base64 text in the database. A portrait 3:4 video at 720 px is 540 x 720, at 1080 px 810 x 1080;
--    the phone never records above the resolution of its own viewfinder, so it never upscales.)
--   * one video can never be larger than video.maxMB (12 MB by default): long 'ultra' videos and 60 s 'high'
--     videos get a lower bitrate so that they still fit (60 s 'high' = about 890 kbit/s, 45 s 'ultra' = about 1200).
--
--   standard  today's lightest setting: smallest videos and fastest uploads, a bit blocky when things move.
--   high      the default: sharp and smooth at 30 fps; about 3 times longer to upload than standard.
--   ultra     for servers that raised the rateLimiter convars (and MySQL max_allowed_packet, see video.maxMB).
--             VP9 gives the best picture per bit but costs the player more CPU while recording (it falls back
--             to VP8 on a game client that cannot record VP9).
-- ------------------------------------------------------------
Config.Recording = {
    enabled = true,              -- false = the Camera app cannot record video (photos still work). The Voice Recorder
                                 -- has its own switch: Config.VoiceMemos.enabled in config_voicememos.lua

    quality = 'high',            -- 'standard' | 'high' | 'ultra' (see the table above and `presets` below)

    -- WHO MAY RECORD VIDEO (photos are never affected). Checked by the server on every recording; the phone
    -- explains on the shutter why video is not available.
    --   mode = 'all'          everybody
    --          'ace'          only players with the ACE below, e.g. in server.cfg:
    --                           add_ace group.journalist apex_phone.video allow
    --          'job'          only the jobs listed in `jobs`
    --          'ace_or_job'   the ACE OR one of the jobs
    --   jobs = 'police, weazel:2'   comma separated job names; 'name:2' = that job from grade 2 up
    permission = {
        mode = 'all',
        ace  = 'apex_phone.video',
        jobs = '',
    },

    -- 4. anything that is not listed below (generic phone item, or no item at all)
    default = { videoSeconds = 15, audioSeconds = 120 },

    -- 3. per system (optional): uncomment to give every PearPhone / every NOVA the same limit
    os = {
        -- ios     = { videoSeconds = 45, audioSeconds = 300 },
        -- android = { videoSeconds = 45, audioSeconds = 300 },
    },

    -- 2. per model (every colour of one model). The defaults follow the shop prices (Config.Shop):
    --    the most expensive phone records the longest.
    models = {
        pearfold = { videoSeconds = 60, audioSeconds = 600 },   -- PearPhone Fold (2199)
        pear18   = { videoSeconds = 45, audioSeconds = 300 },   -- PearPhone 18 Pro Max (1499)
        s26      = { videoSeconds = 45, audioSeconds = 300 },   -- NOVA S26 Ultra (1399)
        novaflip = { videoSeconds = 30, audioSeconds = 180 },   -- NOVA Fold8 (1199)
    },

    -- 1. per device item (optional, wins over everything): a single colour can be different
    devices = {
        -- pear18_wine = { videoSeconds = 60 },
    },

    -- VIDEO (Camera app). PRECEDENCE, per value: a number set HERE (above 0) > the `quality` preset > the 'high' preset.
    -- Leave height / fps / kbps / audioBps at 0 and codec at 'auto' to let the quality preset decide.
    -- (Old config files that still have numbers here, e.g. height = 640, fps = 24, charsPerSecond = 80000, keep exactly
    --  those numbers: the preset only fills what is 0 or missing.)
    video = {
        audio = true,            -- record the player's microphone with the video (if the player allows it;
                                 -- without the microphone the video is saved silent and the phone says why)
        height = 0,              -- height in pixels of the recorded video (240..1080; the width follows the viewfinder)
        fps = 0,                 -- frames per second (10..30). Lower = lighter on the player's PC
        kbps = 0,                -- video bitrate in kbit/s (100..8000). Higher = sharper, bigger files, slower uploads
        audioBps = 0,            -- bits per second of the sound track (Opus, 16000..128000)
        codec = 'auto',          -- 'auto' (from the preset) | 'vp8' (light) | 'vp9' (better picture, more CPU)
        -- charsPerSecond = 80000,  -- OLD way to set the bitrate (base64 characters per second of video). Still works
                                    -- when kbps is 0; leave it commented to use the preset
        minVideoBps = 150000,    -- floor for the video bitrate (a smaller budget shortens the allowed length instead)
        maxVideoBps = 0,         -- ceiling for the video bitrate (0 = 1.6 x the preset bitrate, at least 2 500 000)
        maxMB = 12,              -- largest single video in MB of base64 text (1..18; 12 = a 9 MB file). Videos are stored
                                 -- in MySQL: max_allowed_packet must be bigger than this (MariaDB 16 MB and MySQL 8 64 MB
                                 -- by default; XAMPP ships 1 MB!). The server reads max_allowed_packet at start and never
                                 -- lets a video go over it (it prints a warning in the console when it is small).
    },

    -- The quality presets. You can change a preset here or add your own and select it in `quality`.
    -- height (px), fps, videoKbps (video bitrate in kbit/s), audioBps (sound in bit/s), codec ('vp8' | 'vp9').
    presets = {
        standard = { height = 640,  fps = 24, videoKbps = 340,  audioBps = 32000, codec = 'vp8' },
        high     = { height = 720,  fps = 30, videoKbps = 1000, audioBps = 48000, codec = 'vp8' },
        ultra    = { height = 1080, fps = 30, videoKbps = 2500, audioBps = 64000, codec = 'vp9' },
    },

    -- AUDIO quality (Voice Recorder app)
    audio = {
        bps = 32000,             -- bits per second (Opus). 32 kbit/s is clear voice
        charsPerSecond = 6400,   -- budget when audioMaxChars is missing (32 kbit/s = 4 000 bytes = 5 333 base64 chars per second, plus room)
    },

    -- STORAGE (the videos stay in the gallery table apex_phone_photos, like the photos)
    storage = {
        maxVideosPerPlayer = 20,        -- videos one character can keep (favourites count too); 0 = no cap
        maxVideoMBPerPlayer = 150,      -- total size of one character's videos in MB of base64 text; 0 = no cap.
                                        -- 150 MB = about 19 full-length 45 s videos at 'high' (shorter videos stop at
                                        -- maxVideosPerPlayer first). It was 60 when every video was 'standard'
        keepDays = 0,                   -- 0 = keep forever; a number deletes NON-favourite videos older than that
    },

    -- UPLOAD pace (see the note at the top)
    upload = {
        share = 0.45,            -- fraction of the server's rateLimiter_netEventSize_rate used by one upload (0.1..0.8).
                                 -- 0.45 leaves room for a video call (Config.VideoCall uses up to about 0.5)
    },

    -- VIDEOS ON THE SOCIAL APPS (a video from the gallery published as a post, story, reel, tweet or Recado status)
    social = {
        enabled    = true,  -- gallery videos can be published on the social apps
        instashot  = true,  -- Instashot feed posts
        stories    = true,  -- Instashot stories
        reels      = true,  -- Reels
        twix       = true,  -- Twix (Tweeter)
        recado     = true,  -- Recado status and chats
        maxSeconds = 60,    -- longest video accepted in a post (0 = only the device limit)
        maxMB      = 12,    -- largest video accepted in a post, in MB of base64 text. 12 = the cap of one video
                            -- (video.maxMB), so any gallery video can be posted; lower it to keep posts lighter
                            -- (8 MB = about 45 s at 'high', 2 minutes at 'standard')
    },
}
