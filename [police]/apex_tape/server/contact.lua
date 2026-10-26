-- Server-observed contacts. No client network event can request a tear.
TapeContactServer={}
local C,M,R=TapeContactServer,TapeContactMath,nil
local samples,records,lastSent,sequences={},{},{},{}
local cursor=1
local ticks,lastTick,tears,lastTear=0,0,0,nil
function C.diagnostics()return {ticks=ticks,lastTick=lastTick,tears=tears,lastTear=lastTear,enabled=Config.Contact.Enabled,blockWalking=Config.Contact.Pedestrians.BlockWalking}end
function C.public(id)return lastSent[id] or {}end
local function tear(t,actor,speed,reason,fraction)
 if t.brokenAt or t.openUntil then return end
 local released=TapeEnhanceServer and TapeEnhanceServer.anchorImpact(t,speed,reason)
 if released then fraction=released.fraction end
 tears=tears+1;lastTear={id=t.id,actor=actor,speed=speed,reason=reason}
 if Config.Breakaway.RemoveImmediately then R.remove(t.id,nil,reason)
 else
  t.tearFloorA=nil;t.tearFloorB=nil;t.tearFloorStamp=nil;t.brokenAt=os.time();t.breakFraction=math.max(.1,math.min(.9,fraction));t.revision=(t.revision or 0)+1
  R.dirty();R.emit(t.bucket,'apex_policetape:add',R.public(t))
 end
 TapeServices.audit(reason,actor,{id=t.id,speed=speed})
 TriggerEvent('apex_policetape:torn',t.id,actor,speed*3.6)
