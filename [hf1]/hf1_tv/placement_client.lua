local objects={}
local placing=false
local function notify(msg,kind) lib.notify({title='HF1 TV',description=msg,type=kind or 'inform'}) end
local function clearObject(id)
    local e=objects[id]
    if e then
        if DoesEntityExist(e) then
            exports.ox_target:removeLocalEntity(e,{'hf1_tv_placed_pickup_'..id})
            DeleteEntity(e)
        end
        objects[id]=nil
    end
end
local function spawnObject(tv)
    if objects[tv.id] and DoesEntityExist(objects[tv.id]) then return end
    local model=joaat(tv.model)
    if not IsModelInCdimage(model) then return end
    RequestModel(model)
    local limit=GetGameTimer()+5000
    while not HasModelLoaded(model) and GetGameTimer()<limit do Wait(0) end
    if not HasModelLoaded(model) then return end
    local p=tv.coords
    local e=CreateObjectNoOffset(model,p.x,p.y,p.z,false,false,false)
    if e==0 then return end
    SetEntityHeading(e,tv.heading)
    FreezeEntityPosition(e,true)
    SetEntityInvincible(e,true)
    objects[tv.id]=e
    SetModelAsNoLongerNeeded(model)
    exports.ox_target:addLocalEntity(e,{
        {name='hf1_tv_placed_pickup_'..tv.id,icon='fa-solid fa-box',label='Pick up television (owner only)',distance=2.5,
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
            if not objects[id] then CreateThread(function() spawnObject(tv) end) end
        end
    end
    for id in pairs(objects) do if not seen[id] then clearObject(id) end end
end)
RegisterNetEvent('hf1_tv:placedRemoved',function(id)
    clearObject(tonumber(id))
end)
local function cameraRay(distance)
    local rot=GetGameplayCamRot(2)
    local pos=GetGameplayCamCoord()
    local z=math.rad(rot.z)
    local x=math.rad(rot.x)
    local horizontal=math.abs(math.cos(x))
    local dir=vector3(-math.sin(z)*horizontal,math.cos(z)*horizontal,math.sin(x))
    local dest=pos+dir*distance
    local handle=StartShapeTestRay(pos.x,pos.y,pos.z,dest.x,dest.y,dest.z,1+16,PlayerPedId(),7)
    local _,hit,coords,normal=GetShapeTestResult(handle)
    return hit==1,coords,normal
end
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
    FreezeEntityPosition(ghost,true)
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
    local lastUi=''
    local function updateUI(message)
        if message~=lastUi then
            lib.hideTextUI()
            lib.showTextUI(message,{position='top-center',icon='tv',style={borderRadius=8}})
            lastUi=message
        end
    end
    -- Raycast is an aid, not a gate: missing collision must never block placement.
    local function aimPoint()
        local rot=GetGameplayCamRot(2)
        local origin=GetGameplayCamCoord()
        local pitch,yaw=math.rad(rot.x),math.rad(rot.z)
        local direction=vector3(-math.sin(yaw)*math.cos(pitch),math.cos(yaw)*math.cos(pitch),math.sin(pitch))
        local point,normal,hit=aimPoint()
        if IsDisabledControlJustPressed(0,24) then
            anchor=point
            anchorNormal=normal
            selected=true
            height=0.0
            depth=0.0
            if snap and normal and math.abs(normal.z)<0.55 then
                heading=(math.deg(math.atan(normal.y,normal.x))-90.0)%360
            end
        end
        if not walkMode and IsDisabledControlJustPressed(0,47) then
            snap=not snap
            -- Keep a selected position only if it is still a valid surface.

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
            if IsDisabledControlPressed(0,45) then height=math.min(height+speed,3.0) end
            if IsDisabledControlPressed(0,44) then height=math.max(height-speed,-2.0) end
            if IsDisabledControlPressed(0,174) then heading=(heading+0.75)%360 end
            if IsDisabledControlPressed(0,175) then heading=(heading-0.75)%360 end
            if IsDisabledControlJustPressed(0,172) then depth=math.min(depth+0.025,0.75) end
            if IsDisabledControlJustPressed(0,173) then depth=math.max(depth-0.025,-0.5) end
            if IsDisabledControlJustPressed(0,14) then heading=(heading+5)%360 end
            if IsDisabledControlJustPressed(0,15) then heading=(heading-5)%360 end
        end
        local ready=selected and anchor~=nil
        pos=calculatePosition(ready and anchor or point,ready and anchorNormal or normal)
        if pos then SetEntityCoordsNoOffset(ghost,pos.x,pos.y,pos.z,false,false,false) end
        SetEntityHeading(ghost,heading)
        SetEntityAlpha(ghost,ready and 205 or 100,false)
        local status=ready and 'READY' or 'CLICK TO POSITION'
        local modeLabel=walkMode and 'WALK' or 'ADJUST'
        local line=('[TV] %s | %s | [LMB] Set | [E] Place | [X] Exit | [F] Mode | [G] Snap %s'):format(status,modeLabel,snap and 'ON' or 'OFF')
        if not walkMode then line=line..'\\n[WASD] Move | [Q/R] Height | [←/→] Rotate | [↑/↓] Depth' end
        updateUI(line)
        if IsDisabledControlJustPressed(0,73) or IsDisabledControlJustPressed(0,177) then break end
        -- E confirms, matching the existing TV placer request. Left click only
        -- chooses an anchor, so accidental clicks cannot consume inventory.
        if ready and (IsControlJustPressed(0,51) or IsDisabledControlJustPressed(0,51)) then
            TriggerServerEvent('hf1_tv:place',{model=modelName,coords={x=pos.x,y=pos.y,z=pos.z},heading=heading})
            placed=true
            break
        end
    end
    lib.hideTextUI()
    DeleteEntity(ghost)
    SetModelAsNoLongerNeeded(model)
    placing=false
    if placed then notify('Placement submitted. The server will confirm and save it.','inform') end
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
