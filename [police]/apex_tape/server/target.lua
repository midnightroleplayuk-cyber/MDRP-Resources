-- Permissions are checked again on every selected action; UI snapshots are cosmetic.
TapeTargetServer={}
local T=TapeTargetServer
local function distance(R,t,pos)
 local a,b=R.liveEnd(t,'a'),R.liveEnd(t,'b')
 if t.brokenAt then
  local _,d=TapeTearMath.nearest(TapeEnhanceMath.paths(t,a,b,Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB),pos)
  return d
 end
 return R.segmentDistance(pos,a,b)
end
function T.handle(src,action,p)
 local R,cfg=TapeRuntime,Config.Target
 local function fail(error)return {success=false,error=error}end
 if not cfg.Enabled then return fail('Tape targeting is disabled.') end
 local allowed=R.canUse(src)
 local ped=GetPlayerPed(src)
 local pos=ped~=0 and GetEntityCoords(ped)
 if action=='target_rules' then
  if type(p.ids)~='table' or #p.ids>cfg.MaxTapes then return fail('Invalid target query.') end
  local rules={}
  for _,id in ipairs(p.ids) do
   local t=R.tapes[tonumber(id)]
   if t and pos and t.bucket==GetPlayerRoutingBucket(src) and distance(R,t,pos)<=cfg.StreamDistance+Config.EditReach then
    local admin=R.admin(src)
    local owner=R.owned(t,src)
    local access=allowed and Config.Access.Enabled and cfg.Access and (owner or admin or Config.Access.AllowAllAuthorized or (Config.Access.Ace~='' and IsPlayerAceAllowed(src,Config.Access.Ace)))
    rules[t.id]={lift=access,lower=access and (not t.accessHold or t.accessHold.holder==src or admin),repair=allowed and cfg.Repair and Config.Repair.Enabled and not t.carry and not t.looseRemoved and t.brokenAt~=nil and R.editable(src,t,true),remove=allowed and cfg.Remove and (cfg.RemovePolicy=='authorized' or owner or admin)}
    if TapeEnhanceServer then for key,value in pairs(TapeEnhanceServer.rules(src,t))do rules[t.id][key]=value end end
   end
  end
  return {success=true,rules=rules}
 end
 if action~='target_remove' or not cfg.Remove or not allowed then return fail('Tape removal is not permitted.') end
 local t=R.tapes[tonumber(p.id)]
 if not t or not pos or GetEntityHealth(ped)<=0 or GetVehiclePedIsIn(ped,false)~=0 or t.bucket~=GetPlayerRoutingBucket(src)
  or distance(R,t,pos)>math.min(cfg.Distance,Config.EditReach) then return fail('Move close to the tape on foot.') end
 if cfg.RemovePolicy=='owner' and not R.owned(t,src) and not R.admin(src) then return fail('You may only remove your own tape.') end
 if not TapeFeaturesServer.checkDeployment(src,'cut',p.ticket) then return fail('Cutting is incomplete or expired.') end
 if not TapeServices.take(src,Config.Inventory.CutItem,1,Config.Inventory.ConsumeCutItem) then return fail('Cutting tool missing or inventory transaction failed.') end
 TapeFeaturesServer.completeDeployment(src)
 if TapePolishServer then TapePolishServer.cutVisual(t,src) end
 R.remove(t.id,src,'target_remove')
 return {success=true}
end
