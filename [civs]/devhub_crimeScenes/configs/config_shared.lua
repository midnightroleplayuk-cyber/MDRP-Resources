Shared = {}

-- Debug configuration
Shared.Debug = {
    Enabled = false, -- Set to false to disable all Debug() prints
    Levels = {
        Info = true,    -- General information (blue)
        Success = true, -- Success operations (green)
        Warning = true, -- Warnings and potential issues (yellow)
    }
}

Shared.MinPolice = 0 -- Minimum police required to start a crime scene mission

Shared.PedSettings = {
    enabled = true,
    peds = {
        {
            model = "a_m_y_juggalo_01",
            coords = vec4(-779.5085, -180.1830, 37.2836, 117.2973),
            blip = {
                enabled = false,
                sprite = 1,
                color = 2,
                scale = 0.8,
                label = "Crime Scene NPC",
            },
        },
    },
}

Shared.StartRequirements = {
    -- Item example:
    { name = "water", amount = 1, consume = true },
    -- Custom handler example:
    -- {
    --     label = "Crew Membership",
    --     icon = "fas fa-users",
    --     check = function(source)
    --         return true
    --     end,
    --     action = function(source)
    --         -- runs once the mission actually starts
    --     end,
    -- },
}

Shared.LaptopConfig = {
    enabled = true,
    traderId = 'trader_3',
    name = 'Crime Scenes',
    smallDescription = 'Clean up crime scenes and dispose of evidence.',
    description = 'Join the queue and wait for your turn. You will receive a vehicle location and crime scene coordinates. Clean up the scene, load evidence into the vehicle, and dispose of it.',
    bannerImage = 'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/crimeScenes/taskImage.webp',
    images = {
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/crimeScenes/img4.webp',
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/crimeScenes/img2.webp',
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/crimeScenes/taskImage.webp',
    },
    link = "https://store.devhub.gg",
    rewards = {
        items = {},
        money = 2000,
        crimePoints = 750,
        xp = 500,
    },
    tasks = {
        ['uid_1'] = {
            name = 'Join the queue',
            description = 'Join the queue and wait for your turn.',
            icon = 'fas fa-sign-in-alt',
            order = 1,
        },
        ['uid_2'] = {
            name = 'Pick up the vehicle',
            description = 'Go to the marked vehicle location on your map and pick up the assigned vehicle.',
            icon = 'fas fa-car',
            order = 2,
        },
        ['uid_3'] = {
            name = 'Drive to the crime scene',
            description = 'Drive the vehicle to the crime scene location marked on your map.',
            icon = 'fas fa-map-marker-alt',
            order = 3,
        },
        ['uid_4'] = {
            name = 'Clean up the scene',
            description = 'Pack up bodies, body parts, clean blood with UV light and mop, loot or burn crates.',
            icon = 'fas fa-broom',
            order = 4,
        },
        ['uid_5'] = {
            name = 'Load evidence into vehicle',
            description = 'Carry all packed objects and place them into the vehicle trunk.',
            icon = 'fas fa-box',
            order = 5,
        },
        ['uid_6'] = {
            name = 'Dispose of the vehicle',
            description = 'Drive to the disposal location and destroy the vehicle with all evidence inside.',
            icon = 'fas fa-fire',
            order = 6,
        },
    }
}

-- =========================================================================
-- POLICE ALARMS
-- =========================================================================
-- Each TriggerAlarm function is fired at a different point of the mission:
--
--   TriggerAlarm  -> called when the suspect loads ALL evidence into the
--                    vehicle (Scene:sceneCleaned on the server).
--                    coords = crime scene coords.
--
--   TriggerAlarm2 -> called when the evidence vehicle is destroyed
--                    (Scene:destroyScene on the server).
--                    coords = vehicle disposal coords.
--
-- Both functions have a SERVER and a CLIENT version. The server version
-- receives the player `source` as the first argument, the client version
-- does not (there is no `source` on the client).
-- =========================================================================

if IsDuplicityVersion() then
    -- =====================================================================
    -- SERVER SIDE
    -- =====================================================================

    -- Fired when the suspect finishes loading all evidence into the vehicle.
    function TriggerAlarm(source, coords)
        -- TODO implement your police call logic here (SERVER side)
    end

    -- Fired when the evidence vehicle is destroyed.
    function TriggerAlarm2(source, coords)
        -- TODO implement your police call logic here (SERVER side)
    end
else
    -- =====================================================================
    -- CLIENT SIDE
    -- =====================================================================

    -- Fired when the suspect finishes loading all evidence into the vehicle.
    function TriggerAlarm(coords)
        -- TODO implement your police call logic here (client side)
    end

    -- Fired when the evidence vehicle is destroyed.
    function TriggerAlarm2(coords)
        -- TODO implement your police call logic here (client side)
    end
end