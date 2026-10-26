-- =============================================================
--  Client bridge: targeting (ox_target / qb-target) and the
--  "use item" hook for inventories that fire a server event.
-- =============================================================

Target = {}

local hasOx = GetResourceState('ox_target') == 'started'
local hasQb = GetResourceState('qb-target') == 'started'

function Target.Available() return hasOx or hasQb end

--- A box zone at a fixed point.
function Target.AddBox(opts)
    if hasOx then
        exports.ox_target:addBoxZone({
            coords = vec3(opts.coords.x, opts.coords.y, opts.coords.z),
            size = opts.size or vec3(4.0, 4.0, 3.0),
            rotation = opts.heading or 0,
            debug = false,
            options = { {
                name = opts.name,
                event = opts.event,
                icon = opts.icon or 'fa-solid fa-id-card',
                label = opts.label,
                distance = opts.distance or 6.0
            } }
        })
    elseif hasQb then
        local size = opts.size or vec3(4.0, 4.0, 3.0)
        exports['qb-target']:AddBoxZone(opts.name, vec3(opts.coords.x, opts.coords.y, opts.coords.z),
            size.x, size.y, {
                name = opts.name,
                heading = opts.heading or 0.0,
                minZ = opts.coords.z - (size.z / 2),
                maxZ = opts.coords.z + (size.z / 2)
            }, {
                options = { {
                    event = opts.event,
                    icon = opts.icon or 'fas fa-id-card',
                    label = opts.label
                } },
                distance = opts.distance or 3.0
            })
    end
end

--- An option on every player ped.
function Target.AddPlayerOption(opts)
    if hasOx then
        exports.ox_target:addGlobalPlayer({ {
            name = opts.name,
            event = opts.event,
            icon = opts.icon or 'fa-solid fa-id-card',
            label = opts.label,
            distance = opts.distance or 4.0
        } })
    elseif hasQb then
        exports['qb-target']:AddGlobalPlayer({
            options = { {
                event = opts.event,
                icon = opts.icon or 'fas fa-id-card',
                label = opts.label
            } },
            distance = opts.distance or 3.0
        })
    end
end
