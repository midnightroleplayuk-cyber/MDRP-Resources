-- ====================================================================
-- REGION 8 MECHANICS (JCB / truck / stone)
-- ====================================================================
-- Bucket bone distances, dig/dump ranges and the stone placement animation.
-- The sand pile points live in config/jobs/excavator.lua.
-- ====================================================================

Config.ExcavatorSystem = {
    bucketBone       = 49,
    bucketBoneOffset = vec3(0.045, 0.390, -0.045),

    digRadius   = 2.0,
    digMaxAbove = 1.5,
    digMinAbove = -1.5,
    truckBedBone   = nil,
    truckBedOffset = vec3(0.301, -1.703, 2.202),
    loadRadius     = 1.0,
    loadMinAbove   = -0.4,
    scoopMs    = 1500,
    dumpToTruckMs = 1200,

    damperDoor          = 5,
    damperUpThreshold   = 0.5,
    tailgateDoor        = 2,
    tailgateOpenThreshold = 0.3,
    dumpRange           = 5.0,
    truckRearOffset     = -3.8,
    returnRange         = 12.0,

    fillRiseOffset = -1.2,
    fillRiseMs     = 550,
    fillLayerGapMs = 220,

    stoneCarryModel   = 'tworst_job10con5',
    stoneLevelRot     = vec3(-2.864, 1.490, -0.288),
    stoneStackStep    = vec3(0.002, 0.005, 0.092),
    stonePileGroundSnap = true,
    stonePileSink       = 0.02,

    sandPileGap = 7.0,
    carryAttachBone   = 11816,
    carryAttachOffset = vec3(-0.342, -0.174, 0.024),
    carryAttachRot    = vec3(94.8, -129.4, -74.6),
    carryAnimDict     = 'tworsttrow@anim',
    carryAnimClip     = 'tworsttrow_clip',
    carryAnimFlag     = 49,

    placeAnimDict     = 'anim@mp_fireworks',
    placeAnimClip     = 'place_firework_box2',
    placeAnimFlag     = 2,
    placeAnimMs       = 900,
    placeAnimFrac     = 0.5,

    pickupDistance    = 2.5,
    placeDistance     = 3.0,
    highlightDistance = 4.5,

    digParticle  = { asset = 'core', name = 'ent_dst_rocks', scale = 1.2 },
    dumpParticle = { asset = 'core', name = 'ent_dst_rocks', scale = 2.5 },

    pickupSoundKey = 'tower_pickup',
    placeSoundKey  = 'tower_place',
}
