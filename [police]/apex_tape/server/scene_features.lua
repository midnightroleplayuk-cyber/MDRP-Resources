TapeFeaturesServer={actions={target_rules=true,target_remove=true,deploy_begin=true,deploy_cancel=true,access_open=true,access_close=true,template_save=true,template_list=true,template_get=true,template_delete=true,template_place=true,detour_add=true,detour_clear=true,cut=true,handover=true,recover=true}}
local F=TapeFeaturesServer
local S=TapeServices
local G=TapeGeometry
local tickets,safety,strained={},{},{}
local serial=0
local function fail(message)return {success=false,error=message}end
function F.duration(operation)
    if operation=='cut' then return Config.Cutting.DurationMs end
    if operation=='repair' and Config.RepairInteraction.Enabled then return Config.RepairInteraction.DurationMs end
    return Config.Deployment.DurationMs
end
local function enabledOperation(operation)
    if operation=='cut' then return Config.Cutting.Enabled end
    return Config.Deployment.Enabled and (operation=='place' or operation=='perimeter' or operation=='template_place' or (operation=='repair' and Config.Deployment.ApplyToRepair) or (operation=='move' and Config.Deployment.ApplyToMove))
end
function F.checkDeployment(src,operation,token)
    if not enabledOperation(operation) then return true end
    local ticket=tickets[src]
    local now=GetGameTimer()
    if not ticket or ticket.token~=token or ticket.operation~=operation or now<ticket.at or now-ticket.at<F.duration(operation) or now-ticket.at>Config.Deployment.TicketLifetimeMs then return false end
    local ped=GetPlayerPed(src)
    return ped~=0 and GetEntityHealth(ped)>0 and GetVehiclePedIsIn(ped,false)==0 and G.distance(GetEntityCoords(ped),ticket.start)<=Config.Deployment.MaxMovement
end
function F.completeDeployment(src) tickets[src]=nil end
function F.clearPlayer(src) tickets[src]=nil;if TapeAccessServer then TapeAccessServer.clearPlayer(src) end end
local function canTemplate(src,t)
    return t and TapeRuntime.canUse(src) and (TapeRuntime.owned(t,src) or TapeRuntime.admin(src) or Config.Templates.Shared)
end
local function publish(t)
    t.revision=(t.revision or 0)+1
    TapeRuntime.dirty()
    TapeRuntime.emit(t.bucket,'apex_policetape:add',TapeRuntime.public(t))
end
local function tear(t,reason)
    if t.brokenAt then return end
    t.openUntil=nil;t.openedAt=nil;t.accessHold=nil
    if Config.Breakaway.RemoveImmediately then TapeRuntime.remove(t.id,nil,reason)
    else local released=TapeEnhanceServer and TapeEnhanceServer.anchorImpact(t,0,reason);t.brokenAt=os.time();t.breakFraction=released and released.fraction or 0.5;publish(t) end
    S.audit(reason,0,{id=t.id})
    TriggerEvent('apex_policetape:strained',t.id,reason)
