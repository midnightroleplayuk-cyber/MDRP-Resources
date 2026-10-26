-- Replicated contact bowing, with a damped return when a body leaves the ribbon.
TapeContactClient={}
local C=TapeContactClient
local states={}
local positions,sides,directions,entities={},{},{},{}
local vehicleProfiles={}
function C.update(id,contacts,sequence)
 local state=states[id]
 if state and sequence and state.sequence and sequence<=state.sequence then return end
 state=state or {current={},velocity={},last=GetGameTimer()}
 state.target={}
 for i,c in ipairs(contacts or {}) do state.target[c.key or tostring(i)]=c end
 state.sequence=sequence;states[id]=state
end
-- Predict only this client's body/vehicle. Server contacts remain the source
-- for other players and NPCs; tearing stays entirely server-authoritative.
local function prediction(id)
 if not Config.Contact.Prediction or not TapeClient or type(PlayerPedId)~='function' then return end
 local t=TapeClient.tapes()[id]
 if not t or t.brokenAt or t.accessOpen or TapeEnhanceClient and TapeEnhanceClient.passing(id) or TapeAccessClient and TapeAccessClient.holding() then directions[id]=nil;return end
 local ped=PlayerPedId();local actor=GetPlayerServerId(PlayerId())
 local car=IsPedInAnyVehicle(ped,false) and GetVehiclePedIsIn(ped,false) or 0
 local entity=car~=0 and car or ped
 if entities[id]~=entity then directions[id]=nil;entities[id]=entity end
 local kind=car~=0 and 'Vehicles' or 'Pedestrians';local cfg=Config.Contact[kind]
 if not Config.Contact.Enabled or not cfg.Enabled then return end
 local p=GetEntityCoords(entity);local a,b=TapeClient.liveEnds(t)
 local q,f,d=TapeContactMath.nearest(p,a,b)
 local body=p;local radius=cfg.Radius;local minZ,maxZ=cfg.MinZ,cfg.MaxZ
 if car~=0 then
  local model=type(GetEntityModel)=='function' and GetEntityModel(car) or car
  local profile=vehicleProfiles[model]
  if not profile then
   local name='car'
   if type(GetVehicleClass)=='function' then
    name=({[8]='bike',[13]='bike',[10]='truck',[11]='truck',[20]='truck',[14]='ignore',[15]='ignore',[16]='ignore',[21]='ignore'})[GetVehicleClass(car)] or name
   end
   if type(GetHashKey)=='function' then
    for modelName,rule in pairs(Config.Breakaway.Models) do if model==GetHashKey(modelName) then name=rule;break end end
   end
   profile=Config.Breakaway.Profiles[name] or Config.Breakaway.Profiles.car
   vehicleProfiles[model]=profile
  end
  if profile.Enabled==false then directions[id]=nil;return end
  radius=math.max(radius,profile.Radius or radius);minZ,maxZ=profile.MinZ,profile.MaxZ
 end
 if car~=0 then
  local angle=math.rad(GetEntityHeading(car));local x,y=-math.sin(angle)*cfg.HalfLength,math.cos(angle)*cfg.HalfLength
  local front={x=p.x+x,y=p.y+y,z=p.z};local rear={x=p.x-x,y=p.y-y,z=p.z}
  local u;d,u,f=TapeGeometry.closest2d(rear,front,a,b)
  body=TapeAccessMath.lerp(rear,front,u);q=TapeAccessMath.lerp(a,b,f)
  local dir=directions[id] or TapeContactMath.direction(positions[entity] or p,p,a,b)
  body=(front.x*dir.x+front.y*dir.y>=rear.x*dir.x+rear.y*dir.y) and front or rear
 end
 if d>radius or q.z<p.z+minZ or q.z>p.z+maxZ then directions[id]=nil;return end
 local dir=directions[id] or TapeContactMath.direction(positions[entity] or p,p,a,b);directions[id]=dir
 local toward=(body.x-q.x)*dir.x+(body.y-q.y)*dir.y
 local amount=math.max(0,math.min(cfg.MaxDeflection,radius+toward))
 return {key='local',actor=actor,kind=kind,fraction=f,width=cfg.Width,x=dir.x*amount,y=dir.y*amount,z=0},actor,car~=0
