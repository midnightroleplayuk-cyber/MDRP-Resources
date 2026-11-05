-- Wild weed plants that spawn scattered around defined areas for players to find and collect
Config.wildWeed = {
    enabled = true,

    -- Random size multiplier per plant
    scale = {
        min = 0.8,
        max = 1.0,
    },

    -- Optional map blips at each zone
    blip = {
        enabled = false,
        sprite = 496,
        color = 25,
        alpha = 255,
        scale = 0.8,
        label = 'Wild Weed',
        radius = {
            enabled = false,
            color = 25,
            alpha = 70,
        },
    },

    -- Areas where the wild weed will spawn.
    zones = {
        ['alamo_sea'] = {
            -- Item given to the player after collection
            yieldItem = 'kq_weed_bud_og_kush',
            -- Optional. When defined one of the seeds will always be given on collection
            seedItem = 'kq_weed_seed_og_kush',

            -- Amount of the yieldItem gained from a single wild plant
            yield = {
                min = 1,
                max = 3,

                -- Quality of the collected buds (only used when quality metadata is enabled)
                quality = 30,
            },

            -- Model of the weed plant
            model = 'kq_weed_plant_03',
            -- Tint color of the weed plant
            tint = 0,

            -- Center of the zone
            center = vec3(302.37, 4324.85, 46.96), 
            -- Zone radius
            radius = 35.0,
            -- Amount of plants spawned in this zone
            count = 20,

            -- Seconds before a collected plant respawns somewhere else in this zone.
            respawnDelay = 3600,
        },
             ['north_manchester'] = {
            -- Item given to the player after collection
            yieldItem = 'kq_weed_bud_og_kush',
            -- Optional. When defined one of the seeds will always be given on collection
            seedItem = 'kq_weed_seed_og_kush',

            -- Amount of the yieldItem gained from a single wild plant
            yield = {
                min = 1,
                max = 3,

                -- Quality of the collected buds (only used when quality metadata is enabled)
                quality = 30,
            },

            -- Model of the weed plant
            model = 'kq_weed_plant_03',
            -- Tint color of the weed plant
            tint = 0,

            -- Center of the zone
            center = vec3(14.85, 6877.45, 11.54), 
            -- Zone radius
            radius = 35.0,
            -- Amount of plants spawned in this zone
            count = 20,

            -- Seconds before a collected plant respawns somewhere else in this zone.
            respawnDelay = 3600,
        },
        ['gordo_trail'] = {
            yieldItem = 'kq_weed_bud_og_kush',
            seedItem = 'kq_weed_seed_og_kush',

            yield = {
                min = 1,
                max = 3,

                -- Quality of the collected buds (only used when quality metadata is enabled)
                quality = 30,
            },

            model = 'kq_weed_plant_03',
            tint = 1,

            center = vec3(2996.97, 6249.26, 78.68), 
            radius = 40.0,
            count = 20,

            respawnDelay = 3600,
        },
    },
}
