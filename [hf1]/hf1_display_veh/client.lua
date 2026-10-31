local spawned = {}
local records = {}
local editing = false
local spawnedSignatures = {}
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
    spawnedSignatures={}
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
-- Sync only updates metadata. Nearby vehicles are streamed by the distance worker.
RegisterNetEvent('hf1_display_veh:client:sync', function(data)
    records = data or {}
end)

CreateThread(function()
    Wait(1500)
    local data = lib.callback.await('hf1_display_veh:server:get', false)
    if data then TriggerEvent('hf1_display_veh:client:sync', data) end
end)

local function signature(d)
    return table.concat({tostring(d.model), tostring(d.x), tostring(d.y), tostring(d.z),
        tostring(d.heading), tostring(d.plate), tostring(d.primary_color or d.primary),
        tostring(d.secondary_color or d.secondary)}, '|')
end

-- Hysteresis prevents repeated spawn/delete at the edge of the stream radius.
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local spawnSq = Config.StreamDistance * Config.StreamDistance
        local despawnSq = Config.DespawnDistance * Config.DespawnDistance
        for key, d in pairs(records) do
            local id = tonumber(key)
            if id then
                local dx, dy, dz = pos.x - d.x, pos.y - d.y, pos.z - d.z
                local distSq = dx * dx + dy * dy + dz * dz
                local veh = spawned[id]
                if veh and not DoesEntityExist(veh) then
                    spawned[id] = nil
                    spawnedSignatures[id] = nil
                    veh = nil
                end
                if veh and (distSq > despawnSq or spawnedSignatures[id] ~= signature(d)) then
                    DeleteEntity(veh)
                    spawned[id] = nil
                    spawnedSignatures[id] = nil
                    veh = nil
                end
                if not veh and distSq <= spawnSq then
                    spawnDisplay(id, d)
                    if spawned[id] then spawnedSignatures[id] = signature(d) end
                end
            end
        end
        for id, veh in pairs(spawned) do
            if not (records[id] or records[tostring(id)]) then
                if DoesEntityExist(veh) then DeleteEntity(veh) end
                spawned[id] = nil
                spawnedSignatures[id] = nil
            end
        end
        Wait(Config.DistanceCheckInterval)
    end
end)

-- Smooth rotation: frame-based only while a rotating display is actually streamed.
-- Absolute time prevents accumulated drift; no networking or database traffic per frame.
CreateThread(function()
    while true do
        local active = false
        local now = GetGameTimer() * 0.001
        for id, veh in pairs(spawned) do
            local d = records[id] or records[tostring(id)]
            if d and (d.rotating == true or d.rotating == 1) and DoesEntityExist(veh) then
                active = true
                local speed = tonumber(d.speed) or 0
                if speed ~= 0 then
                    SetEntityHeading(veh, ((tonumber(d.heading) or 0) + now * speed) % 360.0)
                end
            end
        end
        -- Frame updates remove visible stepping at high turntable speeds.
        -- Sleep when no rotating displays are nearby.
        Wait(active and 0 or 500)
    end
end)

-- Raycast from gameplay camera through the crosshair for click-to-place.
local function cameraTarget(maxDistance)
    local origin = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(2)
    local pitch, yaw = math.rad(rot.x), math.rad(rot.z)
    local cosPitch = math.cos(pitch)
    local direction = vector3(-math.sin(yaw)*cosPitch, math.cos(yaw)*cosPitch, math.sin(pitch))
    local finish = origin + direction * maxDistance
    local ray = StartShapeTestRay(origin.x, origin.y, origin.z, finish.x, finish.y, finish.z, 1 + 16, PlayerPedId(), 7)
    local _, hit, coords = GetShapeTestResult(ray)
    if hit == 1 then return coords end
    return nil
end

local function snapVehicleToSurface(veh, d)
    -- Use the vehicle's own wheel/bounding geometry, not an arbitrary z offset.
    -- Temporarily enable collision for the native, then restore decorative settings.
    RequestCollisionAtCoord(d.x, d.y, d.z)
    SetEntityCollision(veh, true, true)
    FreezeEntityPosition(veh, false)
    SetEntityCoordsNoOffset(veh, d.x, d.y, d.z + 2.0, false, false, false)
    local success = false
    for i = 1, 15 do
        RequestCollisionAtCoord(d.x, d.y, d.z)
        if SetVehicleOnGroundProperly(veh) then success = true break end
        Wait(0)
    end
    if success then
        local coords = GetEntityCoords(veh)
        d.x, d.y, d.z = coords.x, coords.y, coords.z
    else
        -- Ground native fallback for streamed terrain; never silently change z on failure.
        local found, ground = GetGroundZFor_3dCoord(d.x, d.y, d.z + 50.0, false)
        if found then
            SetEntityCoordsNoOffset(veh, d.x, d.y, ground + 2.0, false, false, false)
            if SetVehicleOnGroundProperly(veh) then
                local coords = GetEntityCoords(veh)
                d.z = coords.z
                success = true
            end
        end
    end
    SetEntityHeading(veh, d.heading)
    FreezeEntityPosition(veh, true)
    SetEntityCollision(veh, false, false)
    return success
