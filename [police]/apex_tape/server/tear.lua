-- Floor reports affect visual remnants only. Only their owner/staff may supply
-- a nearby, bounded sample; one accepted pair is retained until repair/retear.
RegisterNetEvent('apex_policetape:tearGround',function(id,stamp,floorA,floorB)
 local R=TapeRuntime;local src=source
 if not R or not Config.TornEnds.Enabled or type(id)~='number' or type(stamp)~='number' then return end
 local t=R.tapes[id]
 if not t or t.brokenAt~=stamp or t.tearFloorStamp==stamp or t.bucket~=GetPlayerRoutingBucket(src)
  or not (R.owned(t,src) or R.admin(src)) then return end
 local ped=GetPlayerPed(src);if ped==0 then return end
 local a,b=R.liveEnd(t,'a'),R.liveEnd(t,'b')
 if R.segmentDistance(GetEntityCoords(ped),a,b)>Config.DrawDistance then return end
 for _,pair in ipairs({{a,floorA},{b,floorB}})do
  if not TapeGeometry.finite(pair[2]) or pair[1].z-pair[2]<.1 or pair[1].z-pair[2]>Config.TornEnds.ProbeDepth then return end
 end
 t.tearFloorA=floorA;t.tearFloorB=floorB;t.tearFloorStamp=stamp
 -- Ground samples are transient; persistence already keeps the tape geometry.
 R.emit(t.bucket,'apex_policetape:add',R.public(t))
end)