end
function C.get(id)
 local predicted,actor,inCar=prediction(id)
 local state=states[id]
 if not state and not predicted then return {} end
 state=state or {current={},velocity={},target={},last=GetGameTimer()};states[id]=state
 local targets={}
 for key,t in pairs(state.target or {}) do
  if not predicted or (key~='p'..actor and not (inCar and t.actor==actor)) then targets[key]=t
  elseif state.current[key] then
   if not state.current['local'] then state.current['local']=state.current[key];state.velocity['local']=state.velocity[key] end
   state.current[key]=nil;state.velocity[key]=nil
  end
 end
 if predicted then targets['local']=predicted end
 local now=GetGameTimer();local dt=math.min(.05,math.max(0,(now-state.last)/1000));state.last=now
 for key,target in pairs(targets) do
  if not state.current[key] then state.current[key]={x=0,y=0,z=0,fraction=target.fraction,width=target.width} end
 end
 local result={}
 for key,value in pairs(state.current) do
  local target=targets[key]
  local velocity=state.velocity[key] or {x=0,y=0,z=0}
  for _,axis in ipairs({'x','y','z'}) do
   local goal=target and target[axis] or 0
   velocity[axis]=velocity[axis]+((goal-value[axis])*Config.Contact.Spring-velocity[axis]*Config.Contact.Damping)*dt
   value[axis]=value[axis]+velocity[axis]*dt
  end
  if target then value.fraction=target.fraction;value.width=target.width end
  state.velocity[key]=velocity
  if target or math.abs(value.x)+math.abs(value.y)+math.abs(velocity.x)+math.abs(velocity.y)>.002 then result[#result+1]=value
  else state.current[key]=nil;state.velocity[key]=nil end
 end
 return result
end
RegisterNetEvent('apex_policetape:contact',function(data)
 if type(data)=='table' and type(data.id)=='number' and type(data.contacts)=='table' then C.update(data.id,data.contacts,data.sequence) end
end)
-- Walking stops at intact tape; sprinting can commit a real crossing so that
-- the server can observe and tear it. There is no solid barrier prop for cars.
function C.step()
 if not TapeClient then return false end
 local cfg=Config.Contact.Pedestrians;local ped=PlayerPedId()
 if not Config.Contact.Enabled or not cfg.Enabled or IsPedInAnyVehicle(ped,false) or (type(IsEntityDead)=='function' and IsEntityDead(ped))
  or TapeAccessClient and TapeAccessClient.holding() then sides={};positions[ped]=nil;return false end
 local raw=GetEntityCoords(ped);local p={x=raw.x,y=raw.y,z=raw.z}
 local previous=positions[ped] or p
 if TapeGeometry.distance(previous,p)>2 then sides={};previous=p;positions[ped]=p;return false end
 local v=GetEntityVelocity(ped);local velocity={x=v.x,y=v.y,z=v.z}
 local speed=math.sqrt(v.x*v.x+v.y*v.y)
 local sprint=(type(IsPedSprinting)=='function' and IsPedSprinting(ped)) or (type(IsControlPressed)=='function' and IsControlPressed(0,21))
 local fast=Config.Breakaway.Enabled and cfg.TearEnabled and (sprint or speed>=cfg.TearSpeed)
 local touching=false;local remaining=cfg.MaxCorrection;local corrected=false
 for id,t in pairs(TapeClient.tapes()) do
  if not t.brokenAt and not t.accessOpen and not (TapeEnhanceClient and TapeEnhanceClient.passing(id)) then
   local a,b=TapeClient.liveEnds(t);local q,_,d=TapeContactMath.nearest(p,a,b)
   if d<=cfg.Radius+.35 and q.z>=p.z+cfg.MinZ and q.z<=p.z+cfg.MaxZ then
    touching=true
    if cfg.BlockWalking and not fast and remaining>0 then
     local nextPos,nextVelocity,side,amount=TapeContactMath.walkConstraint(previous,p,a,b,velocity,cfg,sides[id],remaining)
     sides[id]=side
     if nextPos then p=nextPos;velocity=nextVelocity;remaining=remaining-amount;corrected=true end
    else sides[id]=nil end
   else sides[id]=nil end
  else sides[id]=nil end
 end
 if corrected then
  SetEntityCoordsNoOffset(ped,p.x+0.0,p.y+0.0,p.z+0.0,true,true,false)
  SetEntityVelocity(ped,velocity.x,velocity.y,velocity.z)
 end
 if corrected and not fast and cfg.Resistance<1 then SetPedMoveRateOverride(ped,cfg.Resistance) end
 positions[ped]=p
 for id in pairs(states) do if not TapeClient.tapes()[id] then states[id]=nil;directions[id]=nil;entities[id]=nil;sides[id]=nil end end
 return touching
end
CreateThread(function()
 while true do local touching=C.step();Wait(touching and 0 or 75) end
end)
