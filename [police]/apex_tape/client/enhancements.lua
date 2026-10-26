TapeEnhanceClient={}
TapeEnhanceHooks=TapeEnhanceHooks or {}
local C,M=TapeEnhanceClient,TapeEnhanceMath
local passage,posePed=nil,nil
local anchorNotices={}
C.targetActions={'pickup','reconnect','drop','pass','inspect'}
C.labels={pickup='Pick up loose end',reconnect='Reconnect carried end',drop='Drop loose end',pass='Duck / step past tape',inspect='Inspect tape / scene'}
local function me()return type(GetPlayerServerId)=='function' and GetPlayerServerId(PlayerId()) or -1 end
local function cancelControl()
 local keyboard=type(IsUsingKeyboardAndMouse)=='function' and IsUsingKeyboardAndMouse(0)
 if type(IsUsingKeyboardAndMouse)~='function' then keyboard=type(IsInputDisabled)~='function' or IsInputDisabled(0)end
 return keyboard and 177 or Config.Controller.Cancel
end
local function cancelled()
 local key=cancelControl()
 return IsControlJustPressed(0,key) or type(IsDisabledControlJustPressed)=='function' and IsDisabledControlJustPressed(0,key)
end
local function held()
 if not TapeClient then return end
 for id,t in pairs(TapeClient.tapes())do if t.carry and t.carry.holder==me() then return id,t end end
end
function C.holding()return held()~=nil end
function C.targetId(action)if action=='drop' or action=='reconnect' then return held()end end
function C.passing(id)return passage and passage.id==id and GetGameTimer()<passage.untilAt end
function C.isAction(action)return C.labels[action]~=nil end
local function nearby()
 local best,distance=nil,Config.EditReach;local p=GetEntityCoords(PlayerPedId())
 for id,t in pairs(TapeClient.tapes())do
  local a,b=TapeClient.liveEnds(t);local d
  if t.brokenAt then local q;q,d=TapeTearMath.nearest(M.paths(t,a,b,Config.TornEnds.SettleMs),p) else local _,_,n=TapeContactMath.nearest(p,a,b);d=n end
  if d<distance then best,distance=id,d end
 end
 return best
