-- Server-created network entities are shared by all nearby clients and recorded
-- as objects. Client requests contain no model, position or tape state.
TapeEditorServer={}
local E=TapeEditorServer
local viewers,objects,lastRequest={},{},{}
local breakClocks={}
local function erase(list)
 for _,o in ipairs(list or {}) do if DoesEntityExist(o.entity) then DeleteEntity(o.entity) end end
end
RegisterNetEvent('apex_policetape:editorSubscribe',function(enabled)
 local src=source;local now=GetGameTimer()
 if lastRequest[src] and now-lastRequest[src]<500 then return end
 lastRequest[src]=now
 if enabled==true and Config.Editor.Enabled then viewers[src]=now else viewers[src]=nil end
end)
AddEventHandler('playerDropped',function()viewers[source]=nil;lastRequest[source]=nil end)
local function publish(bucket,id,list)
 local ids={}
 for _,o in ipairs(list or {}) do
  -- Keep a zero placeholder so an incomplete span is never reported as ready.
  ids[#ids+1]=o.entity~=0 and DoesEntityExist(o.entity) and NetworkGetNetworkIdFromEntity(o.entity) or 0
 end
 TapeRuntime.emit(bucket,'apex_policetape:editorObjects',{id=id,ids=ids})
end
function E.tick()
 local R=TapeRuntime
 if not R or not R.ready() then return end
 local now=GetGameTimer();local wanted={};local ends={};local cfg=Config.Editor
 for src,at in pairs(viewers) do
  local ped=GetPlayerPed(src)
  if not cfg.Enabled or now-at>6000 or ped==0 then viewers[src]=nil
  else
   local p=GetEntityCoords(ped);local bucket=GetPlayerRoutingBucket(src)
   for id,t in pairs(R.tapes) do
    if t.bucket==bucket then
     local pair=ends[id]
     if not pair then pair={R.liveEnd(t,'a'),R.liveEnd(t,'b')};ends[id]=pair end
     local a,b=pair[1],pair[2]
     local distance=R.segmentDistance(p,a,b)
     if distance<=cfg.Distance and (not wanted[id] or distance<wanted[id].distance) then wanted[id]={t=t,a=a,b=b,distance=distance} end
    end
   end
  end
 end
 local sorted={};for id,w in pairs(wanted) do w.id=id;sorted[#sorted+1]=w end
 table.sort(sorted,function(a,b)if a.distance==b.distance then return a.id<b.id end;return a.distance<b.distance end)
 local keep={};local used=0;local tapes=0
 for _,w in ipairs(sorted) do
  local elapsed
  if w.t.brokenAt then
   local clock=breakClocks[w.id]
   if not clock or clock.stamp~=w.t.brokenAt then
    clock={stamp=w.t.brokenAt,start=now-math.max(0,os.time()-w.t.brokenAt)*1000};breakClocks[w.id]=clock
   end
   elapsed=math.max(0,now-clock.start)
  else breakClocks[w.id]=nil end
  local list=TapeEditorMath.segments(w.t,w.a,w.b,now,TapeContactServer and TapeContactServer.public(w.id),elapsed)
  local supported=list and #list>0
  for _,v in ipairs(list or {}) do if not v.model then supported=false end end
  if supported and tapes<cfg.MaxTapes and used+#list<=cfg.MaxObjects then
   keep[w.id]=true;used=used+#list;tapes=tapes+1
   local old=objects[w.id]
   if old and old.bucket~=w.t.bucket then erase(old.list);publish(old.bucket,w.id,{});old=nil end
   local current=old and old.list or {};local changed=not old
   for i,v in ipairs(list) do
    local o=current[i]
    if o and o.model:match('^(.+)_%d+$')==v.model:match('^(.+)_%d+$') then
     local cm=tonumber(o.model:match('_(%d+)$'))
     if math.abs(cm/100-v.length)<.04 then v.model=o.model end
    end
    if not o or o.model~=v.model or not DoesEntityExist(o.entity) and now>=(o.retryAt or 0) then
     if o then erase({o}) end
     local entity=CreateObjectNoOffset(GetHashKey(v.model),v.x,v.y,v.z,true,true,false)
     o={model=v.model,entity=entity,retryAt=now+2000};current[i]=o;changed=true
     if entity~=0 then
      SetEntityRoutingBucket(entity,w.t.bucket);SetEntityOrphanMode(entity,2)
      Entity(entity).state:set('apexTapeEditor',w.id,true)
     end
    end
    if o.entity~=0 and DoesEntityExist(o.entity) and (not o.last or math.abs(o.last.x-v.x)+math.abs(o.last.y-v.y)+math.abs(o.last.z-v.z)>.002 or math.abs(o.last.pitch-v.pitch)+math.abs(o.last.yaw-v.yaw)>.2) then
     SetEntityCoords(o.entity,v.x,v.y,v.z,false,false,false,false)
     SetEntityRotation(o.entity,0,v.pitch,v.yaw,2,true);o.last=v
    end
   end
   for i=#current,#list+1,-1 do erase({current[i]});current[i]=nil;changed=true end
   objects[w.id]={list=current,bucket=w.t.bucket}
   if changed or not old or now-(old.published or 0)>2000 then
    publish(w.t.bucket,w.id,current);objects[w.id].published=now
   else objects[w.id].published=old.published end
  end
 end
 for id in pairs(breakClocks)do if not wanted[id] then breakClocks[id]=nil end end
 for id,record in pairs(objects) do
  if not keep[id] then erase(record.list);publish(record.bucket,id,{});objects[id]=nil end
 end
end
CreateThread(function()while true do Wait(math.max(50,Config.Editor.UpdateMs));E.tick() end end)
AddEventHandler('onResourceStop',function(name)
 if name==GetCurrentResourceName() then for _,r in pairs(objects) do erase(r.list) end end
end)
