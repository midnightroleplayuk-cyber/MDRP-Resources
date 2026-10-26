-- Road-node detours run only on the client currently controlling ambient traffic.
TapeTraffic={}
local T=TapeTraffic
local routes,attempts,stopped={},{},{}
local function controls(vehicle)
    if NetworkGetEntityIsNetworked(vehicle) and not NetworkHasControlOfEntity(vehicle) then return false end
    local driver=GetPedInVehicleSeat(vehicle,-1)
    return driver==0 or not NetworkGetEntityIsNetworked(driver) or NetworkHasControlOfEntity(driver)
end
local function finish(vehicle,restore)
    local route=routes[vehicle]
    routes[vehicle]=nil
    if restore and route and DoesEntityExist(vehicle) and controls(vehicle) and not TapeClient.playerVehicle(vehicle)
        and GetPedInVehicleSeat(vehicle,-1)==route.driver and not IsPedAPlayer(route.driver) then
        TaskVehicleDriveWander(route.driver,vehicle,route.speed,Config.Traffic.DrivingStyle)
        SetVehicleBrakeLights(vehicle,false)
    end
end
function T.isRouted(vehicle)return routes[vehicle]~=nil end
function T.stopped(vehicle,driver,spanId)
    if controls(vehicle) and driver~=0 and not IsPedAPlayer(driver) and not TapeClient.playerVehicle(vehicle) then
        stopped[vehicle]={driver=driver,model=GetEntityModel(vehicle),spanId=spanId,speed=Config.Traffic.Speed}
    end
end
local function node(p)
    local found,pos=GetClosestVehicleNodeWithHeading(p.x,p.y,p.z,1,3.0,0)
    if (found==true or found==1) and #(pos-vector3(p.x,p.y,p.z))<=Config.Traffic.MaxNodeOffset then return {x=pos.x,y=pos.y,z=pos.z} end
end
function T.canAutoDivert(vehicle,segment)
    if not Config.Traffic.Automatic then return false end
    if not Config.Traffic.DiagonalOnly then return true end
    local velocity=GetEntityVelocity(vehicle)
    local dx,dy=segment.b.x-segment.a.x,segment.b.y-segment.a.y
    local length=math.sqrt(dx*dx+dy*dy)
    local speed=math.sqrt(velocity.x*velocity.x+velocity.y*velocity.y)
    if length<.1 or speed<.2 then return false end
    -- A square-on crossing has a zero dot product. Angled tape guides traffic
    -- toward an end, but only a validated clear route is allowed to proceed.
    return math.abs((velocity.x*dx+velocity.y*dy)/(speed*length))>=Config.Traffic.DiagonalThreshold
