-- ====================================================================
-- VEHICLE CRANE (Crane V2)
-- ====================================================================
-- A 21-part chain plus 6 outriggers: joint limits, rope, cargo and camera.
-- Controlled with a handheld remote -- there is no driver seat.
-- ====================================================================

Config                      = Config or {}
Config.Crane                = {

    cranev2Vehicle   = "twhaulma",

    hookMarker       = true,
}

Config.Crane.legFootDrop    = 0.85

Config.Crane.legArmSpread   = 1.4

Config.Crane.legPadClearance = 0.35

Config.Crane.remote         = {
    proximity                = 4.0,
    actionCooldownMs         = 700,
    controlRange             = 50.0,
    propModel                = 'tworst_cranecontrolerp',
    handBone                 = 0,
    propOffset               = vector3(0.0, 0.0, 0.0),
    propRotation             = vector3(0.0, 0.0, 180.0),

    animDict                 = 'tworst_controleranim@anim',
    animClip                 = 'tworst_controleranim_clip',
    animFlag                 = 49,
    holdBlockActions         = true,
    holdForceThirdPerson     = true,
    showcaseOffset           = vector3(0.0, -25.0, 15.0),
    showcaseLookAt           = vector3(0.0, 0.0, 5.0),
    showcaseFov              = 45.0,
    showcaseMouseSensitivity = 8.0,
}

Config.Crane.cv2Deploy      = {
    anakolDelta  = -80.74,
    knuckleDelta = -154.10,
    teleDelta    = 0.0,
    ropeLength   = 1.74,
    timeoutMs    = 20000,
}

Config.Crane.camViews = {
    { key = 'camSmart',    labelKey = 'cam_smart_follow', label = TL('cam_smart_follow', 'Smart follow'),  kind = 'delegate' },
    { key = 'camWide',     labelKey = 'cam_wide', label = TL('cam_wide', 'Wide view'),   kind = 'orbit',
      dist = 25.0, distMin = 6.0, distMax = 60.0, zoomStep = 2.0,
      height = 8.0, lookZ = 5.0, fov = 45.0, sens = 30.0, lerp = 6.0 },
    { key = 'camFp',       labelKey = 'cam_first_person', label = TL('cam_first_person', 'First person'), kind = 'fp',
      fov = 55.0, fovMin = 20.0, fovMax = 70.0, zoomStep = 4.0, sens = 20.0 },
}
