

-- Simple NUI echo bridge for local testing of MusicController -> Client -> MusicPlayer
-- Receives POSTs from NUI (fetch to https://<resource>/<name>) and immediately
-- forwards them back into the same NUI as window messages.

-- Note: music stream NUI callbacks are handled in modules/music/client.lua


