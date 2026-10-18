Config = {}

-- Command used in-game.
Config.Command = 'propdev'

-- How far the developer ray should travel.
Config.MaxDistance = 50.0

-- Persistent HUD centre dot. Detection still uses the exact centre-camera ray.
Config.DrawCrosshair = true

-- Centre-dot RGBA. Bright green by default. Values are 0-255.
Config.CrosshairColor = { r = 0, g = 255, b = 0, a = 255 }

-- Centre-dot size in normalized HUD coordinates. Keep this value small.
Config.CrosshairDotSize = 0.0050

-- Number of scanlines used to make the centre dot circular.
Config.CrosshairCircleRows = 11

-- Identifier allowlist.
-- Add identifiers exactly as FiveM reports them, for example:
-- 'license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
-- 'license2:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
-- 'discord:123456789012345678'
-- 'fivem:12345678'
-- 'steam:11000010abcdef0'
Config.AllowedIdentifiers = {
    'license:9644ec5d883ebf65f1e18006ce3ee478e07f6cee', --HardyF1
    'license:21cb933ca3b23ddf81816dda68e35afcb7ca576c', --Kapper
}

-- If true, server console can use the command without identifier checks.
Config.AllowConsole = false

-- Optional ACE permission support. If enabled, either an allowed identifier OR
-- this ACE permission grants access. Example server.cfg:
-- add_ace group.admin propdev.use allow
Config.UseAcePermission = false
Config.AcePermission = 'propdev.use'

-- UI options.
Config.ShowHelpText = true
Config.ShowEntityCoords = true
Config.ShowRotation = true
Config.ShowNetworkId = true

-- Key used while Prop Dev is enabled to open the ox_lib copy menu for the
-- entity currently under the crosshair. FiveM control 38 = E.
Config.MenuControl = 38
Config.MenuControlLabel = 'E'

-- Raycast flags. 511 keeps the dev tool broad enough to inspect normal props,
-- vehicles, peds and many static/local map objects.
Config.RaycastFlags = 511

-- Static/MLO props can sometimes return collision as world geometry without an
-- entity handle on a thin LOS ray. A tiny capsule on the same camera ray makes
-- those objects much easier to acquire while the visible laser stays exact.
Config.UseCapsuleFallback = true
Config.RaycastRadius = 0.12

-- How often entity selection is scanned. Rendering remains every frame.
-- Lower values acquire a new target faster; 35ms is responsive without tying shape-test
-- completion to the render loop.
Config.ScanIntervalMs = 35

-- Selection is latched: misses never clear the black info panel. It changes only when
-- another valid entity is positively identified, or when /propdev is toggled off.
