-- Visible hand-held access. Server state controls timing; this file only renders/animates.
TapeAccessClient={}
local A,M=TapeAccessClient,TapeAccessMath
local posing,posePed,lowering,requested=nil,nil,false,false
local grips={}
local reachUntil,holdBegan,holdArmed=0,0,false
local function handIK()return Config.Access.Pose=='one_hand' and type(SetIkTarget)=='function' end
local function current()
    if not TapeClient or not Config.Access.Interactive then return nil end
    local mine=GetPlayerServerId(PlayerId())
    for id,t in pairs(TapeClient.tapes()) do
        if t.accessHold and t.accessHold.holder==mine and not t.accessHold.released then return id,t end
    end
end
function A.holding()return current()~=nil end
local function stopPose()
    if posePed and DoesEntityExist(posePed) then StopAnimTask(posePed,Config.Access.AnimDict,Config.Access.AnimName,2.0);if Config.Polish.Enabled then StopAnimTask(posePed,Config.Access.AnimDict,Config.Polish.ReachAnim,2.0) end end
    if TapePolishClient then TapePolishClient.prompt(nil) end
    posing,posePed,lowering,requested=nil,nil,false,false
end
function A.prepare()
    local cfg=Config.Access
    RequestAnimDict(cfg.AnimDict)
    local deadline=GetGameTimer()+cfg.AnimLoadTimeoutMs
    while not HasAnimDictLoaded(cfg.AnimDict) and GetGameTimer()<deadline do Wait(0) end
    return HasAnimDictLoaded(cfg.AnimDict)
end
function A.grip(tape)
    local h=tape.accessHold
    local elapsed=h.elapsed+math.max(0,GetGameTimer()-(tape.accessReceivedAt or GetGameTimer()))
    local raw,amount=M.grip(tape.posA,tape.posB,h,elapsed)
    local base=M.lerp(tape.posA,tape.posB,h.fraction)
    local cache=grips[tape.id]
    if h.phase=='lowering' then
        if cache and cache.phase~='lowering' then cache.lowerFrom=cache.point end
        if cache and cache.lowerFrom then raw=M.lerp(base,cache.lowerFrom,h.from>0 and amount/h.from or 0) end
    elseif not handIK() then
        local player=GetPlayerFromServerId(h.holder)
        if player~=-1 then
            local ped=GetPlayerPed(player)
            if ped~=0 and DoesEntityExist(ped) then
                local offset=Config.Polish.Enabled and Config.Polish.GripOffset or {x=0,y=0,z=0}
                local hand=GetPedBoneCoords(ped,Config.Access.HandBone,offset.x,offset.y,offset.z)
                -- A loading/overridden hands-up pose may still report a waist-level
                -- hand. Keep the raised server grip until the hand is actually up.
                if hand and hand.z>=base.z+Config.Access.MinLift and #(hand-vector3(h.raised.x,h.raised.y,h.raised.z))<=Config.Access.HandFollowDistance then raw=M.lerp(base,hand,amount) end
            end
        end
    end
    local point=vector3(raw.x,raw.y,raw.z)
    grips[tape.id]={point=point,phase=h.phase,lowerFrom=cache and cache.lowerFrom}
    return point,amount
