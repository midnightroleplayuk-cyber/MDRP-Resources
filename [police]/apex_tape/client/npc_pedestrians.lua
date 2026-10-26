-- Existing ambient peds only. The network owner manages tasks; nobody steals
-- entity control, freezes peds, creates crowds or changes their combat flags.
TapeNpcPedestrians={}
local P,M=TapeNpcPedestrians,TapeNpcMath
local records,cooldowns,bubbles={},{},{}
local cursor,lastQuestion=1,-100000
local wasEnabled=true
local key='apexTapePed'
local function point(p)return {x=p.x,y=p.y,z=p.z}end
local function flatDistance(a,b)return math.sqrt((a.x-b.x)^2+(a.y-b.y)^2)end
local function controls(ped)return not NetworkGetEntityIsNetworked(ped) or NetworkHasControlOfEntity(ped) end
local function networkTime()return type(GetNetworkTimeAccurate)=='function' and GetNetworkTimeAccurate() or GetGameTimer() end
local function elapsed(at)return type(GetTimeDifference)=='function' and GetTimeDifference(networkTime(),at) or networkTime()-at end
local function tag(ped,value)
 if NetworkGetEntityIsNetworked(ped) and controls(ped) then Entity(ped).state:set(key,value,true) end
end
local function readTag(ped)return NetworkGetEntityIsNetworked(ped) and Entity(ped).state[key] or nil end
local function safePed(ped,managed)
 local cfg=Config.NpcPedestrians
 if not DoesEntityExist(ped) or IsPedAPlayer(ped) or not IsPedHuman(ped) or IsEntityDead(ped) or IsPedInAnyVehicle(ped,false) or not controls(ped) then return false end
 if cfg.SkipMissionEntities and IsEntityAMissionEntity(ped) then return false end
 if IsPedInCombat(ped,0) or IsPedFleeing(ped) or IsPedRagdoll(ped) then return false end
 if managed then return true end
 if IsPedUsingAnyScenario(ped) then return false end
 local any=GetScriptTaskStatus(ped,GetHashKey('SCRIPT_TASK_ANY'))
 if any==0 or any==1 or any==2 then
  local wander=GetScriptTaskStatus(ped,GetHashKey('SCRIPT_TASK_WANDER_STANDARD'))
  return wander==0 or wander==1 or wander==2
 end
 return true
end
local function ownTask(ped,r)
 if r.scenario and IsPedUsingScenario(ped,r.scenario) then return true end
 if IsPedUsingAnyScenario(ped) then return false end
 local status=r.task and GetScriptTaskStatus(ped,GetHashKey(r.task)) or 7
 if status==0 or status==1 or status==2 then return true end
 local any=GetScriptTaskStatus(ped,GetHashKey('SCRIPT_TASK_ANY'))
 return any==3 or any==7
end
local function publish(ped,r)
 tag(ped,{version=1,model=r.model,spanId=r.spanId,task=r.task,scenario=r.scenario})
end
local function finish(ped,restore)
 local r=records[ped];records[ped]=nil
 if r and DoesEntityExist(ped) and GetEntityModel(ped)==r.model and controls(ped) then
  if restore and safePed(ped,true) and ownTask(ped,r) then ClearPedTasks(ped);TaskWanderStandard(ped,10.0,10) end
  tag(ped,{version=1,model=r.model,released=true,at=networkTime()})
  cooldowns[ped]=GetGameTimer()+Config.NpcPedestrians.CooldownMs
 end
end
local function safePoint(p)
 local cfg=Config.NpcPedestrians
 local ok,q=GetSafeCoordForPed(p.x,p.y,p.z,cfg.OnlyPavement,10)
 if (ok~=true and ok~=1) or not q or flatDistance(p,q)>cfg.MaxSnapDistance or math.abs(p.z-q.z)>cfg.HeightTolerance then return end
 return point(q)
end
local function issue(ped,r,target)
 local cfg=Config.NpcPedestrians
 r.task='SCRIPT_TASK_FOLLOW_NAV_MESH_TO_COORD';r.scenario=nil;r.issuedAt=GetGameTimer();r.progressAt=r.issuedAt;r.bestDistance=nil
 TaskFollowNavMeshToCoord(ped,target.x,target.y,target.z,cfg.WalkSpeed,cfg.RouteTimeoutMs,cfg.WaypointRadius,cfg.NavFlags,0.0)
 publish(ped,r)
end
local function route(ped,r,points,phase)
 if r.scenario and IsPedUsingScenario(ped,r.scenario) then ClearPedTasks(ped) end
 r.points=points;r.index=1;r.phase=phase;r.routeAt=GetGameTimer()
 issue(ped,r,points[1])
