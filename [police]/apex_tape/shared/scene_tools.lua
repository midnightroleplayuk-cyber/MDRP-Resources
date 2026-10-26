TapeSceneTools={}
local T=TapeSceneTools
local G=TapeGeometry
function T.transform(spans,origin,heading)
    if not G.point(origin) or not G.finite(heading) then return nil end
    local angle=math.rad(heading)
    local function convert(p)
        if not G.point(p) then return nil end
        return {x=origin.x+p.x*math.cos(angle)-p.y*math.sin(angle),y=origin.y+p.x*math.sin(angle)+p.y*math.cos(angle),z=origin.z+p.z}
    end
    local result={}
    for _,span in ipairs(spans) do result[#result+1]={a=convert(span.a),b=convert(span.b),style=span.style,postA=span.postA,postB=span.postB} end
    return result
end
function T.capture(spans,heading)
    if #spans==0 or #spans>Config.Templates.MaxSpans or not G.finite(heading) then return nil,'Invalid template size.' end
    local min={x=math.huge,y=math.huge,z=math.huge}
    local max={x=-math.huge,y=-math.huge,z=-math.huge}
    for _,s in ipairs(spans) do for _,p in ipairs({s.a,s.b}) do
        for _,axis in ipairs({'x','y','z'}) do min[axis]=math.min(min[axis],p[axis]);max[axis]=math.max(max[axis],p[axis]) end
    end end
    local center={x=(min.x+max.x)/2,y=(min.y+max.y)/2,z=min.z}
    local relative={}
    for _,span in ipairs(spans) do
        local function subtract(p)return {x=p.x-center.x,y=p.y-center.y,z=p.z-center.z}end
        if G.distance(center,span.a)>Config.Templates.MaxRadius or G.distance(center,span.b)>Config.Templates.MaxRadius then return nil,'Template exceeds the configured radius.' end
        relative[#relative+1]={a=subtract(span.a),b=subtract(span.b),style=span.style,postA=span.postA,postB=span.postB}
    end
    return T.transform(relative,{x=0,y=0,z=0},-heading),center
end
function T.routeClear(start,route,segments,clearance)
    local previous=start
    for _,target in ipairs(route) do
        if not G.point(target) then return false end
        for _,s in ipairs(segments) do
            local distance,u,v=G.closest2d(previous,target,s.a,s.b)
            local roadZ=previous.z+(target.z-previous.z)*u
            local tapeZ=s.a.z+(s.b.z-s.a.z)*v
            if math.abs(roadZ-tapeZ)<5.0 and distance<clearance then return false end
        end
        previous=target
    end
    return true
end
function T.sag(span,rest)
    if not Config.Tension.Enabled then return math.min(Config.Ribbon.sagMax,span*Config.Ribbon.sagFactor) end
    local cfg=Config.Tension
    local ratio=rest and rest>0 and span/rest or 1.0
    local tight=math.max(0,math.min(1,(ratio-1)/math.max(0.01,cfg.MaxStretch-1)))
    local slack=math.max(0,1-ratio)*cfg.SlackMultiplier
    return math.min(cfg.MaxSag,cfg.SagAtReference*(span/cfg.ReferenceSpan)^2*(1+slack))*(1-tight)
end
