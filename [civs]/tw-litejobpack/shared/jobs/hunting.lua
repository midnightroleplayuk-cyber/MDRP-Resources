local HuntingJob = {

    id = "hunting",

    icon = "./img/jobs/hunting_icon.svg",
    image = "./img/jobs/hunting_bg.png",
    video = "https://tworst.info/uploads/videos/12ea93eba1c84986fa24a053a6463cee_1775405614.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(-773.34, 5598.67, 33.61, 170.53),
        model = "cs_hunter",
        scenario = "WORLD_HUMAN_BINOCULARS",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 141,
            color = 27,
            scale = 0.8,
        },
    },

    xprewards = {
        animalKilled = 15,
        carcassDelivered = 50,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        perKg = 15,
        deliveryBonus = 0, -- bonus pay for delivering/selling items
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onKill (animal killed)
        onKill = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 }, { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false, -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

    -- Weapons are managed via the upgrade/tool system: see Config.Tools.hunting
    -- in shared/config_settings.lua. Players purchase weapon upgrades from the
    -- progress panel just like miner pickaxes. The fallback below is only used
    -- if the selected-tool callback fails.
    weapons = {
        primary = {
            hash = "weapon_musket",
            ammo = 30,
            label = "Hunting Rifle",
        },
        oxBasedInventory = false, -- auto-detected for ox_inventory / core_inventory | set true only if your inventory is item-based (weapons are inventory items) but uses a different Config.Inventory name

        -- Ammo items given alongside the weapon (ox_inventory: metadata ammo is always set, these are EXTRA inventory items)
        -- Map each weaponHash to its ammo item and count. Remove or leave empty to skip ammo items.
        ammoItems = {
            ["weapon_musket"]       = { item = "ammo-musket",       count = 30 },
            ["weapon_sniperrifle"]  = { item = "ammo-sniper",       count = 40 },
            ["weapon_heavysniper"]  = { item = "ammo-sniper",       count = 50 },
        },
    },

    disableFriendlyFire = true,

    blips = {
        showAliveAnimals = true, -- true = canlı hayvanlar haritada blip olarak görünsün | false = hayvanları aramak/iz sürmek gerek
        showCarcasses    = true, -- true = öldürülen hayvanların carcass'ı haritada işaretlensin | false = düşürdüğün hayvanı kendin bulmalısın
    },

}

