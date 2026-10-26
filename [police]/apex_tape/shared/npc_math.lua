TapeNpcMath={}
local M,G=TapeNpcMath,TapeGeometry
function M.approach(p,v,s,cfg)
 local q,f,d=TapeContactMath.nearest(p,s.a,s.b)
 if d>cfg.StartDistance or q.z<p.z+cfg.MinZ or q.z>p.z+cfg.MaxZ then return end
 local dx,dy=s.b.x-s.a.x,s.b.y-s.a.y;local length=math.sqrt(dx*dx+dy*dy)
 local speed=math.sqrt(v.x*v.x+v.y*v.y)
 if length<.1 or speed<.15 then return end
 local ux,uy=dx/length,dy/length;local nx,ny=-uy,ux
 local side=(p.x-q.x)*nx+(p.y-q.y)*ny;local normal=v.x*nx+v.y*ny
 if math.abs(normal)<.1 or side*normal>=0 then return end
 local future={x=p.x+v.x*cfg.LookAhead,y=p.y+v.y*cfg.LookAhead,z=p.z}
 if not G.sweepHit(p,future,s.a,s.b,cfg.Clearance,cfg.MinZ,cfg.MaxZ) then return end
 return {q=q,fraction=f,distance=d,sign=side>=0 and 1 or -1,ux=ux,uy=uy,nx=nx,ny=ny,
  diagonal=math.abs((v.x*ux+v.y*uy)/speed)>=cfg.DiagonalThreshold,
  goal={x=p.x+v.x/speed*cfg.WalkPastDistance,y=p.y+v.y/speed*cfg.WalkPastDistance,z=p.z}}
end
function M.routeClear(start,route,segments,cfg)
 local previous=start;local total=0
 for _,target in ipairs(route) do
  if not G.point(target) then return false end
  total=total+G.distance(previous,target)
  if total>cfg.MaxRouteDistance then return false end
  for _,s in ipairs(segments) do
   local d,u,f=G.closest2d(previous,target,s.a,s.b)
   local walkZ=previous.z+(target.z-previous.z)*u;local tapeZ=s.a.z+(s.b.z-s.a.z)*f
   if math.abs(walkZ-tapeZ)<cfg.HeightTolerance and d<cfg.Clearance then return false end
  end
  previous=target
 end
 return true
end
function M.candidates(p,s,hit,cfg)
 local result={}
 for _,sign in ipairs({-1,1}) do
  local endpoint=sign==-1 and s.a or s.b
  local x,y=endpoint.x+hit.ux*sign*cfg.EndClearance,endpoint.y+hit.uy*sign*cfg.EndClearance
  result[#result+1]={
   {x=x+hit.nx*hit.sign*cfg.SideClearance,y=y+hit.ny*hit.sign*cfg.SideClearance,z=p.z},
   {x=x-hit.nx*hit.sign*cfg.SideClearance,y=y-hit.ny*hit.sign*cfg.SideClearance,z=p.z},
   {x=hit.q.x-hit.nx*hit.sign*cfg.SideClearance*2,y=hit.q.y-hit.ny*hit.sign*cfg.SideClearance*2,z=p.z}}
 end
 return result
end
function M.pick(reactions,random)
 local total=0;for _,r in pairs(reactions) do if r.Enabled and r.Weight>0 then total=total+r.Weight end end
 if total==0 then return end
 local value=(random or math.random)()*total;local names={}
 for name in pairs(reactions) do names[#names+1]=name end;table.sort(names)
 for _,name in ipairs(names) do
  local r=reactions[name]
  if r.Enabled and r.Weight>0 then value=value-r.Weight;if value<=0 then return name,r end end
 end
end
