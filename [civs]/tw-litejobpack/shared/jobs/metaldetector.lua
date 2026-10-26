local MetalDetectorJob = {
    id = "metaldetector",

    icon = "./img/jobs/metaldetector_icon.svg",
    image = "./img/jobs/metaldetector_bg.png",
    video = "https://tworst.info/uploads/videos/693c8c7043c4710bef70b9f4541adb3a_1784463053.mp4",
    enabled = true,
    requiredHours = 0,
    maxHours = 0,

    npc = {
        enabled = true,
        coords = vector4(-1100.2054, -1680.0459, 4.4020, 127.3610),
        model = "s_m_y_dockwork_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true,
            sprite = 617,
            color = 47,
            scale = 0.85,
        },
    },

    xprewards = {
        findCompleted = 40,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd", -- onJobEnd | perItem
        completionBonus = 500,
        coopMode = "full",
        coopBonus = 1.1,
    },

    missioncompletedItems = {
        giveItemPlayer = false,
        dropMode = "weightedPool",
        itemList = {
            { item = "sandwich", count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    runtime = {
        spotsPerRound = 8,        -- buried spots generated per round (per zone)
        spotMinSeparation = 10.0, -- minimum distance between generated spots

        -- LEVEL PERKS (config-driven) — the dig minigame gets easier/faster as the
        -- player's metaldetector level rises. Set enabled = false to turn all off.
        --   ballCount   → fewer glowing points per dig (faster digs). reduceBy
        --                 points removed from the MAX every `perLevels` levels,
        --                 never below `min`.
        --   digCooldown → shorter delay between clicks. `base` ms at level 1,
        --                 minus `reduceMs` every `perLevels` levels, floored at
        --                 `min`. (base should match the dig preset's 1200ms.)
        levelPerks = {
            enabled = true,
            ballCount   = { perLevels = 5, reduceBy = 1, min = 2 },
            digCooldown = { base = 1200, perLevels = 3, reduceMs = 60, min = 500 },
        },

        detector = {
            startDistance = 40.0,      -- detector starts beeping within this range of a spot
            digDistance = 2.2,         -- how close the player must be to dig
            digCooldownMs = 900,
            markerDrawDistance = 12.0, -- ground marker becomes visible within this range
            holdAnimation = {
                enabled = true,
                dict = "mini@golfai",
                clip = "wood_idle_a",
                flag = 49, -- loop + upper body + player control (can walk while sweeping)
            },
            hud = {
                enabled = true,     -- top-center compass tape + proximity bar while holding the detector
                showDegrees = true, -- heading degrees chip under the compass center
            },
            tiers = {
                { distance = 40.0, interval = 1400 },
                { distance = 25.0, interval = 950 },
                { distance = 14.0, interval = 600 },
                { distance = 7.0, interval = 300 },
            },
        },

        -- HOW DIG SPOTS ARE PLACED (first match wins):
        --   1. polygons  → PREFERRED. Draw one or MORE polygons per zone over
        --      the sand (ox_lib zone creator point format: a list of vector3
        --      corners per polygon, minimum 3). Spots are generated purely
        --      server-side inside these shapes — water/concrete impossible.
        --      Spots spread across polygons proportionally to their area.
        --   2. spotPool  → hand-placed exact points, random subset per round.
        --   3. arrival scan (groundFilter below) → automatic material check
        --      around players; used only when neither of the above is set.
        -- center/radius are still used for the map blip, GPS route and the
        -- zone boundary check — keep them covering all the zone's polygons.
        -- Each searchZone carries an `id` matching a menu AREA (below); the beach
        -- NAME is pulled from that area, so it is never duplicated here.
        --
        -- Example:
        --   { id = "vespucci", center = vector3(...), radius = 175.0,
        --     polygons = {
        --         { vector3(x1,y1,z), vector3(x2,y2,z), vector3(x3,y3,z), vector3(x4,y4,z) }, -- north strip
        --         { vector3(...), vector3(...), vector3(...) },                               -- south strip
        --     },
        --   },

        -- MENU AREAS (UI-facing, level-gated). One entry PER searchZone, in the
        -- SAME ORDER — index i here maps to searchZones[i]. The player picks a
        -- beach in the job menu (higher beaches need a higher level); the shift
        -- runs on the selected beach and stays there across "Continue" rounds.
        -- lootValueMultiplier scales every find's money value on that beach, so
        -- further-out / higher-level beaches are worth more per dig.
        areas = {
            { id = "vespucci", name = "Vespucci Beach",  type = "metaldetector", requiredLevel = 0, lootValueMultiplier = 1.0,  coord = vector3(-1488.8713, -1263.3081, 2.2650) },
            { id = "delperro", name = "Del Perro Beach", type = "metaldetector", requiredLevel = 2, lootValueMultiplier = 1.25, coord = vector3(-1799.3682, -810.9327, 7.7876) },
            { id = "chumash",  name = "Chumash Shore",   type = "metaldetector", requiredLevel = 4, lootValueMultiplier = 1.6,  coord = vector3(-3285.6477, 1100.8124, 2.0802) },
            { id = "paleto",   name = "Paleto Beach",    type = "metaldetector", requiredLevel = 6, lootValueMultiplier = 2.0,  coord = vector3(-469.6956, 6422.4229, 2.2908) },
        },

        searchZones = {
            { id = "vespucci", center = vector3(-1488.8713, -1263.3081, 2.2650), radius = 175.0,
              polygons = {
                    { vector3(-1635.9767, -1126.1046, 1.7802), vector3(-1425.9137, -1357.4392, 3.6877), vector3(-1382.3429, -1295.1090, 4.3111), vector3(-1602.7177, -1088.1438, 4.9840) },
                },
            },
            { id = "delperro", center = vector3(-1799.3682, -810.9327, 7.7876), radius = 200.0,
              polygons = {
                { vector3(-2096.1450, -569.1917, 2.9978), vector3(-1760.1606, -901.0283, 7.7320), vector3(-1681.4083, -805.1715, 10.0334), vector3(-2038.0869, -517.0897, 10.1395) },

              },
            },
            { id = "chumash", center = vector3(-3285.6477, 1100.8124, 2.0802), radius = 150.0,
              polygons = {
                   { vector3(-3277.7927, 987.8229, 5.2258), vector3(-3247.1179, 1273.1847, 3.0355), vector3(-3266.8076, 1279.0580, 1.1177), vector3(-3303.1582, 973.0081, 2.0550) },

              },
            },
            { id = "paleto", center = vector3(-469.6956, 6422.4229, 2.2908), radius = 150.0,
              polygons = {
                    { vector3(-591.8490, 6392.3794, 3.2060), vector3(-559.1575, 6354.3916, 3.2665), vector3(-270.3351, 6521.4941, 2.7715), vector3(-299.9711, 6568.4561, 1.6969) },

              },
            },
        },

        groundFilter = {
            enabled = true, -- false = legacy behavior (random points, may land on concrete)
            -- Ground materials accepted for dig spots. Entries may be material
            -- NAMES (hashed automatically) or raw numeric hashes. Set
            -- Config.Debug = true and start a round to print the material of
            -- every scanned point to F8 — handy for extending this list.
            -- NOTE: do NOT add 'sand_underwater' — the world raycast passes
            -- through water and would accept the seabed as a dig spot.
            allowedMaterials = {
                'sand_loose', 'sand_compact', 'sand_wet', 'sand_track',
                'sand_dry_deep', 'sand_wet_deep',
            },
            minGroundZ = 0.0,  -- reject spots below this height (0.0 = sea level; beach zones only need dry land)
            scanRadius = 70.0, -- spots are verified this far around the scanning player (collision is loaded there); the round tops itself up as players move deeper
        },

        lootTable = {
            { id = "scrap",  name = "Scrap Metal", chance = 50, value = 300, item = "md_scrap" },
            { id = "coin",   name = "Old Coin", chance = 25, value = 550, item = "md_coin" },
            { id = "silver", name = "Silver Piece", chance = 15, value = 900, item = "md_silver" },
            { id = "gold",   name = "Gold Nugget", chance = 8, value = 1400, item = "md_gold" },
            { id = "relic",  name = "Rare Relic", chance = 2, value = 2200, item = "md_relic" },
        },
        levelChanceBonus = 0.4,

        lootAsItem = {
            enabled = false, -- true: digs deliver the loot as an inventory item (items must exist in your inventory — see ITEMS.md)
            alsoPay = false, -- true: pay the loot's money value in addition to the item
        },

        shovel = {
            prop = "prop_tool_shovel",
            boneIndex = 28422,
            offset = vector3(0.0, 0.0, 0.24),   -- dig-swing grip (used during the burial burst)
            rotation = vector3(0.0, 0.0, 0.0),
            -- Pose between minigame clicks: same stance as the detector sweep
            -- (golf idle) — shovel held in front like a club, tip down.
            holdOffset = vector3(0.0, 0.0, 0.24),
            holdRotation = vector3(0.0, 0.0, 0.0),
            holdAnim = { dict = "mini@golfai", name = "wood_idle_a" },
            -- Slung-on-back pose while the detector is out (tune with the gizmo).
            backBone = 24818,
            backOffset = vector3(0.27, -0.20, 0.14),
            backRotation = vector3(0.0, 90.0, 190.0),
            breakSession = {
                enabled = true, -- true = miner-style dig minigame (hit the glowing points) | false = timed animation below
                ballCount = { min = 3, max = 4 },
                repeatPerBall = 1,
                ballSize = 0.15,
                spread = 0.4,   -- ± scatter of the hit-points around the spot (keep small = same hole)
            },
            -- Shovel sound played on EVERY dig swing (each minigame hit, and once
            -- per timed dig when breakSession is off). The file lives in
            -- html/sounds/<name>.ogg — NUI only loads .ogg, so keep that format.
            -- Set enabled = false to mute it.
            digSound = {
                enabled = true,
                name = "tw_shovel", -- html/sounds/tw_shovel.ogg (no extension here)
                volume = 0.5,       -- 0.0 - 1.0
            },
            -- Used when breakSession.enabled = false (simple timed dig).
            diggingAnimation = {
                dict = "random@burial",
                clip = "a_burial",
                duration = 5000,
            },
        },

        vehicle = {
            spawnLocations = {
                vector4(-1102.0773, -1689.7205, 4.2878, 212.2571),
            },
            model = "bison",
            toolProp = Config.Tools.metaldetector.default.prop,
            color = { primary = 111, secondary = 0 },
            plate = "DETECT",
            useCustomPlate = false,
            fuelOnSpawn = 100.0,
            trunkDoors = { 5 },
            trunkOffset = -3.5, -- distance behind vehicle when picking up / returning tools

            toolPositions = {
                { offset = vector3(-0.78, -2.2, 0.94), rotation = vector3(0.90, -210.0, 90.0) },
                { offset = vector3(-0.78, -1.7, 0.94), rotation = vector3(0.90, -210.0, 90.0) },
                { offset = vector3(0.78, -1.7, 0.97),  rotation = vector3(0.90, -160.0, 90.0) },
                { offset = vector3(0.78, -2.2, 0.97),  rotation = vector3(0.90, -160.0, 90.0) },
            },
        },

        workClothes = {
            coord = vector4(-1091.5787, -1686.6311, 3.6049, 123.0799 + 180.0),
        },

        -- Where the van is HANDED IN to finish the shift (its spawn spot on the
        -- pier). Ending drives the return-to-depot flow instead of deleting the
        -- van out at the beach and stranding the player.
        depot = {
            coord = vector3(-1102.0773, -1689.7205, 4.2878),
            vehicleRadius = 25.0,
        },

        marker = {
            type = 1,
            scale = vector3(0.45, 0.45, 0.2),
            color = { r = 245, g = 190, b = 80, a = 170 },
            bob = false,
            rotate = false,
        },
    },

    preview = {
        playerPosition = vector3(-1503.24, -1068.42, 0.5),
        steps = {
            {
                camCoord = vector3(-1501.0, -1072.0, 2.0),
                camTarget = vector3(-1504.7, -1067.9, 0.7),
            },
            {
                camCoord = vector3(-1613.0, -1030.0, 3.2),
                camTarget = vector3(-1604.0, -1038.0, 0.2),
                entities = {
                    {
                        type = "marker",
                        markerType = 1,
                        coords = vector4(-1604.0, -1038.0, 0.15, 0.0),
                        scale = vector3(0.45, 0.45, 0.2),
                        color = { r = 245, g = 190, b = 80, a = 170 },
                        bob = false,
                        rotate = false,
                    },
                },
            },
        },
    },
}

MetalDetectorJob.clothes = {
    male = {
        tshirt_1 = 59,
        tshirt_2 = 1,
        torso_1 = 56,
        torso_2 = 0,
        arms = 30,
        pants_1 = 98,
        pants_2 = 1,
        shoes_1 = 24,
        shoes_2 = 0,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = -1,
        helmet_2 = 0,
        glasses_1 = 15,
        glasses_2 = 0,
    },
    female = {
        tshirt_1 = 36,
        tshirt_2 = 1,
        torso_1 = 75,
        torso_2 = 3,
        decals_1 = 0,
        decals_2 = 0,
        arms = 30,
        pants_1 = 99,
        pants_2 = 1,
        shoes_1 = 24,
        shoes_2 = 0,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = -1,
        helmet_2 = 0,
        glasses_1 = 5,
        glasses_2 = 0,
    },
}

return MetalDetectorJob
