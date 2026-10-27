-- Server-only handover and bounded scene recovery. No client supplies restore geometry.
TapePolishServer={}
local P,R,S=TapePolishServer,TapeRuntime,TapeServices
local recoveries={}
local function fail(message)return {success=false,error=message}end
local function key(src)return GetPlayerIdentifierByType(src,'license')end
function P.departmentAccess(src,scene)
 if not Config.Polish.Enabled or not scene or not scene.department then return false end
 local job=S.job(src,Config.Permissions.Framework)
 return type(job)=='table' and job.name==scene.department and R.canUse(src)
end
function P.capture(src,scene)
 if not Config.Polish.Enabled or Config.Polish.RecoverSeconds<=0 or not key(src) then return end
 local count=0
 for k,v in pairs(recoveries) do if os.time()>v.untilAt then recoveries[k]=nil else count=count+1 end end
 if count>=Config.Polish.MaxRecoveries and not recoveries[key(src)] then return end
 local snapshot={scene=TapeSettings.copy(scene),spans={},costs={},untilAt=os.time()+Config.Polish.RecoverSeconds}
 for _,t in pairs(R.tapes) do if t.sceneId==scene.id then
  if #snapshot.spans>=Config.Polish.MaxRecoverySpans then return end
  local copy=TapeSettings.copy(t)
  copy.a,copy.b=TapeSettings.copy(R.liveEnd(t,'a')),TapeSettings.copy(R.liveEnd(t,'b'))
  copy.aLocal,copy.bLocal,copy.accessHold,copy.openUntil,copy.openedAt=nil,nil,nil,nil,nil
  copy.coneAId='recovered:'..t.id..':a';copy.coneBId='recovered:'..t.id..':b'
  if Config.Inventory.Enabled and Config.Inventory.RefundOnRemove and R.owned(t,src) and t.paidSpool then
   local item=t.paidItem or Config.Inventory.TapeItem;snapshot.costs[item]=(snapshot.costs[item] or 0)+1
  end
  snapshot.spans[#snapshot.spans+1]=copy
 end end
 recoveries[key(src)]=snapshot
end
function P.cutVisual(t,src)
 local a,b=R.liveEnd(t,'a'),R.liveEnd(t,'b')
 local ped=GetPlayerPed(src);local f=TapeAccessMath.fraction(GetEntityCoords(ped),a,b)
 R.emit(t.bucket,'apex_policetape:cutVisual',{id=t.id,a=a,b=b,style=t.style,fraction=f})
end
local function recover(src)
 local id=key(src);local snapshot=id and recoveries[id]
 if not snapshot or os.time()>snapshot.untilAt then if id then recoveries[id]=nil end;return fail('Recovery window expired or no cleared scene is available.') end
 local scene=snapshot.scene
 if not R.canUse(src) or (not R.admin(src) and scene.bucket~=GetPlayerRoutingBucket(src)) then return fail('Scene recovery access denied.') end
 if scene.expiresAt and scene.expiresAt<=os.time() then return fail('This scene has expired.') end
 local existing=R.scenes[scene.id]
 if existing and (not R.sceneAccess(src,existing) or existing.license~=scene.license or existing.department~=scene.department) then return fail('Scene ownership changed; recovery denied.') end
 local mine=0;for _,t in pairs(R.tapes) do if R.owned(t,src) then mine=mine+1 end end
 local rule=S.department(src);local limit=rule and math.min(Config.MaxPerPlayer,rule.MaxTapes or Config.MaxPerPlayer) or Config.MaxPerPlayer
 if not R.admin(src) and mine+#snapshot.spans>limit then return fail('Recovery would exceed your tape limit.') end
 local ownerCounts={}
 for _,t in pairs(R.tapes)do local k=t.license or tostring(t.owner);ownerCounts[k]=(ownerCounts[k] or 0)+1 end
 for _,t in ipairs(snapshot.spans)do local k=t.license or tostring(t.owner);ownerCounts[k]=(ownerCounts[k] or 0)+1;if ownerCounts[k]>Config.MaxPerPlayer then return fail('Recovery exceeds a saved owner tape limit.') end end
 local sceneCount,ownerScenes=0,0;for _,s in pairs(R.scenes)do sceneCount=sceneCount+1;if s.license==scene.license then ownerScenes=ownerScenes+1 end end
 if not existing and ownerScenes>=Config.Scenes.MaxPerPlayer then return fail('Saved owner scene limit reached.') end
 if not existing and sceneCount>=Config.Scenes.MaxTotal then return fail('Scene limit reached.') end
 for _,t in ipairs(snapshot.spans) do
  if (t.expiresAt and t.expiresAt<=os.time()) or not S.styleAllowed(src,t.style) then return fail('A saved span expired or its design is no longer permitted.') end
 end
 -- Stage validated geometry without broadcasts or item mutations, then commit once.
 local checkpoint=R.checkpoint();local ids={}
 R.scenes[scene.id]=existing or TapeSettings.copy(scene)
 local function rollback()
  R.rollback(checkpoint,ids,not existing and scene.id or nil)
 end
 for _,t in ipairs(snapshot.spans)do
  local result=R.create(src,{a=t.a,b=t.b,coneAId=t.coneAId,coneBId=t.coneBId,postA=t.postA,postB=t.postB,aWrap=t.aWrap,bWrap=t.bWrap,aSurface=t.aSurface,bSurface=t.bSurface,style=t.style,bucket=t.bucket,sceneId=scene.id},true,true)
  if not result.success then rollback();return fail(result.error) end
  ids[#ids+1]=result.id
 end
 local charged={}
 for item,n in pairs(snapshot.costs)do
  if not Config.Inventory.Enabled or not S.take(src,item,n,true) then
   for previous,amount in pairs(charged)do S.refund(src,previous,amount)end
   rollback();R.dirty();return fail('Returned tape items are required to restore this scene.')
  end
  charged[item]=n
 end
 for i,t in ipairs(snapshot.spans)do
  local newId=ids[i];t.id=newId;t.revision=(t.revision or 0)+1;R.tapes[newId]=t
  R.emit(t.bucket,'apex_policetape:add',R.public(t));TriggerEvent('apex_policetape:placed',newId,src)
 end
 recoveries[id]=nil;R.dirty();S.audit('scene_recover',src,{sceneId=scene.id,count=#ids})
 return {success=true,sceneId=scene.id,count=#ids}
end
function P.handle(src,action,p)
 if not Config.Polish.Enabled and action~='cut' then return fail('Polish features are disabled.') end
 if action=='recover' then return recover(src) end
 if action=='cut' then
  local t=R.tapes[tonumber(p.id)]
  if not R.editable(src,t) then return fail('Move close to tape you can cut.') end
  if not TapeFeaturesServer.checkDeployment(src,'cut',p.ticket) then return fail('Cutting is incomplete or expired.') end
  if not S.take(src,Config.Inventory.CutItem,1,Config.Inventory.ConsumeCutItem) then return fail('Cutting tool missing or inventory transaction failed.') end
  TapeFeaturesServer.completeDeployment(src);P.cutVisual(t,src);R.remove(t.id,src,'cut');return {success=true}
 end
 local scene=R.scenes[tonumber(p.sceneId)]
 if not Config.Polish.Handover or not scene or not R.canUse(src) or (not R.admin(src) and (scene.bucket~=GetPlayerRoutingBucket(src) or not R.owned(scene,src))) then return fail('Only the scene owner or an admin can hand it over.') end
 if type(p.department)=='string' and p.department~='' then
  if not Config.Polish.Departments[p.department] then return fail('Department is not enabled for handover.') end
  scene.department=p.department
 else
  local target=tonumber(p.target)
  if not target or target%1~=0 or not GetPlayerName(target) or not key(target) or not R.canUse(target) or GetPlayerRoutingBucket(target)~=scene.bucket then return fail('Choose an authorised online player in the scene bucket.') end
  local n=0;for _,s in pairs(R.scenes)do if R.owned(s,target) then n=n+1 end end
  if target~=src and n>=Config.Scenes.MaxPerPlayer then return fail('Recipient scene limit reached.') end
  local spans=0;for _,t in pairs(R.tapes)do if R.owned(t,target) or t.sceneId==scene.id then spans=spans+1 end end
  if spans>Config.MaxPerPlayer then return fail('Recipient tape limit reached.') end
  scene.owner=target;scene.license=key(target);scene.department=nil
  for _,t in pairs(R.tapes)do if t.sceneId==scene.id then t.owner=target;t.license=key(target);t.revision=(t.revision or 0)+1;R.emit(t.bucket,'apex_policetape:add',R.public(t)) end end
 end
 R.dirty();S.audit('scene_handover',src,{sceneId=scene.id,target=p.target,department=scene.department})
 return {success=true,sceneId=scene.id}
end
