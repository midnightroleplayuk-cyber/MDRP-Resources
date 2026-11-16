-- ------------------------------------------------------------
-- RECADO: full messenger (docs/ARQUITETURA.md section 9)
-- Its own name and design. Built on the Phase 2 messages, groups, media and voice (app = 'recado').
-- Honest limitations: video and screen sharing are not real in FiveM's CEF (simulated video call);
-- GIF only with a provider and key; "ver uma vez" (view once) does not prevent screenshots; no end-to-end encryption.
-- ------------------------------------------------------------
Config.Recado = {
    enabled = true,
    pinsMax = 3,              -- pinned messages per conversation
    forwardMax = 5,           -- recipients per forward
    multiImageMax = 10,       -- images per send
    captionMax = 1000,
    textMax = 4000,
    hdImageBytes = 520000,    -- "HD" quality (normal uses Config.Media.maxImageBytes)
    disappearing = { 86400, 604800, 7776000 },   -- 24 h, 7 days, 90 days
    statusHours = 24,
    statusMaxPerDay = 30,
    polls = { maxOptions = 12 },
    events = { reminders = { 0, 15, 60, 1440 } },   -- minutes before the event
    -- GIF: 'none' (disabled) | 'tenor' (needs a key in a server convar: set recado_gif_key "...")
    gif = { provider = 'none', keyConvar = 'recado_gif_key', limit = 20 },
    channels = { maxAdmins = 8, maxPerOwner = 5 },
    communities = { maxGroups = 20, maxPerOwner = 3 },
    calls = { maxGroupParticipants = 8, scheduledMaxDays = 30, videoProvider = 'simulated', screenShare = false },
    stickers = { 'basicos', 'cidade', 'reacoes' },
}