end
local function sample(key,entity,actor,kind,now,bucket,seen)
 seen[key]=true
 local cfg=Config.Contact[kind]
 local raw=GetEntityCoords(entity);local p={x=raw.x,y=raw.y,z=raw.z}
 local v=GetEntityVelocity(entity);local speed=math.sqrt(v.x*v.x+v.y*v.y+v.z*v.z)
 local old=samples[key]
 local moved=not old or TapeGeometry.distance(old.p,p)>.005
 samples[key]={p=p,at=now,motionAt=moved and now or old.motionAt,bucket=bucket,speed=speed,v={x=v.x,y=v.y},heading=kind=='Vehicles' and GetEntityHeading(entity) or 0}
 if not old or old.bucket~=bucket or now<=old.at or now-old.at>(kind=='Vehicles' and Config.Contact.MaxVehicleSampleGapMs or Config.Breakaway.MaxSampleGapMs)
  or TapeGeometry.distance(old.p,p)>Config.Breakaway.MaxSweepDistance then return end
 local elapsed=(now-old.at)/1000
 local dx,dy,dz=p.x-old.p.x,p.y-old.p.y,p.z-old.p.z
 local motionElapsed=math.max(elapsed,math.min((cfg.MotionWindowMs or 250)/1000,(now-(old.motionAt or old.at))/1000))
 local observed=math.sqrt(dx*dx+dy*dy)/motionElapsed
 -- Position replication can arrive before velocity. Only accept bounded on-foot
 -- displacement for each body type; teleports, stale samples and bucket changes
 -- still fail closed.
 local observedValid=observed<=(cfg.MaxObservedSpeed or (kind=='Vehicles' and 100 or 16)) and math.abs(dz)/motionElapsed<=(kind=='Vehicles' and 20 or 8)
 if TapeGeometry.distance(old.p,p)>math.max(speed,old.speed)*elapsed+cfg.Radius*2 and not observedValid then return end
 local profile=kind=='Vehicles' and TapeServices.vehicleProfile(entity) or nil
 if kind=='Vehicles' and not profile then return end
 local radius=profile and math.max(cfg.Radius,profile.Radius) or cfg.Radius
 local heading=samples[key].heading
 local minZ,maxZ=profile and profile.MinZ or cfg.MinZ,profile and profile.MaxZ or cfg.MaxZ
 for id,t in pairs(R.tapes) do
  if t.bucket==bucket and not t.brokenAt and not t.openUntil and not (kind=='Pedestrians' and TapeEnhanceServer and TapeEnhanceServer.passing(actor,id)) then
   local a,b=R.liveEnd(t,'a'),R.liveEnd(t,'b')
   local body=p
   local q,f,d=M.nearest(p,a,b)
   local front,rear,oldFront,oldRear
   if kind=='Vehicles' then
    local function ends(pos,angle)
     local radians=math.rad(angle)
     local x,y=-math.sin(radians)*cfg.HalfLength,math.cos(radians)*cfg.HalfLength
     return {x=pos.x+x,y=pos.y+y,z=pos.z},{x=pos.x-x,y=pos.y-y,z=pos.z}
    end
    front,rear=ends(p,heading);oldFront,oldRear=ends(old.p,old.heading or heading)
    local u;d,u,f=TapeGeometry.closest2d(rear,front,a,b)
    body=TapeAccessMath.lerp(rear,front,u);q=TapeAccessMath.lerp(a,b,f)
   end
   if d<=Config.Contact.ScanDistance then
    local hit,cross=TapeGeometry.sweepHit(old.p,p,a,b,radius,minZ,maxZ)
    if front and not hit then
     hit,cross=TapeGeometry.sweepHit(oldFront,front,a,b,radius,minZ,maxZ)
     if not hit then hit,cross=TapeGeometry.sweepHit(oldRear,rear,a,b,radius,minZ,maxZ) end
    end
    if not hit and d<=radius and q.z>=p.z+minZ and q.z<=p.z+maxZ then hit=true;cross=f end
    if hit then
     local record=records[id] or {};records[id]=record
     local contact=record[key]
     if not contact then contact={direction=M.direction(old.p,p,a,b),began=now};record[key]=contact end
     contact.seen=now
     if front then
      local frontDot=front.x*contact.direction.x+front.y*contact.direction.y
      local rearDot=rear.x*contact.direction.x+rear.y*contact.direction.y
      body=frontDot>=rearDot and front or rear
     end
     local toward=(body.x-q.x)*contact.direction.x+(body.y-q.y)*contact.direction.y
     local amount=math.max(0,math.min(cfg.MaxDeflection,radius+toward))
     local previousVelocity=old.v or {x=0,y=0}
     local normalSpeed=math.max(math.abs(v.x*contact.direction.x+v.y*contact.direction.y),math.abs(previousVelocity.x*contact.direction.x+previousVelocity.y*contact.direction.y))
     if observedValid then normalSpeed=math.max(normalSpeed,math.abs((dx*contact.direction.x+dy*contact.direction.y)/motionElapsed)) end
     local previousSide=(old.p.x-q.x)*contact.direction.x+(old.p.y-q.y)*contact.direction.y
     local currentSide=(p.x-q.x)*contact.direction.x+(p.y-q.y)*contact.direction.y
     local movingAcross=math.abs(dx*contact.direction.x+dy*contact.direction.y)>.005
     local approaching=movingAcross and (previousSide*currentSide<=0 or math.abs(currentSide)<math.abs(previousSide))
     local fast=normalSpeed>=cfg.TearSpeed and approaching
     local inGrace=os.time()-(t.editedAt or t.createdAt)<Config.Breakaway.SpawnGraceSeconds
     local stretched=not inGrace and kind=='Vehicles' and speed>.15 and amount>=cfg.MaxDeflection*.95 and now-contact.began>=cfg.StretchTearMs
     if Config.Breakaway.Enabled and cfg.TearEnabled and (fast or stretched) then tear(t,actor,math.max(speed,normalSpeed),kind=='Vehicles' and 'vehicle_contact_tear' or 'foot_contact_tear',cross)
     elseif d<=radius and q.z>=p.z+minZ and q.z<=p.z+maxZ then
      contact.value={fraction=f,x=contact.direction.x*amount,y=contact.direction.y*amount,z=0,width=cfg.Width,kind=kind,key=key,actor=actor}
     else record[key]=nil end
    end
   end
  end
 end
