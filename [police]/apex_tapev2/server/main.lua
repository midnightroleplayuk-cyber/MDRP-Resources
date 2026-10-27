local tapes, nextId, buckets, rates = {}, 1, {}, {}
local scenes,nextSceneId={},1
local ready, dirty, storageFault = false, false, false
local resource = GetCurrentResourceName()
local repairTimes={}
local function finite(n) return type(n) == 'number' and n == n and n > -math.huge and n < math.huge end
local function point(p)
    if type(p) ~= 'table' or not finite(p.x) or not finite(p.y) or not finite(p.z)
        or math.abs(p.x)>=100000 or math.abs(p.y)>=100000 or math.abs(p.z)>=100000 then return nil end
    return { x = p.x, y = p.y, z = p.z }
end
local function dist(a, b) return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2 + (a.z-b.z)^2) end
local function segmentDistance(p, a, b)
    local x,y,z = b.x-a.x,b.y-a.y,b.z-a.z
    local length = x*x+y*y+z*z
    local t = length > 0 and math.max(0,math.min(1,((p.x-a.x)*x+(p.y-a.y)*y+(p.z-a.z)*z)/length)) or 0
    return dist(p,{x=a.x+x*t,y=a.y+y*t,z=a.z+z*t})
end
local function anchorEntity(id)
    local netId=type(id)=='string' and id:match('^net:(%d+)')
    if not netId or type(NetworkGetEntityFromNetworkId)~='function' then return 0 end
    local entity=NetworkGetEntityFromNetworkId(tonumber(netId))
    return entity and entity~=0 and DoesEntityExist(entity) and entity or 0
end
local function anchorOffset(id,p)
    local entity=anchorEntity(id)
    if entity==0 then return nil end
    local origin=GetEntityCoords(entity)
    local angle=math.rad(GetEntityHeading(entity))
    local dx,dy=p.x-origin.x,p.y-origin.y
    return {x=dx*math.cos(angle)+dy*math.sin(angle),y=-dx*math.sin(angle)+dy*math.cos(angle),z=p.z-origin.z,model=GetEntityModel(entity),entity=entity,vehicle=type(GetEntityType)=='function' and GetEntityType(entity)==2,origin={x=p.x,y=p.y,z=p.z}}
end
local function liveEnd(t,side)
    local offset=t[side..'Local']
    if offset then
        local entity=anchorEntity(t[side=='a' and 'coneAId' or 'coneBId'])
        if entity~=0 and GetEntityModel(entity)==offset.model and GetEntityRoutingBucket(entity)==t.bucket then
            local p=GetEntityCoords(entity)
            local angle=math.rad(GetEntityHeading(entity))
            return {x=p.x+offset.x*math.cos(angle)-offset.y*math.sin(angle),y=p.y+offset.x*math.sin(angle)+offset.y*math.cos(angle),z=p.z+offset.z}
        end
    end
    return t[side]
end
local function license(src) return GetPlayerIdentifierByType(src, 'license') end
local function owned(t, src)
    local id = license(src)
    return id and t.license == id or (not t.license and t.owner == src)
end
local function admin(src) return src == 0 or (TapeBridge and TapeBridge.isStaff(src)) or IsPlayerAceAllowed(src, Config.AdminAce) end
local function canUse(src)
    if TapeBridge then
        if not TapeBridge.canUse(src) then return false end
        if Config.Permissions.StaffBypass and TapeBridge.isStaff(src) then return true end
    end
    local _,departmentAllowed=TapeServices.department(src)
    if not departmentAllowed then return false end
    if Config.RequireAce and not IsPlayerAceAllowed(src, Config.AcePermission) then return false end
    if Config.Jobs.Enabled then
        local ok,job=pcall(TapeServices.job,src,Config.Jobs.Framework)
        if not ok or not job then return false end
        local grade = type(job.grade) == 'table' and job.grade.level or tonumber(job.grade) or 0
        if Config.Jobs.Allowed[job.name] == nil or grade < Config.Jobs.Allowed[job.name] then return false end
    end
    return true
end
local function hasItem(src,requireTape)
    if requireTape~=false and Config.Inventory.Enabled and TapeServices.count(src,Config.Inventory.TapeItem)<1 then return false end
    if Config.RequiredOxItem == '' then return true end
    local ok, count = pcall(function() return exports.ox_inventory:Search(src, 'count', Config.RequiredOxItem) end)
    return ok and type(count) == 'number' and count > 0
end
local function notify(src, text, kind)
    if src == 0 then print('[APEX Tape] ' .. TapeLocale.Render(text))
    else TriggerClientEvent('apex_policetape:notify', src, text, kind or 'inform') end
end
local function rate(src, channel)
    rates[src] = rates[src] or {}
    local now = GetGameTimer()
    local r = rates[src][channel]
    if not r or now < r.at or now-r.at >= Config.RateLimit.Seconds*1000 then
        r = { at = now, count = 0 }; rates[src][channel] = r
    end
    r.count = r.count+1
    return r.count <= Config.RateLimit.Count
end
local function public(t)
    return { id=t.id, a=liveEnd(t,'a'), b=liveEnd(t,'b'), coneAId=t.coneAId, coneBId=t.coneBId,
        aWrap=t.aWrap, bWrap=t.bWrap,aSurface=t.aSurface,bSurface=t.bSurface,contacts=TapeContactServer and TapeContactServer.public(t.id) or {}, style=t.style,customText=t.customText, owner=t.owner,placedBy=t.placedBy,wear=t.wear,carry=t.carry and {holder=t.carry.holder,side=t.carry.side,point=t.carry.point} or nil,looseRemoved=t.looseRemoved,tailDrop=t.tailDrop and {side=t.tailDrop.side,point=t.tailDrop.point,elapsed=math.max(0,GetGameTimer()-t.tailDrop.started),duration=t.tailDrop.duration} or nil,
        postA=t.postA, postB=t.postB, createdAt=t.createdAt, expiresAt=t.expiresAt,
        sceneId=t.sceneId,revision=t.revision or 0,brokenAt=t.brokenAt,breakFraction=t.breakFraction,breakElapsedMs=t.brokenAt and math.max(0,os.time()-t.brokenAt)*1000 or nil,tearFloorA=t.tearFloorA,tearFloorB=t.tearFloorB,restLength=t.restLength,
        accessOpen=t.openUntil~=nil,openUntil=t.openUntil,accessHold=TapeAccessServer and TapeAccessServer.public(t) or nil,detour=t.sceneId and scenes[t.sceneId] and scenes[t.sceneId].detour or nil }
