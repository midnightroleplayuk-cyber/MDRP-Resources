local S=TapeSettings
S.Errors,S.Warnings={},{}
local function issue(message) S.Errors[#S.Errors+1]=message end
local function merge(base,patch,path)
    for k,v in pairs(patch) do
        local key=(path or 'Config')..'.'..tostring(k)
        if base[k]~=nil and type(v)~=type(base[k]) then issue(key..' has the wrong type.')
        elseif type(v)=='table' and type(base[k])=='table' then
            if key=='Config.Permissions.Jobs' or key=='Config.Permissions.StaffGroups' or key=='Config.NpcPedestrians.Questions.Lines' then base[k]=S.copy(v) else merge(base[k],v,key) end
        else base[k]=S.copy(v) end
    end
    return base
end
-- Read the current buyer configuration format.
function S.read(user)
    if type(user)~='table' then return nil,'config.lua must define UserConfig.' end
    if user.Version~=2 then return nil,'Use Version=2 with a Settings table in config.lua.' end
    if type(user.Settings)~='table' then return nil,'UserConfig.Settings must be a table.' end
    return {Version=2,Settings=S.copy(user.Settings)}
end
Config=S.copy(S.Defaults)
local applied,err=S.read(UserConfig)
if not applied then issue(err);applied={Version=2,Settings={}} end
local chosen=applied.Settings.PerformanceProfile or Config.PerformanceProfile
local profile=Config.PerformanceProfiles[chosen]
if chosen~='custom' and not profile then issue('Unknown PerformanceProfile: '..tostring(chosen)) end
if profile then merge(Config.Performance,profile,'Config.Performance') end
merge(Config,applied.Settings)
local function range(path,min,max,integer)
    local value=Config
    for key in path:gmatch('[^.]+') do value=type(value)=='table' and value[key] or nil end
    if type(value)~='number' or value~=value or value<min or value>max or (integer and value%1~=0) then issue('Config.'..path..' must be '..min..' to '..max..(integer and ' (whole number).' or '.')) end
end
for _,rule in ipairs({{'MaxDistance',1,100},{'MinLength',0.1,10},{'MaxTapes',1,2000,true},{'MaxPerPlayer',1,500,true},{'MaxPerArea',1,500,true},{'AreaRadius',1,500},{'PlacementReach',1,150},{'EditReach',1,20},{'AimReach',1,100},{'PostHeight',0.1,5},{'LifetimeMinutes',0,525600},{'RateLimit.Count',1,1000,true},{'RateLimit.Seconds',1,600},{'Breakaway.SampleMs',50,1000,true},{'Breakaway.MinSpeedKmh',0,500},{'Breakaway.MaxSampleGapMs',50,5000,true},{'Breakaway.VehicleRadius',0.1,5},{'Breakaway.SpawnGraceSeconds',0,60},{'Breakaway.BrokenLifetimeSeconds',0,86400},{'Repair.CooldownSeconds',0,600},{'Backups.Count',1,10,true},{'Backups.IntervalSeconds',1,3600},{'Audit.MaxBytes',1024,10485760,true},{'Audit.Backups',1,10,true},{'Performance.MaxLoadedTextures',2,60,true},{'Performance.MaxVisibleTapes',1,500,true},{'Performance.BucketRefreshMs',250,10000,true},{'Placement.HeightStep',0.01,1},{'Scenes.MaxTotal',1,500,true},{'Presets.MaxSpans',1,100,true},{'Wind.Strength',0,10},{'Wind.GustStrength',0,1}}) do range(table.unpack(rule)) end
if Config.MinLength>Config.MaxDistance then issue('MinLength exceeds MaxDistance.') end
if Config.Breakaway.VehicleMinZ>Config.Breakaway.VehicleMaxZ then issue('VehicleMinZ exceeds VehicleMaxZ.') end
if Config.Placement.MinHeight>Config.Placement.MaxHeight then issue('MinHeight exceeds MaxHeight.') end
for _,rule in ipairs({{'Access.DurationSeconds',1,300},{'Access.MaxDurationSeconds',1,300},{'Access.MaxHoldSeconds',1,600},{'Access.OccupancyRadius',0.1,10},{'Access.OccupancyDelaySeconds',1,30},{'Access.LiftHeight',0.3,5},{'Templates.MaxPerPlayer',1,100,true},{'Templates.MaxTotal',1,1000,true},{'Templates.MaxSpans',1,200,true},{'Templates.MaxRadius',1,100},{'Attachments.CheckMs',50,5000,true},{'Attachments.MissingGraceMs',0,30000,true},{'Attachments.MaxAnchorTravel',0.1,500},{'Attachments.MaxVehicleSpeedKmh',0,500},{'Tension.MaxStretch',1.01,3},{'Tension.BreakDelayMs',0,30000,true},{'Tension.ReferenceSpan',0.1,100},{'Tension.SagAtReference',0,5},{'Tension.MaxSag',0,10},{'Deployment.DurationMs',250,15000,true},{'Deployment.TicketLifetimeMs',1000,120000,true},{'Deployment.MaxMovement',0.1,10},{'Traffic.StartDistance',1,100},{'Traffic.Speed',0.5,30},{'Traffic.VehicleClearance',0.1,10},{'Traffic.MaxVehicles',1,100,true},{'Traffic.MaxWaypoints',1,30,true},{'Traffic.MaxRouteDistance',10,1000}}) do range(table.unpack(rule)) end
if Config.Access.DurationSeconds>Config.Access.MaxDurationSeconds or Config.Access.MaxDurationSeconds>Config.Access.MaxHoldSeconds then issue('Access durations must not exceed the total hold limit.') end
if Config.Deployment.TicketLifetimeMs<Config.Deployment.DurationMs+4000 then issue('Deployment ticket must allow time for animation/model loading.') end
if Config.Attachments.OnUnsafe~='freeze' and Config.Attachments.OnUnsafe~='tear' then issue('Attachments.OnUnsafe must be freeze or tear.') end
for _,key in ipairs({'Confirm','Cancel','HeightUp','HeightDown','Left','Right','StartModifier','StartButton','AccessButton'}) do range('Controller.'..key,0,359,true) end
if Config.Inventory.Enabled and not ({ox=true,qb=true,esx=true,custom=true})[Config.Inventory.System] then issue('Inventory.System must be ox, qb, esx or custom.') end
for _,gate in ipairs({'Departments','Jobs'}) do if not ({qb=true,esx=true,custom=true,auto=true})[Config[gate].Framework] then issue(gate..'.Framework must be qb, esx, custom or auto.') end end
for name,rule in pairs(Config.Departments.Rules) do
    if type(rule)~='table' then issue('Invalid department rule: '..tostring(name))
    else
        if type(rule.MinGrade)~='number' or rule.MinGrade<0 then issue('Department MinGrade must be non-negative: '..tostring(name)) end
        if type(rule.MaxTapes)~='number' or rule.MaxTapes<1 or rule.MaxTapes>500 then issue('Department MaxTapes is invalid: '..tostring(name)) end
        if type(rule.DefaultStyle)~='string' or not Config.TapeStyles[rule.DefaultStyle] then issue('Department DefaultStyle is invalid: '..tostring(name)) end
    end
end
if not TapeMessages and Config.Locale~='en' and Config.Locale~='fr' and Config.Locale~='de' then S.Warnings[#S.Warnings+1]='Unsupported locale; using English fallback.' end
for name,p in pairs(Config.Breakaway.Profiles) do
    if p.Enabled~=false then
        for _,key in ipairs({'MinSpeedKmh','Radius','MinZ','MaxZ'}) do if type(p[key])~='number' or p[key]~=p[key] or math.abs(p[key])>1000 then issue('Invalid vehicle profile '..name..'.'..key) end end
        if type(p.Radius)=='number' and p.Radius<=0 then issue('Vehicle profile radius must be positive: '..name) end
    end
end
local enabled=0 for _,style in pairs(Config.TapeStyles) do if style.enabled~=false then enabled=enabled+1 end end
if enabled==0 or not Config.TapeStyles.police or Config.TapeStyles.police.enabled==false then issue('Keep the police fallback style enabled.') end
if not ({standalone=true,qb=true,esx=true,custom=true,auto=true})[Config.Permissions.Framework] then issue('Permissions.Framework must be standalone, qb, esx, custom or auto.') end
if not ({public=true,jobs=true,staff=true,jobs_or_staff=true,ace=true,custom=true})[Config.Permissions.Mode] then issue('Unknown Permissions.Mode.') end
for name,grade in pairs(Config.Permissions.Jobs) do if type(name)~='string' or type(grade)~='number' or grade<0 then issue('Permissions.Jobs must map names to non-negative grades.') end end
for _,rule in ipairs({{'Access.RaiseMs',100,10000,true},{'Access.LowerMs',100,10000,true},{'Access.HoldReach',0.5,3},{'Access.MaxMovement',0.1,3},{'Access.MaxAnchorMovement',0.1,5},{'Access.HandHeight',0.3,3},{'Access.MinLift',0.05,2},{'Access.HandFollowDistance',0.1,3},{'Access.AnimLoadTimeoutMs',500,10000,true}}) do range(table.unpack(rule)) end
range('Placement.GroundBelowPed',0.1,1.5)
range('Placement.LevelSnapTolerance',.005,.2)
range('Placement.SurfaceSnapDistance',.005,.2)
range('Placement.SurfaceProbeDistance',.1,1)
range('Target.AimRadius',0.1,1.5)
range('Target.AimDistance',2,30)
range('Traffic.DiagonalThreshold',.05,.95)
if Config.Access.LiftHeight<Config.Access.MinLift then issue('Access.LiftHeight must allow Access.MinLift.') end
for _,rule in ipairs({{'Contact.SampleMs',50,1000,true},{'Contact.MaxVehiclesPerTick',1,256,true},{'Contact.MaxVehicleSampleGapMs',100,5000,true},{'Contact.MaxContactsPerTape',1,6,true},{'Contact.ScanDistance',5,100},{'Contact.Spring',1,150},{'Contact.Damping',1,40},{'Contact.Pedestrians.Radius',.1,2},{'Contact.Pedestrians.MaxDeflection',.1,3},{'Contact.Pedestrians.Width',.1,3},{'Contact.Pedestrians.TearSpeed',1,15},{'Contact.Pedestrians.Resistance',.1,1},{'Contact.Vehicles.Radius',.1,5},{'Contact.Vehicles.HalfLength',.1,10},{'Contact.Vehicles.MaxDeflection',.1,5},{'Contact.Vehicles.Width',.1,5},{'Contact.Vehicles.TearSpeed',.1,60},{'Contact.Vehicles.StretchTearMs',100,10000,true},{'AttachmentVisual.SurfaceOffset',.001,.05},{'AttachmentVisual.TabLength',.03,.5},{'AttachmentVisual.MaxWrapRadius',.04,.45}}) do range(table.unpack(rule)) end
if Config.Contact.Pedestrians.MinZ>=Config.Contact.Pedestrians.MaxZ then issue('Contact pedestrian height band is invalid.') end
if Config.Contact.SampleMs>=Config.Breakaway.MaxSampleGapMs or Config.Contact.SampleMs>=Config.Contact.MaxVehicleSampleGapMs then issue('Contact.SampleMs must be below the pedestrian/vehicle stale-sample limits.') end
Config.Command=Config.Commands.ptape
local commandNames={}
for id,name in pairs(Config.Commands) do
    if not S.Defaults.Commands[id] then issue('Unknown command identifier: '..tostring(id)) end
    if type(name)~='string' or not name:match('^[%w_%-]+$') or #name>40 then issue('Command '..tostring(id)..' must be 1-40 letters/numbers/underscores/hyphens without a slash.')
    elseif commandNames[name:lower()] then issue('Duplicate command name: '..name) else commandNames[name:lower()]=true end
end
if not ({ox=true,custom=true})[Config.Target.System] then issue('Target.System must be ox or custom.') end
if not ({authorized=true,owner=true})[Config.Target.RemovePolicy] then issue('Target.RemovePolicy must be authorized or owner.') end
for _,rule in ipairs({{'Target.Distance',.5,5},{'Target.StreamDistance',5,100},{'Target.RefreshMs',100,5000,true},{'Target.PermissionRefreshMs',1000,30000,true},{'Target.SegmentLength',1,10},{'Target.Width',.1,3},{'Target.Height',.1,3},{'Target.MaxZones',1,300,true},{'Target.MaxTapes',1,64,true},{'Target.MoveThreshold',.05,2}}) do range(table.unpack(rule)) end
for _,rule in ipairs({{'Polish.SoundDistance',1,50},{'Polish.FoldLength',.05,.3},{'Polish.PreviewDistance',5,80},{'Polish.PreviewVehicles',1,20,true},{'Polish.PreviewEveryMs',100,2000,true},{'Polish.PromptScale',1,1.6},{'Polish.MaxPromptScale',1,1.6},{'Polish.MaxAimRadius',.1,1.5},{'Polish.HoldControl',0,360,true},{'Polish.HoldGraceMs',250,5000,true},{'Polish.MaxFavourites',1,30,true},{'Polish.ReachMs',100,1500,true},{'Polish.RecoverSeconds',0,120,true},{'Polish.MaxRecoverySpans',1,500,true},{'Polish.MaxRecoveries',1,100,true},{'Cutting.DurationMs',300,10000,true},{'Cutting.RemnantMs',500,5000,true},{'RepairInteraction.DurationMs',300,10000,true},{'RepairInteraction.Reach',.5,3}})do range(table.unpack(rule))end
if Config.Polish.LiftMode~='toggle' and Config.Polish.LiftMode~='hold' then issue('Polish.LiftMode must be toggle or hold.')end
if Config.Polish.ReachMs>Config.Access.RaiseMs then issue('Polish.ReachMs cannot exceed Access.RaiseMs.')end
range('Contact.Pedestrians.MaxObservedSpeed',4,20)
range('Breakaway.TearGap',.1,2)
for _,rule in ipairs({{'Editor.Distance',5,150},{'Editor.MaxTapes',1,64,true},{'Editor.MaxObjects',16,1024,true},{'Editor.UpdateMs',50,1000,true}}) do range(table.unpack(rule)) end
if not ({on=true,off=true,auto=true})[Config.Editor.Mode] then issue('Editor.Mode must be on, off or auto.') end
range('Access.IkArm',3,4,true)
range('Access.GripForward',0,.5)
range('Access.GripSide',-.4,.4)
range('CustomText.MaxLength',1,100,true)
range('CustomText.MaxUnique',1,16,true)
if Config.Access.Pose~='one_hand' and Config.Access.Pose~='animation' then issue('Access.Pose must be one_hand or animation.') end
for _,key in ipairs({'Background','Foreground'}) do
 if type(Config.CustomText[key])~='string' or not Config.CustomText[key]:match('^#%x%x%x%x%x%x$') then issue('CustomText.'..key..' must be a six-digit hex colour.') end
end
range('Contact.Pedestrians.StandOff',.05,.5)
range('Contact.Pedestrians.MaxCorrection',.01,.2)
range('Contact.Pedestrians.MotionWindowMs',100,500,true)
range('Access.AnchorInset',.05,.5)
range('Contact.Vehicles.MaxObservedSpeed',10,150)
range('Contact.Vehicles.MotionWindowMs',100,500,true)
for _,rule in ipairs({{'NpcPedestrians.UpdateMs',100,2000,true},{'NpcPedestrians.ScanDistance',10,150},{'NpcPedestrians.MaxPedsPerTick',1,128,true},{'NpcPedestrians.MaxActive',1,128,true},{'NpcPedestrians.MaxTapes',1,128,true},{'NpcPedestrians.StartDistance',2,20},{'NpcPedestrians.LookAhead',.5,6},{'NpcPedestrians.HeightTolerance',.5,5},{'NpcPedestrians.DiagonalThreshold',.05,.95},{'NpcPedestrians.Clearance',.1,1},{'NpcPedestrians.StopDistance',.8,5},{'NpcPedestrians.EndClearance',1,8},{'NpcPedestrians.SideClearance',1,6},{'NpcPedestrians.WalkPastDistance',4,20},{'NpcPedestrians.MaxRouteDistance',10,200},{'NpcPedestrians.MaxSnapDistance',.1,3},{'NpcPedestrians.WalkSpeed',.5,1.5},{'NpcPedestrians.WaypointRadius',.2,1.5},{'NpcPedestrians.RouteTimeoutMs',5000,60000,true},{'NpcPedestrians.MinDwellMs',1000,120000,true},{'NpcPedestrians.MaxDwellMs',1000,120000,true},{'NpcPedestrians.RetryMs',1000,30000,true},{'NpcPedestrians.CooldownMs',10000,600000,true},{'NpcPedestrians.DepartureDistance',3,20},{'NpcPedestrians.ReactionChance',0,1},{'NpcPedestrians.MaxReactions',0,32,true},{'NpcPedestrians.MaxPerScene',0,16,true},{'NpcPedestrians.Questions.PlayerDistance',2,15},{'NpcPedestrians.Questions.DrawDistance',2,30},{'NpcPedestrians.Questions.DisplayMs',1000,10000,true},{'NpcPedestrians.Questions.GlobalCooldownMs',2000,60000,true},{'NpcPedestrians.Questions.PedCooldownMs',10000,600000,true}})do range(table.unpack(rule))end
if Config.NpcPedestrians.MinDwellMs>Config.NpcPedestrians.MaxDwellMs then issue('NPC minimum dwell exceeds maximum dwell.') end
if Config.NpcPedestrians.MinZ>=Config.NpcPedestrians.MaxZ then issue('NPC height band is invalid.') end
if Config.NpcPedestrians.StopDistance<=Config.NpcPedestrians.Clearance then issue('NPC stop distance must exceed tape clearance.') end
range('NpcPedestrians.NavFlags',0,65535,true)
range('NpcPedestrians.StopApproachMs',1000,15000,true)
range('NpcPedestrians.ProgressTimeoutMs',2000,30000,true)
for name,r in pairs(Config.NpcPedestrians.Reactions) do
 if type(r)~='table' or type(r.Enabled)~='boolean' or type(r.Weight)~='number' or r.Weight~=r.Weight or r.Weight<0 or r.Weight>1000 or type(r.Scenario)~='string' or #r.Scenario>100 or not r.Scenario:match('^[%w_]*$') then issue('Invalid NPC reaction: '..tostring(name)) end
end
if Config.NpcPedestrians.Questions.Enabled and #Config.NpcPedestrians.Questions.Lines<1 or #Config.NpcPedestrians.Questions.Lines>20 then issue('NPC questions require 1-20 lines.') end
for _,line in ipairs(Config.NpcPedestrians.Questions.Lines) do if type(line)~='string' or #line<1 or #line>160 or line:find('%c') then issue('NPC question lines must be 1-160 printable bytes.') end end
if type(Config.NpcPedestrians.Questions.SpeechName)~='string' or not Config.NpcPedestrians.Questions.SpeechName:match('^[%w_]*$') then issue('Invalid NPC stock speech name.') end
for _,rule in ipairs({{'TornEnds.Gravity',.5,30},{'TornEnds.SettleMs',500,10000,true},{'TornEnds.NodesPerSide',2,16,true},{'TornEnds.GroundClearance',.02,.15},{'TornEnds.FloorFallback',.1,5},{'TornEnds.WindScale',0,.5},{'TornEnds.ProbeDepth',2,50},{'TornEnds.GroundQueriesPerTick',1,4,true},{'TornEnds.MaxGroundSpans',1,64,true}})do range(table.unpack(rule))end
for _,rule in ipairs({{'Adjustment.Step',.01,.25},{'Adjustment.MaxSteps',1,10,true},{'Adjustment.Tight',.98,1},{'Adjustment.Loose',1,1.08},{'LooseEnds.Reach',.5,3},{'LooseEnds.MaxWalk',1,30},{'LooseEnds.StretchAllowance',0,.5},{'LooseEnds.MaxCarriers',1,16,true},{'LooseEnds.UpdateMs',100,1000,true},{'LooseEnds.MaxHoldSeconds',5,300,true},{'LooseEnds.HandHeight',0,.5},{'LooseEnds.Forward',0,.6},{'Passage.Reach',.5,3},{'Passage.Distance',.8,2},{'Passage.DurationMs',2000,8000,true},{'Passage.Speed',.5,1.2},{'Passage.CooldownMs',1000,30000,true},{'Inspection.Reach',.5,3},{'AnchorFailure.VehicleSpeed',1,50},{'AnchorFailure.FootSpeed',2,20},{'AnchorFailure.PullRatio',1.01,2},{'AnchorFailure.Drop',.1,1.5},{'AnchorFailure.PullDistance',0,1},{'WeatherWear.TickMs',1000,30000,true},{'WeatherWear.MaxPerTick',1,256,true},{'WeatherWear.MaxStepSeconds',1,60},{'WeatherWear.WindFactor',0,.2},{'WeatherWear.MaxStretch',0,.08},{'WeatherWear.TearAt',.1,1},{'WeatherWear.PublishStep',.001,.2}})do range(table.unpack(rule))end
for name,rate in pairs(Config.WeatherWear.Rates)do if type(name)~='string' or not name:match('^[A-Z_]+$') or (type(rate)~='number' or rate~=rate or rate<0 or rate>.1) then issue('Invalid weather wear rate.') end end
range('LooseEnds.DropMs',300,3000,true)
range('WeatherWear.DefaultWind',0,20)
range('Passage.MinRelativeHeight',-1.2,0)
range('Passage.MaxRelativeHeight',.1,2)
range('Passage.DuckAbove',-.1,1)
if Config.WeatherWear.Weather~='auto' and not Config.WeatherWear.Rates[Config.WeatherWear.Weather] then issue('Choose a known WeatherWear.Weather or auto.')end
if not Config.WeatherWear.Rates[Config.WeatherWear.DefaultWeather] then issue('WeatherWear.DefaultWeather must have a configured rate.')end
for _,name in ipairs(Config.AnchorFailure.Models)do if type(name)~='string' or #name>80 or not name:match('^[%w_]+$') then issue('Anchor failure models must be explicit model names.')end end
S.Valid=#S.Errors==0
for _,message in ipairs(S.Errors) do print('[APEX Tape CONFIG ERROR] '..message) end

-- Keep stock design identities and asset paths consistent.
for id,style in pairs(Config.TapeStyles) do
    local shipped=S.Defaults.TapeStyles[id]
    if shipped then
        style.label,style.text=shipped.label,shipped.text
        style.image=({police='textures/police_tape.png',fire='textures/fire_tape.png',ambulance='textures/ambulance_tape.png',crime='textures/crime_tape.png'})[id] or ('textures/'..id..'.png')
        style.preview='../../'..style.image
    end
end

Config.Version=S.Defaults.Version -- Installed release identity
Config.Build=S.Defaults.Build

if not (applied.Settings.PoleWrap and applied.Settings.PoleWrap.maxRadius) then
    Config.PoleWrap.maxRadius=Config.AttachmentVisual.MaxWrapRadius
end