end
local function batch(src,spans,sceneId,ticket,slack)
    if not F.checkDeployment(src,'template_place',ticket) then return fail('Deployment is incomplete or expired.') end
    local checkpoint=TapeRuntime.checkpoint()
    local createdScene=false
    if not sceneId then
        local scene,err=TapeRuntime.newScene(src,'Template cordon')
        if not scene then return fail(err) end
        sceneId=scene.id;createdScene=true
    end
    local scene=TapeRuntime.scenes[sceneId]
    if not scene or not TapeRuntime.sceneAccess(src,scene) or scene.bucket~=GetPlayerRoutingBucket(src) then return fail('Scene access denied.') end
    local ids={}
    for i,span in ipairs(spans) do
        local data={a=span.a,b=span.b,style=span.style,postA=span.postA,postB=span.postB,sceneId=sceneId,slack=slack,
            coneAId=('template:%.3f:%.3f:%.3f'):format(span.a.x,span.a.y,span.a.z),coneBId=('template:%.3f:%.3f:%.3f'):format(span.b.x,span.b.y,span.b.z)}
        local result=TapeRuntime.create(src,data,false,true)
        if not result.success then TapeRuntime.rollback(checkpoint,ids,createdScene and sceneId);return fail(result.error) end
        ids[#ids+1]=result.id
    end
    if Config.Inventory.Enabled and not S.take(src,Config.Inventory.TapeItem,#ids,Config.Inventory.ConsumeOnPlace) then TapeRuntime.rollback(checkpoint,ids,createdScene and sceneId);return fail('Tape items missing or inventory transaction failed.') end
    F.completeDeployment(src)
    for _,id in ipairs(ids) do
        local t=TapeRuntime.tapes[id]
        t.paidSpool=Config.Inventory.Enabled and Config.Inventory.ConsumeOnPlace;t.paidItem=t.paidSpool and Config.Inventory.TapeItem or nil
        TapeRuntime.emit(t.bucket,'apex_policetape:add',TapeRuntime.public(t));TriggerEvent('apex_policetape:placed',id,src)
    end
    return {success=true,sceneId=sceneId,count=#ids}
end
function F.handle(src,action,p)
    local R=TapeRuntime
    if action=='handover' or action=='recover' or action=='cut' then return TapePolishServer.handle(src,action,p) end
    if action=='target_rules' or action=='target_remove' then return TapeTargetServer.handle(src,action,p) end
    if action=='deploy_cancel' then tickets[src]=nil;return {success=true} end
    if action=='deploy_begin' then
        if TapeAccessServer and TapeAccessServer.holding(src) then return fail('Lower the tape before deploying equipment.') end
        if not enabledOperation(p.operation) then return {success=true,disabled=true} end
        local ped=GetPlayerPed(src)
        if not R.canUse(src) or ped==0 or GetEntityHealth(ped)<=0 or GetVehiclePedIsIn(ped,false)~=0 then return fail('Deployment requires authorised on-foot access.') end
        local pos=GetEntityCoords(ped)
        if p.position and (not G.point(p.position) or G.distance(pos,p.position)>Config.PlacementReach) then return fail('Deployment point is out of reach.') end
        serial=serial+1
        local token=('%d:%d'):format(src,serial)
        tickets[src]={token=token,operation=p.operation,at=GetGameTimer(),start={x=pos.x,y=pos.y,z=pos.z}}
        return {success=true,ticket=token,duration=F.duration(p.operation)}
    end
    if action=='access_open' or action=='access_close' then
        if Config.Access.Interactive and TapeAccessServer then return TapeAccessServer.handle(src,action,p) end
        if not Config.Access.Enabled or not R.canUse(src) then return fail('Access gaps are unavailable.') end
        local t=R.tapes[tonumber(p.id)]
        local allowed=t and (R.owned(t,src) or R.admin(src) or Config.Access.AllowAllAuthorized or (Config.Access.Ace~='' and IsPlayerAceAllowed(src,Config.Access.Ace)))
        if not allowed or t.bucket~=GetPlayerRoutingBucket(src) or t.brokenAt or GetPlayerPed(src)==0 or R.segmentDistance(GetEntityCoords(GetPlayerPed(src)),R.liveEnd(t,'a'),R.liveEnd(t,'b'))>Config.EditReach then return fail('Move close to an intact span you may open.') end
        if action=='access_close' then t.openUntil=nil;t.openedAt=nil;t.accessHold=nil
        else
            local duration=tonumber(p.seconds) or Config.Access.DurationSeconds
            if not G.finite(duration) or duration<1 or duration>Config.Access.MaxDurationSeconds then return fail('Invalid gap duration.') end
            if not t.openUntil then t.openedAt=os.time() end
            t.openUntil=math.min(os.time()+math.floor(duration),(t.openedAt or os.time())+Config.Access.MaxHoldSeconds)
        end
        publish(t);S.audit(action,src,{id=t.id});return {success=true}
    end
    if action=='detour_add' or action=='detour_clear' then
        if not Config.Traffic.Enabled then return fail('Traffic diversion is disabled.') end
        local scene=R.scenes[tonumber(p.sceneId)]
        if not scene or scene.bucket~=GetPlayerRoutingBucket(src) or not R.sceneAccess(src,scene) then return fail('Scene access denied.') end
        if action=='detour_clear' then scene.detour=nil
        else
            local ped=GetPlayerPed(src)
            if ped==0 then return fail('Player unavailable.') end
            local coord=GetEntityCoords(ped)
            local point={x=coord.x,y=coord.y,z=coord.z}
            local center
            for _,t in pairs(R.tapes) do if t.sceneId==scene.id then center=R.liveEnd(t,'a');break end end
            if not center or G.distance(center,point)>Config.Traffic.MaxRouteDistance then return fail('Detour waypoint is too far from the scene.') end
            scene.detour=scene.detour or {}
            if #scene.detour>=Config.Traffic.MaxWaypoints then return fail('Detour waypoint limit reached.') end
            scene.detour[#scene.detour+1]=point
        end
        for _,t in pairs(R.tapes) do if t.sceneId==scene.id then R.emit(t.bucket,'apex_policetape:add',R.public(t)) end end
        R.dirty();S.audit(action,src,{sceneId=scene.id});return {success=true,count=scene.detour and #scene.detour or 0}
    end
    if not Config.Templates.Enabled or not R.canUse(src) then return fail('Scene templates are unavailable.') end
    if action=='template_list' then
        local list={}
        for _,t in pairs(S.Templates) do if canTemplate(src,t) then list[#list+1]={id=t.id,name=t.name,count=#t.spans} end end
        table.sort(list,function(a,b)return a.id<b.id end)
        return {success=true,templates=list}
    elseif action=='template_save' then
        local scene=R.scenes[tonumber(p.sceneId)]
        if not scene or not R.sceneAccess(src,scene) or scene.bucket~=GetPlayerRoutingBucket(src) then return fail('Select a scene in this bucket first.') end
        local name=type(p.name)=='string' and p.name:gsub('%c',''):match('^%s*(.-)%s*$') or ''
        if #name<1 or #name>Config.Scenes.NameLength then return fail('Invalid template name.') end
        local spans={}
        for _,t in pairs(R.tapes) do if t.sceneId==scene.id and not t.brokenAt then spans[#spans+1]={a=R.liveEnd(t,'a'),b=R.liveEnd(t,'b'),style=t.style,postA=t.postA,postB=t.postB} end end
        local relative,err=TapeSceneTools.capture(spans,tonumber(p.heading) or 0)
        if not relative then return fail(err) end
        local existing,total,mine=nil,0,0
        for _,t in pairs(S.Templates) do total=total+1;if R.owned(t,src) then mine=mine+1;if t.name==name then existing=t end end end
        if not existing and (total>=Config.Templates.MaxTotal or mine>=Config.Templates.MaxPerPlayer) then return fail('Template limit reached.') end
        local id=existing and existing.id or S.NextTemplateId
        if not existing then S.NextTemplateId=S.NextTemplateId+1 end
        S.Templates[id]={id=id,name=name,owner=src,license=GetPlayerIdentifierByType(src,'license'),spans=relative,createdAt=os.time()}
        R.dirty();S.audit(action,src,{id=id,count=#relative});return {success=true,templateId=id}
    end
    local template=S.Templates[tonumber(p.templateId)]
    if not canTemplate(src,template) then return fail('Template unavailable or access denied.') end
    if action=='template_get' then return {success=true,template={id=template.id,name=template.name,spans=template.spans}} end
    if action=='template_delete' then
        if not R.owned(template,src) and not R.admin(src) then return fail('Only the owner or an admin may delete a template.') end
        S.Templates[template.id]=nil;R.dirty();return {success=true}
    end
    if action=='template_place' then
        if not G.point(p.center) or not G.finite(p.heading) then return fail('Invalid template placement.') end
        if #template.spans>Config.Templates.MaxSpans then return fail('Template exceeds the configured span limit.') end
        local spans=TapeSceneTools.transform(template.spans,p.center,p.heading)
        return batch(src,spans,tonumber(p.sceneId),p.ticket,p.slack)
    end
    return fail('Unknown template action.')
end
function F.tick()
    local R=TapeRuntime
    if not R or not R.ready() then return end
    local now,epoch=GetGameTimer(),os.time()
    local seen={}
    for id,t in pairs(R.tapes) do
        seen[id]=true
        if TapeAccessServer and t.accessHold then TapeAccessServer.tick(t) end
        if t.openUntil and not t.accessHold and epoch>=t.openUntil then
            local occupied=false
            if epoch<(t.openedAt or epoch)+Config.Access.MaxHoldSeconds then
                for _,value in ipairs(GetPlayers()) do
                    local src=tonumber(value)
                    local ped=GetPlayerPed(src)
                    if ped~=0 and GetPlayerRoutingBucket(src)==t.bucket and R.segmentDistance(GetEntityCoords(ped),R.liveEnd(t,'a'),R.liveEnd(t,'b'))<Config.Access.OccupancyRadius then occupied=true;break end
                end
            end
            if occupied then t.openUntil=math.min(epoch+Config.Access.OccupancyDelaySeconds,(t.openedAt or epoch)+Config.Access.MaxHoldSeconds)
            else t.openUntil=nil;t.openedAt=nil;t.accessHold=nil;publish(t) end
        end
        if Config.Attachments.Enabled then
            safety[id]=safety[id] or {}
            for _,side in ipairs({'a','b'}) do
                local offset=t[side..'Local']
                if offset then
                    local record=safety[id][side] or {last=t[side]};safety[id][side]=record
                    local entity=R.anchorEntity(t[side=='a' and 'coneAId' or 'coneBId'])
                    local invalid=entity==0 or GetEntityModel(entity)~=offset.model or (offset.entity and offset.entity~=entity) or (entity~=0 and GetEntityRoutingBucket(entity)~=t.bucket)
                    local live=R.liveEnd(t,side)
                    local reason
                    if invalid then
                        record.missing=record.missing or now
                        if now<record.missing or now-record.missing>=Config.Attachments.MissingGraceMs then reason='anchor_missing' end
                    else
                        record.missing=nil
                        local velocity=GetEntityVelocity(entity)
                        local speed=math.sqrt(velocity.x^2+velocity.y^2+velocity.z^2)*3.6
                        if offset.origin and G.distance(live,offset.origin)>Config.Attachments.MaxAnchorTravel then reason='anchor_travel' end
                        if offset.vehicle and speed>Config.Attachments.MaxVehicleSpeedKmh then reason='anchor_speed' end
                        if not reason then record.last=live end
                    end
                    if reason then
                        t[side]=record.last;t[side..'Local']=nil
                        t[side=='a' and 'coneAId' or 'coneBId']=('safe:%d:%s'):format(id,side)
                        t[side=='a' and 'aWrap' or 'bWrap']=nil
                        publish(t)
                        if Config.Attachments.OnUnsafe=='tear' then tear(t,reason) end
                        S.audit(reason,0,{id=id,side=side});TriggerEvent('apex_policetape:anchorDetached',id,side,reason)
                    end
                end
            end
        end
        if Config.Tension.Enabled and Config.Tension.BreakEnabled and not t.brokenAt and not t.openUntil then
            local length=G.distance(R.liveEnd(t,'a'),R.liveEnd(t,'b'))
            local rest=t.restLength or G.distance(t.a,t.b)
            if epoch-(t.editedAt or t.createdAt)>=Config.Breakaway.SpawnGraceSeconds and rest>0 and length/rest>Config.Tension.MaxStretch then
                strained[id]=strained[id] or now
                if now>=strained[id] and now-strained[id]>=Config.Tension.BreakDelayMs then tear(t,'tension_tear');strained[id]=nil end
            else strained[id]=nil end
        end
    end
    for id in pairs(safety) do if not seen[id] then safety[id]=nil end end
    for id in pairs(strained) do if not seen[id] then strained[id]=nil end end
    for src,ticket in pairs(tickets) do if now<ticket.at or now-ticket.at>Config.Deployment.TicketLifetimeMs then tickets[src]=nil end end
end
CreateThread(function()while true do Wait(math.max(50,Config.Attachments.CheckMs));F.tick() end end)
