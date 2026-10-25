local owner, job, passage, candidate
local state = 'idle'
local previousUpdate

local function copyVector(v)
    return {x = v.x, y = v.y, z = v.z}
end

local function distance(a, b)
    return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)
end

local function stillObject(entity)
    return entity ~= 0 and DoesEntityExist(entity) and GetEntityType(entity) == 3
        and IsEntityStatic(entity) and not IsEntityAttached(entity) and GetEntitySpeed(entity) < 0.01
end

local function rotationMatches(a, b)
    for _, axis in ipairs({'x', 'y', 'z'}) do
        if math.abs((a[axis] - b[axis] + 180.0) % 360.0 - 180.0) > 0.1 then return false end
    end
    return true
end

function Main:clearCrouchClearance()
    owner, job, passage, previousUpdate, candidate = nil, nil, nil, nil, nil
    state = 'idle'
end

function Main:getCrouchClearanceInfo()
    return {state = state, object = passage and passage.entity or 0,
        model = passage and passage.model or 0, candidate = candidate}
end

local function readProbe(probe)
    if not probe or probe.result then return end
    local status, hit, point, normal, entity = GetShapeTestResult(probe.handle)
    if status == 0 then
        probe.result = {valid = false}
    elseif status == 2 then
        probe.result = {valid = true, hit = hit == true or hit == 1, point = point,
            normal = normal, entity = entity}
    end
end

local function completeJob(now)
    if not job.body or not job.ground then return false end
    local body, upper, ground = job.body.result, job.upper.result, job.ground.result
    if not body or not upper or not ground then return false end
    passage = nil
    if not body.valid or not upper.valid or not ground.valid then
        state = 'invalid-probe'
    elseif now - job.started > 50 then
        state = 'stale-probe'
    elseif body.hit then
        state = 'body-blocked'
    elseif not upper.hit or not stillObject(upper.entity)
        or GetEntityModel(upper.entity) ~= job.model
        or distance(GetEntityCoords(upper.entity), job.objectPosition) >= 0.001
        or not rotationMatches(GetEntityRotation(upper.entity, 2), job.rotation) then
        state = 'no-static-overhead-object'
    elseif not ground.hit or ground.normal.z < 0.8 or ground.entity == upper.entity
        or job.feetZ - ground.point.z < -0.05 or job.feetZ - ground.point.z > 0.25 then
        state = 'unsupported-ground'
    else
        passage = {entity = upper.entity, model = GetEntityModel(upper.entity),
            objectPosition = job.objectPosition, rotation = job.rotation,
            position = job.position, feetZ = job.feetZ, started = job.started}
        state = 'checked'
    end
    job = nil
    return true
end

function Main:updateCrouchClearance(ped)
    if not Config.Crouch or not Config.Crouch.ObjectClearance or not Config.Modules['Crouch']
        or ped ~= cache.ped or ped ~= PlayerPedId() or not DoesEntityExist(ped) then
        self:clearCrouchClearance()
        return false
    end
    if owner ~= ped then self:clearCrouchClearance(); owner = ped end
    local now = GetGameTimer()
    local frameSeconds = math.min(math.max(now - (previousUpdate or now - 16), 16), 50) / 1000.0
    previousUpdate = now
    local position = GetEntityCoords(ped)
    local feetZ = math.min(GetPedBoneCoords(ped, 14201, 0.0, 0.0, 0.0).z,
        GetPedBoneCoords(ped, 52301, 0.0, 0.0, 0.0).z)
    if job then
        readProbe(job.body); readProbe(job.upper); readProbe(job.ground)
        if job.upper.result and not job.body then
            local upper = job.upper.result
            candidate = nil
            if upper.valid and upper.hit and upper.entity ~= 0 and DoesEntityExist(upper.entity) then
                candidate = {model = GetEntityModel(upper.entity), static = IsEntityStatic(upper.entity),
                    entityType = GetEntityType(upper.entity)}
            end
            if not upper.valid or not upper.hit or not stillObject(upper.entity) then
                passage = nil
                state = upper.valid and 'no-static-overhead-object' or 'invalid-probe'
                job = nil
            else
                job.model = GetEntityModel(upper.entity)
                job.objectPosition = copyVector(GetEntityCoords(upper.entity))
                job.rotation = copyVector(GetEntityRotation(upper.entity, 2))
                local p, z = job.position, job.feetZ
                job.body = {handle = StartShapeTestCapsule(p.x, p.y, z + 0.44,
                    p.x, p.y, z + 0.80, 0.40, 83, ped, 4)}
                job.ground = {handle = StartShapeTestLosProbe(p.x, p.y, z + 0.15,
                    p.x, p.y, z - 0.40, 83, ped, 4)}
            end
        end
        if job and not completeJob(now) and now - job.started > 50 then
            passage = nil
            state = 'waiting-for-probes'
        end
    end

    local active = false
    if passage then
        local entity = passage.entity
        local moved = distance(position, passage.position)
        if now - passage.started <= 50 and moved <= 0.075 and math.abs(feetZ - passage.feetZ) <= 0.05
            and moved + GetEntitySpeed(ped) * frameSeconds <= 0.14
            and stillObject(entity) and GetEntityModel(entity) == passage.model
            and distance(GetEntityCoords(entity), passage.objectPosition) < 0.001
            and rotationMatches(GetEntityRotation(entity, 2), passage.rotation) then
            SetEntityNoCollisionEntity(ped, entity, true)
            state = 'active'
            active = true
        else
            passage = nil
            state = 'clearance-expired'
        end
    end

    if not job then
        job = {started = now, position = copyVector(position), feetZ = feetZ,
            upper = {handle = StartShapeTestCapsule(position.x, position.y, feetZ + 1.30,
                position.x, position.y, feetZ + 1.70, 0.35, 83, ped, 4)}}
    end
    return active
end
