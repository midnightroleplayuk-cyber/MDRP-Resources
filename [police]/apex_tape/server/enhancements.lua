TapeEnhanceServer={actions={enh_adjust=true,enh_pickup=true,enh_drop=true,enh_reconnect=true,enh_pass=true,enh_endpass=true,enh_inspect=true}}
local E,M=TapeEnhanceServer,TapeEnhanceMath
TapeEnhanceHooks=TapeEnhanceHooks or {}
local carriers,passages,cooldowns,wearTimes,drops={},{},{},{},{}
local weatherAt,weatherCursor=0,1
local function point(p)return {x=p.x,y=p.y,z=p.z}end
local function publish(t,edit)
 if edit then t.revision=(t.revision or 0)+1;t.editedAt=os.time();TapeRuntime.dirty() end
 TapeRuntime.emit(t.bucket,'apex_policetape:add',TapeRuntime.public(t))
end
local function onFoot(src)
 local ped=GetPlayerPed(src)
 return ped~=0 and GetEntityHealth(ped)>0 and GetVehiclePedIsIn(ped,false)==0 and ped or nil
end
function E.holding(src)
 local t=TapeRuntime and TapeRuntime.tapes[carriers[src]]
 return t and t.carry and t.carry.holder==src and t or nil
end
function E.passing(src,id)
 local p=passages[src]
 return p and p.id==id and GetGameTimer()<p.untilAt
end
local function drop(src)
 local t=E.holding(src);carriers[src]=nil
 if t then
  t.tailDrop={side=t.carry.side,point=t.carry.point,started=GetGameTimer(),duration=Config.LooseEnds.DropMs};drops[t.id]=true
  t.carry=nil;publish(t,true)
 end
end
local function heldPoint(ped)
 local p=GetEntityCoords(ped);local heading=math.rad(GetEntityHeading(ped))
 return {x=p.x-math.sin(heading)*Config.LooseEnds.Forward,y=p.y+math.cos(heading)*Config.LooseEnds.Forward,z=p.z+Config.LooseEnds.HandHeight}
end
function E.rules(src,t)
 local R=TapeRuntime;local own=R.editable(src,t,true)
 return {inspect=Config.Inspection.Enabled and (Config.Inspection.Public or R.canUse(src)),
  pickup=Config.LooseEnds.Enabled and own and t.brokenAt~=nil and not t.carry and not E.holding(src),
  reconnect=Config.LooseEnds.Enabled and t.carry and t.carry.holder==src or false,
  drop=Config.LooseEnds.Enabled and t.carry and t.carry.holder==src or false,
  pass=Config.Passage.Enabled and R.canUse(src) and not t.brokenAt and not t.openUntil and not E.holding(src) and not (TapeAccessServer and TapeAccessServer.holding(src))
   and (Config.Passage.AllowAllAuthorized or own)}
