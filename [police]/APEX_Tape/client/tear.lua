-- Ground checks run asynchronously once per broken span, outside drawing.
TapeTearClient={}
local C=TapeTearClient
local records={}
function C.paths(t,a,b)
 local now=GetGameTimer();local id=t.id
 local record=records[id]
 if not record or record.stamp~=t.brokenAt or TapeGeometry.distance(record.a,a)>.3 or TapeGeometry.distance(record.b,b)>.3 then
  record={stamp=t.brokenAt,a={x=a.x,y=a.y,z=a.z},b={x=b.x,y=b.y,z=b.z},queries={},started=now}
  local count=0;for _ in pairs(records)do count=count+1 end
  if count<Config.TornEnds.MaxGroundSpans or records[id] then records[id]=record end
 end
 record.used=now
 local elapsed=(t.breakElapsedMs or Config.TornEnds.SettleMs)+math.max(0,now-(t.brokenReceivedAt or now))
 return TapeEnhanceMath.paths(t,a,b,elapsed,t.tearFloorA or record.floorA,t.tearFloorB or record.floorB)
end
CreateThread(function()
 while true do
  local now=GetGameTimer();local work=0
  for id,r in pairs(records)do
   local tape=TapeClient and TapeClient.tapes()[id]
   if now-(r.used or now)>5000 or tape and not tape.brokenAt then records[id]=nil
   elseif Config.TornEnds.Enabled and type(StartShapeTestRay)=='function' and type(GetShapeTestResult)=='function' then
    for i,f in ipairs({.25,.5,.75})do
     if work>=Config.TornEnds.GroundQueriesPerTick then break end
     local q=r.queries[i]
     if not q then
      local p=TapeAccessMath.lerp(r.a,r.b,f)
      r.queries[i]={handle=StartShapeTestRay(p.x+0.0,p.y+0.0,p.z+.2,p.x+0.0,p.y+0.0,p.z-Config.TornEnds.ProbeDepth,17,PlayerPedId(),7),at=now}
      work=work+1
     elseif not q.done then
      local status,hit,pos=GetShapeTestResult(q.handle)
      work=work+1
      if status~=1 or now-q.at>2000 then
       q.done=true
       if status==2 and (hit==true or hit==1) and pos and TapeGeometry.point(pos) and pos.z<math.min(r.a.z,r.b.z)-.1 then q.z=pos.z end
       local left=r.queries[1] and r.queries[1].z
       local right=r.queries[3] and r.queries[3].z
       local middle=r.queries[2] and r.queries[2].z
       r.floorA=left and right and left-(right-left)*.5 or left or middle
       r.floorB=left and right and right+(right-left)*.5 or right or middle
      end
     end
    end
    if r.floorA and r.floorB and r.queries[3] and r.queries[3].done and not r.reported and type(TriggerServerEvent)=='function' then
     r.reported=true;TriggerServerEvent('apex_policetape:tearGround',id,r.stamp,r.floorA,r.floorB)
    end
   end
  end
  Wait(50)
 end
end)
