-- Region 5 mechanics: panel carry and placement ranges.

Config.PanelWallSystem = {
    staticFurniture = {
        { model = 'tworst_buildzgrill',    coords = vec3(1025.730, 2441.323, 54.504), rot = vec3(0.0, 0.0, 0.0) },
        { model = 'tworst_buildzstairs2',  coords = vec3(1027.695, 2456.936, 52.654), rot = vec3(0.0,  0.0, 1.25) },
        { model = 'tworst_buildzrampplank', coords = vec3(1003.738, 2459.452, 47.566), rot = vec3(0.0, 0.0, 178.340) },
    },

    carryModel = 'tworst_buildzwall1',

    carryAttachBone   = 11816,
    carryAttachOffset = vec3(-0.622, -0.158, 0.052),
    carryAttachRot    = vec3(84.8, -5.6, -103.4),
    carryAnimDict     = 'tworsttrow@anim',
    carryAnimClip     = 'tworsttrow_clip',
    carryAnimFlag     = 49,

    placeAnimFlag    = 1,
    placeSettleMs      = 600,
    placeSettleFromHand= true,
    placeSettleFrom    = 'front',
    placeSettleFrontDist = 0.55,
    placeSettleFrontUp   = 0.55,
    placeSettleBone    = 60309,
    placeSettleFactor  = 0.70,
    placeSettleMinPush = 0.80,
    placeCommitLeadMs  = 80,
    placeAnimDict    = 'tworstcarry2@anim',
    placeAnimClip    = 'tworstcarry2_clip',
    placeAnimMs      = 1300,
    placeAnimFrac    = 0.0,
    placeCarryBone   = 28252,
    placeCarryOffset = vec3(0.476, 0.134, -0.076),
    placeCarryRot    = vec3(-34.8, 17.2, -14.4),
    placeHideCarried = true,
    placeCarryAlignToSlot = false,

    pickupDistance    = 2.5,
    placeDistance     = 3.0,
    placeReachUp      = 3.5,
    placeReachDown    = 1.2,
    highlightDistance = 4.5,

    hologramMode      = 'all',
    hologramRadius    = 8.0,
    hologramAlpha     = 80,

    pickupSoundKey = false,
    placeSoundKey  = 'tower_place',

    placeProgressBar   = true,
    placeProgressLabel = TL('pw_progress_placing', 'Placing panel'),

    placeLockMs = 5000,
}
