Config = {}

-- Copy both values from the Game Link page in AxisPanel.
Config.Url = 'https://axis-panel.com/api/game-link-node'   -- for example https://axis-panel.com/api/game-link-node
Config.Key = 'PASTE_YOUR_KEY_HERE'

Config.PollSeconds = 2         -- how often the server asks AxisPanel for new commands

-- Events tried (on the player's client) for revive and heal, besides the built-in fallback in client.lua.
-- Check your ambulance/medical resource if revive does not fully clear injuries.
Config.ReviveEvents = { 'qbx_medical:client:playerRevived', 'hospital:client:Revive' }
Config.HealEvents = { 'hospital:client:HealInjuries' }