local runtime = {

    areas = {
        [1] = {
            id = "forest",
            name = "Paleto Forest",
            type = "animals",
            coord = vector3(-753.09, 5117.6, 158.34),
            radius = 200.0,
            animals = {
                { model = "a_c_pig",       weight = { min = 30, max = 60 }, pricePerKg = 18, label = "Wild Boar", spawnWeight = 2 },
                { model = "a_c_rabbit_01", weight = { min = 2, max = 5 },   pricePerKg = 20, label = "Rabbit",    spawnWeight = 8 },
                { model = "a_c_coyote",    weight = { min = 10, max = 20 }, pricePerKg = 22, label = "Coyote",    spawnWeight = 3 },
            },
            spawnCount = 30,
            requiredLevel = 0,
            blip = {
                sprite = 141,
                color = 25,
                label = "Forest Area",
            },
        },
        [2] = {
            id = "desert",
            name = "Sandy Shores Desert",
            type = "predators",
            coord = vector3(2472.14, 3374.18, 50.6),
            radius = 200.0,
            animals = {
                { model = "a_c_coyote", weight = { min = 10, max = 20 }, pricePerKg = 25, label = "Coyote",        spawnWeight = 3 },
                { model = "a_c_mtlion", weight = { min = 20, max = 40 }, pricePerKg = 40, label = "Mountain Lion", spawnWeight = 1 },
                { model = "a_c_pig",    weight = { min = 30, max = 60 }, pricePerKg = 20, label = "Wild Boar",     spawnWeight = 2 },
            },
            spawnCount = 20,
            requiredLevel = 3,
            blip = {
                sprite = 141,
                color = 1,
                label = "Desert Area",
            },
        },
        [3] = {
            id = "swamp",
            name = "Swamp",
            type = "birds",
            coord = vector3(-1981.92, 2572.65, 2.67),
            radius = 150.0,
            animals = {
                { model = "a_c_chickenhawk", weight = { min = 1, max = 3 },   pricePerKg = 30, label = "Hawk", spawnWeight = 6 },
                { model = "a_c_crow",        weight = { min = 0.5, max = 1 }, pricePerKg = 15, label = "Crow", spawnWeight = 6 },
            },
            spawnCount = 40,
            requiredLevel = 5,
            blip = {
                sprite = 141,
                color = 3,
                label = "Swamp Area",
            },
        },
    },

    carcassProp = {
        bone = 57005,
        offset = vector3(0.130, 0.400, 0.500),
        rotation = vector3(0.0, 0.1, 0.0),
    },

    animalCarryConfig = {

        ["a_c_pig"] = {
            bone = 56604,
            offset = vector3(0.120, 0.410, 0.550),
            rotation = vector3(0.1, 0.2, 71.5),
            carryAnim = { dict = "anim@heists@box_carry@", name = "idle" },
        },
        ["a_c_coyote"] = {
            bone = 57005,
            offset = vector3(-0.080, 0.400, -0.350),
            rotation = vector3(280.2, 174.4, -22.9),
            carryAnim = { dict = "anim@heists@box_carry@", name = "idle" },
        },
        ["a_c_mtlion"] = {
            bone = 57005,
            offset = vector3(0.200, -0.250, -0.150),
            rotation = vector3(67.6, -13.3, 17.6),
            carryAnim = { dict = "anim@heists@box_carry@", name = "idle" },
        },

        ["a_c_rabbit_01"] = {
            bone = 28422,
            offset = vector3(-0.197, -0.105, 0.165),
            rotation = vector3(83.01, -24.8, 10.01),
            carryAnim = { dict = "missfbi4prepp1", name = "_bag_walk_garbage_man" },
        },
        ["a_c_chickenhawk"] = {
            bone = 28422,
            offset = vector3(-0.020, 0.000, 0.170),
            rotation = vector3(-100.1, 17.5, 10.1),
            carryAnim = { dict = "missfbi4prepp1", name = "_bag_walk_garbage_man" },
        },
        ["a_c_crow"] = {
            bone = 28422,
            offset = vector3(-0.130, 0.010, 0.360),
            rotation = vector3(-100.1, 46.5, 0.0),
            carryAnim = { dict = "missfbi4prepp1", name = "_bag_walk_garbage_man" },
        },
    },

    animations = {
        pickup = {
            dict = "missexile3",
            name = "ex03_dingy_search_case_base_scientist",
            duration = 1500,
        },
        carry = {
            dict = "anim@heists@box_carry@",
            name = "idle",
        },
    },

    vehicle = {
        spawnLocations = {
            vector4(-772.78, 5578.52, 33.25, 89.36),
            vector4(-773.51, 5565.71, 33.25, 86.36),
            vector4(-763.64, 5548.65, 33.25, 176.35),
            vector4(-752.57, 5546.94, 33.25, 173.35),
            vector4(-747.45, 5535.1, 33.25, 23.35),
            vector4(-766.21, 5523.81, 33.25, 17.35),
        },
        spawnBlockRadius = 4.0,
        model = "kamacho",
        color = { primary = 28, secondary = 6 },
        plate = "HUNTER",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = { 5 },
        maxWeightCapacity = 200,
        weightPerLevel = 0, -- extra kg of trunk capacity per hunting level of the lobby leader (e.g. 20 = +20kg/level; 0 = fixed capacity)
        cargoPositions = {
            { offset = vector3(-0.170, -1.540, 0.770), rotation = vector3(0.0, 0.0, -90.0) },
            { offset = vector3(-0.170, -2.540, 0.770), rotation = vector3(0.0, 0.0, -90.0) },
            { offset = vector3(-0.170, -2.040, 0.770), rotation = vector3(0.0, 0.0, -90.0) },
            { offset = vector3(-0.170, -1.540, 1.170), rotation = vector3(0.0, 0.0, -90.0) },
            { offset = vector3(-0.170, -2.540, 1.170), rotation = vector3(0.0, 0.0, -90.0) },
            { offset = vector3(-0.170, -2.040, 1.170), rotation = vector3(0.0, 0.0, -90.0) },
        },
    },

    processing = {
        coord = vector4(-768.657, 5591.456, 32.528, -2.159),
        prop = "tw_baskul",
        propOffset = vector3(0.0, 0.0, 0.0),
        propRotation = vector3(0.0, 0.0, 0.0),
        spawnDistance = 50.0,
        interactDistance = 2.5,
        maxDistanceFromScale = 15.0,
        maxScaleItems = 20,
        progressTarget = 5, -- animals that fill the progress bar to 100% (display only; tune to a typical round). NOT the scale cap (maxScaleItems).

        npc = {
            model = "cs_hunter",
            coord = vector4(-772.62, 5587.43, 32.49, 182.48),
            scenario = "WORLD_HUMAN_CLIPBOARD",
            interactDistance = 2.0,
        },

        carrier = {
            npcModel        = "s_m_y_construct_02",
            carryProp       = "prop_cs_cardbox_01",
            maxItemsToCarry = 2,
            walkSpeed       = 1.0,

            spawnCoord      = vector4(-760.54, 5583.59, 36.71, 74.49),
            dropCoord       = vector4(-760.54, 5583.59, 36.71, 74.49),

            carryBone       = 57005,
            carryOffset     = vector3(0.0, 0.3, 0.0),
            carryRotation   = vector3(-20.0, 0.0, 0.0),
            pickupTime      = 2000,
            dropTime        = 1500,
        },
    },

    workClothes = {
        coord = vector4(-781.65, 5582.47, 32.5, 87.1),
    },

    -- Out-of-area abandonment: cancels the job if the player strays too far from
    -- BOTH the selected hunting area AND the processing/scale base, while NOT in
    -- the job vehicle. Stops players leaving the job vehicle/weapon abandoned
    -- across the map. The job vehicle counts as "traveling", so long land drives
    -- between areas don't trigger it.
    --
    --   enabled        = false → never auto-cancel. Use this when the area and the
    --                    base are far apart or separated by water (e.g. moving the
    --                    hunt to an island like Cayo Perico), since the land job
    --                    vehicle can't bridge that gap and the timer would fire
    --                    during transit.
    --   areaThreshold  = max distance (m) from the selected area before the timer starts
    --   baseThreshold  = max distance (m) from processing.coord before the timer starts
    --   graceSeconds   = warning window (s) before the job is cancelled
    abandonment = {
        enabled       = true,
        areaThreshold = 600.0,
        baseThreshold = 500.0,
        graceSeconds  = 15,
    },
}

