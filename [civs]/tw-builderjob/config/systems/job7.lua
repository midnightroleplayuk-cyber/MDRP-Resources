-- Region 10 mechanics: carry and placement ranges.

Config.Job7System = {
    staticFurniture = {},

    carryModel = 'tworst_job7plankb',

    carryAttachBone   = 11816,
    carryAttachOffset = vec3(-0.572, -0.128, -0.160),
    carryAttachRot    = vec3(-2.2, -91.4, -110.8),
    carryAnimDict     = 'tworsttrow@anim',
    carryAnimClip     = 'tworsttrow_clip',
    carryAnimFlag     = 49,

    carryGrips = {
        ['tworst_job7plank']  = { bone = 11816, off = vec3(-0.572, -0.128, -0.160), rot = vec3(-2.2, -91.4, -110.8) },
        ['tworst_job7planka'] = { bone = 11816, off = vec3(-0.664, -0.140,  0.004), rot = vec3(-0.6,  -6.2, -113.4) },
        ['tworst_job7plankb'] = { bone = 11816, off = vec3(-0.586, -0.126,  0.082), rot = vec3(84.4,  -9.2, -107.4) },
    },

    placeAnimFlag    = 1,
    placeSettleMs        = 600,
    placeSettleFromHand  = true,
    placeSettleFrom      = 'front',
    placeSettleFrontDist = 0.55,
    placeSettleFrontUp   = 0.55,
    placeSettleBone      = 60309,
    placeSettleFactor    = 0.70,
    placeSettleMinPush   = 0.80,

    placeNailWallScenario = 'WORLD_HUMAN_HAMMERING',
    placeNailWallMs       = 2000,
    placeNailScenarioProps       = { 'prop_tool_hammer' },
    placeNailScenarioSweepRadius = 3.0,

    placeToolModel  = 'prop_tool_hammer',
    placeToolBone   = 57005,
    placeToolOffset = vec3(0.126, 0.054, 0.010),
    placeToolRot    = vec3(67.2, -77.8, -125.4),
    placeToolGroundDelayMs = 1500,
    placeToolOnGround = true,
    placeToolOnWall   = false,

    placeNailSoundKey        = 'nail_hammer',
    placeNailSoundCount      = 4,
    placeNailSoundIntervalMs = 420,
    placeNailSoundStartMs    = 1600,
    placeNailSoundVolume     = 0.45,
    placeNailSoundOnGround   = true,
    placeNailSoundOnWall     = false,
    placeCommitLeadMs    = 80,
    placeProgressBar     = true,
    placeProgressLabel   = TL('j7_placing', 'Placing'),
    placeAnimGroundDict = 'tworsthammer2@anim',
    placeAnimGroundClip = 'tworsthammer2_clip',
    placeAnimGroundMs   = 6000,
    placeAnimGroundFrac = 0.0,
    placeAnimWallDict = 'tworstcarry2@anim',
    placeAnimWallClip = 'tworstcarry2_clip',
    placeAnimWallMs   = 1300,
    placeAnimWallFrac = 0.0,

    placeGrips = {
        ['tworst_job7plank']  = { branch = 'ground', bone = 36029, off = vec3(0.248, 0.376, 0.268), rot = vec3(-23.4, 37.8, -94.4) },
        ['tworst_job7planka'] = { branch = 'wall',   bone = 36029, off = vec3(0.004, 0.248, 0.056), rot = vec3( 15.8, 87.4, 106.8) },
        ['tworst_job7plankb'] = { branch = 'wall',   bone = 36029, off = vec3(0.004, 0.248, 0.056), rot = vec3( 15.8, 87.4, 106.8) },
    },

    placeCarryAlignToSlot = true,

    pickupDistance    = 2.5,
    placeDistance     = 3.0,
    highlightDistance = 4.5,

    srvPickupDistance = 6.0,
    srvPlaceDistance  = 5.0,

    hologramMode   = 'radius',
    hologramRadius = 20.0,
    hologramAlpha  = 80,

    siteRadius = 120.0,

    pickupSoundKey = false,
    placeSoundKey  = false,

    placeLockMs = 5000,
}
