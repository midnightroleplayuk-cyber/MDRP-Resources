Locale                          = Locale or {}

Locale['en'] = { -- 'en' is the reference that will be used for 'Config.Language'

    -- DEBUG SECTION

    --- Client-Side debugging
    DebugName                   = "[DEBUG]",
    ActualHatGlasses            = "Actual Hat ID: %s Actual Glasses ID: %s",
    PredictedHatGlasses         = "Predicted Hat ID: %s Predicted Glasses ID: %s",
    PlayerHasHatGlasses         = "Player has Hat? %s Player has Glasses? %s",
    HatFound                    = "Hat found!",
    GlassesFound                = "Glasses found!",
    ComeCloser                  = "Come closer to inspect",
    HatCoordsSet                = "Hat Coords Set: %s Hat Rotation Set: %s Entity: %s",
    GlassesCoordsSet            = "Glasses Coords Set: %s Glasses Rotation Set: %s Entity: %s",
    DroppedPropCoordsSet        = "Dropped Prop Coords Set: %s Dropped Prop Rotation Set: %s Entity: %s",
    NotPickableGender           = "%s\nIs Pickable: No\nWhy: Wrong gender\nGender: %s",
    NotPickableItem             = "%s\nIs Pickable: No\nWhy: Not a PickItBack Item",
    NotPickableAlredyEquipped   = "%s\nIs Pickable: No\nWhy: Already Equipped",
    PickableItem                = "%s\nIs Pickable: Yes\nDrawableID: %s\nTextureID: %s\nGender: %s",
    Hat                         = "Hat",
    Glasses                     = "Glasses",
    PlayerInterrupted           = "Player interrupted during pickup",
    StartPickup                 = "Starting to pick up prop: Type %s, Identifier %s",
    PickupCompleted             = "Successfully picked up prop: Type %s, Identifier %s",
    PickupFailed                = "Failed to pick up prop: Type %s, Identifier %s",
    SyncingBackProps            = "Syncing back props after failed pickup for Identifier %s",
    SyncingPropCoords           = "Syncing prop coordinates for Identifier %s",
    PlayerInterruptedDetails    = "Dead or dying: %s, Ragdoll: %s, Damaged: %s",

    --- Melee Debug
    MeleeDebugWeapon           = "Melee Debug - Attacker Weapon Hash: %s",
    MeleeDebugConditions       = "Melee Conditions - IsMeleeHit: %s, IsConfigEnabled: %s",
    MeleeDebugWeaponName       = "Melee Weapon Detected - Name: %s",
    MeleeDebugNotMelee         = "Not a melee weapon - Hash: %s",
    MeleeDebugConfigMissing    = "Warning: Melee config setting is missing or invalid",
    MeleeDebugDropSuccess      = "Melee drop conditions met",
    MeleeDebugDropFailed       = "Melee drop conditions not met",

    --- Vehicle Hit Debug
    VehicleDebugHit            = "Vehicle Hit Check - Hit by vehicle: %s",
    VehicleDebugSpeed          = "Vehicle Speed - Current: %.2f %s, Required: %.2f %s",
    VehicleDebugConfigMissing  = "Warning: Vehicle hit config setting is missing or invalid",
    VehicleDebugDropSuccess    = "Vehicle hit conditions met",
    VehicleDebugDropFailed     = "Vehicle hit conditions not met",

    --- Bone Shot Debug
    BoneDebugShot              = "Bone Shot Check - Hit bone ID: %s",
    BoneDebugList              = "Configured Bone IDs: %s",
    BoneDebugMatch             = "Bone Check - Hit bone %s matches configured bone %s",
    BoneDebugNoMatch           = "Bone Check - No matching bones found",
    BoneDebugConfigMissing     = "Warning: Bone shot config setting is missing or invalid",
    BoneDebugDropSuccess       = "Bone shot conditions met",
    BoneDebugDropFailed        = "Bone shot conditions not met",

    --- General Debug
    DebugVictimAttacker        = "Damage Event - Victim: %s, Attacker: %s",
    DebugConditionMet          = "Final condition check - Condition met: %s",
    DebugNoAccessories         = "No accessories to drop - Hat: %s, Glasses: %s",

    --- Server-Side debugging
    PlayerConnected             = "Player %d is connected",
    PlayerNotConnected          = "Player %d is not connected anymore",
    SyncingDroppedProps         = "Syncing dropped props: Hat %s, Glasses %s",
    DroppedEntitiesUpdated      = "Dropped entities updated: Hat %s, Glasses %s",
    PickingUpProp               = "Picking up prop: Type %s, Identifier %s",
    PropPickedUp                = "Prop with Identifier %s has been picked up and will be removed",
    PropAlreadyPickedUp         = "Prop with Identifier %s is already picked up",
    SyncingDroppedPropsCoords   = "Syncing dropped props coordinates for Hat %s and Glasses %s",
    SyncingDroppedPropCoords    = "Syncing dropped prop coordinates for Identifier %s",
    SyncingIKOnPickup           = "Syncing IK on pickup at coordinates %s",
    SyncingBackDroppedProps     = "Syncing back dropped props for Identifier %s",

    -- GENERAL SECTION

    DefaultInteractionText      = "Press  ~INPUT_DE2E528F~to pick up", -- Yes, the weird spacing of ~INPUT_DE2E528F~ is intentional so that the keybind gets displayed correctly

}