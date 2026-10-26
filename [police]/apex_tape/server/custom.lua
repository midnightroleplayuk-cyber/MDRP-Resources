-- Server-only buyer hooks. Preserved by install-update.ps1. Never trust client roles/items.
-- Custom implementations must return the documented values; errors deny the action.
TapeBridgeHooks = {}
-- TapeBridgeHooks.Job = function(source) return {name='police',grade=0,onduty=true} end
-- TapeBridgeHooks.Staff = function(source) return false end
-- TapeBridgeHooks.CanUse = function(source) return false end
-- TapeBridgeHooks.CountItem = function(source,item) return 0 end
-- TapeBridgeHooks.RemoveItem = function(source,item,count) return false end
-- TapeBridgeHooks.AddItem = function(source,item,count) return false end
