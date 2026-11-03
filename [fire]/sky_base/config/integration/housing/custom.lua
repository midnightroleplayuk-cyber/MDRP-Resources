-- Housing adapters have no Config selection. Set this to true after implementing
-- the lookup below; return nil when the player is not currently inside a property.
local enabled = false
if not enabled then return end

Sky.Housing.RegisterAdapter("custom", function(source, fallbackCoords)
    -- Return entrance coordinates as vector3 or an { x, y, z } table.
    -- source is a server id; fallbackCoords is the caller's current fallback.
    return nil
end)

if IsDuplicityVersion() then
    Sky.Housing.RegisterOwnershipAdapter("custom", function(source)
        -- Return a non-negative integer for the online character. Keep nil,
        -- "unsupported" until the custom housing ownership lookup is implemented.
        return nil, "unsupported"
    end)
end
