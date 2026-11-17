-- ============================================================================
-- REGIONS — the 14 job records, their rewards and the XP curve
-- ============================================================================
-- Data, not switches. To turn a region off set `enabled = false` on its record.
-- Payout scaling lives in config/config.lua -> Config.RewardMultiplier.
-- ============================================================================

-- REGION REWARDS: the single place for money and XP, indexed by regionID.
-- Config.RewardMultiplier (config/config.lua) is applied on top of these values.
-- config/economy.lua overwrites money/xp when enabled — it is off by default.
--   money / xp            paid to the crew that finishes the job
--   onlineJobExtraAwards  1 = the bonuses below apply
--   bonusExtraMoney/XP    extra bonus for the crew
Config.RegionAwards       = {
    [1] = { money = 5000, xp = 1000, onlineJobExtraAwards = 1, bonusExtraMoney = 500, bonusExtraXP = 200 },
    [2] = { money = 6500, xp = 1500, onlineJobExtraAwards = 1, bonusExtraMoney = 1000, bonusExtraXP = 300 },
    [3] = { money = 15900, xp = 3600, onlineJobExtraAwards = 1, bonusExtraMoney = 2400, bonusExtraXP = 700 },
    [4] = { money = 7000, xp = 1500, onlineJobExtraAwards = 1, bonusExtraMoney = 1000, bonusExtraXP = 300 },
    [5] = { money = 8000, xp = 1800, onlineJobExtraAwards = 1, bonusExtraMoney = 1200, bonusExtraXP = 350 },
    [6] = { money = 8500, xp = 1900, onlineJobExtraAwards = 1, bonusExtraMoney = 1300, bonusExtraXP = 380 },
    [7] = { money = 9000, xp = 2000, onlineJobExtraAwards = 1, bonusExtraMoney = 1400, bonusExtraXP = 400 },
    [8] = { money = 5000, xp = 1200, onlineJobExtraAwards = 1, bonusExtraMoney = 800, bonusExtraXP = 250 },
    [9] = { money = 14765, xp = 2000, onlineJobExtraAwards = 1, bonusExtraMoney = 1400, bonusExtraXP = 400 },
    [10] = { money = 11325, xp = 2200, onlineJobExtraAwards = 1, bonusExtraMoney = 1500, bonusExtraXP = 450 },
    [11] = { money = 13840, xp = 2400, onlineJobExtraAwards = 1, bonusExtraMoney = 1800, bonusExtraXP = 500 },
    [12] = { money = 5000, xp = 1200, onlineJobExtraAwards = 1, bonusExtraMoney = 800, bonusExtraXP = 250 },
    [13] = { money = 7500, xp = 1800, onlineJobExtraAwards = 1, bonusExtraMoney = 1200, bonusExtraXP = 350 },
    [14] = { money = 5000, xp = 1000, onlineJobExtraAwards = 1, bonusExtraMoney = 500, bonusExtraXP = 200 },
}

do
    local m = tonumber(Config.RewardMultiplier) or 1.0
    if m ~= 1.0 then
        for _, a in pairs(Config.RegionAwards) do
            for _, f in ipairs({ 'money', 'xp', 'bonusExtraMoney', 'bonusExtraXP' }) do
                if tonumber(a[f]) then a[f] = math.floor(a[f] * m + 0.5) end
            end
        end
    end
