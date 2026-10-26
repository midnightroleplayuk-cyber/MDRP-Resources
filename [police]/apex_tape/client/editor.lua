-- Recording objects are prepared near tape before recording begins.
-- The procedural draw loop cannot be reconstructed by Rockstar Editor playback.
TapeEditorClient={}
local E=TapeEditorClient
local mode=Config.Editor.Mode
local records={}
local lastNearbyAt=nil
local recordingWasActive=false
local function nearby(tape)
 if not TapeClient then return false end
 local a,b=TapeClient.liveEnds(tape)
 if not a or not b then return false end
 local p=GetEntityCoords(PlayerPedId())
 local dx,dy,dz=b.x-a.x,b.y-a.y,b.z-a.z
 local squared=dx*dx+dy*dy+dz*dz
 local f=squared>0 and math.max(0,math.min(1,((p.x-a.x)*dx+(p.y-a.y)*dy+(p.z-a.z)*dz)/squared)) or 0
 local x,y,z=p.x-a.x-dx*f,p.y-a.y-dy*f,p.z-a.z-dz*f
 return x*x+y*y+z*z<=Config.Editor.Distance^2
end
local function recording()
 return type(IsRecording)=='function' and IsRecording()==true
end
local function shouldSubscribe()
 if not Config.Editor.Enabled or mode=='off' then lastNearbyAt=nil;return false end
 if mode=='on' then return true end
 for _,tape in pairs(TapeClient and TapeClient.tapes() or {}) do
  if not tape.customText and nearby(tape) then lastNearbyAt=GetGameTimer();return true end
 end
 -- Avoid deleting/recreating props when the player briefly crosses the range edge.
 return lastNearbyAt~=nil and GetGameTimer()-lastNearbyAt<5000
end
RegisterNetEvent('apex_policetape:editorObjects',function(p)
 if type(p)=='table' and type(p.id)=='number' and type(p.ids)=='table' then records[p.id]={ids=p.ids,at=GetGameTimer()} end
end)
local function initialise(entity)
 SetEntityCollision(entity,false,false)
 SetEntityHasGravity(entity,false)
end
local function resolve(r,tapeId)
 if not r or #r.ids==0 then return false,'no recording objects received' end
 if GetGameTimer()-r.at>5000 then return false,'object update expired' end
 for _,id in ipairs(r.ids) do
  if id==0 then return false,'server object creation pending or failed' end
  if not NetworkDoesEntityExistWithNetworkId(id) then return false,'network object not streamed' end
  local entity=NetworkGetEntityFromNetworkId(id)
  if entity==0 or not DoesEntityExist(entity) then return false,'entity not loaded' end
  if Entity(entity).state.apexTapeEditor~=tapeId then return false,'object identity not synchronised' end
  if not HasModelLoaded(GetEntityModel(entity)) then return false,'model not loaded' end
  initialise(entity)
 end
 return true
end
function E.ready(id)
 local tape=TapeClient and TapeClient.tapes()[id]
 if tape and tape.customText then return false end
 local r=records[id];if not r then return false end
 local now=GetGameTimer()
 if r.checked and now-r.checked<250 then return r.ready end
 r.checked=now;r.ready=resolve(r,id);return r.ready
end
local function report(verbose)
 local ready,total,custom=0,0,0
 for id,tape in pairs(TapeClient and TapeClient.tapes() or {}) do
  if nearby(tape) then
   if tape.customText then custom=custom+1
   else
    total=total+1
    local ok,reason=resolve(records[id],id)
    if ok then ready=ready+1 elseif verbose then print(('[APEX Tape Editor] Span %s: %s'):format(id,reason)) end
   end
  end
 end
 return ready,total,custom
end
function E.command(args)
 local value=args[1] or 'status'
 if value=='on' or value=='off' or value=='auto' then
  mode=value;TriggerServerEvent('apex_policetape:editorSubscribe',shouldSubscribe())
  TapeClient.notify('Editor tape mode: '..value..(value=='auto' and '. Nearby tape objects now prepare before recording.' or '.'))
 elseif value=='status' then
  local ready,total,custom=report(true)
  local message=('Editor tape: %s; %d/%d nearby standard spans loaded; %d custom-text spans excluded.'):format(mode,ready,total,custom)
  if not Config.Editor.Enabled then message=message..' Editor.Enabled is false.'
  elseif mode=='off' then message=message..' Recording-object requests are off.'
  elseif ready<total then message=message..' Still loading or unavailable: see F8 details.' end
  TapeClient.notify(message)
  print('[APEX Tape Editor] '..message)
 else TapeClient.notify('Use /tapeeditor on, off, auto or status.','error') end
end
CreateThread(function()
 while true do
  TriggerServerEvent('apex_policetape:editorSubscribe',shouldSubscribe())
  local active=recording()
  if active and not recordingWasActive and Config.Editor.Enabled and mode~='off' then
   local ready,total=report(false)
   if ready<total then TapeClient.notify('Tape recording objects are still loading. Wait for /tapeeditor status to show loaded spans, then record a fresh clip.','error') end
  end
  recordingWasActive=active
  Wait(1000)
 end
end)
-- Initialise shared server props without requesting client entity ownership.
AddStateBagChangeHandler('apexTapeEditor',nil,function(bag,_,value)
 if not value then return end
 CreateThread(function()
  local deadline=GetGameTimer()+5000;local entity=0
  repeat entity=GetEntityFromStateBagName(bag);if entity==0 then Wait(50) end until entity~=0 or GetGameTimer()>deadline
  if entity~=0 then initialise(entity) end
 end)
end)
AddEventHandler('onResourceStop',function(name)
 if name==GetCurrentResourceName() then records={} end
end)
