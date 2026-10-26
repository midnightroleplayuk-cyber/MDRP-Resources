-- Temporary access is owned and timed by the server; clients only animate/render it.
TapeAccessServer={}
local A,M=TapeAccessServer,TapeAccessMath
local function point(p)return {x=p.x,y=p.y,z=p.z}end
local function publish(t)
    t.revision=(t.revision or 0)+1
    TapeRuntime.dirty();TapeRuntime.emit(t.bucket,'apex_policetape:add',TapeRuntime.public(t))
end
function A.holding(src)
    for _,t in pairs(TapeRuntime.tapes) do if t.accessHold and t.accessHold.holder==src then return t end end
end
function A.public(t)
    local h=t.accessHold
    if not h then return nil end
    return {holder=h.holder,fraction=h.fraction,raised=h.raised,phase=h.phase,from=h.from,to=h.to,
        elapsed=math.max(0,GetGameTimer()-h.started),duration=h.duration,released=h.released==true}
end
function A.lower(t,unsafe)
    local h=t.accessHold
    if not h or h.phase=='lowering' then return end
    local amount=M.progress(h.from,h.to,GetGameTimer()-h.started,h.duration)
    h.phase='lowering';h.from=amount;h.to=0;h.started=GetGameTimer()
    h.duration=math.max(100,math.floor(Config.Access.LowerMs*amount));h.released=unsafe==true
    publish(t)
end
function A.clearPlayer(src)
    for _,t in pairs(TapeRuntime.tapes) do if t.accessHold and t.accessHold.holder==src then A.lower(t,true) end end
end
local function safeHolder(t)
    local h=t.accessHold
    local ped=GetPlayerPed(h.holder)
    if ped==0 or GetEntityHealth(ped)<=0 or GetVehiclePedIsIn(ped,false)~=0
        or GetPlayerRoutingBucket(h.holder)~=t.bucket or not TapeRuntime.canUse(h.holder) then return false end
    local pos=GetEntityCoords(ped)
    if TapeGeometry.distance(point(pos),h.origin)>Config.Access.MaxMovement then return false end
    local base=M.lerp(TapeRuntime.liveEnd(t,'a'),TapeRuntime.liveEnd(t,'b'),h.fraction)
    return TapeGeometry.distance(base,h.base)<=Config.Access.MaxAnchorMovement
end
function A.handle(src,action,p)
    local R,cfg=TapeRuntime,Config.Access
    local function fail(error)return {success=false,error=error}end
    if action=='access_open' and TapeEnhanceServer and TapeEnhanceServer.holding(src) then return fail('Drop or reconnect the loose end first.') end
    local t=R.tapes[tonumber(p.id)]
    if not cfg.Enabled or not R.canUse(src) or not t or t.brokenAt or t.bucket~=GetPlayerRoutingBucket(src) then return fail('Access gap unavailable.') end
    local allowed=R.owned(t,src) or R.admin(src) or cfg.AllowAllAuthorized or (cfg.Ace~='' and IsPlayerAceAllowed(src,cfg.Ace))
    local ped=GetPlayerPed(src)
    if not allowed or ped==0 or GetEntityHealth(ped)<=0 or GetVehiclePedIsIn(ped,false)~=0 then return fail('Stand on foot beside tape you may lift.') end
    local pos=point(GetEntityCoords(ped))
    local a,b=R.liveEnd(t,'a'),R.liveEnd(t,'b')
    if R.segmentDistance(pos,a,b)>Config.EditReach then return fail('Move closer to the tape.') end
    if action=='access_close' then
        if t.accessHold and t.accessHold.holder~=src and not R.admin(src) then return fail('Another player is holding this tape.') end
        if t.accessHold then A.lower(t,false) else t.openUntil=nil;t.openedAt=nil;publish(t) end
        return {success=true}
    end
    if t.accessHold then return fail('Someone is already holding this tape.') end
    if A.holding(src) then return fail('You are already holding another span.') end
    local duration=tonumber(p.seconds) or cfg.DurationSeconds
    if not TapeGeometry.finite(duration) or duration<1 or duration>cfg.MaxDurationSeconds then return fail('Invalid gap duration.') end
    local fraction=M.fraction(pos,a,b)
    local margin=math.min(.2,cfg.AnchorInset/math.max(.01,TapeGeometry.distance(a,b)))
    fraction=math.max(margin,math.min(1-margin,fraction))
    local base=M.lerp(a,b,fraction)
    if TapeGeometry.distance(pos,base)>cfg.HoldReach then return fail('Move closer to the ribbon to lift it by hand.') end
    local z=math.min(base.z+cfg.LiftHeight,pos.z+cfg.HandHeight)
    if z<base.z+cfg.MinLift then return fail('This tape is too high to lift safely.') end
    t.openedAt=os.time();t.openUntil=t.openedAt+math.min(math.ceil(cfg.RaiseMs/1000)+math.floor(duration),cfg.MaxHoldSeconds)
    local raised={x=base.x,y=base.y,z=z}
    if cfg.Pose=='one_hand' then
        local dx,dy=base.x-pos.x,base.y-pos.y
        local distance=math.sqrt(dx*dx+dy*dy)
        if distance<.01 then
            dx,dy=-(b.y-a.y),b.x-a.x;distance=math.sqrt(dx*dx+dy*dy)
        end
        if distance>.001 then
            dx,dy=dx/distance,dy/distance
            local side=cfg.GripSide*(cfg.IkArm==3 and -1 or 1)
            raised.x=pos.x+dx*cfg.GripForward+dy*side
            raised.y=pos.y+dy*cfg.GripForward-dx*side
        end
    end
    t.accessHold={holder=src,origin=pos,base=base,fraction=fraction,raised=raised,
        phase='raising',from=0,to=1,started=GetGameTimer(),duration=cfg.RaiseMs}
    publish(t);TapeServices.audit('access_lift',src,{id=t.id})
    return {success=true}
end
function A.tick(t)
    local h=t.accessHold
    if not h then return end
    local now,epoch=GetGameTimer(),os.time()
    if t.brokenAt then t.accessHold=nil;t.openUntil=nil;t.openedAt=nil;publish(t);return end
    if h.phase=='lowering' then
        if now-h.started>=h.duration then t.accessHold=nil;t.openUntil=nil;t.openedAt=nil;publish(t) end
        return
    end
    if not safeHolder(t) then A.lower(t,true);return end
    if h.phase=='raising' and now-h.started>=h.duration then
        h.phase='holding';h.from=1;h.to=1;h.started=now;h.duration=1;publish(t)
    end
    if epoch>=t.openUntil then
        local occupied=false
        if epoch<t.openedAt+Config.Access.MaxHoldSeconds then
            for _,value in ipairs(GetPlayers()) do
                local src=tonumber(value);local ped=GetPlayerPed(src)
                if src~=h.holder and ped~=0 and GetPlayerRoutingBucket(src)==t.bucket
                    and TapeRuntime.segmentDistance(GetEntityCoords(ped),TapeRuntime.liveEnd(t,'a'),TapeRuntime.liveEnd(t,'b'))<Config.Access.OccupancyRadius then occupied=true;break end
            end
        end
        if occupied then t.openUntil=math.min(epoch+Config.Access.OccupancyDelaySeconds,t.openedAt+Config.Access.MaxHoldSeconds)
        else A.lower(t,false) end
    end
end
