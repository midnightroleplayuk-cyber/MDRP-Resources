local objects={}
HF1TVPlacedEntities = HF1TVPlacedEntities or {}
local placing=false
local function notify(msg,kind) lib.notify({title='HF1 TV',description=msg,type=kind or 'inform'}) end
local function clearObject(id)
    local e=objects[id]
    if e then
        if DoesEntityExist(e) then
            exports.ox_target:removeLocalEntity(e,{'hf1_tv_placed_interact_'..id,'hf1_tv_placed_pickup_'..id})
            HF1TVPlacedEntities[e]=nil
            DeleteEntity(e)
        end
        objects[id]=nil
    end
end
local function spawnObject(tv)
    if objects[tv.id] and DoesEntityExist(objects[tv.id]) then return end
    local model=joaat(tv.model)
    if not IsModelInCdimage(model) then print('[hf1_tv] Saved TV invalid model: '..tostring(tv.model)) return end
    RequestModel(model)
    local limit=GetGameTimer()+5000
    while not HasModelLoaded(model) and GetGameTimer()<limit do Wait(0) end
    if not HasModelLoaded(model) then print('[hf1_tv] Saved TV model load timed out: '..tostring(tv.model)) return end
    local p=tv.coords
    local e=CreateObjectNoOffset(model,p.x,p.y,p.z,false,false,false)
    if e==0 then print('[hf1_tv] Saved TV CreateObject failed: '..tostring(tv.model)) return end
    SetEntityHeading(e,tv.heading)
    FreezeEntityPosition(e,true)
    SetEntityInvincible(e,true)
    objects[tv.id]=e
    HF1TVPlacedEntities[e]=true
    SetModelAsNoLongerNeeded(model)
    exports.ox_target:addLocalEntity(e,{
        {name='hf1_tv_placed_interact_'..tv.id,icon='fa-solid fa-tv',label='Interact',distance=Config.InteractDistance,
         onSelect=function(data) TriggerEvent('hf1_tv:openPlacedMenu',data.entity) end},
        {name='hf1_tv_placed_pickup_'..tv.id,icon='fa-solid fa-box',label='Pickup TV',distance=2.5,
         onSelect=function() TriggerServerEvent('hf1_tv:pickup',tv.id) end}
    })
end
RegisterNetEvent('hf1_tv:placedSnapshot',function(data)
    local seen={}
    for k,tv in pairs(data or {}) do
        local id=tonumber(k)
        if id and tv and tv.coords then
            tv.id=id
            seen[id]=true
            if not objects[id] or not DoesEntityExist(objects[id]) then CreateThread(function() spawnObject(tv) end) end
        end
    end
    for id in pairs(objects) do if not seen[id] then clearObject(id) end end
end)
-- Explicit confirmation after the database commit, so the placing player
-- does not depend solely on a potentially missed snapshot broadcast.
RegisterNetEvent('hf1_tv:placedConfirmed',function(tv)
    if not tv or not tv.id then return end
    notify('Television saved. Loading the placed object...', 'success')
    CreateThread(function()
        spawnObject(tv)
        Wait(1000)
        if not objects[tv.id] or not DoesEntityExist(objects[tv.id]) then
            print(('[hf1_tv] Placed TV %s not visible after confirmation; requesting sync'):format(tostring(tv.id)))
            TriggerServerEvent('hf1_tv:placedRequest')
            notify('TV saved, but the prop did not load. Check F8 for details.', 'error')
        end
    end)
end)
RegisterNetEvent('hf1_tv:placedRemoved',function(id)
    clearObject(tonumber(id))
end)
local function cameraRay(distance, ignoredEntity)
    local rot=GetGameplayCamRot(2)
    local origin=GetGameplayCamCoord()
    local pitch,yaw=math.rad(rot.x),math.rad(rot.z)
    local direction=vector3(-math.sin(yaw)*math.cos(pitch),math.cos(yaw)*math.cos(pitch),math.sin(pitch))
    local dest=origin+direction*distance
    -- Synchronous probe: the previous asynchronous ray was read immediately,
    -- often before collision results were ready. Ignore the player and preview.
    local ray=StartExpensiveSynchronousShapeTestLosProbe(origin.x,origin.y,origin.z,
        dest.x,dest.y,dest.z,1 + 16 + 32 + 64,ignoredEntity or PlayerPedId(),7)
    local _,hit,point,normal=GetShapeTestResult(ray)
    if hit==1 and point and #(point-origin)>0.1 then return point,normal,true end
    return dest,nil,false
