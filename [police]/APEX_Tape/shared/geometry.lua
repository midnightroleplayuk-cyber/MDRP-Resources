-- Pure geometry shared by preview, authoritative server operations and tests.
TapeGeometry = {}
local G = TapeGeometry
function G.finite(n) return type(n)=='number' and n==n and math.abs(n)<100000 end
function G.point(p) return (type(p)=='table' or type(p)=='vector3') and G.finite(p.x) and G.finite(p.y) and G.finite(p.z) end
function G.lerp(a,b,t) return {x=a.x+(b.x-a.x)*t,y=a.y+(b.y-a.y)*t,z=a.z+(b.z-a.z)*t} end
function G.distance(a,b) return math.sqrt((a.x-b.x)^2+(a.y-b.y)^2+(a.z-b.z)^2) end
local function clamp(t) return math.max(0,math.min(1,t)) end
local function nearest(p,a,b)
    local dx,dy=b.x-a.x,b.y-a.y
    local length=dx*dx+dy*dy
    local t=length>0 and clamp(((p.x-a.x)*dx+(p.y-a.y)*dy)/length) or 0
    local x,y=a.x+dx*t,a.y+dy*t
    return (p.x-x)^2+(p.y-y)^2,t
end
-- Closest parameters on two 2D segments, with degenerate segments supported.
function G.closest2d(p,q,a,b)
    local rx,ry,sx,sy=q.x-p.x,q.y-p.y,b.x-a.x,b.y-a.y
    local denom=rx*sy-ry*sx
    if math.abs(denom)>0.000001 then
        local dx,dy=a.x-p.x,a.y-p.y
        local u,v=(dx*sy-dy*sx)/denom,(dx*ry-dy*rx)/denom
        if u>=0 and u<=1 and v>=0 and v<=1 then return 0,u,v end
    end
    local d1,v1=nearest(p,a,b)
    local best,u,v=d1,0,v1
    local d2,v2=nearest(q,a,b);if d2<best then best,u,v=d2,1,v2 end
    local d3,u3=nearest(a,p,q);if d3<best then best,u,v=d3,u3,0 end
    local d4,u4=nearest(b,p,q);if d4<best then best,u,v=d4,u4,1 end
    return math.sqrt(best),u,v
end
function G.sweepHit(p,q,a,b,radius,minZ,maxZ)
    local distance,u,v=G.closest2d(p,q,a,b)
    local carZ=p.z+(q.z-p.z)*u
    local tapeZ=a.z+(b.z-a.z)*v
    return distance<=radius and tapeZ>=carZ+minZ and tapeZ<=carZ+maxZ,v
end
function G.preset(kind,center,heading,width,length,spacing)
    local cfg=Config.Presets
    if not cfg.Enabled or not G.point(center) or not G.finite(heading) then return nil,'Invalid preset origin.' end
    if not G.finite(width) or width<1 or width>cfg.MaxDimension then return nil,'Invalid preset size.' end
    if not G.finite(spacing) or spacing<cfg.MinSpacing or spacing>cfg.MaxSpacing then return nil,'Invalid post spacing.' end
    local vertices,closed={},kind~='road'
    if kind=='rectangle' then
        if not G.finite(length) or length<1 or length>cfg.MaxDimension then return nil,'Invalid rectangle length.' end
        vertices={{x=-width/2,y=-length/2},{x=width/2,y=-length/2},{x=width/2,y=length/2},{x=-width/2,y=length/2}}
    elseif kind=='circle' then
        local n=math.max(6,math.ceil(2*math.pi*width/spacing))
        if n>cfg.MaxSpans then return nil,'Too many perimeter spans.' end
        for i=0,n-1 do local angle=2*math.pi*i/n;vertices[#vertices+1]={x=math.cos(angle)*width,y=math.sin(angle)*width} end
    elseif kind=='road' then vertices={{x=-width/2,y=0},{x=width/2,y=0}}
    else return nil,'Unknown preset.' end
    local points={}
    for i=1,(closed and #vertices or #vertices-1) do
        local a,b=vertices[i],vertices[i%#vertices+1]
        local distance=math.sqrt((b.x-a.x)^2+(b.y-a.y)^2)
        local steps=math.max(1,math.ceil(distance/math.min(spacing,Config.MaxDistance)))
        for j=0,steps-1 do points[#points+1]={x=a.x+(b.x-a.x)*j/steps,y=a.y+(b.y-a.y)*j/steps} end
    end
    if not closed then points[#points+1]=vertices[#vertices] end
    if #points-(closed and 0 or 1)>cfg.MaxSpans then return nil,'Too many perimeter spans.' end
    local theta=math.rad(heading)
    for i,p in ipairs(points) do points[i]={x=center.x+p.x*math.cos(theta)-p.y*math.sin(theta),y=center.y+p.x*math.sin(theta)+p.y*math.cos(theta),z=center.z} end
    local spans={}
    for i=1,(closed and #points or #points-1) do
        local j=i%#points+1
        if G.distance(points[i],points[j])<Config.MinLength then return nil,'Preset spans are too short.' end
        spans[#spans+1]={a=points[i],b=points[j],ai=i,bi=j}
    end
    return spans
end
