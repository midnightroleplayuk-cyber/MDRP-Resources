local spawned = {}
local records = {}
local editing = false
local function message(text, kind)
    lib.notify({description=text, type=kind or 'inform'})
end
local function requestModel(model)
    local hash=joaat(model)
    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then return nil end
    RequestModel(hash)
    local deadline=GetGameTimer()+5000
    while not HasModelLoaded(hash) and GetGameTimer()<deadline do Wait(0) end
    if not HasModelLoaded(hash) then return nil end
    return hash
end
local function removeAll()
    for _, veh in pairs(spawned) do
        if DoesEntityExist(veh) then DeleteEntity(veh) end
    end
    spawned={}
end
local function applyAppearance(veh, d)
    SetVehicleNumberPlateText(veh, d.plate or 'DISPLAY')
    SetVehicleColours(veh, tonumber(d.primary_color or d.primary) or 0, tonumber(d.secondary_color or d.secondary) or 0)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleEngineOn(veh, false, true, true)
    SetVehicleDoorsLocked(veh, 2)
    SetVehicleUndriveable(veh, true)
    SetEntityInvincible(veh, true)
    FreezeEntityPosition(veh, true)
    SetEntityCollision(veh, false, false)
end
local function spawnDisplay(id,d)
    local hash=requestModel(d.model)
    if not hash then return end
    local veh=CreateVehicle(hash, d.x+0.0,d.y+0.0,d.z+0.0,d.heading+0.0,false,false)
    if veh == 0 then return end
    SetEntityAsMissionEntity(veh,true,true)
    applyAppearance(veh,d)
    spawned[id]=veh
    SetModelAsNoLongerNeeded(hash)
