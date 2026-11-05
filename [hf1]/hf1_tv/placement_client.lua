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
    local function validSurface(point,normal)
        if not point or not normal then return false end
        local isWall=math.abs(normal.z)<0.35
        local isFloor=normal.z>0.65
        -- Wall-mounted flatscreens belong on vertical surfaces; desktop and
        -- standing models belong on horizontal surfaces (desks, shelves, floors).
        local surfaceOK = wallModel and isWall or (not wallModel and isFloor)
        return #(GetEntityCoords(ped)-point)<=Config.PlacementMaxDistance
            and surfaceOK
    end
    local function calculatePosition(point,normal)
        local offset=(snap and math.abs(normal.z)<0.35) and Config.WallOffset or 0.03
        return point+normal*(offset+depth)+vector3(0,0,height)
    end
    while placing do
        Wait(0)
        -- Same interaction pattern as hf1_npcs: click to choose the world
        -- position, then use movement/rotation/height controls to fine-tune.
        -- F switches between moving your character and adjusting the TV.
        -- In walk mode the movement keys are deliberately left enabled.
        if IsControlJustPressed(0,23) then walkMode=not walkMode end
        local blocked={24,25,14,15,172,173,174,175,44,45,47,73,191,177}
        if not walkMode then
            for _,control in ipairs({30,31,32,33,34,35,21,36}) do
                blocked[#blocked+1]=control
            end
        end
        for _,control in ipairs(blocked) do DisableControlAction(0,control,true) end
        DisablePlayerFiring(PlayerId(),true)
        local hit,point,normal=cameraRay(Config.PlacementMaxDistance)
        local aimingValid=hit and validSurface(point,normal)
        if aimingValid then
            DrawMarker(28,point.x,point.y,point.z+0.025,0,0,0,0,0,0,
                0.14,0.14,0.14,255,255,255,210,false,false,2,false,nil,nil,false)
        end
        if IsDisabledControlJustPressed(0,24) then
            if aimingValid then
                anchor=point
                anchorNormal=normal
                selected=true
                height=0.0
                depth=0.0
                if snap and math.abs(normal.z)<0.35 then
                    heading=(math.deg(math.atan(normal.y,normal.x))-90.0)%360
                end
            else
                notify('Aim at a nearby valid surface before left-clicking.','error')
            end
        end
        if not walkMode and IsDisabledControlJustPressed(0,47) and wallModel then
            snap=not snap
            -- Keep a selected position only if it is still a valid surface.
            if selected and not validSurface(anchor,anchorNormal) then selected=false end
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
        local ready=selected and validSurface(anchor,anchorNormal)
        if ready then
            pos=calculatePosition(anchor,anchorNormal)
        elseif aimingValid then
            pos=calculatePosition(point,normal)
        else
            pos=nil
        end
        if pos then SetEntityCoordsNoOffset(ghost,pos.x,pos.y,pos.z,false,false,false) end
        SetEntityHeading(ghost,heading)
        SetEntityAlpha(ghost,ready and 205 or (pos and 100 or 40),false)
        local status=ready and 'POSITION SELECTED' or 'AIM AND LEFT CLICK TO SELECT'
        local surfaceLabel=wallModel and 'WALL ONLY' or 'DESK / FLOOR / SHELF'
        local modeLabel=walkMode and 'WALK (movement enabled)' or 'ADJUST TV'
        updateUI(('**TV Placement — %s — %s**\n[F] Toggle Walk / Adjust  [LEFT CLICK] Select  [E] Place  [X] Cancel\n%s\n%s'):format(modeLabel,surfaceLabel,
            walkMode and 'Move your character with WASD; click a new surface when close enough.'
                or '[WASD] Move TV  [Q/R] Height  [←/→] Rotate  [↑/↓] Clearance  [Wheel] Rotate',
            ('Selected: **%s**  Height: **%.2fm**  Clearance: **%.2fm**  Snap: **%s**'):format(
                ready and 'YES' or 'NO',height,depth,wallModel and (snap and 'ON' or 'OFF') or 'N/A')))
        if IsDisabledControlJustPressed(0,73) or IsDisabledControlJustPressed(0,177) then break end
        -- E confirms, matching the existing TV placer request. Left click only
        -- chooses an anchor, so accidental clicks cannot consume inventory.
        if ready and IsControlJustPressed(0,51) then
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