end
function C.can(id,action)
 local t=TapeClient.tapes()[id];if not t then return false end
 if action=='inspect' then return Config.Inspection.Enabled end
 if action=='pass' then return Config.Passage.Enabled and not t.brokenAt and not t.accessOpen and not C.holding() and not (TapeAccessClient and TapeAccessClient.holding()) and not passage end
 if not Config.LooseEnds.Enabled then return false end
 if action=='pickup' then
  if not t.brokenAt or t.carry or C.holding() then return false end
  local a,b=TapeClient.liveEnds(t);local paths=TapeTearMath.paths(a,b,t.breakFraction,Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB)
  local p=GetEntityCoords(PlayerPedId())
  for i,side in ipairs({'a','b'})do if not (t.looseRemoved and t.looseRemoved[side]) and TapeGeometry.distance(p,paths[i][#paths[i]])<=Config.LooseEnds.Reach then return true end end
  return false
 end
 return t.carry and t.carry.holder==me() or false
end
local function loadCarry()
 local c=Config.LooseEnds;RequestAnimDict(c.AnimDict)
 local deadline=GetGameTimer()+3000
 while not HasAnimDictLoaded(c.AnimDict) and GetGameTimer()<deadline do Wait(0)end
 return HasAnimDictLoaded(c.AnimDict)
end
local function clearPass()
 if not passage then return end
 local old=passage;passage=nil
 local ped=PlayerPedId()
 if type(GetScriptTaskStatus)=='function' then
  local status=GetScriptTaskStatus(ped,GetHashKey('SCRIPT_TASK_GO_STRAIGHT_TO_COORD'))
  if status==0 or status==1 then ClearPedTasks(ped) end
 end
 if old.crouched then
  if type(TapeEnhanceHooks.RestoreMovement)=='function' then TapeEnhanceHooks.RestoreMovement(ped) else ResetPedMovementClipset(ped,.25) end
 end
 TapeClient.accessAction('enh_endpass',{id=old.id})
end
local function clearRoute(start,goal,duck)
 local z=duck and -.2 or .35
 local handle=StartShapeTestCapsule(start.x+0.0,start.y+0.0,start.z+z,goal.x+0.0,goal.y+0.0,goal.z+z,.25,19,PlayerPedId(),7)
 local deadline=GetGameTimer()+200
 repeat
  local status,hit=GetShapeTestResult(handle)
  if status==2 then return hit~=1 and hit~=true end
  if status==0 then return false end
  Wait(0)
 until GetGameTimer()>=deadline
 return false
end
function C.select(action,id)
 local t=TapeClient.tapes()[id];if not t then return false end
 if not C.can(id,action) then TapeClient.notify('This tape interaction is unavailable.','error');return false end
 if action=='pickup' and not loadCarry() then TapeClient.notify('Carry animation could not load.','error');return false end
 if action=='reconnect' then
  local anchor=TapeClient.aimedAnchor and TapeClient.aimedAnchor()
  if not anchor then TapeClient.notify('Aim at a new solid attachment within reach.','error');return false end
  local p=anchor.attach
  local result=TapeClient.accessAction('enh_reconnect',{id=id,revision=t.revision or 0,position={x=p.x,y=p.y,z=p.z},post=anchor.post==true,surface=anchor.surface,wrap=anchor.wrap})
  if result then TapeClient.notify('Loose end reattached. The other tail remains available.','success') end
  return result~=nil
 end
 if action=='pass' then
  local a,b=TapeClient.liveEnds(t);local start=GetEntityCoords(PlayerPedId());local goal,q=M.crossing(start,a,b)
  if not goal then TapeClient.notify(q,'error');return false end
  local duck=q.z-start.z>Config.Passage.DuckAbove
  if not clearRoute(start,goal,duck) then TapeClient.notify('The route is obstructed. Choose another gap.','error');return false end
  if duck then
   RequestAnimSet(Config.Passage.CrouchClipset);local deadline=GetGameTimer()+2000
   while not HasAnimSetLoaded(Config.Passage.CrouchClipset) and GetGameTimer()<deadline do Wait(0)end
   if not HasAnimSetLoaded(Config.Passage.CrouchClipset) then TapeClient.notify('Crouch movement is unavailable.','error');return false end
  end
  local result=TapeClient.accessAction('enh_pass',{id=id})
  if not result then return false end
  local ped=PlayerPedId();local dest=result.destination
  passage={id=id,untilAt=GetGameTimer()+result.duration,destination=dest,crouched=result.mode=='duck'}
  local heading=GetHeadingFromVector_2d(dest.x-start.x,dest.y-start.y);SetEntityHeading(ped,heading+0.0)
  if passage.crouched then SetPedMovementClipset(ped,Config.Passage.CrouchClipset,.25)
  else
   TaskJump(ped,false,false,false);Wait(120)
   if not passage then return false end
   local velocity=GetEntityVelocity(ped);local dx,dy=dest.x-start.x,dest.y-start.y;local len=math.max(.1,math.sqrt(dx*dx+dy*dy))
   SetEntityVelocity(ped,dx/len*1.2,dy/len*1.2,velocity.z+0.0)
   local deadline=GetGameTimer()+1800
   while passage and GetGameTimer()<deadline and (IsPedJumping(ped) or IsPedFalling(ped)) do Wait(0)end
  end
  if passage then TaskGoStraightToCoord(ped,dest.x+0.0,dest.y+0.0,dest.z+0.0,Config.Passage.Speed+0.0,-1,heading+0.0,.1) end
  return true
 end
 local result=TapeClient.accessAction('enh_'..action,{id=id,revision=t.revision or 0})
 if result and result.inspection then
  local i=result.inspection
  TapeClient.notify(('%s | %s | Placed by %s | %.1f m | Wear %d%% | %s | %s'):format(i.scene,i.style,i.placedBy,i.length,i.wear,i.broken and 'Torn' or 'Intact',i.expires and ('Expires in '..math.ceil(i.expires/60)..' min') or 'No expiry'))
 elseif result then TapeClient.notify(action=='pickup' and 'Loose end picked up. Walk to an anchor; /reconnecttape attaches it. Backspace drops it.' or 'Loose end dropped.','success') end
 return result~=nil
end
function C.command(name,args)
 local id=(name=='droptape' or name=='reconnecttape') and held() or nearby()
 if not id then TapeClient.notify('Move beside the tape or its loose tip.','error');return end
 if name=='tapeadjust' then
  local t=TapeClient.tapes()[id];local a,b=TapeClient.liveEnds(t);local p=GetEntityCoords(PlayerPedId())
  local side=args[2] or (TapeGeometry.distance(p,a)<TapeGeometry.distance(p,b) and 'a' or 'b')
  local direction=args[1] or 'tight';local steps=tonumber(args[3]) or 1
  if not TapeGeometry.finite(steps) or steps%1~=0 or steps<1 or steps>Config.Adjustment.MaxSteps then TapeClient.notify('Adjustment step count is out of range.','error');return end
  local offset=({up={0,0,1},down={0,0,-1},left={-1,0,0},right={1,0,0},forward={0,1,0},back={0,-1,0}})[direction]
  local old=side=='a' and a or b;local goal=old
  if offset then goal={x=old.x+offset[1]*Config.Adjustment.Step*steps,y=old.y+offset[2]*Config.Adjustment.Step*steps,z=old.z+offset[3]*Config.Adjustment.Step*steps} end
  if TapeClient.accessAction('enh_adjust',{id=id,revision=t.revision or 0,side=side,direction=direction,steps=steps,position=goal}) then TapeClient.notify('Tape adjusted.','success') end
 else C.select(({pickuptape='pickup',reconnecttape='reconnect',droptape='drop',tapepass='pass',tapeinspect='inspect'})[name],id) end
end
CreateThread(function()
 while true do
  local id,t=held();local ped=PlayerPedId()
  if id and (IsEntityDead(ped) or IsPedInAnyVehicle(ped,false)) then id=nil end
  if id then
   if not HasAnimDictLoaded(Config.LooseEnds.AnimDict) then RequestAnimDict(Config.LooseEnds.AnimDict)
   elseif not IsEntityPlayingAnim(ped,Config.LooseEnds.AnimDict,Config.LooseEnds.AnimName,3) then
    TaskPlayAnim(ped,Config.LooseEnds.AnimDict,Config.LooseEnds.AnimName,3.0,-3.0,-1,49,1.0,false,false,false);posePed=ped
   end
   for _,key in ipairs({21,22,23,24,25,75})do DisableControlAction(0,key,true)end
   DisablePlayerFiring(PlayerId(),true)
   if cancelled() then C.select('drop',id)end
  elseif posePed then StopAnimTask(posePed,Config.LooseEnds.AnimDict,Config.LooseEnds.AnimName,2.0);posePed=nil end
  if passage then
   local p=GetEntityCoords(ped)
   if GetGameTimer()>=passage.untilAt or IsEntityDead(ped) or IsPedInAnyVehicle(ped,false) or not TapeClient.tapes()[passage.id]
    or TapeGeometry.distance(p,passage.destination)<.35 or cancelled()
    or IsControlJustPressed(0,32) or IsControlJustPressed(0,33) or IsControlJustPressed(0,34) or IsControlJustPressed(0,35) then clearPass() end
  end
  Wait((id or passage) and 0 or 100)
 end
end)
if type(TriggerEvent)=='function' then
 for name,description in pairs({tapeadjust='Adjust existing tape: tight/loose or up/down/left/right/forward/back [a/b] [steps]',
  pickuptape='Pick up a torn tip',reconnecttape='Aim at a new anchor and reconnect the carried end',droptape='Drop the carried end',
  tapepass='Request a controlled duck/hop past tape',tapeinspect='Inspect the nearby scene and tape condition'})do
  TriggerEvent('chat:addSuggestion','/'..TapeCommands.name(name),description)
 end
end
RegisterNetEvent('apex_policetape:anchorRelease',function(data)
 if not Config.AnchorFailure.Enabled or type(data)~='table' or not TapeGeometry.point(data.position) or type(data.model)~='number' then return end
 local key=tostring(data.id)..':'..tostring(data.side)
 local count=0;for k,at in pairs(anchorNotices)do if GetGameTimer()-at>10000 then anchorNotices[k]=nil else count=count+1 end end
 if count>=256 then return end
 if anchorNotices[key] and GetGameTimer()-anchorNotices[key]<5000 then return end
 anchorNotices[key]=GetGameTimer()
 local allowed=false;for _,name in ipairs(Config.AnchorFailure.Models)do if GetHashKey(name)==data.model then allowed=true end end
 if not allowed or TapeGeometry.distance(GetEntityCoords(PlayerPedId()),data.position)>15 then return end
 local pool=GetGamePool('CObject')
 for i=1,math.min(#pool,512)do
  local entity=pool[i]
  if DoesEntityExist(entity) and GetEntityModel(entity)==data.model and TapeGeometry.distance(GetEntityCoords(entity),data.position)<2
   and (not NetworkGetEntityIsNetworked(entity) or NetworkHasControlOfEntity(entity)) then
   FreezeEntityPosition(entity,false)
   local r=GetEntityRotation(entity,2);SetEntityRotation(entity,70.0,r.y+0.0,r.z+0.0,2,true)
   return
  end
 end
end)
AddEventHandler('onResourceStop',function(name)
 if name~=GetCurrentResourceName() then return end
 if posePed then StopAnimTask(posePed,Config.LooseEnds.AnimDict,Config.LooseEnds.AnimName,2.0)end
 if passage and type(GetScriptTaskStatus)=='function' then
  local status=GetScriptTaskStatus(PlayerPedId(),GetHashKey('SCRIPT_TASK_GO_STRAIGHT_TO_COORD'))
  if status==0 or status==1 then ClearPedTasks(PlayerPedId())end
 end
 if passage and passage.crouched then ResetPedMovementClipset(PlayerPedId(),.25)end
 passage=nil
end)
