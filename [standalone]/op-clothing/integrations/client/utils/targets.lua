-- ──────────────────────────────────────────────────────────────────────────────
-- Integrations / Client / Targets
-- ──────────────────────────────────────────────────────────────────────────────

local function method()
    if OPC and OPC.ResolveTargetMethod then
        return OPC.ResolveTargetMethod()
    end
    return (Config and Config.Target and Config.Target.AccessMethod) or 'none'
end

function isTargetActive()
    local m = method()
    return m == 'ox-target' or m == 'qb-target'
end

function addTargetZone(opts)
    opts = opts or {}
    local m = method()
    local name = opts.name
    local dist = opts.distance or 2.0

    if m == 'ox-target' then
        local handle = exports.ox_target:addBoxZone({
            name     = name,
            coords   = opts.coords,
            size     = opts.size or vec3(2.0, 2.0, 3.0),
            rotation = opts.rotation or 0.0,
            debug    = opts.debug or false,
            options  = {
                {
                    name        = name,
                    icon        = opts.icon or 'fa-solid fa-shirt',
                    label       = opts.label,
                    distance    = dist,
                    onSelect    = function() if opts.onSelect then opts.onSelect() end end,
                    canInteract = opts.canInteract,
                },
            },
        })
        return handle or name
    elseif m == 'qb-target' then
        local size = opts.size or vec3(2.0, 2.0, 3.0)
        exports['qb-target']:AddBoxZone(name, opts.coords, size.x, size.y, {
            name      = name,
            heading   = opts.rotation or 0.0,
            debugPoly = opts.debug or false,
            minZ      = (opts.coords.z or 0.0) - (size.z or 2.0) / 2.0,
            maxZ      = (opts.coords.z or 0.0) + (size.z or 2.0) / 2.0,
        }, {
            options = {
                {
                    icon        = opts.icon or 'fa-solid fa-shirt',
                    label       = opts.label,
                    action      = function() if opts.onSelect then opts.onSelect() end end,
                    canInteract = opts.canInteract,
                },
            },
            distance = dist,
        })
        return name
    end
    return nil
end

function addTargetCircle(opts)
    opts = opts or {}
    local m = method()
    local name = opts.name
    local dist = opts.distance or 2.0
    local radius = opts.radius or 2.0

    if m == 'ox-target' then
        local handle = exports.ox_target:addSphereZone({
            name    = name,
            coords  = opts.coords,
            radius  = radius,
            debug   = opts.debug or false,
            options = {
                {
                    name        = name,
                    icon        = opts.icon or 'fa-solid fa-shirt',
                    label       = opts.label,
                    distance    = dist,
                    onSelect    = function() if opts.onSelect then opts.onSelect() end end,
                    canInteract = opts.canInteract,
                },
            },
        })
        return handle or name
    elseif m == 'qb-target' then
        exports['qb-target']:AddCircleZone(name, opts.coords, radius, {
            name = name,
            useZ = false,
        }, {
            options = {
                {
                    icon        = opts.icon or 'fa-solid fa-shirt',
                    label       = opts.label,
                    action      = function() if opts.onSelect then opts.onSelect() end end,
                    canInteract = opts.canInteract,
                },
            },
            distance = dist,
        })
        return name
    end
    return nil
end

function addTargetEntity(entity, opts)
    if not entity then return nil end
    opts = opts or {}
    local m = method()
    local name = opts.name or ('opc:%s'):format(entity)
    local dist = opts.distance or 2.0

    if m == 'ox-target' then
        exports.ox_target:addLocalEntity(entity, {
            {
                name        = name,
                icon        = opts.icon or 'fa-solid fa-shirt',
                label       = opts.label,
                distance    = dist,
                onSelect    = function() if opts.onSelect then opts.onSelect() end end,
                canInteract = opts.canInteract,
            },
        })
        return name
    elseif m == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = {
                {
                    type        = 'client',
                    icon        = opts.icon or 'fa-solid fa-shirt',
                    label       = opts.label,
                    action      = function() if opts.onSelect then opts.onSelect() end end,
                    canInteract = opts.canInteract,
                },
            },
            distance = dist,
        })
        return name
    end
    return nil
end

function removeTarget(handle, name)
    if not handle then return end
    local m = method()
    if m == 'ox-target' then
        pcall(function() exports.ox_target:removeZone(handle) end)
    elseif m == 'qb-target' then
        pcall(function() exports['qb-target']:RemoveZone(name or tostring(handle)) end)
    end
end

function removeTargetEntity(entity, name)
    if not entity then return end
    local m = method()
    if m == 'ox-target' then
        pcall(function() exports.ox_target:removeLocalEntity(entity, { name or ('opc:%s'):format(entity) }) end)
    elseif m == 'qb-target' then
        pcall(function() exports['qb-target']:RemoveTargetEntity(entity) end)
    end
end