end
local function emit(bucket, event, payload)
    for _, value in ipairs(GetPlayers()) do
        local src = tonumber(value)
        if GetPlayerRoutingBucket(src) == bucket then TriggerClientEvent(event, src, payload) end
    end
end
local function sync(src)
    local bucket, list = GetPlayerRoutingBucket(src), {}
    buckets[src] = bucket
    for _, t in pairs(tapes) do if t.bucket == bucket then list[#list+1] = public(t) end end
    TriggerClientEvent('apex_policetape:sync', src, list)
end
local saveRetryAt,saveFailures=0,0
local function save(force)
    if not Config.Persistence or not dirty or storageFault or (not force and os.time()<saveRetryAt) then return end
    local list = {}
    for _, t in pairs(tapes) do
        -- Network entity IDs are session-local. Persist their last supplied position instead.
        local copy = {}
        for k,v in pairs(t) do copy[k] = v end
        copy.a,copy.b=liveEnd(t,'a'),liveEnd(t,'b')
        copy.aLocal,copy.bLocal=nil,nil
        copy.openUntil,copy.openedAt,copy.accessHold=nil,nil,nil
        copy.tearFloorA,copy.tearFloorB,copy.tearFloorStamp=nil,nil,nil
        copy.carry=nil;copy.tailDrop=nil
        if copy.coneAId:match('^net:') then copy.coneAId = 'saved:'..copy.id..':a' end
        if copy.coneBId:match('^net:') then copy.coneBId = 'saved:'..copy.id..':b' end
        copy.owner = 0
        list[#list+1] = copy
    end
    local encoded = json.encode({ version=3, nextId=nextId, tapes=list, scenes=scenes, nextSceneId=nextSceneId, refunds=TapeServices.Refunds,templates=TapeServices.Templates,nextTemplateId=TapeServices.NextTemplateId })
    if TapeServices.writeStore(encoded) then
        dirty=false;saveRetryAt=0
        if saveFailures>0 then print('[APEX Tape] Storage writes recovered.') end
        saveFailures=0
    else
        saveFailures=saveFailures+1
        local delay=math.min(300,30*2^math.min(saveFailures-1,4))
        saveRetryAt=os.time()+delay
        print(('[APEX Tape] Storage write failed: %s. Unsaved changes retained; retry in %ds.'):format(TapeServices.LastStorageError or 'backup or primary verification failed',delay))
    end
end
local function remove(id,actor,reason)
    local t = tapes[id]
    if not t then return false end
    if actor and Config.Inventory.Enabled and Config.Inventory.RefundOnRemove and owned(t,actor) and t.paidSpool then
        TapeServices.refund(actor,t.paidItem or Config.Inventory.TapeItem,1)
    end
    tapes[id]=nil; dirty=true
    TapeServices.audit('remove',actor or 0,{id=id,sceneId=t.sceneId,reason=reason or 'integration'})
    emit(t.bucket, 'apex_policetape:remove', id)
    TriggerEvent('apex_policetape:removed', id)
    return true
end
local function cleanWrap(v)
    return finite(v) and v >= 0.04 and v <= 0.45 and v or nil
end
local function surface(value)
    local p=point(value)
    if not p then return nil end
    local length=math.sqrt(p.x*p.x+p.y*p.y+p.z*p.z)
    if length<.9 or length>1.1 then return nil end
    return {x=p.x/length,y=p.y/length,z=p.z/length}
end
local function create(src, p, trusted, quiet, reused)
    local function fail(text) return { success=false, error=text } end
    if not trusted and not reused and TapeEnhanceServer and TapeEnhanceServer.holding(src) then return {success=false,error='Drop or reconnect the loose end first.'} end
    if not trusted and TapeAccessServer and TapeAccessServer.holding(src) then return fail('Lower the tape before deploying another span.') end
    if not ready then return fail('Tape storage is still loading.') end
    if storageFault then return fail('Tape storage needs administrator repair; see server console.') end
    if not trusted and (not canUse(src) or not hasItem(src,not reused)) then return fail('Permission or required item missing.') end
    if type(p) ~= 'table' then return fail('Invalid request.') end
    if not trusted and not quiet and not TapeFeaturesServer.checkDeployment(src,'place',p.ticket) then return fail('Deployment is incomplete or expired.') end
    local scene
    if p.sceneId~=nil then
        scene=scenes[tonumber(p.sceneId)]
        if not Config.Scenes.Enabled or not scene or (not trusted and (scene.bucket~=GetPlayerRoutingBucket(src) or (not owned(scene,src) and not admin(src) and not (TapePolishServer and TapePolishServer.departmentAccess(src,scene))))) then return fail('Scene access denied.') end
    end
    local a,b = point(p.a),point(p.b)
    if not a or not b then return fail('Invalid coordinates.') end
    local length = dist(a,b)
    local slack=tonumber(p.slack) or 1
    if not finite(slack) or slack<.98 or slack>1.08 then return fail('Invalid tape tension.') end
    if length < Config.MinLength or length > Config.MaxDistance then return fail('Invalid tape length.') end
    if type(p.style) ~= 'string' or not Config.TapeStyles[p.style] or Config.TapeStyles[p.style].enabled==false then return fail('Unknown tape style.') end
    if not trusted and not TapeServices.styleAllowed(src,p.style) then return fail('This tape design is not available to your department.') end
    local customText,textError
    if reused then customText=reused.customText elseif TapeCustomTextServer then customText,textError=TapeCustomTextServer.forPlacement(src);if textError then return fail(textError) end end
    for _, k in ipairs({'coneAId','coneBId'}) do
        if type(p[k]) ~= 'string' or #p[k] < 1 or #p[k] > 128 then return fail('Invalid anchor.') end
    end
    if trusted and p.bucket ~= nil and (not finite(p.bucket) or p.bucket < 0 or p.bucket % 1 ~= 0) then return fail('Invalid bucket.') end
    local bucket = trusted and (p.bucket or 0) or GetPlayerRoutingBucket(src)
    if scene and scene.bucket~=bucket then return fail('Scene bucket mismatch.') end
    if not trusted then
        local ped = GetPlayerPed(src)
        if ped == 0 or GetEntityHealth(ped) <= 0 then return fail('Player unavailable.') end
        local pos = GetEntityCoords(ped)
        if dist(pos,a) > Config.PlacementReach or dist(pos,b) > Config.PlacementReach then return fail('Move closer to both points.') end
    end
    local total, mine, nearby = 0,0,0
    for _, t in pairs(tapes) do
        total=total+1
        if not trusted and owned(t,src) then mine=mine+1 end
        if t.bucket == bucket then
            if dist(a,t.a) < Config.AreaRadius or dist(a,t.b) < Config.AreaRadius then nearby=nearby+1 end
            if (dist(a,t.a)<0.15 and dist(b,t.b)<0.15) or (dist(a,t.b)<0.15 and dist(b,t.a)<0.15) then return fail('duplicate') end
        end
    end
    local department=TapeServices.department(src)
    local ownerLimit=department and math.min(Config.MaxPerPlayer,department.MaxTapes or Config.MaxPerPlayer) or Config.MaxPerPlayer
    if total >= Config.MaxTapes or nearby >= Config.MaxPerArea or (not trusted and mine >= ownerLimit) then return fail('Tape limit reached.') end
    local paid=false
    if not trusted and not quiet and Config.Inventory.Enabled then
        if not TapeServices.take(src,Config.Inventory.TapeItem,1,Config.Inventory.ConsumeOnPlace) then return fail('Tape item missing or inventory transaction failed.') end
        paid=Config.Inventory.ConsumeOnPlace and Config.Inventory.TapeItem~=''
    end
    local id, now = nextId, os.time(); nextId=nextId+1
    local t = { id=id, a=a,b=b, coneAId=p.coneAId,coneBId=p.coneBId,
        aWrap=cleanWrap(p.aWrap),bWrap=cleanWrap(p.bWrap),aSurface=surface(p.aSurface),bSurface=surface(p.bSurface),style=p.style,customText=customText,
        aLocal=anchorOffset(p.coneAId,a),bLocal=anchorOffset(p.coneBId,b),
        postA=p.postA == true,postB=p.postB == true,placedBy=(type(GetPlayerName)=='function' and tostring(GetPlayerName(src) or ''):gsub('%c',''):sub(1,80) or 'Unknown'),owner=src,license=not trusted and license(src) or nil,
        restLength=length*slack,paidSpool=paid,paidItem=paid and Config.Inventory.TapeItem or nil,
        bucket=bucket,sceneId=scene and scene.id or nil,revision=0,createdAt=now,expiresAt=Config.LifetimeMinutes>0 and now+Config.LifetimeMinutes*60 or nil }
    tapes[id]=t; dirty=true
    if not trusted and not quiet then TapeFeaturesServer.completeDeployment(src) end
    if not quiet then
        emit(bucket,'apex_policetape:add',public(t))
        TriggerEvent('apex_policetape:placed',id,src)
        TapeServices.audit('place',src,{id=id,sceneId=t.sceneId,style=t.style})
    end
    return { success=true,id=id }
end
local function editable(src,t,loose)
    if not t or t.bucket ~= GetPlayerRoutingBucket(src) or not canUse(src) then return false end
    if not owned(t,src) and not admin(src) and not (TapePolishServer and TapePolishServer.departmentAccess(src,scenes[t.sceneId])) then return false end
    local ped = GetPlayerPed(src)
    if ped==0 then return false end
    if loose and t.brokenAt then
        local a,b=liveEnd(t,'a'),liveEnd(t,'b')
        local _,distance=TapeTearMath.nearest(TapeEnhanceMath.paths(t,a,b,Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB),GetEntityCoords(ped))
        return distance<=Config.EditReach
    end
    return segmentDistance(GetEntityCoords(ped),liveEnd(t,'a'),liveEnd(t,'b')) <= Config.EditReach
end
RegisterNetEvent('apex_policetape:create', function(requestId,p)
    local src=source
    if not rate(src,'mutate') then return end
    if type(requestId) ~= 'number' then return end
    TriggerClientEvent('apex_policetape:createResult',src,requestId,create(src,p,false))
end)
RegisterNetEvent('apex_policetape:canUse', function(requestId)
    local src=source
    if type(requestId) == 'number' and rate(src,'query') then
        TriggerClientEvent('apex_policetape:rules',src,TapeServices.rules(src))
        TriggerClientEvent('apex_policetape:canUseResult',src,requestId,ready and not storageFault and canUse(src) and hasItem(src))
    end
end)
RegisterNetEvent('apex_policetape:requestSync',function() if ready and rate(source,'sync') then sync(source) end end)
RegisterNetEvent('apex_policetape:edit',function(id,action,style,ticket)
    local src=source
    if not rate(src,'mutate') then return end
    local t=tapes[tonumber(id)]
    if not editable(src,t) then notify(src,'Move closer to tape you own, or use an admin account.','error'); return end
    if action == 'remove' then
        if not TapeFeaturesServer.checkDeployment(src,'cut',ticket) then notify(src,'Use the cutting interaction.','error');return end
        TapeFeaturesServer.completeDeployment(src)
        if not TapeServices.take(src,Config.Inventory.CutItem,1,Config.Inventory.ConsumeCutItem) then notify(src,'Cutting tool missing or inventory transaction failed.','error');return end
        if TapePolishServer then TapePolishServer.cutVisual(t,src) end
        remove(t.id,src,'cut')
    elseif action == 'style' and not t.brokenAt and TapeServices.styleAllowed(src,style) then
        t.revision=(t.revision or 0)+1
        t.style=style;t.customText=nil; dirty=true; emit(t.bucket,'apex_policetape:add',public(t))
        TapeServices.audit('restyle',src,{id=t.id,style=style})
    else return end
    notify(src,'Tape updated.','success')
end)
local function removeMine(src,ids)
    if not rate(src,'mutate') or not canUse(src) then return end
    local count=0
    local candidates={}
    for id,t in pairs(tapes) do
        if owned(t,src) and t.bucket==GetPlayerRoutingBucket(src) then
            local matches=not ids
            if ids then for _,anchor in ipairs(ids) do if anchor==t.coneAId or anchor==t.coneBId then matches=true end end end
            if matches and (not ids or editable(src,t)) then candidates[#candidates+1]=id end
        end
    end
    if #candidates>0 and not TapeServices.take(src,Config.Inventory.CutItem,Config.Inventory.ConsumeCutItem and #candidates or 1,Config.Inventory.ConsumeCutItem) then notify(src,'Cutting tool missing or inventory transaction failed.','error');return end
    for _,id in ipairs(candidates) do remove(id,src,'owner_cleanup');count=count+1 end
    notify(src,('Removed %d tape spans.'):format(count),'success')
end
RegisterNetEvent('apex_policetape:removeMine',function() removeMine(source) end)
RegisterNetEvent('apex_policetape:removeOnCone',function(id) if type(id)=='string' then removeMine(source,{id}) end end)
RegisterNetEvent('apex_policetape:removeOnAnchors',function(ids)
    if type(ids)=='table' and #ids<=8 then removeMine(source,ids) end
end)
RegisterNetEvent('apex_policetape:undo',function()
    local src=source
    if not rate(src,'mutate') or not canUse(src) then return end
    local latest
    for _,t in pairs(tapes) do if owned(t,src) and t.bucket==GetPlayerRoutingBucket(src) and (not latest or t.id>latest.id) then latest=t end end
    if latest then
        if not TapeServices.take(src,Config.Inventory.CutItem,1,Config.Inventory.ConsumeCutItem) then notify(src,'Cutting tool missing or inventory transaction failed.','error');return end
        remove(latest.id,src,'undo'); notify(src,'Last span undone.','success')
    end
end)
RegisterCommand(TapeCommands.name('cleartapes'),function(src,args)
    if not admin(src) then notify(src,'Admin permission required.','error'); return end
    local all=args[1]=='all'
    local radius=tonumber(args[1]) or 25
    if not all and (radius~=radius or radius<1 or radius>200 or src==0) then notify(src,'Use /cleartapes 1-200, or cleartapes all.'); return end
    local pos=src~=0 and GetEntityCoords(GetPlayerPed(src)) or nil
    local count=0
    for id,t in pairs(tapes) do
        if (src==0 or t.bucket==GetPlayerRoutingBucket(src)) and (all or segmentDistance(pos,t.a,t.b)<=radius) then remove(id,src,'admin_clear');count=count+1 end
    end
    TapeServices.audit('admin_clear',src,{count=count,all=all,radius=radius})
    notify(src,('Cleared %d spans.'):format(count),'success')
end,false)
AddEventHandler('playerDropped',function()
    local src=source
    if Config.RemoveOnDisconnect then for id,t in pairs(tapes) do if t.owner==src or owned(t,src) then remove(id) end end end
    -- Never authorize a new player by a recycled source ID.
    for _,t in pairs(tapes) do if t.owner==src then t.owner=0 end end
    for _,scene in pairs(scenes) do if scene.owner==src then scene.owner=0 end end
    if TapeFeaturesServer then TapeFeaturesServer.clearPlayer(src) end
    repairTimes[src]=nil
    buckets[src]=nil;rates[src]=nil
end)
exports('PlaceTape',function(payload) local r=create(0,payload,true);return r.id,r.error end)
exports('RemoveTape',remove)
exports('GetTapes',function() local list={} for _,t in pairs(tapes) do list[#list+1]=public(t) end return list end)
AddEventHandler('onResourceStop',function(name) if name==resource then dirty=true;save(true) end end)
-- Scene and editing RPCs share the same authority, storage and rate limiter.
local function sceneAccess(src,s)
    return s and ((admin(src)) or (s.bucket==GetPlayerRoutingBucket(src) and (owned(s,src) or (TapePolishServer and TapePolishServer.departmentAccess(src,s))) and canUse(src)))
end
local function sceneList(src,all)
    local list={}
    for _,s in pairs(scenes) do
        if (all and admin(src)) or (s.bucket==GetPlayerRoutingBucket(src) and sceneAccess(src,s)) then
            local count,broken,center=0,0,nil
            for _,t in pairs(tapes) do if t.sceneId==s.id then count=count+1;broken=broken+(t.brokenAt and 1 or 0);center=center or t.a end end
            local ownerSource=0
            for _,value in ipairs(GetPlayers()) do
                local playerId=tonumber(value)
                if owned(s,playerId) then ownerSource=playerId;break end
            end
            list[#list+1]={id=s.id,name=s.name,bucket=s.bucket,createdAt=s.createdAt,expiresAt=s.expiresAt,
                department=s.department,owner=ownerSource,ownerName=ownerSource~=0 and GetPlayerName(ownerSource) or 'Offline',count=count,broken=broken,center=center}
        end
    end
    table.sort(list,function(a,b)return a.id>b.id end)
    while #list>Config.AdminPanel.MaxRows do table.remove(list) end
    return list
end
local function newScene(src,name)
    if not Config.Scenes.Enabled or not canUse(src) then return nil,'Scenes are disabled or access denied.' end
    if type(name)~='string' then return nil,'Enter a scene name.' end
    name=name:gsub('%c',''):match('^%s*(.-)%s*$')
    if #name<1 or #name>Config.Scenes.NameLength then return nil,'Scene name is too long or empty.' end
    local mine,total=0,0
    for _,s in pairs(scenes) do total=total+1;if owned(s,src) then mine=mine+1 end end
    if total>=Config.Scenes.MaxTotal or mine>=Config.Scenes.MaxPerPlayer then return nil,'Scene limit reached.' end
    local id=nextSceneId;nextSceneId=nextSceneId+1
    scenes[id]={id=id,name=name,owner=src,license=license(src),bucket=GetPlayerRoutingBucket(src),createdAt=os.time()}
    dirty=true
    return scenes[id]
end
local function clearScene(id,delete,actor)
    local count=0
    for tapeId,t in pairs(tapes) do if t.sceneId==id then remove(tapeId,actor,delete and 'scene_delete' or 'scene_clear');count=count+1 end end
    if delete then scenes[id]=nil;dirty=true end
    return count
end
local function moveEndpoint(src,p)
    if not Config.Placement.Enabled or type(p)~='table' then return false,'Endpoint tools disabled.' end
    if not TapeFeaturesServer.checkDeployment(src,'move',p.ticket) then return false,'Deployment is incomplete or expired.' end
    local t=tapes[tonumber(p.id)]
    if not editable(src,t) or t.brokenAt then return false,'Move close to an intact span you can edit.' end
    if p.revision~=(t.revision or 0) then return false,'Tape changed. Select it again.' end
    local side=p.side
    if side~='a' and side~='b' then return false,'Invalid endpoint.' end
    local pos=point(p.position)
    if not pos or dist(GetEntityCoords(GetPlayerPed(src)),pos)>Config.EditReach then return false,'New endpoint is out of reach.' end
    local old=liveEnd(t,side)
    if dist(GetEntityCoords(GetPlayerPed(src)),old)>Config.EditReach then return false,'Move closer to the endpoint.' end
    local oldId=t[side=='a' and 'coneAId' or 'coneBId']
    local staged={}
    for id,other in pairs(tapes) do
        local replacements={}
        if id==t.id or (Config.Placement.MoveSharedEndpoints and other.sceneId==t.sceneId and other.bucket==t.bucket) then
            for _,endSide in ipairs({'a','b'}) do
                local anchor=other[endSide=='a' and 'coneAId' or 'coneBId']
                if (id==t.id and side==endSide) or (anchor==oldId and dist(liveEnd(other,endSide),old)<0.15) then replacements[endSide]=true end
            end
        end
        if next(replacements) then
            if not editable(src,other) or other.brokenAt then return false,'A shared span cannot be edited.' end
            local a,b=replacements.a and pos or liveEnd(other,'a'),replacements.b and pos or liveEnd(other,'b')
            if dist(a,b)<Config.MinLength or dist(a,b)>Config.MaxDistance then return false,'A connected span would have an invalid length.' end
            if dist(GetEntityCoords(GetPlayerPed(src)),a)>Config.PlacementReach or dist(GetEntityCoords(GetPlayerPed(src)),b)>Config.PlacementReach then return false,'Connected span is out of reach.' end
            staged[id]={a=a,b=b,replacements=replacements}
        end
    end
    -- Check duplicate geometry and area quotas for the whole proposed graph before committing.
    for id,change in pairs(staged) do
        local nearby=0
        for otherId,other in pairs(tapes) do
            if id~=otherId and other.bucket==t.bucket then
                local candidate=staged[otherId] or other
                if (dist(change.a,candidate.a)<0.15 and dist(change.b,candidate.b)<0.15) or (dist(change.a,candidate.b)<0.15 and dist(change.b,candidate.a)<0.15) then return false,'A span already occupies those points.' end
                if dist(change.a,candidate.a)<Config.AreaRadius or dist(change.a,candidate.b)<Config.AreaRadius then nearby=nearby+1 end
            end
        end
        if nearby>=Config.MaxPerArea then return false,'Area tape limit reached.' end
    end
    local anchor=('world:%.2f:%.2f:%.2f'):format(pos.x,pos.y,pos.z)
    for id,change in pairs(staged) do
        local other=tapes[id]
        for endSide in pairs(change.replacements) do
            other[endSide]=pos
            other[endSide..'Local']=nil
            other[endSide=='a' and 'coneAId' or 'coneBId']=anchor
            other[endSide=='a' and 'aWrap' or 'bWrap']=nil
            other[endSide=='a' and 'aSurface' or 'bSurface']=nil
            other[endSide=='a' and 'postA' or 'postB']=p.post==true
        end
        other.restLength=dist(liveEnd(other,'a'),liveEnd(other,'b'))
        other.revision=(other.revision or 0)+1
        other.editedAt=os.time()
        emit(other.bucket,'apex_policetape:add',public(other))
    end
    TapeFeaturesServer.completeDeployment(src)
    dirty=true
    return true
end
local function perimeter(src,p)
    if type(p)~='table' or not Config.Presets.Enabled then return nil,'Presets disabled.' end
    if not TapeFeaturesServer.checkDeployment(src,'perimeter',p.ticket) then return nil,'Deployment is incomplete or expired.' end
    local spans,err=TapeGeometry.preset(p.kind,p.center,p.heading,p.width,p.length,p.spacing)
    if not spans then return nil,err end
    local scene=scenes[tonumber(p.sceneId)]
    if not scene or scene.bucket~=GetPlayerRoutingBucket(src) or not sceneAccess(src,scene) then return nil,'Select a scene before placing a perimeter.' end
    local oldNext,oldDirty=nextId,dirty
    local ids={}
    for _,span in ipairs(spans) do
        local data={a=span.a,b=span.b,coneAId=('preset:%d:%d'):format(oldNext,span.ai),coneBId=('preset:%d:%d'):format(oldNext,span.bi),postA=true,postB=true,style=p.style,sceneId=scene.id,slack=p.slack}
        local result=create(src,data,false,true)
        if not result.success then
            for _,id in ipairs(ids) do tapes[id]=nil end
            nextId=oldNext;dirty=oldDirty
            return nil,result.error
        end
        ids[#ids+1]=result.id
    end
    if Config.Inventory.Enabled and not TapeServices.take(src,Config.Inventory.TapeItem,#ids,Config.Inventory.ConsumeOnPlace) then
        for _,id in ipairs(ids) do tapes[id]=nil end
        nextId=oldNext;dirty=oldDirty
        return nil,'Tape items missing or inventory transaction failed.'
    end
    for _,id in ipairs(ids) do tapes[id].paidSpool=Config.Inventory.Enabled and Config.Inventory.ConsumeOnPlace and Config.Inventory.TapeItem~='';tapes[id].paidItem=tapes[id].paidSpool and Config.Inventory.TapeItem or nil end
    TapeFeaturesServer.completeDeployment(src)
    TapeServices.audit('perimeter',src,{sceneId=scene.id,count=#ids,kind=p.kind})
    for _,id in ipairs(ids) do emit(scene.bucket,'apex_policetape:add',public(tapes[id]));TriggerEvent('apex_policetape:placed',id,src) end
    return ids
end
RegisterNetEvent('apex_policetape:advanced',function(requestId,action,p)
    local src=source
    if type(requestId)~='number' or not rate(src,action=='target_rules' and 'target_query' or 'advanced') then return end
    local result={success=false,error='Unknown action.'}
    local function fail(err) result={success=false,error=err} end
    p=type(p)=='table' and p or {}
    if not ready or storageFault then fail('Tape storage unavailable.')
    elseif TapeEnhanceServer and TapeEnhanceServer.actions[action] then
        result=TapeEnhanceServer.handle(src,action,p)
    elseif action=='custom_text' and TapeCustomTextServer then
        result=TapeCustomTextServer.handle(src,p)
    elseif TapeFeaturesServer and TapeFeaturesServer.actions[action] then
        result=TapeFeaturesServer.handle(src,action,p)
    elseif action=='repair' then
        local t=tapes[tonumber(p.id)]
        local now=GetGameTimer()
        if not Config.Repair.Enabled or not editable(src,t,true) or not t.brokenAt or t.carry or t.looseRemoved or (TapeEnhanceServer and TapeEnhanceServer.holding(src)) then fail('Move close to torn tape you can repair.')
        elseif p.viaTarget and (not Config.Target.Enabled or not Config.Target.Repair) then fail('Target repair is disabled.')
        elseif GetEntityHealth(GetPlayerPed(src))<=0 or GetVehiclePedIsIn(GetPlayerPed(src),false)~=0 then fail('Stand on foot beside torn tape to repair it.')
        elseif p.revision~=(t.revision or 0) then fail('Tape changed. Select it again.')
        elseif t.expiresAt and t.expiresAt<=os.time() then fail('This tape has expired.')
        elseif Config.RepairInteraction.Enabled and select(2,TapeTearMath.nearest(TapeEnhanceMath.paths(t,liveEnd(t,'a'),liveEnd(t,'b'),Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB),GetEntityCoords(GetPlayerPed(src))))>Config.RepairInteraction.Reach then fail('Move beside the torn tape before repairing.')
        elseif not TapeFeaturesServer.checkDeployment(src,'repair',p.ticket) then fail('Deployment is incomplete or expired.')
        elseif repairTimes[src] and now>=repairTimes[src] and now-repairTimes[src]<Config.Repair.CooldownSeconds*1000 then fail('Wait before repairing more tape.')
        elseif not TapeServices.take(src,Config.Inventory.RepairItem,1,Config.Inventory.ConsumeRepairItem) then fail('Repair item missing or inventory transaction failed.')
        else
            TapeFeaturesServer.completeDeployment(src)
            t.restLength=dist(liveEnd(t,'a'),liveEnd(t,'b'));t.wear=0;t.weatherRestBase=nil
            t.brokenAt=nil;t.breakFraction=nil;t.tearFloorA=nil;t.tearFloorB=nil;t.tearFloorStamp=nil;t.editedAt=os.time();t.revision=(t.revision or 0)+1;repairTimes[src]=now;dirty=true
            emit(t.bucket,'apex_policetape:add',public(t));result={success=true}
            TapeServices.audit('repair',src,{id=t.id})
        end
    elseif action=='refunds' then
        local count=TapeServices.claim(src);if count>0 then dirty=true end
        result={success=true,count=count}
    elseif action=='assign' then
        local t=tapes[tonumber(p.id)]
        local s=scenes[tonumber(p.sceneId)]
        if not Config.Scenes.Enabled or not editable(src,t) or not sceneAccess(src,s) or s.bucket~=t.bucket then fail('Move close to tape you can edit and select a scene in this bucket.')
        else t.sceneId=s.id;t.revision=(t.revision or 0)+1;dirty=true;emit(t.bucket,'apex_policetape:add',public(t));result={success=true} end
    elseif action=='list' then
        if p.admin and (not Config.AdminPanel.Enabled or not admin(src)) then fail('Admin access required.')
        else result={success=true,scenes=sceneList(src,p.admin==true),admin=admin(src),rules=TapeServices.rules(src)} end
    elseif action=='new' then
        local scene,err=newScene(src,p.name)
        if scene then result={success=true,sceneId=scene.id} else fail(err) end
    elseif action=='move' then
        local ok,err=moveEndpoint(src,p);result={success=ok,error=err}
    elseif action=='perimeter' then
        local ids,err=perimeter(src,p);result={success=ids~=nil,ids=ids,error=err}
    elseif Config.Scenes.Enabled then
        local s=scenes[tonumber(p.sceneId)]
        if not sceneAccess(src,s) then fail('Scene unavailable or access denied.')
        elseif action=='select' then
            if s.bucket~=GetPlayerRoutingBucket(src) then fail('Scene is in another bucket.') else result={success=true,sceneId=s.id} end
        elseif action=='clear' or action=='delete' then
            local count=0 for _,t in pairs(tapes) do if t.sceneId==s.id then count=count+1 end end
            if count>0 and not admin(src) and not TapeServices.take(src,Config.Inventory.CutItem,Config.Inventory.ConsumeCutItem and count or 1,Config.Inventory.ConsumeCutItem) then fail('Cutting tool missing or inventory transaction failed.')
            else
                if TapePolishServer then TapePolishServer.capture(src,s) end
                result={success=true,count=clearScene(s.id,action=='delete',src)}
            end
        elseif action=='rename' then
            local name=type(p.name)=='string' and p.name:gsub('%c',''):match('^%s*(.-)%s*$') or ''
            if #name<1 or #name>Config.Scenes.NameLength then fail('Invalid scene name.') else s.name=name;dirty=true;result={success=true} end
        elseif action=='style' then
            if not TapeServices.styleAllowed(src,p.style) then fail('Invalid design.')
            else
                for _,t in pairs(tapes) do if t.sceneId==s.id and not t.brokenAt then t.style=p.style;t.customText=nil;t.revision=(t.revision or 0)+1;emit(t.bucket,'apex_policetape:add',public(t)) end end
                dirty=true;result={success=true}
            end
        elseif action=='expiry' then
            if not finite(p.minutes) or p.minutes<0 or p.minutes>10080 then fail('Expiry must be 0–10080 minutes.')
            else s.expiresAt=p.minutes>0 and os.time()+math.floor(p.minutes*60) or nil;dirty=true;result={success=true} end
        end
    end
    if result.success and action~='list' and action~='select' then TapeServices.audit('scene_'..tostring(action),src,{sceneId=tonumber(p.sceneId),id=tonumber(p.id),templateId=tonumber(p.templateId),count=result.count}) end
    TriggerClientEvent('apex_policetape:advancedResult',src,requestId,result)
end)

-- Server-only swept collision: clients cannot request destruction. Each sample
-- is an actual replicated player vehicle; adjacent samples catch fast crossings.

CreateThread(function()
    local expiredScenes={}
    if not TapeServices.startup() then storageFault=true;return end
    if Config.Persistence then
        local raw=TapeServices.readStore()
        if raw and raw~='' then
            local ok,data=pcall(json.decode,raw)
            if not ok or not TapeServices.validStore(raw) then
                storageFault=true
                print('[APEX Tape] Invalid data/tapes.json. File preserved. Back it up and repair it before placing tape.')
            else
                TapeServices.Refunds=type(data.refunds)=='table' and data.refunds or {}
                TapeServices.Templates={}
                for _,template in pairs(data.templates or {}) do template.owner=0;TapeServices.Templates[template.id]=template;TapeServices.NextTemplateId=math.max(TapeServices.NextTemplateId,template.id+1) end
                TapeServices.NextTemplateId=math.max(TapeServices.NextTemplateId,tonumber(data.nextTemplateId) or 1)
                if data.version==2 then dirty=true end
                if type(data.scenes)=='table' then
                    for _,scene in pairs(data.scenes) do
                        if type(scene)=='table' and finite(scene.id) and type(scene.name)=='string' and finite(scene.bucket) then
                            scene.owner=0
                            if not scene.expiresAt or (finite(scene.expiresAt) and scene.expiresAt>os.time()) then scenes[scene.id]=scene else expiredScenes[scene.id]=true end
                            nextSceneId=math.max(nextSceneId,scene.id+1)
                        end
                    end
                end
                if finite(data.nextSceneId) then nextSceneId=math.max(nextSceneId,data.nextSceneId) end
                if finite(data.nextId) and data.nextId >= 1 and data.nextId % 1 == 0 then nextId=data.nextId end
                for _,t in ipairs(data.tapes) do
                    if type(t)=='table' and finite(t.id) and point(t.a) and point(t.b)
                        and type(t.coneAId)=='string' and type(t.coneBId)=='string'
                        and finite(t.bucket) and (not t.expiresAt or finite(t.expiresAt)) then
                        if (not t.expiresAt or t.expiresAt>os.time()) and not expiredScenes[t.sceneId] then
                            t.owner=0
                            t.openUntil=nil;t.openedAt=nil;t.accessHold=nil;t.carry=nil;t.tailDrop=nil
                            t.restLength=t.restLength or dist(t.a,t.b)
                            if t.sceneId and not scenes[t.sceneId] then t.sceneId=nil end
                            if not Config.TapeStyles[t.style] then t.style='police' end
                            tapes[t.id]=t; nextId=math.max(nextId,t.id+1)
                        end
                    end
                end
            end
        end
    end
    ready=true
    for _,src in ipairs(GetPlayers()) do sync(tonumber(src)) end
    while true do
        Wait(math.max(250,Config.Performance.BucketRefreshMs))
        for id,scene in pairs(scenes) do if scene.expiresAt and scene.expiresAt<=os.time() then clearScene(id,true) end end
        for id,t in pairs(tapes) do
            for _,side in ipairs({'a','b'}) do
                if t[side..'Local'] then
                    local current=liveEnd(t,side)
                    if dist(current,t[side])>0.01 then t[side]=current;dirty=true end
                end
            end
            if (t.expiresAt and t.expiresAt<=os.time()) or (t.brokenAt and Config.Breakaway.BrokenLifetimeSeconds>0 and os.time()-t.brokenAt>=Config.Breakaway.BrokenLifetimeSeconds) then remove(id) end
        end
        for _,value in ipairs(GetPlayers()) do local src=tonumber(value); if buckets[src]~=GetPlayerRoutingBucket(src) then sync(src) end end
        if Config.Backups.Enabled and os.time()-TapeServices.LastBackup>=Config.Backups.IntervalSeconds then dirty=true end
        save()
    end
end)

local vehicleSamples={}
CreateThread(function()
    while true do
        Wait(math.max(50,Config.Breakaway.SampleMs))
        if Config.Breakaway.Enabled and ready then
            local seen={}
            for _,value in ipairs(GetPlayers()) do
                local src=tonumber(value)
                local ped=GetPlayerPed(src)
                local vehicle=ped~=0 and GetVehiclePedIsIn(ped,false) or 0
                if vehicle~=0 and GetPedInVehicleSeat(vehicle,-1)==ped then
                    seen[src]=true
                    local v=GetEntityCoords(vehicle)
                    local current={x=v.x,y=v.y,z=v.z}
                    local velocity=GetEntityVelocity(vehicle)
                    local speed=math.sqrt(velocity.x^2+velocity.y^2+velocity.z^2)
                    local now,bucket=GetGameTimer(),GetPlayerRoutingBucket(src)
                    local old=vehicleSamples[src]
                    local cfg=Config.Breakaway
                    local profile=TapeServices.vehicleProfile(vehicle)
                    if profile and old and old.vehicle==vehicle and old.bucket==bucket then
                        local gap=now-old.at
                        local distance=dist(old.position,current)
                        -- Reject stale samples and teleport-sized jumps, rather than sweeping across a city.
                        if gap>0 and gap<=cfg.MaxSampleGapMs and distance<=cfg.MaxSweepDistance
                            and distance<=math.max(speed,old.speed)*(gap/1000)+profile.Radius*2
                            and math.max(speed,old.speed)*3.6>=profile.MinSpeedKmh then
                            for id,t in pairs(tapes) do
                                local a,b=liveEnd(t,'a'),liveEnd(t,'b')
                                if not t.brokenAt and not t.openUntil and t.bucket==bucket and os.time()-(t.editedAt or t.createdAt)>=cfg.SpawnGraceSeconds
                                    and segmentDistance(current,a,b)<=cfg.ScanDistance then
                                    local hit,fraction=TapeGeometry.sweepHit(old.position,current,a,b,profile.Radius,profile.MinZ,profile.MaxZ)
                                    if hit then
                                        if cfg.RemoveImmediately then remove(id,nil,'tear')
                                        else
                                            t.tearFloorA=nil;t.tearFloorB=nil;t.tearFloorStamp=nil;t.brokenAt=os.time();t.breakFraction=math.max(0.1,math.min(0.9,fraction));t.revision=(t.revision or 0)+1;dirty=true
                                            emit(t.bucket,'apex_policetape:add',public(t))
                                        end
                                        TriggerEvent('apex_policetape:torn',id,src,math.max(speed,old.speed)*3.6)
                                        TapeServices.audit('tear',src,{id=id,speed=math.max(speed,old.speed)*3.6})
                                    end
                                end
                            end
                        end
                    end
                    vehicleSamples[src]={vehicle=vehicle,bucket=bucket,position=current,speed=speed,at=now}
                end
            end
            for src in pairs(vehicleSamples) do if not seen[src] then vehicleSamples[src]=nil end end
        else vehicleSamples={} end
    end
end)

-- Internal cross-file API; no network handler exposes trusted mutations directly.
TapeRuntime={tapes=tapes,scenes=scenes,canUse=canUse,owned=owned,admin=admin,editable=editable,
    sceneAccess=sceneAccess,newScene=newScene,liveEnd=liveEnd,anchorEntity=anchorEntity,segmentDistance=segmentDistance,
    public=public,emit=emit,create=create,remove=remove,moveEndpoint=moveEndpoint,
    dirty=function()dirty=true end,
    ready=function()return ready and not storageFault end,
    checkpoint=function()return {nextId=nextId,nextSceneId=nextSceneId,dirty=dirty}end,
    rollback=function(checkpoint,ids,sceneId)
        for _,id in ipairs(ids) do tapes[id]=nil end
        if sceneId then scenes[sceneId]=nil end
        nextId=checkpoint.nextId;nextSceneId=checkpoint.nextSceneId;dirty=checkpoint.dirty
    end,
}
-- Allow a player to share bounded APEX client state without logging arbitrary text.
RegisterNetEvent('apex_policetape:diagnostic',function(report)
    local src=source
    if type(report)~='table' or not rate(src,'diagnostic') then return end
    local safe={source=src,serverVersion=Config.Version,serverBuild=Config.Build,allowed=canUse(src),contacts=TapeContactServer and TapeContactServer.diagnostics and TapeContactServer.diagnostics() or nil}
    safe.clientBuild=type(report.build)=='string' and report.build:match('^[%w.%-]+$') and report.build:sub(1,80) or 'unknown'
    for _,key in ipairs({'active','blocked','focus','menu','scenePanel','hit','ground','firstPoint','ready','embedded','drawNative'}) do safe[key]=report[key]==true end
    for _,key in ipairs({'tapes','textures','failed'}) do local n=tonumber(report[key]);safe[key]=n and n==n and math.max(0,math.min(10000,math.floor(n))) or 0 end
    safe.clientVersion=type(report.version)=='string' and report.version:match('^%d+%.%d+%.%d+$') or 'unknown'
    safe.mode=report.mode=='aim' and 'aim' or 'anchors'
    local missing={}
    for _,style in pairs(Config.TapeStyles) do
        local raw=style.image and LoadResourceFile(resource,style.image)
        if not raw or raw:sub(1,8)~='\137PNG\r\n\26\n' then missing[#missing+1]=style.label end
    end
    safe.missingServerImages=#missing
    print('[APEX Tape diagnostic] '..json.encode(safe))
    if #missing>0 then print('[APEX Tape diagnostic] Missing/invalid PNGs: '..table.concat(missing,', ')) end
end)
