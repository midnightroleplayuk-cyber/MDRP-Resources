-- Cosmetic question relay: no client-supplied text, scenarios, tasks or locations.
local lastNpc,lastPlayer,lastBucket={},{},{}
RegisterNetEvent('apex_policetape:npcQuestion',function(netId,spanId,index)
 local cfg=Config.NpcPedestrians;local q=cfg.Questions;local src=source
 if not cfg.Enabled or not cfg.ReactionsEnabled or not cfg.Reactions.ask.Enabled or not q.Enabled or type(netId)~='number' or netId%1~=0 or netId<1 or netId>65535 or type(index)~='number' or index%1~=0 or not q.Lines[index] then return end
 local now=GetGameTimer();local bucket=GetPlayerRoutingBucket(src)
 if lastPlayer[src] and now-lastPlayer[src]<q.GlobalCooldownMs then return end
 if lastBucket[bucket] and now-lastBucket[bucket]<q.GlobalCooldownMs then return end
 if lastNpc[netId] and now-lastNpc[netId]<q.PedCooldownMs then return end
 local R=TapeRuntime;local t=R and R.tapes[tonumber(spanId)]
 local ped=NetworkGetEntityFromNetworkId(netId);local player=GetPlayerPed(src)
 if not t or t.brokenAt or t.openUntil or t.bucket~=bucket or player==0 or ped==0 or not DoesEntityExist(ped)
  or GetEntityType(ped)~=1 or NetworkGetEntityOwner(ped)~=src or GetEntityRoutingBucket(ped)~=bucket or GetEntityHealth(ped)<=0 then return end
 for _,value in ipairs(GetPlayers()) do if GetPlayerPed(tonumber(value))==ped then return end end
 local p=GetEntityCoords(ped)
 if TapeGeometry.distance(p,GetEntityCoords(player))>cfg.ScanDistance or R.segmentDistance(p,R.liveEnd(t,'a'),R.liveEnd(t,'b'))>cfg.StartDistance+3 then return end
 lastNpc[netId]=now;lastPlayer[src]=now;lastBucket[bucket]=now
 R.emit(bucket,'apex_policetape:npcQuestionBubble',{netId=netId,index=index,model=GetEntityModel(ped)})
end)
AddEventHandler('playerDropped',function()lastPlayer[source]=nil end)
CreateThread(function()
 while true do
  Wait(30000);local now=GetGameTimer()
  for id,at in pairs(lastNpc) do if now-at>Config.NpcPedestrians.Questions.PedCooldownMs*2 then lastNpc[id]=nil end end
  for id,at in pairs(lastBucket) do if now-at>60000 then lastBucket[id]=nil end end
 end
end)
