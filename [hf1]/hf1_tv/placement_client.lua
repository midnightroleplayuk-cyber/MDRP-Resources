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
    SetEntityAlpha(ghost,160,false)
    SetEntityCollision(ghost,false,false)
    FreezeEntityPosition(ghost,true)
    local heading=GetEntityHeading(ped)
    local wall=Config.PlaceableModels[modelName].wall
    local ready=false
    notify('Aim at '..(wall and 'a wall' or 'the floor')..' | Mouse wheel: rotate | E: place | X: cancel')
    while placing do
        Wait(0)
        DisableControlAction(0,24,true)
        DisableControlAction(0,25,true)
        DisableControlAction(0,14,true)
        DisableControlAction(0,15,true)
        local hit,p,n=cameraRay(Config.PlacementMaxDistance)
        ready=false
        if hit and p and n then
            local validSurface=wall and math.abs(n.z)<0.35 or (not wall and n.z>0.75)
            if validSurface and #(GetEntityCoords(ped)-p)<=Config.PlacementMaxDistance then
                ready=true
                local pos=wall and p+n*Config.WallOffset or p
                -- Floor models use their natural base offset; wall models face away from wall.
                if wall then heading=(math.deg(math.atan(n.y,n.x))-90.0)%360 end
                SetEntityCoordsNoOffset(ghost,pos.x,pos.y,pos.z,false,false,false)
            end
        end
        if IsDisabledControlJustPressed(0,14) then heading=(heading+5)%360 end
        if IsDisabledControlJustPressed(0,15) then heading=(heading-5)%360 end
        SetEntityHeading(ghost,heading)
        SetEntityAlpha(ghost,ready and 190 or 70,false)
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(ready and '~g~E~s~ Place  ~b~Mouse wheel~s~ Rotate  ~r~X~s~ Cancel' or '~r~Aim at a suitable surface~s~  ~r~X~s~ Cancel')
        EndTextCommandDisplayHelp(0,false,false,-1)
        if IsControlJustPressed(0,73) then break end
        if ready and IsControlJustPressed(0,38) then
            local pos=GetEntityCoords(ghost)
            TriggerServerEvent('hf1_tv:place',{model=modelName,coords={x=pos.x,y=pos.y,z=pos.z},heading=heading})
            break
        end
    end
    DeleteEntity(ghost)
    SetModelAsNoLongerNeeded(model)
    placing=false
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
