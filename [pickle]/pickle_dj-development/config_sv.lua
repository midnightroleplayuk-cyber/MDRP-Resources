ConfigSV = {}
ConfigSV.StreamingServer = {
    mode = "cloudflare",
    cloudflare = {
        turnTokenId = "73e17b79357fd7eda4a4ef9fcbf01b41",
        apiToken = "a5e05f16661d091e5917f37824e1289ac7c463107559c8a76d33f385222c4db6",
    }
}

-- Per-player music library uploads via FiveManage.
-- Players upload audio files to your FiveManage account; metadata is saved
-- to a per-player database so each player can access their own tracks across
-- sessions. Tracks are NOT shared between players.
--
-- Uses the multipart file-upload endpoint:
--   POST https://api.fivemanage.com/api/file   (multipart field "file")
--   Docs: https://docs.fivemanage.com/api-reference/files/upload-file-multipart
-- Your API key must be scoped for the "Files" API.
ConfigSV.FiveManage = {
    enabled = true,                                     -- master enable
    apiKey = "nCMiCPA2qV7BnslUhVGTtNkmh5DnQgDT",         -- FiveManage API key (Files scope)
    maxFileSizeMB = 12,                                 -- per-file size limit enforced server-side
    maxTracksPerPlayer = 50,                            -- per-player library cap (0 = unlimited)
}
