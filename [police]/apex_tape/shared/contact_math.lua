-- Pure contact geometry used by authoritative samplers and rendering tests.
TapeContactMath={}
local M=TapeContactMath
function M.nearest(p,a,b)
 local x,y=b.x-a.x,b.y-a.y;local l=x*x+y*y
 local f=l>0 and math.max(0,math.min(1,((p.x-a.x)*x+(p.y-a.y)*y)/l)) or .5
 local q={x=a.x+x*f,y=a.y+y*f,z=a.z+(b.z-a.z)*f}
 return q,f,math.sqrt((p.x-q.x)^2+(p.y-q.y)^2)
end
function M.direction(previous,current,a,b)
 local x,y=b.x-a.x,b.y-a.y;local l=math.sqrt(x*x+y*y)
 if l<.001 then return {x=0,y=0} end
 local nx,ny=-y/l,x/l
 local q=M.nearest(previous,a,b)
 local side=(previous.x-q.x)*nx+(previous.y-q.y)*ny
 if math.abs(side)<.01 then side=-((current.x-previous.x)*nx+(current.y-previous.y)*ny) end
 local sign=side>0 and -1 or 1
 return {x=nx*sign,y=ny*sign}
end
function M.weight(t,f,width,length)
 if t<=0 or t>=1 then return 0 end
 local d=math.abs(t-f)*length
 local anchor=math.min(1,t*length/math.max(.01,width*.5),(1-t)*length/math.max(.01,width*.5))
 if d<=width*.35 then return anchor end
 local u=math.max(0,1-(d-width*.35)/math.max(.01,width*.65))
 return u*u*(3-2*u)*anchor
end
-- A short, bounded local correction for walking into intact tape. Never clamps
-- movement along the ribbon or beyond its ends, and never changes player Z.
function M.walkConstraint(previous,p,a,b,v,cfg,side,budget)
 local dx,dy=b.x-a.x,b.y-a.y;local length=math.sqrt(dx*dx+dy*dy)
 if length<.01 then return nil,nil,nil end
 local nx,ny=-dy/length,dx/length
 local f=((p.x-a.x)*dx+(p.y-a.y)*dy)/(length*length)
 if f<=0 or f>=1 then return nil,nil,nil end
 local signed=(p.x-a.x)*nx+(p.y-a.y)*ny
 if math.abs(signed)>cfg.Radius+.35 then return nil,nil,nil end
 if not side then
  local old=(previous.x-a.x)*nx+(previous.y-a.y)*ny
  if math.abs(old)<.01 then old=-(v.x*nx+v.y*ny) end
  side=old>=0 and 1 or -1
 end
 -- A stationary/retreating player must not be continuously warped away
 -- merely for standing near the ribbon. Only resist an inward approach.
 local normalSpeed=(v.x*nx+v.y*ny)*side
 local normalStep=((p.x-previous.x)*nx+(p.y-previous.y)*ny)*side
 if math.abs(normalSpeed)<.01 and math.abs(normalStep)<.001 then return nil,nil,nil end
 if signed*side>=0 and normalSpeed>=-.01 and normalStep>=-.001 then return nil,nil,side end
 local needed=cfg.StandOff-signed*side
 if needed<=0 then return nil,nil,side end
 local correction=math.min(needed,budget or cfg.MaxCorrection)
 local speed=(v.x*nx+v.y*ny)*side
 local velocity={x=v.x,y=v.y,z=v.z}
 if speed<0 then velocity.x=v.x-nx*side*speed;velocity.y=v.y-ny*side*speed end
 return {x=p.x+nx*side*correction,y=p.y+ny*side*correction,z=p.z},velocity,side,correction
end
