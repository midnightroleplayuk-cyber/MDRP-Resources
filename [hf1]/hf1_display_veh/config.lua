Config = {}
Config.Command = 'displayveh'
Config.AllowedIdentifiers = {
    'fivem:17286926', -- Kapper
    'fivem:1059188',  -- Hardy
}
Config.StreamDistance = 100.0 -- Spawn locally within this radius (metres)
Config.DespawnDistance = 120.0 -- Remove beyond this radius; must exceed StreamDistance

Config.DistanceCheckInterval = 1500 -- Milliseconds between proximity checks
Config.RotationTick = 0 -- Legacy setting; rotation is now per-frame ONLY for nearby streamed displays

Config.PlacementRayDistance = 150.0 -- Maximum crosshair placement distance
Config.AutoSnapOnClick = true -- Automatically settle on ground/platform when left clicking

Config.DefaultRotationSpeed = 8.0 -- degrees per second
Config.MinRotationSpeed = -60.0
Config.MaxRotationSpeed = 60.0
Config.PreviewStep = 0.05
Config.SpawnDistance = 5.0