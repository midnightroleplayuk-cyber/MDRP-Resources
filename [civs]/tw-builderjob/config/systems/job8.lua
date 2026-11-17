-- ====================================================================
-- REGION 11 MECHANICS
-- ====================================================================
-- Carry attach/anim, placement ranges and crane pickup tuning. A slot whose support
-- is already filled gets extra reach tolerance (placeSupportedBonus*): hardest to reach.
-- ====================================================================

Config.Job8System = {
    placeLockMs = 5000,

    carryAttachBone   = 11816,
    carryAttachOffset = vec3(-0.672, -0.150, 0.096),
    carryAttachRot    = vec3(-90.8, 45.4, -54.6),
    carryAnimDict     = 'tworsttrow@anim',
    carryAnimClip     = 'tworsttrow_clip',
    carryAnimFlag     = 49,

    placeCarryWallBone   = 28252,
    placeCarryWallOffset = vec3(0.376, 0.194, -0.106),
    placeCarryWallRot    = vec3(-43.6, 2.8, -26.4),
    placeCarryGroundBone   = 28252,
    placeCarryGroundOffset = vec3(0.376, 0.194, -0.106),
    placeCarryGroundRot    = vec3(-43.6, 2.8, -26.4),

    placeAnimWallDict  = 'tworstcarry2@anim',
    placeAnimWallClip  = 'tworstcarry2_clip',
    placeAnimGroundDict = 'tworsthammer2@anim',
    placeAnimGroundClip = 'tworsthammer2_clip',
    placeAnimFlag      = 1,
    placeFacesSlot     = true,
    placeAnimWallMs     = 1300,
    placeAnimWallFrac   = 0.79,
    placeAnimGroundMs   = 6000,
    placeAnimGroundFrac = 0.35,
    placeAnimMs         = 1100,

    pickupDistance    = 2.5,
    placeDistance     = 3.0,
    placeReachUp      = 6.5,
    placeReachDown    = 2.5,
    highlightDistance = 4.5,
    placeMinPileDistance = 2.0,

    placeSupportedBonusHor = 1.5,
    placeSupportedBonusUp  = 2.0,

    cranePickupRange  = 4.0,
    cranePlaceRange   = 4.5,
    craneMachineReach = 30.0,
    craneCarryRot     = vec3(18.0, 0.0, 0.0),
    craneRaiseRange   = 2.0,
    craneHookRigPoint = vec3(0.0, 0.0, 0.25),
    craneRigMode      = nil,

    hologramAlpha     = 80,
}