end
function E.handle(src,action,p)
 if action=='enh_endpass' then passages[src]=nil;return {success=true} end
 local R=TapeRuntime;local t=R.tapes[tonumber(p.id)]
 local function fail(message)return {success=false,error=message}end
 local ped=onFoot(src)
 if not ped or not t or t.bucket~=GetPlayerRoutingBucket(src) then return fail('Stand beside tape in your scene.') end
 local pos=point(GetEntityCoords(ped));local a,b=R.liveEnd(t,'a'),R.liveEnd(t,'b')
 if action=='enh_inspect' then
  local distance=R.segmentDistance(pos,a,b)
  if t.brokenAt then _,distance=TapeTearMath.nearest(M.paths(t,a,b,Config.TornEnds.SettleMs),pos) end
  if not E.rules(src,t).inspect or distance>Config.Inspection.Reach then return fail('Move closer to inspect tape.') end
  local s=t.sceneId and R.scenes[t.sceneId]
  return {success=true,inspection={placedBy=t.placedBy or 'Unknown / saved scene',scene=s and s.name or 'Ungrouped',
   style=(Config.TapeStyles[t.style] or {}).label or t.style,expires=t.expiresAt and math.max(0,t.expiresAt-os.time()) or false,
   wear=math.floor((t.wear or 0)*100),length=TapeGeometry.distance(a,b),broken=t.brokenAt~=nil}}
 end
 if not R.canUse(src) then return fail('Tape permission required.') end
 if action=='enh_drop' then
  if not E.holding(src) or E.holding(src).id~=t.id then return fail('You are not carrying this tape.') end
  drop(src);return {success=true}
 end
 if action=='enh_pass' then
  if not E.rules(src,t).pass then return fail('Controlled passage is unavailable.') end
  local now=GetGameTimer();local c=Config.Passage
  if passages[src] or cooldowns[src] and now-cooldowns[src]<c.CooldownMs then return fail('Wait before crossing again.') end
  if R.segmentDistance(pos,a,b)>c.Reach then return fail('Move beside the tape.') end
  local dest,q=M.crossing(pos,a,b);if not dest then return fail(q) end
  local height=q.z-pos.z
  if height<c.MinRelativeHeight or height>c.MaxRelativeHeight then return fail('This tape is outside safe passage height.') end
  for id,other in pairs(R.tapes)do
   if id~=t.id and other.bucket==t.bucket and not other.brokenAt and not other.openUntil then
    local x,y=R.liveEnd(other,'a'),R.liveEnd(other,'b')
    if TapeGeometry.closest2d(pos,dest,x,y)<.35 and math.abs((x.z+y.z)*.5-q.z)<1.5 then return fail('Another cordon blocks this route.') end
   end
  end
  passages[src]={id=t.id,untilAt=now+c.DurationMs,start=pos};cooldowns[src]=now
  return {success=true,destination=dest,mode=height>c.DuckAbove and 'duck' or 'step',duration=c.DurationMs}
 end
 if not R.editable(src,t,true) then return fail('Move close to tape you may edit.') end
 if p.revision~=(t.revision or 0) then return fail('Tape changed. Select it again.') end
 if action=='enh_adjust' then
  if not Config.Adjustment.Enabled or t.brokenAt or t.accessHold then return fail('Adjust intact, unheld tape.') end
  local c=Config.Adjustment
  if p.direction=='tight' or p.direction=='loose' then
   t.restLength=TapeGeometry.distance(a,b)*(p.direction=='tight' and c.Tight or c.Loose)
   t.weatherRestBase=t.restLength/(1+(t.wear or 0)*Config.WeatherWear.MaxStretch)
   publish(t,true);return {success=true}
  end
  local side=p.side=='a' and 'a' or p.side=='b' and 'b' or (TapeGeometry.distance(pos,a)<TapeGeometry.distance(pos,b) and 'a' or 'b')
  local offset=({up={0,0,1},down={0,0,-1},left={-1,0,0},right={1,0,0},forward={0,1,0},back={0,-1,0}})[p.direction]
  local steps=tonumber(p.steps) or 1
  if not offset or not TapeGeometry.finite(steps) or steps%1~=0 or steps<1 or steps>c.MaxSteps then return fail('Use up/down/left/right/forward/back or tight/loose.') end
  local old=side=='a' and a or b
  local goal={x=old.x+offset[1]*c.Step*steps,y=old.y+offset[2]*c.Step*steps,z=old.z+offset[3]*c.Step*steps}
  local ok,err=R.moveEndpoint(src,{id=t.id,side=side,position=goal,post=t[side=='a' and 'postA' or 'postB'],revision=p.revision,ticket=p.ticket})
  return {success=ok,error=err}
 end
 if not Config.LooseEnds.Enabled or not t.brokenAt then return fail('Choose torn tape first.') end
 if action=='enh_pickup' then
  if t.carry or E.holding(src) or TapeAccessServer and TapeAccessServer.holding(src) then return fail('Finish the current tape interaction first.') end
  local count=0;for _ in pairs(carriers)do count=count+1 end
  if count>=Config.LooseEnds.MaxCarriers then return fail('Loose-end interaction limit reached.') end
  local paths=TapeTearMath.paths(a,b,t.breakFraction,Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB)
  local best,side=Config.LooseEnds.Reach,nil
  for i,key in ipairs({'a','b'})do
   if not (t.looseRemoved and t.looseRemoved[key]) then
    local d=TapeGeometry.distance(pos,paths[i][#paths[i]])
    if d<=best then best=d;side=key end
   end
  end
  if not side then return fail('Move beside a loose tip to pick it up.') end
  t.tailDrop=nil;drops[t.id]=nil
  t.carry={holder=src,side=side,origin=pos,point=heldPoint(ped),started=GetGameTimer()};carriers[src]=t.id
  publish(t,true);return {success=true}
 end
 if action=='enh_reconnect' then
  local carry=t.carry
  if not carry or carry.holder~=src then return fail('Pick up a loose end first.') end
  local goal=p.position
  if not TapeGeometry.point(goal) or TapeGeometry.distance(pos,goal)>Config.EditReach then return fail('Aim at an attachment within reach.') end
  local side=carry.side;local anchor=side=='a' and a or b
  if TapeGeometry.distance(anchor,goal)>M.tailLength(t,a,b,side)+Config.LooseEnds.StretchAllowance then return fail('There is not enough loose tape to reach that anchor.') end
  if not TapeFeaturesServer.checkDeployment(src,'repair',p.ticket) then return fail('Finish reconnecting before attaching tape.') end
  local checkpoint=R.checkpoint()
  local result=R.create(src,{a=anchor,b=goal,coneAId=t[side=='a' and 'coneAId' or 'coneBId'],
   coneBId=('world:%.2f:%.2f:%.2f'):format(goal.x,goal.y,goal.z),style=t.style,sceneId=t.sceneId,
   postA=t[side=='a' and 'postA' or 'postB'],aWrap=t[side=='a' and 'aWrap' or 'bWrap'],aSurface=t[side=='a' and 'aSurface' or 'bSurface'],
   postB=p.post==true,bSurface=p.surface,bWrap=p.wrap},false,true,t)
  if not result.success then return result end
  if not TapeServices.take(src,Config.Inventory.RepairItem,1,Config.Inventory.ConsumeRepairItem) then
   R.rollback(checkpoint,{result.id});return fail('Repair item missing or inventory transaction failed.')
  end
  local fresh=R.tapes[result.id];fresh.owner=t.owner;fresh.license=t.license;fresh.customText=t.customText;fresh.placedBy=t.placedBy
  fresh.paidSpool=t.paidSpool;fresh.paidItem=t.paidItem;t.paidSpool=false
  t.looseRemoved=t.looseRemoved or {};t.looseRemoved[side]=true;t.carry=nil;carriers[src]=nil
  t[side]=point(anchor);t[side..'Local']=nil;t[side=='a' and 'coneAId' or 'coneBId']='spent:'..t.id..':'..side
  t[side=='a' and 'postA' or 'postB']=false
  TapeFeaturesServer.completeDeployment(src)
  if t.looseRemoved.a and t.looseRemoved.b then R.remove(t.id,nil,'tails_reconnected') else publish(t,true) end
  R.emit(fresh.bucket,'apex_policetape:add',R.public(fresh));R.dirty()
  return {success=true,id=fresh.id}
 end
 return fail('Unknown scene tool.')
end
function E.anchorImpact(t,speed,reason)
 local c=Config.AnchorFailure;if not c.Enabled then return end
 local R=TapeRuntime;local a,b=R.liveEnd(t,'a'),R.liveEnd(t,'b')
 local pulling=TapeGeometry.distance(a,b)/math.max(.1,t.restLength or TapeGeometry.distance(a,b))>=c.PullRatio
 local threshold=reason=='foot_contact_tear' and c.FootSpeed or c.VehicleSpeed
 if (speed or 0)<threshold and not pulling then return end
 for _,side in ipairs({'a','b'})do
  local id=t[side=='a' and 'coneAId' or 'coneBId'];local entity=R.anchorEntity(id)
  local model=entity~=0 and GetEntityModel(entity) or tonumber(type(id)=='string' and id:match('^local:(%-?%d+):'))
  local loose=false;for _,name in ipairs(c.Models)do if model==GetHashKey(name) then loose=true;break end end
  if loose then
   local old=point(R.liveEnd(t,side));local other=side=='a' and b or a;local length=math.max(.1,TapeGeometry.distance(old,other))
   t[side]={x=old.x+(other.x-old.x)/length*c.PullDistance,y=old.y+(other.y-old.y)/length*c.PullDistance,z=old.z-c.Drop}
   t[side..'Local']=nil;t[side=='a' and 'coneAId' or 'coneBId']='released:'..t.id..':'..side
   t[side=='a' and 'aWrap' or 'bWrap']=nil;t[side=='a' and 'aSurface' or 'bSurface']=nil;t.looseRemoved=t.looseRemoved or {};t.looseRemoved[side]=true
   R.emit(t.bucket,'apex_policetape:anchorRelease',{id=t.id,side=side,model=model,position=old})
   return {fraction=side=='a' and .01 or .99}
  end
 end
end
function E.weather()
 local c=Config.WeatherWear
 if type(TapeEnhanceHooks.Weather)=='function' then
  local ok,w,wind=pcall(TapeEnhanceHooks.Weather)
  if ok and type(w)=='string' and c.Rates[w:upper()] then return w:upper(),TapeGeometry.finite(tonumber(wind)) and tonumber(wind) or 0 end
 end
 local weather=c.Weather
 if weather=='auto' then weather=type(GlobalState)=='table' and (GlobalState.weather or GlobalState.Weather) or nil end
 if type(weather)~='string' or not c.Rates[weather:upper()] then weather=c.DefaultWeather end
 return weather:upper(),c.DefaultWind
end
function E.tick()
 local R=TapeRuntime;if not R or not R.ready() then return end
 local now=GetGameTimer()
 for id in pairs(drops)do
  local t=R.tapes[id]
  if not t or not t.tailDrop then drops[id]=nil
  else
   if now-t.tailDrop.started>=t.tailDrop.duration then t.tailDrop=nil;drops[id]=nil end
   publish(t,false)
  end
 end
 for src in pairs(carriers)do
  local t=E.holding(src);local ped=onFoot(src)
  if not t then carriers[src]=nil
  elseif not ped or not Config.LooseEnds.Enabled or not R.canUse(src) or t.bucket~=GetPlayerRoutingBucket(src) or now-t.carry.started>Config.LooseEnds.MaxHoldSeconds*1000
   or TapeGeometry.distance(GetEntityCoords(ped),t.carry.origin)>Config.LooseEnds.MaxWalk then drop(src)
  else
   local a,b=R.liveEnd(t,'a'),R.liveEnd(t,'b');local hand=heldPoint(ped);local anchor=t.carry.side=='a' and a or b
   if TapeGeometry.distance(anchor,hand)>M.tailLength(t,a,b,t.carry.side)+Config.LooseEnds.StretchAllowance then drop(src)
   else t.carry.point=hand;publish(t,false) end
  end
 end
 for src,p in pairs(passages)do
  local ped=onFoot(src);local t=R.tapes[p.id]
  if now>=p.untilAt or not ped or not t or t.bucket~=GetPlayerRoutingBucket(src) or not R.canUse(src)
   or TapeGeometry.distance(GetEntityCoords(ped),p.start)>Config.Passage.Distance*3 then passages[src]=nil end
 end
 if not Config.WeatherWear.Enabled or now-weatherAt<Config.WeatherWear.TickMs then return end
 weatherAt=now
 local ids={};for id in pairs(R.tapes)do ids[#ids+1]=id end;table.sort(ids)
 local weather,wind=E.weather();local c=Config.WeatherWear
 for _=1,math.min(#ids,c.MaxPerTick)do
  if weatherCursor>#ids then weatherCursor=1 end
  local id=ids[weatherCursor];weatherCursor=weatherCursor+1;local t=R.tapes[id]
  local last=wearTimes[id] or {at=now,printed=t.wear or 0};wearTimes[id]=last
  local dt=math.max(0,(now-last.at)/1000);last.at=now
  if not t.brokenAt and not t.accessHold then
   t.wear=M.wear(t.wear,dt,weather,wind)
   t.weatherRestBase=t.weatherRestBase or t.restLength or TapeGeometry.distance(R.liveEnd(t,'a'),R.liveEnd(t,'b'))
   t.restLength=t.weatherRestBase*(1+t.wear*c.MaxStretch)
   if c.TearEnabled and t.wear>=c.TearAt then
    t.brokenAt=os.time();t.breakFraction=.5;t.openUntil=nil;t.accessHold=nil;t.tearFloorA=nil;t.tearFloorB=nil;t.tearFloorStamp=nil
    publish(t,true)
   elseif t.wear-last.printed>=c.PublishStep then last.printed=t.wear;R.dirty();publish(t,false) end
  end
 end
 for id in pairs(wearTimes)do if not R.tapes[id] then wearTimes[id]=nil end end
end
AddEventHandler('playerDropped',function()local src=source;drop(src);passages[src]=nil;cooldowns[src]=nil end)
CreateThread(function()while true do Wait(Config.LooseEnds.UpdateMs);E.tick()end end)
