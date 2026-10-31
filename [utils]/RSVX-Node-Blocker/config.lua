Config = {}

Config.Command = 'npczones'

Config.DebugCommand = 'npczones_debug'

Config.RefreshCommand = 'npczones_refresh'

-- prints how many zones/areas are live on your own client, handy for checking the caps below
Config.StatusCommand = 'npczones_status'

Config.Ace = 'npcblocker.manage'

-- Fresh table on purpose. The old npc_blocker_zones table and zones.json are never read or migrated,
-- so whatever bad data was crashing players is left behind.
Config.Table = 'rsvx_npcblocker_zones'

Config.ClearInterval = 1500

-- Distance gate. A zone is only applied while the player is within LoadDistance of its edge and is
-- removed again beyond UnloadDistance. Keep Unload bigger than Load so standing on the border can't flap.
Config.GateInterval = 1000
Config.LoadDistance = 250.0
Config.UnloadDistance = 350.0

Config.CellSize = 2.0
Config.MaxGrid = 100

-- Ped/scenario areas. These are conservative defaults, not known engine limits, raise them if you need to.
Config.MaxRects = 24            -- areas one zone may use
Config.MaxActivePedRects = 96   -- areas live at once on one client, across all zones

-- Road nodes. GTA keeps these in a network world-state pool of 20 slots that is replayed to every joining
-- player and kicks them when full, so everything here stays well under 20 (other resources may use slots too).
-- false: never touch road nodes, vehicle-blocking zones then delete NPC cars that enter instead.
Config.RoadNodes = true
Config.MaxRoadRects = 2          -- road areas one vehicle-blocking zone may use
Config.MaxVehicleZones = 4       -- how many zones may have vehicle blocking on (MaxVehicleZones * MaxRoadRects <= MaxActiveRoadRects)
Config.MaxActiveRoadRects = 8    -- road areas live at once on one client, hard stop
Config.MaxVehicleZoneSize = 300.0 -- metres across, vehicle-blocking zones only

Config.MaxZones = 100