end
RegisterNetEvent('hf1_display_veh:client:sync', function(data)
    records=data or {}
    removeAll()
    for id,d in pairs(records) do
        local numeric=tonumber(id)
        if numeric then spawnDisplay(numeric,d) end
    end
end)
CreateThread(function()
    Wait(1500)
    local data=lib.callback.await('hf1_display_veh:server:get',false)
    if data then TriggerEvent('hf1_display_veh:client:sync',data) end
end)
CreateThread(function()
    while true do
        Wait(0)
        local now=GetGameTimer()/1000.0
        local active=false
        for id,veh in pairs(spawned) do
            local d=records[id] or records[tostring(id)]
            if d and d.rotating and DoesEntityExist(veh) then
                active=true
                SetEntityHeading(veh,(d.heading + now * (tonumber(d.speed) or 0))%360)
            end
        end
        if not active then Wait(500) end
    end
end)
local openMenu
local function editor(existing)
    if editing then return end
    editing=true
    local d={}
    if existing then
        for k,v in pairs(existing) do d[k]=v end
        d.primary=d.primary_color or d.primary
        d.secondary=d.secondary_color or d.secondary
    else
        local ped=PlayerPedId()
        local pos=GetOffsetFromEntityInWorldCoords(ped,0.0,Config.SpawnDistance,0.0)
        d={model='adder',name='Casino Display',plate='DISPLAY',x=pos.x,y=pos.y,z=pos.z,heading=GetEntityHeading(ped),rotating=false,speed=Config.DefaultRotationSpeed,primary=0,secondary=0}
    end
    local fields=lib.inputDialog(existing and 'Edit display' or 'New display',{
        {type='input',label='Display name',required=true,default=d.name,max=60},
        {type='input',label='Vehicle spawn name',required=true,default=d.model},
        {type='input',label='Licence plate (max 8)',required=true,default=d.plate,max=8},
        {type='number',label='Primary GTA colour ID (0-160)',default=d.primary,min=0,max=160},
        {type='number',label='Secondary GTA colour ID (0-160)',default=d.secondary,min=0,max=160},
        {type='checkbox',label='Rotate on turntable',checked=d.rotating},
        {type='number',label='Rotation speed (degrees/sec; negative reverses)',default=d.speed,min=Config.MinRotationSpeed,max=Config.MaxRotationSpeed}
    })
    if not fields then editing=false return end
    d.name=fields[1];d.model=fields[2];d.plate=fields[3]
    d.primary=fields[4];d.secondary=fields[5];d.rotating=fields[6];d.speed=fields[7]
    local hash=requestModel(d.model)
    if not hash then editing=false return message('Invalid vehicle model','error') end
    local veh=CreateVehicle(hash,d.x,d.y,d.z,d.heading,false,false)
    if veh==0 then editing=false return message('Could not create preview','error') end
    SetEntityAsMissionEntity(veh,true,true)
    applyAppearance(veh,d)
    SetModelAsNoLongerNeeded(hash)
    local original=existing and spawned[tonumber(existing.id)]
    if original and DoesEntityExist(original) then SetEntityVisible(original,false,false) end
    message('Arrow keys move | PgUp/PgDn height | Q/E heading | Shift faster | Enter save | Backspace cancel')
    local saved=false
    while true do
        Wait(0)
        DisableControlAction(0, 200, true)
        local step=Config.PreviewStep*(IsControlPressed(0,21) and 5 or 1)
        local heading=GetEntityHeading(veh)
        local rad=math.rad(heading)
        local dx,dy=0.0,0.0
        if IsControlPressed(0,172) then dx=dx-math.sin(rad)*step;dy=dy+math.cos(rad)*step end
        if IsControlPressed(0,173) then dx=dx+math.sin(rad)*step;dy=dy-math.cos(rad)*step end
        if IsControlPressed(0,174) then dx=dx-math.cos(rad)*step;dy=dy-math.sin(rad)*step end
        if IsControlPressed(0,175) then dx=dx+math.cos(rad)*step;dy=dy+math.sin(rad)*step end
        if IsControlPressed(0,10) then d.z=d.z+step end
        if IsControlPressed(0,11) then d.z=d.z-step end
        if IsControlPressed(0,44) then d.heading=(d.heading+1)%360 end
        if IsControlPressed(0,38) then d.heading=(d.heading-1)%360 end
        d.x=d.x+dx;d.y=d.y+dy
        SetEntityCoordsNoOffset(veh,d.x,d.y,d.z,false,false,false)
        SetEntityHeading(veh,d.heading)
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(('~INPUT_CELLPHONE_UP~/Down/Left/Right Move | PgUp/PgDn Height | Q/E Rotate | Shift Fast | Enter Save | Backspace Cancel~n~Z: %.2f | Heading: %.1f'):format(d.z,d.heading))
        EndTextCommandDisplayHelp(0,false,false,-1)
        if IsControlJustPressed(0,191) or IsControlJustPressed(0,201) then saved=true break end
        if IsDisabledControlJustPressed(0,200) or IsControlJustPressed(0,177) then break end
    end
    DeleteEntity(veh)
    if original and DoesEntityExist(original) then SetEntityVisible(original,true,false) end
    editing=false
    if saved then TriggerServerEvent('hf1_display_veh:server:save',d) else message('Cancelled') end
end
openMenu=function()
    local allowed=lib.callback.await('hf1_display_veh:server:access',false)
    if not allowed then return message('Not authorized','error') end
    local options={{title='Create new display',icon='plus',onSelect=function() editor(nil) end}}
    local list={}
    for id,d in pairs(records) do
        list[#list+1]={id=tonumber(id),d=d}
    end
    table.sort(list,function(a,b) return a.id<b.id end)
    for _,item in ipairs(list) do
        local id,d=item.id,item.d
        options[#options+1]={title=d.name,description=('%s | %s | ID %s'):format(d.model,d.plate,id),icon='car',onSelect=function()
            lib.registerContext({id='hf1_display_veh_manage',title=d.name,menu='hf1_display_veh_main',options={
                {title='Edit and reposition',icon='pen',onSelect=function() editor(d) end},
                {title='Delete display',icon='trash',onSelect=function()
                    local choice=lib.alertDialog({header='Delete '..d.name..'?',content='This cannot be undone.',centered=true,cancel=true})
                    if choice=='confirm' then TriggerServerEvent('hf1_display_veh:server:delete',id) end
                end}
            }})
            lib.showContext('hf1_display_veh_manage')
        end}
    end
    lib.registerContext({id='hf1_display_veh_main',title='HF1 Display Vehicles',options=options})
    lib.showContext('hf1_display_veh_main')
end
RegisterCommand(Config.Command,function() openMenu() end,false)
AddEventHandler('onResourceStop',function(resource)
    if resource==GetCurrentResourceName() then removeAll() end
end)