end
Config.Job                = {
    ['pedInteractionDistance'] = 3.0,
    ['coords'] = {
        ['intreactionCoords'] = vector3(1535.54, 1736.45, 110.31),
        ['ped'] = true,
        ['pedCoords'] = vector3(1535.54, 1736.45, 110.31),
        ['pedHeading'] = 85.68,
        ['pedHash'] = 0xC5FEFADE
    },
    ['job'] = 'all',
    ['blip'] = {
        show = true,
        blipName = TL('jobName'),
        blipType = 317,
        blipColor = 17,
        blipScale = 0.70
    },
    ['missionBlips'] = {
        [1] = {
            SetBlipSprite = 317,
            SetBlipColour = 17,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = TL('missionOneBlips')
        },
        [2] = {
            SetBlipSprite = 317,
            SetBlipColour = 17,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = TL('missionTwoBlips')
        },
        [3] = {
            SetBlipSprite = 317,
            SetBlipColour = 17,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = TL('missionThreeBlips')
        },
        [4] = {
            SetBlipSprite = 317,
            SetBlipColour = 17,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = TL('missionFourBlips')
        },
        [5] = {
            SetBlipSprite = 317,
            SetBlipColour = 17,
            SetBlipScale = 0.8,
            SetBlipDisplay = 4,
            blipName = TL('missionFiveBlips')
        },
        ['vehicleBlips'] = {
            SetBlipSprite = 477,
            SetBlipColour = 5,
            SetBlipScale  = 0.75,
        },
    },
    ['missioncompletedItems'] = {
        giveItemPlayer = false,
        dropMode = "weightedPool",
        itemList = {
            { item = "sandwich", count = math.random(1, 4), chance = 50 },
            { item = "sandwich", count = 1,                 chance = 30 },
        },
    },
    ['drawtext'] = {
    },
    ['regionData'] = {
        {
            regionID = 1,
            regionInfo = {
                regionName = TL('regionName_plank', 'El Burro Heights'),
                regionNameKey = 'regionName_plank',
                regionJobTask = TL('regionJobTask'),
                regionImage = "https://file.tworst.com/u/tw-builder/region1.png",
                regionMinimumLevel = 0,
                jobType = 'plank',
            },
            regionAwards = Config.RegionAwards[1],
            missioncompletedItems = {
                giveItemPlayer = false,
                dropMode = "weightedPool",
                itemList = {
                    { item = "sandwich", count = 1, chance = 50 },
                    { item = "water",    count = 1, chance = 30 },
                },
            },
            regionJobTask = {
            },
        },

        {
            regionID = 2,
            regionInfo = {
                regionName = TL('regionName_tower1', 'Tower Crane — Main'),
                regionNameKey = 'regionName_tower1',
                regionJobTask = TL('regionJobTaskTower1'),
                regionImage = "https://file.tworst.com/u/tw-builder/region2.png",
                regionMinimumLevel = 0,
                jobType = 'kulestone',
                jobMetadata = { instanceId = 'main' },
            },
            regionAwards = Config.RegionAwards[2],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 3,
            regionInfo = {
                regionName = TL('regionName_tower2', 'Tower Crane — Site 2'),
                regionNameKey = 'regionName_tower2',
                regionJobTask = TL('regionJobTaskTower2'),
                regionImage = "https://file.tworst.com/u/tw-builder/region3.png",
                regionMinimumLevel = 0,
                jobType = 'kulestone',
                jobMetadata = { instanceId = 'site2' },
            },
            regionAwards = Config.RegionAwards[3],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 4,
            regionInfo = {
                regionName = TL('regionName_pipe', 'Pipe Yard'),
                regionNameKey = 'regionName_pipe',
                regionJobTask = TL('regionJobTaskPipe'),
                regionImage = "https://file.tworst.com/u/tw-builder/region4.png",
                regionMinimumLevel = 0,
                jobType = 'pipe',
            },
            regionAwards = Config.RegionAwards[4],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 5,
            regionInfo = {
                regionName = TL('regionName_panelwall', 'Panel Façade'),
                regionNameKey = 'regionName_panelwall',
                regionJobTask = TL('regionJobTaskPanelwall'),
                regionImage = "https://file.tworst.com/u/tw-builder/region5.png",
                regionMinimumLevel = 0,
                jobType = 'panelwall',
            },
            regionAwards = Config.RegionAwards[5],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 6,
            regionInfo = {
                regionName = TL('regionName_wf', 'Water Facility'),
                regionNameKey = 'regionName_wf',
                regionJobTask = TL('regionJobTaskWf'),
                regionImage = "https://file.tworst.com/u/tw-builder/region6.png",
                regionMinimumLevel = 0,
                jobType = 'waterfacility',
            },
            regionAwards = Config.RegionAwards[6],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 7,
            regionInfo = {
                regionName = TL('regionName_wf2', 'Water Facility 2'),
                regionNameKey = 'regionName_wf2',
                regionJobTask = TL('regionJobTaskWf2'),
                regionImage = "https://file.tworst.com/u/tw-builder/region7.png",
                regionMinimumLevel = 0,
                jobType = 'waterfacility2',
            },
            regionAwards = Config.RegionAwards[7],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 8,
            regionInfo = {
                regionName = TL('regionName_excavator', 'Sidewalk Repair'),
                regionNameKey = 'regionName_excavator',
                regionJobTask = TL('regionJobTaskExcavator', 'Dig sand, fill the pit, lay the sidewalk stones'),
                regionImage = "https://file.tworst.com/u/tw-builder/region8.png",
                regionMinimumLevel = 0,
                jobType = 'excavator_dirt',
            },
            regionAwards = Config.RegionAwards[8],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 9,
            regionInfo = {
                regionName = TL('regionName_job9', 'Lumber Stacking'),
                regionNameKey = 'regionName_job9',
                regionJobTask = TL('regionJobTaskJob9'),
                regionImage = "https://file.tworst.com/u/tw-builder/region9.png",
                regionMinimumLevel = 0,
                jobType = 'job9',
            },
            regionAwards = Config.RegionAwards[9],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 10,
            regionInfo = {
                regionName = TL('regionName_job7', 'Plank Decking'),
                regionNameKey = 'regionName_job7',
                regionJobTask = TL('regionJobTaskJob7'),
                regionImage = "https://file.tworst.com/u/tw-builder/region10.png",
                regionMinimumLevel = 0,
                jobType = 'job7',
            },
            regionAwards = Config.RegionAwards[10],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 11,
            regionInfo = {
                regionName = TL('regionName_job8', 'Wall & Roof Assembly'),
                regionNameKey = 'regionName_job8',
                regionJobTask = TL('regionJobTaskJob8', 'Rent a crane, carry the wall panels by hand and lift the roof beams into place'),
                regionImage = "https://file.tworst.com/u/tw-builder/region11.png",
                regionMinimumLevel = 0,
                jobType = 'job8',
            },
            regionAwards = Config.RegionAwards[11],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        {
            regionID = 12,
            regionInfo = {
                regionName = TL('regionName_job12', 'Crane Haul'),
                regionNameKey = 'regionName_job12',
                regionJobTask = TL('regionJobTaskJob12', 'Rent the crane, load cargo at the depot, haul it to the site and unload'),
                regionImage = "https://file.tworst.com/u/tw-builder/region12.png",
                regionMinimumLevel = 0,
                jobType = 'job12',
            },
            regionAwards = Config.RegionAwards[12],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        -- R13 is switched off in config/jobs/cranepanel.lua (`enabled`), not here:
        -- while that is false this whole record is dropped from regionData. It is
        -- off by default because the panel sites are created with the in-game tool
        -- and none ship.
        {
            regionID = 13,
            regionInfo = {
                regionName = TL('regionName_cranepanel', 'Tower Crane — Panel'),
                regionNameKey = 'regionName_cranepanel',
                regionJobTask = TL('regionJobTaskCranePanel', 'Pick a site, lift the wall panels onto the skeleton with the tower crane'),
                regionImage = "region.png",
                regionMinimumLevel = 0,
                jobType = 'cranepanel',
            },
            regionAwards = Config.RegionAwards[13],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },

        -- R14 ships DISABLED because no permanent plot ships with it. The house
        -- system itself is on (config/systems/permanent_house.lua) and the 27
        -- house models are streamed, but a crew needs a site marked `permanent`
        -- and there is none by default, so the job would reject every start with
        -- "No free plot here." Mark a plot permanent in /tw_bp, then set
        -- enabled = true here.
        {
            regionID = 14,
            enabled = false,
            regionInfo = {
                regionName = TL('regionName_permbuild', 'Permanent Build'),
                regionNameKey = 'regionName_permbuild',
                regionJobTask = TL('regionJobTaskPermBuild', 'Build a house that stays: same site work as El Burro, but the finished house is never torn down'),
                regionImage = "region.png",
                regionMinimumLevel = 0,
                jobType = 'plank',
                jobMetadata = { permanent = true },
            },
            regionAwards = Config.RegionAwards[14],
            missioncompletedItems = { giveItemPlayer = false, dropMode = "weightedPool", itemList = {} },
            regionJobTask = {},
        },
    },

    -- header/label are resolved WHILE THIS FILE LOADS (server language).
    -- headerKey/labelKey are what the client actually shows: it resolves them
    -- in the PLAYER's language before sending the list to the NUI.
    ['dailyMission'] = {
        {
            name = 'jobtask_one',
            header = TL('jobtask') .. " 1",
            headerKey = 'jobtask',
            headerSuffix = ' 1',
            label = TL('dailyjobone'),
            labelKey = 'dailyjobone',
            count = 50,
            xp = 2500,
            money = 1000,
        },
        {
            name = 'jobtask_two',
            header = TL('jobtask') .. " 2",
            headerKey = 'jobtask',
            headerSuffix = ' 2',
            label = TL('dailyjobtwo'),
            labelKey = 'dailyjobtwo',
            count = 10,
            xp = 1000,
            money = 3000

        },
        {
            name = 'jobtask_three',
            header = TL('jobtask') .. " 3",
            headerKey = 'jobtask',
            headerSuffix = ' 3',
            label = TL('dailyjobthree'),
            labelKey = 'dailyjobthree',
            count = 10000,
            xp = 2000,
            money = 3000
        },

        {
            name = 'jobtask_four',
            header = TL('jobtask') .. " 4",
            headerKey = 'jobtask',
            headerSuffix = ' 4',
            label = TL('dailyjobfour'),
            labelKey = 'dailyjobfour',
            count = 20,
            xp = 2000,
            money = 3000
        },
    },
}

-- XP needed to reach each level.
Config.RequiredXP       = {
    [1] = 1000,
    [2] = 1500,
    [3] = 2000,
    [4] = 2500,
    [5] = 3000,
    [6] = 3500,
    [7] = 4000,
    [8] = 4500,
    [9] = 5000,
    [10] = 5500,
    [11] = 6000,
    [12] = 6500,
    [13] = 7000,
    [14] = 7500,
    [15] = 8000,
    [16] = 8500,
    [17] = 9000,
    [18] = 9500,
    [19] = 10000,
    [20] = 10500,
    [21] = 11000,
    [22] = 11500,
    [23] = 12000,
    [24] = 12500,
    [25] = 13000,
    [26] = 13500,
    [27] = 14000,
    [28] = 14500,
    [29] = 15000,
    [30] = 15500,
    [31] = 16000,
    [32] = 16500,
    [33] = 17000,
    [34] = 17500,
    [35] = 18000,
    [36] = 18500,
    [37] = 19000,
    [38] = 19500,
    [39] = 20000,
    [40] = 20500,
    [41] = 21000,
    [42] = 21500,
    [43] = 22000,
    [44] = 22500,
    [45] = 23000,
    [46] = 23500,
    [47] = 24000,
    [48] = 24500,
    [49] = 25000,
    [50] = 25500,
    [51] = 26500,
    [52] = 27500,
    [53] = 28500,
    [54] = 29500,
    [55] = 30500,
    [56] = 31500,
    [57] = 32500,
    [58] = 33500,
    [59] = 34500,
    [60] = 35500,
    [61] = 36500,
    [62] = 37500,
    [63] = 38500,
    [64] = 39500,
    [65] = 40500,
    [66] = 41500,
    [67] = 42500,
    [68] = 43500,
    [69] = 44500,
    [70] = 45500,

}

-- Job type shown on the region card. JobTypeLabelKeys below holds the locale
-- key so each player sees it in their own language.
Config.JobTypeLabels = {
    plank          = TL('jobtype_frame_concrete', 'Frame & Concrete'),
    kulestone      = TL('jobtype_tower_crane', 'Tower Crane'),
    pipe           = TL('jobtype_crane_work', 'Crane Work'),
    panelwall      = TL('jobtype_hand_carry', 'Hand Carry'),
    waterfacility  = TL('jobtype_pump_crane', 'Pump & Crane'),
    waterfacility2 = TL('jobtype_crane_work', 'Crane Work'),
    excavator_dirt = TL('jobtype_excavator_haul', 'Excavator & Haul'),
    job9           = TL('jobtype_hand_carry', 'Hand Carry'),
    job7           = TL('jobtype_hand_carry', 'Hand Carry'),
    job8           = TL('jobtype_hand_and_crane', 'Hand & Crane'),
    job12          = TL('jobtype_haulage', 'Haulage'),
}

Config.JobTypeLabelKeys = {
    plank          = 'jobtype_frame_concrete',
    kulestone      = 'jobtype_tower_crane',
    pipe           = 'jobtype_crane_work',
    panelwall      = 'jobtype_hand_carry',
    waterfacility  = 'jobtype_pump_crane',
    waterfacility2 = 'jobtype_crane_work',
    excavator_dirt = 'jobtype_excavator_haul',
    job9           = 'jobtype_hand_carry',
    job7           = 'jobtype_hand_carry',
    job8           = 'jobtype_hand_and_crane',
    job12          = 'jobtype_haulage',
}

-- Is a region switched off? `enabled = false` above only hides the region from
-- the menu and blocks the server from starting it — scenery props and the
-- tower crane are built by separate layers that never saw that flag, so a
-- disabled region kept its site standing. Those layers ask here now.
-- instanceId is optional: jobs that run a single site (panelwall, pipe...)
-- match on jobType alone.
function TwRegionDisabled(jobType, instanceId)
    local rd = Config.Job and Config.Job.regionData
    if not (rd and jobType) then return false end
    for _, r in ipairs(rd) do
        local info = r.regionInfo
        if info and info.jobType == jobType then
            local mid = info.jobMetadata and info.jobMetadata.instanceId
            if instanceId == nil or mid == instanceId then
                return r.enabled == false
            end
        end
    end
    return false
end
