QBOX MLO AI ZONES
=================
1. Copy hf1_npcblocker to resources/[standalone]/.
2. Add `ensure hf1_npcblocker` to server.cfg.
3. Restart the server (and reconnect clients) to test.
4. Add new locations as new entries in Config.Zones.

IMPORTANT LIMITATIONS:
- SetRoadsInArea uses a bounding rectangle, not the exact 4-corner polygon.
- This does NOT rebuild YND vehicle paths or YNV pedestrian navmesh.
- Density suppression is local to players in the polygon and may also affect nearby streets.
- Existing ambient entities are removed only when locally controlled and classified as population entities.
- Networked mission/script NPCs, player vehicles and other resources' entities are intentionally spared.
- Other resources may override density/road behavior; test on your server.
- If you want cars to reroute naturally, edit the map's YND/YVN nav data instead.
