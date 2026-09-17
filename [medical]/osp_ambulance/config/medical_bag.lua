Config = Config or {}

Config.MedicalBag = {
    itemName = 'medical_bag',
    prop = 'xm_prop_x17_bag_med_01a',
    animDict = 'move_weapon@jerrycan@generic',
    animName = 'idle',
    attachBone = 57005,
    attachOffset = vector3(0.40, 0.0, -0.05),
    attachRotation = vector3(0.0, 280.0, 75.0),
    placeKey = 'E',
    openStashKey = 'G',
    deleteKey = 'Q',
    deleteTime = 4000,
    limitOneActive = true,
    stashPrefix = 'medbag_',
    stashLabel = 'Medical Bag',
    stashSlots = 15,
    stashWeight = 10000,
}
