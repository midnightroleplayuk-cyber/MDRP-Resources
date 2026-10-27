-- Physical recording geometry. No runtime texture replacement or non-uniform scale.
TapeEditorMath={}
local M=TapeEditorMath
function M.model(style,length)
 local entry=Config.TapeStyles[style]
 local image=entry and entry.image
 local stem=image and image:match('^textures/([%w_]+)%.png$')
 if not stem or not TapeEditorTextures[stem] then return nil end
 local cm=math.max(5,math.min(150,math.ceil((length-.00001)*20)*5))
 return ('apex_t_%s_%03d'):format(stem,cm)
end
function M.segments(t,a,b,now,contacts,brokenElapsed)
 if t.customText then return nil end -- Runtime wording is not baked into replay models.
 local parts={};local lerp=TapeAccessMath.lerp
 if t.brokenAt then
  local paths=TapeEnhanceMath.paths(t,a,b,brokenElapsed or Config.TornEnds.SettleMs,t.tearFloorA,t.tearFloorB)
  for _,path in ipairs(paths)do
   for i=1,#path-1 do parts[#parts+1]={path[i],path[i+1]} end
  end
 elseif t.accessHold then
  local h=t.accessHold
  local grip=TapeAccessMath.grip(a,b,h,math.max(0,now-h.started))
  parts={{a,grip},{grip,b}}
 elseif t.openUntil then
  local l,r=lerp(a,b,.2),lerp(a,b,.8)
  l.z=l.z+Config.Access.LiftHeight;r.z=r.z+Config.Access.LiftHeight
  parts={{a,l},{l,r},{r,b}}
 else parts={{a,b}} end
 local result={}
 for _,part in ipairs(parts) do
  local start,finish=part[1],part[2]
  local length=TapeGeometry.distance(start,finish)
  local count=math.max(1,math.ceil(length/1.25))
  local sag=not t.brokenAt and not t.accessHold and TapeSceneTools.sag(length,t.restLength) or 0
  local function point(f)
   local p=lerp(start,finish,f);local belly=math.sin(math.pi*f)
   p.z=p.z-sag*belly
   if Config.Wind.Enabled and not t.brokenAt then
    local amount=Config.Wind.Amplitude*Config.Wind.Strength*belly
    local sway=math.sin(now*.001*Config.Wind.Speed+f*6.8)*amount
    p.x=p.x-(finish.y-start.y)/math.max(length,.01)*sway
    p.y=p.y+(finish.x-start.x)/math.max(length,.01)*sway
    p.z=p.z+math.sin(now*.001*Config.Wind.Speed*.82+f*4.2)*amount*Config.Wind.VerticalRatio
   end
   if #parts==1 and not t.brokenAt then
    for _,c in ipairs(contacts or {}) do
     local weight=math.max(0,1-math.abs(f-c.fraction)*length/math.max(.1,c.width))
     p.x=p.x+c.x*weight;p.y=p.y+c.y*weight;p.z=p.z+(c.z or 0)*weight
    end
   end
   return p
  end
  local prev=point(0)
  for i=1,count do
   local p=point(i/count);local dx,dy,dz=p.x-prev.x,p.y-prev.y,p.z-prev.z
   local len=math.sqrt(dx*dx+dy*dy+dz*dz)
   -- Extreme contact stretching must not leave gaps hidden by clamping a model.
   if len>1.5 then return nil end
   result[#result+1]={length=len,model=M.model(t.style,len),x=(prev.x+p.x)/2,y=(prev.y+p.y)/2,z=(prev.z+p.z)/2,
    pitch=-math.deg(math.atan(dz,math.sqrt(dx*dx+dy*dy))),yaw=math.deg(math.atan(dy,dx))}
   prev=p
  end
 end
 return result
end
