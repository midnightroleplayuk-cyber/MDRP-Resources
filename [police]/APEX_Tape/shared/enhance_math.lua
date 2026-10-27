TapeEnhanceMath={}
local M=TapeEnhanceMath
function M.crossing(p,a,b)
 local q,f=TapeContactMath.nearest(p,a,b)
 if f<.05 or f>.95 then return nil,'Walk around the endpoint instead.' end
 local x,y=b.x-a.x,b.y-a.y;local length=math.sqrt(x*x+y*y)
 if length<.1 then return nil,'Span is too short.' end
 local nx,ny=-y/length,x/length
 local sign=(p.x-q.x)*nx+(p.y-q.y)*ny>=0 and 1 or -1
 return {x=q.x-nx*sign*Config.Passage.Distance,y=q.y-ny*sign*Config.Passage.Distance,z=p.z},q
end
function M.tailLength(t,a,b,side)
 local length=TapeGeometry.distance(a,b)
 local f=math.max(.01,math.min(.99,t.breakFraction or .5))
 return math.max(0,length*(side=='a' and f or 1-f)-Config.Breakaway.TearGap*.5)
end
function M.loosePaths(paths,t,a,b)
 local out={}
 for index,side in ipairs({'a','b'})do
  if not (t.looseRemoved and t.looseRemoved[side]) then
   local path=paths[index]
   if t.carry and t.carry.side==side and TapeGeometry.point(t.carry.point) then
    local anchor=side=='a' and a or b;local hand=t.carry.point
    local spare=math.max(0,M.tailLength(t,a,b,side)-TapeGeometry.distance(anchor,hand))
    path={}
    for i=0,8 do
     local f=i/8;local p=TapeAccessMath.lerp(anchor,hand,f)
     p.z=p.z-math.min(.4,spare*.2)*4*f*(1-f);path[#path+1]=p
    end
   end
   if path and not t.carry and t.tailDrop and t.tailDrop.side==side then
    local d=t.tailDrop;local elapsed=d.elapsed or 0
    if d.started and type(GetGameTimer)=='function' then elapsed=math.max(0,GetGameTimer()-d.started) end
    local amount=TapeAccessMath.progress(0,1,elapsed,d.duration or Config.LooseEnds.DropMs)
    local anchor=side=='a' and a or b
    for i,p in ipairs(path)do
     local f=(i-1)/math.max(1,#path-1)
     local from=TapeAccessMath.lerp(anchor,d.point,f)
     path[i]=TapeAccessMath.lerp(from,p,amount)
    end
   end
   if path then out[#out+1]=path end
  end
 end
 return out
end
function M.paths(t,a,b,elapsed,fa,fb)
 return M.loosePaths(TapeTearMath.paths(a,b,t.breakFraction,elapsed,fa or t.tearFloorA,fb or t.tearFloorB),t,a,b)
end
function M.wear(wear,seconds,weather,wind)
 local c=Config.WeatherWear
 local rate=c.Rates[weather] or c.Rates.CLEAR or 0
 return math.min(1,math.max(0,wear or 0)+math.min(seconds,c.MaxStepSeconds)/60*rate*(1+math.max(0,math.min(wind or 0,20))*c.WindFactor))
end
function M.feedback(anchor,first,minLength,maxLength,reason)
 if not anchor then return false,reason or ('No solid attachment within %.1f m. Aim at a surface or switch placement mode.'):format(Config.AimReach) end
 if first then
  local distance=TapeGeometry.distance(first,anchor.attach)
  if distance<minLength then return false,('Too close: %.2f m; minimum %.2f m.'):format(distance,minLength) end
  if distance>maxLength then return false,('Too far: %.2f m; maximum %.2f m.'):format(distance,maxLength) end
  return true,('Ready to place %.2f m of tape.'):format(distance)
 end
 return true,'Attachment found. Set the first point.'
end
