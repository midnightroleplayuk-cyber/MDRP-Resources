-- Two independent loose tails: each outer attachment stays tied, while its
-- released tip falls and the remaining length settles along the floor.
TapeTearMath={}
local M=TapeTearMath
local function lerp(a,b,u)return {x=a.x+(b.x-a.x)*u,y=a.y+(b.y-a.y)*u,z=a.z+(b.z-a.z)*u}end
local function clamp(x,a,b)return math.max(a,math.min(b,x))end
function M.nearest(paths,p)
 local best,distance=nil,math.huge
 for _,path in ipairs(paths)do
  for i=1,#path-1 do
   local a,b=path[i],path[i+1]
   local x,y,z=b.x-a.x,b.y-a.y,b.z-a.z;local length=x*x+y*y+z*z
   local u=length>0 and clamp(((p.x-a.x)*x+(p.y-a.y)*y+(p.z-a.z)*z)/length,0,1) or 0
   local q=lerp(a,b,u);local d=math.sqrt((p.x-q.x)^2+(p.y-q.y)^2+(p.z-q.z)^2)
   if d<distance then best,distance=q,d end
  end
 end
 return best,distance
end
function M.paths(a,b,f,elapsed,floorA,floorB)
 local cfg=Config.TornEnds
 local dx,dy,dz=b.x-a.x,b.y-a.y,b.z-a.z
 local span=math.sqrt(dx*dx+dy*dy+dz*dz)
 if span<.01 then return {{a},{b}} end
 f=clamp(f or .5,.01,.99)
 local gap=math.min(Config.Breakaway.TearGap*.5/span,.1)
 local cutA,cutB=lerp(a,b,math.max(0,f-gap)),lerp(a,b,math.min(1,f+gap))
 if not cfg.Enabled then
  cutA.z=cutA.z-Config.Breakaway.HangingDrop;cutB.z=cutB.z-Config.Breakaway.HangingDrop
  return {{a,cutA},{b,cutB}}
 end
 floorA=math.min(a.z-cfg.GroundClearance,floorA or a.z-cfg.FloorFallback)
 floorB=math.min(b.z-cfg.GroundClearance,floorB or b.z-cfg.FloorFallback)
 local time=math.max(0,elapsed or cfg.SettleMs)/1000
 local relax=clamp(time/(cfg.SettleMs/1000),0,1);relax=relax*relax*(3-2*relax)
 local horizontal=math.sqrt(dx*dx+dy*dy)
 local slope=(floorB-floorA)/math.max(.01,horizontal)
 local function tail(anchor,tip,floor,signedSlope)
  local x,y,z=tip.x-anchor.x,tip.y-anchor.y,tip.z-anchor.z
  local length=math.sqrt(x*x+y*y+z*z);local h=math.sqrt(x*x+y*y)
  local nx,ny=h>.001 and x/h or 1.0,h>.001 and y/h or 0.0
  local down=math.max(0,anchor.z-floor-cfg.GroundClearance)
  local samples={0,1}
  for i=1,cfg.NodesPerSide-1 do samples[#samples+1]=i/cfg.NodesPerSide end
  -- Keep the touchdown bend even with a short hanging section.
  if down>0 and down<length then
   local value=down/length;local duplicate=false
   for _,u in ipairs(samples)do if math.abs(u-value)<.000001 then duplicate=true end end
   if not duplicate then samples[#samples+1]=value end
  end
  table.sort(samples)
  local result={}
  for _,u in ipairs(samples)do
   local original=lerp(anchor,tip,u)
   local travelled=length*u
   local onFloor=math.max(0,travelled-down)/math.sqrt(1+signedSlope*signedSlope)
   local targetZ=travelled<=down and anchor.z-travelled or floor+cfg.GroundClearance+signedSlope*onFloor
   local drop=.5*cfg.Gravity*time*time*math.sqrt(u)
   local point={x=original.x+(anchor.x+nx*onFloor-original.x)*relax,
    y=original.y+(anchor.y+ny*onFloor-original.y)*relax,z=math.max(targetZ,original.z-drop)}
   -- Tiny airborne flutter dies away as a tail reaches the floor. Grounded
   -- sections remain still and the tied vertex is never displaced.
   if Config.Wind.Enabled and u>0 then
    local air=clamp((point.z-floor-cfg.GroundClearance)/.5,0,1)
    local flutter=Config.Wind.Amplitude*cfg.WindScale*air*u*math.sin(time*4+u*9)
    point.x=point.x-ny*flutter;point.y=point.y+nx*flutter
   end
   if u==0 then point={x=anchor.x,y=anchor.y,z=anchor.z} end
   result[#result+1]=point
  end
  return result
 end
 return {tail(a,cutA,floorA,slope),tail(b,cutB,floorB,-slope)}
end