end
local pendingPlacement=false
RegisterNetEvent('hf1_tv:placeResult',function(success,msg)
    pendingPlacement=false
    notify(msg,success and 'success' or 'error')
    if Config.PlacementShowDiagnostics then print(('[hf1_tv] server placement response: %s %s'):format(tostring(success),tostring(msg))) end
end)
local function placement(modelName)
    if placing then return end
    placing=true
    local model=joaat(modelName)
    RequestModel(model)
    local deadline=GetGameTimer()+5000
    while not HasModelLoaded(model) and GetGameTimer()<deadline do Wait(0) end
    if not HasModelLoaded(model) then placing=false notify('TV model could not load','error') return end
    local ped=PlayerPedId()
    local start=GetEntityCoords(ped)
    local ghost=CreateObjectNoOffset(model,start.x,start.y,start.z,false,false,false)
    if ghost==0 then placing=false notify('Cannot create preview','error') return end
    SetEntityCollision(ghost,false,false)
    SetEntityAlpha(ghost,170,false)
    -- Disable physics so gravity cannot pull the preview away from the cursor.
    -- Move it with NoOffset every frame, then keep it frozen.
    SetEntityDynamic(ghost,false)
    SetEntityHasGravity(ghost,false)
    FreezeEntityPosition(ghost,false)
    local heading=GetEntityHeading(ped)
    local wallModel=Config.PlaceableModels[modelName].wall
    local snap=wallModel
    local walkMode=false
    local height=0.0
    local depth=0.0
    local placed=false
    local selected=false
    local anchor=nil
    local anchorNormal=nil
    local pos=nil
    local aimDistance=6.0
    local lastUi=''
    local function updateUI(message)
        if Config.PlacementShowHelp == false then return end
        if message~=lastUi then
            lib.hideTextUI()
            lib.showTextUI(message,{position='top-center',icon='tv',style={borderRadius=8}})
            lastUi=message
        end
    end
    local minDim,maxDim=GetModelDimensions(model)
    -- GTA prop origins are not consistently at the bottom of the object.
    -- For desk/floor models place the model's bounding-box bottom on the hit point.
    -- Wall models use their centre pivot and optional wall snap.
    local baseOffset=wallModel and 0.0 or -minDim.z
    local function calculatePosition(point,normal)
        local wallHit=normal and math.abs(normal.z)<0.55
        local offset=wallHit and snap and Config.WallOffset or 0.0
        local normalOffset=wallHit and normal*offset or vector3(0,0,0)
        return point + vector3(0,0,height+depth) -- diagnostic: no model or wall offsets; exact blue-marker world XY
    end
    while placing do
        Wait(0)
        -- Disable placement keys in Adjust mode. Walk mode leaves movement available.
        for _,control in ipairs({24,25,14,15,172,173,174,175,38,44,47,73,177,191,201}) do
            DisableControlAction(0,control,true)
        end
        if not walkMode then
            for _,control in ipairs({30,31,32,33,34,35,21,36}) do
                DisableControlAction(0,control,true)
            end
        end
        DisablePlayerFiring(PlayerId(),true)
        -- F toggles between moving the player and moving the preview.
        if IsControlJustPressed(0,23) or IsDisabledControlJustPressed(0,23) then
            walkMode=not walkMode
        end
        -- Ignore the preview itself. Otherwise the ray repeatedly hits the TV
        -- we are moving, making the blue target appear stuck in one spot.
        -- Ignore the player's ped in the ray; the preview has collision disabled
        -- and is no longer a valid ray obstruction.
        -- Cast through the scene, excluding the ghost so it cannot intercept the aim ray.
        local point,normal,hasCollision=cameraRay(Config.PlacementMaxDistance,ghost)
        -- When an MLO has no usable collision, allow manual distance control.
        if not hasCollision then
            local cam=GetGameplayCamCoord()
            local rot=GetGameplayCamRot(2)
            local pitch,yaw=math.rad(rot.x),math.rad(rot.z)
            local direction=vector3(-math.sin(yaw)*math.cos(pitch),math.cos(yaw)*math.cos(pitch),math.sin(pitch))
            point=cam+direction*aimDistance
        end
        -- The wheel changes placement depth whenever the cursor has no
        -- collision target. Do not silently change the TV's heading instead.
        if not selected and not hasCollision then
            if IsDisabledControlJustPressed(0,14) then aimDistance=math.min(aimDistance+0.25,Config.PlacementMaxDistance) end
            if IsDisabledControlJustPressed(0,15) then aimDistance=math.max(aimDistance-0.25,0.75) end
        end
        -- NPC-placer-style live targeting: a thin beam from the camera
        -- to the point being aimed at, plus a visible marker at its end.
        -- Drawing is independent of collision, so custom MLO surfaces
        -- with missing shape-test collision still show a target.
        local camera=GetGameplayCamCoord()
        local beamStart=camera+((point-camera)*0.12)
        DrawLine(beamStart.x,beamStart.y,beamStart.z,
            point.x,point.y,point.z,90,210,255,210)
        DrawMarker(28,point.x,point.y,point.z,
            0.0,0.0,0.0,0.0,0.0,0.0,
            0.14,0.14,0.14,25,220,255,240,
            false,false,2,false,nil,nil,false)
        if IsDisabledControlJustPressed(0,24) then
            anchor=point
            anchorNormal=normal
            selected=true
            height=0.0
            depth=0.0
            if Config.PlacementShowDiagnostics then print(("[hf1_tv] CLICK blue=(%.3f,%.3f,%.3f) ped=(%.3f,%.3f,%.3f) collision=%s normal=%s"):format(point.x,point.y,point.z,GetEntityCoords(ped).x,GetEntityCoords(ped).y,GetEntityCoords(ped).z,tostring(hasCollision),normal and ("%.2f,%.2f,%.2f"):format(normal.x,normal.y,normal.z) or "none")) end
            -- Keep heading unchanged during diagnostic lock; no wall-facing recalculation.
        end
        if IsDisabledControlJustPressed(0,47) then
            snap=not snap
            if snap and selected and anchorNormal and math.abs(anchorNormal.z)<0.55 then
                heading=(math.deg(math.atan(anchorNormal.y,anchorNormal.x))-90.0)%360
            end
        end
        local speed=0.012
        if IsDisabledControlPressed(0,21) then speed=speed*3.0 end
        if IsDisabledControlPressed(0,36) then speed=speed*0.25 end
        if selected and not walkMode then
            local rad=math.rad(heading)
            local forward=vector3(-math.sin(rad),math.cos(rad),0)
            local right=vector3(math.cos(rad),math.sin(rad),0)
            local move=vector3(0,0,0)
            if IsDisabledControlPressed(0,32) then move=move+forward*speed end
            if IsDisabledControlPressed(0,33) then move=move-forward*speed end
            if IsDisabledControlPressed(0,34) then move=move-right*speed end
            if IsDisabledControlPressed(0,35) then move=move+right*speed end
            if #(move)>0 then
                local candidate=anchor+move
                if #(GetEntityCoords(ped)-candidate)<=Config.PlacementMaxDistance then anchor=candidate end
            end
            if IsDisabledControlPressed(0,38) then height=math.min(height+speed,3.0) end
            if IsDisabledControlPressed(0,44) then height=math.max(height-speed,-2.0) end
            if IsDisabledControlPressed(0,174) then heading=(heading+0.75)%360 end
            if IsDisabledControlPressed(0,175) then heading=(heading-0.75)%360 end
            if IsDisabledControlJustPressed(0,172) then depth=math.min(depth+0.025,0.75) end
            if IsDisabledControlJustPressed(0,173) then depth=math.max(depth-0.025,-0.5) end
            if selected then
                if IsDisabledControlJustPressed(0,14) then heading=(heading+5)%360 end
                if IsDisabledControlJustPressed(0,15) then heading=(heading-5)%360 end
            end
        end
        local ready=selected and anchor~=nil
        -- Preview tracks the live aiming marker until left-click locks it.
        local target=ready and anchor or point
        local targetNormal=ready and anchorNormal or normal
        pos=calculatePosition(target,targetNormal)
        -- The cyan marker and the preview share one world-space target.
        -- NoOffset avoids GTA's model-radius/Z offset applied by SetEntityCoords.
        -- Temporarily unfreeze for engines that reject frozen entity teleports,
        -- then refreeze before physics can move the object.
        -- Use an absolute world position, never local-space offsets. Keep the
        -- preview unfrozen, non-dynamic and collisionless during the move.
        SetEntityCoordsNoOffset(ghost,pos.x,pos.y,pos.z,false,false,false)
        SetEntityHeading(ghost,heading)
        SetEntityVelocity(ghost,0.0,0.0,0.0)
        SetEntityAlpha(ghost,ready and 190 or 105,false)
        -- Some GTA prop instances refuse to teleport even when collisionless.
        -- Recreate the LOCAL preview at the intended world coords if that
        -- happens. This avoids the old object staying behind the player.
        local actualBefore=GetEntityCoords(ghost)
        if #(actualBefore-pos)>0.35 then
            DeleteEntity(ghost)
            ghost=CreateObjectNoOffset(model,pos.x,pos.y,pos.z,false,false,false)
            if ghost==0 then
                lib.hideTextUI()
                placing=false
                notify('Preview object could not be repositioned','error')
                return
            end
            SetEntityCollision(ghost,false,false)
            SetEntityDynamic(ghost,false)
            SetEntityHasGravity(ghost,false)
            FreezeEntityPosition(ghost,false)
            SetEntityHeading(ghost,heading)
            SetEntityAlpha(ghost,ready and 190 or 105,false)
        end
        -- Amber marker follows the *actual* entity coordinates, not the
        -- intended position. If it differs from the cyan target, report it.
        local actual=GetEntityCoords(ghost)
        if Config.PlacementShowDiagnostics then
            DrawMarker(28,actual.x,actual.y,actual.z,0,0,0,0,0,0,
                0.065,0.065,0.065,255,190,60,180,false,false,2,false,nil,nil,false)
        end
        if IsDisabledControlJustPressed(0,24) then
            if Config.PlacementShowDiagnostics then print(("[hf1_tv] LOCK target=(%.3f,%.3f,%.3f) calculated=(%.3f,%.3f,%.3f) actual=(%.3f,%.3f,%.3f)"):format(target.x,target.y,target.z,pos.x,pos.y,pos.z,actual.x,actual.y,actual.z)) end
        end
        local mismatch=#(actual-pos)
        if mismatch>0.25 and GetGameTimer()%1500<20 then
            if Config.PlacementShowDiagnostics then print(('[hf1_tv] TV preview mismatch %.2fm target=(%.2f,%.2f,%.2f) actual=(%.2f,%.2f,%.2f)'):format(mismatch,pos.x,pos.y,pos.z,actual.x,actual.y,actual.z)) end
        end
        local status=ready and 'READY' or 'CLICK TO POSITION' 
        local modeLabel=walkMode and 'WALK' or 'ADJUST'
        local line=('[TV] %s | %s | [CLICK] Position | [ENTER] Place | [X] Exit | [F] Walk | [G] Snap %s'):format(status,modeLabel,snap and 'ON' or 'OFF')
        if not walkMode then line=line..'\\n[WASD] Move | [Q/E] Height | [Arrows] Rotate/Depth' end
        if not selected and not hasCollision then line=line..' | NO SURFACE HIT: [Wheel] Aim distance '..string.format('%.1fm',aimDistance) end
        updateUI(line)
        if IsDisabledControlJustPressed(0,73) or IsDisabledControlJustPressed(0,177) then break end
        if ready and (IsControlJustPressed(0,191) or IsDisabledControlJustPressed(0,191) or IsDisabledControlJustPressed(0,201)) then
            pendingPlacement=true
            local payload={model=modelName,coords={x=pos.x,y=pos.y,z=pos.z},heading=heading}
            if Config.PlacementShowDiagnostics then print(('[hf1_tv] sending placement model=%s coords=(%.2f,%.2f,%.2f)'):format(modelName,pos.x,pos.y,pos.z)) end
            TriggerServerEvent('hf1_tv:place',payload)
            SetTimeout(8000,function()
                if pendingPlacement then
                    pendingPlacement=false
                    notify('No placement reply from server. Check server console for hf1_tv errors; item has not been confirmed removed.','error')
                    print('[hf1_tv] ERROR: no server placement response after 8 seconds. Check that placement_server.lua is running.')
                end
            end)
            placed=true
            break
        end
    end
    lib.hideTextUI()
    DeleteEntity(ghost)
    SetModelAsNoLongerNeeded(model)
    placing=false
    if placed then notify('Sending TV placement to server... awaiting confirmation', 'inform') end
