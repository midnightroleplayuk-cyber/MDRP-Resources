-- ------------------------------------------------------------
-- VOICE MEMOS ("Gravador"): records with the microphone of the game's browser (MediaRecorder,
-- webm/opus) and keeps the recordings on the server, per character, uploaded in chunks
-- (Config.Media.chunkBytes) into apex_phone_voicememos.
--
-- Honest note: FiveM's CEF does not guarantee microphone access to the phone. When it is refused
-- the app says so and the player can still listen to old recordings.
-- ------------------------------------------------------------
Config.VoiceMemos = {
    enabled = true,
    maxSeconds = 120,       -- longest recording (the voice messages limit, Config.Media.maxAudioSec, does not apply here)
    maxPerPlayer = 30,      -- recordings kept per character (the app asks to delete old ones)
    maxBytes = 1000000,     -- longest recording as a base64 text (120 s at 32 kbps is about 650 000)
    nameMax = 60,           -- characters in a recording name
    keepDays = 0,           -- 0 = keep forever; a number deletes recordings older than that many days
}
