-- Optional local preferences, accessibility, preview arrows and short-lived cut visuals.
TapePolishClient={}
local P,C=TapePolishClient,Config.Polish
local settings={scale=C.PromptScale,aim=Config.Target.AimRadius,lift=C.LiftMode,preview=C.TrafficPreview}
local favourites,ghosts={},{}
local lastPrompt,lastScale=nil,nil
local previewCache={at=0,vehicles={}}
local previewFrame,previewWork=-1,0
local function notify(text,kind)TapeClient.notify(text,kind or 'inform')end
local function finite(n,lo,hi)return TapeGeometry.finite(n) and n>=lo and n<=hi end
local function save()
 SetResourceKvp('apex_tape:comfort',json.encode(settings))
 SetResourceKvp('apex_tape:favourites',json.encode(favourites))
end
local function decode(name)
 local raw=GetResourceKvpString(name)
 if type(raw)~='string' or #raw>32768 then return end
 local ok,value=pcall(json.decode,raw);if ok and type(value)=='table' then return value end
end
local function validPerimeter(p)
 return type(p)=='table' and ({rectangle=true,circle=true,road=true})[p.kind] and finite(p.width,1,Config.Presets.MaxDimension)
 and finite(p.length,p.kind=='rectangle' and 1 or 0,Config.Presets.MaxDimension) and finite(p.spacing,Config.Presets.MinSpacing,Config.Presets.MaxSpacing) and finite(p.heading,-36000,36000)
end
local function validFavourite(f)
 return type(f)=='table' and Config.TapeStyles[f.style] and finite(f.height,Config.Placement.MinHeight,Config.Placement.MaxHeight)
 and finite(f.slack,.98,1.08) and (f.perimeter==nil or validPerimeter(f.perimeter))
end
local stored=decode('apex_tape:comfort')
if stored then
 if finite(stored.scale,1,C.MaxPromptScale) then settings.scale=stored.scale end
 if finite(stored.aim,.1,C.MaxAimRadius) then settings.aim=stored.aim end
 if stored.lift=='hold' or stored.lift=='toggle' then settings.lift=stored.lift end
 if type(stored.preview)=='boolean' then settings.preview=stored.preview end
end
local saved=decode('apex_tape:favourites')
if saved then local n=0;for name,f in pairs(saved) do if type(name)=='string' and #name<=32 and validFavourite(f) and n<C.MaxFavourites then favourites[name]=f;n=n+1 end end end
function P.aimRadius()return C.Enabled and math.min(C.MaxAimRadius,settings.aim) or Config.Target.AimRadius end
function P.liftMode()return settings.lift end
function P.largePrompt()return C.Enabled and settings.scale>1 end
function P.preferences()return {scale=settings.scale,lift=settings.lift}end
function P.prompt(text)
 if TapeClient and TapeClient.fieldKitPlacement and TapeClient.fieldKitPlacement() then
  if lib and lib.hideTextUI then lib.hideTextUI() end
  if lastPrompt~=nil then SendNUIMessage({action='polishPrompt'});lastPrompt=nil end
  return true
 end
 if not C.Enabled then return false end
 if text~=lastPrompt or lastScale~=settings.scale then
  SendNUIMessage({action='polishPrompt',text=settings.scale>1 and text or nil,scale=settings.scale})
  lastPrompt,lastScale=text,settings.scale
 end
 if settings.scale>1 and lib and lib.hideTextUI then lib.hideTextUI() end
 return settings.scale>1
end
function P.sound()
 if C.Enabled and C.Sound and type(PlaySoundFrontend)=='function' then PlaySoundFrontend(-1,C.SoundName,C.SoundSet,true) end
