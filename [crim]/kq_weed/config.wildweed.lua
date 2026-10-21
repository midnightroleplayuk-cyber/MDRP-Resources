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
        ['zancudo_river'] = {
            -- Item given to the player after collection
            yieldItem = 'kq_weed_bud_white_widow',
            -- Optional. When defined one of the seeds will always be given on collection
            seedItem = 'kq_weed_seed_white_widow',

            -- Amount of the yieldItem gained from a single wild plant
            yield = {
                min = 2,
                max = 3,

                -- Quality of the collected buds (only used when quality metadata is enabled)
                quality = 30,
            },

            -- Model of the weed plant
            model = 'kq_weed_plant_03',
            -- Tint color of the weed plant
            tint = 0,

            -- Center of the zone
            center = vec3(302.37, 4324.85, 46.96), -- 241
            -- Zone radius
            radius = 35.0,
            -- Amount of plants spawned in this zone
            count = 15,

            -- Seconds before a collected plant respawns somewhere else in this zone.
            respawnDelay = 14400,
        },
        ['gordo_trail'] = {
            yieldItem = 'kq_weed_bud_purple_haze',
            seedItem = 'kq_weed_seed_purple_haze',

            yield = {
                min = 2,
                max = 3,

                -- Quality of the collected buds (only used when quality metadata is enabled)
                quality = 30,
            },

            model = 'kq_weed_plant_03',
            tint = 1,

            center = vec3(2996.97, 6249.26, 78.68), -- 470
            radius = 40.0,
            count = 15,

            respawnDelay = 14400,
        },
    },
}