end
CreateThread(function()
    while true do
        local id,t=current()
        if not id then
            if posing then stopPose() end
            if TapeClient then for key in pairs(grips) do if not TapeClient.tapes()[key] or not TapeClient.tapes()[key].accessHold then grips[key]=nil end end end
            Wait(100)
        else
            local cfg,ped,h=Config.Access,PlayerPedId(),t.accessHold
            if posing~=id then
                if posing then stopPose() end
                posing=id;posePed=ped;lowering=false;requested=false;holdBegan=GetGameTimer();holdArmed=false
                reachUntil=GetGameTimer()+(Config.Polish.Enabled and Config.Polish.ReachMs or 0)
                local a,b=TapeClient.liveEnds(t)
                local base=M.lerp(a,b,h.fraction)
                local pos=GetEntityCoords(ped)
                local dx,dy=base.x-pos.x,base.y-pos.y
                if dx*dx+dy*dy<.0001 then dx,dy=-(b.y-a.y),b.x-a.x end
                if dx*dx+dy*dy>.0001 then SetEntityHeading(ped,GetHeadingFromVector_2d(dx,dy)) end
                RequestAnimDict(cfg.AnimDict)
                if Config.Polish.Enabled and HasAnimDictLoaded(cfg.AnimDict) then TaskPlayAnim(ped,cfg.AnimDict,Config.Polish.ReachAnim,3.0,2.0,Config.Polish.ReachMs,49,1.0,false,false,false) end
            end
            if h.phase=='lowering' then
                if not lowering then StopAnimTask(ped,cfg.AnimDict,cfg.AnimName,2.0);lowering=true end
            elseif GetGameTimer()>=reachUntil and HasAnimDictLoaded(cfg.AnimDict) and not IsEntityPlayingAnim(ped,cfg.AnimDict,cfg.AnimName,3) then
                TaskPlayAnim(ped,cfg.AnimDict,cfg.AnimName,3.0,2.0,-1,49,1.0,false,false,false)
            end
            for _,control in ipairs({21,22,23,24,25,30,31,32,33,34,35,36,37,44,45,75,140,141,142,143}) do DisableControlAction(0,control,true) end
            DisablePlayerFiring(PlayerId(),true)
            local keyboard=type(IsUsingKeyboardAndMouse)=='function' and IsUsingKeyboardAndMouse(0) or (type(IsInputDisabled)=='function' and IsInputDisabled(0))
            local cancel=keyboard and 177 or Config.Controller.Cancel
            DisableControlAction(0,cancel,true)
            if not requested and h.phase~='lowering' and (IsDisabledControlJustPressed(0,cancel) or IsControlJustPressed(0,cancel)) then
                requested=true;TapeClient.accessAction('access_close',{id=id})
            end
            local holdMode=Config.Polish.Enabled and ((TapePolishClient and TapePolishClient.liftMode() or Config.Polish.LiftMode)=='hold')
            if holdMode and not requested and h.phase~='lowering' then
                local control=keyboard and Config.Polish.HoldControl or Config.Controller.AccessButton
                DisableControlAction(0,control,true)
                local down=IsDisabledControlPressed(0,control) or IsControlPressed(0,control)
                if down then holdArmed=true end
                if (holdArmed and not down) or (not holdArmed and GetGameTimer()-holdBegan>Config.Polish.HoldGraceMs) then
                    requested=true;TapeClient.accessAction('access_close',{id=id})
                end
            end
            local message=holdMode and h.phase~='lowering' and 'Hold the access key to keep tape raised; release to lower.' or h.phase=='lowering' and 'Lowering tape...' or ('Holding tape up. '..(keyboard and 'Backspace' or Config.Controller.CancelLabel)..': lower.')
            if not (TapePolishClient and TapePolishClient.prompt(message)) then
                BeginTextCommandDisplayHelp('STRING');AddTextComponentSubstringPlayerName(message);EndTextCommandDisplayHelp(0,false,false,-1)
            end
            Wait(0)
        end
    end
end)
AddEventHandler('onResourceStop',function(name)
    if name==GetCurrentResourceName() then stopPose();RemoveAnimDict(Config.Access.AnimDict) end
end)

-- Animation always provides a visible raised-arm base; IK only refines reach.
-- Apply arm IK to local and observed holders. World-space grip is shared with
-- the recording geometry; it does not chase the previous frame's hand bone.
CreateThread(function()
 while true do
  local active=false
  if handIK() and TapeClient then
   for _,t in pairs(TapeClient.tapes()) do
    local h=t.accessHold
    if h and not h.released then
     local player=GetPlayerFromServerId(h.holder)
     if player~=-1 then
      local ped=GetPlayerPed(player)
      if ped~=0 and DoesEntityExist(ped) then
       local a,b=TapeClient.liveEnds(t)
       local elapsed=(h.elapsed or 0)+math.max(0,GetGameTimer()-(t.accessReceivedAt or GetGameTimer()))
       local grip=M.grip(a,b,h,elapsed)
       SetIkTarget(ped,Config.Access.IkArm,0,-1,grip.x+0.0,grip.y+0.0,grip.z+0.0,16,150,250)
       active=true
      end
     end
    end
   end
  end
  Wait(active and 0 or 100)
 end
end)
