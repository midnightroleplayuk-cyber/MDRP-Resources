local Gruppe6Job = {

    id = "gruppe6",
    icon = "./img/jobs/gruppe6_icon.svg",
    image = "./img/jobs/gruppe6_bg.png",
    video = "https://tworst.info/uploads/videos/5d8988dd42775958d7096cb16ec93ccc_1784463063.mp4",
    enabled = true,    -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0,      -- maximum hours allowed to start this job (0 = no limit)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-3.9681, -660.2188, 33.4804, 175.9791),
        model = "s_m_m_security_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 67,
            color = 5,
            scale = 0.8,
        },
    },

    xprewards = {
        perBag = 20,        -- XP accrued per bag loaded into the truck
        jobCompleted = 100, -- one-time XP when ALL stops are completed
    },

    payment = {
        mode = "onJobEnd",     -- accrue per bag, pay the pooled total when the truck is returned
        completionBonus = 500, -- one-time bonus if ALL stops were fully collected
        coopMode = "full",     -- "full" = everyone gets full pay | "split" = pay divided by player count
        coopBonus = 1.0,       -- multiplier for coop play (1.0 = no bonus)
    },

    missioncompletedItems = {
        giveItemPlayer = false,    -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    runtime = {

        vehicle = {
            model = "stockade",
            plate = "GRP6",
            useCustomPlate = false,
            color = { primary = 111, secondary = 0 },
            fuelOnSpawn = 100.0,
            -- Rear door indices vary per vehicle model; opening a nonexistent
            -- index is a harmless no-op, so both candidates are listed.
            trunkDoors = { 2, 3, 5 },
            trunkDoorOpenTime = 2500, -- ms — doors swing open slowly (heist style)
            trunkOffset = -4.2,       -- distance behind vehicle for trunk interactions

            spawnLocations = {
                vector4(-4.7347, -670.2926, 32.3381, 188.4231),
                vector4(-19.3216, -670.2849, 32.3381, 186.8511),
                vector4(-33.9387, -671.3583, 32.3381, 185.4012),
            },

            -- Filled money bags — SINGLE floor layer only (all z = 0.55, no second
            -- z = 1.05 stack). 2 columns × 6 tightly-packed rows (0.35 apart).
            cargoPositions = {
                { offset = vector3(-0.45, -1.30, 0.55), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.45, -1.30, 0.55),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.45, -1.65, 0.55), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.45, -1.65, 0.55),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.45, -2.00, 0.55), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.45, -2.00, 0.55),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.45, -2.35, 0.55), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.45, -2.35, 0.55),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.45, -2.70, 0.55), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.45, -2.70, 0.55),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.45, -3.05, 0.55), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.45, -3.05, 0.55),  rotation = vector3(0.0, 0.0, 0.0) },
            },

            -- EMPTY bags in the cargo bay, attached to the stockade at BONE 0.
            -- Values below = base (-0.18, -0.55, 0.55) + the gizmo deltas measured
            -- against it. One prop disappears each time a crew member grabs a bag.
            -- 11 slots = worst case shown (extra bags beyond this simply don't render).
            emptyBagPositions = {
                { offset = vector3(-0.78, -1.25, 0.85), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.78, -1.65, 0.85), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.78, -2.05, 0.85), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.78, -2.45, 0.85), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.78, -2.85, 0.85), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(-0.78, -3.05, 0.85), rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.72, -1.25, 0.85),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.72, -1.65, 0.85),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.72, -2.05, 0.85),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.72, -2.45, 0.85),  rotation = vector3(0.0, 0.0, 0.0) },
                { offset = vector3(0.72, -2.85, 0.85),  rotation = vector3(0.0, 0.0, 0.0) },
            },
        },

        -- Fleeca branches. blip = entrance (map blip/route), vault = vault-area
        -- anchor (server proximity checks), manager = bank manager NPC spot,
        -- trolleys = one FULL cash trolley per bag (looted trolleys are swapped
        -- map object's hinge position + CLOSED heading (swings open slowly).
        -- All interior coords are placeholders — fine-tune with the dev gizmo.
        -- MENU AREAS (UI-facing, level-gated). Each region draws its runs from a
        -- subset of `banks` (indices below) and pays MORE the further out / higher
        -- level it is (payMultiplier scales every bag's payout). The player picks
        -- a region in the menu; higher regions need a higher level. `banks` must
        -- hold at least `maxBanks` indices so a full run can always be dealt.
        areas = {
            { id = "los_santos", name = "Los Santos",    type = "gruppe6", requiredLevel = 0, payMultiplier = 1.0, banks = { 1, 2, 3 }, coord = vector3(149.9, -1040.5, 29.37) },
            { id = "west_coast", name = "West Coast",    type = "gruppe6", requiredLevel = 3, payMultiplier = 1.5, banks = { 3, 4, 5 }, coord = vector3(-1212.9, -330.8, 37.79) },
            { id = "blaine",     name = "Blaine County", type = "gruppe6", requiredLevel = 6, payMultiplier = 2.0, banks = { 4, 5, 6 }, coord = vector3(1175.0, 2706.6, 38.09) },
        },

        banks = {
            {
                name = "Legion Square",
                blip = vec3(111.71, -1097.82, 28.55),
                vault = vec4(100.81, -1094.11, 28.65, 157.64),
                manager = vec4(104.69, -1093.45, 29.65, 246.27),
                vaultDoor = vec4(99.01, -1096.46, 28.63, 54.87),
                trolleys = { vec4(98.02, -1093.57, 28.63, 64.64),
                    vec4(95.26, -1094.17, 28.63, 159.32),
                    vec4(95.46, -1096.82, 28.63, 230.32) }
            },
            {
                name = "Hawick Ave",
                blip = vector3(314.2, -278.8, 54.17),
                vault = vector4(311.28, -284.55, 54.17, 340.0),
                manager = vector4(307.0898, -282.4506, 54.1646, 341.2426),
                vaultDoor = vector4(310.93, -284.44, 54.16, -90.0),
                trolleys = { vector4(315.1701, -284.8129, 54.1430, 70.1814),
                    vector4(313.9633, -283.4323, 54.1430, 164.2897),
                    vector4(311.3874, -286.9916, 54.1430, 274.3325) }
            },
            {
                name = "Alta",
                blip = vector3(-351.5, -49.5, 49.04),
                vault = vector4(-354.36, -55.30, 49.04, 340.0),
                manager = vector4(-358.0055, -53.3449, 49.0364, 341.9485),
                vaultDoor = vector4(-354.15, -55.11, 49.04, 251.05),
                trolleys = { vector4(-349.9744, -55.6998, 49.0148, 73.9882),
                    vector4(-351.3179, -54.2825, 49.0148, 158.5772),
                    vector4(-353.5810, -58.0117, 49.0148, 248.0982) }
            },
            {
                name = "Del Perro",
                blip = vector3(-1212.9, -330.8, 37.79),
                vault = vector4(-1216.10, -335.20, 37.78, 20.0),
                manager = vector4(-1215.0642, -338.0694, 37.7808, 24.9845),
                vaultDoor = vector4(-1211.07, -336.68, 37.78, 296.76),
                trolleys = { vector4(-1207.7167, -333.8654, 37.7593, 118.5166),
                    vector4(-1209.5992, -333.9837, 37.7593, 208.7742),
                    vector4(-1208.8401, -338.2358, 37.7592, 292.5329) }
            },
            {
                name = "Great Ocean Hwy",
                blip = vector3(-2962.6, 482.9, 15.70),
                vault = vector4(-2957.66, 481.45, 15.70, 88.0),
                manager = vector4(-2957.2727, 477.1357, 15.6969, 91.9026),
                -- This branch's vault door is a DIFFERENT map object than the
                vaultDoor = vector4(-2956.68, 481.34, 15.70, 353.97),
                vaultDoorHash = 4231427725,
                trolleys = { vector4(-2957.1853, 485.5914, 15.6753, 180.0529),
                    vector4(-2958.2966, 483.9294, 15.6753, 271.01920),
                    vector4(-2954.0000, 482.5982, 15.6753, 352.9467) }
            },
            {
                name = "Route 68",
                blip = vector3(1175.0, 2706.6, 38.09),
                vault = vector4(1175.68, 2712.62, 38.09, 178.0),
                manager = vector4(1180.6010, 2712.2900, 38.0879, 180.9746),
                vaultDoor = vector4(1176.40, 2712.75, 38.09, 84.83),
                trolleys = { vector4(1172.0493, 2711.8762, 38.0663, 270.5147),
                    vector4(1173.9043, 2711.0635, 38.0663, 4.6856),
                    vector4(1175.0410, 2715.2532, 38.0662, 92.3408) }
            },
        },

        maxBanks = 3,                       -- banks per shift (<= #banks)

        bagsPerBank = { min = 2, max = 3 }, -- one trolley per bag (max = #trolleys)

        -- Empty duffel taken from the truck's cargo bay: the OPEN (visibly
        -- empty) heist duffel — the same prop the fill scene animates, so the
        -- bag in your hand and the bag being filled are one and the same.
        -- Attach offsets are treasurehunter's proven values (hangs from the
        -- right hand, no cradle carry).
        emptyBag = {
            prop = "hei_p_m_bag_var22_arm_s",
            attachConfig = { boneId = 57005, x = 0.1, y = 0.0, z = -0.15, rotX = 0.0, rotY = 0.0, rotZ = 0.0 },
        },

        -- Carried bags are worn on the BACK as a clothing component (GTA
        -- Online heist duffel): drawable 44 = deflated/EMPTY bag, 45 = stuffed
        -- FULL bag (the classic heist pairing). Adjust per your ped models;
        -- `none` is restored when the bag is put down.
        bagCloth = {
            male = {
                component = 5,
                empty = { drawable = 44, texture = 0 },
                full = { drawable = 45, texture = 0 },
            },
            female = {
                component = 5,
                empty = { drawable = 44, texture = 0 },
                full = { drawable = 45, texture = 0 },
            },
            -- Restored when no money bag is carried: NO bag (the uniform has no
            -- duffel anymore). Back stays empty until the player takes a bag
            -- from the truck; dropping/loading a money bag returns to empty back.
            none = { drawable = 0, texture = 0 },
        },

        -- Filled bags are the CLOSED duffel (prop_cs_heist_bag_02 — the prop
        -- treasurehunter already uses in production, guaranteed to load) for
        -- every type; used as the visible prop inside the truck. The types
        -- differ in payout and name only.
        bagTypes = {
            cash = { prop = "prop_cs_heist_bag_02", pay = 150, chance = 65 },
            documents = { prop = "prop_cs_heist_bag_02", pay = 100, chance = 25 },
            gold = { prop = "prop_cs_heist_bag_02", pay = 450, chance = 10 },
        },

        -- Reach-into-the-cargo-bay animation for taking / returning / loading
        -- bags at the truck's rear (upper-body, plays while the progress runs)
        trunkInteract = {
            dict = "anim@gangops@facility@servers@bodysearch@",
            anim = "player_search",
            flag = 49,           -- upper body, interruptible blend
            takeDuration = 1600, -- ms — grabbing / putting back an empty bag
            loadDuration = 2000, -- ms — loading a filled bag
        },

        -- ONE FULL trolley per bag, spawned at each bank's trolley slots once
        -- the vault opens. A looted trolley is deleted and replaced with the
        -- trolley; nothing to flicker or refill).
        trolley = {
            fullModel = "hei_prop_hei_cash_trolly_01",
            emptyModel = "hei_prop_hei_cash_trolly_03",
        },

        -- ped intro/grab/exit synced with the open duffel's bag_* anims, the
        -- trolley's own cash melting via cart_cash_dissapear during the grab.
        fill = {
            animDict = "anim@heists@ornate_bank@grab_cash",
            cartAnim = "cart_cash_dissapear",
            pedIntro = "intro",
            bagIntro = "bag_intro",
            pedGrab = "grab",
            bagGrab = "bag_grab",
            pedExit = "exit",
            bagExit = "bag_exit",
            bagProp = "hei_p_m_bag_var22_arm_s",
            grabDuration = 12000, -- ms of scooping (legacy fallback when the minigame is off)

            -- Scoop minigame: glowing hit-points on the trolley's cash pile,
            -- attack-click each one (metaldetector's dig-session mechanic).
            breakSession = {
                enabled = true, -- false = passive scoop scene with progress bar
                ballCount = { min = 5, max = 8 },
                repeatPerBall = 1,
                ballSize = 0.16,
                spreadXY = 0.30,
                cashSurfaceZ = 0.72, -- height of the money surface above trolley origin
            },

            -- Cash-mesh depletion: scrub the cart_cash_dissapear scene phase on the
            -- trolley to the BANK-WIDE fill fraction (taken / #bags) so the pile
            -- visibly shrinks as the crew scoops. Pure function of server state, so
            -- coop + late-join safe with no server changes and zero new entities.
            -- Terminal empty is still the full->empty model swap.
            deplete = {
                enabled = true,        -- false = old behaviour (cart stays full until the bank is done)
                mode = "phase",        -- "phase" = scrub cart_cash_dissapear (recommended) | anything else = no gradual melt (model swap only)
                startPhase = 0.0,      -- scene phase at a FULL trolley (0 = brimming). Flip start/max if the melt runs the wrong way in-game.
                maxPhase = 1.0,        -- scene phase at the last bag: 1.0 = fully melted so the last scoop empties the pile (paired with the empty-model swap on last bag taken)
                smoothPerClick = true, -- the active scooper eases their OWN station smoothly per minigame hit (cosmetic, local)
            },
        },

        -- The Fleeca vault door (map object) swings open slowly after the
        vaultDoorCfg = {
            model = "v_ilev_gb_vauldr",
            openAngle = 90.0,      -- degrees swept from the closed heading
            stepDegrees = 0.1,     -- per 10ms tick → ~9s for a full swing
            searchRadius = 3.0,
            closeDistance = 150.0, -- door swings shut once the crew is this far from a FINISHED bank
        },

        manager = {
            models = { "u_m_m_bankman", "s_m_m_highsec_02" },
            scenario = "WORLD_HUMAN_CLIPBOARD",
            spawnDistance = 60.0,
            despawnDistance = 100.0,
            interactDistance = 2.5,
            signDuration = 4000, -- ms paperwork progress at the manager
            vaultOpenDelay = 8,  -- seconds between signing and the vault opening
        },

        workClothes = {
            coord = vector4(3.8025, -667.7628, 31.3381, 98.9634 + 180.0),
        },

        depot = {
            -- Hand the truck in WHERE IT WAS TAKEN: the armored-truck spawn row
            -- on the road (centre slot). The old point sat on the NPC plaza at
            -- -660/z33.48 — a raised sidewalk the stockade couldn't pull up to,
            -- so the in-truck prompt never fired and the shift couldn't be ended.
            coord = vector3(-19.3216, -670.2849, 32.3381),
            vehicleRadius = 25.0, -- truck counts as "back at the pickup" within this
        },

        blips = {
            bank = { sprite = 500, color = 2, scale = 0.8 },
            depot = { sprite = 67, color = 5, scale = 0.9 },
        },
    },

    clothes = {
        male = {
            tshirt_1 = 122,
            tshirt_2 = 0,
            torso_1 = 316,
            torso_2 = 1,
            arms = 96,
            arms_2 = 0,
            pants_1 = 31,
            pants_2 = 0,
            shoes_1 = 24,
            shoes_2 = 0,
            decals_1 = 71,
            decals_2 = 0,
            bproof_1 = 27, -- vest
            bproof_2 = 9,
            -- Empty back (component 5 = 0): the player takes the actual bag from
            -- the truck, so the uniform must NOT put a duffel on. 0 is truthy in
            -- Lua, so ApplyJobClothes still runs and clears the slot to no bag.
            bags_1 = 0,
            bags_2 = 0,
            helmet_1 = 144, -- hat
            helmet_2 = 0,
        },
        female = {
            tshirt_1 = 152,
            tshirt_2 = 0,
            torso_1 = 327,
            torso_2 = 1,
            arms = 117,
            arms_2 = 9,
            pants_1 = 136,
            pants_2 = 1,
            shoes_1 = 24,
            shoes_2 = 0,
            decals_1 = 80,
            decals_2 = 0,
            bproof_1 = 24, -- vest
            bproof_2 = 6,
            -- Empty back (component 5 = 0): the player takes the actual bag from
            -- the truck, so the uniform must NOT put a duffel on. 0 is truthy in
            -- Lua, so ApplyJobClothes still runs and clears the slot to no bag.
            bags_1 = 0,
            bags_2 = 0,
            helmet_1 = 143, -- hat
            helmet_2 = 0,
        },
    },

    -- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
    -- Return true to allow the player to start, false to prevent
    startJobFunction = {
        enabled = false,
        func = function(source, ownerIdentifier, jobId)
            return true
        end,
    },

    -- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
    endJobFunction = {
        enabled = false,
        func = function(source, ownerIdentifier, jobId)
        end,
    },

    -- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
    resetJobFunction = {
        enabled = false,
        func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
        end,
    },
}

return Gruppe6Job