end
function P.command(id,args)
 if not C.Enabled then notify('Polish features are disabled.','error');return end
 local action=args[1]
 if id=='tapehandover' then
  local scene=TapeClient.scene();if not scene then notify('Select a scene first.','error');return end
  local p={sceneId=scene}
  if action=='department' then p.department=args[2] else p.target=tonumber(action) end
  if TapeClient.accessAction('handover',p) then notify('Scene handed over.','success') end
 elseif id=='taperecover' then
  local result=TapeClient.accessAction('recover',{});if result then TapeClient.selectScene(result.sceneId);notify('Scene restored.','success') end
 elseif id=='tapetension' then
  local slack=({tight=.98,normal=1,loose=1.06})[action] or tonumber(action)
  if not finite(slack,.98,1.08) then notify('Use tight, normal, loose or a slack ratio from 0.98 to 1.08.','error');return end
  TapeClient.preferences({slack=slack});notify('Tension updated for new spans.')
 elseif id=='tapetrafficpreview' then settings.preview=not settings.preview;save();notify(settings.preview and 'Traffic preview on.' or 'Traffic preview off.')
 elseif id=='tapecomfort' then
  if action=='scale' and finite(tonumber(args[2]),1,C.MaxPromptScale) then settings.scale=tonumber(args[2])
  elseif action=='target' and finite(tonumber(args[2]),.1,C.MaxAimRadius) then settings.aim=tonumber(args[2])
  elseif action=='lift' and (args[2]=='hold' or args[2]=='toggle') then settings.lift=args[2]
  else notify('Use scale 1–1.6 / target 0.1–1.0 / lift hold|toggle.','error');return end
  save();if TapeClient.refreshPrompt then TapeClient.refreshPrompt() end;notify('Accessibility preference saved.')
 elseif id=='tapefavourite' then
  local name=table.concat(args,' ',2):gsub('%c',''):sub(1,32)
  if action=='list' then local names={};for n in pairs(favourites)do names[#names+1]=n end;table.sort(names);notify(#names>0 and table.concat(names,', ') or 'No favourites saved.');return end
  if name=='' then notify('Use save/load/delete NAME, or list.','error');return end
  if action=='save' then
   local n=0;for _ in pairs(favourites)do n=n+1 end
   if n>=C.MaxFavourites and not favourites[name] then notify('Favourite limit reached.','error');return end
   local f=TapeSettings.copy(TapeClient.preferences())
   if f.perimeter and f.perimeter.kind=='template' then f.perimeter=nil end
   if not validFavourite(f) then notify('Choose a valid design, height and perimeter first.','error');return end
   favourites[name]=f;save();notify('Favourite saved.')
  elseif action=='load' and validFavourite(favourites[name]) then
   local f=favourites[name]
   if f.perimeter and not TapeClient.scene() then notify('Select a scene before loading a perimeter favourite.','error');return end
   TapeClient.preferences(TapeSettings.copy(f));notify('Favourite loaded; confirm placement normally.')
  elseif action=='delete' then favourites[name]=nil;save();notify('Favourite deleted.')
  else notify('Favourite unavailable.','error') end
 end
end
local function arrow(a,b,r,g,bcol)
 DrawLine(a.x,a.y,a.z,b.x,b.y,b.z,r,g,bcol,220)
 local d=b-a;local l=math.sqrt(d.x*d.x+d.y*d.y);if l<.05 then return end
 local back=vector3(d.x/l,d.y/l,0)*.65;local side=vector3(-d.y/l,d.x/l,0)*.3
 local p,q=b-back+side,b-back-side
 DrawLine(b.x,b.y,b.z,p.x,p.y,p.z,r,g,bcol,220);DrawLine(b.x,b.y,b.z,q.x,q.y,q.z,r,g,bcol,220)
end
function P.previewTraffic(a,b)
 if not C.Enabled or not settings.preview or not Config.BlockAiTraffic then return end
 local now=GetGameTimer()
 local frame=type(GetFrameCount)=='function' and GetFrameCount() or now
 if previewFrame~=frame then previewFrame=frame;previewWork=0 end
 if previewWork>=C.PreviewVehicles then return end
 if now-previewCache.at>=C.PreviewEveryMs then
  previewCache.at=now;previewCache.vehicles={};previewCache.routes={}
  local pos=GetEntityCoords(PlayerPedId())
  for _,vehicle in ipairs(GetGamePool('CVehicle'))do
   if #previewCache.vehicles>=C.PreviewVehicles then break end
   if DoesEntityExist(vehicle) and #(GetEntityCoords(vehicle)-pos)<=C.PreviewDistance and not TapeClient.playerVehicle(vehicle) and not (Config.Traffic.SkipMissionEntities and (IsEntityAMissionEntity(vehicle) or (GetPedInVehicleSeat(vehicle,-1)~=0 and IsEntityAMissionEntity(GetPedInVehicleSeat(vehicle,-1))))) then previewCache.vehicles[#previewCache.vehicles+1]=vehicle end
  end
 end
 local span={id=-1,a={x=a.x,y=a.y,z=a.z},b={x=b.x,y=b.y,z=b.z}}
 for _,vehicle in ipairs(previewCache.vehicles)do if DoesEntityExist(vehicle) then
  local start=GetEntityCoords(vehicle);local velocity=GetEntityVelocity(vehicle)
  local l=math.sqrt(velocity.x^2+velocity.y^2)
  local _,_,fraction=TapeGeometry.closest2d(start,start,span.a,span.b)
  local aim=a+(b-a)*fraction
  if previewWork<C.PreviewVehicles and l>.2 and math.abs(start.z-aim.z)<5 and velocity.x*(aim.x-start.x)+velocity.y*(aim.y-start.y)>0 then
   previewWork=previewWork+1
   start=vector3(start.x,start.y,start.z+.4)
   local segments={span}
   for _,t in pairs(TapeClient.tapes())do if not t.brokenAt and not t.accessOpen then local x,y=TapeClient.liveEnds(t);segments[#segments+1]={a={x=x.x,y=x.y,z=x.z},b={x=y.x,y=y.y,z=y.z}} end end
   local signature=('%d:%.1f:%.1f:%.1f:%.1f'):format(vehicle,a.x,a.y,b.x,b.y)
   previewCache.routes=previewCache.routes or {}
   if previewCache.routes[signature]==nil then previewCache.routes[signature]=TapeTraffic and TapeTraffic.previewRoute(vehicle,span,segments) or false end
   local route=previewCache.routes[signature]
   if route then
    local previous=start
    for _,point in ipairs(route)do local target=vector3(point.x,point.y,start.z);arrow(previous,target,230,192,93);previous=target end
   else
    local stop=aim-vector3(velocity.x/l,velocity.y/l,0)*(Config.AiBlock.hardStopDistance or 2.6)
    arrow(start,vector3(stop.x,stop.y,start.z),230,80,75)
   end
  end
 end end
end
RegisterNetEvent('apex_policetape:cutVisual',function(record)
 if not C.Enabled or type(record)~='table' or not TapeGeometry.point(record.a) or not TapeGeometry.point(record.b) or not Config.TapeStyles[record.style] then return end
 if #ghosts>=12 then table.remove(ghosts,1) end
 local a,b=vector3(record.a.x,record.a.y,record.a.z),vector3(record.b.x,record.b.y,record.b.z)
 local pos=GetEntityCoords(PlayerPedId())
 if #(pos-(a+b)*.5)>Config.DrawDistance+#(b-a)*.5 then return end
 record.at=GetGameTimer();ghosts[#ghosts+1]=record
 local d=TapeGeometry.closest2d(pos,pos,record.a,record.b)
 if d<=C.SoundDistance and math.abs(pos.z-(a.z+b.z)*.5)<5 then P.sound() end
end)
CreateThread(function()while true do
 if #ghosts==0 then Wait(200) else
  for i=#ghosts,1,-1 do local t=ghosts[i];local age=GetGameTimer()-t.at
   if age>Config.Cutting.RemnantMs then table.remove(ghosts,i)
   else TapeClient.drawRemnant(t,math.min(.65,(age/1000)^2*.3)) end
  end
  Wait(0)
 end
end end)
AddEventHandler('onResourceStop',function(name)if name==GetCurrentResourceName() then ghosts={};SendNUIMessage({action='polishPrompt'})end end)
