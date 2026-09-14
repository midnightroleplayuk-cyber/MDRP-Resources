QBX ADMINMENU + PLUTO AMBULANCE CREATOR FULL REVIVE PATCH

What changed
------------
1. Players -> General -> Revive
   - Calls Pluto server export RevivePlayer(target ID)
   - Then tells the target client to call clearPlayerInjury(true)
   - Sets ped health to max and clears GTA visible/bone damage state

2. Admin Options -> Revive (self)
   - Calls Pluto client RevivePlayer()
   - Calls clearPlayerInjury(true)
   - Sets health to max and clears visible/bone damage state

Fallback
--------
If plt_ambulance_job is not started, qbx_adminmenu falls back to the original
qbx_medical:client:playerRevived event.

Recommended resource order
--------------------------
ensure qbx_core
ensure qbx_medical
ensure plt_ambulance_job
ensure qbx_adminmenu

Files modified
--------------
server/main.lua
client/admin.lua

Pluto documentation used
------------------------
Client: clearPlayerInjury(clearVitals), RevivePlayer()
Server: RevivePlayer(targetSrc)