HuntingJob.runtime = runtime

local vehSpawn = runtime.vehicle.spawnLocations[1]
local headingRad = math.rad(vehSpawn.w)
local trunkX = vehSpawn.x + math.sin(headingRad) * 3.0
local trunkY = vehSpawn.y - math.cos(headingRad) * 3.0
local trunkHeading = (vehSpawn.w + 180.0) % 360.0

HuntingJob.preview = {
    playerPosition = vector3(-773.0, 5598.0, 33.6),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(-774.0, 5595.2, 35.0),
            camTarget = vector3(-773.1, 5599.9, 33.8),
        },

        {
            autoClothes = true,
            camCoord = vector3(-776.8, 5582.3, 34.8),
            camTarget = vector3(-781.5, 5582.5, 33.1),
        },

        {
            autoVehicle = true,
            camCoord = vector3(-766.3, 5577.9, 35.4),
            camTarget = vector3(-771.1, 5578.3, 34.2),
        },

        {
            camCoord = vector3(-745.3, 5124.1, 161.8),
            camTarget = vector3(-749.0, 5121.0, 160.4),
            entities = {

                {
                    type = "ped",
                    model = runtime.areas[1].animals[1].model,
                    coords = vector4(-750.0, 5118.0, 158.34, 90.0),
                    persist = false
                },

                {
                    type = "ped",
                    model = "cs_hunter",
                    coords = vector4(-758.0, 5117.6, 158.34, 90.0),
                    faceCoord = vector3(-750.0, 5118.0, 158.34),
                    anim = { dict = "combat@aim_variations@gang@1h", name = "gang_aiming_v2_aim_hi", flag = 1 },
                    weapon = "weapon_musket",
                    persist = false
                },
            },
        },

        {
            camCoord = vector3(-770.3, 5584.1, 37.6),
            camTarget = vector3(-770.3, 5580.0, 34.8),
            entities = {
                {
                    type = "ped",
                    model = "cs_hunter",
                    coords = vector4(trunkX, trunkY, vehSpawn.z, vehSpawn.w),
                    anim = { dict = runtime.animations.carry.dict, name = runtime.animations.carry.name, flag = 49 },
                    persist = false
                },
                {
                    type = "ped",
                    model = "a_c_pig",
                    isDead = true,
                    attachTo = 1,
                    attachBone = runtime.animalCarryConfig["a_c_pig"].bone,
                    attachOffset = runtime.animalCarryConfig["a_c_pig"].offset,
                    attachRotation = runtime.animalCarryConfig["a_c_pig"].rotation,
                    persist = false
                },
            },
        },

        {
            autoScale = true,
            autoCarrier = true,
            scaleDUI = { rockCount = 2, payPerRock = 150 },
            camCoord = vector3(-770.8, 5587.6, 33.5),
            camTarget = vector3(-768.7, 5592.0, 32.4),
            entities = {

                { type = "ped", model = "a_c_pig", isDead = true, coords = vector4(runtime.processing.coord.x, runtime.processing.coord.y, runtime.processing.coord.z + 2.0, 0.0), spawnDelay = 2000 },
            },
        },
    },
}

HuntingJob.clothes = {
    male = {
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 67,
        torso_2 = 0,
        arms = 17,
        pants_1 = 9,
        pants_2 = 3,
        shoes_1 = 24,
        shoes_2 = 0,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = 12,
        helmet_2 = 2,
        glasses_1 = -1,
        glasses_2 = 0,
    },
    female = {
        tshirt_1 = 15,
        tshirt_2 = 0,
        torso_1 = 67,
        torso_2 = 0,
        decals_1 = 0,
        decals_2 = 0,
        arms = 17,
        pants_1 = 9,
        pants_2 = 3,
        shoes_1 = 24,
        shoes_2 = 0,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = 46,
        helmet_2 = 3,
        glasses_1 = -1,
        glasses_2 = 0,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
HuntingJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of carcasses processed on the scale
HuntingJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
HuntingJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return HuntingJob
