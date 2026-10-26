TapeTargetClient={}
local T=TapeTargetClient
local zones,rules={},{}
local lastRules=0
local ruleSignature=''
local aimOptionsRegistered=false
local registeredActionCount=0
local aimAt,aimId=nil,nil
local aimNames={'apex_tape:aim:lift','apex_tape:aim:lower','apex_tape:aim:remove','apex_tape:aim:repair'}
local function actions()
 local list={'lift','lower','remove','repair'}
 if TapeEnhanceClient then for _,action in ipairs(TapeEnhanceClient.targetActions)do list[#list+1]=action end end
 return list
end
local function keyFor(action)return ({lift='Lift',lower='Lower',remove='Remove',repair='Repair'})[action] or action end
local function labelFor(action)return Config.Target.Labels[keyFor(action)] or TapeEnhanceClient and TapeEnhanceClient.labels[action] or action end
local function globalId(action)
 return TapeEnhanceClient and TapeEnhanceClient.targetId(action) or T.aimed()
end
local function ready()
 if not Config.Target.Enabled then return false end
 if Config.Target.System=='ox' then return GetResourceState(Config.Target.Resource)=='started' end
 if type(TapeTargetHooks.Ready)~='function' or type(TapeTargetHooks.AddZone)~='function' or type(TapeTargetHooks.RemoveZone)~='function' then return false end
 local ok,value=pcall(TapeTargetHooks.Ready);return ok and value==true
end
local function remove(handle)
 if Config.Target.System=='ox' then return exports[Config.Target.Resource]:removeZone(handle) end
 return TapeTargetHooks.RemoveZone(handle)
end
local function clear()
 if aimOptionsRegistered then pcall(function()exports[Config.Target.Resource]:removeGlobalOption(aimNames)end);aimOptionsRegistered=false end
 aimAt,aimId=nil,nil
 for key,zone in pairs(zones) do pcall(remove,zone.handle);zones[key]=nil end
 rules={};lastRules=0;ruleSignature=''
end
local function distance(id)
 local t=TapeClient.tapes()[id]
 if not t then return math.huge end
 local a,b=TapeClient.liveEnds(t)
 local p=GetEntityCoords(PlayerPedId())
 if t.brokenAt then
  local paths=TapeTearClient and TapeTearClient.paths(t,a,b) or TapeEnhanceMath.paths(t,a,b,Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB)
  local _,d=TapeTearMath.nearest(paths,p);return d
 end
 local x,y,z=b.x-a.x,b.y-a.y,b.z-a.z
 local l=x*x+y*y+z*z
 local f=l>0 and math.max(0,math.min(1,((p.x-a.x)*x+(p.y-a.y)*y+(p.z-a.z)*z)/l)) or 0
 return #(p-(a+(b-a)*f))
end
function T.canInteract(id,action)
 if not Config.Target.Enabled then return false end
 local t=TapeClient and TapeClient.tapes()[id]
 local permission=rules[id]
 if not t or not permission or not permission[action] or IsEntityDead(PlayerPedId()) or IsPedInAnyVehicle(PlayerPedId(),false) then return false end
 local reach=math.min(Config.Target.Distance,Config.EditReach)
 if TapeEnhanceClient and TapeEnhanceClient.isAction(action) then return TapeEnhanceClient.can(id,action) and distance(id)<=reach end
 if action=='lift' then
  if t.brokenAt or t.accessOpen or (TapeAccessClient and TapeAccessClient.holding()) or (TapeEnhanceClient and TapeEnhanceClient.holding()) then return false end
  if Config.Access.Interactive then reach=math.min(reach,Config.Access.HoldReach) end
 elseif action=='lower' then if t.brokenAt or not t.accessOpen then return false end
 elseif action=='repair' then
  if not t.brokenAt or t.carry or t.looseRemoved or (TapeEnhanceClient and TapeEnhanceClient.holding()) or not Config.Target.Repair or not Config.Repair.Enabled then return false end
  if Config.RepairInteraction.Enabled then reach=math.min(reach,Config.RepairInteraction.Reach) end
 end
 return distance(id)<=reach
end
function T.select(action,id)
 if TapeEnhanceClient and TapeEnhanceClient.isAction(action) then
  if not T.canInteract(id,action) then return false end
  return TapeEnhanceClient.select(action,id)
 end
 if not ({lift=true,lower=true,remove=true,repair=true})[action] or not T.canInteract(id,action) then return false end
 if action=='lift' and Config.Access.Interactive and TapeAccessClient and not TapeAccessClient.prepare() then TriggerEvent('apex_policetape:notify','Lift animation unavailable.','error');return false end
 local request=({lift='access_open',lower='access_close',remove='target_remove',repair='repair'})[action]
 local result=TapeClient.accessAction(request,{id=id,revision=TapeClient.tapes()[id].revision or 0,viaTarget=action=='repair'})
 if result then TriggerEvent('apex_policetape:notify',action=='repair' and 'Tape repaired.' or action=='remove' and 'Tape removed.' or action=='lift' and 'Lifting tape. Backspace lowers it early.' or 'Lowering tape.','success') end
 return result~=nil
end
local function options(id)
 local result={}
 for _,action in ipairs(actions()) do
  local key=action=='lift' and 'Lift' or action=='lower' and 'Lower' or action=='repair' and 'Repair' or 'Remove'
  result[#result+1]={name='apex_tape:'..action..':'..id,label=TapeLocale.Render(labelFor(action)),icon=action=='repair' and 'fa-solid fa-screwdriver-wrench' or action=='remove' and 'fa-solid fa-scissors' or 'fa-solid fa-hand',distance=Config.Target.Distance,
   canInteract=function()return T.aimed()~=id and T.canInteract(id,action)end,
   onSelect=function()CreateThread(function()T.select(action,id)end)end}
 end
 return result
end
local function points(t,a,b)
 if t.accessHold and TapeAccessClient and not t.brokenAt then
  local grip=TapeAccessClient.grip({id=t.id,posA=a,posB=b,accessHold=t.accessHold,accessReceivedAt=t.accessReceivedAt})
  return {a,grip,b}
 elseif t.accessOpen and not t.brokenAt then local delta=b-a;local lift=vector3(0,0,Config.Access.LiftHeight);return {a,a+delta*.2+lift,b-delta*.2+lift,b} end
 if t.brokenAt then
  if TapeTearClient then
   local paths=TapeTearClient.paths(t,a,b);local list={skipAfter={}}
   for index,path in ipairs(paths)do
    if index>1 then list.skipAfter[#list]=true end
    for _,p in ipairs(path)do list[#list+1]=vector3(p.x,p.y,p.z) end
   end
   return list
  end
  local cut=a+(b-a)*(t.breakFraction or .5)-vector3(0,0,Config.Breakaway.HangingDrop)
  return {a,cut,b}
 end
 local list={};local samples={0,1}
 local contacts=TapeContactClient and TapeContactClient.get(t.id) or {}
 local length=#(b-a)
 local sag=TapeSceneTools.sag(length,t.restLength)
 local divisions=math.max(2,math.ceil(length/Config.Target.SegmentLength))
 for i=1,divisions-1 do samples[#samples+1]=i/divisions end
 for _,contact in ipairs(contacts) do samples[#samples+1]=contact.fraction end
 table.sort(samples)
 for _,f in ipairs(samples) do
  local p=a+(b-a)*f-vector3(0,0,sag*4*f*(1-f))
  local displacement=vector3(0,0,0);local total=0
  for _,contact in ipairs(contacts) do local w=TapeContactMath.weight(f,contact.fraction,contact.width,length);displacement=displacement+vector3(contact.x,contact.y,contact.z)*w;total=total+w end
  list[#list+1]=p+displacement/math.max(1,total)
 end
 return list
end
-- Rendered ribbons have no collision mesh: the normal ox_target ray passes
-- through them. Global options use a bounded camera-ray/ribbon distance test.
local function dot(a,b)return a.x*b.x+a.y*b.y+a.z*b.z end
local function rayDistance(origin,direction,a,b,limit)
 local v,w=b-a,a-origin
 local vv,dv,dw=dot(v,v),dot(direction,v),dot(direction,w)
 local denominator=vv-dv*dv
 local f=denominator>.000001 and (dw*dv-dot(v,w))/denominator or 0
 f=math.max(0,math.min(1,f))
 local along=math.max(0,math.min(limit,dw+f*dv))
 if vv>.000001 then f=math.max(0,math.min(1,(along*dv-dot(v,w))/vv)) end
 return #(origin+direction*along-(a+v*f)),along
end
function T.aimed()
 local now=GetGameTimer()
 if aimAt and now-aimAt<50 then return aimId end
 aimAt,aimId=now,nil
 if type(GetGameplayCamCoord)~='function' or type(GetGameplayCamRot)~='function' then return nil end
 local origin,rot=GetGameplayCamCoord(),GetGameplayCamRot(2)
 local pitch,yaw=math.rad(rot.x),math.rad(rot.z)
 local direction=vector3(-math.sin(yaw)*math.cos(pitch),math.cos(yaw)*math.cos(pitch),math.sin(pitch))
 local best=math.huge
 for id,t in pairs(TapeClient.tapes()) do
  if rules[id] and distance(id)<=math.min(Config.Target.Distance,Config.EditReach) then
   local a,b=TapeClient.liveEnds(t);local path=points(t,a,b)
   for i=1,#path-1 do
    if not (path.skipAfter and path.skipAfter[i]) then
     local miss,along=rayDistance(origin,direction,path[i],path[i+1],Config.Target.AimDistance)
     if miss<=(TapePolishClient and TapePolishClient.aimRadius() or Config.Target.AimRadius) and along<best then best=along;aimId=id end
    end
   end
  end
 end
 return aimId
end
local function registerAimOptions()
 if Config.Target.System~='ox' or aimOptionsRegistered then return end
 local list={}
 aimNames={}
 for index,action in ipairs(actions()) do
  aimNames[index]='apex_tape:aim:'..action
  local key=action=='lift' and 'Lift' or action=='lower' and 'Lower' or action=='repair' and 'Repair' or 'Remove'
  list[#list+1]={name=aimNames[index],label=TapeLocale.Render(labelFor(action)),icon=action=='repair' and 'fa-solid fa-screwdriver-wrench' or action=='remove' and 'fa-solid fa-scissors' or 'fa-solid fa-hand',
   canInteract=function()local id=globalId(action);return id~=nil and T.canInteract(id,action)end,
   onSelect=function()local id=globalId(action);if id then CreateThread(function()T.select(action,id)end)end end}
 end
 local ok=pcall(function()exports[Config.Target.Resource]:addGlobalOption(list)end)
 aimOptionsRegistered=ok
end
function T.refresh()
 if not TapeClient or not ready() then if next(zones) then clear() end;return end
 if registeredActionCount~=#actions() then clear();registeredActionCount=#actions()end
 registerAimOptions()
 aimAt,aimId=nil,nil
 local cfg=Config.Target
 local pos=GetEntityCoords(PlayerPedId())
 local nearby={}
 for id,t in pairs(TapeClient.tapes()) do
  local d=distance(id)
  if d<=cfg.StreamDistance then nearby[#nearby+1]={id=id,t=t,d=d} end
 end
 table.sort(nearby,function(a,b)return a.d<b.d end)
 while #nearby>cfg.MaxTapes do table.remove(nearby) end
 local ids,candidates={},{}
 for _,entry in ipairs(nearby) do
  ids[#ids+1]=entry.id
  local a,b=TapeClient.liveEnds(entry.t)
  local path=points(entry.t,a,b);local segment=0
  for i=1,#path-1 do
   if not (path.skipAfter and path.skipAfter[i]) then
   local delta=path[i+1]-path[i];local count=math.max(1,math.ceil(#delta/(cfg.SegmentLength+.1)))
   for j=1,count do
    segment=segment+1
    local start=path[i]+delta*((j-1)/count);local finish=path[i]+delta*(j/count)
    local center=(start+finish)*.5;local dx,dy=finish.x-start.x,finish.y-start.y
    candidates[#candidates+1]={key=entry.id..':'..segment,id=entry.id,coords=center,size=vector3(math.sqrt(dx*dx+dy*dy)+.15,cfg.Width,cfg.Height+math.abs(finish.z-start.z)),rotation=math.deg(math.atan(dy,dx)),distance=#(pos-center)}
   end
   end
  end
 end
 local signatureIds={} for _,id in ipairs(ids) do signatureIds[#signatureIds+1]=tostring(id) end;table.sort(signatureIds)
 local signature=table.concat(signatureIds,',')
 if #ids>0 and (lastRules==0 or GetGameTimer()-lastRules>=cfg.PermissionRefreshMs or (signature~=ruleSignature and GetGameTimer()-lastRules>=1000)) then
  lastRules=GetGameTimer();ruleSignature=signature
  local result=TapeClient.accessAction('target_rules',{ids=ids})
  rules=result and result.rules or {}
 end
 table.sort(candidates,function(a,b)return a.distance<b.distance end)
 local wanted={}
 for i=1,math.min(#candidates,cfg.MaxZones) do
  local c=candidates[i];wanted[c.key]=true
  local old=zones[c.key]
  if old and (#(old.coords-c.coords)>cfg.MoveThreshold or #(old.size-c.size)>cfg.MoveThreshold or math.abs(old.rotation-c.rotation)>3) then pcall(remove,old.handle);zones[c.key]=nil;old=nil end
  if not old then
   local zone={name='apex_tape:'..c.key,coords=c.coords,size=c.size,rotation=c.rotation,debug=cfg.Debug,drawSprite=cfg.DrawSprite,options=options(c.id)}
   local ok,handle=pcall(function()if cfg.System=='ox' then return exports[cfg.Resource]:addBoxZone(zone) end;return TapeTargetHooks.AddZone(zone)end)
   if ok and handle~=nil and handle~=false then zones[c.key]={handle=handle,coords=c.coords,size=c.size,rotation=c.rotation} end
  end
 end
 for key,zone in pairs(zones) do if not wanted[key] then pcall(remove,zone.handle);zones[key]=nil end end
end
CreateThread(function()while true do Wait(Config.Target.RefreshMs);T.refresh()end end)
local function stopped(name)if name==GetCurrentResourceName() or name==Config.Target.Resource then clear() end end
AddEventHandler('onResourceStop',stopped)
AddEventHandler('onClientResourceStop',stopped)
exports('TargetTape',function(action,id)return T.select(action,tonumber(id))end)