end
local function beginPlacement()
    if placing then return end
    local options={}
    for name,settings in pairs(Config.PlaceableModels) do
        options[#options+1]={value=name,label=settings.label}
    end
    table.sort(options,function(a,b) return a.label<b.label end)
    local result=lib.inputDialog('Place television',{{type='select',label='TV model',options=options,required=true}})
    if result and result[1] and Config.PlaceableModels[result[1]] then placement(result[1]) end
end
exports('useTelevision',function(data,slot)
    beginPlacement()
end)
RegisterCommand('tvplace',function() beginPlacement() end,false)
RegisterCommand('tvadminremove',function()
    local best,bestDist
    local origin=GetEntityCoords(PlayerPedId())
    for id,e in pairs(objects) do
        if DoesEntityExist(e) then
            local dist=#(GetEntityCoords(e)-origin)
            if dist<Config.PlacementMaxDistance+3 and (not bestDist or dist<bestDist) then best,bestDist=id,dist end
        end
    end
    if not best then notify('No placed TV nearby','error') return end
    local answer=lib.alertDialog({header='Admin remove television?',content='Remove the nearest placed TV (ID '..best..') permanently without returning an item?',centered=true,cancel=true})
    if answer=='confirm' then TriggerServerEvent('hf1_tv:adminRemove',best) end
end,false)
CreateThread(function()
    Wait(1500)
    TriggerServerEvent('hf1_tv:placedRequest')
end)
AddEventHandler('onResourceStop',function(name)
    if name~=GetCurrentResourceName() then return end
    placing=false
    for id in pairs(objects) do clearObject(id) end
end)
