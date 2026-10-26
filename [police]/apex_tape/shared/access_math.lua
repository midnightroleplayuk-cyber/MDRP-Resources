-- Shared timing/geometry for a continuous ribbon held up at one point.
TapeAccessMath={}
local M=TapeAccessMath
local function clamp(v,lo,hi)return math.max(lo,math.min(hi,v))end
function M.progress(from,to,elapsed,duration)
    local u=clamp(elapsed/math.max(1,duration),0,1)
    u=u*u*(3-2*u)
    return from+(to-from)*u
end
function M.fraction(p,a,b)
    local x,y=b.x-a.x,b.y-a.y
    local length=x*x+y*y
    return clamp(length>0 and ((p.x-a.x)*x+(p.y-a.y)*y)/length or .5,0,1)
end
function M.lerp(a,b,t)return {x=a.x+(b.x-a.x)*t,y=a.y+(b.y-a.y)*t,z=a.z+(b.z-a.z)*t}end
function M.grip(a,b,record,elapsed)
    local base=M.lerp(a,b,record.fraction)
    local progress=M.progress(record.from,record.to,elapsed,record.duration)
    return M.lerp(base,record.raised,progress),progress
end