end

-- GTA V vehicle paint names mapped to native colour IDs.
-- Select entries by name; stored IDs remain compatible with existing SQL rows.
local paintNames = {
    [0]='Metallic Black',[1]='Metallic Graphite Black',[2]='Metallic Black Steel',[3]='Metallic Dark Silver',
    [4]='Metallic Silver',[5]='Metallic Blue Silver',[6]='Metallic Steel Gray',[7]='Metallic Shadow Silver',
    [8]='Metallic Stone Silver',[9]='Metallic Midnight Silver',[10]='Metallic Gun Metal',[11]='Metallic Anthracite Grey',
    [12]='Matte Black',[13]='Matte Gray',[14]='Matte Light Grey',[15]='Util Black',[16]='Util Black Poly',
    [17]='Util Dark Silver',[18]='Util Silver',[19]='Util Gun Metal',[20]='Util Shadow Silver',
    [21]='Worn Black',[22]='Worn Graphite',[23]='Worn Silver Grey',[24]='Worn Silver',[25]='Worn Blue Silver',
    [26]='Worn Shadow Silver',[27]='Metallic Red',[28]='Metallic Torino Red',[29]='Metallic Formula Red',
    [30]='Metallic Blaze Red',[31]='Metallic Graceful Red',[32]='Metallic Garnet Red',[33]='Metallic Desert Red',
    [34]='Metallic Cabernet Red',[35]='Metallic Candy Red',[36]='Metallic Sunrise Orange',[37]='Metallic Classic Gold',
    [38]='Metallic Orange',[39]='Matte Red',[40]='Matte Dark Red',[41]='Matte Orange',[42]='Matte Yellow',
    [43]='Util Red',[44]='Util Bright Red',[45]='Util Garnet Red',[46]='Worn Red',[47]='Worn Golden Red',
    [48]='Worn Dark Red',[49]='Metallic Dark Green',[50]='Metallic Racing Green',[51]='Metallic Sea Green',
    [52]='Metallic Olive Green',[53]='Metallic Green',[54]='Metallic Gasoline Blue Green',[55]='Matte Lime Green',
    [56]='Util Dark Green',[57]='Util Green',[58]='Worn Dark Green',[59]='Worn Green',[60]='Worn Sea Wash',
    [61]='Metallic Midnight Blue',[62]='Metallic Dark Blue',[63]='Metallic Saxony Blue',[64]='Metallic Blue',
    [65]='Metallic Mariner Blue',[66]='Metallic Harbor Blue',[67]='Metallic Diamond Blue',[68]='Metallic Surf Blue',
    [69]='Metallic Nautical Blue',[70]='Metallic Bright Blue',[71]='Metallic Purple Blue',[72]='Metallic Spinnaker Blue',
    [73]='Metallic Ultra Blue',[74]='Metallic Bright Blue',[75]='Util Dark Blue',[76]='Util Midnight Blue',
    [77]='Util Blue',[78]='Util Sea Foam Blue',[79]='Util Lightning Blue',[80]='Util Maui Blue Poly',
    [81]='Util Bright Blue',[82]='Matte Dark Blue',[83]='Matte Blue',[84]='Matte Midnight Blue',
    [85]='Worn Dark Blue',[86]='Worn Blue',[87]='Worn Light Blue',[88]='Metallic Taxi Yellow',
    [89]='Metallic Race Yellow',[90]='Metallic Bronze',[91]='Metallic Yellow Bird',[92]='Metallic Lime',
    [93]='Metallic Champagne',[94]='Metallic Pueblo Beige',[95]='Metallic Dark Ivory',[96]='Metallic Choco Brown',
    [97]='Metallic Golden Brown',[98]='Metallic Light Brown',[99]='Metallic Straw Beige',[100]='Metallic Moss Brown',
    [101]='Metallic Biston Brown',[102]='Metallic Beechwood',[103]='Metallic Dark Beechwood',[104]='Metallic Choco Orange',
    [105]='Metallic Beach Sand',[106]='Metallic Sun Bleeched Sand',[107]='Metallic Cream',[108]='Util Brown',
    [109]='Util Medium Brown',[110]='Util Light Brown',[111]='Metallic White',[112]='Metallic Frost White',
    [113]='Worn Honey Beige',[114]='Worn Brown',[115]='Worn Dark Brown',[116]='Worn Straw Beige',
    [117]='Brushed Steel',[118]='Brushed Black Steel',[119]='Brushed Aluminium',[120]='Chrome',
    [121]='Worn Off White',[122]='Util Off White',[123]='Worn Orange',[124]='Worn Light Orange',
    [125]='Metallic Securicor Green',[126]='Worn Taxi Yellow',[127]='Police Car Blue',[128]='Matte Green',
    [129]='Matte Brown',[130]='Worn Orange',[131]='Matte White',[132]='Worn White',[133]='Worn Olive Army Green',
    [134]='Pure White',[135]='Hot Pink',[136]='Salmon Pink',[137]='Metallic Vermillion Pink',
    [138]='Orange',[139]='Green',[140]='Blue',[141]='Metallic Black Blue',[142]='Metallic Black Purple',
    [143]='Metallic Black Red',[144]='Hunter Green',[145]='Metallic Purple',[146]='Metallic Dark Blue',
    [147]='Modshop Black',[148]='Matte Purple',[149]='Matte Dark Purple',[150]='Metallic Lava Red',
    [151]='Matte Forest Green',[152]='Matte Olive Drab',[153]='Matte Desert Brown',[154]='Matte Desert Tan',
    [155]='Matte Foilage Green',[156]='Default Alloy',[157]='Epsilon Blue',[158]='Pure Gold',[159]='Brushed Gold'
}
local paintOptions = {}
for id=0,160 do
    paintOptions[#paintOptions+1] = {value=id, label=('%s (ID %d)'):format(paintNames[id] or 'Other / Unlabelled',id)}
end

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
        {type='select',label='Primary paint colour',description='Choose a GTA paint name',options=paintOptions,default=tonumber(d.primary) or 0,required=true,searchable=true},
        {type='select',label='Secondary paint colour',description='Choose a GTA paint name',options=paintOptions,default=tonumber(d.secondary) or 0,required=true,searchable=true},
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
    message('Aim + LEFT CLICK to place | G ground snap | Z/X colours | C paint channel | Enter save')
    -- Live paint preview while positioning: cycle GTA paint IDs on the preview entity.
    -- The initial searchable dropdown still lets admins jump directly to a named paint.
    local activePaint = 1 -- 1 = primary, 2 = secondary
    local function updatePaint()
        SetVehicleColours(veh, tonumber(d.primary) or 0, tonumber(d.secondary) or 0)
    end
    local function cyclePaint(direction)
        local key = activePaint == 1 and 'primary' or 'secondary'
        d[key] = ((tonumber(d[key]) or 0) + direction) % 160
        updatePaint()
    end
    local saved=false
    while true do
        Wait(0)
        DisableControlAction(0, 200, true)
        DisableControlAction(0, 24, true) -- Left mouse click: place at crosshair
        DisableControlAction(0, 47, true) -- G: snap vehicle onto ground/surface
        DisableControlAction(0, 20, true) -- Z: previous paint
        DisableControlAction(0, 73, true) -- X: next paint
        DisableControlAction(0, 26, true) -- C: primary/secondary toggle
        if IsDisabledControlJustPressed(0, 20) then cyclePaint(-1) end
        if IsDisabledControlJustPressed(0, 73) then cyclePaint(1) end
        if IsDisabledControlJustPressed(0, 26) then activePaint = 3 - activePaint end
        if IsDisabledControlJustPressed(0, 24) then
            local hit = cameraTarget(Config.PlacementRayDistance or 150.0)
            if hit then
                d.x, d.y, d.z = hit.x, hit.y, hit.z + 1.0
                SetEntityCoordsNoOffset(veh,d.x,d.y,d.z,false,false,false)
                if Config.AutoSnapOnClick then
                    if not snapVehicleToSurface(veh,d) then message('Could not snap here; use Page Up/Down or aim at another surface','error') end
                end
            else
                message('No surface under crosshair; aim at the floor or platform','error')
            end
        end
        if IsDisabledControlJustPressed(0, 47) then
            if not snapVehicleToSurface(veh,d) then message('Could not find ground at this position','error') end
        end
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
        local primaryName = paintNames[tonumber(d.primary) or 0] or 'Other'
        local secondaryName = paintNames[tonumber(d.secondary) or 0] or 'Other'
        local selected = activePaint == 1 and 'PRIMARY' or 'SECONDARY'
        AddTextComponentSubstringPlayerName(('Aim + LEFT CLICK Place | G Snap to Ground | Arrows Move | PgUp/PgDn Height~n~Q/E Heading | Shift Fast | Enter Save | Backspace Cancel~n~LIVE COLOURS: Z Previous | X Next | C Primary/Secondary (%s)~n~Primary: %s (%d) | Secondary: %s (%d) | Z: %.2f | Heading: %.1f'):format(selected,primaryName,tonumber(d.primary) or 0,secondaryName,tonumber(d.secondary) or 0,d.z,d.heading))
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