end
function C.tick()
 R=TapeRuntime
 if not R or not R.ready() then return end
 local now=GetGameTimer();local seen={};ticks=ticks+1;lastTick=now
 if Config.Contact.Enabled then
  for _,value in ipairs(GetPlayers()) do
   local src=tonumber(value);local ped=GetPlayerPed(src)
   if Config.Contact.Pedestrians.Enabled and ped~=0 and GetEntityHealth(ped)>0 and GetVehiclePedIsIn(ped,false)==0
    and not (TapeAccessServer and TapeAccessServer.holding(src)) then sample('p'..src,ped,src,'Pedestrians',now,GetPlayerRoutingBucket(src),seen) end
  end
  if Config.Contact.Vehicles.Enabled then
   local vehicles={};local unique={}
   for _,value in ipairs(GetPlayers()) do
    local src=tonumber(value);local ped=GetPlayerPed(src);local car=ped~=0 and GetVehiclePedIsIn(ped,false) or 0
    if car~=0 and not unique[car] then unique[car]=true;vehicles[#vehicles+1]={id=car,actor=src} end
   end
   if Config.Contact.Vehicles.IncludeNPC and type(GetAllVehicles)=='function' then
    local npc=0
    -- Keep touching NPC vehicles hot while rotating the ambient pool under a budget.
    for _,record in pairs(records) do
     for key in pairs(record) do
      local car=tonumber(key:match('^v(%d+)$'))
      if car and not unique[car] and DoesEntityExist(car) and npc<Config.Contact.MaxVehiclesPerTick then
       unique[car]=true;vehicles[#vehicles+1]={id=car,actor=0};npc=npc+1
      end
     end
    end
    local pool=GetAllVehicles();local count=math.min(#pool,Config.Contact.MaxVehiclesPerTick)
    for i=1,count do
     if cursor>#pool then cursor=1 end
     local car=pool[cursor];cursor=cursor+1
     if car and not unique[car] and npc<Config.Contact.MaxVehiclesPerTick then unique[car]=true;vehicles[#vehicles+1]={id=car,actor=0};npc=npc+1 end
    end
   end
   for _,car in ipairs(vehicles) do
    if DoesEntityExist(car.id) then sample('v'..car.id,car.id,car.actor,'Vehicles',now,GetEntityRoutingBucket(car.id),seen) end
   end
  end
 end
 for key,old in pairs(samples) do if not seen[key] and now-old.at>Config.Contact.MaxVehicleSampleGapMs then samples[key]=nil end end
 for id,t in pairs(R.tapes) do
  local list={};local record=records[id]
  if record and Config.Contact.Enabled and not t.brokenAt and not t.openUntil then
   local keys={};for key in pairs(record) do keys[#keys+1]=key end;table.sort(keys)
   for _,key in ipairs(keys) do
    local c=record[key]
    if c.seen~=now or not c.value then record[key]=nil
    elseif #list<Config.Contact.MaxContactsPerTape then list[#list+1]=c.value end
   end
  else records[id]=nil end
  local previous=lastSent[id] or {}
  local changed=#list~=#previous
  if not changed then for i,c in ipairs(list) do local old=previous[i];if math.abs(c.x-old.x)+math.abs(c.y-old.y)+math.abs(c.fraction-old.fraction)>.015 then changed=true;break end end end
  if changed then
   lastSent[id]=list;sequences[id]=(sequences[id] or 0)+1
   R.emit(t.bucket,'apex_policetape:contact',{id=id,contacts=list,sequence=sequences[id]})
  end
 end
 for id in pairs(records) do if not R.tapes[id] then records[id]=nil end end
 for id in pairs(lastSent) do if not R.tapes[id] then lastSent[id]=nil;sequences[id]=nil end end
end
CreateThread(function()while true do Wait(Config.Contact.SampleMs);C.tick() end end)