end
local function candidateRoutes(position,segment,vehicle)
    local options={}
    if segment.detour and #segment.detour>0 then
        options[#options+1]=segment.detour
        local reversed={} for i=#segment.detour,1,-1 do reversed[#reversed+1]=segment.detour[i] end
        options[#options+1]=reversed
    end
    if T.canAutoDivert(vehicle,segment) then
        local a,b=segment.a,segment.b
        local dx,dy=b.x-a.x,b.y-a.y
        local length=math.sqrt(dx*dx+dy*dy)
        if length>0.1 then
            local ux,uy=dx/length,dy/length
            local nx,ny=-uy,ux
            local mx,my=(a.x+b.x)/2,(a.y+b.y)/2
            local sign=((position.x-mx)*nx+(position.y-my)*ny)>=0 and 1 or -1
            for _,endSide in ipairs({-1,1}) do
                local endpoint=endSide==-1 and a or b
                local x=endpoint.x+ux*endSide*Config.Traffic.EndClearance
                local y=endpoint.y+uy*endSide*Config.Traffic.EndClearance
                local cfg=Config.Traffic
                local first=node({x=x+nx*sign*cfg.SideClearance,y=y+ny*sign*cfg.SideClearance,z=position.z})
                local second=node({x=x-nx*sign*cfg.SideClearance,y=y-ny*sign*cfg.SideClearance,z=position.z})
                local last=node({x=mx-nx*sign*cfg.SideClearance*2,y=my-ny*sign*cfg.SideClearance*2,z=position.z})
                if first and second and last then options[#options+1]={first,second,last} end
            end
        end
    end
    return options
end
function T.previewRoute(vehicle,segment,segments)
    local p=GetEntityCoords(vehicle)
    local position={x=p.x,y=p.y,z=p.z}
    local best,score
    for _,route in ipairs(candidateRoutes(position,segment,vehicle)) do
        if TapeSceneTools.routeClear(position,route,segments,Config.Traffic.VehicleClearance) then
            local distance,previous=0,position
            for _,target in ipairs(route) do distance=distance+TapeGeometry.distance(previous,target);previous=target end
            if not score or distance<score then best=route;score=distance end
        end
    end
    return best
end
function T.tryDivert(vehicle,segment,segments)
    if not Config.Traffic.Enabled or routes[vehicle] or TapeClient.playerVehicle(vehicle) or not controls(vehicle) then return routes[vehicle]~=nil end
    local driver=GetPedInVehicleSeat(vehicle,-1)
    if driver==0 or IsPedAPlayer(driver) then return false end
    if Config.Traffic.SkipMissionEntities and (IsEntityAMissionEntity(vehicle) or IsEntityAMissionEntity(driver)) then return false end
    local now=GetGameTimer()
    if attempts[vehicle] and now>=attempts[vehicle] and now-attempts[vehicle]<Config.Traffic.RetryMs then return false end
    local count=0 for _ in pairs(routes) do count=count+1 end
    if count>=Config.Traffic.MaxVehicles then return false end
    attempts[vehicle]=now
    local best=T.previewRoute(vehicle,segment,segments)
    if not best then return false end
    local route={driver=driver,model=GetEntityModel(vehicle),points=best,index=1,at=now,spanId=segment.id,speed=Config.Traffic.Speed}
    routes[vehicle]=route
    stopped[vehicle]=nil
    local target=best[1]
    TaskVehicleDriveToCoordLongrange(driver,vehicle,target.x,target.y,target.z,route.speed,Config.Traffic.DrivingStyle,Config.Traffic.WaypointRadius)
    SetVehicleBrakeLights(vehicle,false)
    return true
end
function T.tick(segments)
    local ids={}
    for _,segment in ipairs(segments) do ids[segment.id]=true end
    local now=GetGameTimer()
    for vehicle,record in pairs(stopped) do
        if not DoesEntityExist(vehicle) or GetEntityModel(vehicle)~=record.model or GetPedInVehicleSeat(vehicle,-1)~=record.driver or TapeClient.playerVehicle(vehicle) or not controls(vehicle) then stopped[vehicle]=nil
        elseif not ids[record.spanId] then
            TaskVehicleDriveWander(record.driver,vehicle,record.speed,Config.Traffic.DrivingStyle);SetVehicleBrakeLights(vehicle,false);stopped[vehicle]=nil
        end
    end
    for vehicle,route in pairs(routes) do
        if not DoesEntityExist(vehicle) or GetEntityModel(vehicle)~=route.model or GetPedInVehicleSeat(vehicle,-1)~=route.driver or TapeClient.playerVehicle(vehicle) or not controls(vehicle) then finish(vehicle,false)
        elseif not Config.Traffic.Enabled or not ids[route.spanId] or now<route.at or now-route.at>Config.Traffic.RouteTimeoutMs then finish(vehicle,true)
        else
            local pos=GetEntityCoords(vehicle)
            local remaining={} for i=route.index,#route.points do remaining[#remaining+1]=route.points[i] end
            if not TapeSceneTools.routeClear({x=pos.x,y=pos.y,z=pos.z},remaining,segments,Config.Traffic.VehicleClearance) then
                finish(vehicle,false);TapeClient.haltVehicle(vehicle,route.driver);T.stopped(vehicle,route.driver,route.spanId)
            elseif #(pos-vector3(route.points[route.index].x,route.points[route.index].y,route.points[route.index].z))<=Config.Traffic.WaypointRadius then
                route.index=route.index+1
                local target=route.points[route.index]
                if not target then finish(vehicle,true)
                else TaskVehicleDriveToCoordLongrange(route.driver,vehicle,target.x,target.y,target.z,route.speed,Config.Traffic.DrivingStyle,Config.Traffic.WaypointRadius) end
            end
        end
    end
    for vehicle,at in pairs(attempts) do if not DoesEntityExist(vehicle) or now<at or now-at>Config.Traffic.RetryMs*3 then attempts[vehicle]=nil end end
end
function T.clear()
    for vehicle in pairs(routes) do finish(vehicle,true) end
    for vehicle,record in pairs(stopped) do
        if DoesEntityExist(vehicle) and GetEntityModel(vehicle)==record.model and GetPedInVehicleSeat(vehicle,-1)==record.driver and controls(vehicle) and not TapeClient.playerVehicle(vehicle) then TaskVehicleDriveWander(record.driver,vehicle,record.speed,Config.Traffic.DrivingStyle);SetVehicleBrakeLights(vehicle,false) end
    end
    stopped={};attempts={}
end
AddEventHandler('onResourceStop',function(name)if name==GetCurrentResourceName() then T.clear() end end)