end
local function plan(p,s,hit,segments)
 local cfg=Config.NpcPedestrians;local best,score
 for _,candidate in ipairs(M.candidates(p,s,hit,cfg)) do
  local path={};for _,target in ipairs(candidate) do local q=safePoint(target);if not q then path=nil;break end;path[#path+1]=q end
  if path and M.routeClear(p,path,segments,cfg) then
   local distance=0;local previous=p
   for _,q in ipairs(path) do distance=distance+TapeGeometry.distance(previous,q);previous=q end
   if not score or distance<score then best,score=path,distance end
  end
 end
 return best
end
local function countReactions(scene)
 local all,near=0,0
 for _,r in pairs(records) do if r.phase=='reaction' then all=all+1;if r.scene==scene then near=near+1 end end end
 return all,near
end
local function stop(ped,r,segments)
 local cfg=Config.NpcPedestrians;local p=point(GetEntityCoords(ped));local h=r.hit
 local target={x=h.q.x+h.nx*h.sign*cfg.StopDistance,y=h.q.y+h.ny*h.sign*cfg.StopDistance,z=p.z}
 local q=safePoint(target)
 if q and M.routeClear(p,{q},segments,cfg) then route(ped,r,{q},'stop_move')
 else
  r.phase='orient';r.reactAt=GetGameTimer()+700;r.task='SCRIPT_TASK_TURN_PED_TO_FACE_COORD';r.scenario=nil;r.issuedAt=GetGameTimer()
  TaskStandStill(ped,800);TaskTurnPedToFaceCoord(ped,h.q.x,h.q.y,h.q.z,700);publish(ped,r)
 end
end
local function react(ped,r)
 local cfg=Config.NpcPedestrians;local now=GetGameTimer()
 local all,near=countReactions(r.scene)
 local name,reaction
 if cfg.ReactionsEnabled and all<cfg.MaxReactions and near<cfg.MaxPerScene and not (cooldowns[ped] and now<cooldowns[ped]) and math.random()<cfg.ReactionChance then name,reaction=M.pick(cfg.Reactions) end
 r.phase='reaction';r.reaction=name;r.task='SCRIPT_TASK_STAND_STILL';r.scenario=reaction and reaction.Scenario~='' and reaction.Scenario or nil
 r.untilAt=now+math.random(cfg.MinDwellMs,cfg.MaxDwellMs);r.issuedAt=now
 if r.scenario then
  r.task='SCRIPT_TASK_START_SCENARIO_IN_PLACE';TaskStartScenarioInPlace(ped,r.scenario,0,true)
 else TaskStandStill(ped,cfg.MaxDwellMs+1000) end
 publish(ped,r)
end
local function depart(ped,r,segments)
 local cfg=Config.NpcPedestrians;local p=point(GetEntityCoords(ped));local h=r.hit
 local q=safePoint({x=p.x+h.nx*h.sign*cfg.DepartureDistance,y=p.y+h.ny*h.sign*cfg.DepartureDistance,z=p.z})
 if q and M.routeClear(p,{q},segments,cfg) then
  cooldowns[ped]=GetGameTimer()+cfg.CooldownMs;route(ped,r,{q},'depart')
 else
  -- No safe exit: wait and retry rather than send a ped into traffic or through tape.
  r.untilAt=GetGameTimer()+cfg.RetryMs;r.task='SCRIPT_TASK_STAND_STILL';r.scenario=nil;r.issuedAt=GetGameTimer()
  ClearPedTasks(ped);TaskStandStill(ped,cfg.RetryMs+1000);publish(ped,r)
 end
end
local function question(ped,r)
 local cfg=Config.NpcPedestrians.Questions;local now=GetGameTimer()
 if not cfg.Enabled or r.asked or now-lastQuestion<cfg.GlobalCooldownMs then return end
 local p=GetEntityCoords(ped);local closest,distance=nil,cfg.PlayerDistance
 for _,player in ipairs(GetActivePlayers()) do
  local actor=GetPlayerPed(player)
  if actor~=0 and not IsEntityDead(actor) then
   local q=GetEntityCoords(actor);local d=TapeGeometry.distance(p,q)
   if d<distance then closest,distance=actor,d end
  end
 end
 if not closest then return end
 r.asked=true;lastQuestion=now
 local index=math.random(#cfg.Lines)
 TaskLookAtEntity(ped,closest,cfg.DisplayMs,2048,3)
 if cfg.Voice and cfg.SpeechName~='' then PlayPedAmbientSpeechNative(ped,cfg.SpeechName,'SPEECH_PARAMS_STANDARD') end
 TriggerEvent('apex_policetape:npcQuestionSpoken',ped,cfg.Lines[index],r.spanId)
 if NetworkGetEntityIsNetworked(ped) then TriggerServerEvent('apex_policetape:npcQuestion',NetworkGetNetworkIdFromEntity(ped),r.spanId,index)
 elseif cfg.Bubbles then bubbles[ped]={index=index,untilAt=now+cfg.DisplayMs,model=GetEntityModel(ped)} end
end
local function segments()
 local cfg=Config.NpcPedestrians;local p=GetEntityCoords(PlayerPedId());local list={}
 for id,t in pairs(TapeClient.tapes()) do
  if not t.brokenAt and not t.accessOpen then
   local a,b=TapeClient.liveEnds(t);local _,_,d=TapeContactMath.nearest(p,a,b)
   if d<cfg.ScanDistance+cfg.StartDistance then list[#list+1]={id=id,a=point(a),b=point(b),scene=t.sceneId or ('span:'..id),distance=d} end
  end
 end
 local managed={};for _,r in pairs(records) do if r.spanId then managed[r.spanId]=true end end
 table.sort(list,function(a,b)
  if managed[a.id]~=managed[b.id] then return managed[a.id]==true end
  return a.distance<b.distance
 end)
 while #list>cfg.MaxTapes do table.remove(list) end
 return list
end
local function takeover(ped)
 local t=readTag(ped)
 if type(t)~='table' or t.version~=1 or t.model~=GetEntityModel(ped) then return false end
 if t.released then
  local remain=Config.NpcPedestrians.CooldownMs-elapsed(t.at or 0)
  if remain>0 then cooldowns[ped]=GetGameTimer()+remain end
  tag(ped,nil);return false
 end
 -- Ownership migration: release only the tagged task, never a new job/combat task.
 local r={model=t.model,task=t.task,scenario=t.scenario,issuedAt=-100000}
 if safePed(ped,true) and ownTask(ped,r) then ClearPedTasks(ped);TaskWanderStandard(ped,10.0,10) end
 cooldowns[ped]=GetGameTimer()+Config.NpcPedestrians.CooldownMs;tag(ped,nil)
 return true
end
local function update(ped,r,list,byId,now)
 if not DoesEntityExist(ped) or GetEntityModel(ped)~=r.model or not controls(ped) then records[ped]=nil;return end
 if not safePed(ped,true) or not ownTask(ped,r) then finish(ped,false);return end
 local p=point(GetEntityCoords(ped));local cfg=Config.NpcPedestrians
 if TapeGeometry.distance(p,GetEntityCoords(PlayerPedId()))>cfg.ScanDistance+10 then finish(ped,true);return end
 if r.spanId and not byId[r.spanId] then
  local live=TapeClient.tapes()[r.spanId]
  if live and not live.brokenAt and not live.accessOpen then finish(ped,true);return end
  local target=safePoint(r.hit.goal)
  if target and M.routeClear(p,{target},list,cfg) then r.spanId=nil;route(ped,r,{target},'resume') else finish(ped,true) end
  return
 end
 if r.phase=='orient' then if now>=r.reactAt then react(ped,r) end;return end
 if r.phase=='reaction' then
  if r.scenario and now-r.issuedAt>2000 and not IsPedUsingScenario(ped,r.scenario) then
   r.scenario=nil;r.reaction='watch';r.task='SCRIPT_TASK_STAND_STILL';r.issuedAt=now
   TaskStandStill(ped,math.max(1000,r.untilAt-now));publish(ped,r)
  end
  if r.reaction=='ask' then question(ped,r) end
  if now>=r.untilAt then depart(ped,r,list) end
  return
 end
 if now-r.routeAt>cfg.RouteTimeoutMs or r.phase=='stop_move' and now-r.routeAt>cfg.StopApproachMs then
  if r.phase=='bypass' then stop(ped,r,list) elseif r.phase=='stop_move' then
   r.phase='orient';r.reactAt=now+700;r.task='SCRIPT_TASK_TURN_PED_TO_FACE_COORD';r.scenario=nil;r.issuedAt=now
   TaskTurnPedToFaceCoord(ped,r.hit.q.x,r.hit.q.y,r.hit.q.z,700);publish(ped,r) else finish(ped,true) end
  return
 end
 local target=r.points[r.index]
 local distance=flatDistance(p,target)
 if not r.bestDistance or distance<r.bestDistance-.15 then r.bestDistance=distance;r.progressAt=now end
 if r.phase=='bypass' and now-r.progressAt>cfg.ProgressTimeoutMs then stop(ped,r,list);return end
 if distance<=cfg.WaypointRadius and math.abs(p.z-target.z)<cfg.HeightTolerance then
  r.index=r.index+1
  if r.index>#r.points then
   if r.phase=='stop_move' then
    r.phase='orient';r.reactAt=now+700;r.task='SCRIPT_TASK_TURN_PED_TO_FACE_COORD';r.scenario=nil;r.issuedAt=now
    TaskTurnPedToFaceCoord(ped,r.hit.q.x,r.hit.q.y,r.hit.q.z,700);publish(ped,r)
   else finish(ped,true) end
  else issue(ped,r,r.points[r.index]) end
  return
 end
 local unsafe=not M.routeClear(p,{target},list,cfg)
 local velocity=GetEntityVelocity(ped)
 local future={x=p.x+velocity.x*.6,y=p.y+velocity.y*.6,z=p.z}
 for _,s in ipairs(list) do if TapeGeometry.sweepHit(p,future,s.a,s.b,cfg.Clearance,cfg.MinZ,cfg.MaxZ) then unsafe=true;break end end
 if unsafe then stop(ped,r,list) end
end
function P.tick()
 if not TapeClient then return end
 local cfg=Config.NpcPedestrians
 if not cfg.Enabled or TapeSettings.Valid==false then if wasEnabled then P.clear() end;wasEnabled=false;return end
 wasEnabled=true
 local list=segments();local byId={};for _,s in ipairs(list) do byId[s.id]=s end
 local now=GetGameTimer();local count=0
 for ped,r in pairs(records) do update(ped,r,list,byId,now);if records[ped] then count=count+1 end end
 for ped,at in pairs(cooldowns) do if now>=at or not DoesEntityExist(ped) then cooldowns[ped]=nil end end
 if #list==0 or count>=cfg.MaxActive then return end
 local pool=GetGamePool('CPed');local player=GetEntityCoords(PlayerPedId())
 for _=1,math.min(#pool,cfg.MaxPedsPerTick) do
  if cursor>#pool then cursor=1 end
  local ped=pool[cursor];cursor=cursor+1
  if ped and not records[ped] and DoesEntityExist(ped) and not IsPedAPlayer(ped) and controls(ped) then
   if not takeover(ped) and safePed(ped,false) then
    local p=point(GetEntityCoords(ped))
    if TapeGeometry.distance(p,player)<=cfg.ScanDistance then
     local v=GetEntityVelocity(ped);local selected,hit
     for _,s in ipairs(list) do local h=M.approach(p,v,s,cfg);if h and (not hit or h.distance<hit.distance) then selected,hit=s,h end end
     if selected then
      local r={model=GetEntityModel(ped),spanId=selected.id,scene=selected.scene,hit=hit};records[ped]=r;count=count+1
      local path=cfg.DivertAngled and hit.diagonal and plan(p,selected,hit,list)
      if path then route(ped,r,path,'bypass') else stop(ped,r,list) end
      if count>=cfg.MaxActive then break end
     end
    end
   end
  end
 end
end
function P.clear()
 for ped in pairs(records) do finish(ped,true) end
 bubbles={}
 -- Catch tagged peds whose ownership changed just before a resource stop.
 for _,ped in ipairs(GetGamePool('CPed')) do if DoesEntityExist(ped) and not IsPedAPlayer(ped) and controls(ped) then takeover(ped);if readTag(ped) then tag(ped,nil) end end end
end
RegisterNetEvent('apex_policetape:npcQuestionBubble',function(p)
 if not Config.NpcPedestrians.Enabled or not Config.NpcPedestrians.Questions.Enabled or not Config.NpcPedestrians.Questions.Bubbles or type(p)~='table' or not Config.NpcPedestrians.Questions.Lines[p.index] then return end
 local ped=NetworkGetEntityFromNetworkId(p.netId)
 if ped~=0 and DoesEntityExist(ped) and GetEntityModel(ped)==p.model then bubbles[ped]={index=p.index,untilAt=GetGameTimer()+Config.NpcPedestrians.Questions.DisplayMs,model=p.model} end
end)
CreateThread(function()while true do Wait(Config.NpcPedestrians.UpdateMs);P.tick() end end)
CreateThread(function()
 while true do
  local active=false;local now=GetGameTimer();local cfg=Config.NpcPedestrians.Questions
  for ped,b in pairs(bubbles) do
   if not Config.NpcPedestrians.Enabled or not cfg.Bubbles or now>b.untilAt or not DoesEntityExist(ped) or GetEntityModel(ped)~=b.model then bubbles[ped]=nil
   else
    local p=GetEntityCoords(ped)
    if TapeGeometry.distance(p,GetEntityCoords(PlayerPedId()))<=cfg.DrawDistance then
     active=true;local visible,x,y=World3dToScreen2d(p.x,p.y,p.z+1.1)
     if visible then
      SetTextScale(.0,.32);SetTextFont(4);SetTextCentre(true);SetTextColour(255,255,255,230);SetTextOutline()
      BeginTextCommandDisplayText('STRING');AddTextComponentSubstringPlayerName(cfg.Lines[b.index]:gsub('~',''));EndTextCommandDisplayText(x,y)
     end
    end
   end
  end
  Wait(active and 0 or 200)
 end
end)
AddEventHandler('onResourceStop',function(name)if name==GetCurrentResourceName() then P.clear() end end)
