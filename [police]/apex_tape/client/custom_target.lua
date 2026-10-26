-- Buyer-owned custom adapter. Preserved by install-update.ps1.
TapeTargetHooks={}
-- For Target.System='custom', implement all three functions using YOUR target API.
-- Zone fields: name,coords(vector3),size(vector3),rotation,debug,drawSprite,options.
-- Each option supplies label,icon,distance,canInteract() and onSelect().
-- Adapt these callbacks to your target library; return its zone handle.
-- TapeTargetHooks.Ready=function()return GetResourceState('my_target')=='started'end
-- TapeTargetHooks.AddZone=function(zone)return exports['my_target']:AddTapeZone(zone)end
-- TapeTargetHooks.RemoveZone=function(handle)exports['my_target']:RemoveTapeZone(handle)end
